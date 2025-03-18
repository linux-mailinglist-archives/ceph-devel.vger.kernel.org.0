Return-Path: <ceph-devel+bounces-2952-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0482DA67151
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 11:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE0A57A4F93
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 10:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EBD20469A;
	Tue, 18 Mar 2025 10:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O4iYiVHF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EC91F4E38
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 10:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742293888; cv=none; b=uQTIAWgeURPChc7aMukfjJajLIIaN3K0FgUI31aN0IMQ7iBysS5uJ86dXCTGNXhC6d8srhzlMX7nn90NI7i8hzVa8diF1MBO6cfg5v0PzsgbXK+xORxdTv4b6IPXLGRBnWTvmOIwbHDSK2lQ+oL/nMenkELtVUqXENZiRM4V4LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742293888; c=relaxed/simple;
	bh=IDmZNIz4QmUkqSnSEkPRmfSfQCcWMZhuhDd2E7x3OiE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Gns7cEsHCwHFr1HmqYnxCZ9KFZ7Arco3/y1M/aPZgqhGGz1wLBFErqmAnpgGYyqdGy7+I8Wav56PAxQSOpX/qL+Kj2OdZr56/OdlYm9qXxESdCc8PLMZlqtzrvEvzjA0wjGmacJp/A8aiccYNw2kUD+BcIXQCM0rFWjnj4b6Lcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O4iYiVHF; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742293886; x=1773829886;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=IDmZNIz4QmUkqSnSEkPRmfSfQCcWMZhuhDd2E7x3OiE=;
  b=O4iYiVHFyptXGS2ZU1HS9onNh0tJN6zCQ0jlr+ZwSjFK6ji0Gvy7/CR/
   o3cFvtLZFl5/pVYNCRByK2ITKS/LjZ+raB4OUwaaO+paWrcnIUERsndgS
   1WumZrETXYBZIbNtqug0WOzQbPIGUzXcNS02jQ5TM0IGBWaqAqB8iOfQJ
   KK3mEHQnELJzbxHi6nU6qA5o656P+zl7ygcE/4SNrbMywXcfUAtN+8Q7D
   7io3XFBdVfuQ529kc93d9N2EgqJaPfVY8jcQOz9uuZfEUEh6BheEDJoWm
   FI3f/5tWB6B9Al7r6PADqwSLwRljy4eJIikJSBoV4IyEPS9n4K8iaRZE1
   Q==;
X-CSE-ConnectionGUID: RUqsFx2lR5+S3rC1qpfBXg==
X-CSE-MsgGUID: XdcDVxO+Se2cU+cxrgpvtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="53639097"
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="53639097"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 03:31:26 -0700
X-CSE-ConnectionGUID: JmAbvFdZSrCDMua3K31JWQ==
X-CSE-MsgGUID: qe5/P8gcSWqMKq9uwg2dcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="122199218"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 18 Mar 2025 03:31:24 -0700
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tuUED-000DfV-2I;
	Tue, 18 Mar 2025 10:31:21 +0000
Date: Tue, 18 Mar 2025 18:30:29 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 12/19] net/ceph/ceph_san_pagefrag.c:107:
 warning: Excess function parameter 'n' description in
 'cephsan_pagefrag_get_ptr_from_tail'
