Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46AE2459FF
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Aug 2020 01:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgHPXEd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Aug 2020 19:04:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:60445 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgHPXEc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 16 Aug 2020 19:04:32 -0400
IronPort-SDR: AaqZmDle5/w7iKVYiNZTU0xw1SdG3bwgnKkvrULS4f0IoreONYqX/u2PsVi/C6v2Z0f2pmWom1
 gq5kfsqmMTvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="218941185"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="gz'50?scan'50,208,50";a="218941185"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 16:04:26 -0700
IronPort-SDR: A9y0d42bUVcg87FuWVqjqzPBSnpUtoVxxcsMUQ0vMMlGGn9yi0olwnsmoAhayG/QihHX3X/GB8
 7fsxJpwtmXUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="gz'50?scan'50,208,50";a="326243310"
Received: from lkp-server02.sh.intel.com (HELO 2f0d8b563e65) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 16 Aug 2020 16:04:24 -0700
Received: from kbuild by 2f0d8b563e65 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1k7RhP-0000GB-GM; Sun, 16 Aug 2020 23:04:23 +0000
Date:   Mon, 17 Aug 2020 07:03:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joe Perches <joe@perches.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ceph: Use generic debugging facility
Message-ID: <202008170710.BoRBUoeo%lkp@intel.com>
References: <d67377660a317c826a7899e6ffcb5bf686733ddb.1597615399.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <d67377660a317c826a7899e6ffcb5bf686733ddb.1597615399.git.joe@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Joe,

I love your patch! Yet something to improve:

