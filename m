Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D4731D3FE
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Feb 2021 03:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhBQCns (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Feb 2021 21:43:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229480AbhBQCns (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Feb 2021 21:43:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613529741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xtoBrI8mZMBgjwlbe5bmMzFULP2d1A4vT95wG+ETeFU=;
        b=X83AmZqntEubW+YbZu9I6OtSa54/YYsdlTLTRm1ihRRSQczxZcJhoBZ34IcnpI27Q+tHFL
        FxLmP2GIFJRNCNVQEzcYCU0qnz92zkheCTSaM7j43JiNlp03lFoKBN3b/Agm187QeWf0os
        OLJLMJHHSQdMNqh4vNsiz9q0cdMo5Lo=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-DucjK2PnOO62zVmzj00n0A-1; Tue, 16 Feb 2021 21:42:18 -0500
X-MC-Unique: DucjK2PnOO62zVmzj00n0A-1
Received: by mail-il1-f199.google.com with SMTP id z16so9289393ilz.22
        for <ceph-devel@vger.kernel.org>; Tue, 16 Feb 2021 18:42:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xtoBrI8mZMBgjwlbe5bmMzFULP2d1A4vT95wG+ETeFU=;
        b=rUZtV8nWbOG5/YWcTLYAxoICQt1c+GmSoP1fqyWbScbAkUqHbOoTn3cOq/dhcaYj3S
         latVY19mJpvVa5eYSpdya1ZBDNJAKnqK2Fbh+uQwwGDUm02oG1RHX7XiHTJsp6aM98UZ
         /SSbotb4oNz2pey5nT0RZnEdbvAR14UQ23FvAg6/+Y9gYkEowpEriWroKZp01YUMJvls
         hbx7nO9xf0VD6pSQY+qkRkDVeO/GLEqhnpwzVmLurAy1wrWwhZZGSb/iW9jQkDf15g/s
         02BaUKjVVxrY3FnfnBnadLjUxAEOwnFKmejd9tA8bK3G5uEMivKCa1TtKu9pde9QnEui
         VrVg==
X-Gm-Message-State: AOAM533YE3wwmOQ4dzR7ByGctnoCk38fONcZj4im6VYNuzYdTKJEK0RJ
        DNVPZegh8l0ilEK5+I54EoRD6YvBBN3lYTtR3zCWjB67BEo2PXYj/BYrHO1WgXwm0v5X8/h/nlJ
        ZTyliJG0P4i8S90aW7d70Of6crW3dHmLy7gPuEw==
X-Received: by 2002:a6b:144c:: with SMTP id 73mr19232862iou.69.1613529737595;
        Tue, 16 Feb 2021 18:42:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyYHc9oHFSOn4la9GUWQpNQr7vA8ygqkGeHqluzP5jkgJswUM7z6N+vqOfmPHP9BNi+W5YbQmjtCJ3OXi6Mbr4=
X-Received: by 2002:a6b:144c:: with SMTP id 73mr19232852iou.69.1613529737407;
 Tue, 16 Feb 2021 18:42:17 -0800 (PST)
MIME-Version: 1.0
References: <20210119144430.337370-1-jlayton@kernel.org> <CAOi1vP-1_4eHzAKS3BP6_fL6=BgV1NCYy6-+0e+gyhC0ZnUTVw@mail.gmail.com>
 <abc7c5b147e3a6c50dcc2c00b4b39d04d555c66a.camel@kernel.org> <CAOi1vP_rAzr7GdD_C=X5qjq26eo34BqewC0YgTd_JLjNXOsZPQ@mail.gmail.com>
In-Reply-To: <CAOi1vP_rAzr7GdD_C=X5qjq26eo34BqewC0YgTd_JLjNXOsZPQ@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 16 Feb 2021 18:41:51 -0800
Message-ID: <CA+2bHPYRzmJ=LVPa+vv8rcN+aLbbBQr4J1r_kEw8XZjyE52RmQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: enable async dirops by default
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 20, 2021 at 4:24 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Wed, Jan 20, 2021 at 1:00 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > On Wed, 2021-01-20 at 11:46 +0100, Ilya Dryomov wrote:
> > > On Tue, Jan 19, 2021 at 4:06 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > >
> > > > This has been behaving reasonably well in testing, and enabling this
> > > > offers significant performance benefits. Enable async dirops by default
> > > > in the kclient going forward, and change show_options to add "wsync"
> > > > when they are disabled.
> > > >
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/super.c | 4 ++--
> > > >  fs/ceph/super.h | 5 +++--
> > > >  2 files changed, 5 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index 9b1b7f4cfdd4..884e2ffabfaf 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -577,8 +577,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> > > >         if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> > > >                 seq_show_option(m, "recover_session", "clean");
> > > >
> > > > -       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > > > -               seq_puts(m, ",nowsync");
> > > > +       if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
> > > > +               seq_puts(m, ",wsync");
> > > >
> > > >         if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
> > > >                 seq_printf(m, ",wsize=%u", fsopt->wsize);
> > > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > > index 13b02887b085..8ee2745f6257 100644
> > > > --- a/fs/ceph/super.h
> > > > +++ b/fs/ceph/super.h
> > > > @@ -46,8 +46,9 @@
> > > >  #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
> > > >
> > > >  #define CEPH_MOUNT_OPT_DEFAULT                 \
> > > > -       (CEPH_MOUNT_OPT_DCACHE |                \
> > > > -        CEPH_MOUNT_OPT_NOCOPYFROM)
> > > > +       (CEPH_MOUNT_OPT_DCACHE          |       \
> > > > +        CEPH_MOUNT_OPT_NOCOPYFROM      |       \
> > > > +        CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > > >
> > > >  #define ceph_set_mount_opt(fsc, opt) \
> > > >         (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
> > > > --
> > > > 2.29.2
> > > >
> > >
> > > Hi Jeff,
> > >
> > > Is it being tested by teuthology?   I see commit 4181742a3ba8 ("qa:
> > > allow arbitrary mount options on kclient mounts"), but nothing beyond
> > > that.  I think "nowsync" needs to be turned on and get at least some
> > > nightly coverage before the default is flipped.
> > >
> > > Thanks,
> > >
> > >                 Ilya
> >
> > Good point. I had thought Patrick had added a qa variant that turned
> > that on, but I don't think that ever got merged. We definitely need that
> > enabled in QA before we make this the default.
> >
> > The catch is that we probably don't _always_ want nowsync enabled, so is
> > there some way to randomize this? Or do we need some sort of yaml file
> > that turns this on by request? What should we be aiming to do for this?
>
> It can be randomized, you can choose to run a particular set of
> jobs with both wsync and nowsync and the rest only with wsync or the
> other way around, etc.  Completely up to you, depending on the sort
> of coverage you want to get (weighted by the number of jobs added to
> the suite).

I wrote up a quick PR for this: https://github.com/ceph/ceph/pull/39505

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

