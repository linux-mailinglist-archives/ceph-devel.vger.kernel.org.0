Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B610E4B8BE4
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 15:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiBPO6f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 09:58:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiBPO6e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 09:58:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4882A66FA2
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 06:58:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C21618F7
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 14:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DE6C004E1;
        Wed, 16 Feb 2022 14:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645023501;
        bh=yQRaV08b6yYawP0//XFrE6u4IX1kHI9ZzRQ6l+MR24Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d/LUJzvjI5mpBpeI2om/wg9YRUjKcN3rwg8oAQfYDzJhQrBMcgqc0weESbao8ctbr
         wDhH75XJQWEOH5T9laseJ/ZAjIKQ3LTwXx+X9mr7IarwSiiKHxY/NcnFjPMQiX9tdh
         PCZQsNEEQaC4cKP+4metft3gzIHmDZPiqygSXfmdUNITxXmLeeSnJFCNj0bLsvBZlO
         seFfc+VlMZNt5eTpdcTiPGGvENGAC7rvVG75cJ+3tB0cMiqcT4Z9bbQ2nqcxOo89Qt
         lEic2LLg53GV1rhE8YQ8UltwwuXplmxWm9HAFJcv/xtkbunE80K1gYgCJrIxFwiSsb
         Dz4sMj+ymqTOQ==
Message-ID: <28350c955afc4f07030ba465cb492605bf5889da.camel@kernel.org>
Subject: Re: [PATCH 1/3] ceph: move to a dedicated slabcache for
 ceph_cap_snap
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 16 Feb 2022 09:58:19 -0500
In-Reply-To: <20220215122316.7625-2-xiubli@redhat.com>
References: <20220215122316.7625-1-xiubli@redhat.com>
         <20220215122316.7625-2-xiubli@redhat.com>
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
> There could be huge number of capsnap queued in a short time, on
> x86_64 it's 248 bytes, which will be rounded up to 256 bytes by
> kzalloc. Move this to a dedicated slabcache to save 8 bytes for
> each.
> 
> For the kmalloc-256 slab cache, the actual size will be 512 bytes:
> kmalloc-256        21797  74656    512   32    4 : tunables, etc
> 
> For a dedicated slab cache the real size is 312 bytes:
> ceph_cap_snap          0      0    312   52    4 : tunables, etc
> 
> So actually we can save 200 bytes for each.
> 

I dropped everything but the top paragraph in the description above. On
non-debug kernels, kmalloc-256 is indeed 256 bytes. The inflation you're
seeing is almost certainly from sort of kernel debugging options.

> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c               | 5 +++--
>  fs/ceph/super.c              | 7 +++++++
>  fs/ceph/super.h              | 2 +-
>  include/linux/ceph/libceph.h | 1 +
>  4 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index b41e6724c591..c787775eaf2a 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -482,7 +482,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>  	struct ceph_buffer *old_blob = NULL;
>  	int used, dirty;
>  
> -	capsnap = kzalloc(sizeof(*capsnap), GFP_NOFS);
> +	capsnap = kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);
>  	if (!capsnap) {
>  		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
>  		return;
> @@ -603,7 +603,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>  	spin_unlock(&ci->i_ceph_lock);
>  
>  	ceph_buffer_put(old_blob);
> -	kfree(capsnap);
> +	if (capsnap)
> +		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
>  	ceph_put_snap_context(old_snapc);
>  }
>  
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index bf79f369aec6..978463fa822c 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -864,6 +864,7 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>   */
>  struct kmem_cache *ceph_inode_cachep;
>  struct kmem_cache *ceph_cap_cachep;
> +struct kmem_cache *ceph_cap_snap_cachep;
>  struct kmem_cache *ceph_cap_flush_cachep;
>  struct kmem_cache *ceph_dentry_cachep;
>  struct kmem_cache *ceph_file_cachep;
> @@ -892,6 +893,9 @@ static int __init init_caches(void)
>  	ceph_cap_cachep = KMEM_CACHE(ceph_cap, SLAB_MEM_SPREAD);
>  	if (!ceph_cap_cachep)
>  		goto bad_cap;
> +	ceph_cap_snap_cachep = KMEM_CACHE(ceph_cap_snap, SLAB_MEM_SPREAD);
> +	if (!ceph_cap_snap_cachep)
> +		goto bad_cap_snap;
>  	ceph_cap_flush_cachep = KMEM_CACHE(ceph_cap_flush,
>  					   SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
>  	if (!ceph_cap_flush_cachep)
> @@ -931,6 +935,8 @@ static int __init init_caches(void)
>  bad_dentry:
>  	kmem_cache_destroy(ceph_cap_flush_cachep);
>  bad_cap_flush:
> +	kmem_cache_destroy(ceph_cap_snap_cachep);
> +bad_cap_snap:
>  	kmem_cache_destroy(ceph_cap_cachep);
>  bad_cap:
>  	kmem_cache_destroy(ceph_inode_cachep);
> @@ -947,6 +953,7 @@ static void destroy_caches(void)
>  
>  	kmem_cache_destroy(ceph_inode_cachep);
>  	kmem_cache_destroy(ceph_cap_cachep);
> +	kmem_cache_destroy(ceph_cap_snap_cachep);
>  	kmem_cache_destroy(ceph_cap_flush_cachep);
>  	kmem_cache_destroy(ceph_dentry_cachep);
>  	kmem_cache_destroy(ceph_file_cachep);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index c0718d5a8fb8..2d08104c8955 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -231,7 +231,7 @@ static inline void ceph_put_cap_snap(struct ceph_cap_snap *capsnap)
>  	if (refcount_dec_and_test(&capsnap->nref)) {
>  		if (capsnap->xattr_blob)
>  			ceph_buffer_put(capsnap->xattr_blob);
> -		kfree(capsnap);
> +		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
>  	}
>  }
>  
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index edf62eaa6285..00af2c98da75 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -284,6 +284,7 @@ DEFINE_RB_LOOKUP_FUNC(name, type, keyfld, nodefld)
>  
>  extern struct kmem_cache *ceph_inode_cachep;
>  extern struct kmem_cache *ceph_cap_cachep;
> +extern struct kmem_cache *ceph_cap_snap_cachep;
>  extern struct kmem_cache *ceph_cap_flush_cachep;
>  extern struct kmem_cache *ceph_dentry_cachep;
>  extern struct kmem_cache *ceph_file_cachep;

-- 
Jeff Layton <jlayton@kernel.org>
