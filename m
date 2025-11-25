Return-Path: <ceph-devel+bounces-4111-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4386AC8469F
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Nov 2025 11:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E3B9C3472D1
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Nov 2025 10:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A976C231836;
	Tue, 25 Nov 2025 10:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RzhndWbb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FF121D5B0;
	Tue, 25 Nov 2025 10:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764065837; cv=none; b=e3gDRjoSgOir0qaQs6rnkPBTMlRD+2bOogUoVkZtWddFkHsehomKKdoys3HprCaocMJF44xI5KygKNCiM2pyMolac6AkuqPz1FD4ymh5+ZSuhj42NKH7YUrk+3JKWbIAI/mjSHFSlApOTlnNmt4VdrdfePx7HA2Bfd/Wsq0xq1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764065837; c=relaxed/simple;
	bh=/NShvCZmdmv7vMPTtCod5iJV1/r1UpcumuJTXJKBd7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8dGVDtsXvx/i2SlS1X6cxGmIKlO2WF+seW6wDzVGNEKKlfBy09Htim+6pwTHi3fyvghVb4RtVa/Qk06VFpUChU/AyQWH0yf4qVlAZgd6fAWxEueaCLsITvnms/T+/jyD5R2etr+EEsvRoDRRa8rAsjnLU6JeCIunBFS98wHkN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RzhndWbb; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764065836; x=1795601836;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/NShvCZmdmv7vMPTtCod5iJV1/r1UpcumuJTXJKBd7c=;
  b=RzhndWbb1zWy8flvqbty5k94gv8PR6njZK6f8I4OIBnHKOfCRh17szGY
   xNEV/lDFA5yl5IVmdfVZIP/wl0KDHvzM9PKsTrKOmniArGVjYJQoXVC5p
   WeZOIFW03TrdBZHmbj6WMyw7R5t6Qo5CHtfKTbIO4gbwxANVLguZ9IoSQ
   kjLAdX+zwJgFTJq00oJUTKC33RKHWg8wUPh94KPGhju3ItkjRgva/s/sb
   pNMX0ZuQ9Kwaas9v/a6cK/veZ4rrNTAFjBJ65kfPnHomUSdasxYPgksGt
   tf9sjcE4n6UhxMKJALCIDbBJXNblWOTfW+oieLrNv5hSv86LPgHLXCsji
   Q==;
X-CSE-ConnectionGUID: h8cJ546jTTKR+Vkbh6RaJA==
X-CSE-MsgGUID: SqeOBDJOSAqYnBDXRc0kmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="68668708"
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="68668708"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 02:17:15 -0800
X-CSE-ConnectionGUID: +zC+rKXxR9qpVDX4v+R96A==
X-CSE-MsgGUID: pVuLPThqTMmD2HfnEDeGfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="191736622"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.152])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 02:17:12 -0800
Date: Tue, 25 Nov 2025 12:17:10 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: david laight <david.laight@runbox.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <aSWCJhA3cNSEIUir@smile.fi.intel.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
 <20251125095516.40a3d57c@pumpkin>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125095516.40a3d57c@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Nov 25, 2025 at 09:55:16AM +0000, david laight wrote:
> On Mon, 10 Nov 2025 15:44:04 +0100
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > In a few cases the code compares 32-bit value to a SIZE_MAX derived
> > constant which is much higher than that value on 64-bit platforms,
> > Clang, in particular, is not happy about this
> > 
> > fs/ceph/snap.c:377:10: error: result of comparison of constant 2305843009213693948 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
> >   377 |         if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> >       |             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Fix this by casting to size_t. Note, that possible replacement of SIZE_MAX
> > by U32_MAX may lead to the behaviour changes on the corner cases.
> 
> Did you really read the code?

I read the piece that prevents builds. The exercise on how to fix this properly
is delegated to the authors and maintainers.

> The test itself needs moving into ceph_create_snap_context().
> Possibly by using kmalloc_array() to do the multiply.
> 
> But in any case are large values sane at all?
> Allocating very large kernel memory blocks isn't a good idea at all.
> 
> In fact this does a kmalloc(... GFP_NOFS) which is pretty likely to
> fail for even moderate sized requests. I bet it fails 64k (order 4?)
> on a regular basis.
> 
> Perhaps all three value that get added to make 'num' need 'sanity limits'
> that mean a large allocation just can't happen.

Nice, can you send a followup to fix all that in a better way?
(I don't care about the fix as long as it doesn't break my builds)

-- 
With Best Regards,
Andy Shevchenko



