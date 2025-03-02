Return-Path: <ceph-devel+bounces-2846-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F994A4B3D2
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Mar 2025 18:32:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6DAC16D1DF
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Mar 2025 17:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71759433D9;
	Sun,  2 Mar 2025 17:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mKOq1AHl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995BF6F30C
	for <ceph-devel@vger.kernel.org>; Sun,  2 Mar 2025 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740936750; cv=none; b=Nq2lka2ItHKtoto1AT91I1qd6OIYvkZokxUZRsdJx+TTLCAhwZNLLEE0nPi9PAIzxDLgs+9Gx8cvxbMAbafCgE27OWm7EAZZqRYi5ODymFB5H49KTn4Emao+nfaCHpLcZlRuboH6ICX9rqrMUi27LSPE1mqr/Sq8Oh+jW8/zp88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740936750; c=relaxed/simple;
	bh=y/MPwKXKpdb/0rrkJb/iKxu1lbNs2yMTNVMJAxngmUk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=awb0RsEdp5XC2x1jI+p0AAA1j/2VgnNmqJdmFlDsim6AlH5ZOmNx0LCZjGiUg5wQAcwxTbJsaQw8G6dKRJDZPkgQg4Mw9feMDKn2sobuB6q1SIFnuJM78wWeaLFsGnsVpi+qLlZwBhzsvPjOqs2t/h7zew8uOJJMH2Yizd462RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mKOq1AHl; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740936748; x=1772472748;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=y/MPwKXKpdb/0rrkJb/iKxu1lbNs2yMTNVMJAxngmUk=;
  b=mKOq1AHlJLO0fFVzriXyxj8iqp2kI1PCs/v+67Ijz2lbgiLtQDDXx/IA
   ib5KoNCKWxdAfN6trZA3lwjDWonW/pFK3+oCVS8264wc5k+mQqEYonPIT
   nu/OKWmpj+dWeivWEIc0DhlHzugrAAcmi3//s3AZxXiL0Z6r6ogjGnimH
   HBMNYAMTZdedNmtGybEVJcLUB6VmpnAcjWUsWigFGgyrKr8HIHJf9TlIP
   EASzAJ4b9wiro5+Ob3LMtHTPv1ZSuBeRrE0EKjTKOieo8DRnUPMZ2VoWK
   3wRu8uDCE1tJvY95aej1Rzu+3ripJoTn0XWjF8m0p7NdMpMnuWeXSyy9T
   g==;
X-CSE-ConnectionGUID: XiyMOt6/RtqWLPJEFvB05g==
X-CSE-MsgGUID: 5EmN0u0ATC2L52yYgkIhAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="44627289"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="44627289"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:32:28 -0800
X-CSE-ConnectionGUID: 079H6gmXQzGTmDibwgioIA==
X-CSE-MsgGUID: VBAXZoG6TqSvQPH3/9PpLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="148716727"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 02 Mar 2025 09:32:27 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tonAu-000HUP-2x;
	Sun, 02 Mar 2025 17:32:24 +0000
Date: Mon, 3 Mar 2025 01:31:26 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 4/5] net/ceph/ceph_san.c:46
 ceph_san_tls_release() warn: inconsistent indenting
Message-ID: <202503030155.aCLWiEGC-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   b980c3ea5fcc54aa543fd5e96212b7fb892d42a5
commit: 284eb81c9d23609f54d9e015ce2c40076e8d8a87 [4/5] TLS logger
config: sparc-randconfig-r071-20250302 (https://download.01.org/0day-ci/archive/20250303/202503030155.aCLWiEGC-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 14.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503030155.aCLWiEGC-lkp@intel.com/

New smatch warnings:
net/ceph/ceph_san.c:46 ceph_san_tls_release() warn: inconsistent indenting
net/ceph/ceph_san.c:71 get_cephsan_context() warn: inconsistent indenting
net/ceph/ceph_san.c:120 log_cephsan_tls() warn: inconsistent indenting
net/ceph/ceph_san.c:393 cephsan_pagefrag_deinit() warn: inconsistent indenting

Old smatch warnings:
net/ceph/ceph_san.c:56 ceph_san_tls_release() warn: inconsistent indenting
net/ceph/ceph_san.c:123 log_cephsan_tls() warn: inconsistent indenting

vim +46 net/ceph/ceph_san.c

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
  > 46	        int head_idx = context->logger.head_idx & (CEPH_SAN_MAX_LOGS - 1);
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
  > 71		if (!context)
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
 > 120				entry->ts = jiffies | 0x0;
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

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

