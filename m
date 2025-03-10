Return-Path: <ceph-devel+bounces-2878-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 339B3A5A362
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Mar 2025 19:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B969A1888684
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Mar 2025 18:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813D822D7AF;
	Mon, 10 Mar 2025 18:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MN8xwxNv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567F4EEAA
	for <ceph-devel@vger.kernel.org>; Mon, 10 Mar 2025 18:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741632402; cv=none; b=BA2Syey6s7RGCsDxZ7N/EzKS/iS0Jt0dqOAqLXvigCDdhKrM7pjgznDO5DuhBrHN8C3I08viykhBsyzY9uZQNFZskMUMWHuHPu3QxNIqHK+2mMtLwZeIirBbvKWwY3PebpRUkuErCG2RMxPAeTPNp+8N3nT1c/12V8/0bqhL+NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741632402; c=relaxed/simple;
	bh=XLXDVkewlJgzZiw0tmrQtMSwGaUw/YB5o41kad7bk88=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tabXM1TxssQ3nVhgXGMI8OXYMwaCBE01w55Jbygj4QOvJpvLD0EKMlKND+b+Lx+IHYsj2ZXmW1Qk1Mbe4evvckxDB5Kf9OxxzEoutBCFJRh/JoWeh0o4YyuAjoMRWAhmsG7sRRwVMaNZcRTi77UoknUp4jhJXdJjXKc4ESTnbPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MN8xwxNv; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741632400; x=1773168400;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=XLXDVkewlJgzZiw0tmrQtMSwGaUw/YB5o41kad7bk88=;
  b=MN8xwxNv+xEnT2lmtZOBLtYFj3uUbPM59I+QWEiELzZ5EfA92vLUlSE8
   zwlhMTYvuRYDgO4CvyJm7ft0JZsU9iIDNV+8EShEZ9HVZ1Z0zJE5f6MKO
   xKnFtJSxjIQ27f7TRwy9UP1bVaLHEAsA+JAFZGbrmwpoNFqkPC6wFJ7s+
   /zMzQOtHwgxHKyl3ONa7A+XQgKFrzLcE73GiufTh6NTMRfkIbCGOK04Px
   vmDgom9XewwttZsEKHu09bNwQcnS1PbYspKcg4ZBlYesupEfGEpdvSotk
   D7EATVmFDWN3vIncnj5dyV2Nb6GRzedaJfCtFVYBXBHDVT+oyYtONSWeM
   g==;
X-CSE-ConnectionGUID: dqRU5ftST7SnTd+SWL4P5A==
X-CSE-MsgGUID: XzvG5GgATRK22O0cERy81g==
X-IronPort-AV: E=McAfee;i="6700,10204,11369"; a="42494054"
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="42494054"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 11:46:39 -0700
X-CSE-ConnectionGUID: Uip3k8ROSZmSZeWpNULX9w==
X-CSE-MsgGUID: Iid1iY5ERnGgxI/Cz0QllQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="120004183"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 10 Mar 2025 11:46:38 -0700
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tri96-0005z8-0G;
	Mon, 10 Mar 2025 18:46:36 +0000
Date: Tue, 11 Mar 2025 02:46:17 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 4/6] net/ceph/ceph_san.c:22:19: sparse:
 sparse: symbol 'ceph_san_log_128_cache' was not declared. Should it be
 static?
