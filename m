Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9C21DCCB3
	for <lists+ceph-devel@lfdr.de>; Thu, 21 May 2020 14:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgEUMTU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 May 2020 08:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgEUMTT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 May 2020 08:19:19 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE65C061A0E;
        Thu, 21 May 2020 05:19:19 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a14so6862920ilk.2;
        Thu, 21 May 2020 05:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/Rr5RVdjxzrGPFl/sDcimE370KmUwCtLyFyo9wrTbU=;
        b=NnNaSH3/iMWlIU9cmWCbfaDtDO3ug/Gb5CJN5Pu7OwqJPHM45tAgw7uzPVPxlQrgvB
         grMPGL5AHhrGbIzWAo8sOACnC7eoYVAntgyG6/3RR6g+ajeWv4jdZzLF/+xLPI+MkaTq
         5PzWtF/KWbzgkYFqdBnco1Z2XBQNEw4LQJPNMLAbB0TvVigzisGGiWzG7Y0O+JkHD39f
         lI8bsjM8eO19jdQ943Z30iDvzbYIyFHWxC9Xu4nFs/2Lwmu3cAB91NfiMCYPtgPF1MFJ
         t8Rg3WHc/kBkd4aKaqlkbnx9UpVVGxrelM94QoT7Fv5DCxfRc33XkcH45dbj0/gmYEfz
         9rZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/Rr5RVdjxzrGPFl/sDcimE370KmUwCtLyFyo9wrTbU=;
        b=Ms2siSHvC49mDeZZzrgdvsP7+GuQridHh2pH62+sqsH2F/yhutor+NZBHYHgH/B635
         q27m3V8twG0eg3TN68C6glo4UMmhbEBoAIGF7/1ddNe1F0GhrDhw3EIioI2NSsv8hajz
         adKh23OH1Oa5GEBjT36EylC/W8rAzrkG1cGexX9E7Qn11fxmIOghRxECtpt93pQ2Lres
         EhnaE6ckCF4gVe62DujlMUWfRMxyz/W0yO0iR4dBXx7GBdCiz3iEMF9Dva/8NO3+ASzA
         WTpJEs7Zkhwwz5B6v0usNzAI1YMbqoYh4fPPNPy2OkwTszR0KHxet8DBLMcZPXc/LSSx
         DqDA==
X-Gm-Message-State: AOAM533NMV9YnNfcUaPq3MnABK5nW2h7SIcXeSWa6Y2g5OBe9nT9GIgE
        e8MPt3vk8uNWdTXu4VcMZYle0pnXdHFSsT+f2fWnVnQm
X-Google-Smtp-Source: ABdhPJxqgYs3SQCMfjteEQflZWWHKNQ+WqwhyPpBL3128oJJluMXxp/LO4vAR/LJRQTsMSkCksxVP0VquZMd3FGD9n4=
X-Received: by 2002:a92:7ec2:: with SMTP id q63mr8243739ill.20.1590063558318;
 Thu, 21 May 2020 05:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200521093845.15101-1-gmayyyha@gmail.com> <cad949df361b68a1c929f9053bce34d1892c8291.camel@kernel.org>
