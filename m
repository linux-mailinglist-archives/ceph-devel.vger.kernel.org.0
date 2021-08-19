Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8903F179A
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 12:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbhHSLAM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Aug 2021 07:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238433AbhHSLAJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 07:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64C0861152;
        Thu, 19 Aug 2021 10:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629370773;
        bh=YWSW8qBHpX1zfE6x+cdgLlvrK1XVqvJgNYLAPMo5fqo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s/RDTnU3QSrQnVdXG8+h+q/qdg7jA73XAtFZ1+H5ro+K7bqmd/hyJl5WFz2DCiwqY
         rw0sZF7QHM17eQ1//XpSpPhbBqwInBAQ630njIjn2kHyIS3NcSbDxjRVkQOj/FuNwL
         ic4Vj+zKM8tb+BX83jtHnz8S90zhNfrwkDtHYoFuB9neq8ONiPrAZr3HMAKbNR+UTz
         ZMP478AhIhox9jZ4LTpcRaFwcRXjd/U0ZWbWySM2Xl8sbjLr7BiwZK+LWcro0sXD5t
         3YoVePe3AeTnq3JrAgG/0GzURFs9kvWd5Cl6f0GqSg4naC0apsAvyfhbHLp/9UGt9H
         0rgtokTFzbcSA==
Message-ID: <e290f32319721d894b1d44c4be37b5b617a18780.camel@kernel.org>
Subject: Re: [PATCH v4] ceph: correctly release memory from capsnap
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 19 Aug 2021 06:59:32 -0400
In-Reply-To: <f2bf8537-41a5-c406-ec11-c11a40d79a42@redhat.com>
References: <20210818133842.15993-1-xiubli@redhat.com>
         <007becbddbb928e7cb52feb5ffafb4f254dd5ba0.camel@kernel.org>
         <f2bf8537-41a5-c406-ec11-c11a40d79a42@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-08-19 at 07:43 +0800, Xiubo Li wrote:
