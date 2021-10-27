Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9695D43CB56
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 15:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242311AbhJ0OAb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 10:00:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242333AbhJ0OA0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 10:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635343080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r8GXY/i8AoKMZPXv+QbWCOb1l7JnYIt6VXM89k7JwfQ=;
        b=O7Lnc/ujay58cpP/upj1BxKhRSTDxwqv26+m8GH/h0m9TYNZ6XFsHGfUONVHKNn/noZfOd
        JWGV7zeJulFU36SrJroLryV2ypDnqpMG5qNZK72ipNJVZlQEvYoSe99mWPwyeDAN131+4L
        9K97umwPYYfSm3naGki+8+W9mVVoMZk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-bGx2sQ_lO9CObcIroQJ3_g-1; Wed, 27 Oct 2021 09:57:59 -0400
X-MC-Unique: bGx2sQ_lO9CObcIroQJ3_g-1
Received: by mail-pl1-f199.google.com with SMTP id k18-20020a170902c41200b0013f24806d35so1282161plk.1
        for <ceph-devel@vger.kernel.org>; Wed, 27 Oct 2021 06:57:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=r8GXY/i8AoKMZPXv+QbWCOb1l7JnYIt6VXM89k7JwfQ=;
        b=do8et89m/zjsWFgZVfaqizGfR9h/ZaZb9ADGSimx4lEdPMEqOkl8HxXOV5QUolvbnX
         0clan1AAs6ii4Bw828hi7f+0eyIOpqxgsnCGWH/QmBeINOv4sQ8FF82knTNqoWG/xy6Q
         8CB7YzVXevCcKLNb1wVoYuiG/li0kF7MTFyNoQAASQ13ROyiL0z4PIgjn/mQSDmRXkHs
         nJYB10t8vR+dMb3Y+t9urQOm3ulVunRMb4CSSxeMnjB25CVJBGvpWFQQgEWmznfXYL8f
         HtZOjOdGC4K3+w5WZvRuvCJjSBHUcnhJZgIkJy78PjDITNMca/cTLaCVCyfcRAqbMSRG
         FAdw==
X-Gm-Message-State: AOAM530gprsUsKrEqozdylPPB7+VIUR7oeSI+hrN/X9qwxb/QL/iqF8f
        tNuD5BBWPnpHmGkzqcyRp7dOtrIcVXmJJluJbdicW2TBXOGBixlWAD3ZQZgICeTqrqneRQsHyjk
        vnhkVTGhmmgHXfIOZCjTWkg==
X-Received: by 2002:a62:e51a:0:b0:44d:67bd:53ab with SMTP id n26-20020a62e51a000000b0044d67bd53abmr32916590pff.86.1635343078509;
        Wed, 27 Oct 2021 06:57:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMMIWCR5aX7fumLWjF4a6rJhvOuvjLc9EOYkROKCv3xOMNVnuuj90PGLtTcPQG9tWbmS3x+g==
X-Received: by 2002:a62:e51a:0:b0:44d:67bd:53ab with SMTP id n26-20020a62e51a000000b0044d67bd53abmr32916559pff.86.1635343078215;
        Wed, 27 Oct 2021 06:57:58 -0700 (PDT)
Received: from [10.72.12.118] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k19sm66628pff.195.2021.10.27.06.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 06:57:57 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] ceph: add truncate size handling support for
 fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
References: <20211020132813.543695-1-xiubli@redhat.com>
 <20211020132813.543695-5-xiubli@redhat.com>
 <d3ffc19d0b3f20a56d49428a486acfd9d6b22001.camel@kernel.org>
 <3a9971c2-916a-1d90-1f77-4bb5bd3befb2@redhat.com>
 <cb4ddb7a862dbb0b5f44c4c4a131adfc8c3f008c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <67789de3-8c2f-4254-e563-7f27e957a84f@redhat.com>
