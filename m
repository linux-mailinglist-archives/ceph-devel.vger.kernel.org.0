Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A80819CEDB
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Apr 2020 05:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390204AbgDCDWG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Apr 2020 23:22:06 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:38997 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388951AbgDCDWG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Apr 2020 23:22:06 -0400
Received: by mail-qv1-f66.google.com with SMTP id v38so2947935qvf.6
        for <ceph-devel@vger.kernel.org>; Thu, 02 Apr 2020 20:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5rU1akUn68A6Wc6Upk7LYX7ztCyRJ9IQtZlblr0vQHw=;
        b=iwqLs8Tvzfmiq2hDuXvC8ZzZo+4H3DTX6fezpzFUlKh9P4v+fqOYgQyrIWSi51L2a5
         P4ioRNjHb9q8UZdyit4TSPIHWlOtjRuIKYNL4VODTkEQzS79WVodvw0wHhTOFpcEkur8
         3x+iy1wYRPFVE59ktAAEARP9wr7mhXOExK8s8JCE9SeAgFwcd+Bl5xZeNBVnComRxEuJ
         aWyxiF3nAYhWhoP7A2CgwMrKLo9srKxiYJtf3UYyoKSW0hYieJMaZQ1ZlP6Gs8sbq2eE
         jtsa3F0uuvj14pfzGjqkBih7lf6NKSvZ0Ktdy09TBucgJMFz7gfUywc2ImT2f0xREV8G
         yqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5rU1akUn68A6Wc6Upk7LYX7ztCyRJ9IQtZlblr0vQHw=;
        b=oyV89THTG+fblYEusNBtQ1MTLOBqqLB4If/So98MSfM1KelGXM6f7aHQU8YKmb6dGx
         i7wrnMYXsjRKQTxEx+6wAD+oO9JHhDqL9ozk/dWf2l4+uc8IL8gF0HB8Ji8Nx0gzHO9k
         eJDziDJYO6/l+Nl1FazNbPD1XJynWui3Ap5Bw1ayzU50aVfn9tZbocwEZm/urnWnCI3F
         tV+w1oi19izfdA5UCoFish+6bzOPhR5Sd2MHm7RWZnYKtKnEGLeEdXHV0Dt4hvNI+WL+
         A4hgE5I35RgP+uuXPRJ+ecH3DddvIzE1nBONWHLsq5DGHJ+n1yNmVMRuZoandDP7ktiN
         RIdw==
X-Gm-Message-State: AGi0PuYYLWsrJ/XrksUqvLZNBYqKU1DuJrXaAwSZL3bju8vyyn0aecF6
        owElsu50ChgGCRpb07st5CQmJHjSORq3F9QfRJQ=
X-Google-Smtp-Source: APiQypJh0S6/1oOUOaFt+wHE4gIM9kOCJjg2T8PqkbKB++fuCH8b/AJbhdDWa1uPQDaJbqAZAYUtMOG9go+oBn9ESFc=
X-Received: by 2002:ad4:4851:: with SMTP id t17mr6470989qvy.33.1585884124494;
 Thu, 02 Apr 2020 20:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200402112911.17023-1-jlayton@kernel.org> <20200402112911.17023-2-jlayton@kernel.org>
In-Reply-To: <20200402112911.17023-2-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 3 Apr 2020 11:21:52 +0800
Message-ID: <CAAM7YAkDdyxuyMgideN7JQYgntMSKoDLHhJQgoG5+C9QVHde0Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ceph: convert mdsc->cap_dirty to a per-session list
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Jan Fajerski <jfajerski@suse.com>,
        Luis Henriques <lhenriques@suse.com>,
        Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 2, 2020 at 7:29 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> This is a per-sb list now, but that makes it difficult to tell when
