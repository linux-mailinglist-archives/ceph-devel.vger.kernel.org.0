Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F2E234689
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jul 2020 15:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbgGaNEc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jul 2020 09:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732368AbgGaNE3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 09:04:29 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962F522B49;
        Fri, 31 Jul 2020 13:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596200669;
        bh=XfIgZV50j2mYIdBJe+jhHA9CKtIEXh9gXeD0mDmSqcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRcfiBMEKIE3y4YKxeW3P98jfVvPxBpZa/y7LWKEZGqu2lQb30bSnYHRAw7oUJyi0
         6ZkgQEWe955hcrf4y4RhWojdHpWfgbF7af1L0ttN/Vg8VBlvbYOIXud6/mDnrtjKWo
         cQ3V6FizLvseVW+smgQrGDQGqEoA5FDsWj/sGj2Q=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, idryomov@gmail.com
Subject: [RFC PATCH v2 10/11] ceph: add fscache writeback support
Date:   Fri, 31 Jul 2020 09:04:20 -0400
Message-Id: <20200731130421.127022-11-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731130421.127022-1-jlayton@kernel.org>
References: <20200731130421.127022-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When updating the backing store from the pagecache (a'la writepage or
writepages), write to the cache first. This allows us to keep caching
files even when they are open for write. If the OSD write fails,
invalidate the cache.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 116 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8905fe4a0930..a21aec8ac0f1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -435,6 +435,98 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+#ifdef CONFIG_CEPH_FSCACHE
+const struct fscache_io_request_ops ceph_write_fsreq_ops = {
+	.get		= ceph_fsreq_get,
+	.put		= ceph_fsreq_put,
+};
+
+/*
+ * Clear the PG_fscache flag from a sequence of pages and wake up anyone who's
+ * waiting.  The last page is included in the sequence. Poached from afs_clear_fscache_bits.
+ */
+static void ceph_clear_fscache_bits(struct address_space *mapping,
+				   pgoff_t start, pgoff_t last)
+{
+	struct page *page;
+
+	XA_STATE(xas, &mapping->i_pages, start);
+
+	rcu_read_lock();
+	xas_for_each(&xas, page, last) {
+		unlock_page_fscache(page);
+	}
+	rcu_read_unlock();
+}
+
+static void ceph_write_to_cache_done(struct fscache_io_request *fsreq)
+{
+	pgoff_t start = fsreq->pos >> PAGE_SHIFT;
+	pgoff_t last = start + fsreq->nr_pages - 1;
+
+	ceph_clear_fscache_bits(fsreq->mapping, start, last);
+	if (fsreq->error && fsreq->error != -ENOBUFS)
+		ceph_fscache_invalidate(fsreq->mapping->host, 0);
+}
+
+static void ceph_write_to_cache(struct inode *inode, u64 off, u64 len)
+{
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct iov_iter iter;
+	struct ceph_fscache_req *req;
+	struct fscache_cookie *cookie = ceph_inode(inode)->fscache;
+	pgoff_t start = off >> PAGE_SHIFT;
+	struct fscache_request_shape shape = {
+		.proposed_start		= start,
+		.proposed_nr_pages	= calc_pages_for(off, len),
+		.max_io_pages		= fsc->mount_options->wsize >> PAGE_SHIFT,
+		.i_size			= i_size_read(inode),
+		.for_write		= true,
+	};
+	pgoff_t last = start + shape.proposed_nr_pages - 1;
+
+	/* Don't do anything if cache is disabled */
+	if (!fscache_cookie_enabled(cookie))
+		goto abandon;
+
+	fscache_shape_request(cookie, &shape);
+	if (!(shape.to_be_done & FSCACHE_WRITE_TO_CACHE) ||
+	    shape.actual_nr_pages == 0 ||
+	    shape.actual_start != shape.proposed_start)
+		goto abandon;
+
+	if (shape.actual_nr_pages < shape.proposed_nr_pages) {
+		ceph_clear_fscache_bits(inode->i_mapping, start + shape.actual_nr_pages,
+					start + shape.proposed_nr_pages - 1);
+		last = shape.proposed_start + shape.actual_nr_pages - 1;
+		len = (u64)(last + 1 - start) << PAGE_SHIFT;
+	}
+
+	req = ceph_fsreq_alloc();
+	if (!req)
+		goto abandon;
+
+	fscache_init_io_request(&req->fscache_req, cookie, &ceph_write_fsreq_ops);
+	req->fscache_req.pos = round_down(off, shape.dio_block_size);
+	req->fscache_req.len = round_up(len, shape.dio_block_size);
+	req->fscache_req.nr_pages = shape.actual_nr_pages;
+	req->fscache_req.mapping = inode->i_mapping;
+	req->fscache_req.io_done = ceph_write_to_cache_done;
+
+	iov_iter_mapping(&iter, WRITE, inode->i_mapping, req->fscache_req.pos,
+			 req->fscache_req.len);
+	fscache_write(&req->fscache_req, &iter);
+	ceph_fsreq_put(&req->fscache_req);
+	return;
+abandon:
+	ceph_clear_fscache_bits(inode->i_mapping, start, last);
+}
+#else
+static inline void ceph_write_to_cache(struct inode *inode, u64 off, u64 len)
+{
+}
+#endif /* CONFIG_CEPH_FSCACHE */
+
 struct ceph_writeback_ctl
 {
 	loff_t i_size;
@@ -588,16 +680,17 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
 		set_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
 
-	set_page_writeback(page);
 	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
 				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
 				    true);
