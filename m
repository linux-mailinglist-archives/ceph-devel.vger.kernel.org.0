Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16704B913B
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 20:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiBPTeF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 14:34:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiBPTeE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 14:34:04 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F314B1F3F2E
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 11:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645040029; x=1676576029;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=bAzoMRtf+I24Zmqs4+cnXW5HieIQnHKD6dEjmJa1llk=;
  b=b4pzbkLmxDHN6vM8oefzqp1uDJmzg3FLl1i8N5MPyDZRy8coUODA5ie9
   J6tjoZmEigfhX93yUJCiNKwYiFhf1piHI9u8CjZ5BOBIWnvskJrW4IgP7
   echOMfJasqy1twPCWWoDa2gXOawwSz8ZFQiT/GbUqvHezkMD3UbtUuyCa
   u3g87uLLshsQ75xLAXxOueqDFcwwqhXPhJXohyQZ76LjA7KvKPVdSqzFd
   utCtaAVkKv3wWVDPV+EDbISK9LYG2+EzE6Oeh/BtNhPEIfXGGI8w3GzQO
   Wm6jT32orI50YUYfM+uFm+aek8Q39eITts+fEgGS4j8oqq1r4dDRHMeDs
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="250649720"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="250649720"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 11:33:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="540299842"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 16 Feb 2022 11:33:48 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nKQ3f-000B3l-C9; Wed, 16 Feb 2022 19:33:47 +0000
Date:   Thu, 17 Feb 2022 03:33:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
Subject: [ceph-client:testing 13/14] fs/ceph/snap.c:438:14: warning: variable
 '_realm' is uninitialized when used here
Message-ID: <202202170318.82LIXBXX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   91e59cfc6ca1a2bf594f60474996c71047edd1e5
commit: 7c7e63bc9910b15ffd1f791838ff0a919058f97c [13/14] ceph: eliminate the recursion when rebuilding the snap context
config: hexagon-randconfig-r005-20220216 (https://download.01.org/0day-ci/archive/20220217/202202170318.82LIXBXX-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0e628a783b935c70c80815db6c061ec84f884af5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/7c7e63bc9910b15ffd1f791838ff0a919058f97c
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 7c7e63bc9910b15ffd1f791838ff0a919058f97c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/ceph/snap.c:438:14: warning: variable '_realm' is uninitialized when used here [-Wuninitialized]
                           list_del(&_realm->rebuild_item);
                                     ^~~~~~
   fs/ceph/snap.c:430:33: note: initialize the variable '_realm' to silence this warning
                   struct ceph_snap_realm *_realm, *child;
                                                 ^
                                                  = NULL
   1 warning generated.


vim +/_realm +438 fs/ceph/snap.c

   417	
   418	/*
   419	 * rebuild snap context for the given realm and all of its children.
   420	 */
   421	static void rebuild_snap_realms(struct ceph_snap_realm *realm,
   422					struct list_head *dirty_realms)
   423	{
   424		LIST_HEAD(realm_queue);
   425		int last = 0;
   426	
   427		list_add_tail(&realm->rebuild_item, &realm_queue);
   428	
   429		while (!list_empty(&realm_queue)) {
   430			struct ceph_snap_realm *_realm, *child;
   431	
   432			/*
   433			 * If the last building failed dues to memory
   434			 * issue, just empty the realm_queue and return
   435			 * to avoid infinite loop.
   436			 */
   437			if (last < 0) {
 > 438				list_del(&_realm->rebuild_item);
   439				continue;
   440			}
   441	
   442			_realm = list_first_entry(&realm_queue,
   443						  struct ceph_snap_realm,
   444						  rebuild_item);
   445			last = build_snap_context(_realm, &realm_queue, dirty_realms);
   446			dout("rebuild_snap_realms %llx %p, %s\n", _realm->ino, _realm,
   447			     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
   448	
   449			list_for_each_entry(child, &_realm->children, child_item)
   450				list_add_tail(&child->rebuild_item, &realm_queue);
   451	
   452			/* last == 1 means need to build parent first */
   453			if (last <= 0)
   454				list_del(&_realm->rebuild_item);
   455		}
   456	}
   457	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
