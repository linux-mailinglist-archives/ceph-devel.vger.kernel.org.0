Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE8A46DFDA
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Dec 2021 01:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbhLIBA3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Dec 2021 20:00:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240543AbhLIBA2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Dec 2021 20:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639011415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1SYbMG1n26FLhPVSvax8zdZFXtMWLTRYeBpMlikZaE=;
        b=gyb55Wdd7cAv8zx6bfKua9x3V/rrHWDsUCl4G2gz+FM5JKaqo3X50gihwASDDCuPG/d/p3
        ZTdeUaobyiWSAnFXUnVLTb1cMV1aPuIfrHu1UJMDcftNpvuh8c2PbuYI+R5Hv2/9MxnLle
        zAlBi9QBjdZfB/bK4Cdbc1f6yaSeL24=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-jl1p_tLIPmKHJG0-tfOtFA-1; Wed, 08 Dec 2021 19:56:54 -0500
X-MC-Unique: jl1p_tLIPmKHJG0-tfOtFA-1
Received: by mail-pj1-f72.google.com with SMTP id 61-20020a17090a09c300b001adc4362b42so2587912pjo.7
        for <ceph-devel@vger.kernel.org>; Wed, 08 Dec 2021 16:56:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=f1SYbMG1n26FLhPVSvax8zdZFXtMWLTRYeBpMlikZaE=;
        b=Bz64scavaJapWKOR/Mv4wDqUL3Dpz6MhgjEu1CLxwNIVjSthRA9548SqJBQz6ozBHp
         fqtrmZeaFsGmANTyZ+Hrj0huT2jEim2O8Z34NlfXNLG+pxbp+BeiJpXK41k/TSAJo2hL
         y8VqeL9GP8ZL4ObWbLfwGAKqgtxZeUj54eOEkprtpF9+wURNm5veM9U4gumbX0/Kxxpb
         k7dh/UDa6zmYGDHhmwgpKSFJaqKcVU5eVhWgWrDLyGP/isY5WNePjbmLHliInjDACZmP
         GOKeDpgJgaCtax2IAqVuX7ch2d2k8HQp4Q7TbNfK7hLayW6UqW+N8rnV4bCN7enMjRoi
         nFSg==
X-Gm-Message-State: AOAM530bXYiFGdzMKpl3dqq8dTMMpB2KfItx0UDJFigNNbS0XU/QSOkB
        YrMu1w7+0VaGuPGrD0CZfKzs4T/08edQM92c3RRrY+bQ035JL/16Tun7DGUOxg0CmhJTSAZvY0W
        YE7aloWz39ofmASAW53KDPLJizkOUcUSo6X0jxYo2yK6bPH9FhkJf9qDVJMaT20FJb4J0nHY=
X-Received: by 2002:a17:90a:49c2:: with SMTP id l2mr11666729pjm.23.1639011412960;
        Wed, 08 Dec 2021 16:56:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxw/qdHc+W2LVa3djmFd6idbtRRTyn0tnvIe6CdT89sHRSvNEnSz0lhcqVbNcPExNEyiVjdRg==
X-Received: by 2002:a17:90a:49c2:: with SMTP id l2mr11666683pjm.23.1639011412560;
        Wed, 08 Dec 2021 16:56:52 -0800 (PST)
Received: from [10.72.12.129] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mi14sm7565560pjb.6.2021.12.08.16.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 16:56:51 -0800 (PST)
Subject: Re: [PATCH v7 8/9] ceph: add object version support for sync read
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211208124528.679831-1-xiubli@redhat.com>
 <20211208124528.679831-2-xiubli@redhat.com>
 <2f46a421f943b5686ba175bd564821f39fb177d7.camel@kernel.org>
 <dad48776c8037361451a0a82bc49f5435e34aaf7.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cec36caf-9f18-15d8-7c9d-9695d1db221e@redhat.com>
Date:   Thu, 9 Dec 2021 08:56:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <dad48776c8037361451a0a82bc49f5435e34aaf7.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 12/9/21 2:22 AM, Jeff Layton wrote:
> On Wed, 2021-12-08 at 10:33 -0500, Jeff Layton wrote:
>> On Wed, 2021-12-08 at 20:45 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Always return the last object's version.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/file.c  | 8 ++++++--
>>>   fs/ceph/super.h | 3 ++-
>>>   2 files changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index b42158c9aa16..9279b8642add 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -883,7 +883,8 @@ enum {
>>>    * only return a short read to the caller if we hit EOF.
>>>    */
>>>   ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>> -			 struct iov_iter *to, int *retry_op)
>>> +			 struct iov_iter *to, int *retry_op,
>>> +			 u64 *last_objver)
>>>   {
>>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>>   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>> @@ -950,6 +951,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>>   					 req->r_end_latency,
>>>   					 len, ret);
>>>   
>>> +		if (last_objver)
>>> +			*last_objver = req->r_version;
>>> +
>> Much better! That said, this might be unreliable if (say) the first OSD
>> read was successful and then the second one failed on a long read that
>> spans objects. We'd want to return a short read in that case, but the
>> last_objver would end up being set to 0.
>>
>> I think you shouldn't set last_objver unless the call is going to return
>>> 0, and then you want to set it to the object version of the last
>> successful read in the series.
>>
Make sense to me.


> Since this was a simple change, I went ahead and folded the patch below
> into this patch and updated wip-fscrypt-size. Let me know if you have
> any objections:
>
> [PATCH] SQUASH: only set last_objver iff we're returning success
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 9279b8642add..ee6fb642cf05 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -893,6 +893,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>   	u64 off = *ki_pos;
>   	u64 len = iov_iter_count(to);
>   	u64 i_size = i_size_read(inode);
> +	u64 objver = 0;
>   
>   	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
>   
> @@ -951,9 +952,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>   					 req->r_end_latency,
>   					 len, ret);
>   
> -		if (last_objver)
> -			*last_objver = req->r_version;
> -
> +		objver = req->r_version;
>   		ceph_osdc_put_request(req);
>   
>   		i_size = i_size_read(inode);
> @@ -1010,6 +1009,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>   		}
>   	}
>   
> +	if (ret > 0)
> +		*last_objver = objver;
> +
>   	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
>   	return ret;
>   }

This also looks good to me :-)

Thanks.

BRs

