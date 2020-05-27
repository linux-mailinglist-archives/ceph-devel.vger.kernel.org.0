Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D6D1E41E8
	for <lists+ceph-devel@lfdr.de>; Wed, 27 May 2020 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgE0MTl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 May 2020 08:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgE0MTl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 May 2020 08:19:41 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 028A720657;
        Wed, 27 May 2020 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590581980;
        bh=cjAzl/3fvbFTf+NSZ0raki8duGDChciBxrdgnoxVNBM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gK1wT2zVou7edjHkpS8HwuYunfdkqk1MY79dZl96mKinHF0doXv5gO8o3MGkl1srd
         MQ+7W3aq0kY+6YqwG+H6xFKlS2912PPb41PKi6xsjc1WKm5LP9y4dWKynL1/Yb93sA
         mgUnLLJwYbmMr+9ENVjlB2tjbKgMwkFyezX0oSDI=
Message-ID: <a271a1f31b98caa26f634ddc23930ccb7973543c.camel@kernel.org>
Subject: Re: [PATCH v4] ceph: skip checking the caps when session
 reconnecting and releasing reqs
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 27 May 2020 08:19:38 -0400
In-Reply-To: <1590562634-29610-1-git-send-email-xiubli@redhat.com>
References: <1590562634-29610-1-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-05-27 at 02:57 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> It make no sense to check the caps when reconnecting to mds. And
> for the async dirop caps, they will be put by its _cb() function,
> so when releasing the requests, it will make no sense too.
> 
> URL: https://tracker.ceph.com/issues/45635
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> Changed in V2:
> - do not check the caps when reconnecting to mds
> - switch ceph_async_check_caps() to ceph_async_put_cap_refs()
> 
> Changed in V3:
> - fix putting the cap refs leak
> 
> Changed in V4:
> - drop ceph_async_check_caps() stuff.
> 
> 

Sigh. I guess this will fix the original issue, but it's just more
evidence that the locking in this code are an absolute shitshow,
particularly when it comes to the session mutex.

Rather than working around it like this, we ought to be coming up with
ways to reduce the need for the session mutex altogether, particularly
in the cap handling code. Doing that means that we need to identify what
the session mutex actually protects of course, and so far I've not been
very successful in determining that.

Mostly, it looks like it's used to provide high-level serialization much
like the client mutex in libcephfs, but it's per-session, and ends up
having to be inverted wrt the mdsc mutex all over the place.

Maybe instead of this, we ought to look at getting rid of the session
mutex altogether -- fold the existing usage of it into the mdsc->mutex.
We'd end up serializing things even more that way, but the session mutex
is already so coarse-grained that it'd probably not affect performance
that much. It would certainly make the locking a _lot_ simpler.

>  fs/ceph/caps.c       | 15 +++++++++++++--
>  fs/ceph/dir.c        |  2 +-
>  fs/ceph/file.c       |  2 +-
>  fs/ceph/mds_client.c | 14 ++++++++++----
>  fs/ceph/mds_client.h |  3 ++-
>  fs/ceph/super.h      |  2 ++
>  6 files changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 62a066e..cea94cd 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3016,7 +3016,8 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
>   * If we are releasing a WR cap (from a sync write), finalize any affected
>   * cap_snap, and wake up any waiters.
>   */
> -void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
> +static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
> +				bool skip_checking_caps)
>  {
>  	struct inode *inode = &ci->vfs_inode;
>  	int last = 0, put = 0, wake = 0;
> @@ -3072,7 +3073,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
>  	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
>  	     last ? " last" : "", put ? " put" : "");
>  
> -	if (last)
> +	if (last && !skip_checking_caps)
>  		ceph_check_caps(ci, 0, NULL);
>  	if (wake)
>  		wake_up_all(&ci->i_cap_wq);
> @@ -3080,6 +3081,16 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
>  		iput(inode);
>  }
>  
> +void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
> +{
> +	__ceph_put_cap_refs(ci, had, false);
> +}
> +
> +void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
> +{
> +	__ceph_put_cap_refs(ci, had, true);
> +}
> +
>  /*
>   * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
>   * context.  Adjust per-snap dirty page accounting as appropriate.
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 39f5311..9f66ea5 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1079,7 +1079,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
>  	}
>  out:
>  	iput(req->r_old_inode);
> -	ceph_mdsc_release_dir_caps(req);
> +	ceph_mdsc_release_dir_caps(req, false);
>  }
>  
>  static int get_caps_for_async_unlink(struct inode *dir, struct dentry *dentry)
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 160644d..812da94 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -565,7 +565,7 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
>  			req->r_deleg_ino);
>  	}
>  out:
> -	ceph_mdsc_release_dir_caps(req);
> +	ceph_mdsc_release_dir_caps(req, false);
>  }
>  
>  static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 4999a4a..229bc5e 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -804,7 +804,7 @@ void ceph_mdsc_release_request(struct kref *kref)
>  	struct ceph_mds_request *req = container_of(kref,
>  						    struct ceph_mds_request,
>  						    r_kref);
> -	ceph_mdsc_release_dir_caps(req);
> +	ceph_mdsc_release_dir_caps(req, true);
>  	destroy_reply_info(&req->r_reply_info);
>  	if (req->r_request)
>  		ceph_msg_put(req->r_request);
> @@ -3391,14 +3391,20 @@ static void handle_session(struct ceph_mds_session *session,
>  	return;
>  }
>  
> -void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
> +void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req,
> +				bool skip_checking_caps)

Can we add a ceph_mdsc_release_dir_caps_no_check() instead of a boolean
argument? That at least better communicates what the function does to
someone reading the code.

Those can just be wrappers around the function that does take a boolean
if need be (similar to ceph_put_cap_refs[_no_check_caps]).

>  {
>  	int dcaps;
>  
>  	dcaps = xchg(&req->r_dir_caps, 0);
>  	if (dcaps) {
>  		dout("releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
> -		ceph_put_cap_refs(ceph_inode(req->r_parent), dcaps);
> +		if (skip_checking_caps)
> +			ceph_put_cap_refs_no_check_caps(ceph_inode(req->r_parent),
> +							dcaps);
> +		else
> +			ceph_put_cap_refs(ceph_inode(req->r_parent),
> +					  dcaps);
>  	}
>  }
>  
> @@ -3434,7 +3440,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
>  		if (req->r_session->s_mds != session->s_mds)
>  			continue;
>  
> -		ceph_mdsc_release_dir_caps(req);
> +		ceph_mdsc_release_dir_caps(req, true);
>  
>  		__send_request(mdsc, session, req, true);
>  	}
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 43111e4..73ee022 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -506,7 +506,8 @@ extern int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc,
>  extern int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
>  				struct inode *dir,
>  				struct ceph_mds_request *req);
> -extern void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req);
> +extern void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req,
> +				       bool skip_checking_caps);
>  static inline void ceph_mdsc_get_request(struct ceph_mds_request *req)
>  {
>  	kref_get(&req->r_kref);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 226f19c..5a6cdd3 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1095,6 +1095,8 @@ extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
>  				bool snap_rwsem_locked);
>  extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
>  extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
> +extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
> +					    int had);
>  extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>  				       struct ceph_snap_context *snapc);
>  extern void ceph_flush_snaps(struct ceph_inode_info *ci,




-- 
Jeff Layton <jlayton@kernel.org>

