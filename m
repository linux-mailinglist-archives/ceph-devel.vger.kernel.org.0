Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BCD4BA03C
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 13:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiBQMfi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Feb 2022 07:35:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiBQMfh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Feb 2022 07:35:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E04E429E958
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 04:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645101321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZvNP4VBWWcatpeDdPUBh8/E3X0kvHJKSfE3gubPDNKo=;
        b=ZkzCh4XLWxNuQ8K8gzKx5E35aC20ubhqJK0Z2BD9aYeDOTRO+y+3/aXq3W14LOTgzgG+mm
        dH2urGFz28DbYvOFf5yFBIh4kHlMMZG3lMsJP5ob+jEM0STr3cE8rbyEJTqakS75lIol9W
        LfdcfnRJsTZxSixcPaHsMGl6DgKMo3k=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-yDBCLi__MbyE5J6a2D3Gcg-1; Thu, 17 Feb 2022 07:35:20 -0500
X-MC-Unique: yDBCLi__MbyE5J6a2D3Gcg-1
Received: by mail-lj1-f197.google.com with SMTP id q20-20020a05651c055400b0024608fd7cdbso2108456ljp.17
        for <ceph-devel@vger.kernel.org>; Thu, 17 Feb 2022 04:35:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZvNP4VBWWcatpeDdPUBh8/E3X0kvHJKSfE3gubPDNKo=;
        b=X801cliPwWkS5rMPeO9a4h5ZlRLhktHGFFVOhA7Fgyqekm0Z1sVlG/zlCaQU1MWnbO
         zicOudyqwNE7L/i0ufeAdMr/fZVQXwWkK3fJibHFUU/M0GgMC//HV5IbmGAwuIaG2qY8
         3lu+aDBDf5ZkKnZX0PEKkSDGFymRf5HfXN0yE4VG4uwXyfAOuZaFVdqsF7n/aSWgBQzP
         HGn3XW6IUzGMlnp2twle3f2kkzlj0i3HePpW1kp6oD+00ttTOzLVKVRBrCJ/ZZcDswwX
         2ZRXybfnTQ0C705jPuWGTynpyBvyYQ7wD4HYX0dM5FLVVZ7zfbthFIqzUY84+3Wy7Xbn
         RC6g==
X-Gm-Message-State: AOAM533DCO/aRgxWP8qMnvIa2eafPjyi/gqAtyGTWMXrJ/tqvMhMzgzH
        nJrH8R4Os7BTMR3MRYeNSMEOs1iUyxyToN1NMDeZ00djooC3583kxVFVAtl8WNi+snTVQjqNfr9
        OBDGPx3b4HUvDj0JCukqyDBcZL2ynaAwcHX8gSg==
X-Received: by 2002:a05:6512:b91:b0:443:922a:c93b with SMTP id b17-20020a0565120b9100b00443922ac93bmr1960624lfv.121.1645101319044;
        Thu, 17 Feb 2022 04:35:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWhOp8KeuHPts8tBywtFZtnEProR/hMmDoBk4JaNZo30V5kFzPUWI695uLnm/TGjBkl8pz/Pn6Urlp5WMyltY=
X-Received: by 2002:a05:6512:b91:b0:443:922a:c93b with SMTP id
 b17-20020a0565120b9100b00443922ac93bmr1960615lfv.121.1645101318856; Thu, 17
 Feb 2022 04:35:18 -0800 (PST)
MIME-Version: 1.0
References: <20220217081542.21182-1-xiubli@redhat.com>
In-Reply-To: <20220217081542.21182-1-xiubli@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Thu, 17 Feb 2022 18:04:39 +0530
Message-ID: <CACPzV1=geW=nGJOzw3KZ==SQBxcB-MVC9GYWhy=jmgKDHMt_QA@mail.gmail.com>
Subject: Re: [PATCH] ceph: zero the dir_entries memory when allocating it
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 17, 2022 at 1:45 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This potentially will cause bug in future if using the old ceph
> version and some members may skipped initialized in handle_reply.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 93e5e3c4ba64..c3b1e73c5fbf 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2286,7 +2286,8 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>         order = get_order(size * num_entries);
>         while (order >= 0) {
>                 rinfo->dir_entries = (void*)__get_free_pages(GFP_KERNEL |
> -                                                            __GFP_NOWARN,
> +                                                            __GFP_NOWARN |
> +                                                            __GFP_ZERO,
>                                                              order);
>                 if (rinfo->dir_entries)
>                         break;
> --
> 2.27.0
>

Looks good.

Acked-by: Venky Shankar <vshankar@redhat.com>

-- 
Cheers,
Venky

