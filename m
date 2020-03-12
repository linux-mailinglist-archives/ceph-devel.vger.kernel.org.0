Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF2182B7F
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Mar 2020 09:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgCLIkT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Mar 2020 04:40:19 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35038 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgCLIkS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Mar 2020 04:40:18 -0400
Received: by mail-vs1-f68.google.com with SMTP id m9so3174684vso.2;
        Thu, 12 Mar 2020 01:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QcZ2BowIj1mMaoHi3wMrHLLDZ1v/hgy/7xmi7Ci4Dsc=;
        b=D1HT3VKAqPG6bFLUnNWaDvqxxKjE8znuqxzMFvXsPD3pGdZuik3/hEnhbU02/L2ADl
         cL7P1YUss6RDwgxxLwbj0JEgr4QRVmu/cTzzx3mAXyufZ+XGAjs6n9vo6y2yblO/ol/h
         G9RT+1znCthaOL4Y8oHV0uQHe+1LHqOb1TNwHZAfYEd3AvYc+smer8FfDV7ezVHIeCRl
         BYe7+INiwtzWvZ8xbnloH42dMN1E/ALBH+EaXZp5CpO9zO2zbTV2RE1WnezYlKiT4ZVe
         plTPv64rQDY3EkbLU5hxO3C22fxI7VAxDtXDchkLGwqIGv3sJvgvFBqIeYGTViQI2/Uy
         epxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QcZ2BowIj1mMaoHi3wMrHLLDZ1v/hgy/7xmi7Ci4Dsc=;
        b=gUPkUGqFV+0CImxFu5jMjLt3aPc44ByPDN3RwMwMiJyzYCk1KJNQWbia69yHJML8mF
         8XibyC/7V18GsWnIKkHW3bA1V3+JUejuYLI+0+/DjNvQR0Tcrc0VYsJgyj7nO0D6ApC5
         DGRi4nRZL9pagX7Eg8RxfUEP1yafF2qbbVaFx5KmLVR7nMatPLmA3YaBQ6+4rcboZEqD
         qL5vZnZOiCNqofl4Z0xJTJGpFXVc1kZW1xgVzK3lsg011w2USjKO5GpueoIgOSITfLwy
         kWkInxcDwj2kI5E2t57ff6p8hOme20wpN5m9u1sPF/39++zlfZiOT4xoNs5uL5v4CKMg
         L5rg==
X-Gm-Message-State: ANhLgQ1qQKiutjsm04L13DanL7eQ0zlxF2xAth6bia4Qj1FO37wao/9T
        z4RUiICcS3WMwfCmEFPR5mDZ+z32iHGj3PEQH48Z0iGq
X-Google-Smtp-Source: ADFU+vsLYTD5Vxqa/lXMMHg3t0IXeGXaNxnkcHGdweKfRcrDq4G6yKM9B+MXoTO1Kjs0f8JpNJNWy6/HGhBQuRkpDCQ=
X-Received: by 2002:a67:24c1:: with SMTP id k184mr4601402vsk.177.1584002416920;
 Thu, 12 Mar 2020 01:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200303093327.8720-1-gmayyyha@gmail.com> <CAOi1vP8jZ2tX_dg90uZY5G8cKX2Lzyu2vrGT_Ew0gVsnK4DDMA@mail.gmail.com>
 <CAB9OAC1+OOgaLF33bSrQ3WeKZyU0qwBqUQzi9MOXwzGta_b2XA@mail.gmail.com> <CAOi1vP9ZHj7gyrjrMmA2oa+cY3ZEO+4-mdJ0HMX7zSWvi_FRTA@mail.gmail.com>
