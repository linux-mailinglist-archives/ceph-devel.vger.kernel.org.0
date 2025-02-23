Return-Path: <ceph-devel+bounces-2760-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E980A40C8D
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Feb 2025 03:28:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF3C8189F4B9
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Feb 2025 02:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B5C134AB;
	Sun, 23 Feb 2025 02:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UMLETFGb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CF44C6C
	for <ceph-devel@vger.kernel.org>; Sun, 23 Feb 2025 02:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740277707; cv=none; b=ks9y1rP4djAOiwsUDnUmzY3JTc21q0/GsyPO14VHDFu+bN8EiDY11u8nLe2bgfDccuC/CwhtlxhjlFw+NCOEJAvQAeHCQPpSGre7SyzTbF72s9IPpgiHCEOO26T8OxfSbk56xOU9axgVtG91DsEPKqGirXfF2U/5QC6TEGkYATU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740277707; c=relaxed/simple;
	bh=x/CR03mTkP5EtUPDfTNB3fFI3VRJEdRXAhwh4iPpP8k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=D14vmwTQPcpDrYVtOHRRP4XCzTCmjErPWsZgn/VdjwZj4YnHz6Vtylqhdww0HG5ZLdCUVtPr6m/9f3zuTaZirT/U5T5CNchrceTz6ThiTuDHC8p7pBV0K0Qz54qFPpl0rgS3X5vMK9la7+7+QnWfU1M+e/qGHsNljeYZa0aVUw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UMLETFGb; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740277706; x=1771813706;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=x/CR03mTkP5EtUPDfTNB3fFI3VRJEdRXAhwh4iPpP8k=;
  b=UMLETFGbVapCIhLn2bKv+o5bssXY/GwSSBBK+UFLcJkJYICjADL/UVdT
   yeLRfw0NnFLYeIT2Lj+OU4X1XcUd39MU4F7QwITcqmsKS6I3LlfkhFq7h
   8QaMXi3RAwCDbKSYwIQqOr6cTnyVcRbolJRXg9nZkSAeECWaPz/SWdHpm
   DOC9K8UU4n6Xr3SrmcK7+gnaG/4L14aojZFsdzvXZzx19q8nWI37980SY
   rXvldtuP2kwwIYkgLnyyDNU2rAhpBuqTlaB+MlUhpsNlzT5oSF/LBjsWH
   pr+89qUtMVf8/eqo3ahId19Xrdao8bqEJ2ucacbJeA8jwY9xnSnOoCUJz
   Q==;
X-CSE-ConnectionGUID: 9wYHhckZRS6lN0TcMVQ20A==
X-CSE-MsgGUID: pbA45239TNWsBJncxKneDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52490044"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52490044"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2025 18:28:25 -0800
X-CSE-ConnectionGUID: RkYzh4Z1SXOLp24qFyhEjw==
X-CSE-MsgGUID: LJjMzJ8WSrauWSY5PgcHHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119842391"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 22 Feb 2025 18:28:24 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tm1jB-000749-2n;
	Sun, 23 Feb 2025 02:28:21 +0000
Date: Sun, 23 Feb 2025 10:27:47 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 6/15] net/ceph/ceph_san.c:17:39: error:
 arithmetic on a pointer to an incomplete type 'typeof (ceph_san_tls)' (aka
 'struct ceph_san_tls_logger')
Message-ID: <202502231007.WIrsl6gW-lkp@intel.com>
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
commit: 485747e7711ebb9bcda819027564d587d215874a [6/15] ceph_san: moving to per_cpu
config: hexagon-randconfig-r072-20250223 (https://download.01.org/0day-ci/archive/20250223/202502231007.WIrsl6gW-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project 204dcafec0ecf0db81d420d2de57b02ada6b09ec)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250223/202502231007.WIrsl6gW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502231007.WIrsl6gW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/ceph/ceph_san.c:17:39: error: arithmetic on a pointer to an incomplete type 'typeof (ceph_san_tls)' (aka 'struct ceph_san_tls_logger')
      17 |     struct ceph_san_tls_logger *tls = this_cpu_ptr(&ceph_san_tls);
         |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:254:27: note: expanded from macro 'this_cpu_ptr'
     254 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
         |                           ^~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:243:2: note: expanded from macro 'raw_cpu_ptr'
     243 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:219:52: note: expanded from macro '__verify_pcpu_ptr'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                     ~~~~~ ^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
>> net/ceph/ceph_san.c:18:23: error: incomplete definition of type 'struct ceph_san_tls_logger'
      18 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |                    ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
>> net/ceph/ceph_san.c:18:39: error: use of undeclared identifier 'CEPH_SAN_MAX_LOGS'
      18 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |                                       ^
   net/ceph/ceph_san.c:19:8: error: incomplete definition of type 'struct ceph_san_tls_logger'
      19 |     tls->logs[head_idx].pid = current->pid;
         |     ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:20:8: error: incomplete definition of type 'struct ceph_san_tls_logger'
      20 |     tls->logs[head_idx].ts = jiffies;
         |     ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:21:15: error: incomplete definition of type 'struct ceph_san_tls_logger'
      21 |     memcpy(tls->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
         |            ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:23:15: error: incomplete definition of type 'struct ceph_san_tls_logger'
      23 |     return tls->logs[head_idx].buf;
         |            ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:15:7: warning: no previous prototype for function 'get_log_cephsan' [-Wmissing-prototypes]
      15 | char *get_log_cephsan(void) {
         |       ^
   net/ceph/ceph_san.c:15:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      15 | char *get_log_cephsan(void) {
         | ^
         | static 
   net/ceph/ceph_san.c:30:6: error: redefinition of 'cephsan_cleanup'
      30 | void cephsan_cleanup(void)
         |      ^
   include/linux/ceph/ceph_san.h:104:20: note: previous definition is here
     104 | static inline void cephsan_cleanup(void) {}
         |                    ^
   net/ceph/ceph_san.c:37:5: error: redefinition of 'cephsan_init'
      37 | int cephsan_init(void)
         |     ^
   include/linux/ceph/ceph_san.h:105:26: note: previous definition is here
     105 | static inline int __init cephsan_init(void) { return 0; }
         |                          ^
   net/ceph/ceph_san.c:9:44: error: tentative definition has type 'typeof(struct ceph_san_tls_logger)' (aka 'struct ceph_san_tls_logger') that is never completed
       9 | DEFINE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                                            ^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   1 warning and 10 errors generated.


vim +17 net/ceph/ceph_san.c

     7	
     8	/* Use per-core TLS logger; no global list or lock needed */
     9	DEFINE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
    10	EXPORT_SYMBOL(ceph_san_tls);
    11	/* The definitions for struct ceph_san_log_entry and struct ceph_san_tls_logger
    12	 * have been moved to cephsan.h (under CONFIG_DEBUG_FS) to avoid duplication.
    13	 */
    14	
    15	char *get_log_cephsan(void) {
    16	    /* Use the per-core TLS logger */
  > 17	    struct ceph_san_tls_logger *tls = this_cpu_ptr(&ceph_san_tls);
  > 18	    int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
    19	    tls->logs[head_idx].pid = current->pid;
    20	    tls->logs[head_idx].ts = jiffies;
    21	    memcpy(tls->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
    22	
    23	    return tls->logs[head_idx].buf;
    24	}
    25	EXPORT_SYMBOL(get_log_cephsan);
    26	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

