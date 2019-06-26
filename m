Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134EE569D1
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 14:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfFZMzu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jun 2019 08:55:50 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:45147 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfFZMzu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jun 2019 08:55:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id D1BE715F883;
        Wed, 26 Jun 2019 05:55:48 -0700 (PDT)
Date:   Wed, 26 Jun 2019 12:55:47 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Alfredo Deza <adeza@redhat.com>
cc:     David Turner <drakonstein@gmail.com>,
        Ceph Devel <ceph-devel@vger.kernel.org>,
        Ceph-User <ceph-users@ceph.com>, dev@ceph.io
Subject: Re: [ceph-users] Changing the release cadence
In-Reply-To: <CAC-Np1zcniBxm84SEGhzYfu55t+fckg1d-Dq0xpab62+ON4K5w@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1906261248400.17148@piezo.novalocal>
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal> <alpine.DEB.2.11.1906171621000.20504@piezo.novalocal> <CAN-Gep+9bxadHMTFQgUFUt_q9Jmfpy3MPU5UTTRNY1jueu7n9w@mail.gmail.com> <CAC-Np1zcniBxm84SEGhzYfu55t+fckg1d-Dq0xpab62+ON4K5w@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigdeitdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucfkphepuddvjedrtddrtddrudenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtohepuggvvhestggvphhhrdhiohenucevlhhushhtvghrufhiiigvpedt
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 25 Jun 2019, Alfredo Deza wrote:
> On Mon, Jun 17, 2019 at 4:09 PM David Turner <drakonstein@gmail.com> wrote:
> >
> > This was a little long to respond with on Twitter, so I thought I'd share my thoughts here. I love the idea of a 12 month cadence. I like October because admins aren't upgrading production within the first few months of a new release. It gives it plenty of time to be stable for the OS distros as well as giving admins something low-key to work on over the holidays with testing the new releases in stage/QA.
> 
> October sounds ideal, but in reality, we haven't been able to release
> right on time as long as I can remember. Realistically, if we set
> October, we are probably going to get into November/December.
> 
> For example, Nautilus was set to release in February and we got it out
> late in late March (Almost April)
> 
> Would love to see more of a discussion around solving the problem of
> releasing when we say we are going to - so that we can then choose
> what the cadence is.

I think the "on time" part is solveable.  We should just use the amount 
of time between take the previous release's freeze date and the 
target release date and go with that.  It is a bit fuzzy because I left it 
up to the leads how they handle the freeze, but I think mid-Januaray is 
about right (in reality we waiting longer than that for lots of RADOS 
stuff).  v14.2.0 was Mar 18, so ~2 months.

The cadence is really separate from that, though: even if every release 
were 2 full months late, if we start with the same target it's still a 1 
year cycle.

sage

