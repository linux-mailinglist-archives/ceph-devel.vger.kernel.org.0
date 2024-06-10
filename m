Return-Path: <ceph-devel+bounces-1278-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BBD901EC7
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Jun 2024 12:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D803A1C219D6
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Jun 2024 10:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15B2762EB;
	Mon, 10 Jun 2024 10:05:19 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF2F7440B;
	Mon, 10 Jun 2024 10:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718013919; cv=none; b=XoaZKfCuRZqjMiodv4Qz8stdP7oFGs9RUSdJnDVUSzaOTtUdgKrzOXT8ZUNQ709i/VEBdZHzQXyNjFG+m0t9DKltz4ID271VGGj8dP0BwyNBt1opgX85ayqFpbi8z1c+CeRqFc2qB1zrq5MUBMW/n6cug9zMvEVPx4KHDXls9yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718013919; c=relaxed/simple;
	bh=AlIc3EQR7y+80/Ejg9RLFaGvxiBK2RPW8SK61+OQ71E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KzuvLgxFRlQ9/LFeeXSJ0k74Ow2JwsjE/SJVZUdTeqTdDvqthV8aiQlZJC/LQIRC70TUKbhqrz677Z5kHmINQ4j1r5O5r2OUc8OrP59I/B+SW14+YcIKoU/GQC2qJ/TKhFgqnhx2Z7DItmvepWAw8lR9XW2vQ1sU/kX07v5noRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42111cf1ca1so2426105e9.3;
        Mon, 10 Jun 2024 03:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718013916; x=1718618716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wPxDOJtBGiXCEwsNw0PSamD2lxZ6+BuGL88bRkvKmGc=;
        b=J2UcTCIxTNYtirp6rg9Rqg7+ofjmDrXXLI/p3esk4iWmOcc94kIr3FgOf8OlmXFqfG
         vSdtdLsAOQam1KieJpZ6wi/eRirGonX4enS8N9sOW1tXtVQVcwbZ/D6e112xLmcAs1NE
         w2SvjDfpn4hkCpsKCUpO5U2GJuU67EPkLpMJhCHIHQ+xI3qzuTlB3UyD8mNHMtKgbFu0
         CvEuR+743C9yQOzhv6Ug8cyL64p1nTLW2ghhUt38Y4BH0qNX1jcuP/7vUoA/AqpIoBj+
         47wTWqIlGwaLUCBdBzAGnX2G6mFQKR+IwVVQyTThje0WFbaE72fGmJR4IL0Lmll0Nf3A
         s6Xg==
X-Forwarded-Encrypted: i=1; AJvYcCVIPidb0grVnOu1OBjhiStaBBv6RqZmgD6P4xIesmi2z6WQ9290jKryl78M4zW7RL2fvB1iLz29uJpJmqqp7H+QDkeEcSWrjC7ctL7WQeyUAXkOuZIwe4Oa3Djr5sC0uNtA4UjIn4bVHHxVgyIguxJod2EZdLxudi7GsksEei8A
X-Gm-Message-State: AOJu0YwMEh41Q+Ht8CwL5G4F1aAFVAia52WhCqvlunaOhwOA7CDvUgv2
	g5waBXdGUXCibEbKiizho/83tr1s8d3lU2mkwMUENing19AdyQQr
X-Google-Smtp-Source: AGHT+IE6UPZS8bKWfPcSCEvXL5Mn6tb7fajf/wnPYc9kjt0FZaI/nNLOOovqnumfJenKH3vEDaiJTA==
X-Received: by 2002:a05:600c:5129:b0:420:29dd:84e2 with SMTP id 5b1f17b1804b1-42164a2a8c7mr63035595e9.2.1718013916264;
        Mon, 10 Jun 2024 03:05:16 -0700 (PDT)
Received: from [10.50.4.180] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4215814e7cbsm171616535e9.39.2024.06.10.03.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jun 2024 03:05:15 -0700 (PDT)
Message-ID: <5efdb532-2589-4327-9eb7-cfa0a40ed000@grimberg.me>
Date: Mon, 10 Jun 2024 13:05:13 +0300
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] net: introduce helper sendpages_ok()
To: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240606161219.2745817-1-ofir.gal@volumez.com>
 <20240606161219.2745817-2-ofir.gal@volumez.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240606161219.2745817-2-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 06/06/2024 19:12, Ofir Gal wrote:
> Network drivers are using sendpage_ok() to check the first page of an
> iterator in order to disable MSG_SPLICE_PAGES. The iterator can
> represent list of contiguous pages.
>
> When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
> it requires all pages in the iterator to be sendable. Therefore it needs
> to check that each page is sendable.
>
> The patch introduces a helper sendpages_ok(), it returns true if all the
> contiguous pages are sendable.
>
> Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
> this helper to check whether the page list is OK. If the helper does not
> return true, the driver should remove MSG_SPLICE_PAGES flag.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
> ---
>   include/linux/net.h | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 688320b79fcc..421a6b5b9ad1 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -322,6 +322,28 @@ static inline bool sendpage_ok(struct page *page)
>   	return !PageSlab(page) && page_count(page) >= 1;
>   }
>   
> +/*
> + * Check sendpage_ok on contiguous pages.
> + */
> +static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
> +{
> +	struct page *p;
> +	size_t count;
> +
> +	p = page + (offset >> PAGE_SHIFT);
> +
> +	count = 0;

Assignment can move to the declaration.

> +	while (count < len) {
> +		if (!sendpage_ok(p))
> +			return false;
> +
> +		p++;
> +		count += PAGE_SIZE;
> +	}
> +
> +	return true;
> +}
> +
>   int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
>   		   size_t num, size_t len);
>   int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,

Other than that,

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

