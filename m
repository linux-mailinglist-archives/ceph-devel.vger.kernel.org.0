Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3310B165EFF
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2020 14:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgBTNmP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Feb 2020 08:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgBTNmP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 08:42:15 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65781206EF;
        Thu, 20 Feb 2020 13:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582206133;
        bh=Re1sk6UAX5U6YPdEGeSguoRb47F1FaFqI1+4b5n35UU=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=LjmNaZ+zqFQRVFJD1ClBU47Y58ukFiLVVZdaEudY/YNVvTDSt8vpHNJpkW5WE3JWM
         S123TsbgL1VamCBly3OtF7wn/axNbG1Tlk7Qc++pu6wgfvoJ5AVwpRsmLGapXFM679
         g4qx4NoEGgy8nPoTvNiGlgEtFFBUQDsPQyqpPLqg=
Message-ID: <ebc63127cc4d7abd9339ab3e72f3b21ae71cf2e8.camel@kernel.org>
Subject: Re: [PATCH 1/4] ceph: always renew caps if mds_wanted is
 insufficient
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Thu, 20 Feb 2020 08:42:12 -0500
In-Reply-To: <20200220122630.63170-1-zyan@redhat.com>
References: <20200220122630.63170-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-20 at 20:26 +0800, Yan, Zheng wrote:
> Not only after mds closes session and caps get dropped. This is
> preparation patch for not requesting caps for idle open files.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>

In this kind of series, it's be nice to add a cover letter that explains
the problem you're trying to solve and how you intend to solve it. I'm
lurking on the bug that I know this involves, but not everyone on the
public mailing list will be familiar with it.

> ---
>  fs/ceph/caps.c       | 36 +++++++++++++++---------------------
>  fs/ceph/mds_client.c |  5 -----
>  fs/ceph/super.h      |  1 -
>  3 files changed, 15 insertions(+), 27 deletions(-)
> 

I do like the diffstat, and that fact that it removes a chunk of code
that I guess is no longer needed.

> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index d05717397c2a..293920d013ff 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2659,6 +2659,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  		}
>  	} else {
>  		int session_readonly = false;
> +		int mds_wanted;
>  		if (ci->i_auth_cap &&
>  		    (need & (CEPH_CAP_FILE_WR | CEPH_CAP_FILE_EXCL))) {
>  			struct ceph_mds_session *s = ci->i_auth_cap->session;
> @@ -2667,32 +2668,27 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  			spin_unlock(&s->s_cap_lock);
>  		}
>  		if (session_readonly) {
> -			dout("get_cap_refs %p needed %s but mds%d readonly\n",
> +			dout("get_cap_refs %p need %s but mds%d readonly\n",
>  			     inode, ceph_cap_string(need), ci->i_auth_cap->mds);
>  			ret = -EROFS;
>  			goto out_unlock;
>  		}
>  
> -		if (ci->i_ceph_flags & CEPH_I_CAP_DROPPED) {
> -			int mds_wanted;
> -			if (READ_ONCE(mdsc->fsc->mount_state) ==
> -			    CEPH_MOUNT_SHUTDOWN) {
> -				dout("get_cap_refs %p forced umount\n", inode);
> -				ret = -EIO;
> -				goto out_unlock;
> -			}
> -			mds_wanted = __ceph_caps_mds_wanted(ci, false);
> -			if (need & ~(mds_wanted & need)) {
> -				dout("get_cap_refs %p caps were dropped"
> -				     " (session killed?)\n", inode);
> -				ret = -ESTALE;
> -				goto out_unlock;
> -			}
> -			if (!(file_wanted & ~mds_wanted))
> -				ci->i_ceph_flags &= ~CEPH_I_CAP_DROPPED;
> +		if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> +			dout("get_cap_refs %p forced umount\n", inode);
> +			ret = -EIO;
> +			goto out_unlock;
> +		}
> +		mds_wanted = __ceph_caps_mds_wanted(ci, false);
> +		if (need & ~mds_wanted) {
> +			dout("get_cap_refs %p need %s > mds_wanted %s\n",
> +			     inode, ceph_cap_string(need),
> +			     ceph_cap_string(mds_wanted));
> +			ret = -ESTALE;
> +			goto out_unlock;

Not directly related to your patch since it did this before, but why
does this cause an -ESTALE return here? ceph seems to have repurposed
the meaning of ESTALE (which usually means "I can't find this inode").

Oh, ok -- it looks like it's being used as an error when the session has
been reconnected.

I think we ought to rework ceph to use a different, more distinct error
code for this purpose that isn't used by exportfs code. I worry that
this could leak into higher layers, when it shouldn't.

include/linux/errno.h has an existing pile of errors to choose from.
Maybe EBADCOOKIE instead? That's only used by the NFS client so it
should be safe for this.

I can look at spinning up a patch for that if you don't want to do it
here.


>  		}
>  
> -		dout("get_cap_refs %p have %s needed %s\n", inode,
> +		dout("get_cap_refs %p have %s need %s\n", inode,
>  		     ceph_cap_string(have), ceph_cap_string(need));
>  	}
>  out_unlock:
> @@ -3646,8 +3642,6 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  		goto out_unlock;
>  
>  	if (target < 0) {
> -		if (cap->mds_wanted | cap->issued)
> -			ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
>  		__ceph_remove_cap(cap, false);
>  		goto out_unlock;
>  	}
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index fab9d6461a65..98d746b3bb53 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1411,8 +1411,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  	dout("removing cap %p, ci is %p, inode is %p\n",
>  	     cap, ci, &ci->vfs_inode);
>  	spin_lock(&ci->i_ceph_lock);
> -	if (cap->mds_wanted | cap->issued)
> -		ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
>  	__ceph_remove_cap(cap, false);
>  	if (!ci->i_auth_cap) {
>  		struct ceph_cap_flush *cf;
> @@ -1578,9 +1576,6 @@ static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
>  			/* mds did not re-issue stale cap */
>  			spin_lock(&ci->i_ceph_lock);
>  			cap->issued = cap->implemented = CEPH_CAP_PIN;
> -			/* make sure mds knows what we want */
> -			if (__ceph_caps_file_wanted(ci) & ~cap->mds_wanted)
> -				ci->i_ceph_flags |= CEPH_I_CAP_DROPPED;
>  			spin_unlock(&ci->i_ceph_lock);
>  		}
>  	} else if (ev == FORCE_RO) {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 37dc1ac8f6c3..d370f89df358 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -517,7 +517,6 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
>  #define CEPH_I_POOL_RD		(1 << 4)  /* can read from pool */
>  #define CEPH_I_POOL_WR		(1 << 5)  /* can write to pool */
>  #define CEPH_I_SEC_INITED	(1 << 6)  /* security initialized */
> -#define CEPH_I_CAP_DROPPED	(1 << 7)  /* caps were forcibly dropped */

This does a lot more than is explained in the changelog. Dropping a flag
wholesale should warrant explaning why. What did this mean before and
why is it no longer relevant?

>  #define CEPH_I_KICK_FLUSH	(1 << 8)  /* kick flushing caps */
>  #define CEPH_I_FLUSH_SNAPS	(1 << 9)  /* need flush snapss */
>  #define CEPH_I_ERROR_WRITE	(1 << 10) /* have seen write errors */

Let's collapse down the number range since you're removing the flag.
There should be no ABI concerns here.
-- 
Jeff Layton <jlayton@kernel.org>

