Return-Path: <ceph-devel+bounces-2844-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 312EAA4B3A9
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Mar 2025 18:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A21F73AE54C
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Mar 2025 17:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7A71EB1B9;
	Sun,  2 Mar 2025 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="A27Xk7AY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB2E3594F
	for <ceph-devel@vger.kernel.org>; Sun,  2 Mar 2025 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740935139; cv=none; b=F4EGugHjRcVe5w6UNf1ErlnQmTsLEuUcMM7AeWIkN10F5tWgtzz781u4jMPlu2fcjN6e10BOC3UzLq+K5Se60PZdzJbarvwMm5kDMDirPk4OLbnqEuaVCWtQPYbOpe+2gt4fT20D7jRvgETt/TsCkZhF3OIjVk57gV2SYJtL5lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740935139; c=relaxed/simple;
	bh=tq+tb9mWzkFwIXw8weGXsxYG+EMkyMy6nxkcqujk91k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a/nBkK5cZtRdKioUG/BEPQYXAzm06OLx/0JLo3iDin9Bl5fBNBW4kI4bz4gjkRo0K+ueM1QwjmwTK5wPQssFqsI+ZEx91bV2E5UMsX672WqAFb2OEtI1i5YNDEHwITtjwlf1iyyUbbB0DwOR1YdsPScksO02a4QYi6i/OGaJNTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=A27Xk7AY; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-46fa764aac2so32619171cf.1
        for <ceph-devel@vger.kernel.org>; Sun, 02 Mar 2025 09:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1740935135; x=1741539935; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Volk3/gaWZQ4nGW5XDowkVlOnh1MBl+g/WndjtrTRJ8=;
        b=A27Xk7AYO9xolo6eas5c4/6UoHPcBtwNze2X/Yyak1IJ8GR/c+mvFl1f4NaSF91Ual
         dbQ06r+B1JYi3CLAojzATrzmKn3UPNPd/Qfx+4j4RBxhGfg7IRQwiB5HS/Pu2E92goEv
         JQcoiNJLAwuq41VTZRMZ7BWXeMU5fpKiyxp2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740935135; x=1741539935;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Volk3/gaWZQ4nGW5XDowkVlOnh1MBl+g/WndjtrTRJ8=;
        b=B3kjBgRZFfBbQtcDHJ4xR29WWT7EHIg/ibwYYH76186eL6Nouw2LjyDTNX1luuRn1j
         4ow/H2wDRCdA+3XWl4aTQW0UmwsDFCgyKCz7VwkTyDzNpV5mIU13zFlac0lNYqu35/Dt
         1GFojm21zB/vibWIhqf8LyKR4Bt+gJSF8QV+pWPHqF/kiR1ZO8rRYUkALXpb9Arxq10p
         ErFd8AhkHEmP6IRO7vBY6I5UV2Mu8kMKfKwBaKyeWiRnir8wdoqkPIR+Fm8UTcDfTd92
         YGMpCpVRGJ9OrGGLFkdBl5HyAxdGbsk4VdvARO8siBM5Ug1Au9A0hk9lxc+vE7R95aNg
         9QjA==
X-Gm-Message-State: AOJu0Yyn1DFLjTXhLEqLcElAGp+MEmDCUgHS1SFnCWGQQrnC9JyyiI0U
	sgJD2liYDebJGLO85CGGv1ELDRgN65iDoaHPic2T+Q4oYB/uB/7Crho+uKvyjw==
X-Gm-Gg: ASbGncsCddx0KcuyUsxwEzJjs9eCp4ofkT/FdoSn5D7d5+uK8T7dLLuvurdqcS4lZTZ
	fP10o0/SVjcd/pI3Y6akAqRvCSL+YetsHUEGafGHsYmGKHtlBaLIsO8fVraNqMp4YGFIgGaVKeq
	mPtlLCKwFmO0mPm3txn/BNb2yyD4vK8xmsjLKeVpqDmplwsr5C2i4XmFCpUgkTsS2Y5vjt90l5k
	TcwC36lhFi5LzsLkF2MTWDZGedmYDAm21D9P+jjvLADAg7xWo+ID14BsEcJadEjLuqDY6IJu+61
	PH3UmYObfsa69Pd+EMDJTPMkqqzpd5i45afKfD1hzPIyq1HWr+6sk/HSEhU4BCwxROyLKd9qyZG
	DY/jK1ztgYefi
X-Google-Smtp-Source: AGHT+IFCVL8dUckc3tcfOXNUOugPLac8vXar2W9wMgC8Vy7gv057oCeMT6yYo4ZcjXN88Q0pYKnU5w==
X-Received: by 2002:a05:622a:11d5:b0:472:12f1:ba4a with SMTP id d75a77b69052e-474bc051974mr162542241cf.4.1740935134638;
        Sun, 02 Mar 2025 09:05:34 -0800 (PST)
