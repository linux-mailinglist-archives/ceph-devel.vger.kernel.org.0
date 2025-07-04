Return-Path: <ceph-devel+bounces-3265-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61394AF88E4
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jul 2025 09:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C41D25862BD
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jul 2025 07:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5656927700B;
	Fri,  4 Jul 2025 07:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTM6b8QB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57125274B3A
	for <ceph-devel@vger.kernel.org>; Fri,  4 Jul 2025 07:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751613084; cv=none; b=nBF3zyTb2k70jgXq/8D5EI7hg70hPA7NjGHGWC9b+dO4TnQxxYRSg1aAUWno1p52fBEHEhNHmSEUETRjEYnVjnKiPq/cRNKiU3RTMqlX8U/tAM9l7XxtI9+dQDljyyibIzQqBfAQeoD61FOtaki/bE5zwxn6YZchR2i2y4X/+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751613084; c=relaxed/simple;
	bh=JLw3lD6nl72qK8sYIiCu7tWhO7iIrzgSqUpwkyYJo2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Nn4lYeoTeSGJ5LPFbOEf0E19WHK4prAxvF6zYgP1RnnoxFo2BPeLv3FyjKidKWBE0r1STb9474C+rgZRS2BHmnqYDvVd+kg8FdCHlMyhfNtQcJEO008nP5g2jbr/Agrx01mqOMt49gJfIiNOSHPioQ7cRSoETRASrNYH8QPzeko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTM6b8QB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751613082; x=1783149082;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=JLw3lD6nl72qK8sYIiCu7tWhO7iIrzgSqUpwkyYJo2Q=;
  b=TTM6b8QBPWhKmdsejlPSlpqgNxAC9Uz+OlQtwqycleCD1sQ3nPw7PH97
   tRUviLvBMUfrmTChlA6leEtVTSAwYpmYHvUvZ3XwI86zmlYLVQ+aTD7Bj
   nbWxZF2HMP2coQU17XbDEfVhFrlhhWZt6K4wb/XQtFJGNNkh4wCXntBZE
   ZO4+64+2R1ILXC12rNizSNhC0itwyGoSQjDsuWPY1VStoptL2nYZ7VFug
   tTqqELB3zT/Xo1loWu/bwNxjqcVOuT8TmZzdoNiAG824wQrP2Wd1cHvPJ
   IQeCLl/2sVykN1OQQP3CbuxJcZIB05KUDachcwXolYVo6CulqEDMwTte5
   g==;
X-CSE-ConnectionGUID: +35Oam3vTZe8dYjlZrnl9w==
X-CSE-MsgGUID: Z+v3X/OMQnCOdWcznq6UMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79384090"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79384090"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 00:11:22 -0700
X-CSE-ConnectionGUID: fgUKOvMpSCaitICZ8jnDOQ==
X-CSE-MsgGUID: yyfXVpgDRT+o/OXQBkT1NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="159124484"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 04 Jul 2025 00:11:20 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uXaZp-0003Qx-2M;
	Fri, 04 Jul 2025 07:11:17 +0000
Date: Fri, 4 Jul 2025 15:10:49 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:binary_tracing 2/4]
 include/linux/ceph/ceph_san_ser.h:116:19: error: static assertion failed due
 to requirement 'sizeof (null_str.str) == sizeof(unsigned long)':
 null_str.str size must match unsigned long for proper alignment
