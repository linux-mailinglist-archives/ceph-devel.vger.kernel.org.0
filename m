Return-Path: <ceph-devel+bounces-1657-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9ED94F19A
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 17:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE20C1F2325F
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 15:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC3B184538;
	Mon, 12 Aug 2024 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAx0TMae"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5390C130AC8;
	Mon, 12 Aug 2024 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723476388; cv=none; b=DXfRu8BrfWThBSNPMd20B338gUGcVFJ7eGSszcQIpIa7QAXCD2rX8VqTq0wVh/B99s3+kfPvOAvCD3lYUsEEINcfbSpk2PRM2Ggoq4pmMu6GCC6NZEG1faLEJKzd4VH/CnNYWJI5N75bXu/bVPXe9Bp1CdmXz+O4Ix5IqPJdtDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723476388; c=relaxed/simple;
	bh=/5Q7hIRwnumtY9BP1FRcNsUSu1rhP1Gnj/W74MxICEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pWOHMpf6+nV8U95YbLQ6j10gl36h/Mb0hPf1qtSpOorEg7IukSDdnki8+6Py8i7TSd5I6LvgTu7+zRD3pzPPsYGG0/p6Aekh5mx9bCEscFjAldiZyN2z7aeTeC3DTzteqTNwc1UCVufWRhVG6v4Ya1xWl0UlGOD1i8ysxAqJSic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAx0TMae; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723476386; x=1755012386;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/5Q7hIRwnumtY9BP1FRcNsUSu1rhP1Gnj/W74MxICEE=;
  b=NAx0TMaeBaWPstmGEUwcuEZN1/j5szdwPMePfeljGHDmb38St7b5iU6L
   sntkCsVJVMKxRfGg0cXrUHlw1X1IW6S+CNdjR3t4PvKpAP2iiytnpPckI
   I42Je4pKEOTNGJkHo8Osi6UmnVt7nQIE5Vdz30ol6mWXPZrlmiHUmB19B
   47I9d+ZjPehhVT5gIXwRjIsVij7crwG+eH4WGRPDh+esqwMad+ggZkeS3
   AKNLL0WZT+0GotQX4gzAnCF8OldYVe6JEGM+5WKwDhMfiMI9Sc1upy/o7
   gz+5IjIcEe3RjWcGfyyXB8tqskczghkT7TAPRhbV7JXc5B6hVYdxEg56c
   w==;
X-CSE-ConnectionGUID: 3NeN6YIQQmeEfvVJQs0SNw==
X-CSE-MsgGUID: xcWlyVv+RFCNhbSnSv/6MQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21759964"
X-IronPort-AV: E=Sophos;i="6.09,283,1716274800"; 
   d="scan'208";a="21759964"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 08:26:26 -0700
X-CSE-ConnectionGUID: aUrhFayOTZmCwUGFN8xRDw==
X-CSE-MsgGUID: lETieQJJSFmuVa2DeduxzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,283,1716274800"; 
   d="scan'208";a="58250576"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 12 Aug 2024 08:26:23 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sdWw8-000Bw5-1S;
	Mon, 12 Aug 2024 15:26:20 +0000
Date: Mon, 12 Aug 2024 23:26:15 +0800
From: kernel test robot <lkp@intel.com>
To: Abhinav Jain <jain.abhinav177@gmail.com>, idryomov@gmail.com,
	xiubli@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	skhan@linuxfoundation.org, javier.carrasco.cruz@gmail.com,
	Abhinav Jain <jain.abhinav177@gmail.com>
Subject: Re: [PATCH net v2] libceph: Make the arguments const as per the TODO
Message-ID: <202408121938.QL7KtnzW-lkp@intel.com>
References: <20240811205509.1089027-1-jain.abhinav177@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240811205509.1089027-1-jain.abhinav177@gmail.com>

Hi Abhinav,

kernel test robot noticed the following build errors:

