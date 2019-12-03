Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2494E1104C2
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 20:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfLCTJd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 14:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfLCTJd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 14:09:33 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83222206DF;
        Tue,  3 Dec 2019 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575400172;
        bh=BnLzoKKXtDLBZePSPHATmQyeNeAsjHO4W6Mhaw42xZk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uoQaQrdU6RQjB3lnkTPNlC8adatrQcSbXsDrSSs/EfogMjd1/svEnOLaI4Uw2HMY6
         rD4SDvaSFuDWzJ0BplacymEjMJuc8EfBQ62n2tjCjVce93n5S1ZHuPlhyxws3UG9Wt
         v2d8MGleV9uE7TSo6E4uYAGg4iHoF6D4Osv20TE0=
Message-ID: <3f37461a0bdd94e9068526fa9a722fdf65c37fdf.camel@kernel.org>
Subject: Re: [ceph-users] Revert a CephFS snapshot?
From:   Jeff Layton <jlayton@kernel.org>
To:     Robert LeBlanc <robert@leblancnet.us>,
        Sage Weil <sage@newdream.net>
Cc:     Jerry Lee <leisurelysw24@gmail.com>,
        Ceph Users <ceph-users@lists.ceph.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 03 Dec 2019 14:09:30 -0500
In-Reply-To: <CAANLjFoHWayCwMi3+n7sGtU_ofeYBVxfqUuJvtOO_NdSMvdRUA@mail.gmail.com>
References: <CAKQB+ftphk7pepLdGEgckLtfj=KBp02cMqdea+R_NTd6Gwn-TA@mail.gmail.com>
         <CA+2bHPaCg4Pq-88hnvnH93QCOfgKv27gDTUjHF5rnDr6Nd2=wQ@mail.gmail.com>
         <CAKQB+fvUCUAeHEHwP06auyK+ZGUHZdRzTT-38xtgsSbQDjyoHQ@mail.gmail.com>
         <CA+2bHPbw3uMLeq77XfjZfhYnYcnF-Gk+Od6UJrTiYkW+g77s4w@mail.gmail.com>
         <alpine.DEB.2.21.1911141900360.17979@piezo.novalocal>
         <CAANLjFoHWayCwMi3+n7sGtU_ofeYBVxfqUuJvtOO_NdSMvdRUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-12-03 at 07:59 -0800, Robert LeBlanc wrote:
> On Thu, Nov 14, 2019 at 11:48 AM Sage Weil <sage@newdream.net> wrote:
> > On Thu, 14 Nov 2019, Patrick Donnelly wrote:
> > > On Wed, Nov 13, 2019 at 6:36 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > > >
> > > > On Thu, 14 Nov 2019 at 07:07, Patrick Donnelly <pdonnell@redhat.com> wrote:
> > > > >
> > > > > On Wed, Nov 13, 2019 at 2:30 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > > > > > Recently, I'm evaluating the snpahsot feature of CephFS from kernel
> > > > > > client and everthing works like a charm.  But, it seems that reverting
> > > > > > a snapshot is not available currently.  Is there some reason or
> > > > > > technical limitation that the feature is not provided?  Any insights
> > > > > > or ideas are appreciated.
> > > > >
> > > > > Please provide more information about what you tried to do (commands
> > > > > run) and how it surprised you.
> > > >
> > > > The thing I would like to do is to rollback a snapped directory to a
> > > > previous version of snapshot.  It looks like the operation can be done
> > > > by over-writting all the current version of files/directories from a
> > > > previous snapshot via cp.  But cp may take lots of time when there are
> > > > many files and directories in the target directory.  Is there any
> > > > possibility to achieve the goal much faster from the CephFS internal
> > > > via command like "ceph fs <cephfs_name> <dir> snap rollback
> > > > <snapname>" (just a example)?  Thank you!
> > > 
> > > RADOS doesn't support rollback of snapshots so it needs to be done
> > > manually. The best tool to do this would probably be rsync of the
> > > .snap directory with appropriate options including deletion of files
> > > that do not exist in the source (snapshot).
> > 
> > rsync is the best bet now, yeah.
> > 
> > RADOS does have a rollback operation that uses clone where it can, but 
> > it's a per-object operation, so something still needs to walk the 
> > hierarchy and roll back each file's content.  The MDS could do this more 
> > efficiently than rsync give what it knows about the snapped inodes 
> > (skipping untouched inodes or, eventually, entire subtrees) but it's a 
> > non-trivial amount of work to implement.
> > 
> 
> Would it make sense to extend CephFS to leverage reflinks for cases like this? That could be faster than rsync and more space efficient. It would require some development time though.
> 

I think reflink would be hard. Ceph hardcodes the inode number into the
object name of the backing objects, so sharing between different inode
numbers is really difficult to do. It could be done, but it means a new
in-object-store layout scheme.

That said...I wonder if we could get better performance by just
converting rsync to use copy_file_range in this situation. That has the
potential to offload a lot of the actual copying work to the OSDs. 
-- 
Jeff Layton <jlayton@kernel.org>

