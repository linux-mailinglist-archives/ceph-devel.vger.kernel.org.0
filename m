Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB2E6C6048
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 08:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjCWHAk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 03:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCWHAa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 03:00:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0E78A66
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ljc+0nYbAKe59gAujdUmOGiLcNcqXNH7iZ8V9YDseGM=;
        b=GTNLnkCSAvIj/OeXI2oW/KOy/uHba/rtC9XgRjSNPJy22LucZ2ZvY7JSLUDIunZLjlAmH6
        fhV2FnRUFLp1pMzer8WOPUp8YCdMoqhjMsYRBFEkXFkA/SDCpZA6uwUxV7LApIbrJEAMVf
        l68jT1fqHJ7MjCy1hng/W4kGk/t1yro=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-bj0exMY0NmK8d9ZQAg5m9A-1; Thu, 23 Mar 2023 02:58:53 -0400
X-MC-Unique: bj0exMY0NmK8d9ZQAg5m9A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB467101A550;
        Thu, 23 Mar 2023 06:58:52 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AF90492B01;
        Thu, 23 Mar 2023 06:58:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 56/71] ceph: plumb in decryption during sync reads
Date:   Thu, 23 Mar 2023 14:55:10 +0800
Message-Id: <20230323065525.201322-57-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Switch to using sparse reads when the inode is encrypted.

Note that the crypto block may be smaller than a page, but the reverse
cannot be true.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 89 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3ba5f74acbaa..0adaa89d0604 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -967,7 +967,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	u64 off = *ki_pos;
 	u64 len = iov_iter_count(to);
 	u64 i_size = i_size_read(inode);
-	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
 	u64 objver = 0;
 
 	dout("sync_read on inode %p %llx~%llx\n", inode, *ki_pos, len);
@@ -998,10 +998,19 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
@@ -1010,10 +1019,13 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
@@ -1021,7 +1033,8 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			break;
 		}
 
-		osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_off,
+		osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
+						 offset_in_page(read_off),
 						 false, false);
 
 		op = &req->r_ops[0];
@@ -1039,7 +1052,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		ceph_update_read_metrics(&fsc->mdsc->metric,
 					 req->r_start_latency,
 					 req->r_end_latency,
-					 len, ret);
+					 read_len, ret);
 
 		if (ret > 0)
 			objver = req->r_version;
@@ -1054,8 +1067,34 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
@@ -1069,15 +1108,16 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
@@ -1094,20 +1134,21 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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
2.31.1

