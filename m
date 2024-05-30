Return-Path: <ceph-devel+bounces-1200-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D04888D5190
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 19:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F84A28A1A5
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2024 17:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20EF9482ED;
	Thu, 30 May 2024 17:58:13 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B79224D4;
	Thu, 30 May 2024 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717091892; cv=none; b=XeNQCWlgoTMyqEqGbKi2I1lgVT2aqpKPFtO3O0lL3yRw0hKyBkB62MyyfxHegT5LgKQchUo+w9lPakR/XuyG+d5C7sYdOyqL+NeHz1QomZl3fjmBNPDK/vE9T3u1YtAT7ZhphPed3TMRQ6nrhOGSq+v1ceTEeJ4xboJI6cH30Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717091892; c=relaxed/simple;
	bh=zy9/jkZo5Kkm2qDUeVoKDrkhkws3NyE2cNMGwJegfBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JWWk7SgJRhRb2nNx5KKBOlTUqsmLTD8+OKGwUO+pUvyf7gbWYlAtMzp1LtBOrwgaiMkFVrXIQ3B8knRJQguzL+OAgyNX8p0Jrm3dnFkZD4AsEmHoqh9ZJyOvBAiFUDiQwIaLV76ylntH/hJnPrcYu31Ij5EjpluHytXPqUpOaYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-421160b07eeso433155e9.0;
        Thu, 30 May 2024 10:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717091889; x=1717696689;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hC23jucMm+q+/3nVmnb3JFDkYf90kQS7VVGYEUblW18=;
        b=AtxxUSC9Z9RFut9NgaZlrP6TaCw2KB0TbOgcgSLlDhS24WgEzwAyZrjSV/EJc6TOjU
         gDV8HzxCRTCDgj93e6P79AhmSssN34Y79P97XG0FbbhIw8dlquQ+1wCqHujl4WieNiBJ
         ApkDl2KECNdpWQsSxbjcd68J7SjxBiuQ1NriYqa4Wet++NJJeiO7lGslnPIUav6GMNaG
         Ix5GvhhE/GqeKGjuc44reOoX5g6khcL8dlBjxo/bk6cID4PdlLHbYF2soVOnzQ6einIY
         XxaOlGJH4jFXOXWsA87u/636dI1NWVA83k7FnDcpVjaYfcWx+nC1CGPJpmaS2MnJQA6w
         TJag==
X-Forwarded-Encrypted: i=1; AJvYcCUdcwrjah0Hxb9HKciNprZV0tLoodaHHCxYdvWzwnZjqzzAiv+xUTTHu4CJoUZ3fPWIdE+AGQAXlJF8XAddNUI2WXOzMIL/ne37Gdg2qWl79D0bfBccYxp0InNAhYkOglREMsCYT9nZxUtRfoG4ygHq84I70h9+Q8GpW/P6Px+U
X-Gm-Message-State: AOJu0Yxe5tmAZ+l0GCNjpjBlJmRogAGXo47mmArADLUhbwp0IoOEMlUv
	VpORhkHBSrNDkYWglxMyfLWfUjwzxgNSy63nsGiV1AKvxzw1Q4Ag
X-Google-Smtp-Source: AGHT+IEKs/D/YOXJKNpqQBu1D27NdILizXiASB7GFF049ZDfxVYEPi5NY+sGao+1Yf3CzW3yUcmd7w==
X-Received: by 2002:a5d:678d:0:b0:35d:bdda:3553 with SMTP id ffacd0b85a97d-35dc00bc230mr2126917f8f.4.1717091889059;
        Thu, 30 May 2024 10:58:09 -0700 (PDT)
Received: from [10.100.102.74] (85.65.193.189.dynamic.barak-online.net. [85.65.193.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212709d341sm31609825e9.36.2024.05.30.10.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 10:58:08 -0700 (PDT)
Message-ID: <d6b2c19b-c2a6-400c-bbf1-bf0469138777@grimberg.me>
Date: Thu, 30 May 2024 20:58:06 +0300
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
To: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, philipp.reisner@linbit.com,
 lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
 idryomov@gmail.com, xiubli@redhat.com
References: <20240530132629.4180932-1-ofir.gal@volumez.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240530132629.4180932-1-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hey Ofir,

On 30/05/2024 16:26, Ofir Gal wrote:
> skb_splice_from_iter() warns on !sendpage_ok() which results in nvme-tcp
> data transfer failure. This warning leads to hanging IO.
>
> nvme-tcp using sendpage_ok() to check the first page of an iterator in
> order to disable MSG_SPLICE_PAGES. The iterator can represent a list of
> contiguous pages.
>
> When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
> it requires all pages in the iterator to be sendable.
> skb_splice_from_iter() checks each page with sendpage_ok().
>
> nvme_tcp_try_send_data() might allow MSG_SPLICE_PAGES when the first
> page is sendable, but the next one are not. skb_splice_from_iter() will
> attempt to send all the pages in the iterator. When reaching an
> unsendable page the IO will hang.

Interesting. Do you know where this buffer came from? I find it strange
that a we get a bvec with a contiguous segment which consists of non slab
originated pages together with slab originated pages... it is surprising 
to see
a mix of the two.

I'm wandering if this is something that happened before david's splice_pages
changes. Maybe before that with multipage bvecs? Anyways it is strange, 
never
seen that.

David,  strange that nvme-tcp is setting a single contiguous element 
bvec but it
is broken up into PAGE_SIZE increments in skb_splice_from_iter...

>
> The patch introduces a helper sendpages_ok(), it returns true if all the
> continuous pages are sendable.
>
> Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
> this helper to check whether the page list is OK. If the helper does not
> return true, the driver should remove MSG_SPLICE_PAGES flag.
>
>
> The bug is reproducible, in order to reproduce we need nvme-over-tcp
> controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
> with bitmap over those devices reproduces the bug.
>
> In order to simulate large optimal IO size you can use dm-stripe with a
> single device.
> Script to reproduce the issue on top of brd devices using dm-stripe is
> attached below.

This is a great candidate for blktests. would be very beneficial to have 
it added there.

