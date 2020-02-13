Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB71B15BE9E
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 13:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgBMMpF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 07:45:05 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42048 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729532AbgBMMpF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 07:45:05 -0500
Received: by mail-qk1-f196.google.com with SMTP id o28so4128200qkj.9
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 04:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZNYmjHg2NM2DRBJQeGlMWHv2WKQkVFZaN0hMcHRnvvA=;
        b=teQYSPuhWDlJI47jxJ/bbalhjaKTnMCSAFNuAAvZ5Th9t9z9MaFQlseX9JBKoRHR/m
         LdtSouBABQb9tJZyjmqO8ilvnGnakvrzl5Hk/wF1EYsI5b0NietsYrFcE3hZjkoLrts+
         0A/6PueaLCeTp2OavqRheLshuKeB+IjTe2y0AAkAgneSXzi5LQQ6i9Dyi8HxX6dBHPT4
         Cp0TPBNmTPAcv1LgOgo2nUcU05KHCV4guxoo61aaVB2GGBhe9ho94rVSYKNXdazjv5sM
         tCtk7Ni7HvGDHHpJXhdwnDz8KkQj6CueVb1EWd9jMa7GbDh8a1FbYDBEussFNXJ1a9Yl
         gp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZNYmjHg2NM2DRBJQeGlMWHv2WKQkVFZaN0hMcHRnvvA=;
        b=ZUPGwjBQoCYGTFxNTb2apfaLOYHEGjDc48wEFJtqq1A5Bq1ufdy4GUVDfrmJuOeUZT
         MrSSCrMQXx7fZraWrM14kk2ZhDVB4mp3gKefCn3DQWHklIbMtQ6vYOgiOf24q39Fn5YW
         MRw9sPG5aPpBViV4JjHC8/KRfIQwQQ1PydpE2CM61Qxyo8nDs8ga+4NKhSIPJsugZmx1
         RBggWPGi6VNFeaPw3gv8q6VOJPDTIsTvs5zY0EnEZahxWys8s5OUVWUimmneMnpI7Eb9
         66z2ZAp/xlCcb62kJ2Pd+6FYukYal5I/bHOfyI7b533XPe9vVjNO+7MVXjXF8sKc+npq
         kwRw==
X-Gm-Message-State: APjAAAVp+yUEuyAD4D+lo/fRlOMwg9BK5juz+g9FCHHtTokUlKTKeCQX
        wJDDVuwHhwbDZ4IEnemzqSj1WtvFG/w1Hp1qsDLtGWEinTZ/4Q==
X-Google-Smtp-Source: APXvYqwX5Z/PPoAfr1kIMotkzjw02scApdK+FHvez2q2cB7hLf1ZKerPKqCLOjYszQ+ylkC5Pha2+MvDm89BV1GTQNI=
X-Received: by 2002:a05:620a:1530:: with SMTP id n16mr12062596qkk.394.1581597903965;
 Thu, 13 Feb 2020 04:45:03 -0800 (PST)
