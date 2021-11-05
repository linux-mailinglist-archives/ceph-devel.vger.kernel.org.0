Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494174464AC
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 15:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhKEOOb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 10:14:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231933AbhKEOO3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Nov 2021 10:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636121509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m2Eil8nO9rs1HFfTR52Cw4NG5+RQA0+tAZolVLoO7LA=;
        b=M6CLLHcLgJP0i/mZIMV5n/Cu1L/lD7Ob9M8s/04+iJpxlmbK/ME+wfP8RV0l2XBNSGoj0x
        LbR6TOjGgG1AVW8CoAKJx40byxuRDOnd12SwDIh7eS/gH8ouavGXefp5twAOnBNHGZEm2p
        pdPAnOqS8cbtGMIernLvh6wNdrAF4gI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-NsEPkw5lP3O_pmMMT9_gPQ-1; Fri, 05 Nov 2021 10:11:48 -0400
X-MC-Unique: NsEPkw5lP3O_pmMMT9_gPQ-1
Received: by mail-pf1-f199.google.com with SMTP id 3-20020a620403000000b0044dbf310032so5940252pfe.0
        for <ceph-devel@vger.kernel.org>; Fri, 05 Nov 2021 07:11:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=m2Eil8nO9rs1HFfTR52Cw4NG5+RQA0+tAZolVLoO7LA=;
        b=Zrntr5Y3z6UsUZEJ17X3SvjQjAr2dSHTIloujI6vN6ahUsBf7MGpHTEinEnW974QpJ
         Z2wUqPdwLzWaWtR/1rs3NIXJJRMRKsTF5p7+j//d3lonA94ePyo8fUB0jXfXX6XNV0gu
         ToC6Kd+AFJPfDopcBIgek2nCGdc+IRpFTutwEv33IG8ujKVpPe5hHUL5G/z9cJNwZlGG
         YuwtvbATYU+pYxaFH22j0ooYKmiDa3dqknydW/kf1K8cdUTbIX+rs2RXekQHXsoGov7X
         I2ZBnVjD5TNcqQwYFkrv4uDFf7zp6M+3HLKcl1QWampB/hd2OH4/6xISyBXc1I09pDbf
         RE/w==
X-Gm-Message-State: AOAM530SdQZPdayl76ZW0HNcfiuS5Y9GAg3QMyoY1YiWSlA8MHur7cXq
        DS+Bkt4yu55rZc9T1vgluUMszs6yhnDDgRvTfsTK7UC1/Lc8+mYR1goqs/2iBmaNYMmkqGtHnnC
        VV1DS4m0DHd+K6VHcNFN5KQLKLHeO3oqo16MNQ6m0HkQzhOduGQ36du3tbc6LOUdjL6linc4=
X-Received: by 2002:a63:1d13:: with SMTP id d19mr45102138pgd.383.1636121506713;
        Fri, 05 Nov 2021 07:11:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxzk9NUWR7fNs0lT9TbQdKNPYT9ksz8gC0V8ZGqDTGlJ+qQTN11/X8ZQANSSrmy7fB7PPToA==
X-Received: by 2002:a63:1d13:: with SMTP id d19mr45102081pgd.383.1636121506144;
        Fri, 05 Nov 2021 07:11:46 -0700 (PDT)
Received: from [10.72.12.174] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t16sm2738344pja.10.2021.11.05.07.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 07:11:45 -0700 (PDT)
Subject: Re: [PATCH v6 9/9] ceph: add truncate size handling support for
 fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211104055248.190987-1-xiubli@redhat.com>
 <20211104055248.190987-10-xiubli@redhat.com>
 <c066546386941ae41a5e907fa54c0e794d2f4865.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <afdedc70-0140-c0a3-a0f2-7656e9394a43@redhat.com>
