Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4868F425B32
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Oct 2021 20:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243830AbhJGTBD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Oct 2021 15:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233866AbhJGTBD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 15:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEAC161139;
        Thu,  7 Oct 2021 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633633149;
        bh=tPKHctQyWN1GTHt3Y5BgH9++tY0+uJdS+Y3RxREBKtM=;
        h=From:To:Cc:Subject:Date:From;
        b=Na3GeHGilvMn3Ofg3Pl5cwHXfi65BkOo0lIN3jvcCvi2moWD1N48Mq6jp1RoJ4x39
         j808WmptdD+hV5SLakuk146kNS6eoTZhvpcGB/BlGY/R2Z63VrajnpXltGozXwYApx
         UQSPBNlNAVVJxlcbxSaHRi/Saq52RLOT+bfcHH32YOPce29ZYpaSJUAWsWa60SLtRW
         7ByvF7C2sFhjuR74DVA+Whvb7tLS7QkxSF+nwIbppE1W0C6qH3eUiON9MXPcpBhhy/
         umVzBGkL0UsJNE04gHhJYdVHfVhmezkTZiEWLeylOr8NH4epIVozYLADK8dMq9PK6c
         MhuZsfe15njzQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH] ceph: fix handling of "meta" errors on ceph
Date:   Thu,  7 Oct 2021 14:59:07 -0400
Message-Id: <20211007185907.122326-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, we check the wb_err too early for directories, before all of
the unsafe child requests have been waited on. In order to fix that we
need to check the mapping->wb_err later nearer to the end of ceph_fsync.

We also have an overly-complex method for tracking errors after
blocklisting. The errors recorded in cleanup_session_requests go to a
completely separate field in the inode, but we end up reporting them the
same way we would for any other error (in fsync).

There's no real benefit to tracking these errors in two different
places, since the only reporting mechanism for them is in fsync, and
we'd need to advance them both every time.

Given that, we can just remove i_meta_err, and convert the places that
used it to instead just use mapping->wb_err instead. That also fixes
the original problem by ensuring that we do a check_and_advance of the
wb_err at the end of the fsync op.

URL: https://tracker.ceph.com/issues/52864
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 14 ++++----------
 fs/ceph/file.c       |  1 -
 fs/ceph/inode.c      |  2 --
 fs/ceph/mds_client.c | 15 ++++-----------
 fs/ceph/super.h      |  3 ---
 5 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cdeb5b2d7920..21268d2c6e56 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2331,7 +2331,6 @@ static int unsafe_request_wait(struct inode *inode)
 
 int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct ceph_file_info *fi = file->private_data;
 	struct inode *inode = file->f_mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 flush_tid;
@@ -2366,14 +2365,9 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	if (err < 0)
 		ret = err;
 
-	if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
-		spin_lock(&file->f_lock);
-		err = errseq_check_and_advance(&ci->i_meta_err,
-					       &fi->meta_err);
-		spin_unlock(&file->f_lock);
-		if (err < 0)
-			ret = err;
-	}
+	err = file_check_and_advance_wb_err(file);
+	if (err < 0)
+		ret = err;
 out:
 	dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
 	return ret;
@@ -4663,7 +4657,7 @@ int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invali
 		spin_unlock(&mdsc->cap_dirty_lock);
 
 		if (dirty_dropped) {
-			errseq_set(&ci->i_meta_err, -EIO);
+			mapping_set_error(inode->i_mapping, -EIO);
 
 			if (ci->i_wrbuffer_ref_head == 0 &&
 			    ci->i_wr_ref == 0 &&
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d20785285d26..91173d3aa161 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -233,7 +233,6 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 
 	spin_lock_init(&fi->rw_contexts_lock);
 	INIT_LIST_HEAD(&fi->rw_contexts);
-	fi->meta_err = errseq_sample(&ci->i_meta_err);
 	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
 
 	return 0;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 23b5a0867e3a..00c73242c4bf 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -542,8 +542,6 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 
 	ceph_fscache_inode_init(ci);
 
-	ci->i_meta_err = 0;
-
 	return &ci->vfs_inode;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 279462482416..598425ccd020 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1493,7 +1493,6 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 {
 	struct ceph_mds_request *req;
 	struct rb_node *p;
-	struct ceph_inode_info *ci;
 
 	dout("cleanup_session_requests mds%d\n", session->s_mds);
 	mutex_lock(&mdsc->mutex);
@@ -1502,16 +1501,10 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
 				       struct ceph_mds_request, r_unsafe_item);
 		pr_warn_ratelimited(" dropping unsafe request %llu\n",
 				    req->r_tid);
-		if (req->r_target_inode) {
-			/* dropping unsafe change of inode's attributes */
-			ci = ceph_inode(req->r_target_inode);
-			errseq_set(&ci->i_meta_err, -EIO);
-		}
-		if (req->r_unsafe_dir) {
-			/* dropping unsafe directory operation */
-			ci = ceph_inode(req->r_unsafe_dir);
-			errseq_set(&ci->i_meta_err, -EIO);
-		}
+		if (req->r_target_inode)
+			mapping_set_error(req->r_target_inode->i_mapping, -EIO);
+		if (req->r_unsafe_dir)
+			mapping_set_error(req->r_unsafe_dir->i_mapping, -EIO);
 		__unregister_request(mdsc, req);
 	}
 	/* zero r_attempts, so kick_requests() will re-send requests */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 8aa39bab2d72..d730e508159f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -435,8 +435,6 @@ struct ceph_inode_info {
 #ifdef CONFIG_CEPH_FSCACHE
 	struct fscache_cookie *fscache;
 #endif
-	errseq_t i_meta_err;
-
 	struct inode vfs_inode; /* at end */
 };
 
@@ -781,7 +779,6 @@ struct ceph_file_info {
 	spinlock_t rw_contexts_lock;
 	struct list_head rw_contexts;
 
-	errseq_t meta_err;
 	u32 filp_gen;
 	atomic_t num_locks;
 };
-- 
2.31.1

