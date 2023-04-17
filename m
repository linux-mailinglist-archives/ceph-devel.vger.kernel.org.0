Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6906E4DAC
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 17:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjDQPvY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Apr 2023 11:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjDQPvX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Apr 2023 11:51:23 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD38BC679
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 08:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681746654; x=1713282654;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VBbS1N6dbiPjtnVybBSFAVAsY8snSznOY+lsSVR+vS8=;
  b=QTaCSJrCkwbsVEOBXEj9vtOUt1prfwwHkI0SzESnpcH4qDVKO2KNi5ZQ
   ZJ6GDSn9o36aB0JEddCCPUjG/fPB2Bj+yrQp+aoF86UUCd+M5py5uyCty
   vCny1ztMuVrp+xKkSJqQcFxfJ5N1QDNZHs4jOTmbyQCUXkfbGam9rWDUX
   eBSUp0Rwg1Ek3PwVJPoOlpObaCTK1l0HALyMdih+PYs3X3OKj5/a8/F19
   Z7CZrGMiMGI8Zp2mSgZYWVbJT/wbcHeTrM3e+mDiuRtgeV68ohJSbNaK9
   enkG/IcX4UKJV6K09MTN7t9VAra9gVcrLHCEM8O1W0v7vwbtx+ESh4xgN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="410139659"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="410139659"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 08:50:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="759997297"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="759997297"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 17 Apr 2023 08:49:58 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1poR78-000cYZ-0g;
        Mon, 17 Apr 2023 15:49:58 +0000
Date:   Mon, 17 Apr 2023 23:49:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org
Subject: [ceph-client:testing 77/77] fs/ceph/mds_client.c:1866:6: warning:
 variable 'iputs' is used uninitialized whenever 'if' condition is false
