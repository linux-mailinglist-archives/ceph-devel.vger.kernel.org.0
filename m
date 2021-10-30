Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30EA4407A4
	for <lists+ceph-devel@lfdr.de>; Sat, 30 Oct 2021 07:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhJ3GB2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 Oct 2021 02:01:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhJ3GB1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 02:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635573537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZmE96de9l0ZOBY2tXDutt7EKrkvgN2XklZlB3lCB6Xk=;
        b=gXIyw0BN8RcI1vOPNvzze2HEldQC/fFfA5bPKWdOaRQKKxd+OoFVZStsmPq0WdY/TaFGD9
        KDqA/+IRbuxfiZmlaURGacDqaD9BqA6Fg7HmjqF/kMVu3GxQhaffc9f1qJj5T/zaMii0NP
        PNqMEDEqw6sN3UTbf72O+GyyolCHdAA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-WE3slcynNteg2MXQCvvbqw-1; Sat, 30 Oct 2021 01:58:55 -0400
X-MC-Unique: WE3slcynNteg2MXQCvvbqw-1
Received: by mail-pg1-f198.google.com with SMTP id m74-20020a633f4d000000b0029fed7e61f9so6000196pga.16
        for <ceph-devel@vger.kernel.org>; Fri, 29 Oct 2021 22:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZmE96de9l0ZOBY2tXDutt7EKrkvgN2XklZlB3lCB6Xk=;
        b=q8L2A2fW2TXqqOVqeP43+XWzHi3bFQ8VpL//a1jMMUSqpEAVGuKXn/X/FV9AYNvgKZ
         11XrGZiHuYjQwd+qwNEY+YsGVJiFDfmW9zQbAfyjR3V0xXgHJhWbpsJcHs7ApKT1zFe9
         7go36Oeim0AACf26Dr6OCKw/YYqedGGvDukkKhGgvORi4BTfTwhLyErOwkD4B4kDh9Mm
         VdrBbumfq4uQoNWXDD5bnBDmMWfvTnedGBdPeQDmHRjcNRuPiDQSP8OdNCF7KXI8rssp
         ztTFS4Tdy7Hqb7VRJnJh+xWB84BnJiRQWtZlDLDQhx93gymOXgfUJFNbHCcFy4U5mtKQ
         UjLg==
X-Gm-Message-State: AOAM531RKpVuYl4/mOiD0b7iw1azQOdoAJlAILwZ/Sd+zcQNTNtJDQ/I
        Ocv5Z/oYjwp5YP4cFWqN1FA5Xpq7TzXNk4Y7dvWOLAbadmihFsq5qZd/VVc22JQq3vhtkFb/KWP
        3098pnx4F8CTHqoKZLkzpO5wFXUEIAX10PeMmi0yGdCbS7DxyYVz5/GviBa8H+kZUweEzXww=
X-Received: by 2002:a05:6a00:1709:b0:47e:66f7:1d13 with SMTP id h9-20020a056a00170900b0047e66f71d13mr9089345pfc.36.1635573533863;
        Fri, 29 Oct 2021 22:58:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDxKafH4giO/VPeQnN1BQaNAmYMwOyK/WiMkk+iOCnTrL5vFVuK6KjL9eMTek2u7RYr3xcLg==
X-Received: by 2002:a05:6a00:1709:b0:47e:66f7:1d13 with SMTP id h9-20020a056a00170900b0047e66f71d13mr9089310pfc.36.1635573533309;
        Fri, 29 Oct 2021 22:58:53 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p4sm9127094pfo.73.2021.10.29.22.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 22:58:52 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] ceph: add truncate size handling support for
 fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211028091438.21402-1-xiubli@redhat.com>
 <20211028091438.21402-5-xiubli@redhat.com>
 <37ca7a43ec7b9d796d4d8fb962309278c0df7d76.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e4941492-ce86-f4df-8852-7fc2e991f899@redhat.com>
