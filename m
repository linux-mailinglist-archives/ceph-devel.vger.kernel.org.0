Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8B9447F11
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 12:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhKHLpO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 06:45:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239303AbhKHLpN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 06:45:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636371749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tIfkfSRXJsMvwVYRQzoY1Y1abk8v0mm6do2zZDEY2Mw=;
        b=EUU2LkCpSJBZqPoAybOMUcfPQjx78r7jzWDmbqELrgYS+nCWzx1FqLXWlEW6NnCUBEn1fR
        1Grkp057A4ahWcCJczf+wyIm/vyFIPkRkOb/Uh5//seUcsM02T9ddrQkaDSZc8+1wUpzAe
        W0mzIJx5Yx5ivah02JLngEV5x+GmPXA=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-vXOkXUQFNamOh4IuBwvgGA-1; Mon, 08 Nov 2021 06:42:28 -0500
X-MC-Unique: vXOkXUQFNamOh4IuBwvgGA-1
Received: by mail-pg1-f197.google.com with SMTP id x14-20020a63cc0e000000b002a5bc462947so9879523pgf.20
        for <ceph-devel@vger.kernel.org>; Mon, 08 Nov 2021 03:42:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tIfkfSRXJsMvwVYRQzoY1Y1abk8v0mm6do2zZDEY2Mw=;
        b=T7wgPAmOJ94jxgPf1MS21d14zXJrODv9pjrfud92na89Lm1WWuLf+WAdBQIGn9lABv
         lxFd8gwjjuw8yGUNuYuQtwIoX504xA6mLcgHMYxhdfaLpNYnA+ymVKw1ADBnZQNe1p6V
         sv2dli3olJ+VqPY9hB3AdhdHcekKm/mofscB03HgfOSlsOsZXbNPxnNLrBp3jRoWwLUq
         YR6XL0NtmLw10KGxdt4eI5SXv3/ULry5QHvKdWgszDV7FPHgLmb73/dFIV9QBqChXsnW
         /VOYZl0D9KmgPczGSVO/1UkGkgJzP3UGO46zI/CEox29tyOsgpGsXS2pwrJW5DMydTqI
         CY8Q==
X-Gm-Message-State: AOAM533IgS11hl9Ehvyu9JgUwowBSN+9QFwb6f1W+IwiTzdXjJU/X3q6
        a3bPTcTpSpObwRa2apva7cUajCBQCYImK6Vc9DXwZXLywLWFZNmWX9wXUWo08qhhqejWn+SWTyb
        jyjXHFNa6sWE9gA7DJjAMOpvRtXE1K4BwbOgrL/jsNuf74Vez74xzQX0PLOH6uDUdQBQiDn0=
X-Received: by 2002:a17:903:1111:b0:13f:d1d7:fb67 with SMTP id n17-20020a170903111100b0013fd1d7fb67mr68856800plh.85.1636371746639;
        Mon, 08 Nov 2021 03:42:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyJLoBJfMHYLgZEA9RMOmQqvRcAEe7/mBvqx8WjXqn4hEVANw6cYLQFj/BGsv4gFiJgI06kg==
X-Received: by 2002:a17:903:1111:b0:13f:d1d7:fb67 with SMTP id n17-20020a170903111100b0013fd1d7fb67mr68856756plh.85.1636371746113;
        Mon, 08 Nov 2021 03:42:26 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p7sm12178688pgn.52.2021.11.08.03.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:42:25 -0800 (PST)
Subject: Re: [PATCH v7 9/9] ceph: add truncate size handling support for
 fscrypt
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211105142215.345566-1-xiubli@redhat.com>
 <20211105142215.345566-10-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <59a4720b-5e3f-4319-85c7-b2f62479854e@redhat.com>
