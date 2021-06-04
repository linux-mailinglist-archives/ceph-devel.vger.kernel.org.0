Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2474539B8FB
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 14:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhFDM2J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 08:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFDM2J (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 08:28:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 140ED61405;
        Fri,  4 Jun 2021 12:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622809583;
        bh=Zy+dQEdANSqpRB4HgJq0QoB1lm/L7iTxlX2KguowZ9c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eIHiqJITC7Ggx0Vio6w8aJ4lhZ/cLd6SA0tP/eqcq3Vb1YRXfQiSG+z7StOF/pcDo
         7LDMl+1PEoP03HM5phS9PgWGr4kWgJYeAnuUPSF8sGVzqbthdXEiYkzL4Rbv92kYfX
         1l4X2JLbolLvFbAhzmhfq3nnF1/HtB3pqx32qSW2ld1kVVfxgm2/Ykk0iex8BDR948
         q+kiJRObhh8z8qTyQjy/mgD8Ex1fmLc81+wRoi0+DyIv7V8kmEkXzPsd3M1+pS8PLg
         OZ0uSPwA6fjqqd0I5KrNRmixSnsytoQsjPYzWSnUWzVzdl/Kw8wCG41pGr+ieGPeDt
         GU7RJvsy/jhWQ==
Message-ID: <77df0b922c9d02e371cbe9d2a6308eeab408abab.camel@kernel.org>
Subject: Re: [PATCH] ceph: ensure we flush delayed caps when unmounting
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Date:   Fri, 04 Jun 2021 08:26:21 -0400
In-Reply-To: <YLnz5c3xiN/KzRGf@suse.de>
References: <20210603134812.80276-1-jlayton@kernel.org>
         <6cd5b19cbcee46474709a97b273c4270088fb241.camel@kernel.org>
         <YLnz5c3xiN/KzRGf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-06-04 at 10:35 +0100, Luis Henriques wrote:
> On Thu, Jun 03, 2021 at 12:57:22PM -0400, Jeff Layton wrote:
> > On Thu, 2021-06-03 at 09:48 -0400, Jeff Layton wrote:
> > > I've seen some warnings when testing recently that indicate that there
> > > are caps still delayed on the delayed list even after we've started
> > > unmounting.
> > > 
> > > When checking delayed caps, process the whole list if we're unmounting,
> > > and check for delayed caps after setting the stopping var and flushing
> > > dirty caps.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/caps.c       | 3 ++-
> > >  fs/ceph/mds_client.c | 1 +
> > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index a5e93b185515..68b4c6dfe4db 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -4236,7 +4236,8 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
> > >  		ci = list_first_entry(&mdsc->cap_delay_list,
> > >  				      struct ceph_inode_info,
> > >  				      i_cap_delay_list);
> > > -		if ((ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
> > > +		if (!mdsc->stopping &&
> > > +		    (ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
> > >  		    time_before(jiffies, ci->i_hold_caps_max))
> > >  			break;
> > >  		list_del_init(&ci->i_cap_delay_list);
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index e5af591d3bd4..916af5497829 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -4691,6 +4691,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
> > >  
> > >  	lock_unlock_sessions(mdsc);
> > >  	ceph_flush_dirty_caps(mdsc);
> > > +	ceph_check_delayed_caps(mdsc);
> > >  	wait_requests(mdsc);
> > >  
> > >  	/*
> > 
> > I'm going to self-NAK this patch for now. Initially this looked good in
> > testing, but I think it's just papering over the real problem, which is
> > that ceph_async_iput can queue a job to a workqueue after the point
> > where we've flushed that workqueue on umount.
> 
> Ah, yeah.  I think I saw this a few times with generic/014 (and I believe
> we chatted about it on irc).  I've been on and off trying to figure out
> the way to fix it but it's really tricky.
> 

Yeah, that's putting it mildly. 

The biggest issue here is the session->s_mutex, which is held over large
swaths of the code, but it's not fully clear what it protects. The
original patch that added ceph_async_iput did it to avoid the session
mutex that gets held for ceph_iterate_session_caps.

My current thinking is that we probably don't need to hold the session
mutex over that function in some cases, if we can guarantee that the
ceph_cap objects we're iterating over don't go away when the lock is
dropped. So, I'm trying to add some refcounting to the ceph_cap
structures themselves to see if that helps.

It may turn out to be a dead end, but if we don't chip away at the edges
of the fundamental problem, we'll never get there...

-- 
Jeff Layton <jlayton@kernel.org>

