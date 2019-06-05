Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D4635950
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 11:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfFEJLt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 05:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfFEJLt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 05:11:49 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5844C307E04E
        for <ceph-devel@vger.kernel.org>; Wed,  5 Jun 2019 09:11:48 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D22B518ED0;
        Wed,  5 Jun 2019 09:11:45 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH] ceph: track and report error of async metadata operation
Date:   Wed,  5 Jun 2019 17:11:43 +0800
Message-Id: <20190605091143.11390-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 05 Jun 2019 09:11:48 +0000 (UTC)
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
 fs/ceph/caps.c       | 10 ++++++++++
 fs/ceph/file.c       |  6 ++++--
 fs/ceph/inode.c      |  2 ++
 fs/ceph/mds_client.c | 38 +++++++++++++++++++++++++-------------
 fs/ceph/super.h      |  4 ++++
 5 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 50409d9fdc90..ba8c976634d4 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2273,6 +2273,16 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		ret = wait_event_interruptible(ci->i_cap_wq,
 					caps_are_flushed(inode, flush_tid));
 	}
+
+	if (!ret) {
+		struct ceph_file_info *fi = file->private_data;
+		if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
+			spin_lock(&file->f_lock);
+			ret = errseq_check_and_advance(&ci->i_meta_err,
+						       &fi->meta_err);
+			spin_unlock(&file->f_lock);
+		}
+	}
 out:
 	dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
 	return ret;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a7080783fe20..2fe8ca7805f4 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -200,6 +200,7 @@ prepare_open_request(struct super_block *sb, int flags, int create_mode)
 static int ceph_init_file_info(struct inode *inode, struct file *file,
 					int fmode, bool isdir)
 {
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_info *fi;
 
 	dout("%s %p %p 0%o (%s)\n", __func__, inode, file,
@@ -210,7 +211,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 		struct ceph_dir_file_info *dfi =
 			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
 		if (!dfi) {
-			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
+			ceph_put_fmode(ci, fmode); /* clean up */
 			return -ENOMEM;
 		}
 
@@ -221,7 +222,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	} else {
 		fi = kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
 		if (!fi) {
-			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
+			ceph_put_fmode(ci, fmode); /* clean up */
 			return -ENOMEM;
 		}
 
@@ -231,6 +232,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	fi->fmode = fmode;
 	spin_lock_init(&fi->rw_contexts_lock);
 	INIT_LIST_HEAD(&fi->rw_contexts);
+	fi->meta_err = errseq_sample(&ci->i_meta_err);
 
 	return 0;
 }
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 6003187dd39e..8c555734f8d5 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -512,6 +512,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	ceph_fscache_inode_init(ci);
 
+	ci->i_meta_err = 0;
+
 	return &ci->vfs_inode;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c0a15e723f11..f2be9c74c3ae 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1264,6 +1264,7 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 {
 	struct ceph_mds_request *req;
 	struct rb_node *p;
+	struct ceph_inode_info *ci;
 
 	dout("cleanup_session_requests mds%d\n", session->s_mds);
 	mutex_lock(&mdsc->mutex);
@@ -1272,6 +1273,14 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 				       struct ceph_mds_request, r_unsafe_item);
 		pr_warn_ratelimited(" dropping unsafe request %llu\n",
 				    req->r_tid);
+		if (req->r_target_inode) {
+			ci = ceph_inode(req->r_target_inode);
+			errseq_set(&ci->i_meta_err, -EIO);
+		}
+		if (req->r_unsafe_dir) {
+			ci = ceph_inode(req->r_unsafe_dir);
+			errseq_set(&ci->i_meta_err, -EIO);
+		}
 		__unregister_request(mdsc, req);
 	}
 	/* zero r_attempts, so kick_requests() will re-send requests */
@@ -1364,7 +1373,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	LIST_HEAD(to_remove);
-	bool drop = false;
+	bool dirty_dropped = false;
 	bool invalidate = false;
 
 	dout("removing cap %p, ci is %p, inode is %p\n",
@@ -1402,7 +1411,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 				inode, ceph_ino(inode));
 			ci->i_dirty_caps = 0;
 			list_del_init(&ci->i_dirty_item);
-			drop = true;
+			dirty_dropped = true;
 		}
 		if (!list_empty(&ci->i_flushing_item)) {
 			pr_warn_ratelimited(
@@ -1412,10 +1421,22 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
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
@@ -1427,15 +1448,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
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
@@ -1449,7 +1461,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	wake_up_all(&ci->i_cap_wq);
 	if (invalidate)
 		ceph_queue_invalidate(inode);
-	if (drop)
+	if (dirty_dropped)
 		iput(inode);
 	return 0;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 98d2bafc2ee2..2e516d47052f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -393,6 +393,8 @@ struct ceph_inode_info {
 	struct fscache_cookie *fscache;
 	u32 i_fscache_gen;
 #endif
+	errseq_t i_meta_err;
+
 	struct inode vfs_inode; /* at end */
 };
 
@@ -701,6 +703,8 @@ struct ceph_file_info {
 
 	spinlock_t rw_contexts_lock;
 	struct list_head rw_contexts;
+
+	errseq_t meta_err;
 };
 
 struct ceph_dir_file_info {
-- 
2.17.2

