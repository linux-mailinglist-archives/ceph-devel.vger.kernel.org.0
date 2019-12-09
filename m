Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333E6116C8B
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2019 12:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfLILwQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 06:52:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727074AbfLILwQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 06:52:16 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82AC2077B;
        Mon,  9 Dec 2019 11:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575892335;
        bh=cfAE/aA3eSB5oiCR57Z9hgml6XZP0btBxdxb5Ly9sWs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K999b9ickQybCvY9ZqNaCU9+/CA9LUxpCA6RVQR0v61SLWn99AdMUB9+K1By057sx
         Vmo5wcssVgvATBsccN1fO5qf8W3dQ0sOtFA30WLb3s4hAv+FQ1RcgLi85JpASH5dZV
         3W4cyYXcY2eBPMkcEpbm98W4Ll90+NJvjI4sxY2Y=
Message-ID: <3c22cbf351831e4e97b281b0c42aa863bd0f2a13.camel@kernel.org>
Subject: Re: [PATCH] ceph: add __send_request helper
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 09 Dec 2019 06:52:13 -0500
In-Reply-To: <20191206015021.31611-1-xiubli@redhat.com>
References: <20191206015021.31611-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-12-05 at 20:50 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 47 +++++++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e47341da5a71..82dfc85b24ee 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2514,6 +2514,26 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
>  	return 0;
>  }
>  
> +/*
> + * called under mdsc->mutex
> + */
> +static int __send_request(struct ceph_mds_client *mdsc,
> +			  struct ceph_mds_session *session,
> +			  struct ceph_mds_request *req,
> +			  bool drop_cap_releases)
> +{
> +	int err;
> +
> +	err = __prepare_send_request(mdsc, req, session->s_mds,
> +				     drop_cap_releases);
> +	if (!err) {
> +		ceph_msg_get(req->r_request);
> +		ceph_con_send(&session->s_con, req->r_request);
> +	}
> +
> +	return err;
> +}
> +
>  /*
>   * send request, or put it on the appropriate wait list.
>   */
> @@ -2603,11 +2623,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  	if (req->r_request_started == 0)   /* note request start time */
>  		req->r_request_started = jiffies;
>  
> -	err = __prepare_send_request(mdsc, req, mds, false);
> -	if (!err) {
> -		ceph_msg_get(req->r_request);
> -		ceph_con_send(&session->s_con, req->r_request);
> -	}
> +	err = __send_request(mdsc, session, req, false);
>  
>  out_session:
>  	ceph_put_mds_session(session);
> @@ -3210,7 +3226,6 @@ static void handle_session(struct ceph_mds_session *session,
>  	return;
>  }
>  
> -
>  /*
>   * called under session->mutex.
>   */
> @@ -3219,18 +3234,12 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
>  {
>  	struct ceph_mds_request *req, *nreq;
>  	struct rb_node *p;
> -	int err;
>  
>  	dout("replay_unsafe_requests mds%d\n", session->s_mds);
>  
>  	mutex_lock(&mdsc->mutex);
> -	list_for_each_entry_safe(req, nreq, &session->s_unsafe, r_unsafe_item) {
> -		err = __prepare_send_request(mdsc, req, session->s_mds, true);
> -		if (!err) {
> -			ceph_msg_get(req->r_request);
> -			ceph_con_send(&session->s_con, req->r_request);
> -		}
> -	}
> +	list_for_each_entry_safe(req, nreq, &session->s_unsafe, r_unsafe_item)
> +		__send_request(mdsc, session, req, true);
>  
>  	/*
>  	 * also re-send old requests when MDS enters reconnect stage. So that MDS
> @@ -3245,14 +3254,8 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
>  		if (req->r_attempts == 0)
>  			continue; /* only old requests */
>  		if (req->r_session &&
> -		    req->r_session->s_mds == session->s_mds) {
> -			err = __prepare_send_request(mdsc, req,
> -						     session->s_mds, true);
> -			if (!err) {
> -				ceph_msg_get(req->r_request);
> -				ceph_con_send(&session->s_con, req->r_request);
> -			}
> -		}
> +		    req->r_session->s_mds == session->s_mds)
> +			__send_request(mdsc, session, req, true);
>  	}
>  	mutex_unlock(&mdsc->mutex);
>  }

Merged into ceph-client/testing.
-- 
Jeff Layton <jlayton@kernel.org>

