Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BEB5736D5
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Jul 2022 15:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiGMNHE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Jul 2022 09:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGMNHA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Jul 2022 09:07:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AAB8F
        for <ceph-devel@vger.kernel.org>; Wed, 13 Jul 2022 06:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657717619; x=1689253619;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5ISBg0EHCCePZYQy5QnxH1HBInUEi/9vbyeLHUdQC9E=;
  b=ZSppNGci7Oryc8gm1sXthM97Po2wZeH55sJKXP0PwHuEz5mwwumXpqhN
   SQ1DXXgWVTUc3ogjZ0scwARkO+6ePjBREyfmCpL83+Hdfyr7kzcWDi1WZ
   YD4C2kQuOxWnsurBkl/JkO7ySKCr4d2SkaiUAZNqHmVpiihaQzi52kKQ0
   WQma9JUPLFaD37w7WUu9unBkxUWjcZDBdx7gvv6/OJLqk5Tp+c4HBYwWy
   916UymKcE1yTLmNYPjymhXC8GYkvSw6NtzhvZtDNP2BEvbLwndwSnHd8O
   i6XUo7aK6hkjm2ME2g4JCoRMFFvvz2gwt7zfMT84rQfaQUFM6DsXNPstx
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="264992337"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="264992337"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 06:06:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="922623122"
Received: from lkp-server02.sh.intel.com (HELO 8708c84be1ad) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jul 2022 06:06:58 -0700
Received: from kbuild by 8708c84be1ad with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oBc4v-0003UD-Ua;
        Wed, 13 Jul 2022 13:06:57 +0000
Date:   Wed, 13 Jul 2022 21:06:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:testing 1/21] fs/ceph/super.c:1101:46: error: 'struct
 ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
Message-ID: <202207132003.QSn2r1BX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   6720fad7ad85215b45fa7899478311d22ba5331a
commit: f450dd288f2774012e8a4928c696192ed877a5c2 [1/21] ceph: implement -o test_dummy_encryption mount option
config: sparc64-randconfig-r015-20220712 (https://download.01.org/0day-ci/archive/20220713/202207132003.QSn2r1BX-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/f450dd288f2774012e8a4928c696192ed877a5c2
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout f450dd288f2774012e8a4928c696192ed877a5c2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=sparc64 SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/ceph/super.c: In function 'ceph_apply_test_dummy_encryption':
>> fs/ceph/super.c:1101:46: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
    1101 |             !fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
         |                                              ^~
   fs/ceph/super.c:1103:54: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
    1103 |                                                  &fsc->fsc_dummy_enc_policy))
         |                                                      ^~
   fs/ceph/super.c:1110:45: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
    1110 |         if (fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
         |                                             ^~
   fs/ceph/super.c:1112:54: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
    1112 |                                                  &fsc->fsc_dummy_enc_policy))
         |                                                      ^~
   fs/ceph/super.c:1118:12: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
    1118 |         fsc->fsc_dummy_enc_policy = fsopt->dummy_enc_policy;
         |            ^~
   fs/ceph/super.c:1121:50: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
    1121 |         err = fscrypt_add_test_dummy_key(sb, &fsc->fsc_dummy_enc_policy);
         |                                                  ^~


vim +1101 fs/ceph/super.c

  1088	
  1089	static int ceph_apply_test_dummy_encryption(struct super_block *sb,
  1090						    struct fs_context *fc,
  1091						    struct ceph_mount_options *fsopt)
  1092	{
  1093		struct ceph_fs_client *fsc = sb->s_fs_info;
  1094		int err;
  1095	
  1096		if (!fscrypt_is_dummy_policy_set(&fsopt->dummy_enc_policy))
  1097			return 0;
  1098	
  1099		/* No changing encryption context on remount. */
  1100		if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE &&
> 1101		    !fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
  1102			if (fscrypt_dummy_policies_equal(&fsopt->dummy_enc_policy,
  1103							 &fsc->fsc_dummy_enc_policy))
  1104				return 0;
  1105			errorfc(fc, "Can't set test_dummy_encryption on remount");
  1106			return -EINVAL;
  1107		}
  1108	
  1109		/* Also make sure fsopt doesn't contain a conflicting value. */
  1110		if (fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
  1111			if (fscrypt_dummy_policies_equal(&fsopt->dummy_enc_policy,
  1112							 &fsc->fsc_dummy_enc_policy))
  1113				return 0;
  1114			errorfc(fc, "Conflicting test_dummy_encryption options");
  1115			return -EINVAL;
  1116		}
  1117	
  1118		fsc->fsc_dummy_enc_policy = fsopt->dummy_enc_policy;
  1119		memset(&fsopt->dummy_enc_policy, 0, sizeof(fsopt->dummy_enc_policy));
  1120	
  1121		err = fscrypt_add_test_dummy_key(sb, &fsc->fsc_dummy_enc_policy);
  1122		if (err) {
  1123			errorfc(fc, "Error adding test dummy encryption key, %d", err);
  1124			return err;
  1125		}
  1126	
  1127		warnfc(fc, "test_dummy_encryption mode enabled");
  1128		return 0;
  1129	}
  1130	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
