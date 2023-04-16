Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB9E6E3C07
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Apr 2023 23:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjDPVK4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 17:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDPVKy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 17:10:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376D41BD3
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 14:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B43B96108F
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 21:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F99C433D2;
        Sun, 16 Apr 2023 21:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681679452;
        bh=V/cxTzwVDUpqee+vMZ+u+epi7sqk9FM4NZ4DSiQIa0Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=j5mWkO+j+IKMukmkeOcVqci6K/OAq8R99J6wTUYbhrrBpN/H47ijTvSnGx0YeHQ/S
         3Lw3SNMTwI0bzF6KqlBsLVXtruVPY27QoKU61L9r1k+kIJJ7K5X/zRIBHtzeeV/Am6
         X2i6vdL99PsO+t5C2sxRPzyRla+kW8eE03/EC2KyPTDhW33XU/9vv8gJWkvCSE6OQp
         FKuiRumzweVcdaUyo67GcbwMSYV75dzcm7z690uSDeXwIcuYn96/9iRU+Mt5TjKqeI
         9dB6O6ajWVzrqphLHuNJW7ylZh/NxdW5ePWwSGxKRfvm5MCZGvl9Gg1oz2pLxMI5EN
         AnGMKwjQyH5cg==
Message-ID: <5636b031b3aea17ea3913fea2f76f94703008ea3.camel@kernel.org>
Subject: Re: [PATCH v18 48/71] ceph: add infrastructure for file encryption
 and decryption
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, vshankar@redhat.com,
        mchangir@redhat.com, lhenriques@suse.de
Date:   Sun, 16 Apr 2023 17:10:50 -0400
In-Reply-To: <CAOi1vP-tVvBCEfu_3ofdwHaEoZr7qo102cZ8BPy8q67DDk-2tw@mail.gmail.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
         <20230412110930.176835-49-xiubli@redhat.com>
         <CAOi1vP-tVvBCEfu_3ofdwHaEoZr7qo102cZ8BPy8q67DDk-2tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2023-04-16 at 22:01 +0200, Ilya Dryomov wrote:
