Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DF5198362
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Mar 2020 20:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgC3S2j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Mar 2020 14:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgC3S2j (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 14:28:39 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A898D206F6;
        Mon, 30 Mar 2020 18:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585592918;
        bh=0MCW7ehYCnf4bjOfAfmGXNIyzsb+HIs0HaVBPtW53q0=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=0QfMaRJF6QTQghAaBVCYi3f/7UCvhUZzkNE7jW4JA0j2Pqgv5O2JLyGtZ3amG6ZmP
         e7Odwaqds/h8bAqMSP3ApZfZD8ITwpFJvgQ5OlVKPM1vxykC8YUQdStCAI0TXuaefs
         GCEwRxfCxMbfwVL0SzBjO9PYwPoQbdYoaZampdow=
Message-ID: <9f75e21301149a550ab6868cf645a89b538f16d0.camel@kernel.org>
Subject: Re: [PATCH] ceph: reset i_requested_max_size if file write is not
 wanted
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Mon, 30 Mar 2020 14:28:37 -0400
In-Reply-To: <1d8f55c9-4d51-6b06-7052-9ce088057e9c@redhat.com>
References: <20200330115637.31019-1-zyan@redhat.com>
         <49fe2d9a5956346af46fb4ce37ccc0c8c35185e2.camel@kernel.org>
         <1d8f55c9-4d51-6b06-7052-9ce088057e9c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-03-30 at 22:26 +0800, Yan, Zheng wrote:
> On 3/30/20 10:00 PM, Jeff Layton wrote:
> > On Mon, 2020-03-30 at 19:56 +0800, Yan, Zheng wrote:
> > > write can stuck at waiting for larger max_size in following sequence of
> > > events:
> > > 
> > > - client opens a file and writes to position 'A' (larger than unit of
> > >    max size increment)
> > > - client closes the file handle and updates wanted caps (not wanting
> > >    file write caps)
> > > - client opens and truncates the file, writes to position 'A' again.
> > > 
> > > At the 1st event, client set inode's requested_max_size to 'A'. At the
> > > 2nd event, mds removes client's writable range, but client does not reset
> > > requested_max_size. At the 3rd event, client does not request max size
> > > because requested_max_size is already larger than 'A'.
> > > 
> > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > ---
> > >   fs/ceph/caps.c | 29 +++++++++++++++++++----------
> > >   1 file changed, 19 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index f8b51d0c8184..61808793e0c0 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -1363,8 +1363,12 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
> > >   	arg->size = inode->i_size;
> > >   	ci->i_reported_size = arg->size;
> > >   	arg->max_size = ci->i_wanted_max_size;
> > > -	if (cap == ci->i_auth_cap)
> > > -		ci->i_requested_max_size = arg->max_size;
> > > +	if (cap == ci->i_auth_cap) {
> > > +		if (want & CEPH_CAP_ANY_FILE_WR)
> > > +			ci->i_requested_max_size = arg->max_size;
> > > +		else
> > > +			ci->i_requested_max_size = 0;
> > > +	}
> > >   
> > >   	if (flushing & CEPH_CAP_XATTR_EXCL) {
> > >   		arg->old_xattr_buf = __ceph_build_xattrs_blob(ci);
> > > @@ -3343,10 +3347,6 @@ static void handle_cap_grant(struct inode *inode,
> > >   				ci->i_requested_max_size = 0;
> > >   			}
> > >   			wake = true;
> > > -		} else if (ci->i_wanted_max_size > ci->i_max_size &&
> > > -			   ci->i_wanted_max_size > ci->i_requested_max_size) {
> > > -			/* CEPH_CAP_OP_IMPORT */
> > > -			wake = true;
> > >   		}
> > >   	}
> > >   
> > > @@ -3422,9 +3422,18 @@ static void handle_cap_grant(struct inode *inode,
> > >   			fill_inline = true;
> > >   	}
> > >   
> > > -	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> > > +	if (ci->i_auth_cap == cap &&
> > > +	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> > >   		if (newcaps & ~extra_info->issued)
> > >   			wake = true;
> > > +
> > > +		if (ci->i_requested_max_size > max_size ||
> > > +		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> > > +			/* re-request max_size if necessary */
> > > +			ci->i_requested_max_size = 0;
> > > +			wake = true;
> > > +		}
> > > +
> > >   		ceph_kick_flushing_inode_caps(session, ci);
> > >   		spin_unlock(&ci->i_ceph_lock);
> > >   		up_read(&session->s_mdsc->snap_rwsem);
> > > @@ -3882,9 +3891,6 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
> > >   		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
> > >   	}
> > >   
> > > -	/* make sure we re-request max_size, if necessary */
> > > -	ci->i_requested_max_size = 0;
> > > -
> > >   	*old_issued = issued;
> > >   	*target_cap = cap;
> > >   }
> > > @@ -4318,6 +4324,9 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
> > >   				cap->issued &= ~drop;
> > >   				cap->implemented &= ~drop;
> > >   				cap->mds_wanted = wanted;
> > > +				if (cap == ci->i_auth_cap &&
> > > +				    !(wanted & CEPH_CAP_ANY_FILE_WR))
> > > +					ci->i_requested_max_size = 0;
> > >   			} else {
> > >   				dout("encode_inode_release %p cap %p %s"
> > >   				     " (force)\n", inode, cap,
> > 
> > Thanks Zheng. I assume this is a regression in the "don't request caps
> > for idle open files" series? If so, is there a commit that definitively
> > broke it? It'd be good to add a Fixes: tag for that if we can to help
> > backporters.
> > 
> > Thanks,
> > 
> 
> It's not regression. It' kclient version of 
> https://tracker.ceph.com/issues/44801. I only saw this bug in ceph-fuse, 
> kclient contain this bug in theory.
> 

Got it, thanks. Merged into ceph-client/testing. I did not mark it for
stable. Let me know if you think it should be.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

