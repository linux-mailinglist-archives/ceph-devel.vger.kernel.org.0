Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB683A9EF0
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Jun 2021 17:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhFPP1Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Jun 2021 11:27:25 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39032 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbhFPP1V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Jun 2021 11:27:21 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 735721FD49;
        Wed, 16 Jun 2021 15:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/4Vl/okx93h8RnHxW4EvKyGsksvqXwj6vdm84oSqLqE=;
        b=eIJGDk6rcHG5jenfscY/f1j0J1ek2H2XkeI5Asm/P8dJFMw81j8NPMk/mvBmMKurNEgXOx
        pnjg64XvpsEX7J4p2OwppeSS3b50PWz37UufVKHcIlZkIE4JmeQvw2eYvwU5f8w4XaiwDu
        QJS2/Z72VyAWl8tc3cdVhsic0lbYtgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857114;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/4Vl/okx93h8RnHxW4EvKyGsksvqXwj6vdm84oSqLqE=;
        b=ui/LiAkDKvjZp4W+OfAPVjW3A2OhJ0OqeTeThilliV66LjEm7Nd4nSIFXvbIu2ceL8r7hR
        wepbpGHPvciKDdDQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 02A67118DD;
        Wed, 16 Jun 2021 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/4Vl/okx93h8RnHxW4EvKyGsksvqXwj6vdm84oSqLqE=;
        b=eIJGDk6rcHG5jenfscY/f1j0J1ek2H2XkeI5Asm/P8dJFMw81j8NPMk/mvBmMKurNEgXOx
        pnjg64XvpsEX7J4p2OwppeSS3b50PWz37UufVKHcIlZkIE4JmeQvw2eYvwU5f8w4XaiwDu
        QJS2/Z72VyAWl8tc3cdVhsic0lbYtgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857114;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/4Vl/okx93h8RnHxW4EvKyGsksvqXwj6vdm84oSqLqE=;
        b=ui/LiAkDKvjZp4W+OfAPVjW3A2OhJ0OqeTeThilliV66LjEm7Nd4nSIFXvbIu2ceL8r7hR
        wepbpGHPvciKDdDQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id xDRbOdkXymBLfAAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Wed, 16 Jun 2021 15:25:13 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 112fadd9;
        Wed, 16 Jun 2021 15:25:13 +0000 (UTC)
Date:   Wed, 16 Jun 2021 16:25:13 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, ukernel@gmail.com,
        idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [RFC PATCH 3/6] ceph: don't take s_mutex or snap_rwsem in
 ceph_check_caps
Message-ID: <YMoX2cchyhHSbzhT@suse.de>
References: <20210615145730.21952-1-jlayton@kernel.org>
 <20210615145730.21952-4-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210615145730.21952-4-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 15, 2021 at 10:57:27AM -0400, Jeff Layton wrote:
