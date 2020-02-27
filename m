Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A641716CE
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2020 13:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgB0MJJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Feb 2020 07:09:09 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38479 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728932AbgB0MJJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Feb 2020 07:09:09 -0500
Received: by mail-qk1-f193.google.com with SMTP id z19so2836822qkj.5
        for <ceph-devel@vger.kernel.org>; Thu, 27 Feb 2020 04:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CblQPzrX34Xkevbh5/28PsodaGLelV2oaMcAWMN5UN0=;
        b=YNdgDZ/gNp3u5Atct/5ifYXGeVivWuqk5gsdhLwGAsdzHaz+DxJ9o2TCdZQlHUCMxE
         P3N0w1D+cKDNNVoQIALpOmLIVMVngsSn/Ef96Eizx4KhIfOuFhG4bflrxMzLmn0D+Ch3
         i4/5S1KqFONHJc/xtDYur8IqO9Cm2ZQjNKdUvuv102UW/EFtorgUMw1JwCTn8NGPBkui
         IdYR8gvafFfh7B5gH0EXUeU0Ux6Ib0YirJvgSEH1AafGKKV8OsyhwNi4+FOmP+czyHY9
         Kl45kG1AK7mMB16d0Of/rK+6SVNo/ZXcLRS4vmVFh9DTkfpLEl1dA6CZFEIiD1or6RH4
         0VCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CblQPzrX34Xkevbh5/28PsodaGLelV2oaMcAWMN5UN0=;
        b=qYre0TV6Yesep/j7NW39ojSpwUblbCnZRBhvQ9yaJZq9xtX05kYyeYyqSZ6if4125i
         un3kn1bbwKVgNBgImvarPdymu10iRUCKxlfFy8K09zXbD703f1PLA0mkT+I8eq5dM8db
         8VnmbzvhDxSBzl4bePA5KGfaen6CosR6Algy8F5Okvbe+GRTw+ndDMkv8r251fQ0Zb+b
         iczpWKMyz0cTfy8kj1e8hCuC0i3jFV7VTNFLzrXiMkZO9G1mH2SiwBUrGWlTky1NI+UV
         x3iGH9+FTo5N69EwSPSxcyvXaOSUaTPawmPgfkrgoUj9toBAtKZ3G2+ZadyktYH+BNmD
         HIAA==
X-Gm-Message-State: APjAAAXSuwFC3lLbTUO7JaqLPq8sagK1K1JUundBep9mnt0C7mj/9tV2
        Us4sRqVctSxw0PEQqqM5JAM9qTrDy/a+pbMgyLM=
X-Google-Smtp-Source: APXvYqyOP+xZYH8RVffbiQhOiLQaiiX/ENALFQgMJFCOihj1zsEELOconb1jgJcAzFFletqCH6Sv00cQplc7yaxmWk8=
X-Received: by 2002:a05:620a:1530:: with SMTP id n16mr5129404qkk.394.1582805347501;
 Thu, 27 Feb 2020 04:09:07 -0800 (PST)
MIME-Version: 1.0
References: <20200221131659.87777-1-zyan@redhat.com> <20200221131659.87777-5-zyan@redhat.com>
 <51ded476a2fc1cd7fcb887ed6886ae2800777f41.camel@kernel.org>
