Return-Path: <ceph-devel+bounces-4107-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5F3C8235E
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 20:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D77993AE8F7
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 19:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAD02D239A;
	Mon, 24 Nov 2025 18:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PICKOpzx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFC231A7FE;
	Mon, 24 Nov 2025 18:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010712; cv=none; b=B1uyOXtdq6SZqgf6tQA1plQNmPaTkdAgBt5KwF23UA5tVEOGwHRP1iPOKvhjspAqCWiwkrcymG4q32PYFpnnUJd0PQ4i1vUVWm+NNVtxyz3dp9SB8ylTkLFMxDFIbZ1a5UAZAQRvJ9nyel8O43BLXES7DMqV3oMzvh7RmQ1pliY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010712; c=relaxed/simple;
	bh=zFdNVV0jn5E5G65Xthdrt9zFFxdKKVR50LKSwwLzc9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n22nkvH6k8V0x8dKIV9ITnIaVgdw+Q3w+Rk3kQ7725fIhf/9f5Kw93ZpKZ/5nTxc2R3dZoRAdAS9INM5QlZjcWIxF4S21WGyU6cxsJC+K7Qo0YCDgaNl4yspSoKZVwlJZ8h3vbkonlvYKKnJF8kAd5Je9mzvBY7iQoMxHiZbJw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PICKOpzx; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010710; x=1795546710;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zFdNVV0jn5E5G65Xthdrt9zFFxdKKVR50LKSwwLzc9w=;
  b=PICKOpzxezk3jGb/xHGASOAJ19Z0SmZhXOepWrrqa9auhRBaOFIb1VUy
   HsMgZ/H0JplXMHTH+9PZ6cxpmPf6PjBo3Ftljj/7sb7g+KggS8KpTr52S
   EAwJZXV1tZRY98BnNcFK2384DWdHXUrGBExB4lAfJAdZTWThdsl/8aPAu
   pJhBxsjrKlEVbTLfBOTds0G5eaUcVc55EsyiT/KoeWbFv7ZzpheBwzXGj
   tFJmQ1JUxlxb7pW09UF73P+1ss6uiVjs2O8UZKCFVjA42BHGfoZgPaqnY
   pGtgdLjbi/RStNO0CB0es65DBZzNHFbFAzFTmOzxCqXOI8CkPtMtc5nZw
   Q==;
X-CSE-ConnectionGUID: nIWoIXvSQluhVlGNciMIqA==
X-CSE-MsgGUID: A/a3hm6yTEumimgZwCUI7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="69882214"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="69882214"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:58:29 -0800
X-CSE-ConnectionGUID: UYK5U28QTR2lQkyXiGmwTw==
X-CSE-MsgGUID: 9F/x9o02SVysBTh6YrcJ1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="196856728"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.244.5])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:58:27 -0800
Date: Mon, 24 Nov 2025 20:58:24 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>,
	"justinstitt@google.com" <justinstitt@google.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"morbo@google.com" <morbo@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nathan@kernel.org" <nathan@kernel.org>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Subject: Re: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <aSSq0K-YqjthuJAg@smile.fi.intel.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com>
 <aRJASMinnNnUVc3Z@smile.fi.intel.com>
 <c2805e34c4054bfa3308af0d18712e412f024ed6.camel@ibm.com>
 <aSR1FU6uCqpOUFeb@smile.fi.intel.com>
 <82c49caff875cc131951a7e5d59ecb45efbb9224.camel@ibm.com>
 <aSSnWaDHK5Yyq_Ae@smile.fi.intel.com>
 <1ab8c386d50d024d0deb8a8c2fee501aae30909b.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ab8c386d50d024d0deb8a8c2fee501aae30909b.camel@ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 24, 2025 at 06:49:26PM +0000, Viacheslav Dubeyko wrote:
> On Mon, 2025-11-24 at 20:43 +0200, andriy.shevchenko@linux.intel.com wrote:
> > On Mon, Nov 24, 2025 at 05:47:04PM +0000, Viacheslav Dubeyko wrote:
> > > On Mon, 2025-11-24 at 17:09 +0200, andriy.shevchenko@linux.intel.com wrote:
> > > > On Mon, Nov 10, 2025 at 08:42:13PM +0000, Viacheslav Dubeyko wrote:
> > > > > On Mon, 2025-11-10 at 21:43 +0200, andriy.shevchenko@linux.intel.com wrote:

...

> > > > > I think we can take the patch as it. It looks good. Probably, it makes sense to
> > > > > take a deeper look in the code on our side.
> > > > > 
> > > > > Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > > > 
> > > > Thanks, can this be applied? My builds are still broken.
> > > 
> > > The patchset has been applied on testing branch already [1].
> > 
> > Thanks for the information. The Linux Next still has no that branch in.
> > I recommend to write Stephen a message to include your testing branch or
> > something like that into Linux Next, so it will get more test coverage.
> 
> It's not my personal branch. :) It's the branch that receives all new patches
> for CephFS kernel client and, usually, it is used for internal testing by Ceph
> team.

Exactly, that's why my proposal. I would not recommend to do the same for
a (semi-)private branches.

> Ilya gathers all patches from there and sends it upstream. So, we need to
> ping Ilya. :)

> > > Ilya, when are we planning to send this patchset upstream?
> > 
> > > [1] https://github.com/ceph/ceph-client.git  

-- 
With Best Regards,
Andy Shevchenko



