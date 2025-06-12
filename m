Return-Path: <ceph-devel+bounces-3101-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D2CAD6FBE
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Jun 2025 14:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 157641BC4758
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Jun 2025 12:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005B62367B0;
	Thu, 12 Jun 2025 12:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="b/+EWrU0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34054219A95
	for <ceph-devel@vger.kernel.org>; Thu, 12 Jun 2025 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749730115; cv=none; b=W6kYOP5HTxjc4GkBmsxUPWfJResp+KN/rkN+ztKoXbjjaPX26kvMb9kJGGV2UjLs5F7ObIQrlKo1LjBc5Dd4VlWHoFCyQYOh9hYbr0L4AB5s4SLJSBAe7v02TPjkOYaP6+CeChPu2zPwCzpbRrByKtiA61r1UqniCCnIkP/nk/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749730115; c=relaxed/simple;
	bh=/5hkVOPMuKNYyP5pXqAuGWYICPyX3micXgythDTEnfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FlsYTrMlbs7cvw+Sbd0ylEmlSErFN3toAr3NQlYn+k8Wy3XpyWFRGqk3iEg24eWGAYaYuNOSNY4OgJ+V0DHrbRlcACn6fVKtqXP2X4MHit9IGBadkq21ZFdt/XZ3tAthpn1vTK4YjuMLIHThUzaSLZcwcVZaYapOIvo076x7D/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=b/+EWrU0; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-86a55400875so87162939f.3
        for <ceph-devel@vger.kernel.org>; Thu, 12 Jun 2025 05:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1749730111; x=1750334911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oiQC+W0yjIGVwcsiN86fhi+gjf0lk8z+cPeuP0rwwk8=;
        b=b/+EWrU00bjwqoqDBfgmYPWOhkSYPf9t6JvmX8kXLzj1ZrUUYHgzKK7TZc6ZTCIm+u
         kPgS+I65OIuGFHJxyqvt7BuJ47EADr8r/3NM6rNo0FaA4y1G8LzTtpQ6EGxttSF5B24P
         /hTX0C/8paMgK9MgwJ57jgm3Pm5KPjA0ypCzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749730111; x=1750334911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oiQC+W0yjIGVwcsiN86fhi+gjf0lk8z+cPeuP0rwwk8=;
        b=ZaHCFyti2Q6lUIN5ruVkYOAzmMJ23BUnA35u0EGkYbJnYALWhojCC73mrC97b/cCSZ
         xjC+/QxUY3r2mZbdW21kZk9SD4OuEvJS/ZTEsMAe7x7BpyyEhn1PMtustGHw2I1Y8LaE
         CprcKNW+OAilsVnkgWdfOO2D217NR7Jakn4Izb2ERYTu0OG5FF+9zK3Av9gmcvW2TlJ+
         7C1gzlv8XHO5VGQ9jJgNF/+eIHhT94e/hxPEwfQMq9RiQUsC0IZIEDBwfwkKrKQmhEBz
         nwEuKf07h23POOJaw43F5OukcccjtcJHhE2iiyIAgqJAuxSaQ2JR/ne2x67u6T3Omt3Q
         9b9A==
X-Forwarded-Encrypted: i=1; AJvYcCVzNJ8kHyjkZZmMcDMczchiWr/z1BOPH1MQCnFTtyLVnXKyvC3obMao+5qF+E2XwBMYOp+tyAgmHiNX@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8FkMi96p7q9KW99WJW9r2jcMvr4oCL/MoYWzebgQyOPF/+NBX
	LGtpMrpWBi2bufCaYNRsu47JwXtUf+c35iNWbFyubsypWuB+eVNaK1SONAGnyBx02w==
X-Gm-Gg: ASbGncsBqCQFta3Mjnhgi7rvCrpANs0F/KFpQ4/NwTt8mLVWdMdT4Ft9TRo0n5wKfap
	oJTK8DI1n1eu+cBejV5IgmQfGzjPEcQ/1yOkldqz8PDey2BSfZZgymhLhQk8tHPBjU4SZ+IZCFM
	Bvz1NiLjUtWVDWI1EVNy2oakpVRlP5sMogGOEbncPyQP+zo8ho8fa2aogYwMMPQW10AiV0RPnRu
	SajU1IP0VIEvKM+LkQio6JZMyMoAlqC6FUqdHnd5IdjZf/R1cDSZEMvrUH8NKpqfV/4JmWRwGVo
	FmrZnRQscC6LN3TFva0G5EYhOwyDrj29phuImlVD535+wrOM3OW32GdhThhmCxxi/qKtwE0s8vN
	7MiPUGBG5SH2DO7puSIJ3
X-Google-Smtp-Source: AGHT+IFE6LoaIDSTbR2+Z49WPjvrD6HagrivYIZlBUHlPLtFW8Kl3MBn0+M7fl7SQRHeC/DZIkrMcg==
X-Received: by 2002:a05:6602:3719:b0:864:a3d0:ddef with SMTP id ca18e2360f4ac-875bc410f92mr880203339f.6.1749730111300;
        Thu, 12 Jun 2025 05:08:31 -0700 (PDT)
Received: from [172.22.22.28] (c-73-228-159-35.hsd1.mn.comcast.net. [73.228.159.35])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-5013b75604esm260578173.8.2025.06.12.05.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 05:08:30 -0700 (PDT)
Message-ID: <28c3f551-c1a2-4bc0-a263-a27576335317@ieee.org>
Date: Thu, 12 Jun 2025 07:08:28 -0500
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] rbd: convert to use secs_to_jiffies
To: Yuesong Li <liyuesong@vivo.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Jens Axboe <axboe@kernel.dk>,
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
References: <20250612110705.91353-1-liyuesong@vivo.com>
Content-Language: en-US
From: Alex Elder <elder@ieee.org>
In-Reply-To: <20250612110705.91353-1-liyuesong@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/25 6:07 AM, Yuesong Li wrote:
> Since secs_to_jiffies()(commit:b35108a51cf7) has been introduced, we can
> use it to avoid scaling the time to msec.
> 
> Signed-off-by: Yuesong Li <liyuesong@vivo.com>

Looks good.

Reviewed-by: Alex Elder <elder@riscstar.com>

> ---
>   drivers/block/rbd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index faafd7ff43d6..92d04a60718f 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4162,7 +4162,7 @@ static void rbd_acquire_lock(struct work_struct *work)
>   		dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
>   		     rbd_dev);
>   		mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
> -		    msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SEC));
> +		    secs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT));
>   	}
>   }
>   
> @@ -6285,7 +6285,7 @@ static int rbd_parse_param(struct fs_parameter *param,
>   		/* 0 is "wait forever" (i.e. infinite timeout) */
>   		if (result.uint_32 > INT_MAX / 1000)
>   			goto out_of_range;
> -		opt->lock_timeout = msecs_to_jiffies(result.uint_32 * 1000);
> +		opt->lock_timeout = secs_to_jiffies(result.uint_32);
>   		break;
>   	case Opt_pool_ns:
>   		kfree(pctx->spec->pool_ns);