In-Reply-To: <CAOi1vP9ZHj7gyrjrMmA2oa+cY3ZEO+4-mdJ0HMX7zSWvi_FRTA@mail.gmail.com>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Thu, 12 Mar 2020 16:40:05 +0800
Message-ID: <CAB9OAC0ZQtti3R3dtxfShBTJXvmwKb_cyY9K=k1mmq3kDm_myQ@mail.gmail.com>
Subject: Re: [v2] ceph: using POOL FULL flag instead of OSDMAP FULL flag
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 11, 2020 at 9:41 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Wed, Mar 11, 2020 at 10:55 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 4:43 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Tue, Mar 3, 2020 at 10:33 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> > > >
> > > > CEPH_OSDMAP_FULL/NEARFULL has been deprecated since mimic, so it
> > > > does not work well in new versions, added POOL flags to handle it.
> > > >
> > > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > > ---
> > > >  fs/ceph/file.c                  |  9 +++++++--
> > > >  include/linux/ceph/osd_client.h |  2 ++
> > > >  include/linux/ceph/osdmap.h     |  3 ++-
> > > >  net/ceph/osd_client.c           | 23 +++++++++++++----------
> > > >  4 files changed, 24 insertions(+), 13 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index 7e0190b1f821..84ec44f9d77a 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -1482,7 +1482,9 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > >         }
> > > >
> > > >         /* FIXME: not complete since it doesn't account for being at quota */
> > > > -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> > > > +       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL) ||
> > > > +           pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > > +                                               CEPH_POOL_FLAG_FULL)) {
> > > >                 err = -ENOSPC;
> > > >                 goto out;
> > > >         }
> > > > @@ -1575,7 +1577,10 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > >         }
> > > >
> > > >         if (written >= 0) {
> > > > -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > > > +               if (ceph_osdmap_flag(&fsc->client->osdc,
> > > > +                                       CEPH_OSDMAP_NEARFULL) ||
> > > > +                   pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > > +                                       CEPH_POOL_FLAG_NEARFULL))
> > > >                         iocb->ki_flags |= IOCB_DSYNC;
> > > >                 written = generic_write_sync(iocb, written);
> > > >         }
> > > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > > index 5a62dbd3f4c2..be9007b93862 100644
> > > > --- a/include/linux/ceph/osd_client.h
> > > > +++ b/include/linux/ceph/osd_client.h
> > > > @@ -375,6 +375,8 @@ static inline bool ceph_osdmap_flag(struct ceph_osd_client *osdc, int flag)
> > > >         return osdc->osdmap->flags & flag;
> > > >  }
> > > >
> > > > +bool pool_flag(struct ceph_osd_client *osdc, s64 pool_id, int flag);
> > > > +
> > > >  extern int ceph_osdc_setup(void);
> > > >  extern void ceph_osdc_cleanup(void);
> > > >
> > > > diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
> > > > index e081b56f1c1d..88faacc11f55 100644
> > > > --- a/include/linux/ceph/osdmap.h
> > > > +++ b/include/linux/ceph/osdmap.h
> > > > @@ -36,7 +36,8 @@ int ceph_spg_compare(const struct ceph_spg *lhs, const struct ceph_spg *rhs);
> > > >
> > > >  #define CEPH_POOL_FLAG_HASHPSPOOL      (1ULL << 0) /* hash pg seed and pool id
> > > >                                                        together */
> > > > -#define CEPH_POOL_FLAG_FULL            (1ULL << 1) /* pool is full */
> > > > +#define CEPH_POOL_FLAG_FULL            (1ULL << 1)  /* pool is full */
> > > > +#define CEPH_POOL_FLAG_NEARFULL        (1ULL << 11) /* pool is nearfull */
> > > >
> > > >  struct ceph_pg_pool_info {
> > > >         struct rb_node node;
> > > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > > index b68b376d8c2f..9ad2b96c3e78 100644
> > > > --- a/net/ceph/osd_client.c
> > > > +++ b/net/ceph/osd_client.c
> > > > @@ -1447,9 +1447,9 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
> > > >                 atomic_dec(&osd->o_osdc->num_homeless);
> > > >  }
> > > >
> > > > -static bool __pool_full(struct ceph_pg_pool_info *pi)
> > > > +static bool __pool_flag(struct ceph_pg_pool_info *pi, int flag)
> > > >  {
> > > > -       return pi->flags & CEPH_POOL_FLAG_FULL;
> > > > +       return pi->flags & flag;
> > > >  }
> > > >
> > > >  static bool have_pool_full(struct ceph_osd_client *osdc)
> > > > @@ -1460,14 +1460,14 @@ static bool have_pool_full(struct ceph_osd_client *osdc)
> > > >                 struct ceph_pg_pool_info *pi =
> > > >                     rb_entry(n, struct ceph_pg_pool_info, node);
> > > >
> > > > -               if (__pool_full(pi))
> > > > +               if (__pool_flag(pi, CEPH_POOL_FLAG_FULL))
> > > >                         return true;
> > > >         }
> > > >
> > > >         return false;
> > > >  }
> > > >
> > > > -static bool pool_full(struct ceph_osd_client *osdc, s64 pool_id)
> > > > +bool pool_flag(struct ceph_osd_client *osdc, s64 pool_id, int flag)
> > > >  {
> > > >         struct ceph_pg_pool_info *pi;
> > > >
> > > > @@ -1475,8 +1475,10 @@ static bool pool_full(struct ceph_osd_client *osdc, s64 pool_id)
> > > >         if (!pi)
> > > >                 return false;
> > > >
> > > > -       return __pool_full(pi);
> > > > +       return __pool_flag(pi, flag);
> > > >  }
> > > > +EXPORT_SYMBOL(pool_flag);
> > > > +
> > > >
> > > >  /*
> > > >   * Returns whether a request should be blocked from being sent
> > > > @@ -1489,7 +1491,7 @@ static bool target_should_be_paused(struct ceph_osd_client *osdc,
> > > >         bool pauserd = ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD);
> > > >         bool pausewr = ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSEWR) ||
> > > >                        ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> > > > -                      __pool_full(pi);
> > > > +                      __pool_flag(pi, CEPH_POOL_FLAG_FULL);
> > > >
> > > >         WARN_ON(pi->id != t->target_oloc.pool);
> > > >         return ((t->flags & CEPH_OSD_FLAG_READ) && pauserd) ||
> > > > @@ -2320,7 +2322,8 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
> > > >                    !(req->r_flags & (CEPH_OSD_FLAG_FULL_TRY |
> > > >                                      CEPH_OSD_FLAG_FULL_FORCE)) &&
> > > >                    (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> > > > -                   pool_full(osdc, req->r_t.base_oloc.pool))) {
> > > > +                  pool_flag(osdc, req->r_t.base_oloc.pool,
> > > > +                            CEPH_POOL_FLAG_FULL))) {
> > > >                 dout("req %p full/pool_full\n", req);
> > > >                 if (ceph_test_opt(osdc->client, ABORT_ON_FULL)) {
> > > >                         err = -ENOSPC;
> > > > @@ -2539,7 +2542,7 @@ static int abort_on_full_fn(struct ceph_osd_request *req, void *arg)
> > > >
> > > >         if ((req->r_flags & CEPH_OSD_FLAG_WRITE) &&
> > > >             (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
> > > > -            pool_full(osdc, req->r_t.base_oloc.pool))) {
> > > > +            pool_flag(osdc, req->r_t.base_oloc.pool, CEPH_POOL_FLAG_FULL))) {
> > > >                 if (!*victims) {
> > > >                         update_epoch_barrier(osdc, osdc->osdmap->epoch);
> > > >                         *victims = true;
> > > > @@ -3707,7 +3710,7 @@ static void set_pool_was_full(struct ceph_osd_client *osdc)
> > > >                 struct ceph_pg_pool_info *pi =
> > > >                     rb_entry(n, struct ceph_pg_pool_info, node);
> > > >
> > > > -               pi->was_full = __pool_full(pi);
> > > > +               pi->was_full = __pool_flag(pi, CEPH_POOL_FLAG_FULL);
> > > >         }
> > > >  }
> > > >
> > > > @@ -3719,7 +3722,7 @@ static bool pool_cleared_full(struct ceph_osd_client *osdc, s64 pool_id)
> > > >         if (!pi)
> > > >                 return false;
> > > >
> > > > -       return pi->was_full && !__pool_full(pi);
> > > > +       return pi->was_full && !__pool_flag(pi, CEPH_POOL_FLAG_FULL);
> > > >  }
> > > >
> > > >  static enum calc_target_result
> > >
> > > Hi Yanhu,
> > >
> > > Sorry for a late reply.
> > >
> > > This adds some unnecessary churn and also exposes a helper that
> > > must be called under osdc->lock without making that obvious.  How
> > > about the attached instead?
> > >
> > > ceph_pg_pool_flags() takes osdmap instead of osdc, making it clear
> > > that the caller is resposibile for keeping the map stable.
> > >
> > > Thanks,
> > >
> > >                 Ilya
> >
> > net/ceph/osdmap.c
> > --------------------------
> > bool ceph_pg_pool_flags(struct ceph_osdmap *map, s64 pool_id, int flag)
> > {
> >         struct ceph_pg_pool_info *pi;
> >
> >         /* CEPH_OSDMAP_FULL|CEPH_OSDMAP_NEARFULL deprecated since mimic */
> >         if (flag & (CEPH_POOL_FLAG_FULL|CEPH_POOL_FLAG_NEARFULL))
> >                 if (map->flags & (CEPH_OSDMAP_FULL|CEPH_OSDMAP_NEARFULL))
> >                         return true;
> >
> >         pi = ceph_pg_pool_by_id(map, pool_id);
> >         if (!pi)
> >                 return false;
> >
> >         return pi->flags & flag;
> > }
> >
> > fs/ceph/file.c
> > -----------------
> > ceph_write_iter() {
> > ...
> >         down_read(&osdc->lock);
> >         if (ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id,
> >                                CEPH_POOL_FLAG_FULL|CEPH_POOL_FLAG_FULL_QUOTA)) {
> >                 err = -ENOSPC;
> >                 up_read(&osdc->lock);
> >                 goto out;
> >         }
> >         up_read(&osdc->lock);
> > ...
> >          down_read(&osdc->lock);
> >           if (ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id,
> >                                         CEPH_POOL_FLAG_NEARFULL))
> >               iocb->ki_flags |= IOCB_DSYNC;
> >           up_read(&osdc->lock);
> > ...
> > }
> >
> > how about this?
>
> Well, this takes osdc->lock and looks up ceph_pg_pool_info twice.
> Given that these checks are inherently racy, I think doing it once
> at the top makes more sense.

be modified as follow.

ceph_write_iter() {
...
        down_read(&osdc->lock);
        pi = ceph_pg_pool_by_id(osdc->osdmap, ci->i_layout.pool_id);
        if (!pi) {
                err = -ENOENT;
                up_read(&osdc->lock);
                goto out;
        }
        up_read(&osdc->lock);
...
}

>
> Also, I don't think this does what you intended it to do.  Your
> ceph_pg_pool_flags(..., CEPH_POOL_FLAG_FULL) returns true even if
> the map only has CEPH_OSDMAP_NEARFULL, triggering early ENOSPC.
>

Ah... my mistake. According to OSDMAP/POOL flag to do respectively.

        if (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
            ceph_pg_pool_flags(pi, CEPH_POOL_FLAG_FULL)) {
                err = -ENOSPC;
                goto out;
        }

include/linux/ceph/osdmap.h
--------------------------------------
static inline bool ceph_pg_pool_flags(struct ceph_pg_pool_info *pi,  int flag)
{
        return pi->flags & flag;
}

Thanks.
