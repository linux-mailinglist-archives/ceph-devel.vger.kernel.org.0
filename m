Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEC13A9F04
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Jun 2021 17:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhFPP2U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Jun 2021 11:28:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39162 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbhFPP2T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Jun 2021 11:28:19 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B62E21FD49;
        Wed, 16 Jun 2021 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2VS9d8/+5D1XtgEKdBgdCocxWedT3pIapSFiMO8cFv0=;
        b=SvKN47SUGxpiXotMUYx7hrdDsI46xuHsz8lVQ/PfG4bNiWbb4qj3ik5sMJFZI+r8l8lCQd
        M7qN2/SaNu+dFQNJzHAQnXt7Zqhk8BjZfVjLSEQ+cIOWQwpWGxjFli8E6R0r0CY6vtNSWp
        ysoCdbHv8/gPUpscyTPYwupdb2aPE9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857172;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2VS9d8/+5D1XtgEKdBgdCocxWedT3pIapSFiMO8cFv0=;
        b=VA8vdWcgYsOfKtjx+QX455Bjh8aHv6nJB5uUZvAKaBBqNdpt5FeP/AjyYSBwGwBJWXcCns
        34u7370g8S9x8eDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 41C75118DD;
        Wed, 16 Jun 2021 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2VS9d8/+5D1XtgEKdBgdCocxWedT3pIapSFiMO8cFv0=;
        b=SvKN47SUGxpiXotMUYx7hrdDsI46xuHsz8lVQ/PfG4bNiWbb4qj3ik5sMJFZI+r8l8lCQd
        M7qN2/SaNu+dFQNJzHAQnXt7Zqhk8BjZfVjLSEQ+cIOWQwpWGxjFli8E6R0r0CY6vtNSWp
        ysoCdbHv8/gPUpscyTPYwupdb2aPE9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857172;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2VS9d8/+5D1XtgEKdBgdCocxWedT3pIapSFiMO8cFv0=;
        b=VA8vdWcgYsOfKtjx+QX455Bjh8aHv6nJB5uUZvAKaBBqNdpt5FeP/AjyYSBwGwBJWXcCns
        34u7370g8S9x8eDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id A/AVDRQYymDHfAAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Wed, 16 Jun 2021 15:26:12 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 1da33df2;
        Wed, 16 Jun 2021 15:26:11 +0000 (UTC)
Date:   Wed, 16 Jun 2021 16:26:11 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, ukernel@gmail.com,
        idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [RFC PATCH 6/6] ceph: eliminate ceph_async_iput()
Message-ID: <YMoYE+DYFt+eEAWm@suse.de>
References: <20210615145730.21952-1-jlayton@kernel.org>
 <20210615145730.21952-7-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210615145730.21952-7-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 15, 2021 at 10:57:30AM -0400, Jeff Layton wrote:
> Now that we don't need to hold session->s_mutex or the snap_rwsem when
> calling ceph_check_caps, we can eliminate ceph_async_iput and just use
> normal iput calls.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       |  6 +++---
>  fs/ceph/inode.c      | 25 +++----------------------
>  fs/ceph/mds_client.c | 22 +++++++++++-----------
>  fs/ceph/quota.c      |  6 +++---
>  fs/ceph/snap.c       | 10 +++++-----
>  fs/ceph/super.h      |  2 --
>  6 files changed, 25 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 5864d5088e27..fd9243e9a1b2 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3147,7 +3147,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>  		wake_up_all(&ci->i_cap_wq);
>  	while (put-- > 0) {
>  		/* avoid calling iput_final() in osd dispatch threads */
> -		ceph_async_iput(inode);
> +		iput(inode);
>  	}
>  }
>  
> @@ -4136,7 +4136,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>  done_unlocked:
>  	ceph_put_string(extra_info.pool_ns);
>  	/* avoid calling iput_final() in mds dispatch threads */
> -	ceph_async_iput(inode);
> +	iput(inode);

To be honest, I'm not really convinced we can blindly substitute
ceph_async_iput() by iput().  This case specifically can problematic
because we may have called ceph_queue_vmtruncate() above (or
handle_cap_grant()).  If we did, we have ci->i_work_mask set and the wq
would have invoked __ceph_do_pending_vmtruncate().  Using the iput() here
won't have that result.  Am I missing something?

Cheers,
--
Luís

