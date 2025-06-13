Return-Path: <ceph-devel+bounces-3116-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB289AD8D3D
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Jun 2025 15:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2308B16E78A
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Jun 2025 13:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9AE192590;
	Fri, 13 Jun 2025 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="W80yf5Jc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D801632DF
	for <ceph-devel@vger.kernel.org>; Fri, 13 Jun 2025 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749821873; cv=none; b=VQ8GxpuO3ahggqRnfj7H0mZmKY1WZwPUWitZLoQhsJAAyP6yQ62Qa7asJZsrNwyy7oXfJnOhyObEviQKm2z5FaMjQAD0C2ZPjg9iWR9pAzlm7aWCYd7d89cygVf0FFsjJPX1Y21EDPJBk30ViyS0rQRzsJ1wufP8HKqCNTkGnJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749821873; c=relaxed/simple;
	bh=BJoef0xWSj+7ZrFt5m5fWdPbULwYKZEpkk2JZYAFbMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YhGPG5DqnAEjdGQl3/487YRVj/w5IVpnGQg4pLXFyadQ8T36Spuozw3EVJvGEewlQGLq2iHLOqG2vVpSSk+AmT2O3eOiRjp6XYSwGhldG4XhhBtG8Upp0uVeVn3Yb1xRI6Mz/oAMCUiflhlqYE79XoH6g2PsVPc4JCq7Hh2yxRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=W80yf5Jc; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3dc8265b9b5so19136595ab.1
        for <ceph-devel@vger.kernel.org>; Fri, 13 Jun 2025 06:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1749821869; x=1750426669; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J+r+Bp65bEAZWnWid1OsBGNzxx17ZgRBrVVBgeYnd6A=;
        b=W80yf5JcFnxbJBJE2+czvUHP+lSXhYAfwc9Fh1A+x1zrJuA8/mCBU4R9VxWdZnsc5S
         PMbfGFM0Cj4tQLwuxqkqHZfpIlX8syRXYFRBEWWMMG0HMbZ9VQDRozUo6pJR53daBDzT
         tbRXmBsGrlxQmd5Sex5UTc1HGuoEKnfr4tzEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749821869; x=1750426669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J+r+Bp65bEAZWnWid1OsBGNzxx17ZgRBrVVBgeYnd6A=;
        b=eShuePJDXBdBbywm/4dTkvGLMPbyWUxgcZjX1BORk41WSzxr0Ugk6Y3EWFVMa3VlQ/
         CdDfR25nVXuNntycBloGSIdEsus1P72e/5kuDyJe1tZMylHjWQliQfQS0mMVNFxHdrqO
         G+Jfwsn6Y6Dxj+2fZ9jNEb2+7/bZBEvjOJTYx++7iK2qQkKrAtSmbMBY+9HOZ7KyjtYT
         Uvf/XtHByr7MPrmHYkkdIMHVsQ5907gSLXKwaJrom53mWjGKDwyNSGlEj+ZOR2sBjv/L
         o+D33CA4z9ntCfkk8uwdRl8kxgJPOs807EXCavyznBQS/FP+PoWkXezmuCnezSasPIMy
         TKhA==
X-Forwarded-Encrypted: i=1; AJvYcCWmXIBNjufXUaMwOhzAWXFrxldJnvxAjpStoX0Z1NVEUaBCWGETVqcD3SUwV+OYUKuiMtiX6XoBM/6c@vger.kernel.org
X-Gm-Message-State: AOJu0YzXAp/Rmp2TjqGp8USDANm/IPeN725uMFuPw8/Mj1Xc4p6Phdz7
	WV1MrT4bdsxmE4/9G0fac8xikGIpdT7Y0N1CYBeQxsx0rpSf7TAEgSV2ZCVKTqste0DCya0tv73
	oUUY=
