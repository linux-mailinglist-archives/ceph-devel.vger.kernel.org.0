Return-Path: <ceph-devel+bounces-1536-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 014D09344F1
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2024 00:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 807F2B2130A
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jul 2024 22:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2955953E24;
	Wed, 17 Jul 2024 22:51:57 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AABC33CC4;
	Wed, 17 Jul 2024 22:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721256716; cv=none; b=aEjApBl9IeIZC/XKXF2FesXAd3pTgMYbzGlAr1q2TYAzpUu0b8NWZXjMoELT9qC1lB3z67kYsT6sYKlHErIY7Za6j/sZ5RoeT7Kdom7W1E1VDQcgSPQWfILqy+SaSOysGc/9EubagYyijbyMOym8zL1oGVBUf9LOanAjnesy2dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721256716; c=relaxed/simple;
	bh=Kta5pGFKsCj1QggM9fckGxDAdIXSyAuSr3K5rkaZJSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LpPkDhQnoo0b1uX80t8WgZfaDfK1WC+c3JoY4bB5f2Lv14z82RS9fOHsS/5G2TcvE8F3bkN0yKrrLzElMabcWY+G2ny1gxRjeS50sqf7fvk+32Fr2PvrAoC5wKh+fGSdTTrVYRlKUxz/bDrVW3DtrA0n5zJqXADp939bh9P6oIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4265f823147so291375e9.3;
        Wed, 17 Jul 2024 15:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721256714; x=1721861514;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0M64jRxdtrIITpN4HFOHIiK/TKB1YJndYfAL1oKmq0=;
        b=t2EGmnFRbKrFDhcGajEpl3+2l6YFCp5WMq9r5GvJazy9u3dw7SeQM+H4IOgMOEvVLp
         buRBfGkbmSBj+BSwZar/5iTJCDMH7uOgM9Rh/7/zY3LcXHxKEf7MIG7jMsYCvD7639qp
         bWriy1xGGs+IaM5djMMaDtFoUegeZRabmhJhweksr7f6fuOrjzrVM20WW19daphg2dNy
         oORVcR3nmHO1xxw+6/xZ7oQKECjJBmT2hLHe68h4F5yc8/Q+JaWaPmup934v+1o0E6yN
         F56ubIrQ9O9HD44BPkbjD7oZp+z/pZAvJciHnlNsIiqooMHTrLX27Hu7bYvmrGH+7WGE
         37nA==
X-Forwarded-Encrypted: i=1; AJvYcCW3YPVuR8uGR+S4QKuImRJcRwCS5/Looi4jWHznz3cibUTTNYJSfCX8PFofz9cpNst7QWtaciWv@vger.kernel.org, AJvYcCWwnFzp/XQX0+0xGW8LYKWecrS2QlboVKSHVrrmamGXyv1iJKlgI05uPX8rOtkdkeVDqoRQLo4/Vc6F@vger.kernel.org, AJvYcCXSkEJ7You+GVwFW/SZgmq1G0VGFuJ8D9TOmRmRqKWVZwJanFLWluB3Ts/G7jEx5lEhjkuEOgXKZsHnbrs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyC9SFMu/JWTqFUb/LN69WhZVVN/Fps5mncdfOMji3Cb82Vcc4
	CV8DnIBA9bQerMDMZhhpHCPqEZpqhipHak5yO3+q/9KIL/+9XfBn
X-Google-Smtp-Source: AGHT+IGjse9ynxNLLxkSLaOFMZvanW6vy86VI1WLzh8tqLRb+7IQ7INQFlIBWZ7Hb1LYbkNNUkxvHA==
X-Received: by 2002:a05:600c:5101:b0:427:9f6f:9c00 with SMTP id 5b1f17b1804b1-427c2d52195mr14721745e9.6.1721256713451;
        Wed, 17 Jul 2024 15:51:53 -0700 (PDT)
Received: from [10.100.102.74] (85.65.198.251.dynamic.barak-online.net. [85.65.198.251])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427c7857eadsm12107835e9.40.2024.07.17.15.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 15:51:53 -0700 (PDT)
Message-ID: <3f675a0f-45c1-41bd-887a-fe6e6d793ecf@grimberg.me>
Date: Thu, 18 Jul 2024 01:51:50 +0300
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] libceph: use sendpages_ok() instead of
 sendpage_ok()