> the cap is the last dirty one associated with the session. Switch
> this to be a per-session list, but continue using the
> mdsc->cap_dirty_lock to protect the lists.
>
> This list is only ever walked in ceph_flush_dirty_caps, so change that
> to walk the sessions array and then flush the caps for inodes on each
> session's list.
>
> If the auth cap ever changes while the inode has dirty caps, then
> move the inode to the appropriate session for the new auth_cap. Also,
> ensure that we never remove an auth cap while the inode is still on the
> s_cap_dirty list.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 64 ++++++++++++++++++++++++++++++++++++++++----
>  fs/ceph/mds_client.c |  2 +-
>  fs/ceph/mds_client.h |  5 ++--
>  fs/ceph/super.h      | 21 ++++++++++++---
>  4 files changed, 81 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 61808793e0c0..95c9b25e45a6 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -727,6 +727,19 @@ void ceph_add_cap(struct inode *inode,
>         if (flags & CEPH_CAP_FLAG_AUTH) {
>                 if (!ci->i_auth_cap ||
>                     ceph_seq_cmp(ci->i_auth_cap->mseq, mseq) < 0) {
> +                       if (ci->i_auth_cap &&
> +                           ci->i_auth_cap->session != cap->session) {
> +                               /*
> +                                * If auth cap session changed, and the cap is
> +                                * dirty, move it to the correct session's list
> +                                */
> +                               if (!list_empty(&ci->i_dirty_item)) {
> +                                       spin_lock(&mdsc->cap_dirty_lock);
> +                                       list_move(&ci->i_dirty_item,
> +                                                 &cap->session->s_cap_dirty);
> +                                       spin_unlock(&mdsc->cap_dirty_lock);
> +                               }
> +                       }
>                         ci->i_auth_cap = cap;
>                         cap->mds_wanted = wanted;
>                 }
> @@ -1123,8 +1136,10 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>
>         /* remove from inode's cap rbtree, and clear auth cap */
>         rb_erase(&cap->ci_node, &ci->i_caps);
> -       if (ci->i_auth_cap == cap)
> +       if (ci->i_auth_cap == cap) {
> +               WARN_ON_ONCE(!list_empty(&ci->i_dirty_item));
>                 ci->i_auth_cap = NULL;
> +       }
>
>         /* remove from session list */
>         spin_lock(&session->s_cap_lock);
> @@ -1690,6 +1705,8 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>              ceph_cap_string(was | mask));
>         ci->i_dirty_caps |= mask;
>         if (was == 0) {
> +               struct ceph_mds_session *session = ci->i_auth_cap->session;
> +
>                 WARN_ON_ONCE(ci->i_prealloc_cap_flush);
>                 swap(ci->i_prealloc_cap_flush, *pcf);
>
> @@ -1702,7 +1719,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>                      &ci->vfs_inode, ci->i_head_snapc, ci->i_auth_cap);
>                 BUG_ON(!list_empty(&ci->i_dirty_item));
>                 spin_lock(&mdsc->cap_dirty_lock);
> -               list_add(&ci->i_dirty_item, &mdsc->cap_dirty);
> +               list_add(&ci->i_dirty_item, &session->s_cap_dirty);
>                 spin_unlock(&mdsc->cap_dirty_lock);
>                 if (ci->i_flushing_caps == 0) {
>                         ihold(inode);
> @@ -3753,6 +3770,13 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>                         if (cap == ci->i_auth_cap)
>                                 ci->i_auth_cap = tcap;
>
> +                       if (!list_empty(&ci->i_dirty_item)) {
> +                               spin_lock(&mdsc->cap_dirty_lock);
> +                               list_move(&ci->i_dirty_item,
> +                                         &tcap->session->s_cap_dirty);
> +                               spin_unlock(&mdsc->cap_dirty_lock);
> +                       }
> +
>                         if (!list_empty(&ci->i_cap_flush_list) &&
>                             ci->i_auth_cap == tcap) {
>                                 spin_lock(&mdsc->cap_dirty_lock);
> @@ -4176,15 +4200,16 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>  /*
>   * Flush all dirty caps to the mds
>   */
> -void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
> +static void flush_dirty_session_caps(struct ceph_mds_session *s)
>  {
> +       struct ceph_mds_client *mdsc = s->s_mdsc;
>         struct ceph_inode_info *ci;
>         struct inode *inode;
>
>         dout("flush_dirty_caps\n");
>         spin_lock(&mdsc->cap_dirty_lock);
> -       while (!list_empty(&mdsc->cap_dirty)) {
> -               ci = list_first_entry(&mdsc->cap_dirty, struct ceph_inode_info,
> +       while (!list_empty(&s->s_cap_dirty)) {
> +               ci = list_first_entry(&s->s_cap_dirty, struct ceph_inode_info,
>                                       i_dirty_item);
>                 inode = &ci->vfs_inode;
>                 ihold(inode);
> @@ -4198,6 +4223,35 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
>         dout("flush_dirty_caps done\n");
>  }
>
> +static void iterate_sessions(struct ceph_mds_client *mdsc,
> +                            void (*cb)(struct ceph_mds_session *))
> +{
> +       int mds = 0;
> +
> +       mutex_lock(&mdsc->mutex);
> +       for (mds = 0; mds < mdsc->max_sessions; ++mds) {
> +               struct ceph_mds_session *s;
> +
> +               if (!mdsc->sessions[mds])
> +                       continue;
> +
> +               s = ceph_get_mds_session(mdsc->sessions[mds]);
> +               if (!s)
> +                       continue;
> +
> +               mutex_unlock(&mdsc->mutex);
> +               cb(s);
> +               ceph_put_mds_session(s);
> +               mutex_lock(&mdsc->mutex);
> +       };
> +       mutex_unlock(&mdsc->mutex);
> +}
> +
> +void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
> +{
> +       iterate_sessions(mdsc, flush_dirty_session_caps);
> +}
> +
>  void __ceph_touch_fmode(struct ceph_inode_info *ci,
>                         struct ceph_mds_client *mdsc, int fmode)
>  {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9a8e7013aca1..be4ad7d28e3a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -755,6 +755,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>         INIT_LIST_HEAD(&s->s_cap_releases);
>         INIT_WORK(&s->s_cap_release_work, ceph_cap_release_work);
>
> +       INIT_LIST_HEAD(&s->s_cap_dirty);
>         INIT_LIST_HEAD(&s->s_cap_flushing);
>
>         mdsc->sessions[mds] = s;
> @@ -4375,7 +4376,6 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>         spin_lock_init(&mdsc->snap_flush_lock);
>         mdsc->last_cap_flush_tid = 1;
>         INIT_LIST_HEAD(&mdsc->cap_flush_list);
> -       INIT_LIST_HEAD(&mdsc->cap_dirty);
>         INIT_LIST_HEAD(&mdsc->cap_dirty_migrating);
>         mdsc->num_cap_flushing = 0;
>         spin_lock_init(&mdsc->cap_dirty_lock);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 8065863321fc..bd20257fb4c2 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -199,8 +199,10 @@ struct ceph_mds_session {
>         struct list_head  s_cap_releases; /* waiting cap_release messages */
>         struct work_struct s_cap_release_work;
>
> -       /* protected by mutex */
> +       /* both protected by s_mdsc->cap_dirty_lock */
> +       struct list_head  s_cap_dirty;        /* inodes w/ dirty caps */
>         struct list_head  s_cap_flushing;     /* inodes w/ flushing caps */
> +
>         unsigned long     s_renew_requested; /* last time we sent a renew req */
>         u64               s_renew_seq;
>
> @@ -424,7 +426,6 @@ struct ceph_mds_client {
>
>         u64               last_cap_flush_tid;
>         struct list_head  cap_flush_list;
> -       struct list_head  cap_dirty;        /* inodes with dirty caps */
>         struct list_head  cap_dirty_migrating; /* ...that are migration... */
>         int               num_cap_flushing; /* # caps we are flushing */
>         spinlock_t        cap_dirty_lock;   /* protects above items */
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index bb372859c0ad..3235c7e3bde7 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -351,9 +351,24 @@ struct ceph_inode_info {
>         struct rb_root i_caps;           /* cap list */
>         struct ceph_cap *i_auth_cap;     /* authoritative cap, if any */
>         unsigned i_dirty_caps, i_flushing_caps;     /* mask of dirtied fields */
> -       struct list_head i_dirty_item, i_flushing_item; /* protected by
> -                                                        * mdsc->cap_dirty_lock
> -                                                        */
> +
> +       /*
> +        * Link to the the auth cap's session's s_cap_dirty list. s_cap_dirty
> +        * is protected by the mdsc->cap_dirty_lock, but each individual item
> +        * is also protected by the inode's i_ceph_lock. Walking s_cap_dirty
> +        * requires the mdsc->cap_dirty_lock. List presence for an item can
> +        * be tested under the i_ceph_lock. Changing anything requires both.
> +        */
> +       struct list_head i_dirty_item;
> +
> +       /* Link to session's s_cap_flushing list. Protected by
> +        * mdsc->cap_dirty_lock.
> +        *
> +        * FIXME: this list is sometimes walked without the spinlock being
> +        *        held. What really protects it?
> +        */
> +       struct list_head i_flushing_item;
> +
>         /* we need to track cap writeback on a per-cap-bit basis, to allow
>          * overlapping, pipelined cap flushes to the mds.  we can probably
>          * reduce the tid to 8 bits if we're concerned about inode size. */
> --
> 2.25.1
>

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>

I think it's better to unify i_dirty_item and i_flushing_item
handling.  how about add a new patch that puts code that move
i_flushing to new  auth session together with the code that move
i_dirty_item.
