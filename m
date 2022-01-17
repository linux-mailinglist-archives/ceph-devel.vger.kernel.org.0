Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B434901EB
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 07:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiAQGY2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 01:24:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:35138 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234643AbiAQGY1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 01:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642400667; x=1673936667;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yCn4wIZKHlYjId01rhTHa5MfOQrVzBUtGwRRGpiC0jU=;
  b=Xqzwg7VWyo2urf2vKEUjD5bs+g4HN2PoC2yjLvTbIIxwn2R4d1NhVvIw
   nctBcjxslOwRKceOY8RibfZylrPzg8Gu//ZJFYjeFibwZrMHexs7NSIR9
   ivOcJUYlwcqPojp6s34TKJcYxe0sS9ym+nCrwbqAjv4izTQgU8zKVbqNt
   8DfnkclKkEUsnSX1mmhTO9KssZQKzWUzB6XltGk6ALBDmhDlb6VpLwxUz
   fEp6usDX+rHPLmYeTa1bVK+nhDTbmfYCLdy2ZZ2tAOkx7ubV9+RznqR9O
   ONIydfCbWoNpWccjf7xRwA2iq2S1O8/EzUtI4E1uSJTGr7A54xYnDrhJC
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="243383941"
X-IronPort-AV: E=Sophos;i="5.88,294,1635231600"; 
   d="scan'208";a="243383941"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 22:24:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,294,1635231600"; 
   d="scan'208";a="517294095"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 16 Jan 2022 22:24:25 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n9LRJ-000BIp-0u; Mon, 17 Jan 2022 06:24:25 +0000
Date:   Mon, 17 Jan 2022 14:23:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Milind Changire <milindchangire@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Milind Changire <mchangir@redhat.com>
Subject: Re: [PATCH v3 1/1] ceph: add getvxattr op
Message-ID: <202201171456.wqUIG50D-lkp@intel.com>
References: <20220117035946.22442-2-mchangir@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117035946.22442-2-mchangir@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Milind,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on fd84bfdddd169c219c3a637889a8b87f70a072c2]

url:    https://github.com/0day-ci/linux/commits/Milind-Changire/ceph-add-support-for-getvxattr-op/20220117-120129
base:   fd84bfdddd169c219c3a637889a8b87f70a072c2
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20220117/202201171456.wqUIG50D-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/2c3b424994ab41a8d52471eb5a6721f466d515dc
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Milind-Changire/ceph-add-support-for-getvxattr-op/20220117-120129
        git checkout 2c3b424994ab41a8d52471eb5a6721f466d515dc
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=riscv SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/ceph/inode.c: In function 'ceph_do_getvxattr':
>> <command-line>: warning: format '%u' expects argument of type 'unsigned int', but argument 7 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
   include/linux/ceph/ceph_debug.h:5:21: note: in expansion of macro 'KBUILD_MODNAME'
       5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
         |                     ^~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:134:29: note: in expansion of macro 'pr_fmt'
     134 |                 func(&id, ##__VA_ARGS__);               \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:152:9: note: in expansion of macro '__dynamic_func_call'
     152 |         __dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:162:9: note: in expansion of macro '_dynamic_func_call'
     162 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/printk.h:574:9: note: in expansion of macro 'dynamic_pr_debug'
     574 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:19:9: note: in expansion of macro 'pr_debug'
      19 |         pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
         |         ^~~~~~~~
   fs/ceph/inode.c:2326:9: note: in expansion of macro 'dout'
    2326 |         dout("do_getvxattr xattr_value_len:%u, size:%u\n", xattr_value_len, size);
         |         ^~~~
   <command-line>: warning: format '%u' expects argument of type 'unsigned int', but argument 8 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
   include/linux/ceph/ceph_debug.h:5:21: note: in expansion of macro 'KBUILD_MODNAME'
       5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
         |                     ^~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:134:29: note: in expansion of macro 'pr_fmt'
     134 |                 func(&id, ##__VA_ARGS__);               \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:152:9: note: in expansion of macro '__dynamic_func_call'
     152 |         __dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:162:9: note: in expansion of macro '_dynamic_func_call'
     162 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/printk.h:574:9: note: in expansion of macro 'dynamic_pr_debug'
     574 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:19:9: note: in expansion of macro 'pr_debug'
      19 |         pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
         |         ^~~~~~~~
   fs/ceph/inode.c:2326:9: note: in expansion of macro 'dout'
    2326 |         dout("do_getvxattr xattr_value_len:%u, size:%u\n", xattr_value_len, size);
         |         ^~~~

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
