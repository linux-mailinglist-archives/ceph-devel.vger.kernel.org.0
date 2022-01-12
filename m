Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC6548C6C9
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jan 2022 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354435AbiALPI5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 10:08:57 -0500
Received: from mga06.intel.com ([134.134.136.31]:21906 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244287AbiALPI5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 10:08:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642000137; x=1673536137;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NrEYlME8cTzwI7qY0lUeX1+iKSNmx/P/RxGw6VmZkYY=;
  b=hfL2Mpz+5VbxdshiTTAp6qZ7TyVQ6FEl0zJYMsZ+wCVHcLC+rQ1gOBYC
   AubHRS0txrdiM4xaG3++8X+dY0tjZufElWXJjprl/M+cVTL1vBKQY4g58
   nLb/y1pD8emCzCZQl6mvgM+sfyOl2CDCZ05WeJDdFoEgE6q7kTr0BymFT
   RNEV85+MythRDxoEbOPgbqT6tHhP7kFCbKlDEVv8lBcMm78xFugRuqOd6
   9kFjaKc5q6XMPDC6HREsMFWSmNg5t0F6+vGeVQWHDGqCSnMR0fpdeZGmw
   8I6oowEfBNal3dIYweK+KELpBA4JOrT983w0cW1S+sQdWf+uqQlYQLSXP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="304491123"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="304491123"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 07:08:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="623472154"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 12 Jan 2022 07:08:54 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n7fF8-0005z2-9L; Wed, 12 Jan 2022 15:08:54 +0000
Date:   Wed, 12 Jan 2022 23:08:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Milind Changire <milindchangire@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Milind Changire <mchangir@redhat.com>
Subject: Re: [PATCH 1/1] ceph: add getvxattr op
Message-ID: <202201122237.Lspc8TH5-lkp@intel.com>
References: <20220111122431.93683-2-mchangir@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111122431.93683-2-mchangir@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Milind,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ceph-client/for-linus]
[also build test WARNING on v5.16 next-20220112]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Milind-Changire/ceph-add-getvxattr-support/20220111-202533
base:   https://github.com/ceph/ceph-client.git for-linus
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220112/202201122237.Lspc8TH5-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/9e670d02ce9f9d6e1ac3e234a89d305c85302338
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Milind-Changire/ceph-add-getvxattr-support/20220111-202533
        git checkout 9e670d02ce9f9d6e1ac3e234a89d305c85302338
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/gpu/drm/vmwgfx/ drivers/iio/ fs/ceph/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/ceph/inode.c: In function 'ceph_do_getvxattr':
>> <command-line>: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
   include/linux/ceph/ceph_debug.h:5:21: note: in expansion of macro 'KBUILD_MODNAME'
       5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
         |                     ^~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:134:15: note: in expansion of macro 'pr_fmt'
     134 |   func(&id, ##__VA_ARGS__);  \
         |               ^~~~~~~~~~~
   include/linux/dynamic_debug.h:152:2: note: in expansion of macro '__dynamic_func_call'
     152 |  __dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:162:2: note: in expansion of macro '_dynamic_func_call'
     162 |  _dynamic_func_call(fmt, __dynamic_pr_debug,  \
         |  ^~~~~~~~~~~~~~~~~~
   include/linux/printk.h:574:2: note: in expansion of macro 'dynamic_pr_debug'
     574 |  dynamic_pr_debug(fmt, ##__VA_ARGS__)
         |  ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:19:2: note: in expansion of macro 'pr_debug'
      19 |  pr_debug("%.*s %12.12s:%-4d : " fmt,    \
         |  ^~~~~~~~
   fs/ceph/inode.c:2326:2: note: in expansion of macro 'dout'
    2326 |  dout("do_getvxattr xattr_value_len:%lu, size:%lu\n", xattr_value_len, size);
         |  ^~~~
   <command-line>: warning: format '%lu' expects argument of type 'long unsigned int', but argument 8 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
   include/linux/ceph/ceph_debug.h:5:21: note: in expansion of macro 'KBUILD_MODNAME'
       5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
         |                     ^~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:134:15: note: in expansion of macro 'pr_fmt'
     134 |   func(&id, ##__VA_ARGS__);  \
         |               ^~~~~~~~~~~
   include/linux/dynamic_debug.h:152:2: note: in expansion of macro '__dynamic_func_call'
     152 |  __dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:162:2: note: in expansion of macro '_dynamic_func_call'
     162 |  _dynamic_func_call(fmt, __dynamic_pr_debug,  \
         |  ^~~~~~~~~~~~~~~~~~
   include/linux/printk.h:574:2: note: in expansion of macro 'dynamic_pr_debug'
     574 |  dynamic_pr_debug(fmt, ##__VA_ARGS__)
         |  ^~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:19:2: note: in expansion of macro 'pr_debug'
      19 |  pr_debug("%.*s %12.12s:%-4d : " fmt,    \
         |  ^~~~~~~~
   fs/ceph/inode.c:2326:2: note: in expansion of macro 'dout'
    2326 |  dout("do_getvxattr xattr_value_len:%lu, size:%lu\n", xattr_value_len, size);
         |  ^~~~

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
