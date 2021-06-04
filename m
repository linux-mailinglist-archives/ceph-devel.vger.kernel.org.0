Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DC439B60D
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 11:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFDJhW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 05:37:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47338 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFDJhV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Jun 2021 05:37:21 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0B9D321A1B;
        Fri,  4 Jun 2021 09:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622799335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wefwno0cxl0e2CSg7D+vExpnXUds7rgWaIz+lJCG3s8=;
        b=MzsVRfn8Gd7ZbvITWJ3UorHWstGccFeZo6uRzQLs7ERahsS5w6KgtLNWK2rpKQFe3/axCB
        1c+HY1G7zctpv+MR4IerUnZqOhBBQHINKrnYVCE+6CB3HBo/mPpg34eCT3eHJ/Ue7A3ENT
        bL42/qRwX4HFdgQb+7ETe/q4dH4+iXY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622799335;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wefwno0cxl0e2CSg7D+vExpnXUds7rgWaIz+lJCG3s8=;
        b=KWzEZ3o5hsBCkhn0Inzjqrg2dVUuB3PJkfjow6VY5IbXv6/OAW8WVItiAtYvWkhJ5wrYOW
        SkhR8RUunhRbAnBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id B0C62118DD;
        Fri,  4 Jun 2021 09:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622799335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wefwno0cxl0e2CSg7D+vExpnXUds7rgWaIz+lJCG3s8=;
        b=MzsVRfn8Gd7ZbvITWJ3UorHWstGccFeZo6uRzQLs7ERahsS5w6KgtLNWK2rpKQFe3/axCB
        1c+HY1G7zctpv+MR4IerUnZqOhBBQHINKrnYVCE+6CB3HBo/mPpg34eCT3eHJ/Ue7A3ENT
        bL42/qRwX4HFdgQb+7ETe/q4dH4+iXY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622799335;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wefwno0cxl0e2CSg7D+vExpnXUds7rgWaIz+lJCG3s8=;
        b=KWzEZ3o5hsBCkhn0Inzjqrg2dVUuB3PJkfjow6VY5IbXv6/OAW8WVItiAtYvWkhJ5wrYOW
        SkhR8RUunhRbAnBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id /AclKObzuWCAbwAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Fri, 04 Jun 2021 09:35:34 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 57217a94;
        Fri, 4 Jun 2021 09:35:34 +0000 (UTC)
Date:   Fri, 4 Jun 2021 10:35:33 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH] ceph: ensure we flush delayed caps when unmounting
Message-ID: <YLnz5c3xiN/KzRGf@suse.de>
References: <20210603134812.80276-1-jlayton@kernel.org>
 <6cd5b19cbcee46474709a97b273c4270088fb241.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6cd5b19cbcee46474709a97b273c4270088fb241.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 03, 2021 at 12:57:22PM -0400, Jeff Layton wrote:
> On Thu, 2021-06-03 at 09:48 -0400, Jeff Layton wrote:
> > I've seen some warnings when testing recently that indicate that there
> > are caps still delayed on the delayed list even after we've started
> > unmounting.
> > 
> > When checking delayed caps, process the whole list if we're unmounting,
> > and check for delayed caps after setting the stopping var and flushing
> > dirty caps.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c       | 3 ++-
> >  fs/ceph/mds_client.c | 1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index a5e93b185515..68b4c6dfe4db 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -4236,7 +4236,8 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
> >  		ci = list_first_entry(&mdsc->cap_delay_list,
> >  				      struct ceph_inode_info,
> >  				      i_cap_delay_list);
> > -		if ((ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
> > +		if (!mdsc->stopping &&
> > +		    (ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
> >  		    time_before(jiffies, ci->i_hold_caps_max))
> >  			break;
> >  		list_del_init(&ci->i_cap_delay_list);
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index e5af591d3bd4..916af5497829 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -4691,6 +4691,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
> >  
> >  	lock_unlock_sessions(mdsc);
> >  	ceph_flush_dirty_caps(mdsc);
> > +	ceph_check_delayed_caps(mdsc);
> >  	wait_requests(mdsc);
> >  
> >  	/*
> 
> I'm going to self-NAK this patch for now. Initially this looked good in
> testing, but I think it's just papering over the real problem, which is
> that ceph_async_iput can queue a job to a workqueue after the point
> where we've flushed that workqueue on umount.

Ah, yeah.  I think I saw this a few times with generic/014 (and I believe
we chatted about it on irc).  I've been on and off trying to figure out
the way to fix it but it's really tricky.

Cheers,
--
Luís


> I think the right approach is to look at how to ensure that calling iput
> doesn't end up taking these coarse-grained locks so we don't need to
> queue it in so many codepaths.
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
