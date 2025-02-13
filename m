Return-Path: <ceph-devel+bounces-2657-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75CAEA33EAF
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 13:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CB9C188EB26
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 12:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD53521D3F9;
	Thu, 13 Feb 2025 12:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iupp5mC9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603F121D3EB
	for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2025 12:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739448029; cv=none; b=T74iWcyRGVnlGQE8BTmiYlQ1O+H4syzaPRF4bJv+9bEFRtYqsEiIpYKXVJFGCEjLcZ2x40HTasUDbhcAfHxb8bs0JqKs2FY3GiJ3X+A3kdutFG2uBqHLbggzCMX8L3xUd8R1FFksxm18vxOSCNtdwSfmNZAJQvPWtsyI2zOtuus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739448029; c=relaxed/simple;
	bh=bopwz3s7r20XpyDQU9by9zeitrsMagvWNR/wNXeJOj4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=K6tB11xxJ9dL15pD3zEB9/yxq8XI+fZpJOQ4RL6bal8IjDgHBn+xBvOpUTEsS1LfLO2TDBn9txcuo3nusaTHijUDBpJVNpGRLpm4lCHZDf6oDpskQI0+VnkoxWC4V2SNAP26C3M0wQrgk7+zaV549xqMtpwlN0/6+U84bx6WCxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iupp5mC9; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739448027; x=1770984027;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=bopwz3s7r20XpyDQU9by9zeitrsMagvWNR/wNXeJOj4=;
  b=Iupp5mC9+ZOCeD61s4vi3Cm9LX0SKW59tCEIBfgNjtaelqQQkUCuW9xG
   6GJdN82yZT9xxJqTCQPHUINLfgi893ncXM7a1+MZQJ1bJr5jXiorjv5rA
   CXSLWwBX0pfjwbxbWfabc1i0o8dl/aWpjx7tcRpKLpezX3FnOP5PhpS7o
   vYaOU4sT0FfF2hsX1Wj6AAhwAP4p0wuKf/zYawOmsX0+Sz/OCTgHJqiFL
   r+4x9mkWM5bLihIRxL5L8ZJnQI4Fct7vwbhTGtyySJJSpyWqFYhUlxUhD
   M4OPpOD/hd3MIwumDvg5hO7187R4jMeATYDZxe7s2L+pgBqCF1P4o2nDD
   g==;
X-CSE-ConnectionGUID: mmJe/9IrSOyd3JxVjLHpIg==
X-CSE-MsgGUID: r5rygtpvRY2M1RwZMNaGkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="51541331"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="51541331"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 04:00:27 -0800
X-CSE-ConnectionGUID: akSZKJSkSnyaloW8IaCGLg==
X-CSE-MsgGUID: 8p5odIoaQ3OIklNoqUFi7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="113301655"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 13 Feb 2025 04:00:25 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tiXtH-00170X-0S;
	Thu, 13 Feb 2025 12:00:23 +0000
Date: Thu, 13 Feb 2025 19:59:57 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 8/13] net/ceph/ceph_san.c:39:100: error:
 invalid application of 'sizeof' to incomplete type 'struct
 ceph_san_log_entry'
