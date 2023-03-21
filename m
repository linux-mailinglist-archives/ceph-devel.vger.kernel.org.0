Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8676C28FF
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Mar 2023 05:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjCUEIA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Mar 2023 00:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjCUEHe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 21 Mar 2023 00:07:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897A71040E
        for <ceph-devel@vger.kernel.org>; Mon, 20 Mar 2023 21:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679371422; x=1710907422;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=q0hX40nV6rdmJ9OmxZGVRXPnorg6ovt3A3Dt8fmXZtA=;
  b=Yg2Gx3G5C/FLdqmXxTLDXmZhoWh+G+D5qdBMNJtUod+AF1qd6uUkKb4i
   +Zn0D0hfLLub8r6kcfqIc6nlGS3ETfdx+UTA7dat5J+9ml2SSvIrpuGXh
   W+IJEeXt5u+YnRbcrSOTlpqg2jLt3r5MExQvasQ9mO4aPWL1fgErBmomT
   adXPdwnC2OmEyqnCkaVc6aJG41VWNhTO6KUC1oHNuo508tJKLBAnNeDzI
   sk3H2HrbvXS9Gb69jCZhXpjLUmqj0t1qVLQphXczxsjtbfASLGz21KkBL
   GlsyX99vksGvf5NUxQQWI6yu5QZbOqD3CkKuM9I1LGGhxr+Gka1WQwgcv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="318492876"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="318492876"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 21:00:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="791901980"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="791901980"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2023 21:00:10 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peTAP-000BZd-25;
        Tue, 21 Mar 2023 04:00:09 +0000
Date:   Tue, 21 Mar 2023 11:59:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:testing 19/80] fs/ceph/super.c:1122:15: error: implicit
 declaration of function 'fscrypt_add_test_dummy_key'
Message-ID: <202303211100.ExmaGnB0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   bc74c6176640bed8ff55211d4211658413f5c19c
commit: 72326544b6f873e44659da920b51572bdf76b143 [19/80] ceph: implement -o test_dummy_encryption mount option
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20230321/202303211100.ExmaGnB0-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/72326544b6f873e44659da920b51572bdf76b143
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 72326544b6f873e44659da920b51572bdf76b143
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=nios2 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303211100.ExmaGnB0-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/ceph/super.c: In function 'ceph_apply_test_dummy_encryption':
>> fs/ceph/super.c:1122:15: error: implicit declaration of function 'fscrypt_add_test_dummy_key' [-Werror=implicit-function-declaration]
    1122 |         err = fscrypt_add_test_dummy_key(sb, &fsc->fsc_dummy_enc_policy);
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/fscrypt_add_test_dummy_key +1122 fs/ceph/super.c

  1088	
  1089	#ifdef CONFIG_FS_ENCRYPTION
  1090	static int ceph_apply_test_dummy_encryption(struct super_block *sb,
  1091						    struct fs_context *fc,
  1092						    struct ceph_mount_options *fsopt)
  1093	{
  1094		struct ceph_fs_client *fsc = sb->s_fs_info;
  1095		int err;
  1096	
  1097		if (!fscrypt_is_dummy_policy_set(&fsopt->dummy_enc_policy))
  1098			return 0;
  1099	
  1100		/* No changing encryption context on remount. */
  1101		if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE &&
  1102		    !fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
  1103			if (fscrypt_dummy_policies_equal(&fsopt->dummy_enc_policy,
  1104							 &fsc->fsc_dummy_enc_policy))
  1105				return 0;
  1106			errorfc(fc, "Can't set test_dummy_encryption on remount");
  1107			return -EINVAL;
  1108		}
  1109	
  1110		/* Also make sure fsopt doesn't contain a conflicting value. */
  1111		if (fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
  1112			if (fscrypt_dummy_policies_equal(&fsopt->dummy_enc_policy,
  1113							 &fsc->fsc_dummy_enc_policy))
  1114				return 0;
  1115			errorfc(fc, "Conflicting test_dummy_encryption options");
  1116			return -EINVAL;
  1117		}
  1118	
  1119		fsc->fsc_dummy_enc_policy = fsopt->dummy_enc_policy;
  1120		memset(&fsopt->dummy_enc_policy, 0, sizeof(fsopt->dummy_enc_policy));
  1121	
> 1122		err = fscrypt_add_test_dummy_key(sb, &fsc->fsc_dummy_enc_policy);
  1123		if (err) {
  1124			errorfc(fc, "Error adding test dummy encryption key, %d", err);
  1125			return err;
  1126		}
  1127	
  1128		warnfc(fc, "test_dummy_encryption mode enabled");
  1129		return 0;
  1130	}
  1131	#else
  1132	static int ceph_apply_test_dummy_encryption(struct super_block *sb,
  1133						    struct fs_context *fc,
  1134						    struct ceph_mount_options *fsopt)
  1135	{
  1136		return 0;
  1137	}
  1138	#endif
  1139	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
