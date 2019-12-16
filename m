Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCA3120740
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2019 14:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfLPNgB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Dec 2019 08:36:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727601AbfLPNgB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 08:36:01 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E852206CB;
        Mon, 16 Dec 2019 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576503360;
        bh=GqZirLs/aD9yUnJgA5+V/Ogf7rPENTb5Jfb2T2t7OlU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n6lHsJ+/qA/KMmYR0+QLSBviM38FwNFb71HpEb9KcTlNnhwCmBZUHXim/H7o1dy0c
         i8i4R3W5wFHGXRBF8sjPdaBA1vyj8meVzLaDSUa8q6jyPvUIDaqgPva7qSNZcpD3N0
         tnHxGVkjybbZAIE0KhcomqzbbDH122toyEBtdf+I=
Message-ID: <fd29229debd759b254dc8e47e4769265a5f64205.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, ukernel@gmail.com
Date:   Mon, 16 Dec 2019 08:35:59 -0500
In-Reply-To: <0a58cb14-1648-6c7e-6e6d-7f6c093f7563@redhat.com>
References: <20191212173159.35013-1-jlayton@kernel.org>
         <0a58cb14-1648-6c7e-6e6d-7f6c093f7563@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-12-16 at 09:57 +0800, Xiubo Li wrote:
> On 2019/12/13 1:31, Jeff Layton wrote:
> > I believe it's possible that we could end up with racing calls to
> > __ceph_remove_cap for the same cap. If that happens, the cap->ci
> > pointer will be zereoed out and we can hit a NULL pointer dereference.
> > 
> > Once we acquire the s_cap_lock, check for the ci pointer being NULL,
> > and just return without doing anything if it is.
> > 
> > URL: https://tracker.ceph.com/issues/43272
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/caps.c | 21 ++++++++++++++++-----
> >   1 file changed, 16 insertions(+), 5 deletions(-)
> > 
> > This is the only scenario that made sense to me in light of Ilya's
> > analysis on the tracker above. I could be off here though -- the locking
> > around this code is horrifically complex, and I could be missing what
> > should guard against this scenario.
> 
> Checked the downstream 3.10.0-862.14.4 code, it seems that when doing 
> trim_caps_cb() and at the same time if the inode is being destroyed we 
> could hit this.
> 

Yes, RHEL7 kernels clearly have this race. We can probably pull in
d6e47819721ae2d9 to fix it there.

> All the __ceph_remove_cap() calls will be protected by the 
> "ci->i_ceph_lock" lock, only except when destroying the inode.
> 
> And the upstream seems have no this problem now.
> 

The only way the i_ceph_lock helps this is if you don't drop it after
you've found the cap in the inode's rbtree.

The only callers that don't hold the i_ceph_lock continuously are the
ceph_iterate_session_caps callbacks. Those however are iterating over
the session->s_caps list, so they shouldn't have a problem there either.

So I agree -- upstream doesn't have this problem and we can drop this
patch. We'll just have to focus on fixing this in RHEL7 instead.

Longer term, I think we need to consider a substantial overhaul of the
cap handling code. The locking in here is much more complex than is
warranted for what this code does. I'll probably start looking at that
once the dust settles on some other efforts.


> 
> > Thoughts?
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 9d09bb53c1ab..7e39ee8eff60 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -1046,11 +1046,22 @@ static void drop_inode_snap_realm(struct ceph_inode_info *ci)
> >   void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >   {
> >   	struct ceph_mds_session *session = cap->session;
> > -	struct ceph_inode_info *ci = cap->ci;
> > -	struct ceph_mds_client *mdsc =
> > -		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> > +	struct ceph_inode_info *ci;
> > +	struct ceph_mds_client *mdsc;
> >   	int removed = 0;
> >   
> > +	spin_lock(&session->s_cap_lock);
> > +	ci = cap->ci;
> > +	if (!ci) {
> > +		/*
> > +		 * Did we race with a competing __ceph_remove_cap call? If
> > +		 * ci is zeroed out, then just unlock and don't do anything.
> > +		 * Assume that it's on its way out anyway.
> > +		 */
> > +		spin_unlock(&session->s_cap_lock);
> > +		return;
> > +	}
> > +
> >   	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
> >   
> >   	/* remove from inode's cap rbtree, and clear auth cap */
> > @@ -1058,13 +1069,12 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >   	if (ci->i_auth_cap == cap)
> >   		ci->i_auth_cap = NULL;
> >   
> > -	/* remove from session list */
> > -	spin_lock(&session->s_cap_lock);
> >   	if (session->s_cap_iterator == cap) {
> >   		/* not yet, we are iterating over this very cap */
> >   		dout("__ceph_remove_cap  delaying %p removal from session %p\n",
> >   		     cap, cap->session);
> >   	} else {
> > +		/* remove from session list */
> >   		list_del_init(&cap->session_caps);
> >   		session->s_nr_caps--;
> >   		cap->session = NULL;
> > @@ -1072,6 +1082,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >   	}
> >   	/* protect backpointer with s_cap_lock: see iterate_session_caps */
> >   	cap->ci = NULL;
> > +	mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> >   
> >   	/*
> >   	 * s_cap_reconnect is protected by s_cap_lock. no one changes
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