Message-ID: <202502131947.rSVtdBrv-lkp@intel.com>
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
commit: f820734471f23bb695f77190c893468887acb9a5 [8/13] ceph_san: use alloc_pages
config: sh-randconfig-001-20250213 (https://download.01.org/0day-ci/archive/20250213/202502131947.rSVtdBrv-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250213/202502131947.rSVtdBrv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502131947.rSVtdBrv-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/ceph/ceph_san.c:16:7: warning: no previous prototype for 'get_log_cephsan' [-Wmissing-prototypes]
      16 | char *get_log_cephsan(void) {
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
   include/linux/percpu-defs.h:219:59: error: invalid use of undefined type 'struct ceph_san_tls_logger'
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
   net/ceph/ceph_san.c:18:39: note: in expansion of macro 'this_cpu_ptr'
      18 |     struct ceph_san_tls_logger *tls = this_cpu_ptr(&ceph_san_tls);
         |                                       ^~~~~~~~~~~~
   net/ceph/ceph_san.c:19:23: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      19 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |                       ^~
   net/ceph/ceph_san.c:19:39: error: 'CEPH_SAN_MAX_LOGS' undeclared (first use in this function); did you mean 'CEPH_SAN_LOG'?
      19 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |                                       ^~~~~~~~~~~~~~~~~
         |                                       CEPH_SAN_LOG
   net/ceph/ceph_san.c:19:39: note: each undeclared identifier is reported only once for each function it appears in
   net/ceph/ceph_san.c:20:8: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      20 |     tls->logs[head_idx].pid = current->pid;
         |        ^~
   net/ceph/ceph_san.c:21:8: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      21 |     tls->logs[head_idx].ts = jiffies;
         |        ^~
   net/ceph/ceph_san.c:22:15: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      22 |     memcpy(tls->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
         |               ^~
   net/ceph/ceph_san.c:24:15: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      24 |     return tls->logs[head_idx].buf;
         |               ^~
   net/ceph/ceph_san.c:19:9: warning: variable 'head_idx' set but not used [-Wunused-but-set-variable]
      19 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |         ^~~~~~~~
   net/ceph/ceph_san.c: At top level:
   net/ceph/ceph_san.c:31:6: error: redefinition of 'cephsan_cleanup'
      31 | void cephsan_cleanup(void)
         |      ^~~~~~~~~~~~~~~
   In file included from net/ceph/ceph_san.c:6:
   include/linux/ceph/ceph_san.h:105:20: note: previous definition of 'cephsan_cleanup' with type 'void(void)'
     105 | static inline void cephsan_cleanup(void) {}
         |                    ^~~~~~~~~~~~~~~
   net/ceph/ceph_san.c: In function 'cephsan_cleanup':
   include/linux/percpu-defs.h:219:59: error: invalid use of undefined type 'struct ceph_san_tls_logger'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                           ^
   include/linux/percpu-defs.h:262:9: note: in expansion of macro '__verify_pcpu_ptr'
     262 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   net/ceph/ceph_san.c:37:23: note: in expansion of macro 'per_cpu_ptr'
      37 |                 tls = per_cpu_ptr(&ceph_san_tls, cpu);
         |                       ^~~~~~~~~~~
   net/ceph/ceph_san.c:38:24: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      38 |                 if (tls->pages) {
         |                        ^~
   net/ceph/ceph_san.c:39:54: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      39 |                         free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                      ^~
   net/ceph/ceph_san.c:39:73: error: 'CEPH_SAN_MAX_LOGS' undeclared (first use in this function); did you mean 'CEPH_SAN_LOG'?
      39 |                         free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                         ^~~~~~~~~~~~~~~~~
         |                                                                         CEPH_SAN_LOG
>> net/ceph/ceph_san.c:39:100: error: invalid application of 'sizeof' to incomplete type 'struct ceph_san_log_entry'
      39 |                         free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                                                    ^~~~~~
   net/ceph/ceph_san.c:40:28: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      40 |                         tls->pages = NULL;
         |                            ^~
   net/ceph/ceph_san.c: At top level:
   net/ceph/ceph_san.c:48:5: error: redefinition of 'cephsan_init'
      48 | int cephsan_init(void)
         |     ^~~~~~~~~~~~
   include/linux/ceph/ceph_san.h:106:26: note: previous definition of 'cephsan_init' with type 'int(void)'
     106 | static inline int __init cephsan_init(void) { return 0; }
         |                          ^~~~~~~~~~~~
   net/ceph/ceph_san.c: In function 'cephsan_init':
   include/linux/percpu-defs.h:219:59: error: invalid use of undefined type 'struct ceph_san_tls_logger'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                           ^
   include/linux/percpu-defs.h:262:9: note: in expansion of macro '__verify_pcpu_ptr'
     262 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~
   net/ceph/ceph_san.c:54:23: note: in expansion of macro 'per_cpu_ptr'
      54 |                 tls = per_cpu_ptr(&ceph_san_tls, cpu);
         |                       ^~~~~~~~~~~
   net/ceph/ceph_san.c:55:20: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                    ^~
   In file included from include/linux/percpu.h:5,
                    from include/linux/percpu_counter.h:14,
                    from include/linux/mm_types.h:21,
                    from include/linux/mmzone.h:22:
   net/ceph/ceph_san.c:55:64: error: 'CEPH_SAN_MAX_LOGS' undeclared (first use in this function); did you mean 'CEPH_SAN_LOG'?
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                ^~~~~~~~~~~~~~~~~
   include/linux/alloc_tag.h:228:16: note: in definition of macro 'alloc_hooks_tag'
     228 |         typeof(_do_alloc) _res = _do_alloc;                             \
         |                ^~~~~~~~~
   include/linux/gfp.h:333:49: note: in expansion of macro 'alloc_hooks'
     333 | #define alloc_pages(...)                        alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   net/ceph/ceph_san.c:55:30: note: in expansion of macro 'alloc_pages'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                              ^~~~~~~~~~~
   net/ceph/ceph_san.c:55:91: error: invalid application of 'sizeof' to incomplete type 'struct ceph_san_log_entry'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                                           ^~~~~~
   include/linux/alloc_tag.h:228:16: note: in definition of macro 'alloc_hooks_tag'
     228 |         typeof(_do_alloc) _res = _do_alloc;                             \
         |                ^~~~~~~~~
   include/linux/gfp.h:333:49: note: in expansion of macro 'alloc_hooks'
     333 | #define alloc_pages(...)                        alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   net/ceph/ceph_san.c:55:30: note: in expansion of macro 'alloc_pages'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                              ^~~~~~~~~~~
   net/ceph/ceph_san.c:55:91: error: invalid application of 'sizeof' to incomplete type 'struct ceph_san_log_entry'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                                           ^~~~~~
   include/linux/alloc_tag.h:228:34: note: in definition of macro 'alloc_hooks_tag'
     228 |         typeof(_do_alloc) _res = _do_alloc;                             \
         |                                  ^~~~~~~~~
   include/linux/gfp.h:333:49: note: in expansion of macro 'alloc_hooks'
     333 | #define alloc_pages(...)                        alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   net/ceph/ceph_san.c:55:30: note: in expansion of macro 'alloc_pages'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                              ^~~~~~~~~~~
   net/ceph/ceph_san.c:56:25: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      56 |                 if (!tls->pages) {
         |                         ^~
   net/ceph/ceph_san.c:60:20: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      60 |                 tls->logs = (struct ceph_san_log_entry *)page_address(tls->pages);
         |                    ^~
   In file included from net/ceph/ceph_san.c:7:
   net/ceph/ceph_san.c:60:74: error: invalid use of undefined type 'struct ceph_san_tls_logger'
      60 |                 tls->logs = (struct ceph_san_log_entry *)page_address(tls->pages);
         |                                                                          ^~
   include/linux/mm.h:2254:48: note: in definition of macro 'page_address'
    2254 | #define page_address(page) lowmem_page_address(page)
         |                                                ^~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/preempt.h:10:
   net/ceph/ceph_san.c: At top level:
   net/ceph/ceph_san.c:11:15: error: storage size of 'ceph_san_tls' isn't known
      11 | EXPORT_SYMBOL(ceph_san_tls);
         |               ^~~~~~~~~~~~
   include/linux/export.h:56:28: note: in definition of macro '__EXPORT_SYMBOL'
      56 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:68:41: note: in expansion of macro '_EXPORT_SYMBOL'
      68 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^~~~~~~~~~~~~~
   net/ceph/ceph_san.c:11:1: note: in expansion of macro 'EXPORT_SYMBOL'
      11 | EXPORT_SYMBOL(ceph_san_tls);
         | ^~~~~~~~~~~~~
   net/ceph/ceph_san.c:11:15: error: storage size of 'ceph_san_tls' isn't known
      11 | EXPORT_SYMBOL(ceph_san_tls);
         |               ^~~~~~~~~~~~
   include/linux/export.h:56:28: note: in definition of macro '__EXPORT_SYMBOL'
      56 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:68:41: note: in expansion of macro '_EXPORT_SYMBOL'


vim +39 net/ceph/ceph_san.c

    27	
    28	/* Cleanup function to free all TLS logger objects.
    29	 * Call this at module exit to free allocated TLS loggers.
    30	 */
    31	void cephsan_cleanup(void)
    32	{
    33		int cpu;
    34		struct ceph_san_tls_logger *tls;
    35	
    36		for_each_possible_cpu(cpu) {
    37			tls = per_cpu_ptr(&ceph_san_tls, cpu);
    38			if (tls->pages) {
  > 39				free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
    40				tls->pages = NULL;
    41			}
    42		}
    43	}
    44	EXPORT_SYMBOL(cephsan_cleanup);
    45	/* Initialize the Ceph SAN logging infrastructure.
    46	 * Call this at module init to set up the global list and lock.
    47	 */
    48	int cephsan_init(void)
    49	{
    50		int cpu;
    51		struct ceph_san_tls_logger *tls;
    52	
    53		for_each_possible_cpu(cpu) {
    54			tls = per_cpu_ptr(&ceph_san_tls, cpu);
    55			tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
    56			if (!tls->pages) {
    57				pr_err("Failed to allocate TLS logs for CPU %d\n", cpu);
    58				return -ENOMEM;
    59			}
    60			tls->logs = (struct ceph_san_log_entry *)page_address(tls->pages);
    61		}
    62		return 0;
    63	}
    64	EXPORT_SYMBOL(cephsan_init);
    65	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

