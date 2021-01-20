Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247122FD036
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 13:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389839AbhATMgv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 07:36:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733079AbhATMMT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 07:12:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB3DD23331;
        Wed, 20 Jan 2021 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611144011;
        bh=RDxPsoOpKbei1SHNhUsnBSrA5vZnVr4GIPPTZQTqPiQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fsApc0jpZUHw6p6p0yxRqayvwb8TIRbfYJ+kETCHhqEE4s0oInC+lq0Ez6WIGDioV
         BWdJvwJ+CYrX9jP7aUUKzh3QPwy4XBRHiZEWUw/WI6ENMD7DKCUBA4bOK7+K1QE/91
         QppH14wGzl6J/9bfaW/82MII44puPZWzBmRCA65YlLKRxZdw56qVZK1JR1K83H5VkE
         buJJcuaRTPU5ApxCCmcxEWvdkxuBwXfUeN71UnEVOUVLLMkyS+esusYfn2L77gLAW6
         Cm/xfCW/9is6+nLJDuzr8J2iYb9npKHKMHlHFqTjuRK2FrsqrCVqlAFUUo3UD+YqEi
         4F7aX29LEQ34A==
Message-ID: <abc7c5b147e3a6c50dcc2c00b4b39d04d555c66a.camel@kernel.org>
Subject: Re: [PATCH] ceph: enable async dirops by default
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 20 Jan 2021 07:00:09 -0500
In-Reply-To: <CAOi1vP-1_4eHzAKS3BP6_fL6=BgV1NCYy6-+0e+gyhC0ZnUTVw@mail.gmail.com>
References: <20210119144430.337370-1-jlayton@kernel.org>
         <CAOi1vP-1_4eHzAKS3BP6_fL6=BgV1NCYy6-+0e+gyhC0ZnUTVw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-01-20 at 11:46 +0100, Ilya Dryomov wrote:
> On Tue, Jan 19, 2021 at 4:06 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > This has been behaving reasonably well in testing, and enabling this
> > offers significant performance benefits. Enable async dirops by default
> > in the kclient going forward, and change show_options to add "wsync"
> > when they are disabled.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/super.c | 4 ++--
> >  fs/ceph/super.h | 5 +++--
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 9b1b7f4cfdd4..884e2ffabfaf 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -577,8 +577,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> >         if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> >                 seq_show_option(m, "recover_session", "clean");
> > 
> > -       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > -               seq_puts(m, ",nowsync");
> > +       if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
> > +               seq_puts(m, ",wsync");
> > 
> >         if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
> >                 seq_printf(m, ",wsize=%u", fsopt->wsize);
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 13b02887b085..8ee2745f6257 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -46,8 +46,9 @@
> >  #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
> > 
> >  #define CEPH_MOUNT_OPT_DEFAULT                 \
> > -       (CEPH_MOUNT_OPT_DCACHE |                \
> > -        CEPH_MOUNT_OPT_NOCOPYFROM)
> > +       (CEPH_MOUNT_OPT_DCACHE          |       \
> > +        CEPH_MOUNT_OPT_NOCOPYFROM      |       \
> > +        CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > 
> >  #define ceph_set_mount_opt(fsc, opt) \
> >         (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
> > --
> > 2.29.2
> > 
> 
> Hi Jeff,
> 
> Is it being tested by teuthology?   I see commit 4181742a3ba8 ("qa:
> allow arbitrary mount options on kclient mounts"), but nothing beyond
> that.  I think "nowsync" needs to be turned on and get at least some
> nightly coverage before the default is flipped.
> 
> Thanks,
> 
>                 Ilya

Good point. I had thought Patrick had added a qa variant that turned
that on, but I don't think that ever got merged. We definitely need that
enabled in QA before we make this the default.

The catch is that we probably don't _always_ want nowsync enabled, so is
there some way to randomize this? Or do we need some sort of yaml file
that turns this on by request? What should we be aiming to do for this?

How are the existing, more obscure mount options usually tested in
teuthology today?
-- 
Jeff Layton <jlayton@kernel.org>

