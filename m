Return-Path: <ceph-devel+bounces-2978-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B8FA69A5C
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 21:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E895176D28
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 20:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A5C2135DE;
	Wed, 19 Mar 2025 20:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aHrZ+FuD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D6520A5DD
	for <ceph-devel@vger.kernel.org>; Wed, 19 Mar 2025 20:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742417669; cv=none; b=kdQ1B35pORsFCOt0Zbiy64sEWCt+Yi0PquS5APRhGO02BoSnmubbFMFnvmB5FeGsIDNWL2EZzVS6V4+3zalb/sRQdE9ZIDhzHtcemvd8SqLkVaNGhb40QuIkrQKC7xsnmHtum1EWGA/8cKLDKtQY3cHjdSdUBjpuWpNteNr4hJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742417669; c=relaxed/simple;
	bh=3bCY6HsdyWvhI7VFxbIY6M1QdaFGaNjFeRKZ6bA/7qs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VcdUpC/KItz8XwWfWEJtWYSTOQdLK3cZJ0vSJ4sgL/SqJ3w1XUNh39Jss8+yNQpAMFqMUffpdxhLq0qGtADXPG3qscmSMCC715+OPimLvdZmjmkpxo6zuhzcFJpLOR3II3raeaGBr/seabGTVcQyxsbI4I7yTE49qCphDWxul3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aHrZ+FuD; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742417668; x=1773953668;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=3bCY6HsdyWvhI7VFxbIY6M1QdaFGaNjFeRKZ6bA/7qs=;
  b=aHrZ+FuD8qegqClHCsbjmV6flk0NH/EwPlqngaLsG/rnDa+Q+pWUiyVe
   /ctneKoodUe/Eb1dV7C79SuDgpz+vZSdkX/yxOB52Gj+Ol3zIo3PrmKhz
   QjnDSO8w4hw9aDhEQ0E+YhzHqldmOvuEgSARslMhcgM/FQmuUyjqvma8G
   u+h3j0LooYstFEm7SnNI4tlj0iLSHCa/eXlKI7jFWpAtKjZIpJbqAQEV+
   lgBWdN40wAIuNRnd4FO62PHde7Y3A2ZjrG9XWUErrbcMfjKzaP0EJD178
   PQ/lHyUjwl2VBoBfC3B90p3nUVgfnHbmE1raIy3S+LafI1llGnd2ioSoA
   g==;
X-CSE-ConnectionGUID: h+N1sg25RMibeqoZHYR3PA==
X-CSE-MsgGUID: w0+tbmS0RX6/SEWuEq0TIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11378"; a="68982923"
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="68982923"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2025 13:54:27 -0700
X-CSE-ConnectionGUID: mmpausyqRUOoVVtiktE2mw==
X-CSE-MsgGUID: LI0/3Fk/QC6IQp8+7Dg9lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="122808094"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 19 Mar 2025 13:54:26 -0700
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tv0Qh-000Feq-34;
	Wed, 19 Mar 2025 20:54:23 +0000
Date: Thu, 20 Mar 2025 04:53:41 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 21/39] fs/ceph/debugfs.c:413:23: error:
 'struct task_struct' has no member named 'cgroups'
Message-ID: <202503200414.qjE4Iyqi-lkp@intel.com>
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
commit: 150b41eb9654d09e993407ae522128f5af588e04 [21/39] debugfs: fixups
config: x86_64-buildonly-randconfig-002-20250320 (https://download.01.org/0day-ci/archive/20250320/202503200414.qjE4Iyqi-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250320/202503200414.qjE4Iyqi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503200414.qjE4Iyqi-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/ceph/debugfs.c: In function 'print_task_cgroup':
>> fs/ceph/debugfs.c:413:23: error: 'struct task_struct' has no member named 'cgroups'
     413 |     if (!task || !task->cgroups)
         |                       ^~
   fs/ceph/debugfs.c:416:15: error: 'struct task_struct' has no member named 'cgroups'
     416 |     css = task->cgroups->subsys[0];
         |               ^~
>> fs/ceph/debugfs.c:418:39: error: invalid use of undefined type 'struct cgroup_subsys_state'
     418 |         cgroup_path_from_kernfs_id(css->cgroup->kn->id, cgroup_path, size);
         |                                       ^~


vim +413 fs/ceph/debugfs.c

   409	
   410	static int print_task_cgroup(struct task_struct *task, char *cgroup_path, size_t size)
   411	{
   412	    struct cgroup_subsys_state *css;
 > 413	    if (!task || !task->cgroups)
   414	        return 0;
   415	
   416	    css = task->cgroups->subsys[0];
   417	    if (css) {
 > 418	        cgroup_path_from_kernfs_id(css->cgroup->kn->id, cgroup_path, size);
   419	    }
   420	    return 1;
   421	}
   422	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