Message-ID: <202503110213.fV7UzFoR-lkp@intel.com>
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
commit: 284eb81c9d23609f54d9e015ce2c40076e8d8a87 [4/6] TLS logger
config: mips-randconfig-r123-20250310 (https://download.01.org/0day-ci/archive/20250311/202503110213.fV7UzFoR-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 14.2.0
reproduce: (https://download.01.org/0day-ci/archive/20250311/202503110213.fV7UzFoR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503110213.fV7UzFoR-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/ceph/ceph_san.c:22:19: sparse: sparse: symbol 'ceph_san_log_128_cache' was not declared. Should it be static?
>> net/ceph/ceph_san.c:23:19: sparse: sparse: symbol 'ceph_san_log_256_cache' was not declared. Should it be static?
>> net/ceph/ceph_san.c:25:19: sparse: sparse: symbol 'ceph_san_tls_logger_cache' was not declared. Should it be static?
>> net/ceph/ceph_san.c:144:42: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_percore_logger * @@
   net/ceph/ceph_san.c:144:42: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:144:42: sparse:     got struct ceph_san_percore_logger *
   net/ceph/ceph_san.c:183:14: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_percore_logger * @@
   net/ceph/ceph_san.c:183:14: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:183:14: sparse:     got struct ceph_san_percore_logger *
   net/ceph/ceph_san.c:243:14: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_percore_logger * @@
   net/ceph/ceph_san.c:243:14: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:243:14: sparse:     got struct ceph_san_percore_logger *

vim +/ceph_san_log_128_cache +22 net/ceph/ceph_san.c

    20	
    21	/* Memory caches for log entries */
  > 22	struct kmem_cache *ceph_san_log_128_cache;
  > 23	struct kmem_cache *ceph_san_log_256_cache;
    24	
  > 25	struct kmem_cache *ceph_san_tls_logger_cache;
    26	
    27	static inline void *cephsan_pagefrag_get_ptr(struct cephsan_pagefrag *pf, u64 val);
    28	/* The definitions for struct ceph_san_log_entry and struct ceph_san_tls_logger
    29	 * have been moved to cephsan.h (under CONFIG_DEBUG_FS) to avoid duplication.
    30	 */
    31	
    32	
    33	/* Release function for TLS storage */
    34	static void ceph_san_tls_release(void *ptr)
    35	{
    36	    struct tls_ceph_san_context *context = ptr;
    37	    if (!context)
    38	        return;
    39	
    40	    /* Remove from global list with lock protection */
    41	    spin_lock(&g_ceph_san_contexts_lock);
    42	    list_del(&context->list);
    43	    spin_unlock(&g_ceph_san_contexts_lock);
    44	
    45	    /* Free all log entries */
    46	        int head_idx = context->logger.head_idx & (CEPH_SAN_MAX_LOGS - 1);
    47	        int tail_idx = (head_idx + 1) & (CEPH_SAN_MAX_LOGS - 1);
    48	
    49	    for (int i = tail_idx; (i & (CEPH_SAN_MAX_LOGS - 1)) != head_idx; i++) {
    50	        struct ceph_san_log_entry_tls *entry = &context->logger.logs[i & (CEPH_SAN_MAX_LOGS - 1)];
    51	        if (entry->buf) {
    52	            if (entry->ts & 0x1)
    53	                    kmem_cache_free(ceph_san_log_256_cache, entry->buf);
    54				else
    55	                    kmem_cache_free(ceph_san_log_128_cache, entry->buf);
    56				entry->buf = NULL;
    57			}
    58		}
    59	
    60	    kmem_cache_free(ceph_san_tls_logger_cache, context);
    61	}
    62	
    63	static struct tls_ceph_san_context *get_cephsan_context(void) {
    64	    struct tls_ceph_san_context *context;
    65	
    66	    context = current->tls.state;
    67	    if (context)
    68	        return context;
    69	
    70	    context = kmem_cache_alloc(ceph_san_tls_logger_cache, GFP_KERNEL);
    71		if (!context)
    72			return NULL;
    73	
    74		context->logger.pid = current->pid;
    75		memcpy(context->logger.comm, current->comm, TASK_COMM_LEN);
    76	
    77	     /* Initialize list entry */
    78	    INIT_LIST_HEAD(&context->list);
    79	
    80	    /* Add to global list with lock protection */
    81	    spin_lock(&g_ceph_san_contexts_lock);
    82	    list_add(&context->list, &g_ceph_san_contexts);
    83	    spin_unlock(&g_ceph_san_contexts_lock);
    84	
    85	    current->tls.state = context;
    86	    current->tls.release = ceph_san_tls_release;
    87	    return context;
    88	}
    89	
    90	void log_cephsan_tls(char *buf) {
    91	    /* Use the task's TLS storage */
    92	    int len = strlen(buf);
    93	    struct tls_ceph_san_context *ctx;
    94	    struct ceph_san_tls_logger *logger;
    95	    char *new_buf;
    96	
    97	    ctx = get_cephsan_context();
    98	    if (!ctx)
    99	        return;
   100	
   101	    logger = &ctx->logger;
   102	
   103	    /* Log the message */
   104	    int head_idx = logger->head_idx + 1 & (CEPH_SAN_MAX_LOGS - 1);
   105	    struct ceph_san_log_entry_tls *entry = &logger->logs[head_idx];
   106	
   107	    /* Only free and reallocate if sizes differ */
   108	    if (!entry->buf || (entry->ts & 0x1) != (len > LOG_BUF_SMALL)) {
   109	        if (entry->buf) {
   110	            if (entry->ts & 0x1)
   111	                kmem_cache_free(ceph_san_log_256_cache, entry->buf);
   112	            else
   113	                kmem_cache_free(ceph_san_log_128_cache, entry->buf);
   114	            entry->buf = NULL;
   115	        }
   116	
   117	        /* Allocate new buffer from appropriate cache */
   118	        if (len <= LOG_BUF_SMALL) {
   119	            new_buf = kmem_cache_alloc(ceph_san_log_128_cache, GFP_KERNEL);
   120				entry->ts = jiffies | 0x0;
   121	        } else {
   122	            new_buf = kmem_cache_alloc(ceph_san_log_256_cache, GFP_KERNEL);
   123				entry->ts = jiffies | 0x1;
   124	        }
   125	    } else {
   126	        /* Reuse existing buffer since size category hasn't changed */
   127	        new_buf = entry->buf;
   128	    }
   129	
   130	    if (!new_buf)
   131	        return;
   132	
   133	    buf[len-1] = '\0';
   134	    entry->buf = new_buf;
   135	    memcpy(entry->buf, buf, len);
   136	
   137	    logger->head_idx = head_idx;
   138	}
   139	
   140	static void log_cephsan_percore(char *buf) {
   141	    /* Use the per-core TLS logger */
   142	    u64 buf_idx;
   143	    int len = strlen(buf);
 > 144	    struct ceph_san_percore_logger *pc = this_cpu_ptr(&ceph_san_percore);
   145	    struct cephsan_pagefrag *pf = this_cpu_ptr(&ceph_san_pagefrag);
   146	
   147	    int head_idx = pc->head_idx + 1 & (CEPH_SAN_MAX_LOGS - 1);
   148	    int pre_len = pc->logs[head_idx].len;
   149	
   150	    buf[len-1] = '\0';
   151	    pc->logs[head_idx].pid = current->pid;
   152	    pc->logs[head_idx].ts = jiffies;
   153	    memcpy(pc->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
   154	
   155	    cephsan_pagefrag_free(pf, pre_len);
   156	    pc->logs[head_idx].len = 0;
   157	
   158	    buf_idx = cephsan_pagefrag_alloc(pf, len);
   159	    if (buf_idx) {
   160	        pc->head_idx = head_idx;
   161	        pc->histogram.counters[len >> 3]++;
   162	        pc->logs[head_idx].len = len;
   163	        pc->logs[head_idx].buf = cephsan_pagefrag_get_ptr(pf, buf_idx);
   164	        memcpy(pc->logs[head_idx].buf, buf, len);
   165	    }
   166	}
   167	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

