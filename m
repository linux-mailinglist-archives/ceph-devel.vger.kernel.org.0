Return-Path: <ceph-devel+bounces-2761-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB21A40CB3
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Feb 2025 05:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D4E617657B
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Feb 2025 04:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D02728399;
	Sun, 23 Feb 2025 04:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xwoe8zfb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF76610C
	for <ceph-devel@vger.kernel.org>; Sun, 23 Feb 2025 04:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740285328; cv=none; b=U86Iwnv7z8o7UNZS44H8jCb8azuAzS4WszWcr5TvjblMPQCNfuROG2EL0Hv0ETqb0d/TCZDWAHTjY+Rd3r7gnHKBJUpr9LHtEDudfJ404+3epHoeDkzxIWP7t95qAQT/QqsVMD8VIC6QNyGO4uDRJ1LP+USoSo6++f2erhbF6Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740285328; c=relaxed/simple;
	bh=1L6cyK5gQtweYCRNuIsW9WWsv43FPEU9XMYoyVHpbA4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TxnhdzuEIz4ha35DmWXCcqNfQEsJOeBdGdNpmqwlW+J6pq7AEXjAyqH1ULa5sjMj5uDLHXM5dZdFtH6kyT+BeRCPan8eXzpyuulimV+zZKh0CPHc9j7y5Mr9ZoXTaEW49JkGlPUVzszpZ5Q4K8KKAxPQtGTB1HerthuXJT5iYdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xwoe8zfb; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740285324; x=1771821324;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=1L6cyK5gQtweYCRNuIsW9WWsv43FPEU9XMYoyVHpbA4=;
  b=Xwoe8zfbZWbePmpkEcKrn6qSNTSVyIh/rEj8ONjos1OnRqBtfunFlACI
   NXwYAMFhOS15LONaVa3T17qJaYdh9DdO4bQGM0o/FQGRtzDOOXeq28bwd
   YMyCxjAxSuOouSTXcNIcLGXyoZP5/CXgxYv7b/r0GAouji1fl/KC0kbwR
   fEBrcKkgT22lTm39NuOF1V+z1Dk7KovaOOLCiH94Z6P0pkXK/iiv5w2si
   oodVR7lrYetm8vekPD7K+SXp4Z7b4OooEMJDKgWI017dnwOkRyhHx7rQJ
   5sx4wqGKT2FysOXZmlrx1f5r3PEcgKEZfXeN42gfmofa/duUeK77N3Z5x
   Q==;
X-CSE-ConnectionGUID: NK8YWzY1TYiagbcHQLRvmw==
X-CSE-MsgGUID: sQSPG47qRau0QK0zoEWKkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11353"; a="28662819"
X-IronPort-AV: E=Sophos;i="6.13,308,1732608000"; 
   d="scan'208";a="28662819"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2025 20:35:24 -0800
X-CSE-ConnectionGUID: 6UfV3AMmQE6t1REMw3d69g==
X-CSE-MsgGUID: 8BPUZS6cQJ6hkufUeciVLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,308,1732608000"; 
   d="scan'208";a="138960204"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 22 Feb 2025 20:35:22 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tm3i3-000785-1V;
	Sun, 23 Feb 2025 04:35:19 +0000
Date: Sun, 23 Feb 2025 12:35:16 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 8/15] net/ceph/ceph_san.c:39:72: error:
 invalid application of 'sizeof' to an incomplete type 'struct
 ceph_san_log_entry'
