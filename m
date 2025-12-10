Return-Path: <ceph-devel+bounces-4170-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EABDCB30F0
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Dec 2025 14:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A24843053911
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Dec 2025 13:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CD230EF75;
	Wed, 10 Dec 2025 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b="XRnABThV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.haak.id.au (mail.haak.id.au [172.105.183.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EB02DC77A;
	Wed, 10 Dec 2025 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.105.183.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765374213; cv=none; b=E4kZRp6+XgyNTRW2KSvtjXsLCEp3AwV9Xn7EvDpFUeRy4paoajjGYbSMa7wQoL4lNDFVvJgCDmcqbf8mf/n7DVXKKuzPSLp5vgjkyExwfPXuzuY4WTVI/1ikj50My0jOXkXT99SDOtGpd/T3+BDRkAv9MifgOZdiRCYS5tVue6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765374213; c=relaxed/simple;
	bh=vbIJ79++239f65+5uhoikdJTPHTEYBJa19HsvUJ+OnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t159XRP2U1ydVu8lYWhzeOnf6qRBg7FUYUfey8L1D2mmBbjccn7EW4juPYcNhrcxqstpA8V2oqfrsImD2TASRQnsnEVcBWfpPFQHt1BMZ8ZVzeUnWkFOut7hy3Np/h3PmXhYUFwlmSAhYNMpVDEgSoZGHdO4XuOR+/kAyWEIhaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au; spf=pass smtp.mailfrom=haak.id.au; dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b=XRnABThV; arc=none smtp.client-ip=172.105.183.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=haak.id.au
Received: from xps15mal (180-150-104-78.b49668.bne.static.aussiebb.net [180.150.104.78])
	by mail.haak.id.au (Postfix) with ESMTPSA id BF9E08337B;
	Wed, 10 Dec 2025 23:43:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=haak.id.au; s=202002;
	t=1765374201; bh=vbIJ79++239f65+5uhoikdJTPHTEYBJa19HsvUJ+OnQ=;
	h=Date:From:To:Subject:From;
	b=XRnABThVx+UyGFi49rlYBNZZc4lMF5MmkFiqKrorzROqSgYKKKxOCKCh6QEN3t4qS
	 NznAnPk6uqT0M4UTQM0zaPZDfSaW6pa7g0Nap9bYHLpU+DciqyiHE2UH243ZHY8Lgm
	 axLWa930++Y2DyXGTy8k3RQ+5MEE+MYIP1B0tU4Nh/iF/vlefHep2J2na4S/2IAPc9
	 g+jYiPiP5DSBNrYlQzM3QyegSy/O405eVJArcwM5Zipqui/1JS3msrfIbMUb1yhlo0
	 letOflN0a0fursH3pHQDh6SnyeIofX9TEPz9vXy3Q6GOJTTm84skZ32CJ5sU/mmI7W
	 3EXCofFis4c/A==
Date: Wed, 10 Dec 2025 23:43:18 +1000
From: Mal Haak <malcolm@haak.id.au>
To: "David Wang" <00107082@163.com>
Cc: linux-kernel@vger.kernel.org, surenb@google.com, xiubli@redhat.com,
 idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: Possible memory leak in 6.17.7
Message-ID: <20251210234318.5d8c2d68@xps15mal>
In-Reply-To: <17469653.4a75.19b01691299.Coremail.00107082@163.com>
References: <20251110182008.71e0858b@xps15mal>
	<20251208110829.11840-1-00107082@163.com>
	<20251209090831.13c7a639@xps15mal>
	<17469653.4a75.19b01691299.Coremail.00107082@163.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 Dec 2025 12:40:21 +0800 (CST)
"David Wang" <00107082@163.com> wrote:

