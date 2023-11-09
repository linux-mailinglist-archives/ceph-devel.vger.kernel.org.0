Return-Path: <ceph-devel+bounces-74-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2354B7E6C5E
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 15:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46FD81C20BB8
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 14:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74C1200A0;
	Thu,  9 Nov 2023 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FA55a3hx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9290C1E522
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 14:24:30 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7F62D77
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 06:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699539870; x=1731075870;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4AT90AkXTHs8LauvVS7t3YKGAO6GVLS+2MaLYxix8pY=;
  b=FA55a3hxCZisIn9XDUnkEexmSCokR/tvIz70et7z3mBc0xaHJq0zs0BS
   by3AW8Giow+ejAPH45lMNDP83cIgZiAClX7H0DogeYyCGO26d/fsMDTQn
   3pdes6IXExYGyBZqX+2Uw+7pr8Z4YuOP0OBNjOluonDqPI1Yyr2KYviBq
   t6OB/oeHgz9VPdSK82vbOz0UP95rA2wOFZ713RCPVrI8oJPC6kSa7rIw/
   Kd3glLYOB38ctkttKLpcaND6IbqSFpmEnnIUr9Z5QFFLxWhWciH/ClwEg
   BQtSGvl842P5lgwjMPOP7w2nvtAx3RdTy+1TT/uAMLAftgeRcEFMIxwk4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="3021509"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="3021509"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 06:24:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="763411298"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="763411298"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 09 Nov 2023 06:24:26 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r15xI-0008mq-2U;
	Thu, 09 Nov 2023 14:24:24 +0000
Date: Thu, 9 Nov 2023 22:24:01 +0800
From: kernel test robot <lkp@intel.com>
To: Xiubo Li <xiubli@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:testing 5/17] fs/ceph/inode.c:790:47: error: expected
 ')' before 'ci'
