Return-Path: <ceph-devel+bounces-1654-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F8B94E779
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 09:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4EF31F2298C
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 07:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D001607B8;
	Mon, 12 Aug 2024 07:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ku3Fu/yG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9690B1509BF;
	Mon, 12 Aug 2024 07:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723446614; cv=none; b=qr8ZkVSWePXv4LCmIP0XAsJKuCEUGB1VC30pzdKuFi9gB+gZYrwa0z87CSkODviuQ2VZIJvkJWb3toetG5lSVRe9G+8IeJ2dhV24cxEKN4fqemgJdUuRilBm5Yaoy237fDF+4Nd+BPGwF7u7kBgvnyGxbYQEljgvVlN84ji6iCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723446614; c=relaxed/simple;
	bh=UZFRD8D4N0lHM4LeVB279uikQiM2J27PBBWBYhoHXUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QuIKU6u3CDCRqnw/l8mpRZ6/hdEzU3RvxgaqTuuFHUdUgUkdy/7xrJYOtSFG3ikKemFgguQI99ZAJQUMrzX6Met7yBCUpFsb5L1t7M2ip6HB/7NQvATvCkCd0R9PieQThIW+sL1+6zB/6nhpWjfkz+9wXch8kkv+Id4e3hOa7jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ku3Fu/yG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723446611; x=1754982611;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UZFRD8D4N0lHM4LeVB279uikQiM2J27PBBWBYhoHXUc=;
  b=ku3Fu/yGNhhzYT3AMRrFzkiLL0RzsYdzcMgqNT6BpLrT+CV6a6Ld0o54
   hjvNxlWvAjA2n+bl284JI4SK06lUb/AsbPLP+MnmkfrgvQJO1bZXRGrS+
   8ogncLocxxk+Y8ymNnsVw1OWHrUAYcbVwz826vYMAuo1314mjsVA1ubRQ
   zOoj4UilmJrMcrbo8BX0okSYgqX/YGDe6Q01msZnFKB+X4Og/RlrrPyLh
   Lg9mRtvkItedsncNVFAfymERdBlv5HaK9RIegFU5sMawtcsvyGxIoKrid
   kTlhmh0lcj+aEL99Ke00Y3iK6xCml2HzVQzHbICzOGTacvOW/2OrA/vTX
   g==;
X-CSE-ConnectionGUID: wioEYvoGSvW8PIxo4rZoQQ==
X-CSE-MsgGUID: FHFwFtvdRm6fpJgTxNv2xQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="21710564"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="21710564"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 00:10:10 -0700
X-CSE-ConnectionGUID: y4ayYwMtQXmgDvxULXYVTw==
X-CSE-MsgGUID: DdOnmdFyQ++ma4hzvd5N7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="57822857"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 12 Aug 2024 00:10:07 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sdPBt-000BTk-1d;
	Mon, 12 Aug 2024 07:10:05 +0000
Date: Mon, 12 Aug 2024 15:09:42 +0800
From: kernel test robot <lkp@intel.com>
To: Abhinav Jain <jain.abhinav177@gmail.com>, idryomov@gmail.com,
	xiubli@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	Abhinav Jain <jain.abhinav177@gmail.com>
Subject: Re: [PATCH net v2] libceph: Make the arguments const as per the TODO
Message-ID: <202408121452.qS7GNcws-lkp@intel.com>
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
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20240812/202408121452.qS7GNcws-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240812/202408121452.qS7GNcws-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408121452.qS7GNcws-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/array_size.h:5,
                    from include/linux/string.h:6,
                    from include/linux/ceph/ceph_debug.h:7,
                    from net/ceph/crypto.c:3:
   net/ceph/crypto.c: In function 'ceph_crypto_key_decode':
>> net/ceph/crypto.c:93:26: error: passing argument 1 of 'ceph_has_room' from incompatible pointer type [-Werror=incompatible-pointer-types]
      93 |         ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
         |                          ^
         |                          |
         |                          const void **
   include/linux/compiler.h:76:45: note: in definition of macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   net/ceph/crypto.c:93:9: note: in expansion of macro 'ceph_decode_need'
      93 |         ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
         |         ^~~~~~~~~~~~~~~~
   In file included from net/ceph/crypto.c:16:
   include/linux/ceph/decode.h:52:41: note: expected 'void **' but argument is of type 'const void **'
      52 | static inline bool ceph_has_room(void **p, void *end, size_t n)
         |                                  ~~~~~~~^
   net/ceph/crypto.c:93:29: warning: passing argument 2 of 'ceph_has_room' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      93 |         ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
         |                             ^~~
   include/linux/compiler.h:76:45: note: in definition of macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   net/ceph/crypto.c:93:9: note: in expansion of macro 'ceph_decode_need'
      93 |         ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
         |         ^~~~~~~~~~~~~~~~
   include/linux/ceph/decode.h:52:50: note: expected 'void *' but argument is of type 'const void *'
      52 | static inline bool ceph_has_room(void **p, void *end, size_t n)
         |                                            ~~~~~~^~~
