Return-Path: <ceph-devel+bounces-4215-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CB1CD59D1
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Dec 2025 11:36:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5ECA930024B4
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Dec 2025 10:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483F12D8DCA;
	Mon, 22 Dec 2025 10:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b/E12IFs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B519226CE2D
	for <ceph-devel@vger.kernel.org>; Mon, 22 Dec 2025 10:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766399765; cv=none; b=MyG3/SxbGh12PqASa0sGENPTTvxuYGZ0z2cpQfuNqLoKX/I5G56j0LCrZ2BM+csYi6BCIG3ocXaTxj5FhCpsfQ6Kw5zR9VsGVNMeX7DCDuF7CN/5pTzlARuJ+0CyoyDUUck1QqHSulGNOI15KaSj4nDaAHw0NXpMLikF3i7zMTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766399765; c=relaxed/simple;
	bh=Xzd0wqjWz1VIxuTGKbQWvhgmJbwB+JZPD9sdA9lb9I4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=qLeTn1G/H10++AfYtTjD9ZPKpJaafyBuFvObYXxSvM5lqb7QGtfDs6CVxme0w05PUgP2QEZ9hyuIgVlnj4ofHPN8Ji3et/3T4o5hbT8Pc9EwrcMyiP/yKJyUFaoY+x1WztWExSAKQtezmDDFfJf1cA+VUS//ZBIEI47XrqscPIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b/E12IFs; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766399763; x=1797935763;
  h=date:from:to:cc:subject:message-id;
  bh=Xzd0wqjWz1VIxuTGKbQWvhgmJbwB+JZPD9sdA9lb9I4=;
  b=b/E12IFsfSE25yQqwVKYm4S6UWh4HY3BUSDNCI4NAPZi4bvV9WBK1OVJ
   z2lyOA9wqZ+9Gle/lTAUVhr0u5EYHmGndjbHjY3oLjKnvqI39xSODBGzD
   3eO5EGOTvrgZqzHuHyF5DBs5xcXnwdev5kJ98PWny0W1dnfad5PoNq8t+
   Y6IYRNprtr6DZrc9+flN0fxpN8rMxzNDEZrRyFoIHraMF/7P9tCd23Qby
   h0IX1BENt1DqHP/++u2xqj2w6YNFu5RbLQwxVu3ndpRG19CDlYnUxdWIQ
   7doae8G/BxyE134TrDAqetC9yy7wXyrBXbTdIk+N4TXAAEuzy2X8bspm0
   w==;
X-CSE-ConnectionGUID: TtumtTLeQwWJGRyQ4laVbQ==
X-CSE-MsgGUID: Xl29qgAERRmt7wNS+uYzOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="67246355"
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="67246355"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 02:36:02 -0800
X-CSE-ConnectionGUID: qr52KHC6SiSXovgDC9/NAw==
X-CSE-MsgGUID: iIct3sCGQimZBzeh1wFIDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="203621915"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 22 Dec 2025 02:36:00 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXdGg-000000000Oz-0AAK;
	Mon, 22 Dec 2025 10:35:58 +0000
Date: Mon, 22 Dec 2025 18:35:37 +0800
From: kernel test robot <lkp@intel.com>
To: "lamtung-monash" <lam.nguyentung@monash.edu>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 ceph-devel@vger.kernel.org
Subject: [ceph-client:pr/29 1/1]
 arch/powerpc/kvm/../../../virt/kvm/eventfd.c:621:19: error: use of undeclared
 identifier 'KVM_MAX_IRQ_ROUTES'
Message-ID: <202512221816.Ezlo8JqW-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

tree:   https://github.com/ceph/ceph-client.git pr/29
head:   a0479e90ee5778543f7bcaafd85387c2eea73126
commit: a0479e90ee5778543f7bcaafd85387c2eea73126 [1/1] Don't accept obviously wrong gsi values via KVM_IRQFD
config: powerpc-ppc64_defconfig (https://download.01.org/0day-ci/archive/20251222/202512221816.Ezlo8JqW-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 42b3483ac4987cae1bdb632398e8a3ce2dea6633)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251222/202512221816.Ezlo8JqW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512221816.Ezlo8JqW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/powerpc/kvm/../../../virt/kvm/eventfd.c:621:19: error: use of undeclared identifier 'KVM_MAX_IRQ_ROUTES'
     621 |         if (args->gsi >= KVM_MAX_IRQ_ROUTES)
         |                          ^~~~~~~~~~~~~~~~~~
   1 error generated.


vim +/KVM_MAX_IRQ_ROUTES +621 arch/powerpc/kvm/../../../virt/kvm/eventfd.c

   614	
   615	int
   616	kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
   617	{
   618		if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN | KVM_IRQFD_FLAG_RESAMPLE))
   619			return -EINVAL;
   620	
 > 621		if (args->gsi >= KVM_MAX_IRQ_ROUTES)
   622			return -EINVAL;
   623	
   624		if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
   625			return kvm_irqfd_deassign(kvm, args);
   626	
   627		return kvm_irqfd_assign(kvm, args);
   628	}
   629	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

