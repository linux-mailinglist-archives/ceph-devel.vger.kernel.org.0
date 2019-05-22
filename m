Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6110A260C3
	for <lists+ceph-devel@lfdr.de>; Wed, 22 May 2019 11:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfEVJx3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 May 2019 05:53:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbfEVJx3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 May 2019 05:53:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4M9jjSJ191960;
        Wed, 22 May 2019 09:53:17 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2smsk52ks6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 09:53:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4M9phKV166948;
        Wed, 22 May 2019 09:53:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2smsgurmj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 09:53:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4M9rFxi022333;
        Wed, 22 May 2019 09:53:16 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 May 2019 09:53:14 +0000
Date:   Wed, 22 May 2019 12:53:08 +0300
From:   kbuild test robot <lkp@intel.com>
To:     kbuild@01.org, "Yan, Zheng" <zyan@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild-all@01.org,
        ceph-devel@vger.kernel.org
Subject: [ceph-client:testing 8/10] fs/ceph/inode.c:1750
 ceph_queue_writeback() warn: test_bit() takes a bit number
Message-ID: <20190522095308.GL19380@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220071
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   a5db6917595a6315a57f7d1aa20973f9ddc2b14f
commit: 33c573a5cd46325e562e4195d1ff390e4c76cb8b [8/10] ceph: single workqueue for inode related works

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
fs/ceph/inode.c:1750 ceph_queue_writeback() warn: test_bit() takes a bit number
fs/ceph/inode.c:1769 ceph_queue_invalidate() warn: test_bit() takes a bit number
fs/ceph/inode.c:1789 ceph_queue_vmtruncate() warn: test_bit() takes a bit number
fs/ceph/inode.c:1925 ceph_inode_work() warn: test_bit() takes a bit number

Old smatch warnings:
fs/ceph/inode.c:1929 ceph_inode_work() warn: test_bit() takes a bit number
fs/ceph/inode.c:1932 ceph_inode_work() warn: test_bit() takes a bit number

# https://github.com/ceph/ceph-client/commit/33c573a5cd46325e562e4195d1ff390e4c76cb8b
git remote add ceph-client https://github.com/ceph/ceph-client.git
git remote update ceph-client
git checkout 33c573a5cd46325e562e4195d1ff390e4c76cb8b
vim +1750 fs/ceph/inode.c

355da1eb7 Sage Weil           2009-10-06  1743  /*
355da1eb7 Sage Weil           2009-10-06  1744   * Write back inode data in a worker thread.  (This can't be done
355da1eb7 Sage Weil           2009-10-06  1745   * in the message handler context.)
355da1eb7 Sage Weil           2009-10-06  1746   */
3c6f6b79a Sage Weil           2010-02-09  1747  void ceph_queue_writeback(struct inode *inode)
3c6f6b79a Sage Weil           2010-02-09  1748  {
33c573a5c Yan, Zheng          2019-05-18  1749  	struct ceph_inode_info *ci = ceph_inode(inode);
33c573a5c Yan, Zheng          2019-05-18 @1750  	set_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask);
                                                                ^^^^^^^^^^^^^^^^^^^^^
Without looking at the git tree, my guess is that CEPH_I_WORK_WRITEBACK
is a BIT(something) so it's a double shift bug.

