Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B106A344A
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Feb 2023 22:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBZVjM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 16:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBZVjL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 16:39:11 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306B2CC3D
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 13:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677447549; x=1708983549;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6sjIrMkWfr9WyjdLWR6ZNqmVUw5ODhQFuUQvI11CJ04=;
  b=EX6dhS4t8zv4HtSN/IJebQvhMp2PQgfmEMgIIWr4q18o+QUHup3NT6j1
   yG0NHiGV+RfXg8W9EMInOg3BYN4JcQdOVoReLIqDaJ21JKZFJ5tDo8hwC
   4HYmjfKk9PE0HCI2+XgM5mXUx82R37PH2cKB0hWzdEf49VI08mPOLDdDL
   b3znFhnmZqQDtyQwziEtnEOIRdU/M5XuPqX+T+ylO+cbUJVLyRYeVQBEM
   QAQnu2v9HxPooOfyMurbXg3yDTHTDQatccUS42QZSzK2sHGrEUauJTItQ
   LGc45CysckA4BRsrX5lmC9CnLTHMJlct/soFQWwF0PRfoxfs3ZCl0sqYg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="336022709"
X-IronPort-AV: E=Sophos;i="5.97,330,1669104000"; 
   d="scan'208";a="336022709"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2023 13:39:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="650981989"
X-IronPort-AV: E=Sophos;i="5.97,330,1669104000"; 
   d="scan'208";a="650981989"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 26 Feb 2023 13:39:07 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pWOjb-0003uB-07;
        Sun, 26 Feb 2023 21:39:07 +0000
Date:   Mon, 27 Feb 2023 05:38:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:testing 32/75] fs/ceph/crypto.c:296:26: error: implicit
 declaration of function 'fscrypt_base64url_decode'; did you mean
 'ceph_base64_decode'?
Message-ID: <202302270537.vINNROs9-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   69aa49c89640a5018393d2ae30e5a6071e3cf9c8
commit: 44947f44747cf0c16f0999962b4a43b6d8a2c6e8 [32/75] ceph: add helpers for converting names for userland presentation
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230227/202302270537.vINNROs9-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/44947f44747cf0c16f0999962b4a43b6d8a2c6e8
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 44947f44747cf0c16f0999962b4a43b6d8a2c6e8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302270537.vINNROs9-lkp@intel.com/

Note: the ceph-client/testing HEAD 69aa49c89640a5018393d2ae30e5a6071e3cf9c8 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   fs/ceph/crypto.c: In function 'ceph_fname_to_usr':
   fs/ceph/crypto.c:267:31: error: implicit declaration of function 'FSCRYPT_BASE64URL_CHARS'; did you mean 'CEPH_BASE64_CHARS'? [-Werror=implicit-function-declaration]
     267 |         if (fname->name_len > FSCRYPT_BASE64URL_CHARS(NAME_MAX))
         |                               ^~~~~~~~~~~~~~~~~~~~~~~
         |                               CEPH_BASE64_CHARS
>> fs/ceph/crypto.c:296:26: error: implicit declaration of function 'fscrypt_base64url_decode'; did you mean 'ceph_base64_decode'? [-Werror=implicit-function-declaration]
     296 |                 declen = fscrypt_base64url_decode(fname->name, fname->name_len, tname->name);
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~
         |                          ceph_base64_decode
   cc1: some warnings being treated as errors


vim +296 fs/ceph/crypto.c

   237	
   238	/**
   239	 * ceph_fname_to_usr - convert a filename for userland presentation
   240	 * @fname: ceph_fname to be converted
   241	 * @tname: temporary name buffer to use for conversion (may be NULL)
   242	 * @oname: where converted name should be placed
   243	 * @is_nokey: set to true if key wasn't available during conversion (may be NULL)
   244	 *
   245	 * Given a filename (usually from the MDS), format it for presentation to
   246	 * userland. If @parent is not encrypted, just pass it back as-is.
   247	 *
   248	 * Otherwise, base64 decode the string, and then ask fscrypt to format it
   249	 * for userland presentation.
   250	 *
   251	 * Returns 0 on success or negative error code on error.
   252	 */
   253	int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
   254			      struct fscrypt_str *oname, bool *is_nokey)
   255	{
   256		int ret;
   257		struct fscrypt_str _tname = FSTR_INIT(NULL, 0);
   258		struct fscrypt_str iname;
   259	
   260		if (!IS_ENCRYPTED(fname->dir)) {
   261			oname->name = fname->name;
   262			oname->len = fname->name_len;
   263			return 0;
   264		}
   265	
   266		/* Sanity check that the resulting name will fit in the buffer */
   267		if (fname->name_len > FSCRYPT_BASE64URL_CHARS(NAME_MAX))
   268			return -EIO;
   269	
   270		ret = __fscrypt_prepare_readdir(fname->dir);
   271		if (ret)
   272			return ret;
   273	
   274		/*
   275		 * Use the raw dentry name as sent by the MDS instead of
   276		 * generating a nokey name via fscrypt.
   277		 */
   278		if (!fscrypt_has_encryption_key(fname->dir)) {
   279			memcpy(oname->name, fname->name, fname->name_len);
   280			oname->len = fname->name_len;
   281			if (is_nokey)
   282				*is_nokey = true;
   283			return 0;
   284		}
   285	
   286		if (fname->ctext_len == 0) {
   287			int declen;
   288	
   289			if (!tname) {
   290				ret = fscrypt_fname_alloc_buffer(NAME_MAX, &_tname);
   291				if (ret)
   292					return ret;
   293				tname = &_tname;
   294			}
   295	
 > 296			declen = fscrypt_base64url_decode(fname->name, fname->name_len, tname->name);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
