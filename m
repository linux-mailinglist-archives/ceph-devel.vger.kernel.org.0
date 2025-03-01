Return-Path: <ceph-devel+bounces-2842-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 396B6A4AE05
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Mar 2025 22:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04E851892556
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Mar 2025 21:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A1F1D2F53;
	Sat,  1 Mar 2025 21:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NitKJ9ps"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDDE179BC
	for <ceph-devel@vger.kernel.org>; Sat,  1 Mar 2025 21:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740864267; cv=none; b=BZM2+YHGXUtkZGfWmqwwYYgwVjG9Q+nDkfF+tLYP2GwgdByZsFKsKU6B3lybGoaTSHs1LFgRXDxn6tGK4DxOVZLGEsZa5XL0JYsTHtzoLqF5iD2nj93Hf/ZBAB33hCQmkpnUnFd/Y+lqXL773FWRrYzxLlZqHYJ1I6ANPLEeIWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740864267; c=relaxed/simple;
	bh=EywiEp6ove7hJgbPS5v48hgV5tjtUBFLS2ed7i3khQA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PAgIr3Z7cpPSM2q8MkisQaceKbhhap1luvoIQxJEFxNn6LaVK4po91C4HlYl0cb/l83BfBJUJxeRzHiDBsEb12dUaC5q+h4b/9aqfMTsYz5NUOhtmYtckDxLicLuuIL3axhxMvY2wnaMXFUs7sVRfZq/W4URUMLGjACg+79viWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NitKJ9ps; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740864265; x=1772400265;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=EywiEp6ove7hJgbPS5v48hgV5tjtUBFLS2ed7i3khQA=;
  b=NitKJ9pswr+PNIyx1TUJDUXQ/hTGjkY1PbAAZoJ5PfqJiUSfKN49Jz5t
   Y98uYyxh+NUaMmTbJ6k9PyysFQdtKRRGg35txgi9eQd1S7s781/0xM86U
   sy51ATG25QiOiWhVg98rnyeCqd+9QLWE0YgxZ5El3IP1BPfEoPFDOVn92
   vqzq5GcIvg5qmBXTqctHxNvcfoRwv26rJ83TD+df9Pu10dvVknFugdhqx
   biyNFT+QkPPgbJRyILhXmg7QrZOiBPTFGxV4AJvw6n77SoRO1SzWGpS5w
   rmVPdtv+BnqLx+sGUr4nr7IbmVp1rRF9eDcGqVZ+PkzXjMmWb8swjjdL1
   w==;
X-CSE-ConnectionGUID: Ag+0ZR2WS1eHNasbQdToFQ==
X-CSE-MsgGUID: BzLZyhVLTLOHFsgQvHAHeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11360"; a="45552575"
X-IronPort-AV: E=Sophos;i="6.13,326,1732608000"; 
   d="scan'208";a="45552575"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2025 13:24:25 -0800
X-CSE-ConnectionGUID: HTG6eEGYSU6ImIcb9xgJ+Q==
X-CSE-MsgGUID: JluZ0US+Qdy2mGAcwWQgnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="154815488"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 01 Mar 2025 13:24:23 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1toUJp-000Gio-0o;
	Sat, 01 Mar 2025 21:24:21 +0000
Date: Sun, 2 Mar 2025 05:23:40 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 3/5] net/ceph/ceph_san.c:29:34: warning:
 suggest parentheses around '+' in operand of '&'
Message-ID: <202503020506.Qrxa9ubO-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   b980c3ea5fcc54aa543fd5e96212b7fb892d42a5
commit: 764e50ba296da76e7332d2d08223d3e484aea2b3 [3/5] tls: adding an allocation histogram
config: arc-randconfig-001-20250302 (https://download.01.org/0day-ci/archive/20250302/202503020506.Qrxa9ubO-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250302/202503020506.Qrxa9ubO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503020506.Qrxa9ubO-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ceph/ceph_san.c: In function 'log_cephsan':
>> net/ceph/ceph_san.c:29:34: warning: suggest parentheses around '+' in operand of '&' [-Wparentheses]
      29 |     int head_idx = tls->head_idx + 1 & (CEPH_SAN_MAX_LOGS - 1);
         |                    ~~~~~~~~~~~~~~^~~


vim +29 net/ceph/ceph_san.c

    15	
    16	
    17	static inline void *cephsan_pagefrag_get_ptr(struct cephsan_pagefrag *pf, u64 val);
    18	/* The definitions for struct ceph_san_log_entry and struct ceph_san_tls_logger
    19	 * have been moved to cephsan.h (under CONFIG_DEBUG_FS) to avoid duplication.
    20	 */
    21	
    22	void log_cephsan(char *buf) {
    23	    /* Use the per-core TLS logger */
    24	    u64 buf_idx;
    25	    int len = strlen(buf);
    26	    struct ceph_san_tls_logger *tls = this_cpu_ptr(&ceph_san_tls);
    27	    struct cephsan_pagefrag *pf = this_cpu_ptr(&ceph_san_pagefrag);
    28	
  > 29	    int head_idx = tls->head_idx + 1 & (CEPH_SAN_MAX_LOGS - 1);
    30	    int pre_len = tls->logs[head_idx].len;
    31	
    32	    buf[len-1] = '\0';
    33	    tls->logs[head_idx].pid = current->pid;
    34	    tls->logs[head_idx].ts = jiffies;
    35	    memcpy(tls->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
    36	
    37	    cephsan_pagefrag_free(pf, pre_len);
    38	    tls->logs[head_idx].len = 0;
    39	
    40	    buf_idx = cephsan_pagefrag_alloc(pf, len);
    41	    if (buf_idx) {
    42			tls->head_idx = head_idx;
    43			tls->histogram.counters[len >> 3]++;
    44			tls->logs[head_idx].len = len;
    45	        tls->logs[head_idx].buf = cephsan_pagefrag_get_ptr(pf, buf_idx);
    46			memcpy(tls->logs[head_idx].buf, buf, len);
    47	    }
    48	}
    49	EXPORT_SYMBOL(log_cephsan);
    50	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

