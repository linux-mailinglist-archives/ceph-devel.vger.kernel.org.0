Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39F844FD5D
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Nov 2021 04:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbhKODKk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 Nov 2021 22:10:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhKODK1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 22:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636945648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9a7hKfq0KSl2rpHY+qu7pAHDaiCCROnIsdyi5ILy9t0=;
        b=ALdHoZ7gdd8rGhfolBgBCOE3zBDa2V/7O+sGLwWomIHGaT/9ptdRAlvwq2aGMtFa9c5C+D
        cM/Tl6lfvVu41RWEidnKTro2SJzaSm2NHSpewnH79C/598ZfrGivlWwDvJokNvMA58V3fO
        sXMhI7AFDajIyg0UF8i8+a+awG+al4k=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-n2wcAx-dPwWOd1jKD0yRHg-1; Sun, 14 Nov 2021 22:07:27 -0500
X-MC-Unique: n2wcAx-dPwWOd1jKD0yRHg-1
Received: by mail-pg1-f198.google.com with SMTP id z5-20020a631905000000b002e79413f1caso413753pgl.8
        for <ceph-devel@vger.kernel.org>; Sun, 14 Nov 2021 19:07:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9a7hKfq0KSl2rpHY+qu7pAHDaiCCROnIsdyi5ILy9t0=;
        b=gPneiGiiHCIDO61ecUGHW6qUnW2szJbJogoE8SvEnxWh9UEF4bBQJuy8IvCxV2zQzv
         EW9ws+w5eBekb773N0JXKd8/6oB7+WxOduOTDb5WJ1qoDXfuvKYDL7FRh8g4UWoDMruH
         eIcfZeZ2TCiZTnpRncIikT9kgRSxiuTH3GFkxmZjmfdcKxM3CoaRIwkQSugzzUprTyBu
         ybGz18vQPUBVLWCXybnxWL4Mzrxff8waM4ZHGzNjosHqsk14W3JsuAYS23zGi6xnOTVR
         +JqbNmYxqR3UGQc7Sg7DqesorMKRlCg6wJgCd/Fft4A0DonuuFn6YNfJSX0U4daVn6cM
         pmxw==
X-Gm-Message-State: AOAM533l9YHY36sEw+23ewA52cmLKWiTxCgsPHr8x3Maqj8+ygK0qWUf
        keXdYvzd/8oxCmJA+vyPo97y9jnXkNcls2kDpSDmO8Kzu/DJRrSRT+9qvjdF8F6EE1g6X0vmIuo
        hBHPA5kdkRN48l0xpVe5moKtSQvScQj/q1cU29/NJar7plEd6zozT/ACvqG8HbxcQ5vbliC8=
X-Received: by 2002:a17:90a:4212:: with SMTP id o18mr42014592pjg.154.1636945646178;
        Sun, 14 Nov 2021 19:07:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfexHS12oC8O9mH6dbLmB2ynKrr5o3o6lFes+m7nXFUQ9NXZenpvOvEt2zo9GCre92zNxkiw==
X-Received: by 2002:a17:90a:4212:: with SMTP id o18mr42014538pjg.154.1636945645748;
        Sun, 14 Nov 2021 19:07:25 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z93sm10789153pjj.7.2021.11.14.19.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 19:07:25 -0800 (PST)
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211108135012.79941-1-xiubli@redhat.com>
 <79e1517f6197185e3aca6b0afa5b810c5b5e8a82.camel@kernel.org>
 <ec7b0b1e-85de-6a4a-a772-5e00dd787d69@redhat.com>
 <f2ecc2760733b0cdde950b6a21bbbb8e9fb15f29.camel@kernel.org>
 <ff4343cc402371813e40695cd556203df753bea0.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ef6cea38-d8dd-349b-c0dd-28a029dddb98@redhat.com>
Date:   Mon, 15 Nov 2021 11:07:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ff4343cc402371813e40695cd556203df753bea0.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/9/21 8:33 PM, Jeff Layton wrote:
> On Mon, 2021-11-08 at 20:57 -0500, Jeff Layton wrote:
>> On Tue, 2021-11-09 at 08:21 +0800, Xiubo Li wrote:
>>> On 11/9/21 2:36 AM, Jeff Layton wrote:
>>>> On Mon, 2021-11-08 at 21:50 +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> Hi Jeff,
>>>>>
>>>>> The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
>>>>> The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
>>>>>
>>>>> Thanks.
>>>>>
>>>>> Xiubo Li (2):
>>>>>     ceph: fix possible crash and data corrupt bugs
>>>>>     ceph: there is no need to round up the sizes when new size is 0
>>>>>
>>>>>    fs/ceph/inode.c | 8 +++++---
>>>>>    1 file changed, 5 insertions(+), 3 deletions(-)
>>>>>
>>>> I'm running xfstests today with the current state of wip-fscrypt-size
>>>> (including the two patches above) with test_dummy_encryption enabled.
>>>> generic/030 failed. The expected output of this part of the test was:
>>>>
>>>> wrote 5136912/5136912 bytes at offset 0
>>>> XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>>>> ==== Pre-Remount ===
>>>> 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
>>>>> XXXXXXXXXXXXXXXX|
>>>> *
>>>> 004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59
>>>>> YYYYYYYYYYYYYYYY|
>>>> *
>>>> 004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00
>>>>> YYYYYYYY........|
>>>> 004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>>>>> ................|
>>>> *
>>>> 004e7000
>>>> ==== Post-Remount ==
>>>> 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
>>>>> XXXXXXXXXXXXXXXX|
>>>> *
>>>> 004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59
>>>>> YYYYYYYYYYYYYYYY|
>>>> *
>>>> 004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00
>>>>> YYYYYYYY........|
>>>> 004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>>>>> ................|
>>>> *
>>>> 004e7000
>>>>
>>>> ...but I got this instead:
>>>>
>>>> wrote 5136912/5136912 bytes at offset 0
>>>> XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>>>> ==== Pre-Remount ===
>>>> 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
>>>>> XXXXXXXXXXXXXXXX|
>>>> *
>>>> 00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>>>>> ................|
>>>> *
>>>> 004e7000
>>>> ==== Post-Remount ==
>>>> 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
>>>>> XXXXXXXXXXXXXXXX|
>>>> *
>>>> 00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>>>>> ................|
>>>> *
>>>> 004e7000
>>>>
>>>>
>>>> ...I suspect this is related to the 075 failures, but I don't see it on
>>>> every attempt, which makes me think "race condition". I'll keep hunting.
>>> Yeah, seems the same issue.
>>>
>> I wonder if we're hitting the same problem that this patch was intended
>> to fix:
>>
>>      057ba5b24532 ceph: Fix race between hole punch and page fault
>>
>> It seems like the problem is very similar. It may be worth testing a
>> patch that takes the filemap_invalidate_lock across the on the wire
>> truncate and the vmtruncate.
>
> Nope. I tried a draft patch that make setattr hold this lock over the
> MDS call and the vmtruncate and it didn't help.
>
> Cheers,


This bug is very similar to the one I have fixed in:

        f4569b11c4eb ceph: return the real size read when it hits EOF

Which is for read case when truncating a file to a smaller size and then 
a bigger one immediately, the stale data will be kept.

Currently bug is in write case.

BRs

-- Xiubo

