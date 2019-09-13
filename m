Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98408B2272
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Sep 2019 16:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbfIMOpt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Sep 2019 10:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388214AbfIMOps (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 10:45:48 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F06120693;
        Fri, 13 Sep 2019 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568385947;
        bh=PR8qYOU3Nn5a28ZpWFSYPT32dDVcvirYJsUo2uDy8BU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e+u1P8H4CVXxERRp8YzIr9+01ZMmasXMTzvGexLP34Gt4LCImmzRsTSZi3uxDa+oq
         X9oBUswvSxXgGxOsvNdkbAX4hmbIZbai/DV5dhBrKu/hToPMub5d16kng6hXsf1mRk
         bPPCO4f63zgFawm7/7OBuYaC++hHtnGtM/X/TQII=
Message-ID: <14f39bfc51e730384f56a21bafa8c97ac8b52fa0.camel@kernel.org>
Subject: Re: [PATCH] ceph: add mount opt, always_auth
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        simon gao <simon29rock@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Fri, 13 Sep 2019 10:45:45 -0400
In-Reply-To: <CAAM7YAmdccvHiOB6+qk5MOLX5u3NrTa4MrUOH_MG+VD=_TV3cA@mail.gmail.com>
References: <1568083391-920-1-git-send-email-simon29rock@gmail.com>
         <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
         <CAJ4mKGbY+veWdLv588Hz4mQidz5ofiGemOQ2Nwx_M6XN0WXGJw@mail.gmail.com>
         <dc75c171278e4dd1fc00c20b3a9843bb412901ac.camel@kernel.org>
         <CAAM7YAmdccvHiOB6+qk5MOLX5u3NrTa4MrUOH_MG+VD=_TV3cA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-09-13 at 10:08 +0800, Yan, Zheng wrote:
> On Thu, Sep 12, 2019 at 6:21 AM Jeff Layton <jlayton@kernel.org> wrote:
> > On Wed, 2019-09-11 at 11:30 -0700, Gregory Farnum wrote:
> > > On Tue, Sep 10, 2019 at 3:11 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > I've no particular objection here, but I'd prefer Greg's ack before we
> > > > merge it, since he raised earlier concerns.
> > > 
> > > You have my acked-by in light of Zheng's comments elsewhere and the
> > > evidence that this actually works in some scenarios.
> > > 
> > > Might be nice to at least get far enough to generate tickets based on
> > > your questions in the other thread, though:
> > > 
> > 
> > I'm not sold yet.
> > 
> > Why is this something the client should have to worry about at all? Can
> > we do something on the MDS to better handle this situation? This really
> > feels like we're exposing an implementation detail via mount option.
> > 
> 
> I think we can.  make mds return empty DirStat::dist in request reply
> 

I guess that'd make the client think that it wasn't replicated?

Under what conditions would you have it return that in the reply? Should
we be looking to have the MDS favor forwarding over replication more (as
Greg seems to be suggesting)?

Note too that I'm not opposed to adding some sort of mitigation for this
problem if needed to help with code that's in the field, but I'd prefer
to address the root cause if we can so the workaround may not be needed
in the future.

Mount options are harder to deprecate since they'll be in docs forever,
and they are necessarily per-vfsmount. If you do need this, would the
switch be more appropriate as a kernel module parameter instead?

> > At a bare minimum, if we take this, I'd like to see some documentation.
> > When should a user decide to turn this on or off? There are no
> > guidelines to the use of this thing so far.
> > 
> > 
> > > On Wed, Sep 11, 2019 at 9:26 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > In an ideal world, what should happen in this case? Should we be
> > > > changing MDS policy to forward the request in this situation?
> > > > 
> > > > This mount option seems like it's exposing something that is really an
> > > > internal implementation detail to the admin. That might be justified,
> > > > but I'm unclear on why we don't expect more saner behavior from the MDS
> > > > on this?
> > > 
> > > I think partly it's that early designs underestimated the cost of
> > > replication and overestimated its utility, but I also thought forwards
> > > were supposed to happen more often than replication so I'm curious why
> > > it's apparently not doing that.
> > > -Greg
> > 
> > --
> > Jeff Layton <jlayton@kernel.org>
> > 

-- 
Jeff Layton <jlayton@kernel.org>