Message-ID: <202503181819.sMIZbyRn-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   75b56e556ea415e29a13a8b7e98d302fbbec4c01
commit: b756c73bb29c0acb3b2509081debd5dc20045242 [12/19] fixup buffer allocation
config: i386-buildonly-randconfig-001-20250318 (https://download.01.org/0day-ci/archive/20250318/202503181819.sMIZbyRn-lkp@intel.com/config)
compiler: clang version 20.1.0 (https://github.com/llvm/llvm-project 24a30daaa559829ad079f2ff7f73eb4e18095f88)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250318/202503181819.sMIZbyRn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503181819.sMIZbyRn-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ceph/ceph_san_pagefrag.c:14: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_init'
   net/ceph/ceph_san_pagefrag.c:54: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_alloc'
>> net/ceph/ceph_san_pagefrag.c:107: warning: Excess function parameter 'n' description in 'cephsan_pagefrag_get_ptr_from_tail'
   net/ceph/ceph_san_pagefrag.c:119: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_free'
   net/ceph/ceph_san_pagefrag.c:130: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_deinit'
>> net/ceph/ceph_san_pagefrag.c:147: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_reset'


vim +107 net/ceph/ceph_san_pagefrag.c

     5	
     6	/**
     7	 * cephsan_pagefrag_init - Initialize the pagefrag allocator.
     8	 *
     9	 * Allocates a 4MB contiguous buffer and resets head and tail pointers.
    10	 *
    11	 * Return: 0 on success, negative error code on failure.
    12	 */
    13	int cephsan_pagefrag_init(struct cephsan_pagefrag *pf)
  > 14	{
    15	    pf->pages = alloc_pages(GFP_KERNEL, get_order(CEPHSAN_PAGEFRAG_SIZE));
    16	    if (!pf->pages)
    17	        return -ENOMEM;
    18	
    19	    pf->buffer = page_address(pf->pages);
    20	    pf->head = 0;
    21	    pf->tail = 0;
    22	    return 0;
    23	}
    24	EXPORT_SYMBOL(cephsan_pagefrag_init);
    25	
    26	/**
    27	 * cephsan_pagefrag_init_with_buffer - Initialize pagefrag with an existing buffer
    28	 * @pf: pagefrag allocator to initialize
    29	 * @buffer: pre-allocated buffer to use
    30	 * @size: size of the buffer
    31	 *
    32	 * Return: 0 on success
    33	 */
    34	int cephsan_pagefrag_init_with_buffer(struct cephsan_pagefrag *pf, void *buffer, size_t size)
    35	{
    36	    pf->pages = NULL; /* No pages allocated, using provided buffer */
    37	    pf->buffer = buffer;
    38	    pf->head = 0;
    39	    pf->tail = 0;
    40	    return 0;
    41	}
    42	EXPORT_SYMBOL(cephsan_pagefrag_init_with_buffer);
    43	
    44	/**
    45	 * cephsan_pagefrag_alloc - Allocate bytes from the pagefrag buffer.
    46	 * @n: number of bytes to allocate.
    47	 *
    48	 * Allocates @n bytes if there is sufficient free space in the buffer.
    49	 * Advances the head pointer by @n bytes (wrapping around if needed).
    50	 *
    51	 * Return: pointer to the allocated memory, or NULL if not enough space.
    52	 */
    53	u64 cephsan_pagefrag_alloc(struct cephsan_pagefrag *pf, unsigned int n)
    54	{
    55	    /* Case 1: tail > head */
    56	    if (pf->tail > pf->head) {
    57	        if (pf->tail - pf->head > n) {
    58	            unsigned int prev_head = pf->head;
    59	            pf->head += n;
    60	            return ((u64)n << 32) | prev_head;
    61	        } else {
    62	            return 0;
    63	        }
    64	    }
    65	    /* Case 2: tail <= head */
    66	    if (pf->head + n <= CEPHSAN_PAGEFRAG_SIZE) {
    67	        /* Normal allocation */
    68	        unsigned int prev_head = pf->head;
    69	        pf->head += n;
    70	        return ((u64)n << 32) | prev_head;
    71	    } else {
    72	        /* Need to wrap around */
    73	        if (n < pf->tail) {
    74	            pf->head = n;
    75	            n += CEPHSAN_PAGEFRAG_SIZE - pf->head;
    76	            return ((u64)n << 32) | 0;
    77	        } else {
    78	            return 0;
    79	        }
    80	    }
    81	    pr_err("impossible: Not enough space in pagefrag buffer\n");
    82	    return 0;
    83	}
    84	EXPORT_SYMBOL(cephsan_pagefrag_alloc);
    85	
    86	/**
    87	 * cephsan_pagefrag_get_ptr - Get buffer pointer from pagefrag allocation result
    88	 * @pf: pagefrag allocator
    89	 * @val: return value from cephsan_pagefrag_alloc
    90	 *
    91	 * Return: pointer to allocated buffer region
    92	 */
    93	void *cephsan_pagefrag_get_ptr(struct cephsan_pagefrag *pf, u64 val)
    94	{
    95	    return pf->buffer + (val & 0xFFFFFFFF);
    96	}
    97	EXPORT_SYMBOL(cephsan_pagefrag_get_ptr);
    98	
    99	/**
   100	 * cephsan_pagefrag_get_ptr_from_tail - Get buffer pointer from pagefrag tail
   101	 * @pf: pagefrag allocator
   102	 * @n: number of bytes to get pointer from
   103	 *
   104	 * Returns pointer to the buffer region at the tail pointer minus @n bytes.
   105	 */
   106	void *cephsan_pagefrag_get_ptr_from_tail(struct cephsan_pagefrag *pf)
 > 107	{
   108	    return pf->buffer + pf->tail;
   109	}
   110	EXPORT_SYMBOL(cephsan_pagefrag_get_ptr_from_tail);
   111	
   112	/**
   113	 * cephsan_pagefrag_free - Free bytes in the pagefrag allocator.
   114	 * @n: number of bytes to free.
   115	 *
   116	 * Advances the tail pointer by @n bytes (wrapping around if needed).
   117	 */
   118	void cephsan_pagefrag_free(struct cephsan_pagefrag *pf, unsigned int n)
   119	{
   120	    pf->tail = (pf->tail + n) & (CEPHSAN_PAGEFRAG_SIZE - 1);
   121	}
   122	EXPORT_SYMBOL(cephsan_pagefrag_free);
   123	
   124	/**
   125	 * cephsan_pagefrag_deinit - Deinitialize the pagefrag allocator.
   126	 *
   127	 * Frees the allocated buffer and resets the head and tail pointers.
   128	 */
   129	void cephsan_pagefrag_deinit(struct cephsan_pagefrag *pf)
   130	{
   131	    if (pf->pages) {
   132	        free_pages((unsigned long)pf->pages, get_order(CEPHSAN_PAGEFRAG_SIZE));
   133	        pf->pages = NULL;
   134	    }
   135	    /* Don't free buffer if it was provided externally */
   136	    pf->buffer = NULL;
   137	    pf->head = pf->tail = 0;
   138	}
   139	EXPORT_SYMBOL(cephsan_pagefrag_deinit);
   140	
   141	/**
   142	 * cephsan_pagefrag_reset - Reset the pagefrag allocator.
   143	 *
   144	 * Resets the head and tail pointers to the beginning of the buffer.
   145	 */
   146	void cephsan_pagefrag_reset(struct cephsan_pagefrag *pf)
 > 147	{

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

