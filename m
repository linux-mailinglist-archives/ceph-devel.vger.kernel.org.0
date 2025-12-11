Return-Path: <ceph-devel+bounces-4172-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4706DCB4AC2
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Dec 2025 05:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 840CE3010CFB
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Dec 2025 04:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6681B4224;
	Thu, 11 Dec 2025 04:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b="cat6QWor"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.haak.id.au (mail.haak.id.au [172.105.183.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A3A4400;
	Thu, 11 Dec 2025 04:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.105.183.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765427048; cv=none; b=O5FI7QkYPeE5UE1hYEvqTKM91QPIhf6fB293p/srN3zSVHNx5hP8c8llW6On63rYnk0UVZcnOz97CYH9T9eQHDZbYdZn1ceKsXhdd7TZ1JaCeAL8dbJNtaDJiEc7JqTpEF1vq9NV9Xeg20ndfka5aK/qdFIFVFG2WcRMRkPBFPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765427048; c=relaxed/simple;
	bh=WUmBOJtXhU4udAhNIOPZRanhMbW7bLMo5HVT3p//nOo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ge9Ma4Tpz8XbwZSGRm2Fig3L+8kMGJ3S0lOaqJREdt62tIxahdi0bDWPdut4T6psa09Bx7pZgWTPBIgVrmulTROxQ5ZuhzVH0fHLCsT4VwqED3aofUvm77zm7P6hY/GkagYdIujyaKIdHpVYGuMyOTQfiLbXapIzs9/4v1STQEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au; spf=pass smtp.mailfrom=haak.id.au; dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b=cat6QWor; arc=none smtp.client-ip=172.105.183.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=haak.id.au
Received: from xps15mal (unknown [1.146.64.210])
	by mail.haak.id.au (Postfix) with ESMTPSA id 762877F162;
	Thu, 11 Dec 2025 14:24:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=haak.id.au; s=202002;
	t=1765427042; bh=WUmBOJtXhU4udAhNIOPZRanhMbW7bLMo5HVT3p//nOo=;
	h=Date:From:To:Subject:From;
	b=cat6QWorztuFWHmHQ6RXB5IgHAoL6JbRRYXcJfEq/M1EGLCb98ttR4LlF1V/mDJTM
	 tw95BP5BcndG+DczG2BO968AYoFu68M0mD6UL520lX6pcBJG5wfz5IW0j9f1qnJeTm
	 lu11UGYdz0j8PEWiY2AI+nLbK4ANjHHNnPnEpg0ekVH+QQkAKOn+VaO/X5vmZ5szH1
	 +Q4u+Oe9bntQyiiqNcJZTVosNiBlPa8z0ygheugwNDvvHCwjz90VxyP6bSBBIC5eJs
	 Hc9dCq2LJgxkoKvax2FORFltEIHtwPlI8swJnLqShYTGkjzNIYPA9sxb/IgkLjrl/U
	 UtqsqHQu4dnZw==
Date: Thu, 11 Dec 2025 14:23:58 +1000
From: Mal Haak <malcolm@haak.id.au>
To: "David Wang" <00107082@163.com>
Cc: linux-kernel@vger.kernel.org, surenb@google.com, xiubli@redhat.com,
 idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: RRe: Possible memory leak in 6.17.7
Message-ID: <20251211142358.563d9ac3@xps15mal>
In-Reply-To: <2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
References: <20251110182008.71e0858b@xps15mal>
	<20251208110829.11840-1-00107082@163.com>
	<20251209090831.13c7a639@xps15mal>
	<17469653.4a75.19b01691299.Coremail.00107082@163.com>
	<20251210234318.5d8c2d68@xps15mal>
	<2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 11:28:21 +0800 (CST)
"David Wang" <00107082@163.com> wrote:

> At 2025-12-10 21:43:18, "Mal Haak" <malcolm@haak.id.au> wrote:
> >On Tue, 9 Dec 2025 12:40:21 +0800 (CST)
> >"David Wang" <00107082@163.com> wrote:
> >  
> >> At 2025-12-09 07:08:31, "Mal Haak" <malcolm@haak.id.au> wrote:  
> >> >On Mon,  8 Dec 2025 19:08:29 +0800
> >> >David Wang <00107082@163.com> wrote:
> >> >    
> >> >> On Mon, 10 Nov 2025 18:20:08 +1000
> >> >> Mal Haak <malcolm@haak.id.au> wrote:    
> >> >> > Hello,
> >> >> > 
> >> >> > I have found a memory leak in 6.17.7 but I am unsure how to
> >> >> > track it down effectively.
> >> >> > 
> >> >> >       
> >> >> 
> >> >> I think the `memory allocation profiling` feature can help.
> >> >> https://docs.kernel.org/mm/allocation-profiling.html
> >> >> 
> >> >> You would need to build a kernel with 
> >> >> CONFIG_MEM_ALLOC_PROFILING=y
> >> >> CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y
> >> >> 
> >> >> And check /proc/allocinfo for the suspicious allocations which
> >> >> take more memory than expected.
> >> >> 
> >> >> (I once caught a nvidia driver memory leak.)
> >> >> 
> >> >> 
> >> >> FYI
> >> >> David
> >> >>     
> >> >
> >> >Thank you for your suggestion. I have some results.
> >> >
> >> >Ran the rsync workload for about 9 hours. It started to look like
> >> >it was happening.
> >> ># smem -pw
> >> >Area                           Used      Cache   Noncache 
> >> >firmware/hardware             0.00%      0.00%      0.00% 
> >> >kernel image                  0.00%      0.00%      0.00% 
> >> >kernel dynamic memory        80.46%     65.80%     14.66% 
> >> >userspace memory              0.35%      0.16%      0.19% 
> >> >free memory                  19.19%     19.19%      0.00% 
> >> ># sort -g /proc/allocinfo|tail|numfmt --to=iec
> >> >         22M     5609 mm/memory.c:1190 func:folio_prealloc 
> >> >         23M     1932 fs/xfs/xfs_buf.c:226 [xfs]
> >> >func:xfs_buf_alloc_backing_mem 
> >> >         24M    24135 fs/xfs/xfs_icache.c:97 [xfs]
> >> > func:xfs_inode_alloc 27M     6693 mm/memory.c:1192
> >> > func:folio_prealloc 58M    14784 mm/page_ext.c:271
> >> > func:alloc_page_ext 258M      129 mm/khugepaged.c:1069
> >> > func:alloc_charge_folio 430M   770788 lib/xarray.c:378
> >> > func:xas_alloc 545M    36444 mm/slub.c:3059 func:alloc_slab_page 
> >> >        9.8G  2563617 mm/readahead.c:189 func:ractl_alloc_folio 
> >> >         20G  5164004 mm/filemap.c:2012 func:__filemap_get_folio 
> >> >
> >> >
> >> >So I stopped the workload and dropped caches to confirm.
> >> >
> >> ># echo 3 > /proc/sys/vm/drop_caches
> >> ># smem -pw
> >> >Area                           Used      Cache   Noncache 
> >> >firmware/hardware             0.00%      0.00%      0.00% 
> >> >kernel image                  0.00%      0.00%      0.00% 
> >> >kernel dynamic memory        33.45%      0.09%     33.36% 
> >> >userspace memory              0.36%      0.16%      0.19% 
> >> >free memory                  66.20%     66.20%      0.00% 
> >> ># sort -g /proc/allocinfo|tail|numfmt --to=iec
> >> >         12M     2987 mm/execmem.c:41 func:execmem_vmalloc 
> >> >         12M        3 kernel/dma/pool.c:96
> >> > func:atomic_pool_expand 13M      751 mm/slub.c:3061
> >> > func:alloc_slab_page 16M        8 mm/khugepaged.c:1069
> >> > func:alloc_charge_folio 18M     4355 mm/memory.c:1190
> >> > func:folio_prealloc 24M     6119 mm/memory.c:1192
> >> > func:folio_prealloc 58M    14784 mm/page_ext.c:271
> >> > func:alloc_page_ext 61M    15448 mm/readahead.c:189
> >> > func:ractl_alloc_folio 79M     6726 mm/slub.c:3059
> >> > func:alloc_slab_page 11G  2674488 mm/filemap.c:2012
> >> > func:__filemap_get_folio  
> 
> Maybe narrowing down the "Noncache" caller of __filemap_get_folio
> would help clarify things. (It could be designed that way, and  needs
> other route than dropping-cache to release the memory, just
> guess....) If you want, you can modify code to split the accounting
> for __filemap_get_folio according to its callers.


Thanks again, I'll add this patch in and see where I end up. 

The issue is nothing will cause the memory to be freed. Dropping caches
doesn't work, memory pressure doesn't work, unmounting the filesystems
doesn't work. Removing the cephfs and netfs kernel modules also doesn't
work. 

This is why I feel it's a ref_count (or similar) issue. 

I've also found it seems to be a fixed amount leaked each time, per
file. Simply doing lots of IO on one large file doesn't leak as fast as
lots of "small" (greater than 10MB less than 100MB seems to be a sweet
spot) 

Also, dropping caches while the workload is running actually amplifies
the issue. So it very much feels like something is wrong in the reclaim
code.

Anyway I'll get this patch applied and see where I end up. 

I now have crash dumps (after enabling crash_on_oom) so I'm going to
try and see if I can find these structures and see what state they are
in

Thanks again. 

Mal


> Following is a draft patch: (based on v6.18)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 09b581c1d878..ba8c659a6ae3 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -753,7 +753,11 @@ static inline fgf_t fgf_set_order(size_t size)
>  }
>  
>  void *filemap_get_entry(struct address_space *mapping, pgoff_t
> index); -struct folio *__filemap_get_folio(struct address_space
> *mapping, pgoff_t index, +
> +#define __filemap_get_folio(...)			\
> +	alloc_hooks(__filemap_get_folio_noprof(__VA_ARGS__))
> +
> +struct folio *__filemap_get_folio_noprof(struct address_space
> *mapping, pgoff_t index, fgf_t fgp_flags, gfp_t gfp);
>  struct page *pagecache_get_page(struct address_space *mapping,
> pgoff_t index, fgf_t fgp_flags, gfp_t gfp);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 024b71da5224..e1c1c26d7cb3 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1938,7 +1938,7 @@ void *filemap_get_entry(struct address_space
> *mapping, pgoff_t index) *
>   * Return: The found folio or an ERR_PTR() otherwise.
>   */
> -struct folio *__filemap_get_folio(struct address_space *mapping,
> pgoff_t index, +struct folio *__filemap_get_folio_noprof(struct
> address_space *mapping, pgoff_t index, fgf_t fgp_flags, gfp_t gfp)
>  {
>  	struct folio *folio;
> @@ -2009,7 +2009,7 @@ struct folio *__filemap_get_folio(struct
> address_space *mapping, pgoff_t index, err = -ENOMEM;
>  			if (order > min_order)
>  				alloc_gfp |= __GFP_NORETRY |
> __GFP_NOWARN;
> -			folio = filemap_alloc_folio(alloc_gfp,
> order);
> +			folio =
> filemap_alloc_folio_noprof(alloc_gfp, order); if (!folio)
>  				continue;
>  
> @@ -2056,7 +2056,7 @@ struct folio *__filemap_get_folio(struct
> address_space *mapping, pgoff_t index, folio_clear_dropbehind(folio);
>  	return folio;
>  }
> -EXPORT_SYMBOL(__filemap_get_folio);
> +EXPORT_SYMBOL(__filemap_get_folio_noprof);
>  
>  static inline struct folio *find_get_entry(struct xa_state *xas,
> pgoff_t max, xa_mark_t mark)
> 
> 
> 
> 
> FYI
> David
> 
> >> >
> >> >So if I'm reading this correctly something is causing folios
> >> >collect and not be able to be freed?    
> >> 
> >> CC cephfs, maybe someone could have an easy reading out of those
> >> folio usage
> >> 
> >>   
> >> >
> >> >Also it's clear that some of the folio's are counting as cache and
> >> >some aren't. 
> >> >
> >> >Like I said 6.17 and 6.18 both have the issue. 6.12 does not. I'm
> >> >now going to manually walk through previous kernel releases and
> >> >find where it first starts happening purely because I'm having
> >> >issues building earlier kernels due to rust stuff and other python
> >> >incompatibilities making doing a git-bisect a bit fun.
> >> >
> >> >I'll do it the packages way until I get closer, then solve the
> >> >build issues. 
> >> >
> >> >Thanks,
> >> >Mal
> >> >    
> >Thanks David.
> >
> >I've contacted the ceph developers as well. 
> >
> >There was a suggestion it was due to the change from, to quote:
> >folio.free() to folio.put() or something like this.
> >
> >The change happened around 6.14/6.15
> >
> >I've found an easier reproducer. 
> >
> >There has been a suggestion that perhaps the ceph team might not fix
> >this as "you can just reboot before the machine becomes unstable" and
> >"Nobody else has encountered this bug"
> >
> >I'll leave that to other people to make a call on but I'd assume the
> >lack of reports is due to the fact that most stable distros are still
> >on a a far too early kernel and/or are using the fuse driver with
> >k8s.
> >
> >Anyway, thanks for your assistance.  


