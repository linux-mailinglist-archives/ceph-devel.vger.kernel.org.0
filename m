Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B667540301B
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Sep 2021 23:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346927AbhIGVI4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Sep 2021 17:08:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344670AbhIGVI4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Sep 2021 17:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631048869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5chk1sLlqhKkI3Ke66l3ngGqVdBKhHw9HpZJAob0RiU=;
        b=XY0zqCe30PgHcb5YFfHGZJWZQM07KlXkVBZYuGlevExVHyM6jc+DuSGklcXx7tzVtxd2sk
        aHC/ATMHSidHQB3Osa4qXXCJk79j5bjfZfxesfeFPQtmVixJ+59mJ6TKiaaCMnCIEqa6+W
        gvXKDeUZs+76bXLFUaVhxlZ7XcAotUY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-EyJja_0JMr-kPkiabPn1-Q-1; Tue, 07 Sep 2021 17:07:48 -0400
X-MC-Unique: EyJja_0JMr-kPkiabPn1-Q-1
Received: by mail-il1-f197.google.com with SMTP id a6-20020a92d346000000b0022b61ba0872so2287ilh.20
        for <ceph-devel@vger.kernel.org>; Tue, 07 Sep 2021 14:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5chk1sLlqhKkI3Ke66l3ngGqVdBKhHw9HpZJAob0RiU=;
        b=pzD8m3egeL1QSmifRccRy9eE+8TfGfaXTRgVzz8U1m427tWJDRIie+3sBz/63frCr7
         eN9j18N03i3QN5fOODm08W8CausN6GYkZdNLpgynSGZmQ3rOaf9soYtCyWo/B9ic+dOv
         TQ32rfZo1zg8+ZAwraTfSC6L9ovd7f7b41yWn5If0XMos7mrJCh46pui0WaX82P61E25
         a06vVogu4VBQTauec2dOVlPfFDRKkgsy0eghx5WTQysFuW8NA1tIRtA9x/BcvLdck8a9
         lmrAl7gIQhke5YTYme54QgLGe5KNfn8cNyhl/VrJKyTK7cp/e2AjPrq2OKj51N5nGHPE
         kTgg==
X-Gm-Message-State: AOAM532RtoWLRBYhPOTmLF8KxHFGcIjfuug8AOhqn7ebQlRtV9j2PoX4
        gP65P9pR2La7rGzV1Uj+VnE3/KLAamxTCec4rj0SYSd6u8ZtnZzPDtRYz1WLxa2l63jlYz/6fub
        iZtVCQPou3WY8UONG+9CvGm/QL3zu4v7Mwn7N6Q==
X-Received: by 2002:a92:ca0a:: with SMTP id j10mr177264ils.192.1631048867711;
        Tue, 07 Sep 2021 14:07:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXSYiWPmDCTrge6I0oIiu8xXY2Zw0cvvpL2+nbF0UDwwcHvWfDJt1xFqBt0dleEyBlRjciNsc8VuAW9MmxgAk=
X-Received: by 2002:a92:ca0a:: with SMTP id j10mr177248ils.192.1631048867488;
 Tue, 07 Sep 2021 14:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210809164410.27750-1-jlayton@kernel.org> <6aeae1ddabffc701e1b039e99464c116c682a3fa.camel@kernel.org>
In-Reply-To: <6aeae1ddabffc701e1b039e99464c116c682a3fa.camel@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 7 Sep 2021 17:07:21 -0400
Message-ID: <CA+2bHPbJArs_n-WWMHg7s2A9Yejod7iqeyv6ijOz_HFWGSt_gw@mail.gmail.com>
Subject: Re: [PATCH] ceph: enable async dirops by default
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 1, 2021 at 12:54 PM Jeff Layton <jlayton@kernel.org> wrote:
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

Sounds good to me.


-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

