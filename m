Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE2A51226A
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiD0TUp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiD0TTX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD8C55226
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA684B8294D
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E313C385AA;
        Wed, 27 Apr 2022 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086830;
        bh=rItEWpmSRv/A4aabM++mvrfbxY8VcvJEPV5gWd9Kih4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCt2SF8CsI0D08DOGpYgMR4WfM6v93AOyFnkD/amr1lgYbl/Yu1dRjybPu9eog4FS
         QLMiLZKba5T+qyIE21z8xGnJIVhSvcGV8qX7djU+6Aky9EepK7qCQoaRNDhcgBe+Ag
         pZl9lhzzQlGmdxc1+f0gvBBcIcDhb6PWVnm9NubqBTtRMtooMYe9aukD8pCrbgi8wi
         4ygCjcJDghJe20PTNAV/9VqETFnp/obJOW8nGXyUVWhu+tl0DabmK+0EoHnIElQZ8i
         qLf/r2N0PJ0keNTB2M6Mnn4gp4xlKq4fo7hEuUN3/kz13njTYBPX3NPmOSxm+EJN4Q
         HR0ScDw3ebCoQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 48/64] ceph: add truncate size handling support for fscrypt
Date:   Wed, 27 Apr 2022 15:12:58 -0400
Message-Id: <20220427191314.222867-49-jlayton@kernel.org>
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

From: Xiubo Li <xiubli@redhat.com>

This will transfer the encrypted last block contents to the MDS
along with the truncate request only when the new size is smaller
and not aligned to the fscrypt BLOCK size. When the last block is
located in the file hole, the truncate request will only contain
the header.

The MDS could fail to do the truncate if there has another client
or process has already updated the RADOS object which contains
the last block, and will return -EAGAIN, then the kclient needs
to retry it. The RMW will take around 50ms, and will let it retry
20 times for now.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.h |  21 +++++
 fs/ceph/inode.c  | 198 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h  |   5 ++
 3 files changed, 217 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index b65d8f8b813c..bfda2220cb78 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -26,6 +26,27 @@ struct ceph_fname {
 	bool		no_copy;
 };
 
+/*
+ * Header for the crypted file when truncating the size, this
+ * will be sent to MDS, and the MDS will update the encrypted
+ * last block and then truncate the size.
+ */
+struct ceph_fscrypt_truncate_size_header {
+	__u8  ver;
+	__u8  compat;
+
+	/*
+	 * It will be sizeof(assert_ver + file_offset + block_size)
+	 * if the last block is empty when it's located in a file
+	 * hole. Or the data_len will plus CEPH_FSCRYPT_BLOCK_SIZE.
+	 */
+	__le32 data_len;
+
+	__le64 change_attr;
+	__le64 file_offset;
+	__le32 block_size;
+} __packed;
+
 struct ceph_fscrypt_auth {
 	__le32	cfa_version;
 	__le32	cfa_blob_len;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d606dd7c093b..9936d82193b5 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -595,6 +595,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	ci->i_truncate_seq = 0;
 	ci->i_truncate_size = 0;
 	ci->i_truncate_pending = 0;
+	ci->i_truncate_pagecache_size = 0;
 
 	ci->i_max_size = 0;
 	ci->i_reported_size = 0;
@@ -766,6 +767,10 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 		dout("truncate_size %lld -> %llu\n", ci->i_truncate_size,
 		     truncate_size);
 		ci->i_truncate_size = truncate_size;
+		if (IS_ENCRYPTED(inode))
+			ci->i_truncate_pagecache_size = size;
+		else
+			ci->i_truncate_pagecache_size = truncate_size;
 	}
 	return queue_trunc;
 }
@@ -2139,7 +2144,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	/* there should be no reader or writer */
 	WARN_ON_ONCE(ci->i_rd_ref || ci->i_wr_ref);
 
-	to = ci->i_truncate_size;
+	to = ci->i_truncate_pagecache_size;
 	wrbuffer_refs = ci->i_wrbuffer_ref;
 	dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
 	     ci->i_truncate_pending, to);
@@ -2149,7 +2154,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	truncate_pagecache(inode, to);
 
 	spin_lock(&ci->i_ceph_lock);
