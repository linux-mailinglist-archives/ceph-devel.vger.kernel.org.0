Return-Path: <ceph-devel+bounces-1549-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 459D393A520
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 19:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED2F51F23597
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 17:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F3E158203;
	Tue, 23 Jul 2024 17:51:46 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5F3381B1;
	Tue, 23 Jul 2024 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721757106; cv=none; b=uyr6kRTGauY6BYSDrjs/84vOsd1njDOOdN9J44rlrg9lxDrY3vGhgMOoOYdRCYcIdU11rd/y6dOYmA1i+wc1BwtHLLwx+T1V/8tPJAke7gXyb53GDtfVLxbsXoMgmRFn7386Wq+V7l4Fpeg4jD9AzgezzDPpibpOjp5SLg5F2wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721757106; c=relaxed/simple;
	bh=q/906rZhLsSEmkkYt9iPHA1Kz16OIGT4ctkfGoPky5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S6YpPjtqW5ONKSzAgdrH2uGec+xmImy6fHViftrYhoaMUViqmbbu3rYmrLBvuiJRxRuCX0vanxJq8PHYvpf7Hvp7ASUk3a4D1uhT00Sl1sGK79iHxFxh6mOJX7T0K+75+IAKnEFr0AuxK/4cp73/F7e7xHrBmX45JyB62zamM6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fc53171e56so736435ad.3;
        Tue, 23 Jul 2024 10:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721757104; x=1722361904;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VoeGtHSXB64zwiuwvms6AcLkRLb38MEJZx4ZT1nmMD0=;
        b=wa2y1R+yFBtgBwE09xRS//fjt9+3wgJ4N2WXoK51/80fE+LG0H+r3liCn8AvqYP0jA
         eEArRJAlYdeaW9px7F+UjJvVn8lXLZHX2JX3P7TsKZyMygEMdW4byhXrCcjYMm982YAH
         hlnd8SNZuMPjwDjMOdaFruwXqeEEjGs97zOFxF8E0ccWmL3ySJ7bJHJKmOfwKZ3EsZU8
         J7etZLGxLvkmGrIDDNV3BYvxDKNwOAIge2RBnKcIgE6uHpsn9ebqe7lBi8fD1KN1Dqk/
         FD42D9W3BfqqY2dr9lYtdvxs+EzFpa/nDxLx5YZ7F4LiGRTQWmXXyeO8kgHx4DdP6udP
         6+IA==
X-Forwarded-Encrypted: i=1; AJvYcCXqGo2vhhIHfi/Ur/QbEKCGbx3M2eOyVASRVpUArmWSnZuHMGoJVPttaFfTm3KmmNnMiUBAWsSaBmiXYdsTiF6cECNZfhMsKOlE/uPtMikXrDoYvwVAOGUaWI+AnoH5nnhagrzv5QWkK1qQ1E4aIgxu6vt65WDSM4QBW/paF6Ax
X-Gm-Message-State: AOJu0Ywpkw3orfPuupdrq1GLYCWsJmaRFBmk9DE2tYj6gVGqTuleST9K
	JFt45R7g4apFc6q6Upwr8C3Fbd9w+V68ABN3/o8ZzedWIq5T1y0++NpyBg==
X-Google-Smtp-Source: AGHT+IEWZwnlQ/uVz5RIULJVj6dMBCxAtD4yCOb6ArLoAjAlN3bT5GK7xeRd3S5Zevx1CkOR4GghGQ==
X-Received: by 2002:a17:902:e5d0:b0:1fc:5cc8:bb1b with SMTP id d9443c01a7336-1fd746009a8mr88898525ad.7.1721757102488;
        Tue, 23 Jul 2024 10:51:42 -0700 (PDT)
Received: from [192.168.68.149] ([70.90.172.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f2947a1sm78061045ad.86.2024.07.23.10.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 10:51:41 -0700 (PDT)
Message-ID: <54cba15d-6598-47c4-9a62-81c4f463ef64@grimberg.me>
Date: Tue, 23 Jul 2024 10:51:38 -0700
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
To: Jens Axboe <axboe@kernel.dk>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org,
 Ofir Gal <ofir.gal@volumez.com>
Cc: dhowells@redhat.com, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kbusch@kernel.org, hch@lst.de,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240718084515.3833733-1-ofir.gal@volumez.com>
 <172174144805.171126.5886411285955173900.b4-ty@kernel.dk>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <172174144805.171126.5886411285955173900.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 23/07/2024 16:30, Jens Axboe wrote:
> On Thu, 18 Jul 2024 11:45:11 +0300, Ofir Gal wrote:
>> skb_splice_from_iter() warns on !sendpage_ok() which results in nvme-tcp
>> data transfer failure. This warning leads to hanging IO.
>>
>> nvme-tcp using sendpage_ok() to check the first page of an iterator in
>> order to disable MSG_SPLICE_PAGES. The iterator can represent a list of
>> contiguous pages.
>>
>> [...]
> Applied, thanks!
>
> [1/3] net: introduce helper sendpages_ok()
>        commit: 80b272a6f50b2a76f7d2c71a5c097c56d103a9ed
> [2/3] nvme-tcp: use sendpages_ok() instead of sendpage_ok()
>        commit: 41669803e5001f674083c9c176a4749eb1abbe29
> [3/3] drbd: use sendpages_ok() instead of sendpage_ok()
>        commit: e601087934f178a9a9ae8f5a3938b4aa76379ea1
>
> Best regards,

Thanks Jens.

