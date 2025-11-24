Return-Path: <ceph-devel+bounces-4104-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E71C8222D
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 19:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5EA633497F3
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 18:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEFF31A54E;
	Mon, 24 Nov 2025 18:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cOOda/kb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B31D31A545;
	Mon, 24 Nov 2025 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764009825; cv=none; b=V0C1js0mN3a/iJ2O6lYOp0a6wna1s5BEN8a+y/tdfF4d7R9gOzqDL1pHzz6+KqcokUHT82XmLhRIiynXfRYM7z55iFkpwz0g8Kn3KLcfRtQhlSkgWrjk4SUSM0buFPCpwRafXygKj1mtoFrXUnVFD5JQW9Jej0DeJP+H7c3cq+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764009825; c=relaxed/simple;
	bh=LXtoF+aRO9OG8tgJk/Vy4h6gs94oaYjsrQDAgVwnba0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjTAnmJXBTgpJbV2wPvVB7ZaoYvUE/gC914dZXdABJ19KaB3rLaZeo5aALO/C9h6vX77FZRYKzb8Sfh3BNiPQKSjFwDtB5r2U7xOhcfGnYmXbuow1E2zD4JCXTX1bhC92XqNCuCZD89Gu4rOaB1y51/DPn8opN84gkOUT9V0M9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cOOda/kb; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764009822; x=1795545822;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LXtoF+aRO9OG8tgJk/Vy4h6gs94oaYjsrQDAgVwnba0=;
  b=cOOda/kbMrndDh+clF77950RC+9NByWmu9XoI1kVRyMyNqcm7xgm+hOg
   ZspZNbVoECJq0PklpBizOTymt89p2PNYTCezbIkgR5rTdR0QTfzdy4PtL
   gEAhnQgvyCVYxw7JaeDekVCAEuxZOx2ipXdXcxE8QIrZWG42ldT7bcYWe
   7I8yNQvvW1O9pvv4qTD3it8qBAyQX6knqBVIVyiWtkrZ7lE8qrGAj2RHd
   yP3PBMdkPcqCRV2lwcxW1Xp9k5xDLFtsEMvDdQxk5WDay0eerZHmxRajw
   31htFY4wLa+IHFKEWavxT1l0cko2pfxqZ5KMKvK+a9iuW6stb4saA6kmy
   w==;
X-CSE-ConnectionGUID: q1Ks/Ot7TMa5k5BqG6SDAw==
X-CSE-MsgGUID: aY+55gRLRaiCttA5fGwPFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="88667319"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="88667319"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:43:41 -0800
X-CSE-ConnectionGUID: 97zqQHQuSiOpoCmV509mHA==
X-CSE-MsgGUID: FrpfCr9oTw2Kmy1suvDsZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192648941"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.244.5])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:43:39 -0800
Date: Mon, 24 Nov 2025 20:43:37 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "idryomov@gmail.com" <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
	"justinstitt@google.com" <justinstitt@google.com>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"morbo@google.com" <morbo@google.com>,
	"nathan@kernel.org" <nathan@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Subject: Re: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <aSSnWaDHK5Yyq_Ae@smile.fi.intel.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
 <aRJASMinnNnUVc3Z@smile.fi.intel.com>
 <c2805e34c4054bfa3308af0d18712e412f024ed6.camel@ibm.com>
 <aSR1FU6uCqpOUFeb@smile.fi.intel.com>
 <82c49caff875cc131951a7e5d59ecb45efbb9224.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82c49caff875cc131951a7e5d59ecb45efbb9224.camel@ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 24, 2025 at 05:47:04PM +0000, Viacheslav Dubeyko wrote:
> On Mon, 2025-11-24 at 17:09 +0200, andriy.shevchenko@linux.intel.com wrote:
> > On Mon, Nov 10, 2025 at 08:42:13PM +0000, Viacheslav Dubeyko wrote:
> > > On Mon, 2025-11-10 at 21:43 +0200, andriy.shevchenko@linux.intel.com wrote:

...

> > > I think we can take the patch as it. It looks good. Probably, it makes sense to
> > > take a deeper look in the code on our side.
> > > 
> > > Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > 
> > Thanks, can this be applied? My builds are still broken.
> 
> The patchset has been applied on testing branch already [1].

Thanks for the information. The Linux Next still has no that branch in.
I recommend to write Stephen a message to include your testing branch or
something like that into Linux Next, so it will get more test coverage.

> Ilya, when are we planning to send this patchset upstream?

> [1] https://github.com/ceph/ceph-client.git

-- 
With Best Regards,
Andy Shevchenko



