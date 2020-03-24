Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6170B191391
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Mar 2020 15:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgCXOsl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Mar 2020 10:48:41 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37469 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgCXOsl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 Mar 2020 10:48:41 -0400
Received: by mail-qt1-f194.google.com with SMTP id d12so12668069qtj.4
        for <ceph-devel@vger.kernel.org>; Tue, 24 Mar 2020 07:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B16dVImMc0rm/KxV0D1nwHmyAAdMN+R/tlW741qAhCw=;
        b=upXIWR4ZvBSKXO6yPiCH3/n4vjgCctl2oZ2A7hee4jX5WffisVuA2Zi4H/xoxyMBqM
         YQzT3iYsIDPexdFsA0lRLeP1OicxT/B7SbqtAhpa+2uhWVSNCKnPqJgpTUJwYLoF4pLy
         SOwJkPpwZQ5cHg05hYcHR86gTGRWESwqMkA4aZHQswhXlbpCf3hW9pFq4ViP84Uhp1RC
         5Qm6dOUVhAfdq2WGtXlTJsCXIsPZ0/TzUfwDVwiF7whlERxY1Ui0qRMUu2DKraSwP5m2
         UxoWHu6Fxs9hk3npTUAQ4VksfLJv0y6v8V/YlRd99Lp7ZHYDb1V7JRCGbwORmcpZG7xv
         0pIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B16dVImMc0rm/KxV0D1nwHmyAAdMN+R/tlW741qAhCw=;
        b=Ue4ikK35CjJAbP4ArtvQt/fmPDx/XqYxusDRjPx1ukKSoickfCuaLqx1sRJ77Gpl+y
         aC51wC6r08rnjkkObhpHwLDNTgc7KTkGbOkO2wz6wL6LPPYnm4AoZZaYCR3cdxyC6OX0
         DU28VJsdyNtLIu5IC5BKmvB5o7NXv/HgGKJROT82t6XZZ0xfaVk/pHFvR4Lt81ZG3MT9
         dZbQetOPnLTTh2tKRweeimTqCJ2Vldp82uYixBOacrYvsJBylihPv3KEE4flIimQ1tuz
         E/QDaWIiOzMTx7ftmcAUvRnjq+wjDa0w2Ayikg8fJS9yeflMMNLFcxsfPvGt6f8vQB/J
         MmGw==
X-Gm-Message-State: ANhLgQ2fOZh8fbF7phF++TipLADAP8H9UTleLsbsxW0/VtBpvlHbMVkG
        2xaYaGZGiUIhDu5nv/dRQ/rnIdGFmt5AbcHehu36vIpxTLQ=
X-Google-Smtp-Source: ADFU+vuKIMVgq9ap1q9r4xX0hhUdbjoQ6n+5PGMKNTM3IVMndH8jfCwFVPjusVTNPqW4buBFLiJ4WhVSq1R5274K890=
X-Received: by 2002:ac8:18f3:: with SMTP id o48mr27577115qtk.368.1585061317275;
 Tue, 24 Mar 2020 07:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200323160708.104152-1-jlayton@kernel.org> <20200323160708.104152-2-jlayton@kernel.org>
