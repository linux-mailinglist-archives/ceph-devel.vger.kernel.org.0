Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F25B11AC49
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2019 14:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfLKNlf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Dec 2019 08:41:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbfLKNlf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 08:41:35 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ABCD20836;
        Wed, 11 Dec 2019 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576071694;
        bh=e2i9d3yfaQgpMSDAHwx11on3pSeIKMfAUvr5LnPLeSw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QD7qBXlIE6naROy4iPc1DGQ+WbQkjIVX0RKbQLT9H0EpbzGdkbN6lLoYu1gvX0dNZ
         b9QbShjRooQqVg6OjacZfMVW90IzYcuemgXc1EcMHocEc7Qn/sAPhyB5zsa2ZP77or
         x3DKFEWlgrKCnA5Ivt7ACOgW84Cynffhp8Q9aV1Q=
Message-ID: <1dccc3cc4a622547df0da814763634d42070cbad.camel@kernel.org>
Subject: Re: [PATCH] ceph: retry the same mds later after the new session is
 opened
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 11 Dec 2019 08:41:32 -0500
In-Reply-To: <20191209124715.2255-1-xiubli@redhat.com>
References: <20191209124715.2255-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-12-09 at 07:47 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> With max_mds > 1 and for a request which are choosing a random
> mds rank and if the relating session is not opened yet, the request
> will wait the session been opened and resend again. While every
> time the request is beening __do_request, it will release the
> req->session first and choose a random one again, so this time it
> may choose another random mds rank. The worst case is that it will
> open all the mds sessions one by one just before it can be
> successfully sent out out.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 68f3b5ed6ac8..d747e9baf9c9 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -876,7 +876,8 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
>   * Called under mdsc->mutex.
>   */
>  static int __choose_mds(struct ceph_mds_client *mdsc,
> -			struct ceph_mds_request *req)
> +			struct ceph_mds_request *req,
> +			bool *random)
>  {
>  	struct inode *inode;
>  	struct ceph_inode_info *ci;
> @@ -886,6 +887,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  	u32 hash = req->r_direct_hash;
>  	bool is_hash = test_bit(CEPH_MDS_R_DIRECT_IS_HASH, &req->r_req_flags);
>  
> +	if (random)
> +		*random = false;
> +
>  	/*
>  	 * is there a specific mds we should try?  ignore hint if we have
>  	 * no session and the mds is not up (active or recovering).
> @@ -1021,6 +1025,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  	return mds;
>  
>  random:
> +	if (random)
> +		*random = true;
> +
>  	mds = ceph_mdsmap_get_random_mds(mdsc->mdsmap);
>  	dout("choose_mds chose random mds%d\n", mds);
>  	return mds;
> @@ -2556,6 +2563,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  	struct ceph_mds_session *session = NULL;
>  	int mds = -1;
>  	int err = 0;
> +	bool random;
>  
>  	if (req->r_err || test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
>  		if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags))
> @@ -2596,7 +2604,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  
>  	put_request_session(req);
>  
> -	mds = __choose_mds(mdsc, req);
> +	mds = __choose_mds(mdsc, req, &random);
>  	if (mds < 0 ||
>  	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
>  		dout("do_request no mds or not active, waiting for map\n");
> @@ -2624,8 +2632,12 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  			goto out_session;
>  		}
>  		if (session->s_state == CEPH_MDS_SESSION_NEW ||
> -		    session->s_state == CEPH_MDS_SESSION_CLOSING)
> +		    session->s_state == CEPH_MDS_SESSION_CLOSING) {
>  			__open_session(mdsc, session);
> +			/* retry the same mds later */
> +			if (random)
> +				req->r_resend_mds = mds;
> +		}
>  		list_add(&req->r_wait, &session->s_waiting);
>  		goto out_session;
>  	}
> @@ -2890,7 +2902,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>  			mutex_unlock(&mdsc->mutex);
>  			goto out;
>  		} else  {
> -			int mds = __choose_mds(mdsc, req);
> +			int mds = __choose_mds(mdsc, req, NULL);
>  			if (mds >= 0 && mds != req->r_session->s_mds) {
>  				dout("but auth changed, so resending\n");
>  				__do_request(mdsc, req);

Is there a tracker bug for this?

This does seem like the behavior we'd want. I wish it were a little less
Rube Goldberg to do this, but this code is already pretty messy so this
doesn't really make it too much worse.

In any case, merged with a reworded changelog.
-- 
Jeff Layton <jlayton@kernel.org>

