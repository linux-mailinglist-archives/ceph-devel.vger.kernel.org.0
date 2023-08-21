Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88B87829E6
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Aug 2023 15:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbjHUNEk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Aug 2023 09:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbjHUNEk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Aug 2023 09:04:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D9ED1
        for <ceph-devel@vger.kernel.org>; Mon, 21 Aug 2023 06:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692623076; x=1724159076;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=9+jeni15yFVJo+yYmKNq7jEt3xhp7Y9ojBWKnFOKBUM=;
  b=ULGgKwMMsFhVI+9bLzPJyP6A3tJO3UjZI3P/xqxfhlsKQFuMPBniA5/h
   3rzbnKuV7CapnJFXc/Gtjaj3IBi/49G7jLxVDEK8+9iL+qkDXWQ9/zo++
   JhZGvnSfZ0tpiqofEjzKB/KfBijPVQv2mNhJDsllQYOLsSVeAjYja4DfM
   6vC/ngBoIWWZZzPMd99w+KgX6e92wbEJzUuZTMxfVOX0nc8AT1qy9p+Uc
   fZK39BqCIXHg4EmHdSZC7BYjeUGDa9M2nTIKCd5m+NuKfYLRwcxNW93gN
   8MxC0nk8oiKSNCbwWXf/1e6lJomHXs6Z1mpg0SBwqGUOCQ1gzfl3O1oaI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="373554351"
X-IronPort-AV: E=Sophos;i="6.01,190,1684825200"; 
   d="scan'208";a="373554351"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 06:04:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="729425281"
X-IronPort-AV: E=Sophos;i="6.01,190,1684825200"; 
   d="scan'208";a="729425281"
Received: from lkp-server02.sh.intel.com (HELO 6809aa828f2a) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 21 Aug 2023 06:04:18 -0700
Received: from kbuild by 6809aa828f2a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qY4Zt-0000VC-2n;
        Mon, 21 Aug 2023 13:04:17 +0000
Date:   Mon, 21 Aug 2023 21:03:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [ceph-client:testing 78/96] fs/ceph/mds_client.c:2639: warning:
 Function parameter or member 'mdsc' not described in 'ceph_mdsc_build_path'
Message-ID: <202308212002.IYVp010T-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   a7fb1265323db972dd333f71b9a53e9479f62e37
commit: 7072b2e8839b81f9781603bd2c5e40c9ccd13f6a [78/96] ceph: pass the mdsc to several helpers
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20230821/202308212002.IYVp010T-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230821/202308212002.IYVp010T-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308212002.IYVp010T-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/ceph/mds_client.c:2639: warning: Function parameter or member 'mdsc' not described in 'ceph_mdsc_build_path'


vim +2639 fs/ceph/mds_client.c

