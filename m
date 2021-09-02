Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF273FF084
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbhIBPxX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 11:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbhIBPxW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 11:53:22 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBCCC061575
        for <ceph-devel@vger.kernel.org>; Thu,  2 Sep 2021 08:52:24 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n24so3059186ion.10
        for <ceph-devel@vger.kernel.org>; Thu, 02 Sep 2021 08:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wxNZS6jaKDKEhalF0FXbn91bDAOwW5Mok0Og6z4ZSSw=;
        b=dPuUHBImn+LDZkqlRZxkUAugQYmDmKEzpNogbhYE91Zvfj1f3d28woEXX5KhtpkXDH
         Zu5V4xnxROVMwvRNwGthAyqYf7v5ua6J1F8ZRwExdCq1ns3i2fpx7qG1AUWxzVpMk9Mi
         sJtdb298MSDaklVazkhtbSiz7AhBd0spfvb2bvQLS2C4b9mhKCr7S0Kg3G9Kgn1Ddrod
         6AABR2ui6l4/KR3F0vzvEhDE1CECbbVqoCsGBMwXgcSY/1P8JmqrGZ56Y9mGPNZQWtTq
         Cq40RwqHRYQaZWIoJP1LThgj+7VpLn2kib0E3dIwN2RRquwp2s4AWFXM2YDaNL81wAGt
         Nzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wxNZS6jaKDKEhalF0FXbn91bDAOwW5Mok0Og6z4ZSSw=;
        b=dg7Ny5GPjIcOGF9HoyYsAcgbQ9osjbILXKPYKzDeHxA1F0eq5WJKAblOCTt1C/21zz
         OJru7Kkgw3w2NdZCDsN0gKK/8rlxUDwrdZXILZDfX4oMtY/5+cVB9UjnQNau4fK7LBUV
         JzrWD7G3UBTQKtR7o4bTkPZxwzRsqjLJlCCSs1P4EiqjhKGGmJpxcM1/GC7mOBmx0WMe
         469+YxQZPiye7jBOsNG1TttCCRfkrYkfwq4lTcBvfUxQrOKcRTmWi2ZtZScmFwFBZey3
         nL7sD7gqyTvrhLw8KeZjuKDaimSCyXFYIgv0Lc6X3n6hcKHre50WSl0HeDzkR8j1RC5K
         9kwQ==
X-Gm-Message-State: AOAM530gdScX2LAKIFWwj65nZBeIEec11PkZOce9ouhI/t5jyyo/33ox
        Ip1d5Gi/vmYT5GBc5AX2OlFJaSN/Shdgy5w4exJS1+eFSE3xvQ==
X-Google-Smtp-Source: ABdhPJxI96jiYPFm52HaoqF7l9tsun6P6malrtwh1ZO2uhTcqZ7QGfficStoyiy284SnRnblVNDr+xwg+p7dzpmR6t4=
X-Received: by 2002:a5d:9304:: with SMTP id l4mr3359574ion.167.1630597943769;
 Thu, 02 Sep 2021 08:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210809164410.27750-1-jlayton@kernel.org> <6aeae1ddabffc701e1b039e99464c116c682a3fa.camel@kernel.org>
In-Reply-To: <6aeae1ddabffc701e1b039e99464c116c682a3fa.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 2 Sep 2021 17:52:00 +0200
Message-ID: <CAOi1vP_NutCKZHyR_mYkN9p282JAuz+qkdnhMeYgRji_OuQ6VQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: enable async dirops by default
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 1, 2021 at 6:54 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2021-08-09 at 12:44 -0400, Jeff Layton wrote:
> > Async dirops have been supported in mainline kernels for quite some time
> > now, and we've recently (as of June) started doing regular testing in
> > teuthology with '-o nowsync'. So far, that hasn't uncovered any issues,
> > so I think the time is right to flip the default for this option.
> >
> > Enable async dirops by default, and change /proc/mounts to show "wsync"
> > when they are disabled rather than "nowsync" when they are enabled.
> >
> > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/super.c | 4 ++--
> >  fs/ceph/super.h | 3 ++-
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 609ffc8c2d78..f517ad9eeb26 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -698,8 +698,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> >       if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> >               seq_show_option(m, "recover_session", "clean");
> >
> > -     if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > -             seq_puts(m, ",nowsync");
> > +     if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
> > +             seq_puts(m, ",wsync");
> >
> >       if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
> >               seq_printf(m, ",wsize=%u", fsopt->wsize);
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 389b45ac291b..0bc36cf4c683 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -48,7 +48,8 @@
> >
> >  #define CEPH_MOUNT_OPT_DEFAULT                       \
> >       (CEPH_MOUNT_OPT_DCACHE |                \
> > -      CEPH_MOUNT_OPT_NOCOPYFROM)
> > +      CEPH_MOUNT_OPT_NOCOPYFROM |            \
> > +      CEPH_MOUNT_OPT_ASYNC_DIROPS)
> >
> >  #define ceph_set_mount_opt(fsc, opt) \
> >       (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
>
> I think we ought to wait to merge this into mainline just yet, but I'd
> like to leave it in the "testing" branch for now.
>
> I've been working this bug with Patrick for the last month or two:
>
>     https://tracker.ceph.com/issues/51279
>
> In at least one case, the problem seems to be that the MDS failed an
> async create with an ENOSPC error. The kclient's error handling around
> this is pretty non-existent right now, so it caused an unmount to hang.
>
> It's a pity we still don't have revoke()...
>
> I've started working on a series to clean this up, but in the meantime I
> think we ought to wait until that's in place before we make nowsync the
> default.
>
> Sound ok?

Yeah, I don't see any rush to make it the default especially given that
it hasn't been on in testing that long.

Thanks,

                Ilya
