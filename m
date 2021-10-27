Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2264443D737
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 01:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJ0XLB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 19:11:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229987AbhJ0XK6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 19:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635376111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrV4WUd9VxV3Dh/i0y2i26P0alMkja/gC7fFHko/Z1k=;
        b=fdSSZLoCZXtfrFTjNGWHl70MFysMpqyiWWNN9hU7UoYzliUFZBC9IjIzn24g7NmrFkZVnK
        3sylCkROZFjWA9gdWJamHbvbshS6N5bb97Ums9h7mXv9qoyz1+y4HCl5oexN1jUNNMdXFV
        2GUFtZSjuB8rYtDLCFoMUU1zF0dhvaI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-H5F1VSTvM6mE1DDOGRGaCQ-1; Wed, 27 Oct 2021 19:08:30 -0400
X-MC-Unique: H5F1VSTvM6mE1DDOGRGaCQ-1
Received: by mail-pj1-f71.google.com with SMTP id n2-20020a17090a2fc200b001a1bafb59bfso2392813pjm.1
        for <ceph-devel@vger.kernel.org>; Wed, 27 Oct 2021 16:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qrV4WUd9VxV3Dh/i0y2i26P0alMkja/gC7fFHko/Z1k=;
        b=N1LMO8ML4DbGZi81U0BOrogy2sAFe1QdDg8IDlo+1e2zfBJ3M8rYt99JRRxy1u2K4f
         +Jff+y/tH+t+SmvpLgmbpNcVXZQwOmw/S6H+P0WWQc6TSMZu7wI2HO2gJXCzrH3Ftrmx
         1o+jGgp3wp+z+b3gcxZwXH6kNoU25LcLfein+SgpZgY53JA9yv26DmfcUGw5sdeNdN26
         jQW3NFpNhwDYSb6O11uvwUshSP7Iw2ggGnrzrEUmqr5+SPMdHUJDkCj5HST19oMrJx3N
         dm/Ju/wumyfbgCNK5T5i5MziC5p5WsOQhh+H9M0Zx9KBqSGBC6Zn7ngMqsp8eNsLKxL6
         TWgQ==
X-Gm-Message-State: AOAM532OwbdcUEwZYeWjF0DBp/NPIE0uDlGyS1qzysMbik2Y8DGsn8Lt
        vjhDNnzDyY2i2G7oyZVMC1VlItCbrm84QOUOKDKd9TntAEZzaPVl7RzIU+S+GvdO0pLkf+x/9Mq
        2CX8VNh5lmk3651ZfFeHrCqIbZO0+o5tfUYhozuiY1gmxIlwD4Skn0BbTdB/hnPn1gOSpHxc=
X-Received: by 2002:aa7:8718:0:b0:47b:f2ca:2e59 with SMTP id b24-20020aa78718000000b0047bf2ca2e59mr603047pfo.21.1635376108450;
        Wed, 27 Oct 2021 16:08:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEcsNy+/KMJCiM6PcWLTo+6cf28cNHGy8xMdlNO9PNXBBBjzQwrpphSNSWeb7YRG/sn1jbfg==
X-Received: by 2002:aa7:8718:0:b0:47b:f2ca:2e59 with SMTP id b24-20020aa78718000000b0047bf2ca2e59mr603004pfo.21.1635376108050;
        Wed, 27 Oct 2021 16:08:28 -0700 (PDT)
Received: from [10.72.12.20] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lr18sm5633240pjb.39.2021.10.27.16.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 16:08:27 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] ceph: add truncate size handling support for
 fscrypt
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20211020132813.543695-1-xiubli@redhat.com>
 <20211020132813.543695-5-xiubli@redhat.com>
 <d3ffc19d0b3f20a56d49428a486acfd9d6b22001.camel@kernel.org>
 <3a9971c2-916a-1d90-1f77-4bb5bd3befb2@redhat.com>
 <cb4ddb7a862dbb0b5f44c4c4a131adfc8c3f008c.camel@kernel.org>
 <YXlq95FB8sU493dr@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1707263a-2132-83dc-04f0-5cbdf91c6a2a@redhat.com>
