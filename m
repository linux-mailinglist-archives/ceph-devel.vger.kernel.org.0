Return-Path: <ceph-devel+bounces-3361-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B25B1DF3D
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Aug 2025 00:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A1B7583BEB
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Aug 2025 22:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882061FC0E2;
	Thu,  7 Aug 2025 22:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wu+6Tcff"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7F81C8633
	for <ceph-devel@vger.kernel.org>; Thu,  7 Aug 2025 22:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754604602; cv=none; b=hOR7C62gQ32uiKQvvSlvBK4XWf+VOOEHLr5VwARLvhLbIqKTf+XnYsW01Gm4QZsnlzbuAv+zwngmmycZgvnigWBkpJfl/n3eOCitWfwCt9nlQpiuv5RWKjewL/X7QBuvFiWNUHqMk1QJRjuaAJ5WfKcHUMiB8XjEW7YQE+CG5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754604602; c=relaxed/simple;
	bh=xXrfZGazxAM855ubj0eUvD1vkiP8TzfU8oT4oa4W1rw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iP6I3oo584lan9qg2b/argjraPcQ+lrb1EYVM02wGIjhLr4YvnGxRkPTSSPR99YVq36Gj51xNIMBWvOKANyO3FEmqhqkhHqSnzN0FSC/NurVgMFXQlRJhL+kHEaqfwiM3OgieeWFdUA/7JLbbJc6s1GVYlbTfuJ3kocmzRbrS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wu+6Tcff; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754604600; x=1786140600;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=xXrfZGazxAM855ubj0eUvD1vkiP8TzfU8oT4oa4W1rw=;
  b=Wu+6TcffmxC3bRYV6J1wEyjg0OFwZI4adnnffF4UweMC7toDZHR2eO3+
   BMVfHmA3cmCPdgl1zdEa5QbVYvAYEam7ZXU+D9DI4tfD+GKP78OTYOzv5
   5g4pHujbiEOVyTUdxd89/3MRkZfIIRWHSU5wNimqlI/CRxQHHv/6Abdgu
   JmyQVsWnOEW7W3PDhVoA8b5wsMqpIsTx+w+XZ/kk65YK045tqR1HL5CNp
   NMZUJi0WSNoiVFsvgrHjVM4rtjra/2Xt6+0+4l5skRzOcKfuvDPia5LwY
   nQ8zr1gv6a+vtB4TRo1r2Yg88LYWzHRJX8pLXebIEqv7qQELYQIVfTfTA
   w==;
X-CSE-ConnectionGUID: 9RRX5OVPSOSW8Q/MedmD+A==
X-CSE-MsgGUID: 6TIAVQdtT1qKPzIcYfciuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="74529148"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="74529148"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 15:09:59 -0700
X-CSE-ConnectionGUID: 3rhhNP+4TWemcEEHQtlnYw==
X-CSE-MsgGUID: Iugv/aIERyu00FeHHzC8yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="169385876"
Received: from unknown (HELO b3b7d4258b7c) ([10.91.175.65])
  by orviesa003.jf.intel.com with ESMTP; 07 Aug 2025 15:09:58 -0700
Received: from kbuild by b3b7d4258b7c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uk8o7-0002XP-22;
	Thu, 07 Aug 2025 22:09:55 +0000
Date: Fri, 8 Aug 2025 00:09:27 +0200
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls-tracing-only 10/14] fs/ceph/debugfs.c:420:3: error:
 call to undeclared function 'rtlog_log_iter_init'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202508080007.MgUCTMaC-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls-tracing-only
