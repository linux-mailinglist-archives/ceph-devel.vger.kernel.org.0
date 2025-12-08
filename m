Return-Path: <ceph-devel+bounces-4167-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F56CABB59
	for <lists+ceph-devel@lfdr.de>; Mon, 08 Dec 2025 02:02:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3C4233003059
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Dec 2025 01:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533EF3A1DB;
	Mon,  8 Dec 2025 01:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eWnnZJSL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C433B8D51
	for <ceph-devel@vger.kernel.org>; Mon,  8 Dec 2025 01:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765155721; cv=none; b=BpXmYY1LXrC4K960wxsszNjogiIIyDPIH9ICMbMawwNo6YV7mr7RoELzhSsXWRd052p1gDi2vnmP9c364bMh2l4cJaWVn0p/9FV/sC6jX98fJsFsRaDkdRMjouP1FwKccEe2MGUD4ApTmHbhXmeH0TwuGQpxSm62WlSk42tbqeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765155721; c=relaxed/simple;
	bh=nKYGmn8MtEVmEwgLFmmy5Fb7btgub39hjMXTuQ4qI6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fflmPQT/JkzFXD4FaKdBR3VOqsKAYB2UWhmIaUi3ocNotiHK0aOX8+uEl9V7oepYXyHsCnDc7peAm+hwbAKIRVOyZHcD+jRuDZYn7fxgFqFYZgWezIJ8Zwjwu2TGbwBrhNx4rk43xJBo3+zkqk0PMKW4mzRzYNJnyTQGyNhhVb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eWnnZJSL; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <59d516eb-bcc9-4e1b-8b69-42ac75399ca0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765155716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CI0y81w2UxFWlT4pWievY3wQYMKmVGuLL7VKmJiD67s=;
	b=eWnnZJSLLgYlzYsL3cvyFJwG0u0f/j6K44gmiZqssnHNy6Y91QjiWUEgrIU7nBETFujZk4
	4AnNRGsq4Dr1DK0yGA9DeRQSUBMWu9uI51KMT7B/hS/aSpBkTj3OtkYvV1KRNInujLiJ+Z
	Iio8bEew96yLL0/v1aOxCdb5WaST5ps=
Date: Mon, 8 Dec 2025 09:01:47 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] rbd: stop selecting CRC32, CRYPTO, and CRYPTO_AES
To: Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20251207170730.3055857-1-idryomov@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20251207170730.3055857-1-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/8/2025 1:07 AM, Ilya Dryomov 写道:
> None of the RBD code directly requires CRC32, CRYPTO, or CRYPTO_AES.
> These options are needed by CEPH_LIB code and they are selected there
> directly.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Reviewed-by: Dongsheng Yang <dongsheng.yang@linux.dev>


Thanx

> ---
>   drivers/block/Kconfig | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 77d694448990..858320b6ebb7 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -316,9 +316,6 @@ config BLK_DEV_RBD
>   	tristate "Rados block device (RBD)"
>   	depends on INET && BLOCK
>   	select CEPH_LIB
> -	select CRC32
> -	select CRYPTO_AES
> -	select CRYPTO
>   	help
>   	  Say Y here if you want include the Rados block device, which stripes
>   	  a block device over objects stored in the Ceph distributed object

