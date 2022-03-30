Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAE44EBEDD
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 12:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbiC3Khb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 06:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245410AbiC3Kha (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 06:37:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4603B2BB23
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 03:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F8761496
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 10:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B68FC340EE;
        Wed, 30 Mar 2022 10:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648636544;
        bh=2ns+ayi4V9FiXoxYTl0WqQKAneRwU/qllwZKvXnuFWo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EPxmM7+ZqH2LDdoxMX03nFiaiDVwJAhp6O3G1Tgd6IOcwijdoCaLL2/IQSXDnLCrW
         H9kH1aLxlDKBi6hIeqUqzZOO3NryhgtZ0NqRbqobEKq207aug6m0oOcK81C984we8v
         zuRnvgZWo+gHbjoZJ2YQbVJehADBVR6f2TG6lWJMSleEeE3p/tqmst2Q/MdBjRY4EE
         ggkBxpteIZST7eiNhMdfkeZCPljv6X59/nDmfvWjGfC8lCLYnQP7mMFA07MUOOTf7H
         B1ovI19HAt43+352nHMWtY3kjyXXMffRMJ2ficlbwS3bv/Iix0Vntj9KQE9TleHeFi
         csKzpIvZDgnug==
Message-ID: <0d35a7866d5843357b58316e6c781f67be60469f.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: stop forwarding the request when exceeding 256
 times
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, gfarnum@redhat.com,
        lhenriques@suse.de, ceph-devel@vger.kernel.org
Date:   Wed, 30 Mar 2022 06:35:42 -0400
In-Reply-To: <20220330012521.170962-1-xiubli@redhat.com>
References: <20220330012521.170962-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-30 at 09:25 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The type of 'num_fwd' in ceph 'MClientRequestForward' is 'int32_t',
> while in 'ceph_mds_request_head' the type is '__u8'. So in case
> the request bounces between MDSes exceeding 256 times, the client
> will get stuck.
> 
> In this case it's ususally a bug in MDS and continue bouncing the
> request makes no sense.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V3:
> - avoid usig the hardcode of 256
> 
> V2:
> - s/EIO/EMULTIHOP/
> - Fixed dereferencing NULL seq bug
> - Removed the out lable
> 
> 
>  fs/ceph/mds_client.c | 39 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a89ee866ebbb..e11d31401f12 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3293,6 +3293,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>  	int err = -EINVAL;
>  	void *p = msg->front.iov_base;
>  	void *end = p + msg->front.iov_len;
> +	bool aborted = false;
>  
>  	ceph_decode_need(&p, end, 2*sizeof(u32), bad);
>  	next_mds = ceph_decode_32(&p);
> @@ -3301,16 +3302,41 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>  	mutex_lock(&mdsc->mutex);
>  	req = lookup_get_request(mdsc, tid);
>  	if (!req) {
> +		mutex_unlock(&mdsc->mutex);
>  		dout("forward tid %llu to mds%d - req dne\n", tid, next_mds);
> -		goto out;  /* dup reply? */
> +		return;  /* dup reply? */
>  	}
>  
>  	if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
>  		dout("forward tid %llu aborted, unregistering\n", tid);
>  		__unregister_request(mdsc, req);
>  	} else if (fwd_seq <= req->r_num_fwd) {
> -		dout("forward tid %llu to mds%d - old seq %d <= %d\n",
> -		     tid, next_mds, req->r_num_fwd, fwd_seq);
> +		/*
> +		 * The type of 'num_fwd' in ceph 'MClientRequestForward'
> +		 * is 'int32_t', while in 'ceph_mds_request_head' the
> +		 * type is '__u8'. So in case the request bounces between
> +		 * MDSes exceeding 256 times, the client will get stuck.
> +		 *
> +		 * In this case it's ususally a bug in MDS and continue
> +		 * bouncing the request makes no sense.
> +		 *
> +		 * In future this could be fixed in ceph code, so avoid
> +		 * using the hardcode here.
> +		 */
> +		int max = sizeof_field(struct ceph_mds_request_head, num_fwd);
> +		max = 1 << (max * BITS_PER_BYTE);
> +		if (req->r_num_fwd >= max) {
> +			mutex_lock(&req->r_fill_mutex);
> +			req->r_err = -EMULTIHOP;
> +			set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
> +			mutex_unlock(&req->r_fill_mutex);
> +			aborted = true;
> +			pr_warn_ratelimited("forward tid %llu seq overflow\n",
> +					    tid);
> +		} else {
> +			dout("forward tid %llu to mds%d - old seq %d <= %d\n",
> +			     tid, next_mds, req->r_num_fwd, fwd_seq);
> +		}
>  	} else {
>  		/* resend. forward race not possible; mds would drop */
>  		dout("forward tid %llu to mds%d (we resend)\n", tid, next_mds);
> @@ -3322,9 +3348,12 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>  		put_request_session(req);
>  		__do_request(mdsc, req);
>  	}
> -	ceph_mdsc_put_request(req);
> -out:
>  	mutex_unlock(&mdsc->mutex);
> +
> +	/* kick calling process */
> +	if (aborted)
> +		complete_request(mdsc, req);
> +	ceph_mdsc_put_request(req);
>  	return;
>  
>  bad:

Reviewed-by: Jeff Layton <jlayton@kernel.org>
