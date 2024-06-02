Return-Path: <ceph-devel+bounces-1247-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 873078D742C
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Jun 2024 09:48:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42501281C1C
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Jun 2024 07:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995AC1E49F;
	Sun,  2 Jun 2024 07:48:19 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CD4208A1;
	Sun,  2 Jun 2024 07:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717314499; cv=none; b=AnK3njdj2p0Jnr2oze3t0gL1tPYISbKCxGc8ToBW+nGPHgx1mINYUoyhfd9JRZQz2UX8Pn6+XxzWOtU6NxykyMMz1WQ4B9S0qjVF1gkew4opLfxBI23EzEpiioHSQGUewads5SXUyB6vazzUcavnjgS5yP9oCBXOaAoB41f1Flw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717314499; c=relaxed/simple;
	bh=0osbBSBLTMt8nX/8+KW0zNocP78w7qcjHw2JL9olbfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Df/JkQ6P1CVerlRVHFoTAUJ8TWJC8uqxFZwsT8rCk4ZPZeK5Ne9ruk29tG2peoRkHeCRrYy6ntBIyXrCVVegMAx19Yxv/of/4JolDW8uqdde1QHqqjESOyEZcbYKbrc0JnRtMDkaSRsWNKP0jKT9ptaz2Nj7ibTYoXt2234HOms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-35e544aa9a9so19307f8f.2;
        Sun, 02 Jun 2024 00:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717314496; x=1717919296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Mi/VKBiZjMcaZsYVmfXcA5vUMibCH5GQOs6BRjI06o=;
        b=tj+taI39WaKJoLi+4NzuLFlFrkkj1WGSluBv+5Xo+5bPSShP+w2kRDMmmJ2gS5bof+
         0WhJgLZt05mCkYw54d+n7nGfC77SBvPUBqYUE4zPf2exeKMm9mTPBUfZabKP2m3DFE7j
         mwScTMMN6nyFwvT1oHsaRH7biCilyz07gB/yzwKaof47RaY0SwRbtpbOYcux09BXD/gu
         FpCUl6SOoJJJGxwhogeSj5RDDm+pY4aTqrG5Lx4cu9TDgSsGLF4iNPyUF04pjAg6uRUz
         PD/HWNPfx3pLPwqhuUiVeJinFUg2R2WM7XopN7BCRfSfqXjZ5sNlCLAOGHSslDvposXe
         9ITg==
X-Forwarded-Encrypted: i=1; AJvYcCW70C9ThNH0FoFyl9U1VJ5oSSXz9IJpPgutcMJp/7ryP1EEm2m/gDMtf2AE59jvoXpampH3xqvKunLHb8GsXpPdKe+IUWv3Q28doWy830q8+2yDW7jauvBBS5WzPNlLMODhEGamt1g73MUjZYll2x1B6ILrg8K29nCbX6KFExIr
X-Gm-Message-State: AOJu0YxSpKzWLEtUFujMIyZCDuZJvpXC3P12SfakCG2dhv/LqiLcnHeW
	kIPgdky/4345W+6CE6K6Yl1iyJhmpMu1Z1CEEr3taMGBlSFqaveO
X-Google-Smtp-Source: AGHT+IFsCjXnSMmjNSZUGoj/v4xQvOLvmmlAnC28L1qi45HucRzp7Mm8nzhveD4Y6FLy0KHDf5ir5A==
X-Received: by 2002:adf:f547:0:b0:358:d0c:b9a0 with SMTP id ffacd0b85a97d-35e0f23ebc2mr4051664f8f.1.1717314495772;
        Sun, 02 Jun 2024 00:48:15 -0700 (PDT)
Received: from [10.100.102.74] (85.65.205.146.dynamic.barak-online.net. [85.65.205.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd062edcdsm5532084f8f.70.2024.06.02.00.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 00:48:15 -0700 (PDT)
Message-ID: <9f62247b-ae36-49d9-9ccc-6ea5a238e147@grimberg.me>
Date: Sun, 2 Jun 2024 10:48:12 +0300
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
To: Jakub Kicinski <kuba@kernel.org>, Ofir Gal <ofir.gal@volumez.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240601153430.19416989@kernel.org>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240601153430.19416989@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 02/06/2024 1:34, Jakub Kicinski wrote:
> On Thu, 30 May 2024 17:24:10 +0300 Ofir Gal wrote:
>> skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
>> skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
>> skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)
> noob question, how do you get 3 contiguous pages, the third of which
> is slab? is_slab doesn't mean what I think it does, or we got extremely
> lucky with kmalloc?
>

The contig range according to the trace is 256K, the third page was just the
first time that it saw this !ok page.

I asked the same thing. nvme-tcp gets a bio and sets up its own iov_iter
on the bio bvec for sending it over the wire. The test that reproduces this
creates an raid1 md device which probably has at least some effect into how
we got this buffer.

With the recent multipage bvecs work from Ming, nvme-tcp bvec entries will
often point to contiguous ranges that are > PAGE_SIZE. I didn't look 
into the
implementation of skb_splice_from_iter, but I think its not very 
efficient to
extract a contiguous range in PAGE_SIZE granular vector...

