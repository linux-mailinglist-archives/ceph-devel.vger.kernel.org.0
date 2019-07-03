Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C155E430
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 14:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGCMpR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 08:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMpR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:45:17 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 274C588306
        for <ceph-devel@vger.kernel.org>; Wed,  3 Jul 2019 12:45:17 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4C3017B40;
        Wed,  3 Jul 2019 12:45:14 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 7/9] ceph: add 'force_reconnect' option for remount
Date:   Wed,  3 Jul 2019 20:44:40 +0800
Message-Id: <20190703124442.6614-8-zyan@redhat.com>
In-Reply-To: <20190703124442.6614-1-zyan@redhat.com>
References: <20190703124442.6614-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 03 Jul 2019 12:45:17 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The option make client reconnect to cluster, using new entity addr.
It can be used for recovering from blacklistd.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/mds_client.c   | 16 ++++++++---
 fs/ceph/super.c        | 60 +++++++++++++++++++++++++++++++++++++++---
 fs/ceph/super.h        |  1 +
 net/ceph/ceph_common.c | 30 ++++++++++++---------
 4 files changed, 88 insertions(+), 19 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d4f07d3120cb..59172e63a61f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1394,9 +1394,12 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		struct ceph_cap_flush *cf;
 		struct ceph_mds_client *mdsc = fsc->mdsc;
 
