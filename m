Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862EC443AF6
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 02:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhKCBZs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Nov 2021 21:25:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231231AbhKCBZr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Nov 2021 21:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635902591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=behughMsahVZFW3uqsPXrCbFS754Vt4IL01OeK8ovUc=;
        b=dT1SUxw4TBM/PCYH6EUijKh/wtrcq41FsE5r/d5Xd8/7F28IgAmlkc0OehvT4h4nksURM7
        Q47zGBsu1G51AdGml3CK2D7Z9MIAR6aDrSSMnM+44UxwER4aEikdIKx3oNgnby32RyDLTn
        hKQWAu767RTSaEIlsW5803sVpa5iMN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-Bn27bhwwNMmrZ9wwGuEg1A-1; Tue, 02 Nov 2021 21:22:59 -0400
X-MC-Unique: Bn27bhwwNMmrZ9wwGuEg1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D35B6824F83;
        Wed,  3 Nov 2021 01:22:58 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B0A2652AC;
        Wed,  3 Nov 2021 01:22:56 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 8/8] ceph: add truncate size handling support for fscrypt
Date:   Wed,  3 Nov 2021 09:22:32 +0800
Message-Id: <20211103012232.14488-9-xiubli@redhat.com>
In-Reply-To: <20211103012232.14488-1-xiubli@redhat.com>
References: <20211103012232.14488-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
or process has already updated the Rados object which contains
the last block, and will return -EAGAIN, then the kclient needs
to retry it. The RMW will take around 50ms, and will let it retry
20 times for now.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c              |  10 +-
 fs/ceph/inode.c             | 198 ++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h             |   8 +-
 include/linux/ceph/crypto.h |  28 +++++
 4 files changed, 230 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/ceph/crypto.h

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4d37e5ea8ab6..5c89d2b42b9e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -871,7 +871,8 @@ enum {
  * only return a short read to the caller if we hit EOF.
  */
 ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-			 struct iov_iter *to, int *retry_op)
+			 struct iov_iter *to, int *retry_op,
+			 u64 *assert_ver)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
@@ -938,6 +939,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 					 req->r_end_latency,
 					 len, ret);
 
+		/* Grab assert version. It must be non-zero. */
+		*assert_ver = req->r_version;
+		WARN_ON_ONCE(assert_ver == 0);
 		ceph_osdc_put_request(req);
 
 		i_size = i_size_read(inode);
@@ -1003,12 +1007,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	u64 assert_ver;
 
 	dout("sync_read on file %p %llu~%u %s\n", file, iocb->ki_pos,
 	     (unsigned)iov_iter_count(to),
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
 
-	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
+	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op,
+				&assert_ver);
 
 }
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 15c2fb1e2c8a..0dffcf60b7f4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -21,6 +21,7 @@
 #include "cache.h"
 #include "crypto.h"
 #include <linux/ceph/decode.h>
+#include <linux/ceph/crypto.h>
 
 /*
  * Ceph inode operations
@@ -586,6 +587,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	ci->i_truncate_seq = 0;
 	ci->i_truncate_size = 0;
 	ci->i_truncate_pending = 0;
+	ci->i_truncate_pagecache_size = 0;
 
 	ci->i_max_size = 0;
 	ci->i_reported_size = 0;
@@ -751,6 +753,10 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 		dout("truncate_size %lld -> %llu\n", ci->i_truncate_size,
 		     truncate_size);
 		ci->i_truncate_size = truncate_size;
+		if (IS_ENCRYPTED(inode))
+			ci->i_truncate_pagecache_size = size;
+		else
+			ci->i_truncate_pagecache_size = truncate_size;
 	}
 
 	if (queue_trunc)
@@ -1026,10 +1032,14 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		pool_ns = old_ns;
 
 		if (IS_ENCRYPTED(inode) && size &&
-		    (iinfo->fscrypt_file_len == sizeof(__le64))) {
-			size = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
-			if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
-				pr_warn("size=%llu fscrypt_file=%llu\n", info->size, size);
+		    (iinfo->fscrypt_file_len >= sizeof(__le64))) {
+			u64 fsize = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
+			if (fsize) {
+				size = fsize;
+				if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
+					pr_warn("size=%llu fscrypt_file=%llu\n",
+						info->size, size);
+			}
 		}
 
 		queue_trunc = ceph_fill_file_size(inode, issued,
@@ -2142,7 +2152,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	/* there should be no reader or writer */
 	WARN_ON_ONCE(ci->i_rd_ref || ci->i_wr_ref);
 
-	to = ci->i_truncate_size;
+	to = ci->i_truncate_pagecache_size;
 	wrbuffer_refs = ci->i_wrbuffer_ref;
 	dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
 	     ci->i_truncate_pending, to);
@@ -2151,7 +2161,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	truncate_pagecache(inode, to);
 
 	spin_lock(&ci->i_ceph_lock);
