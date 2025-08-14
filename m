Return-Path: <ceph-devel+bounces-3454-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5BC7B26FB5
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Aug 2025 21:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E42E1CC701C
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Aug 2025 19:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F172222CA;
	Thu, 14 Aug 2025 19:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQ8ZtUyL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449E61C84B2
	for <ceph-devel@vger.kernel.org>; Thu, 14 Aug 2025 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755199943; cv=none; b=oHslv5zcbxjMaNAz1ccskNrjduGcFEQW94OQz5uRYZQ3BLMP05rFDXcacfW36Bd553ZGnMMo3EHzoSdIZBvmT1Fa/5Bt/yaymGfBV7mVJhlkiJkwFy7fwSgHQIva2P5/8CazmXb/of59EbRHJjTBjNQuXOmoUH5T8mf2hYOZqgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755199943; c=relaxed/simple;
	bh=4g1Kzv+qcaRABcpccRnABJeryu1o3YSf777DqZOXLrk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iK6OyAkVy70FCnSFt84rWgdJwjND6dWG2iYgTRf5RPJTb8iaLgRd7Bzkf+h4KbFNDPIIqoEb22bzrYWYI4/riEuqGTWLLPTg7gvpPJSQk4aGwZ514FAfr2l/v7tnwWe6V+IwoQmo19jRraOJWJZVNAQJ6zioPqPVTxfU1dUj5aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lQ8ZtUyL; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755199941; x=1786735941;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4g1Kzv+qcaRABcpccRnABJeryu1o3YSf777DqZOXLrk=;
  b=lQ8ZtUyLJe8+HVHgglWQqG669bunZQ9HDELi3mUtfjy9MaFw1o6YiY43
   Abhj6OzME3PzKdSe1EeI/4Zp92kjGbsLzMje/MREqh7d8oR7vlmIgZGJ9
   xUVCbdYhsBUmORe3300/7eHpU7EgjtEIy9ZcHEgtj3h6k1Qu5lTA1pgfE
   HrW9skJJKnRs7RWaeLIn44mgdyrsLZT3hLggG334yGGx8/8vn9UNa2W82
   qxZutim3iNsPrAOsuDnfypk+iMsA0VHEqUjryMFADPOfuKocyHFncY9q4
   cmX346ZAf72Yk6i0Uj3JOuB4em6J4Soo0oTXhN8K15iGSv/FH9WxD3ED/
   w==;
X-CSE-ConnectionGUID: wK0eEU3PTCy4v3H0Yq/BQg==
X-CSE-MsgGUID: jl0mWXKhRHmF6hTzCy2BrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="68226978"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="68226978"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 12:32:21 -0700
X-CSE-ConnectionGUID: 2KzvbGrgRGCHjMVLqHiVYg==
X-CSE-MsgGUID: UT5PAdj0Q5uVv3/XmOJaJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166807008"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 14 Aug 2025 12:32:19 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umdgP-000BGv-0C;
	Thu, 14 Aug 2025 19:32:17 +0000
Date: Fri, 15 Aug 2025 03:31:54 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls-tracing-only 7/10]
 include/linux/blog/blog_ser.h:115:16: error: static assertion failed due to
 requirement 'sizeof (null_str.str) == sizeof(unsigned long)': null_str.str
 size must match unsigned long for proper alignment
Message-ID: <202508150308.8w4wxpk9-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls-tracing-only
head:   6b738aa5f6bb2343f8277d318ff1e9ea9289212c
commit: 4dbfb9232bb3bff162418ee08fe5379af0bcab48 [7/10] phase I
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20250815/202508150308.8w4wxpk9-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250815/202508150308.8w4wxpk9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508150308.8w4wxpk9-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from lib/blog/blog_core.c:13:
   In file included from include/linux/blog/blog.h:17:
>> include/linux/blog/blog_ser.h:115:16: error: static assertion failed due to requirement 'sizeof (null_str.str) == sizeof(unsigned long)': null_str.str size must match unsigned long for proper alignment
     115 |         static_assert(sizeof(null_str.str) == sizeof(unsigned long),
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                                  ^~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/blog/blog_ser.h:115:37: note: expression evaluates to '8 == 4'
     115 |         static_assert(sizeof(null_str.str) == sizeof(unsigned long),
         |                       ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                                  ^~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   1 error generated.


vim +115 include/linux/blog/blog_ser.h

   111	
   112	static inline size_t write_null_str(char *dst)
   113	{
   114		*(union null_str_u *)dst = null_str;
 > 115		static_assert(sizeof(null_str.str) == sizeof(unsigned long),
   116		             "null_str.str size must match unsigned long for proper alignment");
   117		return __builtin_strlen(null_str.str);
   118	}
   119	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

