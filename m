Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3273B6E3BC4
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Apr 2023 22:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDPUBU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 16:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPUBT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 16:01:19 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC0E1FF3
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 13:01:16 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fy21so15993319ejb.9
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 13:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681675275; x=1684267275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+xAjk1nhcvn/Agi3T7O47qtBtcCEBLEAuJ9Owi28Zc=;
        b=CTtV8ypMngH5rxS0F8YB3u41z3plQoUVDbrVN+4E98RTQZHaQCfn21e0H2o0ra1Yat
         VDSfdaw2Dwj1DJXfzO0o1J6hpy0+EEYmsLv98W0O7GyRG4C6FbaBjnrddgoE6XEUxdtF
         BZectekv/VZdzEAqtUvaOIFtdxTch0G7RBCbUjUjLYt5kifwglR/QsPFAMlG3Bh1wMfG
         fG+rPOUtexwKQJcOmyNEmEbmGXsWKskkF/hX87oL5IepXHZyZTxw4HLXV6v5yLQN/+aI
         m4UvMApEOrTl+fr33YYk2vhbq1CRMk+Laz4RKqRisvSHb0nzRUjS+y+ldei3Fn/fOL3p
         Ha+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681675275; x=1684267275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+xAjk1nhcvn/Agi3T7O47qtBtcCEBLEAuJ9Owi28Zc=;
        b=bvJcb3YSHJe/A7OiX8tvDe4JuI9RobahPRBTftfOQfimX25dmpvd+lw+IibDYEjUfi
         wt3mI/alqPTomsEm89XI0RIa+LbmxWuvSCjUDCopM73MO+NbUrINQlm5pk7lp8MCJzCS
         2KHHhN2aUAughDGaYlYCLPBDSTBMGk7elHlsXYDhjbwIsSB/VekXkRJpnUdF+gdy3QOg
         pSOw+gasZ98HOG6L9k3tovh1KVabZeRSebentLoYeQZzpEd1E+WOxRSjOu0076Tpggsx
         Dxb25ApQ/KEbZvCj4fEBFoHxW/TTNwXPwqv/UYJ/mYz0VQn2KhLbrrfoz1HQ4RsrOyZy
         sOIg==
X-Gm-Message-State: AAQBX9dUHDDBcS1+E+ntChA9y/TVYq4OPYRvo3ZsRT/BlQWynTFBgBex
        qwAtwe+CepOH7kpKIzVubb3VdSwcAqyUqZP55Es=
X-Google-Smtp-Source: AKy350b8Og/AP+zcl1clVj6tcwttwt6ngjexgRBWzTBoraprVABw8bn7sBS0ba3w3muoKk57XfhWwqzzcALPQ4YfvmA=
X-Received: by 2002:a17:906:3e57:b0:90b:53f6:fd8b with SMTP id
 t23-20020a1709063e5700b0090b53f6fd8bmr5928640eji.31.1681675275019; Sun, 16
 Apr 2023 13:01:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230412110930.176835-1-xiubli@redhat.com> <20230412110930.176835-49-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-49-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 16 Apr 2023 22:01:03 +0200
