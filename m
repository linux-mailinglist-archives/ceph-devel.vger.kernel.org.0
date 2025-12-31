Return-Path: <ceph-devel+bounces-4239-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACF7CEB311
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 04:33:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 48FED3009F60
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 03:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6726827732;
	Wed, 31 Dec 2025 03:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hcTPH6rx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED71182B7
	for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 03:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767152003; cv=none; b=DccpbzKiL7Ooor0Qpr0e2/xBQEUuJZGApp9DqMcYCyKz1NrUIyBjW+xtS/knvmUsZGedOWVjHQ/U8NmdQiL8TlJYum7JMWZqygq4/YA/SxCcm8Um00dFC44o4QylHlmBQ+iJ27aeuqEUTWZ/127wwPUH6er4DQRptCKtcptMNwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767152003; c=relaxed/simple;
	bh=+pW0M7kGbku/Mut2XBpQICjZtZtaWclR0ggpK2BPemc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Qcex1ehQvRTQ5zPRj40JsUtypOXRXuu7zt6ZCs1717ng5hBMdurj524dYfn39dyigYlYvdQUEt/nwNDHm+hRsWGuwS7dfRgp6oklYalXfmuiSWiItt5SE6ZLZdEb4nv1uxpZXpxhU5I6T0YBzn4uI53hWeIsLyG4A8s/y/CiIyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hcTPH6rx; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767152002; x=1798688002;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=+pW0M7kGbku/Mut2XBpQICjZtZtaWclR0ggpK2BPemc=;
  b=hcTPH6rxLvLTQaCekUNizvE/l3pDelyN8fTpaYYw5MzTwbcjoEnKEyWh
   mTMNtRLpWSn1Jbkxsj+IYA776qardSJy/jeVFAMFfwzgvE+36DymM6ieF
   u73U/w1r+qFBruDUOI3I3wsYc/+891ozfC5IoIr915sRzkibAeg7rbATf
   NGz33lxb6G4d6pBhkEXxaj3jy/YGxVdVmTufAUcYLxnMQ1Nhl0vdlUzib
   PGLuRTv6x+ZPDhz4Z9Vknn/0sT32/Rxknv1b7yS+GY6CkUAVuwwFPG+7h
   Y5W0eHu3h8nKtonjQqyWQckponWeZrXcKwiIUKPgE2Wmhe8Nw/oElqFQy
   w==;
X-CSE-ConnectionGUID: g7jX4/kWTByJCHnDiyNezg==
X-CSE-MsgGUID: Xw1IQ3EuSs+XToSPyhiLBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11657"; a="94196617"
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="94196617"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 19:33:21 -0800
X-CSE-ConnectionGUID: cPQADFlOQ5idl3uZj4PDSQ==
X-CSE-MsgGUID: +cgcqonXQ96ndc5Qck8gTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="201593264"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 30 Dec 2025 19:33:20 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vamxZ-0000000085Q-3Mzv;
	Wed, 31 Dec 2025 03:33:17 +0000
Date: Wed, 31 Dec 2025 04:32:31 +0100
From: kernel test robot <lkp@intel.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:wip-krb5-only 8/8] net/ceph/crypto.c:20:12: warning:
 'set_aes_tfm' defined but not used
Message-ID: <202512310401.GTUQsLUi-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git wip-krb5-only
head:   252215f12e8c715bfa0a1d6237edf74bc5fdb1eb
commit: f223d3366fa1de01d0119237ac6a4e7bbb85bec7 [8/8] krb5 only
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251231/202512310401.GTUQsLUi-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251231/202512310401.GTUQsLUi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512310401.GTUQsLUi-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ceph/crypto.c:20:12: warning: 'set_aes_tfm' defined but not used [-Wunused-function]
      20 | static int set_aes_tfm(struct ceph_crypto_key *key)
         |            ^~~~~~~~~~~


vim +/set_aes_tfm +20 net/ceph/crypto.c

8b6e4f2d8b21c2 fs/ceph/crypto.c  Sage Weil    2010-02-02  19  
e58c5c85457182 net/ceph/crypto.c Ilya Dryomov 2025-12-22 @20  static int set_aes_tfm(struct ceph_crypto_key *key)
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  21  {
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  22  	unsigned int noio_flag;
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  23  	int ret;
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  24  
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  25  	noio_flag = memalloc_noio_save();
4f18d0d9525b0a net/ceph/crypto.c Ilya Dryomov 2025-12-22  26  	key->aes_tfm = crypto_alloc_sync_skcipher("cbc(aes)", 0, 0);
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  27  	memalloc_noio_restore(noio_flag);
4f18d0d9525b0a net/ceph/crypto.c Ilya Dryomov 2025-12-22  28  	if (IS_ERR(key->aes_tfm)) {
4f18d0d9525b0a net/ceph/crypto.c Ilya Dryomov 2025-12-22  29  		ret = PTR_ERR(key->aes_tfm);
4f18d0d9525b0a net/ceph/crypto.c Ilya Dryomov 2025-12-22  30  		key->aes_tfm = NULL;
e58c5c85457182 net/ceph/crypto.c Ilya Dryomov 2025-12-22  31  		return ret;
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  32  	}
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  33  
4f18d0d9525b0a net/ceph/crypto.c Ilya Dryomov 2025-12-22  34  	ret = crypto_sync_skcipher_setkey(key->aes_tfm, key->key, key->len);
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  35  	if (ret)
e58c5c85457182 net/ceph/crypto.c Ilya Dryomov 2025-12-22  36  		return ret;
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  37  
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  38  	return 0;
e58c5c85457182 net/ceph/crypto.c Ilya Dryomov 2025-12-22  39  }
7af3ea189a9a13 net/ceph/crypto.c Ilya Dryomov 2016-12-02  40  

:::::: The code at line 20 was first introduced by commit
:::::: e58c5c85457182987abb3d7f97de88192e97947d introduce ceph_crypto_key_prepare()

:::::: TO: Ilya Dryomov <idryomov@gmail.com>
:::::: CC: Ilya Dryomov <idryomov@gmail.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