-	if (to == ci->i_truncate_size) {
+	if (to == ci->i_truncate_pagecache_size) {
 		ci->i_truncate_pending = 0;
 		finish = 1;
 	}
@@ -2232,6 +2242,134 @@ static const struct inode_operations ceph_encrypted_symlink_iops = {
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
+#if 0
+	u64 block = orig_pos >> CEPH_FSCRYPT_BLOCK_SHIFT;
+#endif
+	struct ceph_pagelist *pagelist = NULL;
+	struct kvec iov;
+	struct iov_iter iter;
+	struct page *page = NULL;
+	struct ceph_fscrypt_truncate_size_header header;
+	int retry_op = 0;
+	int len = CEPH_FSCRYPT_BLOCK_SIZE;
+	loff_t i_size = i_size_read(inode);
+	u64 assert_ver = cpu_to_le64(0);
+	int got, ret, issued;
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
+	if (issued & (CEPH_CAP_FILE_BUFFER))
+		filemap_fdatawrite(&inode->i_data);
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
+	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &assert_ver);
+	ceph_put_cap_refs(ci, got);
+
+	/* Insert the header first */
+	header.ver = 1;
+	header.compat = 1;
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
+		dout("%s hit hole, ppos %lld < size %lld\n", __func__,
+		     pos, i_size);
+
+		header.data_len = cpu_to_le32(8 + 8 + 4);
+		header.assert_ver = cpu_to_le64(0);
+		header.file_offset = cpu_to_le64(0);
+		header.block_size = cpu_to_le64(0);
+		ret = 0;
+	} else {
+		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
+		header.assert_ver = assert_ver;
+		header.file_offset = cpu_to_le64(orig_pos);
+		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
+
+		/* truncate and zero out the extra contents for the last block */
+		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
+
+#if 0 // Uncomment this when the fscrypt is enabled globally in kceph
+
+		/* encrypt the last block */
+		ret = fscrypt_encrypt_block_inplace(inode, page,
+						    CEPH_FSCRYPT_BLOCK_SIZE,
+						    0, block,
+						    GFP_KERNEL);
+		if (ret)
+			goto out;
+#endif
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
+	kunmap_local(iov.iov_base);
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
@@ -2239,12 +2377,15 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
 
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
@@ -2257,6 +2398,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		return PTR_ERR(req);
 	}
 
+retry:
+	fill_fscrypt = false;
 	spin_lock(&ci->i_ceph_lock);
 	issued = __ceph_caps_issued(ci, NULL);
 
@@ -2378,10 +2521,27 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
@@ -2404,7 +2564,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 					cpu_to_le64(round_up(isize,
 							     CEPH_FSCRYPT_BLOCK_SIZE));
 				req->r_fscrypt_file = attr->ia_size;
-				/* FIXME: client must zero out any partial blocks! */
 			} else {
 				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
 				req->r_args.setattr.old_size = cpu_to_le64(isize);
@@ -2476,7 +2635,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 	if (inode_dirty_flags)
 		__mark_inode_dirty(inode, inode_dirty_flags);
 
-
 	if (mask) {
 		req->r_inode = inode;
 		ihold(inode);
@@ -2484,7 +2642,25 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
+			goto retry;
+		}
 	}
 out:
 	dout("setattr %p result=%d (%s locally, %d remote)\n", inode, err,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 2362d758af97..030f895900c3 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -408,6 +408,11 @@ struct ceph_inode_info {
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
@@ -1254,7 +1259,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
 extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			    struct file *file, unsigned flags, umode_t mode);
 extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
-				struct iov_iter *to, int *retry_op);
+				struct iov_iter *to, int *retry_op,
+				u64 *assert_ver);
 extern int ceph_release(struct inode *inode, struct file *filp);
 extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 				  char *data, size_t len);
diff --git a/include/linux/ceph/crypto.h b/include/linux/ceph/crypto.h
new file mode 100644
index 000000000000..2b0961902887
--- /dev/null
+++ b/include/linux/ceph/crypto.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _FS_CEPH_CRYPTO_H
+#define _FS_CEPH_CRYPTO_H
+
+#include <linux/types.h>
+
+/*
+ * Header for the crypted file when truncating the size, this
+ * will be sent to MDS, and the MDS will update the encrypted
+ * last block and then truncate the size.
+ */
+struct ceph_fscrypt_truncate_size_header {
+       __u8  ver;
+       __u8  compat;
+
+       /*
+	* It will be sizeof(assert_ver + file_offset + block_size)
+	* if the last block is empty when it's located in a file
+	* hole. Or the data_len will plus CEPH_FSCRYPT_BLOCK_SIZE.
+	*/
+       __le32 data_len;
+
+       __le64 assert_ver;
+       __le64 file_offset;
+       __le32 block_size;
+} __packed;
+
+#endif
-- 
2.27.0