33c573a5c Yan, Zheng          2019-05-18  1751  
15a2015fb Sage Weil           2011-11-05  1752  	ihold(inode);
33c573a5c Yan, Zheng          2019-05-18  1753  	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
33c573a5c Yan, Zheng          2019-05-18  1754  		       &ci->i_work)) {
2c27c9a57 Sage Weil           2010-02-17  1755  		dout("ceph_queue_writeback %p\n", inode);
3c6f6b79a Sage Weil           2010-02-09  1756  	} else {
33c573a5c Yan, Zheng          2019-05-18  1757  		dout("ceph_queue_writeback %p already queued, mask=%lx\n",
33c573a5c Yan, Zheng          2019-05-18  1758  		     inode, ci->i_work_mask);
15a2015fb Sage Weil           2011-11-05  1759  		iput(inode);
3c6f6b79a Sage Weil           2010-02-09  1760  	}
3c6f6b79a Sage Weil           2010-02-09  1761  }
3c6f6b79a Sage Weil           2010-02-09  1762  
355da1eb7 Sage Weil           2009-10-06  1763  /*
3c6f6b79a Sage Weil           2010-02-09  1764   * queue an async invalidation
3c6f6b79a Sage Weil           2010-02-09  1765   */
3c6f6b79a Sage Weil           2010-02-09  1766  void ceph_queue_invalidate(struct inode *inode)
3c6f6b79a Sage Weil           2010-02-09  1767  {
33c573a5c Yan, Zheng          2019-05-18  1768  	struct ceph_inode_info *ci = ceph_inode(inode);
33c573a5c Yan, Zheng          2019-05-18 @1769  	set_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask);
33c573a5c Yan, Zheng          2019-05-18  1770  
15a2015fb Sage Weil           2011-11-05  1771  	ihold(inode);
33c573a5c Yan, Zheng          2019-05-18  1772  	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
33c573a5c Yan, Zheng          2019-05-18  1773  		       &ceph_inode(inode)->i_work)) {
3c6f6b79a Sage Weil           2010-02-09  1774  		dout("ceph_queue_invalidate %p\n", inode);
3c6f6b79a Sage Weil           2010-02-09  1775  	} else {
33c573a5c Yan, Zheng          2019-05-18  1776  		dout("ceph_queue_invalidate %p already queued, mask=%lx\n",
33c573a5c Yan, Zheng          2019-05-18  1777  		     inode, ci->i_work_mask);
15a2015fb Sage Weil           2011-11-05  1778  		iput(inode);
3c6f6b79a Sage Weil           2010-02-09  1779  	}
3c6f6b79a Sage Weil           2010-02-09  1780  }
3c6f6b79a Sage Weil           2010-02-09  1781  
3c6f6b79a Sage Weil           2010-02-09  1782  /*
33c573a5c Yan, Zheng          2019-05-18  1783   * Queue an async vmtruncate.  If we fail to queue work, we will handle
33c573a5c Yan, Zheng          2019-05-18  1784   * the truncation the next time we call __ceph_do_pending_vmtruncate.
355da1eb7 Sage Weil           2009-10-06  1785   */
33c573a5c Yan, Zheng          2019-05-18  1786  void ceph_queue_vmtruncate(struct inode *inode)
355da1eb7 Sage Weil           2009-10-06  1787  {
33c573a5c Yan, Zheng          2019-05-18  1788  	struct ceph_inode_info *ci = ceph_inode(inode);
33c573a5c Yan, Zheng          2019-05-18 @1789  	set_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask);
33c573a5c Yan, Zheng          2019-05-18  1790  
33c573a5c Yan, Zheng          2019-05-18  1791  	ihold(inode);
33c573a5c Yan, Zheng          2019-05-18  1792  	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
33c573a5c Yan, Zheng          2019-05-18  1793  		       &ci->i_work)) {
33c573a5c Yan, Zheng          2019-05-18  1794  		dout("ceph_queue_vmtruncate %p\n", inode);
33c573a5c Yan, Zheng          2019-05-18  1795  	} else {
33c573a5c Yan, Zheng          2019-05-18  1796  		dout("ceph_queue_vmtruncate %p already queued, mask=%lx\n",
33c573a5c Yan, Zheng          2019-05-18  1797  		     inode, ci->i_work_mask);
33c573a5c Yan, Zheng          2019-05-18  1798  		iput(inode);
33c573a5c Yan, Zheng          2019-05-18  1799  	}
33c573a5c Yan, Zheng          2019-05-18  1800  }
33c573a5c Yan, Zheng          2019-05-18  1801  
33c573a5c Yan, Zheng          2019-05-18  1802  static void ceph_do_invalidate_pages(struct inode *inode)
33c573a5c Yan, Zheng          2019-05-18  1803  {
33c573a5c Yan, Zheng          2019-05-18  1804  	struct ceph_inode_info *ci = ceph_inode(inode);
6c93df5db Yan, Zheng          2016-04-15  1805  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
355da1eb7 Sage Weil           2009-10-06  1806  	u32 orig_gen;
355da1eb7 Sage Weil           2009-10-06  1807  	int check = 0;
355da1eb7 Sage Weil           2009-10-06  1808  
b0d7c2231 Yan, Zheng          2013-08-12  1809  	mutex_lock(&ci->i_truncate_mutex);
6c93df5db Yan, Zheng          2016-04-15  1810  
52953d559 Seraphime Kirkovski 2016-12-26  1811  	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
6c93df5db Yan, Zheng          2016-04-15  1812  		pr_warn_ratelimited("invalidate_pages %p %lld forced umount\n",
6c93df5db Yan, Zheng          2016-04-15  1813  				    inode, ceph_ino(inode));
6c93df5db Yan, Zheng          2016-04-15  1814  		mapping_set_error(inode->i_mapping, -EIO);
6c93df5db Yan, Zheng          2016-04-15  1815  		truncate_pagecache(inode, 0);
6c93df5db Yan, Zheng          2016-04-15  1816  		mutex_unlock(&ci->i_truncate_mutex);
6c93df5db Yan, Zheng          2016-04-15  1817  		goto out;
6c93df5db Yan, Zheng          2016-04-15  1818  	}
6c93df5db Yan, Zheng          2016-04-15  1819  
be655596b Sage Weil           2011-11-30  1820  	spin_lock(&ci->i_ceph_lock);
355da1eb7 Sage Weil           2009-10-06  1821  	dout("invalidate_pages %p gen %d revoking %d\n", inode,
355da1eb7 Sage Weil           2009-10-06  1822  	     ci->i_rdcache_gen, ci->i_rdcache_revoking);
cd045cb42 Sage Weil           2010-11-04  1823  	if (ci->i_rdcache_revoking != ci->i_rdcache_gen) {
9563f88c1 Yan, Zheng          2013-11-22  1824  		if (__ceph_caps_revoking_other(ci, NULL, CEPH_CAP_FILE_CACHE))
9563f88c1 Yan, Zheng          2013-11-22  1825  			check = 1;
be655596b Sage Weil           2011-11-30  1826  		spin_unlock(&ci->i_ceph_lock);
b0d7c2231 Yan, Zheng          2013-08-12  1827  		mutex_unlock(&ci->i_truncate_mutex);
355da1eb7 Sage Weil           2009-10-06  1828  		goto out;
355da1eb7 Sage Weil           2009-10-06  1829  	}
355da1eb7 Sage Weil           2009-10-06  1830  	orig_gen = ci->i_rdcache_gen;
be655596b Sage Weil           2011-11-30  1831  	spin_unlock(&ci->i_ceph_lock);
355da1eb7 Sage Weil           2009-10-06  1832  
9abd4db71 Yan, Zheng          2016-05-18  1833  	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
9abd4db71 Yan, Zheng          2016-05-18  1834  		pr_err("invalidate_pages %p fails\n", inode);
9abd4db71 Yan, Zheng          2016-05-18  1835  	}
355da1eb7 Sage Weil           2009-10-06  1836  
be655596b Sage Weil           2011-11-30  1837  	spin_lock(&ci->i_ceph_lock);
cd045cb42 Sage Weil           2010-11-04  1838  	if (orig_gen == ci->i_rdcache_gen &&
cd045cb42 Sage Weil           2010-11-04  1839  	    orig_gen == ci->i_rdcache_revoking) {
355da1eb7 Sage Weil           2009-10-06  1840  		dout("invalidate_pages %p gen %d successful\n", inode,
355da1eb7 Sage Weil           2009-10-06  1841  		     ci->i_rdcache_gen);
cd045cb42 Sage Weil           2010-11-04  1842  		ci->i_rdcache_revoking--;
355da1eb7 Sage Weil           2009-10-06  1843  		check = 1;
355da1eb7 Sage Weil           2009-10-06  1844  	} else {
cd045cb42 Sage Weil           2010-11-04  1845  		dout("invalidate_pages %p gen %d raced, now %d revoking %d\n",
cd045cb42 Sage Weil           2010-11-04  1846  		     inode, orig_gen, ci->i_rdcache_gen,
cd045cb42 Sage Weil           2010-11-04  1847  		     ci->i_rdcache_revoking);
9563f88c1 Yan, Zheng          2013-11-22  1848  		if (__ceph_caps_revoking_other(ci, NULL, CEPH_CAP_FILE_CACHE))
9563f88c1 Yan, Zheng          2013-11-22  1849  			check = 1;
355da1eb7 Sage Weil           2009-10-06  1850  	}
be655596b Sage Weil           2011-11-30  1851  	spin_unlock(&ci->i_ceph_lock);
b0d7c2231 Yan, Zheng          2013-08-12  1852  	mutex_unlock(&ci->i_truncate_mutex);
9563f88c1 Yan, Zheng          2013-11-22  1853  out:
355da1eb7 Sage Weil           2009-10-06  1854  	if (check)
355da1eb7 Sage Weil           2009-10-06  1855  		ceph_check_caps(ci, 0, NULL);
3c6f6b79a Sage Weil           2010-02-09  1856  }
3c6f6b79a Sage Weil           2010-02-09  1857  
3c6f6b79a Sage Weil           2010-02-09  1858  /*
355da1eb7 Sage Weil           2009-10-06  1859   * Make sure any pending truncation is applied before doing anything
355da1eb7 Sage Weil           2009-10-06  1860   * that may depend on it.
355da1eb7 Sage Weil           2009-10-06  1861   */
b415bf4f9 Yan, Zheng          2013-07-02  1862  void __ceph_do_pending_vmtruncate(struct inode *inode)
355da1eb7 Sage Weil           2009-10-06  1863  {
355da1eb7 Sage Weil           2009-10-06  1864  	struct ceph_inode_info *ci = ceph_inode(inode);
355da1eb7 Sage Weil           2009-10-06  1865  	u64 to;
a85f50b6e Yan, Zheng          2012-11-19  1866  	int wrbuffer_refs, finish = 0;
355da1eb7 Sage Weil           2009-10-06  1867  
b0d7c2231 Yan, Zheng          2013-08-12  1868  	mutex_lock(&ci->i_truncate_mutex);
355da1eb7 Sage Weil           2009-10-06  1869  retry:
be655596b Sage Weil           2011-11-30  1870  	spin_lock(&ci->i_ceph_lock);
355da1eb7 Sage Weil           2009-10-06  1871  	if (ci->i_truncate_pending == 0) {
355da1eb7 Sage Weil           2009-10-06  1872  		dout("__do_pending_vmtruncate %p none pending\n", inode);
be655596b Sage Weil           2011-11-30  1873  		spin_unlock(&ci->i_ceph_lock);
b0d7c2231 Yan, Zheng          2013-08-12  1874  		mutex_unlock(&ci->i_truncate_mutex);
355da1eb7 Sage Weil           2009-10-06  1875  		return;
355da1eb7 Sage Weil           2009-10-06  1876  	}
355da1eb7 Sage Weil           2009-10-06  1877  
355da1eb7 Sage Weil           2009-10-06  1878  	/*
355da1eb7 Sage Weil           2009-10-06  1879  	 * make sure any dirty snapped pages are flushed before we
355da1eb7 Sage Weil           2009-10-06  1880  	 * possibly truncate them.. so write AND block!
355da1eb7 Sage Weil           2009-10-06  1881  	 */
355da1eb7 Sage Weil           2009-10-06  1882  	if (ci->i_wrbuffer_ref_head < ci->i_wrbuffer_ref) {
c8fd0d37f Yan, Zheng          2017-08-28  1883  		spin_unlock(&ci->i_ceph_lock);
355da1eb7 Sage Weil           2009-10-06  1884  		dout("__do_pending_vmtruncate %p flushing snaps first\n",
355da1eb7 Sage Weil           2009-10-06  1885  		     inode);
355da1eb7 Sage Weil           2009-10-06  1886  		filemap_write_and_wait_range(&inode->i_data, 0,
355da1eb7 Sage Weil           2009-10-06  1887  					     inode->i_sb->s_maxbytes);
355da1eb7 Sage Weil           2009-10-06  1888  		goto retry;
355da1eb7 Sage Weil           2009-10-06  1889  	}
355da1eb7 Sage Weil           2009-10-06  1890  
b0d7c2231 Yan, Zheng          2013-08-12  1891  	/* there should be no reader or writer */
b0d7c2231 Yan, Zheng          2013-08-12  1892  	WARN_ON_ONCE(ci->i_rd_ref || ci->i_wr_ref);
b0d7c2231 Yan, Zheng          2013-08-12  1893  
355da1eb7 Sage Weil           2009-10-06  1894  	to = ci->i_truncate_size;
355da1eb7 Sage Weil           2009-10-06  1895  	wrbuffer_refs = ci->i_wrbuffer_ref;
355da1eb7 Sage Weil           2009-10-06  1896  	dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
355da1eb7 Sage Weil           2009-10-06  1897  	     ci->i_truncate_pending, to);
be655596b Sage Weil           2011-11-30  1898  	spin_unlock(&ci->i_ceph_lock);
355da1eb7 Sage Weil           2009-10-06  1899  
4e217b5dc Yan, Zheng          2014-06-08  1900  	truncate_pagecache(inode, to);
355da1eb7 Sage Weil           2009-10-06  1901  
be655596b Sage Weil           2011-11-30  1902  	spin_lock(&ci->i_ceph_lock);
a85f50b6e Yan, Zheng          2012-11-19  1903  	if (to == ci->i_truncate_size) {
a85f50b6e Yan, Zheng          2012-11-19  1904  		ci->i_truncate_pending = 0;
a85f50b6e Yan, Zheng          2012-11-19  1905  		finish = 1;
a85f50b6e Yan, Zheng          2012-11-19  1906  	}
be655596b Sage Weil           2011-11-30  1907  	spin_unlock(&ci->i_ceph_lock);
a85f50b6e Yan, Zheng          2012-11-19  1908  	if (!finish)
a85f50b6e Yan, Zheng          2012-11-19  1909  		goto retry;
355da1eb7 Sage Weil           2009-10-06  1910  
b0d7c2231 Yan, Zheng          2013-08-12  1911  	mutex_unlock(&ci->i_truncate_mutex);
b0d7c2231 Yan, Zheng          2013-08-12  1912  
355da1eb7 Sage Weil           2009-10-06  1913  	if (wrbuffer_refs == 0)
355da1eb7 Sage Weil           2009-10-06  1914  		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
a85f50b6e Yan, Zheng          2012-11-19  1915  
03066f234 Yehuda Sadeh        2010-07-27  1916  	wake_up_all(&ci->i_cap_wq);
355da1eb7 Sage Weil           2009-10-06  1917  }
355da1eb7 Sage Weil           2009-10-06  1918  
33c573a5c Yan, Zheng          2019-05-18  1919  static void ceph_inode_work(struct work_struct *work)
33c573a5c Yan, Zheng          2019-05-18  1920  {
33c573a5c Yan, Zheng          2019-05-18  1921  	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
33c573a5c Yan, Zheng          2019-05-18  1922  						 i_work);
33c573a5c Yan, Zheng          2019-05-18  1923  	struct inode *inode = &ci->vfs_inode;
33c573a5c Yan, Zheng          2019-05-18  1924  
33c573a5c Yan, Zheng          2019-05-18 @1925  	if (test_and_clear_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask)) {
33c573a5c Yan, Zheng          2019-05-18  1926  		dout("writeback %p\n", inode);
33c573a5c Yan, Zheng          2019-05-18  1927  		filemap_fdatawrite(&inode->i_data);
33c573a5c Yan, Zheng          2019-05-18  1928  	}
33c573a5c Yan, Zheng          2019-05-18  1929  	if (test_and_clear_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask))
33c573a5c Yan, Zheng          2019-05-18  1930  		ceph_do_invalidate_pages(inode);
33c573a5c Yan, Zheng          2019-05-18  1931  
33c573a5c Yan, Zheng          2019-05-18  1932  	if (test_and_clear_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask))
33c573a5c Yan, Zheng          2019-05-18  1933  		__ceph_do_pending_vmtruncate(inode);
33c573a5c Yan, Zheng          2019-05-18  1934  
33c573a5c Yan, Zheng          2019-05-18  1935  	iput(inode);
33c573a5c Yan, Zheng          2019-05-18  1936  }
33c573a5c Yan, Zheng          2019-05-18  1937  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
