Return-Path: <ceph-devel+bounces-1995-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F7399BC258
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Nov 2024 02:10:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C26D01F22A5A
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Nov 2024 01:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6DFE17588;
	Tue,  5 Nov 2024 01:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcxe0rIF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EC5B65C
	for <ceph-devel@vger.kernel.org>; Tue,  5 Nov 2024 01:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730769035; cv=none; b=n3HXasDkGRtn0J+Gq458D6W0e+Fq78vsXHaqkdXWw5lkRLrk1Q+t3drp9zTOO0AWaXN5yzQw8MpU7hnOU9b3nOmeOeL2wYkHN+T1827ldhpf09EESgw8r0IS6GbkNsQwVYG5g1sZUr47vtis4zgKNcde3j0cHzH8PtiuQtUjkt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730769035; c=relaxed/simple;
	bh=Ymr5JnrhbOfqAKtwJmtRXjmJWiXBGwXXcXTzou/NF0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M3y5tRdLZ+UjROkO2E1uAVlaEwLPHKGMhjGJBWigeDTIkBbyRmx3BHEAxkSN/OG4yaYS1qn5zALsY6/8P3/ySF6Y72tPUJusOYFTccGPIW9tHXqrpPLVyGSl0HScBX5PnZPjUD1Q107oEtmDCGR0lxWpTfl3JmYioaes4BRudrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dcxe0rIF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730769032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mQrI1kRwhfcRSOOnjWLG73nDB4jYuzuyZMzsbah+X30=;
	b=dcxe0rIFxiv2kwzdXV9VBUFnaIU0sVL3Sg2LjR4MejMGxqn8OYX9lEgvu/pjNBjYE7tO8z
	kspbEjqjEzNl/VPwcTIBM41NZMJVv5ckH7VW3DqAKsaMJwYxaOiID7xaA7aI84T4mVpkOy
	e0UULGkkvLi1eAHoinrscd838bLCNPE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-xdvrGXatP52-ok-dUXiL4w-1; Mon, 04 Nov 2024 20:10:31 -0500
X-MC-Unique: xdvrGXatP52-ok-dUXiL4w-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-7e6cc094c2fso4409206a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 04 Nov 2024 17:10:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730769030; x=1731373830;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQrI1kRwhfcRSOOnjWLG73nDB4jYuzuyZMzsbah+X30=;
        b=lw2aT0shlG4Iupl3dXa4VsqBPAlN3OVndIafWLXMpf/pGYaSXquKguHoAnrkb27nbB
         XdSNEdUfHm64yLG4dvwCOu9vWprcXOgHyXGawmBb6d8cRB8hlJIu41O52sz6/hc+KYWN
         kGRntkoPlBoNkwgHUcbjRRmd+C/5VzhlqXSENXFYfyvQhd4zTYIFr8iBTw4C69wTLAsz
         BFcSK44cMfLX6qoE4IZldYB6ZYWFFqAZVbChag5TuMFArO7zfhmMqC9aveysbLJTma3F
         lNAd8gZ3xV5YaHwoZVSmZYnDpteXA1bg/o2rI6u9D0gqC3cOG+Y6mmYdatEQ0+m6xrN6
         bTYg==
X-Forwarded-Encrypted: i=1; AJvYcCVqkjP7b6dtYg6QfdK1tT5mGksrkO0ffAn7fHhkmppW8kK6FQaA9oawKGxNUumHRCxRoo/UtSxrWOkj@vger.kernel.org
X-Gm-Message-State: AOJu0YwsOsj1Wa0lCLgRHj8AORTxxseblmtxckUoLhzfqyXGmRfdN+4M
	Dt8TSWAgHt1G2U6+oerkWpOVStmoxoIL/4besZG3fpq2fokdNniBx4X0ceZoJpBu3MtT8FQKjcp
	sQMkbCuCRDpnm7MQ+ZFO8jVGCF0cAIOSYeKEJ92TJkkJ+uAUW6WwULwgExxl9ZBmyafU=
X-Received: by 2002:a05:6a21:339c:b0:1d1:88bf:dff6 with SMTP id adf61e73a8af0-1dba418905fmr22235698637.15.1730769030470;
        Mon, 04 Nov 2024 17:10:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeNul7GlylouXAxBOR3WLYQ3P9uClGonjaipSFCJzWqrBIEF6+AJ5Wo5jq0mPJOXZ4mnguEA==
X-Received: by 2002:a05:6a21:339c:b0:1d1:88bf:dff6 with SMTP id adf61e73a8af0-1dba418905fmr22235669637.15.1730769030131;
        Mon, 04 Nov 2024 17:10:30 -0800 (PST)
Received: from [10.72.112.104] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee459f9050sm7932167a12.74.2024.11.04.17.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 17:10:29 -0800 (PST)
Message-ID: <7fffefc1-370d-4f04-979f-caeede1e9c0f@redhat.com>
Date: Tue, 5 Nov 2024 09:10:25 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
To: Luis Henriques <luis.henriques@linux.dev>, alex.markuze@ibm.com
Cc: Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240905135700.16394-1-luis.henriques@linux.dev>
 <e1c50195-07a9-4634-be01-71f4567daa54@redhat.com> <87plphm32k.fsf@linux.dev>
 <bb7c03b3-f922-4146-8644-bd9889e1bf86@redhat.com> <87ldz9ma5b.fsf@linux.dev>
 <878qtzcbjh.fsf@camandro.org>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <878qtzcbjh.fsf@camandro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

CC Alex

Hi Luis,

Alex will take over it and help push it recently. I am a bit busy with 
my new things these days.

BTW, if possible please join 'ceph' workspace's #cephfs slack channel 
and you could push it faster there ?

Thanks

- Xiubo


在 2024/11/4 22:34, Luis Henriques 写道:
> Hi Xiubo, Hi Ilya,
>
> On Mon, Sep 30 2024, Luis Henriques wrote:
> [...]
>> Hi Xiubo,
>>
>> I know you've been busy, but I was wondering if you (or someone else) had
>> a chance to have a look at this.  It's pretty easy to reproduce, and it
>> has been seen in production.  Any chances of getting some more feedback on
>> this fix?
> It has been a while since I first reported this issue.  Taking the risk of
> being "that annoying guy", I'd like to ping you again on this.  I've
> managed to reproduce the issue very easily, and it's also being triggered
> very frequently in production.  Any news?
>
> Cheers,


