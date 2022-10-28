Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D04610741
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Oct 2022 03:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiJ1B3u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 21:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbiJ1B3r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 21:29:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF7CA99F9
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 18:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666920527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wla9uF0gA118Z36K6veuICKKbGh2thQWauGdmuDklz4=;
        b=Z39HolheXTCdtQmJH1Td8Ih8LdeQMYDEDKKd/tswMdNt24m6yGlLEiqTnete/ii5ZC7Pa3
        bcMjyfWRfVFbaeoslPoUecDa99QUB9etegjT23UKJc1unuVDv2STjWXP1xNSYMo/T4qTk7
        c9IZ24KKy02YyDU8ybaMiPYkptgitQU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-544-rlPMI5rRPcCqufc__S35GQ-1; Thu, 27 Oct 2022 21:28:44 -0400
X-MC-Unique: rlPMI5rRPcCqufc__S35GQ-1
Received: by mail-pj1-f70.google.com with SMTP id x14-20020a17090a2b0e00b002134b1401ddso1813519pjc.8
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 18:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wla9uF0gA118Z36K6veuICKKbGh2thQWauGdmuDklz4=;
        b=vRsyxqXYhDTD3tzkeaGsDB3xdXw0H4+SHe4v/lWibpB/Nwu2Q7MqCL5/kQgfzkNnjR
         cK5+ZwBjjBJwkyrGlav98epOdqp0nvqnQPj7DL2PvZTkfA43Lv9Mb7R5qx04XZ3eM6Bg
         lGAzWsv0u+9HA6VXEJ9USqnKOj8iGNXRyElaBqckGaYZYHhEUjscZZYsVli0V1gBtk+L
         ySnzvNMrpAC2BHL/MzZ2ko3JiVeTpJW5UrLgY/6inT4r4W0O5mmRw1D42cnnCQAIcV5a
         /2aH2/SOzY986WJwXkTm4aEuT1VIa2qHhag5uqVcdxNwjW1iAbuhhXRc4xxJbOOInpVf
         PVlA==
X-Gm-Message-State: ACrzQf2ccwZRM1BerH6PAMWpFAi0JmWMk7jQttO0c6qUZLEM1iJwfCsC
        RYyYQKRY/VWXItdv8kFgdApjuxVhFp/RlH+eb45hFeCiIKHTpnAogDr4g4IvmfvjDyehxRaegVT
        zrlfKuXa3zFXDO0toEeBQWw==
X-Received: by 2002:a63:3184:0:b0:46f:714d:96f6 with SMTP id x126-20020a633184000000b0046f714d96f6mr211382pgx.298.1666920523319;
        Thu, 27 Oct 2022 18:28:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM64yR5cKYB75ppDJGHgde46Bvcv+KVzYwGEN3aPYDhKENXwt2ytxb7v1yXtoNq23XOELC+igQ==
X-Received: by 2002:a63:3184:0:b0:46f:714d:96f6 with SMTP id x126-20020a633184000000b0046f714d96f6mr211363pgx.298.1666920523052;
        Thu, 27 Oct 2022 18:28:43 -0700 (PDT)
Received: from [10.72.13.65] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 1-20020a17090a0e8100b002009db534d1sm1545432pjx.24.2022.10.27.18.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 18:28:42 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix mdsmap decode for v >= 17
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221027152811.7603-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8b666226-ef41-13ae-c90c-aaa5f499b0a0@redhat.com>
Date:   Fri, 28 Oct 2022 09:28:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221027152811.7603-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 27/10/2022 23:28, Luís Henriques wrote:
> Commit d93231a6bc8a ("ceph: prevent a client from exceeding the MDS
> maximum xattr size") was merged before the corresponding MDS-side changes
> have been merged.  With the introduction of 'bal_rank_mask' in the mdsmap,
> the decoding of maps with v>=17 is now incorrect.  Fix this by skipping
> the 'bal_rank_mask' string decoding.
>
> Fixes: d93231a6bc8a ("ceph: prevent a client from exceeding the MDS maximum xattr size")
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Hi!
>
> This inconsistency was introduced by ceph PR #43284; I think that, before
> picking this patch, we need to get PR #46357 merged to avoid new
> problems.
>
> Cheers,
> --
> Luís
>
>   fs/ceph/mdsmap.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 3fbabc98e1f7..fe4f1a6c3465 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -379,6 +379,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>   		ceph_decode_skip_8(p, end, bad_ext);
>   		/* required_client_features */
>   		ceph_decode_skip_set(p, end, 64, bad_ext);
> +		/* bal_rank_mask */
> +		ceph_decode_skip_string(p, end, bad_ext);
>   		ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext);
>   	} else {
>   		/* This forces the usage of the (sync) SETXATTR Op */
>
Luis,

Because the ceph PR #43284 will break kclient here and your xattr size 
patch got merged long time ago, we should fix it in ceph. More detail 
please see my comments in:

https://github.com/ceph/ceph/pull/46357#issuecomment-1294290492

Thanks!

- Xiubo



