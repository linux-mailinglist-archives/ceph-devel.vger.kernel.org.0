Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D1672F23F
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 03:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbjFNB4s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 21:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjFNB4q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 21:56:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE1EE79
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686707804; x=1718243804;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ui9ddGZaZ16rXJs4SNBEJtIw7GW2FS8IJhjAvMoqqdM=;
  b=czrBEd1Nmn32EIDo/6eIQYbU85N8DwHo2NsEQcs5k0mvvN6xpejNQj0L
   Z6F+anD3DkJLF8RLybRsbYQYFCKemASVLX5qHC291k0WeivwVYX5PU9Mc
   0PghqMmPNO0R9HFGRfZjwEmEOB2pGZzTSn+VDGzC9YxY04muG8+F0MCya
   g+XO82ZLXheBLHt48vD065gyITsLYZgs9J9BxAkRKRnUQl7Ak9UCWfr82
   tBzjqmvt59ZVnlukh9ZywpX3wks77QJfxhNm7I24V9ZMsQJIoD0EyA3uf
   B+X/SBzWf7bpXBdssTa/cMUo0mQ4+dx+ekb3kx2r3j+pSF5wBSep1znE9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="348156699"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="348156699"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 18:56:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="706026158"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="706026158"
Received: from lkp-server01.sh.intel.com (HELO 211f47bdb1cb) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 13 Jun 2023 18:56:42 -0700
Received: from kbuild by 211f47bdb1cb with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q9FkX-00024i-0y;
        Wed, 14 Jun 2023 01:56:41 +0000
Date:   Wed, 14 Jun 2023 09:56:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org, Patrick Donnelly <pdonnell@redhat.com>
Subject: [ceph-client:testing 21/21] fs/ceph/xattr.c:61:22: warning: unused
 variable 'cl'