X-Gm-Gg: ASbGncvaNEJaCI0xBDP8CdQl9DigCtyUeN8ZJrNdtEewTOJ9LHVlVA9fKRHBq386cuq
	PrJE609kntakHD0AYX00Qttm8iiA/VTr2khiuxx9VULMbqnDkSfiNZOWL7ZhUmDAGnxhQutV+77
	rUpP4F8t7UZy+dylCnfb+3EZgbUQj6C9y3yExnAHW4AoxvpV60xit7LMBKzMymPrU4iiDSb7Rtz
	RNzfSgImxLPCwURz1fkbBGjADKlauJvi5ScBRNwdd2vMbQynPkcxs19dc5FKULTg+NK+eZL7z9u
	uk3iLFa2gE32G0d6m2Ru3rj+5tZMRMmgWKn1YDmra84XC6qjLYhjFE60heFt1rmq60oJNILtcgw
	fZwQrQpbFzDqQxNl+gDsT
X-Google-Smtp-Source: AGHT+IHmsqeaMGQ+A9VzBjS2uR5emsuPjFhHVVeYjhQKAzqV/edqTdOsFGFmJAYO4yUNC+PGzl3SQQ==
X-Received: by 2002:a05:6e02:178d:b0:3dc:87c7:a5b5 with SMTP id e9e14a558f8ab-3de00ad78d0mr34635405ab.3.1749821867585;
        Fri, 13 Jun 2025 06:37:47 -0700 (PDT)
Received: from [172.22.22.28] (c-73-228-159-35.hsd1.mn.comcast.net. [73.228.159.35])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-50149b7a47dsm301397173.22.2025.06.13.06.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 06:37:47 -0700 (PDT)
Message-ID: <9dfa0d6b-e28d-4e83-acd0-1ad7803d2387@ieee.org>
Date: Fri, 13 Jun 2025 08:37:45 -0500
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ceph: convert to use secs_to_jiffies
To: Yuesong Li <liyuesong@vivo.com>, Ilya Dryomov <idryomov@gmail.com>,
 Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
References: <20250613102322.3074153-1-liyuesong@vivo.com>
Content-Language: en-US
From: Alex Elder <elder@ieee.org>
In-Reply-To: <20250613102322.3074153-1-liyuesong@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/25 5:23 AM, Yuesong Li wrote:
> Since secs_to_jiffies()(commit:b35108a51cf7) has been introduced, we can
> use it to avoid scaling the time to msec.
> 
> Signed-off-by: Yuesong Li <liyuesong@vivo.com>

Looks good.

Reviewed-by: Alex Elder <elder@riscstar.com>

> ---
>   net/ceph/ceph_common.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 4c6441536d55..9ef326b0d50e 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -530,26 +530,26 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>   		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
>   			goto out_of_range;
>   		opt->osd_keepalive_timeout =
> -		    msecs_to_jiffies(result.uint_32 * 1000);
> +		    secs_to_jiffies(result.uint_32);
>   		break;
>   	case Opt_osd_idle_ttl:
>   		/* 0 isn't well defined right now, reject it */
>   		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)
>   			goto out_of_range;
> -		opt->osd_idle_ttl = msecs_to_jiffies(result.uint_32 * 1000);
> +		opt->osd_idle_ttl = secs_to_jiffies(result.uint_32);
>   		break;
>   	case Opt_mount_timeout:
>   		/* 0 is "wait forever" (i.e. infinite timeout) */
>   		if (result.uint_32 > INT_MAX / 1000)
>   			goto out_of_range;
> -		opt->mount_timeout = msecs_to_jiffies(result.uint_32 * 1000);
> +		opt->mount_timeout = secs_to_jiffies(result.uint_32);
>   		break;
>   	case Opt_osd_request_timeout:
>   		/* 0 is "wait forever" (i.e. infinite timeout) */
>   		if (result.uint_32 > INT_MAX / 1000)
>   			goto out_of_range;
>   		opt->osd_request_timeout =
> -		    msecs_to_jiffies(result.uint_32 * 1000);
> +		    secs_to_jiffies(result.uint_32);
>   		break;
>   
>   	case Opt_share:


