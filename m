Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DCE364AB5
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Apr 2021 21:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241817AbhDSTlo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Apr 2021 15:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234946AbhDSTln (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 15:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C773361363;
        Mon, 19 Apr 2021 19:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618861273;
        bh=kd5rx11sXBpoAXWQWPr79R7WX661RiUn16tK0sYGSHM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qCuDsu7ES2n7CodDrz2bo4g0lv9b5Oik9uMbF0YuOcXyMZB8uPZuXiD3nms1/f+Fj
         EoHqNN2ejms4OcAJWy95xDy9n8miA9t+3t9tNIrgEgwSjsOT2fg/TU1OrlVBdekxx7
         /hr6EWmsFqXjuheahagAp4RAexc4kXUkYW6+RkrrvTQpuplOz+2ipzwXXC7VwOQ2y+
         ty59Wuk0hNN27utuAMZgcML0ZuIbgy1uinSbQPi3tt3OAk9iLuScAf8wcW2oxiPOLU
         USb5eWzXlZN5Rksk+xekB0OO8heenxgAIsLFPdzsi3xyn4Iaa31vurYQppWbtywdQd
         rZSLdzmg8Mikg==
Message-ID: <0b0dc523bf795e78d72c341764a3954f7a7924be.camel@kernel.org>
Subject: Re: [PATCH] ceph: convert {n}ref from atomic_t to refcount_t
From:   Jeff Layton <jlayton@kernel.org>
To:     Yejune Deng <yejune.deng@gmail.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Mon, 19 Apr 2021 15:41:11 -0400
In-Reply-To: <20210324102625.112640-1-yejune.deng@gmail.com>
References: <20210324102625.112640-1-yejune.deng@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-03-24 at 18:26 +0800, Yejune Deng wrote:
> refcount_t type should be used instead of atomic_t when the variable
> is used as a reference counter. This is because the implementation of
> refcount_t can prevent overflows and detect possible use-after-free.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  fs/ceph/mds_client.h |  2 +-
>  fs/ceph/snap.c       | 27 +++++++++++++++------------
>  fs/ceph/super.h      |  2 +-
>  3 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index eaa7c5422116..bf99c5ba47fc 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -351,7 +351,7 @@ struct ceph_pool_perm {
>  struct ceph_snapid_map {
>  	struct rb_node node;
>  	struct list_head lru;
> -	atomic_t ref;
> +	refcount_t ref;
>  	u64 snap;
>  	dev_t dev;
>  	unsigned long last_used;
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 0728b01d4d43..c0fbbb56b259 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -66,14 +66,15 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
>  			 struct ceph_snap_realm *realm)
>  {
>  	dout("get_realm %p %d -> %d\n", realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
> +	     refcount_read(&realm->nref), refcount_read(&realm->nref)+1);
>  	/*
>  	 * since we _only_ increment realm refs or empty the empty
>  	 * list with snap_rwsem held, adjusting the empty list here is
>  	 * safe.  we do need to protect against concurrent empty list
>  	 * additions, however.
>  	 */
> -	if (atomic_inc_return(&realm->nref) == 1) {
> +	refcount_inc(&realm->nref);
> +	if (refcount_read(&realm->nref) == 1) {
>  		spin_lock(&mdsc->snap_empty_lock);
>  		list_del_init(&realm->empty_item);
>  		spin_unlock(&mdsc->snap_empty_lock);
> @@ -117,7 +118,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
>  	if (!realm)
>  		return ERR_PTR(-ENOMEM);
>  
> -	atomic_set(&realm->nref, 1);    /* for caller */
> +	refcount_set(&realm->nref, 1);    /* for caller */
>  	realm->ino = ino;
>  	INIT_LIST_HEAD(&realm->children);
>  	INIT_LIST_HEAD(&realm->child_item);
> @@ -199,8 +200,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
>  			     struct ceph_snap_realm *realm)
>  {
>  	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> -	if (atomic_dec_and_test(&realm->nref))
> +	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
> +	if (refcount_dec_and_test(&realm->nref))
>  		__destroy_snap_realm(mdsc, realm);
>  }
>  
> @@ -211,8 +212,8 @@ void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
>  			 struct ceph_snap_realm *realm)
>  {
>  	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
> -	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
> -	if (!atomic_dec_and_test(&realm->nref))
> +	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
> +	if (!refcount_dec_and_test(&realm->nref))
>  		return;
>  
>  	if (down_write_trylock(&mdsc->snap_rwsem)) {
> @@ -1034,7 +1035,8 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
>  		} else if (snap < exist->snap) {
>  			p = &(*p)->rb_right;
>  		} else {
> -			if (atomic_inc_return(&exist->ref) == 1)
> +			refcount_inc(&exist->ref);
> +			if (refcount_read(&exist->ref) == 1)
>  				list_del_init(&exist->lru);
>  			break;
>  		}
> @@ -1057,7 +1059,7 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
>  	}
>  
>  	INIT_LIST_HEAD(&sm->lru);
> -	atomic_set(&sm->ref, 1);
> +	refcount_set(&sm->ref, 1);
>  	sm->snap = snap;
>  
>  	exist = NULL;
> @@ -1076,7 +1078,8 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
>  		exist = NULL;
>  	}
>  	if (exist) {
> -		if (atomic_inc_return(&exist->ref) == 1)
> +		refcount_inc(&exist->ref);
> +		if (refcount_read(&exist->ref) == 1)

Hi Yejune,

I believe this patch is causing the regression reported here:

    https://tracker.ceph.com/issues/50281

Note that the above two operations together aren't atomic like
atomic_inc_return is, and I suspect this is causing the object to remain
on the LRU list after its refcount has made a 0->1 transition. Does
refcount_t allow a 0->1 transition like this code does?

In any case, I'm dropping this patch for now.

>  			list_del_init(&exist->lru);
>  	} else {
>  		rb_link_node(&sm->node, parent, p);
> @@ -1099,7 +1102,7 @@ void ceph_put_snapid_map(struct ceph_mds_client* mdsc,
>  {
>  	if (!sm)
>  		return;
> -	if (atomic_dec_and_lock(&sm->ref, &mdsc->snapid_map_lock)) {
> +	if (refcount_dec_and_lock(&sm->ref, &mdsc->snapid_map_lock)) {
>  		if (!RB_EMPTY_NODE(&sm->node)) {
>  			sm->last_used = jiffies;
>  			list_add_tail(&sm->lru, &mdsc->snapid_map_lru);
> @@ -1161,7 +1164,7 @@ void ceph_cleanup_snapid_map(struct ceph_mds_client *mdsc)
>  		sm = list_first_entry(&to_free, struct ceph_snapid_map, lru);
>  		list_del(&sm->lru);
>  		free_anon_bdev(sm->dev);
> -		if (WARN_ON_ONCE(atomic_read(&sm->ref))) {
> +		if (WARN_ON_ONCE(refcount_read(&sm->ref))) {
>  			pr_err("snapid map %llx -> %x still in use\n",
>  			       sm->snap, sm->dev);
>  		}
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index c48bb30c8d70..062123a73ef1 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -835,7 +835,7 @@ struct ceph_readdir_cache_control {
>  struct ceph_snap_realm {
>  	u64 ino;
>  	struct inode *inode;
> -	atomic_t nref;
> +	refcount_t nref;
>  	struct rb_node node;
>  
>  	u64 created, seq;

Thanks,
--
Jeff Layton <jlayton@kernel.org>

