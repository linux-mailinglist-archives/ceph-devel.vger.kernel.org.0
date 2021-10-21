Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B71A43691A
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Oct 2021 19:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhJURfk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Oct 2021 13:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231441AbhJURfg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 13:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96A18619E0;
        Thu, 21 Oct 2021 17:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634837600;
        bh=0mi5BRB2iEJx/azT/2b/IU0aHCxCgVOW4BkeyKDBK+4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZKPXTwVYlFc7+FyUKZjxMWGxFgOzAt2/ZqjVl/OvBNsQEhfDukY5lxc24ij0dcFBh
         6JLSOYJpr5jp3GQlLKUs5dSoethZEbInhrBEQLjhkqExwjD9XXPz8PR7Un58BH2rgp
         5FYfpuZlVtAMnMJfrmoS/eg+qIrbT5aVKWdNg3xKWw5/aNkLScpP+sfcmlGB2uAlmr
         y+JVaU4U4Y775/uu68NxdhunJ1jESEltY5a77kAAzslK+iEUpG4KdTeryZY3+Rv+Al
         IfVGZmRmz9wiBn2v5tDlGB5ECj/OpvrAlJGJTDrh7DoGE9YLFNx5yR7+zZxyoG2tF+
         pVtJaSFgBfsjw==
Message-ID: <e49d6160752caf5855dfe5e122cb74cf30cd1b49.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
From:   Jeff Layton <jlayton@kernel.org>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 Oct 2021 13:33:18 -0400
In-Reply-To: <CA+2bHPYacg5yjO9otP5wUVxgwxw+d4hroVQod5VeFUTJNosQ9w@mail.gmail.com>
References: <20211020143708.14728-1-lhenriques@suse.de>
         <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
         <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
         <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
         <CA+2bHPZTazVGtZygdbthQ-AWiC3AN_hsYouhVVs=PDo5iowgTw@mail.gmail.com>
         <e5627f7d9eb9cf2b753136e1187d5d6ff7789389.camel@kernel.org>
         <CA+2bHPYacg5yjO9otP5wUVxgwxw+d4hroVQod5VeFUTJNosQ9w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-10-21 at 13:30 -0400, Patrick Donnelly wrote:
> On Thu, Oct 21, 2021 at 12:35 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
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
> Okay that makes more sense!
> 
> Side note: I am a bit horrified by how computer-unfriendly that
> table-formatted data is.
> 

Not going to disagree with you there. I'm happy to consider patches to
reformat that to be more machine-readable.
-- 
Jeff Layton <jlayton@kernel.org>

