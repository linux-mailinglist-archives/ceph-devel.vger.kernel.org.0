Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9405439386
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Oct 2021 12:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbhJYKXE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Oct 2021 06:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232720AbhJYKXE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 06:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7F1A60EB9;
        Mon, 25 Oct 2021 10:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635157242;
        bh=vLIB1StnAB/zbNHABDgAdbBZXqyK5QARCCOpr2ElA5E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p8+en/salrcBZHXG4LLGnPGcgrH/L/e9+VC7IR7UJ9LBW6vBKsGAOaD4n0lnD4gt2
         +1/XPMcAeobUNYGgaPc92QObSXK0Xl3DLFHneLT4/gaxd/m6XkneiozRso9tO4kn0D
         wX7/wqj8Syacc93Aei9JYGOS9x3+iZLlhuY8VZoU8F0xDHx+ijUDE/QYWsg+xQvVLa
         r4n9anNYnBqveLVwVgsFJGC2Ir0iAwr0qlCj1L4ED+FE1UK8JZqcQva1WNI/GOE4y9
         6UulzRgXgEVszfVMjWF/VCjGedeYtKGIaYJRUGZWox+EYBna3//ZbZaethUG5SaZuL
         igFR/agy9My3w==
Message-ID: <ee5d8674c5b80668c2de8575ff2b0afcbb463200.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Mon, 25 Oct 2021 06:20:40 -0400
In-Reply-To: <YXaDBFvar4TS+EB8@suse.de>
References: <20211020143708.14728-1-lhenriques@suse.de>
         <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
         <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
         <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
         <CA+2bHPZTazVGtZygdbthQ-AWiC3AN_hsYouhVVs=PDo5iowgTw@mail.gmail.com>
         <e5627f7d9eb9cf2b753136e1187d5d6ff7789389.camel@kernel.org>
         <YXaDBFvar4TS+EB8@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-10-25 at 11:12 +0100, Luís Henriques wrote:
> On Thu, Oct 21, 2021 at 12:35:18PM -0400, Jeff Layton wrote:
> > On Thu, 2021-10-21 at 12:18 -0400, Patrick Donnelly wrote:
> > > On Thu, Oct 21, 2021 at 11:44 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > 
> > > > On Thu, 2021-10-21 at 09:52 -0400, Patrick Donnelly wrote:
> > > > > On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > > 
> > > > > > On Wed, 2021-10-20 at 15:37 +0100, Luís Henriques wrote:
> > > > > > > This counter will keep track of the number of remote object copies done on
> > > > > > > copy_file_range syscalls.  This counter will be filesystem per-client, and
> > > > > > > can be accessed from the client debugfs directory.
> > > > > > > 
> > > > > > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > > > > > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > > > > > > ---
> > > > > > > This is an RFC to reply to Patrick's request in [0].  Note that I'm not
> > > > > > > 100% sure about the usefulness of this patch, or if this is the best way
> > > > > > > to provide the functionality Patrick requested.  Anyway, this is just to
> > > > > > > get some feedback, hence the RFC.
> > > > > > > 
> > > > > > > Cheers,
> > > > > > > --
> > > > > > > Luís
> > > > > > > 
> > > > > > > [0] https://github.com/ceph/ceph/pull/42720
> > > > > > > 
> > > > > > 
> > > > > > I think this would be better integrated into the stats infrastructure.
> > > > > > 
> > > > > > Maybe you could add a new set of "copy" stats to struct
> > > > > > ceph_client_metric that tracks the total copy operations done, their
> > > > > > size and latency (similar to read and write ops)?
> > > > > 
> > > > > I think it's a good idea to integrate this into "stats" but I think a
> > > > > local debugfs file for some counters is still useful. The "stats"
> > > > > module is immature at this time and I'd rather not build any qa tests
> > > > > (yet) that rely on it.
> > > > > 
> > > > > Can we generalize this patch-set to a file named "op_counters" or
> > > > > similar and additionally add other OSD ops performed by the kclient?
> > > > > 
> > > > 
> > > > 
> > > > Tracking this sort of thing is the main purpose of the stats code. I'm
> > > > really not keen on adding a whole separate set of files for reporting
> > > > this.
> > > 
> > > Maybe I'm confused. Is there some "file" which is already used for
> > > this type of debugging information? Or do you mean the code for
> > > sending stats to the MDS to support cephfs-top?
> > > 
> > > > What's the specific problem with relying on the data in debugfs
> > > > "metrics" file?
> > > 
> > > Maybe no problem? I wasn't aware of a "metrics" file.
> > > 
> > 
> > Yes. For instance:
> > 
> > # cat /sys/kernel/debug/ceph/*/metrics
> > item                               total
> > ------------------------------------------
> > opened files  / total inodes       0 / 4
> > pinned i_caps / total inodes       5 / 4
> > opened inodes / total inodes       0 / 4
> > 
> > item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
> > -----------------------------------------------------------------------------------
> > read          0           0               0               0               0
> > write         5           914013          824797          1092343         103476
> > metadata      79          12856           1572            114572          13262
> > 
> > item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)
> > ----------------------------------------------------------------------------------------
> > read          0           0               0               0               0
> > write         5           4194304         4194304         4194304         20971520
> > 
> > item          total           miss            hit
> > -------------------------------------------------
> > d_lease       11              0               29
> > caps          5               68              10702
> > 
> > 
> > I'm proposing that Luis add new lines for "copy" to go along with the
> > "read" and "write" ones. The "total" counter should give you a count of
> > the number of operations.
> 
> The problem with this is that it will require quite some work on the
> MDS-side because, AFAIU, the MDS will need to handle different versions of
> the CEPH_MSG_CLIENT_METRICS message (with and without the new copy-from
> metrics).
> 
> Will this extra metric ever be useful on the MDS side?  From what I
> understood Patrick's initial request was to have a way to find out, on the
> client, if remote copies are really happening.  (*sigh* for not having
> tracepoints.)
> 
> Anyway, I can look into adding this to the metrics infrastructure, but
> it'll likely take me some more time to get to it and to figure out (once
> again) how the messages versioning work.
> 

I think it is useful info to report to the MDS, but it's not required to
send these to the MDS to solve the current problem. My suggestion would
be to add what's needed to track these stats in the kclient and report
them via debugfs, but don't send the info to the MDS just yet.

Later, we could extend the protocol with COPY stats, and add the
necessary infrastructure to the MDS to deal with it. Once that's in
place, we can then extend the kclient to start sending this info along
when it reports the stats.
-- 
Jeff Layton <jlayton@kernel.org>

