Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D9B2FD038
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 13:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbhATMhP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 07:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732337AbhATMYw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Jan 2021 07:24:52 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB409C0613CF
        for <ceph-devel@vger.kernel.org>; Wed, 20 Jan 2021 04:23:56 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id u17so46509856iow.1
        for <ceph-devel@vger.kernel.org>; Wed, 20 Jan 2021 04:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6T4MFrKVCMIP3ueSo8Td+vbgimqumwzV0GMiRtczcaU=;
        b=OdAF6ZOQFEVXyWUZ1t2KHZtAcAcScsbSXd7rBN0HQP8yHGWaS82L1nF5vhX3F3TGj6
         0OdNXX1vhARwpFx7GLsd6trRc5AokFB4uIEvz+Lmnu23FiFtOR7DWbIuPgIMcRAeJnqu
         BQt/TPNtRLlx72bHUdHiwflVbAi8nSpRzc/zT91lfNEHEZrEyB2toW5/vvCmYJNyYXU1
         Br01I4kxbgmLxuZz57eTd5K6e93uX8cZO0LsF8U+94s8C30fDoH4K6M/CDZSCvji1F9k
         WOPKKicxr6U/GnreZiKUuHDeG22rTuGf9TbN2DEztbOUF+wdC53B8KWZm484eS4rlzPx
         a24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6T4MFrKVCMIP3ueSo8Td+vbgimqumwzV0GMiRtczcaU=;
        b=kVCEcAFkIkub074UjyLqY05i3eqVV2bn88nYoeq7IwpOfW9AV0TwaH6fGRD65sm3pF
         fam9vrNzz5fPGVhWWtpps2bgzzBpc+S6SHoPN+SvT8BkjfbtX7neBEFY3/fLkxxcTZeA
         qHS5dKOzOwyFoBu2y3bv0Kv9yn2jPk+DGK+R4gb6yjTm5ekWvbJuX294JoPty9Kj5+RS
         UXWTWcNK9doNqiZ+5JNToLcjcao5LAnUBWmpByFdRx2ncBvvwTZj8PNFwZGVsadkISqZ
         YZqZwKtKYR2PFNfg9oUIVzYBl92py82KupKjDZF2O5aISNl/UFP3k1S1pO14vvhbHX+k
         ivQw==
X-Gm-Message-State: AOAM531N24Y5kvSFnMvGQ9ZKO0BNUP7o9u1Rj67SYIhlFt1wzdfMmJ4N
        lPScj2EclCfy/3Um/6Hjr1wd5WQaI5Li7IM836w=
X-Google-Smtp-Source: ABdhPJxaUjnuPme/VVRlPEq25nu+/aHyxp33BOz7rUbfJ18MKpYOhm81iMNCnQOKq2CQrwHi2dP8hhS0MhNQlGevTY0=
X-Received: by 2002:a6b:14d:: with SMTP id 74mr6616840iob.182.1611145436070;
 Wed, 20 Jan 2021 04:23:56 -0800 (PST)
MIME-Version: 1.0
References: <20210119144430.337370-1-jlayton@kernel.org> <CAOi1vP-1_4eHzAKS3BP6_fL6=BgV1NCYy6-+0e+gyhC0ZnUTVw@mail.gmail.com>
 <abc7c5b147e3a6c50dcc2c00b4b39d04d555c66a.camel@kernel.org>
In-Reply-To: <abc7c5b147e3a6c50dcc2c00b4b39d04d555c66a.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 20 Jan 2021 13:24:09 +0100
Message-ID: <CAOi1vP_rAzr7GdD_C=X5qjq26eo34BqewC0YgTd_JLjNXOsZPQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: enable async dirops by default
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 20, 2021 at 1:00 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2021-01-20 at 11:46 +0100, Ilya Dryomov wrote:
> > On Tue, Jan 19, 2021 at 4:06 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > This has been behaving reasonably well in testing, and enabling this
> > > offers significant performance benefits. Enable async dirops by default
> > > in the kclient going forward, and change show_options to add "wsync"
> > > when they are disabled.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/super.c | 4 ++--
> > >  fs/ceph/super.h | 5 +++--
> > >  2 files changed, 5 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index 9b1b7f4cfdd4..884e2ffabfaf 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -577,8 +577,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> > >         if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> > >                 seq_show_option(m, "recover_session", "clean");
> > >
> > > -       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > > -               seq_puts(m, ",nowsync");
> > > +       if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
> > > +               seq_puts(m, ",wsync");
> > >
> > >         if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
> > >                 seq_printf(m, ",wsize=%u", fsopt->wsize);
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 13b02887b085..8ee2745f6257 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -46,8 +46,9 @@
> > >  #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
> > >
> > >  #define CEPH_MOUNT_OPT_DEFAULT                 \
> > > -       (CEPH_MOUNT_OPT_DCACHE |                \
> > > -        CEPH_MOUNT_OPT_NOCOPYFROM)
> > > +       (CEPH_MOUNT_OPT_DCACHE          |       \
> > > +        CEPH_MOUNT_OPT_NOCOPYFROM      |       \
> > > +        CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > >
> > >  #define ceph_set_mount_opt(fsc, opt) \
> > >         (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
> > > --
> > > 2.29.2
> > >
> >
> > Hi Jeff,
> >
> > Is it being tested by teuthology?   I see commit 4181742a3ba8 ("qa:
> > allow arbitrary mount options on kclient mounts"), but nothing beyond
> > that.  I think "nowsync" needs to be turned on and get at least some
> > nightly coverage before the default is flipped.
> >
> > Thanks,
> >
> >                 Ilya
>
> Good point. I had thought Patrick had added a qa variant that turned
> that on, but I don't think that ever got merged. We definitely need that
> enabled in QA before we make this the default.
>
> The catch is that we probably don't _always_ want nowsync enabled, so is
> there some way to randomize this? Or do we need some sort of yaml file
> that turns this on by request? What should we be aiming to do for this?

It can be randomized, you can choose to run a particular set of
jobs with both wsync and nowsync and the rest only with wsync or the
other way around, etc.  Completely up to you, depending on the sort
of coverage you want to get (weighted by the number of jobs added to
the suite).

Thanks,

                Ilya
