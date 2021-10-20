Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D13434C12
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 15:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhJTNa6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 09:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230017AbhJTNa5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 09:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634736522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z5kqTX6yX49N3ZOBXU8aLJ5y7pB8bHPB8pTUt5g3L40=;
        b=fYJor4tdtul0QfPzDbzVNQKd/AThHWB/k73Wjdc8GEBs5LTK2DGFGLGmfpB4BsK0wtbf5b
        wDyVpVjS37JZJ8BgJC/mf35lIi3sfHkyt6NR8CLMnsO4+ugQNgwXH1c8CJn1mXmMLhLdbT
        p15ykkF7v7g7aBQHqJW6tJ6AV/hKELU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-hKNpR4Y9MCKEHpFxN4biUA-1; Wed, 20 Oct 2021 09:28:41 -0400
X-MC-Unique: hKNpR4Y9MCKEHpFxN4biUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5F6010144FF;
        Wed, 20 Oct 2021 13:28:39 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86DE51042AAF;
        Wed, 20 Oct 2021 13:28:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 4/4] ceph: add truncate size handling support for fscrypt
Date:   Wed, 20 Oct 2021 21:28:13 +0800
Message-Id: <20211020132813.543695-5-xiubli@redhat.com>
In-Reply-To: <20211020132813.543695-1-xiubli@redhat.com>
References: <20211020132813.543695-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will transfer the encrypted last block contents to the MDS
along with the truncate request only when new size is smaller and
not aligned to the fscrypt BLOCK size.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  |   9 +--
 fs/ceph/inode.c | 210 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 190 insertions(+), 29 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 4e2a588465c5..1a36f0870d89 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1296,16 +1296,13 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
 	/*
 	 * fscrypt_auth and fscrypt_file (version 12)
 	 *
-	 * fscrypt_auth holds the crypto context (if any). fscrypt_file
-	 * tracks the real i_size as an __le64 field (and we use a rounded-up
-	 * i_size in * the traditional size field).
-	 *
-	 * FIXME: should we encrypt fscrypt_file field?
+	 * fscrypt_auth holds the crypto context (if any). fscrypt_file will
+	 * always be zero here.
 	 */
 	ceph_encode_32(&p, arg->fscrypt_auth_len);
 	ceph_encode_copy(&p, arg->fscrypt_auth, arg->fscrypt_auth_len);
 	ceph_encode_32(&p, sizeof(__le64));
