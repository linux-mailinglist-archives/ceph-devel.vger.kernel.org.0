Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E94160247
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Feb 2020 07:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgBPGuI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Feb 2020 01:50:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57546 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725866AbgBPGuI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Feb 2020 01:50:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581835806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DFo7NVVT4dvhh1XQbdKoBfigj9U2B1Xib7IhMGbYRaI=;
        b=B42jWAevcUpH1bRGSORM+HcGGCG+kB918cOGKdbijkTVP2WJVChi7czm04dMg3j7fjhlxx
        ujHxDqm/kqwNG3ikUgjF7uYYSW8STl5+yNmgcWzfqs9Qfog3+e5f19sNevGVGiWFNWVcVs
        9ksMYWahVgrJ+cFMs1198TATaaCsHpA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-D11SvrqmNUeW1B0Z07Sk7w-1; Sun, 16 Feb 2020 01:50:00 -0500
X-MC-Unique: D11SvrqmNUeW1B0Z07Sk7w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D35C1005510;
        Sun, 16 Feb 2020 06:49:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DB5E5D9C9;
        Sun, 16 Feb 2020 06:49:52 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add halt mount option support
Date:   Sun, 16 Feb 2020 01:49:45 -0500
Message-Id: <20200216064945.61726-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will simulate pulling the power cable situation, which will
do:

- abort all the inflight osd/mds requests and fail them with -EIO.
- reject any new coming osd/mds requests with -EIO.
- close all the mds connections directly without doing any clean up
  and disable mds sessions recovery routine.
- close all the osd connections directly without doing any clean up.
- set the msgr as stopped.

URL: https://tracker.ceph.com/issues/44044
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c            | 12 ++++++++++--
 fs/ceph/mds_client.h            |  3 ++-
 fs/ceph/super.c                 | 33 ++++++++++++++++++++++++++++-----
 fs/ceph/super.h                 |  1 +
 include/linux/ceph/libceph.h    |  1 +
 include/linux/ceph/mon_client.h |  2 ++
 include/linux/ceph/osd_client.h |  1 +
 net/ceph/ceph_common.c          | 14 ++++++++++++++
 net/ceph/mon_client.c           | 16 ++++++++++++++--
 net/ceph/osd_client.c           | 11 +++++++++++
 10 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b0f34251ad28..b6aa357f7c61 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4110,6 +4110,9 @@ static void maybe_recover_session(struct ceph_mds_c=
lient *mdsc)
 {
 	struct ceph_fs_client *fsc =3D mdsc->fsc;
=20
+	if (ceph_test_mount_opt(fsc, HALT))
+		return;
+
 	if (!ceph_test_mount_opt(fsc, CLEANRECOVER))
 		return;
=20
@@ -4735,7 +4738,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_clien=
t *mdsc)
 	dout("stopped\n");
 }
=20
-void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
+void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc, bool halt)
 {
 	struct ceph_mds_session *session;
 	int mds;
@@ -4748,7 +4751,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client=
 *mdsc)
 		if (!session)
 			continue;
=20
-		if (session->s_state =3D=3D CEPH_MDS_SESSION_REJECTED)
+		/*
+		 * when halting the superblock, it will simulate pulling
+		 * the power cable, so here close the connection before
+		 * doing any cleanup.
+		 */
+		if (halt || (session->s_state =3D=3D CEPH_MDS_SESSION_REJECTED))
 			__unregister_session(mdsc, session);
 		__wake_requests(mdsc, &session->s_waiting);
 		mutex_unlock(&mdsc->mutex);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index c13910da07c4..b66eea830ae1 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -478,7 +478,8 @@ extern int ceph_send_msg_mds(struct ceph_mds_client *=
mdsc,
=20
 extern int ceph_mdsc_init(struct ceph_fs_client *fsc);
 extern void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc);
-extern void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc);
+extern void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc,
+				   bool halt);
 extern void ceph_mdsc_destroy(struct ceph_fs_client *fsc);
=20
 extern void ceph_mdsc_sync(struct ceph_mds_client *mdsc);
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 8b52bea13273..2a6fd5d2fffa 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -155,6 +155,7 @@ enum {
 	Opt_acl,
 	Opt_quotadf,
 	Opt_copyfrom,
+	Opt_halt,
 };