To: Ilya Dryomov <idryomov@gmail.com>, Ofir Gal <ofir.gal@volumez.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com,
 pabeni@redhat.com, kbusch@kernel.org, xiubli@redhat.com
References: <20240611063618.106485-1-ofir.gal@volumez.com>
 <20240611063618.106485-5-ofir.gal@volumez.com>
 <2695367b-8c67-47ab-aa2c-3529b50b1a83@volumez.com>
 <CAOi1vP96JtsP02hpsZpeknKN_dh3JdnQomO8aTbuH6Bz247rxA@mail.gmail.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <CAOi1vP96JtsP02hpsZpeknKN_dh3JdnQomO8aTbuH6Bz247rxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 17/07/2024 23:26, Ilya Dryomov wrote:
> On Tue, Jul 16, 2024 at 2:46 PM Ofir Gal <ofir.gal@volumez.com> wrote:
>> Xiubo/Ilya please take a look
>>
>> On 6/11/24 09:36, Ofir Gal wrote:
>>> Currently ceph_tcp_sendpage() and do_try_sendpage() use sendpage_ok() in
>>> order to enable MSG_SPLICE_PAGES, it check the first page of the
>>> iterator, the iterator may represent contiguous pages.
>>>
>>> MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
>>> pages it sends with sendpage_ok().
>>>
>>> When ceph_tcp_sendpage() or do_try_sendpage() send an iterator that the
>>> first page is sendable, but one of the other pages isn't
>>> skb_splice_from_iter() warns and aborts the data transfer.
>>>
>>> Using the new helper sendpages_ok() in order to enable MSG_SPLICE_PAGES
>>> solves the issue.
>>>
>>> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
>>> ---
>>>   net/ceph/messenger_v1.c | 2 +-
>>>   net/ceph/messenger_v2.c | 2 +-
>>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
>>> index 0cb61c76b9b8..a6788f284cd7 100644
>>> --- a/net/ceph/messenger_v1.c
>>> +++ b/net/ceph/messenger_v1.c
>>> @@ -94,7 +94,7 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
>>>         * coalescing neighboring slab objects into a single frag which
>>>         * triggers one of hardened usercopy checks.
>>>         */
>>> -     if (sendpage_ok(page))
>>> +     if (sendpages_ok(page, size, offset))
>>>                msg.msg_flags |= MSG_SPLICE_PAGES;
>>>
>>>        bvec_set_page(&bvec, page, size, offset);
>>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>>> index bd608ffa0627..27f8f6c8eb60 100644
>>> --- a/net/ceph/messenger_v2.c
>>> +++ b/net/ceph/messenger_v2.c
>>> @@ -165,7 +165,7 @@ static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
>>>                 * coalescing neighboring slab objects into a single frag
>>>                 * which triggers one of hardened usercopy checks.
>>>                 */
>>> -             if (sendpage_ok(bv.bv_page))
>>> +             if (sendpages_ok(bv.bv_page, bv.bv_len, bv.bv_offset))
>>>                        msg.msg_flags |= MSG_SPLICE_PAGES;
>>>                else
>>>                        msg.msg_flags &= ~MSG_SPLICE_PAGES;
> Hi Ofir,
>
> Ceph should be fine as is -- there is an internal "cursor" abstraction
> that that is limited to PAGE_SIZE chunks, using bvec_iter_bvec() instead
> of mp_bvec_iter_bvec(), etc.  This means that both do_try_sendpage() and
> ceph_tcp_sendpage() should be called only with
>
>    page_off + len <= PAGE_SIZE
>
> being true even if the page is contiguous (and that we lose out on the
> potential performance benefit, of course...).
>
> That said, if the plan is to remove sendpage_ok() so that it doesn't
> accidentally grow new users who are unaware of this pitfall, consider
> this
>
> Acked-by: Ilya Dryomov <idryomov@gmail.com>

 From which tree should this go from? we can take it via the nvme tree, 
unless
someone else wants to queue it up...

