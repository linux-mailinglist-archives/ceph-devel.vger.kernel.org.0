Return-Path: <ceph-devel+bounces-3016-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E655A9382B
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Apr 2025 15:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC87C464D4E
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Apr 2025 13:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7126126BF7;
	Fri, 18 Apr 2025 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MkGvdd7n"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080F5224F6
	for <ceph-devel@vger.kernel.org>; Fri, 18 Apr 2025 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744984715; cv=none; b=C3sVPw5pdPPWhBjPfjNOhF3OQYIfS55m2bGfFS63BvcyokrZ+n+qV5l1W3Pl15dHbPL5J6Y1y0UbXcSFyFSdL6e/0VLTbuxE7Cr8dO4c2wDZXYC0y6hRfLB1X3al62KqUCTMVALeZTNTGTNgZ+365wPHeq2WNrZ+bTy8YgtLO8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744984715; c=relaxed/simple;
	bh=pPt2nH40rR+OHeDjnAewm63+49oFL0/hRd/GcDmvK5c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DL1hoboN1mSOhe1k2YBNJuTCBVxMYUGpCXyXVPnrh05I6lYNXNRHWS3CEZhZsZQKxTnpfPKWy+5zibjvQn56wdvP4LUxElj9FdgmIC2stJO4PvAcZ/c5vDLC1DtCcEt3nAXjou+FQtTxX6CT6TIcZKrm2MSxbZbAIM2gnshcLXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MkGvdd7n; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744984713; x=1776520713;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=pPt2nH40rR+OHeDjnAewm63+49oFL0/hRd/GcDmvK5c=;
  b=MkGvdd7n9wchbvqSTDvpqdDN+MWsmdF3VQKMjzqgEl86skCm6SQY4RV1
   Y/3w2rPauqrCgk6BeBh6oBiM7PwQ6KP7joLxV5QBk6uEXByz8EkqvgRmB
   FyZ0v6b6dorsY+SRocaXTIEiqgRXIojQXAlapx1aMauRww1ReExFtR6M6
   aBBOS4NUHR5WlGabXQCrpGTL2BNoaGriC3g2Aqb5PC8K8vSnE6yx4NBTi
   4rmanI3qrnjILaB5pfMQLXLWsw4fJsOhc5S1ByUDcHjNwyYFl9f/GNwJa
   wOOgLWFYyWVsA1JtJoTs9XjawhwOUQRjhmGeuI5yMtVD3QLTSWrAIWeJy
   A==;
X-CSE-ConnectionGUID: T5uqtmwsQhawNphPQO2W2Q==
X-CSE-MsgGUID: Xx5KDqA9TMiiDPe9W5qgXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="57252662"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="57252662"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 06:58:32 -0700
X-CSE-ConnectionGUID: 7kltDLE0Qq+lMB2TO/97/A==
X-CSE-MsgGUID: cY7DD/P4RY6bonXeUbvWGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131066087"
Received: from lkp-server01.sh.intel.com (HELO 61e10e65ea0f) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 18 Apr 2025 06:58:31 -0700
Received: from kbuild by 61e10e65ea0f with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u5mEe-0002uX-3D;
	Fri, 18 Apr 2025 13:58:28 +0000
Date: Fri, 18 Apr 2025 21:57:40 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 69/76] csky-linux-gcc: error: unrecognized
 command-line option '-fmacro-backtrace-limit=0'; did you mean
 '-ftemplate-backtrace-limit='?
Message-ID: <202504182112.Y9Wc5U9x-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   e971700a84a03996c40a4a05e47ddcb65d20ff25
commit: 758e3b13187ab7e12eed0a51f51461c3f85a9fa5 [69/76] handling static and dynamic arrays better
config: csky-randconfig-002-20250418 (https://download.01.org/0day-ci/archive/20250418/202504182112.Y9Wc5U9x-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250418/202504182112.Y9Wc5U9x-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504182112.Y9Wc5U9x-lkp@intel.com/

All errors (new ones prefixed by >>):

>> csky-linux-gcc: error: unrecognized command-line option '-fmacro-backtrace-limit=0'; did you mean '-ftemplate-backtrace-limit='?
--
>> csky-linux-gcc: error: unrecognized command-line option '-fmacro-backtrace-limit=0'; did you mean '-ftemplate-backtrace-limit='?
--
>> csky-linux-gcc: error: unrecognized command-line option '-fmacro-backtrace-limit=0'; did you mean '-ftemplate-backtrace-limit='?
>> csky-linux-gcc: error: unrecognized command-line option '-fmacro-backtrace-limit=0'; did you mean '-ftemplate-backtrace-limit='?
   make[3]: *** [scripts/Makefile.build:194: scripts/mod/empty.o] Error 1 shuffle=2816476035
>> csky-linux-gcc: error: unrecognized command-line option '-fmacro-backtrace-limit=0'; did you mean '-ftemplate-backtrace-limit='?
   make[3]: *** [scripts/Makefile.build:102: scripts/mod/devicetable-offsets.s] Error 1 shuffle=2816476035
   make[3]: Target 'scripts/mod/' not remade because of errors.
   make[2]: *** [Makefile:1263: prepare0] Error 2 shuffle=2816476035
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:251: __sub-make] Error 2 shuffle=2816476035
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:251: __sub-make] Error 2 shuffle=2816476035
   make: Target 'prepare' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

