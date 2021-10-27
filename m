Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E25B43C210
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 07:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbhJ0FO7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 01:14:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236866AbhJ0FO6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 01:14:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635311553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9hVZJ6QtC8MznMnKUSnxynSv8iUt1gM1m5eHMiUX89E=;
        b=ZkIwQbUJtUN1+Eym3yGWmkxaTaRDIzLUSSvfxjHCU9Gi8qJ+5oQ+5sRzvzAWIkpB5nS5G2
        QiaC7gSGUxczh6T1nU5i8yQX8A/RW+ViAJNtVHjYcK9wQOdqKxVkd4hz2mEsaa+ZPtcMm6
        o/MA88k5uCvOlnb50u77GvRMJD7TDWo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-wal1o2lpM_q2oTQ1-jqOfQ-1; Wed, 27 Oct 2021 01:12:32 -0400
X-MC-Unique: wal1o2lpM_q2oTQ1-jqOfQ-1
Received: by mail-pf1-f197.google.com with SMTP id 134-20020a62198c000000b0047bf0981003so963602pfz.4
        for <ceph-devel@vger.kernel.org>; Tue, 26 Oct 2021 22:12:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9hVZJ6QtC8MznMnKUSnxynSv8iUt1gM1m5eHMiUX89E=;
        b=Y8E9kGig2gmRCHUENxXeMxC3TxeL/NzktcgyoMlVzK/oettubYWeP/FWgrxwp5Bllg
         Woas9XrLE5pgjzF8EO+isZ7ohK/32na141GTmsiqJRYDXcVd4NtWs9tK6C/mmdbS7IJQ
         N5hjGiM+J417t8VMGp2VAXd7sgZ0RiYrmgqz+d6B6HSt6tQSlUl3QZw2oSOz5Wda0UOL
         h6U467JBsxcKvdP73GxxGPy5OvLMjGMHDzuJqQi+Nojsf0Q7gWJijX/CQ0XVtAFZHixG
         LzkIff3wXZcO63/l5TIhnzxFj93ZVgicPW85J1PXc2wpycqYEk1RurEWH/9nZW4IIeUo
         GZEQ==
X-Gm-Message-State: AOAM531jik/pSCQbR1b2Xv6DjXkm1YQZ9kvBdwLcdqsv4lsoE6GflBjO
        MAH/CaDMDqqeDxkWDvlHXKumsX1+Y4wQVMd0tgfEKZOMMoWNvT4W8rpDWJ5rhIiiuH1j8WPcyg1
        uNs66xmWagVDrFSl92r3HXJOCGY8Hx5pZetmQZQ7iOg5lQwkheIiQSDB9jeXjqEJOXT6TiXU=
X-Received: by 2002:a17:90a:7893:: with SMTP id x19mr3428602pjk.197.1635311550649;
        Tue, 26 Oct 2021 22:12:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJxBhpKt5lhJimJpFzXCRp91yfe6JFqmSOF4HZJ22YmbDrS28W+31wgpGP/oGk+GkNGtmi3w==
X-Received: by 2002:a17:90a:7893:: with SMTP id x19mr3428558pjk.197.1635311550179;
        Tue, 26 Oct 2021 22:12:30 -0700 (PDT)
Received: from [10.72.12.93] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id lr3sm2823753pjb.3.2021.10.26.22.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 22:12:29 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] ceph: add truncate size handling support for
 fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20211020132813.543695-1-xiubli@redhat.com>
 <20211020132813.543695-5-xiubli@redhat.com>
 <d3ffc19d0b3f20a56d49428a486acfd9d6b22001.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3a9971c2-916a-1d90-1f77-4bb5bd3befb2@redhat.com>
Date:   Wed, 27 Oct 2021 13:12:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d3ffc19d0b3f20a56d49428a486acfd9d6b22001.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/26/21 4:01 AM, Jeff Layton wrote:
> On Wed, 2021-10-20 at 21:28 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will transfer the encrypted last block contents to the MDS
>> along with the truncate request only when new size is smaller and
>> not aligned to the fscrypt BLOCK size.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c  |   9 +--
>>   fs/ceph/inode.c | 210 ++++++++++++++++++++++++++++++++++++++++++------
>>   2 files changed, 190 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 4e2a588465c5..1a36f0870d89 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
...
>> +fill_last_block:
>> +	pagelist = ceph_pagelist_alloc(GFP_KERNEL);
>> +	if (!pagelist)
>> +		return -ENOMEM;
>> +
>> +	/* Insert the header first */
>> +	header.ver = 1;
>> +	header.compat = 1;
>> +	/* sizeof(file_offset) + sizeof(block_size) + blen */
>> +	header.data_len = cpu_to_le32(8 + 8 + CEPH_FSCRYPT_BLOCK_SIZE);
>> +	header.file_offset = cpu_to_le64(orig_pos);
>> +	if (fill_header_only) {
>> +		header.file_offset = cpu_to_le64(0);
>> +		header.block_size = cpu_to_le64(0);
>> +	} else {
>> +		header.file_offset = cpu_to_le64(orig_pos);
>> +		header.block_size = cpu_to_le64(CEPH_FSCRYPT_BLOCK_SIZE);
>> +	}
>> +	ret = ceph_pagelist_append(pagelist, &header, sizeof(header));
>> +	if (ret)
>> +		goto out;
>>
>>
> Note that you're doing a read/modify/write cycle, and you must ensure
> that the object remains consistent between the read and write or you may
> end up with data corruption. This means that you probably need to
> transmit an object version as part of the write. See this patch in the
> stack:
>
>      libceph: add CEPH_OSD_OP_ASSERT_VER support
>
> That op tells the OSD to stop processing the request if the version is
> wrong.
>
> You'll want to grab the "ver" from the __ceph_sync_read call, and then
> send that along with the updated last block. Then, when the MDS is
> truncating, it can use a CEPH_OSD_OP_ASSERT_VER op with that version to
> ensure that the object hasn't changed when doing it. If the assertion
> trips, then the MDS should send back EAGAIN or something similar to the
> client to tell it to retry.
>
> It's also possible (though I've never used it) to make an OSD request
> assert that the contents of an extent haven't changed, so you could
> instead send along the old contents along with the new ones, etc.
>
> That may end up being more efficient if the object is getting hammered
> with I/O in other fscrypt blocks within the same object. It may be worth
> exploring that avenue as well.

Hi Jeff,

One questions about this:

Should we consider that the FSCRYPT BLOCK will cross two different Rados 
objects ? As default the Rados object size is 4MB.

In case the FSCRYPT BLOCK size is 4K, when the object size is 3K or 5K ?

Or the object size should always be multiple of FSCRYPT BLOCK size ?


Thanks



