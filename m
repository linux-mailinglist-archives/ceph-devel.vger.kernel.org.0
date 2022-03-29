Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988394EAC43
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Mar 2022 13:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiC2L37 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 07:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiC2L35 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 07:29:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D565D1E95E2
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 04:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F039B816A6
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 11:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B057FC2BBE4;
        Tue, 29 Mar 2022 11:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648553290;
        bh=3feNozJB0BdVbKQyAU3kuhf++taiWQXGu/b6SVSImsY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KNgZxnbQxoPc2t+aZh69hRbN7bPMJpd6TnJl0BgVZpkY3c3yZMpGt3GKf6S2htHbo
         lOkquhd8+n8Xa+kYBMnu6dYuiwuEkfow4ulNtqYDkheQmghpTpCaZyT51O33bvkRfG
         5k4iqe3ivvGlm8YVrh2IxxQ1Afks3qsYwqc5Tbp9PGoRRqJ2OtO1M3Hy1XR+xLM40X
         k5oCF7I+8ONG0xuVSVIR8kMDAqVWzN9D25zIVvATSlcp8xqAH1rkUn/JLgg69egdY4
         AZgsplC+ztcxYZEdCm2O0RTObbChDUM6Un76SimZ6RlciQ/Rs2W3kaxoNTBnRyT7XR
         GdWdyCHpiXHHg==
Message-ID: <6e83064bc5dc81721a2058bda95ae0f12584b2bf.camel@kernel.org>
Subject: Re: [PATCH] ceph: stop forwarding the request when exceeding 256
 times
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>,
        =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     idryomov@gmail.com, vshankar@redhat.com, gfarnum@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 29 Mar 2022 07:28:08 -0400
In-Reply-To: <a568c0c0-6620-e369-2e14-b6d06a9f4340@redhat.com>
References: <20220329080608.14667-1-xiubli@redhat.com>
         <87fsn1qe39.fsf@brahms.olymp>
         <a568c0c0-6620-e369-2e14-b6d06a9f4340@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-29 at 19:12 +0800, Xiubo Li wrote:
> On 3/29/22 5:53 PM, Luís Henriques wrote:
> > xiubli@redhat.com writes:
> > 
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > The type of 'num_fwd' in ceph 'MClientRequestForward' is 'int32_t',
> > > while in 'ceph_mds_request_head' the type is '__u8'. So in case
> > > the request bounces between MDSes exceeding 256 times, the client
> > > will get stuck.
> > > 
> > > In this case it's ususally a bug in MDS and continue bouncing the
> > > request makes no sense.
> > Ouch.  Nice catch.  This patch looks OK to me, just 2 minor comments
> > bellow.
> > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/mds_client.c | 31 ++++++++++++++++++++++++++++---
> > >   1 file changed, 28 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index a89ee866ebbb..0bb6e7bc499c 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -3293,6 +3293,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
> > >   	int err = -EINVAL;
> > >   	void *p = msg->front.iov_base;
> > >   	void *end = p + msg->front.iov_len;
> > > +	bool aborted = false;
> > >   
> > >   	ceph_decode_need(&p, end, 2*sizeof(u32), bad);
> > >   	next_mds = ceph_decode_32(&p);
> > > @@ -3309,8 +3310,28 @@ static void handle_forward(struct ceph_mds_client *mdsc,
> > >   		dout("forward tid %llu aborted, unregistering\n", tid);
> > >   		__unregister_request(mdsc, req);
> > >   	} else if (fwd_seq <= req->r_num_fwd) {
> > > -		dout("forward tid %llu to mds%d - old seq %d <= %d\n",
> > > -		     tid, next_mds, req->r_num_fwd, fwd_seq);
> > > +		/*
> > > +		 * The type of 'num_fwd' in ceph 'MClientRequestForward'
> > > +		 * is 'int32_t', while in 'ceph_mds_request_head' the
> > > +		 * type is '__u8'. So in case the request bounces between
> > > +		 * MDSes exceeding 256 times, the client will get stuck.
> > > +		 *
> > > +		 * In this case it's ususally a bug in MDS and continue
> > > +		 * bouncing the request makes no sense.
> > > +		 */
> > > +		if (req->r_num_fwd == 256) {
> > > +			mutex_lock(&req->r_fill_mutex);
> > > +			req->r_err = -EIO;
> > Not sure -EIO is the most appropriate.  Maybe -E2BIG... although not quite
> > it either.
> > 
> Yeah, I also not very sure here.
> 
> Jeff ?
> 

Matching errors like this really comes down to a judgement call.  E2BIG
usually means that some buffer was sized too small, so you'll have users
trying to figure out what they passed in wrong if you return that here.

-EIO is the usual "default" when you don't know what else to use.
There's also -EREMOTEIO which may be closer here since this is
indicative of MDS problems. Given that, it may also be a good idea to
log a pr_warn or pr_notice message at the same time explaining what
happened.


> 
> > > +			set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
> > > +			mutex_unlock(&req->r_fill_mutex);
> > > +			aborted = true;
> > > +			dout("forward tid %llu to mds%d - seq overflowed %d <= %d\n",
> > > +			     tid, next_mds, req->r_num_fwd, fwd_seq);
> > > +			goto out;
> > This 'goto' statement can be dropped, but one before (when the
> > lookup_get_request() fails) needs to be adjusted, otherwise
> > ceph_mdsc_put_request() may be called with a NULL pointer.
> 
> Yeah, will fix it.
> 
> Thanks.
> 
> -- Xiubo
> 
> 
> > Cheers,
> 

-- 
Jeff Layton <jlayton@kernel.org>
