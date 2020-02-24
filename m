Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3177A16A9C5
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2020 16:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgBXPR3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Feb 2020 10:17:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbgBXPR3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 10:17:29 -0500
Received: from vulkan (unknown [4.28.11.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC302082F;
        Mon, 24 Feb 2020 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582557448;
        bh=64endsEfyR71cGkO35yeQBxylK/Z89TDigoYnc2d9qc=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=CaVRMxO2eer6Iz4zAH8cbIUNEFT6haOq1CDfuaKeiZC679QBLCdTEPXceV4h1Fpj0
         gSl1DnP11r8f5zhXPO4DJ7V7qagqPq8WwcDSyERrshV3F2CkbZy0UcYDJbaPrRbHUr
         sgAMDJQ8AuF5WN8t82zfmPSZ747vl+6UXLPm074U=
Message-ID: <256363c4d8f3c71973e14911a2b39d8ff9996a98.camel@kernel.org>
Subject: Re: [PATCH v2 1/4] ceph: always renew caps if mds_wanted is
 insufficient
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Mon, 24 Feb 2020 07:17:26 -0800
In-Reply-To: <8126e83a-0732-b44a-6858-4c9cc13c3231@redhat.com>
References: <20200221131659.87777-1-zyan@redhat.com>
         <20200221131659.87777-2-zyan@redhat.com>
         <f1e5924fb183b738e4103130ec1197cacea0047e.camel@kernel.org>
         <8126e83a-0732-b44a-6858-4c9cc13c3231@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-02-24 at 11:17 +0800, Yan, Zheng wrote:
> On 2/22/20 1:17 AM, Jeff Layton wrote:
> > On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
> > > original code only renews caps for inodes with CEPH_I_CAP_DROPPED flags.
> > > The flag indicates that mds closed session and caps were dropped. This
> > > patch is preparation for not requesting caps for idle open files.
> > > 
> > > CEPH_I_CAP_DROPPED is no longer tested by anyone, so this patch also
> > > remove it.
> > > 
> > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > ---
> > >   fs/ceph/caps.c       | 36 +++++++++++++++---------------------
> > >   fs/ceph/mds_client.c |  5 -----
> > >   fs/ceph/super.h      | 11 +++++------
> > >   3 files changed, 20 insertions(+), 32 deletions(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index d05717397c2a..293920d013ff 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -2659,6 +2659,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
> > >   		}
> > >   	} else {
> > >   		int session_readonly = false;
> > > +		int mds_wanted;
> > >   		if (ci->i_auth_cap &&
> > >   		    (need & (CEPH_CAP_FILE_WR | CEPH_CAP_FILE_EXCL))) {
> > >   			struct ceph_mds_session *s = ci->i_auth_cap->session;
> > > @@ -2667,32 +2668,27 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
> > >   			spin_unlock(&s->s_cap_lock);
> > >   		}
> > >   		if (session_readonly) {
> > > -			dout("get_cap_refs %p needed %s but mds%d readonly\n",
> > > +			dout("get_cap_refs %p need %s but mds%d readonly\n",
> > >   			     inode, ceph_cap_string(need), ci->i_auth_cap->mds);
> > >   			ret = -EROFS;
> > >   			goto out_unlock;
> > >   		}
> > >   
> > > -		if (ci->i_ceph_flags & CEPH_I_CAP_DROPPED) {
> > > -			int mds_wanted;
> > > -			if (READ_ONCE(mdsc->fsc->mount_state) ==
> > > -			    CEPH_MOUNT_SHUTDOWN) {
> > > -				dout("get_cap_refs %p forced umount\n", inode);
> > > -				ret = -EIO;
> > > -				goto out_unlock;
> > > -			}
> > > -			mds_wanted = __ceph_caps_mds_wanted(ci, false);
> > > -			if (need & ~(mds_wanted & need)) {
> > > -				dout("get_cap_refs %p caps were dropped"
> > > -				     " (session killed?)\n", inode);
> > > -				ret = -ESTALE;
> > > -				goto out_unlock;
> > > -			}
> > > -			if (!(file_wanted & ~mds_wanted))
> > > -				ci->i_ceph_flags &= ~CEPH_I_CAP_DROPPED;
> > > +		if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> > > +			dout("get_cap_refs %p forced umount\n", inode);
> > > +			ret = -EIO;
> > > +			goto out_unlock;
> > > +		}
> > > +		mds_wanted = __ceph_caps_mds_wanted(ci, false);
> > > +		if (need & ~mds_wanted) {
> > > +			dout("get_cap_refs %p need %s > mds_wanted %s\n",
> > > +			     inode, ceph_cap_string(need),
> > > +			     ceph_cap_string(mds_wanted));
> > > +			ret = -ESTALE;
> > > +			goto out_unlock;
> > >   		}
> > >   
> > 
> > I was able to reproduce softlockups with xfstests reliably for a little
> > while, but it doesn't always happen. I bisected it down to this patch
> > though. I suspect the problem is in the hunk above. It looks like it's
> > getting into a situation where this is continually returning ESTALE.
> > 
> > I cranked up debug logging in this function and I see this:
> > 
> > [  259.284839] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> > [  259.284848] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> > [  259.284855] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> > [  259.284863] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284868] ceph:  get_cap_refs 000000003d7d65fa need Fr > mds_wanted -
> > [  259.284877] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284885] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284890] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284899] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> > [  259.284908] ceph:  get_cap_refs 000000003d7d65fa need Fr > mds_wanted -
> > [  259.284918] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284926] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284945] ceph:  get_cap_refs 000000003d7d65fa need Fr > mds_wanted -
> > [  259.284950] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284961] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284969] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > [  259.284975] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> > [  259.284984] ceph:  get_cap_refs 000000003d7d65fa need Fr > mds_wanted -
> > [  259.284994] ceph:  get_cap_refs 000000003d7d65fa ret -116 got -
> > [  259.285003] ceph:  get_cap_refs 000000003d7d65fa need Fr want Fc
> > 
> 
> Looks like ceph_check_caps did update caps' mds_wanted. Did you test 
> this patch with async dirops patches? please try reproducing this issue 
> again with debug log of try_get_cap_refs(), ceph_check_caps() and 
> ceph_renew_caps().
> 
> 

