Return-Path: <ceph-devel+bounces-2658-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9313DA33EDA
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 13:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E874B188E40F
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 12:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F15227EBE;
	Thu, 13 Feb 2025 12:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ujw1EF4h"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C19A21D3F9
	for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2025 12:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739448690; cv=none; b=G7ORHDjzYY4zXH+ig7fzDLvftQzrUq5QQRoyBKz2w36GX+qNUJbOwaO66hHTwhMlelZzzqZm7E9nYdC22lFq4sHmE7WHEpCo0gjrKOSIKslorogmuIDPbBWDXan677kvuWnLzWhco4OsHNP81AC4TL7lJmuLHZINEKoXziFBo44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739448690; c=relaxed/simple;
	bh=tcARAwqkZDBAhU6cmdyNfSPdcXoB4V5O7YOWRqe7uR0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pMwVXrtFzG4/txpXMZVYwk5OL2r3TR4RUi1L/gUQeYQBXiPJf58kYQRkvxrBbJc5s8erFNxt0fu2qDUbq4hZK1+oqxXk70cBWhs9zVhkq9IjIKM3gyMNHD4fjsduJMYQAb7bY9hLMHNca1oQ9+Hp+vI0FD6RQMpvAg0cYGwLvx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ujw1EF4h; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739448688; x=1770984688;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=tcARAwqkZDBAhU6cmdyNfSPdcXoB4V5O7YOWRqe7uR0=;
  b=Ujw1EF4h+rRel/KFmLEpXUCuUcgwGXFQVfEat7sZb3zV4xK+BeeYQycF
   EdNNSjuv/B4mP1q5uIg2VEGMweCTpukRz5N/LIr60n315nRJAH1LcjEfE
   pvcxrKYPy3Ky0mGFoAJCnrckUDxUHm34RmFuidkFoHTAFLjhzvspn2y2m
   mwT+FV7W7DmgwmFRoqd4lMTOu56yvW0ouhbl/oKboW1JTKxf6ACZC+Oe5
   DMpho0KZTLiOY20xue8kWRid/xzNBI3IJgu3SDKB5wOj3vaNuswk+bFyu
   2Ew/TdnZm9tDW/skHMH37sOTZO4EWHI9hJ9uMUiXN8GcWhsfejn+odj7+
   g==;
X-CSE-ConnectionGUID: q+GQcIFWQmKy6QncSXE4og==
X-CSE-MsgGUID: wCo0EokGTISZu/Bm8Wp0Ig==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="57549589"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="57549589"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 04:11:28 -0800
X-CSE-ConnectionGUID: 67fzG+PHSBWZwBSoIrdYiQ==
X-CSE-MsgGUID: opa0QoV4SSOyR+wbweMxjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="143971391"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 13 Feb 2025 04:11:27 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tiY3w-001717-0E;
	Thu, 13 Feb 2025 12:11:24 +0000
Date: Thu, 13 Feb 2025 20:11:15 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 13/13]
 include/linux/ceph/ceph_debug.h:24:22: warning: '%s' directive output may be
 truncated writing up to 255 bytes into a region of size 219
