Return-Path: <ceph-devel+bounces-2877-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F26A59C83
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Mar 2025 18:12:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 767983A911D
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Mar 2025 17:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42945231A57;
	Mon, 10 Mar 2025 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aKxrglvh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41381231A3F
	for <ceph-devel@vger.kernel.org>; Mon, 10 Mar 2025 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626667; cv=none; b=hixeAjESgYHtmdWUHx1zqrqbzwaQb4vGTgxTdcwLpcDf3jFG5I8Ef/faLa2aJ/QDsiUeb5652Cfz/lt+MHVbVJAfx6RZBQ/MszURBTw78lEQUy0zCrasxTA59T6Rrzf3GrMlsK5j0OAsdR8TKF1QPacAvJ4rb3Yl3E5H0rCWEAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626667; c=relaxed/simple;
	bh=np1RlJ0dj67ubCzPw+iTKg8/NU4oqPdl/P2mryoWguk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cC8AqwG2ZALn3wT7dTkRAmfHGZZ0Cw/dRbefa9IF1ySHwWljcRVBO47Mpg8BOpgND98gKLmjx8tP1oo7vm+ILD2/m7RpVNIwiHzdyt7VwVubsmAAJzRbHdTBbhNETHYr0crQl0u7et1tC0T1QCceYJA8ncBSE6fQqpGRsdB8heU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aKxrglvh; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741626665; x=1773162665;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=np1RlJ0dj67ubCzPw+iTKg8/NU4oqPdl/P2mryoWguk=;
  b=aKxrglvh0bBJpvl1cOmBqytFShlh3f2legsTtW1YsxH2+15oKAQP7njw
   in6c1NE4rUfrqYhcrsyin6KfFu0ACIboVfOsxO/0LnsUq3PHaO+b6orsv
   HvZJKZr/T1geX12W+SNtEhr+TmwgaAZUFLmui7LfSmMjAmeGeSGATEktI
   5rApMWqEs0yeR42EKtvYL7u4ChOW+zTVA9JsTiUD32VwR2Z0R3a1ruwb7
   Z4S9Qreotcon3oyYGGlZSwWH6Np6xdzKeioZ2Wm7v0wpXonptPC+ydFCN
   6A0D5cXLuAbjgK0Y5cjK+6NGMY747XISNoF0f+etxDJatUxK/Glq4LY5E
   A==;
X-CSE-ConnectionGUID: fV4EzRM4T4KG7N44ionuVg==
X-CSE-MsgGUID: kajNMbkNROqL/4/1mvWK6Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11369"; a="53263936"
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="53263936"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 10:11:04 -0700
X-CSE-ConnectionGUID: jQut7fI5T7KyCvnxB4uQeg==
X-CSE-MsgGUID: zt/RVzolQqegzC27Qf+A5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="150849866"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 10 Mar 2025 10:11:03 -0700
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1trgeW-0004WB-2N;
	Mon, 10 Mar 2025 17:10:57 +0000
Date: Tue, 11 Mar 2025 01:10:13 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 6/6] net/ceph/ceph_san.c:40:5: warning: this
 'if' clause does not guard...
Message-ID: <202503110127.na2HCVqj-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   8bb4b4a8adc916ebe57638af949152b069d7b58a
commit: 8bb4b4a8adc916ebe57638af949152b069d7b58a [6/6] cephsan: bug fixes
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20250311/202503110127.na2HCVqj-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250311/202503110127.na2HCVqj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503110127.na2HCVqj-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:99,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/linux/spinlock.h:60,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from net/ceph/ceph_san.c:1:
   net/ceph/ceph_san.c: In function 'ceph_san_tls_release':