Date:   Fri, 5 Nov 2021 22:11:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c066546386941ae41a5e907fa54c0e794d2f4865.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/5/21 9:36 PM, Jeff Layton wrote:
> On Thu, 2021-11-04 at 13:52 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will transfer the encrypted last block contents to the MDS
>> along with the truncate request only when the new size is smaller
>> and not aligned to the fscrypt BLOCK size. When the last block is
>> located in the file hole, the truncate request will only contain
>> the header.
>>
>> The MDS could fail to do the truncate if there has another client
>> or process has already updated the Rados object which contains
>> the last block, and will return -EAGAIN, then the kclient needs
>> to retry it. The RMW will take around 50ms, and will let it retry
>> 20 times for now.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c             | 205 ++++++++++++++++++++++++++++++++++--
>>   fs/ceph/super.h             |   5 +
>>   include/linux/ceph/crypto.h |  28 +++++
>>   3 files changed, 227 insertions(+), 11 deletions(-)
>>   create mode 100644 include/linux/ceph/crypto.h
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 15c2fb1e2c8a..5817685ea9a5 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -21,6 +21,7 @@
>>   #include "cache.h"
>>   #include "crypto.h"
>>   #include <linux/ceph/decode.h>
>> +#include <linux/ceph/crypto.h>
>>   
>>   /*
>>    * Ceph inode operations
>> @@ -586,6 +587,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>   	ci->i_truncate_seq = 0;
>>   	ci->i_truncate_size = 0;
>>   	ci->i_truncate_pending = 0;
>> +	ci->i_truncate_pagecache_size = 0;
>>   
>>   	ci->i_max_size = 0;
>>   	ci->i_reported_size = 0;
>> @@ -751,6 +753,10 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>>   		dout("truncate_size %lld -> %llu\n", ci->i_truncate_size,
>>   		     truncate_size);
>>   		ci->i_truncate_size = truncate_size;
>> +		if (IS_ENCRYPTED(inode))
>> +			ci->i_truncate_pagecache_size = size;
>> +		else
>> +			ci->i_truncate_pagecache_size = truncate_size;
>>   	}
>>   
>>   	if (queue_trunc)
>> @@ -1026,10 +1032,14 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>>   		pool_ns = old_ns;
>>   
>>   		if (IS_ENCRYPTED(inode) && size &&
>> -		    (iinfo->fscrypt_file_len == sizeof(__le64))) {
>> -			size = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
>> -			if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
>> -				pr_warn("size=%llu fscrypt_file=%llu\n", info->size, size);
>> +		    (iinfo->fscrypt_file_len >= sizeof(__le64))) {
>> +			u64 fsize = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
>> +			if (fsize) {
>> +				size = fsize;
>> +				if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
>> +					pr_warn("size=%llu fscrypt_file=%llu\n",
>> +						info->size, size);
>> +			}
>>   		}
>>   
>>   		queue_trunc = ceph_fill_file_size(inode, issued,
>> @@ -2142,7 +2152,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
>>   	/* there should be no reader or writer */
>>   	WARN_ON_ONCE(ci->i_rd_ref || ci->i_wr_ref);
>>   
>> -	to = ci->i_truncate_size;
>> +	to = ci->i_truncate_pagecache_size;
>>   	wrbuffer_refs = ci->i_wrbuffer_ref;
>>   	dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
>>   	     ci->i_truncate_pending, to);
>> @@ -2151,7 +2161,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
>>   	truncate_pagecache(inode, to);
>>   
>>   	spin_lock(&ci->i_ceph_lock);
>> -	if (to == ci->i_truncate_size) {
>> +	if (to == ci->i_truncate_pagecache_size) {
>>   		ci->i_truncate_pending = 0;
>>   		finish = 1;
>>   	}
>> @@ -2232,6 +2242,141 @@ static const struct inode_operations ceph_encrypted_symlink_iops = {
>>   	.listxattr = ceph_listxattr,
>>   };
>>   
>> +/*
>> + * Transfer the encrypted last block to the MDS and the MDS
>> + * will help update it when truncating a smaller size.
>> + *
>> + * We don't support a PAGE_SIZE that is smaller than the
>> + * CEPH_FSCRYPT_BLOCK_SIZE.
>> + */
>> +static int fill_fscrypt_truncate(struct inode *inode,
>> +				 struct ceph_mds_request *req,
>> +				 struct iattr *attr)
>> +{
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	int boff = attr->ia_size % CEPH_FSCRYPT_BLOCK_SIZE;
>> +	loff_t pos, orig_pos = round_down(attr->ia_size, CEPH_FSCRYPT_BLOCK_SIZE);
>> +#if 0
>> +	u64 block = orig_pos >> CEPH_FSCRYPT_BLOCK_SHIFT;
>> +#endif
>> +	struct ceph_pagelist *pagelist = NULL;
>> +	struct kvec iov;
>> +	struct iov_iter iter;
>> +	struct page *page = NULL;
>> +	struct ceph_fscrypt_truncate_size_header header;
>> +	int retry_op = 0;
>> +	int len = CEPH_FSCRYPT_BLOCK_SIZE;
>> +	loff_t i_size = i_size_read(inode);
>> +	struct ceph_object_vers objvers = {0, NULL};
>> +	int got, ret, issued;
>> +
>> +	ret = __ceph_get_caps(inode, NULL, CEPH_CAP_FILE_RD, 0, -1, &got);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	issued = __ceph_caps_issued(ci, NULL);
>> +
>> +	dout("%s size %lld -> %lld got cap refs on %s, issued %s\n", __func__,
>> +	     i_size, attr->ia_size, ceph_cap_string(got),
>> +	     ceph_cap_string(issued));
>> +
>> +	/* Try to writeback the dirty pagecaches */
>> +	if (issued & (CEPH_CAP_FILE_BUFFER))
>> +		filemap_fdatawrite(&inode->i_data);
>> +
>> +	page = __page_cache_alloc(GFP_KERNEL);
>> +	if (page == NULL) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
>> +	if (!pagelist) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	iov.iov_base = kmap_local_page(page);
>> +	iov.iov_len = len;
>> +	iov_iter_kvec(&iter, READ, &iov, 1, len);
>> +
>> +	pos = orig_pos;
>> +	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &objvers);
>> +	ceph_put_cap_refs(ci, got);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	WARN_ON_ONCE(objvers.count != 1);
>> +
>> +	/* Insert the header first */
>> +	header.ver = 1;
>> +	header.compat = 1;
>> +
>> +	/*
>> +	 * If we hit a hole here, we should just skip filling
>> +	 * the fscrypt for the request, because once the fscrypt
>> +	 * is enabled, the file will be split into many blocks
>> +	 * with the size of CEPH_FSCRYPT_BLOCK_SIZE, if there
>> +	 * has a hole, the hole size should be multiple of block
>> +	 * size.
>> +	 *
>> +	 * If the Rados object doesn't exist, it will be set 0.
>> +	 */
>> +	if (!objvers.objvers[0].objver) {
>> +		dout("%s hit hole, ppos %lld < size %lld\n", __func__,
>> +		     pos, i_size);
>> +
>> +		header.data_len = cpu_to_le32(8 + 8 + 4);
>> +		header.assert_ver = cpu_to_le64(0);
>> +		header.file_offset = cpu_to_le64(0);
>> +		header.block_size = cpu_to_le64(0);
> Note that 0 is a special case, and nothing will complain if you don't
> endian-convert it before assigning it.
Yeah.
>
>> +		ret = 0;
>> +	} else {
>> +		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
>> +		header.assert_ver = objvers.objvers[0].objver;
>> +		header.file_offset = cpu_to_le64(orig_pos);
>> +		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
>> +
>> +		/* truncate and zero out the extra contents for the last block */
>> +		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
>>
>>
> sparse throws some warnings here:
>
>    CHECK   fs/ceph/inode.c
> fs/ceph/inode.c:1020:32: warning: incorrect type in initializer (different base types)
> fs/ceph/inode.c:1020:32:    expected unsigned long long [usertype] size
> fs/ceph/inode.c:1020:32:    got restricted __le64 [usertype] size
> fs/ceph/inode.c:1039:41: warning: restricted __le64 degrades to integer
> fs/ceph/inode.c:1048:41: warning: cast to restricted __le64
> fs/ceph/inode.c:2332:35: warning: incorrect type in assignment (different base types)
> fs/ceph/inode.c:2332:35:    expected restricted __le32 [assigned] [usertype] block_size
> fs/ceph/inode.c:2332:35:    got restricted __le64 [usertype]
> fs/ceph/inode.c:2336:35: warning: incorrect type in assignment (different base types)
> fs/ceph/inode.c:2336:35:    expected restricted __le64 [assigned] [usertype] assert_ver
> fs/ceph/inode.c:2336:35:    got unsigned long long [usertype] objver
> fs/ceph/inode.c:2338:35: warning: incorrect type in assignment (different base types)
> fs/ceph/inode.c:2338:35:    expected restricted __le32 [assigned] [usertype] block_size
> fs/ceph/inode.c:2338:35:    got restricted __le64 [usertype]
> fs/ceph/inode.c:2549:45: warning: incorrect type in assignment (different base types)
> fs/ceph/inode.c:2549:45:    expected restricted __le64 [usertype] r_fscrypt_file
> fs/ceph/inode.c:2549:45:    got long long [usertype] ia_size
> fs/ceph/inode.c:2573:53: warning: incorrect type in assignment (different base types)
> fs/ceph/inode.c:2573:53:    expected restricted __le64 [usertype] r_fscrypt_file
> fs/ceph/inode.c:2573:53:    got long long [usertype] ia_size
>
> I've attached a patch to this email. Can you fold those deltas into the
> appropriate patches in your series and resend?
>
> FWIW, esp. when dealing with this sort of endianness-converting code,
> it's often a good idea to install sparse and build the kmod with C=1,
> which will catch these sorts of warnings.
>
> Here's what I usually use this to build the module:
>
>      $ make -j16 M=fs/ceph W=1 C=1
>
> There are some persistent bogus warnings about lock imbalances that I
> sitll need to fix one of these days, but I've just been ignoring those
> for now.

Will fix this and post the V7 later.


>> +
>> +#if 0 // Uncomment this when the fscrypt is enabled globally in kceph
>> +
>> +		/* encrypt the last block */
>> +		ret = fscrypt_encrypt_block_inplace(inode, page,
>> +						    CEPH_FSCRYPT_BLOCK_SIZE,
>> +						    0, block,
>> +						    GFP_KERNEL);
>> +		if (ret)
>> +			goto out;
>> +#endif
>> +	}
>> +
>> +	/* Insert the header */
>> +	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (header.block_size) {
>> +		/* Append the last block contents to pagelist */
>> +		ret = ceph_pagelist_append(pagelist, iov.iov_base,
>> +					   CEPH_FSCRYPT_BLOCK_SIZE);
>> +		if (ret)
>> +			goto out;
>> +	}
>> +	req->r_pagelist = pagelist;
>> +out:
>> +	dout("%s %p size dropping cap refs on %s\n", __func__,
>> +	     inode, ceph_cap_string(got));
>> +	kunmap_local(iov.iov_base);
>> +	if (page)
>> +		__free_pages(page, 0);
>> +	if (ret && pagelist)
>> +		ceph_pagelist_release(pagelist);
>> +	kfree(objvers.objvers);
>> +	return ret;
>> +}
>> +
>>   int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>> @@ -2239,12 +2384,15 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   	struct ceph_mds_request *req;
>>   	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>   	struct ceph_cap_flush *prealloc_cf;
>> +	loff_t isize = i_size_read(inode);
>>   	int issued;
>>   	int release = 0, dirtied = 0;
>>   	int mask = 0;
>>   	int err = 0;
>>   	int inode_dirty_flags = 0;
>>   	bool lock_snap_rwsem = false;
>> +	bool fill_fscrypt;
>> +	int truncate_retry = 20; /* The RMW will take around 50ms */
>>   
>>   	prealloc_cf = ceph_alloc_cap_flush();
>>   	if (!prealloc_cf)
>> @@ -2257,6 +2405,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   		return PTR_ERR(req);
>>   	}
>>   
>> +retry:
>> +	fill_fscrypt = false;
>>   	spin_lock(&ci->i_ceph_lock);
>>   	issued = __ceph_caps_issued(ci, NULL);
>>   
>> @@ -2378,10 +2528,27 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   		}
>>   	}
>>   	if (ia_valid & ATTR_SIZE) {
>> -		loff_t isize = i_size_read(inode);
>> -
>>   		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
>> -		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
>> +		/*
>> +		 * Only when the new size is smaller and not aligned to
>> +		 * CEPH_FSCRYPT_BLOCK_SIZE will the RMW is needed.
>> +		 */
>> +		if (IS_ENCRYPTED(inode) && attr->ia_size < isize &&
>> +		    (attr->ia_size % CEPH_FSCRYPT_BLOCK_SIZE)) {
>> +			mask |= CEPH_SETATTR_SIZE;
>> +			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
>> +				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
>> +			set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>> +			mask |= CEPH_SETATTR_FSCRYPT_FILE;
>> +			req->r_args.setattr.size =
>> +				cpu_to_le64(round_up(attr->ia_size,
>> +						     CEPH_FSCRYPT_BLOCK_SIZE));
>> +			req->r_args.setattr.old_size =
>> +				cpu_to_le64(round_up(isize,
>> +						     CEPH_FSCRYPT_BLOCK_SIZE));
>> +			req->r_fscrypt_file = attr->ia_size;
>> +			fill_fscrypt = true;
>> +		} else if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
>>   			if (attr->ia_size > isize) {
>>   				i_size_write(inode, attr->ia_size);
>>   				inode->i_blocks = calc_inode_blocks(attr->ia_size);
>> @@ -2404,7 +2571,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   					cpu_to_le64(round_up(isize,
>>   							     CEPH_FSCRYPT_BLOCK_SIZE));
>>   				req->r_fscrypt_file = attr->ia_size;
>> -				/* FIXME: client must zero out any partial blocks! */
>>   			} else {
>>   				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>>   				req->r_args.setattr.old_size = cpu_to_le64(isize);
>> @@ -2476,7 +2642,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   	if (inode_dirty_flags)
>>   		__mark_inode_dirty(inode, inode_dirty_flags);
>>   
>> -
>>   	if (mask) {
>>   		req->r_inode = inode;
>>   		ihold(inode);
>> @@ -2484,7 +2649,25 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   		req->r_args.setattr.mask = cpu_to_le32(mask);
>>   		req->r_num_caps = 1;
>>   		req->r_stamp = attr->ia_ctime;
>> +		if (fill_fscrypt) {
>> +			err = fill_fscrypt_truncate(inode, req, attr);
>> +			if (err)
>> +				goto out;
>> +		}
>> +
>> +		/*
>> +		 * The truncate request will return -EAGAIN when the
>> +		 * last block has been updated just before the MDS
>> +		 * successfully gets the xlock for the FILE lock. To
>> +		 * avoid corrupting the file contents we need to retry
>> +		 * it.
>> +		 */
>>   		err = ceph_mdsc_do_request(mdsc, NULL, req);
>> +		if (err == -EAGAIN && truncate_retry--) {
>> +			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
>> +			     inode, err, ceph_cap_string(dirtied), mask);
>> +			goto retry;
>> +		}
>>   	}
>>   out:
>>   	dout("setattr %p result=%d (%s locally, %d remote)\n", inode, err,
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index b347b12e86a9..071857bb59d8 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -408,6 +408,11 @@ struct ceph_inode_info {
>>   	u32 i_truncate_seq;        /* last truncate to smaller size */
>>   	u64 i_truncate_size;       /*  and the size we last truncated down to */
>>   	int i_truncate_pending;    /*  still need to call vmtruncate */
>> +	/*
>> +	 * For none fscrypt case it equals to i_truncate_size or it will
>> +	 * equals to fscrypt_file_size
>> +	 */
>> +	u64 i_truncate_pagecache_size;
>>   
>>   	u64 i_max_size;            /* max file size authorized by mds */
>>   	u64 i_reported_size; /* (max_)size reported to or requested of mds */
>> diff --git a/include/linux/ceph/crypto.h b/include/linux/ceph/crypto.h
>> new file mode 100644
>> index 000000000000..2b0961902887
>> --- /dev/null
>> +++ b/include/linux/ceph/crypto.h
>> @@ -0,0 +1,28 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _FS_CEPH_CRYPTO_H
>> +#define _FS_CEPH_CRYPTO_H
>> +
>> +#include <linux/types.h>
>> +
>> +/*
>> + * Header for the crypted file when truncating the size, this
>> + * will be sent to MDS, and the MDS will update the encrypted
>> + * last block and then truncate the size.
>> + */
>> +struct ceph_fscrypt_truncate_size_header {
>> +       __u8  ver;
>> +       __u8  compat;
>> +
>> +       /*
>> +	* It will be sizeof(assert_ver + file_offset + block_size)
>> +	* if the last block is empty when it's located in a file
>> +	* hole. Or the data_len will plus CEPH_FSCRYPT_BLOCK_SIZE.
>> +	*/
>> +       __le32 data_len;
>> +
>> +       __le64 assert_ver;
>> +       __le64 file_offset;
>> +       __le32 block_size;
>> +} __packed;
>> +
>> +#endif
> When I said to move this to crypto.h, I meant fs/ceph/crypto.h. Let's
> not add a new header file for this. Can you move this definition into
> there?

Sure.

BRs

-- Xiubo


>
> Thanks,

