Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0897D5A124B
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242810AbiHYNcH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242753AbiHYNbx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DC6B5169
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A0AA61CFD
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906E0C43470;
        Thu, 25 Aug 2022 13:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434308;
        bh=gzbJ3vpZYn3C2puFdD9XXRBqOjArPCWr5BZ71jGVmDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pyzzk76vlp4RqqOcMBovHEjmrwlVMrXESTzjPVH+iZ+jrKnoyH8kbUBjvj07etUJQ
         e804xGz2/u4gCT4iyCtrOjTIbr6YGaxouaVEE2U6xNdXCS30nLLsvDgw3cuQ6qYqbE
         eFHTo886RhbQBK0cRfpU2fYLC/W+emdazABH2bqJDNm+4ayG/qUZcelnnBmbwE1Yyy
         w77rlpd/J2Qit1MUjJuNUOwOV03legA2pcnEjpVG8yTayHQV4/U0lJohtR/m+7+1ur
         Wk37Ia7b0tvBKYtZ2y5BfaH7PftLjwQ8n2jOt9AcrWOIp6eRRMCO9BG3s7W2BLdImM
         TFPOoGRiEeyWA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 19/29] ceph: plumb in decryption during sync reads
Date:   Thu, 25 Aug 2022 09:31:22 -0400
Message-Id: <20220825133132.153657-20-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Switch to using sparse reads when the inode is encrypted.

Note that the crypto block may be smaller than a page, but the reverse
cannot be true.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 89 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 064af05da955..3ebdc43959a4 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -962,7 +962,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	u64 off = *ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
-	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
 	u64 objver = 0;
 
 	dout("sync_read on inode %p %llx~%llx\n", inode, *ki_pos, len);
@@ -990,10 +990,19 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
@@ -1002,10 +1011,13 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
@@ -1013,7 +1025,8 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			break;
 		}
 
-		osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_off,
+		osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
+						 offset_in_page(read_off),
 						 false, false);
 
 		op = &req->r_ops[0];
@@ -1031,7 +1044,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		ceph_update_read_metrics(&fsc->mdsc->metric,
 					 req->r_start_latency,
 					 req->r_end_latency,
-					 len, ret);
+					 read_len, ret);
 
 		if (ret > 0)
 			objver = req->r_version;
@@ -1046,8 +1059,34 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
@@ -1061,15 +1100,16 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
@@ -1086,20 +1126,21 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
2.37.2

