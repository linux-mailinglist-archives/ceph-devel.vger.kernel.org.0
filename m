Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C405334E6
	for <lists+ceph-devel@lfdr.de>; Wed, 25 May 2022 03:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242915AbiEYBqc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 May 2022 21:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241848AbiEYBqb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 May 2022 21:46:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248EF1155
        for <ceph-devel@vger.kernel.org>; Tue, 24 May 2022 18:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653443190; x=1684979190;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BUCr7taSuw0KO80L47YnHxQ/XCxEO+sy4ysfJBba/DU=;
  b=SmxBJ1X7PC/+6NiZ+imNM29kVgkA4sjoA9tbQZ60hTJLs5nk+CbXI0+0
   1eEgj6S+UM+vB7LPH5k6k+41WLSm4nri6ljlpCbNWzuyoMdDl77GuUOqt
   anlkXt0m7bpyEhFigJt00eEXSsr1ygRjARKW/ir/6Cx2TwhghQ/yrRbg6
   qHpbZYKfWRYIF+BSMlq+yk5e/M4qi/LK/4ZWwBtXtD3QZUUmrfzwddPuG
   Bh9c5J1fanO0xMMSINLwv/1kU+8uJqay1D3s0GK3b1kO0bKpS9hys0gaa
   OxTG2v3ewikZIV20cu4auQzD2j2BT3dH8zauMwmS9lyOUgQYSkqgstxXy
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="273688123"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="273688123"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 18:46:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="578139991"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2022 18:46:27 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntg6V-0002cQ-Ad;
        Wed, 25 May 2022 01:46:27 +0000
Date:   Wed, 25 May 2022 09:45:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        xiubli@redhat.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH] libceph: drop last_piece flag from ceph_msg_data_cursor
Message-ID: <202205250950.eYgtitA1-lkp@intel.com>
References: <20220524220610.141970-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524220610.141970-1-jlayton@kernel.org>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

I love your patch! Perhaps something to improve:

[auto build test WARNING on ceph-client/for-linus]
[also build test WARNING on v5.18 next-20220524]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Jeff-Layton/libceph-drop-last_piece-flag-from-ceph_msg_data_cursor/20220525-060709
base:   https://github.com/ceph/ceph-client.git for-linus
config: hexagon-randconfig-r034-20220524 (https://download.01.org/0day-ci/archive/20220525/202205250950.eYgtitA1-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 10c9ecce9f6096e18222a331c5e7d085bd813f75)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/09a57bbfef50219b0f819adc621516e6b3344fe4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jeff-Layton/libceph-drop-last_piece-flag-from-ceph_msg_data_cursor/20220525-060709
        git checkout 09a57bbfef50219b0f819adc621516e6b3344fe4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/ceph/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/ceph/messenger.c:178:5: warning: format specifies type 'unsigned short' but the argument has type 'int' [-Wformat]
                            ntohs(in4->sin_port));
                            ^~~~~~~~~~~~~~~~~~~~
   include/linux/byteorder/generic.h:142:18: note: expanded from macro 'ntohs'
   #define ntohs(x) ___ntohs(x)
                    ^~~~~~~~~~~
   include/linux/byteorder/generic.h:137:21: note: expanded from macro '___ntohs'
   #define ___ntohs(x) __be16_to_cpu(x)
                       ^~~~~~~~~~~~~~~~
   include/uapi/linux/byteorder/little_endian.h:43:26: note: expanded from macro '__be16_to_cpu'
   #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/swab.h:105:2: note: expanded from macro '__swab16'
           (__builtin_constant_p((__u16)(x)) ?     \
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/ceph/messenger.c:184:5: warning: format specifies type 'unsigned short' but the argument has type 'int' [-Wformat]
                            ntohs(in6->sin6_port));
                            ^~~~~~~~~~~~~~~~~~~~~
   include/linux/byteorder/generic.h:142:18: note: expanded from macro 'ntohs'
   #define ntohs(x) ___ntohs(x)
                    ^~~~~~~~~~~
   include/linux/byteorder/generic.h:137:21: note: expanded from macro '___ntohs'
   #define ___ntohs(x) __be16_to_cpu(x)
                       ^~~~~~~~~~~~~~~~
   include/uapi/linux/byteorder/little_endian.h:43:26: note: expanded from macro '__be16_to_cpu'
   #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/swab.h:105:2: note: expanded from macro '__swab16'
           (__builtin_constant_p((__u16)(x)) ?     \
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/ceph/messenger.c:858:12: warning: comparison of distinct pointer types ('typeof (cursor->resid) *' (aka 'unsigned int *') and 'typeof ((1UL << 18) - *page_offset) *' (aka 'unsigned long *')) [-Wcompare-distinct-pointer-types]
           *length = min(cursor->resid, PAGE_SIZE - *page_offset);
                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
   net/ceph/messenger.c:931:12: warning: comparison of distinct pointer types ('typeof (cursor->resid) *' (aka 'unsigned int *') and 'typeof ((1UL << 18) - *page_offset) *' (aka 'unsigned long *')) [-Wcompare-distinct-pointer-types]
           *length = min(cursor->resid, PAGE_SIZE - *page_offset);
                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
   4 warnings generated.


vim +858 net/ceph/messenger.c

   845	
   846	static struct page *
   847	ceph_msg_data_pages_next(struct ceph_msg_data_cursor *cursor,
   848						size_t *page_offset, size_t *length)
   849	{
   850		struct ceph_msg_data *data = cursor->data;
   851	
   852		BUG_ON(data->type != CEPH_MSG_DATA_PAGES);
   853	
   854		BUG_ON(cursor->page_index >= cursor->page_count);
   855		BUG_ON(cursor->page_offset >= PAGE_SIZE);
   856	
   857		*page_offset = cursor->page_offset;
 > 858		*length = min(cursor->resid, PAGE_SIZE - *page_offset);
   859		return data->pages[cursor->page_index];
   860	}
   861	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