In-Reply-To: <20200323160708.104152-2-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 24 Mar 2020 22:48:25 +0800
Message-ID: <CAAM7YAkEpEzxjMTjgjbRRoZ95hqUX-SULYxkPof3aEgd+EqDuA@mail.gmail.com>
Subject: Re: [PATCH 1/8] ceph: reorganize __send_cap for less spinlock abuse
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 24, 2020 at 12:07 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Get rid of the __releases annotation by breaking it up into two
> functions: __prep_cap which is done under the spinlock and __send_cap
> that is done outside it.
>
> Nothing checks the return value from __send_cap, so make it void
> return.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 193 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 110 insertions(+), 83 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 779433847f20..5bdca0da58a4 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1318,44 +1318,27 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
>  }
>
>  /*
> - * Send a cap msg on the given inode.  Update our caps state, then
> - * drop i_ceph_lock and send the message.
> - *
> - * Make note of max_size reported/requested from mds, revoked caps
> - * that have now been implemented.
> - *
> - * Return non-zero if delayed release, or we experienced an error
> - * such that the caller should requeue + retry later.
> - *
> - * called with i_ceph_lock, then drops it.
> - * caller should hold snap_rwsem (read), s_mutex.
> + * Prepare to send a cap message to an MDS. Update the cap state, and populate
> + * the arg struct with the parameters that will need to be sent. This should
> + * be done under the i_ceph_lock to guard against changes to cap state.
>   */
> -static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
> -                     int op, int flags, int used, int want, int retain,
> -                     int flushing, u64 flush_tid, u64 oldest_flush_tid)
> -       __releases(cap->ci->i_ceph_lock)
> +static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
> +                      int op, int flags, int used, int want, int retain,
> +                      int flushing, u64 flush_tid, u64 oldest_flush_tid,
> +                      struct ceph_buffer **old_blob)
>  {
>         struct ceph_inode_info *ci = cap->ci;
>         struct inode *inode = &ci->vfs_inode;
> -       struct ceph_buffer *old_blob = NULL;
> -       struct cap_msg_args arg;
>         int held, revoking;
> -       int wake = 0;
> -       int ret;
>
> -       /* Don't send anything if it's still being created. Return delayed */
> -       if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> -               spin_unlock(&ci->i_ceph_lock);
> -               dout("%s async create in flight for %p\n", __func__, inode);
> -               return 1;
> -       }
> +       lockdep_assert_held(&ci->i_ceph_lock);
>
>         held = cap->issued | cap->implemented;
>         revoking = cap->implemented & ~cap->issued;
>         retain &= ~revoking;
>
> -       dout("__send_cap %p cap %p session %p %s -> %s (revoking %s)\n",
> -            inode, cap, cap->session,
> +       dout("%s %p cap %p session %p %s -> %s (revoking %s)\n",
> +            __func__, inode, cap, cap->session,
>              ceph_cap_string(held), ceph_cap_string(held & retain),
>              ceph_cap_string(revoking));
>         BUG_ON((retain & CEPH_CAP_PIN) == 0);
> @@ -1363,60 +1346,51 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>         ci->i_ceph_flags &= ~CEPH_I_FLUSH;
>
>         cap->issued &= retain;  /* drop bits we don't want */
> -       if (cap->implemented & ~cap->issued) {
> -               /*
> -                * Wake up any waiters on wanted -> needed transition.
> -                * This is due to the weird transition from buffered
> -                * to sync IO... we need to flush dirty pages _before_
> -                * allowing sync writes to avoid reordering.
> -                */
> -               wake = 1;
> -       }
>         cap->implemented &= cap->issued | used;
>         cap->mds_wanted = want;
>
> -       arg.session = cap->session;
> -       arg.ino = ceph_vino(inode).ino;
> -       arg.cid = cap->cap_id;
> -       arg.follows = flushing ? ci->i_head_snapc->seq : 0;
> -       arg.flush_tid = flush_tid;
> -       arg.oldest_flush_tid = oldest_flush_tid;
> +       arg->session = cap->session;
> +       arg->ino = ceph_vino(inode).ino;
> +       arg->cid = cap->cap_id;
> +       arg->follows = flushing ? ci->i_head_snapc->seq : 0;
> +       arg->flush_tid = flush_tid;
> +       arg->oldest_flush_tid = oldest_flush_tid;
>
> -       arg.size = inode->i_size;
> -       ci->i_reported_size = arg.size;
> -       arg.max_size = ci->i_wanted_max_size;
> +       arg->size = inode->i_size;
> +       ci->i_reported_size = arg->size;
> +       arg->max_size = ci->i_wanted_max_size;
>         if (cap == ci->i_auth_cap)
> -               ci->i_requested_max_size = arg.max_size;
> +               ci->i_requested_max_size = arg->max_size;
>
>         if (flushing & CEPH_CAP_XATTR_EXCL) {
> -               old_blob = __ceph_build_xattrs_blob(ci);
> -               arg.xattr_version = ci->i_xattrs.version;
> -               arg.xattr_buf = ci->i_xattrs.blob;
> +               *old_blob = __ceph_build_xattrs_blob(ci);
> +               arg->xattr_version = ci->i_xattrs.version;
> +               arg->xattr_buf = ci->i_xattrs.blob;
>         } else {
> -               arg.xattr_buf = NULL;
> +               arg->xattr_buf = NULL;
>         }
>
> -       arg.mtime = inode->i_mtime;
> -       arg.atime = inode->i_atime;
> -       arg.ctime = inode->i_ctime;
> -       arg.btime = ci->i_btime;
> -       arg.change_attr = inode_peek_iversion_raw(inode);
> +       arg->mtime = inode->i_mtime;
> +       arg->atime = inode->i_atime;
> +       arg->ctime = inode->i_ctime;
> +       arg->btime = ci->i_btime;
> +       arg->change_attr = inode_peek_iversion_raw(inode);
>
> -       arg.op = op;
> -       arg.caps = cap->implemented;
> -       arg.wanted = want;
> -       arg.dirty = flushing;
> +       arg->op = op;
> +       arg->caps = cap->implemented;
> +       arg->wanted = want;
> +       arg->dirty = flushing;
>
> -       arg.seq = cap->seq;
> -       arg.issue_seq = cap->issue_seq;
> -       arg.mseq = cap->mseq;
> -       arg.time_warp_seq = ci->i_time_warp_seq;
> +       arg->seq = cap->seq;
> +       arg->issue_seq = cap->issue_seq;
> +       arg->mseq = cap->mseq;
> +       arg->time_warp_seq = ci->i_time_warp_seq;
>
> -       arg.uid = inode->i_uid;
> -       arg.gid = inode->i_gid;
> -       arg.mode = inode->i_mode;
> +       arg->uid = inode->i_uid;
> +       arg->gid = inode->i_gid;
> +       arg->mode = inode->i_mode;
>
> -       arg.inline_data = ci->i_inline_version != CEPH_INLINE_NONE;
> +       arg->inline_data = ci->i_inline_version != CEPH_INLINE_NONE;
>         if (!(flags & CEPH_CLIENT_CAPS_PENDING_CAPSNAP) &&
>             !list_empty(&ci->i_cap_snaps)) {
>                 struct ceph_cap_snap *capsnap;
> @@ -1429,18 +1403,46 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>                         }
>                 }
>         }
> -       arg.flags = flags;
> +       arg->flags = flags;
> +}
>
> -       spin_unlock(&ci->i_ceph_lock);
> +/*
> + * Wake up any waiters on wanted -> needed transition. This is due to the weird
> + * transition from buffered to sync IO... we need to flush dirty pages _before_
> + * allowing sync writes to avoid reordering.
> + */
> +static inline bool should_wake_cap_waiters(struct ceph_cap *cap)
> +{
> +       lockdep_assert_held(&cap->ci->i_ceph_lock);
>
> -       ceph_buffer_put(old_blob);
> +       return cap->implemented & ~cap->issued;
> +}
>
> -       ret = send_cap_msg(&arg);
> +/*
> + * Send a cap msg on the given inode.  Update our caps state, then
> + * drop i_ceph_lock and send the message.
> + *
> + * Make note of max_size reported/requested from mds, revoked caps
> + * that have now been implemented.
> + *
> + * Return non-zero if delayed release, or we experienced an error
> + * such that the caller should requeue + retry later.
> + *
> + * called with i_ceph_lock, then drops it.
> + * caller should hold snap_rwsem (read), s_mutex.
> + */
> +static void __send_cap(struct ceph_mds_client *mdsc, struct cap_msg_args *arg,
> +                      struct ceph_inode_info *ci, bool wake)
> +{
> +       struct inode *inode = &ci->vfs_inode;
> +       int ret;
> +
> +       ret = send_cap_msg(arg);
>         if (ret < 0) {
>                 pr_err("error sending cap msg, ino (%llx.%llx) "
>                        "flushing %s tid %llu, requeue\n",
> -                      ceph_vinop(inode), ceph_cap_string(flushing),
> -                      flush_tid);
> +                      ceph_vinop(inode), ceph_cap_string(arg->dirty),
> +                      arg->flush_tid);
>                 spin_lock(&ci->i_ceph_lock);
>                 __cap_delay_requeue(mdsc, ci);
>                 spin_unlock(&ci->i_ceph_lock);
> @@ -1448,8 +1450,6 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>
>         if (wake)
>                 wake_up_all(&ci->i_cap_wq);
> -
> -       return ret;
>  }
>
>  static inline int __send_flush_snap(struct inode *inode,
> @@ -1967,6 +1967,10 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>         }
>
>         for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
> +               struct cap_msg_args arg;
> +               struct ceph_buffer *old_blob = NULL;
> +               bool wake;
> +