Message-ID: <CAOi1vP-tVvBCEfu_3ofdwHaEoZr7qo102cZ8BPy8q67DDk-2tw@mail.gmail.com>
Subject: Re: [PATCH v18 48/71] ceph: add infrastructure for file encryption
 and decryption
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, lhenriques@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 12, 2023 at 1:13=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Jeff Layton <jlayton@kernel.org>
>
> ...and allow test_dummy_encryption to bypass content encryption
> if mounted with test_dummy_encryption=3Dclear.
>
> Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Tested-by: Venky Shankar <vshankar@redhat.com>
> Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/crypto.c | 177 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/crypto.h |  71 +++++++++++++++++++
>  fs/ceph/super.c  |   6 ++
>  fs/ceph/super.h  |   1 +
>  4 files changed, 255 insertions(+)
>
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index fe47fbdaead9..35e292045e9d 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -9,6 +9,7 @@
>  #include <linux/ceph/ceph_debug.h>
>  #include <linux/xattr.h>
>  #include <linux/fscrypt.h>
> +#include <linux/ceph/striper.h>
>
>  #include "super.h"
>  #include "mds_client.h"
> @@ -354,3 +355,179 @@ int ceph_fscrypt_prepare_readdir(struct inode *dir)
>         }
>         return 0;
>  }
> +
> +int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
> +                                 struct page *page, unsigned int len,
> +                                 unsigned int offs, u64 lblk_num)
> +{
> +       struct ceph_mount_options *opt =3D ceph_inode_to_client(inode)->m=
ount_options;
> +
> +       if (opt->flags & CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR)
> +               return 0;
> +
> +       dout("%s: len %u offs %u blk %llu\n", __func__, len, offs, lblk_n=
um);
> +       return fscrypt_decrypt_block_inplace(inode, page, len, offs, lblk=
_num);
> +}
> +
> +int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
> +                                 struct page *page, unsigned int len,
> +                                 unsigned int offs, u64 lblk_num, gfp_t =
gfp_flags)
> +{
> +       struct ceph_mount_options *opt =3D ceph_inode_to_client(inode)->m=
ount_options;
> +
> +       if (opt->flags & CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR)
> +               return 0;
> +
> +       dout("%s: len %u offs %u blk %llu\n", __func__, len, offs, lblk_n=
um);
> +       return fscrypt_encrypt_block_inplace(inode, page, len, offs, lblk=
_num, gfp_flags);
> +}
> +
> +/**
> + * ceph_fscrypt_decrypt_pages - decrypt an array of pages
> + * @inode: pointer to inode associated with these pages
> + * @page: pointer to page array
> + * @off: offset into the file that the read data starts
> + * @len: max length to decrypt
> + *
> + * Decrypt an array of fscrypt'ed pages and return the amount of
> + * data decrypted. Any data in the page prior to the start of the
> + * first complete block in the read is ignored. Any incomplete
> + * crypto blocks at the end of the array are ignored (and should
> + * probably be zeroed by the caller).
> + *
> + * Returns the length of the decrypted data or a negative errno.
> + */
> +int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page, =
u64 off, int len)
> +{
> +       int i, num_blocks;
> +       u64 baseblk =3D off >> CEPH_FSCRYPT_BLOCK_SHIFT;
> +       int ret =3D 0;
> +
> +       /*
> +        * We can't deal with partial blocks on an encrypted file, so mas=
k off
> +        * the last bit.
> +        */
> +       num_blocks =3D ceph_fscrypt_blocks(off, len & CEPH_FSCRYPT_BLOCK_=
MASK);
> +
> +       /* Decrypt each block */
> +       for (i =3D 0; i < num_blocks; ++i) {
> +               int blkoff =3D i << CEPH_FSCRYPT_BLOCK_SHIFT;
> +               int pgidx =3D blkoff >> PAGE_SHIFT;
> +               unsigned int pgoffs =3D offset_in_page(blkoff);
> +               int fret;
> +
> +               fret =3D ceph_fscrypt_decrypt_block_inplace(inode, page[p=
gidx],
> +                               CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
> +                               baseblk + i);
> +               if (fret < 0) {
> +                       if (ret =3D=3D 0)
> +                               ret =3D fret;
> +                       break;
> +               }
> +               ret +=3D CEPH_FSCRYPT_BLOCK_SIZE;
> +       }
> +       return ret;
> +}
> +
> +/**
> + * ceph_fscrypt_decrypt_extents: decrypt received extents in given buffe=
r
> + * @inode: inode associated with pages being decrypted
> + * @page: pointer to page array
> + * @off: offset into the file that the data in page[0] starts
> + * @map: pointer to extent array
> + * @ext_cnt: length of extent array
> + *
> + * Given an extent map and a page array, decrypt the received data in-pl=
ace,
> + * skipping holes. Returns the offset into buffer of end of last decrypt=
ed
> + * block.
> + */
> +int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page=
, u64 off,
> +                                struct ceph_sparse_extent *map, u32 ext_=
cnt)
> +{
> +       int i, ret =3D 0;
> +       struct ceph_inode_info *ci =3D ceph_inode(inode);
> +       u64 objno, objoff;
> +       u32 xlen;
> +
> +       /* Nothing to do for empty array */
> +       if (ext_cnt =3D=3D 0) {
> +               dout("%s: empty array, ret 0\n", __func__);
> +               return 0;
> +       }
> +
> +       ceph_calc_file_object_mapping(&ci->i_layout, off, map[0].len,
> +                                     &objno, &objoff, &xlen);
> +
> +       for (i =3D 0; i < ext_cnt; ++i) {
> +               struct ceph_sparse_extent *ext =3D &map[i];
> +               int pgsoff =3D ext->off - objoff;
> +               int pgidx =3D pgsoff >> PAGE_SHIFT;
> +               int fret;
> +
> +               if ((ext->off | ext->len) & ~CEPH_FSCRYPT_BLOCK_MASK) {
> +                       pr_warn("%s: bad encrypted sparse extent idx %d o=
ff %llx len %llx\n",
> +                               __func__, i, ext->off, ext->len);
> +                       return -EIO;
> +               }
> +               fret =3D ceph_fscrypt_decrypt_pages(inode, &page[pgidx],
> +                                                off + pgsoff, ext->len);
> +               dout("%s: [%d] 0x%llx~0x%llx fret %d\n", __func__, i,
> +                               ext->off, ext->len, fret);
> +               if (fret < 0) {
> +                       if (ret =3D=3D 0)
> +                               ret =3D fret;
> +                       break;
> +               }
> +               ret =3D pgsoff + fret;
> +       }
> +       dout("%s: ret %d\n", __func__, ret);
> +       return ret;
> +}
> +
> +/**
> + * ceph_fscrypt_encrypt_pages - encrypt an array of pages
> + * @inode: pointer to inode associated with these pages
> + * @page: pointer to page array
> + * @off: offset into the file that the data starts
> + * @len: max length to encrypt
> + * @gfp: gfp flags to use for allocation
> + *
> + * Decrypt an array of cleartext pages and return the amount of
> + * data encrypted. Any data in the page prior to the start of the
> + * first complete block in the read is ignored. Any incomplete
> + * crypto blocks at the end of the array are ignored.
> + *
> + * Returns the length of the encrypted data or a negative errno.
> + */
> +int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, =
u64 off,
> +                               int len, gfp_t gfp)
> +{
> +       int i, num_blocks;
> +       u64 baseblk =3D off >> CEPH_FSCRYPT_BLOCK_SHIFT;
> +       int ret =3D 0;
> +
> +       /*
> +        * We can't deal with partial blocks on an encrypted file, so mas=
k off
> +        * the last bit.
> +        */
> +       num_blocks =3D ceph_fscrypt_blocks(off, len & CEPH_FSCRYPT_BLOCK_=
MASK);
> +
> +       /* Encrypt each block */
> +       for (i =3D 0; i < num_blocks; ++i) {
> +               int blkoff =3D i << CEPH_FSCRYPT_BLOCK_SHIFT;
> +               int pgidx =3D blkoff >> PAGE_SHIFT;
> +               unsigned int pgoffs =3D offset_in_page(blkoff);
> +               int fret;
> +
> +               fret =3D ceph_fscrypt_encrypt_block_inplace(inode, page[p=
gidx],
> +                               CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
> +                               baseblk + i, gfp);
> +               if (fret < 0) {
> +                       if (ret =3D=3D 0)
> +                               ret =3D fret;
> +                       break;
> +               }
> +               ret +=3D CEPH_FSCRYPT_BLOCK_SIZE;
> +       }
> +       return ret;
> +}
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index 80acb23d0bb4..887f191cc423 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -100,6 +100,40 @@ int ceph_fname_to_usr(const struct ceph_fname *fname=
, struct fscrypt_str *tname,
>                         struct fscrypt_str *oname, bool *is_nokey);
>  int ceph_fscrypt_prepare_readdir(struct inode *dir);
>
> +static inline unsigned int ceph_fscrypt_blocks(u64 off, u64 len)
> +{
> +       /* crypto blocks cannot span more than one page */
> +       BUILD_BUG_ON(CEPH_FSCRYPT_BLOCK_SHIFT > PAGE_SHIFT);
> +
> +       return ((off+len+CEPH_FSCRYPT_BLOCK_SIZE-1) >> CEPH_FSCRYPT_BLOCK=
_SHIFT) -
> +               (off >> CEPH_FSCRYPT_BLOCK_SHIFT);
> +}
> +
> +/*
> + * If we have an encrypted inode then we must adjust the offset and
> + * range of the on-the-wire read to cover an entire encryption block.
> + * The copy will be done using the original offset and length, after
> + * we've decrypted the result.
> + */
> +static inline void ceph_fscrypt_adjust_off_and_len(struct inode *inode, =
u64 *off, u64 *len)
> +{
> +       if (IS_ENCRYPTED(inode)) {
> +               *len =3D ceph_fscrypt_blocks(*off, *len) * CEPH_FSCRYPT_B=
LOCK_SIZE;
> +               *off &=3D CEPH_FSCRYPT_BLOCK_MASK;
> +       }
> +}
> +
> +int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
> +                                 struct page *page, unsigned int len,
> +                                 unsigned int offs, u64 lblk_num);
> +int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
> +                                 struct page *page, unsigned int len,
> +                                 unsigned int offs, u64 lblk_num, gfp_t =
gfp_flags);
> +int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page, =
u64 off, int len);
> +int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page=
, u64 off,
> +                                struct ceph_sparse_extent *map, u32 ext_=
cnt);
> +int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, =
u64 off,
> +                               int len, gfp_t gfp);
>  #else /* CONFIG_FS_ENCRYPTION */
>
>  static inline void ceph_fscrypt_set_ops(struct super_block *sb)
> @@ -157,6 +191,43 @@ static inline int ceph_fscrypt_prepare_readdir(struc=
t inode *dir)
>  {
>         return 0;
>  }
> +
> +static inline void ceph_fscrypt_adjust_off_and_len(struct inode *inode, =
u64 *off, u64 *len)
> +{
> +}
> +
> +static inline int ceph_fscrypt_decrypt_block_inplace(const struct inode =
*inode,
> +                                         struct page *page, unsigned int=
 len,
> +                                         unsigned int offs, u64 lblk_num=
)
> +{
> +       return 0;
> +}
> +
> +static inline int ceph_fscrypt_encrypt_block_inplace(const struct inode =
*inode,
> +                                 struct page *page, unsigned int len,
> +                                 unsigned int offs, u64 lblk_num, gfp_t =
gfp_flags)
> +{
> +       return 0;
> +}
> +
> +static inline int ceph_fscrypt_decrypt_pages(struct inode *inode, struct=
 page **page,
> +                                            u64 off, int len)
> +{
> +       return 0;
> +}
> +
> +static inline int ceph_fscrypt_decrypt_extents(struct inode *inode, stru=
ct page **page,
> +                                       u64 off, struct ceph_sparse_exten=
t *map,
> +                                       u32 ext_cnt)
> +{
> +       return 0;
> +}
> +
> +static inline int ceph_fscrypt_encrypt_pages(struct inode *inode, struct=
 page **page,
> +                                            u64 off, int len, gfp_t gfp)
> +{
> +       return 0;
> +}
>  #endif /* CONFIG_FS_ENCRYPTION */
>
>  #endif
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index b9dd2fa36d8b..4b0a070d5c6d 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -591,6 +591,12 @@ static int ceph_parse_mount_param(struct fs_context =
*fc,
>                 break;
>         case Opt_test_dummy_encryption:
>  #ifdef CONFIG_FS_ENCRYPTION
> +               /* HACK: allow for cleartext "encryption" in files for te=
sting */
> +               if (param->string && !strcmp(param->string, "clear")) {
> +                       fsopt->flags |=3D CEPH_MOUNT_OPT_DUMMY_ENC_CLEAR;

I really wonder whether this is still needed?  Having a mount option
that causes everything to be automatically encrypted with a dummy key
for testing purposes makes total sense.  Making it possible to disable
encryption through the same -- not so much.

Does any other fscrypt-enabled filesystem in mainline do this?

Thanks,

                Ilya
