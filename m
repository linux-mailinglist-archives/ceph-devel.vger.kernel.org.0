Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3513F7751
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 16:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241582AbhHYO0s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 10:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241595AbhHYO0g (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 10:26:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48BC4610CD;
        Wed, 25 Aug 2021 14:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629901550;
        bh=Pq+Mhh4xcYh9JG9EpwqxSxQl7qgeSfUE4NFG42Hlg2g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I+FvxF6sV09iQ0AZNyR6kl/9aG17qcDdbnPyljzwOxs9yBIB1O2NhuNWhXf1ACE2G
         /4K0Mh/hkbqyI1xRRWdTuVOBd61OLikt1GdnUcNkCLz6QRJtHT3zAv2RuDyvKMVjLf
         tTK5XQ8OmiugeR1QJEh9TY2xNL3rtn5tQWk3NicV4XMsWq9dLElrDdeMBML3zPt4lh
         JV2swOdc6mWhazmIHOsfswZ0XUKlFAAHaZhpeuT36tQk1R/AIgkK4tfLRhvsnWtXlT
         tjacod5fgZnk6AyvyeLZ2j6M8qNTyvikuckoTr09QjuVzIEHPAED1+ABLWej57Jfts
         IU3cdprKjfSog==
Message-ID: <4c9e45b40fb4c2f5e7b5c14df2507525d0710f54.camel@kernel.org>
Subject: Re: [PATCH v3 1/3] ceph: remove the capsnaps when removing the caps
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 25 Aug 2021 10:25:49 -0400
In-Reply-To: <20210825134545.117521-2-xiubli@redhat.com>
References: <20210825134545.117521-1-xiubli@redhat.com>
         <20210825134545.117521-2-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-25 at 21:45 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The capsnaps will ihold the inodes when queuing to flush, so when
> force umounting it will close the sessions first and if the MDSes
> respond very fast and the session connections are closed just
> before killing the superblock, which will flush the msgr queue,
> then the flush capsnap callback won't ever be called, which will
> lead the memory leak bug for the ceph_inode_info.
> 
> URL: https://tracker.ceph.com/issues/52295
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 67 +++++++++++++++++++++++++++++++++-----------
>  fs/ceph/mds_client.c | 31 +++++++++++++++++++-
>  fs/ceph/super.h      |  6 ++++
>  3 files changed, 86 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 1e6261a16fb5..61326b490b2b 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3162,7 +3162,15 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>  				break;
>  			}
>  		}
> -		BUG_ON(!found);
> +
> +		/*
> +		 * The capsnap should already be removed when
> +		 * removing auth cap in case likes force unmount.
> +		 */
> +		BUG_ON(!found && ci->i_auth_cap);
> +		if (!found)
> +			goto unlock;
> +
>  		capsnap->dirty_pages -= nr;
>  		if (capsnap->dirty_pages == 0) {
>  			complete_capsnap = true;
> @@ -3184,6 +3192,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>  		     complete_capsnap ? " (complete capsnap)" : "");
>  	}
>  
> +unlock:
>  	spin_unlock(&ci->i_ceph_lock);
>  
>  	if (last) {
> @@ -3658,6 +3667,43 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>  		iput(inode);
>  }
>  
> +void __ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
> +			   bool *wake_ci, bool *wake_mdsc)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	bool ret;
> +
> +	lockdep_assert_held(&ci->i_ceph_lock);

Hmm, your earlier patch had a note saying that the s_mutex needed to he
held here too. Is that not the case?