how about defining 'wake' and 'old_blob' into cap_msg_args, move
should_wake_cap_waiters() code into __prep_cap.

>                 cap = rb_entry(p, struct ceph_cap, ci_node);
>
>                 /* avoid looping forever */
> @@ -2094,9 +2098,15 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>
>                 mds = cap->mds;  /* remember mds, so we don't repeat */
>
> -               /* __send_cap drops i_ceph_lock */
> -               __send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> -                          retain, flushing, flush_tid, oldest_flush_tid);
> +               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> +                          retain, flushing, flush_tid, oldest_flush_tid,
> +                          &old_blob);
> +               wake = should_wake_cap_waiters(cap);
> +               spin_unlock(&ci->i_ceph_lock);
> +
> +               ceph_buffer_put(old_blob);
> +               __send_cap(mdsc, &arg, ci, wake);
> +
>                 goto retry; /* retake i_ceph_lock and restart our cap scan. */
>         }
>
> @@ -2135,6 +2145,9 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>  retry_locked:
>         if (ci->i_dirty_caps && ci->i_auth_cap) {
>                 struct ceph_cap *cap = ci->i_auth_cap;
> +               struct ceph_buffer *old_blob = NULL;
> +               struct cap_msg_args arg;
> +               bool wake;
>
>                 if (session != cap->session) {
>                         spin_unlock(&ci->i_ceph_lock);
> @@ -2162,11 +2175,15 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>                 flush_tid = __mark_caps_flushing(inode, session, true,
>                                                  &oldest_flush_tid);
>
> -               /* __send_cap drops i_ceph_lock */
> -               __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH, CEPH_CLIENT_CAPS_SYNC,
> +               __prep_cap(&arg, cap, CEPH_CAP_OP_FLUSH, CEPH_CLIENT_CAPS_SYNC,
>                            __ceph_caps_used(ci), __ceph_caps_wanted(ci),
>                            (cap->issued | cap->implemented),
> -                          flushing, flush_tid, oldest_flush_tid);
> +                          flushing, flush_tid, oldest_flush_tid, &old_blob);
> +               wake = should_wake_cap_waiters(cap);
> +               spin_unlock(&ci->i_ceph_lock);
> +
> +               ceph_buffer_put(old_blob);
> +               __send_cap(mdsc, &arg, ci, wake);
>         } else {
>                 if (!list_empty(&ci->i_cap_flush_list)) {
>                         struct ceph_cap_flush *cf =
> @@ -2368,15 +2385,25 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
>                 first_tid = cf->tid + 1;
>
>                 if (cf->caps) {
> +                       struct ceph_buffer *old_blob = NULL;
> +                       struct cap_msg_args arg;
> +                       bool wake;
> +
>                         dout("kick_flushing_caps %p cap %p tid %llu %s\n",
>                              inode, cap, cf->tid, ceph_cap_string(cf->caps));
> -                       __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
> +                       __prep_cap(&arg, cap, CEPH_CAP_OP_FLUSH,
>                                          (cf->tid < last_snap_flush ?
>                                           CEPH_CLIENT_CAPS_PENDING_CAPSNAP : 0),
>                                           __ceph_caps_used(ci),
>                                           __ceph_caps_wanted(ci),
>                                           (cap->issued | cap->implemented),
> -                                         cf->caps, cf->tid, oldest_flush_tid);
> +                                         cf->caps, cf->tid, oldest_flush_tid,
> +                                         &old_blob);
> +                       wake = should_wake_cap_waiters(cap);
> +                       spin_unlock(&ci->i_ceph_lock);
> +
> +                       ceph_buffer_put(old_blob);
> +                       __send_cap(mdsc, &arg, ci, wake);
>                 } else {
>                         struct ceph_cap_snap *capsnap =
>                                         container_of(cf, struct ceph_cap_snap,
> --
> 2.25.1
>
