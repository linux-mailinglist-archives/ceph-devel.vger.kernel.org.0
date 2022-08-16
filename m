Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46710594F44
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Aug 2022 06:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiHPEH7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Aug 2022 00:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiHPEHf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Aug 2022 00:07:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217B0187FA3
        for <ceph-devel@vger.kernel.org>; Mon, 15 Aug 2022 17:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660610145; x=1692146145;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=1qjc3yt0u6hZtdiJxtiVzMXN4w7XoYMopIf069352Uc=;
  b=Q4hjuvz+NbyXA3+6pvS9mIZuG1ZRqcrFYZ8s6kpMbT+LWq9uY6kJkhJZ
   Fms5y7uvRuzp4Z4aBu1dFkISnFl647foT7TrIYhrLW/IKZJKnUe5rpeiG
   4XLOCLK1gZpboiuicIQi2jDtbGgHp71QGZyAwpMneJVGbB+j46owavpnT
   RUCwxY8pHqUJjIMpqyM73X0y497SkWOHPtJD8KSPK6REpePJeHxt0jmTZ
   OlJ2gy0rogm+1xyO2gCZ67sowxfnlnkC+MMp0Wc8jniE1y3rLqtv0zTWE
   Ce8a0Vfw6eLa0Pd02y46uW335OoU1Xbga6koEh0cAZy3c7c0ckguKcZdA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="275143581"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="275143581"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 17:35:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="934682988"
Received: from lkp-server02.sh.intel.com (HELO 3d2a4d02a2a9) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 15 Aug 2022 17:35:41 -0700
Received: from kbuild by 3d2a4d02a2a9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oNkYX-0001Il-0p;
        Tue, 16 Aug 2022 00:35:41 +0000
Date:   Tue, 16 Aug 2022 08:35:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:testing 14/39] net/ceph/messenger.c:988:15: error:
 implicit declaration of function 'iov_iter_get_pages'; did you mean
 'iov_iter_get_pages2'?
Message-ID: <202208160842.GUNdBYbK-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   bc940dc5cc27be90472e00ddf510b28b29ffd6ce
commit: a5cb140194256429d5ce74439e8165390d9380a6 [14/39] libceph: add new iov_iter-based ceph_msg_data_type and ceph_osd_data_type
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220816/202208160842.GUNdBYbK-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/ceph/ceph-client/commit/a5cb140194256429d5ce74439e8165390d9380a6
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout a5cb140194256429d5ce74439e8165390d9380a6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ceph/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/ceph/messenger.c: In function 'ceph_msg_data_iter_next':
>> net/ceph/messenger.c:988:15: error: implicit declaration of function 'iov_iter_get_pages'; did you mean 'iov_iter_get_pages2'? [-Werror=implicit-function-declaration]
     988 |         len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
         |               ^~~~~~~~~~~~~~~~~~
         |               iov_iter_get_pages2
   cc1: some warnings being treated as errors


vim +988 net/ceph/messenger.c

   977	
   978	static struct page *ceph_msg_data_iter_next(struct ceph_msg_data_cursor *cursor,
   979							size_t *page_offset,
   980							size_t *length)
   981	{
   982		struct page *page;
   983		ssize_t len;
   984	
   985		if (cursor->lastlen)
   986			iov_iter_revert(&cursor->iov_iter, cursor->lastlen);
   987	
 > 988		len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
   989					 1, page_offset);
   990		BUG_ON(len < 0);
   991	
   992		cursor->lastlen = len;
   993	
   994		/*
   995		 * FIXME: Al Viro says that he will soon change iov_iter_get_pages
   996		 * to auto-advance the iterator. Emulate that here for now.
   997		 */
   998		iov_iter_advance(&cursor->iov_iter, len);
   999	
  1000		/*
  1001		 * FIXME: The assumption is that the pages represented by the iov_iter
  1002		 * 	  are pinned, with the references held by the upper-level
  1003		 * 	  callers, or by virtue of being under writeback. Eventually,
  1004		 * 	  we'll get an iov_iter_get_pages variant that doesn't take page
  1005		 * 	  refs. Until then, just put the page ref.
  1006		 */
  1007		VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
  1008		put_page(page);
  1009	
  1010		*length = min_t(size_t, len, cursor->resid);
  1011		return page;
  1012	}
  1013	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
