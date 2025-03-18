Return-Path: <ceph-devel+bounces-2951-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F27B6A66F17
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 09:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB62D7A715E
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 08:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61434204C28;
	Tue, 18 Mar 2025 08:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b0LRrbbp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7277C2046AF
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 08:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742288078; cv=none; b=Df+yNYEbhoqrluRA/NqUbX1+KgO2JLDlxyth9WASL8Bp4tsoQQwv0yegZP2Qu1juIplo92pmoN2m9pdUxk6asA2p3ps9vvnmBgFk50QUHpa12o3FzVKZ1CGIYDMI8HnsKnYem5vkK5b4H4/z+d8R67D3yud2BIvkT2zWBBk3zpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742288078; c=relaxed/simple;
	bh=zyeRAKjkRqHsBrmxCmfGPXxBwL9hFs37DoCv6zPH/4c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QAVZJYR46lpEvcW/34qWt9FsavUI+PRyYhSkrCMBfYc0UXOyr5yMeG0vWapGXi3p/eciQTx7EOZVHPdIHDd1eOWD6NhTvn0pozUTtN3JLycRmwI2a0DWnqSvl1S99oD4yT+bjfXTmQQr2cIaq48VYD1fHODh5NEma60iTh4OQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b0LRrbbp; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742288076; x=1773824076;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=zyeRAKjkRqHsBrmxCmfGPXxBwL9hFs37DoCv6zPH/4c=;
  b=b0LRrbbpdQ7Uw0Ts1IsD/p6/9krgIRj+JZqGYn7dOPKkDk0ytMJ6rJjb
   4BqDCVjmUCr/LN5QKs+KFbnFf6oUa0YnwI2yEjpkT6roLn5mDe9mIW12b
   kw4vA5n2JGKrMT6Vids3CijwZ0p6WJBerfnop1Tih1zKm7lHpcu/fCINl
   PWx4JY/HyPnXtOpkoOZVkNPr357pIJCqKrEC3DNhbzaFObIsdpVuJUdxa
   gxUiYvjwuw4feBlLoOEXDGUhJr0lQe4BIIBX/Rm5IZl3pnVhKtlIoeR33
   mnjG3E1S8mY/WxOpGlK3r5aE6dUxj8514Gy5HlLadii36kfOKeKU3qfL1
   g==;
X-CSE-ConnectionGUID: 6Cw3Qu3iRPWygb3TVLn0Ig==
X-CSE-MsgGUID: awqDnjOCRX2ruGOTfE2YXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="43547829"
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="43547829"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 01:54:36 -0700
X-CSE-ConnectionGUID: pDHzbGU9SiChCaAt3qwE/Q==
X-CSE-MsgGUID: Kur8WnAzSwivW5H9SvbYwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="122367990"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 18 Mar 2025 01:54:34 -0700
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tuSiW-000DbX-0x;
	Tue, 18 Mar 2025 08:54:32 +0000
Date: Tue, 18 Mar 2025 16:54:29 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 7/19] net/ceph/ceph_san_pagefrag.c:14:
 warning: Function parameter or struct member 'pf' not described in
 'cephsan_pagefrag_init'
Message-ID: <202503181619.RZqFxBO6-lkp@intel.com>
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
commit: f8434cc50705f961b879b491d7ea5524b5da1ca1 [7/19] ceph_san: moving to magzaines
config: i386-buildonly-randconfig-001-20250318 (https://download.01.org/0day-ci/archive/20250318/202503181619.RZqFxBO6-lkp@intel.com/config)
compiler: clang version 20.1.0 (https://github.com/llvm/llvm-project 24a30daaa559829ad079f2ff7f73eb4e18095f88)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250318/202503181619.RZqFxBO6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503181619.RZqFxBO6-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ceph/ceph_san_pagefrag.c:14: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_init'
>> net/ceph/ceph_san_pagefrag.c:54: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_alloc'
>> net/ceph/ceph_san_pagefrag.c:108: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_free'
>> net/ceph/ceph_san_pagefrag.c:119: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_deinit'


vim +14 net/ceph/ceph_san_pagefrag.c

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
  > 54	{
    55	    /* Case 1: tail > head */
    56	    if (pf->tail > pf->head) {
    57	        if (pf->tail - pf->head >= n) {
    58	            unsigned int prev_head = pf->head;
    59	            pf->head += n;
    60	            return ((u64)n << 32) | prev_head;
    61	        } else {
    62	            pr_err("Not enough space in pagefrag buffer\n");
    63	            return 0;
    64	        }
    65	    }
    66	    /* Case 2: tail <= head */
    67	    if (pf->head + n <= CEPHSAN_PAGEFRAG_SIZE) {
    68	        /* Normal allocation */
    69	        unsigned int prev_head = pf->head;
    70	        pf->head += n;
    71	        return ((u64)n << 32) | prev_head;
    72	    } else {
    73	        /* Need to wrap around */
    74	        if (n <= pf->tail) {
    75	            pf->head = n;
    76	            n += CEPHSAN_PAGEFRAG_SIZE - pf->head;
    77	            return ((u64)n << 32) | 0;
    78	        } else {
    79	            pr_err("Not enough space for wrap-around allocation\n");
    80	            return 0;
    81	        }
    82	    }
    83	    pr_err("impossible: Not enough space in pagefrag buffer\n");
    84	    return 0;
    85	}
    86	EXPORT_SYMBOL(cephsan_pagefrag_alloc);
    87	
    88	/**
    89	 * cephsan_pagefrag_get_ptr - Get buffer pointer from pagefrag allocation result
    90	 * @pf: pagefrag allocator
    91	 * @val: return value from cephsan_pagefrag_alloc
    92	 *
    93	 * Return: pointer to allocated buffer region
    94	 */
    95	void *cephsan_pagefrag_get_ptr(struct cephsan_pagefrag *pf, u64 val)
    96	{
    97	    return pf->buffer + (val & 0xFFFFFFFF);
    98	}
    99	EXPORT_SYMBOL(cephsan_pagefrag_get_ptr);
   100	
   101	/**
   102	 * cephsan_pagefrag_free - Free bytes in the pagefrag allocator.
   103	 * @n: number of bytes to free.
   104	 *
   105	 * Advances the tail pointer by @n bytes (wrapping around if needed).
   106	 */
   107	void cephsan_pagefrag_free(struct cephsan_pagefrag *pf, unsigned int n)
 > 108	{
   109	    pf->tail = (pf->tail + n) & (CEPHSAN_PAGEFRAG_SIZE - 1);
   110	}
   111	EXPORT_SYMBOL(cephsan_pagefrag_free);
   112	
   113	/**
   114	 * cephsan_pagefrag_deinit - Deinitialize the pagefrag allocator.
   115	 *
   116	 * Frees the allocated buffer and resets the head and tail pointers.
   117	 */
   118	void cephsan_pagefrag_deinit(struct cephsan_pagefrag *pf)
 > 119	{

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

