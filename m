Return-Path: <ceph-devel+bounces-2660-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E01A34A8A
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 17:47:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60ACE170700
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 16:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2EE12010F5;
	Thu, 13 Feb 2025 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RffCemLm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022A226980A
	for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2025 16:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739464381; cv=none; b=UpZrHHqXDbSS4fHJpBwwPr/qzTyIwcCaNUUMdO94C2bnWLdVXFjzyyZeWrXFBi/6vCH4xXx/vOOY7cLMqWcXSrDNRfUCWIVm+ATCZxZkEDaqncIctOpckeg9lIVw8UXVC+ZjDlOSbz/JwAuRqmLB3WbyalZfD6F38dsH/rOWs74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739464381; c=relaxed/simple;
	bh=CpGwgU7DLZM6Q0gfJ3kuP6lTKPEZqRvxkfJ5HJZ2JwI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CQxtLR4DbzZEjblynhK6IbKOO+2fl2kHHGs+9QjQ44hBmqJ9nk0aoq4Q9Xmd4uwkD1+j0xQDUADBIZk+7epRXiq2u+1gAzlTs1nVYJIzHMvnAUAMBc5FNZWFEXu0EFdQA4TrNEqHyH0zINs9yc33jbOQULBT4FUEWvOkjrxohCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RffCemLm; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739464380; x=1771000380;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=CpGwgU7DLZM6Q0gfJ3kuP6lTKPEZqRvxkfJ5HJZ2JwI=;
  b=RffCemLm4nFi8JpiaUF3WjXlWunSQ+frXnLRddGl0vhJ5WWBWEDWlwTf
   ngPlF4yoJOnm+H4ToTOmt4yqtAunpwTrgB5hRkjaZORY4ZDpUvfk/NxaI
   1aUjJ0KX++L0oJJqPXTLFqL/PMhGWy4MrQLU4wm8gg2C8W3yS5amlax+1
   EnxNp49hCIkyGfarmjTpbwqfXhXlEmqJRETMNnijbbivUv+BRx2wrSfst
   UYUM2kfdv5noInjwz2LDm/Edh0GTn74Klpp6OWnb++lrKLkVo+JgxHLAy
   sdAJaq0FYOYYbPRyAmHuereCtBxNgnJDTCT6zzTq+xZsTthxG+KccXpO6
   g==;
X-CSE-ConnectionGUID: yJEd58T5Rra5v/p8uaK48g==
X-CSE-MsgGUID: F5YzXzCYSKamtDL88X2rTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="43942941"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="43942941"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 08:33:00 -0800
X-CSE-ConnectionGUID: Mq4py3gjSmWV4xf3GDSH+A==
X-CSE-MsgGUID: X1H49WHcSrKN6PmH7PVaxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="113160403"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 13 Feb 2025 08:32:58 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tic92-0018Ql-0F;
	Thu, 13 Feb 2025 16:32:56 +0000
Date: Fri, 14 Feb 2025 00:32:34 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 6/13] net/ceph/ceph_san.c:17:39: sparse:
 sparse: incorrect type in initializer (different address spaces)
