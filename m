Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382C524A172
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 16:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgHSOOh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 10:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgHSOOg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 10:14:36 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D8DC061757
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 07:14:36 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v6so24731285iow.11
        for <ceph-devel@vger.kernel.org>; Wed, 19 Aug 2020 07:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDYhFv7AvYkCsJvmwQYuD6NOQIyeeLgFcG+swHVnZEc=;
        b=LMvkuouL3uobm3n/AlR//Ivk5Zxb/mGzrjEnbVXzOYlkz/5cznMZDFctDiYD7BWGoh
         1u4TIWeATKRrzBVi20gqeYjU4fPgbQbKe3uufjMfHPWaTMWCnCKFS/SupEi3hMfghQ0+
         Bz+Sw8tJYyk05zSQQDzUtFO32Twjgcz4S96uZdDlIX0i9f8qbSXguiGiCWb4MvU8G5bN
         xripEhdrCIEMWsw33fR2q/XM1Cg4g4htwddOvyI90cOEM86PRg79NuJ1z3E6M92PUM6c
         rEOM8hZvTxz3aA5ATcY1t9KLrAQtJxkG9CuYu6zmcOMYlHeq4b2xuv1wDY/zO2sHmQSM
         G8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDYhFv7AvYkCsJvmwQYuD6NOQIyeeLgFcG+swHVnZEc=;
        b=ZqNLUHjZkTFGtb2nXSgeW7/q5PYyB+Slnrw5QkOcT1hUUHApaKRE39fgJgASp7Zs5A
         tJNGkoUqioNE2dQXanYwriuomvj12+N4HgwJJWTVmD5ZYajXs+lLYGwaoP9PdK+Rugss
         ZA388apdaVnRUA9ZSPel0Bn1LZZX4ISXWuMenzP6TshDY3HLC2ortA2uA7bdwRQKt4k3
         XZhuO7mev2ziiolzHwj1ghc3JJdbCCxIYLqQnDFIwn7toCj5cm327lQRG05gb7GQIlB3
         0MmVEofr60AgaMuixuhlc3ZtOICabjhCBhlo3W5kXZZn7xUy/ul6kSdlBNKIZTobylTu
         N3rg==
X-Gm-Message-State: AOAM532undgTNKCxESEWdNBh4tMsfghW0AX9MX/dpnreWxqIisYUkUtm
        HuhdWP4mquXPD6Nd1t/wSrJ7ufPiUuC4g7Wv912xUzzCsmc=
X-Google-Smtp-Source: ABdhPJzWZMb+AoVGlPUiZVmkEK005IMmIB7uYq2qxc+VTH7Ie5sUcF6lQIzAbExfyA+/xjoLPxq5ilaScgLaIV1hOxo=
X-Received: by 2002:a05:6638:1413:: with SMTP id k19mr23308958jad.93.1597846475507;
 Wed, 19 Aug 2020 07:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200819093614.22774-1-idryomov@gmail.com> <621fd8c3449930aef3ff8eb9542dc32c760afed5.camel@kernel.org>
 <CAOi1vP86LGSLDjGdpw7Qf_MgoNt4+a-7pbXa_G=q68RuzeggaA@mail.gmail.com> <75662a9e241bb590097c95ba24da65907388ed9f.camel@kernel.org>
