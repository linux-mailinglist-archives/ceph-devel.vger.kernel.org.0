Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B694AB63E
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 09:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiBGIGP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 03:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245034AbiBGH4k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 02:56:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B088C043184
        for <ceph-devel@vger.kernel.org>; Sun,  6 Feb 2022 23:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644220598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDQvCx6HOgffS+cwCGGJsfqxQ7QZ8TXZKuTWbSZxZ9c=;
        b=DgO9zx9MHA2bHju/l8IDKDT2edSZv/3RnD/F0p3ejg91Mrfk2qsoYvEApEVxj4ZHfsV/2D
        gmABP3AJbxzxnX1YrjKGa1nJj9FcjUyK2A1an43kHEwF863NNIFzVqBp35SwdG09/HkuNP
        WEROtMY6bytgq4nb8vJO/j7z7riWAuA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-vRvpZHZSN9mWr2kgVKsT-g-1; Mon, 07 Feb 2022 02:56:37 -0500
X-MC-Unique: vRvpZHZSN9mWr2kgVKsT-g-1
Received: by mail-pj1-f72.google.com with SMTP id n4-20020a17090ade8400b001b8bb511c3bso1850180pjv.7
        for <ceph-devel@vger.kernel.org>; Sun, 06 Feb 2022 23:56:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NDQvCx6HOgffS+cwCGGJsfqxQ7QZ8TXZKuTWbSZxZ9c=;
        b=05yX03B6VOWgOZfiM1Vzlm2ypFs5uq9NfCc9fY1y3gA2OAHkEuaE77p3MlWRT7dVyy
         YzKWK3AR699wVjisQZkNqaX+hdtops/g2HTbUWmDHmMDyUuS7P3Bt41HOCCozrPaB7hu
         8c6oG/KxvNjWkVAhHKr8nfG0rsyVbe9/P9TSLN8e94l7eas1Ipjh+BvILsdiO4pZJwO/
         PSsaE7G6tfx4bdF+8h6xcJFRuX5VW+G29RSiZ9smUim28krCKhr9euyOe+zXkBc5LxS0
         id2GpqoigX0yNZgK2RBg3RF/axy0SfqhAbPxfO1/3hsP/hJWS0cM4AGx6Ekly/6pDQA2
         nEjg==
X-Gm-Message-State: AOAM532xP91b9cm19I3UO+Xpsd2DB3Iv29yLQm96Qx/BV9AXCU+zfknH
        n4jNiJ/GSpIichk7+zM8KgMWPzjL2VrbFkrFT7QQWjzXat0Oxc/Qf2z7aOana3FGAyVBG573I2k
        TlbuFMcW8WbLta+IWUzd21g==
X-Received: by 2002:a05:6a00:2283:: with SMTP id f3mr14500218pfe.24.1644220596024;
        Sun, 06 Feb 2022 23:56:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9XSk9zT9z8t2SQZKOViXDbbnFowIvLwfZguPyShd6PIgrQGpPVaLLNcSRYMI1b5E+B/Rlqg==
X-Received: by 2002:a05:6a00:2283:: with SMTP id f3mr14500206pfe.24.1644220595588;
        Sun, 06 Feb 2022 23:56:35 -0800 (PST)
