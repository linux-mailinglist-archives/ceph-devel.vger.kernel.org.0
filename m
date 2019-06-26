Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C52569DD
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 14:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfFZM5r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jun 2019 08:57:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbfFZM5r (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 08:57:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BFC6285363;
        Wed, 26 Jun 2019 12:57:46 +0000 (UTC)
Received: from ovpn-112-33.rdu2.redhat.com (ovpn-112-33.rdu2.redhat.com [10.10.112.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ACCCD5C1A1;
        Wed, 26 Jun 2019 12:57:45 +0000 (UTC)
Date:   Wed, 26 Jun 2019 12:57:44 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     Alfonso Martinez Hidalgo <almartin@redhat.com>
cc:     Alfredo Deza <adeza@redhat.com>,
        David Turner <drakonstein@gmail.com>,
        Ceph Devel <ceph-devel@vger.kernel.org>,
        Ceph-User <ceph-users@ceph.com>, dev@ceph.io
Subject: Re: [ceph-users] Changing the release cadence
In-Reply-To: <CAE6AcseMEfRjRtA0iUPMwsQPP+ebEqDDHYeWUpXWGeWTggnKRw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1906261255530.17148@piezo.novalocal>
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal> <alpine.DEB.2.11.1906171621000.20504@piezo.novalocal> <CAN-Gep+9bxadHMTFQgUFUt_q9Jmfpy3MPU5UTTRNY1jueu7n9w@mail.gmail.com> <CAC-Np1zcniBxm84SEGhzYfu55t+fckg1d-Dq0xpab62+ON4K5w@mail.gmail.com>
 <CAE6AcseMEfRjRtA0iUPMwsQPP+ebEqDDHYeWUpXWGeWTggnKRw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1126956908-1561553866=:17148"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 26 Jun 2019 12:57:46 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1126956908-1561553866=:17148
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 26 Jun 2019, Alfonso Martinez Hidalgo wrote:
> I think March is a good idea.

Spring had a slight edge over fall in the twitter poll (for whatever 
that's worth).  I see the appeal for fall when it comes to down time for  
retailers, but as a practical matter for Octopus specifically, a target of
say October means freezing in August, which means we only have 2
more months of development time.  I'm worried that will turn Octopus 
in another weak (aka lightly adopted) release.

March would mean freezing in January again, which would give us July to 
Dec... 6 more months.

sage



> 
> On Tue, Jun 25, 2019 at 4:32 PM Alfredo Deza <adeza@redhat.com> wrote:
> 
> > On Mon, Jun 17, 2019 at 4:09 PM David Turner <drakonstein@gmail.com>
> > wrote:
> > >
> > > This was a little long to respond with on Twitter, so I thought I'd
> > share my thoughts here. I love the idea of a 12 month cadence. I like
> > October because admins aren't upgrading production within the first few
> > months of a new release. It gives it plenty of time to be stable for the OS
> > distros as well as giving admins something low-key to work on over the
> > holidays with testing the new releases in stage/QA.
> >
> > October sounds ideal, but in reality, we haven't been able to release
> > right on time as long as I can remember. Realistically, if we set
> > October, we are probably going to get into November/December.
> >
> > For example, Nautilus was set to release in February and we got it out
> > late in late March (Almost April)
> >
> > Would love to see more of a discussion around solving the problem of
> > releasing when we say we are going to - so that we can then choose
> > what the cadence is.
> >
> > >
> > > On Mon, Jun 17, 2019 at 12:22 PM Sage Weil <sage@newdream.net> wrote:
> > >>
> > >> On Wed, 5 Jun 2019, Sage Weil wrote:
> > >> > That brings us to an important decision: what time of year should we
> > >> > release?  Once we pick the timing, we'll be releasing at that time
> > *every
> > >> > year* for each release (barring another schedule shift, which we want
> > to
> > >> > avoid), so let's choose carefully!
> > >>
> > >> I've put up a twitter poll:
> > >>
> > >>         https://twitter.com/liewegas/status/1140655233430970369
> > >>
> > >> Thanks!
> > >> sage
> > >> _______________________________________________
> > >> ceph-users mailing list
> > >> ceph-users@lists.ceph.com
> > >> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
> > >
> > > _______________________________________________
> > > ceph-users mailing list
> > > ceph-users@lists.ceph.com
> > > http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
> >
> 
> 
> -- 
> 
> Alfonso Martínez
> 
> Senior Software Engineer, Ceph Storage
> 
> Red Hat <https://www.redhat.com>
> <https://red.ht/sig>
> 
--8323329-1126956908-1561553866=:17148--
