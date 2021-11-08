Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130FE4481B9
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 15:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbhKHOa3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 09:30:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239426AbhKHOa2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 09:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636381663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8JLwhbnRVCBq0k5xiIzljuagPYVl4vnVGGyUCfpPJw=;
        b=Fc/pBqnv5a0x3xGk6Uc7nYF4yLsGg1yrJc8v+kJ1mG0+iar4Z7ltx/SznQzCVqiQlZOGL2
        hNBWyg+ir0goj6FuN/KLAAmITzGWFVGZB6tCnJCbZAI3Q21nD8uVmA486hCD0ugCalN+SH
        B8WbHcarOzrrAbsesIT/oFgjYCb8X9U=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-LcPlO-4gPECoudkejYE1Kw-1; Mon, 08 Nov 2021 09:27:43 -0500
X-MC-Unique: LcPlO-4gPECoudkejYE1Kw-1
Received: by mail-pl1-f197.google.com with SMTP id u22-20020a170902a61600b00141ab5dd25dso6627007plq.5
        for <ceph-devel@vger.kernel.org>; Mon, 08 Nov 2021 06:27:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=S8JLwhbnRVCBq0k5xiIzljuagPYVl4vnVGGyUCfpPJw=;
        b=X3giqTDbgeBM2V4mzSCVV9zCUnH5zguSJg12CGquIWmNvRq+WIYW8MLUWOpwLZTzuo
         /KwHB5O6jM1iJFiEXmQ1IHHNV95z+3mgzHyCV942lGYErXmpRJAc2NB9vKgMq1P3GJQ+
         rOcwvhtbYte9C/Hgw/Mh3fNRiNs92d/yhRysSAqG1TGlwLlzn8WYagGySSlQey/oTzm3
         RQZOzIMOwy3Qusi+S+alOWnGjyuWBPCmp7tHFsEdfX03W7TUBCj9/SQ2EKwQT3B+DnTr
         m7mlj5vtl6flzcDieldRK/Y1KhI6ltUoer/uFVpCUTUK0B7dEoH697VpoPuEmswTdGNB
         kO8w==
X-Gm-Message-State: AOAM530xKAOteZa9NpTGYlsqJljI1PxEO4/cELjf6fuVQQ4Gqsvi2Kf+
        slGCrwGPfnmciGCGQ5U3CoINqS/oXTBLYkgifgy5/PMvgXNS7ovr+zwmb5xySk5m3r3E7o1NuZF
        vs3GAp8uFE+VVY2ZXbgQQAVAFdTGziknZN2eKLX519I1tp026wY5O7mC8Z8rawSDqf4nvjw8=
X-Received: by 2002:aa7:8c41:0:b0:47e:603f:26be with SMTP id e1-20020aa78c41000000b0047e603f26bemr78817504pfd.14.1636381661132;
        Mon, 08 Nov 2021 06:27:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/DX9vf/SmOk+7xrVnSXivb1WmToT2vg0paBtEMnUdbgzFfrfbod/h5/zY+j+oKsUwEc5kHg==
X-Received: by 2002:aa7:8c41:0:b0:47e:603f:26be with SMTP id e1-20020aa78c41000000b0047e603f26bemr78817450pfd.14.1636381660717;
        Mon, 08 Nov 2021 06:27:40 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y184sm9667298pfg.175.2021.11.08.06.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 06:27:40 -0800 (PST)
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211108135012.79941-1-xiubli@redhat.com>
 <25c8bbac-99c1-66a9-cb79-96eb0213c702@redhat.com>
Message-ID: <94d1f3ca-6c38-8633-faf9-adc092a1286d@redhat.com>
Date:   Mon, 8 Nov 2021 22:27:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <25c8bbac-99c1-66a9-cb79-96eb0213c702@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Possibly we need to pick up some more patches or some code section from 
your experimental branch for the read/write.

On 11/8/21 10:10 PM, Xiubo Li wrote:
> Hi Jeff,
>
> After this fixing, there still has one bug and I am still looking at it:
>
> [root@lxbceph1 xfstests]# ./check generic/075
> FSTYP         -- ceph
> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0-rc6+
>
> generic/075     [failed, exit status 1] - output mismatch (see 
> /mnt/kcephfs/xfstests/results//generic/075.out.bad)
>     --- tests/generic/075.out    2021-11-08 20:54:07.456980801 +0800
>     +++ /mnt/kcephfs/xfstests/results//generic/075.out.bad 2021-11-08 
> 21:20:49.741906997 +0800
>     @@ -12,7 +12,4 @@
>      -----------------------------------------------
>      fsx.2 : -d -N numops -l filelen -S 0
>      -----------------------------------------------
>     -
>     ------------------------------------------------
>     -fsx.3 : -d -N numops -l filelen -S 0 -x
>     ------------------------------------------------
>     ...
>     (Run 'diff -u tests/generic/075.out 
> /mnt/kcephfs/xfstests/results//generic/075.out.bad'  to see the entire 
> diff)
> Ran: generic/075
> Failures: generic/075
> Failed 1 of 1 tests
>
>
> I checked the result outputs, it seems when truncating the size to a 
> smaller sizeA and then to a bigger sizeB again, in theory those 
> contents between sizeA and sizeB should be zeroed, but it didn't.
>
> The last block updating is correct.
>
> Any idea ?
>
> Thanks.
>
>
> On 11/8/21 9:50 PM, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Hi Jeff,
>>
>> The #1 could be squashed to the previous "ceph: add truncate size 
>> handling support for fscrypt" commit.
>> The #2 could be squashed to the previous "ceph: fscrypt_file field 
>> handling in MClientRequest messages" commit.
>>
>> Thanks.
>>
>> Xiubo Li (2):
>>    ceph: fix possible crash and data corrupt bugs
>>    ceph: there is no need to round up the sizes when new size is 0
>>
>>   fs/ceph/inode.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>

