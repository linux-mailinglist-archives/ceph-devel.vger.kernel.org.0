Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB4743E8EE
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 21:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhJ1TUC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 15:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhJ1TUB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 15:20:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0016860F58;
        Thu, 28 Oct 2021 19:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635448654;
        bh=5DtxnPx2F+NAMXzL5CRZfq/SJbXf8/gX5nfRWhZ+sEY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HZY9963Av9uvzOpaDouBJwv3e5OsC54BkPTJcZ1pbyo6jodehlBG+n2zwPNjOV6mK
         SKPcDQsIxQssQneqVzBb1LqHdwEHIDvHXNEzCF8b5Nc3C5GYgDWt1+cDEk9MJ59rEv
         6xzvidMxUIBpT2UKCiPgKNSQtcbmzhXgXTB1QVrvuyW3EF43n1bnnwlSFnNst3eMiy
         yfvjzjbjfpqycIE4F9LL4RxavpqMb38rK/gzAYh5oDdUJ6rgZaba/zNlwcczaf5BtG
         lnUvgflHNqvMznMtTM+I+DBmU29IFfWD7yg4ZcQlMsadN+cMcn5g7owNA3gfPx43rR
         8yuDkzcpwHRCg==
Message-ID: <37ca7a43ec7b9d796d4d8fb962309278c0df7d76.camel@kernel.org>
Subject: Re: [PATCH v3 4/4] ceph: add truncate size handling support for
 fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 28 Oct 2021 15:17:32 -0400
In-Reply-To: <20211028091438.21402-5-xiubli@redhat.com>
References: <20211028091438.21402-1-xiubli@redhat.com>
         <20211028091438.21402-5-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-10-28 at 17:14 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will transfer the encrypted last block contents to the MDS
