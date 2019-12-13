Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4A11E2AA
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Dec 2019 12:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfLMLTT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Dec 2019 06:19:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:52320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725937AbfLMLTT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 06:19:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CD13AC45;
        Fri, 13 Dec 2019 11:19:18 +0000 (UTC)
Date:   Fri, 13 Dec 2019 11:19:16 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@redhat.com, ukernel@gmail.com
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
Message-ID: <20191213111916.GA24501@hermes.olymp>
References: <20191212173159.35013-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191212173159.35013-1-jlayton@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 12, 2019 at 12:31:59PM -0500, Jeff Layton wrote:
> I believe it's possible that we could end up with racing calls to
> __ceph_remove_cap for the same cap. If that happens, the cap->ci
> pointer will be zereoed out and we can hit a NULL pointer dereference.
> 
> Once we acquire the s_cap_lock, check for the ci pointer being NULL,
> and just return without doing anything if it is.
> 
> URL: https://tracker.ceph.com/issues/43272
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> This is the only scenario that made sense to me in light of Ilya's
> analysis on the tracker above. I could be off here though -- the locking
> around this code is horrifically complex, and I could be missing what
> should guard against this scenario.
> 
> Thoughts?

This patch _seems_ to make sense.  But, as you said, the locking code is
incredibly complex.  I tried to understand if __send_cap() could have a
similar race by accessing cap->ci without s_cap_lock.  But I couldn't
reach a conclusion :-/

Cheers,
--
Luís

> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 9d09bb53c1ab..7e39ee8eff60 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1046,11 +1046,22 @@ static void drop_inode_snap_realm(struct ceph_inode_info *ci)
>  void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  {
>  	struct ceph_mds_session *session = cap->session;
> -	struct ceph_inode_info *ci = cap->ci;
> -	struct ceph_mds_client *mdsc =
> -		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> +	struct ceph_inode_info *ci;
> +	struct ceph_mds_client *mdsc;
>  	int removed = 0;
>  
> +	spin_lock(&session->s_cap_lock);
> +	ci = cap->ci;
> +	if (!ci) {
> +		/*
> +		 * Did we race with a competing __ceph_remove_cap call? If
> +		 * ci is zeroed out, then just unlock and don't do anything.
> +		 * Assume that it's on its way out anyway.
> +		 */
> +		spin_unlock(&session->s_cap_lock);
> +		return;
> +	}
> +
>  	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>  
>  	/* remove from inode's cap rbtree, and clear auth cap */
> @@ -1058,13 +1069,12 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  	if (ci->i_auth_cap == cap)
>  		ci->i_auth_cap = NULL;
>  
> -	/* remove from session list */
> -	spin_lock(&session->s_cap_lock);
>  	if (session->s_cap_iterator == cap) {
>  		/* not yet, we are iterating over this very cap */
>  		dout("__ceph_remove_cap  delaying %p removal from session %p\n",
>  		     cap, cap->session);
>  	} else {
> +		/* remove from session list */
>  		list_del_init(&cap->session_caps);
>  		session->s_nr_caps--;
>  		cap->session = NULL;
> @@ -1072,6 +1082,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  	}
>  	/* protect backpointer with s_cap_lock: see iterate_session_caps */
>  	cap->ci = NULL;
> +	mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
>  
>  	/*
>  	 * s_cap_reconnect is protected by s_cap_lock. no one changes
> -- 
> 2.23.0
> 
