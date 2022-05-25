Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E585341AF
	for <lists+ceph-devel@lfdr.de>; Wed, 25 May 2022 18:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245385AbiEYQtV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 May 2022 12:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbiEYQtU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 May 2022 12:49:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212861145C
        for <ceph-devel@vger.kernel.org>; Wed, 25 May 2022 09:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DD77B81E3F
        for <ceph-devel@vger.kernel.org>; Wed, 25 May 2022 16:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C33C385B8;
        Wed, 25 May 2022 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653497355;
        bh=DcaYq3Pa0b6lSpil12xC4OQHse4rZi906VxBmn+n6RY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rAk2DKTl3K8fEAf5MNW4UJBniIibMOOpbGHR0Nh1in7r31bg/tmavpI07lWK6h+Kn
         JLvESJ+l6/agfyJHoTFRWx+O0KIJoUaLTe2yPcw0mk6w+hmyV9kGpiAISXVcLdRssv
         HXTNayF4sigsdVpmJxHNkqHXlLvUZDsyzqgLo9D5bETkRDsRJyr0dccwQQ5Xvw8DOg
         a0PAUrf6L4PYaNTArKrHf2WWRJfs+VM2n9BGYbqRRNiEsXQ3EPPgHQf4mR2YnAans1
         C7rTvIeE3ger8p8kOyQJNYU38W94X6hgF8cxApGAknmDxQlHYm/q3SJMO4hWb7sI0Z
         aI619q6vOQHkQ==
Message-ID: <844d88b270629cac601d440efa810213294d21a4.camel@kernel.org>
Subject: Re: [ceph-client:wip-fscrypt 53/64] fs/ceph/file.c:1896
 ceph_sync_write() error: uninitialized symbol 'assert_ver'.
