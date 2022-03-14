Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4FE4D7952
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Mar 2022 03:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbiCNCYG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Mar 2022 22:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbiCNCYE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Mar 2022 22:24:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B820B5C
        for <ceph-devel@vger.kernel.org>; Sun, 13 Mar 2022 19:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647224573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7vWVsQdhNGf871HU5/J2X+Rj4SmxrAC72hC6MdQp9n8=;
        b=K65v/S4yndWtSQfnWHwxT/UGDZ1NEk4fJbr+Yb6nV9idGbKyb70hMGcXE2bWqSnKAbuRr7
        fNJEL8HH7SaetGu80ISsjQJukB+Ty8Wki5mu7jGKRNGmbICeRLxPjdGZDJsi75Elu1MkoQ
        9JSVM6xoR+nXcaotIZaSMFc2wffE0N8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-GAJg-w4rPfe5UAiGpTYx_w-1; Sun, 13 Mar 2022 22:22:52 -0400
X-MC-Unique: GAJg-w4rPfe5UAiGpTYx_w-1
Received: by mail-pj1-f70.google.com with SMTP id g19-20020a17090a579300b001b9d80f3714so9358580pji.7
        for <ceph-devel@vger.kernel.org>; Sun, 13 Mar 2022 19:22:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7vWVsQdhNGf871HU5/J2X+Rj4SmxrAC72hC6MdQp9n8=;
        b=RxhTSCD8alwoo2kpOvgY3P90oZGZ5a125EQS6j3iFKYFuRIUuLi1ztpwzLkMazKD4D
         lhoKqXQ7giOfBO4FDPfBsM9++FFgdU5av1fTX27bAae8XE2SRyqN4FuKk1tMGTx95AOC
         LzMU6FCN5dAqhf3C9RmYHUve0gqoNWJjFaOI9bMZXEqCisWLHz95fx9HAUmJWwy7ua0j
         TBR1kPx1btps4ySG/J168NR5s0adGYEpg8aoKpZ3e7jMEqMeEALsF/3AXT+J78ZaUFXl
         Htm4uwcldgbvnrmMaZKMrnukjce6NTbo1iUGP3Mc3izFuzskR3/CvHUD6lw46nWAvf5f
         PdNg==
X-Gm-Message-State: AOAM5329AW4S+iu3qAVLOhMIqVI6ncKlqS95lGcPLKW/xvbnV9vaN/HT
        4H1AXsS8r9JsN+pFwe/XP9YURbnnKaf21ywUJa/b0UoQYaLae76APsTOeaDNdfjvbVcABMcKFK2
        4Enu6br6bFeydfdb1KIpg8A==
X-Received: by 2002:a17:902:cec9:b0:151:9b2c:338 with SMTP id d9-20020a170902cec900b001519b2c0338mr20941019plg.164.1647224570992;
        Sun, 13 Mar 2022 19:22:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBCuvUqcM371kUumUBJQ2Xhv76SAkzS/c+iMLlTpX/S0c46CJ3HDr+/j+TEDDmqg3tx5w98A==
X-Received: by 2002:a17:902:cec9:b0:151:9b2c:338 with SMTP id d9-20020a170902cec900b001519b2c0338mr20941006plg.164.1647224570741;
        Sun, 13 Mar 2022 19:22:50 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q21-20020a63e215000000b00373efe2cbcbsm14904771pgh.80.2022.03.13.19.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 19:22:50 -0700 (PDT)
Subject: Re: [PATCH 3/3] ceph: convert to sparse reads
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
References: <20220309123323.20593-1-jlayton@kernel.org>
 <20220309123323.20593-4-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <393b92d5-ce25-92dd-936f-049d7a819d13@redhat.com>
Date:   Mon, 14 Mar 2022 10:22:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220309123323.20593-4-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/9/22 8:33 PM, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/addr.c | 2 +-
>   fs/ceph/file.c | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 752c421c9922..f42440d7102b 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -317,7 +317,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
>   		return;
>   
>   	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
> -			0, 1, CEPH_OSD_OP_READ,
> +			0, 1, CEPH_OSD_OP_SPARSE_READ,

For this possibly should we add one option to disable it ? Just in case 
we need to debug the fscrypt or something else when we hit the 
read/write related issue ?

- Xiubo

>   			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
>   			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
>   	if (IS_ERR(req)) {
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index feb75eb1cd82..d1956a20c627 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -934,7 +934,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>   
>   		req = ceph_osdc_new_request(osdc, &ci->i_layout,
>   					ci->i_vino, off, &len, 0, 1,
> -					CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
> +					CEPH_OSD_OP_SPARSE_READ, CEPH_OSD_FLAG_READ,
>   					NULL, ci->i_truncate_seq,
>   					ci->i_truncate_size, false);
>   		if (IS_ERR(req)) {
> @@ -1291,7 +1291,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>   					    vino, pos, &size, 0,
>   					    1,
>   					    write ? CEPH_OSD_OP_WRITE :
> -						    CEPH_OSD_OP_READ,
> +						    CEPH_OSD_OP_SPARSE_READ,
>   					    flags, snapc,
>   					    ci->i_truncate_seq,
>   					    ci->i_truncate_size,

