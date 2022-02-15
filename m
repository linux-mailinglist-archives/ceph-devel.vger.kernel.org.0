Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88C4B7824
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 21:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbiBOQ57 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 11:57:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236268AbiBOQ56 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 11:57:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26122F11B2
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 08:57:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B611761468
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 16:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF306C340EB;
        Tue, 15 Feb 2022 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644944267;
        bh=SNP6Zj4Va0675NmWl0wYJIitLhw5ENQCd4nEk6VA2/o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Wa5LH+hu5DDXY+rdYuEe9LtsYw9jTrUZZBRwVfFZLSoCTuilTw/pJs5Cauo6ighyf
         0/1G2fB4aVlXOXWdptNywNR5k0cQBKdOzuHQGHmfsh5ybWbVSBz8LJayd+F7biH5U1
         nFGMBehGn/o4hqZO70BPlAAKx0Bd7MAgpWLV+rp5N0GEc0QHarnBTipWzo9bHA5lmw
         A34ovlqoREWCprP+Hx1DC5WcctVdXrDPhS4G46U4XsApU+JzEL8dA0gAe1xF7rse/p
         vZygBeyS/o1WdFCY28J6b6rR7V1ZYgC6588kUm/eYi3B3Z9K/lD8I3t2km55KM+hI5
         /wp951nfGyOTQ==
Message-ID: <7239f8b4e48ce1e0fcba850ae183c5225f6e774b.camel@kernel.org>
Subject: Re: [PATCH 2/3] ceph: move kzalloc under i_ceph_lock with
 GFP_ATOMIC flag
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 15 Feb 2022 11:57:45 -0500
In-Reply-To: <20220215122316.7625-3-xiubli@redhat.com>
References: <20220215122316.7625-1-xiubli@redhat.com>
         <20220215122316.7625-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-02-15 at 20:23 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> There has one case that the snaprealm has been updated and then
> it will iterate all the inode under it and try to queue a cap
> snap for it. But in some case there has millions of subdirectries
> or files under it and most of them no any Fw or dirty pages and
> then will just be skipped.
> 
> URL: https://tracker.ceph.com/issues/44100
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c | 37 +++++++++++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index c787775eaf2a..d075d3ce5f6d 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -477,19 +477,21 @@ static bool has_new_snaps(struct ceph_snap_context *o,
>  static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>  {
>  	struct inode *inode = &ci->vfs_inode;
> -	struct ceph_cap_snap *capsnap;
> +	struct ceph_cap_snap *capsnap = NULL;
>  	struct ceph_snap_context *old_snapc, *new_snapc;
>  	struct ceph_buffer *old_blob = NULL;
>  	int used, dirty;
> -
> -	capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
> -	if (!capsnap) {
> -		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
> -		return;
> +	bool need_flush = false;
> +	bool atomic_alloc_mem_failed = false;
> +
> +retry:
> +	if (unlikely(atomic_alloc_mem_failed)) {
> +	        capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
> +		if (!capsnap) {
> +			pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
> +			return;
> +		}
>  	}
> -	capsnap->cap_flush.is_capsnap = true;
> -	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
> -	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
>  
>  	spin_lock(&ci->i_ceph_lock);
>  	used = __ceph_caps_used(ci);
> @@ -532,7 +534,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>  	 */
>  	if (has_new_snaps(old_snapc, new_snapc)) {
>  		if (dirty & (CEPH_CAP_ANY_EXCL|CEPH_CAP_FILE_WR))
> -			capsnap->need_flush = true;
> +			need_flush = true;
>  	} else {
>  		if (!(used & CEPH_CAP_FILE_WR) &&
>  		    ci->i_wrbuffer_ref_head == 0) {
> @@ -542,6 +544,21 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>  		}
>  	}
>  
> +	if (!capsnap) {
> +	        capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_ATOMIC);
> +		if (unlikely(!capsnap)) {
> +			pr_err("ENOMEM atomic allocating ceph_cap_snap on %p\n",
> +			       inode);
> +			spin_unlock(&ci->i_ceph_lock);
> +			atomic_alloc_mem_failed = true;
> +			goto retry;
> +		}
> +	}
> +	capsnap->need_flush = need_flush;
> +	capsnap->cap_flush.is_capsnap = true;
> +	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
> +	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
> +
>  	dout("queue_cap_snap %p cap_snap %p queuing under %p %s %s\n",
>  	     inode, capsnap, old_snapc, ceph_cap_string(dirty),
>  	     capsnap->need_flush ? "" : "no_flush");

I'm not so thrilled with this patch.

First, are you sure you want GFP_ATOMIC here? Something like GFP_NOWAIT
may be better since you have a fallback so the kernel can still make
forward progress on reclaim if this returns NULL.

That said, this is pretty kludgey. I'd much prefer to see something that
didn't require this sort of hack. Maybe instead you could have
queue_realm_cap_snaps do the allocation and pass a (struct ceph_cap_snap
**) pointer in, and it can set the thing to NULL if it ends up using it?

That way, we still don't do the allocation under spinlock and you only
end up allocating the number you need (plus maybe one or two on the
edges).

-- 
Jeff Layton <jlayton@kernel.org>