Date:   Mon, 8 Nov 2021 19:42:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211105142215.345566-10-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/5/21 10:22 PM, xiubli@redhat.com wrote:
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
>   fs/ceph/crypto.h |  21 +++++
>   fs/ceph/inode.c  | 210 +++++++++++++++++++++++++++++++++++++++++++----
>   fs/ceph/super.h  |   5 ++
>   3 files changed, 222 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index ab27a7ed62c3..393c308e8fc2 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -25,6 +25,27 @@ struct ceph_fname {
>   	u32		ctext_len;	// length of crypttext
>   };
>   
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
>   struct ceph_fscrypt_auth {
>   	__le32	cfa_version;
>   	__le32	cfa_blob_len;
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 15c2fb1e2c8a..eebbd0296004 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -586,6 +586,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>   	ci->i_truncate_seq = 0;
>   	ci->i_truncate_size = 0;
>   	ci->i_truncate_pending = 0;
> +	ci->i_truncate_pagecache_size = 0;
>   
>   	ci->i_max_size = 0;
>   	ci->i_reported_size = 0;
> @@ -751,6 +752,10 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>   		dout("truncate_size %lld -> %llu\n", ci->i_truncate_size,
>   		     truncate_size);
>   		ci->i_truncate_size = truncate_size;
> +		if (IS_ENCRYPTED(inode))
> +			ci->i_truncate_pagecache_size = size;
> +		else
> +			ci->i_truncate_pagecache_size = truncate_size;
>   	}
>   
>   	if (queue_trunc)
> @@ -1011,7 +1016,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>   
>   	if (new_version ||
>   	    (new_issued & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
> -		u64 size = info->size;
> +		u64 size = le64_to_cpu(info->size);
>   		s64 old_pool = ci->i_layout.pool_id;
>   		struct ceph_string *old_ns;
>   
> @@ -1026,16 +1031,20 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>   		pool_ns = old_ns;
>   
>   		if (IS_ENCRYPTED(inode) && size &&
> -		    (iinfo->fscrypt_file_len == sizeof(__le64))) {
> -			size = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
> -			if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
> -				pr_warn("size=%llu fscrypt_file=%llu\n", info->size, size);
> +		    (iinfo->fscrypt_file_len >= sizeof(__le64))) {
> +			u64 fsize = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
> +			if (fsize) {
> +				size = fsize;
> +				if (le64_to_cpu(info->size) !=
> +				    round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
> +					pr_warn("size=%llu fscrypt_file=%llu\n",
> +						info->size, size);
> +			}
>   		}
>   
>   		queue_trunc = ceph_fill_file_size(inode, issued,
>   					le32_to_cpu(info->truncate_seq),
> -					le64_to_cpu(info->truncate_size),
> -					le64_to_cpu(size));
> +					le64_to_cpu(info->truncate_size), size);
>   		/* only update max_size on auth cap */
>   		if ((info->cap.flags & CEPH_CAP_FLAG_AUTH) &&
>   		    ci->i_max_size != le64_to_cpu(info->max_size)) {
> @@ -2142,7 +2151,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
>   	/* there should be no reader or writer */
>   	WARN_ON_ONCE(ci->i_rd_ref || ci->i_wr_ref);
>   
> -	to = ci->i_truncate_size;
> +	to = ci->i_truncate_pagecache_size;
>   	wrbuffer_refs = ci->i_wrbuffer_ref;
>   	dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
>   	     ci->i_truncate_pending, to);
> @@ -2151,7 +2160,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
>   	truncate_pagecache(inode, to);
>   
>   	spin_lock(&ci->i_ceph_lock);
> -	if (to == ci->i_truncate_size) {
> +	if (to == ci->i_truncate_pagecache_size) {
>   		ci->i_truncate_pending = 0;
>   		finish = 1;
>   	}
> @@ -2232,6 +2241,141 @@ static const struct inode_operations ceph_encrypted_symlink_iops = {
>   	.listxattr = ceph_listxattr,
>   };
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
> +		header.assert_ver = 0;
> +		header.file_offset = 0;
> +		header.block_size = 0;
> +		ret = 0;
> +	} else {
> +		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
> +		header.assert_ver = cpu_to_le64(objvers.objvers[0].objver);
> +		header.file_offset = cpu_to_le64(orig_pos);
> +		header.block_size = cpu_to_le32(CEPH_FSCRYPT_BLOCK_SIZE);
> +
> +		/* truncate and zero out the extra contents for the last block */
> +		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
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
>   int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
>   {
>   	struct ceph_inode_info *ci = ceph_inode(inode);
> @@ -2239,12 +2383,15 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>   	struct ceph_mds_request *req;
>   	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>   	struct ceph_cap_flush *prealloc_cf;
> +	loff_t isize = i_size_read(inode);
>   	int issued;
>   	int release = 0, dirtied = 0;
>   	int mask = 0;
>   	int err = 0;
>   	int inode_dirty_flags = 0;
>   	bool lock_snap_rwsem = false;
> +	bool fill_fscrypt;
> +	int truncate_retry = 20; /* The RMW will take around 50ms */
>   
>   	prealloc_cf = ceph_alloc_cap_flush();
>   	if (!prealloc_cf)
> @@ -2257,6 +2404,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>   		return PTR_ERR(req);
>   	}
>   
> +retry:
> +	fill_fscrypt = false;
>   	spin_lock(&ci->i_ceph_lock);
>   	issued = __ceph_caps_issued(ci, NULL);
>   
> @@ -2378,10 +2527,27 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>   		}
>   	}
>   	if (ia_valid & ATTR_SIZE) {
> -		loff_t isize = i_size_read(inode);
> -
>   		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
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
>   			if (attr->ia_size > isize) {
>   				i_size_write(inode, attr->ia_size);
>   				inode->i_blocks = calc_inode_blocks(attr->ia_size);
> @@ -2404,7 +2570,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>   					cpu_to_le64(round_up(isize,
>   							     CEPH_FSCRYPT_BLOCK_SIZE));
>   				req->r_fscrypt_file = attr->ia_size;
> -				/* FIXME: client must zero out any partial blocks! */
>   			} else {
>   				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>   				req->r_args.setattr.old_size = cpu_to_le64(isize);
> @@ -2476,7 +2641,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>   	if (inode_dirty_flags)
>   		__mark_inode_dirty(inode, inode_dirty_flags);
>   
> -
>   	if (mask) {
>   		req->r_inode = inode;
>   		ihold(inode);
> @@ -2484,7 +2648,25 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>   		req->r_args.setattr.mask = cpu_to_le32(mask);
>   		req->r_num_caps = 1;
>   		req->r_stamp = attr->ia_ctime;
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
>   		err = ceph_mdsc_do_request(mdsc, NULL, req);
> +		if (err == -EAGAIN && truncate_retry--) {
> +			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
> +			     inode, err, ceph_cap_string(dirtied), mask);
> +			goto retry;

Here before retry we should put the request and release 'prealloc_cf'.


> +		}
>   	}
>   out:
>   	dout("setattr %p result=%d (%s locally, %d remote)\n", inode, err,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index b347b12e86a9..071857bb59d8 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -408,6 +408,11 @@ struct ceph_inode_info {
>   	u32 i_truncate_seq;        /* last truncate to smaller size */
>   	u64 i_truncate_size;       /*  and the size we last truncated down to */
>   	int i_truncate_pending;    /*  still need to call vmtruncate */
> +	/*
> +	 * For none fscrypt case it equals to i_truncate_size or it will
> +	 * equals to fscrypt_file_size
> +	 */
> +	u64 i_truncate_pagecache_size;
>   
>   	u64 i_max_size;            /* max file size authorized by mds */
>   	u64 i_reported_size; /* (max_)size reported to or requested of mds */

