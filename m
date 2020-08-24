Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C414324FF10
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 15:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHXNjF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 09:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgHXNiv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Aug 2020 09:38:51 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC8EC061573
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 06:38:50 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i10so3038583iow.3
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 06:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r1vi6YqCbLqcpXfC7fccBjHJJsIi5VSiSWKuMcLax/4=;
        b=mD8BVANvp9HLG1AM+fc0pJdO/kZ18o/m3GCa2pzl5ZNhFA1mBE915feP2d014RnpRc
         /9QHPe/BwYUAbTusvUJjxY6YN0LfGE4BQSqDSjnKheXXovJkX7kKSVzp2Orib1lD/xr9
         3SaXkDGDsdAGvYpTI8dKU4Qy/a1gwXRiXzG7BjwGPsxzBTQqDGxSAslLJBrmozGeiJiq
         aY2UEK33AzHdqRaezIRqcx5qfxVDV+NmhMO6S3pLk6Ryowg2TLubvTl8mgM8tjgUO2H6
         szyALxA8yn7HMr78sf01v2TyVICNUsVw8oJTB7wVCuYF6mllVGhaZnyuEIie/uh8Ge6I
         qiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r1vi6YqCbLqcpXfC7fccBjHJJsIi5VSiSWKuMcLax/4=;
        b=KdNxAO0HlaWeM3hTzB8kjehilMKFjWfByn+rDVEQiUEn52QIQ7FX56ByUrFwHEqhRl
         jJKv61XFmBWFukWQCD/VFutbY34AUCRTF9LTRjrj1sb+0KCyFPQSPivYFQKT7J0sNG5Z
         zio3AAT8lU6wCQc3TGVOJMisj9JBnmb2r9r9Veo2qheHZg/lkXTBNPXHutiAvedn7Ubt
         uMrLEWldSrM+63RIgG2mJiX/Z0er0L7mNwKUEmn4PIrl2a4syNpNqai6BW7zzAhXPYS+
         EPsdclsO8mIxBs5UfkdfktSeQrggfF6zaXQunvAFKObNXUGXvGSmw25YDbTb5Gc/YpjE
         fhZw==
X-Gm-Message-State: AOAM5309rVaSA40KYDQ5owIJuHZsv9fC+hifbT6CVderJ8jPVZtnwmcf
        mgbNBLiGcWe+eTuc8//r5ycqtZ6Ulpf/PWh515s=
X-Google-Smtp-Source: ABdhPJwJ2DQZBiXreLJjD+Kv3ji2aHu4fXrXdub+Ad435v2bx3+bDRC9agDta7jJmkzO8K13WS4rhsgA/bhaoIsjSNg=
X-Received: by 2002:a02:aa87:: with SMTP id u7mr5643270jai.13.1598276329692;
 Mon, 24 Aug 2020 06:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200818162316.389462-1-jlayton@kernel.org> <20200819151645.38951-1-jlayton@kernel.org>
