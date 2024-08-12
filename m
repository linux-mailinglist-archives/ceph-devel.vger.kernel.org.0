Return-Path: <ceph-devel+bounces-1652-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7B394E4B0
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 04:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78E691F2218B
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 02:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C0D67A0D;
	Mon, 12 Aug 2024 02:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T8mclz/o"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3EF4D8D1;
	Mon, 12 Aug 2024 02:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723429021; cv=none; b=NjtWAhIOb/WJnbTfCbzO8AyKgvUNg5gnCa5hKOZhPu17/qs37vnQzo5WKq6CiMJNj0gkennlgWg/OipzGug266cm/tDd/bei5m42cZWJeIV+g07iV2oDShkP2le9LiHktu53Ka1SZBfSZYXvOXeF0jw4dCXXFEERXlr/JjD+1+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723429021; c=relaxed/simple;
	bh=1BthmYLXft2vjc2EBdR/kbPBvUittp4y+lMelQZI7aY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=POeF6dgOwsFZ83q30mmw6irxfVsKKoOpfR/kiKFwB5flcaW+5q7UHuuefTOahU1Li4aNIds1etQe9HKmDfP3IWn08ZpAxScAfGdQL9ylwV92358+9g8BeDg/XuUmqhSOmKJo8wwKa1Q3e/Fz6XHLuWocBAWzPVeGLuGwqkSs0vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T8mclz/o; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723429019; x=1754965019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1BthmYLXft2vjc2EBdR/kbPBvUittp4y+lMelQZI7aY=;
  b=T8mclz/oi+MjHGF1yK0CvdXRIqAxfDecIu/upi+lOPPNG/6kKmntc0H+
   1Mv1Gvcn5E55rQ6CrJTmiy4mVROWhzXKg50VTZ1ppYoDGEWAW3LXwfw40
   5KIXDOsqonPmj/CP6TwuyBUwiOl5dvcLa/vJfxQNbObLG0GpAxUAkZbG3
   4nZR132bU4f7dv362CKY+R0WMtMDsNdHRiHDADCKkVG5aaqNbP0wBAGOn
   tzosqG10dUx3SSBaijY7KqsmEYFeNTQIg28AN25Cl5ssgYgISJlxPFG6Y
   oGiBNkyJX23bC22BRoJs0ZIcM5v2lsr4bsO9vHOr6VxQToZr7MhiMr4H9
   A==;
X-CSE-ConnectionGUID: oB9IU7TJQLyMWaTJPcWSOw==
X-CSE-MsgGUID: CZ7qMUVVTgesR++qS8Q1Fg==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="25290359"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="25290359"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2024 19:16:59 -0700
X-CSE-ConnectionGUID: VGKqhFh3RbibQBD7I/sU8w==
X-CSE-MsgGUID: D8S7/TT9QHu2NLXDj1Ieng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="58359393"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 11 Aug 2024 19:16:56 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sdKbz-000BJr-3A;
	Mon, 12 Aug 2024 02:16:48 +0000
Date: Mon, 12 Aug 2024 10:15:24 +0800
From: kernel test robot <lkp@intel.com>
To: Abhinav Jain <jain.abhinav177@gmail.com>, idryomov@gmail.com,
	xiubli@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	Abhinav Jain <jain.abhinav177@gmail.com>
Subject: Re: [PATCH net] libceph: Make the input const as per the TODO
Message-ID: <202408120903.UYNxKoDx-lkp@intel.com>
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
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20240812/202408120903.UYNxKoDx-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240812/202408120903.UYNxKoDx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408120903.UYNxKoDx-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> net/ceph/crypto.c:89:5: error: conflicting types for 'ceph_crypto_key_decode'; have 'int(struct ceph_crypto_key *, const void **, const void *)'
      89 | int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
         |     ^~~~~~~~~~~~~~~~~~~~~~
   In file included from net/ceph/crypto.c:17:
   net/ceph/crypto.h:25:5: note: previous declaration of 'ceph_crypto_key_decode' with type 'int(struct ceph_crypto_key *, void **, void *)'
      25 | int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end);
         |     ^~~~~~~~~~~~~~~~~~~~~~
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
>> net/ceph/crypto.c:93:29: warning: passing argument 2 of 'ceph_has_room' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
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
>> net/ceph/crypto.c:98:31: warning: passing argument 2 of 'set_secret' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      98 |         ret = set_secret(key, *p);
         |                               ^~
   net/ceph/crypto.c:23:58: note: expected 'void *' but argument is of type 'const void *'
      23 | static int set_secret(struct ceph_crypto_key *key, void *buf)
         |                                                    ~~~~~~^~~
>> net/ceph/crypto.c:99:26: warning: passing argument 1 of 'memzero_explicit' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      99 |         memzero_explicit(*p, key->len);
         |                          ^~
   include/linux/string.h:356:43: note: expected 'void *' but argument is of type 'const void *'
     356 | static inline void memzero_explicit(void *s, size_t count)
         |                                     ~~~~~~^
   net/ceph/crypto.c: In function 'ceph_crypto_key_unarmor':