Message-ID: <202502231205.FMTqBemE-lkp@intel.com>
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
commit: f820734471f23bb695f77190c893468887acb9a5 [8/15] ceph_san: use alloc_pages
config: hexagon-randconfig-r072-20250223 (https://download.01.org/0day-ci/archive/20250223/202502231205.FMTqBemE-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project 204dcafec0ecf0db81d420d2de57b02ada6b09ec)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250223/202502231205.FMTqBemE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502231205.FMTqBemE-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/ceph/ceph_san.c:18:39: error: arithmetic on a pointer to an incomplete type 'typeof (ceph_san_tls)' (aka 'struct ceph_san_tls_logger')
      18 |     struct ceph_san_tls_logger *tls = this_cpu_ptr(&ceph_san_tls);
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
   net/ceph/ceph_san.c:19:23: error: incomplete definition of type 'struct ceph_san_tls_logger'
      19 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |                    ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:19:39: error: use of undeclared identifier 'CEPH_SAN_MAX_LOGS'
      19 |     int head_idx = tls->head_idx++ & (CEPH_SAN_MAX_LOGS - 1);
         |                                       ^
   net/ceph/ceph_san.c:20:8: error: incomplete definition of type 'struct ceph_san_tls_logger'
      20 |     tls->logs[head_idx].pid = current->pid;
         |     ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:21:8: error: incomplete definition of type 'struct ceph_san_tls_logger'
      21 |     tls->logs[head_idx].ts = jiffies;
         |     ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:22:15: error: incomplete definition of type 'struct ceph_san_tls_logger'
      22 |     memcpy(tls->logs[head_idx].comm, current->comm, TASK_COMM_LEN);
         |            ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:24:15: error: incomplete definition of type 'struct ceph_san_tls_logger'
      24 |     return tls->logs[head_idx].buf;
         |            ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:16:7: warning: no previous prototype for function 'get_log_cephsan' [-Wmissing-prototypes]
      16 | char *get_log_cephsan(void) {
         |       ^
   net/ceph/ceph_san.c:16:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      16 | char *get_log_cephsan(void) {
         | ^
         | static 
   net/ceph/ceph_san.c:31:6: error: redefinition of 'cephsan_cleanup'
      31 | void cephsan_cleanup(void)
         |      ^
   include/linux/ceph/ceph_san.h:105:20: note: previous definition is here
     105 | static inline void cephsan_cleanup(void) {}
         |                    ^
   net/ceph/ceph_san.c:37:9: error: arithmetic on a pointer to an incomplete type 'typeof (ceph_san_tls)' (aka 'struct ceph_san_tls_logger')
      37 |                 tls = per_cpu_ptr(&ceph_san_tls, cpu);
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:237:2: note: expanded from macro 'per_cpu_ptr'
     237 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:219:52: note: expanded from macro '__verify_pcpu_ptr'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                     ~~~~~ ^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:38:10: error: incomplete definition of type 'struct ceph_san_tls_logger'
      38 |                 if (tls->pages) {
         |                     ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:39:33: error: incomplete definition of type 'struct ceph_san_tls_logger'
      39 |                         free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                   ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
>> net/ceph/ceph_san.c:39:72: error: invalid application of 'sizeof' to an incomplete type 'struct ceph_san_log_entry'
      39 |                         free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                                             ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/ceph/ceph_san.c:39:86: note: forward declaration of 'struct ceph_san_log_entry'
      39 |                         free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                                                           ^
   net/ceph/ceph_san.c:39:52: error: use of undeclared identifier 'CEPH_SAN_MAX_LOGS'
      39 |                         free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                         ^
   net/ceph/ceph_san.c:40:7: error: incomplete definition of type 'struct ceph_san_tls_logger'
      40 |                         tls->pages = NULL;
         |                         ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:48:5: error: redefinition of 'cephsan_init'
      48 | int cephsan_init(void)
         |     ^
   include/linux/ceph/ceph_san.h:106:26: note: previous definition is here
     106 | static inline int __init cephsan_init(void) { return 0; }
         |                          ^
   net/ceph/ceph_san.c:54:9: error: arithmetic on a pointer to an incomplete type 'typeof (ceph_san_tls)' (aka 'struct ceph_san_tls_logger')
      54 |                 tls = per_cpu_ptr(&ceph_san_tls, cpu);
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:237:2: note: expanded from macro 'per_cpu_ptr'
     237 |         __verify_pcpu_ptr(ptr);                                         \
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:219:52: note: expanded from macro '__verify_pcpu_ptr'
     219 |         const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;    \
         |                                                     ~~~~~ ^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:55:6: error: incomplete definition of type 'struct ceph_san_tls_logger'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                 ~~~^
   include/linux/ceph/ceph_san.h:10:24: note: forward declaration of 'struct ceph_san_tls_logger'
      10 | DECLARE_PER_CPU(struct ceph_san_tls_logger, ceph_san_tls);
         |                        ^
   net/ceph/ceph_san.c:55:70: error: invalid application of 'sizeof' to an incomplete type 'struct ceph_san_log_entry'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                                    ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/gfp.h:333:59: note: expanded from macro 'alloc_pages'
     333 | #define alloc_pages(...)                        alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
         |                                                                                ^~~~~~~~~~~
   include/linux/alloc_tag.h:236:31: note: expanded from macro 'alloc_hooks'
     236 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |                                      ^~~~~~~~~
   include/linux/alloc_tag.h:228:9: note: expanded from macro 'alloc_hooks_tag'
     228 |         typeof(_do_alloc) _res = _do_alloc;                             \
         |                ^~~~~~~~~
   net/ceph/ceph_san.c:55:84: note: forward declaration of 'struct ceph_san_log_entry'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                                                  ^
   net/ceph/ceph_san.c:55:50: error: use of undeclared identifier 'CEPH_SAN_MAX_LOGS'
      55 |                 tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
         |                                                                ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   1 warning and 20 errors generated.


vim +39 net/ceph/ceph_san.c

    27	
    28	/* Cleanup function to free all TLS logger objects.
    29	 * Call this at module exit to free allocated TLS loggers.
    30	 */
    31	void cephsan_cleanup(void)
    32	{
    33		int cpu;
    34		struct ceph_san_tls_logger *tls;
    35	
    36		for_each_possible_cpu(cpu) {
    37			tls = per_cpu_ptr(&ceph_san_tls, cpu);
    38			if (tls->pages) {
  > 39				free_pages((unsigned long)tls->pages, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
    40				tls->pages = NULL;
    41			}
    42		}
    43	}
    44	EXPORT_SYMBOL(cephsan_cleanup);
    45	/* Initialize the Ceph SAN logging infrastructure.
    46	 * Call this at module init to set up the global list and lock.
    47	 */
    48	int cephsan_init(void)
    49	{
    50		int cpu;
    51		struct ceph_san_tls_logger *tls;
    52	
    53		for_each_possible_cpu(cpu) {
    54			tls = per_cpu_ptr(&ceph_san_tls, cpu);
    55			tls->pages = alloc_pages(GFP_KERNEL, get_order(CEPH_SAN_MAX_LOGS * sizeof(struct ceph_san_log_entry)));
    56			if (!tls->pages) {
    57				pr_err("Failed to allocate TLS logs for CPU %d\n", cpu);
    58				return -ENOMEM;
    59			}
    60			tls->logs = (struct ceph_san_log_entry *)page_address(tls->pages);
    61		}
    62		return 0;
    63	}
    64	EXPORT_SYMBOL(cephsan_init);
    65	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

