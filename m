Return-Path: <ceph-devel+bounces-2655-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3988FA33791
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 06:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD280168B8A
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 05:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA2A206F0F;
	Thu, 13 Feb 2025 05:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PzQqIJ4P"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC084204F85
	for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2025 05:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739425905; cv=none; b=CYKgDoLHcdJYrZ3D8JaCQ+QSs4/2CX5fWsTt4Yr4RBJbC9ZTa3ihoje2ZE+iJN6fiQOgXOPaWnDn3rt9VZG/iFiet7U4a+Nn+0am++8eW1Dw48T8B243m25I3wB4JrELZVLWeSlgnwGKM8P5Fbp1yDfCb/x7WZE/+HG8+UiGraM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739425905; c=relaxed/simple;
	bh=+NgcqgU4b4J+Z2Erz/ak4ix0hLEJo8md5cclSD+KSXU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ey+Vmg7wMA1EpXeo3Vwm+ZIkuLN0cajwSgoqq5iD2uk8KUYezAKczIYO2CUsJpjyodeWEQc//Q8m9vvg07QpuRsqr1pWzJZJT3ZOlZwZRAOZlUAwlrPPnpqmdJWqyCyoWc484AsWmhgv/2LTUj2BF58h/OWvs6FEQYm0RaTDhd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PzQqIJ4P; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739425902; x=1770961902;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=+NgcqgU4b4J+Z2Erz/ak4ix0hLEJo8md5cclSD+KSXU=;
  b=PzQqIJ4PqNdDAP+5/xKV6kGsBlEAvYcBW9JqvSOiyFcjGj5z+zE1Hy4w
   VilOmw6M8xvzzhL2xiW3Rz/LsK53zWBscJ8PVi24bcdEALHYeXNCSMkJK
   G+8Deqa6h9kp6/A5sD+xnSaSraLHO/U4NrJesCdfQ3+AkClQtclhfV6m+
   1OzZCokDKL62++uXvzLh2+yS6uWjt57HLJ7wAutBoTsmiaP+/QXXHjYhe
   YkmdySXHLVz4V8PiOgajpv55W9UxGsQFmp467ay9t0nGPQ4nHilhBU0tZ
   +VrgXgaDp4RCd3d+U2knPsOAeslXAJT1mSmxNnWlrDPA1K3Xe52hHECRk
   Q==;
X-CSE-ConnectionGUID: NtJ9SXkZQl+BGXGXQU4K/g==
X-CSE-MsgGUID: 9yUrVBktR8anGEiKUW2R9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="50759778"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="50759778"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 21:51:42 -0800
X-CSE-ConnectionGUID: eDAzHSarTgyXwaXZn2F4IQ==
X-CSE-MsgGUID: eQaSamxIRiKIHnvPdPCKRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="113566085"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Feb 2025 21:51:41 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tiS8Q-0016af-1w;
	Thu, 13 Feb 2025 05:51:38 +0000
Date: Thu, 13 Feb 2025 13:50:56 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 3/13] net/ceph/ceph_san.c:100: warning:
 Function parameter or struct member 'pf' not described in
 'cephsan_pagefrag_init'
Message-ID: <202502131328.J5Q1ZaRE-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alex,