> along with the truncate request only when new size is smaller and
> not aligned to the fscrypt BLOCK size.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c              |   2 -
>  fs/ceph/file.c              |  10 +-
>  fs/ceph/inode.c             | 182 ++++++++++++++++++++++++++++++++++--
>  fs/ceph/super.h             |   3 +-
>  include/linux/ceph/crypto.h |  23 +++++
>  5 files changed, 206 insertions(+), 14 deletions(-)
>  create mode 100644 include/linux/ceph/crypto.h
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 4e2a588465c5..c9624b059eb0 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1299,8 +1299,6 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
>  	 * fscrypt_auth holds the crypto context (if any). fscrypt_file
>  	 * tracks the real i_size as an __le64 field (and we use a rounded-up
>  	 * i_size in * the traditional size field).
> -	 *
> -	 * FIXME: should we encrypt fscrypt_file field?
>  	 */
>  	ceph_encode_32(&p, arg->fscrypt_auth_len);
>  	ceph_encode_copy(&p, arg->fscrypt_auth, arg->fscrypt_auth_len);
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 1988e75ad4a2..2a780e0133df 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -902,7 +902,8 @@ static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64
>   * only return a short read to the caller if we hit EOF.
>   */
>  ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> -			 struct iov_iter *to, int *retry_op)
> +			 struct iov_iter *to, int *retry_op,
> +			 u64 *assert_ver)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> @@ -978,6 +979,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>  					 req->r_end_latency,
>  					 len, ret);
>  
> +		/* Grab assert version. It must be non-zero. */
> +		*assert_ver = req->r_version;
> +		WARN_ON_ONCE(assert_ver == 0);
>  		ceph_osdc_put_request(req);
>  
>  		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
> @@ -1074,12 +1078,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  {
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file_inode(file);
> +	u64 assert_ver;
>  
>  	dout("sync_read on file %p %llu~%u %s\n", file, iocb->ki_pos,
>  	     (unsigned)iov_iter_count(to),
>  	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>  
> -	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
> +	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op,
> +				&assert_ver);
>  
>  }
>  
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 9b798690fdc9..abb634866897 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -21,6 +21,7 @@
>  #include "cache.h"
>  #include "crypto.h"
>  #include <linux/ceph/decode.h>
> +#include <linux/ceph/crypto.h>
>  
>  /*
>   * Ceph inode operations
> @@ -1034,10 +1035,14 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>  		pool_ns = old_ns;
>  
>  		if (IS_ENCRYPTED(inode) && size &&
> -		    (iinfo->fscrypt_file_len == sizeof(__le64))) {
> -			size = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
> -			if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
> -				pr_warn("size=%llu fscrypt_file=%llu\n", info->size, size);
> +		    (iinfo->fscrypt_file_len >= sizeof(__le64))) {
> +			u64 fsize = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
> +			if (fsize) {
> +				size = fsize;
> +				if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
> +					pr_warn("size=%llu fscrypt_file=%llu\n",
> +						info->size, size);
> +			}
>  		}
>  
>  		queue_trunc = ceph_fill_file_size(inode, issued,
> @@ -2229,6 +2234,130 @@ static const struct inode_operations ceph_encrypted_symlink_iops = {
>  	.listxattr = ceph_listxattr,
>  };
>  
> +/*
> + * Transfer the encrypted last block to the MDS and the MDS
> + * will update the file when truncating a smaller size.
> + *
> + * We don't support a PAGE_SIZE that is smaller than the
> + * CEPH_FSCRYPT_BLOCK_SIZE.
> + */
> +static int fill_fscrypt_truncate(struct inode *inode,
> +				 struct ceph_mds_request *req,
> +				 struct iattr *attr)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	int boff = attr->ia_size % CEPH_FSCRYPT_BLOCK_SIZE;
> +	loff_t pos, orig_pos = round_down(attr->ia_size, CEPH_FSCRYPT_BLOCK_SIZE);
> +	u64 block = orig_pos >> CEPH_FSCRYPT_BLOCK_SHIFT;
> +	struct ceph_pagelist *pagelist = NULL;
> +	struct kvec iov;
> +	struct iov_iter iter;
> +	struct page *page = NULL;
> +	struct ceph_fscrypt_truncate_size_header header;
> +	int retry_op = 0;
> +	int len = CEPH_FSCRYPT_BLOCK_SIZE;
> +	loff_t i_size = i_size_read(inode);
> +	bool fill_header_only = false;
> +	u64 assert_ver = cpu_to_le64(0);
> +	int got, ret, issued;
> +
> +	ret = __ceph_get_caps(inode, NULL, CEPH_CAP_FILE_RD, 0, -1, &got);
> +	if (ret < 0)
> +		return ret;
> +
> +	dout("%s size %lld -> %lld got cap refs on %s\n", __func__,
> +	     i_size, attr->ia_size, ceph_cap_string(got));
> +
> +	issued = __ceph_caps_issued(ci, NULL);
> +
> +	/* Try to writeback the dirty pagecaches */
> +	if (issued & (CEPH_CAP_FILE_BUFFER))
> +		filemap_fdatawrite(&inode->i_data);
> +
> +	page = __page_cache_alloc(GFP_KERNEL);
> +	if (page == NULL) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	iov.iov_base = kmap_local_page(page);
> +	iov.iov_len = len;
> +	iov_iter_kvec(&iter, READ, &iov, 1, len);
> +
> +	pos = orig_pos;
> +	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &assert_ver);
> +
> +	/*
> +	 * If we hit a hole here, we should just skip filling
> +	 * the fscrypt for the request, because once the fscrypt
> +	 * is enabled, the file will be split into many blocks
> +	 * with the size of CEPH_FSCRYPT_BLOCK_SIZE, if there
> +	 * has a hole, the hole size should be multiple of block
> +	 * size.
> +	 */
> +	if (pos < i_size && ret < len) {
> +		dout("%s hit hole, ppos %lld < size %lld\n",
> +		     __func__, pos, i_size);
> +
> +		ret = 0;
> +		fill_header_only = true;
> +		goto fill_last_block;
> +	}
> 
> 
You can drop the goto above if you just put everything between here and
fill_last_block into an else block.

