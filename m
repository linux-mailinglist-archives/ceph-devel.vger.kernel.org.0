Return-Path: <ceph-devel+bounces-3360-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F389AB1D7EF
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Aug 2025 14:32:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF2B2565D7B
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Aug 2025 12:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43BAD2472B0;
	Thu,  7 Aug 2025 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AmlrS0Hy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A703D23F413
	for <ceph-devel@vger.kernel.org>; Thu,  7 Aug 2025 12:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754569977; cv=none; b=ERQEIzsWv2dKcqF9MSh5Cx746X82xZoy8gAU1oTdPtyFy6XmZQVapKbwLy7yG25tp+jmj+cZWpJExhfGjMUdV5AUXCcFmHTEuRKk0kAZipnPx6cPttHHhLhfCgrSgfgw5bBOox5mZfeV62SpsFr8EMgyW/9bhkVJ+Y/ZOj9BJ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754569977; c=relaxed/simple;
	bh=vZkM54kTBg0RFWPkBbk8zwfryinMyBvIjNSW26uuwk0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=T29eRfJBZJyZ9ExSCMtzlTIHOQ+tS1cNg0saZEGrCTIBzmYOdD7DZDcnC/seh2K6ROaD4HvouK4ZVcSP6P4IOfj5iigFkDpagYqEX6jJJJIyzaEaK/fntebV1FUGXpKKoa6FqBh4mY/abXGAtz8glT628G/d05PMpc3BcK3YJ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AmlrS0Hy; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754569975; x=1786105975;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=vZkM54kTBg0RFWPkBbk8zwfryinMyBvIjNSW26uuwk0=;
  b=AmlrS0HyE/zH80XqtMTO86n4zSJ04R+rLo6MAUHbOTPqSZDvVvZu1fKn
   o+XDls/l2F6dlZSL8wBEVO0wMRxJ+TcCpbkKERBuTWrCuwKI3ai08myFc
   tpdNWr75xNm4okXrNTHZnQpnHEWCoNXs5ByFnI+N8nXvCDIoZG3xsoHAz
   cC/+TEm+5We2qtY3v9vJqf4bYjU+W+pSvaG3lAi/YqE4GRKTu2r1PuCHy
   bSkY3bNrJat/kOw0r9VdXtgNJXFWVk4xp0TEFP5ac9MgTwvH23y+yMTdw
   PJ03hFRxM2CXhGHFbuqU0QZ3cCVFa8yS9AgPBdDsbdWYzxhGNEvBxqKqX
   g==;
X-CSE-ConnectionGUID: HHo/yHxFQYWSfL/nHrsovw==
X-CSE-MsgGUID: KuOZmPnSRceqcUbU7xqN1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="55940099"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="55940099"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 05:32:52 -0700
X-CSE-ConnectionGUID: 6GioXaWZRfiV/ZI09GeXfQ==
X-CSE-MsgGUID: 7r39erp8TvSYrorKHk/iWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165846325"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 07 Aug 2025 05:32:50 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujznc-0002mI-1q;
	Thu, 07 Aug 2025 12:32:48 +0000
Date: Thu, 7 Aug 2025 20:32:43 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls-tracing-only 10/14] fs/ceph/debugfs.c:416:20:
 error: 'g_rtlog_logger' undeclared; did you mean 'rtlog_logger'?