> +
> +	dout("removing capsnap %p, inode %p ci %p\n", capsnap, inode, ci);
> +
> +	list_del_init(&capsnap->ci_item);
> +	ret = __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
> +	if (wake_ci)
> +		*wake_ci = ret;
> +
> +	spin_lock(&mdsc->cap_dirty_lock);
> +	if (list_empty(&ci->i_cap_flush_list))
> +		list_del_init(&ci->i_flushing_item);
> +
> +	ret = __detach_cap_flush_from_mdsc(mdsc, &capsnap->cap_flush);
> +	if (wake_mdsc)
> +		*wake_mdsc = ret;
> +	spin_unlock(&mdsc->cap_dirty_lock);
> +}
> +
> +void ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
> +			 bool *wake_ci, bool *wake_mdsc)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +	lockdep_assert_held(&ci->i_ceph_lock);
> +
> +	WARN_ON_ONCE(capsnap->dirty_pages || capsnap->writing);
> +	__ceph_remove_capsnap(inode, capsnap, wake_ci, wake_mdsc);
> +}
> +
>  /*
>   * Handle FLUSHSNAP_ACK.  MDS has flushed snap data to disk and we can
>   * throw away our cap_snap.
> @@ -3695,23 +3741,10 @@ static void handle_cap_flushsnap_ack(struct inode *inode, u64 flush_tid,
>  			     capsnap, capsnap->follows);
>  		}
>  	}
> -	if (flushed) {
> -		WARN_ON(capsnap->dirty_pages || capsnap->writing);
> -		dout(" removing %p cap_snap %p follows %lld\n",
> -		     inode, capsnap, follows);
> -		list_del(&capsnap->ci_item);
> -		wake_ci |= __detach_cap_flush_from_ci(ci, &capsnap->cap_flush);
> -
> -		spin_lock(&mdsc->cap_dirty_lock);
> -
> -		if (list_empty(&ci->i_cap_flush_list))
> -			list_del_init(&ci->i_flushing_item);
> -
> -		wake_mdsc |= __detach_cap_flush_from_mdsc(mdsc,
> -							  &capsnap->cap_flush);
> -		spin_unlock(&mdsc->cap_dirty_lock);
> -	}
> +	if (flushed)
> +		ceph_remove_capsnap(inode, capsnap, &wake_ci, &wake_mdsc);
>  	spin_unlock(&ci->i_ceph_lock);
> +
>  	if (flushed) {
>  		ceph_put_snap_context(capsnap->context);
>  		ceph_put_cap_snap(capsnap);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index df3a735f7837..36ad0ebb2295 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1604,14 +1604,39 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>  	return ret;
>  }
>  
> +static int remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
> +{
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_cap_snap *capsnap;
> +	int capsnap_release = 0;
> +
> +	lockdep_assert_held(&ci->i_ceph_lock);
> +
> +	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
> +
> +	while (!list_empty(&ci->i_cap_snaps)) {
> +		capsnap = list_first_entry(&ci->i_cap_snaps,
> +					   struct ceph_cap_snap, ci_item);
> +		__ceph_remove_capsnap(inode, capsnap, NULL, NULL);
> +		ceph_put_snap_context(capsnap->context);
> +		ceph_put_cap_snap(capsnap);
> +		capsnap_release++;
> +	}
> +	wake_up_all(&ci->i_cap_wq);
> +	wake_up_all(&mdsc->cap_flushing_wq);
> +	return capsnap_release;
> +}
> +
>  static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  				  void *arg)
>  {
>  	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	LIST_HEAD(to_remove);
>  	bool dirty_dropped = false;
>  	bool invalidate = false;
> +	int capsnap_release = 0;
>  
>  	dout("removing cap %p, ci is %p, inode is %p\n",
>  	     cap, ci, &ci->vfs_inode);
> @@ -1619,7 +1644,6 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  	__ceph_remove_cap(cap, false);
>  	if (!ci->i_auth_cap) {
>  		struct ceph_cap_flush *cf;
> -		struct ceph_mds_client *mdsc = fsc->mdsc;
>  
>  		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
>  			if (inode->i_data.nrpages > 0)
> @@ -1683,6 +1707,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  			list_add(&ci->i_prealloc_cap_flush->i_list, &to_remove);
>  			ci->i_prealloc_cap_flush = NULL;
>  		}
> +
> +		if (!list_empty(&ci->i_cap_snaps))
> +			capsnap_release = remove_capsnaps(mdsc, inode);
>  	}
>  	spin_unlock(&ci->i_ceph_lock);
>  	while (!list_empty(&to_remove)) {
> @@ -1699,6 +1726,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  		ceph_queue_invalidate(inode);
>  	if (dirty_dropped)
>  		iput(inode);
> +	while (capsnap_release--)
> +		iput(inode);
>  	return 0;
>  }
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 8f4f2747be65..445d13d760d1 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1169,6 +1169,12 @@ extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
>  					    int had);
>  extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
>  				       struct ceph_snap_context *snapc);
> +extern void __ceph_remove_capsnap(struct inode *inode,
> +				  struct ceph_cap_snap *capsnap,
> +				  bool *wake_ci, bool *wake_mdsc);
> +extern void ceph_remove_capsnap(struct inode *inode,
> +				struct ceph_cap_snap *capsnap,
> +				bool *wake_ci, bool *wake_mdsc);
>  extern void ceph_flush_snaps(struct ceph_inode_info *ci,
>  			     struct ceph_mds_session **psession);
>  extern bool __ceph_should_report_size(struct ceph_inode_info *ci);

-- 
Jeff Layton <jlayton@kernel.org>

