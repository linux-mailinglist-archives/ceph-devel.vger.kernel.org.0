Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D402472EBB
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 14:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfGXMVp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 08:21:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbfGXMVo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 08:21:44 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23EB83082B5A
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 12:21:44 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-93.pek2.redhat.com [10.72.12.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCD0360BEC;
        Wed, 24 Jul 2019 12:21:41 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v2 6/9] ceph: add helper function that forcibly reconnects to ceph cluster.
Date:   Wed, 24 Jul 2019 20:21:17 +0800
Message-Id: <20190724122120.17438-7-zyan@redhat.com>
In-Reply-To: <20190724122120.17438-1-zyan@redhat.com>
References: <20190724122120.17438-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 24 Jul 2019 12:21:44 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It closes mds sessions, drop all caps and invalidates page caches,
then use new entity address to reconnect to the cluster.

After reconnect, all dirty data/metadata are dropped, file locks
get lost sliently. Open files continue to work because client will
try renewing caps on later read/write.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/mds_client.c | 15 ++++++++++++---
 fs/ceph/super.c      | 26 +++++++++++++++++++++++++-
 fs/ceph/super.h      |  3 ++-
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d4f07d3120cb..c49009965369 100644
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
@@ -4378,6 +4386,7 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 		}
 		mutex_unlock(&session->s_mutex);
 		ceph_put_mds_session(session);
+
 		mutex_lock(&mdsc->mutex);
 		kick_requests(mdsc, mds);
 	}
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 84d23c896daa..310a4c05961c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -829,7 +829,6 @@ static void ceph_umount_begin(struct super_block *sb)
 	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
 	ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
 	ceph_mdsc_force_umount(fsc->mdsc);
-	return;
 }
 
 static int ceph_remount(struct super_block *sb, int *flags, char *data)
@@ -1154,6 +1153,31 @@ static struct file_system_type ceph_fs_type = {
 };
 MODULE_ALIAS_FS("ceph");
 
+int ceph_force_reconnect(struct super_block *sb)
+{
+	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
+	int err = 0;
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
+	fsc->mount_state = CEPH_MOUNT_MOUNTED;
+
+	if (sb->s_root) {
+		err = __ceph_do_getattr(d_inode(sb->s_root), NULL,
+					CEPH_STAT_CAP_INODE, true);
+	}
+	return err;
+}
+
 static int __init init_ceph(void)
 {
 	int ret = init_caches();
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 2950061846da..8a59b7a81c5a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -846,7 +846,8 @@ static inline int default_congestion_kb(void)
 }
 
 
-
+/* super.c */
+extern int ceph_force_reconnect(struct super_block *sb);
 /* snap.c */
 struct ceph_snap_realm *ceph_lookup_snap_realm(struct ceph_mds_client *mdsc,
 					       u64 ino);
-- 
2.20.1

