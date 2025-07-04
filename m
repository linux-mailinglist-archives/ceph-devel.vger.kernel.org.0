Return-Path: <ceph-devel+bounces-3268-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC1BAF9C4F
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Jul 2025 00:31:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B458C7A4931
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jul 2025 22:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0F5289819;
	Fri,  4 Jul 2025 22:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RzHoH0Vu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A9E2E3719
	for <ceph-devel@vger.kernel.org>; Fri,  4 Jul 2025 22:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751668312; cv=none; b=nFeW53A8QBDT0NKJ7scpo8q3h8PEhYO5HM9A0jI0ppymewbsHxTTKgjqQyqBWY670EaBP0aRz3/TMFK5ZsS7jWAsb7z8/xBpZ+JUcbk8FPOXQj3+8Zj4Z6KblJccWLOzgmBKqfc8p25AyEHtRI+FYf8eJB/2DEWzrsv3WZD7d5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751668312; c=relaxed/simple;
	bh=PxYBPboDRasXzW6Hx07ve0Ia+g8XeliZMeZoLQ9Ie7w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Nn4qEnKF5ISZHZMR7k6YNt7r0AwEOFHCaukXrnUp/M83+iwWohyuxwJf8ZzcMwuI/l0d4z/knBSZjKi1gxYxup0oR41cZ/PeAWfQyMKf1EWaQ/6ydkZ79ImG6PDV3haG5TYNZKZbnuB7slJIfNR8Lbac6Rq99sXyOuhuGHVsfAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RzHoH0Vu; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751668310; x=1783204310;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=PxYBPboDRasXzW6Hx07ve0Ia+g8XeliZMeZoLQ9Ie7w=;
  b=RzHoH0VuEpXT2VB4CxAjJ5rVFdp4HMbizPAP0GuuraXd9vSjwwX7SYNa
   IZKVaQ+nRiQjKURmwTJ13YOnFvcRZuXfw9gwzVbyQju8Ih7bVWuoxIeqA
   2bEjRmARAtP1+moyx2oBJTAbC2whPXXhW+ClCsGVkzTR6bN1SLG7Haw3g
   qq3MZmtgY/9Md+9pIpcAW62SZHl2v2ejLRxnGJVuPlokcJDqv+NPIkPik
   hadJ0tPNW1MPdNIKQ1TYchuh9237Gic2TkXIfCfEtq6KRsxcjq50UMrJ4
   INKPYILmPrMERGrgbJVGUzSsb9YUw2BGikwtiE1p5h5SNW/6wQzRqinHX
   w==;
X-CSE-ConnectionGUID: 3QixaR70RbGq9DV62OpwEA==
X-CSE-MsgGUID: 4WzLUWEhRPWpjf7o3+5IDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11484"; a="53214352"
X-IronPort-AV: E=Sophos;i="6.16,288,1744095600"; 
   d="scan'208";a="53214352"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 15:31:49 -0700
X-CSE-ConnectionGUID: jyE4BRSUSBmistWw+Nt/Bw==
X-CSE-MsgGUID: HnvsKqZgQlaT/ONBnsWL7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,288,1744095600"; 
   d="scan'208";a="154810538"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 04 Jul 2025 15:31:47 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uXowb-00047T-1k;
	Fri, 04 Jul 2025 22:31:45 +0000
Date: Sat, 5 Jul 2025 06:31:22 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:binary_tracing 2/4] net/ceph/ceph_san_logger.c:508:21:
 sparse: sparse: incorrect type in initializer (different address spaces)