-	if (to == ci->i_truncate_size) {
+	if (to == ci->i_truncate_pagecache_size) {
 		ci->i_truncate_pending = 0;
 		finish = 1;
 	}
@@ -2230,6 +2235,142 @@ static const struct inode_operations ceph_encrypted_symlink_iops = {
 	.listxattr = ceph_listxattr,
 };
 
+/*
+ * Transfer the encrypted last block to the MDS and the MDS
+ * will help update it when truncating a smaller size.
+ *
+ * We don't support a PAGE_SIZE that is smaller than the
+ * CEPH_FSCRYPT_BLOCK_SIZE.
+ */
+static int fill_fscrypt_truncate(struct inode *inode,
+				 struct ceph_mds_request *req,
+				 struct iattr *attr)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	int boff = attr->ia_size % CEPH_FSCRYPT_BLOCK_SIZE;
+	loff_t pos, orig_pos = round_down(attr->ia_size, CEPH_FSCRYPT_BLOCK_SIZE);
+	u64 block = orig_pos >> CEPH_FSCRYPT_BLOCK_SHIFT;
+	struct ceph_pagelist *pagelist = NULL;
+	struct kvec iov = {0};
+	struct iov_iter iter;
+	struct page *page = NULL;
+	struct ceph_fscrypt_truncate_size_header header;
+	int retry_op = 0;
+	int len = CEPH_FSCRYPT_BLOCK_SIZE;
+	loff_t i_size = i_size_read(inode);
+	int got, ret, issued;
+	u64 objver;
+
+	ret = __ceph_get_caps(inode, NULL, CEPH_CAP_FILE_RD, 0, -1, &got);
+	if (ret < 0)
+		return ret;
+
+	issued = __ceph_caps_issued(ci, NULL);
+
+	dout("%s size %lld -> %lld got cap refs on %s, issued %s\n", __func__,
+	     i_size, attr->ia_size, ceph_cap_string(got),
+	     ceph_cap_string(issued));
+
+	/* Try to writeback the dirty pagecaches */
+	if (issued & (CEPH_CAP_FILE_BUFFER)) {
+		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;
+		ret = filemap_write_and_wait_range(inode->i_mapping,
+						   orig_pos, lend);
+		if (ret < 0)
+			goto out;
+	}
+
+	page = __page_cache_alloc(GFP_KERNEL);
+	if (page == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
+	if (!pagelist) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	iov.iov_base = kmap_local_page(page);
+	iov.iov_len = len;
+	iov_iter_kvec(&iter, READ, &iov, 1, len);
+
+	pos = orig_pos;
+	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &objver);
+	if (ret < 0)
+		goto out;
+
+	/* Insert the header first */
+	header.ver = 1;
+	header.compat = 1;
+	header.change_attr = cpu_to_le64(inode_peek_iversion_raw(inode));
+
+	/*
+	 * Always set the block_size to CEPH_FSCRYPT_BLOCK_SIZE,
+	 * because in MDS it may need this to do the truncate.
+	 */
+	header.block_size = cpu_to_le32(CEPH_FSCRYPT_BLOCK_SIZE);
+
+	/*
+	 * If we hit a hole here, we should just skip filling
+	 * the fscrypt for the request, because once the fscrypt
+	 * is enabled, the file will be split into many blocks
+	 * with the size of CEPH_FSCRYPT_BLOCK_SIZE, if there
+	 * has a hole, the hole size should be multiple of block
+	 * size.
+	 *
+	 * If the Rados object doesn't exist, it will be set to 0.
+	 */
+	if (!objver) {
+		dout("%s hit hole, ppos %lld < size %lld\n", __func__,
+		     pos, i_size);
+
+		header.data_len = cpu_to_le32(8 + 8 + 4);
+		header.file_offset = 0;
+		ret = 0;
+	} else {
+		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
+		header.file_offset = cpu_to_le64(orig_pos);
+
+		/* truncate and zero out the extra contents for the last block */
+		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
+
+		/* encrypt the last block */
+		ret = ceph_fscrypt_encrypt_block_inplace(inode, page,
+						    CEPH_FSCRYPT_BLOCK_SIZE,
+						    0, block,
+						    GFP_KERNEL);
+		if (ret)
+			goto out;
+	}
+
+	/* Insert the header */
+	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
+	if (ret)
+		goto out;
+
+	if (header.block_size) {
+		/* Append the last block contents to pagelist */
+		ret = ceph_pagelist_append(pagelist, iov.iov_base,
+					   CEPH_FSCRYPT_BLOCK_SIZE);
+		if (ret)
+			goto out;
+	}
+	req->r_pagelist = pagelist;
+out:
+	dout("%s %p size dropping cap refs on %s\n", __func__,
+	     inode, ceph_cap_string(got));
+	ceph_put_cap_refs(ci, got);
+	if (iov.iov_base)
+		kunmap_local(iov.iov_base);
+	if (page)
+		__free_pages(page, 0);
+	if (ret && pagelist)
+		ceph_pagelist_release(pagelist);
+	return ret;
+}
+
 int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -2237,13 +2378,17 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 	struct ceph_mds_request *req;
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_cap_flush *prealloc_cf;
+	loff_t isize = i_size_read(inode);
 	int issued;
 	int release = 0, dirtied = 0;
 	int mask = 0;
 	int err = 0;
 	int inode_dirty_flags = 0;
 	bool lock_snap_rwsem = false;
