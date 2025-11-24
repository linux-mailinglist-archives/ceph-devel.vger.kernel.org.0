Return-Path: <ceph-devel+bounces-4101-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7E0C813F4
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 16:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 27D254E12DE
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 15:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB23311C1F;
	Mon, 24 Nov 2025 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ft0FcCmH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9932D22333B;
	Mon, 24 Nov 2025 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763996984; cv=none; b=gDLxmWu2ccY9plCvIAVDJ+D5F4K1I3wACmAJJZ7yB5lZNtxaM3kmwFDtpG5KXwLlMCKIVo29ezGKMzn7sqMvtd9tQ0JTzNgl+Xu1/mzG+Vd9AtnT/FvtS96VPaMDdgjMaL32i/AloZ5JlTX7SA1RQ2aOWR7FA9olZ3Jd3JpnI4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763996984; c=relaxed/simple;
	bh=9E5q0Wtvi/ASKPKgGbV6kYs3NyCkhXSfZkl6l0TaYN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fssersFkoX9AJHbxujawd9cxEUZLyFhPbwJb66VS1CDGHN3jf7pgQdwOOKMwcufQkkYaJ/railPaV9lzKO3zHhwykm5wJmqFq4lW0wrm0Lqut0t72xdRm+Ghzst4QDcPZeKjlRVuiyqXnb8mopDcHNF99ckChQpGkSqD/mdI4iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ft0FcCmH; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763996982; x=1795532982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9E5q0Wtvi/ASKPKgGbV6kYs3NyCkhXSfZkl6l0TaYN4=;
  b=ft0FcCmHSl9AorouW/BqCg9PrEOFcl/Q8u0RA0++pR4UdcFaBF0UMYqt
   kK12+PiRaFZw+OvPeme4pSGeDluQxdxF2Em1RDGjrOLwm8QwQkrZjKdMk
   OYDOGB74gVsoGAuQz2p7iRc9G3kKsNHmI/95f4Ezlf6OTNI7f+lDu78Sf
   Bj9KnOJYskRVZ2EdTxBuVY4Scq0tH+DxN6ybIS2BBz8WkMyTHLadj0lon
   K1Lteu27lqsIMuc89g1f5P9880ks2RzHWlarwvWJ8BfhcqD18clH06mnW
   dzUPXHs6Io7b9AsBsdVdzLVlzeaTaALSTAqBO0CQXyRMbxMbX8zwYQGLm
   A==;
X-CSE-ConnectionGUID: ZwKFcoF8TwemdF39NclbAQ==
X-CSE-MsgGUID: aW/rpD6LQaCdRQ1aWpOk5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76323217"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76323217"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 07:09:38 -0800
X-CSE-ConnectionGUID: DeH5VPFdSk6NccHcd4S/Yw==
X-CSE-MsgGUID: h3P8F/8SQSK7f7LMzeInSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192373237"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.244.5])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 07:09:35 -0800
Date: Mon, 24 Nov 2025 17:09:32 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>,
	"justinstitt@google.com" <justinstitt@google.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nathan@kernel.org" <nathan@kernel.org>,
	"morbo@google.com" <morbo@google.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Subject: Re: [PATCH v1 1/1] libceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <aSR1LFQnZgBgkN0t@smile.fi.intel.com>
References: <20251110144653.375367-1-andriy.shevchenko@linux.intel.com>
 <8d1983c9d4c84a6c78b72ba23aa196e849b465a1.camel@ibm.com>
 <aRI-ohUyQLxIY1vu@smile.fi.intel.com>
 <d33fedf2943e0de53317ef19840b46aedb58186e.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33fedf2943e0de53317ef19840b46aedb58186e.camel@ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 10, 2025 at 08:39:49PM +0000, Viacheslav Dubeyko wrote:
> On Mon, 2025-11-10 at 21:36 +0200, andriy.shevchenko@linux.intel.com wrote:
> > On Mon, Nov 10, 2025 at 07:28:36PM +0000, Viacheslav Dubeyko wrote:
> > > On Mon, 2025-11-10 at 15:46 +0100, Andy Shevchenko wrote:

...

> > > >  	ceph_decode_32_safe(p, end, len, e_inval);
> > > >  	if (len == 0 && incremental)
> > > >  		return NULL;	/* new_pg_temp: [] to remove */
> > > > -	if (len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
> > > > +	if ((size_t)len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
> > > >  		return ERR_PTR(-EINVAL);
> > > >  
> > > >  	ceph_decode_need(p, end, len * sizeof(u32), e_inval);
> > 
> > > I am guessing... What if we change the declaration of len on size_t, then could
> > > it be more clear solution here? For example, let's consider this for both cases:
> > > 
> > > size_t len, i;
> > > 
> > > Could it eliminate the issue and to make the Clang happy? Or could it introduce
> > > another warnings/issues?
> > 
> > Probably, but the code is pierced with the sizeof(u32) and alike, moreover
> > size_t is architecture-dependent type, while the set of macros in decode.h
> > seems to operate on the fixed-width type. That said, I prefer my way of fixing
> > this. But if you find another, better one, I am all ears!
> > 
> > *Also note, I'm not familiar with the guts of the ceph, so maybe your solution
> > is the best, but I want more people to confirm this.
> 
> I think the patch looks good as it is. And we can take it. If we find the better
> way
> of fixing this, then we can do it anytime.
> 
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Thanks, can this be applied? My builds are still broken.

-- 
With Best Regards,
Andy Shevchenko



