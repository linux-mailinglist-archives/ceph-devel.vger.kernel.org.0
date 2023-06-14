Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5201D730148
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245393AbjFNOJK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jun 2023 10:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245301AbjFNOJI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Jun 2023 10:09:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527F326A8
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jun 2023 07:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686751727; x=1718287727;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Mt9SyJZwPeXkU6bQYo1qvvr2ExMtI7gtsbrGk9+TCLc=;
  b=DUuQr80Tj6Dq9RdSFos1Uw934J4Td3+uZlB++IZgvqa6forlIhqx6h/W
   kBfsGjZ4jv+DJbVWUvkBEatOJof23ZQA/p9ZhzZNn8fThYlCFT/035tEU
   2WZY0z1haF9kZ9nGtzCfPamfsQWs2K9Zjs1p7mygqPUGc/xriasYPRLIx
   xEIgBviQmD2n+iGoT7x0rvYMsidRSwhGMu+9IluFSqTIFtDURjZEIEx/M
   jDoTJbMqQy1biMCXeHsvIKOSpemNdBobhDH4Ii9KfjuQhE7+WrPZ24UCy
   LTYsj929ggS2E+Xb9GejM0aVu8SEd5a8Ih1eh5qs+Vsbyzywn8DtROJmT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="424503839"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="424503839"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:08:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="886244393"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="886244393"
Received: from lkp-server02.sh.intel.com (HELO d59cacf64e9e) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 14 Jun 2023 07:08:11 -0700
Received: from kbuild by d59cacf64e9e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q9RAQ-0000jF-2H;
        Wed, 14 Jun 2023 14:08:10 +0000
Date:   Wed, 14 Jun 2023 22:07:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [ceph-client:testing 21/21] fs/ceph/file.c:24:29: warning: unused
 variable 'cl'
