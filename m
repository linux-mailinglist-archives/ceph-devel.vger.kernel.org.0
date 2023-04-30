Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC65E6F28FB
	for <lists+ceph-devel@lfdr.de>; Sun, 30 Apr 2023 15:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjD3NFa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 30 Apr 2023 09:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjD3NF3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 30 Apr 2023 09:05:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6F010DB
        for <ceph-devel@vger.kernel.org>; Sun, 30 Apr 2023 06:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682859928; x=1714395928;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=AzO2q01Iyt1d3fdlMh3ynjEGVAHGuttVLpfDG/UjdeE=;
  b=GoCUiyBRBCVZmHdbTW5xupRhnhYDpksI0pVT34vBdbya1AO/NqDlm/0I
   ySZwO2nBMhk0STC4vqy6D2+IQTF0qyJdZdHnokQG9kMAG+iWPmQrHHAtJ
   h/ZA6d5ZYTolx4CHw67jxzBziLrHc0mGhTuxS06vCQxSN5RwzEQWS4eTF
   buKG2XZhqrCIt4Zy555JbpWMmhtAqoctfWcYGkLCsABm8QjPsZcygK12b
   kuE3x5S/c5WKLI7QUvjAJLjiE55WysL+Bq7vbs40q5szYtgMXrz2a6xq5
   4iUcO6pLB7snTpa9XW6bFZ+7MBLnuQGrPu53kIq40CPGH/+ldnPHJJRCH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10696"; a="350968406"
X-IronPort-AV: E=Sophos;i="5.99,239,1677571200"; 
   d="scan'208";a="350968406"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2023 06:05:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10696"; a="1025325082"
X-IronPort-AV: E=Sophos;i="5.99,239,1677571200"; 
   d="scan'208";a="1025325082"
Received: from lkp-server01.sh.intel.com (HELO 5bad9d2b7fcb) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 30 Apr 2023 06:05:25 -0700
Received: from kbuild by 5bad9d2b7fcb with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pt6k0-0001eb-30;
        Sun, 30 Apr 2023 13:05:24 +0000
Date:   Sun, 30 Apr 2023 21:05:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>,
        =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:testing 36/82] fs/ceph/crypto.c:296:26: error: implicit
 declaration of function 'fscrypt_base64url_decode'; did you mean
 'ceph_base64_decode'?
Message-ID: <202304302052.vH44LZpP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   55bbf9011c2a0947e91b8890c4659f80c0c19e31
commit: c9a1dfee71011b270118865911d2b56fb256398d [36/82] ceph: add helpers for converting names for userland presentation
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230430/202304302052.vH44LZpP-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/c9a1dfee71011b270118865911d2b56fb256398d
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout c9a1dfee71011b270118865911d2b56fb256398d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304302052.vH44LZpP-lkp@intel.com/

Note: the ceph-client/testing HEAD 55bbf9011c2a0947e91b8890c4659f80c0c19e31 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   fs/ceph/crypto.c: In function 'ceph_fname_to_usr':
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
   267		if (fname->name_len > CEPH_BASE64_CHARS(NAME_MAX))
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
