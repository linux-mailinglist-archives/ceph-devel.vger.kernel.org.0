Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C390C277C0
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 10:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfEWINy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 04:13:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfEWINy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 May 2019 04:13:54 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63B49C05678B
        for <ceph-devel@vger.kernel.org>; Thu, 23 May 2019 08:13:53 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D19FE65F42;
        Thu, 23 May 2019 08:13:50 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 2/8] ceph: single workqueue for inode related works
Date:   Thu, 23 May 2019 16:13:39 +0800
Message-Id: <20190523081345.20410-2-zyan@redhat.com>
In-Reply-To: <20190523081345.20410-1-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 23 May 2019 08:13:53 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We have three workqueue for inode works. Later patch will introduce
one more work for inode. It's not good to introcuce more workqueue
and add more 'struct work_struct' to 'struct ceph_inode_info'.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/file.c  |   2 +-
 fs/ceph/inode.c | 124 ++++++++++++++++++++++--------------------------
 fs/ceph/super.c |  28 +++--------
 fs/ceph/super.h |  17 ++++---
 4 files changed, 74 insertions(+), 97 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ccc054794542..b7be02dfb897 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -790,7 +790,7 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 		if (aio_work) {
 			INIT_WORK(&aio_work->work, ceph_aio_retry_work);
 			aio_work->req = req;
-			queue_work(ceph_inode_to_client(inode)->wb_wq,
+			queue_work(ceph_inode_to_client(inode)->inode_wq,
 				   &aio_work->work);
 			return;
 		}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 6eabcdb321cb..d9ff349821f0 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -33,9 +33,7 @@
 
 static const struct inode_operations ceph_symlink_iops;
 
-static void ceph_invalidate_work(struct work_struct *work);
-static void ceph_writeback_work(struct work_struct *work);
-static void ceph_vmtruncate_work(struct work_struct *work);
+static void ceph_inode_work(struct work_struct *work);
 
 /*
  * find or create an inode, given the ceph ino number
@@ -509,10 +507,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ci->i_snap_realm_item);
 	INIT_LIST_HEAD(&ci->i_snap_flush_item);
 
-	INIT_WORK(&ci->i_wb_work, ceph_writeback_work);
-	INIT_WORK(&ci->i_pg_inv_work, ceph_invalidate_work);
-
-	INIT_WORK(&ci->i_vmtruncate_work, ceph_vmtruncate_work);
+	INIT_WORK(&ci->i_work, ceph_inode_work);
+	ci->i_work_mask = 0;
 
 	ceph_fscache_inode_init(ci);
 
@@ -1750,51 +1746,62 @@ bool ceph_inode_set_size(struct inode *inode, loff_t size)
  */
 void ceph_queue_writeback(struct inode *inode)
 {
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	set_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask);
+
 	ihold(inode);
-	if (queue_work(ceph_inode_to_client(inode)->wb_wq,
-		       &ceph_inode(inode)->i_wb_work)) {
+	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
+		       &ci->i_work)) {
 		dout("ceph_queue_writeback %p\n", inode);
 	} else {
-		dout("ceph_queue_writeback %p failed\n", inode);
+		dout("ceph_queue_writeback %p already queued, mask=%lx\n",
+		     inode, ci->i_work_mask);
 		iput(inode);
 	}
 }
 
-static void ceph_writeback_work(struct work_struct *work)
-{
-	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
-						  i_wb_work);
-	struct inode *inode = &ci->vfs_inode;
-
-	dout("writeback %p\n", inode);
-	filemap_fdatawrite(&inode->i_data);
-	iput(inode);
-}
-
 /*
  * queue an async invalidation
  */
 void ceph_queue_invalidate(struct inode *inode)
 {
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	set_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask);
+
 	ihold(inode);
-	if (queue_work(ceph_inode_to_client(inode)->pg_inv_wq,
-		       &ceph_inode(inode)->i_pg_inv_work)) {
+	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
+		       &ceph_inode(inode)->i_work)) {
 		dout("ceph_queue_invalidate %p\n", inode);
 	} else {
-		dout("ceph_queue_invalidate %p failed\n", inode);
+		dout("ceph_queue_invalidate %p already queued, mask=%lx\n",
+		     inode, ci->i_work_mask);
 		iput(inode);
 	}
 }
 
 /*
- * Invalidate inode pages in a worker thread.  (This can't be done
- * in the message handler context.)
+ * Queue an async vmtruncate.  If we fail to queue work, we will handle
+ * the truncation the next time we call __ceph_do_pending_vmtruncate.
  */
