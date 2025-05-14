Return-Path: <ceph-devel+bounces-3029-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36733AB74C6
	for <lists+ceph-devel@lfdr.de>; Wed, 14 May 2025 20:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AF978C4797
	for <lists+ceph-devel@lfdr.de>; Wed, 14 May 2025 18:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9B328981D;
	Wed, 14 May 2025 18:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="STw0v52y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-il1-f194.google.com (mail-il1-f194.google.com [209.85.166.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BE6289820
	for <ceph-devel@vger.kernel.org>; Wed, 14 May 2025 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747248746; cv=none; b=s7UtjCsOeWBcdRa1heg8+5CzNG1rVQAIEj1H87ijmyXSCqgfThHDZlx1QHTdUuEvwMzd1pOQnaQC103uwF5KM9CV/DxtId976bggAwktlOTZH/hx6L5i4En3y/89FgSNvYHIWOZbL72If8xRAZlRb28vmOTwmvGshc+qxqauXuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747248746; c=relaxed/simple;
	bh=CQJ/Izdemu9Upqt5gzxnWRlT+ZgctMHmGm8idYAOny8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=djxYnE8aMllVaBhRwSbFGjP4QRA+QpNVkosw2EbPAJwmjwizIfk08ZdEbIyndK+rM9Xr5J8dBS33qKiQSwZtmZKXWeNq2Sp8kh2J0Y1gTN7a/z+6hKZtb2rFrbQRNQerdPhspW7ACKufbnQqr9dKl/yRHpI6mza+mE9/o8gT3Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=STw0v52y; arc=none smtp.client-ip=209.85.166.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Received: by mail-il1-f194.google.com with SMTP id e9e14a558f8ab-3db6ddcef4eso914885ab.2
        for <ceph-devel@vger.kernel.org>; Wed, 14 May 2025 11:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1747248743; x=1747853543; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HGMN7yT051U8CF0u0W3zG/2Gp6ABI+Yzeacfvbogg24=;
        b=STw0v52yb5f0mPL9IZXFtif2MvZtEGQ2168zGGYzHCPb6t4M0vFI1jgwVwp1LT9Pn2
         Za9nauB7EZCqRUQTpEvQ2fc5DQm9SbI5ueJz6kx8+ASZEMaH0r5RKD0q77mQfTOU3xpZ
         WRuxwr5X3agOghIhOz2VBvaJVhlUgfFwPjXSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747248743; x=1747853543;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HGMN7yT051U8CF0u0W3zG/2Gp6ABI+Yzeacfvbogg24=;
        b=F0lU2z5QTNQ3QQU9mVtbdov+CVlKAqTqq3c8I0A+Hiy5Pg5NVGHh6E9T2oEJntP1MS
         CRo7eVZg/v4/c1PnqAzlcX6gZSNjIlzPFUALlOPz3onhFnU8ckXHNJQwBRK0B3HLjWVQ
         yW5shlMBCSgnIQK3tR9QmfB0QuIuPU2NOYgLeui7K//Bb/Ut/Rk91aut73LBYN4NDpy7
         RAou0cyQ5LB/p/f/r7rS1p0odtJWgFSlQORKT6dQLuC0XKpFkfHQ9i9ibRf8AUHoLETP
         msY3Vis//fDVwtfay+Ey5ZR2VeeyjBFLqeg9nmRGdssaoQSj/GAQ9NKeYFwIlOuaJUjm
         +jRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuKhL3qV3LnPxrj0U78upva4uW4YVP5eV8Qhcrfji6TudfDVBhh6M8POvv+MBEWSxLqkjjjT4MtoBw@vger.kernel.org
X-Gm-Message-State: AOJu0YzcoJzalP7oGf9FUede6etH563XiKgiGNPFCjuKPGR/uSxfvNF6
	58M4tTfSnQ6azd9yzw+jR26aJ0i5dFyxJPupKfav7BC3Di0hyrWYAHiAJk+fjQ==
X-Gm-Gg: ASbGnctoRfs19KQ5wsH86tEAMSITegMS8gIaituCZseAyyT0nfwCTdp3HyGcTS4fKR+
	N0QzstsHQ0EFMZnhO3cR+8Lp1SJ9DRpYZ2wLjj12USpvsLrwnt1T+KZR+FOaKdi1iXJu733Jyq2
	6y4+K0wWn8lBb70VGICRRHVvsni7wmKihjQqy0z2WHgXu/NqPL8kN3bZ0jOnu5RAZ6QyXdOIvQ8
	vXjEB0Gae0W+hQxsXsaNO3olpECS0OXecanOfK8FYgMMsdMu05BeOm1xaThT6mugtge/7pKpFFf
	uvoRw3oV9lyLS9ZZjyd0YGRc1+D7XVr32MmQe9pNfckJJvyEEJkOkheUMjvw7spk9dxC17txaWS
	We06UTLtlEw==
X-Google-Smtp-Source: AGHT+IFWNOPlW3Guyw5uFAogWr2c6RBmPpeNia2yV6RQZMbC2QrNjBo4dAxX2hlRCnwwzJwFcrXEhA==
X-Received: by 2002:a05:6e02:4415:10b0:3db:7007:297e with SMTP id e9e14a558f8ab-3db70072a21mr27112305ab.6.1747248742981;
        Wed, 14 May 2025 11:52:22 -0700 (PDT)
Received: from [172.22.22.28] (c-73-228-159-35.hsd1.mn.comcast.net. [73.228.159.35])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-4fa226587acsm2718570173.115.2025.05.14.11.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 11:52:22 -0700 (PDT)
Message-ID: <9c69fb88-d4e1-4567-93ec-ed303b9ba01a@ieee.org>
Date: Wed, 14 May 2025 13:52:20 -0500
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rbd: replace strcpy() with strscpy()
To: Siddarth Gundu <siddarthsgml@gmail.com>, idryomov@gmail.com
Cc: dongsheng.yang@easystack.cn, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250514182015.163117-1-siddarthsgml@gmail.com>
Content-Language: en-US
From: Alex Elder <elder@ieee.org>
In-Reply-To: <20250514182015.163117-1-siddarthsgml@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 1:20 PM, Siddarth Gundu wrote:
> strcpy() is deprecated; use strscpy() instead.
> 
> Both the destination and source buffer are of fixed length
> so strscpy with 2-arguments is used.
> 
> Link: https://github.com/KSPP/linux/issues/88
> Signed-off-by: Siddarth Gundu <siddarthsgml@gmail.com>
> ---
>   drivers/block/rbd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index faafd7ff43d6..92b38972db1c 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -39,6 +39,7 @@
>   
>   #include <linux/kernel.h>
>   #include <linux/device.h>
> +#include <linux/string.h>
>   #include <linux/module.h>
>   #include <linux/blk-mq.h>
>   #include <linux/fs.h>
> @@ -3654,7 +3655,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)

Could the cookie argument possibly be defined with
its size?  I.e.:
   __rbd_lock(struct rbd_device *rbd_dev, const char cookie[32])

I see all the callers pass an array that's 32 characters,
but the function argument doesn't guarantee that.

You could also abstract the cookie with a typedef and
operations on it.

					-Alex

>   	struct rbd_client_id cid = rbd_get_cid(rbd_dev);
>   
>   	rbd_dev->lock_state = RBD_LOCK_STATE_LOCKED;
> -	strcpy(rbd_dev->lock_cookie, cookie);
> +	strscpy(rbd_dev->lock_cookie, cookie);
>   	rbd_set_owner_cid(rbd_dev, &cid);
>   	queue_work(rbd_dev->task_wq, &rbd_dev->acquired_lock_work);
>   }


