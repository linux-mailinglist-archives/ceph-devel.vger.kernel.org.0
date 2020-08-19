Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69074249296
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 03:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgHSB6g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Aug 2020 21:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSB6f (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Aug 2020 21:58:35 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875EFC061389
        for <ceph-devel@vger.kernel.org>; Tue, 18 Aug 2020 18:58:35 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id n129so20295990qkd.6
        for <ceph-devel@vger.kernel.org>; Tue, 18 Aug 2020 18:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7v95E293BMCy1zQwHD3R77UlfsRnHjqVj5s5q5vYXt0=;
        b=TCg+s4G+tYjBIFlOsc21z/EMzDWymzt2rtXc7Y1qBkvFja/UZzHmOaPUXgIAF1rUqa
         5Ol4TQtHP4Lt9Ad97EqR1Bilm1ugln4eZ6A7QlfX5gs01M1Hv2KPo6RNp8khJ5ZHzH4J
         EUdKvt8inZgTxFWxes7m9O+/6Ame43P16PVntSgRjHlc9RB3yXZDnzgq3V2bKi0rAZRL
         38DZkwI1Rj0PZnCN2SC70mZeuxS3CAEjEBW44P7VHya0yTtwbBstHoApQ/daPRNZtRyz
         7lxDHMmVpQZbS68iL4MjAxk0vG5NEOjsGPOVemMBsY2TCl7ygp93SggWJuXUQRw6MeJM
         W+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7v95E293BMCy1zQwHD3R77UlfsRnHjqVj5s5q5vYXt0=;
        b=VCTPVs8TI7dXp4rbzLCtQfOY/4Vc/iZitZE5VlD3uO2g6gjOeSimQUc3Ec406r7d7O
         Po4O53cCSAFONO3Nbo7/f2A4Das+SkSeTTH/rRAHYSpzYWmrAkX53ULz3Pl/FndQyzos
         2TWqIfYGew4tBPTs4rhODZxCmYVvViS4ueZc2mHPRqsMB3/l/lMvTBl5NZY3eTfzusnq
         Z1bz5Qrx9CcatTzL8+x1sK37jaopwvW3o9ZGNT6p+Yoj+Czk3RxfsJQ4BGTveAxXts28
         uxvXcCWD7v8mZUOHn/XoImDxoS93FfXqfbi3oLa0kHZiw78ewZbK/Boa238Xe+ZOikL9
         OrXQ==
X-Gm-Message-State: AOAM533YdLH72XpP7zpkrgjezIiuQLj9LO2VhOo2FvHHf08rRj6YDSmp
        VvuUa9ayeQsOec4s+A1t7e9PkU9jfJwxH8Ok2lY=
X-Google-Smtp-Source: ABdhPJwNNbaWTi0pPZKyDMuPPfjSJnsx6ErfN8HsquAtCBiWUEkX7HSIet62KhoGsS8MGxFzW0wZUX1tB0T1Y5SMVwA=
X-Received: by 2002:a05:620a:4f4:: with SMTP id b20mr19667213qkh.300.1597802314478;
 Tue, 18 Aug 2020 18:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200818162316.389462-1-jlayton@kernel.org> <20200818194904.706003-1-jlayton@kernel.org>
In-Reply-To: <20200818194904.706003-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 19 Aug 2020 09:58:22 +0800
Message-ID: <CAAM7YA=-vZ6GAdw2=PKQH+RzY6P8NTLPU7cuwtSQP9k_C7f5Fw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix inode number handling on arches with 32-bit ino_t
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, Ulrich.Weigand@de.ibm.com,
        Tuan.Hoang1@ibm.com, Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 3:52 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Tuan and Ulrich mentioned that they were hitting a problem on s390x,
> which has a 32-bit ino_t value, even though it's a 64-bit arch (for
> historical reasons).
>
> I think the current handling of inode numbers in the ceph driver is
> wrong. It tries to use 32-bit inode numbers on 32-bit arches, but that's
> actually not a problem. 32-bit arches can deal with 64-bit inode numbers
> just fine when userland code is compiled with LFS support (the common
> case these days).
>
> What we really want to do is just use 64-bit numbers everywhere, unless
> someone has mounted with the ino32 mount option. In that case, we want
> to ensure that we hash the inode number down to something that will fit
> in 32 bits before presenting the value to userland.
>
> Add new helper functions that do this, and only do the conversion before
> presenting these values to userland in getattr, readdir, debugfs, and
> (some) debug log messages.
>
> The inode table hashvalue is changed to just cast the inode number to
> unsigned long, as low-order bits are the most likely to vary anyway.
>
> While it's not strictly required, we do want to put something in
> inode->i_ino. Instead of basing it on BITS_PER_LONG, however, base it on
> the size of the ino_t type.
>
> Reported-by: Tuan Hoang1 <Tuan.Hoang1@ibm.com>
> Reported-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> URL: https://tracker.ceph.com/issues/46828
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 14 +++++-----
>  fs/ceph/debugfs.c    |  4 +--
>  fs/ceph/dir.c        | 31 +++++++++-------------
>  fs/ceph/file.c       |  4 +--
>  fs/ceph/inode.c      | 18 +++++++------
>  fs/ceph/mds_client.h |  2 +-
>  fs/ceph/quota.c      |  4 +--
>  fs/ceph/super.h      | 63 +++++++++++++++++++-------------------------
>  8 files changed, 64 insertions(+), 76 deletions(-)
>
> v2:
> - fix dir_emit inode number for ".."
> - fix ino_t size test
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 55ccccf77cea..d5b1f781f398 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -887,8 +887,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>         int have = ci->i_snap_caps;
>
>         if ((have & mask) == mask) {
> -               dout("__ceph_caps_issued_mask ino 0x%lx snap issued %s"
> -                    " (mask %s)\n", ci->vfs_inode.i_ino,
> +               dout("__ceph_caps_issued_mask ino 0x%llx snap issued %s"
> +                    " (mask %s)\n", ceph_present_inode(&ci->vfs_inode),

debug output should alway use 64 bits ino number

>                      ceph_cap_string(have),
>                      ceph_cap_string(mask));
>                 return 1;
> @@ -899,8 +899,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>                 if (!__cap_is_valid(cap))
>                         continue;
>                 if ((cap->issued & mask) == mask) {
> -                       dout("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s"
> -                            " (mask %s)\n", ci->vfs_inode.i_ino, cap,
> +                       dout("__ceph_caps_issued_mask ino 0x%llx cap %p issued %s"
> +                            " (mask %s)\n", ceph_present_inode(&ci->vfs_inode), cap,
>                              ceph_cap_string(cap->issued),
>                              ceph_cap_string(mask));
>                         if (touch)
> @@ -911,8 +911,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>                 /* does a combination of caps satisfy mask? */
>                 have |= cap->issued;
>                 if ((have & mask) == mask) {
> -                       dout("__ceph_caps_issued_mask ino 0x%lx combo issued %s"
> -                            " (mask %s)\n", ci->vfs_inode.i_ino,
> +                       dout("__ceph_caps_issued_mask ino 0x%llx combo issued %s"
> +                            " (mask %s)\n", ceph_present_inode(&ci->vfs_inode),
>                              ceph_cap_string(cap->issued),
>                              ceph_cap_string(mask));
>                         if (touch) {
> @@ -2872,7 +2872,7 @@ int ceph_get_caps(struct file *filp, int need, int want,
>                         struct cap_wait cw;
>                         DEFINE_WAIT_FUNC(wait, woken_wake_function);
>
> -                       cw.ino = inode->i_ino;
> +                       cw.ino = ceph_present_inode(inode);

should always assign 64 bits inode number to it

>                         cw.tgid = current->tgid;
>                         cw.need = need;
>                         cw.want = want;
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 20043382d825..5eeca7987717 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -211,7 +211,7 @@ static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
>  {
>         struct seq_file *s = p;
>
> -       seq_printf(s, "0x%-17lx%-17s%-17s\n", inode->i_ino,
> +       seq_printf(s, "0x%-17llx%-17s%-17s\n", ceph_present_inode(inode),
>                    ceph_cap_string(cap->issued),
>                    ceph_cap_string(cap->implemented));
>         return 0;
> @@ -256,7 +256,7 @@ static int caps_show(struct seq_file *s, void *p)
>
>         spin_lock(&mdsc->caps_list_lock);
>         list_for_each_entry(cw, &mdsc->cap_wait_list, list) {
> -               seq_printf(s, "%-13d0x%-17lx%-17s%-17s\n", cw->tgid, cw->ino,
> +               seq_printf(s, "%-13d0x%-17llx%-17s%-17s\n", cw->tgid, cw->ino,
>                                 ceph_cap_string(cw->need),
>                                 ceph_cap_string(cw->want));
>         }
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 060bdcc5ce32..1a61a435a1cd 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -259,9 +259,7 @@ static int __dcache_readdir(struct file *file,  struct dir_context *ctx,
>                              dentry, dentry, d_inode(dentry));
>                         ctx->pos = di->offset;
>                         if (!dir_emit(ctx, dentry->d_name.name,
> -                                     dentry->d_name.len,
> -                                     ceph_translate_ino(dentry->d_sb,
> -                                                        d_inode(dentry)->i_ino),
> +                                     dentry->d_name.len, ceph_present_inode(d_inode(dentry)),
>                                       d_inode(dentry)->i_mode >> 12)) {
>                                 dput(dentry);
>                                 err = 0;
> @@ -324,18 +322,21 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>         /* always start with . and .. */
>         if (ctx->pos == 0) {
>                 dout("readdir off 0 -> '.'\n");
> -               if (!dir_emit(ctx, ".", 1,
> -                           ceph_translate_ino(inode->i_sb, inode->i_ino),
> +               if (!dir_emit(ctx, ".", 1, ceph_present_inode(inode),
>                             inode->i_mode >> 12))
>                         return 0;
>                 ctx->pos = 1;
>         }
>         if (ctx->pos == 1) {
> -               ino_t ino = parent_ino(file->f_path.dentry);
> +               u64 ino;
> +               struct dentry *dentry = file->f_path.dentry;
> +
> +               spin_lock(&dentry->d_lock);
> +               ino = ceph_present_inode(dentry->d_parent->d_inode);
> +               spin_unlock(&dentry->d_lock);
> +
>                 dout("readdir off 1 -> '..'\n");
> -               if (!dir_emit(ctx, "..", 2,
> -                           ceph_translate_ino(inode->i_sb, ino),
> -                           inode->i_mode >> 12))
> +               if (!dir_emit(ctx, "..", 2, ino, inode->i_mode >> 12))
>                         return 0;
>                 ctx->pos = 2;
>         }
> @@ -507,9 +508,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>         }
>         for (; i < rinfo->dir_nr; i++) {
>                 struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> -               struct ceph_vino vino;
> -               ino_t ino;
> -               u32 ftype;
>
>                 BUG_ON(rde->offset < ctx->pos);
>
> @@ -519,13 +517,10 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>                      rde->name_len, rde->name, &rde->inode.in);
>
>                 BUG_ON(!rde->inode.in);
> -               ftype = le32_to_cpu(rde->inode.in->mode) >> 12;
> -               vino.ino = le64_to_cpu(rde->inode.in->ino);
> -               vino.snap = le64_to_cpu(rde->inode.in->snapid);
> -               ino = ceph_vino_to_ino(vino);
>
>                 if (!dir_emit(ctx, rde->name, rde->name_len,
> -                             ceph_translate_ino(inode->i_sb, ino), ftype)) {
> +                             ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
> +                             le32_to_cpu(rde->inode.in->mode) >> 12)) {
>                         dout("filldir stopping us...\n");
>                         return 0;
>                 }
> @@ -1161,7 +1156,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
>
>         if (try_async && op == CEPH_MDS_OP_UNLINK &&
>             (req->r_dir_caps = get_caps_for_async_unlink(dir, dentry))) {
> -               dout("async unlink on %lu/%.*s caps=%s", dir->i_ino,
> +               dout("async unlink on %llu/%.*s caps=%s", ceph_present_inode(dir),
>                      dentry->d_name.len, dentry->d_name.name,
>                      ceph_cap_string(req->r_dir_caps));
>                 set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 5fa28a620932..20e0c6f1d8f2 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -642,8 +642,8 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>         } else {
>                 struct dentry *dn;
>
> -               dout("%s d_adding new inode 0x%llx to 0x%lx/%s\n", __func__,
> -                       vino.ino, dir->i_ino, dentry->d_name.name);
> +               dout("%s d_adding new inode 0x%llx to 0x%llx/%s\n", __func__,
> +                       vino.ino, ceph_ino(dir), dentry->d_name.name);
>                 ceph_dir_clear_ordered(dir);
>                 ceph_init_inode_acls(inode, as_ctx);
>                 if (inode->i_state & I_NEW) {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 357c937699d5..8dbb56d2edef 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -41,8 +41,10 @@ static void ceph_inode_work(struct work_struct *work);
>   */
>  static int ceph_set_ino_cb(struct inode *inode, void *data)
>  {
> -       ceph_inode(inode)->i_vino = *(struct ceph_vino *)data;
> -       inode->i_ino = ceph_vino_to_ino(*(struct ceph_vino *)data);
> +       struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +       ci->i_vino = *(struct ceph_vino *)data;
> +       inode->i_ino = ceph_vino_to_ino(ci->i_vino);
>         inode_set_iversion_raw(inode, 0);
>         return 0;
>  }
> @@ -50,17 +52,17 @@ static int ceph_set_ino_cb(struct inode *inode, void *data)
>  struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>  {
>         struct inode *inode;
> -       ino_t t = ceph_vino_to_ino(vino);
>
> -       inode = iget5_locked(sb, t, ceph_ino_compare, ceph_set_ino_cb, &vino);
> +       inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
> +                            ceph_set_ino_cb, &vino);
>         if (!inode)
>                 return ERR_PTR(-ENOMEM);
>         if (inode->i_state & I_NEW)
>                 dout("get_inode created new inode %p %llx.%llx ino %llx\n",
> -                    inode, ceph_vinop(inode), (u64)inode->i_ino);
> +                    inode, ceph_vinop(inode), ceph_present_inode(inode));
>
> -       dout("get_inode on %lu=%llx.%llx got %p\n", inode->i_ino, vino.ino,
> -            vino.snap, inode);
> +       dout("get_inode on %llu=%llx.%llx got %p\n", ceph_present_inode(inode),
> +            vino.ino, vino.snap, inode);
>         return inode;
>  }
>
> @@ -2378,7 +2380,7 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
>         }
>
>         generic_fillattr(inode, stat);
> -       stat->ino = ceph_translate_ino(inode->i_sb, inode->i_ino);
> +       stat->ino = ceph_present_inode(inode);
>
>         /*
>          * btime on newly-allocated inodes is 0, so if this is still set to
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index bc9e95937d7c..658800605bfb 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -372,7 +372,7 @@ struct ceph_quotarealm_inode {
>
>  struct cap_wait {
>         struct list_head        list;
> -       unsigned long           ino;
> +       u64                     ino;
>         pid_t                   tgid;
>         int                     need;
>         int                     want;
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 198ddde5c1e6..cc2c4d40b022 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -23,12 +23,12 @@ static inline bool ceph_has_realms_with_quotas(struct inode *inode)
>  {
>         struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>         struct super_block *sb = mdsc->fsc->sb;
> +       struct inode *root = d_inode(sb->s_root);
>
>         if (atomic64_read(&mdsc->quotarealms_count) > 0)
>                 return true;
>         /* if root is the real CephFS root, we don't have quota realms */
> -       if (sb->s_root->d_inode &&
> -           (sb->s_root->d_inode->i_ino == CEPH_INO_ROOT))
> +       if (root && ceph_ino(root) == CEPH_INO_ROOT)
>                 return false;
>         /* otherwise, we can't know for sure */
>         return true;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 4c3c964b1c54..0dd272a4a410 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -457,15 +457,7 @@ ceph_vino(const struct inode *inode)
>         return ceph_inode(inode)->i_vino;
>  }
>
> -/*
> - * ino_t is <64 bits on many architectures, blech.
> - *
> - *               i_ino (kernel inode)   st_ino (userspace)
> - * i386          32                     32
> - * x86_64+ino32  64                     32
> - * x86_64        64                     64
> - */
> -static inline u32 ceph_ino_to_ino32(__u64 vino)
> +static inline u32 ceph_ino_to_ino32(u64 vino)
>  {
>         u32 ino = vino & 0xffffffff;
>         ino ^= vino >> 32;
> @@ -474,36 +466,13 @@ static inline u32 ceph_ino_to_ino32(__u64 vino)
>         return ino;
>  }
>
> -/*
> - * kernel i_ino value
> - */
>  static inline ino_t ceph_vino_to_ino(struct ceph_vino vino)
>  {
> -#if BITS_PER_LONG == 32
> -       return ceph_ino_to_ino32(vino.ino);
> -#else
> +       if (sizeof(ino_t) == sizeof(u32))
> +               return ceph_ino_to_ino32(vino.ino);
>         return (ino_t)vino.ino;
> -#endif
>  }
>
> -/*
> - * user-visible ino (stat, filldir)
> - */
> -#if BITS_PER_LONG == 32
> -static inline ino_t ceph_translate_ino(struct super_block *sb, ino_t ino)
> -{
> -       return ino;
> -}
> -#else
> -static inline ino_t ceph_translate_ino(struct super_block *sb, ino_t ino)
> -{
> -       if (ceph_test_mount_opt(ceph_sb_to_client(sb), INO32))
> -               ino = ceph_ino_to_ino32(ino);
> -       return ino;
> -}
> -#endif
> -
> -
>  /* for printf-style formatting */
>  #define ceph_vinop(i) ceph_inode(i)->i_vino.ino, ceph_inode(i)->i_vino.snap
>
> @@ -511,11 +480,34 @@ static inline u64 ceph_ino(struct inode *inode)
>  {
>         return ceph_inode(inode)->i_vino.ino;
>  }
> +
>  static inline u64 ceph_snap(struct inode *inode)
>  {
>         return ceph_inode(inode)->i_vino.snap;
>  }
>
> +/**
> + * ceph_present_ino - format an inode number for presentation to userland
> + * @sb: superblock where the inode lives
> + * @ino: inode number to (possibly) convert
> + *
> + * If the user mounted with the ino32 option, then the 64-bit value needs
> + * to be converted to something that can fit inside 32 bits. Note that
> + * internal kernel code never uses this value, so this is entirely for
> + * userland consumption.
> + */
> +static inline u64 ceph_present_ino(struct super_block *sb, u64 ino)
> +{
> +       if (unlikely(ceph_test_mount_opt(ceph_sb_to_client(sb), INO32)))
> +               return ceph_ino_to_ino32(ino);
> +       return ino;
> +}
> +
> +static inline u64 ceph_present_inode(struct inode *inode)
> +{
> +       return ceph_present_ino(inode->i_sb, ceph_ino(inode));
> +}
> +
>  static inline int ceph_ino_compare(struct inode *inode, void *data)
>  {
>         struct ceph_vino *pvino = (struct ceph_vino *)data;
> @@ -527,8 +519,7 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>  static inline struct inode *ceph_find_inode(struct super_block *sb,
>                                             struct ceph_vino vino)
>  {
> -       ino_t t = ceph_vino_to_ino(vino);
> -       return ilookup5(sb, t, ceph_ino_compare, &vino);
> +       return ilookup5(sb, (unsigned long)vino.ino, ceph_ino_compare, &vino);
>  }
>
>
> --
> 2.26.2
>