>> net/ceph/crypto.c:94:36: error: passing argument 1 of 'ceph_decode_16' from incompatible pointer type [-Werror=incompatible-pointer-types]
      94 |         key->type = ceph_decode_16(p);
         |                                    ^
         |                                    |
         |                                    const void **
   include/linux/ceph/decode.h:31:41: note: expected 'void **' but argument is of type 'const void **'
      31 | static inline u16 ceph_decode_16(void **p)
         |                                  ~~~~~~~^
>> net/ceph/crypto.c:95:26: error: passing argument 1 of 'ceph_decode_copy' from incompatible pointer type [-Werror=incompatible-pointer-types]
      95 |         ceph_decode_copy(p, &key->created, sizeof(key->created));
         |                          ^
         |                          |
         |                          const void **
   include/linux/ceph/decode.h:43:44: note: expected 'void **' but argument is of type 'const void **'
      43 | static inline void ceph_decode_copy(void **p, void *pv, size_t n)
         |                                     ~~~~~~~^
   net/ceph/crypto.c:96:35: error: passing argument 1 of 'ceph_decode_16' from incompatible pointer type [-Werror=incompatible-pointer-types]
      96 |         key->len = ceph_decode_16(p);
         |                                   ^
         |                                   |
         |                                   const void **
   include/linux/ceph/decode.h:31:41: note: expected 'void **' but argument is of type 'const void **'
      31 | static inline u16 ceph_decode_16(void **p)
         |                                  ~~~~~~~^
   net/ceph/crypto.c:97:26: error: passing argument 1 of 'ceph_has_room' from incompatible pointer type [-Werror=incompatible-pointer-types]
      97 |         ceph_decode_need(p, end, key->len, bad);
         |                          ^
         |                          |
         |                          const void **
   include/linux/compiler.h:76:45: note: in definition of macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   net/ceph/crypto.c:97:9: note: in expansion of macro 'ceph_decode_need'
      97 |         ceph_decode_need(p, end, key->len, bad);
         |         ^~~~~~~~~~~~~~~~
   include/linux/ceph/decode.h:52:41: note: expected 'void **' but argument is of type 'const void **'
      52 | static inline bool ceph_has_room(void **p, void *end, size_t n)
         |                                  ~~~~~~~^
   net/ceph/crypto.c:97:29: warning: passing argument 2 of 'ceph_has_room' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      97 |         ceph_decode_need(p, end, key->len, bad);
         |                             ^~~
   include/linux/compiler.h:76:45: note: in definition of macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   net/ceph/crypto.c:97:9: note: in expansion of macro 'ceph_decode_need'
      97 |         ceph_decode_need(p, end, key->len, bad);
         |         ^~~~~~~~~~~~~~~~
   include/linux/ceph/decode.h:52:50: note: expected 'void *' but argument is of type 'const void *'
      52 | static inline bool ceph_has_room(void **p, void *end, size_t n)
         |                                            ~~~~~~^~~
   net/ceph/crypto.c:98:31: warning: passing argument 2 of 'set_secret' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      98 |         ret = set_secret(key, *p);
         |                               ^~
   net/ceph/crypto.c:23:58: note: expected 'void *' but argument is of type 'const void *'
      23 | static int set_secret(struct ceph_crypto_key *key, void *buf)
         |                                                    ~~~~~~^~~
   net/ceph/crypto.c:99:26: warning: passing argument 1 of 'memzero_explicit' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      99 |         memzero_explicit(*p, key->len);
         |                          ^~
   include/linux/string.h:356:43: note: expected 'void *' but argument is of type 'const void *'
     356 | static inline void memzero_explicit(void *s, size_t count)
         |                                     ~~~~~~^
   during RTL pass: mach
   net/ceph/crypto.c: In function 'ceph_crypto_key_unarmor':
   net/ceph/crypto.c:134:1: internal compiler error: in arc_ifcvt, at config/arc/arc.cc:9703
     134 | }
         | ^
   0x5b78c1 arc_ifcvt
   	/tmp/build-crosstools-gcc-13.2.0-binutils-2.41/gcc/gcc-13.2.0/gcc/config/arc/arc.cc:9703
   0xe431b4 arc_reorg
   	/tmp/build-crosstools-gcc-13.2.0-binutils-2.41/gcc/gcc-13.2.0/gcc/config/arc/arc.cc:8552
   0xaed299 execute
   	/tmp/build-crosstools-gcc-13.2.0-binutils-2.41/gcc/gcc-13.2.0/gcc/reorg.cc:3927
   Please submit a full bug report, with preprocessed source (by using -freport-bug).
   Please include the complete backtrace with any bug report.
   See <https://gcc.gnu.org/bugs/> for instructions.


vim +/ceph_has_room +93 net/ceph/crypto.c

8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02   88  
19c7b44529ef1b net/ceph/crypto.c Abhinav Jain 2024-08-12   89  int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02   90  {
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02   91  	int ret;
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02   92  
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  @93  	ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  @94  	key->type = ceph_decode_16(p);
8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  @95  	ceph_decode_copy(p, &key->created, sizeof(key->created));
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

