Return-Path: <ceph-devel+bounces-175-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D6C7F0A18
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Nov 2023 01:33:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 369191C208BA
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Nov 2023 00:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB681849;
	Mon, 20 Nov 2023 00:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnD2mO0H"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403C2107
	for <ceph-devel@vger.kernel.org>; Sun, 19 Nov 2023 16:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700440388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCyeeEPwIGj3bpAJL4TtDBoFWik53odHI36KbldyAKM=;
	b=QnD2mO0HdS8KrrflSJ42lgot/DjGPvifby0lewVs9f+A8UbfizOIqJ7lStawWktbbpcGkR
	2+6F4q0bRDXFSZxNOU1aj6rga1aiP3pwVsuUjBavVt7HCIpQyjkJB7V5L5kGzykRErxu80
	Vad5hFuPCDKMoJBRLB1Ud4wjf7SC5dY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-3Q3KGLgAMnavD-uUgc_DRA-1; Sun, 19 Nov 2023 19:33:06 -0500
X-MC-Unique: 3Q3KGLgAMnavD-uUgc_DRA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1ce5b6ec63cso31496635ad.3
        for <ceph-devel@vger.kernel.org>; Sun, 19 Nov 2023 16:33:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700440382; x=1701045182;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCyeeEPwIGj3bpAJL4TtDBoFWik53odHI36KbldyAKM=;
        b=Joj4SpDvuNkkxUR7y6cECHRNU8pVaW4mzKA41IDA8gmxzzyCEPlECZ/bL7A6TYDSrk
         jWTlNh3i6GEA4O9a/2jcxI104mLlsvKk0/cHKYxHDrQmsJbenpIVCovRDZGysG97R8eC
         qNwBardo5DqP/vm3xUfGeF+S20Rc8Cx2EY31huKQZWAJG0Cta5SyqLpa8AZX0YKdjz0f
         EYnDr5tEMRSn3X7My0HUembNjgHh6d1ni5vkwnnZYwuU1yUi+8ZwEBCVdDlb5G8UxA9+
         NORlK65ZGn639YVNJDmQanpjaun8Mb7aHNcJDoKACQU13A99gvLKl0qPLs3tGZiRAjNH
         +GUA==
X-Gm-Message-State: AOJu0Yyp2frxxVadJXeQCxifIePztAde5OXaTAdTh8Rspzn87QmK3Rc3
	R3BXBiuFsPF89gl9vl0K7aP4c1mHmGOsGR723WNLVGtd8N+iWJ/g3uZC1gURzmeRj//jwhhYeGX
	BIWwCfCCoiJ9ro768MDv2hg==
X-Received: by 2002:a17:903:24f:b0:1cc:31c4:377b with SMTP id j15-20020a170903024f00b001cc31c4377bmr4657578plh.63.1700440382384;
        Sun, 19 Nov 2023 16:33:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFKpiHzxc7T7GkDawGmHPBW9MXDVjLIBv1HPj4WXs1mGDpxPpVR+Zmi56gIvYiEElODTwvU8w==
X-Received: by 2002:a17:903:24f:b0:1cc:31c4:377b with SMTP id j15-20020a170903024f00b001cc31c4377bmr4657568plh.63.1700440382103;
        Sun, 19 Nov 2023 16:33:02 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902cec800b001bbd1562e75sm4854592plg.55.2023.11.19.16.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Nov 2023 16:33:01 -0800 (PST)
Message-ID: <dd56647e-bcae-d38f-a4d4-d5d8c4bcd5f7@redhat.com>
Date: Mon, 20 Nov 2023 08:32:58 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 00/15] Many folio conversions for ceph
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>, Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
 David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org
References: <20230825201225.348148-1-willy@infradead.org>
 <ZVeIuiixrBypiXjp@casper.infradead.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <ZVeIuiixrBypiXjp@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/17/23 23:37, Matthew Wilcox wrote:
> On Fri, Aug 25, 2023 at 09:12:10PM +0100, Matthew Wilcox (Oracle) wrote:
>> I know David is working to make ceph large-folio-aware from the bottom up.
>> Here's my attempt at making the top (ie the part of ceph that interacts
>> with the page cache) folio-aware.  Mostly this is just phasing out use
>> of struct page in favour of struct folio and using the new APIs.
>>
>> The fscrypt interaction still needs a bit of work, but it should be a
>> little easier now.  There's still some weirdness in how ceph interacts
>> with the page cache; for example it holds folios locked while doing
>> writeback instead of dropping the folio lock after setting the writeback
>> flag.  I'm not sure why it does that, but I don't want to try fixing that
>> as part of this series.
>>
>> I don't have a ceph setup, so these patches are only compile tested.
>> I really want to be rid of some compat code, and cecph is sometimes the
>> last user (or really close to being the last user).
> Any progress on merging these?  It's making other patches I'm working on
> more difficult to have these patches outstanding.
>
Hi Willy,

I had one comment on the [01/15], could you confirm that ?

Thanks

- Xiubo



