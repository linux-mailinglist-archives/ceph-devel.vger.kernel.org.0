Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E892BAEF8
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Nov 2020 16:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgKTPaN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Nov 2020 10:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728059AbgKTPaM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 10:30:12 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 064B5223FD;
        Fri, 20 Nov 2020 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605886211;
        bh=BG2FuI8tWs+R6EghSvjLjdZLMRL2gnF1sAr6c4cW/8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MobNi6p+chFlu2JzjZzCxrujynR3f1FjSXHMB9tWkxH6ghfSTfjn+2Q9qHkoDBgcK
         eODUv5LcQmpVLSBhsUgyTm9vktPb5GTeg4OwPMR65n0lfh25byKj5wd8VIsrLpbQpI
         VO2DUW6IZ0kd7fEmBg0XdV57nO6fV+moTgtkvzOg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, idryomov@redhat.com, dhowells@redhat.com
Subject: [PATCH 4/5] ceph: convert ceph_readpages to ceph_readahead
Date:   Fri, 20 Nov 2020 10:30:05 -0500
Message-Id: <20201120153006.304296-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201120153006.304296-1-jlayton@kernel.org>
References: <20201120153006.304296-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Convert ceph_readpages to ceph_readahead and make it use
netfs_readahead. With this we can rip out a lot of the old
readpage/readpages infrastructure.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 230 ++++++++-----------------------------------------
 1 file changed, 34 insertions(+), 196 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index dfd9fa05e0e1..ea17ee7d7218 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -342,215 +342,53 @@ static int ceph_readpage(struct file *filp, struct page *page)
 	return netfs_readpage(filp, page, &ceph_readpage_netfs_ops, NULL);
 }
 
-/*
- * Finish an async read(ahead) op.
- */
-static void finish_read(struct ceph_osd_request *req)
-{
-	struct inode *inode = req->r_inode;
-	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_osd_data *osd_data;
-	int rc = req->r_result <= 0 ? req->r_result : 0;
-	int bytes = req->r_result >= 0 ? req->r_result : 0;
-	int num_pages;
-	int i;
-
-	dout("finish_read %p req %p rc %d bytes %d\n", inode, req, rc, bytes);
-	if (rc == -EBLOCKLISTED)
-		ceph_inode_to_client(inode)->blocklisted = true;
-
-	/* unlock all pages, zeroing any data we didn't read */
-	osd_data = osd_req_op_extent_osd_data(req, 0);
-	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
-	num_pages = calc_pages_for((u64)osd_data->alignment,
-					(u64)osd_data->length);
-	for (i = 0; i < num_pages; i++) {
-		struct page *page = osd_data->pages[i];
-
-		if (rc < 0 && rc != -ENOENT)
-			goto unlock;
-		if (bytes < (int)PAGE_SIZE) {
-			/* zero (remainder of) page */
-			int s = bytes < 0 ? 0 : bytes;
-			zero_user_segment(page, s, PAGE_SIZE);
-		}
- 		dout("finish_read %p uptodate %p idx %lu\n", inode, page,
-		     page->index);
-		flush_dcache_page(page);
-		SetPageUptodate(page);
-unlock:
-		unlock_page(page);
-		put_page(page);
-		bytes -= PAGE_SIZE;
-	}
-
-	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
-				 req->r_end_latency, rc);
-
-	kfree(osd_data->pages);
-}
-
-/*
- * start an async read(ahead) operation.  return nr_pages we submitted
- * a read for on success, or negative error code.
- */
-static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
-		      struct list_head *page_list, int max)
+static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
 {
-	struct ceph_osd_client *osdc =
-		&ceph_inode_to_client(inode)->client->osdc;
+	struct inode *inode = mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct page *page = lru_to_page(page_list);
-	struct ceph_vino vino;
-	struct ceph_osd_request *req;
-	u64 off;
-	u64 len;
-	int i;
-	struct page **pages;
-	pgoff_t next_index;
-	int nr_pages = 0;
-	int got = 0;
-	int ret = 0;
+	int got = (int)(uintptr_t)priv;
 
-	if (!rw_ctx) {
-		/* caller of readpages does not hold buffer and read caps
-		 * (fadvise, madvise and readahead cases) */
-		int want = CEPH_CAP_FILE_CACHE;
-		ret = ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want,
-					true, &got);
-		if (ret < 0) {
-			dout("start_read %p, error getting cap\n", inode);
-		} else if (!(got & want)) {
-			dout("start_read %p, no cache cap\n", inode);
-			ret = 0;
-		}
-		if (ret <= 0) {
-			if (got)
-				ceph_put_cap_refs(ci, got);
-			while (!list_empty(page_list)) {
-				page = lru_to_page(page_list);
-				list_del(&page->lru);
-				put_page(page);
-			}
-			return ret;
-		}
-	}
-
-	off = (u64) page_offset(page);
-
-	/* count pages */
-	next_index = page->index;
-	list_for_each_entry_reverse(page, page_list, lru) {
-		if (page->index != next_index)
-			break;
-		nr_pages++;
-		next_index++;
-		if (max && nr_pages == max)
-			break;
-	}
-	len = nr_pages << PAGE_SHIFT;
-	dout("start_read %p nr_pages %d is %lld~%lld\n", inode, nr_pages,
-	     off, len);
-	vino = ceph_vino(inode);
-	req = ceph_osdc_new_request(osdc, &ci->i_layout, vino, off, &len,
-				    0, 1, CEPH_OSD_OP_READ,
-				    CEPH_OSD_FLAG_READ, NULL,
-				    ci->i_truncate_seq, ci->i_truncate_size,
-				    false);
-	if (IS_ERR(req)) {
-		ret = PTR_ERR(req);
-		goto out;
-	}
-
-	/* build page vector */
-	nr_pages = calc_pages_for(0, len);
-	pages = kmalloc_array(nr_pages, sizeof(*pages), GFP_KERNEL);
-	if (!pages) {
-		ret = -ENOMEM;
-		goto out_put;
-	}
-	for (i = 0; i < nr_pages; ++i) {
-		page = list_entry(page_list->prev, struct page, lru);
-		BUG_ON(PageLocked(page));
-		list_del(&page->lru);
-
- 		dout("start_read %p adding %p idx %lu\n", inode, page,
-		     page->index);
-		if (add_to_page_cache_lru(page, &inode->i_data, page->index,
-					  GFP_KERNEL)) {
-			put_page(page);
-			dout("start_read %p add_to_page_cache failed %p\n",
-			     inode, page);
-			nr_pages = i;
-			if (nr_pages > 0) {
-				len = nr_pages << PAGE_SHIFT;
-				osd_req_op_extent_update(req, 0, len);
-				break;
-			}
-			goto out_pages;
-		}
-		pages[i] = page;
-	}
-	osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
-	req->r_callback = finish_read;
-	req->r_inode = inode;
-
-	dout("start_read %p starting %p %lld~%lld\n", inode, req, off, len);
-	ret = ceph_osdc_start_request(osdc, req, false);
-	if (ret < 0)
-		goto out_pages;
-	ceph_osdc_put_request(req);
-
-	/* After adding locked pages to page cache, the inode holds cache cap.
-	 * So we can drop our cap refs. */
 	if (got)
 		ceph_put_cap_refs(ci, got);
