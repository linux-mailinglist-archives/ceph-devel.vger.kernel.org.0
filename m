Return-Path: <ceph-devel+bounces-2977-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B15FFA69A50
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 21:42:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BDAC179B0B
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 20:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0522066D6;
	Wed, 19 Mar 2025 20:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="junjQD3w"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0682B1DED60
	for <ceph-devel@vger.kernel.org>; Wed, 19 Mar 2025 20:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742416948; cv=none; b=uvN4lzKDFCUxNDnlxFqx3mgnzTbUA6cbY74LMvuuB0s8hAKlc9qFTxHDoUcJ9diUBHAecW6PtFdenhiNUj+syh1XulYyniquA4HMuxvMl8mRju76IjNHtG1z6C0HdPny/B2vt4HJk3/CADbjJ1PS+uFPsMInKGAd9Rl8iL72p70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742416948; c=relaxed/simple;
	bh=r708IfrKkd3c59+8R4uZLI4R3yJAoseV0DEXXAC1K8M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RB4x7vuRnRUmXM2fVr3/1b3B43aup2sLxOBYrZ+wf6PVxAMi5zum8zhuokTAt29olnHhfuKm+ROfQ+Cs/PGVunM4tt/xu9uh7zFkXrYJW3G7KElzsyiTzXf2Q9jltK59tSztWmRGDXLaH1JbOvUtBeFgWQzPZDlHzaZbNs8i988=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=junjQD3w; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742416947; x=1773952947;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=r708IfrKkd3c59+8R4uZLI4R3yJAoseV0DEXXAC1K8M=;
  b=junjQD3wPlgxQp89MC6UjkKk9b/txfv+0sn+kKnJmz+moYihwU/CbbWv
   NyoT8CMBLQKaK9i9MucQGCyo0af97mKZMgIZ6I/LURVLJYDhaLDvbN2eK
   sGz32iFRta2wP+Gst6kNS85oE6DxxiEFQEShduszKE+kGwYC4j2OW6yDY
   /TyQuoNqyfaBqe7JzHTzzbWyy1xSxzRN873DNT62Is0ugj2Q2SV0xPRgd
   fRpoo66qCErVWgnlDz6Pj+Li7ql6WpdCHML+BtP20U6pgW9va/1ojdOut
   V4BhB6tVuSFwCpenPve3dn41Geg50zLGmsHpeJgUfVxkBkP+i1hawqF6c
   Q==;
X-CSE-ConnectionGUID: auK2I+L3Rci5oxxTvePAFA==
X-CSE-MsgGUID: R1NnXA07R4O3C3tJbh8FlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11378"; a="66085218"
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="66085218"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2025 13:42:26 -0700
X-CSE-ConnectionGUID: yLtqpQWWRT220XUCpcMAQw==
X-CSE-MsgGUID: IArHm/R/TPaO1ifW9NYN2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="122782443"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 19 Mar 2025 13:42:25 -0700
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tv0F4-000FeV-1I;
	Wed, 19 Mar 2025 20:42:22 +0000
Date: Thu, 20 Mar 2025 04:41:58 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 20/39] net/ceph/ceph_san_logger.c:119:
 warning: Function parameter or struct member 'func' not described in
 'ceph_san_log'
Message-ID: <202503200418.ZxDBCjuJ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   9d7726eb13dd4dbf6bba377991e8c20e18f26dae
commit: 3fc959eb069b4707f932cd4556c2df2ea91e6a20 [20/39] fixups
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20250320/202503200418.ZxDBCjuJ-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250320/202503200418.ZxDBCjuJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503200418.ZxDBCjuJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ceph/ceph_san_logger.c:119: warning: Function parameter or struct member 'func' not described in 'ceph_san_log'


vim +119 net/ceph/ceph_san_logger.c

