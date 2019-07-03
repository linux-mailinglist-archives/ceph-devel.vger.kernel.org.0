Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A967F5E42D
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 14:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfGCMpB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 08:45:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMpB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:45:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC6AC3086262
        for <ceph-devel@vger.kernel.org>; Wed,  3 Jul 2019 12:45:00 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA359834EB;
        Wed,  3 Jul 2019 12:44:58 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 4/9] ceph: track and report error of async metadata operation
Date:   Wed,  3 Jul 2019 20:44:37 +0800
Message-Id: <20190703124442.6614-5-zyan@redhat.com>
In-Reply-To: <20190703124442.6614-1-zyan@redhat.com>
References: <20190703124442.6614-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 03 Jul 2019 12:45:00 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Use errseq_t to track and report errors of async metadata operations,
similar to how kernel handles errors during writeback.

If any dirty caps or any unsafe request gets dropped during session
eviction, record -EIO in corresponding inode's i_meta_err. The error
will be reported by subsequent fsync,

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c       | 24 +++++++++++++++++-------
 fs/ceph/file.c       |  6 ++++--
 fs/ceph/inode.c      |  2 ++
 fs/ceph/mds_client.c | 40 +++++++++++++++++++++++++++-------------
 fs/ceph/super.h      |  4 ++++
 5 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d98dcd976c80..345d73f57b80 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2258,35 +2258,45 @@ static int unsafe_request_wait(struct inode *inode)
 
 int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
+	struct ceph_file_info *fi = file->private_data;
 	struct inode *inode = file->f_mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 flush_tid;
-	int ret;
+	int ret, err;
 	int dirty;
 
 	dout("fsync %p%s\n", inode, datasync ? " datasync" : "");
 
 	ret = file_write_and_wait_range(file, start, end);
-	if (ret < 0)
-		goto out;
-
 	if (datasync)
 		goto out;
 
 	dirty = try_flush_caps(inode, &flush_tid);
 	dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
 
-	ret = unsafe_request_wait(inode);
+	err = unsafe_request_wait(inode);
 
 	/*
 	 * only wait on non-file metadata writeback (the mds
 	 * can recover size and mtime, so we don't need to
 	 * wait for that)
 	 */
