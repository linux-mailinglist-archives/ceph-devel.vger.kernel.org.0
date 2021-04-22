Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3BA368007
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Apr 2021 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhDVMFu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Apr 2021 08:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236064AbhDVMFs (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 08:05:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7962961422;
        Thu, 22 Apr 2021 12:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619093113;
        bh=FbZLAzi+FMiBNWM2uKDOaAZnMei+xieMEiz71giP4oo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r69oAHCAbs80Mvcuk5niIdyUSQdB695NkP2hNx604QtIcrvQ3dQ0OSpwKnGoW/S5S
         KQX5zbnUfUWccUdMLGPcAi0UCAxm+5s1eftUE9X3wbUumSVdZLUqYj+gOtF84kp8+Q
         cVOCJgX+Sir/LD79aS8ZLtH6A9WRP4UeN4YAQ3M2MWFxjDHIGettzjGzmVlmwxwyDT
         WMY1psuccKhqpJ5yseuu91thCMvFhrmLgFBoyXK9pGqLWanvtqoTrIPFcfHvQl95SK
         w9fgt6nu714XvxJHQ/vDRUC8gS/9xm9rCc7j1Ld0vkZ3p5c3dUUZRqSk1XRsaA/JeA
         OMGjZU6hbAMww==
Message-ID: <8f2e47965340c4a5dcd7e6b025b1bcd7a588f058.camel@kernel.org>
Subject: Re: Hole punch races in Ceph
From:   Jeff Layton <jlayton@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Thu, 22 Apr 2021 08:05:12 -0400
In-Reply-To: <20210422120255.GH26221@quack2.suse.cz>
References: <20210422111557.GE26221@quack2.suse.cz>
         <fca235a3e2f0fe2a96d0482c3586372a9580c98b.camel@kernel.org>
         <20210422120255.GH26221@quack2.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-04-22 at 14:02 +0200, Jan Kara wrote:
> On Thu 22-04-21 07:43:16, Jeff Layton wrote:
> > On Thu, 2021-04-22 at 13:15 +0200, Jan Kara wrote:
> > > Hello,
> > > 
> > > I'm looking into how Ceph protects against races between page fault and
> > > hole punching (I'm unifying protection for this kind of races among
> > > filesystems) and AFAICT it does not. What I have in mind in particular is a
> > > race like:
> > > 
> > > CPU1					CPU2
> > > 
> > > ceph_fallocate()
> > >   ...
> > >   ceph_zero_pagecache_range()
> > > 					ceph_filemap_fault()
> > > 					  faults in page in the range being
> > > 					  punched
> > >   ceph_zero_objects()
> > > 
> > > And now we have a page in punched range with invalid data. If
> > > ceph_page_mkwrite() manages to squeeze in at the right moment, we might
> > > even associate invalid metadata with the page I'd assume (but I'm not sure
> > > whether this would be harmful). Am I missing something?
> > > 
> > > 								Honza
> > 
> > No, I don't think you're missing anything. If ceph_page_mkwrite happens
> > to get called at an inopportune time then we'd probably end up writing
> > that page back into the punched range too. What would be the best way to
> > fix this, do you think?
> > 
> > One idea:
> > 
> > We could lock the pages we're planning to punch out first, then
> > zero/punch out the objects on the OSDs, and then do the hole punch in
> > the pagecache? Would that be sufficient to close the race?
> 
> Yes, that would be sufficient but very awkward e.g. if you want to punch
> out 4GB of data which even needn't be in the page cache. But all
> filesystems have this problem - e.g. ext4, xfs, etc. have already their
> private locks to avoid races like this, I'm now working on lifting the
> fs-private solutions into a generic one so I'll fix CEPH along the way as
> well. I was just making sure I'm not missing some other protection
> mechanism in CEPH.
> 

Even better! I'll keep an eye out for your patches.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

