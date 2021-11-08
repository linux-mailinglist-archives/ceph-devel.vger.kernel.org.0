Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890AC448207
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 15:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbhKHOrj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 09:47:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239800AbhKHOri (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 09:47:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636382694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kFtNfM1qnhTtqBpjNoJNbZFQMqC5JiDfAocYImJp/Uc=;
        b=WTL78ZszB7VVLaJrXU6yJ6V4rWGzgGe0FYs9GIlPLmjBFqGDy517cA6zyMZpLSPvIByBXf
        Q/rB9j0LPKy159KFmh7uERHOt72j7MqCaFCUshkpJrH3vJ4Gs3x4PhIOZ+FFpwPqw14VLr
        kCHQaGFcoKkaH+oquwUcSliCyMYFRfE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-VOESUJZcOlO_-QbOmScNuw-1; Mon, 08 Nov 2021 09:44:52 -0500
X-MC-Unique: VOESUJZcOlO_-QbOmScNuw-1
Received: by mail-pg1-f200.google.com with SMTP id p13-20020a63c14d000000b002da483902b1so2068217pgi.12
        for <ceph-devel@vger.kernel.org>; Mon, 08 Nov 2021 06:44:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kFtNfM1qnhTtqBpjNoJNbZFQMqC5JiDfAocYImJp/Uc=;
        b=HE4eJsghkTnguo1arj1bv88zMaV29TNpJ5tEFqShJRTznZCEFyyIJfTTWXRGgHFd3c
         wthKvQzTf2IuArI9YIUDyxcv4R6zLS+vxoyKpw8eKwKMwe3OslkanbL2x5NB+myrc9gC
         bWkTZgCgOgQy0vJsl2NQrF9Iux8vyyTnJ6NRiswx3xxLVQ16n7hZRYlQu5GaC957ZGF+
         0l73lfhgsP+i1DBamTBGWH9Dwhvslc7ZBVsXGbEWYi0+QvKJm5Ntz5A9vRsHfGnmsuDh
         sRqwl+g4kaxvyjOY3OlN4RPppL6FsulkwshmEqO/JWiqxPgNb75MKXkdF9BT9X5lzRr5
         biiA==
X-Gm-Message-State: AOAM5321es9G4XDk3Ps5PiWhV+C2/LFi5MA3EKSuH6yHoNG6jsgVj/a6
        /t6r4yaKGlkqMf6Ao4t/AZVMX8N2jjx4pE0cQLchb0D+7wxGB5jcCh4ToPSDDNZObpgWBXl+UK/
        0WyVYLu5vJoeLGHcJ+7DnqI80d+sfuHy+WaHfWAOk+ViKBpiSkQv7bnnauNf8YgTMU/cQwYY=
X-Received: by 2002:a17:903:230b:b0:141:e3ce:2738 with SMTP id d11-20020a170903230b00b00141e3ce2738mr94874plh.57.1636382690837;
        Mon, 08 Nov 2021 06:44:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxrd882OOyVeojfuv9xxtnFhMQqG4DD7zh2kDiCUUL7jnt1vWECx3qMmmULOOp46QoH3f7wWQ==
X-Received: by 2002:a17:903:230b:b0:141:e3ce:2738 with SMTP id d11-20020a170903230b00b00141e3ce2738mr94814plh.57.1636382690128;
        Mon, 08 Nov 2021 06:44:50 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mi3sm14389425pjb.35.2021.11.08.06.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 06:44:49 -0800 (PST)
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211108135012.79941-1-xiubli@redhat.com>
 <25c8bbac-99c1-66a9-cb79-96eb0213c702@redhat.com>
 <b4ce8eecc10c0796f233d42c5a92d2dead4a5f85.camel@kernel.org>
 <8569597c-4b56-07e2-6fbe-ce5d42ecb720@redhat.com>
Message-ID: <9616949b-5778-9468-cccb-43a57303d3d3@redhat.com>
Date:   Mon, 8 Nov 2021 22:44:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8569597c-4b56-07e2-6fbe-ce5d42ecb720@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/8/21 10:41 PM, Xiubo Li wrote:
>
> On 11/8/21 10:26 PM, Jeff Layton wrote:
>> On Mon, 2021-11-08 at 22:10 +0800, Xiubo Li wrote:
>>> Hi Jeff,
>>>
>>> After this fixing, there still has one bug and I am still looking at 
>>> it:
>>>
>>> [root@lxbceph1 xfstests]# ./check generic/075
>>> FSTYP         -- ceph
>>> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0-rc6+
>>>
>>> generic/075     [failed, exit status 1] - output mismatch (see
>>> /mnt/kcephfs/xfstests/results//generic/075.out.bad)
>>>       --- tests/generic/075.out    2021-11-08 20:54:07.456980801 +0800
>>>       +++ /mnt/kcephfs/xfstests/results//generic/075.out.bad 2021-11-08
>>> 21:20:49.741906997 +0800
>>>       @@ -12,7 +12,4 @@
>>>        -----------------------------------------------
>>>        fsx.2 : -d -N numops -l filelen -S 0
>>>        -----------------------------------------------
>>>       -
>>>       ------------------------------------------------
>>>       -fsx.3 : -d -N numops -l filelen -S 0 -x
>>>       ------------------------------------------------
>>>       ...
>>>       (Run 'diff -u tests/generic/075.out
>>> /mnt/kcephfs/xfstests/results//generic/075.out.bad'  to see the 
>>> entire diff)
>>> Ran: generic/075
>>> Failures: generic/075
>>> Failed 1 of 1 tests
>>>
>>>
>>> I checked the result outputs, it seems when truncating the size to a
>>> smaller sizeA and then to a bigger sizeB again, in theory those 
>>> contents
>>> between sizeA and sizeB should be zeroed, but it didn't.
>>>
>>> The last block updating is correct.
>>>
>>> Any idea ?
>>>
>>
>> Yep, that's the one I saw (intermittently) too. I also saw some failures
>> around generic/029 and generic/030 that may be related. I haven't dug
>> down as far into the problem as you have though.
>>
>> The nice thing about fsx is that it gives you a lot of info about what
>> it does. There is also a way to replay a series of ops too, so you may
>> want to try to see if you can make a reliable reproducer for this
>> problem.
>
> I can reproduce this every time.
>
>
>> Are these truncates running concurrently in different tasks?
>
> No, from the "075.2.fsxlog" they are serialized. The truncates 
> themselves worked well, but there also have some 
> mapwrite/write/mapread/read between them. From the logs, I am sure 
> that those none zeroed contents are from mapwrite/write. It seems the 
> dirty pages are flushed to OSDs just after the truncates.
>
>
>>   If so, then
>> we may need some mechanism to ensure that they are serialized vs. one
>> another.
>
> The truncate will hold the 'inode->i_rwsem' lock too, so it won't 
> allow the truncate/read/write to run in parallel. But I am not sure 
> the mapwrite ?
>
>
The logs segments from "075.2.fsxlog":

2317 3728 mapread    0x330312 thru   0x33a6b1        (0xa3a0 bytes)
2318 3730 punch      from 0x5ffc53 to 0x608516, (0x88c3 bytes)
2319 3731 write      0x6e9465 thru   0x6f8c04        (0xf7a0 bytes)
2320 3732 mapread    0x49f516 thru   0x49f570        (0x5b bytes)
2321 3733 write      0x72847b thru   0x733f14        (0xba9a bytes)
2322 3736 punch      from 0x2a90a0 to 0x2aa68e, (0x15ee bytes)
2323 3739 write      0x644a24 thru   0x64aa30        (0x600d bytes)
2324 3740 trunc      from 0x7aa4b0 to 0x9dbef3
2325 3741 mapread    0x5aa6bd thru   0x5b7246        (0xcb8a bytes)
2326 3742 trunc      from 0x9dbef3 to 0x718ae4
2327 3743 write      0x3ac9b0 thru   0x3aeee0        (0x2531 bytes)
2328 3744 read       0x6e171c thru   0x6f0fd6        (0xf8bb bytes)
2329 3747 trunc      from 0x718ae4 to 0x627ddb
2330 3748 mapread    0xe4e2c thru    0xf0bd5 (0xbdaa bytes)
2331 3752 write      0x71def1 thru   0x71e152        (0x262 bytes)
2332 3753 mapwrite   0x9eb0d8 thru   0x9f4ef7        (0x9e20 bytes)
2333 3754 mapwrite   0x7db56d thru   0x7e1278        (0x5d0c bytes)
2334 3755 punch      from 0x9368cb to 0x9437fb, (0xcf30 bytes)
2335 3757 write      0x366827 thru   0x3699ff        (0x31d9 bytes)
2336 3761 mapwrite   0x529471 thru   0x52b085        (0x1c15 bytes)
2337 3762 trunc      from 0x9f4ef8 to 0x86bfab
2338 3764 write      0x9c85b9 thru   0x9d0bdc        (0x8624 bytes)
2339 3765 mapread    0x11b451 thru   0x11fec5        (0x4a75 bytes)
2340 3766 write      0x5938cb thru   0x59e0d0        (0xa806 bytes)
2341 3767 read       0xe3063 thru    0xe8ee7 (0x5e85 bytes)
2342 3768 punch      from 0x859f3f to 0x8698ec, (0xf9ad bytes)
2343 3771 punch      from 0x86d188 to 0x86eef3, (0x1d6b bytes)
2344 3773 write      0x9f43c9 thru   0x9fffff        (0xbc37 bytes)
2345 3774 trunc      from 0xa00000 to 0x26d4b9
2346 3777 trunc      from 0x26d4b9 to 0x9c695f
2347 3783 trunc      from 0x9c695f to 0x9129ed
2348 3784 mapread    0x448402 thru   0x45074d        (0x834c bytes)
2349 READ BAD DATA: offset = 0x448402, size = 0x834c, fname = 075.2
2350 OFFSET  GOOD    BAD     RANGE
2351 0x448402        0x0000  0x74ea  0x00000
2352 operation# (mod 256) for the bad data may be 116
2353 0x448403        0x0000  0xea74  0x00001
2354 operation# (mod 256) for the bad data may be 116



>>
>>> On 11/8/21 9:50 PM, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Hi Jeff,
>>>>
>>>> The #1 could be squashed to the previous "ceph: add truncate size 
>>>> handling support for fscrypt" commit.
>>>> The #2 could be squashed to the previous "ceph: fscrypt_file field 
>>>> handling in MClientRequest messages" commit.
>>>>
>>>> Thanks.
>>>>
>>>> Xiubo Li (2):
>>>>     ceph: fix possible crash and data corrupt bugs
>>>>     ceph: there is no need to round up the sizes when new size is 0
>>>>
>>>>    fs/ceph/inode.c | 8 +++++---
>>>>    1 file changed, 5 insertions(+), 3 deletions(-)
>>>>