> +
> +	/* truncate and zero out the extra contents for the last block */
> +	memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
> +
> +	/* encrypt the last block */
> +	ret = fscrypt_encrypt_block_inplace(inode, page,
> +					    CEPH_FSCRYPT_BLOCK_SIZE,
> +					    0, block,
> +					    GFP_KERNEL);
> +	if (ret)
> +		goto out;
> 
> 

Careful with the above. We don't _really_ want to run the encryption
just yet, until we're ready to turn on content encryption everywhere.
Might want to #ifdef 0 that out for now.

> +
> +fill_last_block:
> +	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
> +	if (!pagelist)
> +		return -ENOMEM;
> +
> +	/* Insert the header first */
> +	header.ver = 1;
> +	header.compat = 1;
> +	if (fill_header_only) {
> +		header.data_len = cpu_to_le32(8 + 8 + 4);
> +		header.assert_ver = cpu_to_le64(0);
> +		header.file_offset = cpu_to_le64(0);
> +		header.block_size = cpu_to_le64(0);
> +	} else {
> +		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
> +		header.assert_ver = assert_ver;
> +		header.file_offset = cpu_to_le64(orig_pos);
> +		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
> +	}
> +	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
> +	if (ret)
> +		goto out;
> +
> +	if (!fill_header_only) {
> +		/* Append the last block contents to pagelist */
> +		ret = ceph_pagelist_append(pagelist, iov.iov_base,
> +					   CEPH_FSCRYPT_BLOCK_SIZE);
> +		if (ret)
> +			goto out;
> +	}
> +	req->r_pagelist = pagelist;
> +out:
> +	dout("%s %p size dropping cap refs on %s\n", __func__,
> +	     inode, ceph_cap_string(got));
> +	kunmap_local(iov.iov_base);
> +	if (page)
> +		__free_pages(page, 0);
> +	if (ret && pagelist)
> +		ceph_pagelist_release(pagelist);
> +	ceph_put_cap_refs(ci, got);
> +	return ret;
> +}
> +
>  int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> @@ -2236,12 +2365,14 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  	struct ceph_mds_request *req;
>  	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>  	struct ceph_cap_flush *prealloc_cf;
> +	loff_t isize = i_size_read(inode);
>  	int issued;
>  	int release = 0, dirtied = 0;
>  	int mask = 0;
>  	int err = 0;
>  	int inode_dirty_flags = 0;
>  	bool lock_snap_rwsem = false;
> +	bool fill_fscrypt;
>  
>  	prealloc_cf = ceph_alloc_cap_flush();
>  	if (!prealloc_cf)
> @@ -2254,6 +2385,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  		return PTR_ERR(req);
>  	}
>  
> +retry:
> +	fill_fscrypt = false;
>  	spin_lock(&ci->i_ceph_lock);
>  	issued = __ceph_caps_issued(ci, NULL);
>  
> @@ -2367,10 +2500,27 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  		}
>  	}
>  	if (ia_valid & ATTR_SIZE) {
> -		loff_t isize = i_size_read(inode);
> -
>  		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
> -		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
> +		/*
> +		 * Only when the new size is smaller and not aligned to
> +		 * CEPH_FSCRYPT_BLOCK_SIZE will the RMW is needed.
> +		 */
> +		if (IS_ENCRYPTED(inode) && attr->ia_size < isize &&
> +		    (attr->ia_size % CEPH_FSCRYPT_BLOCK_SIZE)) {
> +			mask |= CEPH_SETATTR_SIZE;
> +			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
> +				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
> +			set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +			mask |= CEPH_SETATTR_FSCRYPT_FILE;
> +			req->r_args.setattr.size =
> +				cpu_to_le64(round_up(attr->ia_size,
> +						     CEPH_FSCRYPT_BLOCK_SIZE));
> +			req->r_args.setattr.old_size =
> +				cpu_to_le64(round_up(isize,
> +						     CEPH_FSCRYPT_BLOCK_SIZE));
> +			req->r_fscrypt_file = attr->ia_size;
> +			fill_fscrypt = true;
> +		} else if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
>  			if (attr->ia_size > isize) {
>  				i_size_write(inode, attr->ia_size);
>  				inode->i_blocks = calc_inode_blocks(attr->ia_size);
> @@ -2393,7 +2543,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  					cpu_to_le64(round_up(isize,
>  							     CEPH_FSCRYPT_BLOCK_SIZE));
>  				req->r_fscrypt_file = attr->ia_size;
> -				/* FIXME: client must zero out any partial blocks! */
>  			} else {
>  				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>  				req->r_args.setattr.old_size = cpu_to_le64(isize);
> @@ -2465,7 +2614,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  	if (inode_dirty_flags)
>  		__mark_inode_dirty(inode, inode_dirty_flags);
>  
> -
>  	if (mask) {
>  		req->r_inode = inode;
>  		ihold(inode);
> @@ -2473,7 +2621,23 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  		req->r_args.setattr.mask = cpu_to_le32(mask);
>  		req->r_num_caps = 1;
>  		req->r_stamp = attr->ia_ctime;
> +		if (fill_fscrypt) {
> +			err = fill_fscrypt_truncate(inode, req, attr);
> +			if (err)
> +				goto out;
> +		}
> +
> +		/*
> +		 * The truncate will return -EAGAIN when some one
> +		 * has updated the last block before the MDS hold
> +		 * the xlock for the FILE lock. Need to retry it.
> +		 */
>  		err = ceph_mdsc_do_request(mdsc, NULL, req);
> +		if (err == -EAGAIN) {
> +			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
> +			     inode, err, ceph_cap_string(dirtied), mask);
> +			goto retry;
> +		}

The rest looks reasonable. We may want to cap the number of retries in
case something goes really wrong or in the case of a livelock with a
competing client. I'm not sure what a reasonable number of tries would
be though -- 5? 10? 100? We may want to benchmark out how long this rmw
operation takes and then we can use that to determine a reasonable
number of tries.

If you run out of tries, you could probably  just return -EAGAIN in that
case. That's not listed in the truncate(2) manpage, but it seems like a
reasonable way to handle that sort of problem.

>  	}
>  out:
>  	dout("setattr %p result=%d (%s locally, %d remote)\n", inode, err,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 57bc952c54e1..c8144273ff28 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1236,7 +1236,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
>  extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  			    struct file *file, unsigned flags, umode_t mode);
>  extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
> -				struct iov_iter *to, int *retry_op);
> +				struct iov_iter *to, int *retry_op,
> +				u64 *assert_ver);
>  extern int ceph_release(struct inode *inode, struct file *filp);
>  extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>  				  char *data, size_t len);
> diff --git a/include/linux/ceph/crypto.h b/include/linux/ceph/crypto.h
> new file mode 100644
> index 000000000000..e0f799d4d4ee
> --- /dev/null
> +++ b/include/linux/ceph/crypto.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _FS_CEPH_CRYPTO_H
> +#define _FS_CEPH_CRYPTO_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * Header for the crypted file when truncating the size, this
> + * will be sent to MDS, and MDS will do the encrypted last
> + * block's update and size truncating.
> + */
> +struct ceph_fscrypt_truncate_size_header {
> +       __u8  ver;
> +       __u8  compat;
> +       /* length of sizeof(assert_ver + file_offset + block_size + CEPH_FSCRYPT_BLOCK_SIZE) */
> +       __le32 data_len;
> +
> +       __le64 assert_ver;
> +       __le64 file_offset;
> +       __le32 block_size;
> +} __packed;
> +
> +#endif

-- 
Jeff Layton <jlayton@kernel.org>