5d7efc49126a6d Jeff Layton    2021-01-14  2616  
0874db5f86bc5b Jeff Layton    2020-08-07  2617  /**
0874db5f86bc5b Jeff Layton    2020-08-07  2618   * ceph_mdsc_build_path - build a path string to a given dentry
0874db5f86bc5b Jeff Layton    2020-08-07  2619   * @dentry: dentry to which path should be built
0874db5f86bc5b Jeff Layton    2020-08-07  2620   * @plen: returned length of string
0874db5f86bc5b Jeff Layton    2020-08-07  2621   * @pbase: returned base inode number
0874db5f86bc5b Jeff Layton    2020-08-07  2622   * @for_wire: is this path going to be sent to the MDS?
0874db5f86bc5b Jeff Layton    2020-08-07  2623   *
0874db5f86bc5b Jeff Layton    2020-08-07  2624   * Build a string that represents the path to the dentry. This is mostly called
0874db5f86bc5b Jeff Layton    2020-08-07  2625   * for two different purposes:
0874db5f86bc5b Jeff Layton    2020-08-07  2626   *
0874db5f86bc5b Jeff Layton    2020-08-07  2627   * 1) we need to build a path string to send to the MDS (for_wire == true)
0874db5f86bc5b Jeff Layton    2020-08-07  2628   * 2) we need a path string for local presentation (e.g. debugfs) (for_wire == false)
2f2dc053404feb Sage Weil      2009-10-06  2629   *
0874db5f86bc5b Jeff Layton    2020-08-07  2630   * The path is built in reverse, starting with the dentry. Walk back up toward
0874db5f86bc5b Jeff Layton    2020-08-07  2631   * the root, building the path until the first non-snapped inode is reached (for_wire)
0874db5f86bc5b Jeff Layton    2020-08-07  2632   * or the root inode is reached (!for_wire).
2f2dc053404feb Sage Weil      2009-10-06  2633   *
2f2dc053404feb Sage Weil      2009-10-06  2634   * Encode hidden .snap dirs as a double /, i.e.
2f2dc053404feb Sage Weil      2009-10-06  2635   *   foo/.snap/bar -> foo//bar
2f2dc053404feb Sage Weil      2009-10-06  2636   */
7072b2e8839b81 Xiubo Li       2023-06-09  2637  char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
7072b2e8839b81 Xiubo Li       2023-06-09  2638  			   int *plen, u64 *pbase, int for_wire)
2f2dc053404feb Sage Weil      2009-10-06 @2639  {
1b82f60fdbf92e Jeff Layton    2020-08-05  2640  	struct dentry *cur;
1b82f60fdbf92e Jeff Layton    2020-08-05  2641  	struct inode *inode;
2f2dc053404feb Sage Weil      2009-10-06  2642  	char *path;
f77f21bb28367d Jeff Layton    2019-04-29  2643  	int pos;
1b71fe2efa31cd Al Viro        2011-07-16  2644  	unsigned seq;
69a10fb3f4b876 Jeff Layton    2019-04-26  2645  	u64 base;
2f2dc053404feb Sage Weil      2009-10-06  2646  
d37b1d9943d513 Markus Elfring 2017-08-20  2647  	if (!dentry)
2f2dc053404feb Sage Weil      2009-10-06  2648  		return ERR_PTR(-EINVAL);
2f2dc053404feb Sage Weil      2009-10-06  2649  
f77f21bb28367d Jeff Layton    2019-04-29  2650  	path = __getname();
d37b1d9943d513 Markus Elfring 2017-08-20  2651  	if (!path)
2f2dc053404feb Sage Weil      2009-10-06  2652  		return ERR_PTR(-ENOMEM);
f77f21bb28367d Jeff Layton    2019-04-29  2653  retry:
f77f21bb28367d Jeff Layton    2019-04-29  2654  	pos = PATH_MAX - 1;
f77f21bb28367d Jeff Layton    2019-04-29  2655  	path[pos] = '\0';
f77f21bb28367d Jeff Layton    2019-04-29  2656  
f77f21bb28367d Jeff Layton    2019-04-29  2657  	seq = read_seqbegin(&rename_lock);
1b82f60fdbf92e Jeff Layton    2020-08-05  2658  	cur = dget(dentry);
f77f21bb28367d Jeff Layton    2019-04-29  2659  	for (;;) {
0874db5f86bc5b Jeff Layton    2020-08-07  2660  		struct dentry *parent;
2f2dc053404feb Sage Weil      2009-10-06  2661  
1b82f60fdbf92e Jeff Layton    2020-08-05  2662  		spin_lock(&cur->d_lock);
1b82f60fdbf92e Jeff Layton    2020-08-05  2663  		inode = d_inode(cur);
2f2dc053404feb Sage Weil      2009-10-06  2664  		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
104648ad3f2ebe Sage Weil      2010-03-18  2665  			dout("build_path path+%d: %p SNAPDIR\n",
1b82f60fdbf92e Jeff Layton    2020-08-05  2666  			     pos, cur);
0874db5f86bc5b Jeff Layton    2020-08-07  2667  			spin_unlock(&cur->d_lock);
0874db5f86bc5b Jeff Layton    2020-08-07  2668  			parent = dget_parent(cur);
0874db5f86bc5b Jeff Layton    2020-08-07  2669  		} else if (for_wire && inode && dentry != cur && ceph_snap(inode) == CEPH_NOSNAP) {
1b82f60fdbf92e Jeff Layton    2020-08-05  2670  			spin_unlock(&cur->d_lock);
d6b8bd679c9c88 Jeff Layton    2019-05-09  2671  			pos++; /* get rid of any prepended '/' */
2f2dc053404feb Sage Weil      2009-10-06  2672  			break;
0874db5f86bc5b Jeff Layton    2020-08-07  2673  		} else if (!for_wire || !IS_ENCRYPTED(d_inode(cur->d_parent))) {
1b82f60fdbf92e Jeff Layton    2020-08-05  2674  			pos -= cur->d_name.len;
1b71fe2efa31cd Al Viro        2011-07-16  2675  			if (pos < 0) {
1b82f60fdbf92e Jeff Layton    2020-08-05  2676  				spin_unlock(&cur->d_lock);
2f2dc053404feb Sage Weil      2009-10-06  2677  				break;
1b71fe2efa31cd Al Viro        2011-07-16  2678  			}
1b82f60fdbf92e Jeff Layton    2020-08-05  2679  			memcpy(path + pos, cur->d_name.name, cur->d_name.len);
0874db5f86bc5b Jeff Layton    2020-08-07  2680  			spin_unlock(&cur->d_lock);
0874db5f86bc5b Jeff Layton    2020-08-07  2681  			parent = dget_parent(cur);
0874db5f86bc5b Jeff Layton    2020-08-07  2682  		} else {
0874db5f86bc5b Jeff Layton    2020-08-07  2683  			int len, ret;
0874db5f86bc5b Jeff Layton    2020-08-07  2684  			char buf[NAME_MAX];
0874db5f86bc5b Jeff Layton    2020-08-07  2685  
0874db5f86bc5b Jeff Layton    2020-08-07  2686  			/*
0874db5f86bc5b Jeff Layton    2020-08-07  2687  			 * Proactively copy name into buf, in case we need to present
0874db5f86bc5b Jeff Layton    2020-08-07  2688  			 * it as-is.
0874db5f86bc5b Jeff Layton    2020-08-07  2689  			 */
0874db5f86bc5b Jeff Layton    2020-08-07  2690  			memcpy(buf, cur->d_name.name, cur->d_name.len);
0874db5f86bc5b Jeff Layton    2020-08-07  2691  			len = cur->d_name.len;
0874db5f86bc5b Jeff Layton    2020-08-07  2692  			spin_unlock(&cur->d_lock);
0874db5f86bc5b Jeff Layton    2020-08-07  2693  			parent = dget_parent(cur);
0874db5f86bc5b Jeff Layton    2020-08-07  2694  
97142624013d56 Luís Henriques 2022-11-29  2695  			ret = ceph_fscrypt_prepare_readdir(d_inode(parent));
0874db5f86bc5b Jeff Layton    2020-08-07  2696  			if (ret < 0) {
0874db5f86bc5b Jeff Layton    2020-08-07  2697  				dput(parent);
0874db5f86bc5b Jeff Layton    2020-08-07  2698  				dput(cur);
0874db5f86bc5b Jeff Layton    2020-08-07  2699  				return ERR_PTR(ret);
0874db5f86bc5b Jeff Layton    2020-08-07  2700  			}
0874db5f86bc5b Jeff Layton    2020-08-07  2701  
0874db5f86bc5b Jeff Layton    2020-08-07  2702  			if (fscrypt_has_encryption_key(d_inode(parent))) {
0874db5f86bc5b Jeff Layton    2020-08-07  2703  				len = ceph_encode_encrypted_fname(d_inode(parent), cur, buf);
0874db5f86bc5b Jeff Layton    2020-08-07  2704  				if (len < 0) {
0874db5f86bc5b Jeff Layton    2020-08-07  2705  					dput(parent);
0874db5f86bc5b Jeff Layton    2020-08-07  2706  					dput(cur);
0874db5f86bc5b Jeff Layton    2020-08-07  2707  					return ERR_PTR(len);
2f2dc053404feb Sage Weil      2009-10-06  2708  				}
0874db5f86bc5b Jeff Layton    2020-08-07  2709  			}
0874db5f86bc5b Jeff Layton    2020-08-07  2710  			pos -= len;
0874db5f86bc5b Jeff Layton    2020-08-07  2711  			if (pos < 0) {
0874db5f86bc5b Jeff Layton    2020-08-07  2712  				dput(parent);
0874db5f86bc5b Jeff Layton    2020-08-07  2713  				break;
0874db5f86bc5b Jeff Layton    2020-08-07  2714  			}
0874db5f86bc5b Jeff Layton    2020-08-07  2715  			memcpy(path + pos, buf, len);
0874db5f86bc5b Jeff Layton    2020-08-07  2716  		}
0874db5f86bc5b Jeff Layton    2020-08-07  2717  		dput(cur);
0874db5f86bc5b Jeff Layton    2020-08-07  2718  		cur = parent;
f77f21bb28367d Jeff Layton    2019-04-29  2719  
f77f21bb28367d Jeff Layton    2019-04-29  2720  		/* Are we at the root? */
1b82f60fdbf92e Jeff Layton    2020-08-05  2721  		if (IS_ROOT(cur))
f77f21bb28367d Jeff Layton    2019-04-29  2722  			break;
f77f21bb28367d Jeff Layton    2019-04-29  2723  
f77f21bb28367d Jeff Layton    2019-04-29  2724  		/* Are we out of buffer? */
f77f21bb28367d Jeff Layton    2019-04-29  2725  		if (--pos < 0)
f77f21bb28367d Jeff Layton    2019-04-29  2726  			break;
f77f21bb28367d Jeff Layton    2019-04-29  2727  
f77f21bb28367d Jeff Layton    2019-04-29  2728  		path[pos] = '/';
2f2dc053404feb Sage Weil      2009-10-06  2729  	}
1b82f60fdbf92e Jeff Layton    2020-08-05  2730  	inode = d_inode(cur);
1b82f60fdbf92e Jeff Layton    2020-08-05  2731  	base = inode ? ceph_ino(inode) : 0;
1b82f60fdbf92e Jeff Layton    2020-08-05  2732  	dput(cur);
f5946bcc5e7903 Jeff Layton    2019-10-16  2733  
f5946bcc5e7903 Jeff Layton    2019-10-16  2734  	if (read_seqretry(&rename_lock, seq))
f5946bcc5e7903 Jeff Layton    2019-10-16  2735  		goto retry;
f5946bcc5e7903 Jeff Layton    2019-10-16  2736  
f5946bcc5e7903 Jeff Layton    2019-10-16  2737  	if (pos < 0) {
f5946bcc5e7903 Jeff Layton    2019-10-16  2738  		/*
f5946bcc5e7903 Jeff Layton    2019-10-16  2739  		 * A rename didn't occur, but somehow we didn't end up where
f5946bcc5e7903 Jeff Layton    2019-10-16  2740  		 * we thought we would. Throw a warning and try again.
f5946bcc5e7903 Jeff Layton    2019-10-16  2741  		 */
0874db5f86bc5b Jeff Layton    2020-08-07  2742  		pr_warn("build_path did not end path lookup where expected (pos = %d)\n", pos);
2f2dc053404feb Sage Weil      2009-10-06  2743  		goto retry;
2f2dc053404feb Sage Weil      2009-10-06  2744  	}
2f2dc053404feb Sage Weil      2009-10-06  2745  
69a10fb3f4b876 Jeff Layton    2019-04-26  2746  	*pbase = base;
f77f21bb28367d Jeff Layton    2019-04-29  2747  	*plen = PATH_MAX - 1 - pos;
104648ad3f2ebe Sage Weil      2010-03-18  2748  	dout("build_path on %p %d built %llx '%.*s'\n",
f77f21bb28367d Jeff Layton    2019-04-29  2749  	     dentry, d_count(dentry), base, *plen, path + pos);
f77f21bb28367d Jeff Layton    2019-04-29  2750  	return path + pos;
2f2dc053404feb Sage Weil      2009-10-06  2751  }
2f2dc053404feb Sage Weil      2009-10-06  2752  

:::::: The code at line 2639 was first introduced by commit
:::::: 2f2dc053404febedc9c273452d9d518fb31fde72 ceph: MDS client

:::::: TO: Sage Weil <sage@newdream.net>
:::::: CC: Sage Weil <sage@newdream.net>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
