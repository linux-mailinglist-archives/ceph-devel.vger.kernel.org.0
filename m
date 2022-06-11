Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7CE5475F6
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Jun 2022 17:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiFKPLX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 11 Jun 2022 11:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbiFKPLW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 11 Jun 2022 11:11:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FDC2611
        for <ceph-devel@vger.kernel.org>; Sat, 11 Jun 2022 08:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654960281; x=1686496281;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ed9bTYR0nyjmJR2+k0jBVpXtKnsbpVI4upqyWb1Dflw=;
  b=hw4eloXoqf4hMmhTgp1ituveXWLlkkSYt22Zs5IQed/rfcblsz86eBPR
   jXQFCBGcwy219KfwC9NV/fRGZAuHHblarGbF7B558WQol3+td43ioGN7D
   UahhFmKFHdnipvFGK3R0p2d2m6X4ccojCYkbiFu/8oHWwlFfutn8WIE6N
   ppVCfqyne8lHrhbIOBNOkVNz9JtH4kcbjuUuwvvlndutF5n2LRSA8Ztel
   KrZFriFD32+yIrTuXLgyf4FctM2HzAEmXZ8n2aGCF4Ajn0U7s89hVFhNy
   mGoJdIqsL60JKAHCA4HqoZONdTE2w9erYuMFaOcv4MG1fU4h6WkxTyglB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10375"; a="278673129"
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="278673129"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 08:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="611133218"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 11 Jun 2022 08:11:18 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o02lh-000J09-UH;
        Sat, 11 Jun 2022 15:11:17 +0000
Date:   Sat, 11 Jun 2022 23:10:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [ceph-client:testing 7/9] lib/iov_iter.c:1464:9: warning: comparison
 of distinct pointer types ('typeof (nr * ((1UL) << (12)) - offset) *' (aka
 'unsigned long *') and 'typeof (maxsize) *' (aka 'unsigned int *'))
Message-ID: <202206112305.4DdsErK8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   7b864d005b1f7f6a144420e180891b6401078407
commit: 3adeefbfca0fd57cc943b7ec0330385f48041f0c [7/9] [DO NOT MERGE] iov_iter: Fix iter_xarray_get_pages{,_alloc}()
config: riscv-randconfig-r034-20220611 (https://download.01.org/0day-ci/archive/20220611/202206112305.4DdsErK8-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ff4abe755279a3a47cc416ef80dbc900d9a98a19)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv-linux-gnu
        # https://github.com/ceph/ceph-client/commit/3adeefbfca0fd57cc943b7ec0330385f48041f0c
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 3adeefbfca0fd57cc943b7ec0330385f48041f0c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> lib/iov_iter.c:1464:9: warning: comparison of distinct pointer types ('typeof (nr * ((1UL) << (12)) - offset) *' (aka 'unsigned long *') and 'typeof (maxsize) *' (aka 'unsigned int *')) [-Wcompare-distinct-pointer-types]
           return min(nr * PAGE_SIZE - offset, maxsize);
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:45:19: note: expanded from macro 'min'
   #define min(x, y)       __careful_cmp(x, y, <)
                           ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
           __builtin_choose_expr(__safe_cmp(x, y), \
                                 ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
                   (__typecheck(x, y) && __no_side_effects(x, y))
                    ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
           (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                      ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   lib/iov_iter.c:1628:9: warning: comparison of distinct pointer types ('typeof (nr * ((1UL) << (12)) - offset) *' (aka 'unsigned long *') and 'typeof (maxsize) *' (aka 'unsigned int *')) [-Wcompare-distinct-pointer-types]
           return min(nr * PAGE_SIZE - offset, maxsize);
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:45:19: note: expanded from macro 'min'
   #define min(x, y)       __careful_cmp(x, y, <)
                           ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
           __builtin_choose_expr(__safe_cmp(x, y), \
                                 ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
                   (__typecheck(x, y) && __no_side_effects(x, y))
                    ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
           (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                      ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   2 warnings generated.


vim +1464 lib/iov_iter.c

  1430	
  1431	static ssize_t iter_xarray_get_pages(struct iov_iter *i,
  1432					     struct page **pages, size_t maxsize,
  1433					     unsigned maxpages, size_t *_start_offset)
  1434	{
  1435		unsigned nr, offset;
  1436		pgoff_t index, count;
  1437		size_t size = maxsize;
  1438		loff_t pos;
  1439	
  1440		if (!size || !maxpages)
  1441			return 0;
  1442	
  1443		pos = i->xarray_start + i->iov_offset;
  1444		index = pos >> PAGE_SHIFT;
  1445		offset = pos & ~PAGE_MASK;
  1446		*_start_offset = offset;
  1447	
  1448		count = 1;
  1449		if (size > PAGE_SIZE - offset) {
  1450			size -= PAGE_SIZE - offset;
  1451			count += size >> PAGE_SHIFT;
  1452			size &= ~PAGE_MASK;
  1453			if (size)
  1454				count++;
  1455		}
  1456	
  1457		if (count > maxpages)
  1458			count = maxpages;
  1459	
  1460		nr = iter_xarray_populate_pages(pages, i->xarray, index, count);
  1461		if (nr == 0)
  1462			return 0;
  1463	
> 1464		return min(nr * PAGE_SIZE - offset, maxsize);
  1465	}
  1466	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