-	ceph_encode_64(&p, arg->size);
+	ceph_encode_64(&p, 0);
 }
 
 /*
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9b798690fdc9..924a69bc074d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1035,9 +1035,13 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 		if (IS_ENCRYPTED(inode) && size &&
 		    (iinfo->fscrypt_file_len == sizeof(__le64))) {
-			size = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
-			if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
-				pr_warn("size=%llu fscrypt_file=%llu\n", info->size, size);
+			u64 fsize = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
+			if (fsize) {
+				size = fsize;
+				if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
+					pr_warn("size=%llu fscrypt_file=%llu\n",
+						info->size, size);
+			}
 		}
 
 		queue_trunc = ceph_fill_file_size(inode, issued,
@@ -2229,6 +2233,157 @@ static const struct inode_operations ceph_encrypted_symlink_iops = {
 	.listxattr = ceph_listxattr,
 };
 
+struct ceph_fscrypt_header {
+	__u8  ver;
+	__u8  compat;
+	__le32 data_len; /* length of sizeof(file_offset + block_size + BLOCK SIZE) */
+	__le64 file_offset;
+	__le64 block_size;
+} __packed;
+
+/*
+ * Transfer the encrypted last block to the MDS and the MDS
+ * will update the file when truncating a smaller size.
+ */
+static int fill_request_for_fscrypt(struct inode *inode,
+				    struct ceph_mds_request *req,
+				    struct iattr *attr)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	int boff = attr->ia_size % CEPH_FSCRYPT_BLOCK_SIZE;
+	loff_t pos, orig_pos = round_down(attr->ia_size, CEPH_FSCRYPT_BLOCK_SIZE);
+	size_t blen = min_t(size_t, CEPH_FSCRYPT_BLOCK_SIZE, PAGE_SIZE);
+	struct ceph_pagelist *pagelist = NULL;
+	struct kvec *iovs = NULL;
+	struct iov_iter iter;
+	struct page **pages = NULL;
+	struct ceph_fscrypt_header header;
+	int num_pages = 0;
+	int retry_op = 0;
+	int iov_off, iov_idx, len = 0;
+	loff_t i_size = i_size_read(inode);
+	bool fill_header_only = false;
+	int ret, i;
+	int got;
+
+	/*
+	 * Do not support the inline data case, which will be
+	 * removed soon
+	 */
+	if (ci->i_inline_version != CEPH_INLINE_NONE)
+		return -EINVAL;
+
+	ret = __ceph_get_caps(inode, NULL, CEPH_CAP_FILE_RD, 0, -1, &got);
+	if (ret < 0)
+		return ret;
+
+	dout("%s size %lld -> %lld got cap refs on %s\n", __func__,
+	     i_size, attr->ia_size, ceph_cap_string(got));
+
+	/* Should we consider the tiny page in 1K case ? */
+	num_pages = (CEPH_FSCRYPT_BLOCK_SIZE + PAGE_SIZE -1) / PAGE_SIZE;
+	pages = ceph_alloc_page_vector(num_pages, GFP_NOFS);
+	if (IS_ERR(pages)) {
+		ret = PTR_ERR(pages);
+		goto out;
+	}
+
+	iovs = kcalloc(num_pages, sizeof(struct kvec), GFP_NOFS);
+	if (!iovs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (i = 0; i < num_pages; i++) {
+		iovs[i].iov_base = kmap_local_page(pages[i]);
+		iovs[i].iov_len = PAGE_SIZE;
+		len += iovs[i].iov_len;
+	}
+	iov_iter_kvec(&iter, READ, iovs, num_pages, len);
+
+	pos = orig_pos;
+	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op);
+
+	/*
+	 * If we hit a hole here, we should just skip filling
+	 * the fscrypt for the request, because once the fscrypt
+	 * is enabled, the file will be split into many blocks
+	 * with the size of CEPH_FSCRYPT_BLOCK_SIZE, if there
+	 * has a hole, the hole size should be multiple of block
+	 * size.
+	 */
+	if (pos < i_size && ret < len) {
+		dout("%s hit hole, ppos %lld < size %lld\n",
+		     __func__, pos, i_size);
+
+		ret = 0;
+		fill_header_only = true;
+		goto fill_last_block;
+	}
+
+	/* truncate and zero out the extra contents for the last block */
+	iov_idx = boff / PAGE_SIZE;
+	iov_off = boff % PAGE_SIZE;
+	memset(iovs[iov_idx].iov_base + iov_off, 0, PAGE_SIZE - iov_off);
+
+	/* encrypt the last block */
+	for (i = 0; i < num_pages; i++) {
+		u32 shift = CEPH_FSCRYPT_BLOCK_SIZE > PAGE_SIZE ?
+			    PAGE_SHIFT : CEPH_FSCRYPT_BLOCK_SHIFT;
+		u64 block = orig_pos >> shift;
+
+		ret = fscrypt_encrypt_block_inplace(inode, pages[i],
+						    blen, 0, block,
+						    GFP_KERNEL);
+		if (ret)
+			goto out;
+	}
+
+fill_last_block:
+	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
+	if (!pagelist)
+		return -ENOMEM;
+
+	/* Insert the header first */
+	header.ver = 1;
+	header.compat = 1;
+	/* sizeof(file_offset) + sizeof(block_size) + blen */
+	header.data_len = cpu_to_le32(8 + 8 + CEPH_FSCRYPT_BLOCK_SIZE);
+	header.file_offset = cpu_to_le64(orig_pos);
+	if (fill_header_only) {
+		header.file_offset = cpu_to_le64(0);
+		header.block_size = cpu_to_le64(0);
+	} else {
+		header.file_offset = cpu_to_le64(orig_pos);
+		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
+	}
+	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
+	if (ret)
+		goto out;
+
+	if (!fill_header_only) {
+		/* Append the last block contents to pagelist */
+		for (i = 0; i < num_pages; i++) {
+			ret = ceph_pagelist_append(pagelist, iovs[i].iov_base,
+						   blen);
+			if (ret)
+				goto out;
+		}
+	}
+	req->r_pagelist = pagelist;
+out:
+	dout("%s %p size dropping cap refs on %s\n", __func__,
+	     inode, ceph_cap_string(got));
+	for (i = 0; iovs && i < num_pages; i++)
+		kunmap_local(iovs[i].iov_base);
+	kfree(iovs);
+	if (pages)
+		ceph_release_page_vector(pages, num_pages);
+	if (ret && pagelist)
+		ceph_pagelist_release(pagelist);
+	ceph_put_cap_refs(ci, got);
+	return ret;
+}
+
 int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -2236,6 +2391,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 	struct ceph_mds_request *req;
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_cap_flush *prealloc_cf;
+	loff_t isize = i_size_read(inode);
 	int issued;
 	int release = 0, dirtied = 0;
 	int mask = 0;