Message-ID: <202502132038.TPFGWJku-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   cd1e899feeb6a7da55cbb74b9245c8bbb77f82ba
commit: cd1e899feeb6a7da55cbb74b9245c8bbb77f82ba [13/13] cephsun: using a dynamic buffer allocation
config: openrisc-allyesconfig (https://download.01.org/0day-ci/archive/20250213/202502132038.TPFGWJku-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250213/202502132038.TPFGWJku-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502132038.TPFGWJku-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/ceph/ceph_debug.h:9,
                    from net/ceph/mon_client.c:2:
   net/ceph/mon_client.c: In function '__send_subscribe':
>> include/linux/ceph/ceph_debug.h:24:22: warning: '%s' directive output may be truncated writing up to 255 bytes into a region of size 219 [-Wformat-truncation=]
      24 |         CEPH_SAN_LOG("%12.12s:%-4d : " fmt,                             \
         |                      ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san.h:83:33: note: in definition of macro 'CEPH_SAN_LOG'
      83 |     snprintf(buf, LOG_BUF_SIZE, fmt, ##__VA_ARGS__); \
         |                                 ^~~
   net/ceph/mon_client.c:367:17: note: in expansion of macro 'dout'
     367 |                 dout("%s %s start %llu flags 0x%x\n", __func__, buf,
         |                 ^~~~
   include/linux/ceph/ceph_debug.h:24:22: note: directive argument in the range [0, 255]
      24 |         CEPH_SAN_LOG("%12.12s:%-4d : " fmt,                             \
         |                      ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san.h:83:33: note: in definition of macro 'CEPH_SAN_LOG'
      83 |     snprintf(buf, LOG_BUF_SIZE, fmt, ##__VA_ARGS__); \
         |                                 ^~~
   net/ceph/mon_client.c:367:17: note: in expansion of macro 'dout'
     367 |                 dout("%s %s start %llu flags 0x%x\n", __func__, buf,
         |                 ^~~~
   include/linux/ceph/ceph_san.h:83:5: note: 'snprintf' output between 57 and 332 bytes into a destination of size 256
      83 |     snprintf(buf, LOG_BUF_SIZE, fmt, ##__VA_ARGS__); \
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:24:9: note: in expansion of macro 'CEPH_SAN_LOG'
      24 |         CEPH_SAN_LOG("%12.12s:%-4d : " fmt,                             \
         |         ^~~~~~~~~~~~
   net/ceph/mon_client.c:367:17: note: in expansion of macro 'dout'
     367 |                 dout("%s %s start %llu flags 0x%x\n", __func__, buf,
         |                 ^~~~
   include/linux/ceph/ceph_san.h:83:5: warning: 'snprintf' argument 7 overlaps destination object 'buf' [-Wrestrict]
      83 |     snprintf(buf, LOG_BUF_SIZE, fmt, ##__VA_ARGS__); \
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_debug.h:24:9: note: in expansion of macro 'CEPH_SAN_LOG'
      24 |         CEPH_SAN_LOG("%12.12s:%-4d : " fmt,                             \
         |         ^~~~~~~~~~~~
   net/ceph/mon_client.c:367:17: note: in expansion of macro 'dout'
     367 |                 dout("%s %s start %llu flags 0x%x\n", __func__, buf,
         |                 ^~~~
   include/linux/ceph/ceph_san.h:82:10: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
      82 |     char buf[LOG_BUF_SIZE]; \
         |          ^~~
   include/linux/ceph/ceph_debug.h:24:9: note: in expansion of macro 'CEPH_SAN_LOG'
      24 |         CEPH_SAN_LOG("%12.12s:%-4d : " fmt,                             \
         |         ^~~~~~~~~~~~
   net/ceph/mon_client.c:367:17: note: in expansion of macro 'dout'
     367 |                 dout("%s %s start %llu flags 0x%x\n", __func__, buf,
         |                 ^~~~


vim +24 include/linux/ceph/ceph_debug.h

de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  12  
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  13  /*
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  14   * wrap pr_debug to include a filename:lineno prefix on each line.
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  15   * this incurs some overhead (kernel size and execution time) due to
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  16   * the extra function call at each call site.
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  17   */
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  18  
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  19  # if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  20  #  define dout(fmt, ...)						\
3d14c5d2b6e15c include/linux/ceph/ceph_debug.h Yehuda Sadeh       2010-04-06  21  	pr_debug("%.*s %12.12s:%-4d:" fmt,				\
04fa82972277cd include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-11  22  		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
04fa82972277cd include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-11  23  		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__); 	\
866762b26eb7fd include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-12 @24  	CEPH_SAN_LOG("%12.12s:%-4d : " fmt,				\
6f4dbd149d2a15 include/linux/ceph/ceph_debug.h Ilya Dryomov       2017-05-19  25  		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
5c5f0d2b5f92c4 include/linux/ceph/ceph_debug.h Xiubo Li           2023-06-09  26  #  define doutc(client, fmt, ...)					\
5c5f0d2b5f92c4 include/linux/ceph/ceph_debug.h Xiubo Li           2023-06-09  27  	pr_debug("%.*s %12.12s:%-4d : [%pU %llu] " fmt,			\
04fa82972277cd include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-11  28  		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
04fa82972277cd include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-11  29  		 kbasename(__FILE__), __LINE__,				\
04fa82972277cd include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-11  30  		 &client->fsid, client->monc.auth->global_id,		\
04fa82972277cd include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-11  31  		 ##__VA_ARGS__); 					\
ab4d8f9713554f include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-12  32  	CEPH_SAN_LOG("%12.12s:%-4d:" fmt,				\
ab4d8f9713554f include/linux/ceph/ceph_debug.h Alex Markuze       2025-02-12  33  		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  34  # else
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  35  /* faux printk call just to see any compiler warnings. */
b37cafacbf98ea include/linux/ceph/ceph_debug.h Geert Uytterhoeven 2024-02-28  36  #  define dout(fmt, ...)					\
b37cafacbf98ea include/linux/ceph/ceph_debug.h Geert Uytterhoeven 2024-02-28  37  		no_printk(KERN_DEBUG fmt, ##__VA_ARGS__)
b37cafacbf98ea include/linux/ceph/ceph_debug.h Geert Uytterhoeven 2024-02-28  38  #  define doutc(client, fmt, ...)				\
b37cafacbf98ea include/linux/ceph/ceph_debug.h Geert Uytterhoeven 2024-02-28  39  		no_printk(KERN_DEBUG "[%pU %llu] " fmt,		\
5c5f0d2b5f92c4 include/linux/ceph/ceph_debug.h Xiubo Li           2023-06-09  40  			  &client->fsid,			\
5c5f0d2b5f92c4 include/linux/ceph/ceph_debug.h Xiubo Li           2023-06-09  41  			  client->monc.auth->global_id,		\
b37cafacbf98ea include/linux/ceph/ceph_debug.h Geert Uytterhoeven 2024-02-28  42  			  ##__VA_ARGS__)
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  43  # endif
de57606c23afde fs/ceph/ceph_debug.h            Sage Weil          2009-10-06  44  

:::::: The code at line 24 was first introduced by commit
:::::: 866762b26eb7fd11c6fcbb9aaaad9a4a232968c9 minor cosmetics

:::::: TO: Alex Markuze <amarkuze@redhat.com>
:::::: CC: Alex Markuze <amarkuze@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