[auto build test ERROR on net/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Abhinav-Jain/libceph-Make-the-arguments-const-as-per-the-TODO/20240812-045647
base:   net/main
patch link:    https://lore.kernel.org/r/20240811205509.1089027-1-jain.abhinav177%40gmail.com
patch subject: [PATCH net v2] libceph: Make the arguments const as per the TODO
config: i386-buildonly-randconfig-002-20240812 (https://download.01.org/0day-ci/archive/20240812/202408121938.QL7KtnzW-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240812/202408121938.QL7KtnzW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408121938.QL7KtnzW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/ceph/crypto.c:93:19: error: passing 'const void **' to parameter of type 'void **' discards qualifiers in nested pointer types [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      93 |         ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
         |                          ^
   include/linux/ceph/decode.h:59:29: note: expanded from macro 'ceph_decode_need'
      59 |                 if (!likely(ceph_has_room(p, end, n)))          \
         |                                           ^
   include/linux/compiler.h:76:40: note: expanded from macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   include/linux/ceph/decode.h:52:41: note: passing argument to parameter 'p' here
      52 | static inline bool ceph_has_room(void **p, void *end, size_t n)
         |                                         ^
>> net/ceph/crypto.c:93:22: error: passing 'const void *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      93 |         ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
         |                             ^~~
   include/linux/ceph/decode.h:59:32: note: expanded from macro 'ceph_decode_need'
      59 |                 if (!likely(ceph_has_room(p, end, n)))          \
         |                                              ^~~
   include/linux/compiler.h:76:40: note: expanded from macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   include/linux/ceph/decode.h:52:50: note: passing argument to parameter 'end' here
      52 | static inline bool ceph_has_room(void **p, void *end, size_t n)
         |                                                  ^
   net/ceph/crypto.c:94:29: error: passing 'const void **' to parameter of type 'void **' discards qualifiers in nested pointer types [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      94 |         key->type = ceph_decode_16(p);
         |                                    ^
   include/linux/ceph/decode.h:31:41: note: passing argument to parameter 'p' here
      31 | static inline u16 ceph_decode_16(void **p)
         |                                         ^
   net/ceph/crypto.c:95:19: error: passing 'const void **' to parameter of type 'void **' discards qualifiers in nested pointer types [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      95 |         ceph_decode_copy(p, &key->created, sizeof(key->created));
         |                          ^
   include/linux/ceph/decode.h:43:44: note: passing argument to parameter 'p' here
      43 | static inline void ceph_decode_copy(void **p, void *pv, size_t n)
         |                                            ^
   net/ceph/crypto.c:96:28: error: passing 'const void **' to parameter of type 'void **' discards qualifiers in nested pointer types [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      96 |         key->len = ceph_decode_16(p);
         |                                   ^
   include/linux/ceph/decode.h:31:41: note: passing argument to parameter 'p' here
      31 | static inline u16 ceph_decode_16(void **p)
         |                                         ^
   net/ceph/crypto.c:97:19: error: passing 'const void **' to parameter of type 'void **' discards qualifiers in nested pointer types [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      97 |         ceph_decode_need(p, end, key->len, bad);
         |                          ^
   include/linux/ceph/decode.h:59:29: note: expanded from macro 'ceph_decode_need'
      59 |                 if (!likely(ceph_has_room(p, end, n)))          \
         |                                           ^
   include/linux/compiler.h:76:40: note: expanded from macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   include/linux/ceph/decode.h:52:41: note: passing argument to parameter 'p' here
      52 | static inline bool ceph_has_room(void **p, void *end, size_t n)
         |                                         ^
   net/ceph/crypto.c:97:22: error: passing 'const void *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      97 |         ceph_decode_need(p, end, key->len, bad);
         |                             ^~~
   include/linux/ceph/decode.h:59:32: note: expanded from macro 'ceph_decode_need'
      59 |                 if (!likely(ceph_has_room(p, end, n)))          \
         |                                              ^~~
   include/linux/compiler.h:76:40: note: expanded from macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   include/linux/ceph/decode.h:52:50: note: passing argument to parameter 'end' here
      52 | static inline bool ceph_has_room(void **p, void *end, size_t n)
         |                                                  ^
   net/ceph/crypto.c:98:24: error: passing 'const void *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      98 |         ret = set_secret(key, *p);
         |                               ^~
   net/ceph/crypto.c:23:58: note: passing argument to parameter 'buf' here
      23 | static int set_secret(struct ceph_crypto_key *key, void *buf)
         |                                                          ^
   net/ceph/crypto.c:99:19: error: passing 'const void *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      99 |         memzero_explicit(*p, key->len);
         |                          ^~
   include/linux/string.h:356:43: note: passing argument to parameter 's' here
     356 | static inline void memzero_explicit(void *s, size_t count)
         |                                           ^
   9 errors generated.


vim +93 net/ceph/crypto.c

8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02   88  
19c7b44529ef1b net/ceph/crypto.c Abhinav Jain 2024-08-12   89  int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02   90  {
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02   91  	int ret;
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02   92  
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  @93  	ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02   94  	key->type = ceph_decode_16(p);
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02   95  	ceph_decode_copy(p, &key->created, sizeof(key->created));
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02   96  	key->len = ceph_decode_16(p);
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02   97  	ceph_decode_need(p, end, key->len, bad);
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02   98  	ret = set_secret(key, *p);
10f42b3e648377 net/ceph/crypto.c Ilya Dryomov 2020-12-22   99  	memzero_explicit(*p, key->len);
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  100  	*p += key->len;
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  101  	return ret;
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  102  
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  103  bad:
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  104  	dout("failed to decode crypto key\n");
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  105  	return -EINVAL;
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  106  }
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  107  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