head:   ffad14ce035a047cbfda2d38f7ae37b0767de136
commit: 310aa14b5bf4d5ecd1abf6a00782e044f7d76940 [10/14] ceph integration
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250808/202508080007.MgUCTMaC-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250808/202508080007.MgUCTMaC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508080007.MgUCTMaC-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/ceph/debugfs.c:367:19: warning: variable 'seconds' set but not used [-Wunused-but-set-variable]
     367 |     unsigned long seconds;
         |                   ^
   fs/ceph/debugfs.c:416:13: error: use of undeclared identifier 'g_rtlog_logger'
     416 |         spin_lock(&g_rtlog_logger.lock);
         |                    ^
   fs/ceph/debugfs.c:418:28: error: use of undeclared identifier 'g_rtlog_logger'
     418 |         list_for_each_entry(ctx, &g_rtlog_logger.contexts, list) {
         |                                   ^
   fs/ceph/debugfs.c:418:28: error: use of undeclared identifier 'g_rtlog_logger'
   fs/ceph/debugfs.c:418:28: error: use of undeclared identifier 'g_rtlog_logger'
   fs/ceph/debugfs.c:418:28: error: use of undeclared identifier 'g_rtlog_logger'
>> fs/ceph/debugfs.c:420:3: error: call to undeclared function 'rtlog_log_iter_init'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     420 |                 rtlog_log_iter_init(&iter, &ctx->pf);
         |                 ^
>> fs/ceph/debugfs.c:431:19: error: call to undeclared function 'rtlog_log_iter_next'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     431 |                 while ((entry = rtlog_log_iter_next(&iter)) != NULL) {
         |                                 ^
   fs/ceph/debugfs.c:431:17: error: incompatible integer to pointer conversion assigning to 'struct rtlog_log_entry *' from 'int' [-Wint-conversion]
     431 |                 while ((entry = rtlog_log_iter_next(&iter)) != NULL) {
         |                               ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
>> fs/ceph/debugfs.c:436:19: error: call to undeclared function 'rtlog_is_valid_kernel_addr'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     436 |                         if (!entry || !rtlog_is_valid_kernel_addr(entry)) {
         |                                        ^
   fs/ceph/debugfs.c:423:7: warning: variable 'ctx_entries' set but not used [-Wunused-but-set-variable]
     423 |                 int ctx_entries = 0;
         |                     ^
   fs/ceph/debugfs.c:481:15: error: use of undeclared identifier 'g_rtlog_logger'
     481 |         spin_unlock(&g_rtlog_logger.lock);
         |                      ^
   fs/ceph/debugfs.c:502:24: error: use of undeclared identifier 'g_rtlog_logger'
     502 |     spin_lock_irqsave(&g_rtlog_logger.lock, flags);
         |                        ^
   fs/ceph/debugfs.c:506:31: error: use of undeclared identifier 'g_rtlog_logger'
     506 |     list_for_each_entry(ctx, &g_rtlog_logger.contexts, list) {
         |                               ^
   fs/ceph/debugfs.c:506:31: error: use of undeclared identifier 'g_rtlog_logger'
   fs/ceph/debugfs.c:506:31: error: use of undeclared identifier 'g_rtlog_logger'
   fs/ceph/debugfs.c:506:31: error: use of undeclared identifier 'g_rtlog_logger'
   fs/ceph/debugfs.c:516:29: error: use of undeclared identifier 'g_rtlog_logger'
     516 |     spin_unlock_irqrestore(&g_rtlog_logger.lock, flags);
         |                             ^
   2 warnings and 16 errors generated.


vim +/rtlog_log_iter_init +420 fs/ceph/debugfs.c

   405	
   406	static int rtlog_tls_show_internal(struct seq_file *s, void *p)
   407	{
   408		struct rtlog_tls_ctx *ctx;
   409		struct rtlog_log_iter iter;
   410		struct rtlog_log_entry *entry;
   411		const struct rtlog_source_info *source;
   412		int total_entries = 0;
   413		int total_contexts = 0;
   414	
   415		/* Lock the logger to safely traverse the contexts list */
 > 416		spin_lock(&g_rtlog_logger.lock);
   417	
 > 418		list_for_each_entry(ctx, &g_rtlog_logger.contexts, list) {
   419			/* Initialize iterator for this context's pagefrag */
 > 420			rtlog_log_iter_init(&iter, &ctx->pf);
   421			int pid = ctx->pid;
   422			char *comm = ctx->comm;
   423			int ctx_entries = 0;
   424	
   425			total_contexts++;
   426	
   427			/* Lock the pagefrag before accessing entries */
   428			spin_lock_bh(&ctx->pf.lock);
   429	
   430			/* Iterate through log entries in this context */
 > 431			while ((entry = rtlog_log_iter_next(&iter)) != NULL) {
   432				char datetime_str[32];
   433				char reconstructed_msg[256];
   434	
   435				/* Validate entry before processing */
 > 436				if (!entry || !rtlog_is_valid_kernel_addr(entry)) {
   437					seq_printf(s, "[%d][%s]: Invalid entry pointer %p\n", pid, comm, entry);
   438					break;
   439				}
   440	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