I tried with and without async dirops and was able to reproduce it
either way. It seems like the issue is that the mds_wanted set is not
being updated properly when we end up in in get_cap_refs.

I'm traveling at the moment though and won't be able to reproduce this
until I'm back at work (Thursday).


> 
> > ...not sure I understand the logical flow in this function well enough
> > to suggest a fix yet though.
> > 
> > > -		dout("get_cap_refs %p have %s needed %s\n", inode,
> > > +		dout("get_cap_refs %p have %s need %s\n", inode,
> > >   		     ceph_cap_string(have), ceph_cap_string(need));
> > >   	}
> > >   out_unlock:
> > > @@ -3646,8 +3642,6 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
> > >   		goto out_unlock;
> > >   
> > >   	if (target < 0) {
> > > -		if (cap->mds_wanted | cap->issued)
> > > -			ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
> > >   		__ceph_remove_cap(cap, false);
> > >   		goto out_unlock;
> > >   	}
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index fab9d6461a65..98d746b3bb53 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -1411,8 +1411,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >   	dout("removing cap %p, ci is %p, inode is %p\n",
> > >   	     cap, ci, &ci->vfs_inode);
> > >   	spin_lock(&ci->i_ceph_lock);
> > > -	if (cap->mds_wanted | cap->issued)
> > > -		ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
> > >   	__ceph_remove_cap(cap, false);
> > >   	if (!ci->i_auth_cap) {
> > >   		struct ceph_cap_flush *cf;
> > > @@ -1578,9 +1576,6 @@ static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
> > >   			/* mds did not re-issue stale cap */
> > >   			spin_lock(&ci->i_ceph_lock);
> > >   			cap->issued = cap->implemented = CEPH_CAP_PIN;
> > > -			/* make sure mds knows what we want */
> > > -			if (__ceph_caps_file_wanted(ci) & ~cap->mds_wanted)
> > > -				ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
> > >   			spin_unlock(&ci->i_ceph_lock);
> > >   		}
> > >   	} else if (ev == FORCE_RO) {
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 37dc1ac8f6c3..48e84d7f48a0 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -517,12 +517,11 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
> > >   #define CEPH_I_POOL_RD		(1 << 4)  /* can read from pool */
> > >   #define CEPH_I_POOL_WR		(1 << 5)  /* can write to pool */
> > >   #define CEPH_I_SEC_INITED	(1 << 6)  /* security initialized */
> > > -#define CEPH_I_CAP_DROPPED	(1 << 7)  /* caps were forcibly dropped */
> > > -#define CEPH_I_KICK_FLUSH	(1 << 8)  /* kick flushing caps */
> > > -#define CEPH_I_FLUSH_SNAPS	(1 << 9)  /* need flush snapss */
> > > -#define CEPH_I_ERROR_WRITE	(1 << 10) /* have seen write errors */
> > > -#define CEPH_I_ERROR_FILELOCK	(1 << 11) /* have seen file lock errors */
> > > -#define CEPH_I_ODIRECT		(1 << 12) /* inode in direct I/O mode */
> > > +#define CEPH_I_KICK_FLUSH	(1 << 7)  /* kick flushing caps */
> > > +#define CEPH_I_FLUSH_SNAPS	(1 << 8)  /* need flush snapss */
> > > +#define CEPH_I_ERROR_WRITE	(1 << 9)  /* have seen write errors */
> > > +#define CEPH_I_ERROR_FILELOCK	(1 << 10) /* have seen file lock errors */
> > > +#define CEPH_I_ODIRECT		(1 << 11) /* inode in direct I/O mode */
> > >   
> > >   /*
> > >    * Masks of ceph inode work.