Date:   Thu, 28 Oct 2021 07:08:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YXlq95FB8sU493dr@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/27/21 11:06 PM, Luís Henriques wrote:
> On Wed, Oct 27, 2021 at 08:17:55AM -0400, Jeff Layton wrote:
>> On Wed, 2021-10-27 at 13:12 +0800, Xiubo Li wrote:
>>> On 10/26/21 4:01 AM, Jeff Layton wrote:
>>>> On Wed, 2021-10-20 at 21:28 +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> This will transfer the encrypted last block contents to the MDS
>>>>> along with the truncate request only when new size is smaller and
>>>>> not aligned to the fscrypt BLOCK size.
>>>>>
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>    fs/ceph/caps.c  |   9 +--
>>>>>    fs/ceph/inode.c | 210 ++++++++++++++++++++++++++++++++++++++++++------
>>>>>    2 files changed, 190 insertions(+), 29 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>>> index 4e2a588465c5..1a36f0870d89 100644
>>>>> --- a/fs/ceph/caps.c
>>>>> +++ b/fs/ceph/caps.c
>>> ...
>>>>> +fill_last_block:
>>>>> +	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
>>>>> +	if (!pagelist)
>>>>> +		return -ENOMEM;
>>>>> +
>>>>> +	/* Insert the header first */
>>>>> +	header.ver = 1;
>>>>> +	header.compat = 1;
>>>>> +	/* sizeof(file_offset) + sizeof(block_size) + blen */
>>>>> +	header.data_len = cpu_to_le32(8 + 8 + CEPH_FSCRYPT_BLOCK_SIZE);
>>>>> +	header.file_offset = cpu_to_le64(orig_pos);
>>>>> +	if (fill_header_only) {
>>>>> +		header.file_offset = cpu_to_le64(0);
>>>>> +		header.block_size = cpu_to_le64(0);
>>>>> +	} else {
>>>>> +		header.file_offset = cpu_to_le64(orig_pos);
>>>>> +		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
>>>>> +	}
>>>>> +	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
>>>>> +	if (ret)
>>>>> +		goto out;
>>>>>
>>>>>
>>>> Note that you're doing a read/modify/write cycle, and you must ensure
>>>> that the object remains consistent between the read and write or you may
>>>> end up with data corruption. This means that you probably need to
>>>> transmit an object version as part of the write. See this patch in the
>>>> stack:
>>>>
>>>>       libceph: add CEPH_OSD_OP_ASSERT_VER support
>>>>
>>>> That op tells the OSD to stop processing the request if the version is
>>>> wrong.
>>>>
>>>> You'll want to grab the "ver" from the __ceph_sync_read call, and then
>>>> send that along with the updated last block. Then, when the MDS is
>>>> truncating, it can use a CEPH_OSD_OP_ASSERT_VER op with that version to
>>>> ensure that the object hasn't changed when doing it. If the assertion
>>>> trips, then the MDS should send back EAGAIN or something similar to the
>>>> client to tell it to retry.
>>>>
>>>> It's also possible (though I've never used it) to make an OSD request
>>>> assert that the contents of an extent haven't changed, so you could
>>>> instead send along the old contents along with the new ones, etc.
>>>>
>>>> That may end up being more efficient if the object is getting hammered
>>>> with I/O in other fscrypt blocks within the same object. It may be worth
>>>> exploring that avenue as well.
>>> Hi Jeff,
>>>
>>> One questions about this:
>>>
>>> Should we consider that the FSCRYPT BLOCK will cross two different Rados
>>> objects ? As default the Rados object size is 4MB.
>>>
>>> In case the FSCRYPT BLOCK size is 4K, when the object size is 3K or 5K ?
>>>
>>> Or the object size should always be multiple of FSCRYPT BLOCK size ?
>>>
>> The danger here is that it's very hard to ensure atomicity in RADOS
>> across two different objects. If your crypto blocks can span objects,
>> then you can end up with torn writes, and a torn write on a crypto block
>> turns it into garbage.
>>
>> So, I think we want to forbid:
>>
>> 1/ custom file layouts on encrypted files, to ensure that we don't end
>> up with weird object sizes. Luis' patch from August does this, but I
>> think we might want the MDS to also vet this.
>>
>> 2/ block sizes larger than the object size
> I believe that object sizes have a minimum of 65k, defined by
> CEPH_MIN_STRIPE_UNIT.

It's 64KB.

> So, maybe I'm oversimplifying, but I think we just
> need to ensure (a build-time check?) that
>
>    CEPH_FSCRYPT_BLOCK_SIZE <= CEPH_MIN_STRIPE_UNIT

I think you are right, and IMO this makes sense.

Thanks

-- Xiubo

> Cheers,
> --
> Luís
>
>> 3/ non-power-of-two crypto block sizes (so no 3k or 5k blocks, but you
>> could do 1k, 2k, 4k, 8k, etc...)
>>
>> ...with that we should be able to ensure that they never span objects.
>> Eventually we may be able to relax some of these constraints, but I
>> don't think most users will have a problem with these constraints.
>>
>> -- 
>> Jeff Layton <jlayton@kernel.org>
>>