Message-ID: <202508072033.jPVKaD9G-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls-tracing-only
head:   ffad14ce035a047cbfda2d38f7ae37b0767de136
commit: 310aa14b5bf4d5ecd1abf6a00782e044f7d76940 [10/14] ceph integration
config: i386-buildonly-randconfig-004-20250807 (https://download.01.org/0day-ci/archive/20250807/202508072033.jPVKaD9G-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508072033.jPVKaD9G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508072033.jPVKaD9G-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   fs/ceph/inode.c: In function 'ceph_get_inode':
   fs/ceph/inode.c:137:29: warning: unused variable 'cl' [-Wunused-variable]
     137 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/inode.c: In function '__get_or_create_frag':
   fs/ceph/inode.c:261:29: warning: unused variable 'cl' [-Wunused-variable]
     261 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function '__ceph_choose_frag':
   fs/ceph/inode.c:325:29: warning: unused variable 'cl' [-Wunused-variable]
     325 |         struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_alloc_inode':
   fs/ceph/inode.c:570:32: warning: unused variable 'fsc' [-Wunused-variable]
     570 |         struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
         |                                ^~~
   fs/ceph/inode.c: In function 'ceph_evict_inode':
   fs/ceph/inode.c:693:29: warning: unused variable 'cl' [-Wunused-variable]
     693 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_fill_file_time':
   fs/ceph/inode.c:846:29: warning: unused variable 'cl' [-Wunused-variable]
     846 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function '__update_dentry_lease':
   fs/ceph/inode.c:1361:29: warning: unused variable 'cl' [-Wunused-variable]
    1361 |         struct ceph_client *cl = ceph_inode_to_client(dir);
         |                             ^~
   fs/ceph/inode.c: In function 'fill_readdir_cache':
   fs/ceph/inode.c:1873:29: warning: unused variable 'cl' [-Wunused-variable]
    1873 |         struct ceph_client *cl = ceph_inode_to_client(dir);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_inode_set_size':
   fs/ceph/inode.c:2119:29: warning: unused variable 'cl' [-Wunused-variable]
    2119 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_queue_inode_work':
   fs/ceph/inode.c:2139:29: warning: unused variable 'cl' [-Wunused-variable]
    2139 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/inode.c: In function '__ceph_do_pending_vmtruncate':
   fs/ceph/inode.c:2220:29: warning: unused variable 'cl' [-Wunused-variable]
    2220 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_inode_work':
   fs/ceph/inode.c:2283:29: warning: unused variable 'cl' [-Wunused-variable]
    2283 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function 'fill_fscrypt_truncate':
>> fs/ceph/inode.c:2371:16: warning: unused variable 'i_size' [-Wunused-variable]
    2371 |         loff_t i_size = i_size_read(inode);
         |                ^~~~~~
   fs/ceph/inode.c:2358:29: warning: unused variable 'cl' [-Wunused-variable]
    2358 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function '__ceph_setattr':
   fs/ceph/inode.c:2495:29: warning: unused variable 'cl' [-Wunused-variable]
    2495 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/inode.c: In function '__ceph_do_getattr':
   fs/ceph/inode.c:2923:29: warning: unused variable 'cl' [-Wunused-variable]
    2923 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/inode.c: In function 'ceph_do_getvxattr':
   fs/ceph/inode.c:2971:29: warning: unused variable 'cl' [-Wunused-variable]
    2971 |         struct ceph_client *cl = fsc->client;
         |                             ^~
--
   fs/ceph/ioctl.c: In function 'ceph_ioctl_lazyio':
   fs/ceph/ioctl.c:248:29: warning: unused variable 'cl' [-Wunused-variable]
     248 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/ioctl.c: In function 'ceph_ioctl':
   fs/ceph/ioctl.c:368:32: warning: unused variable 'fsc' [-Wunused-variable]
     368 |         struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
         |                                ^~~
   At top level:
>> fs/ceph/ioctl.c:329:20: warning: 'ceph_ioctl_cmd_name' defined but not used [-Wunused-function]
     329 | static const char *ceph_ioctl_cmd_name(const unsigned int cmd)
         |                    ^~~~~~~~~~~~~~~~~~~
--
   fs/ceph/file.c: In function 'ceph_flags_sys2wire':
   fs/ceph/file.c:25:29: warning: unused variable 'cl' [-Wunused-variable]
      25 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_init_file_info':
   fs/ceph/file.c:206:29: warning: unused variable 'cl' [-Wunused-variable]
     206 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_init_file':
   fs/ceph/file.c:265:29: warning: unused variable 'cl' [-Wunused-variable]
     265 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_renew_caps':
>> fs/ceph/file.c:313:21: warning: unused variable 'issued' [-Wunused-variable]
     313 |                 int issued = __ceph_caps_issued(ci, NULL);
         |                     ^~~~~~
   fs/ceph/file.c:303:29: warning: unused variable 'cl' [-Wunused-variable]
     303 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_open':
   fs/ceph/file.c:363:29: warning: unused variable 'cl' [-Wunused-variable]
     363 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_finish_async_create':
   fs/ceph/file.c:671:29: warning: unused variable 'cl' [-Wunused-variable]
     671 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_release':
   fs/ceph/file.c:997:29: warning: unused variable 'cl' [-Wunused-variable]
     997 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function '__ceph_sync_read':
   fs/ceph/file.c:1052:29: warning: unused variable 'cl' [-Wunused-variable]
    1052 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_sync_read':
   fs/ceph/file.c:1254:29: warning: unused variable 'cl' [-Wunused-variable]
    1254 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_aio_complete':
   fs/ceph/file.c:1286:29: warning: unused variable 'cl' [-Wunused-variable]
    1286 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_aio_complete_req':
   fs/ceph/file.c:1339:29: warning: unused variable 'cl' [-Wunused-variable]
    1339 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_direct_read_write':
   fs/ceph/file.c:1486:29: warning: unused variable 'cl' [-Wunused-variable]
    1486 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_sync_write':
   fs/ceph/file.c:1715:29: warning: unused variable 'cl' [-Wunused-variable]
    1715 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_read_iter':
   fs/ceph/file.c:2115:29: warning: unused variable 'cl' [-Wunused-variable]
    2115 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'ceph_write_iter':
   fs/ceph/file.c:2339:29: warning: unused variable 'cl' [-Wunused-variable]
    2339 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/file.c: In function 'ceph_fallocate':
   fs/ceph/file.c:2699:29: warning: unused variable 'cl' [-Wunused-variable]
    2699 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/file.c: In function 'is_file_size_ok':
   fs/ceph/file.c:2870:29: warning: unused variable 'cl' [-Wunused-variable]
    2870 |         struct ceph_client *cl = ceph_inode_to_client(src_inode);
         |                             ^~
   fs/ceph/file.c: In function '__ceph_copy_file_range':
   fs/ceph/file.c:3030:29: warning: unused variable 'cl' [-Wunused-variable]
    3030 |         struct ceph_client *cl = src_fsc->client;
         |                             ^~
--
   fs/ceph/xattr.c: In function 'ceph_vxattrcb_layout':
   fs/ceph/xattr.c:62:29: warning: unused variable 'cl' [-Wunused-variable]
      62 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/xattr.c: In function '__set_xattr':
   fs/ceph/xattr.c:577:29: warning: unused variable 'cl' [-Wunused-variable]
     577 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/xattr.c: In function '__get_xattr':
   fs/ceph/xattr.c:695:45: warning: unused variable 'len' [-Wunused-variable]
     695 |                                         int len = min(xattr->val_len, MAX_XATTR_VAL_PRINT_LEN);
         |                                             ^~~
   fs/ceph/xattr.c:676:29: warning: unused variable 'cl' [-Wunused-variable]
     676 |         struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
         |                             ^~
   fs/ceph/xattr.c: In function '__copy_xattr_names':
   fs/ceph/xattr.c:743:29: warning: unused variable 'cl' [-Wunused-variable]
     743 |         struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
         |                             ^~
   fs/ceph/xattr.c: In function '__ceph_destroy_xattrs':
   fs/ceph/xattr.c:767:29: warning: unused variable 'cl' [-Wunused-variable]
     767 |         struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
         |                             ^~
   fs/ceph/xattr.c: In function '__build_xattrs':
   fs/ceph/xattr.c:797:29: warning: unused variable 'cl' [-Wunused-variable]
     797 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/xattr.c: In function '__get_required_blob_size':
   fs/ceph/xattr.c:885:29: warning: unused variable 'cl' [-Wunused-variable]
     885 |         struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
         |                             ^~
   fs/ceph/xattr.c: In function '__ceph_build_xattrs_blob':
   fs/ceph/xattr.c:912:29: warning: unused variable 'cl' [-Wunused-variable]
     912 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/xattr.c: In function 'ceph_listxattr':
   fs/ceph/xattr.c:1070:29: warning: unused variable 'cl' [-Wunused-variable]
    1070 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/xattr.c: In function 'ceph_sync_setxattr':
>> fs/ceph/xattr.c:1115:33: warning: unused variable 'ci' [-Wunused-variable]
    1115 |         struct ceph_inode_info *ci = ceph_inode(inode);
         |                                 ^~
   fs/ceph/xattr.c:1114:29: warning: unused variable 'cl' [-Wunused-variable]
    1114 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
--
   fs/ceph/mdsmap.c: In function 'ceph_mdsmap_decode':
>> fs/ceph/mdsmap.c:180:26: warning: variable 'inc' set but not used [-Wunused-but-set-variable]
     180 |                 s32 mds, inc, state;
         |                          ^~~
--
   fs/ceph/addr.c: In function 'ceph_dirty_folio':
>> fs/ceph/addr.c:85:29: warning: unused variable 'cl' [-Wunused-variable]
      85 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_invalidate_folio':
   fs/ceph/addr.c:145:29: warning: unused variable 'cl' [-Wunused-variable]
     145 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'finish_netfs_read':
   fs/ceph/addr.c:216:29: warning: unused variable 'cl' [-Wunused-variable]
     216 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_netfs_issue_read':
   fs/ceph/addr.c:355:29: warning: unused variable 'cl' [-Wunused-variable]
     355 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_init_request':
   fs/ceph/addr.c:461:29: warning: unused variable 'cl' [-Wunused-variable]
     461 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'get_oldest_context':
   fs/ceph/addr.c:625:29: warning: unused variable 'cl' [-Wunused-variable]
     625 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'write_folio_nounlock':
   fs/ceph/addr.c:723:29: warning: unused variable 'cl' [-Wunused-variable]
     723 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_define_writeback_range':
   fs/ceph/addr.c:1072:29: warning: unused variable 'cl' [-Wunused-variable]
    1072 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_check_page_before_write':
   fs/ceph/addr.c:1143:29: warning: unused variable 'cl' [-Wunused-variable]
    1143 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_process_folio_batch':
   fs/ceph/addr.c:1293:29: warning: unused variable 'cl' [-Wunused-variable]
    1293 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_writepages_start':
   fs/ceph/addr.c:1642:29: warning: unused variable 'cl' [-Wunused-variable]
    1642 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_find_incompatible':
   fs/ceph/addr.c:1800:29: warning: unused variable 'cl' [-Wunused-variable]
    1800 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_write_end':
   fs/ceph/addr.c:1900:29: warning: unused variable 'cl' [-Wunused-variable]
    1900 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_filemap_fault':
   fs/ceph/addr.c:1964:29: warning: unused variable 'cl' [-Wunused-variable]
    1964 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_page_mkwrite':
   fs/ceph/addr.c:2054:29: warning: unused variable 'cl' [-Wunused-variable]
    2054 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_fill_inline_data':
   fs/ceph/addr.c:2157:29: warning: unused variable 'cl' [-Wunused-variable]
    2157 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_uninline_data':
   fs/ceph/addr.c:2204:29: warning: unused variable 'cl' [-Wunused-variable]
    2204 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function '__ceph_pool_perm_get':
   fs/ceph/addr.c:2360:29: warning: unused variable 'cl' [-Wunused-variable]
    2360 |         struct ceph_client *cl = fsc->client;
         |                             ^~
   fs/ceph/addr.c: In function 'ceph_pool_perm_check':
   fs/ceph/addr.c:2534:29: warning: unused variable 'cl' [-Wunused-variable]
    2534 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
--
   fs/ceph/mds_client.c: In function '__open_session':
>> fs/ceph/mds_client.c:1667:13: warning: variable 'mstate' set but not used [-Wunused-but-set-variable]
    1667 |         int mstate;
         |             ^~~~~~
   fs/ceph/mds_client.c: In function 'ceph_mdsc_handle_mdsmap':
>> fs/ceph/mds_client.c:6125:13: warning: variable 'maplen' set but not used [-Wunused-but-set-variable]
    6125 |         u32 maplen;
         |             ^~~~~~
--
   fs/ceph/caps.c: In function 'ceph_unreserve_caps':
   fs/ceph/caps.c:312:29: warning: unused variable 'cl' [-Wunused-variable]
     312 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_get_cap':
   fs/ceph/caps.c:334:29: warning: unused variable 'cl' [-Wunused-variable]
     334 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_put_cap':
   fs/ceph/caps.c:389:29: warning: unused variable 'cl' [-Wunused-variable]
     389 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function '__cap_set_timeouts':
>> fs/ceph/caps.c:500:23: warning: unused variable 'inode' [-Wunused-variable]
     500 |         struct inode *inode = &ci->netfs.inode;
         |                       ^~~~~
   fs/ceph/caps.c: In function '__cap_delay_requeue':
   fs/ceph/caps.c:520:23: warning: unused variable 'inode' [-Wunused-variable]
     520 |         struct inode *inode = &ci->netfs.inode;
         |                       ^~~~~
   fs/ceph/caps.c: In function '__cap_delay_requeue_front':
   fs/ceph/caps.c:547:23: warning: unused variable 'inode' [-Wunused-variable]
     547 |         struct inode *inode = &ci->netfs.inode;
         |                       ^~~~~
   fs/ceph/caps.c: In function '__cap_delay_cancel':
   fs/ceph/caps.c:566:23: warning: unused variable 'inode' [-Wunused-variable]
     566 |         struct inode *inode = &ci->netfs.inode;
         |                       ^~~~~
   fs/ceph/caps.c: In function '__check_cap_issue':
   fs/ceph/caps.c:594:29: warning: unused variable 'cl' [-Wunused-variable]
     594 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_add_cap':
   fs/ceph/caps.c:670:29: warning: unused variable 'cl' [-Wunused-variable]
     670 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__cap_is_valid':
   fs/ceph/caps.c:803:29: warning: unused variable 'cl' [-Wunused-variable]
     803 |         struct ceph_client *cl = cap->session->s_mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c:802:23: warning: unused variable 'inode' [-Wunused-variable]
     802 |         struct inode *inode = &cap->ci->netfs.inode;
         |                       ^~~~~
   fs/ceph/caps.c: In function '__ceph_caps_issued':
   fs/ceph/caps.c:828:29: warning: unused variable 'cl' [-Wunused-variable]
     828 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__touch_cap':
   fs/ceph/caps.c:885:29: warning: unused variable 'cl' [-Wunused-variable]
     885 |         struct ceph_client *cl = s->s_mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c:883:23: warning: unused variable 'inode' [-Wunused-variable]
     883 |         struct inode *inode = &cap->ci->netfs.inode;
         |                       ^~~~~
   fs/ceph/caps.c: In function '__ceph_caps_issued_mask':
   fs/ceph/caps.c:907:29: warning: unused variable 'cl' [-Wunused-variable]
     907 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__ceph_remove_cap':
   fs/ceph/caps.c:1139:23: warning: unused variable 'inode' [-Wunused-variable]
    1139 |         struct inode *inode = &ci->netfs.inode;
         |                       ^~~~~
   fs/ceph/caps.c:1137:29: warning: unused variable 'cl' [-Wunused-variable]
    1137 |         struct ceph_client *cl = session->s_mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function '__prep_cap':
>> fs/ceph/caps.c:1410:13: warning: variable 'held' set but not used [-Wunused-but-set-variable]
    1410 |         int held, revoking;
         |             ^~~~
   fs/ceph/caps.c:1409:29: warning: unused variable 'cl' [-Wunused-variable]
    1409 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_flush_snaps':
   fs/ceph/caps.c:1741:29: warning: unused variable 'cl' [-Wunused-variable]
    1741 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__mark_caps_flushing':
   fs/ceph/caps.c:1933:29: warning: unused variable 'cl' [-Wunused-variable]
    1933 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'try_nonblocking_invalidate':
   fs/ceph/caps.c:1982:29: warning: unused variable 'cl' [-Wunused-variable]
    1982 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_check_caps':
   fs/ceph/caps.c:2034:29: warning: unused variable 'cl' [-Wunused-variable]
    2034 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'flush_mdlog_and_wait_inode_unsafe_requests':
   fs/ceph/caps.c:2383:29: warning: unused variable 'cl' [-Wunused-variable]
    2383 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_fsync':
   fs/ceph/caps.c:2501:29: warning: unused variable 'cl' [-Wunused-variable]
    2501 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_write_inode':
   fs/ceph/caps.c:2553:29: warning: unused variable 'cl' [-Wunused-variable]
    2553 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_kick_flushing_inode_caps':
   fs/ceph/caps.c:2757:23: warning: unused variable 'inode' [-Wunused-variable]
    2757 |         struct inode *inode = &ci->netfs.inode;
         |                       ^~~~~
   fs/ceph/caps.c: In function 'ceph_take_cap_refs':
   fs/ceph/caps.c:2786:29: warning: unused variable 'cl' [-Wunused-variable]
    2786 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'try_get_cap_refs':
   fs/ceph/caps.c:2839:29: warning: unused variable 'cl' [-Wunused-variable]
    2839 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'check_max_size':
   fs/ceph/caps.c:2998:29: warning: unused variable 'cl' [-Wunused-variable]
    2998 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_try_drop_cap_snap':
   fs/ceph/caps.c:3222:29: warning: unused variable 'cl' [-Wunused-variable]
    3222 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function '__ceph_put_cap_refs':
   fs/ceph/caps.c:3257:29: warning: unused variable 'cl' [-Wunused-variable]
    3257 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_put_wrbuffer_cap_refs':
   fs/ceph/caps.c:3367:29: warning: unused variable 'cl' [-Wunused-variable]
    3367 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'invalidate_aliases':
   fs/ceph/caps.c:3452:29: warning: unused variable 'cl' [-Wunused-variable]
    3452 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'handle_cap_grant':
>> fs/ceph/caps.c:3628:21: warning: unused variable 'len' [-Wunused-variable]
    3628 |                 int len = le32_to_cpu(grant->xattr_len);
         |                     ^~~
>> fs/ceph/caps.c:3518:27: warning: variable 'dirty' set but not used [-Wunused-but-set-variable]
    3518 |         int used, wanted, dirty;
         |                           ^~~~~
   fs/ceph/caps.c: In function 'handle_cap_flush_ack':
   fs/ceph/caps.c:3900:47: warning: unused variable 'inode' [-Wunused-variable]
    3900 |                                 struct inode *inode =
         |                                               ^~~~~
>> fs/ceph/caps.c:3843:13: warning: unused variable 'dirty' [-Wunused-variable]
    3843 |         int dirty = le32_to_cpu(m->dirty);
         |             ^~~~~
>> fs/ceph/caps.c:3842:18: warning: unused variable 'seq' [-Wunused-variable]
    3842 |         unsigned seq = le32_to_cpu(m->seq);
         |                  ^~~
   fs/ceph/caps.c:3839:29: warning: unused variable 'cl' [-Wunused-variable]
    3839 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function '__ceph_remove_capsnap':
   fs/ceph/caps.c:3953:29: warning: unused variable 'cl' [-Wunused-variable]
    3953 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'handle_cap_trunc':
   fs/ceph/caps.c:4055:13: warning: unused variable 'seq' [-Wunused-variable]
    4055 |         int seq = le32_to_cpu(trunc->seq);
         |             ^~~
>> fs/ceph/caps.c:4054:13: warning: unused variable 'mds' [-Wunused-variable]
    4054 |         int mds = session->s_mds;
         |             ^~~
   fs/ceph/caps.c:4053:29: warning: unused variable 'cl' [-Wunused-variable]
    4053 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_handle_caps':
>> fs/ceph/caps.c:4368:24: warning: variable 'issue_seq' set but not used [-Wunused-but-set-variable]
    4368 |         u32 seq, mseq, issue_seq;
         |                        ^~~~~~~~~
   fs/ceph/caps.c: In function 'ceph_check_delayed_caps':
   fs/ceph/caps.c:4650:29: warning: unused variable 'cl' [-Wunused-variable]
    4650 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'flush_dirty_session_caps':
   fs/ceph/caps.c:4704:29: warning: unused variable 'cl' [-Wunused-variable]
    4704 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'flush_cap_releases':
   fs/ceph/caps.c:4737:29: warning: unused variable 'cl' [-Wunused-variable]
    4737 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_encode_inode_release':
   fs/ceph/caps.c:4885:29: warning: unused variable 'cl' [-Wunused-variable]
    4885 |         struct ceph_client *cl = ceph_inode_to_client(inode);
         |                             ^~
   fs/ceph/caps.c: In function 'ceph_encode_dentry_release':
   fs/ceph/caps.c:4978:29: warning: variable 'cl' set but not used [-Wunused-but-set-variable]
    4978 |         struct ceph_client *cl;
         |                             ^~
   fs/ceph/caps.c: In function 'remove_capsnaps':
   fs/ceph/caps.c:5028:29: warning: unused variable 'cl' [-Wunused-variable]
    5028 |         struct ceph_client *cl = mdsc->fsc->client;
         |                             ^~
..


vim +416 fs/ceph/debugfs.c

   405	
   406	static int rtlog_tls_show_internal(struct seq_file *s, void *p)
   407	{
   408		struct rtlog_tls_ctx *ctx;
   409		struct rtlog_log_iter iter;
   410		struct rtlog_log_entry *entry;
   411		const struct rtlog_source_info *source;
   412		int total_entries = 0;
   413		int total_contexts = 0;
   414	
   415		/* Lock the logger to safely traverse the contexts list */
 > 416		spin_lock(&g_rtlog_logger.lock);
   417	
   418		list_for_each_entry(ctx, &g_rtlog_logger.contexts, list) {
   419			/* Initialize iterator for this context's pagefrag */
 > 420			rtlog_log_iter_init(&iter, &ctx->pf);
   421			int pid = ctx->pid;
   422			char *comm = ctx->comm;
   423			int ctx_entries = 0;
   424	
   425			total_contexts++;
   426	
   427			/* Lock the pagefrag before accessing entries */
   428			spin_lock_bh(&ctx->pf.lock);
   429	
   430			/* Iterate through log entries in this context */
 > 431			while ((entry = rtlog_log_iter_next(&iter)) != NULL) {
   432				char datetime_str[32];
   433				char reconstructed_msg[256];
   434	
   435				/* Validate entry before processing */
 > 436				if (!entry || !rtlog_is_valid_kernel_addr(entry)) {
   437					seq_printf(s, "[%d][%s]: Invalid entry pointer %p\n", pid, comm, entry);
   438					break;
   439				}
   440	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

