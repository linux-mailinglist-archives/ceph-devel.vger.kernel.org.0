Return-Path: <ceph-devel+bounces-2843-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F782A4AE24
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Mar 2025 23:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B61C57A7263
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Mar 2025 22:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E111CD215;
	Sat,  1 Mar 2025 22:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jUczk/Wy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438EBB664
	for <ceph-devel@vger.kernel.org>; Sat,  1 Mar 2025 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740868808; cv=none; b=mQg+FYl5eI49xsDvhjibMnEtB5bY18RD9JR1kdJL7xOaI9cWhLD36nq0wATdNpGEJi8rl5d9YjPCu+RzO3cpyoig6e8xXdXJ/fNU07YxX/ijBZneOWw1qresZ9V7H0KlKiG56OmPkvg1B1wi6sjpbVmqVZetHc//Y2/aIek7xt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740868808; c=relaxed/simple;
	bh=PdK1UUaMuAxvtbgNcZVnxIgrqPGUxF/T632/5X+Ktd8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BJ2NqpyBrlkLrePpIfPMVJCV526/S7AaQCs4rGD6IfuVA1qzCIHZhu/v22gLwhrJnxyJM7tRZwmDuvV+o5XkijZv0WQFsetDfFIL+MEmRRe78C2UVRLtJ6/FBApFjwS/GRknz/NgLppt24kaA9c7dZ5D2Mg0KDm8nLm8xtDhMag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jUczk/Wy; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740868806; x=1772404806;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=PdK1UUaMuAxvtbgNcZVnxIgrqPGUxF/T632/5X+Ktd8=;
  b=jUczk/WywEz1j71kdWBLF9+UVkTTy2ef55m1wD5dfmmllYDSWCrshSeI
   Mw5YTvVYpi87XFdYTumnRX6TyypFXfjOo1pSDJBm2cSYdM4cg1XKBPtCv
   gI2ZxgizznhwGmIaP7/wzFRPb82/z0FtBlaFb6N1oCj78hJuN7nee9+cT
   wl7WmnPhF0lYCYZbccMBsHEzwbPSd6YAmR7xHcEgRZsBr1Q7C+7BxEHJC
   hRNSaldNRFS7y9o9AflLpAzZVuZaFBmT9fhVJ+1bXVWDvCFk/QXLxks4V
   8E2cifCzN1gUxLNml3xsm2OwPXRoutmyFjhWAN0kGAnH213L5UZTL4VMG
   g==;
X-CSE-ConnectionGUID: +qzLoSYaTVyfm9scktuRrw==
X-CSE-MsgGUID: IIx3pppcTy+Llpuq+E7qlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11360"; a="64233316"
X-IronPort-AV: E=Sophos;i="6.13,326,1732608000"; 
   d="scan'208";a="64233316"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2025 14:40:05 -0800
X-CSE-ConnectionGUID: o5+aKWqLSJ+OcsnFNTzKaw==
X-CSE-MsgGUID: iu9ZKw4mQXuUas8x8WYiOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,326,1732608000"; 
   d="scan'208";a="117406932"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 01 Mar 2025 14:40:05 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1toVV4-000Gmy-1B;
	Sat, 01 Mar 2025 22:40:02 +0000
Date: Sun, 2 Mar 2025 06:39:04 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 4/5] fs/ceph/debugfs.c:512:21: warning:
 unused variable 'idx'
Message-ID: <202503020611.ushnPNHC-lkp@intel.com>
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
config: arc-randconfig-001-20250302 (https://download.01.org/0day-ci/archive/20250302/202503020611.ushnPNHC-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250302/202503020611.ushnPNHC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503020611.ushnPNHC-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ceph/debugfs.c: In function 'ceph_san_tls_show':
>> fs/ceph/debugfs.c:512:21: warning: unused variable 'idx' [-Wunused-variable]
     512 |                 int idx = 0;
         |                     ^~~


vim +/idx +512 fs/ceph/debugfs.c

   490	
   491	static int ceph_san_tls_show(struct seq_file *s, void *p)
   492	{
   493		struct tls_ceph_san_context *ctx;
   494		struct ceph_san_tls_logger *logger;
   495		struct ceph_san_log_entry_tls *entry;
   496		unsigned long flags;
   497		int count = 0;
   498	
   499		seq_printf(s, "All Ceph SAN TLS logs from all contexts:\n");
   500		seq_printf(s, "%-8s %-16s %-20s %-8s %-s\n",
   501				   "PID", "Task", "Timestamp", "Index", "Log Message");
   502		seq_printf(s, "-------------------------------------------------------------------------\n");
   503	
   504		spin_lock_irqsave(&g_ceph_san_contexts_lock, flags);
   505	
   506		list_for_each_entry(ctx, &g_ceph_san_contexts, list) {
   507			logger = &ctx->logger;
   508			count++;
   509	
   510			seq_printf(s, "\n=== Context for PID %d ===\n", logger->pid);
   511	
 > 512			int idx = 0;
   513			int head_idx = logger->head_idx & (CEPH_SAN_MAX_LOGS - 1);
   514			int tail_idx = (head_idx + 1) & (CEPH_SAN_MAX_LOGS - 1);
   515	
   516			for (int i = tail_idx; (i & (CEPH_SAN_MAX_LOGS - 1)) != head_idx; i++) {
   517				struct timespec64 ts;
   518				entry = &logger->logs[i & (CEPH_SAN_MAX_LOGS - 1)];
   519	
   520				if (entry->ts == 0 || !entry->buf) {
   521					continue;
   522				}
   523	
   524				jiffies_to_timespec64(entry->ts, &ts);
   525	
   526				seq_printf(s, "%-8d %-16s %lld.%09ld\n",
   527						  logger->pid,
   528						  logger->comm,
   529						  (long long)ts.tv_sec,
   530						  ts.tv_nsec);
   531			}
   532	
   533			seq_printf(s, "\n");
   534		}
   535	
   536		spin_unlock_irqrestore(&g_ceph_san_contexts_lock, flags);
   537	
   538		if (count == 0) {
   539			seq_printf(s, "No TLS contexts found.\n");
   540		} else {
   541			seq_printf(s, "\nTotal contexts: %d\n", count);
   542		}
   543	
   544		return 0;
   545	}
   546	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

