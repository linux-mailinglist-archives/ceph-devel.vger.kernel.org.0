Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C98E4EBEDF
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 12:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245431AbiC3KiU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 06:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245410AbiC3KiR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 06:38:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8ED2BB1C
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 03:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD92C60F25
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 10:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACDCC340EC;
        Wed, 30 Mar 2022 10:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648636592;
        bh=T+Hj6wfSk6fXUfAH4AESvkSF06ni0y8AQpyGrQA9X5s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G87OghP1LpL7XJbqXjtp6EkorjMnOZhvmfv9UnsWCDaugRi7K4Gshej5GZA9I+D5j
         X3/p6OlLTVwRCOYTcnEY20wJyNfiG6fhIo8uZKWsauIjoc+sMetTbwtpRDMyHtvkFE
         o41CTGtZ4kkTf8VoubIWGPz/6ONAt1VGnwa/r4JVCU+fjhDcfZdGIIUu9hrQcEp+UP
         wekhaY+q1r1DjbvuOJ24BtylihPf0U7kKXrkJ1qz72UzEZO10ZC43d9m2D9s9GMuPL
         1YcyH2WlbkXKd+E/ouRCvfakfFG7TzR7cBi8T31DorSKTRXfvp36rc+Xua+L3E2ME0
         USNyg7hU+TtlQ==
Message-ID: <9790a90311f2bf6d190ba0c5ea861042ebf2a277.camel@kernel.org>
Subject: Re: [PATCH] ceph: stop retrying the request when exceeding 256 times
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 30 Mar 2022 06:36:30 -0400
In-Reply-To: <20220330064444.330384-1-xiubli@redhat.com>
References: <20220330064444.330384-1-xiubli@redhat.com>
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

On Wed, 2022-03-30 at 14:44 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The type of 'r_attempts' in kernel 'ceph_mds_request' is 'int',
> while in 'ceph_mds_request_head' the type of 'num_retry' is '__u8'.
> So in case the request retries exceeding 256 times, the MDS will
> receive a incorrect retry seq.
> 
> In this case it's ususally a bug in MDS and continue retrying the
> request makes no sense. For now let's limit it to 256. In future
> this could be fixed in ceph code, so avoid using the hardcode here.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e11d31401f12..f476c65fb985 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2679,7 +2679,28 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>  	struct ceph_mds_client *mdsc = session->s_mdsc;
>  	struct ceph_mds_request_head_old *rhead;
>  	struct ceph_msg *msg;
> -	int flags = 0;
> +	int flags = 0, max_retry;
> +
> +	/*
> +	 * The type of 'r_attempts' in kernel 'ceph_mds_request'
> +	 * is 'int', while in 'ceph_mds_request_head' the type of
> +	 * 'num_retry' is '__u8'. So in case the request retries
> +	 *  exceeding 256 times, the MDS will receive a incorrect
> +	 *  retry seq.
> +	 *
> +	 * In this case it's ususally a bug in MDS and continue
> +	 * retrying the request makes no sense.
> +	 *
> +	 * In future this could be fixed in ceph code, so avoid
> +	 * using the hardcode here.
> +	 */
> +	max_retry = sizeof_field(struct ceph_mds_request_head, num_retry);
> +	max_retry = 1 << (max_retry * BITS_PER_BYTE);
> +	if (req->r_attempts >= max_retry) {
> +		pr_warn_ratelimited("%s request tid %llu seq overflow\n",
> +				    __func__, req->r_tid);
> +		return -EMULTIHOP;
> +	}
>  
>  	req->r_attempts++;
>  	if (req->r_inode) {
> @@ -2691,7 +2712,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>  		else
>  			req->r_sent_on_mseq = -1;
>  	}
> -	dout("prepare_send_request %p tid %lld %s (attempt %d)\n", req,
> +	dout("%s %p tid %lld %s (attempt %d)\n", __func__, req,
>  	     req->r_tid, ceph_mds_op_name(req->r_op), req->r_attempts);
>  
>  	if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {

Reviewed-by: Jeff Layton <jlayton@kernel.org>
