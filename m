Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF3446434
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhKENjK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 09:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhKENjI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 09:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E71A6112D;
        Fri,  5 Nov 2021 13:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636119388;
        bh=k2mG7OwDFLbY8ccAM+jSoczLL2dTT9banPiuTxSYVhE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ofX25/Wu3fx59XUQUjuVSxAYFIN0I0J6ZnG2D03NT/1idHyq/V9ozCp7SXXM8asHx
         wB7mEBNTCHfsU67i513g1PcrrwiCS21YCsmUY89sxNEZqnjlW7UARea4ximoKPEbl8
         Y0jodzBwOA5wweqm6E1s66a5UQ/P3DK467GgAs+WSPLNcOOjmWV7uQX8qfQwo3TpBv
         StRFJBQjox52BReoDJ9aE2+tijhXOcshQARtOiJ+y3AaRdr1QF7m2/hj3eY033azG7
         ALH9j6NcDdGg3lF8LFUf7l/0yz5oYRwKzjdl66xPhZzk9HChiZ4Fy20u7VVAAjPY3M
         TkvbcF9+UfWUw==
Message-ID: <c066546386941ae41a5e907fa54c0e794d2f4865.camel@kernel.org>
Subject: Re: [PATCH v6 9/9] ceph: add truncate size handling support for
 fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 05 Nov 2021 09:36:26 -0400
In-Reply-To: <20211104055248.190987-10-xiubli@redhat.com>
References: <20211104055248.190987-1-xiubli@redhat.com>
         <20211104055248.190987-10-xiubli@redhat.com>
Content-Type: multipart/mixed; boundary="=-slFkkYVU+wlm/GramZuj"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--=-slFkkYVU+wlm/GramZuj
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