Date:   Wed, 27 Oct 2021 21:57:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cb4ddb7a862dbb0b5f44c4c4a131adfc8c3f008c.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/27/21 8:17 PM, Jeff Layton wrote:
> On Wed, 2021-10-27 at 13:12 +0800, Xiubo Li wrote:
>> On 10/26/21 4:01 AM, Jeff Layton wrote:
>>> On Wed, 2021-10-20 at 21:28 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This will transfer the encrypted last block contents to the MDS
>>>> along with the truncate request only when new size is smaller and
>>>> not aligned to the fscrypt BLOCK size.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c  |   9 +--
>>>>    fs/ceph/inode.c | 210 ++++++++++++++++++++++++++++++++++++++++++------
>>>>    2 files changed, 190 insertions(+), 29 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 4e2a588465c5..1a36f0870d89 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>> ...
>>>> +fill_last_block:
>>>> +	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
>>>> +	if (!pagelist)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	/* Insert the header first */
>>>> +	header.ver = 1;
>>>> +	header.compat = 1;
>>>> +	/* sizeof(file_offset) + sizeof(block_size) + blen */
>>>> +	header.data_len = cpu_to_le32(8 + 8 + CEPH_FSCRYPT_BLOCK_SIZE);
>>>> +	header.file_offset = cpu_to_le64(orig_pos);
>>>> +	if (fill_header_only) {
>>>> +		header.file_offset = cpu_to_le64(0);
>>>> +		header.block_size = cpu_to_le64(0);
>>>> +	} else {
>>>> +		header.file_offset = cpu_to_le64(orig_pos);
>>>> +		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
>>>> +	}
>>>> +	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
>>>> +	if (ret)
>>>> +		goto out;
>>>>
>>>>
>>> Note that you're doing a read/modify/write cycle, and you must ensure
>>> that the object remains consistent between the read and write or you may
>>> end up with data corruption. This means that you probably need to
>>> transmit an object version as part of the write. See this patch in the
>>> stack:
>>>
>>>       libceph: add CEPH_OSD_OP_ASSERT_VER support
>>>
>>> That op tells the OSD to stop processing the request if the version is
>>> wrong.
>>>
>>> You'll want to grab the "ver" from the __ceph_sync_read call, and then
>>> send that along with the updated last block. Then, when the MDS is
>>> truncating, it can use a CEPH_OSD_OP_ASSERT_VER op with that version to
>>> ensure that the object hasn't changed when doing it. If the assertion
>>> trips, then the MDS should send back EAGAIN or something similar to the
>>> client to tell it to retry.
>>>
>>> It's also possible (though I've never used it) to make an OSD request
>>> assert that the contents of an extent haven't changed, so you could
>>> instead send along the old contents along with the new ones, etc.
>>>
>>> That may end up being more efficient if the object is getting hammered
>>> with I/O in other fscrypt blocks within the same object. It may be worth
>>> exploring that avenue as well.
>> Hi Jeff,
>>
>> One questions about this:
>>
>> Should we consider that the FSCRYPT BLOCK will cross two different Rados
>> objects ? As default the Rados object size is 4MB.
>>
>> In case the FSCRYPT BLOCK size is 4K, when the object size is 3K or 5K ?
>>
>> Or the object size should always be multiple of FSCRYPT BLOCK size ?
>>
> The danger here is that it's very hard to ensure atomicity in RADOS
> across two different objects. If your crypto blocks can span objects,
> then you can end up with torn writes, and a torn write on a crypto block
> turns it into garbage.
>
> So, I think we want to forbid:
>
> 1/ custom file layouts on encrypted files, to ensure that we don't end
> up with weird object sizes. Luis' patch from August does this, but I
> think we might want the MDS to also vet this.
>
> 2/ block sizes larger than the object size
>
> 3/ non-power-of-two crypto block sizes (so no 3k or 5k blocks, but you
> could do 1k, 2k, 4k, 8k, etc...)
>
> ...with that we should be able to ensure that they never span objects.
> Eventually we may be able to relax some of these constraints, but I
> don't think most users will have a problem with these constraints.

Yeah, this sounds reasonable. I will code based on these assumptions.

Thanks.

