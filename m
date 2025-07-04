Return-Path: <ceph-devel+bounces-3266-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F7FAF8D6D
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jul 2025 11:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39C8D76219E
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jul 2025 09:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FE82F2C59;
	Fri,  4 Jul 2025 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lD1akZQl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39AA2F2734
	for <ceph-devel@vger.kernel.org>; Fri,  4 Jul 2025 08:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619332; cv=none; b=qtRUd2b29KcLP9AAlG5KsymIpkKy/U+zHBJBP8mS2Z+RPlC2J1oofry2wg0So+Rew/pXi6DPv//r7Oe6hqX0PzWaCgVIOSeZZM4oMyxzEZ37gf6ZDpqb7ReiEsNeW+e4kwW3vRLg22U5M7gy2LOx4vVSyItWnJEilcDjKMfOvIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619332; c=relaxed/simple;
	bh=l5cx+9qiwz1/mdN8psfGuZAOxVWeKzWAIoNKt73zuJU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iH1WpAwlXSsuuZynakt0RHKKkBMXfpZQ4ZEIyqezM1SzDn4BzeBw09t7yCx5s78TFEfZjiZJTECFG141+vth1ou9i2TYZk4Or9yGHI9cFVpQZnU1nq5SZU6+gw7EWY2FnGz/xgp9i/bWFuspPNh0fGxJlaXkqaScpUIqh7/ppRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lD1akZQl; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619331; x=1783155331;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=l5cx+9qiwz1/mdN8psfGuZAOxVWeKzWAIoNKt73zuJU=;
  b=lD1akZQlC1dx2XrADDY4YpPzwMzmyy5sWH55ef+PyiVzowA/QtXWi8Zt
   TP5RRexj6ytoI0Vkxyxi8mhWlk0WxXyu0AAYnjDTBtH8XEh/MSDiR9eE3
   oJY+gZTqi4wTsU3MCGnG2SrlQBocXdzpNiysbwBgSyKeCE3xssnfCFtKF
   AxdKChcDtWAEeatd2IxajO0gl/vI0Bp7nXhddQTjETlpFIBSkqTOJqEtq
   O+tV/EENSCsvhF551rIPwSMq9g/3j6722FA2jLp4lqv0GG2DqcCwxSAHg
   a0Ivkz7OFIwxX6Aeoid7NOXQ43RnWqABRzteI6K31R4OmO8xz0YqcgKx3
   g==;
X-CSE-ConnectionGUID: xArozWnXR5yzWiEngNRlPg==
X-CSE-MsgGUID: BFhObb6wTQqdGahQ0n79cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="57761123"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="57761123"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:55:30 -0700
X-CSE-ConnectionGUID: zeEv05baT5elNOAH80IJKw==
X-CSE-MsgGUID: UfbzOGDHRzmQuQeSuwRJXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="178263680"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 04 Jul 2025 01:55:29 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uXcCd-0003WV-0H;
	Fri, 04 Jul 2025 08:55:27 +0000
Date: Fri, 4 Jul 2025 16:55:18 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:binary_tracing 2/4] net/ceph/ceph_san_logger.c:313:5:
 warning: 'strncpy' output may be truncated copying 15 bytes from a string of
 length 15
Message-ID: <202507041628.HXpoOzaS-lkp@intel.com>
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
config: arm64-randconfig-004-20250704 (https://download.01.org/0day-ci/archive/20250704/202507041628.HXpoOzaS-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250704/202507041628.HXpoOzaS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507041628.HXpoOzaS-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ceph/ceph_san_logger.c: In function 'ceph_san_get_tls_ctx':
>> net/ceph/ceph_san_logger.c:313:5: warning: 'strncpy' output may be truncated copying 15 bytes from a string of length 15 [-Wstringop-truncation]
     313 |     strncpy(ctx->comm, current->comm, TASK_COMM_LEN);
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/strncpy +313 net/ceph/ceph_san_logger.c

   264	
   265	static void ceph_san_tls_release_verbose(void *ptr)
   266	{
   267	    struct ceph_san_tls_ctx *ctx = container_of(ptr, struct ceph_san_tls_ctx, release);
   268	    if (!ctx) {
   269	        pr_err("ceph_san_logger -- Callback : invalid TLS context pointer %d\n", current->pid);
   270	        return;
   271	    }
   272	    if (ctx->debug_poison != CEPH_SAN_CTX_POISON) {
   273	        pr_err("ceph_san_logger -- Callback : invalid TLS context id=%llu has invalid debug_poison value 0x%llx\n",
   274	               ctx->id, (unsigned long long)ctx->debug_poison);
   275	        BUG();
   276	    }
   277	    if (atomic_read(&ctx->refcount) != 1) {
   278	        pr_err("ceph_san_logger -- Callback : invalid TLS context refcount %d for pid %d [%s]\n",
   279	               atomic_read(&ctx->refcount), ctx->pid, ctx->comm);
   280	        BUG();
   281	    }
   282	    ceph_san_tls_release(ctx);
   283	}
   284	/**
   285	 * ceph_san_get_tls_ctx - Get or create TLS context for current task
   286	 *
   287	 * Returns pointer to TLS context or NULL on error
   288	 */
   289	struct ceph_san_tls_ctx *ceph_san_get_tls_ctx(void)
   290	{
   291	    struct ceph_san_tls_ctx *ctx = get_tls_ctx(); /* Inline helper, gets container_of */
   292	
   293	    if (ctx) {
   294	        if (!is_valid_active_ctx(ctx, "Existing TLS")) {
   295	            current->tls_ctx = NULL; /* Invalidate bad pointer */
   296	            BUG();
   297	        }
   298	        return ctx;
   299	    }
   300	
   301	    /* Create new context */
   302	    pr_debug("ceph_san_logger: creating new TLS context for pid %d [%s]\n",
   303	             current->pid, current->comm);
   304	
   305	    ctx = get_new_ctx(); /* Get base context with refcount 0 */
   306	    if (!ctx)
   307	        return NULL;
   308	
   309	    /* Set up TLS specific parts */
   310	    current->tls_ctx = (void *)&ctx->release;
   311	    ctx->task = current;
   312	    ctx->pid = current->pid;
 > 313	    strncpy(ctx->comm, current->comm, TASK_COMM_LEN);
   314	    ctx->comm[TASK_COMM_LEN - 1] = '\0'; /* Ensure null termination */
   315	
   316	    /* Increment refcount from 0 to 1 */
   317	    if (atomic_inc_return(&ctx->refcount) != 1) {
   318	        pr_err("BUG: Failed to set refcount=1 for new TLS context id=%llu (was %d before inc)\n",
   319	                ctx->id, atomic_read(&ctx->refcount) - 1);
   320	        current->tls_ctx = NULL; /* Don't leave partially set up context */
   321	        BUG();
   322	    }
   323	
   324	    pr_debug("ceph_san_logger: successfully created new TLS context id=%llu for pid %d [%s]\n",
   325	           ctx->id, ctx->pid, ctx->comm);
   326	    return ctx;
   327	}
   328	EXPORT_SYMBOL(ceph_san_get_tls_ctx);
   329	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

