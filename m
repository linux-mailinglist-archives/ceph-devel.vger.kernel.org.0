Return-Path: <ceph-devel+bounces-3452-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 917A1B26DCB
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Aug 2025 19:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4847F1896FB6
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Aug 2025 17:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7790F30AAD9;
	Thu, 14 Aug 2025 17:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KBC45Kds"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E44B3074BF
	for <ceph-devel@vger.kernel.org>; Thu, 14 Aug 2025 17:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192957; cv=none; b=shRW2g6vOpm6Ox5F0FggdSKevobcMw9Svg7K/j3vF9SMdqL0ILl3y7bDFSiciEotNF8Yh76PiDQ0Y9Is/acGkTyCW7GEUza7XSagWODXIDgIdeaaNfrlZkzedB+5v436HnAErEhMVevJq+9rEN332J29APGKnCnJ+2aaT/IZ/rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192957; c=relaxed/simple;
	bh=bI7J9Hiwp/Ns+uHOXC16jsm9HZ3H4cqjwVHPm85ECQM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=avQQi/ESQ46iSIORjrRf6m6M/OcOGk1KvvbXw20Ujg21Kek3kvujTOqhqS/B7dlvtIN5ejnMTeuQS9ezNjmfjig0F7CBczNyX6Xkqb8XU0JPGi4vPXxPe856NV5xujWicnT7H2vtmu/ZyPtDWrPZP5NnNk2oizqZhciT7SsP6VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KBC45Kds; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755192954; x=1786728954;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=bI7J9Hiwp/Ns+uHOXC16jsm9HZ3H4cqjwVHPm85ECQM=;
  b=KBC45Kds+UbjQ6tY28oAjVlA2+giySylZAwhJ45U7hpVfa7ZL/kJr8WN
   ii34MeM3uI1kMzt6Rb55LZoHCZiR7A0U5f4shtgGDvlPypDQEv1EElSy6
   x3etHuiTR2C56tag3Jz1JuGaAb9QiZir3fF6Jbr2ZXz5SFCENEy3jAjlT
   rDCMs0++cVl7nwMg+b7ehGteVM7bgfhU1ufQwpnz+c8ELFSDFgqAb8Vzx
   dg6XT5bJjAHRtbD8tUpEDMzEqsxMPwcD8PaifzgvgTTQch04ybJdQy212
   Z/N9Ed9EpsIix6LgvznHoAsTR/PaxNWcImzkLVjqFtRkeNBPXdsHbgWsX
   g==;
X-CSE-ConnectionGUID: 32106wKwRHK6PK7Anwlk5A==
X-CSE-MsgGUID: T/HwkGeBR6q/WI2Ct+q/Gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57470729"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57470729"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 10:35:53 -0700
X-CSE-ConnectionGUID: ZQDIa0doSPy85J4c94/eiA==
X-CSE-MsgGUID: 9biQ/pcTSNST3iAabiggvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167181999"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 14 Aug 2025 10:35:51 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umbrh-000BDI-0c;
	Thu, 14 Aug 2025 17:35:49 +0000
Date: Fri, 15 Aug 2025 01:35:02 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls-tracing-only 3/10]
 include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to
 integer of different size
