Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AE926C637
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Sep 2020 19:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgIPRju (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Sep 2020 13:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbgIPRi7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:38:59 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A844B2076C;
        Wed, 16 Sep 2020 17:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600277939;
        bh=jKY2L0+BIoKCnkrk12Tkp01kroUzXRO5lx7n1np0GtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyawjpLjdhOjpzIcNDBSf28Qr0Y8M2hHoJfwLaSKFIqbymjNmsxPQniklnmUdVpEb
         Ej680Au/K8iW78ZP7vxEEBTwMpA7D1XTuhEbGrCu48uZX2YQgyxXa739RRZkzJMTEX
         jy15fhMMTjnMJ6u9FIahSk3JeAiiaCQAOgUECqxo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com
Subject: [PATCH 3/5] ceph: fold ceph_sync_readpages into ceph_readpage
Date:   Wed, 16 Sep 2020 13:38:52 -0400
Message-Id: <20200916173854.330265-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916173854.330265-1-jlayton@kernel.org>
References: <20200916173854.330265-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's the only caller and this will make reorg easier.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 79 ++++++++++++++++----------------------------------
 1 file changed, 25 insertions(+), 54 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 02e286c30d44..19de3e9ccafe 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -182,58 +182,15 @@ static int ceph_releasepage(struct page *page, gfp_t g)
 	return !PagePrivate(page);
 }
 
-/*
- * Read some contiguous pages.  If we cross a stripe boundary, shorten
- * *plen.  Return number of bytes read, or error.
- */
-static int ceph_sync_readpages(struct ceph_fs_client *fsc,
-			       struct ceph_vino vino,
-			       struct ceph_file_layout *layout,
-			       u64 off, u64 *plen,
-			       u32 truncate_seq, u64 truncate_size,
-			       struct page **pages, int num_pages,
-			       int page_align)
-{
-	struct ceph_osd_client *osdc = &fsc->client->osdc;
-	struct ceph_osd_request *req;
-	int rc = 0;
-
-	dout("readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
-	     vino.snap, off, *plen);
-	req = ceph_osdc_new_request(osdc, layout, vino, off, plen, 0, 1,
-				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
-				    NULL, truncate_seq, truncate_size,
-				    false);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	/* it may be a short read due to an object boundary */
-	osd_req_op_extent_osd_data_pages(req, 0,
-				pages, *plen, page_align, false, false);
-
-	dout("readpages  final extent is %llu~%llu (%llu bytes align %d)\n",
-	     off, *plen, *plen, page_align);
-
-	rc = ceph_osdc_start_request(osdc, req, false);
-	if (!rc)
-		rc = ceph_osdc_wait_request(osdc, req);
-
-	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
-				 req->r_end_latency, rc);
-
-	ceph_osdc_put_request(req);
-	dout("readpages result %d\n", rc);
-	return rc;
-}
-
-/*
- * read a single page, without unlocking it.
- */
+/* read a single page, without unlocking it. */
 static int ceph_do_readpage(struct file *filp, struct page *page)
 {
 	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_osd_client *osdc = &fsc->client->osdc;
+	struct ceph_osd_request *req;
+	struct ceph_vino vino = ceph_vino(inode);
 	int err = 0;
 	u64 off = page_offset(page);
 	u64 len = PAGE_SIZE;
@@ -260,12 +217,27 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 	if (err == 0)
 		return -EINPROGRESS;
 
-	dout("readpage inode %p file %p page %p index %lu\n",
-	     inode, filp, page, page->index);
-	err = ceph_sync_readpages(fsc, ceph_vino(inode),
-				  &ci->i_layout, off, &len,
-				  ci->i_truncate_seq, ci->i_truncate_size,
-				  &page, 1, 0);
+	dout("readpage ino %llx.%llx file %p off %llu len %llu page %p index %lu\n",
+	     vino.ino, vino.snap, filp, off, len, page, page->index);
+	req = ceph_osdc_new_request(osdc, &ci->i_layout, vino, off, &len, 0, 1,
+				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ, NULL,
+				    ci->i_truncate_seq, ci->i_truncate_size,
+				    false);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
+
+	err = ceph_osdc_start_request(osdc, req, false);
+	if (!err)
+		err = ceph_osdc_wait_request(osdc, req);
+
+	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
+				 req->r_end_latency, err);
+
+	ceph_osdc_put_request(req);
+	dout("readpage result %d\n", err);
+
 	if (err == -ENOENT)
 		err = 0;
 	if (err < 0) {
@@ -283,7 +255,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 
 	SetPageUptodate(page);
 	ceph_readpage_to_fscache(inode, page);
-
 out:
 	return err < 0 ? err : 0;
 }
-- 
2.26.2