=20
 enum ceph_recover_session_mode {
@@ -194,6 +195,7 @@ static const struct fs_parameter_spec ceph_mount_para=
m_specs[] =3D {
 	fsparam_string	("snapdirname",			Opt_snapdirname),
 	fsparam_string	("source",			Opt_source),
 	fsparam_u32	("wsize",			Opt_wsize),
+	fsparam_flag	("halt",			Opt_halt),
 	{}
 };
=20
@@ -435,6 +437,9 @@ static int ceph_parse_mount_param(struct fs_context *=
fc,
 			fc->sb_flags &=3D ~SB_POSIXACL;
 		}
 		break;
+	case Opt_halt:
+		fsopt->flags |=3D CEPH_MOUNT_OPT_HALT;
+		break;
 	default:
 		BUG();
 	}
@@ -601,6 +606,8 @@ static int ceph_show_options(struct seq_file *m, stru=
ct dentry *root)
 	if (m->count =3D=3D pos)
 		m->count--;
=20
+	if (fsopt->flags & CEPH_MOUNT_OPT_HALT)
+		seq_puts(m, ",halt");
 	if (fsopt->flags & CEPH_MOUNT_OPT_DIRSTAT)
 		seq_puts(m, ",dirstat");
 	if ((fsopt->flags & CEPH_MOUNT_OPT_RBYTES))
@@ -877,22 +884,28 @@ static void destroy_caches(void)
 }
=20
 /*
- * ceph_umount_begin - initiate forced umount.  Tear down down the
- * mount, skipping steps that may hang while waiting for server(s).
+ * ceph_umount_begin - initiate forced umount.  Tear down the mount,
+ * skipping steps that may hang while waiting for server(s).
  */
-static void ceph_umount_begin(struct super_block *sb)
+static void __ceph_umount_begin(struct super_block *sb, bool halt)
 {
 	struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
=20
-	dout("ceph_umount_begin - starting forced umount\n");
 	if (!fsc)
 		return;
 	fsc->mount_state =3D CEPH_MOUNT_SHUTDOWN;
 	ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
-	ceph_mdsc_force_umount(fsc->mdsc);
+	ceph_mdsc_force_umount(fsc->mdsc, halt);
 	fsc->filp_gen++; // invalidate open files
 }
