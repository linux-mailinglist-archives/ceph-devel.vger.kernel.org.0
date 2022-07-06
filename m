Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05E0568893
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Jul 2022 14:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiGFMpI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Jul 2022 08:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbiGFMpC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Jul 2022 08:45:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC14F220F8
        for <ceph-devel@vger.kernel.org>; Wed,  6 Jul 2022 05:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657111484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBJ2r1suJ+bd37UtdqCEXXoWx7EpGZguYpaHHB4dfe0=;
        b=SYhlPvJrTjdstBdbI03GOpfJv71oZqDMFBgACRD4J+ACTk1wXEH+5plWs9fW3dIbsYg5ib
        WrryXZpTfsWp/1lLtQKpxAFJW5RxuVLqxtUVeHOaXo8MUlXVqucqG/UKRif7LlF2cGW3q7
        mJCpifE2T12Vt3+2GxQ7z/bq9Mo6Cfw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-wMDTps0OMdi8V80DmJZNnA-1; Wed, 06 Jul 2022 08:44:41 -0400
X-MC-Unique: wMDTps0OMdi8V80DmJZNnA-1
Received: by mail-pj1-f70.google.com with SMTP id pt7-20020a17090b3d0700b001efb2800e55so894278pjb.3
        for <ceph-devel@vger.kernel.org>; Wed, 06 Jul 2022 05:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BBJ2r1suJ+bd37UtdqCEXXoWx7EpGZguYpaHHB4dfe0=;
        b=03iEa7KpwLtLA1zgXUpSLqS8G5cdg3jx47mRi5OYnBE156U3uCgfKekLEwt7485bBC
         VzOuWDuBNxzCFjvaMyhUeGorLwvZ/woWaghaX9hRVM8CXZMb6dXtX57CDTr7Omd9A8Fa
         zLPG21auPldqgrKj0aeeGp5uGkz3lraze/WUAUkxb09vOZMwYvfLcapfsTV9QHapnEge
         Ih7gOn16g0SKLTOsq3u6lj9Ls+s2yMhzMnXkocbNvauu+EHydWr3NC8/pqMJmco6WhgS
         vAIdzZatMecvie+NLqZh0zsZW22ozArq/bWp27lLofcb6he667/+dGEJZGuPNsOjhzIK
         iY8w==
X-Gm-Message-State: AJIora8U077ledZaN94GdugeY/Ds7GvYC84aV2nMAuQTfh6VYYUVD70Q
        Py4jDmolTFki700ZxhD5mtfMinQJuTeCR+Q3LxxYUAz9Q2622xN1r0C4g0o6Z3xp5/YuddqMqQE
        AMfdbS0sTbMlzmjZstJFjL/N3zPCV1rHYVUIbASmviKy2PjY6cjbVB6cEEYY/FR+EJhw2y+s=
X-Received: by 2002:a17:902:d5c7:b0:16c:131:7409 with SMTP id g7-20020a170902d5c700b0016c01317409mr3464617plh.80.1657111479565;
        Wed, 06 Jul 2022 05:44:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v1Iu65M1cHV/j8v/NGn/sXPTwkk8Fjy6mC8qX08UZ7IXXhB55BmIVSEPz/UEDLYTAHKLQSLA==
X-Received: by 2002:a17:902:d5c7:b0:16c:131:7409 with SMTP id g7-20020a170902d5c700b0016c01317409mr3464585plh.80.1657111479070;
        Wed, 06 Jul 2022 05:44:39 -0700 (PDT)
Received: from [10.72.12.227] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 8-20020aa79208000000b0050dc76281e0sm20529395pfo.186.2022.07.06.05.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 05:44:37 -0700 (PDT)
Subject: Re: [ceph-client:wip-fscrypt 48/59] fs/ceph/file.c:1727:45: error:
 too many arguments to function call, expected 2, have 3
To:     kernel test robot <lkp@intel.com>, Jeff Layton <jlayton@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org
References: <202207061958.I86cqkif-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c0197b6c-05cb-f268-4d13-b56456c7d936@redhat.com>
Date:   Wed, 6 Jul 2022 20:44:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202207061958.I86cqkif-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Fixed it in the wip-fscrypt branch.

Thanks!

