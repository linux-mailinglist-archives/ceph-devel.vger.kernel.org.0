Return-Path: <ceph-devel+bounces-1651-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C8B794E3E3
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 01:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86D05B20EDB
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Aug 2024 23:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34993165F12;
	Sun, 11 Aug 2024 23:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JIWZjKAn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79783D969;
	Sun, 11 Aug 2024 23:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723419763; cv=none; b=M9B109uhB8kvNg5K3h3z5GsHomaQAW+awkfu+mGhO3d0rrV9GC+6lhEdY8mebRSWXXlLoKZAVM0uk3gvB6B4CZyOgTzLTB0X0A/ukKnX0ui5iCeMsBlrWAPxW3wM/fgg97E24c9pIyOS0qtN7h2dVTZZEEFFdf0MDSQw7F4xC+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723419763; c=relaxed/simple;
	bh=bOzVc66EOtribw7hYUCqgq+ialPqt+EWyQe7S+D2QEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VKzHNJ8Yy3ZDQJQcbqjozDP0GUmtWoWK5plKTn/SU56kBjsabIe2AGYLAyS2HbwdEtGTes3OXuSmoL16KLIDWYt7ysVF3jvelChh5M1jGZMym532delKx6QAodyR5dnuKWW+hvRDtAZG7eLSKbx+kGSrAevjI/BorKInPCsDFWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JIWZjKAn; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723419762; x=1754955762;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bOzVc66EOtribw7hYUCqgq+ialPqt+EWyQe7S+D2QEM=;
  b=JIWZjKAnElgv+WQFCmyMHiiAiNfPWFgRxd+8LKjh53i1n+B9H57xXMFl
   X6VdVxa/F2MSKemzoy0fWcqE+DYl8Og45lu1KMNn5zfnXEynD/on4CLZm
   9JpzO2xN78bZS//hPj228uqXJ9yBzvU/g+q9Oz0LPGTiZ74kMi3oNxQve
   iT9Y76SLQHG3f8XPTD8Ui9oa7JuwkMW7V5p+9PaUg29F8kAK50ywhFZuO
   telfcRmSCES0raAwr9CmSh/Nwv+I/DQWgJtNycJdQBITQNXw9b2BAKViH
   vIk/d08PDFOFoSOrvUZM6k5JoKv76iGF1CvaML1cb7fPaUk/tMSQ8J970
   w==;
X-CSE-ConnectionGUID: nVas3Pn8Qn2tgNjGOfYcMw==
X-CSE-MsgGUID: VHIpHL+QTduQRd26h83PdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="46917020"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="46917020"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2024 16:42:41 -0700
X-CSE-ConnectionGUID: OQizJ+//SK6T5FdwL88LyQ==
X-CSE-MsgGUID: ffABVu1dSjiwg1Ihcm5OaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="58335888"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 11 Aug 2024 16:42:37 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sdICk-000BEB-0h;
	Sun, 11 Aug 2024 23:42:31 +0000
Date: Mon, 12 Aug 2024 07:42:00 +0800
From: kernel test robot <lkp@intel.com>
To: Abhinav Jain <jain.abhinav177@gmail.com>, idryomov@gmail.com,
	xiubli@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	skhan@linuxfoundation.org, javier.carrasco.cruz@gmail.com,
	Abhinav Jain <jain.abhinav177@gmail.com>
Subject: Re: [PATCH net] libceph: Make the input const as per the TODO
Message-ID: <202408120724.pyUdMxWP-lkp@intel.com>
References: <20240811193645.1082042-1-jain.abhinav177@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240811193645.1082042-1-jain.abhinav177@gmail.com>

Hi Abhinav,

kernel test robot noticed the following build errors:

[auto build test ERROR on net/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Abhinav-Jain/libceph-Make-the-input-const-as-per-the-TODO/20240812-033900
base:   net/main
patch link:    https://lore.kernel.org/r/20240811193645.1082042-1-jain.abhinav177%40gmail.com
patch subject: [PATCH net] libceph: Make the input const as per the TODO
config: i386-buildonly-randconfig-002-20240812 (https://download.01.org/0day-ci/archive/20240812/202408120724.pyUdMxWP-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240812/202408120724.pyUdMxWP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408120724.pyUdMxWP-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/ceph/crypto.c:89:5: error: conflicting types for 'ceph_crypto_key_decode'
      89 | int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
         |     ^
   net/ceph/crypto.h:25:5: note: previous declaration is here
      25 | int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end);
         |     ^
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
   net/ceph/crypto.c:315:37: error: passing 'const void **' to parameter of type 'void **' discards qualifiers in nested pointer types [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
     315 |         ret = ceph_crypto_key_decode(ckey, &p, (const char *)prep->data + datalen);
         |                                            ^~
   net/ceph/crypto.h:25:64: note: passing argument to parameter 'p' here
      25 | int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end);
         |                                                                ^
>> net/ceph/crypto.c:315:41: error: passing 'const char *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
     315 |         ret = ceph_crypto_key_decode(ckey, &p, (const char *)prep->data + datalen);
         |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/ceph/crypto.h:25:73: note: passing argument to parameter 'end' here
      25 | int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end);
         |                                                                         ^
   12 errors generated.


vim +/ceph_crypto_key_decode +89 net/ceph/crypto.c

    88	
  > 89	int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
    90	{
    91		int ret;
    92	
  > 93		ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
    94		key->type = ceph_decode_16(p);
    95		ceph_decode_copy(p, &key->created, sizeof(key->created));
    96		key->len = ceph_decode_16(p);
    97		ceph_decode_need(p, end, key->len, bad);
    98		ret = set_secret(key, *p);
    99		memzero_explicit(*p, key->len);
   100		*p += key->len;
   101		return ret;
   102	
   103	bad:
   104		dout("failed to decode crypto key\n");
   105		return -EINVAL;
   106	}
   107	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

