Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D360915BE3D
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 13:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgBMMHD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 07:07:03 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44829 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729888AbgBMMHD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 07:07:03 -0500
Received: by mail-qk1-f196.google.com with SMTP id v195so5343418qkb.11
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 04:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mlQxvC6UcmJVw/zgaL3mpUWLitsluQZbKsL+hy/Iw/Q=;
        b=Bw4iHFHZTLEjDqlmTyAqDNLHKRHeQBnlhEsX/+wJOsV8KgIS6U2/4qH8FoHMgqbYlT
         aIJUU6ChzAX/QLShDtrVG2J+KVu9S4SFyJF9Jq+0IlPZ92ImvZZnj2JxJcSlNkCfZ9Va
         JHrINyLzh9CCrg5gWIU0FkxqLrXz/aCK0fIWOIwbtnlEMd+tZ29xKrPafHL8IPZaR7mk
         5V5K8903IiALaClOsqObqSk+Kghe/VyDI+d0DNGzDAwMLzWOwaYxIktCt7zdWB0cF0OO
         5/tBGStlHeXxWxAFyzCXDqpq10kTbruC1iIZst4PTnM54a8Ll5WV8406faYm0PEjm4pA
         6k8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mlQxvC6UcmJVw/zgaL3mpUWLitsluQZbKsL+hy/Iw/Q=;
        b=lCYXD40C5GnF3DfwGVkfWwIZGO19l2WgxnSMV46YZsIqr9Xx2IMS0lb5gfm+iPN+ns
         DguCclX0kk0/maVNdgb5TsiOiLgFcBl4fTvV1hgYsE72VIjKZqYig0m4vt20nxB6Fgsv
         6lpRivBam9FZkCgihGihcKEGb8doQma7THZ4zGXUuKsms/u1HiwnF/wsBKbRy+YGj03y
         5hiMRZDco9U/yLklsbx6v0juin41Gh5/2N8fPGDb2ShiGNvUzTwdIH0IcXuiz0Rbnf1E
         GRzPHzZGIWQLq9s6wGSBRxXXA8CBU5qOoSPdF0vCyUlMmJ1bjusXdQ1Nqd0hBXJbqBbA
         Ga4Q==
X-Gm-Message-State: APjAAAVB2uzWQuF3lCRxQEuXX3UikPI0Fslg2uayKMf226oeqslT6GAr
        kJjbVsw2D+xJBQzhr8fQ8k5IadAcwQbExyyVZ88=
X-Google-Smtp-Source: APXvYqw0wtlh0D5JWPunAMIcX9D4w83uHjebV/KA5L0Cyx9/cCcy8vTJgFXISJsiOStGT/kZIEplyUuzkW04oNaKzfs=
X-Received: by 2002:a05:620a:204d:: with SMTP id d13mr14558285qka.56.1581595621348;
 Thu, 13 Feb 2020 04:07:01 -0800 (PST)
MIME-Version: 1.0
References: <20200212172729.260752-1-jlayton@kernel.org> <20200212172729.260752-3-jlayton@kernel.org>
In-Reply-To: <20200212172729.260752-3-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 13 Feb 2020 20:06:49 +0800
Message-ID: <CAAM7YA=W6xJg4fh71aQ0vBXn62+V_8RXS2zsUgychVV9RpUaVw@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] ceph: perform asynchronous unlink if we have
 sufficient caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 13, 2020 at 1:29 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> The MDS is getting a new lock-caching facility that will allow it
