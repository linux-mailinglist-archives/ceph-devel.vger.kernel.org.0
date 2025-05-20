Return-Path: <ceph-devel+bounces-3052-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB78ABE0F4
	for <lists+ceph-devel@lfdr.de>; Tue, 20 May 2025 18:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F1E24C4A43
	for <lists+ceph-devel@lfdr.de>; Tue, 20 May 2025 16:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347D326FA76;
	Tue, 20 May 2025 16:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="TvHMWY1D"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8219B24A076
	for <ceph-devel@vger.kernel.org>; Tue, 20 May 2025 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747759461; cv=none; b=pNcXv/0SBDCrpiToHfJ1AvikCcPTAkuzUVTgGZf2cfCnLJBnVythWq2Th4qx26h85x52cAfWGjwA0Q36U9S0TfvbBGSEA8wSAgC6/bRrFlFYeCxzpIaQQyD/UXPEGjtuxTLr7ZqUb7yyoUA3nBpT/LnU5myVUNDL8iiFImV0hXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747759461; c=relaxed/simple;
	bh=I8LrWZqIHYlb56pv6j0QfitWQLXKD3XwqYdsmYabKlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LHwbW8+Ji2jB7Up2jUohWQgLFTi1XtjjaspMk3Q7Ynwx7N80n4EsMIP4YJp9lJTiqaHEUj57JZceStEAgLQ32O2JX5YeW0zribNhBkaTWHud6pDGF2jQ7DdxqK+TsXQZ0Mt3q5HTlXxt8DpExFYjqLrBjkV0LRdVDCckB3QOZC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=TvHMWY1D; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3dc75fe4e9bso6456435ab.0
        for <ceph-devel@vger.kernel.org>; Tue, 20 May 2025 09:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1747759457; x=1748364257; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dIhSOsd6KsjfJUD60NW9xxZfhreQZz87ROZ1U+eqjAc=;
        b=TvHMWY1D5krt6vooVpMoMNrnD3xZC623xhOoO0N0EB6SCfd0JpOc6hqXR6MraworQc
         TYqXlxDRmhtEZSvs7eG53CUMiak4WiuYgJ9KwPebVnLVpO65soNNo+0f6Vu+gX2U6rY2
         +YThxTJM67pBxTbrUSjgnuftsKMUr0H/t/a5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747759457; x=1748364257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dIhSOsd6KsjfJUD60NW9xxZfhreQZz87ROZ1U+eqjAc=;
        b=Zw+CEXIE4QOSZmruckmMRLVVZbfzCLxkQen3u1Jqi/29b+sBLMAB3mx5SoWhjoQCoe
         IByAgTvRRYOBr7AA8uK2DFgnMxwzCR8yncshlfaYfa6vXy4WGRpNLhY6S1Sb/cIItBGo
         +tK52qPp6E6u6PZIXpUCg02qk8ZAe7hIiv2CAWeZ2uMW6Nk5yL0ZsPznfp0moGnMeyjV
         sPy74uMDS/mz9FFJoLmjhHNV2HG9hgTBc5IW/kY7PeSXaJKf9ywAUXYa20e8fsr9osdT
         rYravZN9tRGri55sHepzOmIzpg7MlSLCIqUzou4TTcpn0nPe5YyQtpD47phli5IvJQcy
         goig==
X-Forwarded-Encrypted: i=1; AJvYcCW7hQxNbFEv/9+t4lZm21GBhT5oSmUPB3B75EEgyq6KIsK5tLSZ9LkA+GN+RN9sHucMA5qsMvwS9B63@vger.kernel.org
X-Gm-Message-State: AOJu0YzCxzK9D0O4d/1oNTmCsNkmsmNrWeptzK/ZOX5+1K2Ul4dRUBE2
	xDa3h/GUDzaURmlTlzNiVUIUX7Ed+QSo18TVlHQlV84nTQdYPOGrF8DJ2EP5zF67qA==
X-Gm-Gg: ASbGncu/AlaCeAvPJ7W9DsfdZ2mAyixgsP3L1sfaojTrdXDeLvYG9pcYeYazyMShhlt
	m5GvxhSH3HWJ3BT2zfaKHcOHdge3iaAqbidjlGFYWJXvwCudbxrK20YqpSNFPlgj7BJy3kWVTR1
	xy5IetmkiShTfDYPCzOqheFskxkfDQZgFDRoBxC0V0TphmlH7/l+J+i4/CuUXMvlbC41e3zjSb+
	vJNTZJ73wn1ibTYDRHZsFG2BVi2s0agiADalwucV5LYGgxIszf1TqPLW5TnXg6RpEuqPd384RKU
	sdwdA3Qjt40pYw51PSWlsBSFhiSHUJVz1/KiYmqm0wHVknigbLfjHq7U/GffBDQwY3fR6+UYr2d
	bJT2BymuQ1w==
