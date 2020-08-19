Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38CC249F1C
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 15:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgHSNHG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 09:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbgHSNG5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 09:06:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA840C061757
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 06:06:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so20566483iln.1
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 06:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hl3CH1y3gpS1LkA3BRX4igPWdUFis9urrbf3FL329Nc=;
        b=huVP8NiYObRH0MAE+X2MYZlr1T3oNekmvxx7ale7oNa3QHHsAmPJwn0wtn8r2qYLFB
         F1Rw35LZRb+6pl6C+clkYFTx8eSDmNNyQE+Hr/4BEbjdIp+Iu8j8v+kyD73HlIKJ2i8F
         h0jQg+w1HjvKoEo2g6bkIuoWh+2kwV7PwFuW+eyumiPn36I8/q4TZtHHQ0DG88j4vnkH
         DC6T55PpTFYZAr3t+C1seK1tqwe81Nz0AgW45s1JzBkvsvEPtEnzWdWHbKigWJQXm76U
         Oyniy7GFOhuhBnL4gCrRtd8sOLbUWf2YxmGWAkHxF+5gtmEwK96s2yHIqGwwjJJcNviS
         mFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hl3CH1y3gpS1LkA3BRX4igPWdUFis9urrbf3FL329Nc=;
        b=Q5dDHZBLETf3Djjob/4meZyIJf2lpaLo24/ezZU2VRvqOYyV5V2hH3wDCdT0fr/AUH
         EdBPanYnwdGwxEVvtcwoEm0vaFqssFaPay2QO7h4FyFu8j/i+ENr/VLUXH4r4yiQKukd
         MufMLvH561gDer+pR/YuOe2tvzbyNWDTKuw1oAFGNywp3wHZU0vFJlPts8N9bjIb421c
         NmX1RFl7XxP00bgsNBELiKPukQ5xt0XV1R07Ozl7094zo4Z+dJnBiWmLbCKRvJW5RnSn
         l8glpoRPA/B7bAnDC1Tdnfk58M8MDqmaPQCyAD6xPzJNL85khcjSewjCF5RBVUdL1K9r
         BErg==
X-Gm-Message-State: AOAM530xCMo8oPfG0sqcbWcSYQg6sF3sLXv9kTqhHwta7D8ROwUtljj/
        Pcwmcf3UbYMoEnTjRlXCXFp/nJhpm3y4hjLIq/BSs0HiOqw=
X-Google-Smtp-Source: ABdhPJwuH+cvOwMgpkxCVqlZiSnG+5KCyU+3o9hkcd37AOAjXjtKVM0dn2wtQcnZDs7wWlOlI+RpPQvdatDWdJ7bp1M=
X-Received: by 2002:a05:6e02:86:: with SMTP id l6mr13724084ilm.281.1597842414271;
 Wed, 19 Aug 2020 06:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200819093614.22774-1-idryomov@gmail.com> <621fd8c3449930aef3ff8eb9542dc32c760afed5.camel@kernel.org>
