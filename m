Return-Path: <ceph-devel+bounces-1258-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA36D8DB71A
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 23:27:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECCC51C23D7D
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 21:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0E913BC38;
	Mon,  3 Jun 2024 21:27:13 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727A513BAE5;
	Mon,  3 Jun 2024 21:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717450033; cv=none; b=NYj7j2ReoT88lDCctX0hVEeLZgLH5VUrI1cJ/SmlIUKDQc0nXs2skRGoF7hp87vLu0PhknwsuX0WVo+HkYTzVlQwaHReG/K13NByg2gaoicfyroHnf0xHlt3LS9KHpYDLuVJLQqIcLNpro7wo9G0nHzjOxsuAVWzyZ3JGjdGXns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717450033; c=relaxed/simple;
	bh=cweTklJChgGQJ4iaB8EL2Zwbqlpyn3DUc51xHBMHR10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CYRDAnqEHjhZzdTOVODamO+zcXvgc5IRrOPmpOFwJ5d4TOweGRtSB6zqU4FXBB8nvRZnn6DvK72OvXVrkkN0lixM3Wnt0f4+F55tQU7KEPjADxwf9K82OnISgpzEVa3+NtxN67u3fPWPtcHPPYVon/6C0at7jtgWVM370INKi1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-35dbf63c774so161264f8f.2;
        Mon, 03 Jun 2024 14:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717450030; x=1718054830;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uY599MDCIjCv3UIyzbwe3bA9VXqb6OB7ySlkBu+KXLw=;
        b=kIhkd+Qxb2SAVzXaMbJkzBlqKEWhwCMmnvoqoOC031bH/Q624ZLlxgl8+Kk1k1U3nH
         neGykquLU6h2Lqr0elQPuZlBszQSD5nh1NRWTRaw6OEIeFnK5/WfEjMg5wK4yRMczUeH
         40XfZW9m3ME2VyFmxXoZVeNUIpM9ssQBi1wgG5wlzKgz8b5E4KDUTIOEUSo/iRPFEqst
         PHHWm5CFi4REfonBQXEP00ad1ycG0bb8XjGbNiI1hN4uQyIUZF0WHBgvq+u9p6mX2qnK
         +umPwL9QNcRru/Gp7KKfmn9XEWNDTVnaJ5ijBHEprE/4vahZm3rWB779Rlv92mRE342Q
         9Tuw==
X-Forwarded-Encrypted: i=1; AJvYcCXWVM/EDnAqp9YkhNzqoXjBE7CkLVke+hJE/crcgtZsrtNV1UALsV4Db3nSeVSBoq1d/yM3leX2lnoE8nLaESogfSmNIaMeXf3xLDJYnr309+LdBgc/yRnIHRMtJaVpaiEl98/vqqo1f/RgFWhH8ptZwWnOLLQ2z57W/ucHR/Sm
X-Gm-Message-State: AOJu0YwcfF7pEv3F2slftBILNgaiZEyZsGpYaP3MTGNBNF1e1UTRHRFz
	EKaap0feZFw33BRGf4IlT5cMc6PsRrvCVLbMSRg3iuFa0dyPqJVk
X-Google-Smtp-Source: AGHT+IH46P8IN4JrAN5hCuulfHxINGqT3MUA6PYnKCaDFijovEp8eZHOBGyMyXYbErBqqHO2JIAUtg==
X-Received: by 2002:a05:600c:1c1e:b0:421:2c02:9779 with SMTP id 5b1f17b1804b1-4212e0c55c3mr82014925e9.4.1717450029553;
        Mon, 03 Jun 2024 14:27:09 -0700 (PDT)
Received: from [10.100.102.74] (85.65.205.146.dynamic.barak-online.net. [85.65.205.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42134f12e72sm100165345e9.34.2024.06.03.14.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 14:27:09 -0700 (PDT)
Message-ID: <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me>
Date: Tue, 4 Jun 2024 00:27:06 +0300
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
 <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me>
 <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>> I still don't understand how a page in the middle of a contiguous range ends
>> up coming from the slab while others don't.
> I haven't investigate the origin of the IO
> yet. I suspect the first 2 pages are the superblocks of the raid
> (mdp_superblock_1 and bitmap_super_s) and the rest of the IO is the bitmap.

Well, if these indeed are different origins and just *happen* to be a 
mixture
of slab originated pages and non-slab pages combined together in a 
single bio of a bvec entry,
I'd suspect that it would be more beneficial to split the bvec 
(essentially not allow bio_add_page
to append the page to tail bvec depending on a queue limit (similar to 
how we handle sg gaps).

>
>> Ofir, can you please check which condition in sendpage_ok actually fails?
> It failed because the page has slab, page count is 1. Sorry for not
> clarifying this.
>
> "skbuff: !sendpage_ok - page: 0x54f9f140 (pfn: 120757). is_slab: 1, page_count: 1"
>                                                                   ^
> The print I used:
> pr_info(
>      "!sendpage_ok - page: 0x%p (pfn: %lx). is_slab: %u, page_count: %u\n",
>      (void *)page,
>      page_to_pfn(page),
>      page_address(page),
>      !!PageSlab(page),
>      page_count(page)
> );
>
>


