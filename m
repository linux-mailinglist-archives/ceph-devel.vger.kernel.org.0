Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B5B3EEE07
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhHQOEb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 10:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhHQOEb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 10:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C4860E09;
        Tue, 17 Aug 2021 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629209038;
        bh=WIPfPgsN0CtssJDUL8cAv12htGUDKmRWZ5qOaKwJ4B4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=elxbkf9fTtExI+OaYrQKPC+6mYEGnWt2Rr7tOQqMMbTQXrzBxxTp6sVNIwL1oLFQd
         PTEvWuiaRaZI+nE2YWTUIptosY0myy4QiJItKyeOlT0tiAk5E8zUoIypU+FKoZdM4j
         ww0AeqAMI3BPybIVVfoY1zD3cCB930eVbFvm+2b7x+HkSRpLmyorea5hgTXMu0TRbq
         815/mCI92EuTB3HnC/FylbsyWgfRM4ucnMBEjpPBidmxGYcQXR3cFFukjkJIzguEdg
         qVMUaQtpcO8mu1J+oWv/R9wTLFEhSD3VAD9tyO3MpmDDiKItAbqtTLkfI3Q0bLnFCE
         +AnogJt/5vNzg==
Message-ID: <25dd85fdb777f9b260392ceeda41fc5e62018ddd.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: correctly release memory from capsnap
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 17 Aug 2021 10:03:56 -0400
In-Reply-To: <20210817123517.15764-1-xiubli@redhat.com>
References: <20210817123517.15764-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-08-17 at 20:35 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When force umounting, it will try to remove all the session caps.
> If there has any capsnap is in the flushing list, the remove session
> caps callback will try to release the capsnap->flush_cap memory to
> "ceph_cap_flush_cachep" slab cache, while which is allocated from
> kmalloc-256 slab cache.
> 
> At the same time switch to list_del_init() because just in case the
> force umount has removed it from the lists and the
> handle_cap_flushsnap_ack() comes then the seconds list_del_init()
> won't crash the kernel.
> 
> URL: https://tracker.ceph.com/issues/52283
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> - Only to resolve the crash issue.
> - s/list_del/list_del_init/
> 
> 
>  fs/ceph/caps.c       | 18 ++++++++++++++----
>  fs/ceph/mds_client.c |  7 ++++---
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 990258cbd836..4ee0ef87130a 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1667,7 +1667,16 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>  
>  struct ceph_cap_flush *ceph_alloc_cap_flush(void)
>  {
> -	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> +	struct ceph_cap_flush *cf;
> +
> +	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> +	/*
> +	 * caps == 0 always means for the capsnap
> +	 * caps > 0 means dirty caps being flushed
> +	 * caps == -1 means preallocated, not used yet
> +	 */
> +	cf->caps = -1;
> +	return cf;
>  }
>  
>  void ceph_free_cap_flush(struct ceph_cap_flush *cf)
> @@ -1704,14 +1713,14 @@ static bool __finish_cap_flush(struct ceph_mds_client *mdsc,
>  			prev->wake = true;
>  			wake = false;
>  		}
> -		list_del(&cf->g_list);
> +		list_del_init(&cf->g_list);
>  	} else if (ci) {
>  		if (wake && cf->i_list.prev != &ci->i_cap_flush_list) {
>  			prev = list_prev_entry(cf, i_list);
>  			prev->wake = true;
>  			wake = false;
>  		}
> -		list_del(&cf->i_list);
> +		list_del_init(&cf->i_list);
>  	} else {
>  		BUG_ON(1);
>  	}
> @@ -3398,7 +3407,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>  		cf = list_first_entry(&to_remove,
>  				      struct ceph_cap_flush, i_list);
>  		list_del(&cf->i_list);
> -		ceph_free_cap_flush(cf);
> +		if (cf->caps)
> +			ceph_free_cap_flush(cf);
>  	}
>  
>  	if (wake_ci)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 2c3d762c7973..dc30f56115fa 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1226,7 +1226,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  		spin_lock(&mdsc->cap_dirty_lock);
>  
>  		list_for_each_entry(cf, &to_remove, i_list)
> -			list_del(&cf->g_list);
> +			list_del_init(&cf->g_list);
>  
>  		if (!list_empty(&ci->i_dirty_item)) {
>  			pr_warn_ratelimited(
> @@ -1266,8 +1266,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  		struct ceph_cap_flush *cf;
>  		cf = list_first_entry(&to_remove,
>  				      struct ceph_cap_flush, i_list);
> -		list_del(&cf->i_list);
> -		ceph_free_cap_flush(cf);
> +		list_del_init(&cf->i_list);
> +		if (cf->caps)
> +			ceph_free_cap_flush(cf);
>  	}
>  
>  	wake_up_all(&ci->i_cap_wq);

This patch doesn't seem to apply to the current testing branch. Is it
against an older tree?

-- 
Jeff Layton <jlayton@kernel.org>

