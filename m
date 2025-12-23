Return-Path: <ceph-devel+bounces-4227-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D8613CDAD98
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Dec 2025 00:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BD1730422BD
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Dec 2025 23:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9AF2EDD40;
	Tue, 23 Dec 2025 23:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpcEOuvg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VIlXGj29"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E872868B0
	for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 23:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766533463; cv=none; b=oJLbLq/6M6ORe2NGGeX/HVLS6IOadu3Ttk8gn7SlBbWNteMaufnXtiFxF9UTDNFMhFjnvqYJHOXsNV4WNn9b+Za3+1isNrmOCvoyoUrvVrR0fesECPsjEuoU70Fd4egH0suRnATIa5WNyiF/qIVTvi/zXyyxXRzfFT5DmmrtSlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766533463; c=relaxed/simple;
	bh=/8kN33I8bA7RCPX+VbXGZd1QkhUHJAOsoieb023EkFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=utFH1i+eeZ3C8iR5WAFWxWu4KFdaUkgXrzx+/iybPCzj4z3GyXDl0GjQomVdT5DKRMGRZNvF8XU3cOPrxcTtpHCcnGEEDbtQTTHKWJGxyMOMAhkWwWzcojFMAo+dkctlX+gcKBEUCrFy+5mw2Cx122Sm3QLpeJ3HnKHbAACByGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpcEOuvg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VIlXGj29; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766533460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ATYHY/NQnVWjttH1cUnHv7Cr35FcKdWXAUZQFCTGU6g=;
	b=CpcEOuvgoRXIpsb7Pkhx6DVphzww8XvraOBWY+EykUF+SceFI6ao2/uksWuvEYVtLsGH+s
	zjBHjonrcs1yD+aXNQDyZf7x1B7LpZhePGU2NPfkhI7SAb52W2SZzK5qM9nM+8bt8W+EzG
	NTgN4EakJJYWpt+EACoaZ2lMWNMFSqs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-l-fYE-4xOe-SRdrH-1Vbsw-1; Tue, 23 Dec 2025 18:44:19 -0500
X-MC-Unique: l-fYE-4xOe-SRdrH-1Vbsw-1
X-Mimecast-MFC-AGG-ID: l-fYE-4xOe-SRdrH-1Vbsw_1766533458
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so143004565ad.1
        for <ceph-devel@vger.kernel.org>; Tue, 23 Dec 2025 15:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766533458; x=1767138258; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ATYHY/NQnVWjttH1cUnHv7Cr35FcKdWXAUZQFCTGU6g=;
        b=VIlXGj29v7urgxe2Z2ttd4QkwmjKSlbtqQ+J8kB4RLL5VD1eRv/rMlZ+2NYZr9aBYK
         c7szI0t3nfdDD97uvNZxwBrVHXdOwVmZgyAsDaUxJFYdgV2PWmFpacmBK9rXR/fnz6Gq
         SC5Mg3ArOLOXbjsNijCSJpiDGNWGWwE7RH6GrvTyAwM74sbq8Z5VefTuIE10epxM4h42
         9u+Xi69lzafo5dnyRD51CTQmeNUYQ1nRGVsXDaB9ko63lkTmRJP2mWguC5ULt72QFuu1
         5qRBLAo0KAgpGHeL+aS7ixmtsZNlYyOVDY2ZpsiKQVllFnjOselk9NUwCXXo0dddLwze
         /keg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766533458; x=1767138258;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ATYHY/NQnVWjttH1cUnHv7Cr35FcKdWXAUZQFCTGU6g=;
        b=rsmybWWth6WF0oXGCtxzMJT4SxRbAp9CuRvM76CP0J3QKYVObRgzgl/e/Ncw/bKEec
         CJfYBI5u0ML0G50GqyriWltHMrLPf5m/8Xn6w5D81aA+rHHxBA6+Tnmo9/ki993d2FlR
         sGKuSpf3Mj6ugMpQbaZdgKeP2WkQZVhf3IY592gOGE1yCmQMW3In34F99GPWSv0TnMjf
         NDH25D2Mm0kcz9tAP8QTozI3AM+evLWVT8wQnFZiJrdL0/zAMmdxhY3F8j/HJwNvcljV
         AeaoGKLvSf5G6TGew88eOJaMmWUq+GHUuB6cdvDhwGf7Ged4kl6CuooYX0olMIxKaC38
         Wx/A==
