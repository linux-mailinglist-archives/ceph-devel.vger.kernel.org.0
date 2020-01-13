Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B475613923C
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 14:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgAMNbn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jan 2020 08:31:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAMNbn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 08:31:43 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07FB5207FD;
        Mon, 13 Jan 2020 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578922301;
        bh=LqEya61BgofjamqbC/Z99eactG3iYFMA8BNhPoV4eKc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Zk70R5r2dBCvT/Dh5/kGsFKUHiTeGkV4TC9PxM6Ii91I3Wz8gZIn/Qs0L/A+Zi81I
         +GQaTVQ7kdmb5nqKEmlenmqzp9U2C35wmsdfIcaDNpq6p1kn+UoGPWjbePZb/PxWcB
         9f5r4QE/Mrn2VY2ZANyIhG1Ty2cJT/xdyTrsFtgk=
Message-ID: <44b57b023ecec1eea052f43db194c1707b2a0329.camel@kernel.org>
Subject: Re: [RFC PATCH 7/9] ceph: add flag to delegate an inode number for
 async create
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com
Date:   Mon, 13 Jan 2020 08:31:39 -0500
In-Reply-To: <056df2f9-07b9-a5ac-f4f3-861b8a364ff3@redhat.com>
References: <20200110205647.311023-1-jlayton@kernel.org>
         <20200110205647.311023-8-jlayton@kernel.org>
         <056df2f9-07b9-a5ac-f4f3-861b8a364ff3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-01-13 at 17:17 +0800, Yan, Zheng wrote:
> On 1/11/20 4:56 AM, Jeff Layton wrote:
> > In order to issue an async create request, we need to send an inode
> > number when we do the request, but we don't know which to which MDS
> > we'll be issuing the request.
> > 
> 
> the request should be sent to auth mds (dir_ci->i_auth_cap->session) of 
> directory. I think grabing inode number in get_caps_for_async_create() 
> is simpler.
> 

That would definitely be simpler. I didn't know whether we could count
on having an i_auth_cap in that case.

Will a non-auth MDS ever hand out DIR_CREATE/DIR_UNLINK caps? I'm a
little fuzzy on what the rules are for caps being handed out by non-auth 
MDS's.

> > Add a new r_req_flag that tells the request sending machinery to
> > grab an inode number from the delegated set, and encode it into the
> > request. If it can't get one then have it return -ECHILD. The
> > requestor can then reissue a synchronous request.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/inode.c      |  1 +
> >   fs/ceph/mds_client.c | 19 ++++++++++++++++++-
> >   fs/ceph/mds_client.h |  2 ++
> >   3 files changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 79bb1e6af090..9cfc093fd273 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1317,6 +1317,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >   		err = ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
> >   				NULL, session,
> >   				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
> > +				 !test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags) &&
> >   				 rinfo->head->result == 0) ?  req->r_fmode : -1,
> >   				&req->r_caps_reservation);
> >   		if (err < 0) {
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 852c46550d96..9e7492b21b50 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2623,7 +2623,10 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
> >   	rhead->flags = cpu_to_le32(flags);
> >   	rhead->num_fwd = req->r_num_fwd;
> >   	rhead->num_retry = req->r_attempts - 1;
> > -	rhead->ino = 0;
> > +	if (test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags))
> > +		rhead->ino = cpu_to_le64(req->r_deleg_ino);
> > +	else
> > +		rhead->ino = 0;
> >   
> >   	dout(" r_parent = %p\n", req->r_parent);
> >   	return 0;
> > @@ -2736,6 +2739,20 @@ static void __do_request(struct ceph_mds_client *mdsc,
> >   		goto out_session;
> >   	}
> >   
> > +	if (test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags) &&
> > +	    !req->r_deleg_ino) {
> > +		req->r_deleg_ino = get_delegated_ino(req->r_session);
> > +
> > +		if (!req->r_deleg_ino) {
> > +			/*
> > +			 * If we can't get a deleg ino, exit with -ECHILD,
> > +			 * so the caller can reissue a sync request
> > +			 */
> > +			err = -ECHILD;
> > +			goto out_session;
> > +		}
> > +	}
> > +
> >   	/* send request */
> >   	req->r_resend_mds = -1;   /* forget any previous mds hint */
> >   
> > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > index 3db7ef47e1c9..e0b36be7c44f 100644
> > --- a/fs/ceph/mds_client.h
> > +++ b/fs/ceph/mds_client.h
> > @@ -258,6 +258,7 @@ struct ceph_mds_request {
> >   #define CEPH_MDS_R_GOT_RESULT		(5) /* got a result */
> >   #define CEPH_MDS_R_DID_PREPOPULATE	(6) /* prepopulated readdir */
> >   #define CEPH_MDS_R_PARENT_LOCKED	(7) /* is r_parent->i_rwsem wlocked? */
> > +#define CEPH_MDS_R_DELEG_INO		(8) /* attempt to get r_deleg_ino */
> >   	unsigned long	r_req_flags;
> >   
> >   	struct mutex r_fill_mutex;
> > @@ -307,6 +308,7 @@ struct ceph_mds_request {
> >   	int               r_num_fwd;    /* number of forward attempts */
> >   	int               r_resend_mds; /* mds to resend to next, if any*/
> >   	u32               r_sent_on_mseq; /* cap mseq request was sent at*/
> > +	unsigned long	  r_deleg_ino;
> >   
> >   	struct list_head  r_wait;
> >   	struct completion r_completion;
> > 

-- 
Jeff Layton <jlayton@kernel.org>

