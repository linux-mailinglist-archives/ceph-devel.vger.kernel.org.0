Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC473547A46
	for <lists+ceph-devel@lfdr.de>; Sun, 12 Jun 2022 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbiFLNKN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 12 Jun 2022 09:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiFLNKN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 12 Jun 2022 09:10:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3863617055
        for <ceph-devel@vger.kernel.org>; Sun, 12 Jun 2022 06:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655039410; x=1686575410;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=SxWO73rfdM9B0wT1nwNckaWx++odQfwK/5xeXVepsFo=;
  b=mxo7shT8UZYS/OVjKAA/oDzRyOwovL2WPlii9URxC7AI5Nbc4CUT7B/z
   ErHpvQF0vs4pUOlMIzwOiOUlOne/5GZGnp38iSsj0rgaD4bPPlmBvZF0I
   uXnzc5qJ24GwAQ1uGn2+R42yLPCDtlj7ePAnJBPe6ZtmBgMaHf0wat0VT
   Nar/BGxsa2l4OCUdaiVKemxLdfRpV/b5PvJT3ASlQEQTzx7n09cXHcp6g
   5h4OuOxvah4SZv/afI8n0wm+auRCoFwF66iKNS9QUQd3m+ZA8pnkhqqHI
   ExkHapQ4xJPjKwMSuXzeaYwY4PhT0rMDg0latrwNxS4/aMvKUyCgpcmaK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10375"; a="364372208"
X-IronPort-AV: E=Sophos;i="5.91,294,1647327600"; 
   d="scan'208";a="364372208"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2022 06:10:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,294,1647327600"; 
   d="scan'208";a="617133413"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 12 Jun 2022 06:10:08 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o0NLz-000Jw3-Ir;
        Sun, 12 Jun 2022 13:10:07 +0000
Date:   Sun, 12 Jun 2022 21:09:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:testing 7/14] fs/ceph/addr.c:125:9: error: implicit
 declaration of function 'VM_WARN_ON_FOLIO'; did you mean 'VM_WARN_ON_ONCE'?
Message-ID: <202206122152.diN4bDDL-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   3e303a58e3a89d254098138aa8488872bf73c9a4
commit: 00043f493521923e81e179ef2e01a47941b07ef2 [7/14] ceph: switch back to testing for NULL folio->private in ceph_dirty_folio
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220612/202206122152.diN4bDDL-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/ceph/ceph-client/commit/00043f493521923e81e179ef2e01a47941b07ef2
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 00043f493521923e81e179ef2e01a47941b07ef2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/ceph/addr.c: In function 'ceph_dirty_folio':
>> fs/ceph/addr.c:125:9: error: implicit declaration of function 'VM_WARN_ON_FOLIO'; did you mean 'VM_WARN_ON_ONCE'? [-Werror=implicit-function-declaration]
     125 |         VM_WARN_ON_FOLIO(folio->private, folio);
         |         ^~~~~~~~~~~~~~~~
         |         VM_WARN_ON_ONCE
   cc1: some warnings being treated as errors


vim +125 fs/ceph/addr.c

    74	
    75	/*
    76	 * Dirty a page.  Optimistically adjust accounting, on the assumption
    77	 * that we won't race with invalidate.  If we do, readjust.
    78	 */
    79	static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
    80	{
    81		struct inode *inode;
    82		struct ceph_inode_info *ci;
    83		struct ceph_snap_context *snapc;
    84	
    85		if (folio_test_dirty(folio)) {
    86			dout("%p dirty_folio %p idx %lu -- already dirty\n",
    87			     mapping->host, folio, folio->index);
    88			VM_BUG_ON_FOLIO(!folio_test_private(folio), folio);
    89			return false;
    90		}
    91	
    92		inode = mapping->host;
    93		ci = ceph_inode(inode);
    94	
    95		/* dirty the head */
    96		spin_lock(&ci->i_ceph_lock);
    97		BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
    98		if (__ceph_have_pending_cap_snap(ci)) {
    99			struct ceph_cap_snap *capsnap =
   100					list_last_entry(&ci->i_cap_snaps,
   101							struct ceph_cap_snap,
   102							ci_item);
   103			snapc = ceph_get_snap_context(capsnap->context);
   104			capsnap->dirty_pages++;
   105		} else {
   106			BUG_ON(!ci->i_head_snapc);
   107			snapc = ceph_get_snap_context(ci->i_head_snapc);
   108			++ci->i_wrbuffer_ref_head;
   109		}
   110		if (ci->i_wrbuffer_ref == 0)
   111			ihold(inode);
   112		++ci->i_wrbuffer_ref;
   113		dout("%p dirty_folio %p idx %lu head %d/%d -> %d/%d "
   114		     "snapc %p seq %lld (%d snaps)\n",
   115		     mapping->host, folio, folio->index,
   116		     ci->i_wrbuffer_ref-1, ci->i_wrbuffer_ref_head-1,
   117		     ci->i_wrbuffer_ref, ci->i_wrbuffer_ref_head,
   118		     snapc, snapc->seq, snapc->num_snaps);
   119		spin_unlock(&ci->i_ceph_lock);
   120	
   121		/*
   122		 * Reference snap context in folio->private.  Also set
   123		 * PagePrivate so that we get invalidate_folio callback.
   124		 */
 > 125		VM_WARN_ON_FOLIO(folio->private, folio);
   126		folio_attach_private(folio, snapc);
   127	
   128		return ceph_fscache_dirty_folio(mapping, folio);
   129	}
   130	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
