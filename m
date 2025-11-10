Return-Path: <ceph-devel+bounces-3977-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 077C6C4916B
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 20:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 643534ECD16
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 19:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3353338582;
	Mon, 10 Nov 2025 19:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jCGtMTmd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD244336EFD;
	Mon, 10 Nov 2025 19:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762803369; cv=none; b=lqjCNSwRdNR6+IxeeFuitQLVri/MV9VcM/Z+TWnCNlL+otVVOaewdIlSlAxpKvDLpZjU1mAqd7R69jUQWD8sSwqmxkI7eNvwzNuRyl655rBTAlBoB/NX6qGlXyD9scHni1qWCflS2pExyBh8q91z6cPWf0tOsHAOAipXsOKcwY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762803369; c=relaxed/simple;
	bh=olv7d//xcCevUgqm9DIDkmw0k6Ut2QCEuYEXptcV9sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/YiRNogIH4K545YECnH0Uq4nXtAlSAYAb+VEIDutnnOjGFgwSXs1LhLf0Bf+4gIRaB0pCbXCtd140GgndjpSm3FIrSCj30MGk2esu6QG/ppFfTPGau845sKj0BoiizNYBdUyoNntsW9f/DWkBfpfdjUSxLulvjdxJfxqZjaCbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jCGtMTmd; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762803368; x=1794339368;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=olv7d//xcCevUgqm9DIDkmw0k6Ut2QCEuYEXptcV9sY=;
  b=jCGtMTmd3qmaiO7tGkm4Vzxs2MaZIe2nVAXWmCBtBQLamUnzWdbSRzmf
   2zzEHSIG4xuESe76m/RWxPcSLItwZg+9Om5Mdfm9hw2452Dpbo+m/rNCk
   ebuWK1nAS107txAeTAlLdkxogQpWQdbJG8HbfVLEmOnfhwzG8atfuHj+/
   7/UCqi5I2JEIC4mAj2R/1JXcAqBITon0xjolMHxcXhPXUFslYM+OEdQJU
   a2WSbx5km3l8kexMlc049vTHQbAKljZ8uiDy2E6fohCVeAPCErFV+5DzK
   swdIlzfVRbJ1chmMf7pkx9GcPOEV8gLLO9pZ+mhF3V+YQ1F6NqvHQ4RPT
   g==;
X-CSE-ConnectionGUID: gTOxp0/NRIm10/61xoT29Q==
X-CSE-MsgGUID: LL96BJzNRSuJX3xepD9qhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="75546759"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="75546759"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 11:36:07 -0800
X-CSE-ConnectionGUID: +Q9UiPQPRvSLyVkLuGMm/A==
X-CSE-MsgGUID: rosFfrD0QyqcFhI9x8YSvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="193760668"
Received: from kniemiec-mobl1.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.245.235])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 11:36:05 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vIXgI-00000007Yi7-1PZM;
	Mon, 10 Nov 2025 21:36:02 +0200
Date: Mon, 10 Nov 2025 21:36:02 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nathan@kernel.org" <nathan@kernel.org>,
	"justinstitt@google.com" <justinstitt@google.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	"nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>,
	"morbo@google.com" <morbo@google.com>
Subject: Re: [PATCH v1 1/1] libceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <aRI-ohUyQLxIY1vu@smile.fi.intel.com>
References: <20251110144653.375367-1-andriy.shevchenko@linux.intel.com>
 <8d1983c9d4c84a6c78b72ba23aa196e849b465a1.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d1983c9d4c84a6c78b72ba23aa196e849b465a1.camel@ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 10, 2025 at 07:28:36PM +0000, Viacheslav Dubeyko wrote:
> On Mon, 2025-11-10 at 15:46 +0100, Andy Shevchenko wrote:

...

> >  	ceph_decode_32_safe(p, end, len, e_inval);
> >  	if (len == 0 && incremental)
> >  		return NULL;	/* new_pg_temp: [] to remove */
> > -	if (len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
> > +	if ((size_t)len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
> >  		return ERR_PTR(-EINVAL);
> >  
> >  	ceph_decode_need(p, end, len * sizeof(u32), e_inval);

> I am guessing... What if we change the declaration of len on size_t, then could
> it be more clear solution here? For example, let's consider this for both cases:
> 
> size_t len, i;
> 
> Could it eliminate the issue and to make the Clang happy? Or could it introduce
> another warnings/issues?

Probably, but the code is pierced with the sizeof(u32) and alike, moreover
size_t is architecture-dependent type, while the set of macros in decode.h
seems to operate on the fixed-width type. That said, I prefer my way of fixing
this. But if you find another, better one, I am all ears!

*Also note, I'm not familiar with the guts of the ceph, so maybe your solution
is the best, but I want more people to confirm this.

-- 
With Best Regards,
Andy Shevchenko



