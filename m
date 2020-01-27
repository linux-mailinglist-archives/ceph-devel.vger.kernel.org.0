Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051A114AA16
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jan 2020 19:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgA0SwC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jan 2020 13:52:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:55068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgA0SwC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 13:52:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8BB7CAEA2;
        Mon, 27 Jan 2020 18:51:59 +0000 (UTC)
Date:   Mon, 27 Jan 2020 18:52:03 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] parallel 'copy-from' Ops in copy_file_range
Message-ID: <20200127185203.GC22545@suse.com>
References: <20200127164321.17468-1-lhenriques@suse.com>
 <CAOi1vP9RBBX9RtnZExk_9JX9-H-8B_2R6TQ6-iR3sRw047PfoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP9RBBX9RtnZExk_9JX9-H-8B_2R6TQ6-iR3sRw047PfoQ@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 27, 2020 at 07:16:17PM +0100, Ilya Dryomov wrote:
> On Mon, Jan 27, 2020 at 5:43 PM Luis Henriques <lhenriques@suse.com> wrote:
> >
> > Hi,
> >
> > As discussed here[1] I'm sending an RFC patchset that does the
> > parallelization of the requests sent to the OSDs during a copy_file_range
> > syscall in CephFS.
> >
> >   [1] https://lore.kernel.org/lkml/20200108100353.23770-1-lhenriques@suse.com/
> >
> > I've also some performance numbers that I wanted to share. Here's a
> > description of the very simple tests I've run:
> >
> >  - create a file with 200 objects in it
> >    * i.e. tests with different object sizes mean different file sizes
> >  - drop all caches and umount the filesystem
> >  - Measure:
> >    * mount filesystem
> >    * full file copy (with copy_file_range)
> >    * umount filesystem
> >
> > Tests were repeated several times and the average value was used for
> > comparison.
> >
> >   DISCLAIMER:
> >   These numbers are only indicative, and different clusters and client
> >   configs will for sure show different performance!  More rigorous tests
> >   would be require to validate these results.
> >
> > Having as baseline a full read+write (basically, a copy_file_range
> > operation within a filesystem mounted without the 'copyfrom' option),
> > here's some values for different object sizes:
> >
> >                           8M      4M      1M      65k
> > read+write              100%    100%    100%     100%
> > sequential               51%     52%     83%    >100%
> > parallel (throttle=1)    51%     52%     83%    >100%
> > parallel (throttle=0)    17%     17%     83%    >100%
> >
> > Notes:
> >
> > - 'parallel (throttle=0)' was a test where *all* the requests (i.e. 200
> >   requests to copy the 200 objects in the file) were sent to the OSDs and
> >   the wait for requests completion is done at the end only.
> >
> > - 'parallel (throttle=1)' was just a control test, where the wait for
> >   completion is done immediately after a request is sent.  It was expected
> >   to be very similar to the non-optimized ('sequential') tests.
> >
> > - These tests were executed on a cluster with 40 OSDs, spread across 5
> >   (bare-metal) nodes.
> >
> > - The tests with object size of 65k show that copy_file_range definitely
> >   doesn't scale to files with small object sizes.  '> 100%' actually means
> >   more than 10x slower.
> >
> > Measuring the mount+copy+umount masks the actual difference between
> > different throttle values due to the time spent in mount+umount.  Thus,
> > there was no real difference between throttle=0 (send all and wait) and
> > throttle=20 (send 20, wait, send 20, ...).  But here's what I observed
> > when measuring only the copy operation (4M object size):
> >
> > read+write              100%
> > parallel (throttle=1)    56%
> > parallel (throttle=5)    23%
> > parallel (throttle=10)   14%
> > parallel (throttle=20)    9%
> > parallel (throttle=5)     5%
> 
> Was this supposed to be throttle=50?

Ups, no it should be throttle=0 (i.e. no throttle).

> >
> > Anyway, I'll still need to revisit patch 0003 as it doesn't follow the
> > suggestion done by Jeff to *not* add another knob to fine-tune the
> > throttle value -- this patch adds a kernel parameter for a knob that I
> > wanted to use in my testing to observe different values of this throttle
> > limit.
> >
> > The goal is to probably to drop this patch and do the throttling in patch
> > 0002.  I just need to come up with a decent heuristic.  Jeff's suggestion
> > was to use rsize/wsize, which are set to 64M by default IIRC.  Somehow I
> > feel that it should be related to the number of OSDs in the cluster
> > instead, but I'm not sure how.  And testing these sort of heuristics would
> > require different clusters, which isn't particularly easy to get.  Anyway,
> > comments are welcome!
> 
> I agree with Jeff, this throttle is certainly not worth a module
> parameter (or a mount option).  I would start with something like
> C * (wsize / object size) and pick C between 1 and 4.

Sure, I also agree with not adding the new parameter or mount option.
It's just tricky to pick (and test!) the best formula to use.  From your
proposal the throttle value would be by default between 16 and 64; those
probably work fine in some situations (for example, in the cluster I used
for running my tests).  But for a really big cluster, with hundreds of
OSDs, it's difficult to say.

Anyway, I'll come up with a proposal for the next revision.  And thanks a
lot for your feedback.

Cheers,
--
Luís
