Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFBF48D038
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 02:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiAMBjt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 20:39:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231470AbiAMBjn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 20:39:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642037979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZsUSNfoA8GEyxoXTejwPFImnUwlHYvrYEmyY509QC2Y=;
        b=PGM7rBgp6IkaiIpbKl1Yu/R7vMlQ0kBAwnu7beAfgTFcHUHWPrdtbVHbUwiaWSh224nDuc
        mpzbdxTZv07YSsna+qPT6OZ4SGLxxO4pVqXq+lsOzPOG2QU4FiMz/s5d3jGXySPNGS8ToA
        vFuH7Udpavjm+VwAsHSkLTbPWqNj4s4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-phW0la0cPumh2NdFgGgCpA-1; Wed, 12 Jan 2022 20:39:38 -0500
X-MC-Unique: phW0la0cPumh2NdFgGgCpA-1
Received: by mail-pj1-f70.google.com with SMTP id i8-20020a17090a718800b001b35ee7ac29so5080673pjk.3
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jan 2022 17:39:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZsUSNfoA8GEyxoXTejwPFImnUwlHYvrYEmyY509QC2Y=;
        b=njA0jdBGdgp3ByZF+fqSTYL4yruNzUpoWFf7BNrNUplOKK9oEzmXWFL7R1EhasMAm8
         fSuMCTasMeHAAX42oik6pl17s5jGAPt72wZxzxL6w3R1nimoGy/wK+XDPg/6DQXDwZY2
         nEMzjY2CfnW41RKPLbjEZ1pX/LLuhHOcPrXdbpLrihBLVfr2xoMv6EMvhrFtTHyvxlpu
         mE84xjplNcyqAt/ageiyVrn4tmyWSxbt6EFPOxjfEVtoBV3HShIGBaTxkqRBf9vcL8uK
         +qCA0esO35pUHySuseCuaa3LR7/YHbTu0Iv7O3QVUhwXifdScP52Wgi+8jof0YzjbnDj
         7cJQ==
X-Gm-Message-State: AOAM530WglQJQLK9Alne5duwepF0uK/2IKQPRwKXde3UxPXUTztUvwAx
        xz3zuUpUQ6qYH6v0wSF1VOiiP6UtVuidjEME0XJh/VZ7K19zXQBsMaOzL5rwjTKjHoNF1HYGygT
        smyW/JKqkj5fwVJtMiYwBIw==
X-Received: by 2002:a65:6119:: with SMTP id z25mr2018573pgu.597.1642037977432;
        Wed, 12 Jan 2022 17:39:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyd5GV2JVr/dm+P1EtRDIWVXDtdgiH5Qm2I0etSoL3IGG2If8rqEel7dA3WpjAubT254pm2eA==
X-Received: by 2002:a65:6119:: with SMTP id z25mr2018555pgu.597.1642037977091;
        Wed, 12 Jan 2022 17:39:37 -0800 (PST)
Received: from [10.72.12.99] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f10sm850370pfj.145.2022.01.12.17.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 17:39:36 -0800 (PST)
Subject: Re: [PATCH] ceph: put the requests/sessions when it fails to alloc
 memory
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, mail@nh2.me
References: <20220112042904.8557-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <86c8671c-484b-3447-819f-abcf5853d2d8@redhat.com>
Date:   Thu, 13 Jan 2022 09:39:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220112042904.8557-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

cc Niklas.

On 1/12/22 12:29 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> When failing to allocate the sessions memory we should make sure
> the req1 and req2 and the sessions get put. And also in case the
> max_sessions decreased so when kreallocate the new memory some
> sessions maybe missed being put.
>
> And if the max_sessions is 0 krealloc will return ZERO_SIZE_PTR,
> which will lead to a distinct access fault.
>
> URL: https://tracker.ceph.com/issues/53819
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Fixes: e1a4541ec0b9 ("ceph: flush the mdlog before waiting on unsafe reqs")

This is reported by:

Reported-by: Niklas Hambuechen <mail@nh2.me>

I just get the correct mail from Niklas.

Regards

- Xiubo


