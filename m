Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CF2505ED2
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 22:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiDRUIh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 16:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiDRUIf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 16:08:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851E32E0B2
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 13:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650312355; x=1681848355;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=j8V+Mx09URl/vJGXg7F+xUW1JtsgGT1o+WDFEn4YeM8=;
  b=njNTs4uxs9NREFiOd18z19BOdm8TQQEWF2y9BbusZ+6Uzyyet0JcWc3x
   KKwqMb8NrvB+wkG2+DM7ZS+Y3gA9/aUwixV/+ArMCX6kyk4eAxcXtzjsw
   AzXr+l7/I7eUiBOh39zRi45lLaakmU2VtjjI7oH0eBylH7vZVdAOoB+ju
   d7IlnMj37ImtL6H4SAAOpu+Gc7Apyz0RafHQzrVeOyPeh7Ogqe5lgGCR9
   +vYuYJAY/dPrdmiPGdjGZVjNV+XFQJIngoPqEJHUfkOBfpsVrfx3eZq6O
   VQ5KzFg9qKffB7MBUBvcPNrKDyICsXgYTAhnXZ486gc5Vm8/G4m9rK4YT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="288694184"
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="288694184"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 13:05:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="575731874"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 18 Apr 2022 13:05:53 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ngXdA-0004wG-SE;
        Mon, 18 Apr 2022 20:05:52 +0000
Date:   Tue, 19 Apr 2022 04:05:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:wip-fscrypt 62/69] fs/ceph/inode.c:196:19: error:
 'struct ceph_inode_info' has no member named 'fscrypt_auth'
Message-ID: <202204190343.Mo544W33-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git wip-fscrypt
head:   4ff01fe87e581e76289ec6d1b0c03fc9c4f2f851
commit: fd1aab0d215fa1b9a84a42ec93f09f0283bb8071 [62/69] ceph: add support for encrypted snapshot names
config: powerpc-randconfig-m031-20220417 (https://download.01.org/0day-ci/archive/20220419/202204190343.Mo544W33-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/fd1aab0d215fa1b9a84a42ec93f09f0283bb8071
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client wip-fscrypt
        git checkout fd1aab0d215fa1b9a84a42ec93f09f0283bb8071
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/ceph/inode.c: In function 'ceph_get_snapdir':
>> fs/ceph/inode.c:196:19: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth'
     196 |                 ci->fscrypt_auth = kmemdup(pci->fscrypt_auth,
         |                   ^~
   fs/ceph/inode.c:196:47: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth'
     196 |                 ci->fscrypt_auth = kmemdup(pci->fscrypt_auth,
         |                                               ^~
>> fs/ceph/inode.c:197:47: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth_len'
     197 |                                            pci->fscrypt_auth_len,
         |                                               ^~
   fs/ceph/inode.c:199:23: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth'
     199 |                 if (ci->fscrypt_auth) {
         |                       ^~
   fs/ceph/inode.c:201:27: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth_len'
     201 |                         ci->fscrypt_auth_len = pci->fscrypt_auth_len;
         |                           ^~
   fs/ceph/inode.c:201:51: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth_len'
     201 |                         ci->fscrypt_auth_len = pci->fscrypt_auth_len;
         |                                                   ^~


vim +196 fs/ceph/inode.c

   154	
   155	/*
   156	 * get/constuct snapdir inode for a given directory
   157	 */
   158	struct inode *ceph_get_snapdir(struct inode *parent)
   159	{
   160		struct ceph_vino vino = {
   161			.ino = ceph_ino(parent),
   162			.snap = CEPH_SNAPDIR,
   163		};
   164		struct inode *inode = ceph_get_inode(parent->i_sb, vino, NULL);
   165		struct ceph_inode_info *ci = ceph_inode(inode);
   166		int ret = -ENOTDIR;
   167	
   168		if (IS_ERR(inode))
   169			return inode;
   170	
   171		if (!S_ISDIR(parent->i_mode)) {
   172			pr_warn_once("bad snapdir parent type (mode=0%o)\n",
   173				     parent->i_mode);
   174			goto err;
   175		}
   176	
   177		if (!(inode->i_state & I_NEW) && !S_ISDIR(inode->i_mode)) {
   178			pr_warn_once("bad snapdir inode type (mode=0%o)\n",
   179				     inode->i_mode);
   180			goto err;
   181		}
   182	
   183		inode->i_mode = parent->i_mode;
   184		inode->i_uid = parent->i_uid;
   185		inode->i_gid = parent->i_gid;
   186		inode->i_mtime = parent->i_mtime;
   187		inode->i_ctime = parent->i_ctime;
   188		inode->i_atime = parent->i_atime;
   189		ci->i_rbytes = 0;
   190		ci->i_btime = ceph_inode(parent)->i_btime;
   191	
   192		/* if encrypted, just borrow fscrypt_auth from parent */
   193		if (IS_ENCRYPTED(parent)) {
   194			struct ceph_inode_info *pci = ceph_inode(parent);
   195	
 > 196			ci->fscrypt_auth = kmemdup(pci->fscrypt_auth,
 > 197						   pci->fscrypt_auth_len,
   198						   GFP_KERNEL);
   199			if (ci->fscrypt_auth) {
   200				inode->i_flags |= S_ENCRYPTED;
   201				ci->fscrypt_auth_len = pci->fscrypt_auth_len;
   202			} else {
   203				dout("Failed to alloc snapdir fscrypt_auth\n");
   204				ret = -ENOMEM;
   205				goto err;
   206			}
   207		}
   208		if (inode->i_state & I_NEW) {
   209			inode->i_op = &ceph_snapdir_iops;
   210			inode->i_fop = &ceph_snapdir_fops;
   211			ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
   212			unlock_new_inode(inode);
   213		}
   214	
   215		return inode;
   216	err:
   217		if ((inode->i_state & I_NEW))
   218			discard_new_inode(inode);
   219		else
   220			iput(inode);
   221		return ERR_PTR(ret);
   222	}
   223	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