>> include/linux/kern_levels.h:5:25: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type 'unsigned int' [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:473:25: note: in definition of macro 'printk_index_wrap'
     473 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:544:9: note: in expansion of macro 'printk'
     544 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
      11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:544:16: note: in expansion of macro 'KERN_ERR'
     544 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~
   net/ceph/ceph_san.c:41:13: note: in expansion of macro 'pr_err'
      41 |             pr_err("sig is wrong %p %llx != %llx", context, context->sig, CEPH_SAN_SIG);
         |             ^~~~~~
>> net/ceph/ceph_san.c:40:5: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
      40 |     if (context->sig != CEPH_SAN_SIG)
         |     ^~
   net/ceph/ceph_san.c:42:13: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
      42 |             return;
         |             ^~~~~~
   net/ceph/ceph_san.c: In function 'log_cephsan_tls':
   net/ceph/ceph_san.c:112:37: warning: suggest parentheses around '+' in operand of '&' [-Wparentheses]
     112 |     int head_idx = logger->head_idx + 1 & (CEPH_SAN_MAX_LOGS - 1);
         |                    ~~~~~~~~~~~~~~~~~^~~
   net/ceph/ceph_san.c: In function 'log_cephsan_percore':
   net/ceph/ceph_san.c:155:33: warning: suggest parentheses around '+' in operand of '&' [-Wparentheses]
     155 |     int head_idx = pc->head_idx + 1 & (CEPH_SAN_MAX_LOGS - 1);
         |                    ~~~~~~~~~~~~~^~~
--
   In file included from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:99,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/linux/spinlock.h:60,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from ceph_san.c:1:
   ceph_san.c: In function 'ceph_san_tls_release':
>> include/linux/kern_levels.h:5:25: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type 'unsigned int' [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:473:25: note: in definition of macro 'printk_index_wrap'
     473 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:544:9: note: in expansion of macro 'printk'
     544 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
      11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:544:16: note: in expansion of macro 'KERN_ERR'
     544 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~
   ceph_san.c:41:13: note: in expansion of macro 'pr_err'
      41 |             pr_err("sig is wrong %p %llx != %llx", context, context->sig, CEPH_SAN_SIG);
         |             ^~~~~~
   ceph_san.c:40:5: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
      40 |     if (context->sig != CEPH_SAN_SIG)
         |     ^~
   ceph_san.c:42:13: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
      42 |             return;
         |             ^~~~~~
   ceph_san.c: In function 'log_cephsan_tls':
   ceph_san.c:112:37: warning: suggest parentheses around '+' in operand of '&' [-Wparentheses]
     112 |     int head_idx = logger->head_idx + 1 & (CEPH_SAN_MAX_LOGS - 1);
         |                    ~~~~~~~~~~~~~~~~~^~~
   ceph_san.c: In function 'log_cephsan_percore':
   ceph_san.c:155:33: warning: suggest parentheses around '+' in operand of '&' [-Wparentheses]
     155 |     int head_idx = pc->head_idx + 1 & (CEPH_SAN_MAX_LOGS - 1);
         |                    ~~~~~~~~~~~~~^~~


vim +/if +40 net/ceph/ceph_san.c

    26	
    27	static inline void *cephsan_pagefrag_get_ptr(struct cephsan_pagefrag *pf, u64 val);
    28	/* The definitions for struct ceph_san_log_entry and struct ceph_san_tls_logger
    29	 * have been moved to cephsan.h (under CONFIG_DEBUG_FS) to avoid duplication.
    30	 */
    31	
    32	#define CEPH_SAN_SIG 0xDEADC0DE
    33	/* Release function for TLS storage */
    34	static void ceph_san_tls_release(void *ptr)
    35	{
    36	    struct tls_ceph_san_context *context = ptr;
    37	    if (!context)
    38	        return;
    39	
  > 40	    if (context->sig != CEPH_SAN_SIG)
  > 41		    pr_err("sig is wrong %p %llx != %llx", context, context->sig, CEPH_SAN_SIG);
    42		    return;
    43	
    44	    /* Remove from global list with lock protection */
    45	    spin_lock(&g_ceph_san_contexts_lock);
    46	    list_del(&context->list);
    47	    spin_unlock(&g_ceph_san_contexts_lock);
    48	
    49	    /* Free all log entries */
    50	        int head_idx = context->logger.head_idx & (CEPH_SAN_MAX_LOGS - 1);
    51	        int tail_idx = (head_idx + 1) & (CEPH_SAN_MAX_LOGS - 1);
    52	
    53	    for (int i = tail_idx; (i & (CEPH_SAN_MAX_LOGS - 1)) != head_idx; i++) {
    54	        struct ceph_san_log_entry_tls *entry = &context->logger.logs[i & (CEPH_SAN_MAX_LOGS - 1)];
    55	        if (entry->buf) {
    56	            if (entry->ts & 0x1)
    57	                    kmem_cache_free(ceph_san_log_256_cache, entry->buf);
    58				else
    59	                    kmem_cache_free(ceph_san_log_128_cache, entry->buf);
    60				entry->buf = NULL;
    61			}
    62		}
    63	
    64	    kmem_cache_free(ceph_san_tls_logger_cache, context);
    65	}
    66	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

