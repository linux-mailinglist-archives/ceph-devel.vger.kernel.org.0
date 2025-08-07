Return-Path: <ceph-devel+bounces-3359-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 63704B1D69B
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Aug 2025 13:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 646DD7AB27A
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Aug 2025 11:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8E2278161;
	Thu,  7 Aug 2025 11:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EF/V5Dp+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65F9277C9B;
	Thu,  7 Aug 2025 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754565923; cv=none; b=aHnjbMNyto587fui9UL5ZVmjqEikyNYLNLGmNuOCIn5DlGsZ9lyKWbbc9APeBVAlLBA06iKSi2LKdHSa1kQ6msROkjhgAbEBYcrmzv59we7pNGeCHzjl5pj9TLBhyQekISfBysj/qykP46KBJUSjtUt/IRbplM/TX3OUuTYlVHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754565923; c=relaxed/simple;
	bh=nf1Uz/64Xk7Uq7Ha4ydJ+I/gpEixPS0OjNVi7zKfnbE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Im2RR1d6XZBeohyJJgpubVf6rb0sj7DATtIYAa5PUCdBANUqt2ATQDOwwvnIeSbROcw9oPInxyDG941GZOqO9BDn9QYO6mkPAK22uYogfsntjQBqKu19nTwANKuFZgAV0F1HUaU78oMTHk/y2cNGq5RLLAOcsW1oCHLLN5UwM9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EF/V5Dp+; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754565921; x=1786101921;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=nf1Uz/64Xk7Uq7Ha4ydJ+I/gpEixPS0OjNVi7zKfnbE=;
  b=EF/V5Dp+CmHRzGTULRjUnz0mq2pxAmWjepBWy0Y+sL7KgqVajjgvEO64
   SUwvGc0/PNFI0X1jBrJTDDDvDQiQPbImXMDONDRnYSt3IpH056OU/Z4Zz
   3hzTucNYW6ZmL9XCO0x5W0d4tBBYFGL9wAfZZclYDPsoakeTQtfgv2Ji2
   6jR6Fwm5tg9HllF2hosMkTs9ex1FnNnwfnTAmlwtzU5CR1FZyrchWxrFx
   tNvl/LqZbaWuN18KGEY/KO3K1aEGu0g+m7xwgaequyehfmDtqVpia4TnR
   b5z0qry8BZVsjATZOm8JDcTzyudA5CNHG5NvMff6nDlNjErpWv1kVmzRe
   g==;
X-CSE-ConnectionGUID: EiphjtueTWi1SuSjWB/0VA==
X-CSE-MsgGUID: tkQiYBkwRy+4XWZdRRU8MA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="82343250"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="82343250"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 04:25:20 -0700
X-CSE-ConnectionGUID: dzliR5lhQsu/jdTiLvSQ2w==
X-CSE-MsgGUID: kQ2ZwGZQRsWAVVRVI3eYRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="196023491"
Received: from igk-lkp-server01.igk.intel.com (HELO b3b7d4258b7c) ([10.91.175.65])
  by orviesa002.jf.intel.com with ESMTP; 07 Aug 2025 04:25:19 -0700
Received: from kbuild by b3b7d4258b7c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujykG-0002RL-1E;
	Thu, 07 Aug 2025 11:25:16 +0000
Date: Thu, 7 Aug 2025 13:24:56 +0200
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [ceph-client:tls-tracing-only 14/14] htmldocs: Warning:
 Documentation/binary-logging/rtlog-api-reference.rst references a file that
 doesn't exist: Documentation/trace/rtlog.rst
Message-ID: <202508071322.vUnGCohg-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls-tracing-only
head:   ffad14ce035a047cbfda2d38f7ae37b0767de136
commit: ffad14ce035a047cbfda2d38f7ae37b0767de136 [14/14] Documentation
reproduce: (https://download.01.org/0day-ci/archive/20250807/202508071322.vUnGCohg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508071322.vUnGCohg-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Documentation/userspace-api/netlink/netlink-raw.rst: :doc:`rt_link<../../networking/netlink_spec/rt_link>`
   Documentation/userspace-api/netlink/netlink-raw.rst: :doc:`tc<../../networking/netlink_spec/tc>`
   Documentation/userspace-api/netlink/netlink-raw.rst: :doc:`tc<../../networking/netlink_spec/tc>`
>> Warning: Documentation/binary-logging/rtlog-api-reference.rst references a file that doesn't exist: Documentation/trace/rtlog.rst
>> Warning: Documentation/binary-logging/rtlog-api-reference.rst references a file that doesn't exist: Documentation/trace/rtlog-developer-guide.rst
>> Warning: Documentation/binary-logging/rtlog-api-reference.rst references a file that doesn't exist: Documentation/trace/rtlog-examples.rst
>> Warning: Documentation/binary-logging/rtlog-api-reference.rst references a file that doesn't exist: Documentation/trace/rtlog-performance.rst
>> Warning: Documentation/binary-logging/rtlog-developer-guide.rst references a file that doesn't exist: Documentation/trace/rtlog.rst
>> Warning: Documentation/binary-logging/rtlog-examples.rst references a file that doesn't exist: Documentation/trace/rtlog.rst
>> Warning: Documentation/binary-logging/rtlog-examples.rst references a file that doesn't exist: Documentation/trace/rtlog-developer-guide.rst
>> Warning: Documentation/binary-logging/rtlog-performance.rst references a file that doesn't exist: Documentation/trace/rtlog.rst
>> Warning: Documentation/binary-logging/rtlog-performance.rst references a file that doesn't exist: Documentation/trace/rtlog-developer-guide.rst
   Warning: Documentation/devicetree/bindings/regulator/siliconmitus,sm5703-regulator.yaml references a file that doesn't exist: Documentation/devicetree/bindings/mfd/siliconmitus,sm5703.yaml
   Warning: Documentation/hwmon/g762.rst references a file that doesn't exist: Documentation/devicetree/bindings/hwmon/g762.txt
   Warning: Documentation/translations/ja_JP/SubmittingPatches references a file that doesn't exist: linux-2.6.12-vanilla/Documentation/dontdiff
   Warning: Documentation/translations/ja_JP/process/submit-checklist.rst references a file that doesn't exist: Documentation/translations/ja_JP/SubmitChecklist
   Warning: Documentation/translations/zh_CN/admin-guide/README.rst references a file that doesn't exist: Documentation/dev-tools/kgdb.rst

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

