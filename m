Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816873F4BFE
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Aug 2021 15:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhHWN7v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 09:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhHWN7v (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 09:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21F3E613A5;
        Mon, 23 Aug 2021 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629727148;
        bh=fEHAcaDwI+NpKLTpy2wkpaBoLDbxaBGuvz/UsaKwvvY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ujx9QwuxSLVYhjMRrI91TFR35RZquGI9CPohaApbV2qMS4hb3nlxOHjmzaWE1dt++
         1KQG+BVFHSRLBx7ITYQKweIlWsOCU+RXqtIUaTdxKUYM/SdpREKrU0cTqruaHAKGPw
         96zJV0KtmI0pRsp5VBBO4m60ZWecU4I/3Y+mf1GKaL/yAHoQmQYknRwKPz/0Dve1vG
         LClybhRadbMRy8xJmLDUqVjel7HRRdQSBeDYcmsgQU5pRk39kX2fXV5nK3UI3bbQl3
         AXR1Nu8Ak6OfEabWz+BZP+i+rsP6+49dRTYEL7smGWG8zPR9KECGYrjTYKYpS5zPvI
         LZSexwUWy3qMQ==
Message-ID: <ac8b71a9e07be3c21fc5a788932196bda381e637.camel@kernel.org>
Subject: Re: [PATCH 3/3] ceph: don't WARN if we're iterate removing the
 session caps
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 23 Aug 2021 09:59:07 -0400
In-Reply-To: <20210818080603.195722-4-xiubli@redhat.com>
References: <20210818080603.195722-1-xiubli@redhat.com>
         <20210818080603.195722-4-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-18 at 16:06 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For example in case force umounting it will remove all the session
> caps one by one even it's dirty cap.
> 
> URL: https://tracker.ceph.com/issues/52295
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 15 ++++++++-------
>  fs/ceph/mds_client.c |  4 ++--
>  fs/ceph/super.h      |  3 ++-
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 7def99fbdca6..1ed9b9d57dd3 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1101,7 +1101,7 @@ int ceph_is_any_caps(struct inode *inode)
>   * caller should hold i_ceph_lock.
>   * caller will not hold session s_mutex if called from destroy_inode.
>   */
> -void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> +void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release, bool warn)

I think it'd be better to refactor __ceph_remove_cap so that it has a
wrapper function that does the WARN_ON_ONCE call under the right
conditions.

Maybe add a ceph_remove_cap() that does:

	WARN_ON_ONCE(ci && ci->i_auth_cap == cap &&
		     !list_empty(&ci->i_dirty_item) &&
		     !mdsc->fsc->blocklisted);

...and then calls __ceph_remove_cap(). Then you could have the ones that
set "warn" to false call __ceph_remove_cap() and the others would call
ceph_remove_cap(). That's at least a little less ugly (and more
efficient).

Alternately, I guess you could try to test what state the session is in
and only warn if it's not being force-unmounted?

>  {
>  	struct ceph_mds_session *session = cap->session;
>  	struct ceph_inode_info *ci = cap->ci;
> @@ -1121,7 +1121,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  	/* remove from inode's cap rbtree, and clear auth cap */
>  	rb_erase(&cap->ci_node, &ci->i_caps);
>  	if (ci->i_auth_cap == cap) {
> -		WARN_ON_ONCE(!list_empty(&ci->i_dirty_item) &&
> +		WARN_ON_ONCE(warn && !list_empty(&ci->i_dirty_item) &&
>  			     !mdsc->fsc->blocklisted);
>  		ci->i_auth_cap = NULL;
>  	}
> @@ -1304,7 +1304,7 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
>  	while (p) {
>  		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
>  		p = rb_next(p);
> -		__ceph_remove_cap(cap, true);
> +		__ceph_remove_cap(cap, true, true);
>  	}
>  	spin_unlock(&ci->i_ceph_lock);
>  }
> @@ -3815,7 +3815,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  		goto out_unlock;
>  
>  	if (target < 0) {
> -		__ceph_remove_cap(cap, false);
> +		__ceph_remove_cap(cap, false, true);
>  		goto out_unlock;
>  	}
>  
> @@ -3850,7 +3850,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  				change_auth_cap_ses(ci, tcap->session);
>  			}
>  		}
> -		__ceph_remove_cap(cap, false);
> +		__ceph_remove_cap(cap, false, true);
>  		goto out_unlock;
>  	} else if (tsession) {
>  		/* add placeholder for the export tagert */
> @@ -3867,7 +3867,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>  			spin_unlock(&mdsc->cap_dirty_lock);
>  		}
>  
> -		__ceph_remove_cap(cap, false);
> +		__ceph_remove_cap(cap, false, true);
>  		goto out_unlock;
>  	}
>  
> @@ -3978,7 +3978,8 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
>  					ocap->mseq, mds, le32_to_cpu(ph->seq),
>  					le32_to_cpu(ph->mseq));
>  		}
> -		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
> +		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE),
> +				  true);
>  	}
>  
>  	*old_issued = issued;
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 0302af53e079..d99ec2618585 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1636,7 +1636,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  	dout("removing cap %p, ci is %p, inode is %p\n",
>  	     cap, ci, &ci->vfs_inode);
>  	spin_lock(&ci->i_ceph_lock);
> -	__ceph_remove_cap(cap, false);
> +	__ceph_remove_cap(cap, false, false);
>  	if (!ci->i_auth_cap) {
>  		struct ceph_cap_flush *cf;
>  
> @@ -2008,7 +2008,7 @@ static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
>  
>  	if (oissued) {
>  		/* we aren't the only cap.. just remove us */
> -		__ceph_remove_cap(cap, true);
> +		__ceph_remove_cap(cap, true, true);
>  		(*remaining)--;
>  	} else {
>  		struct dentry *dentry;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 51ec17d12b26..106ddfd1ce92 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1142,7 +1142,8 @@ extern void ceph_add_cap(struct inode *inode,
>  			 unsigned issued, unsigned wanted,
>  			 unsigned cap, unsigned seq, u64 realmino, int flags,
>  			 struct ceph_cap **new_cap);
> -extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
> +extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release,
> +			      bool warn);
>  extern void __ceph_remove_caps(struct ceph_inode_info *ci);
>  extern void ceph_put_cap(struct ceph_mds_client *mdsc,
>  			 struct ceph_cap *cap);

-- 
Jeff Layton <jlayton@kernel.org>