Message-ID: <202304172343.2ToBO5ag-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d
commit: 3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d [77/77] ceph: fix potential use-after-free bug when trimming caps
config: x86_64-randconfig-a011-20230417 (https://download.01.org/0day-ci/archive/20230417/202304172343.2ToBO5ag-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/ceph/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304172343.2ToBO5ag-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/ceph/mds_client.c:1866:6: warning: variable 'iputs' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (cap) {
               ^~~
   fs/ceph/mds_client.c:1877:9: note: uninitialized use occurs here
           while (iputs--)
                  ^~~~~
   fs/ceph/mds_client.c:1866:2: note: remove the 'if' if its condition is always true
           if (cap) {
           ^~~~~~~~~
   fs/ceph/mds_client.c:1862:11: note: initialize the variable 'iputs' to silence this warning
           int iputs;
                    ^
                     = 0
>> fs/ceph/mds_client.c:1957:7: warning: variable 'cap' is uninitialized when used here [-Wuninitialized]
                   if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
                       ^~~
   fs/ceph/mds_client.c:1949:22: note: initialize the variable 'cap' to silence this warning
           struct ceph_cap *cap;
                               ^
                                = NULL
   2 warnings generated.


vim +1866 fs/ceph/mds_client.c

  1855	
  1856	static int remove_session_caps_cb(struct inode *inode, struct rb_node *ci_node,
  1857					  void *arg)
  1858	{
  1859		struct ceph_inode_info *ci = ceph_inode(inode);
  1860		bool invalidate = false;
  1861		struct ceph_cap *cap;
  1862		int iputs;
  1863	
  1864		spin_lock(&ci->i_ceph_lock);
  1865		cap = rb_entry(ci_node, struct ceph_cap, ci_node);
> 1866		if (cap) {
  1867			dout(" removing cap %p, ci is %p, inode is %p\n",
  1868			     cap, ci, &ci->netfs.inode);
  1869	
  1870			iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
  1871		}
  1872		spin_unlock(&ci->i_ceph_lock);
  1873	
  1874		wake_up_all(&ci->i_cap_wq);
  1875		if (invalidate)
  1876			ceph_queue_invalidate(inode);
  1877		while (iputs--)
  1878			iput(inode);
  1879		return 0;
  1880	}
  1881	
  1882	/*
  1883	 * caller must hold session s_mutex
  1884	 */
  1885	static void remove_session_caps(struct ceph_mds_session *session)
  1886	{
  1887		struct ceph_fs_client *fsc = session->s_mdsc->fsc;
  1888		struct super_block *sb = fsc->sb;
  1889		LIST_HEAD(dispose);
  1890	
  1891		dout("remove_session_caps on %p\n", session);
  1892		ceph_iterate_session_caps(session, remove_session_caps_cb, fsc);
  1893	
  1894		wake_up_all(&fsc->mdsc->cap_flushing_wq);
  1895	
  1896		spin_lock(&session->s_cap_lock);
  1897		if (session->s_nr_caps > 0) {
  1898			struct inode *inode;
  1899			struct ceph_cap *cap, *prev = NULL;
  1900			struct ceph_vino vino;
  1901			/*
  1902			 * iterate_session_caps() skips inodes that are being
  1903			 * deleted, we need to wait until deletions are complete.
  1904			 * __wait_on_freeing_inode() is designed for the job,
  1905			 * but it is not exported, so use lookup inode function
  1906			 * to access it.
  1907			 */
  1908			while (!list_empty(&session->s_caps)) {
  1909				cap = list_entry(session->s_caps.next,
  1910						 struct ceph_cap, session_caps);
  1911				if (cap == prev)
  1912					break;
  1913				prev = cap;
  1914				vino = cap->ci->i_vino;
  1915				spin_unlock(&session->s_cap_lock);
  1916	
  1917				inode = ceph_find_inode(sb, vino);
  1918				iput(inode);
  1919	
  1920				spin_lock(&session->s_cap_lock);
  1921			}
  1922		}
  1923	
  1924		// drop cap expires and unlock s_cap_lock
  1925		detach_cap_releases(session, &dispose);
  1926	
  1927		BUG_ON(session->s_nr_caps > 0);
  1928		BUG_ON(!list_empty(&session->s_cap_flushing));
  1929		spin_unlock(&session->s_cap_lock);
  1930		dispose_cap_releases(session->s_mdsc, &dispose);
  1931	}
  1932	
  1933	enum {
  1934		RECONNECT,
  1935		RENEWCAPS,
  1936		FORCE_RO,
  1937	};
  1938	
  1939	/*
  1940	 * wake up any threads waiting on this session's caps.  if the cap is
  1941	 * old (didn't get renewed on the client reconnect), remove it now.
  1942	 *
  1943	 * caller must hold s_mutex.
  1944	 */
  1945	static int wake_up_session_cb(struct inode *inode, struct rb_node *ci_node, void *arg)
  1946	{
  1947		struct ceph_inode_info *ci = ceph_inode(inode);
  1948		unsigned long ev = (unsigned long)arg;
  1949		struct ceph_cap *cap;
  1950	
  1951		if (ev == RECONNECT) {
  1952			spin_lock(&ci->i_ceph_lock);
  1953			ci->i_wanted_max_size = 0;
  1954			ci->i_requested_max_size = 0;
  1955			spin_unlock(&ci->i_ceph_lock);
  1956		} else if (ev == RENEWCAPS) {
> 1957			if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
  1958				/* mds did not re-issue stale cap */
  1959				spin_lock(&ci->i_ceph_lock);
  1960				cap = rb_entry(ci_node, struct ceph_cap, ci_node);
  1961				if (cap)
  1962					cap->issued = cap->implemented = CEPH_CAP_PIN;
  1963				spin_unlock(&ci->i_ceph_lock);
  1964			}
  1965		} else if (ev == FORCE_RO) {
  1966		}
  1967		wake_up_all(&ci->i_cap_wq);
  1968		return 0;
  1969	}
  1970	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
