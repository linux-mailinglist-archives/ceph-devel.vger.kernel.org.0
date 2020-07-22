Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EB42296B2
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 12:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgGVKzV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 06:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgGVKzT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 06:55:19 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6705D207CD;
        Wed, 22 Jul 2020 10:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595415318;
        bh=bMd7f6hiztFdf0MzCHUL+YGcdVHb3KaucBGRXiMvViI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icIm0QBfkTKxfSVExWIuyTo8sFEXp3IHqSVjqvx/Gb3AJtiIFryfHu9eKyNDokg4o
         qwBxk1Ud2hITNfSyt7ejtDqEuXdHBV0YEXOsDyZr4uvmsi3bnEYi/bnE2aAoldmLhu
         3xqPERPtocUarlQLQyWDwNc2d+uY5b0uHAbACM44=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     dhowells@redhat.com, dwysocha@redhat.com, smfrench@gmail.com
Subject: [RFC PATCH 08/11] ceph: plug write_begin into read helper
Date:   Wed, 22 Jul 2020 06:55:08 -0400
Message-Id: <20200722105511.11187-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722105511.11187-1-jlayton@kernel.org>
References: <20200722105511.11187-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Plug write_begin into the read helper routine. This requires adding a
new is_req_valid op that we can use to vet whether there is an
incompatible snap context that needs to be flushed before we can fill
the page.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 251 +++++++++++++++++++++++++------------------------
 1 file changed, 130 insertions(+), 121 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 98f5edbf70b6..cc10bf17b65b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -185,6 +185,7 @@ static int ceph_releasepage(struct page *page, gfp_t g)
 
 struct ceph_fscache_req {
 	struct fscache_io_request	fscache_req;
+	struct ceph_snap_context	*snapc;
 	refcount_t			ref;
 };
 
@@ -376,77 +377,6 @@ static int ceph_readpage(struct file *filp, struct page *page)
 	return err;
 }
 
-/* read a single page, without unlocking it. */
-static int ceph_do_readpage(struct file *filp, struct page *page)
-{
-	struct inode *inode = file_inode(filp);
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_osd_client *osdc = &fsc->client->osdc;
-	struct ceph_osd_request *req;
-	struct ceph_vino vino = ceph_vino(inode);
-	int err = 0;
-	u64 off = page_offset(page);
-	u64 len = PAGE_SIZE;
-
-	if (off >= i_size_read(inode)) {
-		zero_user_segment(page, 0, PAGE_SIZE);
-		SetPageUptodate(page);
-		return 0;
-	}
-
-	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		/*
-		 * Uptodate inline data should have been added
-		 * into page cache while getting Fcr caps.
-		 */
-		if (off == 0)
-			return -EINVAL;
-		zero_user_segment(page, 0, PAGE_SIZE);
-		SetPageUptodate(page);
-		return 0;
-	}
-
-	dout("readpage ino %llx.%llx file %p off %llu len %llu page %p index %lu\n",
-	     vino.ino, vino.snap, filp, off, len, page, page->index);
-	req = ceph_osdc_new_request(osdc, &ci->i_layout, vino, off, &len, 0, 1,
-				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ, NULL,
-				    ci->i_truncate_seq, ci->i_truncate_size,
-				    false);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
-
-	err = ceph_osdc_start_request(osdc, req, false);
-	if (!err)
-		err = ceph_osdc_wait_request(osdc, req);
-
-	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
-				 req->r_end_latency, err);
-
-	ceph_osdc_put_request(req);
-	dout("readpage result %d\n", err);
-
-	if (err == -ENOENT)
-		err = 0;
-	if (err < 0) {
-		SetPageError(page);
-		if (err == -EBLACKLISTED)
-			fsc->blacklisted = true;
-		goto out;
-	}
-	if (err < PAGE_SIZE)
-		/* zero fill remainder of page */
-		zero_user_segment(page, err, PAGE_SIZE);
-	else
-		flush_dcache_page(page);
-
-	SetPageUptodate(page);
-out:
-	return err < 0 ? err : 0;
-}
-
 /*
  * Finish an async read(ahead) op.
  */
@@ -1473,6 +1403,30 @@ ceph_find_incompatible(struct inode *inode, struct page *page)
 	return NULL;
 }
 
+static int ceph_fsreq_is_req_valid(struct fscache_io_request *fsreq)
+{
+	struct ceph_snap_context *snapc;
+	struct ceph_fscache_req *req = container_of(fsreq, struct ceph_fscache_req, fscache_req);
+
+	snapc = ceph_find_incompatible(fsreq->mapping->host, fsreq->no_unlock_page);
+	if (snapc) {
+		if (IS_ERR(snapc))
+			return PTR_ERR(snapc);
+		req->snapc = snapc;
+		return -EAGAIN;
+	}
+	return 0;
+}
+
+const struct fscache_io_request_ops ceph_read_for_write_fsreq_ops = {
+	.issue_op	= ceph_fsreq_issue_op,
+	.reshape	= ceph_fsreq_reshape,
+	.is_req_valid	= ceph_fsreq_is_req_valid,
+	.done		= ceph_fsreq_done,
+	.get		= ceph_fsreq_get,
+	.put		= ceph_fsreq_put,
+};
+
 /*
  * We are only allowed to write into/dirty the page if the page is
  * clean, or already dirty within the same snap context.
@@ -1483,76 +1437,131 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 {
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_snap_context *snapc;
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct fscache_cookie *cookie = ceph_fscache_cookie(ci);
 	struct page *page = NULL;
 	pgoff_t index = pos >> PAGE_SHIFT;
-	loff_t page_off = pos & PAGE_MASK;
 	int pos_in_page = pos & ~PAGE_MASK;
-	int end_in_page = pos_in_page + len;
-	loff_t i_size;
 	int r;
-refind:
-	/* get a page */
-	page = grab_cache_page_write_begin(mapping, index, 0);
-	if (!page)
-		return -ENOMEM;
 
