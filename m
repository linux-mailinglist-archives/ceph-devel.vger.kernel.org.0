Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A601C12E5EB
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Jan 2020 12:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgABL5Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Jan 2020 06:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgABL5Y (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 06:57:24 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D7A20863;
        Thu,  2 Jan 2020 11:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577966242;
        bh=zZpGvJPMCrJlEjbFOw1D+Rpfm5Ys8eAX/E/IbNgEHmU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A4Ohmvqsd4oJyr5XcB2LNwUv3c7AmXcqvUGBSguqOPZX44WtJIWbLDK9+HdKssh7J
         MZuItP9P7DmJCHb3ZlWx1UD0gEfKbrL5B/g6+IaDIF9XFB2NaCy50hR9di1KquymMe
         J2j8EEDc7OLUD4Q0D6QZOKcRwy/4YwKRIAKf/iRc=
Message-ID: <1223804be310293a8697eab9bb1ebd7b8c613bb6.camel@kernel.org>
Subject: Re: [PATCH] ceph: dout switches to hex format for the 'hash'
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Thu, 02 Jan 2020 06:57:21 -0500
In-Reply-To: <20200102030937.59546-1-xiubli@redhat.com>
References: <20200102030937.59546-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-01-01 at 22:09 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> It's hard to read especially when it is:
> 
> ceph:  __choose_mds 00000000b7bc9c15 is_hash=1 (-271041095) mode 0
> 
> At the same time switch to __func__ to get rid of the check patch
> warning.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e209eb9f2efb..b2f3d62f6a78 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -911,7 +911,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  	if (req->r_resend_mds >= 0 &&
>  	    (__have_session(mdsc, req->r_resend_mds) ||
>  	     ceph_mdsmap_get_state(mdsc->mdsmap, req->r_resend_mds) > 0)) {
> -		dout("choose_mds using resend_mds mds%d\n",
> +		dout("%s using resend_mds mds%d\n", __func__,
>  		     req->r_resend_mds);
>  		return req->r_resend_mds;
>  	}
> @@ -929,7 +929,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  			rcu_read_lock();
>  			inode = get_nonsnap_parent(req->r_dentry);
>  			rcu_read_unlock();
> -			dout("__choose_mds using snapdir's parent %p\n", inode);
> +			dout("%s using snapdir's parent %p\n", __func__, inode);
>  		}
>  	} else if (req->r_dentry) {
>  		/* ignore race with rename; old or new d_parent is okay */
> @@ -949,7 +949,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  			/* direct snapped/virtual snapdir requests
>  			 * based on parent dir inode */
>  			inode = get_nonsnap_parent(parent);
> -			dout("__choose_mds using nonsnap parent %p\n", inode);
> +			dout("%s using nonsnap parent %p\n", __func__, inode);
>  		} else {
>  			/* dentry target */
>  			inode = d_inode(req->r_dentry);
> @@ -965,8 +965,8 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  		rcu_read_unlock();
>  	}
>  
> -	dout("__choose_mds %p is_hash=%d (%d) mode %d\n", inode, (int)is_hash,
> -	     (int)hash, mode);
> +	dout("%s %p is_hash=%d (0x%x) mode %d\n", __func__, inode, (int)is_hash,
> +	     hash, mode);
>  	if (!inode)
>  		goto random;
>  	ci = ceph_inode(inode);
> @@ -984,11 +984,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  				get_random_bytes(&r, 1);
>  				r %= frag.ndist;
>  				mds = frag.dist[r];
> -				dout("choose_mds %p %llx.%llx "
> -				     "frag %u mds%d (%d/%d)\n",
> -				     inode, ceph_vinop(inode),
> -				     frag.frag, mds,
> -				     (int)r, frag.ndist);
> +				dout("%s %p %llx.%llx frag %u mds%d (%d/%d)\n",
> +				     __func__, inode, ceph_vinop(inode),
> +				     frag.frag, mds, (int)r, frag.ndist);
>  				if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=
>  				    CEPH_MDS_STATE_ACTIVE &&
>  				    !ceph_mdsmap_is_laggy(mdsc->mdsmap, mds))
> @@ -1001,9 +999,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  			if (frag.mds >= 0) {
>  				/* choose auth mds */
>  				mds = frag.mds;
> -				dout("choose_mds %p %llx.%llx "
> -				     "frag %u mds%d (auth)\n",
> -				     inode, ceph_vinop(inode), frag.frag, mds);
> +				dout("%s %p %llx.%llx frag %u mds%d (auth)\n",
> +				     __func__, inode, ceph_vinop(inode),
> +				     frag.frag, mds);
>  				if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=
>  				    CEPH_MDS_STATE_ACTIVE) {
>  					if (mode == USE_ANY_MDS &&
> @@ -1028,7 +1026,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  		goto random;
>  	}
>  	mds = cap->session->s_mds;
> -	dout("choose_mds %p %llx.%llx mds%d (%scap %p)\n",
> +	dout("%s %p %llx.%llx mds%d (%scap %p)\n", __func__,
>  	     inode, ceph_vinop(inode), mds,
>  	     cap == ci->i_auth_cap ? "auth " : "", cap);
>  	spin_unlock(&ci->i_ceph_lock);
> @@ -1043,7 +1041,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  		*random = true;
>  
>  	mds = ceph_mdsmap_get_random_mds(mdsc->mdsmap);
> -	dout("choose_mds chose random mds%d\n", mds);
> +	dout("%s chose random mds%d\n", __func__, mds);
>  	return mds;
>  }
>  

Thanks! Merged with a slightly revised changelog.
-- 
Jeff Layton <jlayton@kernel.org>

