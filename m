Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763F143F8A0
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Oct 2021 10:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhJ2IQq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 Oct 2021 04:16:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232313AbhJ2IQq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 04:16:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635495256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ASpBsdMS9/9e9rno0juGDavGfGxT0V0B5RmeFUKzxLM=;
        b=GhQE3NN44HYMuhBjH0p+qwzhQPvH8Nb7Gvk40H8oaio2AHDhPDk5j6DskP7yDYhnM67p8P
        rrbCjohx2q+rfR8vZdhYVpngz0Dsvul8JTVgVplil3vFGT4k7Jw0h3+Sdjb4mfOjxpe6s9
        sylfFiD9NQvFV03rYsBbxDSUFardX2g=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-V4tdCI-kMS20TYukR2mYGg-1; Fri, 29 Oct 2021 04:14:14 -0400
X-MC-Unique: V4tdCI-kMS20TYukR2mYGg-1
Received: by mail-pj1-f71.google.com with SMTP id nv1-20020a17090b1b4100b001a04861d474so4839857pjb.5
        for <ceph-devel@vger.kernel.org>; Fri, 29 Oct 2021 01:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ASpBsdMS9/9e9rno0juGDavGfGxT0V0B5RmeFUKzxLM=;
        b=I3vvhB/E9Io5dRkBx7F7d6/70UAAc7NvRgXqkmw1NKFg4fLQAmuQPSjmzoKLwUtNus
         fFmmUEG1pB3xmSiWEMxBgCk7p7RKEG+RS/mXwPSjAeuhIYlMZkCZSMhMZeAx3/Pa42w6
         LOqSr0mNcNMy8B7XmfPuk9Y7dxzQDLxrGjuU6VsikdCXRZc7ZDmOrLVE7qMielMQXcaZ
         LXKSlSWf6kG88PridfF3kzpo/EQEiaM0r/GrHxDuWn5Y0r5PIKDwwk1mDMFTCQ/QOTc/
         x20JtyuvHifnM8xngoQkW2Ot6IOorOtCEN0mE5D99P44c6fD7UwgKVw6amoMADTdvF5f
         qF8w==
X-Gm-Message-State: AOAM532jgMBe8CJkCR3X0vr/T0lCvE/bNjOVNk4C9Qdil86jw1P087EA
        8hjDa90DWA4x7guyfabJpnvB6dcpbE5pGAM9604AF67o/qSm0zvFrJCk9oKgaNjUTTeI00hPBw7
        3kE77GGPMM5JJw+VQkhtAvuNk0yy1chCBfXEFBRQ/LMMtTblshz+0bMS+z6OVNaayvGORVCo=
X-Received: by 2002:a17:903:22c5:b0:140:298b:9e27 with SMTP id y5-20020a17090322c500b00140298b9e27mr8679122plg.23.1635495252870;
        Fri, 29 Oct 2021 01:14:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy39WCSJoH9hYjXv3KaAMLRN0fzqUEn8kB1dFW2Hnu8JA5MbSfqmJXsG1/shmAp65Fy7g2Qhg==
X-Received: by 2002:a17:903:22c5:b0:140:298b:9e27 with SMTP id y5-20020a17090322c500b00140298b9e27mr8679093plg.23.1635495252489;
        Fri, 29 Oct 2021 01:14:12 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o4sm5698489pfb.48.2021.10.29.01.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 01:14:11 -0700 (PDT)
Subject: Re: [PATCH v3 2/4] ceph: add __ceph_sync_read helper support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211028091438.21402-1-xiubli@redhat.com>
 <20211028091438.21402-3-xiubli@redhat.com>
 <c824c92834ebcb01867a4fbc4d4bb0cbce95a8ad.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8fcffb2a-416d-374e-0e31-3c742bfc7f27@redhat.com>
Date:   Fri, 29 Oct 2021 16:14:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c824c92834ebcb01867a4fbc4d4bb0cbce95a8ad.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/29/21 2:21 AM, Jeff Layton wrote:
> On Thu, 2021-10-28 at 17:14 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c  | 31 +++++++++++++++++++++----------
>>   fs/ceph/super.h |  2 ++
>>   2 files changed, 23 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 6e677b40410e..74db403a4c35 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -901,20 +901,17 @@ static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64
>>    * If we get a short result from the OSD, check against i_size; we need to
>>    * only return a short read to the caller if we hit EOF.
>>    */
>> -static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>> -			      int *retry_op)
>> +ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>> +			 struct iov_iter *to, int *retry_op)
>>   {
>> -	struct file *file = iocb->ki_filp;
>> -	struct inode *inode = file_inode(file);
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>   	struct ceph_osd_client *osdc = &fsc->client->osdc;
>>   	ssize_t ret;
>> -	u64 off = iocb->ki_pos;
>> +	u64 off = *ki_pos;
>>   	u64 len = iov_iter_count(to);
>>   
>> -	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>> -	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>> +	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
>>   
>>   	if (!len)
>>   		return 0;
>> @@ -1058,18 +1055,32 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   			break;
>>   	}
>>   
>> -	if (off > iocb->ki_pos) {
>> +	if (off > *ki_pos) {
>>   		if (ret >= 0 &&
>>   		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
>>   			*retry_op = CHECK_EOF;
>> -		ret = off - iocb->ki_pos;
>> -		iocb->ki_pos = off;
>> +		ret = off - *ki_pos;
>> +		*ki_pos = off;
>>   	}
>>   out:
>>   	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
>>   	return ret;
>>   }
>>   
>> +static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>> +			      int *retry_op)
>> +{
>> +	struct file *file = iocb->ki_filp;
>> +	struct inode *inode = file_inode(file);
>> +
>> +	dout("sync_read on file %p %llu~%u %s\n", file, iocb->ki_pos,
>> +	     (unsigned)iov_iter_count(to),
>> +	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>> +
>> +	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
>> +
>> +}
>> +
>>   struct ceph_aio_request {
>>   	struct kiocb *iocb;
>>   	size_t total_len;
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 027d5f579ba0..57bc952c54e1 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -1235,6 +1235,8 @@ extern int ceph_renew_caps(struct inode *inode, int fmode);
>>   extern int ceph_open(struct inode *inode, struct file *file);
>>   extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>   			    struct file *file, unsigned flags, umode_t mode);
>> +extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>> +				struct iov_iter *to, int *retry_op);
>>   extern int ceph_release(struct inode *inode, struct file *filp);
>>   extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>>   				  char *data, size_t len);
> I went ahead and picked this patch too since #3 had a dependency on it.
> If we decide we want #3 for stable though, then we probably ought to
> respin these to avoid it.

I saw you have merged these two into the testing branch, should I respin 
for the #3 ?


