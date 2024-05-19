Return-Path: <ceph-devel+bounces-1149-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2EF8C948C
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 13:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 418E61F21799
	for <lists+ceph-devel@lfdr.de>; Sun, 19 May 2024 11:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA56D45BE4;
	Sun, 19 May 2024 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iYZPusQj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C1B8BEA;
	Sun, 19 May 2024 11:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716119781; cv=none; b=TtRKQxrEE9HloCA1RRrcen9fZ4RPAjTKj95VWTdB2CtuAP8aX5QBgN+rONamvblDtPq1lTtloOX0LB4rYAPAKSdFUhmtgI97vUAoHm19+WW7jCg2Q1j4gyWOl8aBNxt7beJyUqoYG3d2Xl239V3XAwPbOvww5RNfP3zBe67CmnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716119781; c=relaxed/simple;
	bh=cvI1px9O6st8lE8BzPkgS3iM0oL4c8mM9MP987YJZDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3jUB7Q/0KRQr2tNTJtibNqoUbfvvr+H2zuVX1vFw9cPILUfLiKbyWkBAQgvA8jUVRbxqMwJlJBhsRIJfcD9A10QgJpHP/3uDNKsPMmSbJ6Yd9ipOU4oSZCcIyRSAiCps7Kt5o0jRfA3RbcLwodBxHV0hclJbxE36DVZ7AhKZ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iYZPusQj; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716119779; x=1747655779;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cvI1px9O6st8lE8BzPkgS3iM0oL4c8mM9MP987YJZDU=;
  b=iYZPusQjHX/Bn97EIb5+DlQ9yBPDbl083kjVfnU8XKrUPw0b3HgtiUny
   B0OkrgEniDhaZ2+jCEGsBJZCkrEsJkPAjH4i82jppqeCITnz1Q+7G9x1d
   dh7nQrsDKAAzWlj7Nd3+WYSL2HTqHJ7JGAYTSQvHijoIGZ+dpH/FItiLf
   dBS3Owcju1Wc+bpQc7uxb/DHohUT/XLG8aW5Nm3L8lgUA8imsvm2OWf2B
   11mKemxBLcJ0BXmKFfG+kIwH6TLSAFJJtknW3O767lEWHKHXSpfB0c/Bz
   w/+DZ9VB7Gz/3vb/lZZQbEvh3MAM0gs9m4tt9TS5JMf2IyB0Iua2en3uR
   A==;
X-CSE-ConnectionGUID: BphWRI4rSpS3Yj/3x6nR1g==
X-CSE-MsgGUID: M+bojiynReq1eJ8UwYZrfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11076"; a="22828833"
X-IronPort-AV: E=Sophos;i="6.08,173,1712646000"; 
   d="scan'208";a="22828833"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2024 04:56:19 -0700
X-CSE-ConnectionGUID: sr0koyjmRuCZYaFNK954jg==
X-CSE-MsgGUID: UWeqezrhSamDUYPoGjS+AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,173,1712646000"; 
   d="scan'208";a="37079835"
Received: from unknown (HELO 108735ec233b) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 19 May 2024 04:56:15 -0700
Received: from kbuild by 108735ec233b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s8f9B-0003bu-1L;
	Sun, 19 May 2024 11:56:13 +0000
Date: Sun, 19 May 2024 19:55:48 +0800
From: kernel test robot <lkp@intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/2 net-next] libceph: Use sruct_size() in
 ceph_create_snap_context()
Message-ID: <202405191916.QmDasdJ5-lkp@intel.com>
References: <5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet@wanadoo.fr>

Hi Christophe,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Christophe-JAILLET/libceph-Use-__counted_by-in-struct-ceph_snap_context/20240519-172142
base:   net-next/main
patch link:    https://lore.kernel.org/r/5b7c72bdb52703bbfa5511ed500aed4babde1308.1716109606.git.christophe.jaillet%40wanadoo.fr
patch subject: [PATCH 1/2 net-next] libceph: Use sruct_size() in ceph_create_snap_context()
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20240519/202405191916.QmDasdJ5-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240519/202405191916.QmDasdJ5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405191916.QmDasdJ5-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/ceph/snapshot.c:32:18: error: call to undeclared function 'sruct_size'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      32 |         snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
         |                         ^
>> net/ceph/snapshot.c:32:36: error: use of undeclared identifier 'snaps'; did you mean 'snapc'?
      32 |         snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
         |                                           ^~~~~
         |                                           snapc
   net/ceph/snapshot.c:30:28: note: 'snapc' declared here
      30 |         struct ceph_snap_context *snapc;
         |                                   ^
   2 errors generated.


vim +/sruct_size +32 net/ceph/snapshot.c

    11	
    12	/*
    13	 * Ceph snapshot contexts are reference counted objects, and the
    14	 * returned structure holds a single reference.  Acquire additional
    15	 * references with ceph_get_snap_context(), and release them with
    16	 * ceph_put_snap_context().  When the reference count reaches zero
    17	 * the entire structure is freed.
    18	 */
    19	
    20	/*
    21	 * Create a new ceph snapshot context large enough to hold the
    22	 * indicated number of snapshot ids (which can be 0).  Caller has
    23	 * to fill in snapc->seq and snapc->snaps[0..snap_count-1].
    24	 *
    25	 * Returns a null pointer if an error occurs.
    26	 */
    27	struct ceph_snap_context *ceph_create_snap_context(u32 snap_count,
    28							gfp_t gfp_flags)
    29	{
    30		struct ceph_snap_context *snapc;
    31	
  > 32		snapc = kzalloc(sruct_size(snapc, snaps, snap_count), gfp_flags);
    33		if (!snapc)
    34			return NULL;
    35	
    36		refcount_set(&snapc->nref, 1);
    37		snapc->num_snaps = snap_count;
    38	
    39		return snapc;
    40	}
    41	EXPORT_SYMBOL(ceph_create_snap_context);
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

