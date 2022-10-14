Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A604C5FEE58
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Oct 2022 15:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJNNGK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Oct 2022 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJNNGJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Oct 2022 09:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6CA2CDC6
        for <ceph-devel@vger.kernel.org>; Fri, 14 Oct 2022 06:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665752768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2yLIl2GUxdjw1hchGpPbAzz/dx/oE6hKuMf6JCaP1c4=;
        b=PVzPd/t+VMEA4Rkew22LxbShNXEML9MK1OTALaZOE7IO8pLk/ebGGcwezYpnWVxLcKhVTf
        NGjoBtWwX0yns1EU1fM2ZmkpIqqsvx9IGrF0lxc8PrvuoxOKB75fqgn7miRkWgRtiwYpxx
        87c1+oF9LhT5p5MvXOQA9Wj1SiUKzXA=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-96-C4bFaI8tNY28QUBRXLJNUw-1; Fri, 14 Oct 2022 09:06:06 -0400
X-MC-Unique: C4bFaI8tNY28QUBRXLJNUw-1
Received: by mail-pf1-f200.google.com with SMTP id q18-20020aa79832000000b00562d921e30aso2885367pfl.4
        for <ceph-devel@vger.kernel.org>; Fri, 14 Oct 2022 06:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2yLIl2GUxdjw1hchGpPbAzz/dx/oE6hKuMf6JCaP1c4=;
        b=biy01DI0vhWPeLsurBE503I258cE+Kvld5Zbb0ct7HeXm8on1Q0us73ZAZ+0Q/80a7
         Mmm0EVvmShMi04S++O6ajGYGsEZN9Z9F0tRiZe7F1R0HeMeOGsNWg4qRZ6WqD5QlbzHK
         27HjDLNn4506fIGlz5TLOBvQOW6YOVn7o3bJZVkIhnZoQ8KBekGB4J6y6qCwyF6YmNNn
         tMBffFHOQ23AfEMzbroJTRquDYmYP/tE93vDapJsDWuvrGsvLPZ/MoRoE2yZ7krg7hKn
         P9c7te4+f1t8HbJ/E94Pxrr8Rb1Iabjj/PBiRimZ0t6wI1wGtxQfW3eO5fBMSDxYgRjy
         krEw==
X-Gm-Message-State: ACrzQf29jv/gkROyLzkMDbB0vC6V2q63mGDIBzehbTg6m+xAFn0UCHXr
        0Whp+eS534ddNKhKh3+x1pomYwdmPGkAfwOmmu/RfLlAhwPEb6P6OHHfeVTGDVIXGpXwEX2pSsH
        vt6Gioyry0soyr4CSGETj6w==
X-Received: by 2002:a17:90b:23c5:b0:20b:1cb4:2ca9 with SMTP id md5-20020a17090b23c500b0020b1cb42ca9mr17594168pjb.139.1665752765652;
        Fri, 14 Oct 2022 06:06:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5N8y2bX9I4l2OjPbgrab8/LojaGdXeVUYqqHKbCKHIA+FYupUl5l4GOSqQYKKPnTPPOlOJww==
X-Received: by 2002:a17:90b:23c5:b0:20b:1cb4:2ca9 with SMTP id md5-20020a17090b23c500b0020b1cb42ca9mr17594120pjb.139.1665752765197;
        Fri, 14 Oct 2022 06:06:05 -0700 (PDT)
Received: from [10.72.12.247] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090322c400b0017f75654a33sm1677576plg.73.2022.10.14.06.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 06:06:04 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix a NULL vs IS_ERR() check
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <Y0kttQIe0+2Rw+SP@kili>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4ab06613-4e98-4364-22e9-ae116d9e5c8c@redhat.com>
Date:   Fri, 14 Oct 2022 21:05:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y0kttQIe0+2Rw+SP@kili>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 14/10/2022 17:36, Dan Carpenter wrote:
> The ceph_lookup_inode() function returns error pointers.  It never
> returns NULL.
>
> Fixes: aa87052dd965 ("ceph: fix incorrectly showing the .snap size for stat")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   fs/ceph/inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 4af5e55abc15..bad9eeb6a1a5 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2492,7 +2492,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>   			struct inode *parent;
>   
>   			parent = ceph_lookup_inode(sb, ceph_ino(inode));
> -			if (!parent)
> +			if (IS_ERR(parent))
>   				return PTR_ERR(parent);
>   
>   			pci = ceph_inode(parent);

Good catch!

Will merge it to the testing branch soon.

Thanks Dan.

- Xiubo


