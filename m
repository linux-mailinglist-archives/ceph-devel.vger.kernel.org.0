Return-Path: <ceph-devel+bounces-2848-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CA1A4CAD5
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Mar 2025 19:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B71641889ADA
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Mar 2025 18:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A77522ACF2;
	Mon,  3 Mar 2025 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="E9elgDOP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4961EF0B7;
	Mon,  3 Mar 2025 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741025617; cv=none; b=ayE/PVxUnmKfWaSDd9t1hxN0yOf8HNvCED7SlP4aDNrwmK6WZdZchCKozivgaxRAOWD0p893cEAmXKb9cMmUMzYiYA8+W4TuWePPYpW3g6+sW4v8LJLn9QNPnpKqwjPaF+cikqUdZjpvtbPD8hrvhAjfkZMBzDoRF3IsL0oKwxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741025617; c=relaxed/simple;
	bh=F6Z0BN+3hKZPN/y08u5s9KL0bARPiF2rGzp+BqQm9pw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=os2jI4h4q6zZCbMjYDgmLSwQh8GQ8j1NgwkauwRCVFC873u54Mef1+v6H5hzLXphYLpIXDuqkF+gcArW0nXVdHUvwxVy02vhh+LT5d3UE09SBJG+Nh/HAH4KPvLdqLOOn1SIM+EWKWeLY8EATsaZLiuPyjJ1JwMvyt1Mg8S8zOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=E9elgDOP; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.65.97.24] (unknown [20.236.11.185])
	by linux.microsoft.com (Postfix) with ESMTPSA id 01FD42110480;
	Mon,  3 Mar 2025 10:13:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 01FD42110480
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741025610;
	bh=vjIVrkAKe+QXU3xO1k+YnRel/IS8P/2bHL0s5aUiBxY=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=E9elgDOPj8Ox/9Gsvyd7W/Zp9zOI0KKL5YZvCjgV3HlH6J2C9fc1dhIeRK+rgUGjz
	 PKAS5/wQ4IPVLJ8hOYD+lbQVO4rWClH18aV+ljO4Mys1DuLjSTFNxpMnmnhU47qGMd
	 HLNe9Pr2WNTiFJHXqXiCL26hr5bk9V6SW9AVWob4=
Message-ID: <d5035d88-f714-47c2-ace6-8bd609d84633@linux.microsoft.com>
Date: Mon, 3 Mar 2025 10:13:34 -0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Daniel Vacek <neelx@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Xiubo Li <xiubli@redhat.com>,
 eahariha@linux.microsoft.com, ceph-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] rbd: convert timeouts to secs_to_jiffies()
To: Alex Elder <elder@ieee.org>, Andrew Morton <akpm@linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>
References: <20250301-converge-secs-to-jiffies-part-two-v4-0-c9226df9e4ed@linux.microsoft.com>
 <20250301-converge-secs-to-jiffies-part-two-v4-1-c9226df9e4ed@linux.microsoft.com>
 <4c4b3d6f-64b7-4ba3-8d2e-d8b1f1a03a53@ieee.org>
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <4c4b3d6f-64b7-4ba3-8d2e-d8b1f1a03a53@ieee.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/2/2025 9:05 AM, Alex Elder wrote:
> On 2/28/25 10:22 PM, Easwar Hariharan wrote:
>> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
>> secs_to_jiffies().  As the value here is a multiple of 1000, use
>> secs_to_jiffies() instead of msecs_to_jiffies() to avoid the multiplication
>>
>> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
>> the following Coccinelle rules:
>>
>> @depends on patch@ expression E; @@
>>
>> -msecs_to_jiffies(E * 1000)
>> +secs_to_jiffies(E)
>>
>> @depends on patch@ expression E; @@
>>
>> -msecs_to_jiffies(E * MSEC_PER_SEC)
>> +secs_to_jiffies(E)
>>
>> Change the check for range to check against HZ.
>>
>> Acked-by: Ilya Dryomov <idryomov@gmail.com>
>> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> 
> I think what you've done in the last hunk below should not be
> done that way.  I also suggest something to the (related, but
> not part of this series) secs_to_jiffies() implementation.
> 
>> ---
>>   drivers/block/rbd.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index faafd7ff43d6ef53110ab3663cc7ac322214cc8c..1c406b17f3cee741b7bdd9f742958b3f1d5b1bbe 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -108,7 +108,7 @@ static int atomic_dec_return_safe(atomic_t *v)
>>   #define RBD_OBJ_PREFIX_LEN_MAX    64
>>     #define RBD_NOTIFY_TIMEOUT    5    /* seconds */
>> -#define RBD_RETRY_DELAY        msecs_to_jiffies(1000)
>> +#define RBD_RETRY_DELAY        secs_to_jiffies(1)
>>     /* Feature bits */
>>   @@ -4162,7 +4162,7 @@ static void rbd_acquire_lock(struct work_struct *work)
>>           dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
>>                rbd_dev);
>>           mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
>> -            msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SEC));
>> +            secs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT));
>>       }
>>   }
>>   @@ -6283,9 +6283,9 @@ static int rbd_parse_param(struct fs_parameter *param,
>>           break;
>>       case Opt_lock_timeout:
>>           /* 0 is "wait forever" (i.e. infinite timeout) */
>> -        if (result.uint_32 > INT_MAX / 1000)
> 
> Previously, the above line was verifying that the multiplication
> done below would not overflow.  It was unrelated to whatever
> msecs_to_jiffies() did.
> 
>> +        if (result.uint32 > INT_MAX / HZ)
> 
> Here you are assuming something about what secs_to_jiffies()
> does.  It's a very reasonable assumption, but you are encoding
> this in unrelated code, which you shouldn't do.
> 
> Just do the direct conversion as you've done above:
> 
>         if (result.uint32 > INT_MAX)
> 
>>               goto out_of_range;
>> -        opt->lock_timeout = msecs_to_jiffies(result.uint_32 * 1000);
>> +        opt->lock_timeout = secs_to_jiffies(result.uint_32);
> 
> Unfortunately, secs_to_jiffies() does not implement the clamp
> operation that msecs_to_jiffies() does.  If you look at
> __msecs_to_jiffies() you see that the unsigned value provided
> is limited to MAX_JIFFY_OFFSET if it's negative when interpreted
> as a signed int (i.e., if its high bit is set).
> 
> I think the secs_to_jiffies() implementation could benefit
> from the use of an overflow check.  This might not be
> exactly right, but it gives the idea:

Fair enough, let me explore this.

@Jens, @Andrew, can you drop the rbd and libceph patches from your respective
trees while I work this out?

Thanks,
Easwar (he/him)

> 
> #define secs_to_jiffies(_secs)                    \
>     ({                            \
>         unsigned long _result;                \
>                                 \
>         if (check_mul_overflow(_secs, HZ, &_result))    \
>             _result = MAX_JIFFY_OFFSET;        \
>         (_result);                    \
>     })
> 
>                     -Alex
> 
> 
>>           break;
>>       case Opt_pool_ns:
>>           kfree(pctx->spec->pool_ns);
>>


