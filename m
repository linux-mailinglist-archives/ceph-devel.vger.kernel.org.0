Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC072EC2DA
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Jan 2021 18:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbhAFR73 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Jan 2021 12:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbhAFR73 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 12:59:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7284E23123;
        Wed,  6 Jan 2021 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609955928;
        bh=UcHQFlGZVq1ipZlExCUmXU028iG2mHFIhaKHwJoUEhM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k80Hv5Wt7/CEnrx0zdsnqJdCCIhIT7EyLYQSzykmQrK9lxwWHBnVlXYuRs6H+JRhI
         xGit9EPLeZti/Fs/6cwYZWnqYvlBUYruWSD9B4b3U4+muOGaMcctvC5N+UY6KAnAog
         0N41tq9E6KDaYL0ouCuHfZ98GPbmQRXZl0MPMvwgiveKaJhmQ713YyWRe9PFIJWaHa
         D1UTiZdiPRMV8EPNCKzGafmbG490RspDJ4gOcQseJakajSWiaKBl7NEpirGMtwx5vs
         CD7GWSlDqNc6PBxJFQpR51pTbUgKiTrIVkHiOgKIbHXRsdKJ+00RCJGspyt9yQ5+zy
         /4Kb+jvaxgbwQ==
Message-ID: <cd2653125508e1f3eb0dcf423a04b76a1a8be5f3.camel@kernel.org>
Subject: Re: [PATCH] ceph: defer flushing the capsnap if the Fb is used
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 06 Jan 2021 12:58:47 -0500
In-Reply-To: <20210106014726.77614-1-xiubli@redhat.com>
References: <20210106014726.77614-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-01-06 at 09:47 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the Fb cap is used it means the client is flushing the dirty
> data to OSD, just defer flushing the capsnap.
> 
> URL: https://tracker.ceph.com/issues/48679
> URL: https://tracker.ceph.com/issues/48640
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 33 +++++++++++++++++++--------------
>  fs/ceph/snap.c |  6 +++---
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index abbf48fc6230..a61ca9183f41 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3047,6 +3047,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>  {
>  	struct inode *inode = &ci->vfs_inode;
>  	int last = 0, put = 0, flushsnaps = 0, wake = 0;
> +	bool check_flushsnaps = false;
>  
> 
> 
> 
>  	spin_lock(&ci->i_ceph_lock);
>  	if (had & CEPH_CAP_PIN)
> @@ -3063,26 +3064,15 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>  	if (had & CEPH_CAP_FILE_BUFFER) {
>  		if (--ci->i_wb_ref == 0) {
>  			last++;
> -			put++;
> +			check_flushsnaps = true;
>  		}

The "put" variable here is a counter of how many iputs need to be done
at the end of this function. If you just set check_flushsnaps instead of
incrementing "put", then you won't do an iput unless both
__ceph_have_pending_cap_snap and ceph_try_drop_cap_snap both return
true.

In the case where you're not dealing with snapshots at all, is this
going to cause an inode refcount leak?

>  		dout("put_cap_refs %p wb %d -> %d (?)\n",
>  		     inode, ci->i_wb_ref+1, ci->i_wb_ref);
>  	}
> -	if (had & CEPH_CAP_FILE_WR)
> +	if (had & CEPH_CAP_FILE_WR) {
>  		if (--ci->i_wr_ref == 0) {
>  			last++;
> -			if (__ceph_have_pending_cap_snap(ci)) {
> -				struct ceph_cap_snap *capsnap =
> -					list_last_entry(&ci->i_cap_snaps,
> -							struct ceph_cap_snap,
> -							ci_item);
> -				capsnap->writing = 0;
> -				if (ceph_try_drop_cap_snap(ci, capsnap))
> -					put++;
> -				else if (__ceph_finish_cap_snap(ci, capsnap))
> -					flushsnaps = 1;
> -				wake = 1;
> -			}
> +			check_flushsnaps = true;
>  			if (ci->i_wrbuffer_ref_head == 0 &&
>  			    ci->i_dirty_caps == 0 &&
>  			    ci->i_flushing_caps == 0) {
> @@ -3094,6 +3084,21 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>  			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
>  				drop_inode_snap_realm(ci);
>  		}
> +	}
> +	if (check_flushsnaps) {
> +		if (__ceph_have_pending_cap_snap(ci)) {
> +			struct ceph_cap_snap *capsnap =
> +				list_last_entry(&ci->i_cap_snaps,
> +						struct ceph_cap_snap,
> +						ci_item);
> +			capsnap->writing = 0;
> +			if (ceph_try_drop_cap_snap(ci, capsnap))
> +				put++;
> +			else if (__ceph_finish_cap_snap(ci, capsnap))
> +				flushsnaps = 1;
> +			wake = 1;
> +		}
> +	}
>  	spin_unlock(&ci->i_ceph_lock);
>  
> 
> 
> 
>  	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index b611f829cb61..639fb91cc9db 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -561,10 +561,10 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>  	capsnap->context = old_snapc;
>  	list_add_tail(&capsnap->ci_item, &ci->i_cap_snaps);
>  
> 
> 
> 
> -	if (used & CEPH_CAP_FILE_WR) {
> +	if (used & (CEPH_CAP_FILE_WR | CEPH_CAP_FILE_BUFFER)) {
>  		dout("queue_cap_snap %p cap_snap %p snapc %p"
> -		     " seq %llu used WR, now pending\n", inode,
> -		     capsnap, old_snapc, old_snapc->seq);
> +		     " seq %llu used WR | BUFFFER, now pending\n",
> +		     inode, capsnap, old_snapc, old_snapc->seq);
>  		capsnap->writing = 1;
>  	} else {
>  		/* note mtime, size NOW. */

-- 
Jeff Layton <jlayton@kernel.org>