209e15e6548ab5f Alex Markuze 2025-03-16  109  
209e15e6548ab5f Alex Markuze 2025-03-16  110  /**
209e15e6548ab5f Alex Markuze 2025-03-16  111   * ceph_san_log - Log a message
209e15e6548ab5f Alex Markuze 2025-03-16  112   * @file: Source file name
209e15e6548ab5f Alex Markuze 2025-03-16  113   * @line: Line number
209e15e6548ab5f Alex Markuze 2025-03-16  114   * @fmt: Format string
209e15e6548ab5f Alex Markuze 2025-03-16  115   *
209e15e6548ab5f Alex Markuze 2025-03-16  116   * Logs a message to the current TLS context's log buffer
209e15e6548ab5f Alex Markuze 2025-03-16  117   */
3fc959eb069b470 Alex Markuze 2025-03-18  118  void ceph_san_log(const char *file, const char *func, unsigned int line, const char *fmt, ...)
209e15e6548ab5f Alex Markuze 2025-03-16 @119  {
209e15e6548ab5f Alex Markuze 2025-03-16  120      /* Format the message into local buffer first */
209e15e6548ab5f Alex Markuze 2025-03-16  121      char buf[256];
209e15e6548ab5f Alex Markuze 2025-03-16  122      struct ceph_san_tls_ctx *ctx;
209e15e6548ab5f Alex Markuze 2025-03-16  123      struct ceph_san_log_entry *entry;
209e15e6548ab5f Alex Markuze 2025-03-16  124      va_list args;
b756c73bb29c0ac Alex Markuze 2025-03-16  125      u64 alloc;
ca02ecf6a70fb40 Alex Markuze 2025-03-17  126      int len, needed_size;
209e15e6548ab5f Alex Markuze 2025-03-16  127  
209e15e6548ab5f Alex Markuze 2025-03-16  128      ctx = ceph_san_get_tls_ctx();
7ef17a741382bcb Alex Markuze 2025-03-17  129      if (!ctx) {
7ef17a741382bcb Alex Markuze 2025-03-17  130          pr_err("Failed to get TLS context\n");
209e15e6548ab5f Alex Markuze 2025-03-16  131          return;
7ef17a741382bcb Alex Markuze 2025-03-17  132      }
209e15e6548ab5f Alex Markuze 2025-03-16  133  
209e15e6548ab5f Alex Markuze 2025-03-16  134      va_start(args, fmt);
209e15e6548ab5f Alex Markuze 2025-03-16  135      len = vsnprintf(buf, sizeof(buf), fmt, args);
209e15e6548ab5f Alex Markuze 2025-03-16  136      va_end(args);
209e15e6548ab5f Alex Markuze 2025-03-16  137  
ca02ecf6a70fb40 Alex Markuze 2025-03-17  138      needed_size = sizeof(*entry) + len + 1;
f268ba79f69f9e5 Alex Markuze 2025-03-17  139      /* Allocate entry from pagefrag - We need a spinlock here to protect access iterators */
f268ba79f69f9e5 Alex Markuze 2025-03-17  140      spin_lock(&ctx->pf.lock);
ca02ecf6a70fb40 Alex Markuze 2025-03-17  141      alloc = cephsan_pagefrag_alloc(&ctx->pf, needed_size);
b756c73bb29c0ac Alex Markuze 2025-03-16  142      while (!alloc) {
b756c73bb29c0ac Alex Markuze 2025-03-16  143          entry = cephsan_pagefrag_get_ptr_from_tail(&ctx->pf);
e49e5f0dc7ce606 Alex Markuze 2025-03-16  144          BUG_ON(entry->debug_poison != CEPH_SAN_LOG_ENTRY_POISON);
e043972dfcde1e5 Alex Markuze 2025-03-16  145          BUG_ON(entry->len == 0);
b756c73bb29c0ac Alex Markuze 2025-03-16  146          cephsan_pagefrag_free(&ctx->pf, entry->len);
ca02ecf6a70fb40 Alex Markuze 2025-03-17  147          alloc = cephsan_pagefrag_alloc(&ctx->pf, needed_size);
ca02ecf6a70fb40 Alex Markuze 2025-03-17  148          //In case we hit the wrap around, we may get a partial allocation that should be marked as used
ca02ecf6a70fb40 Alex Markuze 2025-03-17  149          if (alloc && cephsan_pagefrag_get_alloc_size(alloc) < needed_size) {
ca02ecf6a70fb40 Alex Markuze 2025-03-17  150              entry = cephsan_pagefrag_get_ptr(&ctx->pf, alloc);
ca02ecf6a70fb40 Alex Markuze 2025-03-17  151              memset(entry->buffer, 0, sizeof(entry->buffer));
ca02ecf6a70fb40 Alex Markuze 2025-03-17  152              entry->len = cephsan_pagefrag_get_alloc_size(alloc);
ca02ecf6a70fb40 Alex Markuze 2025-03-17  153              alloc = 0;
ca02ecf6a70fb40 Alex Markuze 2025-03-17  154          }
b756c73bb29c0ac Alex Markuze 2025-03-16  155      }
209e15e6548ab5f Alex Markuze 2025-03-16  156      entry = cephsan_pagefrag_get_ptr(&ctx->pf, alloc);
209e15e6548ab5f Alex Markuze 2025-03-16  157  
209e15e6548ab5f Alex Markuze 2025-03-16  158      /* Fill in entry details */
e49e5f0dc7ce606 Alex Markuze 2025-03-16  159      entry->debug_poison = CEPH_SAN_LOG_ENTRY_POISON;
209e15e6548ab5f Alex Markuze 2025-03-16  160      entry->ts = jiffies;
209e15e6548ab5f Alex Markuze 2025-03-16  161      entry->line = line;
209e15e6548ab5f Alex Markuze 2025-03-16  162      entry->file = file;
3fc959eb069b470 Alex Markuze 2025-03-18  163      entry->func = func;
3fc959eb069b470 Alex Markuze 2025-03-18  164      entry->buffer = (char *)(entry + 1);
ca02ecf6a70fb40 Alex Markuze 2025-03-17  165      entry->len = cephsan_pagefrag_get_alloc_size(alloc);
f268ba79f69f9e5 Alex Markuze 2025-03-17  166      spin_unlock(&ctx->pf.lock);
f268ba79f69f9e5 Alex Markuze 2025-03-17  167  
f268ba79f69f9e5 Alex Markuze 2025-03-17  168      /* Copy to entry buffer */
f268ba79f69f9e5 Alex Markuze 2025-03-17  169      memcpy(entry->buffer, buf, len + 1);
f268ba79f69f9e5 Alex Markuze 2025-03-17  170      entry->buffer[len] = '\0';
209e15e6548ab5f Alex Markuze 2025-03-16  171  }
209e15e6548ab5f Alex Markuze 2025-03-16  172  EXPORT_SYMBOL(ceph_san_log);
209e15e6548ab5f Alex Markuze 2025-03-16  173  

:::::: The code at line 119 was first introduced by commit
:::::: 209e15e6548ab5ff8ab19f7a64868f38f5e6831a cephsan logger: WIP

:::::: TO: Alex Markuze <amarkuze@redhat.com>
:::::: CC: Alex Markuze <amarkuze@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

