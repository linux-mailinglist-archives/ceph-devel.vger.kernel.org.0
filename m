Return-Path: <ceph-devel+bounces-2662-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04833A34C51
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 18:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7891B7A33E0
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 17:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C91227E88;
	Thu, 13 Feb 2025 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z0NE47cU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F1A221720
	for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2025 17:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739468771; cv=none; b=F6DzE6c8Tcgj0jKVdmYn05n5K0zr2OjWJQwHn0kmc0trNA+J0xlyyDp259oz4Dv7BEfA7d5KssEUsZKYNL8L1WUhRn3cZAIxrgTV01gPFqpRGV1GohtSgCQF0TSSPTSaVDGqQkRQdTXZHQ988aI7o1VLYTEpvvBfcvhURC1Cw6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739468771; c=relaxed/simple;
	bh=4Qi4aFvSW5Z/Wvoeq9b06HzJ56rZuchfxdbZiQZMv0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uW7TAKvx5tv4/lZiOHriHPGqb9NVqMOpV8WwSS+gw2txFRiNPZ05YsYSC6PXC3vagqFSdIJoov1IPDLipScq+L0Cnrbub2GeZATXyslecC/FzJpTLfJ8PpoFG8uedSBSKhOZMmLYeDxCutvmo3q8GDzsvK0QrZDVaXNnLE+HmMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z0NE47cU; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739468769; x=1771004769;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4Qi4aFvSW5Z/Wvoeq9b06HzJ56rZuchfxdbZiQZMv0Y=;
  b=Z0NE47cUy6ms6OliNJw8OKrrNR8/nXZER70jHfAl9Os5WOel/yvRGQdE
   JBbArwyPSiSsVXGJP0ikBFjugc4ClHRarXojneCtEeAYNPpknzbM5V5vf
   El8iQXw+FRw6226dkmOLkLK1w0ueCt5r0JHim33y0oZK99kPyOnCDPxps
   TLyesLgtOvHPSJhW0uN5rvl9VkaMnRxUb6+mItV9q7A4trdGnxbEwLKMy
   E3c2rDpMKAAofclGSNPbqgrwB33qZJImo+r0mxLIC3ZGRgEfcjqQA4pN/
   V5U9R3Ohab2gd3C9VYFCe1FjaUjQ494NsmIVvPSTquWhowB5LTuYO9oLs
   w==;
X-CSE-ConnectionGUID: kBR1IfdESLqedYnw78Xubg==
X-CSE-MsgGUID: BUSFrWCoRAaBQu8e6Bobdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="39417927"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="39417927"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 09:46:08 -0800
X-CSE-ConnectionGUID: Me2jYdVuRe+Rj7iK/9F/6Q==
X-CSE-MsgGUID: BNRDYOI+Ty6LYxXW95dffw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117847849"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 13 Feb 2025 09:46:07 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tidHo-0018WJ-2d;
	Thu, 13 Feb 2025 17:46:04 +0000
Date: Fri, 14 Feb 2025 01:45:59 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 13/13] net/ceph/ceph_san.c:25:39: sparse:
 sparse: incorrect type in initializer (different address spaces)
Message-ID: <202502140148.QryPfsF2-lkp@intel.com>
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
config: alpha-randconfig-r133-20250213 (https://download.01.org/0day-ci/archive/20250214/202502140148.QryPfsF2-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 14.2.0
reproduce: (https://download.01.org/0day-ci/archive/20250214/202502140148.QryPfsF2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502140148.QryPfsF2-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/ceph/ceph_san.c:188:39: sparse: sparse: no newline at end of file
   net/ceph/ceph_san.c:24:39: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_tls_logger * @@
   net/ceph/ceph_san.c:24:39: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:24:39: sparse:     got struct ceph_san_tls_logger *
>> net/ceph/ceph_san.c:25:39: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct cephsan_pagefrag * @@
   net/ceph/ceph_san.c:25:39: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:25:39: sparse:     got struct cephsan_pagefrag *
   net/ceph/ceph_san.c:54:23: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_tls_logger * @@
   net/ceph/ceph_san.c:54:23: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:54:23: sparse:     got struct ceph_san_tls_logger *
   net/ceph/ceph_san.c:72:23: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ceph_san_tls_logger * @@
   net/ceph/ceph_san.c:72:23: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:72:23: sparse:     got struct ceph_san_tls_logger *
   net/ceph/ceph_san.c:82:22: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct cephsan_pagefrag * @@
   net/ceph/ceph_san.c:82:22: sparse:     expected void const [noderef] __percpu *__vpp_verify
   net/ceph/ceph_san.c:82:22: sparse:     got struct cephsan_pagefrag *

vim +25 net/ceph/ceph_san.c

    15	
    16	
    17	static inline void *cephsan_pagefrag_get_ptr(struct cephsan_pagefrag *pf, u64 val);
    18	/* The definitions for struct ceph_san_log_entry and struct ceph_san_tls_logger
    19	 * have been moved to cephsan.h (under CONFIG_DEBUG_FS) to avoid duplication.
    20	 */
    21	
    22	void log_cephsan(char *buf) {
    23	    /* Use the per-core TLS logger */
    24	    struct ceph_san_tls_logger *tls = this_cpu_ptr(&ceph_san_tls);
  > 25		struct cephsan_pagefrag *pf = this_cpu_ptr(&ceph_san_pagefrag);
    26	
    27	    int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
    28		int pre_len = tls->logs[head_idx].len;
    29	    tls->logs[head_idx].pid = current->pid;
    30	    tls->logs[head_idx].ts = jiffies;
    31	    memcpy(tls->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
    32	
    33		cephsan_pagefrag_free(pf, pre_len);
    34	
    35		int len = strlen(buf);
    36	    u64 buf_idx = cephsan_pagefrag_alloc(pf, len);
    37	    if (buf_idx) {
    38			tls->logs[head_idx].len = len;
    39	        tls->logs[head_idx].buf = cephsan_pagefrag_get_ptr(pf, buf_idx);
    40			memcpy(tls->logs[head_idx].buf, buf, len);
    41	    }
    42	}
    43	EXPORT_SYMBOL(log_cephsan);
    44	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

