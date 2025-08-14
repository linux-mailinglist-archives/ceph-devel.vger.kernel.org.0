Return-Path: <ceph-devel+bounces-3453-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 015A3B26F0F
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Aug 2025 20:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 456991CE1783
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Aug 2025 18:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A995230BD2;
	Thu, 14 Aug 2025 18:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Co6+KOIt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A58230270
	for <ceph-devel@vger.kernel.org>; Thu, 14 Aug 2025 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196750; cv=none; b=qGIBpeXRnEOZ4t57vUpSD22k9G83crh3Q+gXhv0wKjroz4zLzM4zjZmyIOrRfiwjrMVx9jxMnV9CKoR2Z55T2TCN/5QuYjdULdd3fOxG3m2OLceZXm4m25wkHOwDY8qv4Bo26DtuTcKIMvj+KsNoe3jCgUUunJnX+iAaH5Hq1ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196750; c=relaxed/simple;
	bh=RekP2xtbihvn9PYkQBDOIGYtPwlkahunev1yh6OlXA0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Yo4sNkv8x+kvdnf0WVj1V3LWdDzX4gLdf9UzfG/x/NBBbHvAvNSCFgJpG1lahcC4JVZ87UaC8f3Jjh6BuEN1Uicm007nGH3PFlD+KumwfrLYUei4etyQiGnlBf937ufh/GHc/5G2v9nRvufNdfsC7PBXcrQv0TTky5CxAQU6RjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Co6+KOIt; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755196749; x=1786732749;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=RekP2xtbihvn9PYkQBDOIGYtPwlkahunev1yh6OlXA0=;
  b=Co6+KOItihV2BD6mrmeIXsrQWolqOqXzXDTBvw5+pKLMKQUkXQmk2dZB
   MwOE3sdzLx8hy6/6fz1zME5E6J/o1JXEwcMCyQIVQjL4/dHBWqWaCK1lh
   5lUUIBQf5gs6q0iFN2lM+lRB4ZUYSU6fC8uAr9tsP/UhpJGIZnFf0CR0v
   Ch42iPu4+D3NkSNu1FehtcWXKCAOVkgcGm29zGe6rZXjMtjgbYNpZ5J4h
   BKsg2eCwInyWR8MVe4gvF4QFXcjzG6YOEPTh3FxJmJwPV4uUKm2NnybNJ
   0kgkeENhIwBdOLeckT+IPKCaA2AMH/Xpz67gb9NS3xNc2Gh7vFsRylK9U
   g==;
X-CSE-ConnectionGUID: gc3llUaiRh2ulKoAV3xwVg==
X-CSE-MsgGUID: IvE/lHHMRg+d2ISeqoNuHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57598177"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57598177"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 11:39:08 -0700
X-CSE-ConnectionGUID: QwnicAjfQgqMBmz9hA+g6Q==
X-CSE-MsgGUID: l6TlSs5SQ0+o5eCUwLh6oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167092148"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 14 Aug 2025 11:39:06 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umcqt-000BFE-2M;
	Thu, 14 Aug 2025 18:39:03 +0000
Date: Fri, 15 Aug 2025 02:39:01 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls-tracing-only 7/10] lib/blog/blog_core.c:94:
 warning: Function parameter or struct member 'ctx' not described in
 'blog_set_napi_ctx'
Message-ID: <202508150210.LbtTLrLl-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls-tracing-only
head:   6b738aa5f6bb2343f8277d318ff1e9ea9289212c
commit: 4dbfb9232bb3bff162418ee08fe5379af0bcab48 [7/10] phase I
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20250815/202508150210.LbtTLrLl-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250815/202508150210.LbtTLrLl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508150210.LbtTLrLl-lkp@intel.com/