[auto build test ERROR on ceph-client/for-linus]
[also build test ERROR on v5.9-rc1 next-20200814]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Joe-Perches/ceph-Neaten-debugging/20200817-060623
base:   https://github.com/ceph/ceph-client.git for-linus
config: openrisc-randconfig-r026-20200817 (attached as .config)
compiler: or1k-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=openrisc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/ceph/ceph_common.c: In function 'parse_fsid':
>> net/ceph/ceph_common.c:227:2: error: implicit declaration of function 'dout'; did you mean 'dput'? [-Werror=implicit-function-declaration]
     227 |  dout("parse_fsid '%s'\n", str);
         |  ^~~~
         |  dput
   In file included from net/ceph/ceph_common.c:24:
   At top level:
   include/linux/ceph/ceph_features.h:21:24: warning: 'DEPRECATED_CEPH_FEATUREMASK_RESERVED_BROKEN' defined but not used [-Wunused-const-variable=]
      21 |  static const uint64_t DEPRECATED_CEPH_FEATUREMASK_##name =  \
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:172:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE_DEPRECATED'
     172 | DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facing
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:20:24: warning: 'DEPRECATED_CEPH_FEATURE_RESERVED_BROKEN' defined but not used [-Wunused-const-variable=]
      20 |  static const uint64_t DEPRECATED_CEPH_FEATURE_##name = (1ULL<<bit); \
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:172:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE_DEPRECATED'
     172 | DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facing
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_RESERVED' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:171:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     171 | DEFINE_CEPH_FEATURE(62, 1, RESERVED)           // do not use; used as a sentinal
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_RESERVED' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:171:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     171 | DEFINE_CEPH_FEATURE(62, 1, RESERVED)           // do not use; used as a sentinal
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_CEPHX_V2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:169:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     169 | DEFINE_CEPH_FEATURE(61, 1, CEPHX_V2)             // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_OSD_RECOVERY_DELETES' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:168:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     168 | DEFINE_CEPH_FEATURE(60, 1, OSD_RECOVERY_DELETES) // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_OSD_RECOVERY_DELETES' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:168:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     168 | DEFINE_CEPH_FEATURE(60, 1, OSD_RECOVERY_DELETES) // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_MSG_ADDR2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:167:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     167 | DEFINE_CEPH_FEATURE(59, 1, MSG_ADDR2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_CHANGE_ATTR' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:166:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     166 | DEFINE_CEPH_FEATURE(59, 1, FS_CHANGE_ATTR) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_CHANGE_ATTR' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:166:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     166 | DEFINE_CEPH_FEATURE(59, 1, FS_CHANGE_ATTR) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_BTIME' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:165:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     165 | DEFINE_CEPH_FEATURE(59, 1, FS_BTIME)
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_BTIME' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:165:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     165 | DEFINE_CEPH_FEATURE(59, 1, FS_BTIME)
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_FILE_LAYOUT_V2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:164:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     164 | DEFINE_CEPH_FEATURE(58, 1, FS_FILE_LAYOUT_V2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_FILE_LAYOUT_V2' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:164:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     164 | DEFINE_CEPH_FEATURE(58, 1, FS_FILE_LAYOUT_V2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_NEW_OSDOPREPLY_ENCODING' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:163:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     163 | DEFINE_CEPH_FEATURE(58, 1, NEW_OSDOPREPLY_ENCODING) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_CRUSH_TUNABLES5' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:162:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     162 | DEFINE_CEPH_FEATURE(58, 1, CRUSH_TUNABLES5)
--
   net/ceph/messenger.c: In function 'con_sock_state_init':
>> net/ceph/messenger.c:309:2: error: implicit declaration of function 'dout'; did you mean 'dput'? [-Werror=implicit-function-declaration]
     309 |  dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
         |  ^~~~
         |  dput
   In file included from net/ceph/messenger.c:21:
   At top level:
   include/linux/ceph/ceph_features.h:21:24: warning: 'DEPRECATED_CEPH_FEATUREMASK_RESERVED_BROKEN' defined but not used [-Wunused-const-variable=]
      21 |  static const uint64_t DEPRECATED_CEPH_FEATUREMASK_##name =  \
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:172:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE_DEPRECATED'
     172 | DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facing
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:20:24: warning: 'DEPRECATED_CEPH_FEATURE_RESERVED_BROKEN' defined but not used [-Wunused-const-variable=]
      20 |  static const uint64_t DEPRECATED_CEPH_FEATURE_##name = (1ULL<<bit); \
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:172:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE_DEPRECATED'
     172 | DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facing
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_RESERVED' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:171:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     171 | DEFINE_CEPH_FEATURE(62, 1, RESERVED)           // do not use; used as a sentinal
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_RESERVED' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:171:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     171 | DEFINE_CEPH_FEATURE(62, 1, RESERVED)           // do not use; used as a sentinal
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_CEPHX_V2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:169:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     169 | DEFINE_CEPH_FEATURE(61, 1, CEPHX_V2)             // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_CEPHX_V2' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:169:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     169 | DEFINE_CEPH_FEATURE(61, 1, CEPHX_V2)             // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_OSD_RECOVERY_DELETES' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:168:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     168 | DEFINE_CEPH_FEATURE(60, 1, OSD_RECOVERY_DELETES) // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_OSD_RECOVERY_DELETES' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:168:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     168 | DEFINE_CEPH_FEATURE(60, 1, OSD_RECOVERY_DELETES) // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_MSG_ADDR2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:167:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     167 | DEFINE_CEPH_FEATURE(59, 1, MSG_ADDR2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_MSG_ADDR2' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:167:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     167 | DEFINE_CEPH_FEATURE(59, 1, MSG_ADDR2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_CHANGE_ATTR' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:166:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     166 | DEFINE_CEPH_FEATURE(59, 1, FS_CHANGE_ATTR) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_CHANGE_ATTR' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:166:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     166 | DEFINE_CEPH_FEATURE(59, 1, FS_CHANGE_ATTR) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_BTIME' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:165:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     165 | DEFINE_CEPH_FEATURE(59, 1, FS_BTIME)
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_BTIME' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:165:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     165 | DEFINE_CEPH_FEATURE(59, 1, FS_BTIME)
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_FILE_LAYOUT_V2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:164:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     164 | DEFINE_CEPH_FEATURE(58, 1, FS_FILE_LAYOUT_V2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_FILE_LAYOUT_V2' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:164:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     164 | DEFINE_CEPH_FEATURE(58, 1, FS_FILE_LAYOUT_V2) // overlap
--
   net/ceph/msgpool.c: In function 'msgpool_alloc':
>> net/ceph/msgpool.c:20:3: error: implicit declaration of function 'dout'; did you mean 'dput'? [-Werror=implicit-function-declaration]
      20 |   dout("msgpool_alloc %s failed\n", pool->name);
         |   ^~~~
         |   dput
   cc1: some warnings being treated as errors
--
   net/ceph/buffer.c: In function 'ceph_buffer_new':
>> net/ceph/buffer.c:29:2: error: implicit declaration of function 'dout'; did you mean 'dput'? [-Werror=implicit-function-declaration]
      29 |  dout("buffer_new %p\n", b);
         |  ^~~~
         |  dput
   cc1: some warnings being treated as errors
--
   net/ceph/mon_client.c: In function 'ceph_monmap_decode':
>> net/ceph/mon_client.c:53:2: error: implicit declaration of function 'dout'; did you mean 'dput'? [-Werror=implicit-function-declaration]
      53 |  dout("monmap_decode %p %p len %d (%d)\n", p, end, len, (int)(end-p));
         |  ^~~~
         |  dput
   In file included from net/ceph/mon_client.c:10:
   At top level:
   include/linux/ceph/ceph_features.h:21:24: warning: 'DEPRECATED_CEPH_FEATUREMASK_RESERVED_BROKEN' defined but not used [-Wunused-const-variable=]
      21 |  static const uint64_t DEPRECATED_CEPH_FEATUREMASK_##name =  \
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:172:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE_DEPRECATED'
     172 | DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facing
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:20:24: warning: 'DEPRECATED_CEPH_FEATURE_RESERVED_BROKEN' defined but not used [-Wunused-const-variable=]
      20 |  static const uint64_t DEPRECATED_CEPH_FEATURE_##name = (1ULL<<bit); \
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:172:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE_DEPRECATED'
     172 | DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facing
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_RESERVED' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:171:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     171 | DEFINE_CEPH_FEATURE(62, 1, RESERVED)           // do not use; used as a sentinal
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_RESERVED' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:171:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     171 | DEFINE_CEPH_FEATURE(62, 1, RESERVED)           // do not use; used as a sentinal
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_CEPHX_V2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:169:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     169 | DEFINE_CEPH_FEATURE(61, 1, CEPHX_V2)             // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_CEPHX_V2' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:169:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     169 | DEFINE_CEPH_FEATURE(61, 1, CEPHX_V2)             // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_OSD_RECOVERY_DELETES' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:168:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     168 | DEFINE_CEPH_FEATURE(60, 1, OSD_RECOVERY_DELETES) // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_OSD_RECOVERY_DELETES' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:168:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     168 | DEFINE_CEPH_FEATURE(60, 1, OSD_RECOVERY_DELETES) // *do not share this bit*
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_MSG_ADDR2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:167:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     167 | DEFINE_CEPH_FEATURE(59, 1, MSG_ADDR2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_MSG_ADDR2' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:167:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     167 | DEFINE_CEPH_FEATURE(59, 1, MSG_ADDR2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_CHANGE_ATTR' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:166:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     166 | DEFINE_CEPH_FEATURE(59, 1, FS_CHANGE_ATTR) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_CHANGE_ATTR' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:166:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     166 | DEFINE_CEPH_FEATURE(59, 1, FS_CHANGE_ATTR) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_BTIME' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:165:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     165 | DEFINE_CEPH_FEATURE(59, 1, FS_BTIME)
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_BTIME' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:165:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     165 | DEFINE_CEPH_FEATURE(59, 1, FS_BTIME)
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:15:24: warning: 'CEPH_FEATUREMASK_FS_FILE_LAYOUT_V2' defined but not used [-Wunused-const-variable=]
      15 |  static const uint64_t CEPH_FEATUREMASK_##name =   \
         |                        ^~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:164:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     164 | DEFINE_CEPH_FEATURE(58, 1, FS_FILE_LAYOUT_V2) // overlap
         | ^~~~~~~~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_FS_FILE_LAYOUT_V2' defined but not used [-Wunused-const-variable=]
      14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
         |                        ^~~~~~~~~~~~~
   include/linux/ceph/ceph_features.h:164:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
     164 | DEFINE_CEPH_FEATURE(58, 1, FS_FILE_LAYOUT_V2) // overlap
..

# https://github.com/0day-ci/linux/commit/ab0413062c34a692c0480a3237a04534f823e02d
git remote add linux-review https://github.com/0day-ci/linux
git fetch --no-tags linux-review Joe-Perches/ceph-Neaten-debugging/20200817-060623
git checkout ab0413062c34a692c0480a3237a04534f823e02d
vim +227 net/ceph/ceph_common.c

3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  219  
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  220  static int parse_fsid(const char *str, struct ceph_fsid *fsid)
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  221  {
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  222  	int i = 0;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  223  	char tmp[3];
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  224  	int err = -EINVAL;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  225  	int d;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  226  
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06 @227  	dout("parse_fsid '%s'\n", str);
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  228  	tmp[2] = 0;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  229  	while (*str && i < 16) {
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  230  		if (ispunct(*str)) {
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  231  			str++;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  232  			continue;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  233  		}
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  234  		if (!isxdigit(str[0]) || !isxdigit(str[1]))
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  235  			break;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  236  		tmp[0] = str[0];
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  237  		tmp[1] = str[1];
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  238  		if (sscanf(tmp, "%x", &d) < 1)
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  239  			break;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  240  		fsid->fsid[i] = d & 0xff;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  241  		i++;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  242  		str += 2;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  243  	}
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  244  
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  245  	if (i == 16)
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  246  		err = 0;
4c069a5821ddc5 Chengguang Xu 2018-01-30  247  	dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  248  	return err;
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  249  }
3d14c5d2b6e15c Yehuda Sadeh  2010-04-06  250  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--Q68bSM7Ycu6FN28Q
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
Ri5VBhvmKn+xr0EAs/gGvwDneEJzynwBAA==

--Q68bSM7Ycu6FN28Q--