Message-ID: <202311092233.sNJtgjfM-lkp@intel.com>
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
config: mips-allmodconfig (https://download.01.org/0day-ci/archive/20231109/202311092233.sNJtgjfM-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231109/202311092233.sNJtgjfM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311092233.sNJtgjfM-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:22,
                    from arch/mips/include/asm/bug.h:42,
                    from include/linux/bug.h:5,
                    from include/linux/fortify-string.h:5,
                    from include/linux/string.h:254,
                    from include/linux/ceph/ceph_debug.h:7,
                    from fs/ceph/inode.c:2:
   fs/ceph/inode.c: In function 'ceph_fill_file_size':
>> fs/ceph/inode.c:790:47: error: expected ')' before 'ci'
     790 |                                               ci->i_truncate_seq, truncate_seq);
         |                                               ^~
   include/linux/printk.h:379:42: note: in definition of macro '__printk_index_emit'
     379 |                 if (__builtin_constant_p(_fmt) && __builtin_constant_p(_level)) { \
         |                                          ^~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/printk.h:498:25: note: in expansion of macro 'pr_fmt'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                         ^~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
   include/linux/printk.h:379:41: note: to match this '('
     379 |                 if (__builtin_constant_p(_fmt) && __builtin_constant_p(_level)) { \
         |                                         ^
   include/linux/printk.h:426:17: note: in expansion of macro '__printk_index_emit'
     426 |                 __printk_index_emit(_fmt, NULL, NULL);                  \
         |                 ^~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
>> fs/ceph/inode.c:790:47: error: expected ')' before 'ci'
     790 |                                               ci->i_truncate_seq, truncate_seq);
         |                                               ^~
   include/linux/printk.h:388:61: note: in definition of macro '__printk_index_emit'
     388 |                                 .fmt = __builtin_constant_p(_fmt) ? (_fmt) : NULL, \
         |                                                             ^~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/printk.h:498:25: note: in expansion of macro 'pr_fmt'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                         ^~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
   include/linux/printk.h:388:60: note: to match this '('
     388 |                                 .fmt = __builtin_constant_p(_fmt) ? (_fmt) : NULL, \
         |                                                            ^
   include/linux/printk.h:426:17: note: in expansion of macro '__printk_index_emit'
     426 |                 __printk_index_emit(_fmt, NULL, NULL);                  \
         |                 ^~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
>> fs/ceph/inode.c:790:47: error: expected ')' before 'ci'
     790 |                                               ci->i_truncate_seq, truncate_seq);
         |                                               ^~
   include/linux/printk.h:388:70: note: in definition of macro '__printk_index_emit'
     388 |                                 .fmt = __builtin_constant_p(_fmt) ? (_fmt) : NULL, \
         |                                                                      ^~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/printk.h:498:25: note: in expansion of macro 'pr_fmt'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                         ^~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
   include/linux/printk.h:388:69: note: to match this '('
     388 |                                 .fmt = __builtin_constant_p(_fmt) ? (_fmt) : NULL, \
         |                                                                     ^
   include/linux/printk.h:426:17: note: in expansion of macro '__printk_index_emit'
     426 |                 __printk_index_emit(_fmt, NULL, NULL);                  \
         |                 ^~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:498:9: note: in expansion of macro 'printk'
     498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
      68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
         |         ^~~~~~
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
>> fs/ceph/inode.c:790:47: error: expected ')' before 'ci'
     790 |                                               ci->i_truncate_seq, truncate_seq);
         |                                               ^~
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
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
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
   fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
     789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
         |                                 ^~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:25: warning: format '%p' expects a matching 'void *' argument [-Wformat=]
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
>> include/linux/kern_levels.h:5:25: warning: format '%llu' expects a matching 'long long unsigned int' argument [-Wformat=]
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
>> fs/ceph/inode.c:791:72: error: expected ')' before 'isize'
     791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
         |                                                                        ^~~~~
   include/linux/printk.h:379:42: note: in definition of macro '__printk_index_emit'
     379 |                 if (__builtin_constant_p(_fmt) && __builtin_constant_p(_level)) { \
         |                                          ^~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
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
   include/linux/printk.h:379:41: note: to match this '('
     379 |                 if (__builtin_constant_p(_fmt) && __builtin_constant_p(_level)) { \
         |                                         ^
   include/linux/printk.h:426:17: note: in expansion of macro '__printk_index_emit'
     426 |                 __printk_index_emit(_fmt, NULL, NULL);                  \
         |                 ^~~~~~~~~~~~~~~~~~~
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
>> fs/ceph/inode.c:791:72: error: expected ')' before 'isize'
     791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
         |                                                                        ^~~~~
   include/linux/printk.h:388:61: note: in definition of macro '__printk_index_emit'
     388 |                                 .fmt = __builtin_constant_p(_fmt) ? (_fmt) : NULL, \
         |                                                             ^~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
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
   include/linux/printk.h:388:60: note: to match this '('
     388 |                                 .fmt = __builtin_constant_p(_fmt) ? (_fmt) : NULL, \
         |                                                            ^
   include/linux/printk.h:426:17: note: in expansion of macro '__printk_index_emit'
     426 |                 __printk_index_emit(_fmt, NULL, NULL);                  \
         |                 ^~~~~~~~~~~~~~~~~~~
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
>> fs/ceph/inode.c:791:72: error: expected ')' before 'isize'
     791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
         |                                                                        ^~~~~
   include/linux/printk.h:388:70: note: in definition of macro '__printk_index_emit'
     388 |                                 .fmt = __builtin_constant_p(_fmt) ? (_fmt) : NULL, \
         |                                                                      ^~~~
   include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
     455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
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
   include/linux/printk.h:388:69: note: to match this '('
     388 |                                 .fmt = __builtin_constant_p(_fmt) ? (_fmt) : NULL, \
         |                                                                     ^
   include/linux/printk.h:426:17: note: in expansion of macro '__printk_index_emit'
     426 |                 __printk_index_emit(_fmt, NULL, NULL);                  \
         |                 ^~~~~~~~~~~~~~~~~~~
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
>> fs/ceph/inode.c:791:72: error: expected ')' before 'isize'
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
>> include/linux/kern_levels.h:5:25: warning: format '%p' expects a matching 'void *' argument [-Wformat=]
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
>> include/linux/kern_levels.h:5:25: warning: format '%llu' expects a matching 'long long unsigned int' argument [-Wformat=]
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
>> <command-line>: warning: format '%s' expects argument of type 'char *', but argument 9 has type 'u32' {aka 'unsigned int'} [-Wformat=]
   include/linux/ceph/ceph_debug.h:5:21: note: in expansion of macro 'KBUILD_MODNAME'
       5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
         |                     ^~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in expansion of macro 'pr_fmt'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:248:9: note: in expansion of macro '__dynamic_func_call_cls'
     248 |         __dynamic_func_call_cls(__UNIQUE_ID(ddebug), cls, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:269:9: note: in expansion of macro '_dynamic_func_call'
     269 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/printk.h:579:9: note: in expansion of macro 'dynamic_pr_debug'
     579 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:23:9: note: in expansion of macro 'pr_debug'
      23 |         pr_debug("%.*s %12.12s:%-4d : [%pU %llu] " fmt,                 \
         |         ^~~~~~~~
   fs/ceph/inode.c:794:25: note: in expansion of macro 'doutc'
     794 |                         doutc(cl, "%s truncate_seq %u -> %u\n",
         |                         ^~~~~
>> <command-line>: warning: format '%u' expects a matching 'unsigned int' argument [-Wformat=]
   include/linux/ceph/ceph_debug.h:5:21: note: in expansion of macro 'KBUILD_MODNAME'
       5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
         |                     ^~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in expansion of macro 'pr_fmt'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:248:9: note: in expansion of macro '__dynamic_func_call_cls'
     248 |         __dynamic_func_call_cls(__UNIQUE_ID(ddebug), cls, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:269:9: note: in expansion of macro '_dynamic_func_call'
     269 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/printk.h:579:9: note: in expansion of macro 'dynamic_pr_debug'
     579 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:23:9: note: in expansion of macro 'pr_debug'
      23 |         pr_debug("%.*s %12.12s:%-4d : [%pU %llu] " fmt,                 \
         |         ^~~~~~~~
   fs/ceph/inode.c:794:25: note: in expansion of macro 'doutc'
     794 |                         doutc(cl, "%s truncate_seq %u -> %u\n",
         |                         ^~~~~


vim +790 fs/ceph/inode.c

   747	
   748	/*
   749	 * Helpers to fill in size, ctime, mtime, and atime.  We have to be
   750	 * careful because either the client or MDS may have more up to date
   751	 * info, depending on which capabilities are held, and whether
   752	 * time_warp_seq or truncate_seq have increased.  (Ordinarily, mtime
   753	 * and size are monotonically increasing, except when utimes() or
   754	 * truncate() increments the corresponding _seq values.)
   755	 */
   756	int ceph_fill_file_size(struct inode *inode, int issued,
   757				u32 truncate_seq, u64 truncate_size,
   758				u64 size, int newcaps)
   759	{
   760		struct ceph_client *cl = ceph_inode_to_client(inode);
   761		struct ceph_inode_info *ci = ceph_inode(inode);
   762		int queue_trunc = 0;
   763		loff_t isize = i_size_read(inode);
   764	
   765		if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) > 0 ||
   766		    (truncate_seq == ci->i_truncate_seq && size > isize)) {
   767			doutc(cl, "size %lld -> %llu\n", isize, size);
   768			if (size > 0 && S_ISDIR(inode->i_mode)) {
   769				pr_err_client(cl, "non-zero size for directory\n");
   770				size = 0;
   771			}
   772			i_size_write(inode, size);
   773			inode->i_blocks = calc_inode_blocks(size);
   774			/*
   775			 * If we're expanding, then we should be able to just update
   776			 * the existing cookie.
   777			 */
   778			if (size > isize)
   779				ceph_fscache_update(inode);
   780			ci->i_reported_size = size;
   781			if (truncate_seq != ci->i_truncate_seq) {
   782				/* the MDS should have revoked these caps */
   783				if (issued & (CEPH_CAP_FILE_RD |
   784					      CEPH_CAP_FILE_LAZYIO)) {
   785					pr_err_client(cl, "%p ino %llx.%llx already issued %s, newcaps %s\n",
   786					              inode, ceph_vinop(inode),
   787					              ceph_cap_string(issued),
   788						      ceph_cap_string(newcaps));
 > 789					pr_err_client(" truncate_seq %u -> %u\n",
 > 790					              ci->i_truncate_seq, truncate_seq);
 > 791					pr_err_client("  size %lld -> %llu\n", isize, size);
   792					WARN_ON(1);
   793				}
   794				doutc(cl, "%s truncate_seq %u -> %u\n",
   795				      ci->i_truncate_seq, truncate_seq);
   796				ci->i_truncate_seq = truncate_seq;
   797	
   798				/*
   799				 * If we hold relevant caps, or in the case where we're
   800				 * not the only client referencing this file and we
   801				 * don't hold those caps, then we need to check whether
   802				 * the file is either opened or mmaped
   803				 */
   804				if ((issued & (CEPH_CAP_FILE_CACHE|
   805					       CEPH_CAP_FILE_BUFFER)) ||
   806				    mapping_mapped(inode->i_mapping) ||
   807				    __ceph_is_file_opened(ci)) {
   808					ci->i_truncate_pending++;
   809					queue_trunc = 1;
   810				}
   811			}
   812		}
   813	
   814		/*
   815		 * It's possible that the new sizes of the two consecutive
   816		 * size truncations will be in the same fscrypt last block,
   817		 * and we need to truncate the corresponding page caches
   818		 * anyway.
   819		 */
   820		if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) >= 0) {
   821			doutc(cl, "truncate_size %lld -> %llu, encrypted %d\n",
   822			      ci->i_truncate_size, truncate_size,
   823			      !!IS_ENCRYPTED(inode));
   824	
   825			ci->i_truncate_size = truncate_size;
   826	
   827			if (IS_ENCRYPTED(inode)) {
   828				doutc(cl, "truncate_pagecache_size %lld -> %llu\n",
   829				      ci->i_truncate_pagecache_size, size);
   830				ci->i_truncate_pagecache_size = size;
   831			} else {
   832				ci->i_truncate_pagecache_size = truncate_size;
   833			}
   834		}
   835		return queue_trunc;
   836	}
   837	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

