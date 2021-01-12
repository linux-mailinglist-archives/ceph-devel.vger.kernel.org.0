Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7812F3DF3
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Jan 2021 01:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392300AbhALVte (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Jan 2021 16:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388345AbhALVtc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 16:49:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF2D23122;
        Tue, 12 Jan 2021 21:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610488131;
        bh=+8aGZ1R8+lonnxCub9hBFNdVpOd2DSl9c0qhpVuXx/Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bm6mSxxcurUDVWvG9wmnnRoTVLUivD/KfM+Ik6Os/I3C+/ygQGIxeAduIb9FjcsFg
         tynoB+lqQghoWQnnNl93sOVy64RnSSKqnduisScMcXjsgAPQl6iUfFJUt8IUk4hLVz
         3ErrZrPxtyq5kDr+ls/mwnMsVQBXkcpe9c01EvCWL0BgnA3R7N0d7tUwsbuGwvZLsq
         csghK8G717oihi1IxHEncr6wtbRn+8Eg6pxDIHVru9xidpMmeh6q/hIajvOiaAn3bY
         hbromCIUaK1Zswf0GCVI+hbpF4H9aTjCw5guaLR//8PHKDvBocNP+l9fxE4kmnr9rc
         SqlqA5DLrl9/A==
Message-ID: <f698d039251d444eec334b119b5ae0b0dd101a21.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: defer flushing the capsnap if the Fb is used
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 12 Jan 2021 16:48:49 -0500
In-Reply-To: <20210110020140.141727-1-xiubli@redhat.com>
References: <20210110020140.141727-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2021-01-10 at 10:01 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the Fb cap is used it means the current inode is flushing the
> dirty data to OSD, just defer flushing the capsnap.
> 
> URL: https://tracker.ceph.com/issues/48679
> URL: https://tracker.ceph.com/issues/48640
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V3:
> - Add more comments about putting the inode ref
> - A small change about the code style
> 
> V2:
> - Fix inode reference leak bug
> 
>  fs/ceph/caps.c | 32 +++++++++++++++++++-------------
>  fs/ceph/snap.c |  6 +++---
>  2 files changed, 22 insertions(+), 16 deletions(-)
> 

Hi Xiubo,

This patch seems to cause hangs in some xfstests (generic/013, in
particular). I'll take a closer look when I have a chance, but I'm
dropping this for now.

-- Jeff


> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index abbf48fc6230..b00234cf3b04 100644
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
> @@ -3063,26 +3064,17 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>  	if (had & CEPH_CAP_FILE_BUFFER) {
>  		if (--ci->i_wb_ref == 0) {
>  			last++;
> +			/* put the ref held by ceph_take_cap_refs() */
>  			put++;
> +			check_flushsnaps = true;
>  		}
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
> @@ -3094,6 +3086,20 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>  			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
>  				drop_inode_snap_realm(ci);
>  		}
> +	}
> +	if (check_flushsnaps && __ceph_have_pending_cap_snap(ci)) {
> +		struct ceph_cap_snap *capsnap =
> +			list_last_entry(&ci->i_cap_snaps,
> +					struct ceph_cap_snap,
> +					ci_item);
> +		capsnap->writing = 0;
> +		if (ceph_try_drop_cap_snap(ci, capsnap))
> +		        /* put the ref held by ceph_queue_cap_snap() */
> +			put++;
> +		else if (__ceph_finish_cap_snap(ci, capsnap))
> +			flushsnaps = 1;
> +		wake = 1;
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

