Return-Path: <ceph-devel+bounces-55-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE1E7E2139
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B9BDB20E2C
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851EE1EB4D;
	Mon,  6 Nov 2023 12:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxMHZfM/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF311EB36
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 12:20:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CE4BD
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699273208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ENL9RrKdZo99P7t73J14LRhZSwJCWCHBP9Qof0eLNUo=;
	b=bxMHZfM/SVc4vI7DWqX3G4RYIbg9a0wC+ogkDqbKqFCLfAo7qHlOdPKqpuOXIO+u4gYf8m
	BSQK37hY/CGFndvMdcRLCK2Qx/R0HsBzP1VGl0W8wJ60YTWyoQX5+FRv7HwbwU49EOWNMo
	IwiNefAQ991/NKNA0WGG2/L0a6whUNI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-1j80YR9WNK2sjgKH4sBuIw-1; Mon, 06 Nov 2023 07:20:07 -0500
X-MC-Unique: 1j80YR9WNK2sjgKH4sBuIw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cc2ebc3b3eso25836645ad.2
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 04:20:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699273206; x=1699878006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENL9RrKdZo99P7t73J14LRhZSwJCWCHBP9Qof0eLNUo=;
        b=HFlGIfK2x2Hdf/4UUwufNn+Uc7WFUHoNNJy8Xo5Qh3dIPr08CMPwncXz9JEIT/2xNR
         hx2WUpnXCc20nOjGxabOWxeTj2+DKALhT/2t2RSSnx7TbNXsaU1C6SjI8HwlWFEDdRWl
         036FtO1XQn+84QZa7f3PNR03Ywdo0Ytf6Sc9ILOelU8hVGXJfaPdaKMK/Rr/CjhkRvA2
         A1WdBIDp50JrFdV2LhUQexhLp+UQYRTfa0H/9AZe+JHVwIfdzOO5xvlYuPlosLNtTVE5
         gJRUmwSMffIg2vm0aHRCSe8rQq+d8H3DeMC5I52eS77YdwfzqiErf4Kg/82jhVq7+1dZ
         8bWQ==
X-Gm-Message-State: AOJu0YwRc/h0XzbImWE3+YySqrGE+aXzcKkd+0iykcYcOZhb64yzyXFK
	9BsxWwqu4b/fcLhs0tO1efCkIP3fBmiOVQ46OO+yPfMe9R9iIzC6+/PkkmSeIpcceZjAh8zZabQ
	KqLSdlNLKNjuAeYrOe2yVhA==
X-Received: by 2002:a17:903:24d:b0:1cc:9781:4782 with SMTP id j13-20020a170903024d00b001cc97814782mr9804145plh.62.1699273206447;
        Mon, 06 Nov 2023 04:20:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFqj6Vn8K6CEqGbXsDhiostYX5JU99uHSTlPX0fian1aT7mhsCE9h9NYv/n5pfdUxeJeka3g==
X-Received: by 2002:a17:903:24d:b0:1cc:9781:4782 with SMTP id j13-20020a170903024d00b001cc97814782mr9804128plh.62.1699273206123;
        Mon, 06 Nov 2023 04:20:06 -0800 (PST)
Received: from [10.72.112.221] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q10-20020a170902edca00b001ca4c7bee0csm5836499plk.232.2023.11.06.04.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 04:20:05 -0800 (PST)
Message-ID: <b23e8296-ca61-6be5-e07f-f0e184ac3c55@redhat.com>
Date: Mon, 6 Nov 2023 20:20:01 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] libceph: increase the max extents check for sparse
 read
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231106010300.247597-1-xiubli@redhat.com>
 <CAOi1vP-knSTdi5OxG=Yv5cGVJOQ7f5qhS41rhcRj-NQXhqnrtQ@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-knSTdi5OxG=Yv5cGVJOQ7f5qhS41rhcRj-NQXhqnrtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/6/23 19:46, Ilya Dryomov wrote:
> On Mon, Nov 6, 2023 at 2:05 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> There is no any limit for the extent array size and it's possible
>> that we will hit 4096 limit just after a lot of random writes to
>> a file and then read with a large size. In this case the messager
>> will fail by reseting the connection and keeps resending the inflight
>> IOs infinitely.
>>
>> Just increase the limit to a larger number and then warn it to
>> let user know that allocating memory could fail with this.
>>
>> URL: https://tracker.ceph.com/issues/62081
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Increase the MAX_EXTENTS instead of removing it.
>> - Do not return an errno when hit the limit.
>>
>>
>>   net/ceph/osd_client.c | 15 +++++++--------
>>   1 file changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index c03d48bd3aff..050dc39065fb 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5850,7 +5850,7 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
>>   }
>>   #endif
>>
>> -#define MAX_EXTENTS 4096
>> +#define MAX_EXTENTS (16*1024*1024)
> I don't think this is a sensible limit -- see my other reply.

Ilya,

As I mentioned in that thread, the sparse read could be enabled in 
non-fscrypt case. If so the "64M (CEPH_MSG_MAX_DATA_LEN) / 4K = 16384" 
still won't be enough.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>


