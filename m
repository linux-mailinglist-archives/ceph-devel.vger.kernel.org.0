Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AD3452A64
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Nov 2021 07:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhKPGRk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Nov 2021 01:17:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231922AbhKPGRj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 01:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637043282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v/wOh3dIYqvp3VTJgtjYJS8hQaiOO0T/VpjwGy3T/O8=;
        b=T7uX3QId9FTIGA5qVk2FlZHag3PKnAbjD/kpC6SU7Adz6KvE+RphZ9YkRSfbPzEfbIkyNJ
        /rqo5dY3woNbCrz8Odw6zpGuj5Ad4+HOtET1fIFLuUpjvHlaNyeGkqcEug0nbLh8WYKIWq
        XMQJW7kmp7G1wSLnKkrmgib2eCWKWIg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-dwKWixxQOPSnSWS3d9K-rw-1; Tue, 16 Nov 2021 01:14:40 -0500
X-MC-Unique: dwKWixxQOPSnSWS3d9K-rw-1
Received: by mail-pj1-f71.google.com with SMTP id d3-20020a17090a6a4300b001a70e45f34cso1123662pjm.0
        for <ceph-devel@vger.kernel.org>; Mon, 15 Nov 2021 22:14:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=v/wOh3dIYqvp3VTJgtjYJS8hQaiOO0T/VpjwGy3T/O8=;
        b=EnEwqDK8WtzQTmXzlXxLyCbxJ2fAHDSKbg6bzYYTu6q4GFjiwMWP+GGuFdXHAZYzw5
         kDJ2D0FLvbEcSJN7J/xAJ0aFEDZW6WvS2Bxm/JDCMlCBMP+7RipljoGCWD1GHvHsjzIi
         fh6rTEeONdv9wJu0QPbbskY+H4fxE2AUnHeKtpqTkrLZchJ3iLx2m8a7GGGk8+qZDOWh
         +G3VXnZqWymz8jtDXd3LedpWwRlkrcqeTsrXnlN2KRZzB8M2ghOTECcm4kJx3bZ4WUPl
         mIXMyZQEg0iPNQQ8wVJE9/6qWE6SABGgxxoeAqlAfvwpQuQ9r7KEOCD32a4ziz7IP+4+
         Vezg==
X-Gm-Message-State: AOAM531TkIqVv8D21ZDt3FXiDmGcVKc2UHdOjWAsom9scZ6xIPR2cnO/
        /lY05JEZowDhgm1Xag/O6lt5qncm83urB6EAe8hDKlXL8s0oOqUQS+i/5t4zhyiz3fYmDB94bqW
        PdkVPn/99EmApRftX6EXO6qcxvtGjyCSCZO8x9TuzOI6Um3Sf69ZNiVgm40Xl3ryMHu5yHrA=
X-Received: by 2002:a05:6a00:1681:b0:46f:6fc0:e515 with SMTP id k1-20020a056a00168100b0046f6fc0e515mr38339511pfc.11.1637043278610;
        Mon, 15 Nov 2021 22:14:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4I9geGR1NHughBvlFRsm1+zbsx+d/aMiIFytdrOALIMuQsLK7X0pO4qfOU/RAFpx/HiLdcQ==
X-Received: by 2002:a05:6a00:1681:b0:46f:6fc0:e515 with SMTP id k1-20020a056a00168100b0046f6fc0e515mr38339480pfc.11.1637043278295;
        Mon, 15 Nov 2021 22:14:38 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l6sm19372313pfc.126.2021.11.15.22.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 22:14:37 -0800 (PST)
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211108135012.79941-1-xiubli@redhat.com>
 <79e1517f6197185e3aca6b0afa5b810c5b5e8a82.camel@kernel.org>
 <ec7b0b1e-85de-6a4a-a772-5e00dd787d69@redhat.com>
 <f2ecc2760733b0cdde950b6a21bbbb8e9fb15f29.camel@kernel.org>
 <ff4343cc402371813e40695cd556203df753bea0.camel@kernel.org>
 <a0a9f6f4-5c49-b072-8161-5d085ab97b89@redhat.com>
Message-ID: <fb590d29-2e63-f62d-1681-caac83b92194@redhat.com>
Date:   Tue, 16 Nov 2021 14:14:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a0a9f6f4-5c49-b072-8161-5d085ab97b89@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/16/21 12:56 PM, Xiubo Li wrote:
>
> On 11/9/21 8:33 PM, Jeff Layton wrote:
>> On Mon, 2021-11-08 at 20:57 -0500, Jeff Layton wrote:
>>>
[...]
>>>>> ...I suspect this is related to the 075 failures, but I don't see 
>>>>> it on
>>>>> every attempt, which makes me think "race condition". I'll keep 
>>>>> hunting.
>>>> Yeah, seems the same issue.
>>>>
>>> I wonder if we're hitting the same problem that this patch was intended
>>> to fix:
>>>
>>>      057ba5b24532 ceph: Fix race between hole punch and page fault
>>>
>>> It seems like the problem is very similar. It may be worth testing a
>>> patch that takes the filemap_invalidate_lock across the on the wire
>>> truncate and the vmtruncate.
>>
>> Nope. I tried a draft patch that make setattr hold this lock over the
>> MDS call and the vmtruncate and it didn't help.
>
> It's buggy by using the `filer.write_trunc()` caller in MDS side, it 
> works well in case the truncate_from - truncate_size < 4MB, or it will 
> keep the stale file contents without trimming or zeroing them.
>
> I will push the MDS side PR to fix it.
>
Have updated the MDS side PR.

Both the generic/030 and generic/075 tests passed, and I am still 
testing others.

BRs

-- Xiubo


> Thanks
>
> -- Xiubo
>
>
>> Cheers,

