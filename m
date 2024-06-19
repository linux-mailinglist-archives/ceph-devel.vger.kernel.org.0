Return-Path: <ceph-devel+bounces-1466-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48DFF90E083
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2024 02:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CF161C21067
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2024 00:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9D3368;
	Wed, 19 Jun 2024 00:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JuRZsRH6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86110181
	for <ceph-devel@vger.kernel.org>; Wed, 19 Jun 2024 00:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718756007; cv=none; b=VMtqjaAdoJpQwKzCIXar3LJQ0LrmYHp0q95q20BTN42X5lOQk/IE4bCPjrfgiZn7yHv1JD2aj+klEt8WsHuP9X3H35iwm4qlfMZ2LvFmS3ZdtAB1Kw+Kud7hF98SeuiVo4ZDbq2dEWI2UhLJNXyxcPEY0F/jGkxhBGWw6UwqZZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718756007; c=relaxed/simple;
	bh=lR6Qk4olaYaYoNe8FVX4dijr0ThZKOTSJKnXzeGoMtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KRCz5SRIidBmE3J2qzyJy+ca+oFYI/W1r+nMa3b5+m2lg8WoFpSNjbfc4LJZ+yOE+hm7t9SLLwURrdm5+80WY+WE0eCnweekBtcXDKTd2ParE9Zy7+WlVrgQh16ETDCAHD35LqAyDbKC3WRQ3pj8p+3qDi6nVuEc01pzsblLRE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JuRZsRH6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718756004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qr+EHjqcXFCRZb4Wb/R4c8LN/Ts6luIfZ2TV0eyTTzw=;
	b=JuRZsRH6/D7NOUSdq/7o9dea5omTFpDyEUBkzcvoIck+K8kQDt8XHNS84HNanuqVKsHB9F
	wIOuN8LLVp7asksymgVJI4rG2CdVT69TMIs+HfKL7ACtTKJyoRikY9tPdhIlQ0fcT/E4UN
	FpQY0w266BdHzLwJznVvKBxpIsfQ/eQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-Xq3jjWY_NNKs9dvbdfTpFQ-1; Tue, 18 Jun 2024 20:13:21 -0400
X-MC-Unique: Xq3jjWY_NNKs9dvbdfTpFQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1f9a6356a02so6583735ad.3
        for <ceph-devel@vger.kernel.org>; Tue, 18 Jun 2024 17:13:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718756000; x=1719360800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qr+EHjqcXFCRZb4Wb/R4c8LN/Ts6luIfZ2TV0eyTTzw=;
        b=A0UCrJsD2XQvnNxgchuklwTZ50lgLFDzhgobbgdHAeyrBbinqDMw3i9OR8RB9wi/eH
         w95mObK9WqNcPbAQoaIb74ZSu57rM+e5Qh3ILmaJ1QxzVg5m12RAKA4ZrIR0Vae+CAbS
         lij0ja3+PPbAgBRNKGCPqX8Laz28QFEPP2EVRjiQoF3pXJnzdvPVGEzEv9WftYJIxQDg
         mg/ryECo/8HCsLWt+mFtnxoWW9de5DoDi3Q+DXcfAxQUL9kBfdNBIorutGXFfy1TwySm
         CWTYYPx98xeYGSd0qf9x0vt/+61c9iZhNF9+ej+n5VUbXvCsnkNY4/ASL9SH9AQ0wSc2
         2HpQ==
X-Gm-Message-State: AOJu0YzeGGB9zwSnmg+Py8O5EbEqfEBNgk6pRhL1tsi4rrWosh2A+3s0
	NguyyUX96mM+BOP3zFd0TxgmexOZz2vQv5YTDyQgrldk8L1WNa0usVS6j7RTSAiIfa98DRRVGF8
	auue/LUNrPTtXZnCchpgeEGFwPZKgw++pzLdkZ4xmBuSwhKu+SK2o3nTcY1TRxaNzRnrTdg==
X-Received: by 2002:a17:903:234e:b0:1f7:22a8:4f8a with SMTP id d9443c01a7336-1f9aa484f36mr12115035ad.57.1718755999502;
        Tue, 18 Jun 2024 17:13:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzadG68Z66EaP0aTXxOYqhdIESJ2Jpdt8GU+AZ7PM81ITjFS2EFXUcHXjri3Q8+XsCKtau0Q==
X-Received: by 2002:a17:903:234e:b0:1f7:22a8:4f8a with SMTP id d9443c01a7336-1f9aa484f36mr12114815ad.57.1718755999060;
        Tue, 18 Jun 2024 17:13:19 -0700 (PDT)
Received: from [10.72.112.11] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f15149sm103670495ad.218.2024.06.18.17.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 17:13:18 -0700 (PDT)
Message-ID: <c952b08e-69ca-421d-bb41-7b5990e1a1ca@redhat.com>
Date: Wed, 19 Jun 2024 08:13:14 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: avoid call to strlen() in ceph_mds_auth_match()
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: ceph-devel@vger.kernel.org
References: <20240618143640.169194-1-dmantipov@yandex.ru>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240618143640.169194-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 6/18/24 22:36, Dmitry Antipov wrote:
> Since 'snprintf()' returns the number of characters emitted,
> an extra call to 'strlen()' in 'ceph_mds_auth_match()' may
> be dropped. Compile tested only.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>   fs/ceph/mds_client.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c2157f6e0c69..7224283046a7 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5665,9 +5665,9 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
>   				if (!_tpath)
>   					return -ENOMEM;
>   				/* remove the leading '/' */
> -				snprintf(_tpath, n, "%s/%s", spath + 1, tpath);
> +				tlen = snprintf(_tpath, n, "%s/%s",
> +						spath + 1, tpath);
>   				free_tpath = true;
> -				tlen = strlen(_tpath);
>   			}
>   
>   			/*

Both snprintf and strlen will return the string length without the 
trailing null. So this change LGTM.

Applied to the 'testing' branch and will run the tests.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thanks