-
-	return nr_pages;
-
-out_pages:
-	for (i = 0; i < nr_pages; ++i) {
-		unlock_page(pages[i]);
-	}
-	ceph_put_page_vector(pages, nr_pages, false);
-out_put:
-	ceph_osdc_put_request(req);
-out:
-	if (got)
-		ceph_put_cap_refs(ci, got);
-	return ret;
 }
+const struct netfs_read_request_ops ceph_readahead_netfs_ops = {
+	.init_rreq		= ceph_init_rreq,
+	.is_cache_enabled	= ceph_is_cache_enabled,
+	.begin_cache_operation	= ceph_begin_cache_operation,
+	.issue_op		= ceph_netfs_issue_op,
+	.clamp_length		= ceph_netfs_clamp_length,
+	.cleanup		= ceph_readahead_cleanup,
+};
 
-
-/*
- * Read multiple pages.  Leave pages we don't read + unlock in page_list;
- * the caller (VM) cleans them up.
- */
-static int ceph_readpages(struct file *file, struct address_space *mapping,
-			  struct list_head *page_list, unsigned nr_pages)
+static void ceph_readahead(struct readahead_control *ractl)
 {
-	struct inode *inode = file_inode(file);
-	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_file_info *fi = file->private_data;
+	struct inode *inode = file_inode(ractl->file);
+	struct ceph_file_info *fi = ractl->file->private_data;
 	struct ceph_rw_context *rw_ctx;
-	int rc = 0;
-	int max = 0;
+	int got = 0;
+	int ret = 0;
 
 	if (ceph_inode(inode)->i_inline_version != CEPH_INLINE_NONE)
-		return -EINVAL;
+		return;
 
 	rw_ctx = ceph_find_rw_context(fi);
-	max = fsc->mount_options->rsize >> PAGE_SHIFT;
-	dout("readpages %p file %p ctx %p nr_pages %d max %d\n",
-	     inode, file, rw_ctx, nr_pages, max);
-	while (!list_empty(page_list)) {
-		rc = start_read(inode, rw_ctx, page_list, max);
-		if (rc < 0)
-			goto out;
+	if (!rw_ctx) {
+		/*
+		 * readahead callers do not necessarily hold Fcb caps
+		 * (e.g. fadvise, madvise).
+		 */
+		int want = CEPH_CAP_FILE_CACHE;
+
+		ret = ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want, true, &got);
+		if (ret < 0)
+			dout("start_read %p, error getting cap\n", inode);
+		else if (!(got & want))
+			dout("start_read %p, no cache cap\n", inode);
+
+		if (ret <= 0)
+			return;
 	}
-out:
-	dout("readpages %p file %p ret %d\n", inode, file, rc);
-	return rc;
+	netfs_readahead(ractl, &ceph_readahead_netfs_ops, (void *)(uintptr_t)got);
 }
 
 struct ceph_writeback_ctl
@@ -1503,7 +1341,7 @@ static ssize_t ceph_direct_io(struct kiocb *iocb, struct iov_iter *iter)
 
 const struct address_space_operations ceph_aops = {
 	.readpage = ceph_readpage,
-	.readpages = ceph_readpages,
+	.readahead = ceph_readahead,
 	.writepage = ceph_writepage,
 	.writepages = ceph_writepages_start,
 	.write_begin = ceph_write_begin,
-- 
2.28.0

