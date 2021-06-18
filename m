Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9089A3ACBAF
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Jun 2021 15:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhFRNGQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Jun 2021 09:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhFRNGP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 18 Jun 2021 09:06:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF13A61205;
        Fri, 18 Jun 2021 13:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624021446;
        bh=5SgV00qTm0nED2wUVTokH63W0spaHGR/Pi1420/q8cc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ib+WNayq5Gb+Rll8dx59lkLpEW1rGfIXsBMlCVRZ9CUOcWJHPMhdiKHkINhuHr0Qd
         XhC/yTb9n+QStXKgG6pBEPIu1TQclAwP0pHrSbqiC4ak8ZuPqc8pHwBIIG5zprKjOr
         /kFecGp6/9zzHApdhQYv/x1Y6oyYbBLZlszOVDTZHjLOxyX22vDNydEgIgLz9N868R
         44oxJdEjW8tpYQ7WR/pU3G3bfKc3319HqdZmV/KTeKq0UT9bg0PHWSt4OeBB6W7/fZ
         KwMqetC0Y9VSeEfqqEgJ6kJTexiV78vC96tC0ATCJQq1vSXlMvwB2uVl558IDKq2dh
         O8dEV2gosv8+A==
Message-ID: <edbe17a2339026890983978a96cd66b0edb58e52.camel@kernel.org>
Subject: Re: [RFC PATCH 6/6] ceph: eliminate ceph_async_iput()
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, ukernel@gmail.com,
        idryomov@gmail.com, xiubli@redhat.com
Date:   Fri, 18 Jun 2021 09:04:04 -0400
In-Reply-To: <YMyX/EjKZRV8/liC@suse.de>
References: <20210615145730.21952-1-jlayton@kernel.org>
         <20210615145730.21952-7-jlayton@kernel.org> <YMoYE+DYFt+eEAWm@suse.de>
         <1d1b99544873ba7d7fb5442db152e739a5234c39.camel@kernel.org>
         <YMyX/EjKZRV8/liC@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-06-18 at 13:56 +0100, Luis Henriques wrote:
> On Thu, Jun 17, 2021 at 12:24:35PM -0400, Jeff Layton wrote:
> > On Wed, 2021-06-16 at 16:26 +0100, Luis Henriques wrote:
> > > On Tue, Jun 15, 2021 at 10:57:30AM -0400, Jeff Layton wrote:
> > > > Now that we don't need to hold session->s_mutex or the snap_rwsem when
> > > > calling ceph_check_caps, we can eliminate ceph_async_iput and just use
> > > > normal iput calls.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/caps.c       |  6 +++---
> > > >  fs/ceph/inode.c      | 25 +++----------------------
> > > >  fs/ceph/mds_client.c | 22 +++++++++++-----------
> > > >  fs/ceph/quota.c      |  6 +++---
> > > >  fs/ceph/snap.c       | 10 +++++-----
> > > >  fs/ceph/super.h      |  2 --
> > > >  6 files changed, 25 insertions(+), 46 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > index 5864d5088e27..fd9243e9a1b2 100644
> > > > --- a/fs/ceph/caps.c
> > > > +++ b/fs/ceph/caps.c
> > > > @@ -3147,7 +3147,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
> > > >  		wake_up_all(&ci->i_cap_wq);
> > > >  	while (put-- > 0) {
> > > >  		/* avoid calling iput_final() in osd dispatch threads */
> > > > -		ceph_async_iput(inode);
> > > > +		iput(inode);
> > > >  	}
> > > >  }
> > > >  
> > > > @@ -4136,7 +4136,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
> > > >  done_unlocked:
> > > >  	ceph_put_string(extra_info.pool_ns);
> > > >  	/* avoid calling iput_final() in mds dispatch threads */
> > > > -	ceph_async_iput(inode);
> > > > +	iput(inode);
> > > 
> > > To be honest, I'm not really convinced we can blindly substitute
> > > ceph_async_iput() by iput().  This case specifically can problematic
> > > because we may have called ceph_queue_vmtruncate() above (or
> > > handle_cap_grant()).  If we did, we have ci->i_work_mask set and the wq
> > > would have invoked __ceph_do_pending_vmtruncate().  Using the iput() here
> > > won't have that result.  Am I missing something?
> > > 
> > 
> > The point of this set is to make iput safe to run even when the s_mutex
> > and/or snap_rwsem is held. When we queue up the ci->i_work, we do take a
> > reference to the inode and still run iput there. This set just stops
> > queueing iputs themselves to the workqueue.
> > 
> > I really don't see a problem with this call site in ceph_handle_caps in
> > particular, as it's calling iput after dropping the s_mutex. Probably
> > that should not have been converted to use ceph_async_iput in the first
> > place.
> 
> Obviously, you're right.  I don't what I was thinking of when I was
> reading this code and saw: ci->i_work_mask bits are set in one place (in
> ceph_queue_vmtruncate(), for ex.) and then the work is queued only in
> ceph_async_iput().  Which is obviously wrong!
> 
> Anyway, sorry for the noise.
> 
> (Oh, and BTW: this patch should also remove comments such as "avoid
> calling iput_final() in mds dispatch threads", and similar that exist in
> several places before ceph_async_iput() is (or rather *was*) called.)
> 

Thanks. I saw that I missed a few of those sorts of comments. I'll plan
to remove those before I merge this.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

