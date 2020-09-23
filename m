Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A128275779
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Sep 2020 13:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIWLwH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Sep 2020 07:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbgIWLwH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 07:52:07 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95B99235FC
        for <ceph-devel@vger.kernel.org>; Wed, 23 Sep 2020 11:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600861925;
        bh=xTJgIcE/lf5S3NoaGkPbcAbvpNtkSVU5O6NHzVDGZGQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=xaU0jARdOFTF8OtBmRu5u1LwxiFIC3FTSZ2NVnP937y1gIaFMTFHSGxnt3AlYZm1L
         x/19F7UYfYOm/olrA+iT7vB1igs1e0TFol3CUdFQ8kcMOIYwcKxVSr5ePc9NW63cWF
         JCMoyYJqHErYxl1E5kbM8mJ7WKwrRVt59x/zTAWs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH v2 4/5] ceph: fold ceph_sync_writepages into writepage_nounlock
Date:   Wed, 23 Sep 2020 07:52:00 -0400
Message-Id: <20200923115201.15664-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923115201.15664-1-jlayton@kernel.org>
References: <20200923115201.15664-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 93 +++++++++++++++++++-------------------------------
 1 file changed, 35 insertions(+), 58 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 5493a5205a5f..72cbaac68256 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -591,50 +591,6 @@ static u64 get_writepages_data_length(struct inode *inode,
 	return end > start ? end - start : 0;
 }
 
-/*
- * do a synchronous write on N pages
- */
-static int ceph_sync_writepages(struct ceph_fs_client *fsc,
-				struct ceph_vino vino,
-				struct ceph_file_layout *layout,
-				struct ceph_snap_context *snapc,
-				u64 off, u64 len,
-				u32 truncate_seq, u64 truncate_size,
-				struct timespec64 *mtime,
-				struct page **pages, int num_pages)
-{
-	struct ceph_osd_client *osdc = &fsc->client->osdc;
-	struct ceph_osd_request *req;
-	int rc = 0;
-	int page_align = off & ~PAGE_MASK;
-
-	req = ceph_osdc_new_request(osdc, layout, vino, off, &len, 0, 1,
-				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
-				    snapc, truncate_seq, truncate_size,
-				    true);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	/* it may be a short write due to an object boundary */
-	osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_align,
-				false, false);
-	dout("writepages %llu~%llu (%llu bytes)\n", off, len, len);
-
-	req->r_mtime = *mtime;
-	rc = ceph_osdc_start_request(osdc, req, true);
-	if (!rc)
-		rc = ceph_osdc_wait_request(osdc, req);
-
-	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
-				  req->r_end_latency, rc);
-
-	ceph_osdc_put_request(req);
-	if (rc == 0)
-		rc = len;
-	dout("writepages result %d\n", rc);
-	return rc;
-}
-
 /*
  * Write a single page, but leave the page locked.
  *
@@ -643,20 +599,19 @@ static int ceph_sync_writepages(struct ceph_fs_client *fsc,
  */
 static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 {
-	struct inode *inode;
-	struct ceph_inode_info *ci;
-	struct ceph_fs_client *fsc;
+	struct inode *inode = page->mapping->host;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_snap_context *snapc, *oldest;
 	loff_t page_off = page_offset(page);
-	int err, len = PAGE_SIZE;
+	int err;
+	loff_t len = PAGE_SIZE;
 	struct ceph_writeback_ctl ceph_wbc;
+	struct ceph_osd_client *osdc = &fsc->client->osdc;
+	struct ceph_osd_request *req;
 
 	dout("writepage %p idx %lu\n", page, page->index);
 
-	inode = page->mapping->host;
-	ci = ceph_inode(inode);
-	fsc = ceph_inode_to_client(inode);
-
 	/* verify this is a writeable snap context */
 	snapc = page_snap_context(page);
 	if (!snapc) {
@@ -685,7 +640,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	if (ceph_wbc.i_size < page_off + len)
 		len = ceph_wbc.i_size - page_off;
 
-	dout("writepage %p page %p index %lu on %llu~%u snapc %p seq %lld\n",
+	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
 	     inode, page, page->index, page_off, len, snapc, snapc->seq);
 
 	if (atomic_long_inc_return(&fsc->writeback_count) >
@@ -693,11 +648,33 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 		set_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
 
 	set_page_writeback(page);
-	err = ceph_sync_writepages(fsc, ceph_vino(inode),
-				   &ci->i_layout, snapc, page_off, len,
-				   ceph_wbc.truncate_seq,
-				   ceph_wbc.truncate_size,
-				   &inode->i_mtime, &page, 1);
+	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
+				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
+				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
+				    true);
+	if (IS_ERR(req)) {
+		redirty_page_for_writepage(wbc, page);
+		end_page_writeback(page);
+		return PTR_ERR(req);
+	}
+
+	/* it may be a short write due to an object boundary */
+	WARN_ON_ONCE(len > PAGE_SIZE);
+	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
+	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
+
+	req->r_mtime = inode->i_mtime;
+	err = ceph_osdc_start_request(osdc, req, true);
+	if (!err)
+		err = ceph_osdc_wait_request(osdc, req);
+
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+				  req->r_end_latency, err);
+
+	ceph_osdc_put_request(req);
+	if (err == 0)
+		err = len;
+
 	if (err < 0) {
 		struct writeback_control tmp_wbc;
 		if (!wbc)
-- 
2.26.2