On 7/6/22 7:04 PM, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git wip-fscrypt
> head:   55b265c1fd41c55be5e56d9eb4b24da48ac04a8c
> commit: 3c062ae4472df769c1a740ed55ccc252f9e104c1 [48/59] ceph: add read/modify/write to ceph_sync_write
> config: i386-randconfig-a006 (https://download.01.org/0day-ci/archive/20220706/202207061958.I86cqkif-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project f553287b588916de09c66e3e32bf75e5060f967f)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/ceph/ceph-client/commit/3c062ae4472df769c1a740ed55ccc252f9e104c1
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client wip-fscrypt
>          git checkout 3c062ae4472df769c1a740ed55ccc252f9e104c1
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/ceph/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>>> fs/ceph/file.c:1727:45: error: too many arguments to function call, expected 2, have 3
>                             ret = ceph_osdc_start_request(osdc, req, false);
>                                   ~~~~~~~~~~~~~~~~~~~~~~~            ^~~~~
>     include/linux/ceph/osd_client.h:583:6: note: 'ceph_osdc_start_request' declared here
>     void ceph_osdc_start_request(struct ceph_osd_client *osdc,
>          ^
>     fs/ceph/file.c:1896:38: error: too many arguments to function call, expected 2, have 3
>                     ceph_osdc_start_request(osdc, req, false);
>                     ~~~~~~~~~~~~~~~~~~~~~~~            ^~~~~
>     include/linux/ceph/osd_client.h:583:6: note: 'ceph_osdc_start_request' declared here
>     void ceph_osdc_start_request(struct ceph_osd_client *osdc,
>          ^
>     2 errors generated.
>
>
> vim +1727 fs/ceph/file.c
>
>    1553	
>    1554	/*
>    1555	 * Synchronous write, straight from __user pointer or user pages.
>    1556	 *
>    1557	 * If write spans object boundary, just do multiple writes.  (For a
>    1558	 * correct atomic write, we should e.g. take write locks on all
>    1559	 * objects, rollback on failure, etc.)
>    1560	 */
>    1561	static ssize_t
>    1562	ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>    1563			struct ceph_snap_context *snapc)
>    1564	{
>    1565		struct file *file = iocb->ki_filp;
>    1566		struct inode *inode = file_inode(file);
>    1567		struct ceph_inode_info *ci = ceph_inode(inode);
>    1568		struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>    1569		struct ceph_osd_client *osdc = &fsc->client->osdc;
>    1570		struct ceph_osd_request *req;
>    1571		struct page **pages;
>    1572		u64 len;
>    1573		int num_pages;
>    1574		int written = 0;
>    1575		int ret;
>    1576		bool check_caps = false;
>    1577		struct timespec64 mtime = current_time(inode);
>    1578		size_t count = iov_iter_count(from);
>    1579	
>    1580		if (ceph_snap(file_inode(file)) != CEPH_NOSNAP)
>    1581			return -EROFS;
>    1582	
>    1583		dout("sync_write on file %p %lld~%u snapc %p seq %lld\n",
>    1584		     file, pos, (unsigned)count, snapc, snapc->seq);
>    1585	
>    1586		ret = filemap_write_and_wait_range(inode->i_mapping,
>    1587						   pos, pos + count - 1);
>    1588		if (ret < 0)
>    1589			return ret;
>    1590	
>    1591		ceph_fscache_invalidate(inode, false);
>    1592		ret = invalidate_inode_pages2_range(inode->i_mapping,
>    1593						    pos >> PAGE_SHIFT,
>    1594						    (pos + count - 1) >> PAGE_SHIFT);
>    1595		if (ret < 0)
>    1596			dout("invalidate_inode_pages2_range returned %d\n", ret);
>    1597	
>    1598		while ((len = iov_iter_count(from)) > 0) {
>    1599			size_t left;
>    1600			int n;
>    1601			u64 write_pos = pos;
>    1602			u64 write_len = len;
>    1603			u64 objnum, objoff;
>    1604			u32 xlen;
>    1605			u64 assert_ver = 0;
>    1606			bool rmw;
>    1607			bool first, last;
>    1608			struct iov_iter saved_iter = *from;
>    1609			size_t off;
>    1610	
>    1611			ceph_fscrypt_adjust_off_and_len(inode, &write_pos, &write_len);
>    1612	
>    1613			/* clamp the length to the end of first object */
>    1614			ceph_calc_file_object_mapping(&ci->i_layout, write_pos,
>    1615							write_len, &objnum, &objoff,
>    1616							&xlen);
>    1617			write_len = xlen;
>    1618	
>    1619			/* adjust len downward if it goes beyond current object */
>    1620			if (pos + len > write_pos + write_len)
>    1621				len = write_pos + write_len - pos;
>    1622	
>    1623			/*
>    1624			 * If we had to adjust the length or position to align with a
>    1625			 * crypto block, then we must do a read/modify/write cycle. We
>    1626			 * use a version assertion to redrive the thing if something
>    1627			 * changes in between.
>    1628			 */
>    1629			first = pos != write_pos;
>    1630			last = (pos + len) != (write_pos + write_len);
>    1631			rmw = first || last;
>    1632	
>    1633			dout("sync_write ino %llx %lld~%llu adjusted %lld~%llu -- %srmw\n",
>    1634			     ci->i_vino.ino, pos, len, write_pos, write_len, rmw ? "" : "no ");
>    1635	
>    1636			/*
>    1637			 * The data is emplaced into the page as it would be if it were in
>    1638			 * an array of pagecache pages.
>    1639			 */
>    1640			num_pages = calc_pages_for(write_pos, write_len);
>    1641			pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
>    1642			if (IS_ERR(pages)) {
>    1643				ret = PTR_ERR(pages);
>    1644				break;
>    1645			}
>    1646	
>    1647			/* Do we need to preload the pages? */
>    1648			if (rmw) {
>    1649				u64 first_pos = write_pos;
>    1650				u64 last_pos = (write_pos + write_len) - CEPH_FSCRYPT_BLOCK_SIZE;
>    1651				u64 read_len = CEPH_FSCRYPT_BLOCK_SIZE;
>    1652				struct ceph_osd_req_op *op;
>    1653	
>    1654				/* We should only need to do this for encrypted inodes */
>    1655				WARN_ON_ONCE(!IS_ENCRYPTED(inode));
>    1656	
>    1657				/* No need to do two reads if first and last blocks are same */
>    1658				if (first && last_pos == first_pos)
>    1659					last = false;
>    1660	
>    1661				/*
>    1662				 * Allocate a read request for one or two extents, depending
>    1663				 * on how the request was aligned.
>    1664				 */
>    1665				req = ceph_osdc_new_request(osdc, &ci->i_layout,
>    1666						ci->i_vino, first ? first_pos : last_pos,
>    1667						&read_len, 0, (first && last) ? 2 : 1,
>    1668						CEPH_OSD_OP_SPARSE_READ, CEPH_OSD_FLAG_READ,
>    1669						NULL, ci->i_truncate_seq,
>    1670						ci->i_truncate_size, false);
>    1671				if (IS_ERR(req)) {
>    1672					ceph_release_page_vector(pages, num_pages);
>    1673					ret = PTR_ERR(req);
>    1674					break;
>    1675				}
>    1676	
>    1677				/* Something is misaligned! */
>    1678				if (read_len != CEPH_FSCRYPT_BLOCK_SIZE) {
>    1679					ceph_osdc_put_request(req);
>    1680					ceph_release_page_vector(pages, num_pages);
>    1681					ret = -EIO;
>    1682					break;
>    1683				}
>    1684	
>    1685				/* Add extent for first block? */
>    1686				op = &req->r_ops[0];
>    1687	
>    1688				if (first) {
>    1689					osd_req_op_extent_osd_data_pages(req, 0, pages,
>    1690								 CEPH_FSCRYPT_BLOCK_SIZE,
>    1691								 offset_in_page(first_pos),
>    1692								 false, false);
>    1693					/* We only expect a single extent here */
>    1694					ret = __ceph_alloc_sparse_ext_map(op, 1);
>    1695					if (ret) {
>    1696						ceph_osdc_put_request(req);
>    1697						ceph_release_page_vector(pages, num_pages);
>    1698						break;
>    1699					}
>    1700				}
>    1701	
>    1702				/* Add extent for last block */
>    1703				if (last) {
>    1704					/* Init the other extent if first extent has been used */
>    1705					if (first) {
>    1706						op = &req->r_ops[1];
>    1707						osd_req_op_extent_init(req, 1, CEPH_OSD_OP_SPARSE_READ,
>    1708								last_pos, CEPH_FSCRYPT_BLOCK_SIZE,
>    1709								ci->i_truncate_size,
>    1710								ci->i_truncate_seq);
>    1711					}
>    1712	
>    1713					ret = __ceph_alloc_sparse_ext_map(op, 1);
>    1714					if (ret) {
>    1715						ceph_osdc_put_request(req);
>    1716						ceph_release_page_vector(pages, num_pages);
>    1717						break;
>    1718					}
>    1719	
>    1720					osd_req_op_extent_osd_data_pages(req, first ? 1 : 0,
>    1721								&pages[num_pages - 1],
>    1722								CEPH_FSCRYPT_BLOCK_SIZE,
>    1723								offset_in_page(last_pos),
>    1724								false, false);
>    1725				}
>    1726	
>> 1727				ret = ceph_osdc_start_request(osdc, req, false);
>    1728				if (!ret)
>    1729					ret = ceph_osdc_wait_request(osdc, req);
>    1730	
>    1731				/* FIXME: length field is wrong if there are 2 extents */
>    1732				ceph_update_read_metrics(&fsc->mdsc->metric,
>    1733							 req->r_start_latency,
>    1734							 req->r_end_latency,
>    1735							 read_len, ret);
>    1736	
>    1737				/* Ok if object is not already present */
>    1738				if (ret == -ENOENT) {
>    1739					/*
>    1740					 * If there is no object, then we can't assert
>    1741					 * on its version. Set it to 0, and we'll use an
>    1742					 * exclusive create instead.
>    1743					 */
>    1744					ceph_osdc_put_request(req);
>    1745					ret = 0;
>    1746	
>    1747					/*
>    1748					 * zero out the soon-to-be uncopied parts of the
>    1749					 * first and last pages.
>    1750					 */
>    1751					if (first)
>    1752						zero_user_segment(pages[0], 0,
>    1753								  offset_in_page(first_pos));
>    1754					if (last)
>    1755						zero_user_segment(pages[num_pages - 1],
>    1756								  offset_in_page(last_pos),
>    1757								  PAGE_SIZE);
>    1758				} else {
>    1759					if (ret < 0) {
>    1760						ceph_osdc_put_request(req);
>    1761						ceph_release_page_vector(pages, num_pages);
>    1762						break;
>    1763					}
>    1764	
>    1765					op = &req->r_ops[0];
>    1766					if (op->extent.sparse_ext_cnt == 0) {
>    1767						if (first)
>    1768							zero_user_segment(pages[0], 0,
>    1769									  offset_in_page(first_pos));
>    1770						else
>    1771							zero_user_segment(pages[num_pages - 1],
>    1772									  offset_in_page(last_pos),
>    1773									  PAGE_SIZE);
>    1774					} else if (op->extent.sparse_ext_cnt != 1 ||
>    1775						   ceph_sparse_ext_map_end(op) !=
>    1776							CEPH_FSCRYPT_BLOCK_SIZE) {
>    1777						ret = -EIO;
>    1778						ceph_osdc_put_request(req);
>    1779						ceph_release_page_vector(pages, num_pages);
>    1780						break;
>    1781					}
>    1782	
>    1783					if (first && last) {
>    1784						op = &req->r_ops[1];
>    1785						if (op->extent.sparse_ext_cnt == 0) {
>    1786							zero_user_segment(pages[num_pages - 1],
>    1787									  offset_in_page(last_pos),
>    1788									  PAGE_SIZE);
>    1789						} else if (op->extent.sparse_ext_cnt != 1 ||
>    1790							   ceph_sparse_ext_map_end(op) !=
>    1791								CEPH_FSCRYPT_BLOCK_SIZE) {
>    1792							ret = -EIO;
>    1793							ceph_osdc_put_request(req);
>    1794							ceph_release_page_vector(pages, num_pages);
>    1795							break;
>    1796						}
>    1797					}
>    1798	
>    1799					/* Grab assert version. It must be non-zero. */
>    1800					assert_ver = req->r_version;
>    1801					WARN_ON_ONCE(ret > 0 && assert_ver == 0);
>    1802	
>    1803					ceph_osdc_put_request(req);
>    1804					if (first) {
>    1805						ret = ceph_fscrypt_decrypt_block_inplace(inode,
>    1806								pages[0],
>    1807								CEPH_FSCRYPT_BLOCK_SIZE,
>    1808								offset_in_page(first_pos),
>    1809								first_pos >> CEPH_FSCRYPT_BLOCK_SHIFT);
>    1810						if (ret < 0) {
>    1811							ceph_release_page_vector(pages, num_pages);
>    1812							break;
>    1813						}
>    1814					}
>    1815					if (last) {
>    1816						ret = ceph_fscrypt_decrypt_block_inplace(inode,
>    1817								pages[num_pages - 1],
>    1818								CEPH_FSCRYPT_BLOCK_SIZE,
>    1819								offset_in_page(last_pos),
>    1820								last_pos >> CEPH_FSCRYPT_BLOCK_SHIFT);
>    1821						if (ret < 0) {
>    1822							ceph_release_page_vector(pages, num_pages);
>    1823							break;
>    1824						}
>    1825					}
>    1826				}
>    1827			}
>    1828	
>    1829			left = len;
>    1830			off = offset_in_page(pos);
>    1831			for (n = 0; n < num_pages; n++) {
>    1832				size_t plen = min_t(size_t, left, PAGE_SIZE - off);
>    1833	
>    1834				/* copy the data */
>    1835				ret = copy_page_from_iter(pages[n], off, plen, from);
>    1836				if (ret != plen) {
>    1837					ret = -EFAULT;
>    1838					break;
>    1839				}
>    1840				off = 0;
>    1841				left -= ret;
>    1842			}
>    1843			if (ret < 0) {
>    1844				dout("sync_write write failed with %d\n", ret);
>    1845				ceph_release_page_vector(pages, num_pages);
>    1846				break;
>    1847			}
>    1848	
>    1849			if (IS_ENCRYPTED(inode)) {
>    1850				ret = ceph_fscrypt_encrypt_pages(inode, pages,
>    1851								 write_pos, write_len,
>    1852								 GFP_KERNEL);
>    1853				if (ret < 0) {
>    1854					dout("encryption failed with %d\n", ret);
>    1855					ceph_release_page_vector(pages, num_pages);
>    1856					break;
>    1857				}
>    1858			}
>    1859	
>    1860			req = ceph_osdc_new_request(osdc, &ci->i_layout,
>    1861						    ci->i_vino, write_pos, &write_len,
>    1862						    rmw ? 1 : 0, rmw ? 2 : 1,
>    1863						    CEPH_OSD_OP_WRITE,
>    1864						    CEPH_OSD_FLAG_WRITE,
>    1865						    snapc, ci->i_truncate_seq,
>    1866						    ci->i_truncate_size, false);
>    1867			if (IS_ERR(req)) {
>    1868				ret = PTR_ERR(req);
>    1869				ceph_release_page_vector(pages, num_pages);
>    1870				break;
>    1871			}
>    1872	
>    1873			dout("sync_write write op %lld~%llu\n", write_pos, write_len);
>    1874			osd_req_op_extent_osd_data_pages(req, rmw ? 1 : 0, pages, write_len,
>    1875							 offset_in_page(write_pos), false,
>    1876							 true);
>    1877			req->r_inode = inode;
>    1878			req->r_mtime = mtime;
>    1879	
>    1880			/* Set up the assertion */
>    1881			if (rmw) {
>    1882				/*
>    1883				 * Set up the assertion. If we don't have a version number,
>    1884				 * then the object doesn't exist yet. Use an exclusive create
>    1885				 * instead of a version assertion in that case.
>    1886				 */
>    1887				if (assert_ver) {
>    1888					osd_req_op_init(req, 0, CEPH_OSD_OP_ASSERT_VER, 0);
>    1889					req->r_ops[0].assert_ver.ver = assert_ver;
>    1890				} else {
>    1891					osd_req_op_init(req, 0, CEPH_OSD_OP_CREATE,
>    1892							CEPH_OSD_OP_FLAG_EXCL);
>    1893				}
>    1894			}
>    1895	
>    1896			ceph_osdc_start_request(osdc, req, false);
>    1897	
>    1898			ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>    1899						  req->r_end_latency, len, ret);
>    1900			ceph_osdc_put_request(req);
>    1901			if (ret != 0) {
>    1902				dout("sync_write osd write returned %d\n", ret);
>    1903				/* Version changed! Must re-do the rmw cycle */
>    1904				if ((assert_ver && (ret == -ERANGE || ret == -EOVERFLOW)) ||
>    1905				     (!assert_ver && ret == -EEXIST)) {
>    1906					/* We should only ever see this on a rmw */
>    1907					WARN_ON_ONCE(!rmw);
>    1908	
>    1909					/* The version should never go backward */
>    1910					WARN_ON_ONCE(ret == -EOVERFLOW);
>    1911	
>    1912					*from = saved_iter;
>    1913	
>    1914					/* FIXME: limit number of times we loop? */
>    1915					continue;
>    1916				}
>    1917				ceph_set_error_write(ci);
>    1918				break;
>    1919			}
>    1920			ceph_clear_error_write(ci);
>    1921			pos += len;
>    1922			written += len;
>    1923			dout("sync_write written %d\n", written);
>    1924			if (pos > i_size_read(inode)) {
>    1925				check_caps = ceph_inode_set_size(inode, pos);
>    1926				if (check_caps)
>    1927					ceph_check_caps(ceph_inode(inode),
>    1928							CHECK_CAPS_AUTHONLY,
>    1929							NULL);
>    1930			}
>    1931	
>    1932		}
>    1933	
>    1934		if (ret != -EOLDSNAPC && written > 0) {
>    1935			ret = written;
>    1936			iocb->ki_pos = pos;
>    1937		}
>    1938		dout("sync_write returning %d\n", ret);
>    1939		return ret;
>    1940	}
>    1941	
>

