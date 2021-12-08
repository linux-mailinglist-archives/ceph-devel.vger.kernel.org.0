Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DCC46C990
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Dec 2021 01:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbhLHAwT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Dec 2021 19:52:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234092AbhLHAwS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Dec 2021 19:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638924527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DgfMZS6ZskuCUuyU307ca0r6RI99xhEP89NLr/d4umc=;
        b=f+XAuXNBL48iIJ3wL+y6wdb/v591k+ZLTbqeLH/4tBF596E5z18i/LtOb9xfGOFgzW3Jg9
        K+Mp6FL8JalrkJ1C/R6xgi3USJKEeVI7VLoc65xzN4omiulitMA5riEwbhHFyx3SEElv2w
        Gau2+q8DSFxU+KR+aLKkfkUZXkgaeQE=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-M8HUXSkLOFyxG2OcsU7Blg-1; Tue, 07 Dec 2021 19:48:46 -0500
X-MC-Unique: M8HUXSkLOFyxG2OcsU7Blg-1
Received: by mail-pg1-f197.google.com with SMTP id j3-20020a634a43000000b00325af3ab5f0so354355pgl.11
        for <ceph-devel@vger.kernel.org>; Tue, 07 Dec 2021 16:48:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DgfMZS6ZskuCUuyU307ca0r6RI99xhEP89NLr/d4umc=;
        b=elA+tGawBpvoBqdnTrZJgcGMrU0A+vLoBlWi4sB2AdHB10JMly1iPcYpxThUipIOaB
         jQbwIYFuTQ41jo/5tJIeG/j9WrfPLaoRyvI9GNdDLteXZwOfYHBWynVAP73HYWRUWjN/
         AvetIZxfcm7tJBHcFBO7LtqcROQaHU8/C3Dk8xMypxrV6J2c2m+Qe1rYVeUG1zjvsI7U
         YeQfV5pHbD4P2c7T9HNp5XVYstWWl4XbLo7E8dtba1Y9RYK/J+CdZgSPNHh0OZwwrgWq
         Iej5nwJys5bcDvPE8c3k3pl0S+dysupD2PJmx6/M24fKgm38XthCQuFtM1aq003Ms6hR
         FAMA==
X-Gm-Message-State: AOAM532xOEoB8ieyDd8duPZRIpm2FMJUwJlpy7Yl4tqP9QPeaIlTnWU9
        G6myiuePnNon5q3ytoF7802l8LPVbLZBPlP3FR+QLdhez2smVySygPMX29M0W2cprir1XP/ShVE
        U/OyHvbuSL1IbMiCTKMHYuB2V7Hkie/L98eNOx21eLp33leDiMb8w3s7nNn9Q48/tmJoc6VI=
X-Received: by 2002:a17:902:ec04:b0:143:b9b8:827e with SMTP id l4-20020a170902ec0400b00143b9b8827emr54694785pld.54.1638924525075;
        Tue, 07 Dec 2021 16:48:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwQOlJHsalW98aEwKlQNNmNc+tehtCTLLmJB1NEtUuvYyDlXPHSEC8o4KvEM+EPczptWFxJw==
X-Received: by 2002:a17:902:ec04:b0:143:b9b8:827e with SMTP id l4-20020a170902ec0400b00143b9b8827emr54694741pld.54.1638924524680;
        Tue, 07 Dec 2021 16:48:44 -0800 (PST)
Received: from [10.72.12.131] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ms15sm650264pjb.26.2021.12.07.16.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 16:48:43 -0800 (PST)
Subject: Re: [PATCH v6 8/9] ceph: add object version support for sync read
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211104055248.190987-1-xiubli@redhat.com>
 <20211104055248.190987-9-xiubli@redhat.com>
 <a9c5aa357785e7a67297748e4f257d1486b69a4b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <287d1457-dc93-4f8c-8f44-a2bd78b0de48@redhat.com>
