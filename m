Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003623B75C6
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 17:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhF2Pm0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 11:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233460AbhF2PmZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 11:42:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B53561D5D;
        Tue, 29 Jun 2021 15:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624981197;
        bh=k7fK7EG5YPnqbm2o8+w9qiuUzF29iqGlFHFqGtqw4Ck=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nClv1lQD++uQVSfYwGsdLZxcYpLPxdc4zADaoER03QgX56c4DXQolSxgPrnah4Xl7
         TSBcfnMxlrcoyWL8JpB+gyjcA8nYGmytFlJuQ5DEAzmmRbi+15ou9ykDjAsClZi8Ok
         xp/4eD2o2crww71DBVGYryGQYSfvoYjsWoIvYS8/HHfCtdZBPsLMTc35uSHHmBvWhq
         S+gajf2Z0zZxlZrOJoPujgyn/aoqnIaZtoR/feLDSbRAHWwCVwZ9LHbXhvbgnBqXMB
         Ums7WGQBap/eFI0PSh8INg+KFTHcgcd5zO9R6VnbJ7JLqXBQLoe1tqaP1xOfAkkWYM
         Vih5Kc1YyczIg==
Message-ID: <0d114802ce33ec63fa4ef09053e31d410de194d4.camel@kernel.org>
Subject: Re: [PATCH 2/5] ceph: export iterate_sessions
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 29 Jun 2021 11:39:56 -0400
In-Reply-To: <20210629044241.30359-3-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
         <20210629044241.30359-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 26 +-----------------------
>  fs/ceph/mds_client.c | 47 +++++++++++++++++++++++++++++---------------
>  fs/ceph/mds_client.h |  3 +++
>  3 files changed, 35 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index e712826ea3f1..c6a3352a4d52 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4280,33 +4280,9 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>  	dout("flush_dirty_caps done\n");
>  }
>  
> -static void iterate_sessions(struct ceph_mds_client *mdsc,
> -			     void (*cb)(struct ceph_mds_session *))
> -{
> -	int mds;
> -
> -	mutex_lock(&mdsc->mutex);
> -	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
> -		struct ceph_mds_session *s;
> -
> -		if (!mdsc->sessions[mds])
> -			continue;
> -
> -		s = ceph_get_mds_session(mdsc->sessions[mds]);
> -		if (!s)
> -			continue;
> -
> -		mutex_unlock(&mdsc->mutex);
> -		cb(s);
> -		ceph_put_mds_session(s);
> -		mutex_lock(&mdsc->mutex);
> -	}
> -	mutex_unlock(&mdsc->mutex);
> -}
> -
>  void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
>  {
> -	iterate_sessions(mdsc, flush_dirty_session_caps);
> +	ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
>  }
>  
>  void __ceph_touch_fmode(struct ceph_inode_info *ci,
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e49d3e230712..96bef289f58f 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -802,6 +802,33 @@ static void put_request_session(struct ceph_mds_request *req)
>  	}
>  }
>  
> +void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
> +			       void (*cb)(struct ceph_mds_session *),
> +			       bool check_state)
> +{
> +	int mds;
> +
> +	mutex_lock(&mdsc->mutex);
> +	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
> +		struct ceph_mds_session *s;
> +
> +		s = __ceph_lookup_mds_session(mdsc, mds);
> +		if (!s)
> +			continue;
> +
> +		if (check_state && !check_session_state(s)) {
> +			ceph_put_mds_session(s);
> +			continue;
> +		}
> +
> +		mutex_unlock(&mdsc->mutex);
> +		cb(s);
> +		ceph_put_mds_session(s);
> +		mutex_lock(&mdsc->mutex);
> +	}
> +	mutex_unlock(&mdsc->mutex);
> +}
> +
>  void ceph_mdsc_release_request(struct kref *kref)
>  {
>  	struct ceph_mds_request *req = container_of(kref,
> @@ -4416,22 +4443,10 @@ void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
>  /*
>   * lock unlock sessions, to wait ongoing session activities
>   */
> -static void lock_unlock_sessions(struct ceph_mds_client *mdsc)
> +static void lock_unlock_session(struct ceph_mds_session *s)
>  {
> -	int i;
> -
> -	mutex_lock(&mdsc->mutex);
> -	for (i = 0; i < mdsc->max_sessions; i++) {
> -		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
> -		if (!s)
> -			continue;
> -		mutex_unlock(&mdsc->mutex);
> -		mutex_lock(&s->s_mutex);
> -		mutex_unlock(&s->s_mutex);
> -		ceph_put_mds_session(s);
> -		mutex_lock(&mdsc->mutex);
> -	}
> -	mutex_unlock(&mdsc->mutex);
> +	mutex_lock(&s->s_mutex);
> +	mutex_unlock(&s->s_mutex);
>  }
>  

Your patch doesn't materially change this, but it sure would be nice to
know what purpose this lock/unlock garbage serves. Barf.

>  static void maybe_recover_session(struct ceph_mds_client *mdsc)
> @@ -4683,7 +4698,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>  	dout("pre_umount\n");
>  	mdsc->stopping = 1;
>  
> -	lock_unlock_sessions(mdsc);
> +	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>  	ceph_flush_dirty_caps(mdsc);
>  	wait_requests(mdsc);
>  
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index bf2683f0ba43..fca2cf427eaf 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -523,6 +523,9 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
>  	kref_put(&req->r_kref, ceph_mdsc_release_request);
>  }
>  
> +extern void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
> +				       void (*cb)(struct ceph_mds_session *),
> +				       bool check_state);
>  extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
>  extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
>  				    struct ceph_cap *cap);

Again, not really exporting this function, so maybe reword the subject
line?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