Message-ID: <202507050653.f2vZWkeo-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git binary_tracing
head:   242b3aa593381c5ed2f425dbfb145bf7ca42e1fc
commit: 8a1cb95e58001067ea33908f1762ca31d6f93b69 [2/4] ceph_san code
config: x86_64-randconfig-r122-20250704 (https://download.01.org/0day-ci/archive/20250705/202507050653.f2vZWkeo-lkp@intel.com/config)
compiler: clang version 20.1.7 (https://github.com/llvm/llvm-project 6146a88f60492b520a36f8f8f3231e15f3cc6082)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250705/202507050653.f2vZWkeo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507050653.f2vZWkeo-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/ceph/ceph_san_logger.c:508:21: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_tls_ctx [noderef] __percpu ** @@
   net/ceph/ceph_san_logger.c:508:21: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san_logger.c:508:21: sparse:     got struct ceph_san_tls_ctx [noderef] __percpu **
>> net/ceph/ceph_san_logger.c:508:55: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/ceph/ceph_san_logger.c:508:55: sparse:    struct ceph_san_tls_ctx [noderef] __percpu *
   net/ceph/ceph_san_logger.c:508:55: sparse:    struct ceph_san_tls_ctx *
   net/ceph/ceph_san_logger.c:567:36: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_tls_ctx [noderef] __percpu ** @@
>> net/ceph/ceph_san_logger.c:567:36: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct ceph_san_tls_ctx *ctx @@     got struct ceph_san_tls_ctx [noderef] __percpu *[assigned] pscr_ret__ @@
   net/ceph/ceph_san_logger.c:572:13: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_tls_ctx [noderef] __percpu ** @@
   net/ceph/ceph_san_logger.c:589:5: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_tls_ctx [noderef] __percpu ** @@
>> net/ceph/ceph_san_logger.c:589:5: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct ceph_san_tls_ctx [noderef] __percpu *pto_tmp__ @@     got struct ceph_san_tls_ctx *ctx @@
>> net/ceph/ceph_san_logger.c:589:5: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct ceph_san_tls_ctx [noderef] __percpu *pto_tmp__ @@     got struct ceph_san_tls_ctx *ctx @@
>> net/ceph/ceph_san_logger.c:589:5: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct ceph_san_tls_ctx [noderef] __percpu *pto_tmp__ @@     got struct ceph_san_tls_ctx *ctx @@
>> net/ceph/ceph_san_logger.c:589:5: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct ceph_san_tls_ctx [noderef] __percpu *pto_tmp__ @@     got struct ceph_san_tls_ctx *ctx @@

vim +508 net/ceph/ceph_san_logger.c

   482	
   483	    while (entry == NULL) {
   484	        ctx = ceph_san_get_ctx();
   485	        if (!ctx) {
   486	            pr_err("Failed to get TLS context\n");
   487	            return NULL;
   488	        }
   489	        if (!is_valid_kernel_addr(ctx)) {
   490	            pr_err("ceph_san_log: invalid TLS context address: %pK\n", ctx);
   491	            return NULL;
   492	        }
   493	        if (unlikely(retry_count)) {
   494	            pr_debug("[%d]Retrying allocation with ctx %llu (%s, pid %d) (retry %d, needed_size=%zu @ %d)\n",
   495	                     smp_processor_id(), ctx->id, ctx->comm, ctx->pid, retry_count, needed_size, source_id);
   496	        }
   497	
   498	        alloc = cephsan_pagefrag_alloc(&ctx->pf, needed_size);
   499	        if (alloc == (u64)-ENOMEM) {
   500	            pr_debug("[%d]ceph_san_log: pagefrag full for ctx %llu (%s, pid %d), refcount=%d. Alloc failed (retry=%d): pf head=%u active_elements=%d alloc_count=%u, needed_size=%zu, pagefrag_size=%u\n",
   501	                   smp_processor_id(),
   502	                   ctx->id, ctx->comm, ctx->pid, atomic_read(&ctx->refcount), retry_count, ctx->pf.head,
   503	                   ctx->pf.active_elements, ctx->pf.alloc_count,
   504	                   needed_size, CEPHSAN_PAGEFRAG_SIZE);
   505	
   506	            /* Invalidate the correct active context slot before releasing and retrying */
   507	            if (in_serving_softirq()) {
 > 508	                if (this_cpu_read(g_logger.napi_ctxs) == ctx) {
   509	                    pr_debug("[%d]ceph_san_log: Clearing NAPI slot for ctx %llu (CPU %d) due to ENOMEM.\n", smp_processor_id(), ctx->id, smp_processor_id());
   510	                    this_cpu_write(g_logger.napi_ctxs, NULL);
   511	                } else {
   512	                    pr_warn("[%d]ceph_san_log: ENOMEM for ctx %llu (%s, pid %d) in softirq, but it wasn't in current CPU's NAPI slot. NAPI slot holds %p. Refcount: %d.\n",
   513	                            smp_processor_id(), ctx->id, ctx->comm, ctx->pid, this_cpu_read(g_logger.napi_ctxs), atomic_read(&ctx->refcount));
   514	                }
   515	            } else {
   516	                if (current->tls_ctx == (void *)&ctx->release) {
   517	                    pr_debug("[%d]ceph_san_log: Clearing current->tls_ctx for TLS ctx %llu due to ENOMEM.\n", smp_processor_id(), ctx->id);
   518	                    current->tls_ctx = NULL;
   519	                } else {
   520	                    pr_warn("[%d]ceph_san_log: ENOMEM for ctx %llu (%s, pid %d) not in softirq, but it wasn't current->tls_ctx. current->tls_ctx is %p. Refcount: %d.\n",
   521	                            smp_processor_id(), ctx->id, ctx->comm, ctx->pid, current->tls_ctx, atomic_read(&ctx->refcount));
   522	                }
   523	            }
   524	
   525	            ++retry_count;
   526	            ceph_san_tls_release(ctx); /* This decrements refcount, ctx may be reused or freed */
   527	            entry = NULL; /* Ensure we loop to get a new context */
   528	            continue;
   529	        }
   530	        //TODO:: remove this shit alloc should return a ptr
   531	        entry = cephsan_pagefrag_get_ptr(&ctx->pf, alloc);
   532	        if (unlikely(!is_valid_kernel_addr(entry))) {
   533	            pr_debug("[%d]ceph_san_log: invalid log entry pointer: %llx from ctx %llu (%s, pid %d)\n",
   534	                     smp_processor_id(), (unsigned long long)entry, ctx->id, ctx->comm, ctx->pid);
   535	            ceph_san_tls_release(ctx); /* Release the context as we can't use the entry */
   536	            entry = NULL; /* force retry to get a new context and page */
   537	            continue;
   538	        }
   539	        if (unlikely(retry_count)) {
   540	            pr_debug("[%d]Successfully allocated with ctx %llu (%s, pid %d) after %d retries (needed_size=%zu @ %d)\n",
   541	                     smp_processor_id(), ctx->id, ctx->comm, ctx->pid, retry_count, needed_size, source_id);
   542	        }
   543	    }
   544	
   545	    /* Update last_entry pointer */
   546	    ctx->pf.last_entry = entry;
   547	
   548	    /* Fill in entry details */
   549	#if CEPH_SAN_DEBUG_POISON
   550	    entry->debug_poison = CEPH_SAN_LOG_ENTRY_POISON;
   551	#endif
   552	    entry->ts_delta = (u32)(jiffies - ctx->base_jiffies);
   553	    entry->source_id = (u16)source_id;
   554	    entry->client_id = (u8)client_id;
   555	    entry->len = (u8)needed_size;
   556	    return entry->buffer;
   557	}
   558	EXPORT_SYMBOL(ceph_san_log);
   559	
   560	/**
   561	 * ceph_san_get_napi_ctx - Get NAPI context for current CPU
   562	 *
   563	 * Returns pointer to NAPI context or NULL if not set
   564	 */
   565	struct ceph_san_tls_ctx *ceph_san_get_napi_ctx(void)
   566	{
 > 567	    struct ceph_san_tls_ctx *ctx = this_cpu_read(g_logger.napi_ctxs);
   568	
   569	    if (ctx) {
   570	        if (!is_valid_active_ctx(ctx, "NAPI")) {
   571	            pr_err("BUG: Invalid NAPI context found for CPU %d, clearing.\n", smp_processor_id());
   572	            this_cpu_write(g_logger.napi_ctxs, NULL);
   573	            return NULL;
   574	        }
   575	    }
   576	    return ctx;
   577	}
   578	EXPORT_SYMBOL(ceph_san_get_napi_ctx);
   579	
   580	/**
   581	 * ceph_san_set_napi_ctx - Set NAPI context for current CPU
   582	 * @ctx: Context to set
   583	 */
   584	void ceph_san_set_napi_ctx(struct ceph_san_tls_ctx *ctx)
   585	{
   586	    if (ctx && !is_valid_active_ctx(ctx, "New NAPI being set")) {
   587	        BUG(); /* Context should be valid and refcount 1 before being set */
   588	    }
 > 589	    this_cpu_write(g_logger.napi_ctxs, ctx);
   590	}
   591	EXPORT_SYMBOL(ceph_san_set_napi_ctx);
   592	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

