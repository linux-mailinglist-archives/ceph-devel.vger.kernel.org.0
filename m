Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A88951226C
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbiD0TUt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiD0TTi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926EA562DF
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA0C3B8291D
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A943C385AA;
        Wed, 27 Apr 2022 19:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086835;
        bh=1UkJDKwrv9caN2oVCkP6Btr2kn/RYmehHgLLxsRqD7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTl93nU9B0xkpv2a+BUDD9a1XwPcrUE0tgr+NEATBM/y7FWdzqOSX0VXoXVNPH+MB
         9A79tGP2en/R756tObFGrATy8kpq+jk8SbuD4GX1CVpP4JvDi3Y8sdy/M7UxuWjvAs
         Ft6gJ4o17ba8DDw1yP1j4h4/JB282ZG2AlKbHyWmNPrDtuY/42mayQjc/LmbP2JBPi
         8Lt8FQd/LssKvmOhwOgGqBB/ZIDAraVjVCQMlPEQmF0foDYegX/hA3SpPHHHQPn39w
         2UfggaNMogVVr3Y1HA4R7h36BTOzw6V+JE9yy6h/RIlDq+EKQGAkTOH1rdsviOLqBa
         0OKz0lWNA9jNQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 55/64] ceph: plumb in decryption during sync reads
Date:   Wed, 27 Apr 2022 15:13:05 -0400
Message-Id: <20220427191314.222867-56-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Switch to using sparse reads when the inode is encrypted.

Note that the crypto block may be smaller than a page, but the reverse
cannot be true.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 89 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 472c525f732d..3d8f0839b718 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -948,7 +948,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	u64 off = *ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
-	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
 	u64 objver = 0;
 
 	dout("sync_read on inode %p %llx~%llx\n", inode, *ki_pos, len);
@@ -976,10 +976,19 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		int idx;
 		size_t left;
 		struct ceph_osd_req_op *op;
+		u64 read_off = off;
+		u64 read_len = len;
+
+		/* determine new offset/length if encrypted */
+		ceph_fscrypt_adjust_off_and_len(inode, &read_off, &read_len);
+
+		dout("sync_read orig %llu~%llu reading %llu~%llu",
+		     off, len, read_off, read_len);
 
 		req = ceph_osdc_new_request(osdc, &ci->i_layout,
-					ci->i_vino, off, &len, 0, 1,
-					sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
+					ci->i_vino, read_off, &read_len, 0, 1,
+					sparse ? CEPH_OSD_OP_SPARSE_READ :
+						 CEPH_OSD_OP_READ,
 					CEPH_OSD_FLAG_READ,
 					NULL, ci->i_truncate_seq,
 					ci->i_truncate_size, false);
@@ -988,10 +997,13 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			break;
 		}
 
+		/* adjust len downward if the request truncated the len */
+		if (off + len > read_off + read_len)
+			len = read_off + read_len - off;
 		more = len < iov_iter_count(to);
 
-		num_pages = calc_pages_for(off, len);
-		page_off = off & ~PAGE_MASK;
+		num_pages = calc_pages_for(read_off, read_len);
+		page_off = offset_in_page(off);
 		pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
 		if (IS_ERR(pages)) {
 			ceph_osdc_put_request(req);
@@ -999,7 +1011,8 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			break;
 		}
 
-		osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_off,
+		osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
+						 offset_in_page(read_off),
 						 false, false);
 
 		op = &req->r_ops[0];
@@ -1018,7 +1031,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		ceph_update_read_metrics(&fsc->mdsc->metric,
 					 req->r_start_latency,
 					 req->r_end_latency,
-					 len, ret);
+					 read_len, ret);
 
 		if (ret > 0)
 			objver = req->r_version;
@@ -1033,8 +1046,34 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		else if (ret == -ENOENT)
 			ret = 0;
 
+		if (ret > 0 && IS_ENCRYPTED(inode)) {
+			int fret;
+
+			fret = ceph_fscrypt_decrypt_extents(inode, pages, read_off,
+					op->extent.sparse_ext, op->extent.sparse_ext_cnt);
+			if (fret < 0) {
+				ret = fret;
+				ceph_osdc_put_request(req);
+				break;
+			}
+
+			/* account for any partial block at the beginning */
+			fret -= (off - read_off);
+
+			/*
+			 * Short read after big offset adjustment?
+			 * Nothing is usable, just call it a zero
+			 * len read.
+			 */
+			fret = max(fret, 0);
+
+			/* account for partial block at the end */
+			ret = min_t(ssize_t, fret, len);
+		}
+
 		ceph_osdc_put_request(req);
 
+		/* Short read but not EOF? Zero out the remainder. */
 		if (ret >= 0 && ret < len && (off + ret < i_size)) {
 			int zlen = min(len - ret, i_size - off - ret);
 			int zoff = page_off + ret;
@@ -1048,15 +1087,16 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		idx = 0;
 		left = ret > 0 ? ret : 0;
 		while (left > 0) {
-			size_t len, copied;
-			page_off = off & ~PAGE_MASK;
-			len = min_t(size_t, left, PAGE_SIZE - page_off);
+			size_t plen, copied;
+
+			plen = min_t(size_t, left, PAGE_SIZE - page_off);
 			SetPageUptodate(pages[idx]);
 			copied = copy_page_to_iter(pages[idx++],
-						   page_off, len, to);
+						   page_off, plen, to);
 			off += copied;
 			left -= copied;
-			if (copied < len) {
+			page_off = 0;
+			if (copied < plen) {
 				ret = -EFAULT;
 				break;
 			}
@@ -1073,20 +1113,21 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			break;
 	}
 
-	if (off > *ki_pos) {
-		if (off >= i_size) {
-			*retry_op = CHECK_EOF;
-			ret = i_size - *ki_pos;
-			*ki_pos = i_size;
-		} else {
-			ret = off - *ki_pos;
-			*ki_pos = off;
+	if (ret > 0) {
+		if (off > *ki_pos) {
+			if (off >= i_size) {
+				*retry_op = CHECK_EOF;
+				ret = i_size - *ki_pos;
+				*ki_pos = i_size;
+			} else {
+				ret = off - *ki_pos;
+				*ki_pos = off;
+			}
 		}
-	}
-
-	if (last_objver && ret > 0)
-		*last_objver = objver;
 
+		if (last_objver)
+			*last_objver = objver;
+	}
 	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
 	return ret;
 }
-- 
2.35.1

