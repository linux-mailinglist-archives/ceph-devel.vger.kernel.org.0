Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A109AFCEED
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 20:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKNTsb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 14:48:31 -0500
Received: from tragedy.dreamhost.com ([66.33.205.236]:60915 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfKNTsb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Nov 2019 14:48:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 875E715F87A;
        Thu, 14 Nov 2019 11:48:30 -0800 (PST)
Date:   Thu, 14 Nov 2019 19:48:28 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Patrick Donnelly <pdonnell@redhat.com>
cc:     Jerry Lee <leisurelysw24@gmail.com>,
        Ceph Users <ceph-users@lists.ceph.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: [ceph-users] Revert a CephFS snapshot?
In-Reply-To: <CA+2bHPbw3uMLeq77XfjZfhYnYcnF-Gk+Od6UJrTiYkW+g77s4w@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1911141900360.17979@piezo.novalocal>
References: <CAKQB+ftphk7pepLdGEgckLtfj=KBp02cMqdea+R_NTd6Gwn-TA@mail.gmail.com> <CA+2bHPaCg4Pq-88hnvnH93QCOfgKv27gDTUjHF5rnDr6Nd2=wQ@mail.gmail.com> <CAKQB+fvUCUAeHEHwP06auyK+ZGUHZdRzTT-38xtgsSbQDjyoHQ@mail.gmail.com>
 <CA+2bHPbw3uMLeq77XfjZfhYnYcnF-Gk+Od6UJrTiYkW+g77s4w@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudeffedguddvlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucfkphepuddvjedrtddrtddrudenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtoheptggvphhhqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 14 Nov 2019, Patrick Donnelly wrote:
> On Wed, Nov 13, 2019 at 6:36 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
> >
> > On Thu, 14 Nov 2019 at 07:07, Patrick Donnelly <pdonnell@redhat.com> wrote:
> > >
> > > On Wed, Nov 13, 2019 at 2:30 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > > > Recently, I'm evaluating the snpahsot feature of CephFS from kernel
> > > > client and everthing works like a charm.  But, it seems that reverting
> > > > a snapshot is not available currently.  Is there some reason or
> > > > technical limitation that the feature is not provided?  Any insights
> > > > or ideas are appreciated.
> > >
> > > Please provide more information about what you tried to do (commands
> > > run) and how it surprised you.
> >
> > The thing I would like to do is to rollback a snapped directory to a
> > previous version of snapshot.  It looks like the operation can be done
> > by over-writting all the current version of files/directories from a
> > previous snapshot via cp.  But cp may take lots of time when there are
> > many files and directories in the target directory.  Is there any
> > possibility to achieve the goal much faster from the CephFS internal
> > via command like "ceph fs <cephfs_name> <dir> snap rollback
> > <snapname>" (just a example)?  Thank you!
> 
> RADOS doesn't support rollback of snapshots so it needs to be done
> manually. The best tool to do this would probably be rsync of the
> .snap directory with appropriate options including deletion of files
> that do not exist in the source (snapshot).

rsync is the best bet now, yeah.

RADOS does have a rollback operation that uses clone where it can, but 
it's a per-object operation, so something still needs to walk the 
hierarchy and roll back each file's content.  The MDS could do this more 
efficiently than rsync give what it knows about the snapped inodes 
(skipping untouched inodes or, eventually, entire subtrees) but it's a 
non-trivial amount of work to implement.

sage
