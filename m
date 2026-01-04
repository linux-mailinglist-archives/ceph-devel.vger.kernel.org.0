Return-Path: <ceph-devel+bounces-4242-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1979DCF09BC
	for <lists+ceph-devel@lfdr.de>; Sun, 04 Jan 2026 06:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2AFD9300103A
	for <lists+ceph-devel@lfdr.de>; Sun,  4 Jan 2026 05:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DA02D192B;
	Sun,  4 Jan 2026 05:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Whi6kUvh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F622C11F5
	for <ceph-devel@vger.kernel.org>; Sun,  4 Jan 2026 05:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767503708; cv=none; b=eOQOwb8+sulr2qP0xCInDofcfMAf5oKx+n7kxR4PRPJjQT1Midwhl1FA3XXmjKoj6yv4a0+VjVUVFZT3GhBhqFhX5z53JfAz034aHbZBHJ5u37bMyzskIjrYzI8+IiA/MyJc6h4ImiCtzZb1gRHHmoKzC7oNwpbBBLz+yqmif8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767503708; c=relaxed/simple;
	bh=Y2v8mkMKb+X7nBZyqsOrjpDvaEgRQjWJ6IGqSNFa4qw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Uw7BTrrdOCegMifIXI0A0v5ZdGqGR8HcJaGtdsmi0cVT12qOojTVjIK4S+DaEtzTLGFIbqFiLqWkVx1UMxLooYBeu57k/wOXt9g7yfOUCget2eMMFN6tejxeLlUk4of+bgXnRc3iQ1CHUcKnI59rNyvTuAYYQdd5DCiixHuhIbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Whi6kUvh; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767503706; x=1799039706;
  h=date:from:to:cc:subject:message-id;
  bh=Y2v8mkMKb+X7nBZyqsOrjpDvaEgRQjWJ6IGqSNFa4qw=;
  b=Whi6kUvh4L/By+XLxprhYGPfhHZxT7HjlcSA7uYiKX7shGIxlGNS/LlL
   imZE+lo0EdzTbKjfz6PbQySCk30mRpUwUEl+vpWr7PBdvrg/RAL2bhUt+
   2a+6hCwgcekbLvaSXf1aChHWfoy3q8ZlYhJ9gkGw6BtQCp/Gg6uGoORGm
   HHigrTFgfvd5Do2H2dTFgUp002s5hru7LmTFwkULPTjW7u+HpZar2ir78
   0r1JCdyeyDujOl5Jam/HxL5QEtzxModyh4S4G/VB2nsHgCckzue6SlX/Y
   xK6ZPwvyuuK3HGy7oYLzMNytINePa6yKzLjwsNnEwbrXifnfXyWCDyM5N
   Q==;
X-CSE-ConnectionGUID: n8x8ddvwQXuZmH+ev/SzaA==
X-CSE-MsgGUID: WZIf6CqQRqGuGpARu/Si9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="86503970"
X-IronPort-AV: E=Sophos;i="6.21,200,1763452800"; 
   d="scan'208";a="86503970"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2026 21:15:05 -0800
X-CSE-ConnectionGUID: snC5ONM/S42r2/fFJmG7SA==
X-CSE-MsgGUID: cALn8xI9SFWFmBtA9HgoCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,200,1763452800"; 
   d="scan'208";a="202127791"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 03 Jan 2026 21:15:00 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vcGSA-000000000Nt-0vWv;
	Sun, 04 Jan 2026 05:14:58 +0000
Date: Sun, 04 Jan 2026 13:14:52 +0800
From: kernel test robot <lkp@intel.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Subject: [ceph-client:wip-krb5-only 8/8] net/ceph/crypto.c:20:12:
 warning: 'set_aes_tfm' defined but not used
Message-ID: <202601041325.MiYfspoS-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>

tree:   https://github.com/ceph/ceph-client.git wip-krb5-only
head:   252215f12e8c715bfa0a1d6237edf74bc5fdb1eb
commit: 252215f12e8c715bfa0a1d6237edf74bc5fdb1eb [8/8] krb5 only
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20260104/202601041325.MiYfspoS-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260104/202601041325.MiYfspoS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601041325.MiYfspoS-lkp@intel.com/

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