> On Wed, Apr 12, 2023 at 1:13=E2=80=AFPM <xiubli@redhat.com> wrote:
> >=20
> > From: Jeff Layton <jlayton@kernel.org>
> >=20
> > ...and allow test_dummy_encryption to bypass content encryption
> > if mounted with test_dummy_encryption=3Dclear.
> >=20
> > Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> > Tested-by: Venky Shankar <vshankar@redhat.com>
> > Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> > Reviewed-by: Xiubo Li <xiubli@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/crypto.c | 177 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/ceph/crypto.h |  71 +++++++++++++++++++
> >  fs/ceph/super.c  |   6 ++
> >  fs/ceph/super.h  |   1 +
> >  4 files changed, 255 insertions(+)
> >=20
> > diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> > index fe47fbdaead9..35e292045e9d 100644
> > --- a/fs/ceph/crypto.c
> > +++ b/fs/ceph/crypto.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/ceph/ceph_debug.h>
> >  #include <linux/xattr.h>
> >  #include <linux/fscrypt.h>
> > +#include <linux/ceph/striper.h>
> >=20
> >  #include "super.h"
> >  #include "mds_client.h"
> > @@ -354,3 +355,179 @@ int ceph_fscrypt_prepare_readdir(struct inode *di=
r)
> >         }
> >         return 0;
> >  }
> > +
> > +int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
> > +                                 struct page *page, unsigned int len,
> > +                                 unsigned int offs, u64 lblk_num)
> > +{
> > +       struct ceph_mount_options *opt =3D ceph_inode_to_client(inode)-=
>mount_options;
> > +
> > +       if (opt->flags & CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR)
> > +               return 0;
> > +
> > +       dout("%s: len %u offs %u blk %llu\n", __func__, len, offs, lblk=
_num);
> > +       return fscrypt_decrypt_block_inplace(inode, page, len, offs, lb=
lk_num);
> > +}
> > +
> > +int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
> > +                                 struct page *page, unsigned int len,
> > +                                 unsigned int offs, u64 lblk_num, gfp_=
t gfp_flags)
> > +{
> > +       struct ceph_mount_options *opt =3D ceph_inode_to_client(inode)-=
>mount_options;
> > +
> > +       if (opt->flags & CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR)
> > +               return 0;
> > +
> > +       dout("%s: len %u offs %u blk %llu\n", __func__, len, offs, lblk=
_num);
> > +       return fscrypt_encrypt_block_inplace(inode, page, len, offs, lb=
lk_num, gfp_flags);
> > +}
> > +
> > +/**
> > + * ceph_fscrypt_decrypt_pages - decrypt an array of pages
> > + * @inode: pointer to inode associated with these pages
> > + * @page: pointer to page array
> > + * @off: offset into the file that the read data starts
> > + * @len: max length to decrypt
> > + *
> > + * Decrypt an array of fscrypt'ed pages and return the amount of
> > + * data decrypted. Any data in the page prior to the start of the
> > + * first complete block in the read is ignored. Any incomplete
> > + * crypto blocks at the end of the array are ignored (and should
> > + * probably be zeroed by the caller).
> > + *
> > + * Returns the length of the decrypted data or a negative errno.
> > + */
> > +int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page=
, u64 off, int len)
> > +{
> > +       int i, num_blocks;
> > +       u64 baseblk =3D off >> CEPH_FSCRYPT_BLOCK_SHIFT;
> > +       int ret =3D 0;
> > +
> > +       /*
> > +        * We can't deal with partial blocks on an encrypted file, so m=
ask off
> > +        * the last bit.
> > +        */
> > +       num_blocks =3D ceph_fscrypt_blocks(off, len & CEPH_FSCRYPT_BLOC=
K_MASK);
> > +
> > +       /* Decrypt each block */
> > +       for (i =3D 0; i < num_blocks; ++i) {
> > +               int blkoff =3D i << CEPH_FSCRYPT_BLOCK_SHIFT;
> > +               int pgidx =3D blkoff >> PAGE_SHIFT;
> > +               unsigned int pgoffs =3D offset_in_page(blkoff);
> > +               int fret;
> > +
> > +               fret =3D ceph_fscrypt_decrypt_block_inplace(inode, page=
[pgidx],
> > +                               CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
> > +                               baseblk + i);
> > +               if (fret < 0) {
> > +                       if (ret =3D=3D 0)
> > +                               ret =3D fret;
> > +                       break;
> > +               }
> > +               ret +=3D CEPH_FSCRYPT_BLOCK_SIZE;
> > +       }
> > +       return ret;
> > +}
> > +
> > +/**
> > + * ceph_fscrypt_decrypt_extents: decrypt received extents in given buf=
fer
> > + * @inode: inode associated with pages being decrypted
> > + * @page: pointer to page array
> > + * @off: offset into the file that the data in page[0] starts
> > + * @map: pointer to extent array
> > + * @ext_cnt: length of extent array
> > + *
> > + * Given an extent map and a page array, decrypt the received data in-=
place,
> > + * skipping holes. Returns the offset into buffer of end of last decry=
pted
> > + * block.
> > + */
> > +int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **pa=
ge, u64 off,
> > +                                struct ceph_sparse_extent *map, u32 ex=
t_cnt)
> > +{
> > +       int i, ret =3D 0;
> > +       struct ceph_inode_info *ci =3D ceph_inode(inode);
> > +       u64 objno, objoff;
> > +       u32 xlen;
> > +
> > +       /* Nothing to do for empty array */
> > +       if (ext_cnt =3D=3D 0) {
> > +               dout("%s: empty array, ret 0\n", __func__);
> > +               return 0;
> > +       }
> > +
> > +       ceph_calc_file_object_mapping(&ci->i_layout, off, map[0].len,
> > +                                     &objno, &objoff, &xlen);
> > +
> > +       for (i =3D 0; i < ext_cnt; ++i) {
> > +               struct ceph_sparse_extent *ext =3D &map[i];
> > +               int pgsoff =3D ext->off - objoff;
> > +               int pgidx =3D pgsoff >> PAGE_SHIFT;
> > +               int fret;
> > +
> > +               if ((ext->off | ext->len) & ~CEPH_FSCRYPT_BLOCK_MASK) {
> > +                       pr_warn("%s: bad encrypted sparse extent idx %d=
 off %llx len %llx\n",
> > +                               __func__, i, ext->off, ext->len);
> > +                       return -EIO;
> > +               }
> > +               fret =3D ceph_fscrypt_decrypt_pages(inode, &page[pgidx]=
,
> > +                                                off + pgsoff, ext->len=
);
> > +               dout("%s: [%d] 0x%llx~0x%llx fret %d\n", __func__, i,
> > +                               ext->off, ext->len, fret);
> > +               if (fret < 0) {
> > +                       if (ret =3D=3D 0)
> > +                               ret =3D fret;
> > +                       break;
> > +               }
> > +               ret =3D pgsoff + fret;
> > +       }
> > +       dout("%s: ret %d\n", __func__, ret);
> > +       return ret;
> > +}
> > +
> > +/**
> > + * ceph_fscrypt_encrypt_pages - encrypt an array of pages
> > + * @inode: pointer to inode associated with these pages
> > + * @page: pointer to page array
> > + * @off: offset into the file that the data starts
> > + * @len: max length to encrypt
> > + * @gfp: gfp flags to use for allocation
> > + *
> > + * Decrypt an array of cleartext pages and return the amount of
> > + * data encrypted. Any data in the page prior to the start of the
> > + * first complete block in the read is ignored. Any incomplete
> > + * crypto blocks at the end of the array are ignored.
> > + *
> > + * Returns the length of the encrypted data or a negative errno.
> > + */
> > +int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page=
, u64 off,
> > +                               int len, gfp_t gfp)
> > +{
> > +       int i, num_blocks;
> > +       u64 baseblk =3D off >> CEPH_FSCRYPT_BLOCK_SHIFT;
> > +       int ret =3D 0;
> > +
> > +       /*
> > +        * We can't deal with partial blocks on an encrypted file, so m=
ask off
> > +        * the last bit.
> > +        */
> > +       num_blocks =3D ceph_fscrypt_blocks(off, len & CEPH_FSCRYPT_BLOC=
K_MASK);
> > +
> > +       /* Encrypt each block */
> > +       for (i =3D 0; i < num_blocks; ++i) {
> > +               int blkoff =3D i << CEPH_FSCRYPT_BLOCK_SHIFT;
> > +               int pgidx =3D blkoff >> PAGE_SHIFT;
> > +               unsigned int pgoffs =3D offset_in_page(blkoff);
> > +               int fret;
> > +
> > +               fret =3D ceph_fscrypt_encrypt_block_inplace(inode, page=
[pgidx],
> > +                               CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
> > +                               baseblk + i, gfp);
> > +               if (fret < 0) {
> > +                       if (ret =3D=3D 0)
> > +                               ret =3D fret;
> > +                       break;
> > +               }
> > +               ret +=3D CEPH_FSCRYPT_BLOCK_SIZE;
> > +       }
> > +       return ret;
> > +}
> > diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> > index 80acb23d0bb4..887f191cc423 100644
> > --- a/fs/ceph/crypto.h
> > +++ b/fs/ceph/crypto.h
> > @@ -100,6 +100,40 @@ int ceph_fname_to_usr(const struct ceph_fname *fna=
me, struct fscrypt_str *tname,
> >                         struct fscrypt_str *oname, bool *is_nokey);
> >  int ceph_fscrypt_prepare_readdir(struct inode *dir);
> >=20
> > +static inline unsigned int ceph_fscrypt_blocks(u64 off, u64 len)
> > +{
> > +       /* crypto blocks cannot span more than one page */
> > +       BUILD_BUG_ON(CEPH_FSCRYPT_BLOCK_SHIFT > PAGE_SHIFT);
> > +
> > +       return ((off+len+CEPH_FSCRYPT_BLOCK_SIZE-1) >> CEPH_FSCRYPT_BLO=
CK_SHIFT) -
> > +               (off >> CEPH_FSCRYPT_BLOCK_SHIFT);
> > +}
> > +
> > +/*
> > + * If we have an encrypted inode then we must adjust the offset and
> > + * range of the on-the-wire read to cover an entire encryption block.
> > + * The copy will be done using the original offset and length, after
> > + * we've decrypted the result.
> > + */
> > +static inline void ceph_fscrypt_adjust_off_and_len(struct inode *inode=
, u64 *off, u64 *len)
> > +{
> > +       if (IS_ENCRYPTED(inode)) {
> > +               *len =3D ceph_fscrypt_blocks(*off, *len) * CEPH_FSCRYPT=
_BLOCK_SIZE;
> > +               *off &=3D CEPH_FSCRYPT_BLOCK_MASK;
> > +       }
> > +}
> > +
> > +int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
> > +                                 struct page *page, unsigned int len,
> > +                                 unsigned int offs, u64 lblk_num);
> > +int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
> > +                                 struct page *page, unsigned int len,
> > +                                 unsigned int offs, u64 lblk_num, gfp_=
t gfp_flags);
> > +int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page=
, u64 off, int len);
> > +int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **pa=
ge, u64 off,
> > +                                struct ceph_sparse_extent *map, u32 ex=
t_cnt);
> > +int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page=
, u64 off,
> > +                               int len, gfp_t gfp);
> >  #else /* CONFIG_FS_ENCRYPTION */
> >=20
> >  static inline void ceph_fscrypt_set_ops(struct super_block *sb)
> > @@ -157,6 +191,43 @@ static inline int ceph_fscrypt_prepare_readdir(str=
uct inode *dir)
> >  {
> >         return 0;
> >  }
> > +
> > +static inline void ceph_fscrypt_adjust_off_and_len(struct inode *inode=
, u64 *off, u64 *len)
> > +{
> > +}
> > +
> > +static inline int ceph_fscrypt_decrypt_block_inplace(const struct inod=
e *inode,
> > +                                         struct page *page, unsigned i=
nt len,
> > +                                         unsigned int offs, u64 lblk_n=
um)
> > +{
> > +       return 0;
> > +}
> > +
> > +static inline int ceph_fscrypt_encrypt_block_inplace(const struct inod=
e *inode,
> > +                                 struct page *page, unsigned int len,
> > +                                 unsigned int offs, u64 lblk_num, gfp_=
t gfp_flags)
> > +{
> > +       return 0;
> > +}
> > +
> > +static inline int ceph_fscrypt_decrypt_pages(struct inode *inode, stru=
ct page **page,
> > +                                            u64 off, int len)
> > +{
> > +       return 0;
> > +}
> > +
> > +static inline int ceph_fscrypt_decrypt_extents(struct inode *inode, st=
ruct page **page,
> > +                                       u64 off, struct ceph_sparse_ext=
ent *map,
> > +                                       u32 ext_cnt)
> > +{
> > +       return 0;
> > +}
> > +
> > +static inline int ceph_fscrypt_encrypt_pages(struct inode *inode, stru=
ct page **page,
> > +                                            u64 off, int len, gfp_t gf=
p)
> > +{
> > +       return 0;
> > +}
> >  #endif /* CONFIG_FS_ENCRYPTION */
> >=20
> >  #endif
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index b9dd2fa36d8b..4b0a070d5c6d 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -591,6 +591,12 @@ static int ceph_parse_mount_param(struct fs_contex=
t *fc,
> >                 break;
> >         case Opt_test_dummy_encryption:
> >  #ifdef CONFIG_FS_ENCRYPTION
> > +               /* HACK: allow for cleartext "encryption" in files for =
testing */
> > +               if (param->string && !strcmp(param->string, "clear")) {
> > +                       fsopt->flags |=3D CEPH_MOUNT_OPT_DUMMY_ENC_CLEA=
R;
>=20
> I really wonder whether this is still needed?  Having a mount option
> that causes everything to be automatically encrypted with a dummy key
> for testing purposes makes total sense.  Making it possible to disable
> encryption through the same -- not so much.
>=20
> Does any other fscrypt-enabled filesystem in mainline do this?
>=20

I doubt it. It was totally a hack that I had in place to help debugging
when I was developing this. My intention was always to remove this
before merging it. I think doing that now would be a good idea.

--=20
Jeff Layton <jlayton@kernel.org>