In-Reply-To: <621fd8c3449930aef3ff8eb9542dc32c760afed5.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Aug 2020 15:07:01 +0200
Message-ID: <CAOi1vP86LGSLDjGdpw7Qf_MgoNt4+a-7pbXa_G=q68RuzeggaA@mail.gmail.com>
Subject: Re: [PATCH] libceph: multiple workspaces for CRUSH computations
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Robin Geuze <robing@nl.team.blue>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 2:25 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-08-19 at 11:36 +0200, Ilya Dryomov wrote:
> > Replace a global map->crush_workspace (protected by a global mutex)
> > with a list of workspaces, up to the number of CPUs + 1.
> >
> > This is based on a patch from Robin Geuze <robing@nl.team.blue>.
> > Robin and his team have observed a 10-20% increase in IOPS on all
> > queue depths and lower CPU usage as well on a high-end all-NVMe
> > 100GbE cluster.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  include/linux/ceph/osdmap.h |  14 ++-
> >  include/linux/crush/crush.h |   3 +
> >  net/ceph/osdmap.c           | 166 ++++++++++++++++++++++++++++++++----
> >  3 files changed, 166 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
> > index 3f4498fef6ad..cad9acfbc320 100644
> > --- a/include/linux/ceph/osdmap.h
> > +++ b/include/linux/ceph/osdmap.h
> > @@ -137,6 +137,17 @@ int ceph_oid_aprintf(struct ceph_object_id *oid, gfp_t gfp,
> >                    const char *fmt, ...);
> >  void ceph_oid_destroy(struct ceph_object_id *oid);
> >
> > +struct workspace_manager {
> > +     struct list_head idle_ws;
> > +     spinlock_t ws_lock;
> > +     /* Number of free workspaces */
> > +     int free_ws;
> > +     /* Total number of allocated workspaces */
> > +     atomic_t total_ws;
> > +     /* Waiters for a free workspace */
> > +     wait_queue_head_t ws_wait;
> > +};
> > +
> >  struct ceph_pg_mapping {
> >       struct rb_node node;
> >       struct ceph_pg pgid;
> > @@ -184,8 +195,7 @@ struct ceph_osdmap {
> >        * the list of osds that store+replicate them. */
> >       struct crush_map *crush;
> >
> > -     struct mutex crush_workspace_mutex;
> > -     void *crush_workspace;
> > +     struct workspace_manager crush_wsm;
> >  };
> >
> >  static inline bool ceph_osd_exists(struct ceph_osdmap *map, int osd)
> > diff --git a/include/linux/crush/crush.h b/include/linux/crush/crush.h
> > index 2f811baf78d2..30dba392b730 100644
> > --- a/include/linux/crush/crush.h
> > +++ b/include/linux/crush/crush.h
> > @@ -346,6 +346,9 @@ struct crush_work_bucket {
> >
> >  struct crush_work {
> >       struct crush_work_bucket **work; /* Per-bucket working store */
> > +#ifdef __KERNEL__
> > +     struct list_head item;
> > +#endif
> >  };
> >
> >  #ifdef __KERNEL__
> > diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> > index 96c25f5e064a..fa08c15be0c0 100644
> > --- a/net/ceph/osdmap.c
> > +++ b/net/ceph/osdmap.c
> > @@ -964,6 +964,143 @@ static int decode_pool_names(void **p, void *end, struct ceph_osdmap *map)
> >       return -EINVAL;
> >  }
> >
> > +/*
> > + * CRUSH workspaces
> > + *
> > + * workspace_manager framework borrowed from fs/btrfs/compression.c.
> > + * Two simplifications: there is only one type of workspace and there
> > + * is always at least one workspace.
> > + */
> > +static struct crush_work *alloc_workspace(const struct crush_map *c)
> > +{
> > +     struct crush_work *work;
> > +     size_t work_size;
> > +
> > +     WARN_ON(!c->working_size);
> > +     work_size = crush_work_size(c, CEPH_PG_MAX_SIZE);
> > +     dout("%s work_size %zu bytes\n", __func__, work_size);
> > +
> > +     work = ceph_kvmalloc(work_size, GFP_NOIO);
> > +     if (!work)
> > +             return NULL;
> > +
>
> In general, how big are these allocations? They're all uniform so you
> could make a dedicated slabcache for this. Granted you'll only have one
> a max of per cpu, but some boxes have a lot of CPUs these days.

Hi Jeff,

They are going to vary in size from CRUSH map to CRUSH map and need
a vmalloc fallback, so a dedicated cache wouldn't work.

>
> > +     INIT_LIST_HEAD(&work->item);
> > +     crush_init_workspace(c, work);
> > +     return work;
> > +}
> > +
> > +static void free_workspace(struct crush_work *work)
> > +{
> > +     WARN_ON(!list_empty(&work->item));
> > +     kvfree(work);
> > +}
> > +
> > +static void init_workspace_manager(struct workspace_manager *wsm)
> > +{
> > +     INIT_LIST_HEAD(&wsm->idle_ws);
> > +     spin_lock_init(&wsm->ws_lock);
> > +     atomic_set(&wsm->total_ws, 0);
> > +     wsm->free_ws = 0;
> > +     init_waitqueue_head(&wsm->ws_wait);
> > +}
> > +
> > +static void add_initial_workspace(struct workspace_manager *wsm,
> > +                               struct crush_work *work)
> > +{
> > +     WARN_ON(!list_empty(&wsm->idle_ws));
> > +
> > +     list_add(&work->item, &wsm->idle_ws);
> > +     atomic_set(&wsm->total_ws, 1);
> > +     wsm->free_ws = 1;
> > +}
> > +
> > +static void cleanup_workspace_manager(struct workspace_manager *wsm)
> > +{
> > +     struct crush_work *work;
> > +
> > +     while (!list_empty(&wsm->idle_ws)) {
> > +             work = list_first_entry(&wsm->idle_ws, struct crush_work,
> > +                                     item);
> > +             list_del_init(&work->item);
> > +             free_workspace(work);
> > +     }
> > +     atomic_set(&wsm->total_ws, 0);
> > +     wsm->free_ws = 0;
> > +}
> > +
> > +/*
> > + * Finds an available workspace or allocates a new one.  If it's not
> > + * possible to allocate a new one, waits until there is one.
> > + */
> > +static struct crush_work *get_workspace(struct workspace_manager *wsm,
> > +                                     const struct crush_map *c)
> > +{
> > +     struct crush_work *work;
> > +     int cpus = num_online_cpus();
> > +
> > +again:
> > +     spin_lock(&wsm->ws_lock);
> > +     if (!list_empty(&wsm->idle_ws)) {
> > +             work = list_first_entry(&wsm->idle_ws, struct crush_work,
> > +                                     item);
> > +             list_del_init(&work->item);
> > +             wsm->free_ws--;
> > +             spin_unlock(&wsm->ws_lock);
> > +             return work;
> > +
> > +     }
> > +     if (atomic_read(&wsm->total_ws) > cpus) {
> > +             DEFINE_WAIT(wait);
> > +
> > +             spin_unlock(&wsm->ws_lock);
> > +             prepare_to_wait(&wsm->ws_wait, &wait, TASK_UNINTERRUPTIBLE);
> > +             if (atomic_read(&wsm->total_ws) > cpus && !wsm->free_ws)
> > +                     schedule();
> > +             finish_wait(&wsm->ws_wait, &wait);
> > +             goto again;
> > +     }
> > +     atomic_inc(&wsm->total_ws);
> > +     spin_unlock(&wsm->ws_lock);
> > +
> > +     work = alloc_workspace(c);
> > +     if (!work) {
> > +             atomic_dec(&wsm->total_ws);
> > +             wake_up(&wsm->ws_wait);
> > +
> > +             /*
> > +              * Do not return the error but go back to waiting.  We
> > +              * have the inital workspace and the CRUSH computation
> > +              * time is bounded so we will get it eventually.
> > +              */
> > +             WARN_ON(atomic_read(&wsm->total_ws) < 1);
> > +             goto again;
> > +     }
> > +     return work;
> > +}
> > +
> > +/*
> > + * Puts a workspace back on the list or frees it if we have enough
> > + * idle ones sitting around.
> > + */
> > +static void put_workspace(struct workspace_manager *wsm,
> > +                       struct crush_work *work)
> > +{
> > +     spin_lock(&wsm->ws_lock);
> > +     if (wsm->free_ws <= num_online_cpus()) {
> > +             list_add(&work->item, &wsm->idle_ws);
> > +             wsm->free_ws++;
> > +             spin_unlock(&wsm->ws_lock);
> > +             goto wake;
> > +     }
> > +     spin_unlock(&wsm->ws_lock);
> > +
> > +     free_workspace(work);
> > +     atomic_dec(&wsm->total_ws);
> > +wake:
> > +     if (wq_has_sleeper(&wsm->ws_wait))
> > +             wake_up(&wsm->ws_wait);
>
> Is this racy? Could you end up missing a wakeup because something began
> waiting between the check and wake_up? This is not being checked under
> any sort of lock, so you could end up preempted between the two.
>
> It might be better to just unconditionally call wake_up. In principle,
> that should be a no-op if there is nothing waiting.

Yeah, it raised my eyebrows as well (and !wsm->free_ws test without
a lock in get_workspace() too).  This is a straight up cut-and-paste
from Btrfs through, so I decided to leave it as is.  This is pretty
old code and it survived there for over ten years, although I'm not
sure how many people actually enable compression in the field.

If we hit issues, I'd just reimplement the whole thing from scratch
rather than attempting to tweak a cut-and-paste that is not entirely
straightforward.

Thanks,

                Ilya
