Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E731DE552
	for <lists+ceph-devel@lfdr.de>; Fri, 22 May 2020 13:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgEVL0s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 May 2020 07:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbgEVL0s (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 22 May 2020 07:26:48 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9649206BE;
        Fri, 22 May 2020 11:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590146807;
        bh=HffsPUQV72xCQs16Zb0KzhZezC5HpjM92iOzJX/rQuY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qQbEm9ryVan7BjBF+/jjM9T2zy6S1jtAG5Gjhwxv3k4lAah88e1xbExs/ozNf7APm
         UcrqlrHUD8AvfIUbKoOLaZzq1TtG/M2Z1Tf8RkNsedvPPK/D9Uo29bXF/Jppza2Vti
         y2Ari/wR2C3dtcT83vBwhmfuiY+6h+bT9YCTVMDA=
Message-ID: <29349a65bc94651a96d2e4a8392e1ca4a00bd2d7.camel@kernel.org>
Subject: Re: [PATCH] ceph: show max caps in debugfs caps file
From:   Jeff Layton <jlayton@kernel.org>
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Fri, 22 May 2020 07:26:45 -0400
In-Reply-To: <CAB9OAC2yxtAciWmJzVSga-pu3ZUjjmsctfj+pQQTr78-W_cfuA@mail.gmail.com>
References: <20200521093845.15101-1-gmayyyha@gmail.com>
         <cad949df361b68a1c929f9053bce34d1892c8291.camel@kernel.org>
         <CAB9OAC0ry=tuYa-uWjGbnPGEpDCaQYhmN7bJFYvkZ1Uszo=Xpw@mail.gmail.com>
         <d1e221be16e220009f1ca55d4b1eb6728462a279.camel@kernel.org>
         <CAB9OAC2yxtAciWmJzVSga-pu3ZUjjmsctfj+pQQTr78-W_cfuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-05-22 at 16:27 +0800, Yanhu Cao wrote:
> On Thu, May 21, 2020 at 8:51 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Thu, 2020-05-21 at 20:19 +0800, Yanhu Cao wrote:
> > > On Thu, May 21, 2020 at 7:09 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > On Thu, 2020-05-21 at 17:38 +0800, Yanhu Cao wrote:
> > > > >         before
> > > > >         ------
> > > > >         total           1026
> > > > >         avail           1024
> > > > >         used            2
> > > > >         reserved        0
> > > > >         min             1024
> > > > > 
> > > > >         after
> > > > >         ------
> > > > >         total           1026
> > > > >         avail           1024
> > > > >         used            2
> > > > >         max             2048
> > > > >         reserved        0
> > > > >         min             1024
> > > > > 
> > > > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > > > ---
> > > > >  fs/ceph/caps.c    | 6 ++++--
> > > > >  fs/ceph/debugfs.c | 7 ++++---
> > > > >  fs/ceph/super.h   | 2 +-
> > > > >  3 files changed, 9 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > > index 5f3aa4d607de..e2c759a2ef35 100644
> > > > > --- a/fs/ceph/caps.c
> > > > > +++ b/fs/ceph/caps.c
> > > > > @@ -404,8 +404,8 @@ void ceph_put_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap)
> > > > >  }
> > > > > 
> > > > >  void ceph_reservation_status(struct ceph_fs_client *fsc,
> > > > > -                          int *total, int *avail, int *used, int *reserved,
> > > > > -                          int *min)
> > > > > +                          int *total, int *avail, int *used, int *max,
> > > > > +                          int *reserved, int *min)
> > > > >  {
> > > > >       struct ceph_mds_client *mdsc = fsc->mdsc;
> > > > > 
> > > > > @@ -417,6 +417,8 @@ void ceph_reservation_status(struct ceph_fs_client *fsc,
> > > > >               *avail = mdsc->caps_avail_count;
> > > > >       if (used)
> > > > >               *used = mdsc->caps_use_count;
> > > > > +     if (max)
> > > > > +             *max = mdsc->caps_use_max;
> > > > 
> > > > Can you lay out what value this will provide? I'm not convinced that
> > > > this information is really that helpful:
> > > > 
> > > > mdsc->caps_use_max is just set to the value of the "caps_max" mount
> > > > option, and that information is displayed in /proc/mounts if it's not
> > > > set to the default.
> > > > 
> > > > What might be more interesting is to track the most recent "max_caps"
> > > > value sent by the MDS (see the CEPH_SESSION_RECALL_STATE message
> > > > handling). Tracking that would give us a more dynamic view of the
> > > > current maximum requested by the MDS, which is often going to be less
> > > > than what "caps_max" was set to at mount time.
> > > 
> > > Do you mean the 'mds_recall_max_caps'? which can be set by the MDS.
> > > Clients use this value every time to trim caps.
> > > 
> > > There is an option mds_max_caps_per_client which is a soft limit,
> > > which is determined by the behavior of the client.
> > > and we recently encounter a warning '1 MDSs report oversized
> > > cache'(ceph-v12.2.12: mds_cache_memory_limit=64G, used=100G),
> > > Therefore, the effect is not good.
> > > 
> > > So we want to know whether the caps held by the client exceed caps_max
> > > through the debugfs caps file (default or mount option).
> > > 
> > > 
> > 
> > Ok, I doubt this patch is going to tell you what you want to know then.
> > There are two limits involved here:
> > 
> > 1/ the limit set by the caps_max mount option for the client
> > 2/ a dynamic limit that is managed by the MDS issuing
> >    CEPH_SESSION_RECALL_STATE messages to the clients (max_caps).
> > 
> > This patch is only going to tell you about the first one, but the second
> > one is more interesting to monitor on a long-term basis.
> > 
> > When the mds exceeds its memory limits, it can issue
> > CEPH_SESSION_RECALL_STATE messages to the clients, to tell them to
> > reduce their own caches to a particular size. Currently we just take
> > that value and feed it into ceph_trim_caps and forget about it.
> > 
> > It would probably be useful though to keep track of the most recent
> > value issued by the MDS, and print this value as min(mount_option_max,
> > max_caps_from_mds). Bonus points if you can help untangle the confusing
> > naming of all these values in the process.
> 
> How about this? Add a new field caps_limit(calculated by
> session->caps, mds_recall_max_caps,
> mds_max_caps_per_client, mds_min_caps_per_client) in ceph_mds_client,
> which can be set by ceph_trim_caps.
> 
> struct ceph_mds_client {
> ...
> -       int             caps_use_max;        /* max used caps */
> +      int             caps_use_max;        /* max used caps, limited
> by client */
> +      int             caps_limit;                /* limited by mds */
> ...
> }
> 
> int ceph_trim_caps(...)
> {
>         int trim_caps = session->s_nr_caps - max_caps;
> +      mdsc->caps_limit = max_caps;
>    ...
> }
> 
> if client's caps have no limit, we can track caps_limit.
> Don't use min(caps_use_max, caps_limit) because it shows more clearly
> whether it is limited by the client or mds.
> 
> e.g.
> ----
> total 3112
> avail 1025
> used 2087
> limit 2068   => caps_limit
> max 2048   => caps_use_max(mount_option_caps_max)
> 
> trimmed
> -------
> total 1943
> avail 1025
> used 918
> limit 918
> max 2048
> 
> 

Sure, that'd be fine. The "max" is somewhat redundant info that you can
get elsewhere, but printing it here won't hurt anything.

> > > > >       if (reserved)
> > > > >               *reserved = mdsc->caps_reserve_count;
> > > > >       if (min)
> > > > > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > > > > index 481ac97b4d25..942004376588 100644
> > > > > --- a/fs/ceph/debugfs.c
> > > > > +++ b/fs/ceph/debugfs.c
> > > > > @@ -138,16 +138,17 @@ static int caps_show(struct seq_file *s, void *p)
> > > > >  {
> > > > >       struct ceph_fs_client *fsc = s->private;
> > > > >       struct ceph_mds_client *mdsc = fsc->mdsc;
> > > > > -     int total, avail, used, reserved, min, i;
> > > > > +     int total, avail, used, max, reserved, min, i;
> > > > >       struct cap_wait *cw;
> > > > > 
> > > > > -     ceph_reservation_status(fsc, &total, &avail, &used, &reserved, &min);
> > > > > +     ceph_reservation_status(fsc, &total, &avail, &used, &max,
> > > > > +                             &reserved, &min);
> > > > >       seq_printf(s, "total\t\t%d\n"
> > > > >                  "avail\t\t%d\n"
> > > > >                  "used\t\t%d\n"
> > > > >                  "reserved\t%d\n"
> > > > >                  "min\t\t%d\n\n",
> > > > > -                total, avail, used, reserved, min);
> > > > > +                total, avail, used, max, reserved, min);
> > > > >       seq_printf(s, "ino                issued           implemented\n");
> > > > >       seq_printf(s, "-----------------------------------------------\n");
> > > > > 
> > > > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > > > index 60aac3aee055..79aa42d9336c 100644
> > > > > --- a/fs/ceph/super.h
> > > > > +++ b/fs/ceph/super.h
> > > > > @@ -700,7 +700,7 @@ extern void ceph_unreserve_caps(struct ceph_mds_client *mdsc,
> > > > >                              struct ceph_cap_reservation *ctx);
> > > > >  extern void ceph_reservation_status(struct ceph_fs_client *client,
> > > > >                                   int *total, int *avail, int *used,
> > > > > -                                 int *reserved, int *min);
> > > > > +                                 int *max, int *reserved, int *min);
> > > > > 
> > > > > 
> > > > > 
> > > > 
> > > > --
> > > > Jeff Layton <jlayton@kernel.org>
> > > > 
> > 
> > --
> > Jeff Layton <jlayton@kernel.org>
> > 

-- 
Jeff Layton <jlayton@kernel.org>

