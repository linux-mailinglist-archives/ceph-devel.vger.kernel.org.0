Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4EF11FBB0
	for <lists+ceph-devel@lfdr.de>; Sun, 15 Dec 2019 23:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfLOWk0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 15 Dec 2019 17:40:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfLOWkZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 15 Dec 2019 17:40:25 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9ADB24676;
        Sun, 15 Dec 2019 22:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576449624;
        bh=7fvVsjGOXuRarpThwV1NOwYUT+rh8Ev7cYG5o29zMgs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BUODI5BBOGJV5gmrNXfvtEwnCAFsAdlJCgusZf7Z4x7LSwr57v4eHaQVNlGrG54dV
         hBrwIHstIKEiNhYSa2tIieZCu3AcR+UBwJfLAQzUytgQva3zIyOE+6TBWQIYIqTqik
         DkIATFtEMdNrbtnJNW6UD+U2YH8yeSNUah5mHI/w=
Message-ID: <64d5a16d920098122144e0df8e03df0cadfb2784.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Date:   Sun, 15 Dec 2019 17:40:21 -0500
In-Reply-To: <CAAM7YAmquOg5ESMAMa5y0gGAR-UAivYF8m+nqrJNmK=SzG6+wA@mail.gmail.com>
References: <20191212173159.35013-1-jlayton@kernel.org>
         <CAAM7YAmquOg5ESMAMa5y0gGAR-UAivYF8m+nqrJNmK=SzG6+wA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2019-12-14 at 10:46 +0800, Yan, Zheng wrote:
> On Fri, Dec 13, 2019 at 1:32 AM Jeff Layton <jlayton@kernel.org> wrote:
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
> >  fs/ceph/caps.c | 21 ++++++++++++++++-----
> >  1 file changed, 16 insertions(+), 5 deletions(-)
> > 
> > This is the only scenario that made sense to me in light of Ilya's
> > analysis on the tracker above. I could be off here though -- the locking
> > around this code is horrifically complex, and I could be missing what
> > should guard against this scenario.
> > 
> 
> I think the simpler fix is,  in trim_caps_cb, check if cap-ci is
> non-null before calling __ceph_remove_cap().  this should work because
> __ceph_remove_cap() is always called inside i_ceph_lock
> 

Is that sufficient though? The stack trace in the bug shows it being
called by ceph_trim_caps, but I think we could hit the same problem with
other __ceph_remove_cap callers, if they happen to race in at the right
time.


> > Thoughts?
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 9d09bb53c1ab..7e39ee8eff60 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -1046,11 +1046,22 @@ static void drop_inode_snap_realm(struct ceph_inode_info *ci)
> >  void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >  {
> >         struct ceph_mds_session *session = cap->session;
> > -       struct ceph_inode_info *ci = cap->ci;
> > -       struct ceph_mds_client *mdsc =
> > -               ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> > +       struct ceph_inode_info *ci;
> > +       struct ceph_mds_client *mdsc;
> >         int removed = 0;
> > 
> > +       spin_lock(&session->s_cap_lock);
> > +       ci = cap->ci;
> > +       if (!ci) {
> > +               /*
> > +                * Did we race with a competing __ceph_remove_cap call? If
> > +                * ci is zeroed out, then just unlock and don't do anything.
> > +                * Assume that it's on its way out anyway.
> > +                */
> > +               spin_unlock(&session->s_cap_lock);
> > +               return;
> > +       }
> > +
> >         dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
> > 
> >         /* remove from inode's cap rbtree, and clear auth cap */
> > @@ -1058,13 +1069,12 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >         if (ci->i_auth_cap == cap)
> >                 ci->i_auth_cap = NULL;
> > 
> > -       /* remove from session list */
> > -       spin_lock(&session->s_cap_lock);
> >         if (session->s_cap_iterator == cap) {
> >                 /* not yet, we are iterating over this very cap */
> >                 dout("__ceph_remove_cap  delaying %p removal from session %p\n",
> >                      cap, cap->session);
> >         } else {
> > +               /* remove from session list */
> >                 list_del_init(&cap->session_caps);
> >                 session->s_nr_caps--;
> >                 cap->session = NULL;
> > @@ -1072,6 +1082,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >         }
> >         /* protect backpointer with s_cap_lock: see iterate_session_caps */
> >         cap->ci = NULL;
> > +       mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> > 
> >         /*
> >          * s_cap_reconnect is protected by s_cap_lock. no one changes
> > --
> > 2.23.0
> > 

-- 
Jeff Layton <jlayton@kernel.org>