+	bool fill_fscrypt;
+	int truncate_retry = 20; /* The RMW will take around 50ms */
 
+retry:
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return -ENOMEM;
@@ -2255,6 +2400,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		return PTR_ERR(req);
 	}
 
+	fill_fscrypt = false;
 	spin_lock(&ci->i_ceph_lock);
 	issued = __ceph_caps_issued(ci, NULL);
 
@@ -2376,10 +2522,27 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
+			fill_fscrypt = true;
+		} else if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
 			if (attr->ia_size > isize) {
 				i_size_write(inode, attr->ia_size);
 				inode->i_blocks = calc_inode_blocks(attr->ia_size);
@@ -2402,7 +2565,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 					cpu_to_le64(round_up(isize,
 							     CEPH_FSCRYPT_BLOCK_SIZE));
 				req->r_fscrypt_file = attr->ia_size;
-				/* FIXME: client must zero out any partial blocks! */
 			} else {
 				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
 				req->r_args.setattr.old_size = cpu_to_le64(isize);
@@ -2468,8 +2630,10 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 
 	release &= issued;
 	spin_unlock(&ci->i_ceph_lock);
-	if (lock_snap_rwsem)
+	if (lock_snap_rwsem) {
 		up_read(&mdsc->snap_rwsem);
+		lock_snap_rwsem = false;
+	}
 
 	if (inode_dirty_flags)
 		__mark_inode_dirty(inode, inode_dirty_flags);
@@ -2481,7 +2645,27 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		req->r_args.setattr.mask = cpu_to_le32(mask);
 		req->r_num_caps = 1;
 		req->r_stamp = attr->ia_ctime;
+		if (fill_fscrypt) {
+			err = fill_fscrypt_truncate(inode, req, attr);
+			if (err)
+				goto out;
+		}
+
+		/*
+		 * The truncate request will return -EAGAIN when the
+		 * last block has been updated just before the MDS
+		 * successfully gets the xlock for the FILE lock. To
+		 * avoid corrupting the file contents we need to retry
+		 * it.
+		 */
 		err = ceph_mdsc_do_request(mdsc, NULL, req);
+		if (err == -EAGAIN && truncate_retry--) {
+			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
+			     inode, err, ceph_cap_string(dirtied), mask);
+			ceph_mdsc_put_request(req);
+			ceph_free_cap_flush(prealloc_cf);
+			goto retry;
+		}
 	}
 out:
 	dout("setattr %p result=%d (%s locally, %d remote)\n", inode, err,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d37e0b8aca55..224176e7bb22 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -410,6 +410,11 @@ struct ceph_inode_info {
 	u32 i_truncate_seq;        /* last truncate to smaller size */
 	u64 i_truncate_size;       /*  and the size we last truncated down to */
 	int i_truncate_pending;    /*  still need to call vmtruncate */
+	/*
+	 * For none fscrypt case it equals to i_truncate_size or it will
+	 * equals to fscrypt_file_size
+	 */
+	u64 i_truncate_pagecache_size;
 
 	u64 i_max_size;            /* max file size authorized by mds */
 	u64 i_reported_size; /* (max_)size reported to or requested of mds */
-- 
2.35.1

