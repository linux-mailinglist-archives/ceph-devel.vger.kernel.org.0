Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566A83D0DE3
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Jul 2021 13:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhGUK5H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 06:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238823AbhGUKm1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 06:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C132160FF3;
        Wed, 21 Jul 2021 11:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626866584;
        bh=+WgRr4NCoh1R/slVbZWxCyebD9vOG67TEPN1RLUL4I8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n+1zcG1PdDia9MmyHhZ6jeBtP2kbigl2bAnjOhunuUJrJiQ1Nwn86ZX6zBjiS6kW3
         KdDkEb6vcdrRATM2tgYlDqEDIEE+4tTBPAl7w4fCKOD1l8zf4td8NMeSZkavDoPSwj
         S/0DI0P6nO3w9L8FfsgeD0Ba9Jn3lFwDVLkV3DpABkKDJR3dyVQ/NrAEKlRsZJfeFW
         iHT+RrUASvdRXqetoJEd/KJg+yjK5u0K/qPjmuM478m2q46gWCWn6PsLcKjWKAbbzc
         3q75CDsQxFU5geWMmZcIzMN1fQs2VHcRM5HJvh36nQiX7pM/h3zSsDuOHZvH7xJHEx
         BCCvYcgp1jciQ==
Message-ID: <a2ab96c71ac875bd98efef4f7cb4590fbfae3b82.camel@kernel.org>
Subject: Re: [PATCH RFC] ceph: flush the delayed caps in time
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 21 Jul 2021 07:23:02 -0400
In-Reply-To: <20210721082720.110202-1-xiubli@redhat.com>
References: <20210721082720.110202-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-07-21 at 16:27 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The delayed_work will be executed per 5 seconds, during this time
> the cap_delay_list may accumulate thounsands of caps need to flush,
> this will make the MDS's dispatch queue be full and need a very long
> time to handle them. And if there has some other operations, likes
> a rmdir request, it will be add in the tail of dispath queue and
> need to wait for several or tens of seconds.
> 
> In client side we shouldn't queue to many of the cap requests and
> flush them if there has more than 100 items.
> 

Why 100? My inclination is to say NAK on this.

I'm not a fan of this sort of arbitrary throttling in order to alleviate
a scalability problem in the MDS. The cap delay logic is already
horrifically complex as well, and this just makes it worse. If the MDS
happens to be processing requests from a lot of clients, this may not
help at all.

> URL: https://tracker.ceph.com/issues/51734

The core problem sounds like the MDS got a call and just took way too
long to get to it. Shouldn't we be addressing this in the MDS instead?
It sounds like it needs to do a better job of parallelizing cap flushes.

> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 21 ++++++++++++++++++++-
>  fs/ceph/mds_client.c |  3 ++-
>  fs/ceph/mds_client.h |  3 +++
>  3 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 4b966c29d9b5..064865761d2b 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -507,6 +507,8 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
>  static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>  				struct ceph_inode_info *ci)
>  {
> +	int num = 0;
> +
>  	dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
>  	     ci->i_ceph_flags, ci->i_hold_caps_max);
>  	if (!mdsc->stopping) {
> @@ -515,12 +517,19 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>  			if (ci->i_ceph_flags & CEPH_I_FLUSH)
>  				goto no_change;
>  			list_del_init(&ci->i_cap_delay_list);
> +			mdsc->num_cap_delay--;
>  		}
>  		__cap_set_timeouts(mdsc, ci);
>  		list_add_tail(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
> +		num = ++mdsc->num_cap_delay;
>  no_change:
>  		spin_unlock(&mdsc->cap_delay_lock);
>  	}
> +
> +	if (num > 100) {
> +		flush_delayed_work(&mdsc->delayed_work);
> +		schedule_delayed(mdsc);
> +	}
>  }
>  
>  /*
> @@ -531,13 +540,23 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>  static void __cap_delay_requeue_front(struct ceph_mds_client *mdsc,
>  				      struct ceph_inode_info *ci)
>  {
> +	int num;
> +
>  	dout("__cap_delay_requeue_front %p\n", &ci->vfs_inode);
>  	spin_lock(&mdsc->cap_delay_lock);
>  	ci->i_ceph_flags |= CEPH_I_FLUSH;
> -	if (!list_empty(&ci->i_cap_delay_list))
> +	if (!list_empty(&ci->i_cap_delay_list)) {
>  		list_del_init(&ci->i_cap_delay_list);
> +		mdsc->num_cap_delay--;
> +	}
>  	list_add(&ci->i_cap_delay_list, &mdsc->cap_delay_list);
> +	num = ++mdsc->num_cap_delay;
>  	spin_unlock(&mdsc->cap_delay_lock);
> +
> +	if (num > 100) {
> +		flush_delayed_work(&mdsc->delayed_work);
> +		schedule_delayed(mdsc);
> +	}
>  }
>  
>  /*
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 79aa4ce3a388..14e44de05812 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4514,7 +4514,7 @@ void inc_session_sequence(struct ceph_mds_session *s)
>  /*
>   * delayed work -- periodically trim expired leases, renew caps with mds
>   */
> -static void schedule_delayed(struct ceph_mds_client *mdsc)
> +void schedule_delayed(struct ceph_mds_client *mdsc)
>  {
>  	int delay = 5;
>  	unsigned hz = round_jiffies_relative(HZ * delay);
> @@ -4616,6 +4616,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  	mdsc->request_tree = RB_ROOT;
>  	INIT_DELAYED_WORK(&mdsc->delayed_work, delayed_work);
>  	mdsc->last_renew_caps = jiffies;
> +	mdsc->num_cap_delay = 0;
>  	INIT_LIST_HEAD(&mdsc->cap_delay_list);
>  	INIT_LIST_HEAD(&mdsc->cap_wait_list);
>  	spin_lock_init(&mdsc->cap_delay_lock);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index a7af09257382..b4289b8d23ec 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -423,6 +423,7 @@ struct ceph_mds_client {
>  	struct rb_root         request_tree;  /* pending mds requests */
>  	struct delayed_work    delayed_work;  /* delayed work */
>  	unsigned long    last_renew_caps;  /* last time we renewed our caps */
> +	unsigned long    num_cap_delay;    /* caps in the cap_delay_list */
>  	struct list_head cap_delay_list;   /* caps with delayed release */
>  	spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
>  	struct list_head snap_flush_list;  /* cap_snaps ready to flush */
> @@ -568,6 +569,8 @@ extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
>  			  struct ceph_mds_session *session,
>  			  int max_caps);
>  
> +extern void schedule_delayed(struct ceph_mds_client *mdsc);
> +
>  static inline int ceph_wait_on_async_create(struct inode *inode)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);

-- 
Jeff Layton <jlayton@kernel.org>