Message-ID: <202306140913.VwDYFVjP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   a87fa198004c3239486394be301efa333b2ee366
commit: a87fa198004c3239486394be301efa333b2ee366 [21/21] ceph: print the client global_id in all the debug logs
config: x86_64-randconfig-a002-20230612 (https://download.01.org/0day-ci/archive/20230614/202306140913.VwDYFVjP-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/a87fa198004c3239486394be301efa333b2ee366
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout a87fa198004c3239486394be301efa333b2ee366
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/ceph/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306140913.VwDYFVjP-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/ceph/xattr.c:61:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/xattr.c:573:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
                               ^
   fs/ceph/xattr.c:672:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
                               ^
   fs/ceph/xattr.c:741:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
                               ^
   fs/ceph/xattr.c:766:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
                               ^
   fs/ceph/xattr.c:796:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/xattr.c:884:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
                               ^
   fs/ceph/xattr.c:912:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/xattr.c:1070:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/xattr.c:1114:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   10 warnings generated.
--
>> fs/ceph/locks.c:80:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/locks.c:163:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/locks.c:253:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/locks.c:321:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/locks.c:383:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/locks.c:410:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/locks.c:448:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   7 warnings generated.
--
>> fs/ceph/caps.c:312:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:334:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:390:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:574:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:650:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:782:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = cap->session->s_mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:807:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:863:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = s->s_mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:885:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:975:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:1129:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = session->s_mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:1400:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:1722:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:1913:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:1962:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:2011:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:2354:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:2471:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:2524:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:2749:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:2802:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:2958:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:3175:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:3212:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:3328:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:3413:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:3475:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:3788:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:3900:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:3946:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:3998:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/caps.c:4571:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:4616:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/caps.c:4760:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
>> fs/ceph/caps.c:4853:22: warning: variable 'cl' set but not used [-Wunused-but-set-variable]
           struct ceph_client *cl;
                               ^
   fs/ceph/caps.c:4905:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   36 warnings generated.
--
>> fs/ceph/export.c:39:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/export.c:90:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/export.c:211:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
>> fs/ceph/export.c:304:25: warning: unused variable 'fsc' [-Wunused-variable]
           struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
                                  ^
   fs/ceph/export.c:371:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/export.c:423:25: warning: unused variable 'fsc' [-Wunused-variable]
           struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
                                  ^
   6 warnings generated.
--
>> fs/ceph/super.c:122:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/super.c:1060:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/super.c:1152:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/super.c:1207:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/super.c:1244:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   5 warnings generated.
--
>> fs/ceph/addr.c:83:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:141:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:169:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:249:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/addr.c:353:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/addr.c:443:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:574:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:671:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/addr.c:1459:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:1564:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:1629:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:1720:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:1825:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/addr.c:1872:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/addr.c:2028:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = fsc->client;
                               ^
   fs/ceph/addr.c:2202:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   16 warnings generated.
--
>> fs/ceph/snap.c:154:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/snap.c:193:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/snap.c:296:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/snap.c:379:10: warning: result of comparison of constant 2305843009213693948 with expression of type 'u32' (aka 'unsigned int') is always false [-Wtautological-constant-out-of-range-compare]
           if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
               ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/ceph/snap.c:441:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/snap.c:538:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/snap.c:675:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/snap.c:952:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/snap.c:1202:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/snap.c:1301:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   10 warnings generated.
--
>> fs/ceph/mds_client.c:965:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:1289:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:1701:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:1718:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:1748:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = session->s_mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:1811:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = session->s_mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:1879:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/mds_client.c:1993:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = session->s_mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:2042:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:2099:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = session->s_mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:2161:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:2244:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:2265:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:2445:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:2483:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:2855:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:3274:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:3482:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:3504:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:3528:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:3578:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:3635:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:3656:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = req->r_mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:4195:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = req->r_mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:4208:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = req->r_mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:4374:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = ceph_inode_to_client(inode);
                               ^
   fs/ceph/mds_client.c:4563:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:5095:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = session->s_mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:5351:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:5430:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:5494:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   fs/ceph/mds_client.c:5539:22: warning: unused variable 'cl' [-Wunused-variable]
           struct ceph_client *cl = mdsc->fsc->client;
                               ^
   32 warnings generated.
..


vim +/cl +61 fs/ceph/xattr.c

    56	
    57	static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
    58					    size_t size)
    59	{
    60		struct ceph_fs_client *fsc = ceph_sb_to_fs_client(ci->netfs.inode.i_sb);
  > 61		struct ceph_client *cl = fsc->client;
    62		struct ceph_osd_client *osdc = &fsc->client->osdc;
    63		struct ceph_string *pool_ns;
    64		s64 pool = ci->i_layout.pool_id;
    65		const char *pool_name;
    66		const char *ns_field = " pool_namespace=";
    67		char buf[128];
    68		size_t len, total_len = 0;
    69		ssize_t ret;
    70	
    71		pool_ns = ceph_try_get_string(ci->i_layout.pool_ns);
    72	
    73		dout_client(cl, "%s %p\n", __func__, &ci->netfs.inode);
    74		down_read(&osdc->lock);
    75		pool_name = ceph_pg_pool_name_by_id(osdc->osdmap, pool);
    76		if (pool_name) {
    77			len = snprintf(buf, sizeof(buf),
    78			"stripe_unit=%u stripe_count=%u object_size=%u pool=",
    79			ci->i_layout.stripe_unit, ci->i_layout.stripe_count,
    80		        ci->i_layout.object_size);
    81			total_len = len + strlen(pool_name);
    82		} else {
    83			len = snprintf(buf, sizeof(buf),
    84			"stripe_unit=%u stripe_count=%u object_size=%u pool=%lld",
    85			ci->i_layout.stripe_unit, ci->i_layout.stripe_count,
    86			ci->i_layout.object_size, pool);
    87			total_len = len;
    88		}
    89	
    90		if (pool_ns)
    91			total_len += strlen(ns_field) + pool_ns->len;
    92	
    93		ret = total_len;
    94		if (size >= total_len) {
    95			memcpy(val, buf, len);
    96			ret = len;
    97			if (pool_name) {
    98				len = strlen(pool_name);
    99				memcpy(val + ret, pool_name, len);
   100				ret += len;
   101			}
   102			if (pool_ns) {
   103				len = strlen(ns_field);
   104				memcpy(val + ret, ns_field, len);
   105				ret += len;
   106				memcpy(val + ret, pool_ns->str, pool_ns->len);
   107				ret += pool_ns->len;
   108			}
   109		}
   110		up_read(&osdc->lock);
   111		ceph_put_string(pool_ns);
   112		return ret;
   113	}
   114	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