X-Google-Smtp-Source: AGHT+IHY7B5sqXo+CEWbfToCa57PdPA6J2aKxv4nOj0xzwl7zY48v0c2pBUeeGTux6+dhIv/h45ldA==
X-Received: by 2002:a05:6e02:2191:b0:3dc:6824:53ab with SMTP id e9e14a558f8ab-3dc682457camr98502715ab.8.1747759457395;
        Tue, 20 May 2025 09:44:17 -0700 (PDT)
Received: from [172.22.22.28] (c-73-228-159-35.hsd1.mn.comcast.net. [73.228.159.35])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea4d3sm2317814173.134.2025.05.20.09.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 09:44:16 -0700 (PDT)
Message-ID: <f92ddea4-edf1-42f9-a738-51233ce3d45e@ieee.org>
Date: Tue, 20 May 2025 11:44:15 -0500
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] rbd: replace strcpy() with strscpy()
To: Siddarth Gundu <siddarthsgml@gmail.com>, idryomov@gmail.com,
 dongsheng.yang@easystack.cn, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250519063840.6743-1-siddarthsgml@gmail.com>
Content-Language: en-US
From: Alex Elder <elder@ieee.org>
In-Reply-To: <20250519063840.6743-1-siddarthsgml@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/19/25 1:38 AM, Siddarth Gundu wrote:
> strcpy() is deprecated; use strscpy() instead.
> 
> Both the destination and source buffer are of fixed length
> so strscpy with 2-arguments is used.
> 
> Introduce a typedef for cookie array to improve code clarity.
> 
> Link: https://github.com/KSPP/linux/issues/88
> Signed-off-by: Siddarth Gundu <siddarthsgml@gmail.com>
> ---
> changes since v1
> - added a typedef for cookie arrays
> 
> About the typedef: I was a bit hesitant to add it since the kernel
> style guide is against adding new typedef but I wanted to follow
> the review feedback for this.

I personally think the typedef here is the appropriate.  But
it's really up to Ilya whether he likes this approach.  Get
his input before you do more.

There's a basic question about whether this is a useful
abstraction.  It's used for "lock cookies" but do they
serve a broader purpose?

The other part of my suggestion was to define functions that
provide an API.  For example:

static inline rbd_cookie_t rbd_cookie_set(rbd_cookie_t cookie, u64 id);
static inline u64 rbd_cookie_get(rbd_cookie_t cookie);

Anyway, before I say any more let's see if Ilya even wants
to go in this direction.  Your original proposal was OK, I
just thought specifying the length might be safer.

					-Alex

>   drivers/block/rbd.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index faafd7ff43d6..863d9c591aa5 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -46,11 +46,14 @@
>   #include <linux/slab.h>
>   #include <linux/idr.h>
>   #include <linux/workqueue.h>
> +#include <linux/string.h>
>   
>   #include "rbd_types.h"
>   
>   #define RBD_DEBUG	/* Activate rbd_assert() calls */
>   
> +typedef char rbd_cookie_t[32];
> +
>   /*
>    * Increment the given counter and return its updated value.
>    * If the counter is already 0 it will not be incremented.
> @@ -411,7 +414,7 @@ struct rbd_device {
>   
>   	struct rw_semaphore	lock_rwsem;
>   	enum rbd_lock_state	lock_state;
> -	char			lock_cookie[32];
> +	rbd_cookie_t		lock_cookie;
>   	struct rbd_client_id	owner_cid;
>   	struct work_struct	acquired_lock_work;
>   	struct work_struct	released_lock_work;
> @@ -3649,12 +3652,12 @@ static void format_lock_cookie(struct rbd_device *rbd_dev, char *buf)
>   	mutex_unlock(&rbd_dev->watch_mutex);
>   }
>   
> -static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
> +static void __rbd_lock(struct rbd_device *rbd_dev, const rbd_cookie_t cookie)
>   {
>   	struct rbd_client_id cid = rbd_get_cid(rbd_dev);
>   
>   	rbd_dev->lock_state = RBD_LOCK_STATE_LOCKED;
> -	strcpy(rbd_dev->lock_cookie, cookie);
> +	strscpy(rbd_dev->lock_cookie, cookie);
>   	rbd_set_owner_cid(rbd_dev, &cid);
>   	queue_work(rbd_dev->task_wq, &rbd_dev->acquired_lock_work);
>   }
> @@ -3665,7 +3668,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
>   static int rbd_lock(struct rbd_device *rbd_dev)
>   {
>   	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> -	char cookie[32];
> +	rbd_cookie_t cookie;
>   	int ret;
>   
>   	WARN_ON(__rbd_is_lock_owner(rbd_dev) ||
> @@ -4581,7 +4584,7 @@ static void rbd_unregister_watch(struct rbd_device *rbd_dev)
>   static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
>   {
>   	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
> -	char cookie[32];
> +	rbd_cookie_t cookie;
>   	int ret;
>   
>   	if (!rbd_quiesce_lock(rbd_dev))


