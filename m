Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772DD169312
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Feb 2020 03:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgBWCPF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 22 Feb 2020 21:15:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60787 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726884AbgBWCPF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 22 Feb 2020 21:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582424102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Cf6M7RTMd4mg9bf4aZVr+tKfjem3IA0aVWIcs96R25c=;
        b=QLUg50IT9n6mQ8UvKUQyp6QVPXc1LQFcn+y/GFHuD0L+wHH4Em7eo4wT8pll5Hdi/XiX6G
        KxV8+N/TQ+NnAYHKqIse9Tdxe8+riT4ELGrU0KrVdvHkZrO9Se78QOC6v7+9CgYnH16kO+
        erdUnwHnVclBVh0IT/HsBpR35Q7XnSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-f3FagKxFOV6tl3pHNBxhow-1; Sat, 22 Feb 2020 21:14:56 -0500
X-MC-Unique: f3FagKxFOV6tl3pHNBxhow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FDE9100550E;
        Sun, 23 Feb 2020 02:14:55 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39DFB5C114;
        Sun, 23 Feb 2020 02:14:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add 'fs' mount option support
Date:   Sat, 22 Feb 2020 21:14:40 -0500
Message-Id: <20200223021440.40257-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The 'fs' here will be cleaner when specifying the ceph fs name,
and we can easily get the corresponding name from the `ceph fs
dump`:

[...]
Filesystem 'a' (1)
fs_name	a
epoch	12
flags	12
[...]

The 'fs' here just an alias name for 'mds_namespace' mount options,
and we will keep 'mds_namespace' for backwards compatibility.

URL: https://tracker.ceph.com/issues/44214
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c |  8 ++++----
 fs/ceph/super.c      | 21 +++++++++++----------
 fs/ceph/super.h      |  2 +-
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3e792eca6af7..82f63ef2694c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4590,7 +4590,7 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_ms=
g *msg)
 {
 	struct ceph_fs_client *fsc =3D mdsc->fsc;
-	const char *mds_namespace =3D fsc->mount_options->mds_namespace;
+	const char *fs_name =3D fsc->mount_options->fs_name;
 	void *p =3D msg->front.iov_base;
 	void *end =3D p + msg->front.iov_len;
 	u32 epoch;
@@ -4634,9 +4634,9 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client =
*mdsc, struct ceph_msg *msg)
 		namelen =3D ceph_decode_32(&info_p);
 		ceph_decode_need(&info_p, info_end, namelen, bad);
=20
-		if (mds_namespace &&
-		    strlen(mds_namespace) =3D=3D namelen &&
-		    !strncmp(mds_namespace, (char *)info_p, namelen)) {
+		if (fs_name &&
+		    strlen(fs_name) =3D=3D namelen &&
+		    !strncmp(fs_name, (char *)info_p, namelen)) {
 			mount_fscid =3D fscid;
 			break;
 		}
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c7f150686a53..31acb4fe1f2c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -140,7 +140,7 @@ enum {
 	Opt_congestion_kb,
 	/* int args above */
 	Opt_snapdirname,
-	Opt_mds_namespace,
+	Opt_fs,
 	Opt_recover_session,
 	Opt_source,
 	/* string args above */
@@ -181,7 +181,8 @@ static const struct fs_parameter_spec ceph_mount_para=
meters[] =3D {
 	fsparam_flag_no	("fsc",				Opt_fscache), // fsc|nofsc
 	fsparam_string	("fsc",				Opt_fscache), // fsc=3D...
 	fsparam_flag_no ("ino32",			Opt_ino32),
-	fsparam_string	("mds_namespace",		Opt_mds_namespace),
+	fsparam_string	("mds_namespace",		Opt_fs), // backwards compatibility
+	fsparam_string	("fs",				Opt_fs), // new alias for mds_namespace
 	fsparam_flag_no ("poolperm",			Opt_poolperm),
 	fsparam_flag_no ("quotadf",			Opt_quotadf),
 	fsparam_u32	("rasize",			Opt_rasize),
@@ -300,9 +301,9 @@ static int ceph_parse_mount_param(struct fs_context *=
fc,
 		fsopt->snapdir_name =3D param->string;
 		param->string =3D NULL;
 		break;
-	case Opt_mds_namespace:
-		kfree(fsopt->mds_namespace);
-		fsopt->mds_namespace =3D param->string;
+	case Opt_fs:
+		kfree(fsopt->fs_name);
+		fsopt->fs_name =3D param->string;
 		param->string =3D NULL;
 		break;
 	case Opt_recover_session:
@@ -460,7 +461,7 @@ static void destroy_mount_options(struct ceph_mount_o=
ptions *args)
 		return;
=20
 	kfree(args->snapdir_name);
-	kfree(args->mds_namespace);
+	kfree(args->fs_name);
 	kfree(args->server_path);
 	kfree(args->fscache_uniq);
 	kfree(args);
@@ -494,7 +495,7 @@ static int compare_mount_options(struct ceph_mount_op=
tions *new_fsopt,
 	if (ret)
 		return ret;
=20
-	ret =3D strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
+	ret =3D strcmp_null(fsopt1->fs_name, fsopt2->fs_name);
 	if (ret)
 		return ret;
=20
@@ -561,8 +562,8 @@ static int ceph_show_options(struct seq_file *m, stru=
ct dentry *root)
 	if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) =3D=3D 0)
 		seq_puts(m, ",copyfrom");
=20
-	if (fsopt->mds_namespace)
-		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
+	if (fsopt->fs_name)
+		seq_show_option(m, "fs", fsopt->fs_name);
=20
 	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
 		seq_show_option(m, "recover_session", "clean");
@@ -643,7 +644,7 @@ static struct ceph_fs_client *create_fs_client(struct=
 ceph_mount_options *fsopt,
 	fsc->client->extra_mon_dispatch =3D extra_mon_dispatch;
 	ceph_set_opt(fsc->client, ABORT_ON_FULL);
=20
-	if (!fsopt->mds_namespace) {
+	if (!fsopt->fs_name) {
 		ceph_monc_want_map(&fsc->client->monc, CEPH_SUB_MDSMAP,
 				   0, true);
 	} else {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4b269dc845bb..fc4c125b42fb 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -90,7 +90,7 @@ struct ceph_mount_options {
 	 */
=20
 	char *snapdir_name;   /* default ".snap" */
-	char *mds_namespace;  /* default NULL */
+	char *fs_name;        /* default NULL */
 	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
 };
--=20
2.21.0