Date:   Sat, 30 Oct 2021 13:58:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <37ca7a43ec7b9d796d4d8fb962309278c0df7d76.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/29/21 3:17 AM, Jeff Layton wrote:
> On Thu, 2021-10-28 at 17:14 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will transfer the encrypted last block contents to the MDS
>> along with the truncate request only when new size is smaller and
>> not aligned to the fscrypt BLOCK size.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c              |   2 -
>>   fs/ceph/file.c              |  10 +-
>>   fs/ceph/inode.c             | 182 ++++++++++++++++++++++++++++++++++--
>>   fs/ceph/super.h             |   3 +-
>>   include/linux/ceph/crypto.h |  23 +++++
>>   5 files changed, 206 insertions(+), 14 deletions(-)
>>   create mode 100644 include/linux/ceph/crypto.h
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 4e2a588465c5..c9624b059eb0 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1299,8 +1299,6 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
>>   	 * fscrypt_auth holds the crypto context (if any). fscrypt_file
>>   	 * tracks the real i_size as an __le64 field (and we use a rounded-up
>>   	 * i_size in * the traditional size field).
>> -	 *
>> -	 * FIXME: should we encrypt fscrypt_file field?
>>   	 */
>>   	ceph_encode_32(&p, arg->fscrypt_auth_len);
>>   	ceph_encode_copy(&p, arg->fscrypt_auth, arg->fscrypt_auth_len);
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 1988e75ad4a2..2a780e0133df 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -902,7 +902,8 @@ static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64
>>    * only return a short read to the caller if we hit EOF.
>>    */
>>   ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>> -			 struct iov_iter *to, int *retry_op)
>> +			 struct iov_iter *to, int *retry_op,
>> +			 u64 *assert_ver)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>> @@ -978,6 +979,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   					 req->r_end_latency,
>>   					 len, ret);
>>   
>> +		/* Grab assert version. It must be non-zero. */
>> +		*assert_ver = req->r_version;
>> +		WARN_ON_ONCE(assert_ver == 0);
>>   		ceph_osdc_put_request(req);
>>   
>>   		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
>> @@ -1074,12 +1078,14 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   {
>>   	struct file *file = iocb->ki_filp;
>>   	struct inode *inode = file_inode(file);
>> +	u64 assert_ver;
>>   
>>   	dout("sync_read on file %p %llu~%u %s\n", file, iocb->ki_pos,
>>   	     (unsigned)iov_iter_count(to),
>>   	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>>   
>> -	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
>> +	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op,
>> +				&assert_ver);
>>   
>>   }
>>   
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 9b798690fdc9..abb634866897 100644
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
>> @@ -1034,10 +1035,14 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
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
>> @@ -2229,6 +2234,130 @@ static const struct inode_operations ceph_encrypted_symlink_iops = {
>>   	.listxattr = ceph_listxattr,
>>   };
>>   
>> +/*
>> + * Transfer the encrypted last block to the MDS and the MDS
>> + * will update the file when truncating a smaller size.
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
>> +	u64 block = orig_pos >> CEPH_FSCRYPT_BLOCK_SHIFT;
>> +	struct ceph_pagelist *pagelist = NULL;
>> +	struct kvec iov;
>> +	struct iov_iter iter;
>> +	struct page *page = NULL;
>> +	struct ceph_fscrypt_truncate_size_header header;
>> +	int retry_op = 0;
>> +	int len = CEPH_FSCRYPT_BLOCK_SIZE;
>> +	loff_t i_size = i_size_read(inode);
>> +	bool fill_header_only = false;
>> +	u64 assert_ver = cpu_to_le64(0);
>> +	int got, ret, issued;
>> +
>> +	ret = __ceph_get_caps(inode, NULL, CEPH_CAP_FILE_RD, 0, -1, &got);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	dout("%s size %lld -> %lld got cap refs on %s\n", __func__,
>> +	     i_size, attr->ia_size, ceph_cap_string(got));
>> +
>> +	issued = __ceph_caps_issued(ci, NULL);
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
>> +	iov.iov_base = kmap_local_page(page);
>> +	iov.iov_len = len;
>> +	iov_iter_kvec(&iter, READ, &iov, 1, len);
>> +
>> +	pos = orig_pos;
>> +	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &assert_ver);
>> +
>> +	/*
>> +	 * If we hit a hole here, we should just skip filling
>> +	 * the fscrypt for the request, because once the fscrypt
>> +	 * is enabled, the file will be split into many blocks
>> +	 * with the size of CEPH_FSCRYPT_BLOCK_SIZE, if there
>> +	 * has a hole, the hole size should be multiple of block
>> +	 * size.
>> +	 */
>> +	if (pos < i_size && ret < len) {
>> +		dout("%s hit hole, ppos %lld < size %lld\n",
>> +		     __func__, pos, i_size);
>> +
>> +		ret = 0;
>> +		fill_header_only = true;
>> +		goto fill_last_block;
>> +	}
>>
>>
> You can drop the goto above if you just put everything between here and
> fill_last_block into an else block.

