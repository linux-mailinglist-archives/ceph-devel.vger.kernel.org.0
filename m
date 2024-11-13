Return-Path: <ceph-devel+bounces-2073-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B4A9C6674
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2024 02:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53F901F2563B
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2024 01:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADE7BA34;
	Wed, 13 Nov 2024 01:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UKVbaMHl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9764A2F5A;
	Wed, 13 Nov 2024 01:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731460005; cv=none; b=EcLfVDRgibLchlx2iHWlgnlt+526s/ehYNH8rUTDApJiFTCWF+p+2nJV23pv3ilyPtd9++Z8xLU25uLAqit+7+dxhSnnM6yJJ977SwNt39JacMourmmE5tOIvsPTHeUlkEwTWu23nBYwxROhrj67Nt0Cyij2A1twwhPcugpI6NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731460005; c=relaxed/simple;
	bh=jUOI7YM6MSLcyJwnqrB7V58PYe0qyz24mpLSBFMB2VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZjEdWxjH1WZP70ucnE0mBoXLiwRrp6zeu5pwsZ/qLaRxTudRxJ7TG6PfOQN45i9BeKyFfxcSWTIu1iwbS+VskgA3/aBXyRe5OzW6ClOEXwMGX0pHXpmEZc3mNNyIxrftWY2CR1adoNyB1SSLOZ94glVwI2JXV/RsdU8eBG4RQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UKVbaMHl; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731460003; x=1762996003;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jUOI7YM6MSLcyJwnqrB7V58PYe0qyz24mpLSBFMB2VU=;
  b=UKVbaMHlBXt//1psrCZveNKWcV1SVvJ1QhRZbbOr4mHArrzgoHhNa8Wk
   q8QmadqvS1cLldwMVn9mrC+57SFTZJuj3kCGF/DsuBlihEGsdpR5eVWoR
   trLBybJOWZIUQ0OlGw8nTbkUySqpFwp8vF58BsePA9I2IAABpV9qTw0a4
   aUsIK24B6FH9IKbsCxRQu41tXap/vxzCtp/Xs1N0Mp33AxCQP9u+9vqkz
   +0l044mxJEANvuJCgT4TXdFjjbDQ+et2WgMzf0ZDx+gJRxEaOtIsMWY0+
   w4mbNKgxOq+5BuhNH3c7ShWgA5/q0OeIoQxvzcrlNbDK7K8a70lxaIBZM
   g==;
X-CSE-ConnectionGUID: DlhmXGw3RA+OmvbOj4vJ9A==
X-CSE-MsgGUID: /VQbLNJcTHCRw7fQEd2c7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="30730129"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="30730129"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 17:06:43 -0800
X-CSE-ConnectionGUID: FyxkOQ9zSl+fFiGokKVcwA==
X-CSE-MsgGUID: 9IgAG/SiQpi6Ys4JK01k2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="88119007"
Received: from lkp-server01.sh.intel.com (HELO bcfed0da017c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 12 Nov 2024 17:06:41 -0800
Received: from kbuild by bcfed0da017c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tB1qB-0001u5-0y;
	Wed, 13 Nov 2024 01:06:39 +0000
Date: Wed, 13 Nov 2024 09:06:30 +0800
From: kernel test robot <lkp@intel.com>
To: Abdul Rahim <abdul.rahim@myyahoo.com>, xiubli@redhat.com,
	idryomov@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Abdul Rahim <abdul.rahim@myyahoo.com>
Subject: Re: [PATCH] Use strscpy() instead of strcpy()
Message-ID: <202411130853.c11sinW2-lkp@intel.com>
References: <20241111221037.92853-1-abdul.rahim@myyahoo.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111221037.92853-1-abdul.rahim@myyahoo.com>

Hi Abdul,

kernel test robot noticed the following build errors:

[auto build test ERROR on ceph-client/testing]
[also build test ERROR on ceph-client/for-linus linus/master v6.12-rc7 next-20241112]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Abdul-Rahim/Use-strscpy-instead-of-strcpy/20241112-064257
base:   https://github.com/ceph/ceph-client.git testing
patch link:    https://lore.kernel.org/r/20241111221037.92853-1-abdul.rahim%40myyahoo.com
patch subject: [PATCH] Use strscpy() instead of strcpy()
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20241113/202411130853.c11sinW2-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241113/202411130853.c11sinW2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411130853.c11sinW2-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/bitfield.h:10,
                    from include/linux/fortify-string.h:5,
                    from include/linux/string.h:390,
                    from include/linux/ceph/ceph_debug.h:7,
                    from fs/ceph/export.c:2:
   fs/ceph/export.c: In function '__get_snap_name':
>> include/linux/build_bug.h:16:51: error: negative width in bit-field '<anonymous>'
      16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
         |                                                   ^
   include/linux/compiler.h:243:33: note: in expansion of macro 'BUILD_BUG_ON_ZERO'
     243 | #define __must_be_array(a)      BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
         |                                 ^~~~~~~~~~~~~~~~~
   include/linux/string.h:79:47: note: in expansion of macro '__must_be_array'
      79 |         sized_strscpy(dst, src, sizeof(dst) + __must_be_array(dst) +    \
         |                                               ^~~~~~~~~~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy0'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:113:9: note: in expansion of macro 'CONCATENATE'
     113 |         CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   fs/ceph/export.c:455:25: note: in expansion of macro 'strscpy'
     455 |                         strscpy(name, fsc->mount_options->snapdir_name);
         |                         ^~~~~~~


vim +16 include/linux/build_bug.h

bc6245e5efd70c Ian Abbott       2017-07-10   6  
bc6245e5efd70c Ian Abbott       2017-07-10   7  #ifdef __CHECKER__
bc6245e5efd70c Ian Abbott       2017-07-10   8  #define BUILD_BUG_ON_ZERO(e) (0)
bc6245e5efd70c Ian Abbott       2017-07-10   9  #else /* __CHECKER__ */
bc6245e5efd70c Ian Abbott       2017-07-10  10  /*
bc6245e5efd70c Ian Abbott       2017-07-10  11   * Force a compilation error if condition is true, but also produce a
8788994376d84d Rikard Falkeborn 2019-12-04  12   * result (of value 0 and type int), so the expression can be used
bc6245e5efd70c Ian Abbott       2017-07-10  13   * e.g. in a structure initializer (or where-ever else comma expressions
bc6245e5efd70c Ian Abbott       2017-07-10  14   * aren't permitted).
bc6245e5efd70c Ian Abbott       2017-07-10  15   */
8788994376d84d Rikard Falkeborn 2019-12-04 @16  #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
527edbc18a70e7 Masahiro Yamada  2019-01-03  17  #endif /* __CHECKER__ */
527edbc18a70e7 Masahiro Yamada  2019-01-03  18  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

