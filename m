Return-Path: <ceph-devel+bounces-2656-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F44A33D19
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 11:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79D903A84B2
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 10:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B182135C0;
	Thu, 13 Feb 2025 10:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fgvyitxn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE742135CF
	for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2025 10:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739444302; cv=none; b=Nskrafgexpz0ygwalaseCavmLt4nC5deCYeSykSTkOCtGjcBY3/0FGnJ1VhSikYvF/9Bc2jQIDXTrsL5B9mr2+tyLn2qWoPeX+iH97cz6H5tIm2Atajo7MvJWtM0A0+B3N/+IXeT059Tn1aIT76SI+P3CYaJXR+5k/dQZvSEj2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739444302; c=relaxed/simple;
	bh=tj+Hgy7VyfAwJg4jAzW0I5c3mGBtr/B6lo6DVFjLF6U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=X3tsFjI/npz/p4QvINeFfGdl1REvzn3wAwxD1mXQkRmHg4rNLNWijosgQnSrgTxt0q/HNxBuGp5VUpLPKJyr2zOWD/s1MX3Q4mJTmKN0Ug0VCqkjJ1wOjA5gBU6+vuHZLfYwre2lopyBIidjkg6klmqBB8j9W7i0M2Whqput+Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fgvyitxn; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739444300; x=1770980300;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=tj+Hgy7VyfAwJg4jAzW0I5c3mGBtr/B6lo6DVFjLF6U=;
  b=FgvyitxnqK+/QGPtHB6RS1ot0qlNlqdtQ2RzYZIOl1qkYjwQ8JiII5JD
   LY5TtBbHW5K5GGb4gLXciD2hjBVWVOrielmOiYubA4zpr4PwjCB8w3Ozk
   cW07ZyvN7E9U4s8pCWus3lOevhF9c0PpZvjXrRDkHgSnZ/qb8sby8TiVw
   uQaeKWhyxrFuo8HYeVfTMsYcydszenWxbwQBPs0kOK9szNExoO3dPrG1K
   p1SlgoHx1qQkix9lB+k6Gy6cEykQ4fIFKK4OhBjvodz/WGZpB607COA9W
   1gzB2XhnNdn2sEExTY/ktyWiWVQaq+JfaaFQnjYoLD+3RZm4kWnfx+9gU
   Q==;
X-CSE-ConnectionGUID: 2NoC2d3JRzK95TmkyvCIHg==
X-CSE-MsgGUID: KiFHM/xvQJ+8+Til76ZKZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="57542057"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="57542057"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 02:58:20 -0800
X-CSE-ConnectionGUID: lrtY8sMvRsWuJJHsqiw31w==
X-CSE-MsgGUID: 3LR3jwkmRR6RRZXWa309iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112942475"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 13 Feb 2025 02:58:18 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tiWvA-0016wn-0N;
	Thu, 13 Feb 2025 10:58:16 +0000
Date: Thu, 13 Feb 2025 18:57:26 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 6/13] include/linux/percpu-defs.h:219:59:
 error: invalid use of undefined type 'struct ceph_san_tls_logger'
