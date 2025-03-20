Return-Path: <ceph-devel+bounces-2980-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E9A3A69EF1
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Mar 2025 05:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BA353B4D8F
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Mar 2025 04:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210F71C3C1D;
	Thu, 20 Mar 2025 04:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eMDlmNbe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AF678F5E
	for <ceph-devel@vger.kernel.org>; Thu, 20 Mar 2025 04:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742443670; cv=none; b=Ji3liLxtw4m7GWzgUiqbM1q3lZwCHwS+fqSgmqj80NoLa8SvLoyKTdWCzW/d90DU7r3IjS5+Mcvemo5/4ix5DRXqaQkw4CRk/Qu0oeKtUrQLkLWax/uE3MjPWyA+3z1nbCuUNgvpgF8fWctLIXpbRAnLjv4Ns6USffUQYThDS4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742443670; c=relaxed/simple;
	bh=HhUPj+6CHoORJOPeSrROpdDhFffmAw1/d5cxWw8emj0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uvbINE1SQ954IEcN+BGhV//ElAODSSNzY7j49E552lQZPgzsQgRhfQ9/JhAEcCu2ndZcAtJBoZBQ1UD8aJxBKh7cXWqn+Dr7f8Fo5a6VhX+k9d9Qpx6oGfblnqsJC5xjug3KDJbJg9R2Kz5nGB8DwaZ69C2v9iACF3gxsrNS4ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eMDlmNbe; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742443668; x=1773979668;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=HhUPj+6CHoORJOPeSrROpdDhFffmAw1/d5cxWw8emj0=;
  b=eMDlmNbeYSIzJO3jhtpTrA4vYaabsecrEoGkgfb519BdknhQ0yGgjzJi
   2//JCCu8QarA1o0TbanL+hVp+66jtM/3JrOQfCHWi+j7n2azYAoWdUlLz
   ZOZh64ELUAxCDZzH3Gm81V3wPJ52nc6Q84ln2NQIlemXkVu8Bquf6Wbmf
   CwjjOnXwgfxLLxB8XImodnh7FuVoD86NQZYhlCpBEDYqMkxJXgvwuXr/h
   PujSu9iMbhPAeQLDo6f76kY/QPNfGX8ubS12D1Hkf5FRBvNDL18pIfqNe
   OR8WWmws+sm5HVsR+KAWH8K6ir/LQ1Aa5Mk/F8i7/5Q+JCY00RGIFeq47
   g==;
X-CSE-ConnectionGUID: 7ObzoUbNQuCuy2XOMGDdiw==
X-CSE-MsgGUID: oihdii6yRsiop5yxrjY1JQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11378"; a="55040529"
X-IronPort-AV: E=Sophos;i="6.14,260,1736841600"; 
   d="scan'208";a="55040529"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2025 21:07:47 -0700
X-CSE-ConnectionGUID: 8JCQGTlsRzWequHkxBRrmg==
X-CSE-MsgGUID: Hy41Y46DTh+k919CWAujvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,260,1736841600"; 
   d="scan'208";a="122741265"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 19 Mar 2025 21:07:46 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tv7Af-0000Br-0G;
	Thu, 20 Mar 2025 04:07:09 +0000
Date: Thu, 20 Mar 2025 12:01:40 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 21/39] fs/ceph/debugfs.c:413:25: error: no
 member named 'cgroups' in 'struct task_struct'
Message-ID: <202503201109.rmiFfk3H-lkp@intel.com>
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
config: s390-randconfig-r062-20250320 (https://download.01.org/0day-ci/archive/20250320/202503201109.rmiFfk3H-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250320/202503201109.rmiFfk3H-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503201109.rmiFfk3H-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/ceph/debugfs.c:413:25: error: no member named 'cgroups' in 'struct task_struct'
       if (!task || !task->cgroups)
                     ~~~~  ^
   fs/ceph/debugfs.c:416:17: error: no member named 'cgroups' in 'struct task_struct'
       css = task->cgroups->subsys[0];
             ~~~~  ^
>> fs/ceph/debugfs.c:418:39: error: incomplete definition of type 'struct cgroup_subsys_state'
           cgroup_path_from_kernfs_id(css->cgroup->kn->id, cgroup_path, size);
                                      ~~~^
   include/linux/kthread.h:219:8: note: forward declaration of 'struct cgroup_subsys_state'
   struct cgroup_subsys_state;
          ^
   3 errors generated.


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