-	dout("write_begin file %p inode %p page %p %d~%d\n", file,
-	     inode, page, (int)pos, (int)len);
+	if (ci->i_inline_version != CEPH_INLINE_NONE) {
+		/*
+		 * In principle, we should never get here, as the inode should have been uninlined
+		 * before we're allowed to write to the page (in write_iter or page_mkwrite).
+		 */
+		WARN_ONCE(1, "ceph: write_begin called on still-inlined inode!\n");
 
-	for (;;) {
-		snapc = ceph_find_incompatible(inode, page);
-		if (snapc) {
-			if (IS_ERR(snapc)) {
-				r = PTR_ERR(snapc);
-				break;
-			}
-			unlock_page(page);
-			ceph_queue_writeback(inode);
-			r = wait_event_killable(ci->i_cap_wq,
-						context_is_writeable_or_written(inode, snapc));
-			ceph_put_snap_context(snapc);
-			put_page(page);
-			goto refind;
+		/*
+		 * Uptodate inline data should have been added
+		 * into page cache while getting Fcr caps.
+		 */
+		if (index == 0) {
+			r = -EINVAL;
+			goto out;
 		}
 
-		if (PageUptodate(page)) {
-			dout(" page %p already uptodate\n", page);
-			break;
+		page = grab_cache_page_write_begin(mapping, index, 0);
+		if (!page)
+			return -ENOMEM;
+
+		zero_user_segment(page, 0, PAGE_SIZE);
+		SetPageUptodate(page);
+		r = 0;
+		goto out;
+	}
+
+	do {
+		struct ceph_fscache_req *req;
+		struct ceph_snap_context *snapc = NULL;
+
+		page = pagecache_get_page(mapping, index, FGP_WRITE, 0);
+		if (page) {
+			r = 0;
+			if (PageUptodate(page)) {
+				lock_page(page);
+				if (PageUptodate(page))
+					goto out;
+				unlock_page(page);
+			}
 		}
 
-		/* full page? */
-		if (pos_in_page == 0 && len == PAGE_SIZE)
-			break;
+		/*
+		 * In some cases we don't need to read at all:
+		 * - full page write
+		 * - write that lies completely beyond EOF
+		 * - write that covers the the page from start to EOF or beyond it
+		 */
+		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
+		    (pos >= i_size_read(inode)) ||
+		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
+			if (!page) {
+				page = grab_cache_page_write_begin(mapping, index, 0);
+				if (!page) {
+					r = -ENOMEM;
+					break;
+				}
+			} else {
+				lock_page(page);
+			}
+
+			snapc = ceph_find_incompatible(inode, page);
+			if (!snapc) {
+				zero_user_segments(page, 0, pos_in_page,
+							 pos_in_page + len, PAGE_SIZE);
+				r = 0;
+				goto out;
+			}
+
+			unlock_page(page);
 
-		/* past end of file? */
-		i_size = i_size_read(inode);
-		if (page_off >= i_size ||
-		    (pos_in_page == 0 && (pos+len) >= i_size &&
-		     end_in_page - pos_in_page != PAGE_SIZE)) {
-			dout(" zeroing %p 0 - %d and %d - %d\n",
-			     page, pos_in_page, end_in_page, (int)PAGE_SIZE);
-			zero_user_segments(page,
-					   0, pos_in_page,
-					   end_in_page, PAGE_SIZE);
+			if (IS_ERR(snapc)) {
+				r = PTR_ERR(snapc);
+				goto out;
+			}
+			goto flush_incompat;
+		}
+
+		req = ceph_fsreq_alloc();
+		if (!req) {
+			unlock_page(page);
+			r = -ENOMEM;
 			break;
 		}
 
-		/* we need to read it. */
-		r = ceph_do_readpage(file, page);
-		if (r) {
-			if (r == -EINPROGRESS)
-				continue;
+		/*
+		 * Do the read. If we find out that we need to wait on writeback, then kick that
+		 * off, wait for it and then resubmit the read.
+		 */
+		fscache_init_io_request(&req->fscache_req, cookie, &ceph_read_for_write_fsreq_ops);
+		req->fscache_req.mapping = inode->i_mapping;
+
+		r = fscache_read_helper_for_write(&req->fscache_req, &page, index,
+						  fsc->mount_options->rsize >> PAGE_SHIFT, 0);
+		if (r != -EAGAIN) {
+			if (r == 0)
+				r = wait_on_bit(&req->fscache_req.flags,
+						FSCACHE_IO_READ_IN_PROGRESS, TASK_KILLABLE);
+			ceph_fsreq_put(&req->fscache_req);
 			break;
 		}
-	}
 
+		BUG_ON(!req->snapc);
+		snapc = ceph_get_snap_context(req->snapc);
+		ceph_fsreq_put(&req->fscache_req);
+flush_incompat:
+		put_page(page);
+		page = NULL;
+		ceph_queue_writeback(inode);
+		r = wait_event_killable(ci->i_cap_wq,
+					context_is_writeable_or_written(inode, snapc));
+		ceph_put_snap_context(snapc);
+	} while (r == 0);
+out:
 	if (r < 0) {
-		if (page) {
-			unlock_page(page);
+		if (page)
 			put_page(page);
-		}
 	} else {
+		WARN_ON_ONCE(!PageLocked(page));
 		*pagep = page;
 	}
 	return r;
-- 
2.26.2

