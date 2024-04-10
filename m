Return-Path: <ceph-devel+bounces-1068-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F0A89E9CF
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Apr 2024 07:35:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 078D31C210F5
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Apr 2024 05:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F58171AF;
	Wed, 10 Apr 2024 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HRf+UF85"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D75228FD
	for <ceph-devel@vger.kernel.org>; Wed, 10 Apr 2024 05:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727337; cv=none; b=JdBiPazk1RdylgTOT4AyOHcZQXLoKdpzFqrMIe9DLYgiFedKLIdeTqdDvPJn2KDjE+33OKmBOefDnu+60W/XVknnwXMM4Sf4MoVCOo5JhPiHnaT/RpynqrCHw0kcNrpT3afzCUAlAFD61fKhzhFb0lSi3ZZipi5G3gE5E4FL7Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727337; c=relaxed/simple;
	bh=93obgPk3d9jSt86o+xKN2cQKhZrnN4OY5ThygN1bg+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VjiRqLFk+r5EcEiJUIyUO0uEqABJ/LNgoXjoJVx3zIunxn68a0bCU/A1UT0A7ZaG7yqtQhqSRju3mLP93HRldf6G+rE17jbSaOgArqOpSYMpW7khB5q0IOh+s+5O/IOdlPPoFDB3TOt16d0P44TaK+Fyqf8cBxngDCYoMdHJq98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HRf+UF85; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712727334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cr/arVSAH7B1pjOOdBpt0vIwge9OobLZ71nS3jV6wR8=;
	b=HRf+UF85Oi4IBpt+bPw+1w46VW1I/iSJhNdPDEv7dJqdJF0kvIYNGltkRjUGk1GR2HQ8lZ
	q3fdj9KV04knHp9xRnHjG9LQig1+b4R3c09PVDJudG4coJVpcOCgnP/WsA71Jv5YPIA5Kv
	bI3H3AepZuytO6yRgNFEjxV8f4fqc+A=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-RD9mTrphNaisDe4ozLRmhg-1; Wed, 10 Apr 2024 01:35:28 -0400
X-MC-Unique: RD9mTrphNaisDe4ozLRmhg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1e3c2fbc920so31084735ad.0
        for <ceph-devel@vger.kernel.org>; Tue, 09 Apr 2024 22:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712727328; x=1713332128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cr/arVSAH7B1pjOOdBpt0vIwge9OobLZ71nS3jV6wR8=;
        b=tnqKakxiFvgYN8aoI27JoGU6mYU8AEEEfnv0HHHIBFdSs0ehYRXlYLJIEatMD92wNm
         Wou0u0XTJQRMUBfAEjVg8CQXmLp1Ht9ia30Nv0Si/V4+xFe02tMRB6SBfeO+aAWJ91iM
         d6DksRETx+dc3J/y5jhBSN/6rCGDavvIbBkvYtdzkhiec3D52kNF3E7vJaS+sezTSBbd
         GUG+KNKOriZ66g2wKH8h5ERgVEamZi1BWuHxaw1BBjvCBk8Qs5JkGFcZAamv5EzCMALs
         3Zy5WPWKCLEHZ/oRrX7YIaN4kywj8a1CBA2jusu+5+Wxf8PURspRsaE7A4+RQ6QVvTai
         rhiw==
X-Gm-Message-State: AOJu0Ywh2CpEhukM+cLZ/42i+BX0+6f6yZI5Q6gA/Nf1U8Mfem3ydMj8
	QCzLbp3Jhu4GY6ryhs56iIv0eRdHLmkaIXgZh3MWkQeAGrFJdAOF4Cr35iM9sb51Pk5kCpdmJ9f
	MPdV+e3MXBidVwr5KBorCHd2nKNtDi9PzXr6N9Skb0zZlck08vvpNvP08soE=
X-Received: by 2002:a17:902:e88a:b0:1e0:ab65:85e5 with SMTP id w10-20020a170902e88a00b001e0ab6585e5mr2939792plg.1.1712727327701;
        Tue, 09 Apr 2024 22:35:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoazP3Eq6f6wob2DvYKZgw3j8Eun2T6usH5u5KHOGTTWnJDVD/Bzn4SWDICD2pLAGljCm0mw==
X-Received: by 2002:a17:902:e88a:b0:1e0:ab65:85e5 with SMTP id w10-20020a170902e88a00b001e0ab6585e5mr2939774plg.1.1712727327400;
        Tue, 09 Apr 2024 22:35:27 -0700 (PDT)
Received: from [10.72.112.191] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902ec8300b001e249903b0fsm9467698plg.256.2024.04.09.22.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 22:35:27 -0700 (PDT)
Message-ID: <a340e99f-21ee-44e9-8670-2435e753cc3b@redhat.com>
Date: Wed, 10 Apr 2024 13:35:23 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: remove myself as a Reviewer for Ceph
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, idryomov@redhat.com
Cc: ceph-devel@vger.kernel.org
References: <20240409110157.20423-1-jlayton@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240409110157.20423-1-jlayton@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/9/24 19:01, Jeff Layton wrote:
> It has been a couple of years since I stepped down as CephFS maintainer.
> I'm not involved in any meaningful way with the project these days, so
> while I'm happy to help review the occasional patch, I don't need to be
> cc'ed on all of them.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   MAINTAINERS | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aea47e04c3a5..c45e2c3f6ff9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4869,7 +4869,6 @@ F:	drivers/power/supply/cw2015_battery.c
>   CEPH COMMON CODE (LIBCEPH)
>   M:	Ilya Dryomov <idryomov@gmail.com>
>   M:	Xiubo Li <xiubli@redhat.com>
> -R:	Jeff Layton <jlayton@kernel.org>
>   L:	ceph-devel@vger.kernel.org
>   S:	Supported
>   W:	http://ceph.com/
> @@ -4881,7 +4880,6 @@ F:	net/ceph/
>   CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
>   M:	Xiubo Li <xiubli@redhat.com>
>   M:	Ilya Dryomov <idryomov@gmail.com>
> -R:	Jeff Layton <jlayton@kernel.org>
>   L:	ceph-devel@vger.kernel.org
>   S:	Supported
>   W:	http://ceph.com/

Thanks very much for your strong support Jeff and also for your kindly 
help in ceph.

Cheers

- Xiubo