> On 8/19/21 12:06 AM, Jeff Layton wrote:
> > On Wed, 2021-08-18 at 21:38 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > When force umounting, it will try to remove all the session caps.
> > > If there has any capsnap is in the flushing list, the remove session
> > > caps callback will try to release the capsnap->flush_cap memory to
> > > "ceph_cap_flush_cachep" slab cache, while which is allocated from
> > > kmalloc-256 slab cache.
> > > 
> > > At the same time switch to list_del_init() because just in case the
> > > force umount has removed it from the lists and the
> > > handle_cap_flushsnap_ack() comes then the seconds list_del_init()
> > > won't crash the kernel.
> > > 
> > > URL: https://tracker.ceph.com/issues/52283
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > > 
> > > Changed in V4:
> > > - add a new is_capsnap field in ceph_cap_flush struct.
> > > 
> > > 
> > >   fs/ceph/caps.c       | 19 ++++++++++++-------
> > >   fs/ceph/mds_client.c |  7 ++++---
> > >   fs/ceph/snap.c       |  1 +
> > >   fs/ceph/super.h      |  3 ++-
> > >   4 files changed, 19 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 4663ab830614..52c7026fd0d1 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -1712,7 +1712,11 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
> > >   
> > >   struct ceph_cap_flush *ceph_alloc_cap_flush(void)
> > >   {
> > > -	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> > > +	struct ceph_cap_flush *cf;
> > > +
> > > +	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> > > +	cf->is_capsnap = false;
> > > +	return cf;
> > >   }
> > >   
> > >   void ceph_free_cap_flush(struct ceph_cap_flush *cf)
> > > @@ -1747,7 +1751,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
> > >   		prev->wake = true;
> > >   		wake = false;
> > >   	}
> > > -	list_del(&cf->g_list);
> > > +	list_del_init(&cf->g_list);
> > >   	return wake;
> > >   }
> > >   
> > > @@ -1762,7 +1766,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
> > >   		prev->wake = true;
> > >   		wake = false;
> > >   	}
> > > -	list_del(&cf->i_list);
> > > +	list_del_init(&cf->i_list);
> > >   	return wake;
> > >   }
> > >   
> > > @@ -2400,7 +2404,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
> > >   	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
> > >   
> > >   	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
> > > -		if (!cf->caps) {
> > > +		if (cf->is_capsnap) {
> > >   			last_snap_flush = cf->tid;
> > >   			break;
> > >   		}
> > > @@ -2419,7 +2423,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
> > >   
> > >   		first_tid = cf->tid + 1;
> > >   
> > > -		if (cf->caps) {
> > > +		if (!cf->is_capsnap) {
> > >   			struct cap_msg_args arg;
> > >   
> > >   			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
> > > @@ -3568,7 +3572,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
> > >   			cleaned = cf->caps;
> > >   
> > >   		/* Is this a capsnap? */
> > > -		if (cf->caps == 0)
> > > +		if (cf->is_capsnap)
> > >   			continue;
> > >   
> > >   		if (cf->tid <= flush_tid) {
> > > @@ -3642,7 +3646,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
> > >   		cf = list_first_entry(&to_remove,
> > >   				      struct ceph_cap_flush, i_list);
> > >   		list_del(&cf->i_list);
> > > -		ceph_free_cap_flush(cf);
> > > +		if (!cf->is_capsnap)
> > > +			ceph_free_cap_flush(cf);
> > >   	}
> > >   
> > >   	if (wake_ci)
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index dcb5f34a084b..b9e6a69cc058 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -1656,7 +1656,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >   		spin_lock(&mdsc->cap_dirty_lock);
> > >   
> > >   		list_for_each_entry(cf, &to_remove, i_list)
> > > -			list_del(&cf->g_list);
> > > +			list_del_init(&cf->g_list);
> > >   
> > >   		if (!list_empty(&ci->i_dirty_item)) {
> > >   			pr_warn_ratelimited(
> > > @@ -1710,8 +1710,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >   		struct ceph_cap_flush *cf;
> > >   		cf = list_first_entry(&to_remove,
> > >   				      struct ceph_cap_flush, i_list);
> > > -		list_del(&cf->i_list);
> > > -		ceph_free_cap_flush(cf);
> > > +		list_del_init(&cf->i_list);
> > > +		if (!cf->is_capsnap)
> > > +			ceph_free_cap_flush(cf);
> > >   	}
> > >   
> > >   	wake_up_all(&ci->i_cap_wq);
> > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > index af502a8245f0..62fab59bbf96 100644
> > > --- a/fs/ceph/snap.c
> > > +++ b/fs/ceph/snap.c
> > > @@ -487,6 +487,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
> > >   		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
> > >   		return;
> > >   	}
> > > +	capsnap->cap_flush.is_capsnap = true;
> > >   
> > >   	spin_lock(&ci->i_ceph_lock);
> > >   	used = __ceph_caps_used(ci);
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 106ddfd1ce92..336350861791 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -186,8 +186,9 @@ struct ceph_cap {
> > >   
> > >   struct ceph_cap_flush {
> > >   	u64 tid;
> > > -	int caps; /* 0 means capsnap */
> > > +	int caps;
> > >   	bool wake; /* wake up flush waiters when finish ? */
> > > +	bool is_capsnap; /* true means capsnap */
> > >   	struct list_head g_list; // global
> > >   	struct list_head i_list; // per inode
> > >   	struct ceph_inode_info *ci;
> > Looks good, Xiubo. I'll merge into testing after a bit of local testing
> > on my part.
> > 
> > I'll plan to mark this one for stable too, but I'll need to look at the
> > prerequisites as there may be merge conflicts with earlier kernels.
> 
> I tried it but not all, for some old kernels it may conflict with the 
> code only in `__detach_cap_flush_from_mdsc()` and 
> `__detach_cap_flush_from_ci()`, which will fold these two funcs into 
> __finish_cap_flush().
> 

Yeah, there are quite a few merge conflicts on older kernels and pulling
in earlier patches to eliminate them just brings in more conflicts. We
may have to do a custom backport on this one for some of the older
stable kernels.

-- 
Jeff Layton <jlayton@kernel.org>