In-Reply-To: <20200819151645.38951-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 24 Aug 2020 21:38:38 +0800
Message-ID: <CAAM7YA=JmeYbLBcPji0yEKUQBEpn1iuxs0t+R=kLmSD1RuMghA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix inode number handling on arches with 32-bit ino_t
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, Ulrich.Weigand@de.ibm.com,
        Tuan.Hoang1@ibm.com, Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 11:20 PM Jeff Layton <jlayton@kernel.org> wrote:
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
> presenting these values to userland in getattr and readdir.
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
>  fs/ceph/caps.c       | 14 ++++-----
>  fs/ceph/debugfs.c    |  4 +--
>  fs/ceph/dir.c        | 31 ++++++++-----------
>  fs/ceph/file.c       |  4 +--
>  fs/ceph/inode.c      | 19 ++++++------
>  fs/ceph/mds_client.h |  2 +-
>  fs/ceph/quota.c      |  4 +--
>  fs/ceph/super.h      | 73 +++++++++++++++++++++++---------------------
>  8 files changed, 74 insertions(+), 77 deletions(-)
>
> v4:
> - flesh out comments in super.h
> - merge dout messages in ceph_get_inode
> - rename ceph_vino_to_ino to ceph_vino_to_ino_t
>
> v3:
> - use ceph_ino instead of ceph_present_ino in most dout() messages
>
> v2:
> - fix dir_emit inode number for ".."
> - fix ino_t size test
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 55ccccf77cea..034b3f4fdd3a 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -887,8 +887,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>         int have = ci->i_snap_caps;
>
>         if ((have & mask) == mask) {
> -               dout("__ceph_caps_issued_mask ino 0x%lx snap issued %s"
> -                    " (mask %s)\n", ci->vfs_inode.i_ino,
> +               dout("__ceph_caps_issued_mask ino 0x%llx snap issued %s"
> +                    " (mask %s)\n", ceph_ino(&ci->vfs_inode),
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
> +                            " (mask %s)\n", ceph_ino(&ci->vfs_inode), cap,
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
> +                            " (mask %s)\n", ceph_ino(&ci->vfs_inode),
>                              ceph_cap_string(cap->issued),
>                              ceph_cap_string(mask));
>                         if (touch) {
> @@ -2872,7 +2872,7 @@ int ceph_get_caps(struct file *filp, int need, int want,
>                         struct cap_wait cw;
>                         DEFINE_WAIT_FUNC(wait, woken_wake_function);
>
> -                       cw.ino = inode->i_ino;
> +                       cw.ino = ceph_ino(inode);
>                         cw.tgid = current->tgid;
>                         cw.need = need;
>                         cw.want = want;
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 97539b497e4c..3e3fcda9b276 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -202,7 +202,7 @@ static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
>  {
>         struct seq_file *s = p;
>
> -       seq_printf(s, "0x%-17lx%-17s%-17s\n", inode->i_ino,
> +       seq_printf(s, "0x%-17llx%-17s%-17s\n", ceph_ino(inode),
>                    ceph_cap_string(cap->issued),
>                    ceph_cap_string(cap->implemented));
>         return 0;
> @@ -247,7 +247,7 @@ static int caps_show(struct seq_file *s, void *p)
>
>         spin_lock(&mdsc->caps_list_lock);
>         list_for_each_entry(cw, &mdsc->cap_wait_list, list) {
> -               seq_printf(s, "%-13d0x%-17lx%-17s%-17s\n", cw->tgid, cw->ino,
> +               seq_printf(s, "%-13d0x%-17llx%-17s%-17s\n", cw->tgid, cw->ino,
>                                 ceph_cap_string(cw->need),
>                                 ceph_cap_string(cw->want));
>         }
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 060bdcc5ce32..040eaad9d063 100644
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
> +               dout("async unlink on %llu/%.*s caps=%s", ceph_ino(dir),
>                      dentry->d_name.len, dentry->d_name.name,
>                      ceph_cap_string(req->r_dir_caps));
>                 set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 28714934ced7..27c7047c9383 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -628,8 +628,8 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
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
> index 357c937699d5..d163fa96cb40 100644
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
> +       inode->i_ino = ceph_vino_to_ino_t(ci->i_vino);
>         inode_set_iversion_raw(inode, 0);
>         return 0;
>  }
> @@ -50,17 +52,14 @@ static int ceph_set_ino_cb(struct inode *inode, void *data)
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
> -       if (inode->i_state & I_NEW)
> -               dout("get_inode created new inode %p %llx.%llx ino %llx\n",
> -                    inode, ceph_vinop(inode), (u64)inode->i_ino);
>
> -       dout("get_inode on %lu=%llx.%llx got %p\n", inode->i_ino, vino.ino,
> -            vino.snap, inode);
> +       dout("get_inode on %llu=%llx.%llx got %p new %d\n", ceph_present_inode(inode),
> +            ceph_vinop(inode), inode, !!(inode->i_state & I_NEW));
>         return inode;
>  }
>
> @@ -2378,7 +2377,7 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
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
> index 4c3c964b1c54..a3995ebe0623 100644
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
> @@ -475,34 +467,17 @@ static inline u32 ceph_ino_to_ino32(__u64 vino)
>  }
>
>  /*
> - * kernel i_ino value
> + * Inode numbers in cephfs are 64 bits, but inode->i_ino is 32-bits on
> + * some arches. We generally do not use this value inside the ceph driver, but
> + * we do want to set it to something, so that generic vfs code has an
> + * appropriate value for tracepoints and the like.
>   */
> -static inline ino_t ceph_vino_to_ino(struct ceph_vino vino)
> +static inline ino_t ceph_vino_to_ino_t(struct ceph_vino vino)
>  {
> -#if BITS_PER_LONG == 32
> -       return ceph_ino_to_ino32(vino.ino);
> -#else
> +       if (sizeof(ino_t) == sizeof(u32))
> +               return ceph_ino_to_ino32(vino.ino);
>         return (ino_t)vino.ino;
> -#endif
> -}
> -
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
>  }
> -#endif
> -
>
>  /* for printf-style formatting */
>  #define ceph_vinop(i) ceph_inode(i)->i_vino.ino, ceph_inode(i)->i_vino.snap
> @@ -511,11 +486,34 @@ static inline u64 ceph_ino(struct inode *inode)
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
> @@ -524,11 +522,16 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>                 ci->i_vino.snap == pvino->snap;
>  }
>
> +
>  static inline struct inode *ceph_find_inode(struct super_block *sb,
>                                             struct ceph_vino vino)
>  {
> -       ino_t t = ceph_vino_to_ino(vino);
> -       return ilookup5(sb, t, ceph_ino_compare, &vino);
> +       /*
> +        * NB: The hashval will be run through the fs/inode.c hash function
> +        * anyway, so there is no need to squash the inode number down to
> +        * 32-bits first. Just use low-order bits on arches with 32-bit long.
> +        */
> +       return ilookup5(sb, (unsigned long)vino.ino, ceph_ino_compare, &vino);
>  }
>
    Reviewed-by: "Yan, Zheng" <zyan@redhat.com>


>
> --
> 2.26.2
>