Message-ID: <202306142255.ny5wITLE-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   363520bbbed48e045504a785c8af582e7533a115
commit: 363520bbbed48e045504a785c8af582e7533a115 [21/21] ceph: print the client global_id in all the debug logs
config: i386-randconfig-i011-20230612 (https://download.01.org/0day-ci/archive/20230614/202306142255.ny5wITLE-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        # https://github.com/ceph/ceph-client/commit/363520bbbed48e045504a785c8af582e7533a115
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 363520bbbed48e045504a785c8af582e7533a115
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/ceph/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306142255.ny5wITLE-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ceph/file.c: In function 'ceph_flags_sys2wire':
>> fs/ceph/file.c:24:29: warning: unused variable 'cl' [-Wunused-variable]
      24 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_init_file_info':
   fs/ceph/file.c:205:29: warning: unused variable 'cl' [-Wunused-variable]
     205 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_init_file':
   fs/ceph/file.c:264:29: warning: unused variable 'cl' [-Wunused-variable]
     264 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_renew_caps':
   fs/ceph/file.c:302:29: warning: unused variable 'cl' [-Wunused-variable]
     302 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_open':
   fs/ceph/file.c:363:29: warning: unused variable 'cl' [-Wunused-variable]
     363 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_finish_async_create':
   fs/ceph/file.c:644:29: warning: unused variable 'cl' [-Wunused-variable]
     644 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_release':
   fs/ceph/file.c:930:29: warning: unused variable 'cl' [-Wunused-variable]
     930 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function '__ceph_sync_read':
   fs/ceph/file.c:985:29: warning: unused variable 'cl' [-Wunused-variable]
     985 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_sync_read':
   fs/ceph/file.c:1183:29: warning: unused variable 'cl' [-Wunused-variable]
    1183 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_aio_complete':
   fs/ceph/file.c:1215:29: warning: unused variable 'cl' [-Wunused-variable]
    1215 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_aio_complete_req':
   fs/ceph/file.c:1268:29: warning: unused variable 'cl' [-Wunused-variable]
    1268 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_direct_read_write':
   fs/ceph/file.c:1415:29: warning: unused variable 'cl' [-Wunused-variable]
    1415 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_sync_write':
   fs/ceph/file.c:1642:29: warning: unused variable 'cl' [-Wunused-variable]
    1642 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_read_iter':
   fs/ceph/file.c:2043:29: warning: unused variable 'cl' [-Wunused-variable]
    2043 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_write_iter':
   fs/ceph/file.c:2204:29: warning: unused variable 'cl' [-Wunused-variable]
    2204 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_fallocate':
   fs/ceph/file.c:2537:29: warning: unused variable 'cl' [-Wunused-variable]
    2537 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'is_file_size_ok':
   fs/ceph/file.c:2674:29: warning: unused variable 'cl' [-Wunused-variable]
    2674 |         struct ceph_client *cl = ceph_inode_to_client(src_inode);
         |                             ^~
   fs/ceph/file.c: In function '__ceph_copy_file_range':
   fs/ceph/file.c:2834:29: warning: unused variable 'cl' [-Wunused-variable]
    2834 |         struct ceph_client *cl = src_fsc->client;
         |                             ^~
--
   fs/ceph/caps.c: In function 'ceph_unreserve_caps':
>> fs/ceph/caps.c:311:29: warning: unused variable 'cl' [-Wunused-variable]
     311 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_get_cap':
   fs/ceph/caps.c:333:29: warning: unused variable 'cl' [-Wunused-variable]
     333 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_put_cap':
   fs/ceph/caps.c:388:29: warning: unused variable 'cl' [-Wunused-variable]
     388 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function '__check_cap_issue':
   fs/ceph/caps.c:582:29: warning: unused variable 'cl' [-Wunused-variable]
     582 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_add_cap':
   fs/ceph/caps.c:658:29: warning: unused variable 'cl' [-Wunused-variable]
     658 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__cap_is_valid':
   fs/ceph/caps.c:791:29: warning: unused variable 'cl' [-Wunused-variable]
     791 |         struct ceph_client *cl = cap->session->s_mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function '__ceph_caps_issued':
   fs/ceph/caps.c:816:29: warning: unused variable 'cl' [-Wunused-variable]
     816 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__touch_cap':
   fs/ceph/caps.c:874:29: warning: unused variable 'cl' [-Wunused-variable]
     874 |         struct ceph_client *cl = s->s_mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function '__ceph_caps_issued_mask':
   fs/ceph/caps.c:896:29: warning: unused variable 'cl' [-Wunused-variable]
     896 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_caps_revoking':
   fs/ceph/caps.c:986:29: warning: unused variable 'cl' [-Wunused-variable]
     986 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__ceph_remove_cap':
   fs/ceph/caps.c:1140:29: warning: unused variable 'cl' [-Wunused-variable]
    1140 |         struct ceph_client *cl = session->s_mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function '__prep_cap':
   fs/ceph/caps.c:1412:29: warning: unused variable 'cl' [-Wunused-variable]
    1412 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_flush_snaps':
   fs/ceph/caps.c:1735:29: warning: unused variable 'cl' [-Wunused-variable]
    1735 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__mark_caps_flushing':
   fs/ceph/caps.c:1927:29: warning: unused variable 'cl' [-Wunused-variable]
    1927 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'try_nonblocking_invalidate':
   fs/ceph/caps.c:1976:29: warning: unused variable 'cl' [-Wunused-variable]
    1976 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_check_caps':
   fs/ceph/caps.c:2026:29: warning: unused variable 'cl' [-Wunused-variable]
    2026 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'flush_mdlog_and_wait_inode_unsafe_requests':
   fs/ceph/caps.c:2369:29: warning: unused variable 'cl' [-Wunused-variable]
    2369 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_fsync':
   fs/ceph/caps.c:2487:29: warning: unused variable 'cl' [-Wunused-variable]
    2487 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_write_inode':
   fs/ceph/caps.c:2539:29: warning: unused variable 'cl' [-Wunused-variable]
    2539 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_take_cap_refs':
   fs/ceph/caps.c:2773:29: warning: unused variable 'cl' [-Wunused-variable]
    2773 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'try_get_cap_refs':
   fs/ceph/caps.c:2827:29: warning: unused variable 'cl' [-Wunused-variable]
    2827 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'check_max_size':
   fs/ceph/caps.c:2989:29: warning: unused variable 'cl' [-Wunused-variable]
    2989 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_try_drop_cap_snap':
   fs/ceph/caps.c:3206:29: warning: unused variable 'cl' [-Wunused-variable]
    3206 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__ceph_put_cap_refs':
   fs/ceph/caps.c:3242:29: warning: unused variable 'cl' [-Wunused-variable]
    3242 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_put_wrbuffer_cap_refs':
   fs/ceph/caps.c:3358:29: warning: unused variable 'cl' [-Wunused-variable]
    3358 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'invalidate_aliases':
   fs/ceph/caps.c:3443:29: warning: unused variable 'cl' [-Wunused-variable]
    3443 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'handle_cap_flush_ack':
   fs/ceph/caps.c:3819:29: warning: unused variable 'cl' [-Wunused-variable]
    3819 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function '__ceph_remove_capsnap':
   fs/ceph/caps.c:3934:29: warning: unused variable 'cl' [-Wunused-variable]
    3934 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'handle_cap_flushsnap_ack':
   fs/ceph/caps.c:3980:29: warning: unused variable 'cl' [-Wunused-variable]
    3980 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'handle_cap_trunc':
   fs/ceph/caps.c:4032:29: warning: unused variable 'cl' [-Wunused-variable]
    4032 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_check_delayed_caps':
   fs/ceph/caps.c:4604:29: warning: unused variable 'cl' [-Wunused-variable]
    4604 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'flush_dirty_session_caps':
   fs/ceph/caps.c:4650:29: warning: unused variable 'cl' [-Wunused-variable]
    4650 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_encode_inode_release':
   fs/ceph/caps.c:4794:29: warning: unused variable 'cl' [-Wunused-variable]
    4794 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_encode_dentry_release':
>> fs/ceph/caps.c:4888:29: warning: variable 'cl' set but not used [-Wunused-but-set-variable]
    4888 |         struct ceph_client *cl;
         |                             ^~
   fs/ceph/caps.c: In function 'remove_capsnaps':
   fs/ceph/caps.c:4940:29: warning: unused variable 'cl' [-Wunused-variable]
    4940 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
--
   fs/ceph/inode.c: In function 'ceph_get_inode':
>> fs/ceph/inode.c:132:29: warning: unused variable 'cl' [-Wunused-variable]
     132 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/inode.c: In function '__get_or_create_frag':
   fs/ceph/inode.c:257:29: warning: unused variable 'cl' [-Wunused-variable]
     257 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function '__ceph_choose_frag':
   fs/ceph/inode.c:322:29: warning: unused variable 'cl' [-Wunused-variable]
     322 |         struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_alloc_inode':
>> fs/ceph/inode.c:568:32: warning: unused variable 'fsc' [-Wunused-variable]
     568 |         struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
         |                                ^~~
   fs/ceph/inode.c: In function 'ceph_evict_inode':
   fs/ceph/inode.c:691:29: warning: unused variable 'cl' [-Wunused-variable]
     691 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_fill_file_time':
   fs/ceph/inode.c:849:29: warning: unused variable 'cl' [-Wunused-variable]
     849 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function '__update_dentry_lease':
   fs/ceph/inode.c:1366:29: warning: unused variable 'cl' [-Wunused-variable]
    1366 |         struct ceph_client *cl = ceph_inode_to_client(dir);
         |                             ^~
   fs/ceph/inode.c: In function 'fill_readdir_cache':
   fs/ceph/inode.c:1884:29: warning: unused variable 'cl' [-Wunused-variable]
    1884 |         struct ceph_client *cl = ceph_inode_to_client(dir);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_inode_set_size':
   fs/ceph/inode.c:2123:29: warning: unused variable 'cl' [-Wunused-variable]
    2123 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_queue_inode_work':
   fs/ceph/inode.c:2144:29: warning: unused variable 'cl' [-Wunused-variable]
    2144 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/inode.c: In function '__ceph_do_pending_vmtruncate':
   fs/ceph/inode.c:2226:29: warning: unused variable 'cl' [-Wunused-variable]
    2226 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_inode_work':
   fs/ceph/inode.c:2289:29: warning: unused variable 'cl' [-Wunused-variable]
    2289 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function 'fill_fscrypt_truncate':
   fs/ceph/inode.c:2362:29: warning: unused variable 'cl' [-Wunused-variable]
    2362 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function '__ceph_setattr':
   fs/ceph/inode.c:2497:29: warning: unused variable 'cl' [-Wunused-variable]
    2497 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function '__ceph_do_getattr':
   fs/ceph/inode.c:2892:29: warning: unused variable 'cl' [-Wunused-variable]
    2892 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_do_getvxattr':
   fs/ceph/inode.c:2940:29: warning: unused variable 'cl' [-Wunused-variable]
    2940 |         struct ceph_client *cl = fsc->client;
         |                             ^~
--
   fs/ceph/quota.c: In function 'lookup_quotarealm_inode':
>> fs/ceph/quota.c:134:29: warning: unused variable 'cl' [-Wunused-variable]
     134 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
--
   fs/ceph/addr.c: In function 'ceph_dirty_folio':
>> fs/ceph/addr.c:83:29: warning: unused variable 'cl' [-Wunused-variable]
      83 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_invalidate_folio':
   fs/ceph/addr.c:141:29: warning: unused variable 'cl' [-Wunused-variable]
     141 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_release_folio':
   fs/ceph/addr.c:168:29: warning: unused variable 'cl' [-Wunused-variable]
     168 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'finish_netfs_read':
   fs/ceph/addr.c:247:29: warning: unused variable 'cl' [-Wunused-variable]
     247 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_netfs_issue_read':
   fs/ceph/addr.c:351:29: warning: unused variable 'cl' [-Wunused-variable]
     351 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_init_request':
   fs/ceph/addr.c:438:29: warning: unused variable 'cl' [-Wunused-variable]
     438 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'get_oldest_context':
   fs/ceph/addr.c:568:29: warning: unused variable 'cl' [-Wunused-variable]
     568 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'writepage_nounlock':
   fs/ceph/addr.c:665:29: warning: unused variable 'cl' [-Wunused-variable]
     665 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_find_incompatible':
   fs/ceph/addr.c:1449:29: warning: unused variable 'cl' [-Wunused-variable]
    1449 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_write_end':
   fs/ceph/addr.c:1554:29: warning: unused variable 'cl' [-Wunused-variable]
    1554 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_filemap_fault':
   fs/ceph/addr.c:1619:29: warning: unused variable 'cl' [-Wunused-variable]
    1619 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_page_mkwrite':
   fs/ceph/addr.c:1709:29: warning: unused variable 'cl' [-Wunused-variable]
    1709 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_fill_inline_data':
   fs/ceph/addr.c:1812:29: warning: unused variable 'cl' [-Wunused-variable]
    1812 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_uninline_data':
   fs/ceph/addr.c:1859:29: warning: unused variable 'cl' [-Wunused-variable]
    1859 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function '__ceph_pool_perm_get':
   fs/ceph/addr.c:2015:29: warning: unused variable 'cl' [-Wunused-variable]
    2015 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_pool_perm_check':
   fs/ceph/addr.c:2187:29: warning: unused variable 'cl' [-Wunused-variable]
    2187 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
..


vim +/cl +24 fs/ceph/file.c

    21	
    22	static __le32 ceph_flags_sys2wire(struct ceph_mds_client *mdsc, u32 flags)
    23	{
  > 24		struct ceph_client *cl = mdsc->fsc->client;
    25		u32 wire_flags = 0;
    26	
    27		switch (flags & O_ACCMODE) {
    28		case O_RDONLY:
    29			wire_flags |= CEPH_O_RDONLY;
    30			break;
    31		case O_WRONLY:
    32			wire_flags |= CEPH_O_WRONLY;
    33			break;
    34		case O_RDWR:
    35			wire_flags |= CEPH_O_RDWR;
    36			break;
    37		}
    38	
    39		flags &= ~O_ACCMODE;
    40	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