Received: from [10.72.12.64] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j185sm10178588pfd.85.2022.02.06.23.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 23:56:34 -0800 (PST)
Subject: Re: [PATCH] ceph: eliminate req->r_wait_for_completion from
 ceph_mds_request
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
References: <20220203183845.93932-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ce52f021-a7a8-3d2a-3811-dbf21bd0618e@redhat.com>
Date:   Mon, 7 Feb 2022 15:56:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220203183845.93932-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/4/22 2:38 AM, Jeff Layton wrote:
> ...and instead just pass the wait function on the stack.
>
> Make ceph_mdsc_wait_request non-static, and add an argument for wait for
> completion. Then have ceph_lock_message call ceph_mdsc_submit_request,
> and ceph_mdsc_wait_request and pass in the pointer to
> ceph_lock_wait_for_completion.
>
> While we're in there, rearrange some fields in ceph_mds_request, so we
> save a total of 24 bytes per.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/locks.c      |  8 ++++----
>   fs/ceph/mds_client.c | 11 ++++++-----
>   fs/ceph/mds_client.h |  9 +++++----
>   3 files changed, 15 insertions(+), 13 deletions(-)
>
> v2: actually change ceph_mdsc_do_request to ceph_mdsc_submit_request
>
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index d1f154aec249..3e2843e86e27 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -111,10 +111,10 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
>   	req->r_args.filelock_change.length = cpu_to_le64(length);
>   	req->r_args.filelock_change.wait = wait;
>   
> -	if (wait)
> -		req->r_wait_for_completion = ceph_lock_wait_for_completion;
> -
> -	err = ceph_mdsc_do_request(mdsc, inode, req);
> +	err = ceph_mdsc_submit_request(mdsc, inode, req);
> +	if (!err)
> +		err = ceph_mdsc_wait_request(mdsc, req, wait ?
> +					ceph_lock_wait_for_completion : NULL);
>   	if (!err && operation == CEPH_MDS_OP_GETFILELOCK) {
>   		fl->fl_pid = -le64_to_cpu(req->r_reply_info.filelock_reply->pid);
>   		if (CEPH_LOCK_SHARED == req->r_reply_info.filelock_reply->type)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 5937cbfafd31..72ba22de2b46 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2974,15 +2974,16 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>   	return err;
>   }
>   
> -static int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
> -				  struct ceph_mds_request *req)
> +int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
> +			   struct ceph_mds_request *req,
> +			   ceph_mds_request_wait_callback_t wait_func)
>   {
>   	int err;
>   
>   	/* wait */
>   	dout("do_request waiting\n");
> -	if (!req->r_timeout && req->r_wait_for_completion) {
> -		err = req->r_wait_for_completion(mdsc, req);
> +	if (wait_func) {
> +		err = wait_func(mdsc, req);
>   	} else {
>   		long timeleft = wait_for_completion_killable_timeout(
>   					&req->r_completion,
> @@ -3039,7 +3040,7 @@ int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
>   	/* issue */
>   	err = ceph_mdsc_submit_request(mdsc, dir, req);
>   	if (!err)
> -		err = ceph_mdsc_wait_request(mdsc, req);
> +		err = ceph_mdsc_wait_request(mdsc, req, NULL);
>   	dout("do_request %p done, result %d\n", req, err);
>   	return err;
>   }
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 97c7f7bfa55f..ab12f3ce81a3 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -274,8 +274,8 @@ struct ceph_mds_request {
>   
>   	union ceph_mds_request_args r_args;
>   	int r_fmode;        /* file mode, if expecting cap */
> -	const struct cred *r_cred;
>   	int r_request_release_offset;
> +	const struct cred *r_cred;
>   	struct timespec64 r_stamp;
>   
>   	/* for choosing which mds to send this request to */
> @@ -296,12 +296,11 @@ struct ceph_mds_request {
>   	struct ceph_msg  *r_reply;
>   	struct ceph_mds_reply_info_parsed r_reply_info;
>   	int r_err;
> -
> +	u32               r_readdir_offset;
>   
>   	struct page *r_locked_page;
>   	int r_dir_caps;
>   	int r_num_caps;
> -	u32               r_readdir_offset;
>   
>   	unsigned long r_timeout;  /* optional.  jiffies, 0 is "wait forever" */
>   	unsigned long r_started;  /* start time to measure timeout against */
> @@ -329,7 +328,6 @@ struct ceph_mds_request {
>   	struct completion r_completion;
>   	struct completion r_safe_completion;
>   	ceph_mds_request_callback_t r_callback;
> -	ceph_mds_request_wait_callback_t r_wait_for_completion;
>   	struct list_head  r_unsafe_item;  /* per-session unsafe list item */
>   
>   	long long	  r_dir_release_cnt;
> @@ -507,6 +505,9 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode);
>   extern int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc,
>   				    struct inode *dir,
>   				    struct ceph_mds_request *req);
> +int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
> +			struct ceph_mds_request *req,
> +			ceph_mds_request_wait_callback_t wait_func);
>   extern int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
>   				struct inode *dir,
>   				struct ceph_mds_request *req);

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


