Return-Path: <ceph-devel+bounces-3697-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63007B8BF0F
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Sep 2025 06:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28DFB16C504
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Sep 2025 04:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14EF421B9C0;
	Sat, 20 Sep 2025 04:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLuGppCK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210AE1B7F4
	for <ceph-devel@vger.kernel.org>; Sat, 20 Sep 2025 04:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758342688; cv=none; b=nWuG51NJcWUXO2CwtcjesD7zTOciw3qp1G8/hmLQHXAjt4PgvFVQDj3ggydwberkG4l+6PshjGYmP2u+oBlKemj7UHMmH3Fy3Q3OH+AHVIHNe6l+HCbvyWrpUhsAMy/UgUe3HvT3k29WmM4hWlSWpupexjhPhdkwPrr6nnOA5+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758342688; c=relaxed/simple;
	bh=kAny4aRymFDIo+7FPT/ml2qL4nKq50MkuxSYtUo1xdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D34shcCHuHjXBiSvJAphO/ANAR/eo47RKoVlxmvwYsOYGbAvhk2h4UFI09iJ79CA4tnI1LkZtUZKLX1dGrNfdQtLM7QrTgg4Cn2mx518NXJ4pnkpIcoCryXvNnGiWBRtaopbIXowNvfhu1poBFzMlDVKdvVsMKkP6mK4zxOSbh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLuGppCK; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-4248b320541so6037785ab.1
        for <ceph-devel@vger.kernel.org>; Fri, 19 Sep 2025 21:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758342686; x=1758947486; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mAMf/yo/OOBBY5X1PTbs08x/sucOGtYlA3nCLcNTs+g=;
        b=fLuGppCK4DAjqW2augM3XZ8Si1RMcFrTAkhTtUvRhH0k/DXAIsFNsnQe33qYOjkDng
         nNwrfJWpcAk++ei1tdRu0b/xa/dqgXyvawOXT8SsK/3ZzsRHv1grK/yp2oAR8fVcAXwR
         aPLMAYcsE04tGb7zBj/O6Qr417zM0P4kI/UM02G3avJZ5HQDfbHVXmexAcnnqoce6IS2
         9FBhY/pEVVjVVg5xdbQ9mKV3F8F4pQOU6bNtMts9IsOZfNrtNgB2MR2fO9OUWzHlSwGv
         rXbKeVem2CeEgaM0ME0xcM9hP7hYEEqA6iIC8ZpUfEdjXSYAS+7rUZe5/gatEBHDMS+Y
         mUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758342686; x=1758947486;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAMf/yo/OOBBY5X1PTbs08x/sucOGtYlA3nCLcNTs+g=;
        b=cntb5WEYuOPS2k+DWqbAqBh6EcpcC1BT9dz0U7GxPZZpTXreyOex/WphlS2n80xTtE
         dtwva42OkMNkTT3lWolJYorB0+mTKfD5zaBWMdsfKFexym6JCy06ZvOZKiyXs+0iuKA5
         mpIpS/WNf7lc0YDwHHU5Afym4m+JmZIkFPX6uzN1jeU2GT/rTsipX2xarWdFsjp29HBy
         RxOYFabr2uX1Qma0c9ePdZ7C/KZn6+WIJm6aFuC2MF/CnmPWhbFLeRt10gf5JhL/EEPU
         lF1nThGVZzgiO1cgsqGAgvSNQ/lnjFuMe0KxMiNy9ts7kIT12RpgoZ2Cq2ul2PaT/mnx
         8EsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTxBhD7S3RG7hTZMqSgt2uwAFgUj4mupbYgQOxgyca6rLVAaVPslfQA5dPqOku73gdvkoYFxPSBOA6@vger.kernel.org
X-Gm-Message-State: AOJu0YyZrMHtJkbz6wK+DP/F/eDkQG76Trq15jujHozv7Exumcc1Jnrc
	nR/GTjJgZMqTmjUp21b1itM2YWE3AttsHHUNAu3bMuqQUYJ8D9RGibMh
X-Gm-Gg: ASbGnct6ftuuYohkMAnFa56Hdt3bkC62CMnIJ4k9O9JydHFafvAxKO8/RuNGJkXF9lt
	SpvgOM6DGDEtFfFsT9igdjTPls2KoeI418rStW35Ncqqj7+3MBCDwwcZcYEYbU+1ImoxQOr5QOY
	7xU1RozrsCsoBRzPvmVeTMJ2jDgYRsjRYOuPsT7JQOZqzi8n22W10C0jOpcGtAPcZQxt332Jdpr
	waZookoQJ6pnlMo/2P3aqQ/UIYdwJ+JPOTbbj9yaqS1C13Hq/9NdXXrSFaroDRvurdNHjwZLveC
	TTSpmsOiuu3UfkC4f/zMxdOCyV4CHAkCqYX/qb7km2eeAfOwI30DonBnmbwlCa398X1lHQJdyZ8
	kJCBbd6DqtRgpSOnC0ouFSui8HIghi/2QaglVwg==
X-Google-Smtp-Source: AGHT+IFcG4QqJ4nlgO3oq0I1YnwOZ/K7SIrMHUnkDcvBmlrkEhfFU8B8mZqzq5hu5cnZ8bWVDrbaVA==
X-Received: by 2002:a05:6e02:156b:b0:424:30f:8e7c with SMTP id e9e14a558f8ab-42481909f5emr98881625ab.10.1758342686244;
        Fri, 19 Sep 2025 21:31:26 -0700 (PDT)
Received: from ?IPV6:2600:6c56:7d00:582f::64e? ([2600:6c56:7d00:582f::64e])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-53d56e429f3sm2997444173.74.2025.09.19.21.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 21:31:24 -0700 (PDT)
Message-ID: <73885a08-f255-4638-8a53-f136537f4b4c@gmail.com>
Date: Fri, 19 Sep 2025 23:31:22 -0500
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] hide ->i_state behind accessors
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com,
 amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-unionfs@vger.kernel.org
References: <20250919154905.2592318-1-mjguzik@gmail.com>
Content-Language: en-US
From: Russell Haley <yumpusamongus@gmail.com>
In-Reply-To: <20250919154905.2592318-1-mjguzik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/25 10:49 AM, Mateusz Guzik wrote:
> This is generated against:
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs-6.18.inode.refcount.preliminaries
> 
> First commit message quoted verbatim with rationable + API:
> 
> [quote]
> Open-coded accesses prevent asserting they are done correctly. One
> obvious aspect is locking, but significantly more can checked. For
> example it can be detected when the code is clearing flags which are
> already missing, or is setting flags when it is illegal (e.g., I_FREEING
> when ->i_count > 0).
> 
> Given the late stage of the release cycle this patchset only aims to
> hide access, it does not provide any of the checks.
> 
> Consumers can be trivially converted. Suppose flags I_A and I_B are to
> be handled, then:
> 
> state = inode->i_state  	=> state = inode_state_read(inode)
> inode->i_state |= (I_A | I_B) 	=> inode_state_add(inode, I_A | I_B)
> inode->i_state &= ~(I_A | I_B) 	=> inode_state_del(inode, I_A | I_B)
> inode->i_state = I_A | I_B	=> inode_state_set(inode, I_A | I_B)
> [/quote]

Drive-by bikeshedding: s/set/replace/g

"replace" removes ambiguity with the concept of setting a bit ( |= ). An
alternative would be "set_only".


