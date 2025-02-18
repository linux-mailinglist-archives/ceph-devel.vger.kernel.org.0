Return-Path: <ceph-devel+bounces-2713-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA32A39027
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2025 02:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C9E21891769
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2025 01:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8829D250F8;
	Tue, 18 Feb 2025 01:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n0ig7njm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E3D6A8D2
	for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2025 01:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739840878; cv=none; b=I44b3L5KqUbAZlJRPgbO3+uWc9hSFvtss9Z4i7magF0jGPTjNlhlUyUlCvKNIgdK5yZ6/ipj0JtBMuNhsNqnzgQ5+BemnYVwRmL97v8hF/XhPshIWNS4p42420shA3WWh8/LOzXVSmxv7gy7rKHKC8puCR29cLhZFPBNy69VaMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739840878; c=relaxed/simple;
	bh=GJHX0ckvYWbkaFJDLq14nAGpEZxYZUshURwjLG5Fw00=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I+NBI/WmOUN/nFQChhbKSGjCRIpgAeBNgPkKSfqgOjA4TmtNGFP5sEVx3JrGmGBvzWKBsI/r05urN+0jomYOiNhuF9EsLVr6MGGgNMWPbl7zSG5ek4yiCTD0vxRJfKgDMPlAg0lDWwNkYXoSsTpOsmZwUXnkhn4QQG3HDGnxrh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n0ig7njm; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739840876; x=1771376876;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=GJHX0ckvYWbkaFJDLq14nAGpEZxYZUshURwjLG5Fw00=;
  b=n0ig7njmG0zzN4h2fRELWybXzD1roHVJ95yWrvS0kPmbmENWR5qc54e3
   rE5Oeb9t/GXf7O0dVq1Z1n2dhihh1vQvgCX4h1lz9mUTTbM6PUe0KzcD7
   dN67Zm/sNh9HLgwTaMp66PDzdwcLXkR59N9HCJ1Yg8bMSkb4GVE59nvKq
   OUf6cl3AXcT9n1VWtUnpZZ4weRJNDe44YSXOTZxADrH0LfdywkhR1Nyej
   rfgixQfyNy6fkXQTv+sia9+QA9XeauOgIn5e57SXDCa9lMx9ia2Agc2rV
   DEPbzLit8ZIsSYBzVsKsATQYBhLWojIKJWmYKFVazk0jQly809J37itaI
   A==;
X-CSE-ConnectionGUID: 2S5/ly+SR7+gTWL11e2Uow==
X-CSE-MsgGUID: k/PACQ9ARMOLJlF0KuIGzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="51144271"
X-IronPort-AV: E=Sophos;i="6.13,294,1732608000"; 
   d="scan'208";a="51144271"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 17:07:55 -0800
X-CSE-ConnectionGUID: SpbA4+YvSB6H1j8ZGMK7+w==
X-CSE-MsgGUID: ZYLew98uQUO8TIQQSyI8LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,294,1732608000"; 
   d="scan'208";a="114757673"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 17 Feb 2025 17:07:55 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tkC5Y-001DlD-2K;
	Tue, 18 Feb 2025 01:07:52 +0000
Date: Tue, 18 Feb 2025 09:07:14 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 13/15] net/ceph/ceph_san.c:25 log_cephsan()
 warn: inconsistent indenting
Message-ID: <202502180801.2Fu8xFiD-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   6426787926c0ab3f8cd024b9cac8bd0fd28813a4
commit: cd1e899feeb6a7da55cbb74b9245c8bbb77f82ba [13/15] cephsun: using a dynamic buffer allocation
config: csky-randconfig-r072-20250217 (https://download.01.org/0day-ci/archive/20250218/202502180801.2Fu8xFiD-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 14.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502180801.2Fu8xFiD-lkp@intel.com/

New smatch warnings:
net/ceph/ceph_san.c:25 log_cephsan() warn: inconsistent indenting

Old smatch warnings:
net/ceph/ceph_san.c:28 log_cephsan() warn: inconsistent indenting
net/ceph/ceph_san.c:33 log_cephsan() warn: inconsistent indenting
net/ceph/ceph_san.c:39 log_cephsan() warn: inconsistent indenting

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

