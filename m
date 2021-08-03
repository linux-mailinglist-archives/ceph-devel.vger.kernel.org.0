Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247F73DF4C5
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Aug 2021 20:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbhHCSdf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Aug 2021 14:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238805AbhHCSdf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 14:33:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B4960F58;
        Tue,  3 Aug 2021 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628015604;
        bh=toozmtvUhVrMco0lzgHU84Dsm3DfzwHJMIAE4P6Z/A8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ntD2aH0E6w9PMexLuvQj41RoRTF2xMEB6g7Uurq8K4dyc0vau28LOqv4X2WlOaGsW
         HOT52/1LFhvAUr0bMb2gAvuVEluSIj+75tTJNMbQh0UQtp1ZDU/2r/F/k9Ujkq+HGJ
         QZJflAGVOG2wXb0VIRcWDH9qqwgaMlqFfn1fBi7FH31yEU8ffRPU2sEd/kaMk+SDxI
         OlVrh9pQUFYRObVaH/DKA3DrnUuP6oX+UV+g9HL0NoLCli9Q1fRL+YzTnwjIQo6pCs
         cx/agQbaazExu6jUJY/yZ8PmADzERrTF2B7laVTiXF49huBBnvibkEi8jySpXmU9QT
         9TGILYK5EF5MA==
Message-ID: <05ed962c013a62dbe1b17dcc19bb02a454bdb094.camel@kernel.org>
Subject: Re: [PATCH] ceph: ensure we take snap_empty_lock atomically with
 refcount change
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Sage Weil <sage@redhat.com>,
        Mark Nelson <mnelson@redhat.com>
Date:   Tue, 03 Aug 2021 14:33:22 -0400
In-Reply-To: <20210803175126.29165-1-jlayton@kernel.org>
References: <20210803175126.29165-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-08-03 at 13:51 -0400, Jeff Layton wrote:
> There is a race in ceph_put_snap_realm. The change to the nref and the
> spinlock acquisition are not done atomically, so you could change nref,
> and before you take the spinlock, the nref is incremented again. At that
> point, you end up putting it on the empty list when it shouldn't be
> there. Eventually __cleanup_empty_realms runs and frees it when it's
> still in-use.
> 
> Fix this by protecting the 1->0 transition with atomic_dec_and_lock,
> which should ensure that the race can't occur.
> 
> Because these objects can also undergo a 0->1 refcount transition, we
> must protect that change as well with the spinlock. Increment locklessly
> unless the value is at 0, in which case we take the spinlock, increment
> and then take it off the empty list.
> 
> With these changes, I'm removing the dout() messages from these
> functions as well. They've always been racy, and it's better to not
> print values that may be misleading.
> 
> Cc: Sage Weil <sage@redhat.com>
> Reported-by: Mark Nelson <mnelson@redhat.com>
> URL: https://tracker.ceph.com/issues/46419
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/snap.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 9dbc92cfda38..c81ba22711a5 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -67,19 +67,20 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
>  {
>  	lockdep_assert_held(&mdsc->snap_rwsem);
>  
> -	dout("get_realm %p %d -> %d\n", realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
>  	/*
> -	 * since we _only_ increment realm refs or empty the empty
> -	 * list with snap_rwsem held, adjusting the empty list here is
> -	 * safe.  we do need to protect against concurrent empty list
> -	 * additions, however.
> +	 * The 0->1 and 1->0 transitions must take the snap_empty_lock
> +	 * atomically with the refcount change. Go ahead and bump the
> +	 * nref * here, unless it's 0, in which case we take the

I've cleaned up the comment block above before I merged this into the
testing branch. I've also marked this for stable kernels as well.

> +	 * spinlock and then do the increment and remove it from the
> +	 * list.
>  	 */
> -	if (atomic_inc_return(&realm->nref) == 1) {
> -		spin_lock(&mdsc->snap_empty_lock);
> +	if (atomic_add_unless(&realm->nref, 1, 0))
> +		return;
> +
> +	spin_lock(&mdsc->snap_empty_lock);
> +	if (atomic_inc_return(&realm->nref) == 1)
>  		list_del_init(&realm->empty_item);
> -		spin_unlock(&mdsc->snap_empty_lock);
> -	}
> +	spin_unlock(&mdsc->snap_empty_lock);
>  }
>  
>  static void __insert_snap_realm(struct rb_root *root,
> @@ -215,21 +216,19 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
>  }
>  
>  /*
> - * caller needn't hold any locks
> + * See comments in ceph_get_snap_realm. Caller needn't hold any locks.
>   */
>  void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
>  			 struct ceph_snap_realm *realm)
>  {
> -	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> -	if (!atomic_dec_and_test(&realm->nref))
> +	if (!atomic_dec_and_lock(&realm->nref, &mdsc->snap_empty_lock))
>  		return;
>  
>  	if (down_write_trylock(&mdsc->snap_rwsem)) {
> +		spin_unlock(&mdsc->snap_empty_lock);
>  		__destroy_snap_realm(mdsc, realm);
>  		up_write(&mdsc->snap_rwsem);
>  	} else {
> -		spin_lock(&mdsc->snap_empty_lock);
>  		list_add(&realm->empty_item, &mdsc->snap_empty);
>  		spin_unlock(&mdsc->snap_empty_lock);
>  	}

-- 
Jeff Layton <jlayton@kernel.org>