-		if (ci->i_wrbuffer_ref > 0 &&
-		    READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
-			invalidate = true;
+		if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
+			if (inode->i_data.nrpages > 0)
+				invalidate = true;
+			if (ci->i_wrbuffer_ref > 0)
+				mapping_set_error(&inode->i_data, -EIO);
+		}
 
 		while (!list_empty(&ci->i_cap_flush_list)) {
 			cf = list_first_entry(&ci->i_cap_flush_list,
@@ -4369,7 +4372,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 		session = __ceph_lookup_mds_session(mdsc, mds);
 		if (!session)
 			continue;
+
+		if (session->s_state == CEPH_MDS_SESSION_REJECTED)
+			__unregister_session(mdsc, session);
+		__wake_requests(mdsc, &session->s_waiting);
 		mutex_unlock(&mdsc->mutex);
+
 		mutex_lock(&session->s_mutex);
 		__close_session(mdsc, session);
 		if (session->s_state == CEPH_MDS_SESSION_CLOSING) {
@@ -4378,9 +4386,11 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 		}
 		mutex_unlock(&session->s_mutex);
 		ceph_put_mds_session(session);
+
 		mutex_lock(&mdsc->mutex);
 		kick_requests(mdsc, mds);
 	}
+
 	__wake_requests(mdsc, &mdsc->waiting_for_map);
 	mutex_unlock(&mdsc->mutex);
 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 5f0c950ca966..04a9af66419d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -169,6 +169,7 @@ enum {
 	Opt_noquotadf,
 	Opt_copyfrom,
 	Opt_nocopyfrom,
+	Opt_force_reconnect,
 };
 
 static match_table_t fsopt_tokens = {
@@ -210,6 +211,7 @@ static match_table_t fsopt_tokens = {
 	{Opt_noquotadf, "noquotadf"},
 	{Opt_copyfrom, "copyfrom"},
 	{Opt_nocopyfrom, "nocopyfrom"},
+	{Opt_force_reconnect, "force_reconnect"},
 	{-1, NULL}
 };
 
@@ -373,6 +375,9 @@ static int parse_fsopt_token(char *c, void *private)
 	case Opt_nocopyfrom:
 		fsopt->flags |= CEPH_MOUNT_OPT_NOCOPYFROM;
 		break;
+	case Opt_force_reconnect:
+		fsopt->flags |= CEPH_MOUNT_OPT_FORCERECONNCT;
+		break;
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 	case Opt_acl:
 		fsopt->sb_flags |= SB_POSIXACL;
@@ -832,10 +837,53 @@ static void ceph_umount_begin(struct super_block *sb)
 	return;
 }
 
-static int ceph_remount(struct super_block *sb, int *flags, char *data)
+static int ceph_remount(struct super_block *sb, int *flags, char *options)
 {
-	sync_filesystem(sb);
-	return 0;
+	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
+	struct ceph_options *opt;
+	struct ceph_mount_options *fsopt;
+	int err = 0;
+
+	fsopt = kzalloc(sizeof(*fsopt), GFP_KERNEL);
+	if (!fsopt)
+		return -ENOMEM;
+
+	opt = ceph_parse_options(options, NULL, NULL,
+				 parse_fsopt_token, (void *)fsopt);
+	if (IS_ERR(opt)) {
+		err = PTR_ERR(opt);
+		goto out;
+	}
+
+	if (!(fsopt->flags & CEPH_MOUNT_OPT_FORCERECONNCT)) {
+		sync_filesystem(sb);
+		goto out;
+	}
+
+	ceph_umount_begin(sb);
+
+	/* Make sure all page caches get invalidated.
+	 * see remove_session_caps_cb() */
+	flush_workqueue(fsc->inode_wq);
+
+	/* In case that we were blacklisted. This also reset
+	 * all mon/osd connections */
+	ceph_reset_client_addr(fsc->client);
+
+	ceph_osdc_clear_abort_err(&fsc->client->osdc);
+	fsc->mount_state = 0;
+
+	if (sb->s_root) {
+		err = __ceph_do_getattr(d_inode(sb->s_root), NULL,
+					CEPH_STAT_CAP_INODE, true);
+	} else {
+		err = 0;
+	}
+out:
+	if (!IS_ERR_OR_NULL(opt))
+		ceph_destroy_options(opt);
+	destroy_mount_options(fsopt);
+	return err;
 }
 
 static const struct super_operations ceph_super_ops = {
@@ -1067,6 +1115,12 @@ static struct dentry *ceph_mount(struct file_system_type *fs_type,
 		goto out_final;
 	}
 
+	if (fsopt->flags & CEPH_MOUNT_OPT_FORCERECONNCT) {
+		pr_err("ceph: force_reconnect option is only for remount\n");
+		res = ERR_PTR(-EINVAL);
+		goto out_final;
+	}
+
 	/* create client (which we may/may not use) */
 	fsc = create_fs_client(fsopt, opt);
 	if (IS_ERR(fsc)) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index da33847bdc9a..71ac136b8758 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -31,6 +31,7 @@
 #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
 #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
 
+#define CEPH_MOUNT_OPT_FORCERECONNCT   (1<<0) /* force reconnect, remount only */
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
 #define CEPH_MOUNT_OPT_RBYTES          (1<<5) /* dir st_bytes = rbytes */
 #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 6676f48d615c..3511782a5b0a 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -358,13 +358,6 @@ ceph_parse_options(char *options, const char *dev_name,
 	opt = kzalloc(sizeof(*opt), GFP_KERNEL);
 	if (!opt)
 		return ERR_PTR(-ENOMEM);
-	opt->mon_addr = kcalloc(CEPH_MAX_MON, sizeof(*opt->mon_addr),
-				GFP_KERNEL);
-	if (!opt->mon_addr)
-		goto out;
-
-	dout("parse_options %p options '%s' dev_name '%s'\n", opt, options,
-	     dev_name);
 
 	/* start with defaults */
 	opt->flags = CEPH_OPT_DEFAULT;
@@ -373,12 +366,23 @@ ceph_parse_options(char *options, const char *dev_name,
 	opt->osd_idle_ttl = CEPH_OSD_IDLE_TTL_DEFAULT;
 	opt->osd_request_timeout = CEPH_OSD_REQUEST_TIMEOUT_DEFAULT;
 
-	/* get mon ip(s) */
-	/* ip1[:port1][,ip2[:port2]...] */
-	err = ceph_parse_ips(dev_name, dev_name_end, opt->mon_addr,
-			     CEPH_MAX_MON, &opt->num_mon);
-	if (err < 0)
-		goto out;
+	dout("parse_options %p options '%s' dev_name '%s'\n", opt, options,
+	     (dev_name ? : "null"));
+
+	if (dev_name) {
+		opt->mon_addr = kcalloc(CEPH_MAX_MON, sizeof(*opt->mon_addr),
+					GFP_KERNEL);
+		if (!opt->mon_addr)
+			goto out;
+
+
+		/* get mon ip(s) */
+		/* ip1[:port1][,ip2[:port2]...] */
+		err = ceph_parse_ips(dev_name, dev_name_end, opt->mon_addr,
+				     CEPH_MAX_MON, &opt->num_mon);
+		if (err < 0)
+			goto out;
+	}
 
 	/* parse mount options */
 	while ((c = strsep(&options, ",")) != NULL) {
-- 
2.20.1