In-Reply-To: <51ded476a2fc1cd7fcb887ed6886ae2800777f41.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 27 Feb 2020 20:08:55 +0800
Message-ID: <CAAM7YA=bv707wM9Gez5+=ib0bbjR5L5+eWoAwk04xmXEEgtXpQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ceph: remove delay check logic from ceph_check_caps()
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 27, 2020 at 7:45 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
> > __ceph_caps_file_wanted() already checks 'caps_wanted_delay_min' and
> > 'caps_wanted_delay_max'. There is no need to duplicte the logic in
> > ceph_check_caps() and __send_cap()
> >
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/caps.c  | 146 ++++++++++++------------------------------------
> >  fs/ceph/file.c  |   7 +--
> >  fs/ceph/inode.c |   1 -
> >  fs/ceph/super.h |   8 +--
> >  4 files changed, 42 insertions(+), 120 deletions(-)
> >
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 2959e4c36a15..ad365cf870f6 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -490,13 +490,10 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
> >                              struct ceph_inode_info *ci)
> >  {
> >       struct ceph_mount_options *opt = mdsc->fsc->mount_options;
> > -
> > -     ci->i_hold_caps_min = round_jiffies(jiffies +
> > -                                         opt->caps_wanted_delay_min * HZ);
> >       ci->i_hold_caps_max = round_jiffies(jiffies +
> >                                           opt->caps_wanted_delay_max * HZ);
> > -     dout("__cap_set_timeouts %p min %lu max %lu\n", &ci->vfs_inode,
> > -          ci->i_hold_caps_min - jiffies, ci->i_hold_caps_max - jiffies);
> > +     dout("__cap_set_timeouts %p %lu\n", &ci->vfs_inode,
> > +          ci->i_hold_caps_max - jiffies);
> >  }
> >
> >  /*
> > @@ -508,8 +505,7 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
> >   *    -> we take mdsc->cap_delay_lock
> >   */
> >  static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
> > -                             struct ceph_inode_info *ci,
> > -                             bool set_timeout)
> > +                             struct ceph_inode_info *ci)
> >  {
> >       dout("__cap_delay_requeue %p flags %d at %lu\n", &ci->vfs_inode,
> >            ci->i_ceph_flags, ci->i_hold_caps_max);
> > @@ -520,8 +516,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
> >                               goto no_change;
> >                       list_del_init(&ci->i_cap_delay_list);
> >               }
> > -             if (set_timeout)
> > -                     __cap_set_timeouts(mdsc, ci);
> > +             __cap_set_timeouts(mdsc, ci);
> >               list_add_tail(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
> >  no_change:
> >               spin_unlock(&mdsc->cap_delay_lock);
> > @@ -719,7 +714,7 @@ void ceph_add_cap(struct inode *inode,
> >               dout(" issued %s, mds wanted %s, actual %s, queueing\n",
> >                    ceph_cap_string(issued), ceph_cap_string(wanted),
> >                    ceph_cap_string(actual_wanted));
> > -             __cap_delay_requeue(mdsc, ci, true);
> > +             __cap_delay_requeue(mdsc, ci);
> >       }
> >
> >       if (flags & CEPH_CAP_FLAG_AUTH) {
> > @@ -1304,7 +1299,6 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
> >       struct cap_msg_args arg;
> >       int held, revoking;
> >       int wake = 0;
> > -     int delayed = 0;
> >       int ret;
> >
> >       held = cap->issued | cap->implemented;
> > @@ -1317,28 +1311,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
> >            ceph_cap_string(revoking));
> >       BUG_ON((retain & CEPH_CAP_PIN) == 0);
> >
> > -     arg.session = cap->session;
> > -
> > -     /* don't release wanted unless we've waited a bit. */
> > -     if ((ci->i_ceph_flags & CEPH_I_NODELAY) == 0 &&
> > -         time_before(jiffies, ci->i_hold_caps_min)) {
> > -             dout(" delaying issued %s -> %s, wanted %s -> %s on send\n",
> > -                  ceph_cap_string(cap->issued),
> > -                  ceph_cap_string(cap->issued & retain),
> > -                  ceph_cap_string(cap->mds_wanted),
> > -                  ceph_cap_string(want));
> > -             want |= cap->mds_wanted;
> > -             retain |= cap->issued;
> > -             delayed = 1;
> > -     }
> > -     ci->i_ceph_flags &= ~(CEPH_I_NODELAY | CEPH_I_FLUSH);
> > -     if (want & ~cap->mds_wanted) {
> > -             /* user space may open/close single file frequently.
> > -              * This avoids droping mds_wanted immediately after
> > -              * requesting new mds_wanted.
> > -              */
> > -             __cap_set_timeouts(mdsc, ci);
> > -     }
> > +     ci->i_ceph_flags &= ~CEPH_I_FLUSH;
> >
> >       cap->issued &= retain;  /* drop bits we don't want */
> >       if (cap->implemented & ~cap->issued) {
> > @@ -1353,6 +1326,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
> >       cap->implemented &= cap->issued | used;
> >       cap->mds_wanted = want;
> >
> > +     arg.session = cap->session;
> >       arg.ino = ceph_vino(inode).ino;
> >       arg.cid = cap->cap_id;
> >       arg.follows = flushing ? ci->i_head_snapc->seq : 0;
> > @@ -1413,14 +1387,19 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
> >
> >       ret = send_cap_msg(&arg);
> >       if (ret < 0) {
> > -             dout("error sending cap msg, must requeue %p\n", inode);
> > -             delayed = 1;
> > +             pr_err("error sending cap msg, ino (%llx.%llx) "
> > +                    "flushing %s tid %llu, requeue\n",
> > +                    ceph_vinop(inode), ceph_cap_string(flushing),
> > +                    flush_tid);
> > +             spin_lock(&ci->i_ceph_lock);
> > +             __cap_delay_requeue(mdsc, ci);
> > +             spin_unlock(&ci->i_ceph_lock);
> >       }
> >
> >       if (wake)
> >               wake_up_all(&ci->i_cap_wq);
> >
> > -     return delayed;
> > +     return ret;
> >  }
> >
> >  static inline int __send_flush_snap(struct inode *inode,
> > @@ -1684,7 +1663,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
> >       if (((was | ci->i_flushing_caps) & CEPH_CAP_FILE_BUFFER) &&
> >           (mask & CEPH_CAP_FILE_BUFFER))
> >               dirty |= I_DIRTY_DATASYNC;
> > -     __cap_delay_requeue(mdsc, ci, true);
> > +     __cap_delay_requeue(mdsc, ci);
> >       return dirty;
> >  }
> >
> > @@ -1835,8 +1814,6 @@ bool __ceph_should_report_size(struct ceph_inode_info *ci)
> >   * versus held caps.  Release, flush, ack revoked caps to mds as
> >   * appropriate.
> >   *
> > - *  CHECK_CAPS_NODELAY - caller is delayed work and we should not delay
> > - *    cap release further.
> >   *  CHECK_CAPS_AUTHONLY - we should only check the auth cap
> >   *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, without
> >   *    further delay.
> > @@ -1855,17 +1832,10 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >       int mds = -1;   /* keep track of how far we've gone through i_caps list
> >                          to avoid an infinite loop on retry */
> >       struct rb_node *p;
> > -     int delayed = 0, sent = 0;
> > -     bool no_delay = flags & CHECK_CAPS_NODELAY;
> >       bool queue_invalidate = false;
> >       bool tried_invalidate = false;
> >
> > -     /* if we are unmounting, flush any unused caps immediately. */
> > -     if (mdsc->stopping)
> > -             no_delay = true;
> > -
> >       spin_lock(&ci->i_ceph_lock);
> > -
> >       if (ci->i_ceph_flags & CEPH_I_FLUSH)
> >               flags |= CHECK_CAPS_FLUSH;
> >
> > @@ -1911,14 +1881,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >       }
> >
> >       dout("check_caps %p file_want %s used %s dirty %s flushing %s"
> > -          " issued %s revoking %s retain %s %s%s%s\n", inode,
> > +          " issued %s revoking %s retain %s %s%s\n", inode,
> >            ceph_cap_string(file_wanted),
> >            ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
> >            ceph_cap_string(ci->i_flushing_caps),
> >            ceph_cap_string(issued), ceph_cap_string(revoking),
> >            ceph_cap_string(retain),
> >            (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
> > -          (flags & CHECK_CAPS_NODELAY) ? " NODELAY" : "",
> >            (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "");
> >
> >       /*
> > @@ -1926,7 +1895,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >        * have cached pages, but don't want them, then try to invalidate.
> >        * If we fail, it's because pages are locked.... try again later.
> >        */
> > -     if ((!no_delay || mdsc->stopping) &&
> > +     if ((!(flags & CHECK_CAPS_NOINVAL) || mdsc->stopping) &&
> >           S_ISREG(inode->i_mode) &&
> >           !(ci->i_wb_ref || ci->i_wrbuffer_ref) &&   /* no dirty pages... */
> >           inode->i_data.nrpages &&            /* have cached pages */
> > @@ -2006,21 +1975,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >               if ((cap->issued & ~retain) == 0)
> >                       continue;     /* nope, all good */
> >
> > -             if (no_delay)
> > -                     goto ack;
> > -
> > -             /* delay? */
> > -             if ((ci->i_ceph_flags & CEPH_I_NODELAY) == 0 &&
> > -                 time_before(jiffies, ci->i_hold_caps_max)) {
> > -                     dout(" delaying issued %s -> %s, wanted %s -> %s\n",
> > -                          ceph_cap_string(cap->issued),
> > -                          ceph_cap_string(cap->issued & retain),
> > -                          ceph_cap_string(cap->mds_wanted),
> > -                          ceph_cap_string(want));
> > -                     delayed++;
> > -                     continue;
> > -             }
> > -
> >  ack:
> >               if (session && session != cap->session) {
> >                       dout("oops, wrong session %p mutex\n", session);
> > @@ -2081,24 +2035,18 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >               }
> >
> >               mds = cap->mds;  /* remember mds, so we don't repeat */
> > -             sent++;
> >
> >               /* __send_cap drops i_ceph_lock */
> > -             delayed += __send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0,
> > -                             cap_used, want, retain, flushing,
> > -                             flush_tid, oldest_flush_tid);
> > +             __send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> > +                        retain, flushing, flush_tid, oldest_flush_tid);
> >               goto retry; /* retake i_ceph_lock and restart our cap scan. */
> >       }
> >
> > -     if (list_empty(&ci->i_cap_delay_list)) {
> > -         if (delayed) {
> > -                 /* Reschedule delayed caps release if we delayed anything */
> > -                 __cap_delay_requeue(mdsc, ci, false);
> > -         } else if ((file_wanted & ~CEPH_CAP_PIN) &&
> > -                     !(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
> > -                 /* periodically re-calculate caps wanted by open files */
> > -                 __cap_delay_requeue(mdsc, ci, true);
> > -         }
> > +     /* periodically re-calculate caps wanted by open files */
> > +     if (list_empty(&ci->i_cap_delay_list) &&
> > +         (file_wanted & ~CEPH_CAP_PIN) &&
> > +         !(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
> > +             __cap_delay_requeue(mdsc, ci);
> >       }
> >
> >       spin_unlock(&ci->i_ceph_lock);
> > @@ -2128,7 +2076,6 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
> >  retry_locked:
> >       if (ci->i_dirty_caps && ci->i_auth_cap) {
> >               struct ceph_cap *cap = ci->i_auth_cap;
> > -             int delayed;
> >
> >               if (session != cap->session) {
> >                       spin_unlock(&ci->i_ceph_lock);
> > @@ -2157,18 +2104,10 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
> >                                                &oldest_flush_tid);
> >
> >               /* __send_cap drops i_ceph_lock */
> > -             delayed = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
> > -                                  CEPH_CLIENT_CAPS_SYNC,
> > -                                  __ceph_caps_used(ci),
> > -                                  __ceph_caps_wanted(ci),
> > -                                  (cap->issued | cap->implemented),
> > -                                  flushing, flush_tid, oldest_flush_tid);
> > -
> > -             if (delayed) {
> > -                     spin_lock(&ci->i_ceph_lock);
> > -                     __cap_delay_requeue(mdsc, ci, true);
> > -                     spin_unlock(&ci->i_ceph_lock);
> > -             }
> > +             __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH, CEPH_CLIENT_CAPS_SYNC,
> > +                        __ceph_caps_used(ci), __ceph_caps_wanted(ci),
> > +                        (cap->issued | cap->implemented),
> > +                        flushing, flush_tid, oldest_flush_tid);
> >       } else {
> >               if (!list_empty(&ci->i_cap_flush_list)) {
> >                       struct ceph_cap_flush *cf =
> > @@ -2368,22 +2307,13 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
> >               if (cf->caps) {
> >                       dout("kick_flushing_caps %p cap %p tid %llu %s\n",
> >                            inode, cap, cf->tid, ceph_cap_string(cf->caps));
> > -                     ci->i_ceph_flags |= CEPH_I_NODELAY;
> > -
> > -                     ret = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
> > +                     __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
> >                                        (cf->tid < last_snap_flush ?
> >                                         CEPH_CLIENT_CAPS_PENDING_CAPSNAP : 0),
> >                                         __ceph_caps_used(ci),
> >                                         __ceph_caps_wanted(ci),
> >                                         (cap->issued | cap->implemented),
> >                                         cf->caps, cf->tid, oldest_flush_tid);
> > -                     if (ret) {
> > -                             pr_err("kick_flushing_caps: error sending "
> > -                                     "cap flush, ino (%llx.%llx) "
> > -                                     "tid %llu flushing %s\n",
> > -                                     ceph_vinop(inode), cf->tid,
> > -                                     ceph_cap_string(cf->caps));
> > -                     }
> >               } else {
> >                       struct ceph_cap_snap *capsnap =
> >                                       container_of(cf, struct ceph_cap_snap,
> > @@ -3001,7 +2931,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
> >       dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
> >            last ? " last" : "", put ? " put" : "");
> >
> > -     if (last && !flushsnaps)
> > +     if (last)
> >               ceph_check_caps(ci, 0, NULL);
> >       else if (flushsnaps)
> >               ceph_flush_snaps(ci, NULL);
> > @@ -3419,10 +3349,10 @@ static void handle_cap_grant(struct inode *inode,
> >               wake_up_all(&ci->i_cap_wq);
> >
> >       if (check_caps == 1)
> > -             ceph_check_caps(ci, CHECK_CAPS_NODELAY|CHECK_CAPS_AUTHONLY,
> > +             ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL,
> >                               session);
> >       else if (check_caps == 2)
> > -             ceph_check_caps(ci, CHECK_CAPS_NODELAY, session);
> > +             ceph_check_caps(ci, CHECK_CAPS_NOINVAL, session);
> >       else
> >               mutex_unlock(&session->s_mutex);
> >  }
> > @@ -4097,7 +4027,6 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
> >  {
> >       struct inode *inode;
> >       struct ceph_inode_info *ci;
> > -     int flags = CHECK_CAPS_NODELAY;
> >
> >       dout("check_delayed_caps\n");
> >       while (1) {
> > @@ -4117,7 +4046,7 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
> >
> >               if (inode) {
> >                       dout("check_delayed_caps on %p\n", inode);
> > -                     ceph_check_caps(ci, flags, NULL);
> > +                     ceph_check_caps(ci, 0, NULL);
> >                       /* avoid calling iput_final() in tick thread */
> >                       ceph_async_iput(inode);
> >               }
> > @@ -4142,7 +4071,7 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
> >               ihold(inode);
> >               dout("flush_dirty_caps %p\n", inode);
> >               spin_unlock(&mdsc->cap_dirty_lock);
> > -             ceph_check_caps(ci, CHECK_CAPS_NODELAY|CHECK_CAPS_FLUSH, NULL);
> > +             ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
> >               iput(inode);
> >               spin_lock(&mdsc->cap_dirty_lock);
> >       }
> > @@ -4160,7 +4089,7 @@ void __ceph_touch_fmode(struct ceph_inode_info *ci,
> >               ci->i_last_wr = now;
> >       /* queue periodic check */
> >       if (fmode && list_empty(&ci->i_cap_delay_list))
> > -             __cap_delay_requeue(mdsc, ci, true);
> > +             __cap_delay_requeue(mdsc, ci);
> >  }
> >
> >  void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
> > @@ -4209,7 +4138,6 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
> >       if (inode->i_nlink == 1) {
> >               drop |= ~(__ceph_caps_wanted(ci) | CEPH_CAP_PIN);
> >
> > -             ci->i_ceph_flags |= CEPH_I_NODELAY;
> >               if (__ceph_caps_dirty(ci)) {
> >                       struct ceph_mds_client *mdsc =
> >                               ceph_inode_to_client(inode)->mdsc;
> > @@ -4265,8 +4193,6 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
> >               if (force || (cap->issued & drop)) {
> >                       if (cap->issued & drop) {
> >                               int wanted = __ceph_caps_wanted(ci);
> > -                             if ((ci->i_ceph_flags & CEPH_I_NODELAY) == 0)
> > -                                     wanted |= cap->mds_wanted;
> >                               dout("encode_inode_release %p cap %p "
> >                                    "%s -> %s, wanted %s -> %s\n", inode, cap,
> >                                    ceph_cap_string(cap->issued),
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 84058d3c5685..1d76bdf1a1b9 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1552,7 +1552,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >               if (dirty)
> >                       __mark_inode_dirty(inode, dirty);
> >               if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
> > -                     ceph_check_caps(ci, CHECK_CAPS_NODELAY, NULL);
> > +                     ceph_check_caps(ci, 0, NULL);
> >       }
> >
> >       dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
> > @@ -2129,12 +2129,11 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >
> >       if (endoff > size) {
> >               int caps_flags = 0;
> > -
> >               /* Let the MDS know about dst file size change */
> > -             if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
> > -                     caps_flags |= CHECK_CAPS_NODELAY;
> >               if (ceph_inode_set_size(dst_inode, endoff))
> >                       caps_flags |= CHECK_CAPS_AUTHONLY;
> > +             if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
> > +                     caps_flags |= CHECK_CAPS_AUTHONLY;
>
> Does ceph_quota_is_max_bytes_approaching have any side effects?
>
> It looks like that call can be pretty expensive (including a possible
> separate round trip to the MDS). If we don't need to call it for other
> reasons, then we should probably do:
>
>                 if (ceph_inode_set_size(dst_inode, dst_off) ||
>                     ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
>                         caps_flags |= CHECK_CAPS_AUTHONLY;
>
>

No side affect. I added this change to
https://github.com/ceph/ceph-client/tree/wip-fmode-timeout


> >               if (caps_flags)
> >                       ceph_check_caps(dst_ci, caps_flags, NULL);
> >       }
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 0b0f503c84c3..5a8fa8a2d3cf 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -471,7 +471,6 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
> >       ci->i_prealloc_cap_flush = NULL;
> >       INIT_LIST_HEAD(&ci->i_cap_flush_list);
> >       init_waitqueue_head(&ci->i_cap_wq);
> > -     ci->i_hold_caps_min = 0;
> >       ci->i_hold_caps_max = 0;
> >       INIT_LIST_HEAD(&ci->i_cap_delay_list);
> >       INIT_LIST_HEAD(&ci->i_cap_snaps);
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index d89478db8b24..e586cff3dfd5 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -170,9 +170,9 @@ struct ceph_cap {
> >       struct list_head caps_item;
> >  };
> >
> > -#define CHECK_CAPS_NODELAY    1  /* do not delay any further */
> > -#define CHECK_CAPS_AUTHONLY   2  /* only check auth cap */
> > -#define CHECK_CAPS_FLUSH      4  /* flush any dirty caps */
> > +#define CHECK_CAPS_AUTHONLY   1  /* only check auth cap */
> > +#define CHECK_CAPS_FLUSH      2  /* flush any dirty caps */
> > +#define CHECK_CAPS_NOINVAL    4  /* don't invalidate pagecache */
> >
> >  struct ceph_cap_flush {
> >       u64 tid;
> > @@ -352,7 +352,6 @@ struct ceph_inode_info {
> >       struct ceph_cap_flush *i_prealloc_cap_flush;
> >       struct list_head i_cap_flush_list;
> >       wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
> > -     unsigned long i_hold_caps_min; /* jiffies */
> >       unsigned long i_hold_caps_max; /* jiffies */
> >       struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
> >       struct ceph_cap_reservation i_cap_migration_resv;
> > @@ -513,7 +512,6 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
> >   * Ceph inode.
> >   */
> >  #define CEPH_I_DIR_ORDERED   (1 << 0)  /* dentries in dir are ordered */
> > -#define CEPH_I_NODELAY               (1 << 1)  /* do not delay cap release */
> >  #define CEPH_I_FLUSH         (1 << 2)  /* do not delay flush of dirty metadata */
> >  #define CEPH_I_POOL_PERM     (1 << 3)  /* pool rd/wr bits are valid */
> >  #define CEPH_I_POOL_RD               (1 << 4)  /* can read from pool */
>
> --
> Jeff Layton <jlayton@kernel.org>
>