> These locks appear to be completely unnecessary. Almost all of this
> function is done under the inode->i_ceph_lock, aside from the actual
> sending of the message. Don't take either lock in this function.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 61 ++++++--------------------------------------------
>  1 file changed, 7 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 919eada97a1f..825b1e463ad3 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1912,7 +1912,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  	struct ceph_cap *cap;
>  	u64 flush_tid, oldest_flush_tid;
>  	int file_wanted, used, cap_used;
> -	int took_snap_rwsem = 0;             /* true if mdsc->snap_rwsem held */
>  	int issued, implemented, want, retain, revoking, flushing = 0;
>  	int mds = -1;   /* keep track of how far we've gone through i_caps list
>  			   to avoid an infinite loop on retry */
> @@ -1920,6 +1919,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  	bool queue_invalidate = false;
>  	bool tried_invalidate = false;
>  
> +	if (session)
> +		ceph_get_mds_session(session);
> +
>  	spin_lock(&ci->i_ceph_lock);
>  	if (ci->i_ceph_flags & CEPH_I_FLUSH)
>  		flags |= CHECK_CAPS_FLUSH;
> @@ -2021,8 +2023,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  		    ((flags & CHECK_CAPS_AUTHONLY) && cap != ci->i_auth_cap))
>  			continue;
>  
> -		/* NOTE: no side-effects allowed, until we take s_mutex */
> -
>  		/*
>  		 * If we have an auth cap, we don't need to consider any
>  		 * overlapping caps as used.
> @@ -2085,37 +2085,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  			continue;     /* nope, all good */
>  
>  ack:
> -		if (session && session != cap->session) {
> -			dout("oops, wrong session %p mutex\n", session);
> -			mutex_unlock(&session->s_mutex);
> -			session = NULL;
> -		}
> -		if (!session) {
> -			session = cap->session;
> -			if (mutex_trylock(&session->s_mutex) == 0) {
> -				dout("inverting session/ino locks on %p\n",
> -				     session);
> -				session = ceph_get_mds_session(session);
> -				spin_unlock(&ci->i_ceph_lock);
> -				if (took_snap_rwsem) {
> -					up_read(&mdsc->snap_rwsem);
> -					took_snap_rwsem = 0;
> -				}
> -				if (session) {
> -					mutex_lock(&session->s_mutex);
> -					ceph_put_mds_session(session);
> -				} else {
> -					/*
> -					 * Because we take the reference while
> -					 * holding the i_ceph_lock, it should
> -					 * never be NULL. Throw a warning if it
> -					 * ever is.
> -					 */
> -					WARN_ON_ONCE(true);
> -				}
> -				goto retry;
> -			}
> -		}
> +		ceph_put_mds_session(session);
> +		session = ceph_get_mds_session(cap->session);
>  
>  		/* kick flushing and flush snaps before sending normal
>  		 * cap message */
> @@ -2130,19 +2101,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  			goto retry_locked;
>  		}
>  
> -		/* take snap_rwsem after session mutex */
> -		if (!took_snap_rwsem) {
> -			if (down_read_trylock(&mdsc->snap_rwsem) == 0) {
> -				dout("inverting snap/in locks on %p\n",
> -				     inode);
> -				spin_unlock(&ci->i_ceph_lock);
> -				down_read(&mdsc->snap_rwsem);
> -				took_snap_rwsem = 1;
> -				goto retry;
> -			}
> -			took_snap_rwsem = 1;
> -		}
> -
>  		if (cap == ci->i_auth_cap && ci->i_dirty_caps) {
>  			flushing = ci->i_dirty_caps;
>  			flush_tid = __mark_caps_flushing(inode, session, false,
> @@ -2179,13 +2137,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  
>  	spin_unlock(&ci->i_ceph_lock);
>  
> +	ceph_put_mds_session(session);
>  	if (queue_invalidate)
>  		ceph_queue_invalidate(inode);
> -
> -	if (session)
> -		mutex_unlock(&session->s_mutex);
> -	if (took_snap_rwsem)
> -		up_read(&mdsc->snap_rwsem);
>  }
>  
>  /*
> @@ -3550,13 +3504,12 @@ static void handle_cap_grant(struct inode *inode,
>  	if (wake)
>  		wake_up_all(&ci->i_cap_wq);
>  
> +	mutex_unlock(&session->s_mutex);
>  	if (check_caps == 1)
>  		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL,
>  				session);
>  	else if (check_caps == 2)
>  		ceph_check_caps(ci, CHECK_CAPS_NOINVAL, session);
> -	else
> -		mutex_unlock(&session->s_mutex);
>  }
>  
>  /*
> -- 
> 2.31.1
> 

Ugh, this is a tricky one.  I couldn't find anything wrong but... yeah,
here it is:

Reviewed-by: Luis Henriques <lhenriques@suse.de>

(Suggestion: remove the 'retry/retry_locked' goto dance and simply lock
i_ceph_lock in the only 'goto retry' call.)

Cheers,
--
Luís
