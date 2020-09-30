Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5622F27E40A
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Sep 2020 10:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgI3IpW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Sep 2020 04:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3IpW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Sep 2020 04:45:22 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E681AC061755
        for <ceph-devel@vger.kernel.org>; Wed, 30 Sep 2020 01:45:21 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f15so838672ilj.2
        for <ceph-devel@vger.kernel.org>; Wed, 30 Sep 2020 01:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pL0U4gdCJbIk58DJezag2xTsFBbfcBrlDKCOowoM+KQ=;
        b=TG4D9z1NSNAFujtoX2Q842oMhdgCKzdSCLRE00szJ2Qxpv3KSYM+c0pZOLrrhLYf9I
         KaGl3cE6vhsS3Ct6fvUTgnrLymSLxtNDgKxGa3nvkacjmJpsgCAzf3AY7kt4ohp+T4pG
         Fp1pYy63nHEf6Rr67/+q2jIcyhAbKFlGp2P7h29F2eoICjFhEAF0fsNdnrC/PcOWKNKl
         Jrz5tgQYDEsB4Sl58DU3jxP7KxiG5HhJl7rKUDcphLDX873SoWTjrL2z7/CsXgvXfGvY
         hmS58eaT98b5FRW44Bb7m9jwrEV6W3H8Au64d9Py5sVwybEiCwkO2l6cxac5wZNkabU3
         BCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pL0U4gdCJbIk58DJezag2xTsFBbfcBrlDKCOowoM+KQ=;
        b=lcHc9wxQMui8BRl2Pwrnw2+/s3gmKQLBu5yg4uqKkP3gKx4ijAOj6VBm2ZDqjcvO9x
         M1zOP+orTWa2PSfELpeNyVXmdFCTkZmoBjCfn8ZDovWLohjNWdti6NYEBjqgty3oPgIo
         0cjvNrrogLyhn+SNDaKhXuTPIkQIv4wz+Ewk9hGEyylkWHHvhKy2OE5ihWpbkvNvK1+8
         gcJVFSU/sMjHXRFfZi9fdBXiniH8zK/zofMOizxvZIxbCdCc7qnoJ0WRj9zLLz7d4rX2
         eyUBEVAQCdqrFU0XzEjDBkyo1X26/tpW8f/5Lmlmxv48l88ltnnEFGFhgpdbvOKP1GAl
         hedQ==
X-Gm-Message-State: AOAM533GEidiqAuzJoEcKTBnvwyCvLqie7qQXYjdRQ1bFkqullP5XKHO
        M6++zvlAWyOpfo44YPxf/Sij6jM2pmvfzsU8BK8=
X-Google-Smtp-Source: ABdhPJzinT6r55xTc2wrl7XXVLVQm2aYyu6AvRV+kvF42WjaA02MkOPorYGml8nRMo3eMKSxHLce/PEv+ZZDHgnpuac=
X-Received: by 2002:a92:d5c5:: with SMTP id d5mr1187459ilq.204.1601455521259;
 Wed, 30 Sep 2020 01:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200925140851.320673-1-jlayton@kernel.org> <CAAM7YAmJfNCbt4ON5c44FFVYOUhXu0ipK858aLJK22ZX2E-FdA@mail.gmail.com>
 <CAOi1vP9Nz2Art=rq06qBuU3DvKzZs+RR7pf+qsGxYZkrbSB-1Q@mail.gmail.com>
 <CAAM7YA=bo-pdnLuxFAyChtZCoP6VZ3oUJEX_+Sn5r6i6bO_+8Q@mail.gmail.com> <5ba09f6b5493457341aaa273a3d3bddb155a37b4.camel@kernel.org>
