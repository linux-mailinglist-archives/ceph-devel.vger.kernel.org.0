Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF0B367FFB
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Apr 2021 14:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhDVMDc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Apr 2021 08:03:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:49138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVMDb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 08:03:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1808AAECB;
        Thu, 22 Apr 2021 12:02:56 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id DD5691E37A2; Thu, 22 Apr 2021 14:02:55 +0200 (CEST)
Date:   Thu, 22 Apr 2021 14:02:55 +0200
From:   Jan Kara <jack@suse.cz>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org
Subject: Re: Hole punch races in Ceph
Message-ID: <20210422120255.GH26221@quack2.suse.cz>
References: <20210422111557.GE26221@quack2.suse.cz>
 <fca235a3e2f0fe2a96d0482c3586372a9580c98b.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fca235a3e2f0fe2a96d0482c3586372a9580c98b.camel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu 22-04-21 07:43:16, Jeff Layton wrote:
> On Thu, 2021-04-22 at 13:15 +0200, Jan Kara wrote:
> > Hello,
> > 
> > I'm looking into how Ceph protects against races between page fault and
> > hole punching (I'm unifying protection for this kind of races among
> > filesystems) and AFAICT it does not. What I have in mind in particular is a
> > race like:
> > 
> > CPU1					CPU2
> > 
> > ceph_fallocate()
> >   ...
> >   ceph_zero_pagecache_range()
> > 					ceph_filemap_fault()
> > 					  faults in page in the range being
> > 					  punched
> >   ceph_zero_objects()
> > 
> > And now we have a page in punched range with invalid data. If
> > ceph_page_mkwrite() manages to squeeze in at the right moment, we might
> > even associate invalid metadata with the page I'd assume (but I'm not sure
> > whether this would be harmful). Am I missing something?
> > 
> > 								Honza
> 
> No, I don't think you're missing anything. If ceph_page_mkwrite happens
> to get called at an inopportune time then we'd probably end up writing
> that page back into the punched range too. What would be the best way to
> fix this, do you think?
> 
> One idea:
> 
> We could lock the pages we're planning to punch out first, then
> zero/punch out the objects on the OSDs, and then do the hole punch in
> the pagecache? Would that be sufficient to close the race?

Yes, that would be sufficient but very awkward e.g. if you want to punch
out 4GB of data which even needn't be in the page cache. But all
filesystems have this problem - e.g. ext4, xfs, etc. have already their
private locks to avoid races like this, I'm now working on lifting the
fs-private solutions into a generic one so I'll fix CEPH along the way as
well. I was just making sure I'm not missing some other protection
mechanism in CEPH.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
