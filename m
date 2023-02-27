Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3356A39B4
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjB0Dde (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjB0Ddd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:33:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B811968E
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynLtodM3cP785riaV6hmnLRAJPkQ5jmyQfjDkTbTR2s=;
        b=IOI0b6+LAFWYYWUmUfF/k+u8rMPRHrsoBq2znswPPpSxWc/iPhHaUQMow1K2CpIzp5ZHCp
        7B+2taCgkXifYPUI1R5S8jXEDm9UEVIPWe481YHuhZMCQCVKSScZ0vPHu5wS7jcTZ43Pre
        hgze0zC2h0+csKucsMSeu3R2vebNwkc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-DVKLiKaJOpyxvF1dwExfJA-1; Sun, 26 Feb 2023 22:31:32 -0500
X-MC-Unique: DVKLiKaJOpyxvF1dwExfJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01A1E80D0F1;
        Mon, 27 Feb 2023 03:31:32 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33C361731B;
        Mon, 27 Feb 2023 03:31:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 55/68] ceph: add read/modify/write to ceph_sync_write
Date:   Mon, 27 Feb 2023 11:28:00 +0800
Message-Id: <20230227032813.337906-56-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

When doing a synchronous write on an encrypted inode, we have no
guarantee that the caller is writing crypto block-aligned data. When
that happens, we must do a read/modify/write cycle.

First, expand the range to cover complete blocks. If we had to change
the original pos or length, issue a read to fill the first and/or last
pages, and fetch the version of the object from the result.

We then copy data into the pages as usual, encrypt the result and issue
a write prefixed by an assertion that the version hasn't changed. If it has
changed then we restart the whole thing again.

If there is no object at that position in the file (-ENOENT), we prefix
the write on an exclusive create of the object instead.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 316 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 288 insertions(+), 28 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index cc46aa9b8090..e627bc22c754 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1572,18 +1572,16 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_vino vino;
+	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	struct ceph_osd_request *req;
 	struct page **pages;
 	u64 len;
 	int num_pages;
 	int written = 0;
-	int flags;
 	int ret;
 	bool check_caps = false;
 	struct timespec64 mtime = current_time(inode);
 	size_t count = iov_iter_count(from);