Received: from [10.211.55.5] (c-73-228-159-35.hsd1.mn.comcast.net. [73.228.159.35])
        by smtp.googlemail.com with ESMTPSA id d75a77b69052e-474691a1ff3sm48374241cf.7.2025.03.02.09.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 09:05:33 -0800 (PST)
Message-ID: <4c4b3d6f-64b7-4ba3-8d2e-d8b1f1a03a53@ieee.org>
Date: Sun, 2 Mar 2025 11:05:30 -0600
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] rbd: convert timeouts to secs_to_jiffies()
To: Easwar Hariharan <eahariha@linux.microsoft.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Daniel Vacek <neelx@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Jens Axboe <axboe@kernel.dk>,
 Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250301-converge-secs-to-jiffies-part-two-v4-0-c9226df9e4ed@linux.microsoft.com>
 <20250301-converge-secs-to-jiffies-part-two-v4-1-c9226df9e4ed@linux.microsoft.com>
Content-Language: en-US
From: Alex Elder <elder@ieee.org>
In-Reply-To: <20250301-converge-secs-to-jiffies-part-two-v4-1-c9226df9e4ed@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/25 10:22 PM, Easwar Hariharan wrote:
> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> secs_to_jiffies().  As the value here is a multiple of 1000, use
> secs_to_jiffies() instead of msecs_to_jiffies() to avoid the multiplication
> 
> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
> the following Coccinelle rules:
> 
> @depends on patch@ expression E; @@
> 
> -msecs_to_jiffies(E * 1000)
> +secs_to_jiffies(E)
> 
> @depends on patch@ expression E; @@
> 
> -msecs_to_jiffies(E * MSEC_PER_SEC)
> +secs_to_jiffies(E)
> 
> Change the check for range to check against HZ.
> 
> Acked-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

I think what you've done in the last hunk below should not be
done that way.  I also suggest something to the (related, but
not part of this series) secs_to_jiffies() implementation.

> ---
>   drivers/block/rbd.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index faafd7ff43d6ef53110ab3663cc7ac322214cc8c..1c406b17f3cee741b7bdd9f742958b3f1d5b1bbe 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -108,7 +108,7 @@ static int atomic_dec_return_safe(atomic_t *v)
>   #define RBD_OBJ_PREFIX_LEN_MAX	64
>   
>   #define RBD_NOTIFY_TIMEOUT	5	/* seconds */
> -#define RBD_RETRY_DELAY		msecs_to_jiffies(1000)
> +#define RBD_RETRY_DELAY		secs_to_jiffies(1)
>   
>   /* Feature bits */
>   
> @@ -4162,7 +4162,7 @@ static void rbd_acquire_lock(struct work_struct *work)
>   		dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
>   		     rbd_dev);
>   		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
> -		    msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SEC));
> +		    secs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT));
>   	}
>   }
>   
> @@ -6283,9 +6283,9 @@ static int rbd_parse_param(struct fs_parameter *param,
>   		break;
>   	case Opt_lock_timeout:
>   		/* 0 is "wait forever" (i.e. infinite timeout) */
> -		if (result.uint_32 > INT_MAX / 1000)

Previously, the above line was verifying that the multiplication
done below would not overflow.  It was unrelated to whatever
msecs_to_jiffies() did.

> +		if (result.uint32 > INT_MAX / HZ)

Here you are assuming something about what secs_to_jiffies()
does.  It's a very reasonable assumption, but you are encoding
this in unrelated code, which you shouldn't do.

Just do the direct conversion as you've done above:

		if (result.uint32 > INT_MAX)

>   			goto out_of_range;
> -		opt->lock_timeout = msecs_to_jiffies(result.uint_32 * 1000);
> +		opt->lock_timeout = secs_to_jiffies(result.uint_32);

Unfortunately, secs_to_jiffies() does not implement the clamp
operation that msecs_to_jiffies() does.  If you look at
__msecs_to_jiffies() you see that the unsigned value provided
is limited to MAX_JIFFY_OFFSET if it's negative when interpreted
as a signed int (i.e., if its high bit is set).

I think the secs_to_jiffies() implementation could benefit
from the use of an overflow check.  This might not be
exactly right, but it gives the idea:

#define secs_to_jiffies(_secs)					\
	({							\
		unsigned long _result;				\
								\
		if (check_mul_overflow(_secs, HZ, &_result))	\
			_result = MAX_JIFFY_OFFSET;		\
		(_result);					\
	})

					-Alex


>   		break;
>   	case Opt_pool_ns:
>   		kfree(pctx->spec->pool_ns);
> 


