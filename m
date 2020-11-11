Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E926A2AEF30
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 12:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgKKLIe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Nov 2020 06:08:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:50092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgKKLIe (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 06:08:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 91F92ABD6;
        Wed, 11 Nov 2020 11:08:32 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 57f960c6;
        Wed, 11 Nov 2020 11:08:44 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
References: <20191212173159.35013-1-jlayton@kernel.org>
        <CAAM7YAmquOg5ESMAMa5y0gGAR-UAivYF8m+nqrJNmK=SzG6+wA@mail.gmail.com>
        <64d5a16d920098122144e0df8e03df0cadfb2784.camel@kernel.org>
Date:   Wed, 11 Nov 2020 11:08:44 +0000
In-Reply-To: <64d5a16d920098122144e0df8e03df0cadfb2784.camel@kernel.org> (Jeff
        Layton's message of "Sun, 15 Dec 2019 17:40:21 -0500")
Message-ID: <871rh0f8w3.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Sat, 2019-12-14 at 10:46 +0800, Yan, Zheng wrote:
>> On Fri, Dec 13, 2019 at 1:32 AM Jeff Layton <jlayton@kernel.org> wrote:
>> > I believe it's possible that we could end up with racing calls to
>> > __ceph_remove_cap for the same cap. If that happens, the cap->ci
>> > pointer will be zereoed out and we can hit a NULL pointer dereference.
>> > 
>> > Once we acquire the s_cap_lock, check for the ci pointer being NULL,
>> > and just return without doing anything if it is.
>> > 
>> > URL: https://tracker.ceph.com/issues/43272
>> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> > ---
>> >  fs/ceph/caps.c | 21 ++++++++++++++++-----
>> >  1 file changed, 16 insertions(+), 5 deletions(-)
>> > 
>> > This is the only scenario that made sense to me in light of Ilya's
>> > analysis on the tracker above. I could be off here though -- the locking
>> > around this code is horrifically complex, and I could be missing what
>> > should guard against this scenario.
>> > 
>> 
>> I think the simpler fix is,  in trim_caps_cb, check if cap-ci is
>> non-null before calling __ceph_remove_cap().  this should work because
>> __ceph_remove_cap() is always called inside i_ceph_lock
>> 
>
> Is that sufficient though? The stack trace in the bug shows it being
> called by ceph_trim_caps, but I think we could hit the same problem with
> other __ceph_remove_cap callers, if they happen to race in at the right
> time.

Sorry for resurrecting this old thread, but we just got a report with this
issue on a kernel that includes commit d6e47819721a ("ceph: hold
i_ceph_lock when removing caps for freeing inode").

Looking at the code, I believe Zheng's suggestion should work as I don't
see any __ceph_remove_cap callers that don't hold the i_ceph_lock.  So,
would something like the diff bellow be acceptable?

Cheers,
-- 
Luis


diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8f1d7500a7ec..7dbb73099d2c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1960,7 +1960,8 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
 
 	if (oissued) {
 		/* we aren't the only cap.. just remove us */
-		__ceph_remove_cap(cap, true);
+		if (cap->ci)
+			__ceph_remove_cap(cap, true);
 		(*remaining)--;
 	} else {
 		struct dentry *dentry;


>
>
>> > Thoughts?
>> > 
>> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> > index 9d09bb53c1ab..7e39ee8eff60 100644
>> > --- a/fs/ceph/caps.c
>> > +++ b/fs/ceph/caps.c
>> > @@ -1046,11 +1046,22 @@ static void drop_inode_snap_realm(struct ceph_inode_info *ci)
>> >  void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>> >  {
>> >         struct ceph_mds_session *session = cap->session;
>> > -       struct ceph_inode_info *ci = cap->ci;
>> > -       struct ceph_mds_client *mdsc =
>> > -               ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
>> > +       struct ceph_inode_info *ci;
>> > +       struct ceph_mds_client *mdsc;
>> >         int removed = 0;
>> > 
>> > +       spin_lock(&session->s_cap_lock);
>> > +       ci = cap->ci;
>> > +       if (!ci) {
>> > +               /*
>> > +                * Did we race with a competing __ceph_remove_cap call? If
>> > +                * ci is zeroed out, then just unlock and don't do anything.
>> > +                * Assume that it's on its way out anyway.
>> > +                */
>> > +               spin_unlock(&session->s_cap_lock);
>> > +               return;
>> > +       }
>> > +
>> >         dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>> > 
>> >         /* remove from inode's cap rbtree, and clear auth cap */
>> > @@ -1058,13 +1069,12 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>> >         if (ci->i_auth_cap == cap)
>> >                 ci->i_auth_cap = NULL;
>> > 
>> > -       /* remove from session list */
>> > -       spin_lock(&session->s_cap_lock);
>> >         if (session->s_cap_iterator == cap) {
>> >                 /* not yet, we are iterating over this very cap */
>> >                 dout("__ceph_remove_cap  delaying %p removal from session %p\n",
>> >                      cap, cap->session);
>> >         } else {
>> > +               /* remove from session list */
>> >                 list_del_init(&cap->session_caps);
>> >                 session->s_nr_caps--;
>> >                 cap->session = NULL;
>> > @@ -1072,6 +1082,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>> >         }
>> >         /* protect backpointer with s_cap_lock: see iterate_session_caps */
>> >         cap->ci = NULL;
>> > +       mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
>> > 
>> >         /*
>> >          * s_cap_reconnect is protected by s_cap_lock. no one changes
>> > --
>> > 2.23.0
>> > 