-	size_t off;
 
 	if (ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
@@ -1603,29 +1601,234 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 	if (ret < 0)
 		dout("invalidate_inode_pages2_range returned %d\n", ret);
 
-	flags = /* CEPH_OSD_FLAG_ORDERSNAP | */ CEPH_OSD_FLAG_WRITE;
-
 	while ((len = iov_iter_count(from)) > 0) {
 		size_t left;
 		int n;
+		u64 write_pos = pos;
+		u64 write_len = len;
+		u64 objnum, objoff;
+		u32 xlen;
+		u64 assert_ver = 0;
+		bool rmw;
+		bool first, last;
+		struct iov_iter saved_iter = *from;
+		size_t off;
+
+		ceph_fscrypt_adjust_off_and_len(inode, &write_pos, &write_len);
+
+		/* clamp the length to the end of first object */
+		ceph_calc_file_object_mapping(&ci->i_layout, write_pos,
+						write_len, &objnum, &objoff,
+						&xlen);
+		write_len = xlen;
+
+		/* adjust len downward if it goes beyond current object */
+		if (pos + len > write_pos + write_len)
+			len = write_pos + write_len - pos;
 
-		vino = ceph_vino(inode);
-		req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
-					    vino, pos, &len, 0, 1,
-					    CEPH_OSD_OP_WRITE, flags, snapc,
-					    ci->i_truncate_seq,
-					    ci->i_truncate_size,
-					    false);
-		if (IS_ERR(req)) {
-			ret = PTR_ERR(req);
-			break;
-		}
+		/*
+		 * If we had to adjust the length or position to align with a
+		 * crypto block, then we must do a read/modify/write cycle. We
+		 * use a version assertion to redrive the thing if something
+		 * changes in between.
+		 */
+		first = pos != write_pos;
+		last = (pos + len) != (write_pos + write_len);
+		rmw = first || last;
 
-		num_pages = calc_pages_for(pos, len);
+		dout("sync_write ino %llx %lld~%llu adjusted %lld~%llu -- %srmw\n",
+		     ci->i_vino.ino, pos, len, write_pos, write_len, rmw ? "" : "no ");
+
+		/*
+		 * The data is emplaced into the page as it would be if it were in
+		 * an array of pagecache pages.
+		 */
+		num_pages = calc_pages_for(write_pos, write_len);
 		pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
 		if (IS_ERR(pages)) {
 			ret = PTR_ERR(pages);
-			goto out;
+			break;
+		}
+
+		/* Do we need to preload the pages? */
+		if (rmw) {
+			u64 first_pos = write_pos;
+			u64 last_pos = (write_pos + write_len) - CEPH_FSCRYPT_BLOCK_SIZE;
+			u64 read_len = CEPH_FSCRYPT_BLOCK_SIZE;
+			struct ceph_osd_req_op *op;
+
+			/* We should only need to do this for encrypted inodes */
+			WARN_ON_ONCE(!IS_ENCRYPTED(inode));
+
+			/* No need to do two reads if first and last blocks are same */
+			if (first && last_pos == first_pos)
+				last = false;
+
+			/*
+			 * Allocate a read request for one or two extents, depending
+			 * on how the request was aligned.
+			 */
+			req = ceph_osdc_new_request(osdc, &ci->i_layout,
+					ci->i_vino, first ? first_pos : last_pos,
+					&read_len, 0, (first && last) ? 2 : 1,
+					CEPH_OSD_OP_SPARSE_READ, CEPH_OSD_FLAG_READ,
+					NULL, ci->i_truncate_seq,
+					ci->i_truncate_size, false);
+			if (IS_ERR(req)) {
+				ceph_release_page_vector(pages, num_pages);
+				ret = PTR_ERR(req);
+				break;
+			}
+
+			/* Something is misaligned! */
+			if (read_len != CEPH_FSCRYPT_BLOCK_SIZE) {
+				ceph_osdc_put_request(req);
+				ceph_release_page_vector(pages, num_pages);
+				ret = -EIO;
+				break;
+			}
+
+			/* Add extent for first block? */
+			op = &req->r_ops[0];
+
+			if (first) {
+				osd_req_op_extent_osd_data_pages(req, 0, pages,
+							 CEPH_FSCRYPT_BLOCK_SIZE,
+							 offset_in_page(first_pos),
+							 false, false);
+				/* We only expect a single extent here */
+				ret = __ceph_alloc_sparse_ext_map(op, 1);
+				if (ret) {
+					ceph_osdc_put_request(req);
+					ceph_release_page_vector(pages, num_pages);
+					break;
+				}
+			}
+
+			/* Add extent for last block */
+			if (last) {
+				/* Init the other extent if first extent has been used */
+				if (first) {
+					op = &req->r_ops[1];
+					osd_req_op_extent_init(req, 1, CEPH_OSD_OP_SPARSE_READ,
+							last_pos, CEPH_FSCRYPT_BLOCK_SIZE,
+							ci->i_truncate_size,
+							ci->i_truncate_seq);
+				}
+
+				ret = __ceph_alloc_sparse_ext_map(op, 1);
+				if (ret) {
+					ceph_osdc_put_request(req);
+					ceph_release_page_vector(pages, num_pages);
+					break;
+				}
+
+				osd_req_op_extent_osd_data_pages(req, first ? 1 : 0,
+							&pages[num_pages - 1],
+							CEPH_FSCRYPT_BLOCK_SIZE,
+							offset_in_page(last_pos),
+							false, false);
+			}
+
+			ceph_osdc_start_request(osdc, req);
+			ret = ceph_osdc_wait_request(osdc, req);
+
+			/* FIXME: length field is wrong if there are 2 extents */
+			ceph_update_read_metrics(&fsc->mdsc->metric,
+						 req->r_start_latency,
+						 req->r_end_latency,
+						 read_len, ret);
+
+			/* Ok if object is not already present */
+			if (ret == -ENOENT) {
+				/*
+				 * If there is no object, then we can't assert
+				 * on its version. Set it to 0, and we'll use an
+				 * exclusive create instead.
+				 */
+				ceph_osdc_put_request(req);
+				ret = 0;
+
+				/*
+				 * zero out the soon-to-be uncopied parts of the
+				 * first and last pages.
+				 */
+				if (first)
+					zero_user_segment(pages[0], 0,
+							  offset_in_page(first_pos));
+				if (last)
+					zero_user_segment(pages[num_pages - 1],
+							  offset_in_page(last_pos),
+							  PAGE_SIZE);
+			} else {
+				if (ret < 0) {
+					ceph_osdc_put_request(req);
+					ceph_release_page_vector(pages, num_pages);
+					break;
+				}
+
+				op = &req->r_ops[0];
+				if (op->extent.sparse_ext_cnt == 0) {
+					if (first)
+						zero_user_segment(pages[0], 0,
+								  offset_in_page(first_pos));
+					else
+						zero_user_segment(pages[num_pages - 1],
+								  offset_in_page(last_pos),
+								  PAGE_SIZE);
+				} else if (op->extent.sparse_ext_cnt != 1 ||
+					   ceph_sparse_ext_map_end(op) !=
+						CEPH_FSCRYPT_BLOCK_SIZE) {
+					ret = -EIO;
+					ceph_osdc_put_request(req);
+					ceph_release_page_vector(pages, num_pages);
+					break;
+				}
+
+				if (first && last) {
+					op = &req->r_ops[1];
+					if (op->extent.sparse_ext_cnt == 0) {
+						zero_user_segment(pages[num_pages - 1],
+								  offset_in_page(last_pos),
+								  PAGE_SIZE);
+					} else if (op->extent.sparse_ext_cnt != 1 ||
+						   ceph_sparse_ext_map_end(op) !=
+							CEPH_FSCRYPT_BLOCK_SIZE) {
+						ret = -EIO;
+						ceph_osdc_put_request(req);
+						ceph_release_page_vector(pages, num_pages);
+						break;
+					}
+				}
+
+				/* Grab assert version. It must be non-zero. */
+				assert_ver = req->r_version;
+				WARN_ON_ONCE(ret > 0 && assert_ver == 0);
+
+				ceph_osdc_put_request(req);
+				if (first) {
+					ret = ceph_fscrypt_decrypt_block_inplace(inode,
+							pages[0],
+							CEPH_FSCRYPT_BLOCK_SIZE,
+							offset_in_page(first_pos),
+							first_pos >> CEPH_FSCRYPT_BLOCK_SHIFT);
+					if (ret < 0) {
+						ceph_release_page_vector(pages, num_pages);
+						break;
+					}
+				}
+				if (last) {
+					ret = ceph_fscrypt_decrypt_block_inplace(inode,
+							pages[num_pages - 1],
+							CEPH_FSCRYPT_BLOCK_SIZE,
+							offset_in_page(last_pos),
+							last_pos >> CEPH_FSCRYPT_BLOCK_SHIFT);
+					if (ret < 0) {
+						ceph_release_page_vector(pages, num_pages);
+						break;
+					}
+				}
+			}
 		}
 
 		left = len;
@@ -1633,35 +1836,90 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		for (n = 0; n < num_pages; n++) {
 			size_t plen = min_t(size_t, left, PAGE_SIZE - off);
 
+			/* copy the data */
 			ret = copy_page_from_iter(pages[n], off, plen, from);
-			off = 0;
 			if (ret != plen) {
 				ret = -EFAULT;
 				break;
 			}
+			off = 0;
 			left -= ret;
 		}
-
 		if (ret < 0) {
+			dout("sync_write write failed with %d\n", ret);
 			ceph_release_page_vector(pages, num_pages);
-			goto out;
+			break;
 		}
 
-		req->r_inode = inode;
+		if (IS_ENCRYPTED(inode)) {
+			ret = ceph_fscrypt_encrypt_pages(inode, pages,
+							 write_pos, write_len,
+							 GFP_KERNEL);
+			if (ret < 0) {
+				dout("encryption failed with %d\n", ret);
+				ceph_release_page_vector(pages, num_pages);
+				break;
+			}
+		}
 
-		osd_req_op_extent_osd_data_pages(req, 0, pages, len,
-						 offset_in_page(pos),
-						 false, true);
+		req = ceph_osdc_new_request(osdc, &ci->i_layout,
+					    ci->i_vino, write_pos, &write_len,
+					    rmw ? 1 : 0, rmw ? 2 : 1,
+					    CEPH_OSD_OP_WRITE,
+					    CEPH_OSD_FLAG_WRITE,
+					    snapc, ci->i_truncate_seq,
+					    ci->i_truncate_size, false);
+		if (IS_ERR(req)) {
+			ret = PTR_ERR(req);
+			ceph_release_page_vector(pages, num_pages);
+			break;
+		}
 
+		dout("sync_write write op %lld~%llu\n", write_pos, write_len);
+		osd_req_op_extent_osd_data_pages(req, rmw ? 1 : 0, pages, write_len,
+						 offset_in_page(write_pos), false,
+						 true);
+		req->r_inode = inode;
 		req->r_mtime = mtime;
-		ceph_osdc_start_request(&fsc->client->osdc, req);
-		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+
+		/* Set up the assertion */
+		if (rmw) {
+			/*
+			 * Set up the assertion. If we don't have a version number,
+			 * then the object doesn't exist yet. Use an exclusive create
+			 * instead of a version assertion in that case.
+			 */
+			if (assert_ver) {
+				osd_req_op_init(req, 0, CEPH_OSD_OP_ASSERT_VER, 0);
+				req->r_ops[0].assert_ver.ver = assert_ver;
+			} else {
+				osd_req_op_init(req, 0, CEPH_OSD_OP_CREATE,
+						CEPH_OSD_OP_FLAG_EXCL);
+			}
+		}
+
+		ceph_osdc_start_request(osdc, req);
+		ret = ceph_osdc_wait_request(osdc, req);
 
 		ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 					  req->r_end_latency, len, ret);
-out:
 		ceph_osdc_put_request(req);
 		if (ret != 0) {
+			dout("sync_write osd write returned %d\n", ret);
+			/* Version changed! Must re-do the rmw cycle */
+			if ((assert_ver && (ret == -ERANGE || ret == -EOVERFLOW)) ||
+			     (!assert_ver && ret == -EEXIST)) {
+				/* We should only ever see this on a rmw */
+				WARN_ON_ONCE(!rmw);
+
+				/* The version should never go backward */
+				WARN_ON_ONCE(ret == -EOVERFLOW);
+
+				*from = saved_iter;
+
+				/* FIXME: limit number of times we loop? */
+				continue;
+			}
 			ceph_set_error_write(ci);
 			break;
 		}
@@ -1669,6 +1927,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		ceph_clear_error_write(ci);
 		pos += len;
 		written += len;
+		dout("sync_write written %d\n", written);
 		if (pos > i_size_read(inode)) {
 			check_caps = ceph_inode_set_size(inode, pos);
 			if (check_caps)
@@ -1682,6 +1941,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		ret = written;
 		iocb->ki_pos = pos;
 	}
+	dout("sync_write returning %d\n", ret);
 	return ret;
 }
 
-- 
2.31.1