X-Forwarded-Encrypted: i=1; AJvYcCVc6ZlAb3poprb/D06v+KDArg2qn1f9jqIyXlE64yFcaMB7uKLaG426oI5Act3RAfVddJk6icLnaxEh@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy9oNh1wGudqu3IHpoMq33KtfRHI6SQm15R1EQ5MfyNplvRZ3r
	5DTSTUNJJS4w/02oxRLNQE5rlhO4sATtWjM6675kTameJJiovP3ADpmgU6gBnoRUK4ZQCsumfkp
	y8GE1/2H5Rq3e7dlv01a+n9jdpTvoIHiwjuoT/iW8cezZEgDCNmBZX8PmITPFxRE=
X-Gm-Gg: AY/fxX6aWBkQdC2BORsLKiPOpTCqwv5nZR7SfyK+9sYxcDLe5+N6yC6+N76w6iRTWPK
	bqHmNy0LKBgy/rc2dEbyh+mLOF4HmBEM8v6DnSQM2h/4++5iWJ74iytpZKpF+D7A8Z6Y18sfSh1
	Q6NtA8g4Fo3cqi1N0TorEYZVDniaTiCyWX+fVuPIDmck4YvES/YmYtdxtUicpsL1LCgp+6f1m2r
	Gl0ag35Ia/7Uu2RmIveAHSVnu7n3o4LK5DZMhFhhNp1pGPtQAuP7BWP80SB2yCRIPVcbwcwlDYA
	OpZ32GCmU12XV2bsKbkOHRrWbKMjdEcnmEou2EbQAQKAOvev2v6LZ8Ee7MhlnsO8I1PrFS4YXKi
	/SpMZSOGS8xs=
X-Received: by 2002:a17:902:e785:b0:2a1:47e:1a34 with SMTP id d9443c01a7336-2a2f1f6a1c4mr162159915ad.0.1766533458285;
        Tue, 23 Dec 2025 15:44:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEV5T53bI9KkPU9CRutY6p/Ev419keVrVfn0QAl2ZyrODs+H9QO2wxDfhp8EuTrnIplB+ETZg==
X-Received: by 2002:a17:902:e785:b0:2a1:47e:1a34 with SMTP id d9443c01a7336-2a2f1f6a1c4mr162159805ad.0.1766533457951;
        Tue, 23 Dec 2025 15:44:17 -0800 (PST)
Received: from [10.72.112.70] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d6ec6bsm134758765ad.87.2025.12.23.15.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Dec 2025 15:44:17 -0800 (PST)
Message-ID: <bff1133f-d07f-441c-aab4-d0b6b313b7ac@redhat.com>
Date: Wed, 24 Dec 2025 07:44:12 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ceph: rework co-maintainers list in MAINTAINERS file
To: Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, linux-fsdevel@vger.kernel.org, pdonnell@redhat.com,
 amarkuze@redhat.com, Slava.Dubeyko@ibm.com, vdubeyko@redhat.com,
 Pavan.Rallabhandi@ibm.com
References: <20251216200005.16281-2-slava@dubeyko.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20251216200005.16281-2-slava@dubeyko.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Xiubo Li <xiubli@redhat.com>

On 12/17/25 04:00, Viacheslav Dubeyko wrote:
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> This patch reworks the list of co-mainteainers for
> Ceph file system in MAINTAINERS file.
>
> Fixes: d74d6c0e9895 ("ceph: add bug tracking system info to MAINTAINERS")
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> cc: Alex Markuze <amarkuze@redhat.com>
> cc: Ilya Dryomov <idryomov@gmail.com>
> cc: Ceph Development <ceph-devel@vger.kernel.org>
> ---
>   MAINTAINERS | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b11839cba9d..f17933667828 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5801,7 +5801,8 @@ F:	drivers/power/supply/cw2015_battery.c
>   
>   CEPH COMMON CODE (LIBCEPH)
>   M:	Ilya Dryomov <idryomov@gmail.com>
> -M:	Xiubo Li <xiubli@redhat.com>
> +M:	Alex Markuze <amarkuze@redhat.com>
> +M:	Viacheslav Dubeyko <slava@dubeyko.com>
>   L:	ceph-devel@vger.kernel.org
>   S:	Supported
>   W:	http://ceph.com/
> @@ -5812,8 +5813,9 @@ F:	include/linux/crush/
>   F:	net/ceph/
>   
>   CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
> -M:	Xiubo Li <xiubli@redhat.com>
>   M:	Ilya Dryomov <idryomov@gmail.com>
> +M:	Alex Markuze <amarkuze@redhat.com>
> +M:	Viacheslav Dubeyko <slava@dubeyko.com>
>   L:	ceph-devel@vger.kernel.org
>   S:	Supported
>   W:	http://ceph.com/