All warnings (new ones prefixed by >>):

   lib/blog/blog_core.c:44: warning: Function parameter or struct member 'file' not described in 'blog_get_source_id'
   lib/blog/blog_core.c:44: warning: Function parameter or struct member 'func' not described in 'blog_get_source_id'
   lib/blog/blog_core.c:44: warning: Function parameter or struct member 'line' not described in 'blog_get_source_id'
   lib/blog/blog_core.c:44: warning: Function parameter or struct member 'fmt' not described in 'blog_get_source_id'
   lib/blog/blog_core.c:54: warning: Function parameter or struct member 'id' not described in 'blog_get_source_info'
   lib/blog/blog_core.c:64: warning: Function parameter or struct member 'source_id' not described in 'blog_log'
   lib/blog/blog_core.c:64: warning: Function parameter or struct member 'client_id' not described in 'blog_log'
   lib/blog/blog_core.c:64: warning: Function parameter or struct member 'needed_size' not described in 'blog_log'
>> lib/blog/blog_core.c:94: warning: Function parameter or struct member 'ctx' not described in 'blog_set_napi_ctx'
>> lib/blog/blog_core.c:113: warning: Function parameter or struct member 'n' not described in 'blog_log_trim'
>> lib/blog/blog_core.c:123: warning: Function parameter or struct member 'iter' not described in 'blog_log_iter_init'
>> lib/blog/blog_core.c:123: warning: Function parameter or struct member 'pf' not described in 'blog_log_iter_init'
>> lib/blog/blog_core.c:132: warning: Function parameter or struct member 'iter' not described in 'blog_log_iter_next'
>> lib/blog/blog_core.c:143: warning: Function parameter or struct member 'entry' not described in 'blog_des_entry'
>> lib/blog/blog_core.c:143: warning: Function parameter or struct member 'output' not described in 'blog_des_entry'
>> lib/blog/blog_core.c:143: warning: Function parameter or struct member 'out_size' not described in 'blog_des_entry'
>> lib/blog/blog_core.c:143: warning: Function parameter or struct member 'client_cb' not described in 'blog_des_entry'
   lib/blog/blog_core.c:153: warning: Function parameter or struct member 'addr' not described in 'blog_is_valid_kernel_addr'


vim +94 lib/blog/blog_core.c

    89	
    90	/**
    91	 * blog_set_napi_ctx - Set NAPI context for current CPU
    92	 */
    93	void blog_set_napi_ctx(struct blog_tls_ctx *ctx)
  > 94	{
    95		/* Stub implementation */
    96	}
    97	EXPORT_SYMBOL(blog_set_napi_ctx);
    98	
    99	/**
   100	 * blog_get_ctx - Get appropriate context based on context type
   101	 */
   102	struct blog_tls_ctx *blog_get_ctx(void)
   103	{
   104		/* Stub implementation */
   105		return NULL;
   106	}
   107	EXPORT_SYMBOL(blog_get_ctx);
   108	
   109	/**
   110	 * blog_log_trim - Trim the current context's pagefrag by n bytes
   111	 */
   112	int blog_log_trim(unsigned int n)
 > 113	{
   114		/* Stub implementation */
   115		return 0;
   116	}
   117	EXPORT_SYMBOL(blog_log_trim);
   118	
   119	/**
   120	 * blog_log_iter_init - Initialize the iterator for a specific pagefrag
   121	 */
   122	void blog_log_iter_init(struct blog_log_iter *iter, struct blog_pagefrag *pf)
 > 123	{
   124		/* Stub implementation */
   125	}
   126	EXPORT_SYMBOL(blog_log_iter_init);
   127	
   128	/**
   129	 * blog_log_iter_next - Get next log entry
   130	 */
   131	struct blog_log_entry *blog_log_iter_next(struct blog_log_iter *iter)
 > 132	{
   133		/* Stub implementation */
   134		return NULL;
   135	}
   136	EXPORT_SYMBOL(blog_log_iter_next);
   137	
   138	/**
   139	 * blog_des_entry - Deserialize entry with callback
   140	 */
   141	int blog_des_entry(struct blog_log_entry *entry, char *output, size_t out_size,
   142	                   blog_client_des_fn client_cb)
 > 143	{
   144		/* Stub implementation */
   145		return 0;
   146	}
   147	EXPORT_SYMBOL(blog_des_entry);
   148	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

