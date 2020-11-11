Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9CC2AF32B
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 15:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgKKOL2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 11 Nov 2020 09:11:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:47640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgKKOL1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 09:11:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 18975AC83;
        Wed, 11 Nov 2020 14:11:26 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id a63d49fd;
        Wed, 11 Nov 2020 14:11:38 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
References: <20191212173159.35013-1-jlayton@kernel.org>
        <CAAM7YAmquOg5ESMAMa5y0gGAR-UAivYF8m+nqrJNmK=SzG6+wA@mail.gmail.com>
        <64d5a16d920098122144e0df8e03df0cadfb2784.camel@kernel.org>
        <871rh0f8w3.fsf@suse.de>
        <05512d3c3bf95eb551ea8ae4982b180f8c4deb0d.camel@kernel.org>
Date:   Wed, 11 Nov 2020 14:11:37 +0000
In-Reply-To: <05512d3c3bf95eb551ea8ae4982b180f8c4deb0d.camel@kernel.org> (Jeff
        Layton's message of "Wed, 11 Nov 2020 08:09:17 -0500")
Message-ID: <87mtzodluu.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Wed, 2020-11-11 at 11:08 +0000, Luis Henriques wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>> 
>> > On Sat, 2019-12-14 at 10:46 +0800, Yan, Zheng wrote:
>> > > On Fri, Dec 13, 2019 at 1:32 AM Jeff Layton <jlayton@kernel.org> wrote:
>> > > > I believe it's possible that we could end up with racing calls to
>> > > > __ceph_remove_cap for the same cap. If that happens, the cap->ci
>> > > > pointer will be zereoed out and we can hit a NULL pointer dereference.
>> > > > 
>> > > > Once we acquire the s_cap_lock, check for the ci pointer being NULL,
>> > > > and just return without doing anything if it is.
>> > > > 
>> > > > URL: https://tracker.ceph.com/issues/43272
>> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> > > > ---
>> > > >  fs/ceph/caps.c | 21 ++++++++++++++++-----
>> > > >  1 file changed, 16 insertions(+), 5 deletions(-)
>> > > > 
>> > > > This is the only scenario that made sense to me in light of Ilya's
>> > > > analysis on the tracker above. I could be off here though -- the locking
>> > > > around this code is horrifically complex, and I could be missing what
>> > > > should guard against this scenario.
>> > > > 
>> > > 
>> > > I think the simpler fix is,  in trim_caps_cb, check if cap-ci is
>> > > non-null before calling __ceph_remove_cap().  this should work because
>> > > __ceph_remove_cap() is always called inside i_ceph_lock
>> > > 
>> > 
>> > Is that sufficient though? The stack trace in the bug shows it being
>> > called by ceph_trim_caps, but I think we could hit the same problem with
>> > other __ceph_remove_cap callers, if they happen to race in at the right
>> > time.
>> 
>> Sorry for resurrecting this old thread, but we just got a report with this
>> issue on a kernel that includes commit d6e47819721a ("ceph: hold
>> i_ceph_lock when removing caps for freeing inode").
>> 
>> Looking at the code, I believe Zheng's suggestion should work as I don't
>> see any __ceph_remove_cap callers that don't hold the i_ceph_lock.  So,
>> would something like the diff bellow be acceptable?
>> 
>> Cheers,
>
> I'm still not convinced that's the correct fix.
>
> Why would trim_caps_cb be subject to this race when other
> __ceph_remove_cap callers are not? Maybe the right fix is to test for a
> NULL cap->ci in __ceph_remove_cap and just return early if it is?

I see, you're probably right.  Looking again at the code I see that there
are two possible places where this race could occur, and they're both used
as callbacks in ceph_iterate_session_caps.  They are trim_caps_cb and
remove_session_caps_cb.

These callbacks get the struct ceph_cap as argument and only then they
will acquire i_ceph_lock.  Since this isn't protected with
session->s_cap_lock, I guess this could be where the race window is, where
cap->ci can be set to NULL.

Bellow is the patch you suggested.  If you think that's acceptable I can
resend with a proper commit message.

Cheers,
-- 
Luis

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ded4229c314a..917dfaf0bd01 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1140,12 +1140,17 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 {
 	struct ceph_mds_session *session = cap->session;
 	struct ceph_inode_info *ci = cap->ci;
-	struct ceph_mds_client *mdsc =
-		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
+	struct ceph_mds_client *mdsc;
+
 	int removed = 0;
 
+	if (!ci)
+		return;
+
 	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
 
+	mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
+
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
 	if (ci->i_auth_cap == cap) {
