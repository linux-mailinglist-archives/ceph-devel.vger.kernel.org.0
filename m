Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D481649034C
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 08:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiAQH7b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 02:59:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:62557 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237810AbiAQH7a (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 02:59:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642406370; x=1673942370;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J6L442D4+wPyafdBb32yJmo2x0TLNTOrMacOc2ikUhI=;
  b=gNU+ddJybva2AdWUe3YyjOMPy9Rww5wjd57dyttA3wn7am5zSRUiafjJ
   EVF2J36YPFxkAeljhUZ/nfnxZF4gbo+s8INQHq9Uo3YapYOHJ0340KRW9
   o/AfhAwokSIlZM/z7lnwDs/RbaEZXuiWgGT1qjTzfc4TW8O5jV436RZo7
   kQ1Sp0xzz5Rc5vOuk3PHlq3VnQd3yUvEgnsoFtuVU5AAxkOMlSZpo3NY5
   7B8+s0bUm8A8C1ZUlhmkQmmsiT9buVADsIN1ucPkj2BlWhhBDOh2XetmE
   jhbL5tuXJuc3CcnG+bWytM/yOwJN3+eTVP1eoqJip4iM9C9yOSUtShpI6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="244531617"
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="244531617"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 23:59:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="625107861"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 16 Jan 2022 23:59:27 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n9MvG-000BMz-Lm; Mon, 17 Jan 2022 07:59:26 +0000
Date:   Mon, 17 Jan 2022 15:58:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Milind Changire <milindchangire@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Milind Changire <mchangir@redhat.com>
Subject: Re: [PATCH v3 1/1] ceph: add getvxattr op
Message-ID: <202201171516.ilKzMFxt-lkp@intel.com>
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
config: x86_64-randconfig-r002-20220117 (https://download.01.org/0day-ci/archive/20220117/202201171516.ilKzMFxt-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 5f782d25a742302d25ef3c8b84b54f7483c2deb9)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/2c3b424994ab41a8d52471eb5a6721f466d515dc
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Milind-Changire/ceph-add-support-for-getvxattr-op/20220117-120129
        git checkout 2c3b424994ab41a8d52471eb5a6721f466d515dc
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/ceph/inode.c:2326:53: warning: format specifies type 'unsigned int' but the argument has type 'size_t' (aka 'unsigned long') [-Wformat]
           dout("do_getvxattr xattr_value_len:%u, size:%u\n", xattr_value_len, size);
                                              ~~              ^~~~~~~~~~~~~~~
                                              %lu
   include/linux/ceph/ceph_debug.h:26:29: note: expanded from macro 'dout'
                           printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
                                             ~~~    ^~~~~~~~~~~
   include/linux/printk.h:450:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                       ~~~    ^~~~~~~~~~~
   include/linux/printk.h:422:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                           ~~~~    ^~~~~~~~~~~
   fs/ceph/inode.c:2326:70: warning: format specifies type 'unsigned int' but the argument has type 'size_t' (aka 'unsigned long') [-Wformat]
           dout("do_getvxattr xattr_value_len:%u, size:%u\n", xattr_value_len, size);
                                                       ~~                      ^~~~
                                                       %lu
   include/linux/ceph/ceph_debug.h:26:29: note: expanded from macro 'dout'
                           printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
                                             ~~~    ^~~~~~~~~~~
   include/linux/printk.h:450:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                       ~~~    ^~~~~~~~~~~
   include/linux/printk.h:422:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                           ~~~~    ^~~~~~~~~~~
   2 warnings generated.


vim +2326 fs/ceph/inode.c

  2293	
  2294	int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
  2295			      size_t size)
  2296	{
  2297		struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
  2298		struct ceph_mds_client *mdsc = fsc->mdsc;
  2299		struct ceph_mds_request *req;
  2300		int mode = USE_AUTH_MDS;
  2301		int err;
  2302		char *xattr_value;
  2303		size_t xattr_value_len;
  2304	
  2305		req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR, mode);
  2306		if (IS_ERR(req)) {
  2307			err = -ENOMEM;
  2308			goto out;
  2309		}
  2310	
  2311		req->r_path2 = kstrdup(name, GFP_NOFS);
  2312		if (!req->r_path2) {
  2313			err = -ENOMEM;
  2314			goto put;
  2315		}
  2316	
  2317		ihold(inode);
  2318		req->r_inode = inode;
  2319		err = ceph_mdsc_do_request(mdsc, NULL, req);
  2320		if (err < 0)
  2321			goto put;
  2322	
  2323		xattr_value = req->r_reply_info.xattr_info.xattr_value;
  2324		xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
  2325	
> 2326		dout("do_getvxattr xattr_value_len:%u, size:%u\n", xattr_value_len, size);
  2327	
  2328		err = xattr_value_len;
  2329		if (size == 0)
  2330			goto put;
  2331	
  2332		if (xattr_value_len > size) {
  2333			err = -ERANGE;
  2334			goto put;
  2335		}
  2336	
  2337		memcpy(value, xattr_value, xattr_value_len);
  2338	put:
  2339		ceph_mdsc_put_request(req);
  2340	out:
  2341		dout("do_getvxattr result=%d\n", err);
  2342		return err;
  2343	}
  2344	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
