Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB37027C295
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 12:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgI2Kow (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 06:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI2Kow (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Sep 2020 06:44:52 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FF2C061755
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 03:44:50 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g7so4247834iov.13
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 03:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nQX8gM6If1pmo4+08dQ5a4VAyCKLumKxo+QwBMSiAzY=;
        b=dM7lOo7QR7mp3LOO+OOK3p2MjGpvy94dzRHzHidSO63eQJHJjeAHI/l0e1T+I17kDA
         e0DQuJqI/iBfVmisaPTZ7X81j7QD0MPe0LuZJh26GTxVhjV7fca6pK2BSmB1gZt1zxSV
         J5CVhpZgqacagY/ifsMyshbJYl5i64eTxAg8wNBor0WxXtUJDGcmhKc0z78HXfLZ7/+r
         5ZF7Ugi+rngZfb8cGuOlaje+poYhh3yPMKYeJd6bixBcwDK7BToqCFejmP8Ivt8tfzwg
         ucG3ZTZZUpD7jq38B1jn9RXj+zfUl5w9CHPMfvCDYrYQiNfFkbT7mGGixe+S3awzvhRK
         pBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nQX8gM6If1pmo4+08dQ5a4VAyCKLumKxo+QwBMSiAzY=;
        b=hNTibs9oOKI3ERDeC+jtoA0fOGMNCuuwcN5pcXqZ9buUm4Iu+CNLOZJ5mhnHzKohl2
         b9e5lPtpLt+OCLZKpfbHAHweagWJmMCHuAiGK2lledfKxqN7bWwfJmxO2qhiPk++XkO3
         3CViaMamynIgtDHAmmTWbkFrdIoemfUkQhY4SCfyZwkMX4qsi2R8q0nLomUQW++v9zA9
         o/NrncW9GfjWzmHj0BHdnaXmfGgMg1TKbWsGNimxGUfxjd7bSbYajMLK0dTMYCpFEliP
         43T0+O4p8ugdR/hfjnYOXYtQnkJAdazfCBHOjcoDflrk1zl/xPMmVW+Rm5SlH3CTD4yh
         EAsA==
X-Gm-Message-State: AOAM531e7zW7lOzwEB2cm2QE6pgWTNO76RZ3Di20BX/m0DZY35sZHn94
        EdgyNRBxrUlOQHoEvuPC1ZcAG3B5+34/6bHOiJQ=
X-Google-Smtp-Source: ABdhPJypI022RgERnB46ZVv2h+30iXUNuhhAMdB+H9TcFCtDuw/ARLSyxNW1pw++GXIR6QnoJte+xlxUFQLfFDtLzdU=
X-Received: by 2002:a05:6602:215a:: with SMTP id y26mr1725224ioy.97.1601376290044;
 Tue, 29 Sep 2020 03:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200925140851.320673-1-jlayton@kernel.org> <CAAM7YAmJfNCbt4ON5c44FFVYOUhXu0ipK858aLJK22ZX2E-FdA@mail.gmail.com>
 <CAOi1vP9Nz2Art=rq06qBuU3DvKzZs+RR7pf+qsGxYZkrbSB-1Q@mail.gmail.com>
In-Reply-To: <CAOi1vP9Nz2Art=rq06qBuU3DvKzZs+RR7pf+qsGxYZkrbSB-1Q@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 29 Sep 2020 18:44:38 +0800
Message-ID: <CAAM7YA=bo-pdnLuxFAyChtZCoP6VZ3oUJEX_+Sn5r6i6bO_+8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] ceph: fix spurious recover_session=clean errors
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 29, 2020 at 4:55 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 10:28 AM Yan, Zheng <ukernel@gmail.com> wrote:
> >
> > On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > Ilya noticed that he would get spurious EACCES errors on calls done just
> > > after blocklisting the client on mounts with recover_session=clean. The
> > > session would get marked as REJECTED and that caused in-flight calls to
> > > die with EACCES. This patchset seems to smooth over the problem, but I'm
> > > not fully convinced it's the right approach.
> > >
> >
> > the root is cause is that client does not recover session instantly
> > after getting rejected by mds. Before session gets recovered, client
> > continues to return error.
>
> Hi Zheng,
>
> I don't think it's about whether that happens instantly or not.
> In the example from [1], the first "ls" would fail even if issued
> minutes after the session reject message and the reconnect.  From
> the user's POV it is well after the automatic recovery promised by
> recover_session=clean.
>
> [1] https://tracker.ceph.com/issues/47385

Reconnect should close all old session. It's likely because that
client didn't detect it's blacklisted.

>
> Thanks,
>
>                 Ilya
>
> >
> >
> > > The potential issue I see is that the client could take cap references to
> > > do a call on a session that has been blocklisted. We then queue the
> > > message and reestablish the session, but we may not have been granted
> > > the same caps by the MDS at that point.
> > >
> > > If this is a problem, then we probably need to rework it so that we
> > > return a distinct error code in this situation and have the upper layers
> > > issue a completely new mds request (with new cap refs, etc.)
> > >
> > > Obviously, that's a much more invasive approach though, so it would be
> > > nice to avoid that if this would suffice.
> > >
> > > Jeff Layton (4):
> > >   ceph: don't WARN when removing caps due to blocklisting
> > >   ceph: don't mark mount as SHUTDOWN when recovering session
> > >   ceph: remove timeout on allowing reconnect after blocklisting
> > >   ceph: queue request when CLEANRECOVER is set
> > >
> > >  fs/ceph/caps.c       |  2 +-
> > >  fs/ceph/mds_client.c | 10 ++++------
> > >  fs/ceph/super.c      | 13 +++++++++----
> > >  fs/ceph/super.h      |  1 -
> > >  4 files changed, 14 insertions(+), 12 deletions(-)
> > >
> > > --
> > > 2.26.2
> > >