>  	return;
>  
>  flush_cap_releases:
> @@ -4179,7 +4179,7 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>  			dout("check_delayed_caps on %p\n", inode);
>  			ceph_check_caps(ci, 0, NULL);
>  			/* avoid calling iput_final() in tick thread */
> -			ceph_async_iput(inode);
> +			iput(inode);
>  			spin_lock(&mdsc->cap_delay_lock);
>  		}
>  	}
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 6034821c9d63..5f1c27caf0b6 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1567,7 +1567,7 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
>  		}
>  
>  		/* avoid calling iput_final() in mds dispatch threads */
> -		ceph_async_iput(in);
> +		iput(in);
>  	}
>  
>  	return err;
> @@ -1770,7 +1770,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  					ihold(in);
>  					discard_new_inode(in);
>  				}
> -				ceph_async_iput(in);
> +				iput(in);
>  			}
>  			d_drop(dn);
>  			err = ret;
> @@ -1783,7 +1783,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  			if (ceph_security_xattr_deadlock(in)) {
>  				dout(" skip splicing dn %p to inode %p"
>  				     " (security xattr deadlock)\n", dn, in);
> -				ceph_async_iput(in);
> +				iput(in);
>  				skipped++;
>  				goto next_item;
>  			}
> @@ -1834,25 +1834,6 @@ bool ceph_inode_set_size(struct inode *inode, loff_t size)
>  	return ret;
>  }
>  
> -/*
> - * Put reference to inode, but avoid calling iput_final() in current thread.
> - * iput_final() may wait for reahahead pages. The wait can cause deadlock in
> - * some contexts.
> - */
> -void ceph_async_iput(struct inode *inode)
> -{
> -	if (!inode)
> -		return;
> -	for (;;) {
> -		if (atomic_add_unless(&inode->i_count, -1, 1))
> -			break;
> -		if (queue_work(ceph_inode_to_client(inode)->inode_wq,
> -			       &ceph_inode(inode)->i_work))
> -			break;
> -		/* queue work failed, i_count must be at least 2 */
> -	}
> -}
> -
>  void ceph_queue_inode_work(struct inode *inode, int work_bit)
>  {
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 87d3be10af25..1f960361b78e 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -825,13 +825,13 @@ void ceph_mdsc_release_request(struct kref *kref)
>  	if (req->r_inode) {
>  		ceph_put_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
>  		/* avoid calling iput_final() in mds dispatch threads */
> -		ceph_async_iput(req->r_inode);
> +		iput(req->r_inode);
>  	}
>  	if (req->r_parent) {
>  		ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
> -		ceph_async_iput(req->r_parent);
> +		iput(req->r_parent);
>  	}
> -	ceph_async_iput(req->r_target_inode);
> +	iput(req->r_target_inode);
>  	if (req->r_dentry)
>  		dput(req->r_dentry);
>  	if (req->r_old_dentry)
> @@ -845,7 +845,7 @@ void ceph_mdsc_release_request(struct kref *kref)
>  		 */
>  		ceph_put_cap_refs(ceph_inode(req->r_old_dentry_dir),
>  				  CEPH_CAP_PIN);
> -		ceph_async_iput(req->r_old_dentry_dir);
> +		iput(req->r_old_dentry_dir);
>  	}
>  	kfree(req->r_path1);
>  	kfree(req->r_path2);
> @@ -961,7 +961,7 @@ static void __unregister_request(struct ceph_mds_client *mdsc,
>  
>  	if (req->r_unsafe_dir) {
>  		/* avoid calling iput_final() in mds dispatch threads */
> -		ceph_async_iput(req->r_unsafe_dir);
> +		iput(req->r_unsafe_dir);
>  		req->r_unsafe_dir = NULL;
>  	}
>  
> @@ -1132,7 +1132,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  		cap = rb_entry(rb_first(&ci->i_caps), struct ceph_cap, ci_node);
>  	if (!cap) {
>  		spin_unlock(&ci->i_ceph_lock);
> -		ceph_async_iput(inode);
> +		iput(inode);
>  		goto random;
>  	}
>  	mds = cap->session->s_mds;
> @@ -1143,7 +1143,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  out:
>  	/* avoid calling iput_final() while holding mdsc->mutex or
>  	 * in mds dispatch threads */
> -	ceph_async_iput(inode);
> +	iput(inode);
>  	return mds;
>  
>  random:
> @@ -1548,7 +1548,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>  		if (last_inode) {
>  			/* avoid calling iput_final() while holding
>  			 * s_mutex or in mds dispatch threads */
> -			ceph_async_iput(last_inode);
> +			iput(last_inode);
>  			last_inode = NULL;
>  		}
>  		if (old_cap) {
> @@ -1582,7 +1582,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>  	session->s_cap_iterator = NULL;
>  	spin_unlock(&session->s_cap_lock);
>  
> -	ceph_async_iput(last_inode);
> +	iput(last_inode);
>  	if (old_cap)
>  		ceph_put_cap(session->s_mdsc, old_cap);
>  
> @@ -1723,7 +1723,7 @@ static void remove_session_caps(struct ceph_mds_session *session)
>  
>  			inode = ceph_find_inode(sb, vino);
>  			 /* avoid calling iput_final() while holding s_mutex */
> -			ceph_async_iput(inode);
> +			iput(inode);
>  
>  			spin_lock(&session->s_cap_lock);
>  		}
> @@ -4370,7 +4370,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>  out:
>  	mutex_unlock(&session->s_mutex);
>  	/* avoid calling iput_final() in mds dispatch threads */
> -	ceph_async_iput(inode);
> +	iput(inode);
>  	return;
>  
>  bad:
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 4e32c9600ecc..988c6e04b327 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -75,7 +75,7 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>  	spin_unlock(&ci->i_ceph_lock);
>  
>  	/* avoid calling iput_final() in dispatch thread */
> -	ceph_async_iput(inode);
> +	iput(inode);
>  }
>  
>  static struct ceph_quotarealm_inode *
> @@ -248,7 +248,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
>  		ci = ceph_inode(in);
>  		has_quota = __ceph_has_any_quota(ci);
>  		/* avoid calling iput_final() while holding mdsc->snap_rwsem */
> -		ceph_async_iput(in);
> +		iput(in);
>  
>  		next = realm->parent;
>  		if (has_quota || !next)
> @@ -384,7 +384,7 @@ static bool check_quota_exceeded(struct inode *inode, enum quota_check_op op,
>  			exceeded = true; /* Just break the loop */
>  		}
>  		/* avoid calling iput_final() while holding mdsc->snap_rwsem */
> -		ceph_async_iput(in);
> +		iput(in);
>  
>  		next = realm->parent;
>  		if (exceeded || !next)
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index afc7f4c32364..f928b02bcd31 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -679,13 +679,13 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
>  		spin_unlock(&realm->inodes_with_caps_lock);
>  		/* avoid calling iput_final() while holding
>  		 * mdsc->snap_rwsem or in mds dispatch threads */
> -		ceph_async_iput(lastinode);
> +		iput(lastinode);
>  		lastinode = inode;
>  		ceph_queue_cap_snap(ci);
>  		spin_lock(&realm->inodes_with_caps_lock);
>  	}
>  	spin_unlock(&realm->inodes_with_caps_lock);
> -	ceph_async_iput(lastinode);
> +	iput(lastinode);
>  
>  	dout("queue_realm_cap_snaps %p %llx done\n", realm, realm->ino);
>  }
> @@ -841,7 +841,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
>  		ceph_flush_snaps(ci, &session);
>  		/* avoid calling iput_final() while holding
>  		 * session->s_mutex or in mds dispatch threads */
> -		ceph_async_iput(inode);
> +		iput(inode);
>  		spin_lock(&mdsc->snap_flush_lock);
>  	}
>  	spin_unlock(&mdsc->snap_flush_lock);
> @@ -985,12 +985,12 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>  
>  			/* avoid calling iput_final() while holding
>  			 * mdsc->snap_rwsem or mds in dispatch threads */
> -			ceph_async_iput(inode);
> +			iput(inode);
>  			continue;
>  
>  skip_inode:
>  			spin_unlock(&ci->i_ceph_lock);
> -			ceph_async_iput(inode);
> +			iput(inode);
>  		}
>  
>  		/* we may have taken some of the old realm's children. */
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 31f0be9120dd..6b6332a5c113 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -988,8 +988,6 @@ extern int ceph_inode_holds_cap(struct inode *inode, int mask);
>  extern bool ceph_inode_set_size(struct inode *inode, loff_t size);
>  extern void __ceph_do_pending_vmtruncate(struct inode *inode);
>  
> -extern void ceph_async_iput(struct inode *inode);
> -
>  void ceph_queue_inode_work(struct inode *inode, int work_bit);
>  
>  static inline void ceph_queue_vmtruncate(struct inode *inode)
> -- 
> 2.31.1
> 
