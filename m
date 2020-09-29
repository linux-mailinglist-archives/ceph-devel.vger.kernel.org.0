Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5707F27D746
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 21:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgI2Tu2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 15:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727700AbgI2Tu1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 15:50:27 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A9220774;
        Tue, 29 Sep 2020 19:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601409027;
        bh=8kSSnidOt+M6zbC8QJMPGASDZ11J3FBNTOKYDi51aDQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tV+fP7MtO+TsA7TO0Gw+7qX8DOjRqLMdJT8+JE98m4fUAR5xPYhzkkzau1ddYZ1Ib
         qCs/kPAhHIlhj4AFYraS5elIAC/cKYI1iDSUGfXqblPrQr6sG2+Haqil1f7j8NXtAd
         OiN8uf9ZF19co0dzttaJXENfUKtwAJg1OrSKT7JQ=
Message-ID: <5ba09f6b5493457341aaa273a3d3bddb155a37b4.camel@kernel.org>
Subject: Re: [RFC PATCH 0/4] ceph: fix spurious recover_session=clean errors
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 29 Sep 2020 15:50:25 -0400
In-Reply-To: <CAAM7YA=bo-pdnLuxFAyChtZCoP6VZ3oUJEX_+Sn5r6i6bO_+8Q@mail.gmail.com>
References: <20200925140851.320673-1-jlayton@kernel.org>
         <CAAM7YAmJfNCbt4ON5c44FFVYOUhXu0ipK858aLJK22ZX2E-FdA@mail.gmail.com>
         <CAOi1vP9Nz2Art=rq06qBuU3DvKzZs+RR7pf+qsGxYZkrbSB-1Q@mail.gmail.com>
         <CAAM7YA=bo-pdnLuxFAyChtZCoP6VZ3oUJEX_+Sn5r6i6bO_+8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-09-29 at 18:44 +0800, Yan, Zheng wrote:
> On Tue, Sep 29, 2020 at 4:55 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > On Tue, Sep 29, 2020 at 10:28 AM Yan, Zheng <ukernel@gmail.com> wrote:
> > > On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > Ilya noticed that he would get spurious EACCES errors on calls done just
> > > > after blocklisting the client on mounts with recover_session=clean. The
> > > > session would get marked as REJECTED and that caused in-flight calls to
> > > > die with EACCES. This patchset seems to smooth over the problem, but I'm
> > > > not fully convinced it's the right approach.
> > > > 
> > > 
> > > the root is cause is that client does not recover session instantly
> > > after getting rejected by mds. Before session gets recovered, client
> > > continues to return error.
> > 
> > Hi Zheng,
> > 
> > I don't think it's about whether that happens instantly or not.
> > In the example from [1], the first "ls" would fail even if issued
> > minutes after the session reject message and the reconnect.  From
> > the user's POV it is well after the automatic recovery promised by
> > recover_session=clean.
> > 
> > [1] https://tracker.ceph.com/issues/47385
> 
> Reconnect should close all old session. It's likely because that
> client didn't detect it's blacklisted.
> 

I should have described this better -- let me explain:

It did detect that it was blocklisted (almost immediately) because the
MDS shuts down the session. I think it immediately sends a
SESSION_REJECT message when blacklisting and indicates that it has been
blocklisted.

At that point the session is CEPH_MDS_SESSION_REJECTED. The next MDS
calls through would see that it was in that state and would return
-EACCES. Eventually, the delayed work runs and then the session gets
reconnected, and further calls proceed normally.

So, I think this is just a timing thing for the most part. The workqueue
job runs on a delay of round_jiffies_relative(HZ * 5);, and that's long
enough for the disruption to be noticeable.

While this was happening during 'ls' for Ilya, it could happen in
anything that involves sending a request to the MDS. I think we want to
prevent new opens from erroring out during this window if we can.

The real question is whether this is safe in all cases. For instance, if
the call that we're idling is dependent on holding certain caps, then
it's possible we will have lost them when we got REJECTED.

Hmm...so that means patch 4/4 is probably wrong. I'll comment further in
a reply to that patch.

> > Thanks,
> > 
> >                 Ilya
> > 
> > > 
> > > > The potential issue I see is that the client could take cap references to
> > > > do a call on a session that has been blocklisted. We then queue the
> > > > message and reestablish the session, but we may not have been granted
> > > > the same caps by the MDS at that point.
> > > > 
> > > > If this is a problem, then we probably need to rework it so that we
> > > > return a distinct error code in this situation and have the upper layers
> > > > issue a completely new mds request (with new cap refs, etc.)
> > > > 
> > > > Obviously, that's a much more invasive approach though, so it would be
> > > > nice to avoid that if this would suffice.
> > > > 
> > > > Jeff Layton (4):
> > > >   ceph: don't WARN when removing caps due to blocklisting
> > > >   ceph: don't mark mount as SHUTDOWN when recovering session
> > > >   ceph: remove timeout on allowing reconnect after blocklisting
> > > >   ceph: queue request when CLEANRECOVER is set
> > > > 
> > > >  fs/ceph/caps.c       |  2 +-
> > > >  fs/ceph/mds_client.c | 10 ++++------
> > > >  fs/ceph/super.c      | 13 +++++++++----
> > > >  fs/ceph/super.h      |  1 -
> > > >  4 files changed, 14 insertions(+), 12 deletions(-)
> > > > 
> > > > --
> > > > 2.26.2
> > > > 

-- 
Jeff Layton <jlayton@kernel.org>