In-Reply-To: <cad949df361b68a1c929f9053bce34d1892c8291.camel@kernel.org>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Thu, 21 May 2020 20:19:06 +0800
Message-ID: <CAB9OAC0ry=tuYa-uWjGbnPGEpDCaQYhmN7bJFYvkZ1Uszo=Xpw@mail.gmail.com>
Subject: Re: [PATCH] ceph: show max caps in debugfs caps file
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 21, 2020 at 7:09 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2020-05-21 at 17:38 +0800, Yanhu Cao wrote:
> >         before
> >         ------
> >         total           1026
> >         avail           1024
> >         used            2
> >         reserved        0
> >         min             1024
> >
> >         after
> >         ------
> >         total           1026
> >         avail           1024
> >         used            2
> >         max             2048
> >         reserved        0
> >         min             1024
> >
> > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > ---
> >  fs/ceph/caps.c    | 6 ++++--
> >  fs/ceph/debugfs.c | 7 ++++---
> >  fs/ceph/super.h   | 2 +-
> >  3 files changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 5f3aa4d607de..e2c759a2ef35 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -404,8 +404,8 @@ void ceph_put_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap)
> >  }
> >
> >  void ceph_reservation_status(struct ceph_fs_client *fsc,
> > -                          int *total, int *avail, int *used, int *reserved,
> > -                          int *min)
> > +                          int *total, int *avail, int *used, int *max,
> > +                          int *reserved, int *min)
> >  {
> >       struct ceph_mds_client *mdsc = fsc->mdsc;
> >
> > @@ -417,6 +417,8 @@ void ceph_reservation_status(struct ceph_fs_client *fsc,
> >               *avail = mdsc->caps_avail_count;
> >       if (used)
> >               *used = mdsc->caps_use_count;
> > +     if (max)
> > +             *max = mdsc->caps_use_max;
>
> Can you lay out what value this will provide? I'm not convinced that
> this information is really that helpful:
>
> mdsc->caps_use_max is just set to the value of the "caps_max" mount
> option, and that information is displayed in /proc/mounts if it's not
> set to the default.
>
> What might be more interesting is to track the most recent "max_caps"
> value sent by the MDS (see the CEPH_SESSION_RECALL_STATE message
> handling). Tracking that would give us a more dynamic view of the
> current maximum requested by the MDS, which is often going to be less
> than what "caps_max" was set to at mount time.

Do you mean the 'mds_recall_max_caps'? which can be set by the MDS.
Clients use this value every time to trim caps.

There is an option mds_max_caps_per_client which is a soft limit,
which is determined by the behavior of the client.
and we recently encounter a warning '1 MDSs report oversized
cache'(ceph-v12.2.12: mds_cache_memory_limit=64G, used=100G),
Therefore, the effect is not good.

So we want to know whether the caps held by the client exceed caps_max
through the debugfs caps file (default or mount option).


>
> >       if (reserved)
> >               *reserved = mdsc->caps_reserve_count;
> >       if (min)
> > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > index 481ac97b4d25..942004376588 100644
> > --- a/fs/ceph/debugfs.c
> > +++ b/fs/ceph/debugfs.c
> > @@ -138,16 +138,17 @@ static int caps_show(struct seq_file *s, void *p)
> >  {
> >       struct ceph_fs_client *fsc = s->private;
> >       struct ceph_mds_client *mdsc = fsc->mdsc;
> > -     int total, avail, used, reserved, min, i;
> > +     int total, avail, used, max, reserved, min, i;
> >       struct cap_wait *cw;
> >
> > -     ceph_reservation_status(fsc, &total, &avail, &used, &reserved, &min);
> > +     ceph_reservation_status(fsc, &total, &avail, &used, &max,
> > +                             &reserved, &min);
> >       seq_printf(s, "total\t\t%d\n"
> >                  "avail\t\t%d\n"
> >                  "used\t\t%d\n"
> >                  "reserved\t%d\n"
> >                  "min\t\t%d\n\n",
> > -                total, avail, used, reserved, min);
> > +                total, avail, used, max, reserved, min);
> >       seq_printf(s, "ino                issued           implemented\n");
> >       seq_printf(s, "-----------------------------------------------\n");
> >
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 60aac3aee055..79aa42d9336c 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -700,7 +700,7 @@ extern void ceph_unreserve_caps(struct ceph_mds_client *mdsc,
> >                              struct ceph_cap_reservation *ctx);
> >  extern void ceph_reservation_status(struct ceph_fs_client *client,
> >                                   int *total, int *avail, int *used,
> > -                                 int *reserved, int *min);
> > +                                 int *max, int *reserved, int *min);
> >
> >
> >
>
> --
> Jeff Layton <jlayton@kernel.org>
>
