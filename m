Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE28A347B9C
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Mar 2021 16:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbhCXPEj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 11:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236408AbhCXPEM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 11:04:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D02AA619A4;
        Wed, 24 Mar 2021 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616598252;
        bh=x7SH3yA/mzmsnH/hrV2pehEtDfcK1K7ccJXFfQNsj0g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SEJSAB564QkDcEBxa4kkqRIb3Ik/vUs4bkVbqHvJNbIYe2fSsv7ftrYdpByDO0YGv
         GUii5Fx2HKPYpvj4cIULD+XTNHy2a/yRCaRlE68CYvx8jKLyoLhFKDsgdWTe74ftrh
         mIWypR6eZcjRTQ+4SiRjmDOlZQhUPZA6H3yZMe5UGeOp4uVA3zSxjaCEmDq6szv6Uj
         mLrNVjGmXEJVKUG6Edtff9UAxNiX7xeZ+rUuXdikoFpxDcf3mgeuZXtRRNByf6z+gQ
         U98Nz1buOAhXJjI0YXJ6vTqPTJi4Dq9skB/1aZbdSInOslz5MfpeWN57kPZmF9jfBB
         RvFskDn1kpZsw==
Message-ID: <ffff6f72c5ab4b5916aaeb73435ed8141876ac1f.camel@kernel.org>
Subject: Re: [PATCH] ceph: convert {n}ref from atomic_t to refcount_t
From:   Jeff Layton <jlayton@kernel.org>
To:     Yejune Deng <yejune.deng@gmail.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 24 Mar 2021 11:04:10 -0400
In-Reply-To: <20210324102625.112640-1-yejune.deng@gmail.com>
References: <20210324102625.112640-1-yejune.deng@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
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

Thanks, merged into ceph-client/testing branch. This should make v5.13.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

