Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC1B3B81D0
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 14:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhF3MPy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 08:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234387AbhF3MPy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 08:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6A83619A0;
        Wed, 30 Jun 2021 12:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625055205;
        bh=1wwRGGhAcNgdogtJnGkNtjPTFbl1R4gYLbU3VJvf4Kw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=skd4YfJv37Ng5v5tAkwgYowbcuQmq44y5V8eF6oTwkNt/nG5FPP0NqBgjCg4pFIqg
         6nTXzrm9yGcTGQWu1RtNaOF3n6nh0fkuV+hTUBToiZfJOzyFxZ1JM6FAFs8XKR545+
         OPu2KZqs/CPyDerGfXcbqKoILvRvFvqSnDSG57HWtOGpBei6GZHutU4KDUnW0kXdN0
         PYx64G0P/bO0RwYtVmQlw56Z3HeOVfA90hGwnQpBEVTdrdqXX3MtN/+4Jn+XeSDU9P
         EBkheQSQUKfyyeHAToVBGeiUK/IuxIo6o51JGxRHfPYXtlVj69mKXNXpZax3RLrMFE
         2W7E2xbYOQrYA==
Message-ID: <2e8aabad80e166d7c628fde9d820fc5f403e034f.camel@kernel.org>
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 30 Jun 2021 08:13:23 -0400
In-Reply-To: <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
         <20210629044241.30359-5-xiubli@redhat.com>
         <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
         <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-06-30 at 09:26 +0800, Xiubo Li wrote:
> On 6/29/21 9:25 PM, Jeff Layton wrote:
> > On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
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
> > > This patch will trigger to flush the mdlog in all the MDSes manually
> > > just before waiting the unsafe requests to finish.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/caps.c | 9 +++++++++
> > >   1 file changed, 9 insertions(+)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index c6a3352a4d52..6e80e4649c7a 100644
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
> > > @@ -2305,6 +2306,14 @@ static int unsafe_request_wait(struct inode *inode)
> > >   	}
> > >   	spin_unlock(&ci->i_unsafe_lock);
> > >   
> > > +	/*
> > > +	 * Trigger to flush the journal logs in all the MDSes manually,
> > > +	 * or in the worst case we must wait at most 5 seconds to wait
> > > +	 * the journal logs to be flushed by the MDSes periodically.
> > > +	 */
> > > +	if (req1 || req2)
> > > +		flush_mdlog(mdsc);
> > > +
> > So this is called on fsync(). Do we really need to flush all of the mds
> > logs on every fsync? That sounds like it might have some performance
> > impact. Would it be possible to just flush the mdslog on the MDS that's
> > authoritative for this inode?
> 
> I hit one case before, the mds.0 is the auth mds, but the client just 
> sent the request to mds.2, then when the mds.2 tried to gather the 
> rdlocks then it was stuck for waiting for the mds.0 to flush the mdlog. 
> I think it also will happen that if the mds.0 could also be stuck just 
> like this even its the auth MDS.
> 

It sounds like mds.0 should flush its own mdlog in this situation once
mds.2 started requesting locks that mds.0 was holding. Shouldn't it?

> Normally the mdlog submit thread will be triggered per MDS's tick, 
> that's 5 seconds. But this is not always true mostly because any other 
> client request could trigger the mdlog submit thread to run at any time. 
> Since the fsync is not running all the time, so IMO the performance 
> impact should be okay.
> 
> 

I'm not sure I'm convinced.

Consider a situation where we have a large(ish) ceph cluster with
several MDSs. One client is writing to a file that is on mds.0 and there
is little other activity there. Several other clients are doing heavy
I/O on other inodes (of which mds.1 is auth).

The first client then calls fsync, and now the other clients stall for a
bit while mds.1 unnecessarily flushes its mdlog. I think we need to take
care to only flush the mdlog for mds's that we care about here.


> > 
> > >   	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
> > >   	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
> > >   	if (req1) {
> 

-- 
Jeff Layton <jlayton@kernel.org>