@@ -2367,10 +2523,31 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		}
 	}
 	if (ia_valid & ATTR_SIZE) {
-		loff_t isize = i_size_read(inode);
-
 		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
-		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
+		/*
+		 * Only when the new size is smaller and not aligned to
+		 * CEPH_FSCRYPT_BLOCK_SIZE will the RMW is needed.
+		 */
+		if (IS_ENCRYPTED(inode) && attr->ia_size < isize &&
+		    (attr->ia_size % CEPH_FSCRYPT_BLOCK_SIZE)) {
+			mask |= CEPH_SETATTR_SIZE;
+			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
+				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
+			set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
+			mask |= CEPH_SETATTR_FSCRYPT_FILE;
+			req->r_args.setattr.size =
+				cpu_to_le64(round_up(attr->ia_size,
+						     CEPH_FSCRYPT_BLOCK_SIZE));
+			req->r_args.setattr.old_size =
+				cpu_to_le64(round_up(isize,
+						     CEPH_FSCRYPT_BLOCK_SIZE));
+			req->r_fscrypt_file = attr->ia_size;
+			spin_unlock(&ci->i_ceph_lock);
+			err = fill_request_for_fscrypt(inode, req, attr);
+			spin_lock(&ci->i_ceph_lock);
+			if (err)
+				goto out;
+		} else if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
 			if (attr->ia_size > isize) {
 				i_size_write(inode, attr->ia_size);
 				inode->i_blocks = calc_inode_blocks(attr->ia_size);
@@ -2382,23 +2559,10 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 			   attr->ia_size != isize) {
 			mask |= CEPH_SETATTR_SIZE;
 			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
-				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
-			if (IS_ENCRYPTED(inode)) {
-				set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
-				mask |= CEPH_SETATTR_FSCRYPT_FILE;
-				req->r_args.setattr.size =
-					cpu_to_le64(round_up(attr->ia_size,
-							     CEPH_FSCRYPT_BLOCK_SIZE));
-				req->r_args.setattr.old_size =
-					cpu_to_le64(round_up(isize,
-							     CEPH_FSCRYPT_BLOCK_SIZE));
-				req->r_fscrypt_file = attr->ia_size;
-				/* FIXME: client must zero out any partial blocks! */
-			} else {
-				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
-				req->r_args.setattr.old_size = cpu_to_le64(isize);
-				req->r_fscrypt_file = 0;
-			}
+			           CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
+			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
+			req->r_args.setattr.old_size = cpu_to_le64(isize);
+			req->r_fscrypt_file = 0;
 		}
 	}
 	if (ia_valid & ATTR_MTIME) {
-- 
2.27.0

