Return-Path: <ceph-devel+bounces-1043-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25500890ED4
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Mar 2024 01:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8575289C00
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Mar 2024 00:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2259780C;
	Fri, 29 Mar 2024 00:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i3bTekP7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E818E
	for <ceph-devel@vger.kernel.org>; Fri, 29 Mar 2024 00:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711670738; cv=none; b=S8MyUogF7v5W1jYxBF1HB4MDkICXAmgPKwv9CWRMa896UgsSSc2M0KY1KDf0SoFICQ/0PLuQUeebQqDs60/ZGF4GIYV4ecQTM0+1jXkycbEPYvcXxAltQKxHmyN0qsO2XrAaLk4/nR90L4NdJ8b/pDYTbqFjjlIYYHQzAtyRsFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711670738; c=relaxed/simple;
	bh=cjxm1Ryfb5Z9F4sbSdTRXRhffmjVd0tmVnxtg9IiFvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=utywLtsrJGnD99nPZfRk+weUn2ytsutOjorTUJB0Nlz/3N+hmO3KDoz2b1AG0QnjX7Gw56Xoi0pT7MP8z5mugdccxVQpjz65SHmdza1ETK6CEq1G6himuOtqcGJMfTlL7tpttCpdzxoS5eml3aneOoxI8zes5EAhBHDNJwUllK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i3bTekP7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711670736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oquIsO/B8A2Gk2EwI1tx+d6zNaq8dTKXgOE1D72BOIw=;
	b=i3bTekP7uHuTkj6ouHBfEKGr8LYAO9pNQDW0BfyP/03t49V2PPgG25WWQDROoKbNz9xbCm
	DFBCsbYVKXopkWbFIIX1TaJ9JlwHkX1X/KXZR3qDwUvmcQwl+LaU+X+ruTLu0AWzRq3jr6
	U45UX+ggdQjXbK+mH5JLW4dYeW+8fAs=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-yH3gCG-IM2WnWL38zxW1OA-1; Thu, 28 Mar 2024 20:05:34 -0400
X-MC-Unique: yH3gCG-IM2WnWL38zxW1OA-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-22a1dbcf8e6so1222774fac.2
        for <ceph-devel@vger.kernel.org>; Thu, 28 Mar 2024 17:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711670734; x=1712275534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oquIsO/B8A2Gk2EwI1tx+d6zNaq8dTKXgOE1D72BOIw=;
        b=lWJVRrtUJya4xS8w8H/F5EJoZ2jkegDg7t5PfzbNnyhEXBd/Q38GEDDxTFFOdWbCi9
         nfa850yES57RSxSZmBiFIyXmrX8Svkqx/SKwEZ1GxdIuVkfVWTfvxDRl+tIR6nd1ld5T
         hmwQ+oXW8w8gX2vWUeZjmZntTxc4vsKYWKBQWPvKTRlpME/hjadkLm3akyICRHKvy2oJ
         Lvx/WpAMeGJ7CXTsEfAprQU6oDgh9INa7nqCnDuc4qTCeLc5mON1lU80vXOkEcoGCaeH
         ooIJoOIT4wWqcnOrtzbfJlSE8GTM0/ilgYSzMJId3DPBnzQk7AqSF91kGfmb8PuhmGhl
         lWFw==
X-Forwarded-Encrypted: i=1; AJvYcCU++xbz326dIScnWrGNLy6Lshklp1E9EcFvD45B8PuKvJ3s+ncaRCA8sOGH/BSzy5Sde4jUzOnrqC8BrrdmS1x0ercW8Znx+7KfqQ==
X-Gm-Message-State: AOJu0YznsfxJavugIdy714Lfn+AObF5m69UAfKiP7Erb+yb4t5C+gI6x
	G3ZEpSYkBmHPQ/9UZ/yxcfr0h77088tafS6ZJRIa3yzg33K2Cztpbf5MD30nGkoo6slw/BOaZ1x
	tKI4quRSa9iWLcHhCWuKCEnzD4NxqCX9Q4H74FTsbYOJyQNHFkOGY/72mgpw=
X-Received: by 2002:a05:6870:9213:b0:22a:e91:2d9c with SMTP id e19-20020a056870921300b0022a0e912d9cmr744883oaf.56.1711670733962;
        Thu, 28 Mar 2024 17:05:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnEoQrZF39Z3vBtcbSJQo0k22y/TmSjLE13uEQmcKttgsZxV4Si5B4aokUcJRse8C4U5UT1g==
X-Received: by 2002:a05:6870:9213:b0:22a:e91:2d9c with SMTP id e19-20020a056870921300b0022a0e912d9cmr744867oaf.56.1711670733707;
        Thu, 28 Mar 2024 17:05:33 -0700 (PDT)
Received: from [10.72.112.41] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j23-20020aa78d17000000b006e681769ee0sm2020583pfe.145.2024.03.28.17.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 17:05:33 -0700 (PDT)
Message-ID: <93fc9138-7498-4268-9bd2-d5b87f215963@redhat.com>
Date: Fri, 29 Mar 2024 08:05:20 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] rbd: avoid out-of-range warning
Content-Language: en-US
To: Alex Elder <elder@ieee.org>, Arnd Bergmann <arnd@kernel.org>,
 linux-kernel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
 Jens Axboe <axboe@kernel.dk>, Nathan Chancellor <nathan@kernel.org>,
 Alex Elder <elder@inktank.com>, Josh Durgin <josh.durgin@inktank.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Hannes Reinecke <hare@suse.de>, Christian Brauner <brauner@kernel.org>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 "Ricardo B. Marliere" <ricardo@marliere.net>,
 Jinjie Ruan <ruanjinjie@huawei.com>, Alex Elder <elder@linaro.org>,
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, llvm@lists.linux.dev
References: <20240328143051.1069575-1-arnd@kernel.org>
 <20240328143051.1069575-4-arnd@kernel.org>
 <b8e848fe-96d8-4f75-a2e9-2ed5c11a2fd7@ieee.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <b8e848fe-96d8-4f75-a2e9-2ed5c11a2fd7@ieee.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/28/24 22:53, Alex Elder wrote:
> On 3/28/24 9:30 AM, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> clang-14 points out that the range check is always true on 64-bit
>> architectures since a u32 is not greater than the allowed size:
>>
>> drivers/block/rbd.c:6079:17: error: result of comparison of constant 
>> 2305843009213693948 with expression of type 'u32' (aka 'unsigned 
>> int') is always false 
>> [-Werror,-Wtautological-constant-out-of-range-compare]
> w
>>              ~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> This is harmless, so just change the type of the temporary to size_t
>> to shut up that warning.
>
> This fixes the warning, but then the now size_t value is passed
> to ceph_decode_32_safe(), which implies a different type conversion.
> That too is not harmful, but...
>
> Could we just cast the value in the comparison instead?
>
>   if ((size_t)snap_count > (SIZE_MAX - sizeof (struct ceph_snap_context))
>
> You could drop the space between sizeof and ( while
> you're at it (I always used the space back then).
>
Agree.

- Xiubo


> -Alex
>
>>
>> Fixes: bb23e37acb2a ("rbd: refactor rbd_header_from_disk()")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>   drivers/block/rbd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index 26ff5cd2bf0a..cb25ee513ada 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -6062,7 +6062,7 @@ static int rbd_dev_v2_snap_context(struct 
>> rbd_device *rbd_dev,
>>       void *p;
>>       void *end;
>>       u64 seq;
>> -    u32 snap_count;
>> +    size_t snap_count;
>>       struct ceph_snap_context *snapc;
>>       u32 i;
>
>


