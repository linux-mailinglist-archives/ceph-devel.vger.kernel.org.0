Return-Path: <ceph-devel+bounces-4105-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF22EC82233
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 19:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DAB73A56DA
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Nov 2025 18:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A5231A548;
	Mon, 24 Nov 2025 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XrvJUOjw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F6231A04F;
	Mon, 24 Nov 2025 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764009881; cv=none; b=MwBBIyCtYeWibeTYRRLsy4o+wCbfL8L5xeY2JbauSiRG36Q3B1XPQ7Mx8QA7xmgFKFPAMEZgtBsHN9GKKkDiTBBeUi/fynjXQdNYkFZWnhnsHpkSes6s9wGP+iKKgjlKA5syu45xN0lRGx68B5MkuOEYSXVivIWCxUhzF+/7L/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764009881; c=relaxed/simple;
	bh=A/sWiVhZOpOKye2R0LTDACdFSJeHy5VP/PEJhwxTG0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BrTUuBazzI+lSGQSU39vTix9rXCiZLaTJMA1XeZIwKUzvO/vi+g9E4IFALfYXjTU6YgfUkvI1tkQZGVV+RujE89bS1Z/I6qsy4RgYSPpNGmJo9F9jVIxPb8EZhH4HW2Ajzr+ywMf+S+QXVjD66sOXRKNifPbspkmM7/6ZVHW7LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XrvJUOjw; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764009879; x=1795545879;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A/sWiVhZOpOKye2R0LTDACdFSJeHy5VP/PEJhwxTG0Q=;
  b=XrvJUOjwmYxrhqLJ+A3t6NjdUadKmdNDurFH7UJLqvYHVgtQ24/v33HP
   lr60Gmeqb6EymUjgkLogGJPmdwObzJKApg56FpVQjsjBrO2BvT9FW/Rfp
   TR7MW5GMEVQIFP6WONdquFbWIydOTkafIBZMambMzA+4CtUuoj/mp1tKE
   qrzp6JXKUTYcg6cnEJ9Ey6GBGcZxGaT3bKJ80K8VVLGvIB/8mXETCPIsq
   LnnE0rAYbQap6kjwdjGtb/BQfgGMJbaVICJEtmTnKPw/LzhjSqzdvii7r
   az2rWo+skbwoyUDonHPhadq/Kok/RlSPBLRJwbCiorWjzLfgJmHdihRwm
   A==;
X-CSE-ConnectionGUID: YvCUX7dPSs6VGMIeA7DYgw==
X-CSE-MsgGUID: HNT+ZAwuSGaLFBCISDUb1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="88667371"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="88667371"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:44:39 -0800
X-CSE-ConnectionGUID: gClz3EOmR2KJPHfGCkhwEQ==
X-CSE-MsgGUID: 0iycFCyaS1eGs9rMAxe6Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192649209"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.244.5])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:44:37 -0800
Date: Mon, 24 Nov 2025 20:44:34 +0200
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
Subject: Re: [PATCH v1 1/1] libceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <aSSnkgFfOJxrKRvi@smile.fi.intel.com>
References: <20251110144653.375367-1-andriy.shevchenko@linux.intel.com>
 <8d1983c9d4c84a6c78b72ba23aa196e849b465a1.camel@ibm.com>
 <aRI-ohUyQLxIY1vu@smile.fi.intel.com>
 <d33fedf2943e0de53317ef19840b46aedb58186e.camel@ibm.com>
 <aSR1LFQnZgBgkN0t@smile.fi.intel.com>
 <d4a49f37f2ac64036f1bb254abcca6cef743074d.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4a49f37f2ac64036f1bb254abcca6cef743074d.camel@ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 24, 2025 at 05:45:55PM +0000, Viacheslav Dubeyko wrote:
> On Mon, 2025-11-24 at 17:09 +0200, andriy.shevchenko@linux.intel.com wrote:
> > On Mon, Nov 10, 2025 at 08:39:49PM +0000, Viacheslav Dubeyko wrote:

...

> > Thanks, can this be applied? My builds are still broken.
> 
> The patchset has been applied on testing branch already [1].

Thanks again, and same recommendation as per previous email.

> Ilya, when are we planning to send this patchset upstream?
> 
> [1] https://github.com/ceph/ceph-client.git

-- 
With Best Regards,
Andy Shevchenko



