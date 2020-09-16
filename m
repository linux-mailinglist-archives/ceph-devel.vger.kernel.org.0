Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D5926C638
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Sep 2020 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgIPRj7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Sep 2020 13:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727288AbgIPRi7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:38:59 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81A8520708;
        Wed, 16 Sep 2020 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600277937;
        bh=NKPwYfkTayb562ch4wj6BLB2o+wJeNyJD02fPOTq5Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcVG05W2URtQZcGM4eimFBEmbECUq2Cg2Z7O2RoR9eEyW0I2zfSqSUheNfdbO++2H
         WUHeDgJmjCoDYh0k1AY8umvdcu94PimmW+0GEUuc2YXEmBIgUzB1MAWziocld6vWsP
         2kavUDIR6cEjJKo3eLSpgJ8ui8pkCqzwBH5IO+7g=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com
Subject: [PATCH 1/5] ceph: break out writeback of incompatible snap context to separate function
Date:   Wed, 16 Sep 2020 13:38:50 -0400
Message-Id: <20200916173854.330265-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916173854.330265-1-jlayton@kernel.org>
References: <20200916173854.330265-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When dirtying a page, we have to flush incompatible contexts. Move that
into a separate function.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 96 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 36 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7b1f3dad576f..c8e98fee8164 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1298,40 +1298,34 @@ static int context_is_writeable_or_written(struct inode *inode,
 	return ret;
 }
 
-/*
- * We are only allowed to write into/dirty the page if the page is
- * clean, or already dirty within the same snap context.
+/**
+ * ceph_find_incompatible - find an incompatible context and return it
+ * @inode: inode associated with page
+ * @page: page being dirtied
  *
- * called with page locked.
- * return success with page locked,
- * or any failure (incl -EAGAIN) with page unlocked.
+ * Returns NULL on success, negative error code on error, and a snapc ref that should be
+ * waited on otherwise.
  */
-static int ceph_update_writeable_page(struct file *file,
-			    loff_t pos, unsigned len,
-			    struct page *page)
+static struct ceph_snap_context *
+ceph_find_incompatible(struct inode *inode, struct page *page)
 {
-	struct inode *inode = file_inode(file);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	loff_t page_off = pos & PAGE_MASK;
-	int pos_in_page = pos & ~PAGE_MASK;
-	int end_in_page = pos_in_page + len;
-	loff_t i_size;
-	int r;
-	struct ceph_snap_context *snapc, *oldest;
 
 	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
 		dout(" page %p forced umount\n", page);
-		unlock_page(page);
-		return -EIO;
+		return ERR_PTR(-EIO);
 	}
 
-retry_locked:
-	/* writepages currently holds page lock, but if we change that later, */
-	wait_on_page_writeback(page);
+	for (;;) {
+		struct ceph_snap_context *snapc, *oldest;
+
+		wait_on_page_writeback(page);
+
+		snapc = page_snap_context(page);
+		if (!snapc || snapc == ci->i_head_snapc)
+			break;
 
-	snapc = page_snap_context(page);
-	if (snapc && snapc != ci->i_head_snapc) {
 		/*
 		 * this page is already dirty in another (older) snap
 		 * context!  is it writeable now?
@@ -1346,26 +1340,56 @@ static int ceph_update_writeable_page(struct file *file,
 			 * be writeable or written
 			 */
 			snapc = ceph_get_snap_context(snapc);
-			unlock_page(page);
-			ceph_queue_writeback(inode);
-			r = wait_event_killable(ci->i_cap_wq,
-			       context_is_writeable_or_written(inode, snapc));
-			ceph_put_snap_context(snapc);
-			if (r == -ERESTARTSYS)
-				return r;
-			return -EAGAIN;
+			return snapc;
 		}
 		ceph_put_snap_context(oldest);
 
 		/* yay, writeable, do it now (without dropping page lock) */
 		dout(" page %p snapc %p not current, but oldest\n",
 		     page, snapc);
-		if (!clear_page_dirty_for_io(page))
-			goto retry_locked;
-		r = writepage_nounlock(page, NULL);
-		if (r < 0)
+		if (clear_page_dirty_for_io(page)) {
+			int r = writepage_nounlock(page, NULL);
+			if (r < 0)
+				return ERR_PTR(r);
+		}
+	}
+	return NULL;
+}
+
+/*
+ * We are only allowed to write into/dirty the page if the page is
+ * clean, or already dirty within the same snap context.
+ *
+ * called with page locked.
+ * return success with page locked,
+ * or any failure (incl -EAGAIN) with page unlocked.
+ */
+static int ceph_update_writeable_page(struct file *file,
+			    loff_t pos, unsigned len,
+			    struct page *page)
+{
+	struct inode *inode = file_inode(file);
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_snap_context *snapc;
+	loff_t page_off = pos & PAGE_MASK;
+	int pos_in_page = pos & ~PAGE_MASK;
+	int end_in_page = pos_in_page + len;
+	loff_t i_size;
+	int r;
+
+retry_locked:
+	snapc = ceph_find_incompatible(inode, page);
+	if (snapc) {
+		if (IS_ERR(snapc)) {
+			r = PTR_ERR(snapc);
 			goto fail_unlock;
-		goto retry_locked;
+		}
+		unlock_page(page);
+		ceph_queue_writeback(inode);
+		r = wait_event_killable(ci->i_cap_wq,
+					context_is_writeable_or_written(inode, snapc));
+		ceph_put_snap_context(snapc);
+		return -EAGAIN;
 	}
 
 	if (PageUptodate(page)) {
-- 
2.26.2

