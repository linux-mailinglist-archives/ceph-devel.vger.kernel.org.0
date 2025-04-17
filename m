Return-Path: <ceph-devel+bounces-3015-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF237A91939
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Apr 2025 12:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73CA1188F1AA
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Apr 2025 10:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C27D22C322;
	Thu, 17 Apr 2025 10:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOu/9ht5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8668F22A4E4
	for <ceph-devel@vger.kernel.org>; Thu, 17 Apr 2025 10:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744885442; cv=none; b=Vvn3Oa+IVhiNQ2UuYepTdojhndY0ZPYTFUZJ9MatMg68Ycsrbcda9eN08resxQkLbegORTkOd2hYI6T+DyvGyhOA3g2IBQxyL895mbqByxLAscbFPxLHwTtBu3eKy82NKXfW4KruZisxG0gf+xQz71tm2htQUVdON7sjzN9RZM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744885442; c=relaxed/simple;
	bh=gIsJZD5tFrwIHvhcy2r/+NOceOjoU6wkMbMldBkM4+s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LGgeflX/a7IN1b0MBsg6LV4Gtt5cHC+Cb+VOrTc9mZ9k7hUcVZW9xKEiLuWj0AThMwqBMUqineQU2+/0LRFs+JPQVSVpHEe4bYqZXQcTUT7pl5Zd96Vt1H9ewuMygEDplHfKneyM4wtEhz1xRDqcIH++/Zuhrt6PEYQhW9ycsvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOu/9ht5; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744885440; x=1776421440;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=gIsJZD5tFrwIHvhcy2r/+NOceOjoU6wkMbMldBkM4+s=;
  b=gOu/9ht5RMS4KaTn69MpXVqMW+tjoI/3gZIlpH6l5AHYXQoUM8GR3wKu
   2sayr7ITQ3o7P1ob5WCN2HN/2IXQbZBHiKbhZudf+yqRLnMh10TnN2rP8
   VD4eaPaN6ZJK3qSxKeOTctd/dz2A4MhHBt6ueJRlZLEVAVs7k8D0UDXK+
   nWyhHyG31Dt+Lq92CldVCYhGgD/nlQnhCv7mNjVDIg/0Y+Hb1+Dy3TtPC
   LtIVWkEcqPH1nWuUL/CIa4Uqxc98BkXXgTVVXD5F1TEI75Og65fSwNXWt
   Yd1GzY9fES9N/2tN1IBMHgBUagW6N3yLk9pLCAoFQuvp8Oxc02MtUdahq
   w==;
X-CSE-ConnectionGUID: S014OYi4R2y2PBc2d9fwLA==
X-CSE-MsgGUID: iSlak+2HQkaFud+APSB8gg==
X-IronPort-AV: E=McAfee;i="6700,10204,11405"; a="57108444"
X-IronPort-AV: E=Sophos;i="6.15,218,1739865600"; 
   d="scan'208";a="57108444"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 03:23:59 -0700
X-CSE-ConnectionGUID: m/Sq3WuxR12k4pGEoEc5PQ==
X-CSE-MsgGUID: EUObQveeQJu2R63BORPw1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,218,1739865600"; 
   d="scan'208";a="135928549"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 17 Apr 2025 03:23:59 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u5MPU-000MND-1T;
	Thu, 17 Apr 2025 10:23:56 +0000
Date: Thu, 17 Apr 2025 18:23:03 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 69/74] gcc-12: error: unrecognized
 command-line option '-fmacro-backtrace-limit=0'; did you mean
 '-ftemplate-backtrace-limit='?
Message-ID: <202504171821.721LEYkt-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   0d5ab03c4770a345a051e813774f2f8d1a3efaeb
commit: 758e3b13187ab7e12eed0a51f51461c3f85a9fa5 [69/74] handling static and dynamic arrays better
config: i386-buildonly-randconfig-002-20250417 (https://download.01.org/0day-ci/archive/20250417/202504171821.721LEYkt-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250417/202504171821.721LEYkt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504171821.721LEYkt-lkp@intel.com/

All errors (new ones prefixed by >>):

>> gcc-12: error: unrecognized command-line option '-fmacro-backtrace-limit=0'; did you mean '-ftemplate-backtrace-limit='?
   make[3]: *** [scripts/Makefile.build:194: scripts/mod/empty.o] Error 1 shuffle=2412482620
>> gcc-12: error: unrecognized command-line option '-fmacro-backtrace-limit=0'; did you mean '-ftemplate-backtrace-limit='?
   make[3]: *** [scripts/Makefile.build:102: scripts/mod/devicetable-offsets.s] Error 1 shuffle=2412482620
   make[3]: Target 'scripts/mod/' not remade because of errors.
   make[2]: *** [Makefile:1263: prepare0] Error 2 shuffle=2412482620
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:251: __sub-make] Error 2 shuffle=2412482620
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:251: __sub-make] Error 2 shuffle=2412482620
   make: Target 'prepare' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

