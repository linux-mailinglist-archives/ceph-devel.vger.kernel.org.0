Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418942B1ADF
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Nov 2020 13:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgKMMNM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Nov 2020 07:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgKMMNL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 07:13:11 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D5AE2085B;
        Fri, 13 Nov 2020 12:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605269589;
        bh=O6PzK5exAWOhFPS2u7Fw7/Hi/jyaM/VyjFdzmG9Pww0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WQ/nNZ3sOK6+e0CtsTcy/cxY+vvkXvpHWPSaoDEVprOjYQHmAygyfIRKLE7oGKJbF
         2l8XsMF4dhzjf5qo2fSBvMpk9/ss9jeFKcoCrbZxOaErPqH2eCgjMrG5yqSKVa8SGV
         K/sDUgilW+6y099LjCSHB7EA3ojFrAUATcvurcp0=
Message-ID: <ff7d39759e1a43237e0e8ab209543834a69b5132.camel@kernel.org>
Subject: Re: [PATCH] ceph: when filling trace, do ceph_get_inode outside of
 mutexes
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, gengjichao@jd.com
Date:   Fri, 13 Nov 2020 07:13:07 -0500
In-Reply-To: <87361d8rr2.fsf@suse.de>
References: <20201112181555.539948-1-jlayton@kernel.org>
         <720728ce40c340d5db2a4c003f89483a68876fe5.camel@kernel.org>
         <87361d8rr2.fsf@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-11-13 at 10:40 +0000, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > On Thu, 2020-11-12 at 13:15 -0500, Jeff Layton wrote:
> > > Geng Jichao reported a rather complex deadlock involving several
> > > moving parts:
> > > 
> > > 1) readahead is issued against an inode and some of its pages are locked
> > >    while the read is in flight
> > > 
> > > 2) the same inode is evicted from the cache, and this task gets stuck
> > >    waiting for the page lock because of the above readahead
> > > 
> > > 3) another task is processing a reply trace, and looks up the inode
> > >    being evicted while holding the s_mutex. That ends up waiting for the
> > >    eviction to complete
> > > 
> > > 4) a write reply for an unrelated inode is then processed in the
> > >    ceph_con_workfn job. It calls ceph_check_caps after putting wrbuffer
> > >    caps, and that gets stuck waiting on the s_mutex held by 3.
> > > 
> > > The reply to "1" is stuck behind the write reply in "4", so we deadlock
> > > at that point.
> > > 
> > > This patch changes the trace processing to call ceph_get_inode outside
> > > of the s_mutex and snap_rwsem, which should break the cycle above.
> > > 
> > > URL: https://tracker.ceph.com/issues/47998
> > > Reported-by: Geng Jichao <gengjichao@jd.com>
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/inode.c      | 13 ++++---------
> > >  fs/ceph/mds_client.c | 15 +++++++++++++++
> > >  2 files changed, 19 insertions(+), 9 deletions(-)
> > > 
> > 
> > My belief is that this patch probably won't hurt anything and might fix
> > this specific deadlock. I do however wonder if we might have a whole
> > class of deadlocks of this nature. I can't quite prove it by inspection
> > though, so testing with this would be a good datapoint.
> 
> Yeah, I keep staring at this and can't decide either.  But I agree with
> you: this may or may not fix the issue, but shouldn't hurt.  Just a minor
> comment bellow:
> 
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index 88bbeb05bd27..9b85d86d8efb 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -1315,15 +1315,10 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> > >  	}
> > >  
> > > 
> > > 
> > > 
> > >  	if (rinfo->head->is_target) {
> > > -		tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
> > > -		tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
> > > -
> > > -		in = ceph_get_inode(sb, tvino);
> > > -		if (IS_ERR(in)) {
> > > -			err = PTR_ERR(in);
> > > -			goto done;
> > > -		}
> > > +		/* Should be filled in by handle_reply */
> > > +		BUG_ON(!req->r_target_inode);
> > >  
> > > 
> > > 
> > > 
> > > +		in = req->r_target_inode;
> > >  		err = ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
> > >  				NULL, session,
> > >  				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
> > > @@ -1333,13 +1328,13 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> > >  		if (err < 0) {
> > >  			pr_err("ceph_fill_inode badness %p %llx.%llx\n",
> > >  				in, ceph_vinop(in));
> > > +			req->r_target_inode = NULL;
> > >  			if (in->i_state & I_NEW)
> > >  				discard_new_inode(in);
> > >  			else
> > >  				iput(in);
> > >  			goto done;
> > >  		}
> > > -		req->r_target_inode = in;
> > >  		if (in->i_state & I_NEW)
> > >  			unlock_new_inode(in);
> > >  	}
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index b3c941503f8c..48db1f593d81 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -3179,6 +3179,21 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
> > >  		err = parse_reply_info(session, msg, rinfo, session->s_con.peer_features);
> > >  	mutex_unlock(&mdsc->mutex);
> > >  
> > > 
> > > 
> > > 
> > > +	/* Must find target inode outside of mutexes to avoid deadlocks */
> > > +	if (rinfo->head->is_target) {
> 
> This condition should probably be
> 
> 	if ((err >= 0) && rinfo->head->is_target) {
> 
> This would allow a faster exit path and eventually avoid masking this
> 'err' value with another one from ceph_get_inode().
> 


Good catch. I'll fix that and send a v2.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