In-Reply-To: <5ba09f6b5493457341aaa273a3d3bddb155a37b4.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 30 Sep 2020 16:45:10 +0800
Message-ID: <CAAM7YAnjtrQAfv9mYpAZev=VRMvgUXtX8Ausa4NAeZpcUbO+LQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] ceph: fix spurious recover_session=clean errors
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 30, 2020 at 3:50 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-09-29 at 18:44 +0800, Yan, Zheng wrote:
> > On Tue, Sep 29, 2020 at 4:55 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > On Tue, Sep 29, 2020 at 10:28 AM Yan, Zheng <ukernel@gmail.com> wrote:
> > > > On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > Ilya noticed that he would get spurious EACCES errors on calls done just
> > > > > after blocklisting the client on mounts with recover_session=clean. The
> > > > > session would get marked as REJECTED and that caused in-flight calls to
> > > > > die with EACCES. This patchset seems to smooth over the problem, but I'm
> > > > > not fully convinced it's the right approach.
> > > > >
> > > >
> > > > the root is cause is that client does not recover session instantly
> > > > after getting rejected by mds. Before session gets recovered, client
> > > > continues to return error.
> > >
> > > Hi Zheng,
> > >
> > > I don't think it's about whether that happens instantly or not.
> > > In the example from [1], the first "ls" would fail even if issued
> > > minutes after the session reject message and the reconnect.  From
> > > the user's POV it is well after the automatic recovery promised by
> > > recover_session=clean.
> > >
> > > [1] https://tracker.ceph.com/issues/47385
> >
> > Reconnect should close all old session. It's likely because that
> > client didn't detect it's blacklisted.
> >
>
> I should have described this better -- let me explain:
>
> It did detect that it was blocklisted (almost immediately) because the
> MDS shuts down the session. I think it immediately sends a
> SESSION_REJECT message when blacklisting and indicates that it has been
> blocklisted.
>
> At that point the session is CEPH_MDS_SESSION_REJECTED. The next MDS
> calls through would see that it was in that state and would return
> -EACCES. Eventually, the delayed work runs and then the session gets
> reconnected, and further calls proceed normally.
>
> So, I think this is just a timing thing for the most part. The workqueue
> job runs on a delay of round_jiffies_relative(HZ * 5);, and that's long
> enough for the disruption to be noticeable.
>
> While this was happening during 'ls' for Ilya, it could happen in
> anything that involves sending a request to the MDS. I think we want to
> prevent new opens from erroring out during this window if we can.
>
> The real question is whether this is safe in all cases. For instance, if
> the call that we're idling is dependent on holding certain caps, then
> it's possible we will have lost them when we got REJECTED.
>

The session in rejected state is new session. It should hold no caps.

> Hmm...so that means patch 4/4 is probably wrong. I'll comment further in
> a reply to that patch.
>
> > > Thanks,
> > >
> > >                 Ilya
> > >
> > > >
> > > > > The potential issue I see is that the client could take cap references to
> > > > > do a call on a session that has been blocklisted. We then queue the
> > > > > message and reestablish the session, but we may not have been granted
> > > > > the same caps by the MDS at that point.
> > > > >
> > > > > If this is a problem, then we probably need to rework it so that we
> > > > > return a distinct error code in this situation and have the upper layers
> > > > > issue a completely new mds request (with new cap refs, etc.)
> > > > >
> > > > > Obviously, that's a much more invasive approach though, so it would be
> > > > > nice to avoid that if this would suffice.
> > > > >
> > > > > Jeff Layton (4):
> > > > >   ceph: don't WARN when removing caps due to blocklisting
> > > > >   ceph: don't mark mount as SHUTDOWN when recovering session
> > > > >   ceph: remove timeout on allowing reconnect after blocklisting
> > > > >   ceph: queue request when CLEANRECOVER is set
> > > > >
> > > > >  fs/ceph/caps.c       |  2 +-
> > > > >  fs/ceph/mds_client.c | 10 ++++------
> > > > >  fs/ceph/super.c      | 13 +++++++++----
> > > > >  fs/ceph/super.h      |  1 -
> > > > >  4 files changed, 14 insertions(+), 12 deletions(-)
> > > > >
> > > > > --
> > > > > 2.26.2
> > > > >
>
> --
> Jeff Layton <jlayton@kernel.org>
>
