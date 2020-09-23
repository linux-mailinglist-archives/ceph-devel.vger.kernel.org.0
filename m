Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9839027577C
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Sep 2020 13:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgIWLwF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Sep 2020 07:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgIWLwF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 07:52:05 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4633A21BE5
        for <ceph-devel@vger.kernel.org>; Wed, 23 Sep 2020 11:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600861924;
        bh=od09BW0Qa4/D/CbXljpLsHS8TBJmMyPU1emsEJeQc4M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iMGzmC26o84/2mO0Mvokd8p/dKaAkTtfMxo+O/9KxzEJzDRN4b73ns8wABLK7frfq
         hWZ06hPSdIw34DyJ7FNorrzDCBYexkzyjD5sZvOCLMjCFfnwMTcf4GwQa0BtV6ds9X
         4uSVIcjdCz+0iUT5P6hnzqhzDa98PWlCntEg3cVM=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH v2 1/5] ceph: break out writeback of incompatible snap context to separate function
Date:   Wed, 23 Sep 2020 07:51:57 -0400
Message-Id: <20200923115201.15664-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923115201.15664-1-jlayton@kernel.org>
References: <20200923115201.15664-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When dirtying a page, we have to flush incompatible contexts. Move the
search for an incompatible context into a separate function, and fix up
the caller to wait and retry if there is one.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 112 +++++++++++++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 45 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7b1f3dad576f..f8b478237ea8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1298,74 +1298,96 @@ static int context_is_writeable_or_written(struct inode *inode,
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
+ * We are only allowed to write into/dirty a page if the page is
+ * clean, or already dirty within the same snap context. Returns a
+ * conflicting context if there is one, NULL if there isn't, or a
+ * negative error code on other errors.
+ *
+ * Must be called with page lock held.
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
 		 */
 		oldest = get_oldest_context(inode, NULL, NULL);
 		if (snapc->seq > oldest->seq) {
+			/* not writeable -- return it for the caller to deal with */
 			ceph_put_snap_context(oldest);
-			dout(" page %p snapc %p not current or oldest\n",
-			     page, snapc);
-			/*
-			 * queue for writeback, and wait for snapc to
-			 * be writeable or written
-			 */
-			snapc = ceph_get_snap_context(snapc);
-			unlock_page(page);
-			ceph_queue_writeback(inode);
-			r = wait_event_killable(ci->i_cap_wq,
-			       context_is_writeable_or_written(inode, snapc));
-			ceph_put_snap_context(snapc);
-			if (r == -ERESTARTSYS)
-				return r;
-			return -EAGAIN;
+			dout(" page %p snapc %p not current or oldest\n", page, snapc);
+			return ceph_get_snap_context(snapc);
 		}
 		ceph_put_snap_context(oldest);
 
 		/* yay, writeable, do it now (without dropping page lock) */
-		dout(" page %p snapc %p not current, but oldest\n",
-		     page, snapc);
-		if (!clear_page_dirty_for_io(page))
-			goto retry_locked;
-		r = writepage_nounlock(page, NULL);
-		if (r < 0)
+		dout(" page %p snapc %p not current, but oldest\n", page, snapc);
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