-	if (!ret && (dirty & ~CEPH_CAP_ANY_FILE_WR)) {
-		ret = wait_event_interruptible(ci->i_cap_wq,
+	if (!err && (dirty & ~CEPH_CAP_ANY_FILE_WR)) {
+		err = wait_event_interruptible(ci->i_cap_wq,
 					caps_are_flushed(inode, flush_tid));
 	}
+
+	if (err < 0)
+		ret = err;
+
+	if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
+		spin_lock(&file->f_lock);
+		err = errseq_check_and_advance(&ci->i_meta_err,
+					       &fi->meta_err);
+		spin_unlock(&file->f_lock);
+		if (err < 0)
+			ret = err;
+	}
 out:
 	dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
 	return ret;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index aa20a554142b..deffb3010e6a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -201,6 +201,7 @@ prepare_open_request(struct super_block *sb, int flags, int create_mode)
 static int ceph_init_file_info(struct inode *inode, struct file *file,
 					int fmode, bool isdir)
 {
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_info *fi;
 
 	dout("%s %p %p 0%o (%s)\n", __func__, inode, file,
@@ -211,7 +212,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 		struct ceph_dir_file_info *dfi =
 			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
 		if (!dfi) {
-			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
+			ceph_put_fmode(ci, fmode); /* clean up */
 			return -ENOMEM;
 		}
 
@@ -222,7 +223,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	} else {
 		fi = kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
 		if (!fi) {
-			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
+			ceph_put_fmode(ci, fmode); /* clean up */
 			return -ENOMEM;
 		}
 
@@ -232,6 +233,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	fi->fmode = fmode;
 	spin_lock_init(&fi->rw_contexts_lock);
 	INIT_LIST_HEAD(&fi->rw_contexts);
+	fi->meta_err = errseq_sample(&ci->i_meta_err);
 
 	return 0;
 }
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index a565ab124282..fcaa054a9e37 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -515,6 +515,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	ceph_fscache_inode_init(ci);
 
+	ci->i_meta_err = 0;
+
 	return &ci->vfs_inode;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f51a7957b3e0..d4f07d3120cb 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1270,6 +1270,7 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 {
 	struct ceph_mds_request *req;
 	struct rb_node *p;
+	struct ceph_inode_info *ci;
 
 	dout("cleanup_session_requests mds%d\n", session->s_mds);
 	mutex_lock(&mdsc->mutex);
@@ -1278,6 +1279,16 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 				       struct ceph_mds_request, r_unsafe_item);
 		pr_warn_ratelimited(" dropping unsafe request %llu\n",
 				    req->r_tid);
+		if (req->r_target_inode) {
+			/* dropping unsafe change of inode's attributes */
+			ci = ceph_inode(req->r_target_inode);
+			errseq_set(&ci->i_meta_err, -EIO);
+		}
+		if (req->r_unsafe_dir) {
+			/* dropping unsafe directory operation */
+			ci = ceph_inode(req->r_unsafe_dir);
+			errseq_set(&ci->i_meta_err, -EIO);
+		}
 		__unregister_request(mdsc, req);
 	}
 	/* zero r_attempts, so kick_requests() will re-send requests */
@@ -1370,7 +1381,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	LIST_HEAD(to_remove);
-	bool drop = false;
+	bool dirty_dropped = false;
 	bool invalidate = false;
 
 	dout("removing cap %p, ci is %p, inode is %p\n",
@@ -1405,7 +1416,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 				inode, ceph_ino(inode));
 			ci->i_dirty_caps = 0;
 			list_del_init(&ci->i_dirty_item);
-			drop = true;
+			dirty_dropped = true;
 		}
 		if (!list_empty(&ci->i_flushing_item)) {
 			pr_warn_ratelimited(
@@ -1415,10 +1426,22 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			ci->i_flushing_caps = 0;
 			list_del_init(&ci->i_flushing_item);
 			mdsc->num_cap_flushing--;
-			drop = true;
+			dirty_dropped = true;
 		}
 		spin_unlock(&mdsc->cap_dirty_lock);
 
+		if (dirty_dropped) {
+			errseq_set(&ci->i_meta_err, -EIO);
+
+			if (ci->i_wrbuffer_ref_head == 0 &&
+			    ci->i_wr_ref == 0 &&
+			    ci->i_dirty_caps == 0 &&
+			    ci->i_flushing_caps == 0) {
+				ceph_put_snap_context(ci->i_head_snapc);
+				ci->i_head_snapc = NULL;
+			}
+		}
+
 		if (atomic_read(&ci->i_filelock_ref) > 0) {
 			/* make further file lock syscall return -EIO */
 			ci->i_ceph_flags |= CEPH_I_ERROR_FILELOCK;
@@ -1430,15 +1453,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			list_add(&ci->i_prealloc_cap_flush->i_list, &to_remove);
 			ci->i_prealloc_cap_flush = NULL;
 		}
-
-               if (drop &&
-                  ci->i_wrbuffer_ref_head == 0 &&
-                  ci->i_wr_ref == 0 &&
-                  ci->i_dirty_caps == 0 &&
-                  ci->i_flushing_caps == 0) {
-                      ceph_put_snap_context(ci->i_head_snapc);
-                      ci->i_head_snapc = NULL;
-               }
 	}
 	spin_unlock(&ci->i_ceph_lock);
 	while (!list_empty(&to_remove)) {
@@ -1452,7 +1466,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	wake_up_all(&ci->i_cap_wq);
 	if (invalidate)
 		ceph_queue_invalidate(inode);
-	if (drop)
+	if (dirty_dropped)
 		iput(inode);
 	return 0;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 30e9a4e415cc..749326859045 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -395,6 +395,8 @@ struct ceph_inode_info {
 	struct fscache_cookie *fscache;
 	u32 i_fscache_gen;
 #endif
+	errseq_t i_meta_err;
+
 	struct inode vfs_inode; /* at end */
 };
 
@@ -703,6 +705,8 @@ struct ceph_file_info {
 
 	spinlock_t rw_contexts_lock;
 	struct list_head rw_contexts;
+
+	errseq_t meta_err;
 };
 
 struct ceph_dir_file_info {
-- 
2.20.1

