Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8A448CBCB
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jan 2022 20:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242199AbiALTYN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 14:24:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:55547 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238677AbiALTYN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 14:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642015453; x=1673551453;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g4WGtnSWGoGxcJMGq2QXsbDiFrjWm+zF2yNAi3NrEDk=;
  b=cfIuZkHAmD1a7zydg7ibbluLSiXerfbl+dA+ahuzkKwHQiOyiQIM4+fC
   BKv4JizjVJ062HV92sYjaZDhlfz7CF29qdg/1SqPp6Vy31lQ5KXp22dc6
   zO/KnXdx5BaY32rsxdaIFNbB9/sg4EDut9Q2CCobZ8srB7usq7nE/sqZL
   B+BPwgKK6ofLg+uu2qKEiqH3RWdoBNyQhfwGhysypEEeyhBr3/8ZhgmgI
   r7/brDj/vMfg1Sb3D2QForagrTACigS3DCpiBHIhYW5C3TIESokpDKDnp
   57OJp1MEmVExEn18TiRLfXZk1cuyUJWxLdh91m/GhFH9HMjnFMmjdNWOA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="243631073"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="243631073"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 11:24:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="691512267"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 12 Jan 2022 11:24:09 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n7jE8-0006HU-IT; Wed, 12 Jan 2022 19:24:08 +0000
Date:   Thu, 13 Jan 2022 03:23:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Milind Changire <milindchangire@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Milind Changire <mchangir@redhat.com>
Subject: Re: [PATCH 1/1] ceph: add getvxattr op
Message-ID: <202201130325.UBjYGkoh-lkp@intel.com>
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
config: i386-randconfig-a006 (https://download.01.org/0day-ci/archive/20220113/202201130325.UBjYGkoh-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 244dd2913a43a200f5a6544d424cdc37b771028b)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9e670d02ce9f9d6e1ac3e234a89d305c85302338
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Milind-Changire/ceph-add-getvxattr-support/20220111-202533
        git checkout 9e670d02ce9f9d6e1ac3e234a89d305c85302338
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/ceph/inode.c:2326:55: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
           dout("do_getvxattr xattr_value_len:%lu, size:%lu\n", xattr_value_len, size);
                                              ~~~               ^~~~~~~~~~~~~~~
                                              %u
   include/linux/ceph/ceph_debug.h:35:45: note: expanded from macro 'dout'
   # define dout(fmt, ...) pr_debug(" " fmt, ##__VA_ARGS__)
                                        ~~~    ^~~~~~~~~~~
   include/linux/printk.h:580:38: note: expanded from macro 'pr_debug'
           no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
                                       ~~~     ^~~~~~~~~~~
   include/linux/printk.h:132:17: note: expanded from macro 'no_printk'
                   printk(fmt, ##__VA_ARGS__);             \
                          ~~~    ^~~~~~~~~~~
   include/linux/printk.h:450:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                       ~~~    ^~~~~~~~~~~
   include/linux/printk.h:422:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                           ~~~~    ^~~~~~~~~~~
   fs/ceph/inode.c:2326:72: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
           dout("do_getvxattr xattr_value_len:%lu, size:%lu\n", xattr_value_len, size);
                                                        ~~~                      ^~~~
                                                        %u
   include/linux/ceph/ceph_debug.h:35:45: note: expanded from macro 'dout'
   # define dout(fmt, ...) pr_debug(" " fmt, ##__VA_ARGS__)
                                        ~~~    ^~~~~~~~~~~
   include/linux/printk.h:580:38: note: expanded from macro 'pr_debug'
           no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
                                       ~~~     ^~~~~~~~~~~
   include/linux/printk.h:132:17: note: expanded from macro 'no_printk'
                   printk(fmt, ##__VA_ARGS__);             \
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
> 2326		dout("do_getvxattr xattr_value_len:%lu, size:%lu\n", xattr_value_len, size);
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
