Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674921667B9
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2020 20:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgBTT5O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Feb 2020 14:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbgBTT5N (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 14:57:13 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFCCA206EF;
        Thu, 20 Feb 2020 19:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582228632;
        bh=aqKS4tLdxHrXB7/Nq9k3/tajEdrySOc4spXmlGcN9n4=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=l0n3qAIKe0ioq4PU5I/tn9xcJ7ANdpcIMe3ORjiCwBXYPc7aJTrbVxGku/ef37hZg
         Q5rELFGD52nHXjkdqMmYSj80d86RXXEoTyQli+h1PP7Uhw38b6BYDcKU1kPSqO+GJy
         BHC7hrFIqXiAoEfi0U2oBEr9pEq89LZyzxTBv8yQ=
Message-ID: <cbe4410ed11bd37e4eb7eac3f8301023f14dd69f.camel@kernel.org>
Subject: Re: [PATCH 4/4] ceph: remove delay check logic from
 ceph_check_caps()
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Thu, 20 Feb 2020 14:57:10 -0500
In-Reply-To: <20200220122630.63170-4-zyan@redhat.com>
References: <20200220122630.63170-1-zyan@redhat.com>
         <20200220122630.63170-4-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-20 at 20:26 +0800, Yan, Zheng wrote:
> __ceph_caps_file_wanted() already checks 'caps_wanted_delay_min' and
> 'caps_wanted_delay_max'. There is no need to duplicte the logic in
> ceph_check_caps() and __send_cap()
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c  | 146 ++++++++++++------------------------------------
>  fs/ceph/file.c  |   5 +-
>  fs/ceph/inode.c |   1 -
>  fs/ceph/super.h |   8 +--
>  4 files changed, 41 insertions(+), 119 deletions(-)
> 

Love that diffstat!

I like this patch overall, but it seems to rely on some of the earlier
ones, so I'll wait for your responses or a v2 set.

I think we'll probably want to merge this before the async dirops
series. This makes some significant changes to the underlying cap
handling and I think it'll be cleanest to adapt the async dirops series
on top of it and then merge it after.

> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 2f4ff7e9508e..39bf41d0fbdb 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -490,13 +490,10 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
>  			       struct ceph_inode_info *ci)
>  {
>  	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
> -
> -	ci->i_hold_caps_min = round_jiffies(jiffies +
> -					    opt->caps_wanted_delay_min * HZ);
>  	ci->i_hold_caps_max = round_jiffies(jiffies +
>  					    opt->caps_wanted_delay_max * HZ);
> -	dout("__cap_set_timeouts %p min %lu max %lu\n", &ci->vfs_inode,
> -	     ci->i_hold_caps_min - jiffies, ci->i_hold_caps_max - jiffies);
> +	dout("__cap_set_timeouts %p %lu\n", &ci->vfs_inode,
> +	     ci->i_hold_caps_max - jiffies);
>  }
>  
>  /*
> @@ -508,8 +505,7 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
>   *    -> we take mdsc->cap_delay_lock
>   */
>  static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
> -				struct ceph_inode_info *ci,
> -				bool set_timeout)
> +				struct ceph_inode_info *ci)
>  {
>  	dout("__cap_delay_requeue %p flags %d at %lu\n", &ci->vfs_inode,
>  	     ci->i_ceph_flags, ci->i_hold_caps_max);
> @@ -520,8 +516,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>  				goto no_change;
>  			list_del_init(&ci->i_cap_delay_list);
>  		}
> -		if (set_timeout)
> -			__cap_set_timeouts(mdsc, ci);
> +		__cap_set_timeouts(mdsc, ci);
>  		list_add_tail(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
>  no_change:
>  		spin_unlock(&mdsc->cap_delay_lock);
> @@ -719,7 +714,7 @@ void ceph_add_cap(struct inode *inode,
>  		dout(" issued %s, mds wanted %s, actual %s, queueing\n",
>  		     ceph_cap_string(issued), ceph_cap_string(wanted),
>  		     ceph_cap_string(actual_wanted));
> -		__cap_delay_requeue(mdsc, ci, true);
> +		__cap_delay_requeue(mdsc, ci);
>  	}
>  
>  	if (flags & CEPH_CAP_FLAG_AUTH) {
> @@ -1299,7 +1294,6 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>  	struct cap_msg_args arg;
>  	int held, revoking;
>  	int wake = 0;
> -	int delayed = 0;
>  	int ret;
>  
>  	held = cap->issued | cap->implemented;
> @@ -1312,28 +1306,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>  	     ceph_cap_string(revoking));
>  	BUG_ON((retain & CEPH_CAP_PIN) == 0);
>  
> -	arg.session = cap->session;
> -
> -	/* don't release wanted unless we've waited a bit. */
> -	if ((ci->i_ceph_flags & CEPH_I_NODELAY) == 0 &&
> -	    time_before(jiffies, ci->i_hold_caps_min)) {
> -		dout(" delaying issued %s -> %s, wanted %s -> %s on send\n",
> -		     ceph_cap_string(cap->issued),
> -		     ceph_cap_string(cap->issued & retain),
> -		     ceph_cap_string(cap->mds_wanted),
> -		     ceph_cap_string(want));
> -		want |= cap->mds_wanted;
> -		retain |= cap->issued;
> -		delayed = 1;
> -	}
> -	ci->i_ceph_flags &= ~(CEPH_I_NODELAY | CEPH_I_FLUSH);
> -	if (want & ~cap->mds_wanted) {
> -		/* user space may open/close single file frequently.
> -		 * This avoids droping mds_wanted immediately after
> -		 * requesting new mds_wanted.
> -		 */
> -		__cap_set_timeouts(mdsc, ci);
> -	}
> +	ci->i_ceph_flags &= ~CEPH_I_FLUSH;
>  
>  	cap->issued &= retain;  /* drop bits we don't want */
>  	if (cap->implemented & ~cap->issued) {
> @@ -1348,6 +1321,7 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>  	cap->implemented &= cap->issued | used;
>  	cap->mds_wanted = want;
>  
> +	arg.session = cap->session;
>  	arg.ino = ceph_vino(inode).ino;
>  	arg.cid = cap->cap_id;
>  	arg.follows = flushing ? ci->i_head_snapc->seq : 0;
> @@ -1408,14 +1382,19 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>  
>  	ret = send_cap_msg(&arg);
>  	if (ret < 0) {
> -		dout("error sending cap msg, must requeue %p\n", inode);
> -		delayed = 1;
> +		pr_err("error sending cap msg, ino (%llx.%llx) "
> +		       "flushing %s tid %llu, requeue\n",
> +		       ceph_vinop(inode), ceph_cap_string(flushing),
> +		       flush_tid);
> +		spin_lock(&ci->i_ceph_lock);
> +		__cap_delay_requeue(mdsc, ci);
> +		spin_unlock(&ci->i_ceph_lock);
>  	}
>  
>  	if (wake)
>  		wake_up_all(&ci->i_cap_wq);
>  
> -	return delayed;
> +	return ret;
>  }
>  
>  static inline int __send_flush_snap(struct inode *inode,
> @@ -1679,7 +1658,7 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>  	if (((was | ci->i_flushing_caps) & CEPH_CAP_FILE_BUFFER) &&
>  	    (mask & CEPH_CAP_FILE_BUFFER))
>  		dirty |= I_DIRTY_DATASYNC;
> -	__cap_delay_requeue(mdsc, ci, true);
> +	__cap_delay_requeue(mdsc, ci);
>  	return dirty;
>  }
>  
> @@ -1830,8 +1809,6 @@ bool __ceph_should_report_size(struct ceph_inode_info *ci)
>   * versus held caps.  Release, flush, ack revoked caps to mds as
>   * appropriate.
>   *
> - *  CHECK_CAPS_NODELAY - caller is delayed work and we should not delay
> - *    cap release further.
>   *  CHECK_CAPS_AUTHONLY - we should only check the auth cap
>   *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, without
>   *    further delay.
> @@ -1850,17 +1827,10 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  	int mds = -1;   /* keep track of how far we've gone through i_caps list
>  			   to avoid an infinite loop on retry */
>  	struct rb_node *p;
> -	int delayed = 0, sent = 0;
> -	bool no_delay = flags & CHECK_CAPS_NODELAY;
>  	bool queue_invalidate = false;
>  	bool tried_invalidate = false;
>  
> -	/* if we are unmounting, flush any unused caps immediately. */
> -	if (mdsc->stopping)
> -		no_delay = true;
> -
>  	spin_lock(&ci->i_ceph_lock);
> -
>  	if (ci->i_ceph_flags & CEPH_I_FLUSH)
>  		flags |= CHECK_CAPS_FLUSH;
>  
> @@ -1906,14 +1876,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  	}
>  
>  	dout("check_caps %p file_want %s used %s dirty %s flushing %s"
> -	     " issued %s revoking %s retain %s %s%s%s\n", inode,
> +	     " issued %s revoking %s retain %s %s%s\n", inode,
>  	     ceph_cap_string(file_wanted),
>  	     ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
>  	     ceph_cap_string(ci->i_flushing_caps),
>  	     ceph_cap_string(issued), ceph_cap_string(revoking),
>  	     ceph_cap_string(retain),
>  	     (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
> -	     (flags & CHECK_CAPS_NODELAY) ? " NODELAY" : "",
>  	     (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "");
>  
>  	/*
> @@ -1921,7 +1890,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  	 * have cached pages, but don't want them, then try to invalidate.
>  	 * If we fail, it's because pages are locked.... try again later.
>  	 */
> -	if ((!no_delay || mdsc->stopping) &&
> +	if ((!(flags & CHECK_CAPS_NOINVAL) || mdsc->stopping) &&
>  	    S_ISREG(inode->i_mode) &&
>  	    !(ci->i_wb_ref || ci->i_wrbuffer_ref) &&   /* no dirty pages... */
>  	    inode->i_data.nrpages &&		/* have cached pages */
> @@ -2001,21 +1970,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  		if ((cap->issued & ~retain) == 0)
>  			continue;     /* nope, all good */
>  
> -		if (no_delay)
> -			goto ack;
> -
> -		/* delay? */
> -		if ((ci->i_ceph_flags & CEPH_I_NODELAY) == 0 &&
> -		    time_before(jiffies, ci->i_hold_caps_max)) {
> -			dout(" delaying issued %s -> %s, wanted %s -> %s\n",
> -			     ceph_cap_string(cap->issued),
> -			     ceph_cap_string(cap->issued & retain),
> -			     ceph_cap_string(cap->mds_wanted),
> -			     ceph_cap_string(want));
> -			delayed++;
> -			continue;
> -		}
> -
>  ack:
>  		if (session && session != cap->session) {
>  			dout("oops, wrong session %p mutex\n", session);
> @@ -2076,24 +2030,18 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  		}
>  
>  		mds = cap->mds;  /* remember mds, so we don't repeat */
> -		sent++;
>  
>  		/* __send_cap drops i_ceph_lock */
> -		delayed += __send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0,
> -				cap_used, want, retain, flushing,
> -				flush_tid, oldest_flush_tid);
> +		__send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> +			   retain, flushing, flush_tid, oldest_flush_tid);
>  		goto retry; /* retake i_ceph_lock and restart our cap scan. */
>  	}
>  
> -	if (list_empty(&ci->i_cap_delay_list)) {
> -	    if (delayed) {
> -		    /* Reschedule delayed caps release if we delayed anything */
> -		    __cap_delay_requeue(mdsc, ci, false);
> -	    } else if ((file_wanted & ~CEPH_CAP_PIN) &&
> -			!(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
> -		    /* periodically re-calculate caps wanted by open files */
> -		    __cap_delay_requeue(mdsc, ci, true);
> -	    }
> +	/* periodically re-calculate caps wanted by open files */
> +	if (list_empty(&ci->i_cap_delay_list) &&
> +	    (file_wanted & ~CEPH_CAP_PIN) &&
> +	    !(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
> +		__cap_delay_requeue(mdsc, ci);
>  	}
>  
>  	spin_unlock(&ci->i_ceph_lock);
> @@ -2123,7 +2071,6 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>  retry_locked:
>  	if (ci->i_dirty_caps && ci->i_auth_cap) {
>  		struct ceph_cap *cap = ci->i_auth_cap;
> -		int delayed;
>  
>  		if (session != cap->session) {
>  			spin_unlock(&ci->i_ceph_lock);
> @@ -2152,18 +2099,10 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
>  						 &oldest_flush_tid);
>  
>  		/* __send_cap drops i_ceph_lock */
> -		delayed = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
> -				     CEPH_CLIENT_CAPS_SYNC,
> -				     __ceph_caps_used(ci),
> -				     __ceph_caps_wanted(ci),
> -				     (cap->issued | cap->implemented),
> -				     flushing, flush_tid, oldest_flush_tid);
> -
> -		if (delayed) {
> -			spin_lock(&ci->i_ceph_lock);
> -			__cap_delay_requeue(mdsc, ci, true);
> -			spin_unlock(&ci->i_ceph_lock);
> -		}
> +		__send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH, CEPH_CLIENT_CAPS_SYNC,
> +			   __ceph_caps_used(ci), __ceph_caps_wanted(ci),
> +			   (cap->issued | cap->implemented),
> +			   flushing, flush_tid, oldest_flush_tid);
>  	} else {
>  		if (!list_empty(&ci->i_cap_flush_list)) {
>  			struct ceph_cap_flush *cf =
> @@ -2363,22 +2302,13 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
>  		if (cf->caps) {
>  			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
>  			     inode, cap, cf->tid, ceph_cap_string(cf->caps));
> -			ci->i_ceph_flags |= CEPH_I_NODELAY;
> -
> -			ret = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
> +			__send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
>  					 (cf->tid < last_snap_flush ?
>  					  CEPH_CLIENT_CAPS_PENDING_CAPSNAP : 0),
>  					  __ceph_caps_used(ci),
>  					  __ceph_caps_wanted(ci),
>  					  (cap->issued | cap->implemented),
>  					  cf->caps, cf->tid, oldest_flush_tid);
> -			if (ret) {
> -				pr_err("kick_flushing_caps: error sending "
> -					"cap flush, ino (%llx.%llx) "
> -					"tid %llu flushing %s\n",
> -					ceph_vinop(inode), cf->tid,
> -					ceph_cap_string(cf->caps));
> -			}
>  		} else {
>  			struct ceph_cap_snap *capsnap =
>  					container_of(cf, struct ceph_cap_snap,
> @@ -2999,7 +2929,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
>  	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
>  	     last ? " last" : "", put ? " put" : "");
>  
> -	if (last && !flushsnaps)
> +	if (last)
>  		ceph_check_caps(ci, 0, NULL);
>  	else if (flushsnaps)
>  		ceph_flush_snaps(ci, NULL);
> @@ -3417,10 +3347,10 @@ static void handle_cap_grant(struct inode *inode,
>  		wake_up_all(&ci->i_cap_wq);
>  
>  	if (check_caps == 1)
> -		ceph_check_caps(ci, CHECK_CAPS_NODELAY|CHECK_CAPS_AUTHONLY,
> +		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL,
>  				session);
>  	else if (check_caps == 2)
> -		ceph_check_caps(ci, CHECK_CAPS_NODELAY, session);
> +		ceph_check_caps(ci, CHECK_CAPS_NOINVAL, session);
>  	else
>  		mutex_unlock(&session->s_mutex);
>  }
> @@ -4095,7 +4025,6 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>  {
>  	struct inode *inode;
>  	struct ceph_inode_info *ci;
> -	int flags = CHECK_CAPS_NODELAY;
>  
>  	dout("check_delayed_caps\n");
>  	while (1) {
> @@ -4115,7 +4044,7 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>  
>  		if (inode) {
>  			dout("check_delayed_caps on %p\n", inode);
> -			ceph_check_caps(ci, flags, NULL);
> +			ceph_check_caps(ci, 0, NULL);
>  			/* avoid calling iput_final() in tick thread */
>  			ceph_async_iput(inode);
>  		}
> @@ -4140,7 +4069,7 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
>  		ihold(inode);
>  		dout("flush_dirty_caps %p\n", inode);
>  		spin_unlock(&mdsc->cap_dirty_lock);
> -		ceph_check_caps(ci, CHECK_CAPS_NODELAY|CHECK_CAPS_FLUSH, NULL);
> +		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>  		iput(inode);
>  		spin_lock(&mdsc->cap_dirty_lock);
>  	}
> @@ -4161,7 +4090,7 @@ void __ceph_touch_fmode(struct ceph_inode_info *ci,
>  
>  	/* queue periodic check */
>  	if (bits && list_empty(&ci->i_cap_delay_list))
> -		__cap_delay_requeue(mdsc, ci, true);
> +		__cap_delay_requeue(mdsc, ci);
>  }
>  
>  void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
> @@ -4210,7 +4139,6 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
>  	if (inode->i_nlink == 1) {
>  		drop |= ~(__ceph_caps_wanted(ci) | CEPH_CAP_PIN);
>  
> -		ci->i_ceph_flags |= CEPH_I_NODELAY;
>  		if (__ceph_caps_dirty(ci)) {
>  			struct ceph_mds_client *mdsc =
>  				ceph_inode_to_client(inode)->mdsc;
> @@ -4266,8 +4194,6 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
>  		if (force || (cap->issued & drop)) {
>  			if (cap->issued & drop) {
>  				int wanted = __ceph_caps_wanted(ci);
> -				if ((ci->i_ceph_flags & CEPH_I_NODELAY) == 0)
> -					wanted |= cap->mds_wanted;
>  				dout("encode_inode_release %p cap %p "
>  				     "%s -> %s, wanted %s -> %s\n", inode, cap,
>  				     ceph_cap_string(cap->issued),
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 60a2dfa02ba2..ed70bb448568 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2129,12 +2129,11 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  
>  	if (endoff > size) {
>  		int caps_flags = 0;
> -
>  		/* Let the MDS know about dst file size change */
> -		if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
> -			caps_flags |= CHECK_CAPS_NODELAY;
>  		if (ceph_inode_set_size(dst_inode, endoff))
>  			caps_flags |= CHECK_CAPS_AUTHONLY;
> +		if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
> +			caps_flags |= CHECK_CAPS_AUTHONLY;
>  		if (caps_flags)
>  			ceph_check_caps(dst_ci, caps_flags, NULL);
>  	}
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index bb73b0c8c4d9..5c8d3b01bc5d 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -471,7 +471,6 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>  	ci->i_prealloc_cap_flush = NULL;
>  	INIT_LIST_HEAD(&ci->i_cap_flush_list);
>  	init_waitqueue_head(&ci->i_cap_wq);
> -	ci->i_hold_caps_min = 0;
>  	ci->i_hold_caps_max = 0;
>  	INIT_LIST_HEAD(&ci->i_cap_delay_list);
>  	INIT_LIST_HEAD(&ci->i_cap_snaps);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 1ea76466efcb..9ddaaeefc6f0 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -170,9 +170,9 @@ struct ceph_cap {
>  	struct list_head caps_item;
>  };
>  
> -#define CHECK_CAPS_NODELAY    1  /* do not delay any further */
> -#define CHECK_CAPS_AUTHONLY   2  /* only check auth cap */
> -#define CHECK_CAPS_FLUSH      4  /* flush any dirty caps */
> +#define CHECK_CAPS_AUTHONLY   1  /* only check auth cap */
> +#define CHECK_CAPS_FLUSH      2  /* flush any dirty caps */
> +#define CHECK_CAPS_NOINVAL    4  /* don't invalidate pagecache */
>  

Some mention of the change to NOINVAL in the changelog would be nice.

>  struct ceph_cap_flush {
>  	u64 tid;
> @@ -352,7 +352,6 @@ struct ceph_inode_info {
>  	struct ceph_cap_flush *i_prealloc_cap_flush;
>  	struct list_head i_cap_flush_list;
>  	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
> -	unsigned long i_hold_caps_min; /* jiffies */

This is also nice.

>  	unsigned long i_hold_caps_max; /* jiffies */
>  	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
>  	struct ceph_cap_reservation i_cap_migration_resv;
> @@ -514,7 +513,6 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
>   * Ceph inode.
>   */
>  #define CEPH_I_DIR_ORDERED	(1 << 0)  /* dentries in dir are ordered */
> -#define CEPH_I_NODELAY		(1 << 1)  /* do not delay cap release */
>  #define CEPH_I_FLUSH		(1 << 2)  /* do not delay flush of dirty metadata */
>  #define CEPH_I_POOL_PERM	(1 << 3)  /* pool rd/wr bits are valid */
>  #define CEPH_I_POOL_RD		(1 << 4)  /* can read from pool */

-- 
Jeff Layton <jlayton@kernel.org>

