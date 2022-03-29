Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01004EAF92
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Mar 2022 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbiC2Ouk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 10:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiC2Ouj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 10:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F38E87
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 07:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B95FD6164E
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 14:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80996C2BBE4;
        Tue, 29 Mar 2022 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648565336;
        bh=jwPzhhAhHN/9voqw1HkgkPEPE4Yj0UA+zHabUSMq5HY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LP75C/odw9FFCE5FCBDkImc2MfVYWPfmDugMsqz2O5Ju/k/+BMniwKw7sGua+5SRl
         MKNJGwmgN6vCeCWbpuh888JgggQD2S9fKlhTO4bDt6iKdL2km6N3J/RylDcPOEjh4d
         N9jtY3s38DFVMb7GuRhTCYDsPPj3DPpRZ6I/Sj9DeviPyAAMRReGO95MzMK0VxODdH
         dAJeFtDC37SuGiwWgrkFyf6xdufcII3Twnw9Wx/UX2R5BcfPK+PebJj71gu1iIcsZZ
         e1at7vu5UWogoORquyY0exjtF1LeskjFmw7y6RlJBgVix8gg4mKoyDSeMh+q3XqktW
         3ttReICA34Mmw==
Message-ID: <e3fdf3bcf7ed44d9a0b3f84351f2b72826db15bf.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: stop forwarding the request when exceeding 256
 times
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, gfarnum@redhat.com,
        lhenriques@suse.de, ceph-devel@vger.kernel.org
Date:   Tue, 29 Mar 2022 10:48:54 -0400
In-Reply-To: <20220329122003.77740-1-xiubli@redhat.com>
References: <20220329122003.77740-1-xiubli@redhat.com>
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

On Tue, 2022-03-29 at 20:20 +0800, xiubli@redhat.com wrote:
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
> V2:
> - s/EIO/EMULTIHOP/
> - Fixed dereferencing NULL seq bug
> - Removed the out lable
> 
> 
>  fs/ceph/mds_client.c | 34 +++++++++++++++++++++++++++++-----
>  1 file changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a89ee866ebbb..82c1f783feba 100644
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
> @@ -3301,16 +3302,36 @@ static void handle_forward(struct ceph_mds_client *mdsc,
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
> +		 */
> +		if (req->r_num_fwd == 256) {

Can you also fix this to be expressed as "> UCHAR_MAX"? Or preferably,
if you have a way to get to the ceph_mds_request_head from here, then
express it in terms of sizeof() the field that limits this.

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
> @@ -3322,9 +3343,12 @@ static void handle_forward(struct ceph_mds_client *mdsc,
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

The code looks fine otherwise though...
-- 
Jeff Layton <jlayton@kernel.org>