> ---
>   fs/ceph/caps.c | 55 +++++++++++++++++++++++++++++++++-----------------
>   1 file changed, 37 insertions(+), 18 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 944b18b4e217..5c2719f66f62 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2276,6 +2276,7 @@ static int unsafe_request_wait(struct inode *inode)
>   	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>   	struct ceph_inode_info *ci = ceph_inode(inode);
>   	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
> +	unsigned int max_sessions;
>   	int ret, err = 0;
>   
>   	spin_lock(&ci->i_unsafe_lock);
> @@ -2293,37 +2294,45 @@ static int unsafe_request_wait(struct inode *inode)
>   	}
>   	spin_unlock(&ci->i_unsafe_lock);
>   
> +	/*
> +	 * The mdsc->max_sessions is unlikely to be changed
> +	 * mostly, here we will retry it by reallocating the
> +	 * sessions arrary memory to get rid of the mdsc->mutex
> +	 * lock.
> +	 */
> +retry:
> +	max_sessions = mdsc->max_sessions;
> +
>   	/*
>   	 * Trigger to flush the journal logs in all the relevant MDSes
>   	 * manually, or in the worst case we must wait at most 5 seconds
>   	 * to wait the journal logs to be flushed by the MDSes periodically.
>   	 */
> -	if (req1 || req2) {
> +	if ((req1 || req2) && likely(max_sessions)) {
>   		struct ceph_mds_session **sessions = NULL;
>   		struct ceph_mds_session *s;
>   		struct ceph_mds_request *req;
> -		unsigned int max;
>   		int i;
>   
> -		/*
> -		 * The mdsc->max_sessions is unlikely to be changed
> -		 * mostly, here we will retry it by reallocating the
> -		 * sessions arrary memory to get rid of the mdsc->mutex
> -		 * lock.
> -		 */
> -retry:
> -		max = mdsc->max_sessions;
> -		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
> -		if (!sessions)
> -			return -ENOMEM;
> +		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
> +		if (!sessions) {
> +			err = -ENOMEM;
> +			goto out;
> +		}
>   
>   		spin_lock(&ci->i_unsafe_lock);
>   		if (req1) {
>   			list_for_each_entry(req, &ci->i_unsafe_dirops,
>   					    r_unsafe_dir_item) {
>   				s = req->r_session;
> -				if (unlikely(s->s_mds >= max)) {
> +				if (unlikely(s->s_mds >= max_sessions)) {
>   					spin_unlock(&ci->i_unsafe_lock);
> +					for (i = 0; i < max_sessions; i++) {
> +						s = sessions[i];
> +						if (s)
> +							ceph_put_mds_session(s);
> +					}
> +					kfree(sessions);
>   					goto retry;
>   				}
>   				if (!sessions[s->s_mds]) {
> @@ -2336,8 +2345,14 @@ static int unsafe_request_wait(struct inode *inode)
>   			list_for_each_entry(req, &ci->i_unsafe_iops,
>   					    r_unsafe_target_item) {
>   				s = req->r_session;
> -				if (unlikely(s->s_mds >= max)) {
> +				if (unlikely(s->s_mds >= max_sessions)) {
>   					spin_unlock(&ci->i_unsafe_lock);
> +					for (i = 0; i < max_sessions; i++) {
> +						s = sessions[i];
> +						if (s)
> +							ceph_put_mds_session(s);
> +					}
> +					kfree(sessions);
>   					goto retry;
>   				}
>   				if (!sessions[s->s_mds]) {
> @@ -2358,7 +2373,7 @@ static int unsafe_request_wait(struct inode *inode)
>   		spin_unlock(&ci->i_ceph_lock);
>   
>   		/* send flush mdlog request to MDSes */
> -		for (i = 0; i < max; i++) {
> +		for (i = 0; i < max_sessions; i++) {
>   			s = sessions[i];
>   			if (s) {
>   				send_flush_mdlog(s);
> @@ -2375,15 +2390,19 @@ static int unsafe_request_wait(struct inode *inode)
>   					ceph_timeout_jiffies(req1->r_timeout));
>   		if (ret)
>   			err = -EIO;
> -		ceph_mdsc_put_request(req1);
>   	}
>   	if (req2) {
>   		ret = !wait_for_completion_timeout(&req2->r_safe_completion,
>   					ceph_timeout_jiffies(req2->r_timeout));
>   		if (ret)
>   			err = -EIO;
> -		ceph_mdsc_put_request(req2);
>   	}
> +
> +out:
> +	if (req1)
> +		ceph_mdsc_put_request(req1);
> +	if (req2)
> +		ceph_mdsc_put_request(req2);
>   	return err;
>   }
>   

