Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A089C609788
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Oct 2022 02:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJXAi0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Oct 2022 20:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiJXAiY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 23 Oct 2022 20:38:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1CA61B12
        for <ceph-devel@vger.kernel.org>; Sun, 23 Oct 2022 17:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666571901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UdhZqMRJmQvgYCScCECdvRWph3XGwvAToTHziUz2vk=;
        b=g/l1H6wiSXQZ6nln7zhFBp8GwsYOu7llemSXyYxQlv9q1XDYHODD1+84kjCqvyWYcUz9nP
        VNjDvPtpB85NEomov+vtrzttOjFwMZ+HxGaZ2pCXXVPqR0GdKLK+bOU8kqtslWcFwTDwLv
        AHEBcfumdIDK9sgzNF2RRYqDXCQSc9c=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-380-IMDPo30yMxKDU1AQTRTYmA-1; Sun, 23 Oct 2022 20:38:20 -0400
X-MC-Unique: IMDPo30yMxKDU1AQTRTYmA-1
Received: by mail-pj1-f72.google.com with SMTP id y9-20020a17090a390900b0020d478b0b68so3111006pjb.3
        for <ceph-devel@vger.kernel.org>; Sun, 23 Oct 2022 17:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/UdhZqMRJmQvgYCScCECdvRWph3XGwvAToTHziUz2vk=;
        b=YCC6q1iT6+EZsTIrBPo37zbrjx5NY1A78QAnmpDm1oohfyBT6eSfbIsNPzFq9H70hf
         mi016DTOwJSeuirdbJNFkJkHJmxVGDWKaYcD5xqcvxP1boJeL+QW6mFATjdZ6RRUFKdi
         9l9S0lIGXhJk9AhZzeY4WWmKj3aZxU2fcqM8wLjsefx/N+32A2Y69c4gYWfCR+APpc77
         h1Q2f9CE4redUjEJdoCDS6NfoU5+Ez+fIrSFOctZDZr9y0Yq9jSlMi4Rj4Yw2SSROo66
         AJIfY9kljxA6/ZA0FeLvteL03vnY52D/KK16IhWTmk+i3h309cNuIo/CWtsHPnMtlalk
         1rqg==
X-Gm-Message-State: ACrzQf3rMJjqbaQWb+RFWXpofOVa3QtVKTje4YgU9HE5Blj+BmZEIUD4
        wfSLYDR1G57O9VO55OkQ8RBvWrwew/eouvWRIzXTR1QBoS7/xSktCWAh55YTk130Sc1ml5RGMR2
        OQWqig90psS/ZVQA2D23VLt0yIilVKljg569sugaXED9qahaPI1iByzK1hAYB1vxy+wLdcJU=
X-Received: by 2002:a17:90a:6909:b0:212:f535:a34b with SMTP id r9-20020a17090a690900b00212f535a34bmr7713932pjj.6.1666571899265;
        Sun, 23 Oct 2022 17:38:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6wHbLCC9ZTvDwwS9U1pcyvx0QqS9dwipUoB06/Zkbk5O1zlmqw7Xz8kmlbrjSJwqQcU6lJ+g==
X-Received: by 2002:a17:90a:6909:b0:212:f535:a34b with SMTP id r9-20020a17090a690900b00212f535a34bmr7713905pjj.6.1666571898964;
        Sun, 23 Oct 2022 17:38:18 -0700 (PDT)
Received: from [10.72.12.79] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b00172f4835f60sm18700537plg.189.2022.10.23.17.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Oct 2022 17:38:18 -0700 (PDT)
Subject: Re: [PATCH -next 3/5] ceph: fix possible null-ptr-deref when parsing
 param
To:     Hawkins Jiawei <yin31149@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     18801353760@163.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org
References: <20221023163945.39920-1-yin31149@gmail.com>
 <20221023163945.39920-4-yin31149@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a587d14f-8bdd-ba61-d750-594359f9e5f2@redhat.com>
Date:   Mon, 24 Oct 2022 08:38:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221023163945.39920-4-yin31149@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
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


On 24/10/2022 00:39, Hawkins Jiawei wrote:
> According to commit "vfs: parse: deal with zero length string value",
> kernel will set the param->string to null pointer in vfs_parse_fs_string()
> if fs string has zero length.
>
> Yet the problem is that, ceph_parse_mount_param() will dereferences the
> param->string, without checking whether it is a null pointer, which may
> trigger a null-ptr-deref bug.
>
> This patch solves it by adding sanity check on param->string
> in ceph_parse_mount_param().
>
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> ---
>   fs/ceph/super.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 3fc48b43cab0..341e23fe29eb 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -417,6 +417,9 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>   		param->string = NULL;
>   		break;
>   	case Opt_mds_namespace:
> +		if (!param->string)
> +			return invalfc(fc, "Bad value '%s' for mount option '%s'\n",
> +				       param->string, param->key);
>   		if (!namespace_equals(fsopt, param->string, strlen(param->string)))
>   			return invalfc(fc, "Mismatching mds_namespace");
>   		kfree(fsopt->mds_namespace);

Good catch!

Will merge it to testing branch.

Thanks!

- Xiubo

