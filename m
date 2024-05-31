Return-Path: <ceph-devel+bounces-1233-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2EA68D5D26
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2024 10:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 290091F25345
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2024 08:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38ED015575F;
	Fri, 31 May 2024 08:51:10 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A275136E23;
	Fri, 31 May 2024 08:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145470; cv=none; b=ECqiiPOYCioumBJ2R5dkkHRFOjnzK07ybp6dGMmIHSNhY6UsIYinsjAI0xMyb7OyltLX80doh7zXzlYdHgPXm8Qp+bogKb57z4ule4FQeVTxXnTynTXQM+4IwX73Q+f/RyZUNlz2XMs4auHI//87hgBtX/AlXTlD35cAw8jM8Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145470; c=relaxed/simple;
	bh=hdoU16+sLSX8raAJ/eIvXAYVtS2Mu3wXvkczNWSlYNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IUfMI4+my4rE38YGIPAHwM5ria3Z8Y+1e/+kwtrIU2hQACFvW5kkLeC6ytvWWePsbsRgX+y6XxOlS2Gpt2g37QveskI4nwDcAEgkpcfvnBReQkMKnjhSdPjjAhOJoKXlsGu9XbhPAppbvOM1aqyX339pCv5n/VkBbw43350fLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4211323a709so2347125e9.3;
        Fri, 31 May 2024 01:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717145467; x=1717750267;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FW4G8B4caU0ie3GvcsCDqWy2GOMbEDVFmUW+vM3YSGY=;
        b=ng3n+VP104e+rwZqGWoH+vovlSg/mNPxA0HiOCmENTwiZ1jRI/fWoR8Ok3e/UbnRdO
         ONuTULClhUpWGA2DxwnufAuuyaV1I5hsecjBsdgqJSr/CZaES0qoG+oGR+7AJecdE++Y
         TGwZgP80xa0ywTDTjhIN10ZviGUvW+CR1dTojBl4Vy6eSDwWjaef4FiRs4ATv4nLb8db
         YgpJKxLOCvDmqkXNNbjALi00c2mo+mJb+dzI8ggsNa+WtTk+ZW8J3kyGnb78KLH57YOq
         n2APqU2XH1xqxKmwmHyHDElA/MXI8HajxVf33Ub9pQkM85Y4beb5p36Q1Hs/h2mYEvB8
         KnzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXC7SwkcMBfHKNNvoCdicZQnBCniyiq7y6qCOBHdScaFlmFEZEWPmjVqnDwmoaVx7zhEi50LA6upz7yLFtmoZ0OHff+h2lC8NF2tU/wYo4XZZ+P0MO4pqB/HUqbYbs8fkkqQ7bh3IxqysaftTgXU0BF3MahaFA9XroNfNnGrENW
X-Gm-Message-State: AOJu0YwpU+obmjbQEkdUpHu6XgNEJ0OLLlOPIatKtBmhTLDWaY3Yf/lZ
	P5NHNWgCEhhdCQ6RXZTvF/PexO4JCKYwRaFj4U3sfb7yYHSlTumN
X-Google-Smtp-Source: AGHT+IE0qlRpHCk7A3rlMfeWBmqpGsLaF/G7osysiPnBEXojpS8nDJKC0ci0ffQT8IRDohTHpm1cAg==
X-Received: by 2002:adf:f308:0:b0:354:db35:63a9 with SMTP id ffacd0b85a97d-35e0f1af8c1mr944414f8f.0.1717145466515;
        Fri, 31 May 2024 01:51:06 -0700 (PDT)
Received: from [10.100.102.74] (85.65.193.189.dynamic.barak-online.net. [85.65.193.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04c0a33sm1389227f8f.7.2024.05.31.01.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 01:51:06 -0700 (PDT)
Message-ID: <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
Date: Fri, 31 May 2024 11:51:04 +0300
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
To: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, philipp.reisner@linbit.com,
 lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
 idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240530142417.146696-2-ofir.gal@volumez.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240530142417.146696-2-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 30/05/2024 17:24, Ofir Gal wrote:
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
> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
> ---
>   include/linux/net.h | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 688320b79fcc..b33bdc3e2031 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -322,6 +322,26 @@ static inline bool sendpage_ok(struct page *page)
>   	return !PageSlab(page) && page_count(page) >= 1;
>   }
>   
> +/*
> + * Check sendpage_ok on contiguous pages.
> + */
> +static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
> +{
> +	unsigned int pagecount;
> +	size_t page_offset;
> +	int k;
> +
> +	page = page + offset / PAGE_SIZE;
> +	page_offset = offset % PAGE_SIZE;

lets not modify the input page variable.

p = page + offset >> PAGE_SHIFT;
poffset = offset & PAGE_MASK;

> +	pagecount = DIV_ROUND_UP(len + page_offset, PAGE_SIZE);
> +
> +	for (k = 0; k < pagecount; k++)
> +		if (!sendpage_ok(page + k))
> +			return false;

perhaps instead of doing a costly DIV_ROUND_UP for every network send we 
can do:

         count = 0;
         while (count < len) {
                 if (!sendpage_ok(p))
                         return false;
                 page++;
                 count += PAGE_SIZE;
         }

And we can lose page_offset.

It can be done in a number of ways, but we should be able to do it
without the DIV_ROUND_UP...

I still don't understand how a page in the middle of a contiguous range ends
up coming from the slab while others don't.

Ofir, can you please check which condition in sendpage_ok actually fails?