MIME-Version: 1.0
References: <20200212172729.260752-1-jlayton@kernel.org> <20200212172729.260752-10-jlayton@kernel.org>
In-Reply-To: <20200212172729.260752-10-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 13 Feb 2020 20:44:52 +0800
Message-ID: <CAAM7YAmPq_Lnb=K6DwOjaWTtjvKhD7L7XZ5tRUxroCKKNEbq-A@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] ceph: attempt to do async create when possible
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 13, 2020 at 1:30 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> With the Octopus release, the MDS will hand out directory create caps.
>
> If we have Fxc caps on the directory, and complete directory information
> or a known negative dentry, then we can return without waiting on the
> reply, allowing the open() call to return very quickly to userland.
>
> We use the normal ceph_fill_inode() routine to fill in the inode, so we
> have to gin up some reply inode information with what we'd expect the
> newly-created inode to have. The client assumes that it has a full set
> of caps on the new inode, and that the MDS will revoke them when there
> is conflicting access.
>
> This functionality is gated on the wsync/nowsync mount options.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c               | 231 +++++++++++++++++++++++++++++++++--
>  include/linux/ceph/ceph_fs.h |   3 +
>  2 files changed, 224 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 472d90ccdf44..814ff435832c 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -448,6 +448,196 @@ cache_file_layout(struct inode *dst, struct inode *src)
>         spin_unlock(&cdst->i_ceph_lock);
>  }
>
> +/*
> + * Try to set up an async create. We need caps, a file layout, and inode number,
> + * and either a lease on the dentry or complete dir info. If any of those
> + * criteria are not satisfied, then return false and the caller can go
> + * synchronous.
> + */
> +static bool try_prep_async_create(struct inode *dir, struct dentry *dentry,
> +                                 struct ceph_file_layout *lo, u64 *pino)
> +{
> +       struct ceph_inode_info *ci = ceph_inode(dir);
> +       struct ceph_dentry_info *di = ceph_dentry(dentry);
> +       bool ret = false;
> +       u64 ino;
> +
> +       spin_lock(&ci->i_ceph_lock);
> +       /* No auth cap means no chance for Dc caps */
> +       if (!ci->i_auth_cap)
> +               goto no_async;
> +
> +       /* Any delegated inos? */
> +       if (xa_empty(&ci->i_auth_cap->session->s_delegated_inos))
> +               goto no_async;
> +
> +       if (!ceph_file_layout_is_valid(&ci->i_cached_layout))
> +               goto no_async;
> +
> +       if ((__ceph_caps_issued(ci, NULL) &
> +            (CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE)) !=
> +           (CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE))
> +               goto no_async;
> +
> +       if (d_in_lookup(dentry)) {
> +               if (!__ceph_dir_is_complete(ci))
> +                       goto no_async;
> +       } else if (atomic_read(&ci->i_shared_gen) !=
> +                  READ_ONCE(di->lease_shared_gen)) {
> +               goto no_async;
> +       }
> +
> +       ino = ceph_get_deleg_ino(ci->i_auth_cap->session);
> +       if (!ino)
> +               goto no_async;
> +
> +       *pino = ino;
> +       ceph_take_cap_refs(ci, CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE, false);
> +       memcpy(lo, &ci->i_cached_layout, sizeof(*lo));
> +       rcu_assign_pointer(lo->pool_ns,
> +                          ceph_try_get_string(ci->i_cached_layout.pool_ns));
> +       ret = true;
> +no_async:
> +       spin_unlock(&ci->i_ceph_lock);
> +       return ret;
> +}
> +
> +static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
> +                                 struct ceph_mds_request *req)
> +{
> +       int result = req->r_err ? req->r_err :
> +                       le32_to_cpu(req->r_reply_info.head->result);
> +
> +       mapping_set_error(req->r_parent->i_mapping, result);
> +
> +       if (result) {
> +               struct dentry *dentry = req->r_dentry;
> +               int pathlen;
> +               u64 base;
> +               char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> +                                                 &base, 0);
> +
> +               ceph_dir_clear_complete(req->r_parent);
> +               if (!d_unhashed(dentry))
> +                       d_drop(dentry);
> +
> +               /* FIXME: start returning I/O errors on all accesses? */
> +               pr_warn("ceph: async create failure path=(%llx)%s result=%d!\n",
> +                       base, IS_ERR(path) ? "<<bad>>" : path, result);
> +               ceph_mdsc_free_path(path, pathlen);
> +       }
> +
> +       if (req->r_target_inode) {
> +               struct ceph_inode_info *ci = ceph_inode(req->r_target_inode);
> +               u64 ino = ceph_vino(req->r_target_inode).ino;
> +
> +               if (req->r_deleg_ino != ino)
> +                       pr_warn("%s: inode number mismatch! err=%d deleg_ino=0x%llx target=0x%llx\n",
> +                               __func__, req->r_err, req->r_deleg_ino, ino);
> +               mapping_set_error(req->r_target_inode->i_mapping, result);
> +
> +               spin_lock(&ci->i_ceph_lock);
> +               if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> +                       ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
> +                       wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
> +               }
> +               spin_unlock(&ci->i_ceph_lock);
> +       } else {
> +               pr_warn("%s: no req->r_target_inode for 0x%llx\n", __func__,
> +                       req->r_deleg_ino);
> +       }
> +       ceph_put_cap_refs(ceph_inode(req->r_parent),
> +                         CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_CREATE);
> +}
> +
> +static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> +                                   struct file *file, umode_t mode,
> +                                   struct ceph_mds_request *req,
> +                                   struct ceph_acl_sec_ctx *as_ctx,
> +                                   struct ceph_file_layout *lo)
> +{
> +       int ret;
> +       char xattr_buf[4];
> +       struct ceph_mds_reply_inode in = { };
> +       struct ceph_mds_reply_info_in iinfo = { .in = &in };
> +       struct ceph_inode_info *ci = ceph_inode(dir);
> +       struct inode *inode;
> +       struct timespec64 now;
> +       struct ceph_vino vino = { .ino = req->r_deleg_ino,
> +                                 .snap = CEPH_NOSNAP };
> +
> +       ktime_get_real_ts64(&now);
> +
> +       inode = ceph_get_inode(dentry->d_sb, vino);
> +       if (IS_ERR(inode))
> +               return PTR_ERR(inode);
> +
> +       iinfo.inline_version = CEPH_INLINE_NONE;
> +       iinfo.change_attr = 1;
> +       ceph_encode_timespec64(&iinfo.btime, &now);
> +
> +       iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
> +       iinfo.xattr_data = xattr_buf;
> +       memset(iinfo.xattr_data, 0, iinfo.xattr_len);
> +
> +       in.ino = cpu_to_le64(vino.ino);
> +       in.snapid = cpu_to_le64(CEPH_NOSNAP);
> +       in.version = cpu_to_le64(1);    // ???
> +       in.cap.caps = in.cap.wanted = cpu_to_le32(CEPH_CAP_ALL_FILE);
> +       in.cap.cap_id = cpu_to_le64(1);
> +       in.cap.realm = cpu_to_le64(ci->i_snap_realm->ino);
> +       in.cap.flags = CEPH_CAP_FLAG_AUTH;
> +       in.ctime = in.mtime = in.atime = iinfo.btime;
> +       in.mode = cpu_to_le32((u32)mode);
> +       in.truncate_seq = cpu_to_le32(1);
> +       in.truncate_size = cpu_to_le64(-1ULL);
> +       in.xattr_version = cpu_to_le64(1);
> +       in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
> +       in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_mode & S_ISGID ?
> +                               dir->i_gid : current_fsgid()));
> +       in.nlink = cpu_to_le32(1);
> +       in.max_size = cpu_to_le64(lo->stripe_unit);
> +
> +       ceph_file_layout_to_legacy(lo, &in.layout);
> +
> +       ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
> +                             req->r_fmode, NULL);
> +       if (ret) {
> +               dout("%s failed to fill inode: %d\n", __func__, ret);
> +               ceph_dir_clear_complete(dir);
> +               if (!d_unhashed(dentry))
> +                       d_drop(dentry);
> +               if (inode->i_state & I_NEW)
> +                       discard_new_inode(inode);
> +       } else {
> +               struct dentry *dn;
> +
> +               dout("%s d_adding new inode 0x%llx to 0x%lx/%s\n", __func__,
> +                       vino.ino, dir->i_ino, dentry->d_name.name);
> +               ceph_dir_clear_ordered(dir);
> +               ceph_init_inode_acls(inode, as_ctx);
> +               if (inode->i_state & I_NEW) {
> +                       /*
> +                        * If it's not I_NEW, then someone created this before
> +                        * we got here. Assume the server is aware of it at
> +                        * that point and don't worry about setting
> +                        * CEPH_I_ASYNC_CREATE.
> +                        */
> +                       ceph_inode(inode)->i_ceph_flags = CEPH_I_ASYNC_CREATE;
> +                       unlock_new_inode(inode);
> +               }
> +               if (d_in_lookup(dentry) || d_really_is_negative(dentry)) {
> +                       if (!d_unhashed(dentry))
> +                               d_drop(dentry);
> +                       dn = d_splice_alias(inode, dentry);
> +                       WARN_ON_ONCE(dn && dn != dentry);
> +               }
> +               file->f_mode |= FMODE_CREATED;
> +               ret = finish_open(file, dentry, ceph_open);
> +       }
> +       return ret;
> +}
> +
>  /*
>   * Do a lookup + open with a single request.  If we get a non-existent
>   * file or symlink, return 1 so the VFS can retry.
> @@ -460,6 +650,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>         struct ceph_mds_request *req;
>         struct dentry *dn;
>         struct ceph_acl_sec_ctx as_ctx = {};
> +       bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
>         int mask;
>         int err;
>
> @@ -483,7 +674,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>                 /* If it's not being looked up, it's negative */
>                 return -ENOENT;
>         }
> -
> +retry:
>         /* do the open */
>         req = prepare_open_request(dir->i_sb, flags, mode);
>         if (IS_ERR(req)) {
> @@ -492,28 +683,47 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>         }
>         req->r_dentry = dget(dentry);
>         req->r_num_caps = 2;
> +       mask = CEPH_STAT_CAP_INODE | CEPH_CAP_AUTH_SHARED;
> +       if (ceph_security_xattr_wanted(dir))
> +               mask |= CEPH_CAP_XATTR_SHARED;
> +       req->r_args.open.mask = cpu_to_le32(mask);
> +       req->r_parent = dir;
> +
>         if (flags & O_CREAT) {
> +               struct ceph_file_layout lo;
> +
>                 req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
>                 req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
>                 if (as_ctx.pagelist) {
>                         req->r_pagelist = as_ctx.pagelist;
>                         as_ctx.pagelist = NULL;
>                 }
> +               if (try_async && try_prep_async_create(dir, dentry, &lo,
> +                                                      &req->r_deleg_ino)) {
> +                       set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
> +                       req->r_args.open.flags |= cpu_to_le32(CEPH_O_EXCL);
> +                       req->r_callback = ceph_async_create_cb;
> +                       err = ceph_mdsc_submit_request(mdsc, dir, req);
> +                       if (!err) {
> +                               err = ceph_finish_async_create(dir, dentry,
> +                                                       file, mode, req,
> +                                                       &as_ctx, &lo);
> +                       } else if (err == -EJUKEBOX) {
> +                               ceph_mdsc_put_request(req);
> +                               try_async = false;
> +                               goto retry;

put ino number back to s_delegated_inos

> +                       }
> +                       goto out_req;
> +               }
>         }
>
> -       mask = CEPH_STAT_CAP_INODE | CEPH_CAP_AUTH_SHARED;
> -       if (ceph_security_xattr_wanted(dir))
> -               mask |= CEPH_CAP_XATTR_SHARED;
> -       req->r_args.open.mask = cpu_to_le32(mask);
> -
> -       req->r_parent = dir;
>         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>         err = ceph_mdsc_do_request(mdsc,
>                                    (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
>                                    req);
>         err = ceph_handle_snapdir(req, dentry, err);
>         if (err)
> -               goto out_req;
> +               goto out_fmode;
>
>         if ((flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
>                 err = ceph_handle_notrace_create(dir, dentry);
> @@ -527,7 +737,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>                 dn = NULL;
>         }
>         if (err)
> -               goto out_req;
> +               goto out_fmode;
>         if (dn || d_really_is_negative(dentry) || d_is_symlink(dentry)) {
>                 /* make vfs retry on splice, ENOENT, or symlink */
>                 dout("atomic_open finish_no_open on dn %p\n", dn);
> @@ -543,9 +753,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>                 }
>                 err = finish_open(file, dentry, ceph_open);
>         }
> -out_req:
> +out_fmode:
>         if (!req->r_err && req->r_target_inode)
>                 ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode);
> +out_req:
>         ceph_mdsc_put_request(req);
>  out_ctx:
>         ceph_release_acl_sec_ctx(&as_ctx);
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 91d09cf37649..e035c5194005 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -659,6 +659,9 @@ int ceph_flags_to_mode(int flags);
>  #define CEPH_CAP_ANY      (CEPH_CAP_ANY_RD | CEPH_CAP_ANY_EXCL | \
>                            CEPH_CAP_ANY_FILE_WR | CEPH_CAP_FILE_LAZYIO | \
>                            CEPH_CAP_PIN)
> +#define CEPH_CAP_ALL_FILE (CEPH_CAP_PIN | CEPH_CAP_ANY_SHARED | \
> +                          CEPH_CAP_AUTH_EXCL | CEPH_CAP_XATTR_EXCL | \
> +                          CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR)
>
>  #define CEPH_CAP_LOCKS (CEPH_LOCK_IFILE | CEPH_LOCK_IAUTH | CEPH_LOCK_ILINK | \
>                         CEPH_LOCK_IXATTR)
> --
> 2.24.1
>
