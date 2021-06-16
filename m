Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38803A9EEC
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Jun 2021 17:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhFPP0X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Jun 2021 11:26:23 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44158 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbhFPP0W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Jun 2021 11:26:22 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B71B9219E3;
        Wed, 16 Jun 2021 15:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uE55Stj1l3+KmGLaG2F+6XdCFnJFfxcM+dJaT0dmvHo=;
        b=YQILJJ58IO912usI6m1ueeIId9DWYBAiFZBdAqOcRE6bfJHTxIj6TpWZnm4WZc9UCldTZN
        /gmDbsmvgXwoW8vPxNknJ178A8cMfHcLuL45vur3VIWDNzGjX1rfkjucYT/VuZPeU7kyMl
        W5Dt9rZAOur1Y0klfxe/6cWbY4I8hi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857055;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uE55Stj1l3+KmGLaG2F+6XdCFnJFfxcM+dJaT0dmvHo=;
        b=2D4YJafhiRmjws9za89y2mJ+xSVlSS3O1sveApYBAxbwLoGF/JjLIBu6Jxw9MAbodB3mIg
        6BbljsRysLBsbAAg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 3EE6C118DD;
        Wed, 16 Jun 2021 15:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623857055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uE55Stj1l3+KmGLaG2F+6XdCFnJFfxcM+dJaT0dmvHo=;
        b=YQILJJ58IO912usI6m1ueeIId9DWYBAiFZBdAqOcRE6bfJHTxIj6TpWZnm4WZc9UCldTZN
        /gmDbsmvgXwoW8vPxNknJ178A8cMfHcLuL45vur3VIWDNzGjX1rfkjucYT/VuZPeU7kyMl
        W5Dt9rZAOur1Y0klfxe/6cWbY4I8hi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623857055;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uE55Stj1l3+KmGLaG2F+6XdCFnJFfxcM+dJaT0dmvHo=;
        b=2D4YJafhiRmjws9za89y2mJ+xSVlSS3O1sveApYBAxbwLoGF/JjLIBu6Jxw9MAbodB3mIg
        6BbljsRysLBsbAAg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id ulScC58XymCVewAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Wed, 16 Jun 2021 15:24:15 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 0f60dab0;
        Wed, 16 Jun 2021 15:24:14 +0000 (UTC)
Date:   Wed, 16 Jun 2021 16:24:14 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, ukernel@gmail.com,
        idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [RFC PATCH 1/6] ceph: allow ceph_put_mds_session to take NULL or
 ERR_PTR
Message-ID: <YMoXntSeQ1Kl1B2k@suse.de>
References: <20210615145730.21952-1-jlayton@kernel.org>
 <20210615145730.21952-2-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210615145730.21952-2-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 15, 2021 at 10:57:25AM -0400, Jeff Layton wrote:
> ...to simplify some error paths.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c        | 3 +--
>  fs/ceph/inode.c      | 6 ++----
>  fs/ceph/mds_client.c | 6 ++++--
>  fs/ceph/metric.c     | 3 +--
>  4 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index ac431246e0c9..0dc5f8357f58 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1802,8 +1802,7 @@ static void ceph_d_release(struct dentry *dentry)
>  	dentry->d_fsdata = NULL;
>  	spin_unlock(&dentry->d_lock);
>  
> -	if (di->lease_session)
> -		ceph_put_mds_session(di->lease_session);
> +	ceph_put_mds_session(di->lease_session);
>  	kmem_cache_free(ceph_dentry_cachep, di);
>  }
>  
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index df0c8a724609..6f43542b3344 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1154,8 +1154,7 @@ static inline void update_dentry_lease(struct inode *dir, struct dentry *dentry,
>  	__update_dentry_lease(dir, dentry, lease, session, from_time,
>  			      &old_lease_session);
>  	spin_unlock(&dentry->d_lock);
> -	if (old_lease_session)
> -		ceph_put_mds_session(old_lease_session);
> +	ceph_put_mds_session(old_lease_session);
>  }
>  
>  /*
> @@ -1200,8 +1199,7 @@ static void update_dentry_lease_careful(struct dentry *dentry,
>  			      from_time, &old_lease_session);
>  out_unlock:
>  	spin_unlock(&dentry->d_lock);
> -	if (old_lease_session)
> -		ceph_put_mds_session(old_lease_session);
> +	ceph_put_mds_session(old_lease_session);
>  }
>  
>  /*
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e5af591d3bd4..ec669634c649 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -664,6 +664,9 @@ struct ceph_mds_session *ceph_get_mds_session(struct ceph_mds_session *s)
>  
>  void ceph_put_mds_session(struct ceph_mds_session *s)
>  {
> +	if (IS_ERR_OR_NULL(s))
> +		return;
> +
>  	dout("mdsc put_session %p %d -> %d\n", s,
>  	     refcount_read(&s->s_ref), refcount_read(&s->s_ref)-1);
>  	if (refcount_dec_and_test(&s->s_ref)) {
> @@ -1438,8 +1441,7 @@ static void __open_export_target_sessions(struct ceph_mds_client *mdsc,
>  
>  	for (i = 0; i < mi->num_export_targets; i++) {
>  		ts = __open_export_target_session(mdsc, mi->export_targets[i]);
> -		if (!IS_ERR(ts))
> -			ceph_put_mds_session(ts);
> +		ceph_put_mds_session(ts);
>  	}
>  }
>  
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 9577c71e645d..5ac151eb0d49 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -311,8 +311,7 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>  
>  	cancel_delayed_work_sync(&m->delayed_work);
>  
> -	if (m->session)
> -		ceph_put_mds_session(m->session);
> +	ceph_put_mds_session(m->session);
>  }
>  
>  #define METRIC_UPDATE_MIN_MAX(min, max, new)	\
> -- 
> 2.31.1
> 

LGTM, feel free to add my

Reviewed-by: Luis Henriques <lhenriques@suse.de>

Cheers,
--
Luís
