Return-Path: <ceph-devel+bounces-1261-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 744B38FAD82
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 10:25:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E54D2854C4
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 08:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368C6142906;
	Tue,  4 Jun 2024 08:24:55 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2A313C672;
	Tue,  4 Jun 2024 08:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717489495; cv=none; b=qtNTC2IYizmKwSbg1s/2aYfIk2TDnpqmDT+ZegV6ez5aRutL7Cw3sMLFa8cbDZZcQdJK/mTW9x+oRbhWrb2oB5RkbEoQBXuXqSFq8qrthu6yu6Nvy5d2I+7vEe3ukanKcKCxSEM6flOrJQypw6gjMBiLM0+jvdFAeAnYr5GMMhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717489495; c=relaxed/simple;
	bh=V8u4ises0PLg+j92Lwu6MTiv2dwQoVXMLN8iHbUF+/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N9UPO62UtHYlTjQyPCTGm3rS6oUVTWfAiZA+cmKShw0tKxYHfIETy6c36GJlJ0FBf7ZFVzsTSAbfZKwmjhxjejd8z1ROWC+pTsFg4TmYHW2BhyliAHyVvDsBufc+g1T4+rPDmLaj497nE1KLhZAiRzlPMsbmzs4P2RLMO1yfrn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2eab062bbdeso3025971fa.1;
        Tue, 04 Jun 2024 01:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717489491; x=1718094291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jT03552+joJgoqrGEVdI7Fe6g8UVlQf4Q+uQisoEmo8=;
        b=iadCYMBHaT8rFusnKkB/PzQPq6Dnb6uuefo8SPfazjiz7dssrYakp4yvOwMvJUQYr6
         Xl6FaxrUmkJ3tOHsAn4j8hgmSYcAb4dF3R5CFfIOPlxuTcwbCiSv/Rgfx1OBDoedAslG
         k2sfeLXF+9f5L5tFphABCx9vxVFCvWUQThUj/vB8pQdWp3X9/9VtCRpBOwHAJn+QEYIF
         ESxY4vVneo5RM3zdvtqAC3vGrd+zzxajJwR4TVT8tzurUNrwhtYT/VSMjUF7icgGz3dW
         WFJqTYJ3cAD4esXvPn7sG4GCXNtFScdkQMoRedLmV5a8V2cT3tEyQHSvLTm41F5hrW+s
         gCVw==
X-Forwarded-Encrypted: i=1; AJvYcCVXq7HuYzvAQFb65HeqDwbIOg1zIkku4bbwYW4QPqSyLPm/dmIoqGHJiZGqjzsMYSz1OWhEv6LKR337tCykX8TKlZjL7j5jU/BjeEY6bl6AYBOika7hrHA9/imYek39WBaEk6q+x2t7mQeRbOOKsPKVtat05kL/6gNz6LEkMUSJ
X-Gm-Message-State: AOJu0YyzXEz/TkSQKYs5yV5DFXZeDudg7sNZV9pWcHwEmXy/Tz6HUZKp
	jl3BwtBsqU6d2x6WC363nghFGkjNbQzpNfHYrgi34VG9odDlszRh
X-Google-Smtp-Source: AGHT+IHuXM2IV1Hvv1yo73FAtyZR/fINFEtA7+m+S0KNoMFYIA+FZgsSVFChErK9dkk4AU6gDb5/pA==
X-Received: by 2002:a2e:8756:0:b0:2ea:8442:2096 with SMTP id 38308e7fff4ca-2ea95153f82mr61441631fa.2.1717489491014;
        Tue, 04 Jun 2024 01:24:51 -0700 (PDT)
Received: from [10.50.4.180] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4214186ccdcsm34884405e9.16.2024.06.04.01.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 01:24:50 -0700 (PDT)
Message-ID: <62c2b8cd-ce6a-4e13-a58c-a6b30a0dcf17@grimberg.me>
Date: Tue, 4 Jun 2024 11:24:48 +0300
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
To: Christoph Hellwig <hch@lst.de>
Cc: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com,
 edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240530142417.146696-2-ofir.gal@volumez.com>
 <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
 <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com>
 <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me>
 <20240604042738.GA28853@lst.de>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240604042738.GA28853@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 04/06/2024 7:27, Christoph Hellwig wrote:
> On Tue, Jun 04, 2024 at 12:27:06AM +0300, Sagi Grimberg wrote:
>>>> I still don't understand how a page in the middle of a contiguous range ends
>>>> up coming from the slab while others don't.
>>> I haven't investigate the origin of the IO
>>> yet. I suspect the first 2 pages are the superblocks of the raid
>>> (mdp_superblock_1 and bitmap_super_s) and the rest of the IO is the bitmap.
>> Well, if these indeed are different origins and just *happen* to be a
>> mixture
>> of slab originated pages and non-slab pages combined together in a single
>> bio of a bvec entry,
>> I'd suspect that it would be more beneficial to split the bvec (essentially
>> not allow bio_add_page
>> to append the page to tail bvec depending on a queue limit (similar to how
>> we handle sg gaps).
> So you want to add a PageSlab check to bvec_try_merge_page?  That sounds
> fairly expensive..
>

The check needs to happen somewhere apparently, and given that it will 
be gated by a queue flag
only request queues that actually needed will suffer, but they will 
suffer anyways...

