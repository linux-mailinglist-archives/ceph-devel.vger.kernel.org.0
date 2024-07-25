Return-Path: <ceph-devel+bounces-1562-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 867B793BFB8
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 12:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B77B01C20EEB
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 10:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFC4198A3B;
	Thu, 25 Jul 2024 10:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N2ZcRcDe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57CB195FEF
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721902118; cv=none; b=WeHJlPiTJ1GR6ftx52MxdbQu0ZL5WgNNOUhl69zc2Jiic2btFjapQk/rCnKzrFAlBaBa78rjhE1AVYQ6SNsk78opWzht9ZJA4xFhpbgmNjDX3wDeW2vVKiqa3nTNpU0Uhfl6/G+7FlbX9zaQf6c9pjNmk/lAxYcBHeUmZNw2Np0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721902118; c=relaxed/simple;
	bh=5V3FfDcE57PTV8dJL9mUn3Vpu/m8WsSV3QSiFEAnQrY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aA6rD+BrDtAPHJLtJIJHB5PxRDXHaNsXBYd5ldoWooAXscbzdf/HDs2Ii3m6H8gK4nKBYNn51Yg31yO3Ziskr2vEWBVGwTAIHbHOEcRIucCsxJ85Vz/uI0XQCRbA1lPsiu3abG07RWhO8AuSzp9bx3rxeq4//VdxisEbmpg9pmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N2ZcRcDe; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Subject: Re: [PATCH 3/3] rbd: don't assume rbd_is_lock_owner() for exclusive
 mappings
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721902112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqORYgHIZlY1k4GBNsahPXrYPt85iSK6Z0y3QFvX6do=;
	b=N2ZcRcDewcvNlwYMtohjMn2ZHVtkWyvdpnWjMA1FPcAOSu4/xxZq9AiUNcvaPl4cu7tO6L
	R4L1QeYynS05Qbc53Eds5qGAb/Ti3XUxjnHCm3yvxJKWytXqqnzX29s4NCKSZqcaFa/4ZO
	YeRDPH4V6X2T3wUDkRySnc44t7o1xSk=
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
References: <20240724062914.667734-1-idryomov@gmail.com>
 <20240724062914.667734-4-idryomov@gmail.com>
 <9c6bdd62-58a4-e660-9e59-f2f999795d9b@linux.dev>
 <CAOi1vP_wyoEhawoArdUmX4i0w1u37Ei7f7nbjy=_ub0gogRd4Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
Message-ID: <dea0f277-3fe8-4539-24d1-285e6d5c1a76@linux.dev>
Date: Thu, 25 Jul 2024 18:08:24 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_wyoEhawoArdUmX4i0w1u37Ei7f7nbjy=_ub0gogRd4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2024/7/25 星期四 下午 5:31, Ilya Dryomov 写道:
> On Thu, Jul 25, 2024 at 10:45 AM Dongsheng Yang
> <dongsheng.yang@linux.dev> wrote:
>>
>>
>>
>> 在 2024/7/24 星期三 下午 2:29, Ilya Dryomov 写道:
>>> Expanding on the previous commit, assuming that rbd_is_lock_owner()
>>> always returns true (i.e. that we are either in RBD_LOCK_STATE_LOCKED
>>> or RBD_LOCK_STATE_QUIESCING) if the mapping is exclusive is wrong too.
>>> In case ceph_cls_set_cookie() fails, the lock would be temporarily
>>> released even if the mapping is exclusive, meaning that we can end up
>>> even in RBD_LOCK_STATE_UNLOCKED.
>>>
>>> IOW, exclusive mappings are really "just" about disabling automatic
>>> lock transitions (as documented in the man page), not about grabbing
>>> the lock and holding on to it whatever it takes.
>>
>> Hi Ilya,
>>          Could you explain more about "disabling atomic lock transitions"? To be
>> honest, I was thinking --exclusive means "grabbing
>> the lock and holding on to it whatever it takes."
> 
> Hi Dongsheng,
> 
> Here are the relevant excerpts from the documentation [1]:
> 
>> To maintain multi-client access, the exclusive-lock feature
>> implements automatic cooperative lock transitions between clients.
>>
>> Whenever a client that holds an exclusive lock on an RBD image gets
>> a request to release the lock, it stops handling writes, flushes its
>> caches and releases the lock.
>>
>> By default, the exclusive-lock feature does not prevent two or more
>> concurrently running clients from opening the same RBD image and
>> writing to it in turns (whether on the same node or not). In effect,
>> their writes just get linearized as the lock is automatically
>> transitioned back and forth in a cooperative fashion.
>>
>> To disable automatic lock transitions between clients, the
>> RBD_LOCK_MODE_EXCLUSIVE flag may be specified when acquiring the
>> exclusive lock. This is exposed by the --exclusive option for rbd
>> device map command.
> 
> This is mostly equivalent to "grab the lock and hold on to it", but
> it's not guaranteed that the lock would never be released.  If a watch
> error occurs, the lock cookie needs to be updated after the watch is
> reestablished.  If ceph_cls_set_cookie() fails, we have no choice but
> to release the lock and immediately attempt to reacquire it because
> otherwise the lock cookie would disagree with that of the new watch.
> 
> The code in question has always behaved this way.  Prior to commit
> 14bb211d324d ("rbd: support updating the lock cookie without releasing
> the lock"), the lock was (briefly) released on watch errors
> unconditionally.

Thanx Ilya, it clarify things. then

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>

For all of these 3 patches.

Thanx
> 
> [1] https://docs.ceph.com/en/latest/rbd/rbd-exclusive-locks/
> 
> Thanks,
> 
>                  Ilya
> 

