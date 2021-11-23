Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F475459D78
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Nov 2021 09:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhKWIKS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Nov 2021 03:10:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234199AbhKWIKR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 03:10:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637654829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IP8IFfd6uHk5JjGco//e91lqfuJOlcSCE1K+RKB3iPw=;
        b=b4rUuJ0W7FC5yepJXWXHfcP0b5tM7l81VBo06+D7k9E1Z7q7gfPj7X9qDNbUU2v+8JRaig
        kUhg5dUWmxJQoXF04fxllEGTt2p18+f7/lJUsSFUBQBDFt0M8cXhJvNraVKr3D/M76NKNy
        80XFLGjdl4czsOb8EzmPRwVcwGtLdHc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-420-3Mo7ReMlOYyxSI8ua3m30g-1; Tue, 23 Nov 2021 03:06:37 -0500
X-MC-Unique: 3Mo7ReMlOYyxSI8ua3m30g-1
Received: by mail-pf1-f199.google.com with SMTP id c21-20020a62e815000000b004a29ebf0aa7so11321653pfi.2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Nov 2021 00:06:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IP8IFfd6uHk5JjGco//e91lqfuJOlcSCE1K+RKB3iPw=;
        b=dySTly8+NZzsHfVPy8cYnb6Iko0UUbtcDoJ3pfFTN8jC0dEUNfFS9wSfPn/n3o8Rkw
         BalWFGcZ7T1Vp7KHhG1RYOv1tGq0KJ8E64+uJOLWHQId2JpRJJJDusQBqtnapZH+TDMx
         GXF3EoTtrcA7Z31AwBePVJiIZcQXy8TnrGUC5RplhMVmeah4Aeg+xZ4vcvDsyN8xTR9E
         GJl1S86/QW2QQBI6KdM6I9HEF1F1qoj+d1RWX7T96PdIGOX+IYG30CEzgHY6f01xPdvQ
         cTJkBAPsRTmlo4ceg69qBHFkbyPZX/LO4XRnI5lYXI2mPzpUtcPV77QIi5q5dq7b9JlU
         bvBA==
X-Gm-Message-State: AOAM5328r8UKLkXAlfzCSuWPYkAqFNaVs+fUVRgYzC/x37UXoN9Opf74
        w7B8Xl3P7Q0lb+4S8bAg/QcqzwVeRsnW3z2xUAKTwD1qIbeVGt4Z5aXj5eSDZvTbVfaw/yNSWBs
        jejk5R2Vau8+v+ZRGLYQsbMs47YFavoWkXdul6UsLs5Oijwe09Dux77cUFqDd8loVLAJawUA=
X-Received: by 2002:a63:bf4a:: with SMTP id i10mr2518688pgo.196.1637654795702;
        Tue, 23 Nov 2021 00:06:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjZXnTcY56h8HSUyBtrFc2CdmjAt28XflgC7HD/8Q/+8TdhGC/UuUufSYBzTb38K6A51w4ng==
X-Received: by 2002:a63:bf4a:: with SMTP id i10mr2518649pgo.196.1637654795238;
        Tue, 23 Nov 2021 00:06:35 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v19sm353509pju.32.2021.11.23.00.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 00:06:34 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <09babbaf077a76ace4793f2e6ae6127d2e7d6411.camel@kernel.org>
 <1a6b7a20-ba30-0b57-3927-2b61ad64be28@redhat.com>
 <119f590bf2c576fff3ecf44295c7e7bbfcfeb3d8.camel@kernel.org>
 <fe9ce707-3118-a388-bbd4-50d80e957a89@redhat.com>
 <1fedf47381473c01c58cc7ea56e81e176ac7bd73.camel@kernel.org>
 <bfd6b13b-efdc-6362-de9d-92a243f5b166@redhat.com>
Message-ID: <3e08e0d6-5ab8-d6b1-7ee8-86b14dec7c89@redhat.com>
Date:   Tue, 23 Nov 2021 16:06:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <bfd6b13b-efdc-6362-de9d-92a243f5b166@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/23/21 9:00 AM, Xiubo Li wrote:
>
> On 11/23/21 3:10 AM, Jeff Layton wrote:
[...]
>> One thing I'm finding today is that this patch reliably makes
>> generic/445 hang at umount time with -o test_dummy_encryption
>> enabled...which is a bit strange as the test doesn't actually run:
>>
>>      [jlayton@client1 xfstests-dev]$ sudo ./tests/generic/445
>>      QA output created by 445
>>      445 not run: xfs_io falloc  failed (old kernel/wrong fs?)
>>      [jlayton@client1 xfstests-dev]$ sudo umount /mnt/test
>>
>> ...and the umount hangs waiting for writeback to complete. When I back
>> this patch out, the problem goes away. Are you able to reproduce this?
>>
>> There are no mds or osd calls in flight, and no caps (according to
>> debugfs). This is using -o test_dummy_encryption to force encryption.
>
> I have hit a same issue without the "test_dummy_encryption", and it 
> got stuck but I didn't see any call to ceph. But not the 445, I 
> couldn't remember which one, I thought it was something wrong with my 
> OS, I just rebooted my VM.
>
> # ps -aux | grep generic
>
> root      564385  0.0  0.0  11804  4700 pts/1    S+   09:41 0:00 
> /bin/bash ./tests/generic/318
>
> # cat /proc/564385/stack
>
> [<0>] do_wait+0x2cc/0x4e0
> [<0>] kernel_wait4+0xec/0x1b0
> [<0>] __do_sys_wait4+0xe0/0xf0
> [<0>] do_syscall_64+0x37/0x80
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
I have hit this again today, I found that the MDS daemon crashed, and 
when the standby MDSes were replaying the journal log they crashed too.

I think this should be the reason why they stuck. I will check it.

-- Xiubo


> I ran the ceph.exlude tests for two days, I just saw this one time.
>
> I have attached the test results, does it the same with yours ? There 
> have many test cases didn't run.
>
> There have 4 failures and for the generic/020 it will be reproducable 
> by 30%. All the other 3 failures are every time, but they all seems 
> not relevant to fscrypt.
>
>
>> I narrowed it down to the call to _require_seek_data_hole. That calls
>> the seek_sanity_test binary and after that point, umounting the fs
>> hangs. I've not yet been successful at reproducing this while running
>> the binary by hand, so there may be some other preliminary ops that are
>> a factor too.
>>
>> In any case, this looks like a regression, so I'm going to drop this
>> patch for now. I'll keep poking at the problem too however.