-	if (IS_ERR(req)) {
-		redirty_page_for_writepage(wbc, page);
-		end_page_writeback(page);
+	if (IS_ERR(req))
 		return PTR_ERR(req);
-	}
+
+	set_page_writeback(page);
+	if (TestSetPageFsCache(page))
+		BUG();
+	ceph_write_to_cache(inode, page_off, len);
 
 	/* it may be a short write due to an object boundary */
 	WARN_ON_ONCE(len > PAGE_SIZE);
@@ -656,6 +749,9 @@ static int ceph_writepage(struct page *page, struct writeback_control *wbc)
 	struct inode *inode = page->mapping->host;
 	BUG_ON(!inode);
 	ihold(inode);
+
+	ceph_wait_on_page_fscache(page);
+
 	err = writepage_nounlock(page, wbc);
 	if (err == -ERESTARTSYS) {
 		/* direct memory reclaimer was killed by SIGKILL. return 0
@@ -901,7 +997,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 				unlock_page(page);
 				break;
 			}
-			if (PageWriteback(page)) {
+			if (PageWriteback(page) || PageFsCache(page)) {
 				if (wbc->sync_mode == WB_SYNC_NONE) {
 					dout("%p under writeback\n", page);
 					unlock_page(page);
@@ -909,6 +1005,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 				}
 				dout("waiting on writeback %p\n", page);
 				wait_on_page_writeback(page);
+				ceph_wait_on_page_fscache(page);
 			}
 
 			if (!clear_page_dirty_for_io(page)) {
@@ -1041,9 +1138,19 @@ static int ceph_writepages_start(struct address_space *mapping,
 		op_idx = 0;
 		for (i = 0; i < locked_pages; i++) {
 			u64 cur_offset = page_offset(pages[i]);
+			/*
+			 * Discontinuity in page range? Ceph can handle that by just passing
+			 * multiple extents in the write op.
+			 */
 			if (offset + len != cur_offset) {
+				/* If it's full, stop here */
 				if (op_idx + 1 == req->r_num_ops)
 					break;
+
+				/* Kick off an fscache write with what we have so far. */
+				ceph_write_to_cache(inode, offset, len);
+
+				/* Start a new extent */
 				osd_req_op_extent_dup_last(req, op_idx,
 							   cur_offset - offset);
 				dout("writepages got pages at %llu~%llu\n",
@@ -1060,8 +1167,11 @@ static int ceph_writepages_start(struct address_space *mapping,
 			}
 
 			set_page_writeback(pages[i]);
+			if (TestSetPageFsCache(pages[i]))
+				BUG();
 			len += PAGE_SIZE;
 		}
+		ceph_write_to_cache(inode, offset, len);
 
 		if (ceph_wbc.size_stable) {
 			len = min(len, ceph_wbc.i_size - offset);
-- 
2.26.2

