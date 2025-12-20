Return-Path: <ceph-devel+bounces-4214-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2D6CD36C6
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 21:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 895F43001611
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 20:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D96F2FE584;
	Sat, 20 Dec 2025 20:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MQQ9+q7Y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E246310627
	for <ceph-devel@vger.kernel.org>; Sat, 20 Dec 2025 20:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766263427; cv=none; b=KgrQP1PzEj6xzpglISoZ3Uyumhp/dSR22d3VyALQHCiAvs1WtLNv7FdwG0uQfV9qQ3vWxu6SqlCSB4whB3p5Dqt3b8xyx5/DuiuxLoftsFOsKe/N2+4JEWuzqePN6BwrqvxxugtWB0SaznzTWFITdntIShCUkb+2HSKMVAaS+qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766263427; c=relaxed/simple;
	bh=XDCK+uO8ImkcGZB9c1/m2PCmuqB+JyCSrfTUtVVbdJo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Q/290tJ8oyJmCpsquTJRx1tbXBgdfFaLN6l0kbm5JOq/TYO8qyLFBNUjA+UfJmKahww2vWbX59zFFf9Kpm1csAMpuqaYbt/0asaeJyz2opxAPZNDcrDasl9NssMPY0WwwgosyYwVdWBklwrIDZkPHkbIYrQeF5uOrJB5G3sb3CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MQQ9+q7Y; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766263426; x=1797799426;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=XDCK+uO8ImkcGZB9c1/m2PCmuqB+JyCSrfTUtVVbdJo=;
  b=MQQ9+q7YgeQzp/UHrrZ/Zy2o6v060brNop5jDo5JPMzodrbJKu7zfelj
   UhlzI4ia7vhyYbaikrfenhqHmHqbk1ksMF1RWB/a64iSgta1SHuC8Ce7U
   3z3DtFFk7WmUqfjm250Yd+Lek4p//WZLlWRmeyeEDLov8e5oSnqh75BKU
   iDmwTOnDXVDk3GcvRQ6pTXhnO3+qw7BJ1dCV3bjdkDbK8Olx6XO9q5JLW
   gTlN6KwrZV8InXxDdzL8vaoVw4I1CKczmXJQOnmg0ojx8+N+XWhS+E9fJ
   JCg3seuaoHD82zqYAwr/OsMO5P1FWCzCFFIt9Is1ZL2nDE8qIyH0XBgv7
   A==;
X-CSE-ConnectionGUID: HYJRV2L+RpmKrQiMD7foSw==
X-CSE-MsgGUID: dfDTc9kdTHqfZKh/fibArg==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="85601321"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="85601321"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 12:43:46 -0800
X-CSE-ConnectionGUID: j2ygyByPS0qC4L+cquTVCg==
X-CSE-MsgGUID: cOSWewgNQMeEHjS277EXlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="198914774"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 20 Dec 2025 12:43:44 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vX3nh-0000000057V-2FBK;
	Sat, 20 Dec 2025 20:43:41 +0000
Date: Sun, 21 Dec 2025 04:43:21 +0800
From: kernel test robot <lkp@intel.com>
To: lamtung-monash <lam.nguyentung@monash.edu>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:pr/29 1/1]
 arch/powerpc/kvm/../../../virt/kvm/eventfd.c:621:26: error:
 'KVM_MAX_IRQ_ROUTES' undeclared; did you mean 'KVM_CAP_IRQ_ROUTING'?
Message-ID: <202512210455.ARaCp1h0-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git pr/29
head:   a0479e90ee5778543f7bcaafd85387c2eea73126
commit: a0479e90ee5778543f7bcaafd85387c2eea73126 [1/1] Don't accept obviously wrong gsi values via KVM_IRQFD
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20251221/202512210455.ARaCp1h0-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512210455.ARaCp1h0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512210455.ARaCp1h0-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/powerpc/kvm/../../../virt/kvm/eventfd.c: In function 'kvm_irqfd':
>> arch/powerpc/kvm/../../../virt/kvm/eventfd.c:621:26: error: 'KVM_MAX_IRQ_ROUTES' undeclared (first use in this function); did you mean 'KVM_CAP_IRQ_ROUTING'?
     621 |         if (args->gsi >= KVM_MAX_IRQ_ROUTES)
         |                          ^~~~~~~~~~~~~~~~~~
         |                          KVM_CAP_IRQ_ROUTING
   arch/powerpc/kvm/../../../virt/kvm/eventfd.c:621:26: note: each undeclared identifier is reported only once for each function it appears in


vim +621 arch/powerpc/kvm/../../../virt/kvm/eventfd.c

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