> At 2025-12-09 07:08:31, "Mal Haak" <malcolm@haak.id.au> wrote:
> >On Mon,  8 Dec 2025 19:08:29 +0800
> >David Wang <00107082@163.com> wrote:
> >  
> >> On Mon, 10 Nov 2025 18:20:08 +1000
> >> Mal Haak <malcolm@haak.id.au> wrote:  
> >> > Hello,
> >> > 
> >> > I have found a memory leak in 6.17.7 but I am unsure how to
> >> > track it down effectively.
> >> > 
> >> >     
> >> 
> >> I think the `memory allocation profiling` feature can help.
> >> https://docs.kernel.org/mm/allocation-profiling.html
> >> 
> >> You would need to build a kernel with 
> >> CONFIG_MEM_ALLOC_PROFILING=y
> >> CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y
> >> 
> >> And check /proc/allocinfo for the suspicious allocations which take
> >> more memory than expected.
> >> 
> >> (I once caught a nvidia driver memory leak.)
> >> 
> >> 
> >> FYI
> >> David
> >>   
> >
> >Thank you for your suggestion. I have some results.
> >
> >Ran the rsync workload for about 9 hours. It started to look like it
> >was happening.
> ># smem -pw
> >Area                           Used      Cache   Noncache 
> >firmware/hardware             0.00%      0.00%      0.00% 
> >kernel image                  0.00%      0.00%      0.00% 
> >kernel dynamic memory        80.46%     65.80%     14.66% 
> >userspace memory              0.35%      0.16%      0.19% 
> >free memory                  19.19%     19.19%      0.00% 
> ># sort -g /proc/allocinfo|tail|numfmt --to=iec
> >         22M     5609 mm/memory.c:1190 func:folio_prealloc 
> >         23M     1932 fs/xfs/xfs_buf.c:226 [xfs]
> >func:xfs_buf_alloc_backing_mem 
> >         24M    24135 fs/xfs/xfs_icache.c:97 [xfs]
> > func:xfs_inode_alloc 27M     6693 mm/memory.c:1192
> > func:folio_prealloc 58M    14784 mm/page_ext.c:271
> > func:alloc_page_ext 258M      129 mm/khugepaged.c:1069
> > func:alloc_charge_folio 430M   770788 lib/xarray.c:378
> > func:xas_alloc 545M    36444 mm/slub.c:3059 func:alloc_slab_page 
> >        9.8G  2563617 mm/readahead.c:189 func:ractl_alloc_folio 
> >         20G  5164004 mm/filemap.c:2012 func:__filemap_get_folio 
> >
> >
> >So I stopped the workload and dropped caches to confirm.
> >
> ># echo 3 > /proc/sys/vm/drop_caches
> ># smem -pw
> >Area                           Used      Cache   Noncache 
> >firmware/hardware             0.00%      0.00%      0.00% 
> >kernel image                  0.00%      0.00%      0.00% 
> >kernel dynamic memory        33.45%      0.09%     33.36% 
> >userspace memory              0.36%      0.16%      0.19% 
> >free memory                  66.20%     66.20%      0.00% 
> ># sort -g /proc/allocinfo|tail|numfmt --to=iec
> >         12M     2987 mm/execmem.c:41 func:execmem_vmalloc 
> >         12M        3 kernel/dma/pool.c:96 func:atomic_pool_expand 
> >         13M      751 mm/slub.c:3061 func:alloc_slab_page 
> >         16M        8 mm/khugepaged.c:1069 func:alloc_charge_folio 
> >         18M     4355 mm/memory.c:1190 func:folio_prealloc 
> >         24M     6119 mm/memory.c:1192 func:folio_prealloc 
> >         58M    14784 mm/page_ext.c:271 func:alloc_page_ext 
> >         61M    15448 mm/readahead.c:189 func:ractl_alloc_folio 
> >         79M     6726 mm/slub.c:3059 func:alloc_slab_page 
> >         11G  2674488 mm/filemap.c:2012 func:__filemap_get_folio
> >
> >So if I'm reading this correctly something is causing folios collect
> >and not be able to be freed?  
> 
> CC cephfs, maybe someone could have an easy reading out of those
> folio usage
> 
> 
> >
> >Also it's clear that some of the folio's are counting as cache and
> >some aren't. 
> >
> >Like I said 6.17 and 6.18 both have the issue. 6.12 does not. I'm now
> >going to manually walk through previous kernel releases and find
> >where it first starts happening purely because I'm having issues
> >building earlier kernels due to rust stuff and other python
> >incompatibilities making doing a git-bisect a bit fun.
> >
> >I'll do it the packages way until I get closer, then solve the build
> >issues. 
> >
> >Thanks,
> >Mal
> >  
Thanks David.

I've contacted the ceph developers as well. 

There was a suggestion it was due to the change from, to quote:
folio.free() to folio.put() or something like this.

The change happened around 6.14/6.15

I've found an easier reproducer. 

There has been a suggestion that perhaps the ceph team might not fix
this as "you can just reboot before the machine becomes unstable" and
"Nobody else has encountered this bug"

I'll leave that to other people to make a call on but I'd assume the
lack of reports is due to the fact that most stable distros are still
on a a far too early kernel and/or are using the fuse driver with k8s.

Anyway, thanks for your assistance.