> to cache the necessary locks to allow asynchronous directory operations.
> Since the CEPH_CAP_FILE_* caps are currently unused on directories,
> we can repurpose those bits for this purpose.
>
> When performing an unlink, if we have Fx on the parent directory,
> and CEPH_CAP_DIR_UNLINK (aka Fr), and we know that the dentry being
> removed is the primary link, then then we can fire off an unlink
> request immediately and don't need to wait on reply before returning.
>
> In that situation, just fix up the dcache and link count and return
> immediately after issuing the call to the MDS. This does mean that we
> need to hold an extra reference to the inode being unlinked, and extra
> references to the caps to avoid races. Those references are put and
> error handling is done in the r_callback routine.
>
> If the operation ends up failing, then set a writeback error on the
> directory inode, and the inode itself that can be fetched later by
> an fsync on the dir.
>
> The behavior of dir caps is slightly different from caps on normal
> files. Because these are just considered an optimization, if the
> session is reconnected, we will not automatically reclaim them. They
> are instead considered lost until we do another synchronous op in the
> parent directory.
>
> Async dirops are enabled via the "nowsync" mount option, which is
> patterned after the xfs "wsync" mount option. For now, the default
> is "wsync", but eventually we may flip that.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c               | 35 +++++++++----
>  fs/ceph/dir.c                | 99 ++++++++++++++++++++++++++++++++++--
>  fs/ceph/inode.c              |  8 ++-
>  fs/ceph/mds_client.c         |  8 ++-
>  fs/ceph/super.c              | 20 ++++++++
>  fs/ceph/super.h              |  6 ++-
>  include/linux/ceph/ceph_fs.h |  9 ++++
>  7 files changed, 166 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index d05717397c2a..7fc87b693ba4 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -992,7 +992,11 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
>  int __ceph_caps_wanted(struct ceph_inode_info *ci)
>  {
>         int w = __ceph_caps_file_wanted(ci) | __ceph_caps_used(ci);
> -       if (!S_ISDIR(ci->vfs_inode.i_mode)) {
> +       if (S_ISDIR(ci->vfs_inode.i_mode)) {
> +               /* we want EXCL if holding caps of dir ops */
> +               if (w & CEPH_CAP_ANY_DIR_OPS)
> +                       w |= CEPH_CAP_FILE_EXCL;
> +       } else {
>                 /* we want EXCL if dirty data */
>                 if (w & CEPH_CAP_FILE_BUFFER)
>                         w |= CEPH_CAP_FILE_EXCL;
> @@ -1883,10 +1887,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>                          * revoking the shared cap on every create/unlink
>                          * operation.
>                          */
> -                       if (IS_RDONLY(inode))
> +                       if (IS_RDONLY(inode)) {
>                                 want = CEPH_CAP_ANY_SHARED;
> -                       else
> -                               want = CEPH_CAP_ANY_SHARED | CEPH_CAP_FILE_EXCL;
> +                       } else {
> +                               want = CEPH_CAP_ANY_SHARED |
> +                                      CEPH_CAP_FILE_EXCL |
> +                                      CEPH_CAP_ANY_DIR_OPS;
> +                       }
>                         retain |= want;
>                 } else {
>
> @@ -2649,7 +2656,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>                                 }
>                                 snap_rwsem_locked = true;
>                         }
> -                       *got = need | (have & want);
> +                       if ((have & want) == want)
> +                               *got = need | want;
> +                       else
> +                               *got = need;
>                         if (S_ISREG(inode->i_mode) &&
>                             (need & CEPH_CAP_FILE_RD) &&
>                             !(*got & CEPH_CAP_FILE_CACHE))
> @@ -2739,13 +2749,16 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
>         int ret;
>
>         BUG_ON(need & ~CEPH_CAP_FILE_RD);
> -       BUG_ON(want & ~(CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO|CEPH_CAP_FILE_SHARED));
> -       ret = ceph_pool_perm_check(inode, need);
> -       if (ret < 0)
> -               return ret;
> +       if (need) {
> +               ret = ceph_pool_perm_check(inode, need);
> +               if (ret < 0)
> +                       return ret;
> +       }
>
> -       ret = try_get_cap_refs(inode, need, want, 0,
> -                              (nonblock ? NON_BLOCKING : 0), got);
> +       BUG_ON(want & ~(CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO |
> +                       CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
> +                       CEPH_CAP_ANY_DIR_OPS));
> +       ret = try_get_cap_refs(inode, need, want, 0, nonblock, got);

should keep (nonblock ? NON_BLOCKING : 0)

>         return ret == -EAGAIN ? 0 : ret;
>  }
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index d0cd0aba5843..46314ccf48c5 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1036,6 +1036,69 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
>         return err;
>  }
>
> +static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
> +                                struct ceph_mds_request *req)
> +{
> +       int result = req->r_err ? req->r_err :
> +                       le32_to_cpu(req->r_reply_info.head->result);
> +
> +       /* If op failed, mark everyone involved for errors */
> +       if (result) {
> +               int pathlen;
> +               u64 base;
> +               char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> +                                                 &base, 0);
> +
> +               /* mark error on parent + clear complete */
> +               mapping_set_error(req->r_parent->i_mapping, result);
> +               ceph_dir_clear_complete(req->r_parent);
> +
> +               /* drop the dentry -- we don't know its status */
> +               if (!d_unhashed(req->r_dentry))
> +                       d_drop(req->r_dentry);
> +
> +               /* mark inode itself for an error (since metadata is bogus) */
> +               mapping_set_error(req->r_old_inode->i_mapping, result);
> +
> +               pr_warn("ceph: async unlink failure path=(%llx)%s result=%d!\n",
> +                       base, IS_ERR(path) ? "<<bad>>" : path, result);
> +               ceph_mdsc_free_path(path, pathlen);
> +       }
> +
> +       ceph_put_cap_refs(ceph_inode(req->r_parent),
> +                         CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_UNLINK);
> +       iput(req->r_old_inode);
> +}
> +
> +static bool get_caps_for_async_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +       struct ceph_inode_info *ci = ceph_inode(dir);
> +       struct ceph_dentry_info *di;
> +       int ret, want, got = 0;
> +
> +       want = CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_UNLINK;
> +       ret = ceph_try_get_caps(dir, 0, want, true, &got);
> +       dout("FxDu on %p ret=%d got=%s\n", dir, ret, ceph_cap_string(got));
> +       if (ret != 1 || got != want)
> +               return false;
> +
> +        spin_lock(&dentry->d_lock);
> +        di = ceph_dentry(dentry);
> +       /* - We are holding CEPH_CAP_FILE_EXCL, which implies
> +        * CEPH_CAP_FILE_SHARED.
> +        * - Only support async unlink for primary linkage */
> +       if (atomic_read(&ci->i_shared_gen) != di->lease_shared_gen ||
> +           !(di->flags & CEPH_DENTRY_PRIMARY_LINK))
> +               ret = 0;
> +        spin_unlock(&dentry->d_lock);
> +
> +       if (!ret) {
> +               ceph_put_cap_refs(ci, got);
> +               return false;
> +       }
> +       return true;
> +}
> +
>  /*
>   * rmdir and unlink are differ only by the metadata op code
>   */
> @@ -1045,6 +1108,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
>         struct ceph_mds_client *mdsc = fsc->mdsc;
>         struct inode *inode = d_inode(dentry);
>         struct ceph_mds_request *req;
> +       bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
>         int err = -EROFS;
>         int op;
>
> @@ -1059,6 +1123,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
>                         CEPH_MDS_OP_RMDIR : CEPH_MDS_OP_UNLINK;
>         } else
>                 goto out;
> +retry:
>         req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>         if (IS_ERR(req)) {
>                 err = PTR_ERR(req);
> @@ -1067,13 +1132,38 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
>         req->r_dentry = dget(dentry);
>         req->r_num_caps = 2;
>         req->r_parent = dir;
> -       set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>         req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
>         req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
>         req->r_inode_drop = ceph_drop_caps_for_unlink(inode);
> -       err = ceph_mdsc_do_request(mdsc, dir, req);
> -       if (!err && !req->r_reply_info.head->is_dentry)
> -               d_delete(dentry);
> +
> +       if (try_async && op == CEPH_MDS_OP_UNLINK &&
> +           get_caps_for_async_unlink(dir, dentry)) {
> +               dout("ceph: Async unlink on %lu/%.*s", dir->i_ino,
> +                    dentry->d_name.len, dentry->d_name.name);
> +               set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
> +               req->r_callback = ceph_async_unlink_cb;
> +               req->r_old_inode = d_inode(dentry);
> +               ihold(req->r_old_inode);
> +               err = ceph_mdsc_submit_request(mdsc, dir, req);
> +               if (!err) {
> +                       /*
> +                        * We have enough caps, so we assume that the unlink
> +                        * will succeed. Fix up the target inode and dcache.
> +                        */
> +                       drop_nlink(inode);
> +                       d_delete(dentry);
> +               } else if (err == -EJUKEBOX) {
> +                       try_async = false;
> +                       ceph_mdsc_put_request(req);
> +                       goto retry;
> +               }
> +       } else {
> +               set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> +               err = ceph_mdsc_do_request(mdsc, dir, req);
> +               if (!err && !req->r_reply_info.head->is_dentry)
> +                       d_delete(dentry);
> +       }
> +
>         ceph_mdsc_put_request(req);
>  out:
>         return err;
> @@ -1411,6 +1501,7 @@ void ceph_invalidate_dentry_lease(struct dentry *dentry)
>         spin_lock(&dentry->d_lock);
>         di->time = jiffies;
>         di->lease_shared_gen = 0;
> +       di->flags &= ~CEPH_DENTRY_PRIMARY_LINK;
>         __dentry_lease_unlist(di);
>         spin_unlock(&dentry->d_lock);
>  }
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 9869ec101e88..7478bd0283c1 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1051,6 +1051,7 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
>                                   struct ceph_mds_session **old_lease_session)
>  {
>         struct ceph_dentry_info *di = ceph_dentry(dentry);
> +       unsigned mask = le16_to_cpu(lease->mask);
>         long unsigned duration = le32_to_cpu(lease->duration_ms);
>         long unsigned ttl = from_time + (duration * HZ) / 1000;
>         long unsigned half_ttl = from_time + (duration * HZ / 2) / 1000;
> @@ -1062,8 +1063,13 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
>         if (ceph_snap(dir) != CEPH_NOSNAP)
>                 return;
>
> +       if (mask & CEPH_LEASE_PRIMARY_LINK)
> +               di->flags |= CEPH_DENTRY_PRIMARY_LINK;
> +       else
> +               di->flags &= ~CEPH_DENTRY_PRIMARY_LINK;
> +
>         di->lease_shared_gen = atomic_read(&ceph_inode(dir)->i_shared_gen);
> -       if (duration == 0) {
> +       if (!(mask & CEPH_LEASE_VALID)) {
>                 __ceph_dentry_dir_lease_touch(di);
>                 return;
>         }
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9f2aeb6908b2..f0ea32f4cdb9 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3370,7 +3370,7 @@ static int send_reconnect_partial(struct ceph_reconnect_state *recon_state)
>  /*
>   * Encode information about a cap for a reconnect with the MDS.
>   */
> -static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
> +static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>                           void *arg)
>  {
>         union {
> @@ -3393,6 +3393,10 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
>         cap->mseq = 0;       /* and migrate_seq */
>         cap->cap_gen = cap->session->s_cap_gen;
>
> +       /* These are lost when the session goes away */
> +       if (S_ISDIR(inode->i_mode))
> +               cap->issued &= ~(CEPH_CAP_DIR_CREATE|CEPH_CAP_DIR_UNLINK);
> +
>         if (recon_state->msg_version >= 2) {
>                 rec.v2.cap_id = cpu_to_le64(cap->cap_id);
>                 rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
> @@ -3689,7 +3693,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
>                 recon_state.msg_version = 2;
>         }
>         /* trsaverse this session's caps */
> -       err = ceph_iterate_session_caps(session, encode_caps_cb, &recon_state);
> +       err = ceph_iterate_session_caps(session, reconnect_caps_cb, &recon_state);
>
>         spin_lock(&session->s_cap_lock);
>         session->s_cap_reconnect = 0;
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index c7f150686a53..58d64805c9e3 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -155,6 +155,7 @@ enum {
>         Opt_acl,
>         Opt_quotadf,
>         Opt_copyfrom,
> +       Opt_wsync,
>  };
>
>  enum ceph_recover_session_mode {
> @@ -194,6 +195,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>         fsparam_string  ("snapdirname",                 Opt_snapdirname),
>         fsparam_string  ("source",                      Opt_source),
>         fsparam_u32     ("wsize",                       Opt_wsize),
> +       fsparam_flag_no ("wsync",                       Opt_wsync),
>         {}
>  };
>
> @@ -444,6 +446,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>                         fc->sb_flags &= ~SB_POSIXACL;
>                 }
>                 break;
> +       case Opt_wsync:
> +               if (!result.negated)
> +                       fsopt->flags &= ~CEPH_MOUNT_OPT_ASYNC_DIROPS;
> +               else
> +                       fsopt->flags |= CEPH_MOUNT_OPT_ASYNC_DIROPS;
> +               break;
>         default:
>                 BUG();
>         }
> @@ -567,6 +575,9 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>         if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
>                 seq_show_option(m, "recover_session", "clean");
>
> +       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> +               seq_puts(m, ",nowsync");
> +
>         if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
>                 seq_printf(m, ",wsize=%u", fsopt->wsize);
>         if (fsopt->rsize != CEPH_MAX_READ_SIZE)
> @@ -1107,6 +1118,15 @@ static void ceph_free_fc(struct fs_context *fc)
>
>  static int ceph_reconfigure_fc(struct fs_context *fc)
>  {
> +       struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> +       struct ceph_mount_options *fsopt = pctx->opts;
> +       struct ceph_fs_client *fsc = ceph_sb_to_client(fc->root->d_sb);
> +
> +       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> +               ceph_set_mount_opt(fsc, ASYNC_DIROPS);
> +       else
> +               ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
> +
>         sync_filesystem(fc->root->d_sb);
>         return 0;
>  }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 37dc1ac8f6c3..540393ba861b 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -43,13 +43,16 @@
>  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
>  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
> +#define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
>
>  #define CEPH_MOUNT_OPT_DEFAULT                 \
>         (CEPH_MOUNT_OPT_DCACHE |                \
>          CEPH_MOUNT_OPT_NOCOPYFROM)
>
>  #define ceph_set_mount_opt(fsc, opt) \
> -       (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt;
> +       (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
> +#define ceph_clear_mount_opt(fsc, opt) \
> +       (fsc)->mount_options->flags &= ~CEPH_MOUNT_OPT_##opt
>  #define ceph_test_mount_opt(fsc, opt) \
>         (!!((fsc)->mount_options->flags & CEPH_MOUNT_OPT_##opt))
>
> @@ -284,6 +287,7 @@ struct ceph_dentry_info {
>  #define CEPH_DENTRY_REFERENCED         1
>  #define CEPH_DENTRY_LEASE_LIST         2
>  #define CEPH_DENTRY_SHRINK_LIST                4
> +#define CEPH_DENTRY_PRIMARY_LINK       8
>
>  struct ceph_inode_xattrs_info {
>         /*
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 9f747a1b8788..91d09cf37649 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -531,6 +531,9 @@ struct ceph_mds_reply_lease {
>         __le32 seq;
>  } __attribute__ ((packed));
>
> +#define CEPH_LEASE_VALID        (1 | 2) /* old and new bit values */
> +#define CEPH_LEASE_PRIMARY_LINK 4       /* primary linkage */
> +
>  struct ceph_mds_reply_dirfrag {
>         __le32 frag;            /* fragment */
>         __le32 auth;            /* auth mds, if this is a delegation point */
> @@ -660,6 +663,12 @@ int ceph_flags_to_mode(int flags);
>  #define CEPH_CAP_LOCKS (CEPH_LOCK_IFILE | CEPH_LOCK_IAUTH | CEPH_LOCK_ILINK | \
>                         CEPH_LOCK_IXATTR)
>
> +/* cap masks async dir operations */
> +#define CEPH_CAP_DIR_CREATE    CEPH_CAP_FILE_CACHE
> +#define CEPH_CAP_DIR_UNLINK    CEPH_CAP_FILE_RD
> +#define CEPH_CAP_ANY_DIR_OPS   (CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_RD | \
> +                                CEPH_CAP_FILE_WREXTEND | CEPH_CAP_FILE_LAZYIO)
> +
>  int ceph_caps_for_mode(int mode);
>
>  enum {
> --
> 2.24.1
>
