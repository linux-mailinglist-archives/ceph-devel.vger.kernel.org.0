Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C17E45294C
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Nov 2021 05:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbhKPE7u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 15 Nov 2021 23:59:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232972AbhKPE7s (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 23:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637038611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFFkVBReW9/cFy15bK2kiplDHjEnlvVxpxggjEtm6FQ=;
        b=GJgRjXuhbFn0K9WuPZ/uh/yw0rhNCMQ5ttWPu7wMApw12RotNQnmnIjXth99Bs/aFe8SC3
        +zA64+2XR9P/WATCKwJU+wLxC91fgkrTSaSuCjxD3mqfpx0wHchQpC4rWTEkW0kdoysAJr
        ZybmXnckJ+WOtuzuVxJ+xC7qmykKEPk=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-e1V0c_GmPxaPqIy0h1bKXA-1; Mon, 15 Nov 2021 23:56:50 -0500
X-MC-Unique: e1V0c_GmPxaPqIy0h1bKXA-1
Received: by mail-pg1-f198.google.com with SMTP id i25-20020a631319000000b002cce0a43e94so10191234pgl.0
        for <ceph-devel@vger.kernel.org>; Mon, 15 Nov 2021 20:56:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DFFkVBReW9/cFy15bK2kiplDHjEnlvVxpxggjEtm6FQ=;
        b=cNiCZdBPFAxC2pNODgFmyRgyA1ooqhpplspAAYFlz3K+9BS060ZUpEdWBqo68OGbmU
         BtPgjwbuHhJVvRQ1zpykmdrOpb3/bFxeIqjQ64xYj5J6ndvPJYYyg/P7lq1xKuJZmCAV
         8lUn1Np4IZqv/lxzCZsANzGjngamzoRwKkSRQSDd6iBxsCWLxnWu4x6Ar/4hqD+pSKnJ
         r78gpN0uuk0IaCCkMbTJTA7lwn7VhND0++CCEfnSsTSopAIHS4Z+RUv5f+1IvN3gcD+u
         zff87EQvtrThhVniEWZ/pAsnIsmplVisb62yp945IiDZ4yl1iS+5Oz8WuQaDQEliS0pu
         8g3g==
X-Gm-Message-State: AOAM532H+snjmzBUv4wW3+AM7lRWBPYRMtDQBTo2xsuJT99n/UYrV5dQ
        chEdS3IP6Cw7VvKKutsNAyZLnXKK2wapUced6waMcqBJ+2G6n2RjIRUiTY/9nLVdJx5XelcDUU1
        ljY/qhc8youTe6wXsyseKpIB2BOWwbF6gOKxGw9QiNVTsY3PElFetEXxiQ4qJPUeaIXGs30k=
X-Received: by 2002:aa7:8dc6:0:b0:49f:c66e:2d55 with SMTP id j6-20020aa78dc6000000b0049fc66e2d55mr38115996pfr.81.1637038608432;
        Mon, 15 Nov 2021 20:56:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8cEO/sc00+1P40zFO9fZTp9VIisOA5BQEk3AEdPo6gWtNn7hUJjCkNu/wKpgynTdzyzrf1Q==
X-Received: by 2002:aa7:8dc6:0:b0:49f:c66e:2d55 with SMTP id j6-20020aa78dc6000000b0049fc66e2d55mr38115962pfr.81.1637038608000;
        Mon, 15 Nov 2021 20:56:48 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f15sm18872002pfe.171.2021.11.15.20.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 20:56:47 -0800 (PST)
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
Message-ID: <a0a9f6f4-5c49-b072-8161-5d085ab97b89@redhat.com>
Date:   Tue, 16 Nov 2021 12:56:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ff4343cc402371813e40695cd556203df753bea0.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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

It's buggy by using the `filer.write_trunc()` caller in MDS side, it 
works well in case the truncate_from - truncate_size < 4MB, or it will 
keep the stale file contents without trimming or zeroing them.

I will push the MDS side PR to fix it.

Thanks

-- Xiubo


> Cheers,

