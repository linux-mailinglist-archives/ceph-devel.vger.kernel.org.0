Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D274111B5A
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 23:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfLCWID (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 17:08:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:53026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727578AbfLCWIC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 17:08:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 065DFB3375;
        Tue,  3 Dec 2019 22:08:00 +0000 (UTC)
Date:   Tue, 3 Dec 2019 22:07:58 +0000
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Robert LeBlanc <robert@leblancnet.us>,
        Sage Weil <sage@newdream.net>,
        Jerry Lee <leisurelysw24@gmail.com>,
        Ceph Users <ceph-users@lists.ceph.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: [ceph-users] Revert a CephFS snapshot?
Message-ID: <20191203220758.GA19557@hermes.olymp>
References: <CAKQB+ftphk7pepLdGEgckLtfj=KBp02cMqdea+R_NTd6Gwn-TA@mail.gmail.com>
 <CA+2bHPaCg4Pq-88hnvnH93QCOfgKv27gDTUjHF5rnDr6Nd2=wQ@mail.gmail.com>
 <CAKQB+fvUCUAeHEHwP06auyK+ZGUHZdRzTT-38xtgsSbQDjyoHQ@mail.gmail.com>
 <CA+2bHPbw3uMLeq77XfjZfhYnYcnF-Gk+Od6UJrTiYkW+g77s4w@mail.gmail.com>
 <alpine.DEB.2.21.1911141900360.17979@piezo.novalocal>
 <CAANLjFoHWayCwMi3+n7sGtU_ofeYBVxfqUuJvtOO_NdSMvdRUA@mail.gmail.com>
 <3f37461a0bdd94e9068526fa9a722fdf65c37fdf.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f37461a0bdd94e9068526fa9a722fdf65c37fdf.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 03, 2019 at 02:09:30PM -0500, Jeff Layton wrote:
> On Tue, 2019-12-03 at 07:59 -0800, Robert LeBlanc wrote:
> > On Thu, Nov 14, 2019 at 11:48 AM Sage Weil <sage@newdream.net> wrote:
> > > On Thu, 14 Nov 2019, Patrick Donnelly wrote:
> > > > On Wed, Nov 13, 2019 at 6:36 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > > > >
> > > > > On Thu, 14 Nov 2019 at 07:07, Patrick Donnelly <pdonnell@redhat.com> wrote:
> > > > > >
> > > > > > On Wed, Nov 13, 2019 at 2:30 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > > > > > > Recently, I'm evaluating the snpahsot feature of CephFS from kernel
> > > > > > > client and everthing works like a charm.  But, it seems that reverting
> > > > > > > a snapshot is not available currently.  Is there some reason or
> > > > > > > technical limitation that the feature is not provided?  Any insights
> > > > > > > or ideas are appreciated.
> > > > > >
> > > > > > Please provide more information about what you tried to do (commands
> > > > > > run) and how it surprised you.
> > > > >
> > > > > The thing I would like to do is to rollback a snapped directory to a
> > > > > previous version of snapshot.  It looks like the operation can be done
> > > > > by over-writting all the current version of files/directories from a
> > > > > previous snapshot via cp.  But cp may take lots of time when there are
> > > > > many files and directories in the target directory.  Is there any
> > > > > possibility to achieve the goal much faster from the CephFS internal
> > > > > via command like "ceph fs <cephfs_name> <dir> snap rollback
> > > > > <snapname>" (just a example)?  Thank you!
> > > > 
> > > > RADOS doesn't support rollback of snapshots so it needs to be done
> > > > manually. The best tool to do this would probably be rsync of the
> > > > .snap directory with appropriate options including deletion of files
> > > > that do not exist in the source (snapshot).
> > > 
> > > rsync is the best bet now, yeah.
> > > 
> > > RADOS does have a rollback operation that uses clone where it can, but 
> > > it's a per-object operation, so something still needs to walk the 
> > > hierarchy and roll back each file's content.  The MDS could do this more 
> > > efficiently than rsync give what it knows about the snapped inodes 
> > > (skipping untouched inodes or, eventually, entire subtrees) but it's a 
> > > non-trivial amount of work to implement.
> > > 
> > 
> > Would it make sense to extend CephFS to leverage reflinks for cases like this? That could be faster than rsync and more space efficient. It would require some development time though.
> > 
> 
> I think reflink would be hard. Ceph hardcodes the inode number into the
> object name of the backing objects, so sharing between different inode
> numbers is really difficult to do. It could be done, but it means a new
> in-object-store layout scheme.
> 
> That said...I wonder if we could get better performance by just
> converting rsync to use copy_file_range in this situation. That has the
> potential to offload a lot of the actual copying work to the OSDs. 

Just to add my 2 cents, I haven't done any serious performance
measurements with copy_file_range.  However, the very limited
observations I've done surprised me a bit, showing that performance
isn't great.  In fact, when file objects size is small, using
copy_file_range seems to be slower than a full read+write cycle.

It's still on my TODO list to do some more serious performance analysis
and figure out why.  It didn't seemed to be an issue on the client side,
but I don't really have any real evidences.  Once the COPY_FROM2
operation is stable, I can plan to spend some time on this.

Cheers,
--
Luís