=20
+static void ceph_umount_begin(struct super_block *sb)
+{
+	dout("%s - starting forced umount\n", __func__);
+
+	__ceph_umount_begin(sb, false);
+}
+
 static const struct super_operations ceph_super_ops =3D {
 	.alloc_inode	=3D ceph_alloc_inode,
 	.free_inode	=3D ceph_free_inode,
@@ -1193,6 +1206,16 @@ static int ceph_reconfigure_fc(struct fs_context *=
fc)
 	struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
 	struct ceph_mount_options *new_fsopt =3D pctx->opts;
=20
+	/* halt the mount point, will ignore other options */
+	if (new_fsopt->flags & CEPH_MOUNT_OPT_HALT) {
+		dout("halt the mount point\n");
+		fsopt->flags |=3D CEPH_MOUNT_OPT_HALT;
+		__ceph_umount_begin(sb, true);
+		ceph_halt_client(fsc->client);
+
+		return 0;
+	}
+
 	sync_filesystem(sb);
=20
 	if (strcmp_null(new_fsopt->snapdir_name, fsopt->snapdir_name))
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4c40e86ad016..64f16083b216 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -43,6 +43,7 @@
 #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds =
is up */
 #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in s=
tatfs */
 #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-=
from' op */
+#define CEPH_MOUNT_OPT_HALT            (1<<15) /* halt the mount point *=
/
=20
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 8fe9b80e80a5..12e9f0cc8501 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -295,6 +295,7 @@ struct ceph_client *ceph_create_client(struct ceph_op=
tions *opt, void *private);
 struct ceph_entity_addr *ceph_client_addr(struct ceph_client *client);
 u64 ceph_client_gid(struct ceph_client *client);
 extern void ceph_destroy_client(struct ceph_client *client);
+void ceph_halt_client(struct ceph_client *client);
 extern void ceph_reset_client_addr(struct ceph_client *client);
 extern int __ceph_open_session(struct ceph_client *client,
 			       unsigned long started);
diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_cli=
ent.h
index dbb8a6959a73..7718a2e65d07 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -78,6 +78,7 @@ struct ceph_mon_client {
 	struct ceph_msg *m_auth, *m_auth_reply, *m_subscribe, *m_subscribe_ack;
 	int pending_auth;
=20
+	bool halt;
 	bool hunting;
 	int cur_mon;                       /* last monitor i contacted */
 	unsigned long sub_renew_after;
@@ -109,6 +110,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m=
,
=20
 extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_clie=
nt *cl);
 extern void ceph_monc_stop(struct ceph_mon_client *monc);
+void ceph_monc_halt(struct ceph_mon_client *monc);
 extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
=20
 enum {
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
index 02ff3a302d26..4b9143f7d989 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -382,6 +382,7 @@ extern void ceph_osdc_cleanup(void);
 extern int ceph_osdc_init(struct ceph_osd_client *osdc,
 			  struct ceph_client *client);
 extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
+extern void ceph_osdc_halt(struct ceph_osd_client *osdc);
 extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
=20
 extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index a9d6c97b5b0d..c47578ed0546 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -652,6 +652,20 @@ struct ceph_client *ceph_create_client(struct ceph_o=
ptions *opt, void *private)
 }
 EXPORT_SYMBOL(ceph_create_client);
=20
+void ceph_halt_client(struct ceph_client *client)
+{
+	dout("halt_client %p\n", client);
+
+	atomic_set(&client->msgr.stopping, 1);
+
+	/* unmount */
+	ceph_osdc_halt(&client->osdc);
+	ceph_monc_halt(&client->monc);
+
+	dout("halt_client %p done\n", client);
+}
+EXPORT_SYMBOL(ceph_halt_client);
+
 void ceph_destroy_client(struct ceph_client *client)
 {
 	dout("destroy_client %p\n", client);
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 9d9e4e4ea600..5819a02af7fe 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -979,14 +979,16 @@ static void delayed_work(struct work_struct *work)
 	mutex_lock(&monc->mutex);
 	if (monc->hunting) {
 		dout("%s continuing hunt\n", __func__);
-		reopen_session(monc);
+		if (!monc->halt)
+			reopen_session(monc);
 	} else {
 		int is_auth =3D ceph_auth_is_authenticated(monc->auth);
 		if (ceph_con_keepalive_expired(&monc->con,
 					       CEPH_MONC_PING_TIMEOUT)) {
 			dout("monc keepalive timeout\n");
 			is_auth =3D 0;
-			reopen_session(monc);
+			if (!monc->halt)
+				reopen_session(monc);
 		}
=20
 		if (!monc->hunting) {
@@ -1115,6 +1117,16 @@ int ceph_monc_init(struct ceph_mon_client *monc, s=
truct ceph_client *cl)
 }
 EXPORT_SYMBOL(ceph_monc_init);
=20
+void ceph_monc_halt(struct ceph_mon_client *monc)
+{
+	dout("monc halt\n");
+
+	mutex_lock(&monc->mutex);
+	monc->halt =3D true;
+	ceph_con_close(&monc->con);
+	mutex_unlock(&monc->mutex);
+}
+
 void ceph_monc_stop(struct ceph_mon_client *monc)
 {
 	dout("stop\n");
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 108c9457d629..161daf35d7f1 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5202,6 +5202,17 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, s=
truct ceph_client *client)
 	return err;
 }
=20
+void ceph_osdc_halt(struct ceph_osd_client *osdc)
+{
+	down_write(&osdc->lock);
+	while (!RB_EMPTY_ROOT(&osdc->osds)) {
+		struct ceph_osd *osd =3D rb_entry(rb_first(&osdc->osds),
+						struct ceph_osd, o_node);
+		close_osd(osd);
+	}
+	up_write(&osdc->lock);
+}
+
 void ceph_osdc_stop(struct ceph_osd_client *osdc)
 {
 	destroy_workqueue(osdc->completion_wq);
--=20
2.21.0