>> net/ceph/crypto.c:126:43: error: passing argument 2 of 'ceph_crypto_key_decode' from incompatible pointer type [-Werror=incompatible-pointer-types]
     126 |         ret = ceph_crypto_key_decode(key, &p, p + blen);
         |                                           ^~
         |                                           |
         |                                           void **
   net/ceph/crypto.c:89:70: note: expected 'const void **' but argument is of type 'void **'
      89 | int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
         |                                                         ~~~~~~~~~~~~~^
   cc1: some warnings being treated as errors


vim +89 net/ceph/crypto.c

    13	
    14	#include <keys/ceph-type.h>
    15	#include <keys/user-type.h>
    16	#include <linux/ceph/decode.h>
  > 17	#include "crypto.h"
    18	
    19	/*
    20	 * Set ->key and ->tfm.  The rest of the key should be filled in before
    21	 * this function is called.
    22	 */
    23	static int set_secret(struct ceph_crypto_key *key, void *buf)
    24	{
    25		unsigned int noio_flag;
    26		int ret;
    27	
    28		key->key = NULL;
    29		key->tfm = NULL;
    30	
    31		switch (key->type) {
    32		case CEPH_CRYPTO_NONE:
    33			return 0; /* nothing to do */
    34		case CEPH_CRYPTO_AES:
    35			break;
    36		default:
    37			return -ENOTSUPP;
    38		}
    39	
    40		if (!key->len)
    41			return -EINVAL;
    42	
    43		key->key = kmemdup(buf, key->len, GFP_NOIO);
    44		if (!key->key) {
    45			ret = -ENOMEM;
    46			goto fail;
    47		}
    48	
    49		/* crypto_alloc_sync_skcipher() allocates with GFP_KERNEL */
    50		noio_flag = memalloc_noio_save();
    51		key->tfm = crypto_alloc_sync_skcipher("cbc(aes)", 0, 0);
    52		memalloc_noio_restore(noio_flag);
    53		if (IS_ERR(key->tfm)) {
    54			ret = PTR_ERR(key->tfm);
    55			key->tfm = NULL;
    56			goto fail;
    57		}
    58	
    59		ret = crypto_sync_skcipher_setkey(key->tfm, key->key, key->len);
    60		if (ret)
    61			goto fail;
    62	
    63		return 0;
    64	
    65	fail:
    66		ceph_crypto_key_destroy(key);
    67		return ret;
    68	}
    69	
    70	int ceph_crypto_key_clone(struct ceph_crypto_key *dst,
    71				  const struct ceph_crypto_key *src)
    72	{
    73		memcpy(dst, src, sizeof(struct ceph_crypto_key));
    74		return set_secret(dst, src->key);
    75	}
    76	
    77	int ceph_crypto_key_encode(struct ceph_crypto_key *key, void **p, void *end)
    78	{
    79		if (*p + sizeof(u16) + sizeof(key->created) +
    80		    sizeof(u16) + key->len > end)
    81			return -ERANGE;
    82		ceph_encode_16(p, key->type);
    83		ceph_encode_copy(p, &key->created, sizeof(key->created));
    84		ceph_encode_16(p, key->len);
    85		ceph_encode_copy(p, key->key, key->len);
    86		return 0;
    87	}
    88	
  > 89	int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
    90	{
    91		int ret;
    92	
  > 93		ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
  > 94		key->type = ceph_decode_16(p);
  > 95		ceph_decode_copy(p, &key->created, sizeof(key->created));
    96		key->len = ceph_decode_16(p);
  > 97		ceph_decode_need(p, end, key->len, bad);
  > 98		ret = set_secret(key, *p);
  > 99		memzero_explicit(*p, key->len);
   100		*p += key->len;
   101		return ret;
   102	
   103	bad:
   104		dout("failed to decode crypto key\n");
   105		return -EINVAL;
   106	}
   107	
   108	int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
   109	{
   110		int inlen = strlen(inkey);
   111		int blen = inlen * 3 / 4;
   112		void *buf, *p;
   113		int ret;
   114	
   115		dout("crypto_key_unarmor %s\n", inkey);
   116		buf = kmalloc(blen, GFP_NOFS);
   117		if (!buf)
   118			return -ENOMEM;
   119		blen = ceph_unarmor(buf, inkey, inkey+inlen);
   120		if (blen < 0) {
   121			kfree(buf);
   122			return blen;
   123		}
   124	
   125		p = buf;
 > 126		ret = ceph_crypto_key_decode(key, &p, p + blen);
   127		kfree(buf);
   128		if (ret)
   129			return ret;
   130		dout("crypto_key_unarmor key %p type %d len %d\n", key,
   131		     key->type, key->len);
   132		return 0;
   133	}
   134	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

