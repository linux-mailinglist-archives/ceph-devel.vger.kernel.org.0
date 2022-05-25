Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F2533593
	for <lists+ceph-devel@lfdr.de>; Wed, 25 May 2022 05:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiEYDE4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 May 2022 23:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiEYDEy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 May 2022 23:04:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285B15FF03
        for <ceph-devel@vger.kernel.org>; Tue, 24 May 2022 20:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653447893; x=1684983893;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vm1OsWaG6z4/aZh440UxY1H3RGG32dINyzjSovJWCww=;
  b=F2OQfaT0ijj20NskXHzn75g8YV72eGEC4+y5UVTWq8Zbqz+mJ6ePegRB
   TsGJVhKE0Re7Env0Qmt3MR+e9RjfXwhaD3wgiCZ2tfXqWqnJ9EmLqZaV8
   lSTIYODoP4aDuH/8LEW4yHVulqYuk68KYf3W153NU8AeuzPI1kbgVBzLh
   QsKnldsqT8BGgu9xiza14d+C5qanY9bVtY3RX1g9ehHmEGCMvm5nxP7uU
   992ovz0NRF8pQamVJlmGnmMucClhyuhLByLe6wf++3VlM2AmWlxOpolHC
   U9xuzW4BHfT3DQewLBmKLtHyACImQ0+hEGNTvL4Dyh1M5+Wsxe+4CMMPj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="334346516"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="334346516"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 20:04:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="608932683"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 24 May 2022 20:04:50 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nthKM-0002fO-2x;
        Wed, 25 May 2022 03:04:50 +0000
Date:   Wed, 25 May 2022 11:03:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        xiubli@redhat.com
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] libceph: drop last_piece flag from ceph_msg_data_cursor
Message-ID: <202205251055.ijbnX88Q-lkp@intel.com>
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
config: xtensa-randconfig-s031-20220524 (https://download.01.org/0day-ci/archive/20220525/202205251055.ijbnX88Q-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 11.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-14-g5a0004b5-dirty
        # https://github.com/intel-lab-lkp/linux/commit/09a57bbfef50219b0f819adc621516e6b3344fe4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jeff-Layton/libceph-drop-last_piece-flag-from-ceph_msg_data_cursor/20220525-060709
        git checkout 09a57bbfef50219b0f819adc621516e6b3344fe4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=xtensa SHELL=/bin/bash net/ceph/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   net/ceph/messenger.c: note: in included file (through arch/xtensa/include/asm/bitops.h, include/linux/bitops.h, include/linux/log2.h, ...):
   arch/xtensa/include/asm/processor.h:103:2: sparse: sparse: Unsupported xtensa ABI
   arch/xtensa/include/asm/processor.h:133:2: sparse: sparse: Unsupported Xtensa ABI
>> net/ceph/messenger.c:858:19: sparse: sparse: incompatible types in comparison expression (different type sizes):
>> net/ceph/messenger.c:858:19: sparse:    unsigned int *
>> net/ceph/messenger.c:858:19: sparse:    unsigned long *
   net/ceph/messenger.c:931:19: sparse: sparse: incompatible types in comparison expression (different type sizes):
   net/ceph/messenger.c:931:19: sparse:    unsigned int *
   net/ceph/messenger.c:931:19: sparse:    unsigned long *

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
