Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3296C3BD777
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 15:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhGFNO3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 09:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231344AbhGFNO2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 09:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2225361C82;
        Tue,  6 Jul 2021 13:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625577109;
        bh=VsTEsFKC/Yds6Xpp+N66Htd+vCE7pyBNA5XISkXWxac=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TxN3vnHGD+oRqkeBTaZsdJ+sLe1Aett7wmlBQY/V0GgBW1ni0VKxlnIrJmC5qDJrA
         CiE26XiJXN5yQVEBYNLXPGJbHhl2qhfKACmda9Pe5/Te5PeptmgC9FA/7VyBqtVXQL
         yoUdrCF42SeiLrN2oEE6LG+9qTe5N1Fq5UhpwbYX0JZc1WAGf82z6Kf2zTp7RchHiZ
         P5K7VtkFcQUOoC2AlF1ar5PPRSEByjb4QdCSfgw0ToPURkdrRVLbvYnNLuxo6zUcGD
         wtNYmo9eSs50jUOCS0Nkp2n/6djJtYuWSl1rSSyjotXApuamNJadh3ZhU2Zq0rbe8Z
         9u7LK4saXjqZQ==
Message-ID: <e553452368abc74d4ee2943aa3527672dc668f59.camel@kernel.org>
Subject: Re: [PATCH v2 4/4] ceph: flush the mdlog before waiting on unsafe
 reqs
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 06 Jul 2021 09:11:48 -0400
In-Reply-To: <b6e463c2-6b51-81ce-ee90-36e48e77110b@redhat.com>
References: <20210705012257.182669-1-xiubli@redhat.com>
         <20210705012257.182669-5-xiubli@redhat.com>
         <60e6a0d99abe921232b6cb4b9ce5e31272a06790.camel@kernel.org>
         <b6e463c2-6b51-81ce-ee90-36e48e77110b@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-07-06 at 20:37 +0800, Xiubo Li wrote:
> On 7/6/21 7:42 PM, Jeff Layton wrote:
> > On Mon, 2021-07-05 at 09:22 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > For the client requests who will have unsafe and safe replies from
> > > MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
> > > (journal log) immediatelly, because they think it's unnecessary.
> > > That's true for most cases but not all, likes the fsync request.
> > > The fsync will wait until all the unsafe replied requests to be
> > > safely replied.
> > > 
> > > Normally if there have multiple threads or clients are running, the
> > > whole mdlog in MDS daemons could be flushed in time if any request
> > > will trigger the mdlog submit thread. So usually we won't experience
> > > the normal operations will stuck for a long time. But in case there
> > > has only one client with only thread is running, the stuck phenomenon
> > > maybe obvious and the worst case it must wait at most 5 seconds to
> > > wait the mdlog to be flushed by the MDS's tick thread periodically.
> > > 
> > > This patch will trigger to flush the mdlog in the relevant and auth
> > > MDSes to which the in-flight requests are sent just before waiting
> > > the unsafe requests to finish.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/caps.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 78 insertions(+)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index c6a3352a4d52..4b966c29d9b5 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -2286,6 +2286,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
> > >    */
> > >   static int unsafe_request_wait(struct inode *inode)
> > >   {
> > > +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> > >   	struct ceph_inode_info *ci = ceph_inode(inode);
> > >   	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> > >   	int ret, err = 0;
> > > @@ -2305,6 +2306,82 @@ static int unsafe_request_wait(struct inode *inode)
> > >   	}
> > >   	spin_unlock(&ci->i_unsafe_lock);
> > >   
> > > +	/*
> > > +	 * Trigger to flush the journal logs in all the relevant MDSes
> > > +	 * manually, or in the worst case we must wait at most 5 seconds
> > > +	 * to wait the journal logs to be flushed by the MDSes periodically.
> > > +	 */
> > > +	if (req1 || req2) {
> > > +		struct ceph_mds_session **sessions = NULL;
> > > +		struct ceph_mds_session *s;
> > > +		struct ceph_mds_request *req;
> > > +		unsigned int max;
> > > +		int i;
> > > +
> > > +		/*
> > > +		 * The mdsc->max_sessions is unlikely to be changed
> > > +		 * mostly, here we will retry it by reallocating the
> > > +		 * sessions arrary memory to get rid of the mdsc->mutex
> > > +		 * lock.
> > > +		 */
> > > +retry:
> > > +		max = mdsc->max_sessions;
> > > +		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
> > The kerneldoc over krealloc() says:
> > 
> >   * The contents of the object pointed to are preserved up to the
> >   * lesser of the new and old sizes (__GFP_ZERO flag is effectively
> > ignored).
> > 
> > This code however relies on krealloc zeroing out the new part of the
> > allocation. Do you know for certain that that works?
> 
> I readed the krealloc() code, the "__GFP_ZERO flag will be ignored" only 
> for the preserved contents. If the slab really needs to allocate a new 
> object, the slab will help zero it first and then copy the old contents 
> to it, the new part will keep zeroed.
> 
> 

Ok, and in the case where it's an initial kmalloc, that will be done
with __GFP_ZERO so any remaining space in the allocation will already be
zeroed. That works.

> > > +		if (!sessions) {
> > > +			err = -ENOMEM;
> > > +			goto out;
> > > +		}
> > > +		spin_lock(&ci->i_unsafe_lock);
> > > +		if (req1) {
> > > +			list_for_each_entry(req, &ci->i_unsafe_dirops,
> > > +					    r_unsafe_dir_item) {
> > > +				s = req->r_session;
> > > +				if (unlikely(s->s_mds > max)) {
> > > +					spin_unlock(&ci->i_unsafe_lock);
> > > +					goto retry;
> > > +				}
> > > +				if (!sessions[s->s_mds]) {
> > > +					s = ceph_get_mds_session(s);
> > > +					sessions[s->s_mds] = s;
> > nit: maybe just do:
> > 
> >      sessions[s->s_mds] = ceph_get_mds_session(s);
> 
> Then it will exceed 80 chars for this line. Should we ignore it here ?
> 

I probably would have but it's not worth respinning over all by itself.

It might also be possible to do all of this without taking the
i_unsafe_lock twice, but that too probably won't make much difference.

I'll give these a closer look and probably merge into testing branch
later today unless I see a problem.

Thanks!
Jeff

> > 
> > > +				}
> > > +			}
> > > +		}
> > > +		if (req2) {
> > > +			list_for_each_entry(req, &ci->i_unsafe_iops,
> > > +					    r_unsafe_target_item) {
> > > +				s = req->r_session;
> > > +				if (unlikely(s->s_mds > max)) {
> > > +					spin_unlock(&ci->i_unsafe_lock);
> > > +					goto retry;
> > > +				}
> > > +				if (!sessions[s->s_mds]) {
> > > +					s = ceph_get_mds_session(s);
> > > +					sessions[s->s_mds] = s;
> > > +				}
> > > +			}
> > > +		}
> > > +		spin_unlock(&ci->i_unsafe_lock);
> > > +
> > > +		/* the auth MDS */
> > > +		spin_lock(&ci->i_ceph_lock);
> > > +		if (ci->i_auth_cap) {
> > > +		      s = ci->i_auth_cap->session;
> > > +		      if (!sessions[s->s_mds])
> > > +			      sessions[s->s_mds] = ceph_get_mds_session(s);
> > > +		}
> > > +		spin_unlock(&ci->i_ceph_lock);
> > > +
> > > +		/* send flush mdlog request to MDSes */
> > > +		for (i = 0; i < max; i++) {
> > > +			s = sessions[i];
> > > +			if (s) {
> > > +				send_flush_mdlog(s);
> > > +				ceph_put_mds_session(s);
> > > +			}
> > > +		}
> > > +		kfree(sessions);
> > > +	}
> > > +
> > >   	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
> > >   	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
> > >   	if (req1) {
> > > @@ -2321,6 +2398,7 @@ static int unsafe_request_wait(struct inode *inode)
> > >   			err = -EIO;
> > >   		ceph_mdsc_put_request(req2);
> > >   	}
> > > +out:
> > >   	return err;
> > >   }
> > >   
> > Otherwise the whole set looks pretty reasonable.
> > 
> > Thanks,
> 

-- 
Jeff Layton <jlayton@kernel.org>