On Thu, 2021-11-04 at 13:52 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will transfer the encrypted last block contents to the MDS
> along with the truncate request only when the new size is smaller
> and not aligned to the fscrypt BLOCK size. When the last block is
> located in the file hole, the truncate request will only contain
> the header.
> 
> The MDS could fail to do the truncate if there has another client
> or process has already updated the Rados object which contains
> the last block, and will return -EAGAIN, then the kclient needs
> to retry it. The RMW will take around 50ms, and will let it retry
> 20 times for now.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c             | 205 ++++++++++++++++++++++++++++++++++--
>  fs/ceph/super.h             |   5 +
>  include/linux/ceph/crypto.h |  28 +++++
>  3 files changed, 227 insertions(+), 11 deletions(-)
>  create mode 100644 include/linux/ceph/crypto.h
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 15c2fb1e2c8a..5817685ea9a5 100644
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
> @@ -586,6 +587,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>  	ci->i_truncate_seq = 0;
>  	ci->i_truncate_size = 0;
>  	ci->i_truncate_pending = 0;
> +	ci->i_truncate_pagecache_size = 0;
>  
>  	ci->i_max_size = 0;
>  	ci->i_reported_size = 0;
> @@ -751,6 +753,10 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>  		dout("truncate_size %lld -> %llu\n", ci->i_truncate_size,
>  		     truncate_size);
>  		ci->i_truncate_size = truncate_size;
> +		if (IS_ENCRYPTED(inode))
> +			ci->i_truncate_pagecache_size = size;
> +		else
> +			ci->i_truncate_pagecache_size = truncate_size;
>  	}
>  
>  	if (queue_trunc)
> @@ -1026,10 +1032,14 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
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
> @@ -2142,7 +2152,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
>  	/* there should be no reader or writer */
>  	WARN_ON_ONCE(ci->i_rd_ref || ci->i_wr_ref);
>  
> -	to = ci->i_truncate_size;
> +	to = ci->i_truncate_pagecache_size;
>  	wrbuffer_refs = ci->i_wrbuffer_ref;
>  	dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
>  	     ci->i_truncate_pending, to);
> @@ -2151,7 +2161,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
>  	truncate_pagecache(inode, to);
>  
>  	spin_lock(&ci->i_ceph_lock);
> -	if (to == ci->i_truncate_size) {
> +	if (to == ci->i_truncate_pagecache_size) {
>  		ci->i_truncate_pending = 0;
>  		finish = 1;
>  	}
> @@ -2232,6 +2242,141 @@ static const struct inode_operations ceph_encrypted_symlink_iops = {
>  	.listxattr = ceph_listxattr,
>  };
>  
> +/*
> + * Transfer the encrypted last block to the MDS and the MDS
> + * will help update it when truncating a smaller size.
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
> +#if 0
> +	u64 block = orig_pos >> CEPH_FSCRYPT_BLOCK_SHIFT;
> +#endif
> +	struct ceph_pagelist *pagelist = NULL;
> +	struct kvec iov;
> +	struct iov_iter iter;
> +	struct page *page = NULL;
> +	struct ceph_fscrypt_truncate_size_header header;
> +	int retry_op = 0;
> +	int len = CEPH_FSCRYPT_BLOCK_SIZE;
> +	loff_t i_size = i_size_read(inode);
> +	struct ceph_object_vers objvers = {0, NULL};
> +	int got, ret, issued;
> +
> +	ret = __ceph_get_caps(inode, NULL, CEPH_CAP_FILE_RD, 0, -1, &got);
> +	if (ret < 0)
> +		return ret;
> +
> +	issued = __ceph_caps_issued(ci, NULL);
> +
> +	dout("%s size %lld -> %lld got cap refs on %s, issued %s\n", __func__,
> +	     i_size, attr->ia_size, ceph_cap_string(got),
> +	     ceph_cap_string(issued));
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
> +	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
> +	if (!pagelist) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	iov.iov_base = kmap_local_page(page);
> +	iov.iov_len = len;
> +	iov_iter_kvec(&iter, READ, &iov, 1, len);
> +
> +	pos = orig_pos;
> +	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &objvers);
> +	ceph_put_cap_refs(ci, got);
> +	if (ret < 0)
> +		goto out;
> +
> +	WARN_ON_ONCE(objvers.count != 1);
> +
> +	/* Insert the header first */
> +	header.ver = 1;
> +	header.compat = 1;
> +
> +	/*
> +	 * If we hit a hole here, we should just skip filling
> +	 * the fscrypt for the request, because once the fscrypt
> +	 * is enabled, the file will be split into many blocks
> +	 * with the size of CEPH_FSCRYPT_BLOCK_SIZE, if there
> +	 * has a hole, the hole size should be multiple of block
> +	 * size.
> +	 *
> +	 * If the Rados object doesn't exist, it will be set 0.
> +	 */
> +	if (!objvers.objvers[0].objver) {
> +		dout("%s hit hole, ppos %lld < size %lld\n", __func__,
> +		     pos, i_size);
> +
> +		header.data_len = cpu_to_le32(8 + 8 + 4);
> +		header.assert_ver = cpu_to_le64(0);
> +		header.file_offset = cpu_to_le64(0);
> +		header.block_size = cpu_to_le64(0);

Note that 0 is a special case, and nothing will complain if you don't
endian-convert it before assigning it.

> +		ret = 0;
> +	} else {
> +		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
> +		header.assert_ver = objvers.objvers[0].objver;
> +		header.file_offset = cpu_to_le64(orig_pos);
> +		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
> +
> +		/* truncate and zero out the extra contents for the last block */
> +		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
> 
> 

sparse throws some warnings here:

  CHECK   fs/ceph/inode.c
fs/ceph/inode.c:1020:32: warning: incorrect type in initializer (different base types)
fs/ceph/inode.c:1020:32:    expected unsigned long long [usertype] size
fs/ceph/inode.c:1020:32:    got restricted __le64 [usertype] size
fs/ceph/inode.c:1039:41: warning: restricted __le64 degrades to integer
fs/ceph/inode.c:1048:41: warning: cast to restricted __le64
fs/ceph/inode.c:2332:35: warning: incorrect type in assignment (different base types)
fs/ceph/inode.c:2332:35:    expected restricted __le32 [assigned] [usertype] block_size
fs/ceph/inode.c:2332:35:    got restricted __le64 [usertype]
fs/ceph/inode.c:2336:35: warning: incorrect type in assignment (different base types)
fs/ceph/inode.c:2336:35:    expected restricted __le64 [assigned] [usertype] assert_ver
fs/ceph/inode.c:2336:35:    got unsigned long long [usertype] objver
fs/ceph/inode.c:2338:35: warning: incorrect type in assignment (different base types)
fs/ceph/inode.c:2338:35:    expected restricted __le32 [assigned] [usertype] block_size
fs/ceph/inode.c:2338:35:    got restricted __le64 [usertype]
fs/ceph/inode.c:2549:45: warning: incorrect type in assignment (different base types)
fs/ceph/inode.c:2549:45:    expected restricted __le64 [usertype] r_fscrypt_file
fs/ceph/inode.c:2549:45:    got long long [usertype] ia_size
fs/ceph/inode.c:2573:53: warning: incorrect type in assignment (different base types)
fs/ceph/inode.c:2573:53:    expected restricted __le64 [usertype] r_fscrypt_file
fs/ceph/inode.c:2573:53:    got long long [usertype] ia_size

I've attached a patch to this email. Can you fold those deltas into the
appropriate patches in your series and resend?

FWIW, esp. when dealing with this sort of endianness-converting code,
it's often a good idea to install sparse and build the kmod with C=1,
which will catch these sorts of warnings.

Here's what I usually use this to build the module:

    $ make -j16 M=fs/ceph W=1 C=1

There are some persistent bogus warnings about lock imbalances that I
sitll need to fix one of these days, but I've just been ignoring those
for now.

> +
> +#if 0 // Uncomment this when the fscrypt is enabled globally in kceph
> +
> +		/* encrypt the last block */
> +		ret = fscrypt_encrypt_block_inplace(inode, page,
> +						    CEPH_FSCRYPT_BLOCK_SIZE,
> +						    0, block,
> +						    GFP_KERNEL);
> +		if (ret)
> +			goto out;
> +#endif
> +	}
> +
> +	/* Insert the header */
> +	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
> +	if (ret)
> +		goto out;
> +
> +	if (header.block_size) {
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
> +	kfree(objvers.objvers);
> +	return ret;
> +}
> +
>  int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> @@ -2239,12 +2384,15 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
> +	int truncate_retry = 20; /* The RMW will take around 50ms */
>  
>  	prealloc_cf = ceph_alloc_cap_flush();
>  	if (!prealloc_cf)
> @@ -2257,6 +2405,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  		return PTR_ERR(req);
>  	}
>  
> +retry:
> +	fill_fscrypt = false;
>  	spin_lock(&ci->i_ceph_lock);
>  	issued = __ceph_caps_issued(ci, NULL);
>  
> @@ -2378,10 +2528,27 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
> @@ -2404,7 +2571,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  					cpu_to_le64(round_up(isize,
>  							     CEPH_FSCRYPT_BLOCK_SIZE));
>  				req->r_fscrypt_file = attr->ia_size;
> -				/* FIXME: client must zero out any partial blocks! */
>  			} else {
>  				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>  				req->r_args.setattr.old_size = cpu_to_le64(isize);
> @@ -2476,7 +2642,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>  	if (inode_dirty_flags)
>  		__mark_inode_dirty(inode, inode_dirty_flags);
>  
> -
>  	if (mask) {
>  		req->r_inode = inode;
>  		ihold(inode);
> @@ -2484,7 +2649,25 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
> +		 * The truncate request will return -EAGAIN when the
> +		 * last block has been updated just before the MDS
> +		 * successfully gets the xlock for the FILE lock. To
> +		 * avoid corrupting the file contents we need to retry
> +		 * it.
> +		 */
>  		err = ceph_mdsc_do_request(mdsc, NULL, req);
> +		if (err == -EAGAIN && truncate_retry--) {
> +			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
> +			     inode, err, ceph_cap_string(dirtied), mask);
> +			goto retry;
> +		}
>  	}
>  out:
>  	dout("setattr %p result=%d (%s locally, %d remote)\n", inode, err,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index b347b12e86a9..071857bb59d8 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -408,6 +408,11 @@ struct ceph_inode_info {
>  	u32 i_truncate_seq;        /* last truncate to smaller size */
>  	u64 i_truncate_size;       /*  and the size we last truncated down to */
>  	int i_truncate_pending;    /*  still need to call vmtruncate */
> +	/*
> +	 * For none fscrypt case it equals to i_truncate_size or it will
> +	 * equals to fscrypt_file_size
> +	 */
> +	u64 i_truncate_pagecache_size;
>  
>  	u64 i_max_size;            /* max file size authorized by mds */
>  	u64 i_reported_size; /* (max_)size reported to or requested of mds */
> diff --git a/include/linux/ceph/crypto.h b/include/linux/ceph/crypto.h
> new file mode 100644
> index 000000000000..2b0961902887
> --- /dev/null
> +++ b/include/linux/ceph/crypto.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _FS_CEPH_CRYPTO_H
> +#define _FS_CEPH_CRYPTO_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * Header for the crypted file when truncating the size, this
> + * will be sent to MDS, and the MDS will update the encrypted
> + * last block and then truncate the size.
> + */
> +struct ceph_fscrypt_truncate_size_header {
> +       __u8  ver;
> +       __u8  compat;
> +
> +       /*
> +	* It will be sizeof(assert_ver + file_offset + block_size)
> +	* if the last block is empty when it's located in a file
> +	* hole. Or the data_len will plus CEPH_FSCRYPT_BLOCK_SIZE.
> +	*/
> +       __le32 data_len;
> +
> +       __le64 assert_ver;
> +       __le64 file_offset;
> +       __le32 block_size;
> +} __packed;
> +
> +#endif

When I said to move this to crypto.h, I meant fs/ceph/crypto.h. Let's
not add a new header file for this. Can you move this definition into
there?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

--=-slFkkYVU+wlm/GramZuj
Content-Disposition: attachment;
	filename*0=0001-SQUASH-fix-some-endianness-issues-noticed-by-sparse.patc;
	filename*1=h
Content-Type: text/x-patch;
	name="0001-SQUASH-fix-some-endianness-issues-noticed-by-sparse.patch";
	charset="ISO-8859-15"
Content-Transfer-Encoding: base64

RnJvbSA2NTFkN2IxNTM5YjRlN2IwMjczZmI1Y2NmOWI4NjVlZjMxZjUwZDYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPgpEYXRl
OiBGcmksIDUgTm92IDIwMjEgMDk6MjQ6MDIgLTA0MDAKU3ViamVjdDogW1BBVENIXSBTUVVBU0g6
IGZpeCBzb21lIGVuZGlhbm5lc3MgaXNzdWVzIG5vdGljZWQgYnkgc3BhcnNlCgpTaWduZWQtb2Zm
LWJ5OiBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPgotLS0KIGZzL2NlcGgvaW5vZGUu
YyAgICAgIHwgMTggKysrKysrKysrLS0tLS0tLS0tCiBmcy9jZXBoL21kc19jbGllbnQuaCB8ICAy
ICstCiAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2ZzL2NlcGgvaW5vZGUuYyBiL2ZzL2NlcGgvaW5vZGUuYwppbmRleCA1ODE3
Njg1ZWE5YTUuLjg2OTMwMDdhNmYyZSAxMDA2NDQKLS0tIGEvZnMvY2VwaC9pbm9kZS5jCisrKyBi
L2ZzL2NlcGgvaW5vZGUuYwpAQCAtMTAxNyw3ICsxMDE3LDcgQEAgaW50IGNlcGhfZmlsbF9pbm9k
ZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgcGFnZSAqbG9ja2VkX3BhZ2UsCiAKIAlpZiAo
bmV3X3ZlcnNpb24gfHwKIAkgICAgKG5ld19pc3N1ZWQgJiAoQ0VQSF9DQVBfQU5ZX0ZJTEVfUkQg
fCBDRVBIX0NBUF9BTllfRklMRV9XUikpKSB7Ci0JCXU2NCBzaXplID0gaW5mby0+c2l6ZTsKKwkJ
dTY0IHNpemUgPSBsZTY0X3RvX2NwdShpbmZvLT5zaXplKTsKIAkJczY0IG9sZF9wb29sID0gY2kt
PmlfbGF5b3V0LnBvb2xfaWQ7CiAJCXN0cnVjdCBjZXBoX3N0cmluZyAqb2xkX25zOwogCkBAIC0x
MDM2LDcgKzEwMzYsOCBAQCBpbnQgY2VwaF9maWxsX2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUs
IHN0cnVjdCBwYWdlICpsb2NrZWRfcGFnZSwKIAkJCXU2NCBmc2l6ZSA9IF9fbGU2NF90b19jcHUo
KihfX2xlNjQgKilpaW5mby0+ZnNjcnlwdF9maWxlKTsKIAkJCWlmIChmc2l6ZSkgewogCQkJCXNp
emUgPSBmc2l6ZTsKLQkJCQlpZiAoaW5mby0+c2l6ZSAhPSByb3VuZF91cChzaXplLCBDRVBIX0ZT
Q1JZUFRfQkxPQ0tfU0laRSkpCisJCQkJaWYgKGxlNjRfdG9fY3B1KGluZm8tPnNpemUpICE9CisJ
CQkJICAgIHJvdW5kX3VwKHNpemUsIENFUEhfRlNDUllQVF9CTE9DS19TSVpFKSkKIAkJCQkJcHJf
d2Fybigic2l6ZT0lbGx1IGZzY3J5cHRfZmlsZT0lbGx1XG4iLAogCQkJCQkJaW5mby0+c2l6ZSwg
c2l6ZSk7CiAJCQl9CkBAIC0xMDQ0LDggKzEwNDUsNyBAQCBpbnQgY2VwaF9maWxsX2lub2RlKHN0
cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBwYWdlICpsb2NrZWRfcGFnZSwKIAogCQlxdWV1ZV90
cnVuYyA9IGNlcGhfZmlsbF9maWxlX3NpemUoaW5vZGUsIGlzc3VlZCwKIAkJCQkJbGUzMl90b19j
cHUoaW5mby0+dHJ1bmNhdGVfc2VxKSwKLQkJCQkJbGU2NF90b19jcHUoaW5mby0+dHJ1bmNhdGVf
c2l6ZSksCi0JCQkJCWxlNjRfdG9fY3B1KHNpemUpKTsKKwkJCQkJbGU2NF90b19jcHUoaW5mby0+
dHJ1bmNhdGVfc2l6ZSksIHNpemUpOwogCQkvKiBvbmx5IHVwZGF0ZSBtYXhfc2l6ZSBvbiBhdXRo
IGNhcCAqLwogCQlpZiAoKGluZm8tPmNhcC5mbGFncyAmIENFUEhfQ0FQX0ZMQUdfQVVUSCkgJiYK
IAkJICAgIGNpLT5pX21heF9zaXplICE9IGxlNjRfdG9fY3B1KGluZm8tPm1heF9zaXplKSkgewpA
QCAtMjMyNywxNSArMjMyNywxNSBAQCBzdGF0aWMgaW50IGZpbGxfZnNjcnlwdF90cnVuY2F0ZShz
dHJ1Y3QgaW5vZGUgKmlub2RlLAogCQkgICAgIHBvcywgaV9zaXplKTsKIAogCQloZWFkZXIuZGF0
YV9sZW4gPSBjcHVfdG9fbGUzMig4ICsgOCArIDQpOwotCQloZWFkZXIuYXNzZXJ0X3ZlciA9IGNw
dV90b19sZTY0KDApOwotCQloZWFkZXIuZmlsZV9vZmZzZXQgPSBjcHVfdG9fbGU2NCgwKTsKLQkJ
aGVhZGVyLmJsb2NrX3NpemUgPSBjcHVfdG9fbGU2NCgwKTsKKwkJaGVhZGVyLmFzc2VydF92ZXIg
PSAwOworCQloZWFkZXIuZmlsZV9vZmZzZXQgPSAwOworCQloZWFkZXIuYmxvY2tfc2l6ZSA9IDA7
CiAJCXJldCA9IDA7CiAJfSBlbHNlIHsKIAkJaGVhZGVyLmRhdGFfbGVuID0gY3B1X3RvX2xlMzIo
OCArIDggKyA0ICsgQ0VQSF9GU0NSWVBUX0JMT0NLX1NJWkUpOwotCQloZWFkZXIuYXNzZXJ0X3Zl
ciA9IG9ianZlcnMub2JqdmVyc1swXS5vYmp2ZXI7CisJCWhlYWRlci5hc3NlcnRfdmVyID0gY3B1
X3RvX2xlNjQob2JqdmVycy5vYmp2ZXJzWzBdLm9ianZlcik7CiAJCWhlYWRlci5maWxlX29mZnNl
dCA9IGNwdV90b19sZTY0KG9yaWdfcG9zKTsKLQkJaGVhZGVyLmJsb2NrX3NpemUgPSBjcHVfdG9f
bGU2NChDRVBIX0ZTQ1JZUFRfQkxPQ0tfU0laRSk7CisJCWhlYWRlci5ibG9ja19zaXplID0gY3B1
X3RvX2xlMzIoQ0VQSF9GU0NSWVBUX0JMT0NLX1NJWkUpOwogCiAJCS8qIHRydW5jYXRlIGFuZCB6
ZXJvIG91dCB0aGUgZXh0cmEgY29udGVudHMgZm9yIHRoZSBsYXN0IGJsb2NrICovCiAJCW1lbXNl
dChpb3YuaW92X2Jhc2UgKyBib2ZmLCAwLCBQQUdFX1NJWkUgLSBib2ZmKTsKZGlmZiAtLWdpdCBh
L2ZzL2NlcGgvbWRzX2NsaWVudC5oIGIvZnMvY2VwaC9tZHNfY2xpZW50LmgKaW5kZXggZDY0ZmYx
YmQyZjVkLi4xNDlhM2E4Mjg0NzIgMTAwNjQ0Ci0tLSBhL2ZzL2NlcGgvbWRzX2NsaWVudC5oCisr
KyBiL2ZzL2NlcGgvbWRzX2NsaWVudC5oCkBAIC0yODQsNyArMjg0LDcgQEAgc3RydWN0IGNlcGhf
bWRzX3JlcXVlc3QgewogCXVuaW9uIGNlcGhfbWRzX3JlcXVlc3RfYXJncyByX2FyZ3M7CiAKIAlz
dHJ1Y3QgY2VwaF9mc2NyeXB0X2F1dGggKnJfZnNjcnlwdF9hdXRoOwotCV9fbGU2NAlyX2ZzY3J5
cHRfZmlsZTsKKwl1NjQJcl9mc2NyeXB0X2ZpbGU7CiAKIAl1OCAqcl9hbHRuYW1lOwkJICAgIC8q
IGZzY3J5cHQgYmluYXJ5IGNyeXB0dGV4dCBmb3IgbG9uZyBmaWxlbmFtZXMgKi8KIAl1MzIgcl9h
bHRuYW1lX2xlbjsJICAgIC8qIGxlbmd0aCBvZiByX2FsdG5hbWUgKi8KLS0gCjIuMzMuMQoK


--=-slFkkYVU+wlm/GramZuj--
