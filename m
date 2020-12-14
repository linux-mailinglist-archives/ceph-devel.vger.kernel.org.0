Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E292D9B80
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Dec 2020 16:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439541AbgLNPw1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Dec 2020 10:52:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730761AbgLNPwT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 10:52:19 -0500
Message-ID: <c66a8ed80a647620a4f9ca837c44bf278d15ca9c.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607961098;
        bh=R5Z7kVa+VAhScSsCOMLeyRnradKMB/d0Wkqv9oUf2aA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BGf5qAkfqlbuqkNQjZtxaTssTdT+iWaA70B9aYUIoa+4rR30tVsFc8MleIKOrNPZ/
         DtH0dkomTsnPayRuoFuTyxXin+dqBLwA7p3+3IwOaQs1LViUhzeqYf5EOvBtIOC1tp
         oazKF1ZXD99VZqnjXDAuzmWjTXq3MAgXKmeUfsFwvy6XKRJQs+H8b11/7FEw79PPvp
         1Jy4gyfbXjxeDovN5xdmIYY2fHaSJZooR6BlklG213pPY9Yl0h3vgtGmXH2+Jjfk2v
         jrtAxnC8/iko4mLZr8fwgQKHzEITwBFZfw+r4MC9MscQtnjGL5fgKagkBkUsQxqgcZ
         vCerDOOjUGMmg==
Subject: Re: [PATCH 2/3] ceph: clean up inode work queueing
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, idryomov@gmail.com
Date:   Mon, 14 Dec 2020 10:51:36 -0500
In-Reply-To: <871rfs2yg3.fsf@suse.de>
References: <20201211123858.7522-1-jlayton@kernel.org>
         <20201211123858.7522-3-jlayton@kernel.org> <871rfs2yg3.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-12-14 at 15:34 +0000, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > Add a generic function for taking an inode reference, setting the I_WORK
> > bit and queueing i_work. Turn the ceph_queue_* functions into static
> > inline wrappers that pass in the right bit.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/inode.c | 55 ++++++-------------------------------------------
> >  fs/ceph/super.h | 21 ++++++++++++++++---
> >  2 files changed, 24 insertions(+), 52 deletions(-)
> > 
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index c870be90d850..9cd8b37e586a 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1816,60 +1816,17 @@ void ceph_async_iput(struct inode *inode)
> >  	}
> >  }
> >  
> > 
> > -/*
> > - * Write back inode data in a worker thread.  (This can't be done
> > - * in the message handler context.)
> > - */
> > -void ceph_queue_writeback(struct inode *inode)
> > -{
> > -	struct ceph_inode_info *ci = ceph_inode(inode);
> > -	set_bit(CEPH_I_WORK_WRITEBACK, &ci->i_work_mask);
> > -
> > -	ihold(inode);
> > -	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
> > -		       &ci->i_work)) {
> > -		dout("ceph_queue_writeback %p\n", inode);
> > -	} else {
> > -		dout("ceph_queue_writeback %p already queued, mask=%lx\n",
> > -		     inode, ci->i_work_mask);
> > -		iput(inode);
> > -	}
> > -}
> > -
> > -/*
> > - * queue an async invalidation
> > - */
> > -void ceph_queue_invalidate(struct inode *inode)
> > -{
> > -	struct ceph_inode_info *ci = ceph_inode(inode);
> > -	set_bit(CEPH_I_WORK_INVALIDATE_PAGES, &ci->i_work_mask);
> > -
> > -	ihold(inode);
> > -	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
> > -		       &ceph_inode(inode)->i_work)) {
> > -		dout("ceph_queue_invalidate %p\n", inode);
> > -	} else {
> > -		dout("ceph_queue_invalidate %p already queued, mask=%lx\n",
> > -		     inode, ci->i_work_mask);
> > -		iput(inode);
> > -	}
> > -}
> > -
> > -/*
> > - * Queue an async vmtruncate.  If we fail to queue work, we will handle
> > - * the truncation the next time we call __ceph_do_pending_vmtruncate.
> > - */
> > -void ceph_queue_vmtruncate(struct inode *inode)
> > +void ceph_queue_inode_work(struct inode *inode, int work_bit)
> >  {
> > +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> >  	struct ceph_inode_info *ci = ceph_inode(inode);
> > -	set_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask);
> > +	set_bit(work_bit, &ci->i_work_mask);
> >  
> > 
> >  	ihold(inode);
> > -	if (queue_work(ceph_inode_to_client(inode)->inode_wq,
> > -		       &ci->i_work)) {
> > -		dout("ceph_queue_vmtruncate %p\n", inode);
> > +	if (queue_work(fsc->inode_wq, &ceph_inode(inode)->i_work)) {
> 
> Nit: since we have ci, it should probably be used here^^ instead of
> ceph_inode() (this is likely a ceph_queue_invalidate function leftover,
> which already had this inconsistency).
> 
> Other than that, these patches look good although I (obviously) haven't
> seen the lockdep warning you mention.  Hopefully I'll never see it ever,
> with these patches applied ;-)
> 
> Cheers,

Thanks Luis,

I went ahead and made the above change and pushed the set into the
testing branch (note that this patch supersedes the queue_inode_work
patch I sent a couple of weeks ago).
 
-- 
Jeff Layton <jlayton@kernel.org>

