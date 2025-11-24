Return-Path: <ceph-devel+bounces-4100-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D2DC813EB
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 16:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3E553A3163
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 15:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588B830EF7F;
	Mon, 24 Nov 2025 15:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="emz0gOvS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF42930DEDC;
	Mon, 24 Nov 2025 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763996958; cv=none; b=qcQrEK7E//srbb/qPxk9Mz54296M4jmFAUTA7ZQDeLKMRQbR3xaKnjogKL6aG5EjpxibBbvB5RR2Zl6XejnxsDmI/MF493Xfdj+O1dRIsEbAUxQ3CFOpQMgIpolBGuvYFQZqWhd9e1ewP3osXkqFYHOhZmPYshNtUURFKHhYojM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763996958; c=relaxed/simple;
	bh=VdrdC4J0Yqn+eZOSl8V0C8N1cNUsVnzAIpcrW3CmhqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXoD9lxOLT0xaCjJHvte296ZeAuPzk5wJXt9C+lQIXLSq3sY+MvsskWzblnyObd1r0yjxy8jYPIaIAXIWoTAfFdOfk7cXPcjFKZ9opi2Iqpr13SVYgTYFpHyyQnD2w6Agzc7kxWp25edTTIL3IqMI8GI0xTZ0HtipNPaOCCtplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=emz0gOvS; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763996955; x=1795532955;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VdrdC4J0Yqn+eZOSl8V0C8N1cNUsVnzAIpcrW3CmhqI=;
  b=emz0gOvSBz4lULVvvtwXl5Ne6v/njZWKQUnXD7byEakEtU1inSowCj0m
   Gt4BcJVgyHhFtheHWsonRB9qToLnf1jnkRTB80B8oEPPK6W8grwFOjVhO
   CBCv7keY843M8WecvfaJE9GwDeCDlxQOuvxlVyO9rTbUdQSURnAONUNHm
   NhrICtwMeuRXJjYPmTqu8KlJFjApTxihmsraeS4X/mjjKXKu0IsJ7qeDN
   /XtlovPoL8YCdK8QRIFZtElLAK9tY3k3z388tQEoK9PpX7b2ji8D9LmCM
   /J7Obt/j5ANsemUIW3xGevuPG7lXxJwSHdoNg8K/v03hvjeQ5KkUFgBao
   g==;
X-CSE-ConnectionGUID: k8cNNJaoQea39yNA9AZzAw==
X-CSE-MsgGUID: j9MzJNzXQhij978c0m1E+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76323177"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76323177"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 07:09:14 -0800
X-CSE-ConnectionGUID: a1M11qwZS5OUfyJ8a8bY2w==
X-CSE-MsgGUID: BdbkXD2MQt+eOkrYzvzHaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192373186"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.244.5])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 07:09:12 -0800
Date: Mon, 24 Nov 2025 17:09:09 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>,
	"justinstitt@google.com" <justinstitt@google.com>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nathan@kernel.org" <nathan@kernel.org>,
	"morbo@google.com" <morbo@google.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Subject: Re: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <aSR1FU6uCqpOUFeb@smile.fi.intel.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
 <aRJASMinnNnUVc3Z@smile.fi.intel.com>
 <c2805e34c4054bfa3308af0d18712e412f024ed6.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2805e34c4054bfa3308af0d18712e412f024ed6.camel@ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 10, 2025 at 08:42:13PM +0000, Viacheslav Dubeyko wrote:
> On Mon, 2025-11-10 at 21:43 +0200, andriy.shevchenko@linux.intel.com wrote:
> > On Mon, Nov 10, 2025 at 07:37:13PM +0000, Viacheslav Dubeyko wrote:
> > > On Mon, 2025-11-10 at 15:44 +0100, Andy Shevchenko wrote:
> > > > In a few cases the code compares 32-bit value to a SIZE_MAX derived
> > > > constant which is much higher than that value on 64-bit platforms,
> > > > Clang, in particular, is not happy about this
> > > > 
> > > > fs/ceph/snap.c:377:10: error: result of comparison of constant 2305843009213693948 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
> > > >   377 |         if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> > > >       |             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > 
> > > > Fix this by casting to size_t. Note, that possible replacement of SIZE_MAX
> > > > by U32_MAX may lead to the behaviour changes on the corner cases.
> > 
> > ...
> > 
> > > > -	if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> > > > +	if ((size_t)num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> > > 
> > > The same question is here. Does it makes sense to declare num as size_t? Could
> > > it be more clean solution? Or could it introduce another warnings/errors?
> > 
> > Maybe. Or even maybe the U32_MAX is the way to go: Does anybody check those
> > corner cases? Are those never tested? Potential (security) bug?
> > 
> > ...
> > 
> > Whatever you find, in case if it will be not the proposed solution as is,
> > consider these patches as Reported-by.
> > 
> > And thanks for the reviews!
> 
> I think we can take the patch as it. It looks good. Probably, it makes sense to
> take a deeper look in the code on our side.
> 
> Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Thanks, can this be applied? My builds are still broken.

-- 
With Best Regards,
Andy Shevchenko