Message-ID: <202502131856.1wNMq5pb-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   cd1e899feeb6a7da55cbb74b9245c8bbb77f82ba
commit: 485747e7711ebb9bcda819027564d587d215874a [6/13] ceph_san: moving to per_cpu
config: sh-randconfig-001-20250213 (https://download.01.org/0day-ci/archive/20250213/202502131856.1wNMq5pb-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250213/202502131856.1wNMq5pb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502131856.1wNMq5pb-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   net/ceph/ceph_san.c:15:7: warning: no previous prototype for 'get_log_cephsan' [-Wmissing-prototypes]
      15 | char *get_log_cephsan(void) {
         |       ^~~~~~~~~~~~~~~
   In file included from include/asm-generic/percpu.h:7,
                    from ./arch/sh/include/generated/asm/percpu.h:1,
                    from include/linux/irqflags.h:19,
                    from arch/sh/include/asm/cmpxchg-irq.h:5,
                    from arch/sh/include/asm/cmpxchg.h:21,
                    from arch/sh/include/asm/atomic.h:19,
                    from include/linux/atomic.h:7,
                    from include/asm-generic/bitops/atomic.h:5,
                    from arch/sh/include/asm/bitops.h:23,
                    from include/linux/bitops.h:68,
                    from include/linux/thread_info.h:27,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/sh/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from net/ceph/ceph_san.c:1:
   net/ceph/ceph_san.c: In function 'get_log_cephsan':
>> include/linux/percpu-defs.h:219:59: error: invalid use of undefined type 'struct ceph_san_tls_logger'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                           ^
   include/linux/percpu-defs.h:262:9: note: in expansion of macro '__verify_pcpu_ptr'
     262 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:266:33: note: in expansion of macro 'per_cpu_ptr'
     266 | #define raw_cpu_ptr(ptr)        per_cpu_ptr(ptr, 0)
         |                                 ^~~~~~~~~~~
   include/linux/percpu-defs.h:267:33: note: in expansion of macro 'raw_cpu_ptr'
     267 | #define this_cpu_ptr(ptr)       raw_cpu_ptr(ptr)
         |                                 ^~~~~~~~~~~
   net/ceph/ceph_san.c:17:39: note: in expansion of macro 'this_cpu_ptr'
      17 |     struct ceph_san_tls_logger *tls = this_cpu_ptr(&ceph_san_tls);
         |                                       ^~~~~~~~~~~~
>> net/ceph/ceph_san.c:18:23: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      18 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |                       ^~
>> net/ceph/ceph_san.c:18:39: error: 'CEPH_SAN_MAX_LOGS' undeclared (first use in this function); did you mean 'CEPH_SAN_LOG'?
      18 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |                                       ^~~~~~~~~~~~~~~~~
         |                                       CEPH_SAN_LOG
   net/ceph/ceph_san.c:18:39: note: each undeclared identifier is reported only once for each function it appears in
   net/ceph/ceph_san.c:19:8: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      19 |     tls->logs[head_idx].pid = current->pid;
         |        ^~
   net/ceph/ceph_san.c:20:8: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      20 |     tls->logs[head_idx].ts = jiffies;
         |        ^~
   net/ceph/ceph_san.c:21:15: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      21 |     memcpy(tls->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
         |               ^~
   net/ceph/ceph_san.c:23:15: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      23 |     return tls->logs[head_idx].buf;
         |               ^~
>> net/ceph/ceph_san.c:18:9: warning: variable 'head_idx' set but not used [-Wunused-but-set-variable]
      18 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |         ^~~~~~~~
   net/ceph/ceph_san.c: At top level:
>> net/ceph/ceph_san.c:30:6: error: redefinition of 'cephsan_cleanup'
      30 | void cephsan_cleanup(void)
         |      ^~~~~~~~~~~~~~~
   In file included from net/ceph/ceph_san.c:6:
   include/linux/ceph/ceph_san.h:104:20: note: previous definition of 'cephsan_cleanup' with type 'void(void)'
     104 | static inline void cephsan_cleanup(void) {}
         |                    ^~~~~~~~~~~~~~~
>> net/ceph/ceph_san.c:37:5: error: redefinition of 'cephsan_init'
      37 | int cephsan_init(void)
         |     ^~~~~~~~~~~~
   include/linux/ceph/ceph_san.h:105:26: note: previous definition of 'cephsan_init' with type 'int(void)'
     105 | static inline int __init cephsan_init(void) { return 0; }
         |                          ^~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/preempt.h:10:
>> net/ceph/ceph_san.c:10:15: error: storage size of 'ceph_san_tls' isn't known
      10 | EXPORT_SYMBOL(ceph_san_tls);
         |               ^~~~~~~~~~~~
   include/linux/export.h:56:28: note: in definition of macro '__EXPORT_SYMBOL'
      56 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:68:41: note: in expansion of macro '_EXPORT_SYMBOL'
      68 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^~~~~~~~~~~~~~
   net/ceph/ceph_san.c:10:1: note: in expansion of macro 'EXPORT_SYMBOL'
      10 | EXPORT_SYMBOL(ceph_san_tls);
         | ^~~~~~~~~~~~~
>> net/ceph/ceph_san.c:10:15: error: storage size of 'ceph_san_tls' isn't known
      10 | EXPORT_SYMBOL(ceph_san_tls);
         |               ^~~~~~~~~~~~
   include/linux/export.h:56:28: note: in definition of macro '__EXPORT_SYMBOL'
      56 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:68:41: note: in expansion of macro '_EXPORT_SYMBOL'
      68 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^~~~~~~~~~~~~~
   net/ceph/ceph_san.c:10:1: note: in expansion of macro 'EXPORT_SYMBOL'
      10 | EXPORT_SYMBOL(ceph_san_tls);
         | ^~~~~~~~~~~~~
   net/ceph/ceph_san.c: In function 'get_log_cephsan':
   net/ceph/ceph_san.c:24:1: warning: control reaches end of non-void function [-Wreturn-type]
      24 | }
         | ^


vim +219 include/linux/percpu-defs.h

62fde54123fb64 Tejun Heo 2014-06-17  205  
9c28278a24c01c Tejun Heo 2014-06-17  206  /*
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  207   * __verify_pcpu_ptr() verifies @ptr is a percpu pointer without evaluating
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  208   * @ptr and is invoked once before a percpu area is accessed by all
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  209   * accessors and operations.  This is performed in the generic part of
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  210   * percpu and arch overrides don't need to worry about it; however, if an
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  211   * arch wants to implement an arch-specific percpu accessor or operation,
6fbc07bbe2b5a8 Tejun Heo 2014-06-17  212   * it may use __verify_pcpu_ptr() to verify the parameters.
9c28278a24c01c Tejun Heo 2014-06-17  213   *
9c28278a24c01c Tejun Heo 2014-06-17  214   * + 0 is required in order to convert the pointer type from a
9c28278a24c01c Tejun Heo 2014-06-17  215   * potential array type to a pointer to a single item of the array.
9c28278a24c01c Tejun Heo 2014-06-17  216   */
eba117889ac444 Tejun Heo 2014-06-17  217  #define __verify_pcpu_ptr(ptr)						\
eba117889ac444 Tejun Heo 2014-06-17  218  do {									\
9c28278a24c01c Tejun Heo 2014-06-17 @219  	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
9c28278a24c01c Tejun Heo 2014-06-17  220  	(void)__vpp_verify;						\
9c28278a24c01c Tejun Heo 2014-06-17  221  } while (0)
9c28278a24c01c Tejun Heo 2014-06-17  222  

:::::: The code at line 219 was first introduced by commit
:::::: 9c28278a24c01c0073fb89e53c1d2a605ab9587d percpu: reorder macros in percpu header files

:::::: TO: Tejun Heo <tj@kernel.org>
:::::: CC: Tejun Heo <tj@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

