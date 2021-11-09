Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2A449F6C
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 01:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhKIAYK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 19:24:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231793AbhKIAYK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 19:24:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636417284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hVbGIB4nmTGYQM6S6cWYlaO0GFMKSZhic4eE5xGh/0c=;
        b=ZK4rEZl6AtLkuHGXjbA19MQeKMHIFwN0ngCZtbK0PP9vU5TsbTuslstSm08rBz59LnsVXF
        aP3SfQiFQQXSS78fC3F27oHM7P5q7i4/yTqWsO+2AxolWPF94BVJqD3sigWRu6om6mLHXM
        1l3IH+igZ3+HqBr2Li4ATtJnl5auC90=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-XGOcgqbXP0Wzk7HcgiUagg-1; Mon, 08 Nov 2021 19:21:23 -0500
X-MC-Unique: XGOcgqbXP0Wzk7HcgiUagg-1
Received: by mail-pl1-f199.google.com with SMTP id z3-20020a170903018300b0014224dca4a1so6649396plg.0
        for <ceph-devel@vger.kernel.org>; Mon, 08 Nov 2021 16:21:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hVbGIB4nmTGYQM6S6cWYlaO0GFMKSZhic4eE5xGh/0c=;
        b=AwInrS0ROSCcdl6DjKhlwEXWkHlQongtBBcDBIZNc9uefFHpkSaSBBL/C4PdHOobLs
         NTDCQdrnx3dkUhJw0i3CU3GNYKMZDIy3+W1QD+pLn9wQM85zNw8QuApDXWLZuzziRN9U
         vvCHGXM+6iLGFlXPfTYWNXdYMAmYdpNPJiIvaT54NCrR/ZcTh+NaaiHMkmMhKDSPvwhm
         GbhCb82eXS+O99avTmtoEtxesYDOFPJ7cnsUptetLUMtHLOQI9sBaiXFHjTVrUDD1dId
         kVBL+32ZmOiQ/DyEH70tjLNxGVc4Y2b6mEhghWC60ou1zox0QKzxbx8r2Y85WZ00qd/u
         ns+w==
X-Gm-Message-State: AOAM532fBJkLD2WUur+lzXXelCNXLIZAn076D/igYkC3euwVVxCQJ3E+
        9k+FhHs/BkECc8k0mKCcdnStSmwGzxUTywYWubbHPyxAvQhqH5mL25DNX85U7yxZSI3QtYNp6Jw
        3GK6nT4yf3q3HQbWjJrBhJWcgC4Iw5t6AHdcb4XBtTQdXDM1GFcBJlqq4/doJgUXo1vX6tiw=
X-Received: by 2002:a63:dc42:: with SMTP id f2mr2648988pgj.275.1636417282184;
        Mon, 08 Nov 2021 16:21:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKATfkdshZipBQDPjlsvfkcFVmfF2x+EpZfYW6oun1BZJi94cUQd+e4wSAbQLOhlyFPGM/nw==
X-Received: by 2002:a63:dc42:: with SMTP id f2mr2648962pgj.275.1636417281781;
        Mon, 08 Nov 2021 16:21:21 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u18sm881783pgl.16.2021.11.08.16.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 16:21:21 -0800 (PST)
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211108135012.79941-1-xiubli@redhat.com>
 <79e1517f6197185e3aca6b0afa5b810c5b5e8a82.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ec7b0b1e-85de-6a4a-a772-5e00dd787d69@redhat.com>
Date:   Tue, 9 Nov 2021 08:21:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <79e1517f6197185e3aca6b0afa5b810c5b5e8a82.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/9/21 2:36 AM, Jeff Layton wrote:
> On Mon, 2021-11-08 at 21:50 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Hi Jeff,
>>
>> The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
>> The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
>>
>> Thanks.
>>
>> Xiubo Li (2):
>>    ceph: fix possible crash and data corrupt bugs
>>    ceph: there is no need to round up the sizes when new size is 0
>>
>>   fs/ceph/inode.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
> I'm running xfstests today with the current state of wip-fscrypt-size
> (including the two patches above) with test_dummy_encryption enabled.
> generic/030 failed. The expected output of this part of the test was:
>
> wrote 5136912/5136912 bytes at offset 0
> XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ==== Pre-Remount ===
> 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> |XXXXXXXXXXXXXXXX|
> *
> 004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59
> |YYYYYYYYYYYYYYYY|
> *
> 004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00
> |YYYYYYYY........|
> 004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
> *
> 004e7000
> ==== Post-Remount ==
> 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> |XXXXXXXXXXXXXXXX|
> *
> 004e6210  59 59 59 59 59 59 59 59  59 59 59 59 59 59 59 59
> |YYYYYYYYYYYYYYYY|
> *
> 004e6d00  59 59 59 59 59 59 59 59  00 00 00 00 00 00 00 00
> |YYYYYYYY........|
> 004e6d10  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
> *
> 004e7000
>
> ...but I got this instead:
>
> wrote 5136912/5136912 bytes at offset 0
> XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> ==== Pre-Remount ===
> 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> |XXXXXXXXXXXXXXXX|
> *
> 00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
> *
> 004e7000
> ==== Post-Remount ==
> 00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58
> |XXXXXXXXXXXXXXXX|
> *
> 00400000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> |................|
> *
> 004e7000
>
>
> ...I suspect this is related to the 075 failures, but I don't see it on
> every attempt, which makes me think "race condition". I'll keep hunting.

Yeah, seems the same issue.


> Cheers,

