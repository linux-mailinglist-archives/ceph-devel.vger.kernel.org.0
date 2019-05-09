Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B8B1958C
	for <lists+ceph-devel@lfdr.de>; Fri, 10 May 2019 01:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfEIXCb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 May 2019 19:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfEIXCb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 May 2019 19:02:31 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9083F8110C;
        Thu,  9 May 2019 23:02:30 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E3BD460C81;
        Thu,  9 May 2019 23:02:29 +0000 (UTC)
Date:   Thu, 9 May 2019 23:02:28 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     zengran zhang <z13121369189@gmail.com>
cc:     Gregory Farnum <gfarnum@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: some questions about fast dispatch peering events
In-Reply-To: <CALi+v1-qsyB8S8sxPoQe+hpC8C_tz+d7Fz3cmeMoh5sWNQZ8Bg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1905092249260.8559@piezo.novalocal>
References: <CALi+v1_fTKgpKtMTBDw3ioy4SqtsvP3xkjXLyLX5Gb=_7yoaNg@mail.gmail.com> <CAJ4mKGaRZrA9P6=hZ+CZ7oca5_b9uGXZAV5gNu2YiNajy1q8Qw@mail.gmail.com> <CALi+v1-qsyB8S8sxPoQe+hpC8C_tz+d7Fz3cmeMoh5sWNQZ8Bg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-745421679-1557442950=:8559"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 09 May 2019 23:02:30 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-745421679-1557442950=:8559
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 9 May 2019, zengran zhang wrote:
> Gregory Farnum <gfarnum@redhat.com> 于2019年5月9日周四 上午5:00写道：
> >
> > On Wed, May 8, 2019 at 6:12 AM zengran zhang <z13121369189@gmail.com> wrote:
> > >
> > > Hi Sage:
> > >
> > >   I see there are two difference between luminous and upstream after
> > > the patch of *fast dispatch peering events*
> > >
> > > 1. When handle pg query w/o pg, luminous will preject history since
> > > the epoch_send in query and create pg if within the same interval.
> > >     but upstream now will reply empty info or log directly w/o create the pg.
> > >     My question is : can we do this on luminous?
> >
> > I think you mean "project history" here?
> 
> Sorry, I mean could we reply empty info or log directly in luminous
> cluster w/o create the pg?

I'm looking at handle_pg_query() on luminous and I think that's what it 
does... if the interval has changed, we drop/ignore the request.  
Otherwise, we either reply with an empty log or an empty notify. Where do 
you see it creating the pg due to a query?

> > In any case, lots of things around PG creation happened since
> > Luminous, as part of the fast dispatch and enabling PG merge. That
> > included changes to the monitor<->OSD interactions that are difficult
> > to do within a release stream since they change the protocol. We
> > typically handle those protocol changes by flagging them on the
> > "min_osd_release" option. We probably can't backport this behavior
> > given that.
> >
> > >
> > > 2. When handle pg notify w/o pg, luminous will preject history since
> > > the epoch_send of notify and give up next creating if not within the
> > > same interval.
> > >     but upstream now will create the pg unconditionally, If it was
> > > stray, auth primary will purge it later.
> > >     Here my question is: is the behavior of upstream a specially
> > > designed improvement?

My reading of the latest code is that it will only create the PG if the 
current OSD is the primary according to the latest/current OSDMap.  In 
handle_fast_pg_notify, we queue it unconditionally, and in _process, we 
only process the create_info if 

      } else if (osdmap->is_up_acting_osd_shard(token, osd->whoami)) {

This is maybe not as precise as it could be, since maybe the epoch the 
message was sent it we were primary, then we weren't, but now currently we 
are, but in that case we'd still want to create the PG (one way or 
another).  Am I missing anything?

> > My recollection is that this was just for expediency within the fast
> > dispatch pipeline rather than something we thought made life within
> > the cluster better, but I don't remember with any certainty. It might
> > also have improved resiliency of PG create messages from the monitors
> > since the OSD has the PG and will send notifies to subsequent primary
> > targets?
> > -Greg
> 
> Got it, Thank you for the clarification.
> 
> Now our luminous cluster, we found that the stale notify/query with
> too old epoch
> will cause the dispatch queue under high pressure dur to project history..
> then I see the upstream remove the project history, so I'm curious
> about the same
> circumstance on upstream..

Getting rid of project_pg_history was a big goal of the PG create/delete 
and queueing/dispatch refactor that happened for nautilus, for exactly 
that reason.  Post-nautilus, we've also removed the last instance where 
teh OSD has to iterate over past OSDMaps due to mon pg creation messages 
(see https://github.com/ceph/ceph/pull/27696), but that only comes up when 
creating pools (combined with a loady/thrashy cluster).  

In any case, I don't think there is a quick fix for luminous (and I 
wouldn't want to risk a buggy backport), so my recommendation is to move 
to nautilus.

sage
--8323329-745421679-1557442950=:8559--
