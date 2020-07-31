Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4508E234683
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jul 2020 15:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbgGaNE1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jul 2020 09:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgGaNE0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 09:04:26 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B356722B49;
        Fri, 31 Jul 2020 13:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596200666;
        bh=YZccTh39EcRfz7mMECDamQdeR7IUKYYESiB+f64eqVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peMiQl3bEs5pGjDXSEKAAyfacbtbDby+WA3POcmHbj9U0ndgUBdefKb0UOUvxEWSY
         rLE3suYFwqATRF0YO45WuLe/1QsVAMrKOxKJwzsSV/BiOLMNrA4enu2GxB/1Si1B/e
         SSrLhclFWRWyM6Tzi14MFM/shDbVK7aafWnEqYJs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, idryomov@gmail.com
Subject: [RFC PATCH v2 05/11] ceph: fold ceph_update_writeable_page into ceph_write_begin
Date:   Fri, 31 Jul 2020 09:04:15 -0400
Message-Id: <20200731130421.127022-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731130421.127022-1-jlayton@kernel.org>
References: <20200731130421.127022-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...and reorganize the loop for better clarity.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 141 ++++++++++++++++++++++---------------------------
 1 file changed, 62 insertions(+), 79 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index a04eaf75480b..f4df04769761 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1252,6 +1252,8 @@ static int context_is_writeable_or_written(struct inode *inode,
  * @inode: inode associated with page
  * @page: page being dirtied
  *
+ * We are only allowed to write into/dirty the page if the page is
+ * clean, or already dirty within the same snap context.
  * Returns NULL on success, negative error code on error, and a snapc ref that should be
  * waited on otherwise.
  */
@@ -1308,104 +1310,85 @@ ceph_find_incompatible(struct inode *inode, struct page *page)
 /*
  * We are only allowed to write into/dirty the page if the page is
  * clean, or already dirty within the same snap context.
- *
- * called with page locked.
- * return success with page locked,
- * or any failure (incl -EAGAIN) with page unlocked.
  */
-static int ceph_update_writeable_page(struct file *file,
-			    loff_t pos, unsigned len,
-			    struct page *page)
+static int ceph_write_begin(struct file *file, struct address_space *mapping,
+			    loff_t pos, unsigned len, unsigned flags,
+			    struct page **pagep, void **fsdata)
 {
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_snap_context *snapc;
+	struct page *page = NULL;
+	pgoff_t index = pos >> PAGE_SHIFT;
 	loff_t page_off = pos & PAGE_MASK;
 	int pos_in_page = pos & ~PAGE_MASK;
 	int end_in_page = pos_in_page + len;
 	loff_t i_size;
 	int r;
+refind:
+	/* get a page */
+	page = grab_cache_page_write_begin(mapping, index, 0);
+	if (!page)
+		return -ENOMEM;
 
-retry_locked:
-	snapc = ceph_find_incompatible(inode, page);
-	if (snapc) {
-		if (IS_ERR(snapc)) {
-			r = PTR_ERR(snapc);
-			goto fail_unlock;
+	dout("write_begin file %p inode %p page %p %d~%d\n", file,
+	     inode, page, (int)pos, (int)len);
+
+	for (;;) {
+		snapc = ceph_find_incompatible(inode, page);
+		if (snapc) {
+			if (IS_ERR(snapc)) {
+				r = PTR_ERR(snapc);
+				break;
+			}
+			unlock_page(page);
+			ceph_queue_writeback(inode);
+			r = wait_event_killable(ci->i_cap_wq,
+						context_is_writeable_or_written(inode, snapc));
+			ceph_put_snap_context(snapc);
+			put_page(page);
+			goto refind;
 		}
-		unlock_page(page);
-		ceph_queue_writeback(inode);
-		r = wait_event_killable(ci->i_cap_wq,
-					context_is_writeable_or_written(inode, snapc));
-		ceph_put_snap_context(snapc);
-		return -EAGAIN;
-	}
 
-	if (PageUptodate(page)) {
-		dout(" page %p already uptodate\n", page);
-		return 0;
-	}
+		if (PageUptodate(page)) {
+			dout(" page %p already uptodate\n", page);
+			break;
+		}
 
-	/* full page? */
-	if (pos_in_page == 0 && len == PAGE_SIZE)
-		return 0;
+		/* full page? */
+		if (pos_in_page == 0 && len == PAGE_SIZE)
+			break;
 
-	/* past end of file? */
-	i_size = i_size_read(inode);
-
-	if (page_off >= i_size ||
-	    (pos_in_page == 0 && (pos+len) >= i_size &&
-	     end_in_page - pos_in_page != PAGE_SIZE)) {
-		dout(" zeroing %p 0 - %d and %d - %d\n",
-		     page, pos_in_page, end_in_page, (int)PAGE_SIZE);
-		zero_user_segments(page,
-				   0, pos_in_page,
-				   end_in_page, PAGE_SIZE);
-		return 0;
-	}
+		/* past end of file? */
+		i_size = i_size_read(inode);
+		if (page_off >= i_size ||
+		    (pos_in_page == 0 && (pos+len) >= i_size &&
+		     end_in_page - pos_in_page != PAGE_SIZE)) {
+			dout(" zeroing %p 0 - %d and %d - %d\n",
+			     page, pos_in_page, end_in_page, (int)PAGE_SIZE);
+			zero_user_segments(page,
+					   0, pos_in_page,
+					   end_in_page, PAGE_SIZE);
+			break;
+		}
 
-	/* we need to read it. */
-	r = ceph_do_readpage(file, page);
-	if (r < 0) {
-		if (r == -EINPROGRESS)
-			return -EAGAIN;
-		goto fail_unlock;
+		/* we need to read it. */
+		r = ceph_do_readpage(file, page);
+		if (r) {
+			if (r == -EINPROGRESS)
+				continue;
+			break;
+		}
 	}
-	goto retry_locked;
-fail_unlock:
-	unlock_page(page);
-	return r;
-}
 
-/*
- * We are only allowed to write into/dirty the page if the page is
- * clean, or already dirty within the same snap context.
- */
-static int ceph_write_begin(struct file *file, struct address_space *mapping,
-			    loff_t pos, unsigned len, unsigned flags,
-			    struct page **pagep, void **fsdata)
-{
-	struct inode *inode = file_inode(file);
-	struct page *page;
-	pgoff_t index = pos >> PAGE_SHIFT;
-	int r;
-
-	do {
-		/* get a page */
-		page = grab_cache_page_write_begin(mapping, index, 0);
-		if (!page)
-			return -ENOMEM;
-
-		dout("write_begin file %p inode %p page %p %d~%d\n", file,
-		     inode, page, (int)pos, (int)len);
-
-		r = ceph_update_writeable_page(file, pos, len, page);
-		if (r < 0)
+	if (r < 0) {
+		if (page) {
+			unlock_page(page);
 			put_page(page);
-		else
-			*pagep = page;
-	} while (r == -EAGAIN);
-
+		}
+	} else {
+		*pagep = page;
+	}
 	return r;
 }
 
-- 
2.26.2

