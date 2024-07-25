Return-Path: <ceph-devel+bounces-1559-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9597A93BE1C
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 10:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4350B1F22CA4
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 08:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A01518E750;
	Thu, 25 Jul 2024 08:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K8fTtemF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C43318D4A1
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 08:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721897153; cv=none; b=kJsfOokZbiijbhejRpti9Rllco3uEQUdILeD6g5Y6NvoAZcyYh+r05YsI4dWTIhq1dvARxfQtrnjADJLzzkKum1+ICWJQknsIIKdyOZeuTULW9VDt5ykpqaBseN2Hv73Ibxtwq4E7nWCgQ5tSP0P1pq6foSCX+YgApo+A5gHsM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721897153; c=relaxed/simple;
	bh=kkHvCayLr+ANTHV8+i8vavacq47tR86BjS76cMqw2mI=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kYbnS6n0k1XcvCQgdX/nxKj0GlIbQ1diM51G7kFpZ/f83Jr5PqbSFiYdaO63Ndk2LiE2XUO/AUIGMTVfmRZklNZkL9oDAeIX7U0vW1xkhnmwAibLqs8D+ia9B59/dtVf18fZXhnTGNo7nIIbHx0J5W83segnoNZCWVXoVWWvzPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K8fTtemF; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Subject: Re: [PATCH 3/3] rbd: don't assume rbd_is_lock_owner() for exclusive
 mappings
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721897147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KXoyl6lkEA1TnoJp6Apj8eAAF8dX6CkbMkYog1AVBrE=;
	b=K8fTtemFMowuLu8jlWJB2z1i1IyBeRtICC8z1VRCQa9BcYXnW/+IbxKv4ukCNf4vwZxlim
	xxug55h5ptHVenKOOMB1T8rF2tWa0c4lQgyb8Jdl9gjDPqWOnp13G2aAaVTQFSQKGvMT24
	KgjJ6PNEhUHZT1Vfle+NjG8WczbFniw=
To: Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20240724062914.667734-1-idryomov@gmail.com>
 <20240724062914.667734-4-idryomov@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
Message-ID: <9c6bdd62-58a4-e660-9e59-f2f999795d9b@linux.dev>
Date: Thu, 25 Jul 2024 16:45:37 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240724062914.667734-4-idryomov@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2024/7/24 星期三 下午 2:29, Ilya Dryomov 写道:
> Expanding on the previous commit, assuming that rbd_is_lock_owner()
> always returns true (i.e. that we are either in RBD_LOCK_STATE_LOCKED
> or RBD_LOCK_STATE_QUIESCING) if the mapping is exclusive is wrong too.
> In case ceph_cls_set_cookie() fails, the lock would be temporarily
> released even if the mapping is exclusive, meaning that we can end up
> even in RBD_LOCK_STATE_UNLOCKED.
> 
> IOW, exclusive mappings are really "just" about disabling automatic
> lock transitions (as documented in the man page), not about grabbing
> the lock and holding on to it whatever it takes.

Hi Ilya,
	Could you explain more about "disabling atomic lock transitions"? To be 
honest, I was thinking --exclusive means "grabbing
the lock and holding on to it whatever it takes."

Thanx
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   drivers/block/rbd.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index dc4ddae4f7eb..b8e6700d65f8 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -6589,11 +6589,6 @@ static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
>   	if (ret)
>   		return ret;
>   
> -	/*
> -	 * The lock may have been released by now, unless automatic lock
> -	 * transitions are disabled.
> -	 */
> -	rbd_assert(!rbd_dev->opts->exclusive || rbd_is_lock_owner(rbd_dev));
>   	return 0;
>   }
>   
> 

