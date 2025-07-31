Return-Path: <ceph-devel+bounces-3344-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F24EB17A26
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Aug 2025 01:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B8956246EB
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 23:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 769D01D52B;
	Thu, 31 Jul 2025 23:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HlT1pYeT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2F28937E
	for <ceph-devel@vger.kernel.org>; Thu, 31 Jul 2025 23:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754005429; cv=none; b=p4pd9nTucWFUBvaJmEo5DbzXWDVlrt9py07GmU+4TUTSfdDWhVVO+PS1dXwg8S27bFyVQxAvgvjMjOxZRK+ILFrgUoXSAZmTblpWqBUMJ55Z37ZVGM0qkOrGJVVfZYiZQdUEUQ7q4jM4t5ZJnMEUeF5bXqK3o6Y3paJS9eYkRZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754005429; c=relaxed/simple;
	bh=yYDyGB3hiLLhiD9Tf43fQtslkj+92DKYir3PwZ8WLwM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Eu8SyplZt49SAKHVeoJqPNaJNCqkGrcSlYkUS+GbYmqHKu0CXoVfqDg9R40W9tVzPgCskoPCNvSh/oXD7dW9hK2DfOItglPxRTZMcK0IHbSSwJOx6Sqg2AtxVRnIkh0bOKl42xTv5Zh8P0+uMeuQG2oVTNg4kHDyscRCtba/We4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HlT1pYeT; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754005428; x=1785541428;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=yYDyGB3hiLLhiD9Tf43fQtslkj+92DKYir3PwZ8WLwM=;
  b=HlT1pYeT8aC19m3L6T5P/wd87DEeyOZ45dJLXTxdpc4jxVNatN4P8pEy
   vjP26ci9jYwJJWYA/hW5BPwUCdqeVT8umi7EcgkdEdzNXjvjrNhuByolW
   SpfQsPZHgzojk1kYb92X4TKfKl4xsiBbYLRj3CFkDPIGxf/2y3rT5Xu6Z
   sv/41esZmBl//thIjs6WsGfmzfJVVdHaazzcbKbF2wAe1bfHpACWtHJif
   s/+JtpZ/3aTUw9qTQiRKa/tHTTvqFmtxO3phQOv75q8gS9UY/7RMDloRE
   4dtbKjjako+bDHvr7E8pkDz1pq4iYcKfrH/iDIpoNUntUpNt2S+nsnB43
   w==;
X-CSE-ConnectionGUID: RwMTqJSpSzigoHHKdpc+9g==
X-CSE-MsgGUID: +wm0n6E3Rb6m/wyVH5EUGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56042516"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56042516"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 16:43:48 -0700
X-CSE-ConnectionGUID: D7LasEB+Q+OjfnpmH7ullw==
X-CSE-MsgGUID: G226XknfT1OnZGDvdCwRaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="187074416"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 31 Jul 2025 16:43:45 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhcw3-0004DK-1y;
	Thu, 31 Jul 2025 23:43:43 +0000
Date: Fri, 1 Aug 2025 07:42:54 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:wip-tls-tracing-parent-fix 6/8]
 fs/ceph/debugfs.c:366:19: warning: variable 'seconds' set but not used
Message-ID: <202508010753.ulnHM0RZ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git wip-tls-tracing-parent-fix
head:   e9538aee9a1876fc317762d0ace8078e96c897af
commit: e442fc60cf71f159f1138f01ad70d70305ff05d5 [6/8] ceph fs debugfs code
config: i386-buildonly-randconfig-003-20250801 (https://download.01.org/0day-ci/archive/20250801/202508010753.ulnHM0RZ-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250801/202508010753.ulnHM0RZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508010753.ulnHM0RZ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/include/asm/current.h:5,
                    from include/linux/sched.h:12,
                    from include/linux/ceph/ceph_san_logger.h:5,
                    from include/linux/ceph/ceph_debug.h:9,
                    from fs/ceph/debugfs.c:2:
   include/linux/ceph/ceph_san_ser.h: In function 'write_null_str':
   include/linux/build_bug.h:78:41: error: static assertion failed: "null_str.str size must match unsigned long for proper alignment"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   include/linux/ceph/ceph_san_ser.h:116:5: note: in expansion of macro 'static_assert'
     116 |     static_assert(sizeof(null_str.str) == sizeof(unsigned long),
         |     ^~~~~~~~~~~~~
   fs/ceph/debugfs.c: In function 'jiffies_to_formatted_time':
>> fs/ceph/debugfs.c:366:19: warning: variable 'seconds' set but not used [-Wunused-but-set-variable]
     366 |     unsigned long seconds;
         |                   ^~~~~~~


vim +/seconds +366 fs/ceph/debugfs.c

   358	
   359	/* @buffer: The buffer to store the formatted date and time string.
   360	 * @buffer_len: The length of the buffer.
   361	 *
   362	 * Returns: The number of characters written to the buffer, or a negative error code.
   363	 */
   364	static int jiffies_to_formatted_time(unsigned long jiffies_value, char *buffer, size_t buffer_len)
   365	{
 > 366	    unsigned long seconds;
   367	    unsigned long subsec_jiffies;
   368	    unsigned long microseconds;
   369	    struct tm tm_time;
   370	    time64_t timestamp;
   371	
   372	    // Convert jiffies to seconds since boot
   373	    seconds = jiffies_value / HZ;
   374	
   375	    // Calculate remaining jiffies for subsecond precision
   376	    subsec_jiffies = jiffies_value % HZ;
   377	    microseconds = (subsec_jiffies * 1000) / HZ;
   378	
   379	    // Get current time and calculate absolute timestamp
   380	    // Using boottime as reference to convert relative jiffies to absolute time
   381	    timestamp = ktime_get_real_seconds() - (jiffies - jiffies_value) / HZ;
   382	
   383	    // Convert to broken-down time
   384	    time64_to_tm(timestamp, 0, &tm_time);
   385	
   386	    // Format the time into the buffer with millisecond precision
   387	    return snprintf(buffer, buffer_len, "%04ld-%02d-%02d %02d:%02d:%02d.%03lu",
   388	                   tm_time.tm_year + 1900, tm_time.tm_mon + 1, tm_time.tm_mday,
   389	                   tm_time.tm_hour, tm_time.tm_min, tm_time.tm_sec, microseconds);
   390	}
   391	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

