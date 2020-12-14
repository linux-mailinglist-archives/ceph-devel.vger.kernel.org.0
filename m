Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3722B2D9B26
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Dec 2020 16:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408041AbgLNPfT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Dec 2020 10:35:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:53362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731521AbgLNPfH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 10:35:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 847BFACE0;
        Mon, 14 Dec 2020 15:34:24 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 5aff0c9d;
        Mon, 14 Dec 2020 15:34:53 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, idryomov@gmail.com
Subject: Re: [PATCH 2/3] ceph: clean up inode work queueing
References: <20201211123858.7522-1-jlayton@kernel.org>
        <20201211123858.7522-3-jlayton@kernel.org>
Date:   Mon, 14 Dec 2020 15:34:52 +0000
In-Reply-To: <20201211123858.7522-3-jlayton@kernel.org> (Jeff Layton's message
        of "Fri, 11 Dec 2020 07:38:57 -0500")
Message-ID: <871rfs2yg3.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> Add a generic function for taking an inode reference, setting the I_WORK
> bit and queueing i_work. Turn the ceph_queue_* functions into static
> inline wrappers that pass in the right bit.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/inode.c | 55 ++++++-------------------------------------------
>  fs/ceph/super.h | 21 ++++++++++++++++---
>  2 files changed, 24 insertions(+), 52 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index c870be90d850..9cd8b37e586a 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1816,60 +1816,17 @@ void ceph_async_iput(struct inode *inode)
>  	}
>  }
>  
> -/*
> - * Write back inode data in a worker thread.  (This can't be done
> - * in the message handler context.)
> - */
> -void ceph_queue_writeback(struct inode *inode)
> -{
> -	struct ceph_inode_info *ci = ceph_inode(inode);
> -	set_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask);
> -
> -	ihold(inode);
> -	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
> -		       &ci->i_work)) {
> -		dout("ceph_queue_writeback %p\n", inode);
> -	} else {
> -		dout("ceph_queue_writeback %p already queued, mask=%lx\n",
> -		     inode, ci->i_work_mask);
> -		iput(inode);
> -	}
> -}
> -
> -/*
> - * queue an async invalidation
> - */
> -void ceph_queue_invalidate(struct inode *inode)
> -{
> -	struct ceph_inode_info *ci = ceph_inode(inode);
> -	set_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask);
> -
> -	ihold(inode);
> -	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
> -		       &ceph_inode(inode)->i_work)) {
> -		dout("ceph_queue_invalidate %p\n", inode);
> -	} else {
> -		dout("ceph_queue_invalidate %p already queued, mask=%lx\n",
> -		     inode, ci->i_work_mask);
> -		iput(inode);
> -	}
> -}
> -
> -/*
> - * Queue an async vmtruncate.  If we fail to queue work, we will handle
> - * the truncation the next time we call __ceph_do_pending_vmtruncate.
> - */
> -void ceph_queue_vmtruncate(struct inode *inode)
> +void ceph_queue_inode_work(struct inode *inode, int work_bit)
>  {
> +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -	set_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask);
> +	set_bit(work_bit, &ci->i_work_mask);
>  
>  	ihold(inode);
> -	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
> -		       &ci->i_work)) {
> -		dout("ceph_queue_vmtruncate %p\n", inode);
> +	if (queue_work(fsc->inode_wq, &ceph_inode(inode)->i_work)) {

Nit: since we have ci, it should probably be used here^^ instead of
ceph_inode() (this is likely a ceph_queue_invalidate function leftover,
which already had this inconsistency).

Other than that, these patches look good although I (obviously) haven't
seen the lockdep warning you mention.  Hopefully I'll never see it ever,
with these patches applied ;-)

Cheers,
-- 
Luis

> +		dout("queue_inode_work %p, mask=%lx\n", inode, ci->i_work_mask);
>  	} else {
> -		dout("ceph_queue_vmtruncate %p already queued, mask=%lx\n",
> +		dout("queue_inode_work %p already queued, mask=%lx\n",
>  		     inode, ci->i_work_mask);
>  		iput(inode);
>  	}
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index b62d8fee3b86..59153ee201c0 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -962,11 +962,26 @@ extern int ceph_inode_holds_cap(struct inode *inode, int mask);
>  
>  extern bool ceph_inode_set_size(struct inode *inode, loff_t size);
>  extern void __ceph_do_pending_vmtruncate(struct inode *inode);
> -extern void ceph_queue_vmtruncate(struct inode *inode);
> -extern void ceph_queue_invalidate(struct inode *inode);
> -extern void ceph_queue_writeback(struct inode *inode);
> +
>  extern void ceph_async_iput(struct inode *inode);
>  
> +void ceph_queue_inode_work(struct inode *inode, int work_bit);
> +
> +static inline void ceph_queue_vmtruncate(struct inode *inode)
> +{
> +	ceph_queue_inode_work(inode, CEPH_I_WORK_VMTRUNCATE);
> +}
> +
> +static inline void ceph_queue_invalidate(struct inode *inode)
> +{
> +	ceph_queue_inode_work(inode, CEPH_I_WORK_INVALIDATE_PAGES);
> +}
> +
> +static inline void ceph_queue_writeback(struct inode *inode)
> +{
> +	ceph_queue_inode_work(inode, CEPH_I_WORK_WRITEBACK);
> +}
> +
>  extern int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>  			     int mask, bool force);
>  static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
> -- 
>
> 2.29.2
>