Sure, will fix it.


>> +
>> +	/* truncate and zero out the extra contents for the last block */
>> +	memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
>> +
>> +	/* encrypt the last block */
>> +	ret = fscrypt_encrypt_block_inplace(inode, page,
>> +					    CEPH_FSCRYPT_BLOCK_SIZE,
>> +					    0, block,
>> +					    GFP_KERNEL);
>> +	if (ret)
>> +		goto out;
>>
>>
> Careful with the above. We don't _really_ want to run the encryption
> just yet, until we're ready to turn on content encryption everywhere.
> Might want to #ifdef 0 that out for now.

The fill_fscrypt_truncate() will be called by __ceph_setattr() if 
IS_ENCRYPTED(inode) is false.

And this patch series should be based on your previous fscrypt patch set.

>
>> +
>> +fill_last_block:
>> +	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
>> +	if (!pagelist)
>> +		return -ENOMEM;
>> +
>> +	/* Insert the header first */
>> +	header.ver = 1;
>> +	header.compat = 1;
>> +	if (fill_header_only) {
>> +		header.data_len = cpu_to_le32(8 + 8 + 4);
>> +		header.assert_ver = cpu_to_le64(0);
>> +		header.file_offset = cpu_to_le64(0);
>> +		header.block_size = cpu_to_le64(0);
>> +	} else {
>> +		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
>> +		header.assert_ver = assert_ver;
>> +		header.file_offset = cpu_to_le64(orig_pos);
>> +		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
>> +	}
>> +	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (!fill_header_only) {
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
>> +	ceph_put_cap_refs(ci, got);
>> +	return ret;
>> +}
>> +
>>   int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>> @@ -2236,12 +2365,14 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
>>   
>>   	prealloc_cf = ceph_alloc_cap_flush();
>>   	if (!prealloc_cf)
>> @@ -2254,6 +2385,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   		return PTR_ERR(req);
>>   	}
>>   
>> +retry:
>> +	fill_fscrypt = false;
>>   	spin_lock(&ci->i_ceph_lock);
>>   	issued = __ceph_caps_issued(ci, NULL);
>>   
>> @@ -2367,10 +2500,27 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
>> @@ -2393,7 +2543,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   					cpu_to_le64(round_up(isize,
>>   							     CEPH_FSCRYPT_BLOCK_SIZE));
>>   				req->r_fscrypt_file = attr->ia_size;
>> -				/* FIXME: client must zero out any partial blocks! */
>>   			} else {
>>   				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>>   				req->r_args.setattr.old_size = cpu_to_le64(isize);
>> @@ -2465,7 +2614,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   	if (inode_dirty_flags)
>>   		__mark_inode_dirty(inode, inode_dirty_flags);
>>   
>> -
>>   	if (mask) {
>>   		req->r_inode = inode;
>>   		ihold(inode);
>> @@ -2473,7 +2621,23 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
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
>> +		 * The truncate will return -EAGAIN when some one
>> +		 * has updated the last block before the MDS hold
>> +		 * the xlock for the FILE lock. Need to retry it.
>> +		 */
>>   		err = ceph_mdsc_do_request(mdsc, NULL, req);
>> +		if (err == -EAGAIN) {
>> +			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
>> +			     inode, err, ceph_cap_string(dirtied), mask);
>> +			goto retry;
>> +		}
> The rest looks reasonable. We may want to cap the number of retries in
> case something goes really wrong or in the case of a livelock with a
> competing client. I'm not sure what a reasonable number of tries would
> be though -- 5? 10? 100? We may want to benchmark out how long this rmw
> operation takes and then we can use that to determine a reasonable
> number of tries.
>
> If you run out of tries, you could probably  just return -EAGAIN in that
> case. That's not listed in the truncate(2) manpage, but it seems like a
> reasonable way to handle that sort of problem.

Make sesne, will do that.

Thanks

-- Xiubo