First bad commit (maybe != root cause):

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   cd1e899feeb6a7da55cbb74b9245c8bbb77f82ba
commit: a85b831a9a8fcd3420c8a0b8c0c56b608acad771 [3/13] cephsan: moving libceph
config: i386-buildonly-randconfig-001-20250213 (https://download.01.org/0day-ci/archive/20250213/202502131328.J5Q1ZaRE-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250213/202502131328.J5Q1ZaRE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502131328.J5Q1ZaRE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ceph/ceph_san.c:100: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_init'
>> net/ceph/ceph_san.c:121: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_alloc'
>> net/ceph/ceph_san.c:162: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_free'
>> net/ceph/ceph_san.c:172: warning: Function parameter or struct member 'pf' not described in 'cephsan_pagefrag_deinit'


vim +100 net/ceph/ceph_san.c

04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   90  
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   91  
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   92  /**
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   93   * cephsan_pagefrag_init - Initialize the pagefrag allocator.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   94   *
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   95   * Allocates a 16KB contiguous buffer and resets head and tail pointers.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   96   *
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   97   * Return: 0 on success, negative error code on failure.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11   98   */
a85b831a9a8fcd3 net/ceph/ceph_san.c Alex Markuze 2025-02-11   99  int cephsan_pagefrag_init(struct cephsan_pagefrag *pf)
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11 @100  {
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  101  	pf->buffer = kmalloc(CEPHSAN_PAGEFRAG_SIZE, GFP_KERNEL);
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  102  	if (!pf->buffer)
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  103  		return -ENOMEM;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  104  
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  105  	pf->head = 0;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  106  	pf->tail = 0;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  107  	return 0;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  108  }
a85b831a9a8fcd3 net/ceph/ceph_san.c Alex Markuze 2025-02-11  109  EXPORT_SYMBOL(cephsan_pagefrag_init);
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  110  
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  111  /**
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  112   * cephsan_pagefrag_alloc - Allocate bytes from the pagefrag buffer.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  113   * @n: number of bytes to allocate.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  114   *
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  115   * Allocates @n bytes if there is sufficient free space in the buffer.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  116   * Advances the head pointer by @n bytes (wrapping around if needed).
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  117   *
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  118   * Return: pointer to the allocated memory, or NULL if not enough space.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  119   */
a85b831a9a8fcd3 net/ceph/ceph_san.c Alex Markuze 2025-02-11  120  u64 cephsan_pagefrag_alloc(struct cephsan_pagefrag *pf, unsigned int n)
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11 @121  {
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  122  	unsigned int used, free_space, remaining;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  123  	void *ptr;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  124  
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  125  	/* Compute usage in the circular buffer */
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  126  	if (pf->head >= pf->tail)
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  127  		used = pf->head - pf->tail;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  128  	else
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  129  		used = CEPHSAN_PAGEFRAG_SIZE - pf->tail + pf->head;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  130  
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  131  	free_space = CEPHSAN_PAGEFRAG_SIZE - used;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  132  	if (n > free_space)
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  133  		return 0;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  134  
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  135  	/* Check if allocation would wrap around buffer end */
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  136  	if (pf->head + n > CEPHSAN_PAGEFRAG_SIZE) {
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  137  		/* Calculate bytes remaining until buffer end */
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  138  		remaining = CEPHSAN_PAGEFRAG_SIZE - pf->head;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  139  		/* Move tail to start if needed */
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  140  		if (pf->tail < n - remaining)
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  141  			pf->tail = 0;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  142  
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  143  		/* Return pointer to new head at buffer start */
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  144  		ptr = pf->buffer;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  145  		pf->head = n - remaining;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  146  	} else {
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  147  		/* No wrap around needed */
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  148  		ptr = (char *)pf->buffer + pf->head;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  149  		pf->head += n;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  150  	}
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  151  	/* Return combined u64 with buffer index in lower 32 bits and size in upper 32 bits */
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  152  	return ((u64)(n) << 32) | (ptr - pf->buffer);
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  153  }
a85b831a9a8fcd3 net/ceph/ceph_san.c Alex Markuze 2025-02-11  154  EXPORT_SYMBOL(cephsan_pagefrag_alloc);
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  155  /**
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  156   * cephsan_pagefrag_free - Free bytes in the pagefrag allocator.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  157   * @n: number of bytes to free.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  158   *
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  159   * Advances the tail pointer by @n bytes (wrapping around if needed).
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  160   */
a85b831a9a8fcd3 net/ceph/ceph_san.c Alex Markuze 2025-02-11  161  void cephsan_pagefrag_free(struct cephsan_pagefrag *pf, unsigned int n)
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11 @162  {
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  163  	pf->tail = (pf->tail + n) % CEPHSAN_PAGEFRAG_SIZE;
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  164  }
a85b831a9a8fcd3 net/ceph/ceph_san.c Alex Markuze 2025-02-11  165  EXPORT_SYMBOL(cephsan_pagefrag_free);
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  166  /**
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  167   * cephsan_pagefrag_deinit - Deinitialize the pagefrag allocator.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  168   *
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  169   * Frees the allocated buffer and resets the head and tail pointers.
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11  170   */
a85b831a9a8fcd3 net/ceph/ceph_san.c Alex Markuze 2025-02-11  171  void cephsan_pagefrag_deinit(struct cephsan_pagefrag *pf)
04fa82972277cd8 fs/ceph/ceph_san.c  Alex Markuze 2025-02-11 @172  {

:::::: The code at line 100 was first introduced by commit
:::::: 04fa82972277cd879d1bcb1efe97bbe1c53cd104 cephsan: a full string printout

:::::: TO: Alex Markuze <amarkuze@redhat.com>
:::::: CC: Alex Markuze <amarkuze@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