In-Reply-To: <75662a9e241bb590097c95ba24da65907388ed9f.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Aug 2020 16:14:42 +0200
Message-ID: <CAOi1vP9Sn9rLp1uSqEYg6pvy8xA9eSJSzKmioCSVs_pPrV6eDQ@mail.gmail.com>
Subject: Re: [PATCH] libceph: multiple workspaces for CRUSH computations
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Robin Geuze <robing@nl.team.blue>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 3:48 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-08-19 at 15:07 +0200, Ilya Dryomov wrote:
> > On Wed, Aug 19, 2020 at 2:25 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Wed, 2020-08-19 at 11:36 +0200, Ilya Dryomov wrote:
> > > > Replace a global map->crush_workspace (protected by a global mutex)
> > > > with a list of workspaces, up to the number of CPUs + 1.
> > > >
> > > > This is based on a patch from Robin Geuze <robing@nl.team.blue>.
> > > > Robin and his team have observed a 10-20% increase in IOPS on all
> > > > queue depths and lower CPU usage as well on a high-end all-NVMe
> > > > 100GbE cluster.
> > > >
> > > > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > > > ---
> > > >  include/linux/ceph/osdmap.h |  14 ++-
> > > >  include/linux/crush/crush.h |   3 +
> > > >  net/ceph/osdmap.c           | 166 ++++++++++++++++++++++++++++++++----
> > > >  3 files changed, 166 insertions(+), 17 deletions(-)
> > > >
> > > > diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
> > > > index 3f4498fef6ad..cad9acfbc320 100644
> > > > --- a/include/linux/ceph/osdmap.h
> > > > +++ b/include/linux/ceph/osdmap.h
> > > > @@ -137,6 +137,17 @@ int ceph_oid_aprintf(struct ceph_object_id *oid, gfp_t gfp,
> > > >                    const char *fmt, ...);
> > > >  void ceph_oid_destroy(struct ceph_object_id *oid);
> > > >
> > > > +struct workspace_manager {
> > > > +     struct list_head idle_ws;
> > > > +     spinlock_t ws_lock;
> > > > +     /* Number of free workspaces */
> > > > +     int free_ws;
> > > > +     /* Total number of allocated workspaces */
> > > > +     atomic_t total_ws;
> > > > +     /* Waiters for a free workspace */
> > > > +     wait_queue_head_t ws_wait;
> > > > +};
> > > > +
> > > >  struct ceph_pg_mapping {
> > > >       struct rb_node node;
> > > >       struct ceph_pg pgid;
> > > > @@ -184,8 +195,7 @@ struct ceph_osdmap {
> > > >        * the list of osds that store+replicate them. */
> > > >       struct crush_map *crush;
> > > >
> > > > -     struct mutex crush_workspace_mutex;
> > > > -     void *crush_workspace;
> > > > +     struct workspace_manager crush_wsm;
> > > >  };
> > > >
> > > >  static inline bool ceph_osd_exists(struct ceph_osdmap *map, int osd)
> > > > diff --git a/include/linux/crush/crush.h b/include/linux/crush/crush.h
> > > > index 2f811baf78d2..30dba392b730 100644
> > > > --- a/include/linux/crush/crush.h
> > > > +++ b/include/linux/crush/crush.h
> > > > @@ -346,6 +346,9 @@ struct crush_work_bucket {
> > > >
> > > >  struct crush_work {
> > > >       struct crush_work_bucket **work; /* Per-bucket working store */
> > > > +#ifdef __KERNEL__
> > > > +     struct list_head item;
> > > > +#endif
> > > >  };
> > > >
> > > >  #ifdef __KERNEL__
> > > > diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> > > > index 96c25f5e064a..fa08c15be0c0 100644
> > > > --- a/net/ceph/osdmap.c
> > > > +++ b/net/ceph/osdmap.c
> > > > @@ -964,6 +964,143 @@ static int decode_pool_names(void **p, void *end, struct ceph_osdmap *map)
> > > >       return -EINVAL;
> > > >  }
> > > >
> > > > +/*
> > > > + * CRUSH workspaces
> > > > + *
> > > > + * workspace_manager framework borrowed from fs/btrfs/compression.c.
> > > > + * Two simplifications: there is only one type of workspace and there
> > > > + * is always at least one workspace.
> > > > + */
> > > > +static struct crush_work *alloc_workspace(const struct crush_map *c)
> > > > +{
> > > > +     struct crush_work *work;
> > > > +     size_t work_size;
> > > > +
> > > > +     WARN_ON(!c->working_size);
> > > > +     work_size = crush_work_size(c, CEPH_PG_MAX_SIZE);
> > > > +     dout("%s work_size %zu bytes\n", __func__, work_size);
> > > > +
> > > > +     work = ceph_kvmalloc(work_size, GFP_NOIO);
> > > > +     if (!work)
> > > > +             return NULL;
> > > > +
> > >
> > > In general, how big are these allocations? They're all uniform so you
> > > could make a dedicated slabcache for this. Granted you'll only have one
> > > a max of per cpu, but some boxes have a lot of CPUs these days.
> >
> > Hi Jeff,
> >
> > They are going to vary in size from CRUSH map to CRUSH map and need
> > a vmalloc fallback, so a dedicated cache wouldn't work.
> >
>
> Got it. Ok.
>
> > > > +     INIT_LIST_HEAD(&work->item);
> > > > +     crush_init_workspace(c, work);
> > > > +     return work;
> > > > +}
> > > > +
> > > > +static void free_workspace(struct crush_work *work)
> > > > +{
> > > > +     WARN_ON(!list_empty(&work->item));
> > > > +     kvfree(work);
> > > > +}
> > > > +
> > > > +static void init_workspace_manager(struct workspace_manager *wsm)
> > > > +{
> > > > +     INIT_LIST_HEAD(&wsm->idle_ws);
> > > > +     spin_lock_init(&wsm->ws_lock);
> > > > +     atomic_set(&wsm->total_ws, 0);
> > > > +     wsm->free_ws = 0;
> > > > +     init_waitqueue_head(&wsm->ws_wait);
> > > > +}
> > > > +
> > > > +static void add_initial_workspace(struct workspace_manager *wsm,
> > > > +                               struct crush_work *work)
> > > > +{
> > > > +     WARN_ON(!list_empty(&wsm->idle_ws));
> > > > +
> > > > +     list_add(&work->item, &wsm->idle_ws);
> > > > +     atomic_set(&wsm->total_ws, 1);
> > > > +     wsm->free_ws = 1;
> > > > +}
> > > > +
> > > > +static void cleanup_workspace_manager(struct workspace_manager *wsm)
> > > > +{
> > > > +     struct crush_work *work;
> > > > +
> > > > +     while (!list_empty(&wsm->idle_ws)) {
> > > > +             work = list_first_entry(&wsm->idle_ws, struct crush_work,
> > > > +                                     item);
> > > > +             list_del_init(&work->item);
> > > > +             free_workspace(work);
> > > > +     }
> > > > +     atomic_set(&wsm->total_ws, 0);
> > > > +     wsm->free_ws = 0;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Finds an available workspace or allocates a new one.  If it's not
> > > > + * possible to allocate a new one, waits until there is one.
> > > > + */
> > > > +static struct crush_work *get_workspace(struct workspace_manager *wsm,
> > > > +                                     const struct crush_map *c)
> > > > +{
> > > > +     struct crush_work *work;
> > > > +     int cpus = num_online_cpus();
> > > > +
> > > > +again:
> > > > +     spin_lock(&wsm->ws_lock);
> > > > +     if (!list_empty(&wsm->idle_ws)) {
> > > > +             work = list_first_entry(&wsm->idle_ws, struct crush_work,
> > > > +                                     item);
> > > > +             list_del_init(&work->item);
> > > > +             wsm->free_ws--;
> > > > +             spin_unlock(&wsm->ws_lock);
> > > > +             return work;
> > > > +
> > > > +     }
> > > > +     if (atomic_read(&wsm->total_ws) > cpus) {
> > > > +             DEFINE_WAIT(wait);
> > > > +
> > > > +             spin_unlock(&wsm->ws_lock);
> > > > +             prepare_to_wait(&wsm->ws_wait, &wait, TASK_UNINTERRUPTIBLE);
> > > > +             if (atomic_read(&wsm->total_ws) > cpus && !wsm->free_ws)
> > > > +                     schedule();
> > > > +             finish_wait(&wsm->ws_wait, &wait);
> > > > +             goto again;
> > > > +     }
> > > > +     atomic_inc(&wsm->total_ws);
> > > > +     spin_unlock(&wsm->ws_lock);
> > > > +
> > > > +     work = alloc_workspace(c);
> > > > +     if (!work) {
> > > > +             atomic_dec(&wsm->total_ws);
> > > > +             wake_up(&wsm->ws_wait);
> > > > +
> > > > +             /*
> > > > +              * Do not return the error but go back to waiting.  We
> > > > +              * have the inital workspace and the CRUSH computation
> > > > +              * time is bounded so we will get it eventually.
> > > > +              */
> > > > +             WARN_ON(atomic_read(&wsm->total_ws) < 1);
> > > > +             goto again;
> > > > +     }
> > > > +     return work;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Puts a workspace back on the list or frees it if we have enough
> > > > + * idle ones sitting around.
> > > > + */
> > > > +static void put_workspace(struct workspace_manager *wsm,
> > > > +                       struct crush_work *work)
> > > > +{
> > > > +     spin_lock(&wsm->ws_lock);
> > > > +     if (wsm->free_ws <= num_online_cpus()) {
> > > > +             list_add(&work->item, &wsm->idle_ws);
> > > > +             wsm->free_ws++;
> > > > +             spin_unlock(&wsm->ws_lock);
> > > > +             goto wake;
> > > > +     }
> > > > +     spin_unlock(&wsm->ws_lock);
> > > > +
> > > > +     free_workspace(work);
> > > > +     atomic_dec(&wsm->total_ws);
> > > > +wake:
> > > > +     if (wq_has_sleeper(&wsm->ws_wait))
> > > > +             wake_up(&wsm->ws_wait);
> > >
> > > Is this racy? Could you end up missing a wakeup because something began
> > > waiting between the check and wake_up? This is not being checked under
> > > any sort of lock, so you could end up preempted between the two.
> > >
> > > It might be better to just unconditionally call wake_up. In principle,
> > > that should be a no-op if there is nothing waiting.
> >
> > Yeah, it raised my eyebrows as well (and !wsm->free_ws test without
> > a lock in get_workspace() too).  This is a straight up cut-and-paste
> > from Btrfs through, so I decided to leave it as is.  This is pretty
> > old code and it survived there for over ten years, although I'm not
> > sure how many people actually enable compression in the field.
> >
> > If we hit issues, I'd just reimplement the whole thing from scratch
> > rather than attempting to tweak a cut-and-paste that is not entirely
> > straightforward.
>
> Yeah, the free_ws handling looks quite suspicious. At least total_ws is
> atomic...

Yeah, and if not for this suspicious test, free_ws wouldn't be
needed at all.

>
> In practice, I often find that problems like this only become evident
> when you start running on more exotic arches with different caching
> behavior. Hopefully it won't be an issue, but if it ever is it'll
> probably be quite hard to reproduce without some sort of fault
> injection.

I figured that if we ever encounter a hang in get_workspace(),
it would be obvious and wouldn't need reproducing.  Perhaps we
shouldn't wait for that to happen and redo this now, dunno...

Thanks,

                Ilya
