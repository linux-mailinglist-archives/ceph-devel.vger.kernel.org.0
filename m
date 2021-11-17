Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E57453F6B
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Nov 2021 05:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhKQEWd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Nov 2021 23:22:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229632AbhKQEWd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 23:22:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637122774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lsKnXo1StB8mAXjxebSsyTKa5dLWWm50YDTGs+ajpo4=;
        b=XAYNkX1e/M+2sNobwmUVfBR1alyMzWbwCXmXg7U5at+8sSHAsrQrUekX0zQf32SIA1qN54
        WHwBWF3YvYUYgiS6sgj3uGfB1xzUmXz+U4BbYnsEky3uft92gVtRkTX66DLEGr/mUaGYeO
        KV8zUfbkt8n2I037m3/Jzcky6SeeCF4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-u-fF2enZOhGQrxP-uO-0Gg-1; Tue, 16 Nov 2021 23:19:33 -0500
X-MC-Unique: u-fF2enZOhGQrxP-uO-0Gg-1
Received: by mail-pj1-f69.google.com with SMTP id x18-20020a17090a789200b001a7317f995cso2410145pjk.4
        for <ceph-devel@vger.kernel.org>; Tue, 16 Nov 2021 20:19:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lsKnXo1StB8mAXjxebSsyTKa5dLWWm50YDTGs+ajpo4=;
        b=iLQ1bLU4jPDRBZs0FVTXBOcnHSr9Pk31WGzWCgphlY7iywNxbHZBTLEz4zXqWDgP8s
         DOofsdwm/SISID85PeG/ZN7ZSSpB3D98MZOnLLFWkE5x93CZi5Y5dbjNDKCfehCFI7Yj
         tG/P6YXaKfYqexyX9n23qxsIMkp/bA8g3UXu3cQzCKAzWafILeUiRzH2SnTMu7aHs573
         QLNjI7KTmDubZHvHtB8/aB3/z+eU1UL02WkKTuABlezppIs9RVdbOxXiB4JqdSvbmIRg
         ARarngZiJvOBwYqOcKDeRRrcwBJ29V27dGxoVFuBNydN4otlQjJ2gM1w1WD6Xe4VTd4U
         acwQ==
X-Gm-Message-State: AOAM531EZUYJovuazqWmHs7uJxQj8hXHWLLY90aVz8hlOSUq8EZNknZh
        5CSga5J5hYFmyFLhIFC3gmNLuG0+oFj853jl/9vAc1rSQQYfP7ebmhVu2HgoWel8eOa0HaRgLVB
        iExvbZrpHQO1YpzOSbYsI/blk0xqEchYqRL6JoB7P9hdikqCyGTX3tbEiCbth40JxI3eerFY=
X-Received: by 2002:a63:6909:: with SMTP id e9mr3208494pgc.7.1637122771969;
        Tue, 16 Nov 2021 20:19:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxyXAURTgpJr8M6xuRipwbP2aXirLL4WPdQzBWfEuIqcMcAQ+SljBxG+IOaOEl75SbccImucA==
X-Received: by 2002:a63:6909:: with SMTP id e9mr3208458pgc.7.1637122771554;
        Tue, 16 Nov 2021 20:19:31 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mg17sm3556946pjb.17.2021.11.16.20.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 20:19:31 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
To:     "Yan, Zheng" <ukernel@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20211116092002.99439-1-xiubli@redhat.com>
 <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
 <CAAM7YAm6iovKdptjiZhgjm8kwrOeUyBYG3z82+Updrkrd-QMOA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <dc6b86a3-776c-6f51-8187-b7cd02d20355@redhat.com>
Date:   Wed, 17 Nov 2021 12:19:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YAm6iovKdptjiZhgjm8kwrOeUyBYG3z82+Updrkrd-QMOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/17/21 10:47 AM, Yan, Zheng wrote:
> On Wed, Nov 17, 2021 at 4:13 AM Jeff Layton <jlayton@kernel.org> wrote:
>> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> In case truncating a file to a smaller sizeA, the sizeA will be kept
>>> in truncate_size. And if truncate the file to a bigger sizeB, the
>>> MDS will only increase the truncate_seq, but still using the sizeA as
>>> the truncate_size.
>>>
>> Do you mean "kept in ci->i_truncate_size" ? If so, is this really the
>> correct fix? I'll note this in the sources:
>>
>>          u32 i_truncate_seq;        /* last truncate to smaller size */
>>          u64 i_truncate_size;       /*  and the size we last truncated down to */
>>
>> Maybe the MDS ought not bump the truncate_seq unless it was truncating
>> to a smaller size? If not, then that comment seems wrong at least.
>>
> mds does not change truncate_{seq,size} when truncating file to bigger size
>
Yeah, right.

It was introduced by the fscrypt support related patch.

BRs

-- Xiubo


>>> So when filling the inode it will truncate the pagecache by using
>>> truncate_sizeA again, which makes no sense and will trim the inocent
>>> pages.
>>>
>> Is there a reproducer for this? It would be nice to put something in
>> xfstests for it if so.
>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/inode.c | 5 +++--
>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>> index 1b4ce453d397..b4f784684e64 100644
>>> --- a/fs/ceph/inode.c
>>> +++ b/fs/ceph/inode.c
>>> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>>>                         * don't hold those caps, then we need to check whether
>>>                         * the file is either opened or mmaped
>>>                         */
>>> -                     if ((issued & (CEPH_CAP_FILE_CACHE|
>>> +                     if (ci->i_truncate_size != truncate_size &&
>>> +                         ((issued & (CEPH_CAP_FILE_CACHE|
>>>                                       CEPH_CAP_FILE_BUFFER)) ||
>>>                            mapping_mapped(inode->i_mapping) ||
>>> -                         __ceph_is_file_opened(ci)) {
>>> +                         __ceph_is_file_opened(ci))) {
>>>                                ci->i_truncate_pending++;
>>>                                queue_trunc = 1;
>>>                        }
>> --
>> Jeff Layton <jlayton@kernel.org>

