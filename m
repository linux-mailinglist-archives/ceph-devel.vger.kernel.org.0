Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C985538A5C
	for <lists+ceph-devel@lfdr.de>; Tue, 31 May 2022 06:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243794AbiEaEQA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 May 2022 00:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238733AbiEaEP6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 31 May 2022 00:15:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B67C91566
        for <ceph-devel@vger.kernel.org>; Mon, 30 May 2022 21:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653970557; x=1685506557;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=AdWhk0YV+Bw4YkbICtCWOaG9F1lFtTTM8nYZo7ceUZs=;
  b=GR13P5K6Rcp47Pq+lxrxKD0HnXPOgnwr03s4DXZJqozgo3MoG6M68tzz
   K7s1H82DBSfPqTNfVUWsY992Lg70YNoCNHdgduCy8co8yDZOLETu0wwoL
   OgmopxTWROsJrkxISyrQO4C1bX9Ro61lcCiQVKbUqZdS7T3MvBON0jLI0
   RHCDQ/O+5dn/ZF+SM3bNBjAr/KlVWw1mBomRaIuTz3ZwRNozy12C1c/AP
   F3sPbE6lMX11r6xS9MLkMTDLgZC4BXxr9EDZL3eVE+uItspizjub1Y4zU
   zPuIN3muqCb5nvkH1rn0pN6gl5gcuG/UnrT1cqKazr6jmPO5nYpk20ePi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="361508244"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="361508244"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 21:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="562146377"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 30 May 2022 21:15:55 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nvtIQ-0002JK-NW;
        Tue, 31 May 2022 04:15:54 +0000
Date:   Tue, 31 May 2022 12:15:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:wip-fscrypt 5/64] net/ceph/messenger_v2.c:1901:12:
 error: no member named 'last_piece' in 'struct ceph_msg_data_cursor'
Message-ID: <202205311253.o3ML3KvU-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git wip-fscrypt
head:   4a13fcc148c64143afe231bd0cae743b89c70177
commit: 9cccd01a922c653e8e75968b6c0ee15de74d8931 [5/64] libceph: add sparse read support to msgr2 crc state machine
config: arm64-buildonly-randconfig-r002-20220531 (https://download.01.org/0day-ci/archive/20220531/202205311253.o3ML3KvU-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/ceph/ceph-client/commit/9cccd01a922c653e8e75968b6c0ee15de74d8931
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client wip-fscrypt
        git checkout 9cccd01a922c653e8e75968b6c0ee15de74d8931
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash net/ceph/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/ceph/messenger_v2.c:1901:12: error: no member named 'last_piece' in 'struct ceph_msg_data_cursor'
                           cursor->last_piece);
                           ~~~~~~  ^
   include/linux/printk.h:499:37: note: expanded from macro 'pr_warn'
           printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
                                              ^~~~~~~~~~~
   include/linux/printk.h:446:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                              ^~~~~~~~~~~
   include/linux/printk.h:418:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                                   ^~~~~~~~~~~
   1 error generated.


vim +1901 net/ceph/messenger_v2.c

  1823	
  1824	static int prepare_sparse_read_cont(struct ceph_connection *con)
  1825	{
  1826		int ret;
  1827		struct bio_vec bv;
  1828		char *buf = NULL;
  1829		struct ceph_msg_data_cursor *cursor = &con->v2.in_cursor;
  1830	
  1831		WARN_ON(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_CONT);
  1832	
  1833		if (iov_iter_is_bvec(&con->v2.in_iter)) {
  1834			if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
  1835				con->in_data_crc = crc32c(con->in_data_crc,
  1836							  page_address(con->bounce_page),
  1837							  con->v2.in_bvec.bv_len);
  1838				get_bvec_at(cursor, &bv);
  1839				memcpy_to_page(bv.bv_page, bv.bv_offset,
  1840					       page_address(con->bounce_page),
  1841					       con->v2.in_bvec.bv_len);
  1842			} else {
  1843				con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
  1844								    con->v2.in_bvec.bv_page,
  1845								    con->v2.in_bvec.bv_offset,
  1846								    con->v2.in_bvec.bv_len);
  1847			}
  1848	
  1849			ceph_msg_data_advance(cursor, con->v2.in_bvec.bv_len);
  1850			cursor->sr_resid -= con->v2.in_bvec.bv_len;
  1851			dout("%s: advance by 0x%x sr_resid 0x%x\n", __func__,
  1852			     con->v2.in_bvec.bv_len, cursor->sr_resid);
  1853			WARN_ON_ONCE(cursor->sr_resid > cursor->total_resid);
  1854			if (cursor->sr_resid) {
  1855				get_bvec_at(cursor, &bv);
  1856				if (bv.bv_len > cursor->sr_resid)
  1857					bv.bv_len = cursor->sr_resid;
  1858				if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
  1859					bv.bv_page = con->bounce_page;
  1860					bv.bv_offset = 0;
  1861				}
  1862				set_in_bvec(con, &bv);
  1863				con->v2.data_len_remain -= bv.bv_len;
  1864				return 0;
  1865			}
  1866		} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
  1867			/* On first call, we have no kvec so don't compute crc */
  1868			if (con->v2.in_kvec_cnt) {
  1869				WARN_ON_ONCE(con->v2.in_kvec_cnt > 1);
  1870				con->in_data_crc = crc32c(con->in_data_crc,
  1871							  con->v2.in_kvecs[0].iov_base,
  1872							  con->v2.in_kvecs[0].iov_len);
  1873			}
  1874		} else {
  1875			return -EIO;
  1876		}
  1877	
  1878		/* get next extent */
  1879		ret = con->ops->sparse_read(con, cursor, &buf);
  1880		if (ret <= 0) {
  1881			if (ret < 0)
  1882				return ret;
  1883	
  1884			reset_in_kvecs(con);
  1885			add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
  1886			con->v2.in_state = IN_S_HANDLE_EPILOGUE;
  1887			return 0;
  1888		}
  1889	
  1890		if (buf) {
  1891			/* receive into buffer */
  1892			reset_in_kvecs(con);
  1893			add_in_kvec(con, buf, ret);
  1894			con->v2.data_len_remain -= ret;
  1895			return 0;
  1896		}
  1897	
  1898		if (ret > cursor->total_resid) {
  1899			pr_warn("%s: ret 0x%x total_resid 0x%zx resid 0x%zx last %d\n",
  1900				__func__, ret, cursor->total_resid, cursor->resid,
> 1901				cursor->last_piece);
  1902			return -EIO;
  1903		}
  1904		get_bvec_at(cursor, &bv);
  1905		if (bv.bv_len > cursor->sr_resid)
  1906			bv.bv_len = cursor->sr_resid;
  1907		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
  1908			if (unlikely(!con->bounce_page)) {
  1909				con->bounce_page = alloc_page(GFP_NOIO);
  1910				if (!con->bounce_page) {
  1911					pr_err("failed to allocate bounce page\n");
  1912					return -ENOMEM;
  1913				}
  1914			}
  1915	
  1916			bv.bv_page = con->bounce_page;
  1917			bv.bv_offset = 0;
  1918		}
  1919		set_in_bvec(con, &bv);
  1920		con->v2.data_len_remain -= ret;
  1921		return ret;
  1922	}
  1923	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