From:   Jeff Layton <jlayton@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Date:   Wed, 25 May 2022 12:49:13 -0400
In-Reply-To: <202205250038.pULlmpTX-lkp@intel.com>
References: <202205250038.pULlmpTX-lkp@intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-05-24 at 21:39 +0300, Dan Carpenter wrote:
> tree:   https://github.com/ceph/ceph-client.git wip-fscrypt
> head:   9ab30a676da19ce5d83364306a03d643dd446aca
> commit: 6341655663fe166fd30acca6b4e692d2fafb02e5 [53/64] ceph: add read/m=
odify/write to ceph_sync_write
> config: microblaze-randconfig-m031-20220524 (https://download.01.org/0day=
-ci/archive/20220525/202205250038.pULlmpTX-lkp@intel.com/config)
> compiler: microblaze-linux-gcc (GCC) 11.3.0
>=20
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> New smatch warnings:
> fs/ceph/file.c:1896 ceph_sync_write() error: uninitialized symbol 'assert=
_ver'.
>=20
> Old smatch warnings:
> fs/ceph/file.c:146 iter_get_bvecs_alloc() warn: Please consider using kvc=
alloc instead of kvmalloc_array
>=20
> vim +/assert_ver +1896 fs/ceph/file.c
>=20
> 06fee30f6a31f10 Yan, Zheng         2014-07-28  1550  static ssize_t
> 5dda377cf0a6bd4 Yan, Zheng         2015-04-30  1551  ceph_sync_write(stru=
ct kiocb *iocb, struct iov_iter *from, loff_t pos,
> 5dda377cf0a6bd4 Yan, Zheng         2015-04-30  1552  		struct ceph_snap_c=
ontext *snapc)
> e8344e668915a74 majianpeng         2013-09-12  1553  {
> e8344e668915a74 majianpeng         2013-09-12  1554  	struct file *file =
=3D iocb->ki_filp;
> e8344e668915a74 majianpeng         2013-09-12  1555  	struct inode *inode=
 =3D file_inode(file);
> e8344e668915a74 majianpeng         2013-09-12  1556  	struct ceph_inode_i=
nfo *ci =3D ceph_inode(inode);
> e8344e668915a74 majianpeng         2013-09-12  1557  	struct ceph_fs_clie=
nt *fsc =3D ceph_inode_to_client(inode);
> 6341655663fe166 Jeff Layton        2021-01-27  1558  	struct ceph_osd_cli=
ent *osdc =3D &fsc->client->osdc;
> e8344e668915a74 majianpeng         2013-09-12  1559  	struct ceph_osd_req=
uest *req;
> e8344e668915a74 majianpeng         2013-09-12  1560  	struct page **pages=
;
> e8344e668915a74 majianpeng         2013-09-12  1561  	u64 len;
> e8344e668915a74 majianpeng         2013-09-12  1562  	int num_pages;
> e8344e668915a74 majianpeng         2013-09-12  1563  	int written =3D 0;
> e8344e668915a74 majianpeng         2013-09-12  1564  	int ret;
> efb0ca765ac6f49 Yan, Zheng         2017-05-22  1565  	bool check_caps =3D=
 false;
> fac02ddf910814c Arnd Bergmann      2018-07-13  1566  	struct timespec64 m=
time =3D current_time(inode);
> 4908b822b300d2d Al Viro            2014-04-03  1567  	size_t count =3D io=
v_iter_count(from);
> e8344e668915a74 majianpeng         2013-09-12  1568 =20
> e8344e668915a74 majianpeng         2013-09-12  1569  	if (ceph_snap(file_=
inode(file)) !=3D CEPH_NOSNAP)
> e8344e668915a74 majianpeng         2013-09-12  1570  		return -EROFS;
> e8344e668915a74 majianpeng         2013-09-12  1571 =20
> 1c0a9c2d9783604 Yan, Zheng         2017-08-16  1572  	dout("sync_write on=
 file %p %lld~%u snapc %p seq %lld\n",
> 1c0a9c2d9783604 Yan, Zheng         2017-08-16  1573  	     file, pos, (un=
signed)count, snapc, snapc->seq);
> e8344e668915a74 majianpeng         2013-09-12  1574 =20
> e450f4d1a5d633d zhengbin           2019-02-01  1575  	ret =3D filemap_wri=
te_and_wait_range(inode->i_mapping,
> e450f4d1a5d633d zhengbin           2019-02-01  1576  					   pos, pos + c=
ount - 1);
> e8344e668915a74 majianpeng         2013-09-12  1577  	if (ret < 0)
> e8344e668915a74 majianpeng         2013-09-12  1578  		return ret;
> e8344e668915a74 majianpeng         2013-09-12  1579 =20
> 400e1286c0ec3fd Jeff Layton        2021-12-07  1580  	ceph_fscache_invali=
date(inode, false);
> e8344e668915a74 majianpeng         2013-09-12  1581  	ret =3D invalidate_=
inode_pages2_range(inode->i_mapping,
> 09cbfeaf1a5a67b Kirill A. Shutemov 2016-04-01  1582  					    pos >> PAGE=
_SHIFT,
> e450f4d1a5d633d zhengbin           2019-02-01  1583  					    (pos + coun=
t - 1) >> PAGE_SHIFT);
> e8344e668915a74 majianpeng         2013-09-12  1584  	if (ret < 0)
> e8344e668915a74 majianpeng         2013-09-12  1585  		dout("invalidate_i=
node_pages2_range returned %d\n", ret);
> e8344e668915a74 majianpeng         2013-09-12  1586 =20
> 4908b822b300d2d Al Viro            2014-04-03  1587  	while ((len =3D iov=
_iter_count(from)) > 0) {
> e8344e668915a74 majianpeng         2013-09-12  1588  		size_t left;
> e8344e668915a74 majianpeng         2013-09-12  1589  		int n;
> 6341655663fe166 Jeff Layton        2021-01-27  1590  		u64 write_pos =3D =
pos;
> 6341655663fe166 Jeff Layton        2021-01-27  1591  		u64 write_len =3D =
len;
> 6341655663fe166 Jeff Layton        2021-01-27  1592  		u64 objnum, objoff=
;
> 6341655663fe166 Jeff Layton        2021-01-27  1593  		u32 xlen;
> 6341655663fe166 Jeff Layton        2021-01-27  1594  		u64 assert_ver;
> 6341655663fe166 Jeff Layton        2021-01-27  1595  		bool rmw;
> 6341655663fe166 Jeff Layton        2021-01-27  1596  		bool first, last;
> 6341655663fe166 Jeff Layton        2021-01-27  1597  		struct iov_iter sa=
ved_iter =3D *from;
> 6341655663fe166 Jeff Layton        2021-01-27  1598  		size_t off;
> e8344e668915a74 majianpeng         2013-09-12  1599 =20
> 6341655663fe166 Jeff Layton        2021-01-27  1600  		ceph_fscrypt_adjus=
t_off_and_len(inode, &write_pos, &write_len);
> 6341655663fe166 Jeff Layton        2021-01-27  1601 =20
> 6341655663fe166 Jeff Layton        2021-01-27  1602  		/* clamp the lengt=
h to the end of first object */
> 6341655663fe166 Jeff Layton        2021-01-27  1603  		ceph_calc_file_obj=
ect_mapping(&ci->i_layout, write_pos,
> 6341655663fe166 Jeff Layton        2021-01-27  1604  						write_len, &ob=
jnum, &objoff,
> 6341655663fe166 Jeff Layton        2021-01-27  1605  						&xlen);
> 6341655663fe166 Jeff Layton        2021-01-27  1606  		write_len =3D xlen=
;
> 6341655663fe166 Jeff Layton        2021-01-27  1607 =20
> 6341655663fe166 Jeff Layton        2021-01-27  1608  		/* adjust len down=
ward if it goes beyond current object */
> 6341655663fe166 Jeff Layton        2021-01-27  1609  		if (pos + len > wr=
ite_pos + write_len)
> 6341655663fe166 Jeff Layton        2021-01-27  1610  			len =3D write_pos=
 + write_len - pos;
> 6341655663fe166 Jeff Layton        2021-01-27  1611 =20
> 6341655663fe166 Jeff Layton        2021-01-27  1612  		/*
> 6341655663fe166 Jeff Layton        2021-01-27  1613  		 * If we had to ad=
just the length or position to align with a
> 6341655663fe166 Jeff Layton        2021-01-27  1614  		 * crypto block, t=
hen we must do a read/modify/write cycle. We
> 6341655663fe166 Jeff Layton        2021-01-27  1615  		 * use a version a=
ssertion to redrive the thing if something
> 6341655663fe166 Jeff Layton        2021-01-27  1616  		 * changes in betw=
een.
> 6341655663fe166 Jeff Layton        2021-01-27  1617  		 */
> 6341655663fe166 Jeff Layton        2021-01-27  1618  		first =3D pos !=3D=
 write_pos;
> 6341655663fe166 Jeff Layton        2021-01-27  1619  		last =3D (pos + le=
n) !=3D (write_pos + write_len);
> 6341655663fe166 Jeff Layton        2021-01-27  1620  		rmw =3D first || l=
ast;
> 6341655663fe166 Jeff Layton        2021-01-27  1621 =20
> 6341655663fe166 Jeff Layton        2021-01-27  1622  		dout("sync_write i=
no %llx %lld~%llu adjusted %lld~%llu -- %srmw\n",
> 6341655663fe166 Jeff Layton        2021-01-27  1623  		     ci->i_vino.in=
o, pos, len, write_pos, write_len, rmw ? "" : "no ");
> 6341655663fe166 Jeff Layton        2021-01-27  1624 =20
> 6341655663fe166 Jeff Layton        2021-01-27  1625  		/*
> 6341655663fe166 Jeff Layton        2021-01-27  1626  		 * The data is emp=
laced into the page as it would be if it were in
> 6341655663fe166 Jeff Layton        2021-01-27  1627  		 * an array of pag=
ecache pages.
> 6341655663fe166 Jeff Layton        2021-01-27  1628  		 */
> 6341655663fe166 Jeff Layton        2021-01-27  1629  		num_pages =3D calc=
_pages_for(write_pos, write_len);
> 6341655663fe166 Jeff Layton        2021-01-27  1630  		pages =3D ceph_all=
oc_page_vector(num_pages, GFP_KERNEL);
> 6341655663fe166 Jeff Layton        2021-01-27  1631  		if (IS_ERR(pages))=
 {
> 6341655663fe166 Jeff Layton        2021-01-27  1632  			ret =3D PTR_ERR(p=
ages);
> 6341655663fe166 Jeff Layton        2021-01-27  1633  			break;
> 6341655663fe166 Jeff Layton        2021-01-27  1634  		}
> 6341655663fe166 Jeff Layton        2021-01-27  1635 =20
> 6341655663fe166 Jeff Layton        2021-01-27  1636  		/* Do we need to p=
reload the pages? */
> 6341655663fe166 Jeff Layton        2021-01-27  1637  		if (rmw) {
>=20
> "assert_ver" is only initialized when "rmw" is true.
>=20

Fixed in tree by just initializing assert_ver to 0 during declaration.
That should ensure that it's always 0 unless it has been set to
something else.

Thanks, Dan!
--=20
Jeff Layton <jlayton@kernel.org>