Date:   Wed, 8 Dec 2021 08:48:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a9c5aa357785e7a67297748e4f257d1486b69a4b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 12/8/21 1:31 AM, Jeff Layton wrote:
> On Thu, 2021-11-04 at 13:52 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The sync read may split the read into several osdc requests, so
>> for each it may in different Rados objects.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c  | 44 ++++++++++++++++++++++++++++++++++++++++++--
>>   fs/ceph/super.h | 18 +++++++++++++++++-
>>   2 files changed, 59 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 129f6a642f8e..cedd86a6058d 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -871,7 +871,8 @@ enum {
>>    * only return a short read to the caller if we hit EOF.
>>    */
>>   ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>> -			 struct iov_iter *to, int *retry_op)
>> +			 struct iov_iter *to, int *retry_op,
>> +			 struct ceph_object_vers *objvers)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>> @@ -880,6 +881,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   	u64 off = *ki_pos;
>>   	u64 len = iov_iter_count(to);
>>   	u64 i_size;
>> +	u32 object_count = 8;
>>   
>>   	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
>>   
>> @@ -896,6 +898,15 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   	if (ret < 0)
>>   		return ret;
>>   
>> +	if (objvers) {
>> +		objvers->count = 0;
>> +		objvers->objvers = kcalloc(object_count,
>> +					   sizeof(struct ceph_object_ver),
>> +					   GFP_KERNEL);
>> +		if (!objvers->objvers)
>> +			return -ENOMEM;
>> +	}
>> +
>>   	ret = 0;
>>   	while ((len = iov_iter_count(to)) > 0) {
>>   		struct ceph_osd_request *req;
>> @@ -938,6 +949,30 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   					 req->r_end_latency,
>>   					 len, ret);
>>   
>> +		if (objvers) {
>> +			u32 ind = objvers->count;
>> +
>> +			if (objvers->count >= object_count) {
>> +				int ov_size;
>> +
>> +				object_count *= 2;
>> +				ov_size = sizeof(struct ceph_object_ver);
>> +				objvers->objvers = krealloc_array(objvers,
>> +								  object_count,
>> +								  ov_size,
>> +								  GFP_KERNEL);
>> +				if (!objvers->objvers) {
>> +					objvers->count = 0;
>> +					ret = -ENOMEM;
>> +					break;
>> +				}
>> +			}
>> +
>> +			objvers->objvers[ind].offset = off;
>> +			objvers->objvers[ind].length = len;
>> +			objvers->objvers[ind].objver = req->r_version;
>> +			objvers->count++;
>> +		}
>>   		ceph_osdc_put_request(req);
>>   
>>   		i_size = i_size_read(inode);
>> @@ -995,6 +1030,11 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>   	}
>>   
>>   	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
>> +	if (ret < 0 && objvers) {
>> +		objvers->count = 0;
>> +		kfree(objvers->objvers);
>> +		objvers->objvers = NULL;
>> +	}
>>   	return ret;
>>   }
>>   
>> @@ -1008,7 +1048,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>   	     (unsigned)iov_iter_count(to),
>>   	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>>   
>> -	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
>> +	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op, NULL);
>>   }
>>   
>>   struct ceph_aio_request {
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 2362d758af97..b347b12e86a9 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -451,6 +451,21 @@ struct ceph_inode_info {
>>   	struct inode vfs_inode; /* at end */
>>   };
>>   
>> +/*
>> + * The version of an object which contains the
>> + * file range of [offset, offset + length).
>> + */
>> +struct ceph_object_ver {
>> +	u64 offset;
>> +	u64 length;
>> +	u64 objver;
>> +};
>> +
>> +struct ceph_object_vers {
>> +	u32 count;
>> +	struct ceph_object_ver *objvers;
>> +};
>> +
>>   static inline struct ceph_inode_info *
>>   ceph_inode(const struct inode *inode)
>>   {
>> @@ -1254,7 +1269,8 @@ extern int ceph_open(struct inode *inode, struct file *file);
>>   extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>   			    struct file *file, unsigned flags, umode_t mode);
>>   extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>> -				struct iov_iter *to, int *retry_op);
>> +				struct iov_iter *to, int *retry_op,
>> +				struct ceph_object_vers *objvers);
>>
>>
>
> I think this patch is probably overkill. It's not clear to me what you
> gain from tracking the offset and length in the object version.
>
> Reads across multiple objects aren't expected to be atomic in cephfs. It
> sucks, but RADOS can't reasonably guarantee that sort of consistency. I
> don't think you need to track all of the object versions since you only
> care about the last object in the read.
>
> Instead, could we just allow __ceph_sync_read to take a pointer to a u64
> instead of struct ceph_object_vers * ?

The last version was doing like this.

>   Then just have it fill that out
> with the version of the last object in the read.

I thought since this will be a general helper and might read more than 
one Rados objects and just switched to ceph_object_vers.

I am okay to take a pointer to a u64 to fill the last object's version.

I will send a fixing patch.

BRs

>
>>   extern int ceph_release(struct inode *inode, struct file *filp);
>>   extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>>   				  char *data, size_t len);