-static void ceph_invalidate_work(struct work_struct *work)
+void ceph_queue_vmtruncate(struct inode *inode)
 {
-	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
-						  i_pg_inv_work);
-	struct inode *inode = &ci->vfs_inode;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	set_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask);
+
+	ihold(inode);
+	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
+		       &ci->i_work)) {
+		dout("ceph_queue_vmtruncate %p\n", inode);
+	} else {
+		dout("ceph_queue_vmtruncate %p already queued, mask=%lx\n",
+		     inode, ci->i_work_mask);
+		iput(inode);
+	}
+}
+
+static void ceph_do_invalidate_pages(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	u32 orig_gen;
 	int check = 0;
@@ -1846,44 +1853,6 @@ static void ceph_invalidate_work(struct work_struct *work)
 out:
 	if (check)
 		ceph_check_caps(ci, 0, NULL);
-	iput(inode);
-}
-
-
-/*
- * called by trunc_wq;
- *
- * We also truncate in a separate thread as well.
- */
-static void ceph_vmtruncate_work(struct work_struct *work)
-{
-	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
-						  i_vmtruncate_work);
-	struct inode *inode = &ci->vfs_inode;
-
-	dout("vmtruncate_work %p\n", inode);
-	__ceph_do_pending_vmtruncate(inode);
-	iput(inode);
-}
-
-/*
- * Queue an async vmtruncate.  If we fail to queue work, we will handle
- * the truncation the next time we call __ceph_do_pending_vmtruncate.
- */
-void ceph_queue_vmtruncate(struct inode *inode)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-
-	ihold(inode);
-
-	if (queue_work(ceph_sb_to_client(inode->i_sb)->trunc_wq,
-		       &ci->i_vmtruncate_work)) {
-		dout("ceph_queue_vmtruncate %p\n", inode);
-	} else {
-		dout("ceph_queue_vmtruncate %p failed, pending=%d\n",
-		     inode, ci->i_truncate_pending);
-		iput(inode);
-	}
 }
 
 /*
@@ -1947,6 +1916,25 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	wake_up_all(&ci->i_cap_wq);
 }
 
+static void ceph_inode_work(struct work_struct *work)
+{
+	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
+						 i_work);
+	struct inode *inode = &ci->vfs_inode;
+
+	if (test_and_clear_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask)) {
+		dout("writeback %p\n", inode);
+		filemap_fdatawrite(&inode->i_data);
+	}
+	if (test_and_clear_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask))
+		ceph_do_invalidate_pages(inode);
+
+	if (test_and_clear_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask))
+		__ceph_do_pending_vmtruncate(inode);
+
+	iput(inode);
+}
+
 /*
  * symlinks
  */
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index afc4c5d008d4..b1ee41372e85 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -671,18 +671,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 	 * The number of concurrent works can be high but they don't need
 	 * to be processed in parallel, limit concurrency.
 	 */
-	fsc->wb_wq = alloc_workqueue("ceph-writeback", 0, 1);
-	if (!fsc->wb_wq)
+	fsc->inode_wq = alloc_workqueue("ceph-inode", WQ_UNBOUND, 0);
+	if (!fsc->inode_wq)
 		goto fail_client;
-	fsc->pg_inv_wq = alloc_workqueue("ceph-pg-invalid", 0, 1);
-	if (!fsc->pg_inv_wq)
-		goto fail_wb_wq;
-	fsc->trunc_wq = alloc_workqueue("ceph-trunc", 0, 1);
-	if (!fsc->trunc_wq)
-		goto fail_pg_inv_wq;
 	fsc->cap_wq = alloc_workqueue("ceph-cap", 0, 1);
 	if (!fsc->cap_wq)
-		goto fail_trunc_wq;
+		goto fail_inode_wq;
 
 	/* set up mempools */
 	err = -ENOMEM;
@@ -696,12 +690,8 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 
 fail_cap_wq:
 	destroy_workqueue(fsc->cap_wq);
-fail_trunc_wq:
-	destroy_workqueue(fsc->trunc_wq);
-fail_pg_inv_wq:
-	destroy_workqueue(fsc->pg_inv_wq);
-fail_wb_wq:
-	destroy_workqueue(fsc->wb_wq);
+fail_inode_wq:
+	destroy_workqueue(fsc->inode_wq);
 fail_client:
 	ceph_destroy_client(fsc->client);
 fail:
@@ -714,9 +704,7 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 
 static void flush_fs_workqueues(struct ceph_fs_client *fsc)
 {
-	flush_workqueue(fsc->wb_wq);
-	flush_workqueue(fsc->pg_inv_wq);
-	flush_workqueue(fsc->trunc_wq);
+	flush_workqueue(fsc->inode_wq);
 	flush_workqueue(fsc->cap_wq);
 }
 
@@ -724,9 +712,7 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
 {
 	dout("destroy_fs_client %p\n", fsc);
 
-	destroy_workqueue(fsc->wb_wq);
-	destroy_workqueue(fsc->pg_inv_wq);
-	destroy_workqueue(fsc->trunc_wq);
+	destroy_workqueue(fsc->inode_wq);
 	destroy_workqueue(fsc->cap_wq);
 
 	mempool_destroy(fsc->wb_pagevec_pool);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c84135bb72c6..234610ce4155 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -109,9 +109,7 @@ struct ceph_fs_client {
 	mempool_t *wb_pagevec_pool;
 	atomic_long_t writeback_count;
 
-	struct workqueue_struct *wb_wq;
-	struct workqueue_struct *pg_inv_wq;
-	struct workqueue_struct *trunc_wq;
+	struct workqueue_struct *inode_wq;
 	struct workqueue_struct *cap_wq;
 
 #ifdef CONFIG_DEBUG_FS
@@ -388,10 +386,8 @@ struct ceph_inode_info {
 	struct list_head i_snap_flush_item;
 	struct timespec64 i_snap_btime;
 
-	struct work_struct i_wb_work;  /* writeback work */
-	struct work_struct i_pg_inv_work;  /* page invalidation work */
-
-	struct work_struct i_vmtruncate_work;
+	struct work_struct i_work;
+	unsigned long  i_work_mask;
 
 #ifdef CONFIG_CEPH_FSCACHE
 	struct fscache_cookie *fscache;
@@ -513,6 +509,13 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 #define CEPH_I_ERROR_FILELOCK	(1 << 12) /* have seen file lock errors */
 
 
+/*
+ * Masks of ceph inode work.
+ */
+#define CEPH_I_WORK_WRITEBACK		0 /* writeback */
+#define CEPH_I_WORK_INVALIDATE_PAGES	1 /* invalidate pages */
+#define CEPH_I_WORK_VMTRUNCATE		2 /* vmtruncate */
+
 /*
  * We set the ERROR_WRITE bit when we start seeing write errors on an inode
  * and then clear it when they start succeeding. Note that we do a lockless
-- 
2.17.2

