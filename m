Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59CD531FF6
	for <lists+ceph-devel@lfdr.de>; Tue, 24 May 2022 02:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiEXAvh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 May 2022 20:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiEXAvf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 23 May 2022 20:51:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F5E61FA6A
        for <ceph-devel@vger.kernel.org>; Mon, 23 May 2022 17:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653353492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YYTIypUIAadfcSy41CGM20tQJDNF0c7lxi1JOJ+m/Z8=;
        b=DfuAtgdGaAenDRRp4q9ByajuyWWKc9FvP9Go8PC8UDs/+bxryRfOpvEjfO8AYOEOWTdV1f
        VzFyLI6DcVJrnfGyITJ1e3h7bve0sn3rbbkrkYU/3//yA2s6qh+bOGVZHW/b4ivsy1utat
        vQk/AjKevr758u62s9oItF63BKl4SSw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-bkPkZG__Nk6-bLdBTOAAdA-1; Mon, 23 May 2022 20:51:30 -0400
X-MC-Unique: bkPkZG__Nk6-bLdBTOAAdA-1
Received: by mail-pl1-f200.google.com with SMTP id x23-20020a170902b41700b0015ea144789fso8825569plr.13
        for <ceph-devel@vger.kernel.org>; Mon, 23 May 2022 17:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YYTIypUIAadfcSy41CGM20tQJDNF0c7lxi1JOJ+m/Z8=;
        b=Io2AJILWsiXaY+Ok5AO3LxKlqGW9f82iXGGK0GHpUq5Ia8C2E5RszCANbVMzSgaG5A
         2W7EPSL6gOz1s55lBI29x5dZbvri9h+uk6WiYRDtFIGqpV7LmETGhFHYL09nVl9+uU1M
         CtQDI08LixAyaoEhRsAXLpN5WbE7pDNC1+vwK4Topy6pg5HRbSXsaOS7WtFmxaZRiSEq
         s8hAwBLUfnSZqK4HoPWs6VuCRdVD3CH2BBNe3f9vMoZmlWHRtF2lrrj6xNgqFyOaL4Is
         /DMmMt9Y03oa2vHF+lFWc8Fkxa+u3jzx1i7wxZVfFxnZyOqQXhmN7lMOgrvXFYb52rBi
         gFpQ==
X-Gm-Message-State: AOAM533mAil3h1n4+6dtEvgCW/IXjl4dcVhUGQK5m/u1aHUd/KcMWSUF
        kwsWOC1TG3btGk8ixDIe6QtiZ/cjSI0nJOfUxjQLY7/haUlXpZguYtDCTy5DyPZpa63YOJeqR4N
        X2QrPrHJsMLHkQbrWfK2k6Q==
X-Received: by 2002:a63:fc08:0:b0:3f9:e159:b114 with SMTP id j8-20020a63fc08000000b003f9e159b114mr13011206pgi.526.1653353489753;
        Mon, 23 May 2022 17:51:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwH5R8vSDYh7Qy+89u7KjwlPHBHVSXcTSiatpbqsu0in/KQMdoJAbWkmpNFUQY2OLjaEKOovA==
X-Received: by 2002:a63:fc08:0:b0:3f9:e159:b114 with SMTP id j8-20020a63fc08000000b003f9e159b114mr13011200pgi.526.1653353489558;
        Mon, 23 May 2022 17:51:29 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l13-20020a6542cd000000b003c619f3d086sm5367802pgp.2.2022.05.23.17.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 17:51:28 -0700 (PDT)
Subject: Re: [PATCH] MAINTAINERS: move myself from ceph "Maintainer" to
 "Reviewer"
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220523172209.141504-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <70a4bb14-cdb7-2368-1a67-ab69d3ed9317@redhat.com>
Date:   Tue, 24 May 2022 08:51:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220523172209.141504-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/24/22 1:22 AM, Jeff Layton wrote:
> Xiubo has graciously volunteered to take over for me as the Linux cephfs
> client maintainer. Make it official by changing myself to be a
> "Reviewer" for libceph and ceph.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   MAINTAINERS | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d6d879cb0afd..39ec8fd2e996 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4547,8 +4547,8 @@ F:	drivers/power/supply/cw2015_battery.c
>   
>   CEPH COMMON CODE (LIBCEPH)
>   M:	Ilya Dryomov <idryomov@gmail.com>
> -M:	Jeff Layton <jlayton@kernel.org>
>   M:	Xiubo Li <xiubli@redhat.com>
> +R:	Jeff Layton <jlayton@kernel.org>
>   L:	ceph-devel@vger.kernel.org
>   S:	Supported
>   W:	http://ceph.com/
> @@ -4558,9 +4558,9 @@ F:	include/linux/crush/
>   F:	net/ceph/
>   
>   CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
> -M:	Jeff Layton <jlayton@kernel.org>
>   M:	Xiubo Li <xiubli@redhat.com>
>   M:	Ilya Dryomov <idryomov@gmail.com>
> +R:	Jeff Layton <jlayton@kernel.org>
>   L:	ceph-devel@vger.kernel.org
>   S:	Supported
>   W:	http://ceph.com/

Thanks Jeff.

Acked-by: Xiubo Li <xiubli@redhat.com>

