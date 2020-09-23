Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80E527577A
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Sep 2020 13:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgIWLwI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Sep 2020 07:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgIWLwG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 07:52:06 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11C0A2193E
        for <ceph-devel@vger.kernel.org>; Wed, 23 Sep 2020 11:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600861926;
        bh=PeyMDaPbw18gie5xl55cw70Y2YM1lB23U7NekW3yEWc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FFrRS/Py1umQNP9PVHZsOVsREpKFhgufG6UeYez/HK8/jQCU1PZcKbEJuy9DsjpBR
         MpZd8Vj7twP1sP2ramUpYsXMKuD8Et8MuLlRqUExq9GckdTdSzLWFOmvE1ah4yqO23
         NKjywwO9TVYgGv/4Y1WEKcDN9m0Rj0jDwgThzlEk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH v2 5/5] ceph: fold ceph_update_writeable_page into ceph_write_begin
Date:   Wed, 23 Sep 2020 07:52:01 -0400
Message-Id: <20200923115201.15664-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923115201.15664-1-jlayton@kernel.org>
References: <20200923115201.15664-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...and reorganize the loop for better clarity.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 146 +++++++++++++++++++++----------------------------
 1 file changed, 63 insertions(+), 83 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 72cbaac68256..97827f68a3e7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1306,104 +1306,84 @@ ceph_find_incompatible(struct page *page)
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
-	loff_t page_off = pos & PAGE_MASK;
+	struct page *page = NULL;
+	pgoff_t index = pos >> PAGE_SHIFT;
 	int pos_in_page = pos & ~PAGE_MASK;
-	int end_in_page = pos_in_page + len;
-	loff_t i_size;
-	int r;
+	int r = 0;
 
-retry_locked:
-	snapc = ceph_find_incompatible(page);
-	if (snapc) {
-		if (IS_ERR(snapc)) {
-			r = PTR_ERR(snapc);
-			goto fail_unlock;
+	dout("write_begin file %p inode %p page %p %d~%d\n", file, inode, page, (int)pos, (int)len);
+
+	for (;;) {
+		page = grab_cache_page_write_begin(mapping, index, 0);
+		if (!page) {
+			r = -ENOMEM;
+			break;
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
+		snapc = ceph_find_incompatible(page);
+		if (snapc) {
+			if (IS_ERR(snapc)) {
+				r = PTR_ERR(snapc);
+				break;
+			}
+			unlock_page(page);
+			put_page(page);
+			page = NULL;
+			ceph_queue_writeback(inode);
+			r = wait_event_killable(ci->i_cap_wq,
+						context_is_writeable_or_written(inode, snapc));
+			ceph_put_snap_context(snapc);
+			if (r != 0)
+				break;
+			continue;
+		}
 
-	/* full page? */
-	if (pos_in_page == 0 && len == PAGE_SIZE)
-		return 0;
+		if (PageUptodate(page)) {
+			dout(" page %p already uptodate\n", page);
+			break;
+		}
 
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
+		/*
+		 * In some cases we don't need to read at all:
+		 * - full page write
+		 * - write that lies completely beyond EOF
+		 * - write that covers the the page from start to EOF or beyond it
+		 */
+		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
+		    (pos >= i_size_read(inode)) ||
+		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
+			zero_user_segments(page, 0, pos_in_page,
+					   pos_in_page + len, PAGE_SIZE);
+			break;
+		}
 
-	/* we need to read it. */
-	r = ceph_do_readpage(file, page);
-	if (r < 0) {
-		if (r == -EINPROGRESS)
-			return -EAGAIN;
-		goto fail_unlock;
+		/*
+		 * We need to read it. If we get back -EINPROGRESS, then the page was
+		 * handed off to fscache and it will be unlocked when the read completes.
+		 * Refind the page in that case so we can reacquire the page lock. Otherwise
+		 * we got a hard error or the read was completed synchronously.
+		 */
+		r = ceph_do_readpage(file, page);
+		if (r != -EINPROGRESS)
+			break;
 	}
-	goto retry_locked;
-fail_unlock:
-	unlock_page(page);
-	return r;
-}
-
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