Message-ID: <202507041548.xbrz4aTf-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git binary_tracing
head:   242b3aa593381c5ed2f425dbfb145bf7ca42e1fc
commit: 8a1cb95e58001067ea33908f1762ca31d6f93b69 [2/4] ceph_san code
config: arm-randconfig-r071-20250704 (https://download.01.org/0day-ci/archive/20250704/202507041548.xbrz4aTf-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project 61529d9e36fa86782a2458e6bdeedf7f376ef4b5)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250704/202507041548.xbrz4aTf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507041548.xbrz4aTf-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from net/ceph/ceph_common.c:3:
   In file included from include/linux/ceph/ceph_debug.h:9:
   In file included from include/linux/ceph/ceph_san_logger.h:10:
>> include/linux/ceph/ceph_san_ser.h:116:19: error: static assertion failed due to requirement 'sizeof (null_str.str) == sizeof(unsigned long)': null_str.str size must match unsigned long for proper alignment
     116 |     static_assert(sizeof(null_str.str) == sizeof(unsigned long),
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                                  ^~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/ceph/ceph_san_ser.h:116:40: note: expression evaluates to '8 == 4'
     116 |     static_assert(sizeof(null_str.str) == sizeof(unsigned long),
         |                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                                  ^~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   1 error generated.
--
   In file included from net/ceph/ceph_san_logger.c:17:
   In file included from include/linux/ceph/ceph_san_logger.h:10:
>> include/linux/ceph/ceph_san_ser.h:116:19: error: static assertion failed due to requirement 'sizeof (null_str.str) == sizeof(unsigned long)': null_str.str size must match unsigned long for proper alignment
     116 |     static_assert(sizeof(null_str.str) == sizeof(unsigned long),
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                                  ^~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/ceph/ceph_san_ser.h:116:40: note: expression evaluates to '8 == 4'
     116 |     static_assert(sizeof(null_str.str) == sizeof(unsigned long),
         |                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                                  ^~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
>> net/ceph/ceph_san_logger.c:866:67: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     865 |             pr_debug("reconstruct: writing %s string '%s' (len=%zu) at out_offset=%ld\n",
         |                                                                                   ~~~
         |                                                                                   %d
     866 |                    type ? "pointer" : "inline", str, strlen(str), in_buffer - entry->buffer);
         |                                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:637:38: note: expanded from macro 'pr_debug'
     637 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                                     ~~~     ^~~~~~~~~~~
   include/linux/printk.h:135:18: note: expanded from macro 'no_printk'
     135 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ~~~    ^~~~~~~~~~~
   net/ceph/ceph_san_logger.c:877:25: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     876 |             pr_debug("reconstruct: reading int %d at in_offset=%ld\n",
         |                                                                ~~~
         |                                                                %d
     877 |                    val, in_buffer - entry->buffer);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:637:38: note: expanded from macro 'pr_debug'
     637 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                                     ~~~     ^~~~~~~~~~~
   include/linux/printk.h:135:18: note: expanded from macro 'no_printk'
     135 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ~~~    ^~~~~~~~~~~
   net/ceph/ceph_san_logger.c:892:25: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     891 |             pr_debug("reconstruct: reading int %u at in_offset=%ld\n",
         |                                                                ~~~
         |                                                                %d
     892 |                    val, in_buffer - entry->buffer);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:637:38: note: expanded from macro 'pr_debug'
     637 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                                     ~~~     ^~~~~~~~~~~
   include/linux/printk.h:135:18: note: expanded from macro 'no_printk'
     135 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ~~~    ^~~~~~~~~~~
   net/ceph/ceph_san_logger.c:907:25: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     906 |             pr_debug("reconstruct: reading int %u at in_offset=%ld\n",
         |                                                                ~~~
         |                                                                %d
     907 |                    val, in_buffer - entry->buffer);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:637:38: note: expanded from macro 'pr_debug'
     637 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                                     ~~~     ^~~~~~~~~~~
   include/linux/printk.h:135:18: note: expanded from macro 'no_printk'
     135 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ~~~    ^~~~~~~~~~~
   net/ceph/ceph_san_logger.c:922:45: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     921 |             pr_debug("reconstruct: reading pointer %llx at in_offset=%ld\n",
         |                                                                      ~~~
         |                                                                      %d
     922 |                    (unsigned long long)val, in_buffer - entry->buffer);
         |                                             ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:637:38: note: expanded from macro 'pr_debug'
     637 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                                     ~~~     ^~~~~~~~~~~
   include/linux/printk.h:135:18: note: expanded from macro 'no_printk'
     135 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ~~~    ^~~~~~~~~~~
   net/ceph/ceph_san_logger.c:937:30: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     936 |             pr_debug("reconstruct: reading int %u (octal: %o) at in_offset=%ld\n",
         |                                                                            ~~~
         |                                                                            %d
     937 |                    val, val, in_buffer - entry->buffer);
         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:637:38: note: expanded from macro 'pr_debug'
     637 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                                     ~~~     ^~~~~~~~~~~
   include/linux/printk.h:135:18: note: expanded from macro 'no_printk'
     135 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ~~~    ^~~~~~~~~~~
   net/ceph/ceph_san_logger.c:956:33: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     955 |                     pr_debug("reconstruct: reading long long %lld at in_offset=%ld\n",
         |                                                                                ~~~
         |                                                                                %d
     956 |                            val, in_buffer - entry->buffer);
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:637:38: note: expanded from macro 'pr_debug'
     637 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                                     ~~~     ^~~~~~~~~~~
   include/linux/printk.h:135:18: note: expanded from macro 'no_printk'
     135 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ~~~    ^~~~~~~~~~~
   net/ceph/ceph_san_logger.c:962:33: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     961 |                     pr_debug("reconstruct: reading long long %llu at in_offset=%ld\n",
         |                                                                                ~~~
         |                                                                                %d
     962 |                            val, in_buffer - entry->buffer);
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:637:38: note: expanded from macro 'pr_debug'
     637 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                                     ~~~     ^~~~~~~~~~~
   include/linux/printk.h:135:18: note: expanded from macro 'no_printk'
     135 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ~~~    ^~~~~~~~~~~
   net/ceph/ceph_san_logger.c:968:33: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
     967 |                     pr_debug("reconstruct: reading long long %llu at in_offset=%ld\n",
         |                                                                                ~~~
         |                                                                                %d
     968 |                            val, in_buffer - entry->buffer);


vim +116 include/linux/ceph/ceph_san_ser.h

   112	
   113	static inline size_t write_null_str(char *dst)
   114	{
   115		*(union null_str_u *)dst = null_str;
 > 116	    static_assert(sizeof(null_str.str) == sizeof(unsigned long),
   117	                 "null_str.str size must match unsigned long for proper alignment");
   118	    return __builtin_strlen(null_str.str);
   119	}
   120	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

