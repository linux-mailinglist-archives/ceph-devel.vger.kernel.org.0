Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B34DB93E8
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Sep 2019 17:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388488AbfITPYS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Sep 2019 11:24:18 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:39848 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfITPYS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 Sep 2019 11:24:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id A657315F8B5;
        Fri, 20 Sep 2019 08:24:17 -0700 (PDT)
Date:   Fri, 20 Sep 2019 15:24:15 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Alfredo Deza <adeza@redhat.com>
cc:     ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: Set/Unset OSD 'Allows Journal'
In-Reply-To: <CAC-Np1ybHN212ZWbq4zceDrdsCxTTciHbQy4g2O5H0+UEvOE1g@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1909201522490.29897@piezo.novalocal>
References: <CAC-Np1xa5riFgb_tZG3vFn-dcuKtyV+BSCBZV6uu8+6JRrnrWQ@mail.gmail.com> <alpine.DEB.2.11.1909201453051.5147@piezo.novalocal> <CAC-Np1ybHN212ZWbq4zceDrdsCxTTciHbQy4g2O5H0+UEvOE1g@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrvddvgdekjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucfkphepuddvjedrtddrtddrudenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtoheptggvphhhqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 20 Sep 2019, Alfredo Deza wrote:
> On Fri, Sep 20, 2019 at 10:55 AM Sage Weil <sage@newdream.net> wrote:
> >
> > On Thu, 19 Sep 2019, Alfredo Deza wrote:
> > > After deploying Ceph with ceph-deploy on Bionic, the latest luminous
> > > (12.2.12) has ceph-disk creating a file for a journal - something that
> > > is very surprising as I have never seen that functionality in
> > > ceph-disk, without specifying any flags that might indicate a file is
> > > needed.
> > >
> > > Using the same approach with ceph-ansible, the OSD would be created
> > > with a partition (again, via ceph-disk). Same arguments and all,
> > > similar to:
> > >
> > > ceph-disk -v prepare --cluster=ceph --filestore --dmcrypt /dev/sdX
> > >
> > > After going through all the ceph-disk output, this line got different
> > > results from the ceph-deploy cluster than the ceph-ansible one:
> > >
> > > /usr/bin/ceph-osd --check-allows-journal -i 0 --log-file
> > > /var/log/ceph/$cluster-osd-check.log --cluster ceph --setuser ceph
> > > --setgroup ceph
> >
> > This will always be true for filestore and always false for bluestore.
> > Perhaps this is a subtle change due to the default for osd_objectstore
> > having changed between versions?  I think the "fix" is probably to pass
> > '--osd-objecstore bluestore' or '--osd-objecstore filestore' to this
> > command depending on which type of store was getting created?
> 
> Ok, so that would explain the mistery... because ceph-disk asks for
> the OSD with an id of 0, in my case this OSD was created with
> bluestore, and then
> I am trying to create one with filestore!
> 
> This would still be a bug in ceph-disk since I am passing --filestore
> in the invocation and it still goes out to check... but regardless I
> will try to clarify in the docs why and when this would happen.

Since this is ceph-disk, you can make life easier and just assume true for 
filestore and false for everything else without even calling ceph-osd... 
no need to worry about how this will behave with future OSD backends.

sage
