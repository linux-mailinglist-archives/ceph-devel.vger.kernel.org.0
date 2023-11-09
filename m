Return-Path: <ceph-devel+bounces-76-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05AD27E72A6
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 21:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57A4D281023
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 20:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956D0374C0;
	Thu,  9 Nov 2023 20:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="meYMseRi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316EF374C1
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 20:10:31 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA7D44AF
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 12:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699560630; x=1731096630;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=8dCLp2+y+Vp81Snocx4WjEi+kHxZnTxlXpSehl2oVrs=;
  b=meYMseRiCKSoFvNWyuGNsTgmxECCNIj3jLivLOxQelvt2E/INJiBa1a8
   fsg/ja3Svf518H68xXvfoXQr4tf2zMWxDmzQvnFllTT2fxrpQ8kXZmu1U
   wpzk05ZhMyDDlvjgv/Hc6IF85SA801nwy53UTYjJ6BX4/rK5eZxE6pydy
   XFhwNhUGkJaqyNcezZ30lrNVBvs5i/y00BrW23KHJPZRIg0sh4XixkgrP
   UfE5X4u7zPkpbkuwFEmUsgWT0RFJDjgcgwTDskl4zMmn+nAR5EouIgSHv
   OplSeRzkuQnsdd9+nWf4WLzpmhY/FxPVmlu6vQfdzMqYHcG1jytn+3kxi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="388924676"
X-IronPort-AV: E=Sophos;i="6.03,290,1694761200"; 
   d="scan'208";a="388924676"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 12:10:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="887135184"
X-IronPort-AV: E=Sophos;i="6.03,290,1694761200"; 
   d="scan'208";a="887135184"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 09 Nov 2023 12:10:28 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r1BMA-00096W-1o;
	Thu, 09 Nov 2023 20:10:26 +0000
Date: Fri, 10 Nov 2023 04:10:08 +0800
From: kernel test robot <lkp@intel.com>
To: Xiubo Li <xiubli@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:testing 5/17] include/linux/kern_levels.h:5:25:
 warning: format '%s' expects argument of type 'char *', but argument 5 has
 type 'u32' {aka 'unsigned int'}
Message-ID: <202311100323.X2ldielo-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git testing
head:   df68d14f678dc8f70ab1dc9cb4f1257af7b7d91b
commit: c67942de8d2ccb3f1a8d1b87908f679be5a9d6a3 [5/17] [DO NOT MERGE] ceph: BUG if MDS changed truncate_seq with client caps still outstanding
config: i386-randconfig-006-20231110 (https://download.01.org/0day-ci/archive/20231110/202311100323.X2ldielo-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231110/202311100323.X2ldielo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311100323.X2ldielo-lkp@intel.com/

All warnings (new ones prefixed by >>):

         |         ^~~~~~
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
   include/linux/kern_levels.h:5:25: warning: format '%llu' expects a matching 'long long unsigned int' argument [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
      11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:498:16: note: in expansion of macro 'KERN_ERR'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
   fs/ceph/inode.c:791:72: error: expected ')' before 'isize'
     791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
         |                                                                        ^~~~~
   include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/printk.h:498:25: note: in expansion of macro 'pr_fmt'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                         ^~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:791:33: note: in expansion of macro 'pr_err_client'
     791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
         |                                 ^~~~~~~~~~~~~
   include/linux/printk.h:427:24: note: to match this '('
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                        ^
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:791:33: note: in expansion of macro 'pr_err_client'
     791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
         |                                 ^~~~~~~~~~~~~
   include/linux/kern_levels.h:5:25: warning: format '%p' expects a matching 'void *' argument [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
      11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:498:16: note: in expansion of macro 'KERN_ERR'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:791:33: note: in expansion of macro 'pr_err_client'
     791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
         |                                 ^~~~~~~~~~~~~
   include/linux/kern_levels.h:5:25: warning: format '%llu' expects a matching 'long long unsigned int' argument [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
      11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
         |                         ^~~~~~~~
   include/linux/printk.h:498:16: note: in expansion of macro 'KERN_ERR'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:791:33: note: in expansion of macro 'pr_err_client'
     791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
         |                                 ^~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:25: warning: format '%s' expects argument of type 'char *', but argument 5 has type 'u32' {aka 'unsigned int'} [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:129:17: note: in expansion of macro 'printk'
     129 |                 printk(fmt, ##__VA_ARGS__);             \
         |                 ^~~~~~
   include/linux/printk.h:585:9: note: in expansion of macro 'no_printk'
     585 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~
   include/linux/kern_levels.h:15:25: note: in expansion of macro 'KERN_SOH'
      15 | #define KERN_DEBUG      KERN_SOH "7"    /* debug-level messages */
         |                         ^~~~~~~~
   include/linux/printk.h:585:19: note: in expansion of macro 'KERN_DEBUG'
     585 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                   ^~~~~~~~~~
   include/linux/ceph/ceph_debug.h:50:9: note: in expansion of macro 'pr_debug'
      50 |         pr_debug(" [%pU %llu] %s: " fmt, &client->fsid,                 \
         |         ^~~~~~~~
   fs/ceph/inode.c:794:25: note: in expansion of macro 'doutc'
     794 |                         doutc(cl, "%s truncate_seq %u -> %u\n",
         |                         ^~~~~
>> include/linux/kern_levels.h:5:25: warning: format '%u' expects a matching 'unsigned int' argument [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
     427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:129:17: note: in expansion of macro 'printk'
     129 |                 printk(fmt, ##__VA_ARGS__);             \
         |                 ^~~~~~
   include/linux/printk.h:585:9: note: in expansion of macro 'no_printk'
     585 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~
   include/linux/kern_levels.h:15:25: note: in expansion of macro 'KERN_SOH'
      15 | #define KERN_DEBUG      KERN_SOH "7"    /* debug-level messages */
         |                         ^~~~~~~~
   include/linux/printk.h:585:19: note: in expansion of macro 'KERN_DEBUG'
     585 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                   ^~~~~~~~~~
   include/linux/ceph/ceph_debug.h:50:9: note: in expansion of macro 'pr_debug'
      50 |         pr_debug(" [%pU %llu] %s: " fmt, &client->fsid,                 \
         |         ^~~~~~~~
   fs/ceph/inode.c:794:25: note: in expansion of macro 'doutc'
     794 |                         doutc(cl, "%s truncate_seq %u -> %u\n",
         |                         ^~~~~


vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

:::::: The code at line 5 was first introduced by commit
:::::: 04d2c8c83d0e3ac5f78aeede51babb3236200112 printk: convert the format for KERN_<LEVEL> to a 2 byte pattern

:::::: TO: Joe Perches <joe@perches.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