Message-ID: <202508150113.GIrq0aJ3-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alex,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://github.com/ceph/ceph-client.git tls-tracing-only
head:   6b738aa5f6bb2343f8277d318ff1e9ea9289212c
commit: 3dac114cfe81186e593e112c055893cbf9f6ec00 [3/10] fs/ceph: using bout instead of dout
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20250815/202508150113.GIrq0aJ3-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250815/202508150113.GIrq0aJ3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508150113.GIrq0aJ3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/init.h:5,
                    from include/linux/printk.h:6,
                    from include/asm-generic/bug.h:22,
                    from arch/sh/include/asm/bug.h:112,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/current.h:6,
                    from ./arch/sh/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from include/linux/ceph/ceph_san_logger.h:5,
                    from include/linux/ceph/ceph_debug.h:9,
                    from fs/ceph/super.c:3:
   include/linux/ceph/ceph_san_ser.h: In function 'write_null_str':
   include/linux/build_bug.h:78:41: error: static assertion failed: "null_str.str size must match unsigned long for proper alignment"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:116:5: note: in expansion of macro 'static_assert'
     116 |     static_assert(sizeof(null_str.str) == sizeof(unsigned long),
         |     ^~~~~~~~~~~~~
   fs/ceph/super.c: In function 'ceph_parse_new_source':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:306:9: note: in expansion of macro 'bout'
     306 |         bout("using %s entity name", opts->name);
         |         ^~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:325:9: note: in expansion of macro 'bout'
     325 |         bout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
         |         ^~~~
   fs/ceph/super.c: In function 'ceph_parse_source':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:356:9: note: in expansion of macro 'bout'
     356 |         bout("'%s'\n", dev_name);
         |         ^~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:183:94: note: in expansion of macro '___ceph_san_ser1'
     183 | #define ___ceph_san_ser2(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser1(__buffer, __args))
         |                                                                                              ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser2'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:380:9: note: in expansion of macro 'bout'
     380 |         bout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
         |         ^~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:382:17: note: in expansion of macro 'bout'
     382 |                 bout("server path '%s'\n", fsopt->server_path);
         |                 ^~~~
   fs/ceph/super.c: In function 'ceph_parse_mount_param':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:184:58: note: in expansion of macro '__ceph_san_ser_type'
     184 | #define ___ceph_san_ser3(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser2(__buffer, __args))
         |                                                          ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser3'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:428:9: note: in expansion of macro 'bout'
     428 |         bout("%s: fs_parse '%s' token %d\n",__func__, param->key, token);
         |         ^~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:183:58: note: in expansion of macro '__ceph_san_ser_type'
     183 | #define ___ceph_san_ser2(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser1(__buffer, __args))
         |                                                          ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:184:94: note: in expansion of macro '___ceph_san_ser2'
     184 | #define ___ceph_san_ser3(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser2(__buffer, __args))
         |                                                                                              ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser3'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:428:9: note: in expansion of macro 'bout'
     428 |         bout("%s: fs_parse '%s' token %d\n",__func__, param->key, token);
         |         ^~~~
   fs/ceph/super.c: In function 'destroy_mount_options':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:634:9: note: in expansion of macro 'bout'
     634 |         bout("destroy_mount_options %p\n", args);
         |         ^~~~
   fs/ceph/super.c: In function 'destroy_fs_client':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:898:9: note: in expansion of macro 'boutc'
     898 |         boutc(fsc->client, "%p\n", fsc);
         |         ^~~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:183:58: note: in expansion of macro '__ceph_san_ser_type'
     183 | #define ___ceph_san_ser2(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser1(__buffer, __args))
         |                                                          ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser2'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:913:9: note: in expansion of macro 'bout'
     913 |         bout("%s: %p done\n", __func__, fsc);
         |         ^~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:183:94: note: in expansion of macro '___ceph_san_ser1'
     183 | #define ___ceph_san_ser2(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser1(__buffer, __args))
         |                                                                                              ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser2'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:913:9: note: in expansion of macro 'bout'
     913 |         bout("%s: %p done\n", __func__, fsc);
         |         ^~~~
   fs/ceph/super.c: In function 'open_root_dentry':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:1069:9: note: in expansion of macro 'boutc'
    1069 |         boutc(cl, "opening '%s'\n", path);
         |         ^~~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:1095:17: note: in expansion of macro 'boutc'
    1095 |                 boutc(cl, "success, root dentry is %p\n", root);
         |                 ^~~~~
   fs/ceph/super.c: In function 'ceph_real_mount':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:1159:9: note: in expansion of macro 'boutc'
    1159 |         boutc(cl, "mount start %p\n", fsc);
         |         ^~~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:1182:17: note: in expansion of macro 'boutc'
    1182 |                 boutc(cl, "mount opening path '%s'\n", path);
         |                 ^~~~~
   fs/ceph/super.c: In function 'ceph_set_super':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:1213:9: note: in expansion of macro 'boutc'
    1213 |         boutc(cl, "%p\n", s);
         |         ^~~~~
   fs/ceph/super.c: In function 'ceph_compare_super':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:1250:9: note: in expansion of macro 'boutc'
    1250 |         boutc(cl, "%p\n", sb);
         |         ^~~~~
   fs/ceph/super.c: In function 'ceph_get_tree':
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:1347:17: note: in expansion of macro 'bout'
    1347 |                 bout("get_sb got existing client %p\n", fsc);
         |                 ^~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:186:5: note: in expansion of macro '__CEPH_SAN_LOG'
     186 |     __CEPH_SAN_LOG(0, 0, fmt, ##__VA_ARGS__)
         |     ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:69:17: note: in expansion of macro 'CEPH_SAN_LOG'
      69 |                 CEPH_SAN_LOG(fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~
   fs/ceph/super.c:1349:17: note: in expansion of macro 'bout'
    1349 |                 bout("get_sb using new client %p\n", fsc);
         |                 ^~~~
>> include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:185:58: note: in expansion of macro '__ceph_san_ser_type'
     185 | #define ___ceph_san_ser4(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser3(__buffer, __args))
         |                                                          ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser4'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:1361:9: note: in expansion of macro 'boutc'
    1361 |         boutc(fsc->client, "root %p inode %p ino %llx.%llx\n", res,
         |         ^~~~~
   include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:184:58: note: in expansion of macro '__ceph_san_ser_type'
     184 | #define ___ceph_san_ser3(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser2(__buffer, __args))
         |                                                          ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:185:94: note: in expansion of macro '___ceph_san_ser3'
     185 | #define ___ceph_san_ser4(__buffer, __t, __args...)      (__ceph_san_ser_type(__buffer, __t), ___ceph_san_ser3(__buffer, __args))
         |                                                                                              ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser4'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
      36 | #define ___ceph_san_apply(__fn, __n) ___ceph_san_concat(__fn, __n)
         |                                      ^~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:214:42: note: in expansion of macro '___ceph_san_apply'
     214 | #define ___ceph_san_ser(__buffer, ...)   ___ceph_san_apply(___ceph_san_ser, ceph_san_narg(__VA_ARGS__))(__buffer, ##__VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:215:34: note: in expansion of macro '___ceph_san_ser'
     215 | #define ceph_san_ser(...)        ___ceph_san_ser(__VA_ARGS__)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:179:17: note: in expansion of macro 'ceph_san_ser'
     179 |                 ceph_san_ser(___buffer, ##__VA_ARGS__);\
         |                 ^~~~~~~~~~~~
   include/linux/ceph/ceph_san_logger.h:193:9: note: in expansion of macro '__CEPH_SAN_LOG'
     193 |         __CEPH_SAN_LOG(0, __client_id, fmt, ##__VA_ARGS__); \
         |         ^~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:74:17: note: in expansion of macro 'CEPH_SAN_LOG_CLIENT'
      74 |                 CEPH_SAN_LOG_CLIENT(client, fmt, ##__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~
   fs/ceph/super.c:1361:9: note: in expansion of macro 'boutc'
    1361 |         boutc(fsc->client, "root %p inode %p ino %llx.%llx\n", res,
         |         ^~~~~
   fs/ceph/super.c: In function 'ceph_kill_sb':
   include/linux/ceph/ceph_san_ser.h:157:93: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |                                                                                             ^
   include/linux/printk.h:479:33: note: in definition of macro 'printk_index_wrap'
     479 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:550:9: note: in expansion of macro 'printk'
     550 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_san_ser.h:157:10: note: in expansion of macro 'pr_err'
     157 |         (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
         |          ^~~~~~
   include/linux/ceph/ceph_san_ser.h:182:50: note: in expansion of macro '__ceph_san_ser_type'
     182 | #define ___ceph_san_ser1(__buffer, __t)         (__ceph_san_ser_type(__buffer, __t))
         |                                                  ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:35:38: note: in expansion of macro '___ceph_san_ser1'
      35 | #define ___ceph_san_concat(__a, __b) __a ## __b
         |                                      ^~~
   include/linux/ceph/ceph_san_ser.h:36:38: note: in expansion of macro '___ceph_san_concat'
..


vim +157 include/linux/ceph/ceph_san_ser.h

03cd9c6e3aa393 Alex Markuze 2025-05-15  112  
03cd9c6e3aa393 Alex Markuze 2025-05-15  113  static inline size_t write_null_str(char *dst)
03cd9c6e3aa393 Alex Markuze 2025-05-15  114  {
03cd9c6e3aa393 Alex Markuze 2025-05-15  115  	*(union null_str_u *)dst = null_str;
03cd9c6e3aa393 Alex Markuze 2025-05-15 @116      static_assert(sizeof(null_str.str) == sizeof(unsigned long),
03cd9c6e3aa393 Alex Markuze 2025-05-15  117                   "null_str.str size must match unsigned long for proper alignment");
03cd9c6e3aa393 Alex Markuze 2025-05-15  118      return __builtin_strlen(null_str.str);
03cd9c6e3aa393 Alex Markuze 2025-05-15  119  }
03cd9c6e3aa393 Alex Markuze 2025-05-15  120  
03cd9c6e3aa393 Alex Markuze 2025-05-15  121  static inline size_t strscpy_n(char *dst, const char *src)
03cd9c6e3aa393 Alex Markuze 2025-05-15  122  {
03cd9c6e3aa393 Alex Markuze 2025-05-15  123  	size_t count = 0;
03cd9c6e3aa393 Alex Markuze 2025-05-15  124  
03cd9c6e3aa393 Alex Markuze 2025-05-15  125  	while (count < STR_MAX_SIZE - 1) {
03cd9c6e3aa393 Alex Markuze 2025-05-15  126  		dst[count] = src[count];
03cd9c6e3aa393 Alex Markuze 2025-05-15  127  		if (src[count] == '\0')
03cd9c6e3aa393 Alex Markuze 2025-05-15  128  			goto out;
03cd9c6e3aa393 Alex Markuze 2025-05-15  129  		count++;
03cd9c6e3aa393 Alex Markuze 2025-05-15  130  	}
03cd9c6e3aa393 Alex Markuze 2025-05-15  131  
03cd9c6e3aa393 Alex Markuze 2025-05-15  132      dst[count] = '\0';
03cd9c6e3aa393 Alex Markuze 2025-05-15  133      pr_err("strscpy_n: string truncated, exceeded max size %d\n", STR_MAX_SIZE);
03cd9c6e3aa393 Alex Markuze 2025-05-15  134  out:
03cd9c6e3aa393 Alex Markuze 2025-05-15  135  	return count + 1;
03cd9c6e3aa393 Alex Markuze 2025-05-15  136  }
03cd9c6e3aa393 Alex Markuze 2025-05-15  137  
03cd9c6e3aa393 Alex Markuze 2025-05-15  138  static inline ssize_t __strscpy(char *dst, const char *src)
03cd9c6e3aa393 Alex Markuze 2025-05-15  139  {
03cd9c6e3aa393 Alex Markuze 2025-05-15  140  	if (src != NULL)
03cd9c6e3aa393 Alex Markuze 2025-05-15  141  		return strscpy_n(dst, src);
03cd9c6e3aa393 Alex Markuze 2025-05-15  142  	return write_null_str(dst);
03cd9c6e3aa393 Alex Markuze 2025-05-15  143  }
03cd9c6e3aa393 Alex Markuze 2025-05-15  144  
03cd9c6e3aa393 Alex Markuze 2025-05-15  145  static inline void* strscpy_n_update(char *dst, const char *src, const char *file, int line)
03cd9c6e3aa393 Alex Markuze 2025-05-15  146  {
03cd9c6e3aa393 Alex Markuze 2025-05-15  147      ssize_t ret = __strscpy(dst, src);
03cd9c6e3aa393 Alex Markuze 2025-05-15  148      if (!(unlikely(ret > 0 && ret < STR_MAX_SIZE))) {
03cd9c6e3aa393 Alex Markuze 2025-05-15  149          panic("strscpy_n_update: ret = %zd at %s:%d :: %s < - %s\n", ret, file, line, dst, src);
03cd9c6e3aa393 Alex Markuze 2025-05-15  150      }
03cd9c6e3aa393 Alex Markuze 2025-05-15  151      return dst + round_up(ret, 4);
03cd9c6e3aa393 Alex Markuze 2025-05-15  152  }
03cd9c6e3aa393 Alex Markuze 2025-05-15  153  
03cd9c6e3aa393 Alex Markuze 2025-05-15  154  #define __ceph_san_ser_type(__buffer, __t)                          \
03cd9c6e3aa393 Alex Markuze 2025-05-15  155      (__builtin_choose_expr((IS_DYNAMIC_CHAR_PTR((__t)) || IS_STATIC_CHAR_ARRAY((__t))),               \
03cd9c6e3aa393 Alex Markuze 2025-05-15  156          /* For static arrays (like __func__), just save pointer */   \
03cd9c6e3aa393 Alex Markuze 2025-05-15 @157          (pr_err("DYNAMIC_PTR: %s:%d: saving pointer %llx\n", kbasename(__FILE__), __LINE__, (unsigned long long)(__t)), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  158           *(void **)(__buffer) = __suppress_cast_warning(void *, (__t)), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  159           (__buffer) = (void *)((char *)(__buffer) + sizeof(void *))), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  160      __builtin_choose_expr(IS_STR((__t)),               \
03cd9c6e3aa393 Alex Markuze 2025-05-15  161          ((__buffer) = (void *)strscpy_n_update((__buffer), char_ptr(__t), kbasename(__FILE__), __LINE__)), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  162      __builtin_choose_expr(IS_STR_ARRAY((__t)),               \
03cd9c6e3aa393 Alex Markuze 2025-05-15  163          /* For dynamic arrays, save NULL and string bytes */         \
03cd9c6e3aa393 Alex Markuze 2025-05-15  164           ((__buffer) = (void *)strscpy_n_update((__buffer), char_ptr(__t), kbasename(__FILE__), __LINE__)), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  165      __builtin_choose_expr(sizeof((__t)) == 1,                         \
03cd9c6e3aa393 Alex Markuze 2025-05-15  166          (*(uint32_t *)(__buffer) = __suppress_cast_warning(uint32_t, (__t)), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  167           /*pr_err("SERIALIZING_U8: %s:%d: saving uint8_t %u\n", kbasename(__FILE__), __LINE__, (__t)),*/ \
03cd9c6e3aa393 Alex Markuze 2025-05-15  168           (__buffer) = (void *)((char *)(__buffer) + 4)),            \
03cd9c6e3aa393 Alex Markuze 2025-05-15  169      __builtin_choose_expr(sizeof((__t)) == 2, /* we have no way to differentiate u16 and u32 in deserialization */                        \
03cd9c6e3aa393 Alex Markuze 2025-05-15  170          (*(uint32_t *)(__buffer) = __suppress_cast_warning(uint32_t, (__t)), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  171           (__buffer) = (void *)((char *)(__buffer) + 4)),            \
03cd9c6e3aa393 Alex Markuze 2025-05-15  172      __builtin_choose_expr(sizeof((__t)) == 4,                         \
03cd9c6e3aa393 Alex Markuze 2025-05-15  173          (*(uint32_t *)(__buffer) = __suppress_cast_warning(uint32_t, (__t)), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  174           (__buffer) = (void *)((char *)(__buffer) + 4)),            \
03cd9c6e3aa393 Alex Markuze 2025-05-15  175      __builtin_choose_expr(sizeof((__t)) == 8,                         \
03cd9c6e3aa393 Alex Markuze 2025-05-15  176          (*(uint64_t *)(__buffer) = __suppress_cast_warning(uint64_t, (__t)), \
03cd9c6e3aa393 Alex Markuze 2025-05-15  177           (__buffer) = (void *)((char *)(__buffer) + 8)),            \
03cd9c6e3aa393 Alex Markuze 2025-05-15  178          (pr_err("UNSUPPORTED_TYPE: %s:%d: unsupported type size %s\n", kbasename(__FILE__), __LINE__, #__t)) \
03cd9c6e3aa393 Alex Markuze 2025-05-15  179      ))))))))
03cd9c6e3aa393 Alex Markuze 2025-05-15  180  

:::::: The code at line 157 was first introduced by commit
:::::: 03cd9c6e3aa393317477ee1312797da66d21a1a6 ceph_san code

:::::: TO: Alex Markuze <amarkuze@redhat.com>
:::::: CC: Alex Markuze <amarkuze@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

