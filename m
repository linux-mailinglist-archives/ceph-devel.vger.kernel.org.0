Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2202D75C9
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Dec 2020 13:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389152AbgLKMkI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Dec 2020 07:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436539AbgLKMjn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 07:39:43 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH 2/3] ceph: clean up inode work queueing
Date:   Fri, 11 Dec 2020 07:38:57 -0500
Message-Id: <20201211123858.7522-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211123858.7522-1-jlayton@kernel.org>
References: <20201211123858.7522-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add a generic function for taking an inode reference, setting the I_WORK
bit and queueing i_work. Turn the ceph_queue_* functions into static
inline wrappers that pass in the right bit.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 55 ++++++-------------------------------------------
 fs/ceph/super.h | 21 ++++++++++++++++---
 2 files changed, 24 insertions(+), 52 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c870be90d850..9cd8b37e586a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1816,60 +1816,17 @@ void ceph_async_iput(struct inode *inode)
 	}
 }
 
-/*
- * Write back inode data in a worker thread.  (This can't be done
- * in the message handler context.)
- */
-void ceph_queue_writeback(struct inode *inode)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	set_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask);
-
-	ihold(inode);
-	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
-		       &ci->i_work)) {
-		dout("ceph_queue_writeback %p\n", inode);
-	} else {
-		dout("ceph_queue_writeback %p already queued, mask=%lx\n",
-		     inode, ci->i_work_mask);
-		iput(inode);
-	}
-}
-
-/*
- * queue an async invalidation
- */
-void ceph_queue_invalidate(struct inode *inode)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	set_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask);
-
-	ihold(inode);
-	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
-		       &ceph_inode(inode)->i_work)) {
-		dout("ceph_queue_invalidate %p\n", inode);
-	} else {
-		dout("ceph_queue_invalidate %p already queued, mask=%lx\n",
-		     inode, ci->i_work_mask);
-		iput(inode);
-	}
-}
-
-/*
- * Queue an async vmtruncate.  If we fail to queue work, we will handle
- * the truncation the next time we call __ceph_do_pending_vmtruncate.
- */
-void ceph_queue_vmtruncate(struct inode *inode)
+void ceph_queue_inode_work(struct inode *inode, int work_bit)
 {
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	set_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask);
+	set_bit(work_bit, &ci->i_work_mask);
 
 	ihold(inode);
-	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
-		       &ci->i_work)) {
-		dout("ceph_queue_vmtruncate %p\n", inode);
+	if (queue_work(fsc->inode_wq, &ceph_inode(inode)->i_work)) {
+		dout("queue_inode_work %p, mask=%lx\n", inode, ci->i_work_mask);
 	} else {
-		dout("ceph_queue_vmtruncate %p already queued, mask=%lx\n",
+		dout("queue_inode_work %p already queued, mask=%lx\n",
 		     inode, ci->i_work_mask);
 		iput(inode);
 	}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b62d8fee3b86..59153ee201c0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -962,11 +962,26 @@ extern int ceph_inode_holds_cap(struct inode *inode, int mask);
 
 extern bool ceph_inode_set_size(struct inode *inode, loff_t size);
 extern void __ceph_do_pending_vmtruncate(struct inode *inode);
-extern void ceph_queue_vmtruncate(struct inode *inode);
-extern void ceph_queue_invalidate(struct inode *inode);
-extern void ceph_queue_writeback(struct inode *inode);
+
 extern void ceph_async_iput(struct inode *inode);
 
+void ceph_queue_inode_work(struct inode *inode, int work_bit);
+
+static inline void ceph_queue_vmtruncate(struct inode *inode)
+{
+	ceph_queue_inode_work(inode, CEPH_I_WORK_VMTRUNCATE);
+}
+
+static inline void ceph_queue_invalidate(struct inode *inode)
+{
+	ceph_queue_inode_work(inode, CEPH_I_WORK_INVALIDATE_PAGES);
+}
+
+static inline void ceph_queue_writeback(struct inode *inode)
+{
+	ceph_queue_inode_work(inode, CEPH_I_WORK_WRITEBACK);
+}
+
 extern int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 			     int mask, bool force);
 static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
-- 
2.29.2

