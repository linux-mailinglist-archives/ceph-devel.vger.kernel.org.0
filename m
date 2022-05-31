Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C992538B02
	for <lists+ceph-devel@lfdr.de>; Tue, 31 May 2022 07:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244087AbiEaFvZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 May 2022 01:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240070AbiEaFvY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 31 May 2022 01:51:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D4A663E6
        for <ceph-devel@vger.kernel.org>; Mon, 30 May 2022 22:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653976259; x=1685512259;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5tbc2dUXSrDblMPikE6E/hurK+/ZWfHmH0eI55lgG9A=;
  b=XhPf5uAhnN22budwNC6dDDhu0oL2cxCibCK+XSl29M8yfXQ8uAtWGKOg
   np0dZogec2Zl7NTawfklPabdSe6IMj9ohK1u/0C70Jdbt3iX5BNCfFdsW
   INlP0LuRV1yzPAZGa0ljZ15WA6XDnEHMt2xiLqGz1uWpfmwIhErApyn+L
   PGXfnPnCJZw68QnxSaJ2UKGb9YgAOir0sRidGUocTboqyot1K9Vd2jGlF
   khKwyf+aLuu1Yrg8wwfIJDW1YpYpd9eUs3lOtjSroW/Xog/xrNl+KRyv4
   V9qfmrkKQDlfPZvOOKGtoXHOToALsJDCYUzrnuSwnM8st+TqJuxPaP+zr
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="335805453"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="335805453"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 22:50:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="720160579"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 30 May 2022 22:50:58 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nvumP-0002Nw-Ab;
        Tue, 31 May 2022 05:50:57 +0000
Date:   Tue, 31 May 2022 13:50:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:wip-fscrypt 6/64] net/ceph/osd_client.c:5702:51: error:
 too many arguments to function call, expected 3, have 4
Message-ID: <202205311337.ZFkD1cPR-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git wip-fscrypt
head:   4a13fcc148c64143afe231bd0cae743b89c70177
commit: 0614a83e4f104460d5bdb8ba414ab69b8fdbdb39 [6/64] libceph: add sparse read support to OSD client
config: arm64-buildonly-randconfig-r002-20220531 (https://download.01.org/0day-ci/archive/20220531/202205311337.ZFkD1cPR-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/ceph/ceph-client/commit/0614a83e4f104460d5bdb8ba414ab69b8fdbdb39
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client wip-fscrypt
        git checkout 0614a83e4f104460d5bdb8ba414ab69b8fdbdb39
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash net/ceph/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/ceph/osd_client.c:5702:51: error: too many arguments to function call, expected 3, have 4
                   page = ceph_msg_data_next(cursor, &poff, &plen, &last);
                          ~~~~~~~~~~~~~~~~~~                       ^~~~~
   include/linux/ceph/messenger.h:527:14: note: 'ceph_msg_data_next' declared here
   struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
                ^
   1 error generated.


vim +5702 net/ceph/osd_client.c

  5694	
  5695	static void advance_cursor(struct ceph_msg_data_cursor *cursor, size_t len, bool zero)
  5696	{
  5697		while (len) {
  5698			struct page *page;
  5699			size_t poff, plen;
  5700			bool last = false;
  5701	
> 5702			page = ceph_msg_data_next(cursor, &poff, &plen, &last);
  5703			if (plen > len)
  5704				plen = len;
  5705			if (zero)
  5706				zero_user_segment(page, poff, poff + plen);
  5707			len -= plen;
  5708			ceph_msg_data_advance(cursor, plen);
  5709		}
  5710	}
  5711	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