Message-ID: <202502140048.RiHSMZiW-lkp@intel.com>
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
config: alpha-randconfig-r133-20250213 (https://download.01.org/0day-ci/archive/20250214/202502140048.RiHSMZiW-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 14.2.0
reproduce: (https://download.01.org/0day-ci/archive/20250214/202502140048.RiHSMZiW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502140048.RiHSMZiW-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/ceph/ceph_san.c:129:39: sparse: sparse: no newline at end of file
>> net/ceph/ceph_san.c:17:39: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_tls_logger * @@
   net/ceph/ceph_san.c:17:39: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:17:39: sparse:     got struct ceph_san_tls_logger *

vim +17 net/ceph/ceph_san.c

     7	
     8	/* Use per-core TLS logger; no global list or lock needed */
     9	DEFINE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
    10	EXPORT_SYMBOL(ceph_san_tls);
    11	/* The definitions for struct ceph_san_log_entry and struct ceph_san_tls_logger
    12	 * have been moved to cephsan.h (under CONFIG_DEBUG_FS) to avoid duplication.
    13	 */
    14	
    15	char *get_log_cephsan(void) {
    16	    /* Use the per-core TLS logger */
  > 17	    struct ceph_san_tls_logger *tls = this_cpu_ptr(&ceph_san_tls);
    18	    int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
    19	    tls->logs[head_idx].pid = current->pid;
    20	    tls->logs[head_idx].ts = jiffies;
    21	    memcpy(tls->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
    22	
    23	    return tls->logs[head_idx].buf;
    24	}
    25	EXPORT_SYMBOL(get_log_cephsan);
    26	
    27	/* Cleanup function to free all TLS logger objects.
    28	 * Call this at module exit to free allocated TLS loggers.
    29	 */
    30	void cephsan_cleanup(void)
    31	{
    32	}
    33	EXPORT_SYMBOL(cephsan_cleanup);
    34	/* Initialize the Ceph SAN logging infrastructure.
    35	 * Call this at module init to set up the global list and lock.
    36	 */
    37	int cephsan_init(void)
    38	{
    39	
    40		return 0;
    41	}
    42	EXPORT_SYMBOL(cephsan_init);
    43	
    44	/**
    45	 * cephsan_pagefrag_init - Initialize the pagefrag allocator.
    46	 *
    47	 * Allocates a 16KB contiguous buffer and resets head and tail pointers.
    48	 *
    49	 * Return: 0 on success, negative error code on failure.
    50	 */
    51	int cephsan_pagefrag_init(struct cephsan_pagefrag *pf)
    52	{
    53		pf->buffer = kmalloc(CEPHSAN_PAGEFRAG_SIZE, GFP_KERNEL);
    54		if (!pf->buffer)
    55			return -ENOMEM;
    56	
    57		pf->head = 0;
    58		pf->tail = 0;
    59		return 0;
    60	}
    61	EXPORT_SYMBOL(cephsan_pagefrag_init);
    62	
    63	/**
    64	 * cephsan_pagefrag_alloc - Allocate bytes from the pagefrag buffer.
    65	 * @n: number of bytes to allocate.
    66	 *
    67	 * Allocates @n bytes if there is sufficient free space in the buffer.
    68	 * Advances the head pointer by @n bytes (wrapping around if needed).
    69	 *
    70	 * Return: pointer to the allocated memory, or NULL if not enough space.
    71	 */
    72	u64 cephsan_pagefrag_alloc(struct cephsan_pagefrag *pf, unsigned int n)
    73	{
    74		unsigned int used, free_space, remaining;
    75		void *ptr;
    76	
    77		/* Compute usage in the circular buffer */
    78		if (pf->head >= pf->tail)
    79			used = pf->head - pf->tail;
    80		else
    81			used = CEPHSAN_PAGEFRAG_SIZE - pf->tail + pf->head;
    82	
    83		free_space = CEPHSAN_PAGEFRAG_SIZE - used;
    84		if (n > free_space)
    85			return 0;
    86	
    87		/* Check if allocation would wrap around buffer end */
    88		if (pf->head + n > CEPHSAN_PAGEFRAG_SIZE) {
    89			/* Calculate bytes remaining until buffer end */
    90			remaining = CEPHSAN_PAGEFRAG_SIZE - pf->head;
    91			/* Move tail to start if needed */
    92			if (pf->tail < n - remaining)
    93				pf->tail = 0;
    94	
    95			/* Return pointer to new head at buffer start */
    96			ptr = pf->buffer;
    97			pf->head = n - remaining;
    98		} else {
    99			/* No wrap around needed */
   100			ptr = (char *)pf->buffer + pf->head;
   101			pf->head += n;
   102		}
   103		/* Return combined u64 with buffer index in lower 32 bits and size in upper 32 bits */
   104		return ((u64)(n) << 32) | (ptr - pf->buffer);
   105	}
   106	EXPORT_SYMBOL(cephsan_pagefrag_alloc);
   107	/**
   108	 * cephsan_pagefrag_free - Free bytes in the pagefrag allocator.
   109	 * @n: number of bytes to free.
   110	 *
   111	 * Advances the tail pointer by @n bytes (wrapping around if needed).
   112	 */
   113	void cephsan_pagefrag_free(struct cephsan_pagefrag *pf, unsigned int n)
   114	{
   115		pf->tail = (pf->tail + n) % CEPHSAN_PAGEFRAG_SIZE;
   116	}
   117	EXPORT_SYMBOL(cephsan_pagefrag_free);
   118	/**
   119	 * cephsan_pagefrag_deinit - Deinitialize the pagefrag allocator.
   120	 *
   121	 * Frees the allocated buffer and resets the head and tail pointers.
   122	 */
   123	void cephsan_pagefrag_deinit(struct cephsan_pagefrag *pf)
   124	{
   125		kfree(pf->buffer);
   126		pf->buffer = NULL;
   127		pf->head = pf->tail = 0;
   128	}
 > 129	EXPORT_SYMBOL(cephsan_pagefrag_deinit);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

