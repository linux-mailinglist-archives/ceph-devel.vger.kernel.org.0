Return-Path: <ceph-devel+bounces-1528-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E1E930C7C
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jul 2024 04:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53CA61C20AC0
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jul 2024 02:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A154C8F;
	Mon, 15 Jul 2024 02:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8ZBptMM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D72D33FD
	for <ceph-devel@vger.kernel.org>; Mon, 15 Jul 2024 02:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721009439; cv=none; b=sQ/Octag/OZ87bcITjtbMe9oYGGLW6u2MSNmw7DVdfNngaaG56gwzMZfhAwapqEhhqMuH+kTjNRAAZm1xgsdujYULnOxZ2ZHiyo1aTW5m1whYLh/g4vUhr0i0EWI0bM3rWWmxaEePjmkM0L4Igb5/lwLrZw0rLPlg/jAWlYPBIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721009439; c=relaxed/simple;
	bh=43HMwXO7cbJ/1U+Lfgc4ld56tq9KajIrFK3UWKEX62o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BdllWhn+PyNLvd7PBS5JaOZUEcb64Dc8dbJiMv9l8d8nQI8gMwnnAwvHLctHYhpWATe7kH/WyR7bO1e3aeHFw+pFr2qZ3fOL9im6R0C1wnx/Sf2YpXbHz6P2JfL3ejC8LB0DMshBH8vykh9fPMagHYuKa4TSGpCuXwwNTTqoVCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8ZBptMM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721009437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hKPYaZPyECC7pA4BzYeRHadFbSD4okXAM3j62OY4nac=;
	b=a8ZBptMMBnUm+0GP8tLKKa8tj5UJvYwiny7kLaSrBZBjEZBzZ8IuWMM/jgmAZZ1gsRsjZG
	H8ds4wwtINtCEHFolnKh+pu+MJfcZiU+8hFD+8iKd9TdLFjdTn5Llhe/AJ04LXhy+S4zUr
	rN/ni785Pm15/t1wOVsOrQcw/ssHa3s=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-SJgVk7bGNpqqv_f_ooCeVg-1; Sun, 14 Jul 2024 22:10:35 -0400
X-MC-Unique: SJgVk7bGNpqqv_f_ooCeVg-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-70af603db29so2537442b3a.3
        for <ceph-devel@vger.kernel.org>; Sun, 14 Jul 2024 19:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721009434; x=1721614234;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hKPYaZPyECC7pA4BzYeRHadFbSD4okXAM3j62OY4nac=;
        b=j8N8PGyGI9QfBUxdwryE4+tOfsPhntzy1kv/FEqQxp1RDM21jRF6YVaa9blqtOaYMB
         qVBj8deJZyVhfTs+n5mZ2hTxfV5sNv8M3R1yYQoxRQTCJmZN2gI3qEOK/lr97Dsmwupx
         4M4CULg93Xsdj9jE5RV/VpLzYdUGRx3WWav3SBNwg51K+GN0ZVIhnA4xYOiTAkmrh7/u
         dw5efgXhWeUMbOpAH0Qw+8E6wplZ/vjT6qRjizy27DpQ2rsyVmkpjqKRQxWBqcNtJRnR
         BkCUyBj0DpRfYQNg6wRzT+xr10G+mforV+4ECPzPG82h9d6kKyuw6XrW+3XoLSkJeN3Z
         VDzw==
X-Forwarded-Encrypted: i=1; AJvYcCVjnDd1XtNDR6y6WaDaslGVqQ4SGlBycBRIHYFyi9WDoYX+wfZ9prhj0uwKV6mhDYV6cxqrE8xAdtsc8gwGK07Hh5FBzC0vD6wFvQ==
X-Gm-Message-State: AOJu0Yx8x0/VTy0+I055yI+/a7tP6hR4+2HF7AAlR0OoKRfNrTttVnDR
	jgbkXzC9z3hpZEWvfxNnyjojGh3dgYqWXBwYeQQcE7mRPGLsZZdfdUDz7IoMZnaEmDjTTReRXU0
	cp3Re0iIk1NCYLz36DU4aWIH3WU2AoX1HwAkoBxLc1v84778dcJdEbQOZQjWICgpyYNI=
X-Received: by 2002:a05:6a00:848:b0:705:a13b:e740 with SMTP id d2e1a72fcca58-70b4356a6a5mr18746427b3a.19.1721009434676;
        Sun, 14 Jul 2024 19:10:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXPxaMjrnpxxW11tCuQEGaPAVeDQ83Y2Kg1pGIGo3r6EJnD5mMrU1wVVqJNN2BGFt/IeDSsQ==
X-Received: by 2002:a05:6a00:848:b0:705:a13b:e740 with SMTP id d2e1a72fcca58-70b4356a6a5mr18746417b3a.19.1721009434316;
        Sun, 14 Jul 2024 19:10:34 -0700 (PDT)
Received: from [10.72.116.106] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7ebb65a9sm3199913b3a.46.2024.07.14.19.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jul 2024 19:10:33 -0700 (PDT)
Message-ID: <b7738e0d-23bd-4527-9bef-ae15715921b3@redhat.com>
Date: Mon, 15 Jul 2024 10:10:28 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: fix incorrect kmalloc size of pagevec mempool
To: ethanwu <ethanwu@synology.com>, ceph-devel@vger.kernel.org
References: <20240711064756.334775-1-ethanwu@synology.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240711064756.334775-1-ethanwu@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/11/24 14:47, ethanwu wrote:
> The kmalloc size of pagevec mempool is incorrectly calculated.
> It misses the size of page pointer and only accounts the number for the array.
>
> Fixes: a0102bda5bc0 ("ceph: move sb->wb_pagevec_pool to be a global mempool")
> Signed-off-by: ethanwu <ethanwu@synology.com>
> ---
>   fs/ceph/super.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 885cb5d4e771..46f640514561 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -961,7 +961,8 @@ static int __init init_caches(void)
>   	if (!ceph_mds_request_cachep)
>   		goto bad_mds_req;
>   
> -	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10, CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT);
> +	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10,
> +				(CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT) * sizeof(struct page *));
>   	if (!ceph_wb_pagevec_pool)
>   		goto bad_pagevec_pool;
>   

Good cache, LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


