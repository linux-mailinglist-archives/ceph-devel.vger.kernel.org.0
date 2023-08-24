Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04DC7869DD
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Aug 2023 10:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbjHXITW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Aug 2023 04:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240482AbjHXITK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 24 Aug 2023 04:19:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C8610FE
        for <ceph-devel@vger.kernel.org>; Thu, 24 Aug 2023 01:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692865103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTrF4vINF5jS7LQiLYdyF48BPEYBkvqfmSfDJBjjEbs=;
        b=CfNON0XJPo20mmGZ3nPKKOdVriMq2hPBjeRrIFGLdUpZAoLyGLHTCt3YcIVPb6o3k9MHSv
        HtSD0ll8hjIKrw+qXXH18zvM6jcKKJAdIFgG47yxEilDCZT5aPYa2DkRk43Yg5AVHGa79r
        IsFAVe9D5eOGU/OTgTWzzmNqImMVdZM=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-CwYh-dCCPvOGfNii6_nTnA-1; Thu, 24 Aug 2023 04:18:20 -0400
X-MC-Unique: CwYh-dCCPvOGfNii6_nTnA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-565ece76be4so8661840a12.2
        for <ceph-devel@vger.kernel.org>; Thu, 24 Aug 2023 01:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692865100; x=1693469900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTrF4vINF5jS7LQiLYdyF48BPEYBkvqfmSfDJBjjEbs=;
        b=TCCu5tQmK9LKZsjskyPIwhoWOnB1OzaIiKq2eAvAbNrz1Y3Wi4jkHt781tXwJyyv5n
         8gSWJSaO42rVcKiG7UBGCZc2Q6X8XyoFWZ+dWNPnKxGO89VxU+Scj9ZcJAQns14pulfY
         PoBN6cHkH53cTXiBk/Kqd5fNxh60D9I+hIBY0OBTuyb0OgnDkW50eA32CSeZ80Xz7aZm
         slwpkWtec/21tYGAar7GVihnsTePfIO8Z3VSy6XCoc7l9KMBixGfpRhkmaDhEe2ebf2f
         GnoQfNs7gJaj+FfltI6A3y0rure9fvBG1S+VjcsUkCRYFAG1sanxO7MWCOjgdXAHFhkp
         1Ruw==
X-Gm-Message-State: AOJu0YwWi/9gsFVL5gBW96d89/tXya2+3MhAHS+wsyLVVYdR7bK+snN7
        dxT+dJrU0ZzVwPvIZon5hOUEFNocpDAXeKVbYu1BJBF7wQqGQKrW5xdrwFhE7BLCsekb6Bn5z+c
        o6yhh66E7wtLmFfn7MJSuNw==
X-Received: by 2002:a05:6a20:7343:b0:132:2f7d:29ca with SMTP id v3-20020a056a20734300b001322f7d29camr19865052pzc.24.1692865099858;
        Thu, 24 Aug 2023 01:18:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/PhmKYMFw90u1qRn3ESL3p68S/Idsi5WFlV6afQkC98v0aGWlU5S7T90fLQQMYNQbYZ9YTA==
X-Received: by 2002:a05:6a20:7343:b0:132:2f7d:29ca with SMTP id v3-20020a056a20734300b001322f7d29camr19865037pzc.24.1692865099550;
        Thu, 24 Aug 2023 01:18:19 -0700 (PDT)
Received: from [10.72.112.84] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x3-20020a63b343000000b0053051d50a48sm9897547pgt.79.2023.08.24.01.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:18:19 -0700 (PDT)
Message-ID: <260a285f-4dec-5443-401b-eaeeb58b58d9@redhat.com>
Date:   Thu, 24 Aug 2023 16:18:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: Remove duplicate include
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20230824075448.76548-1-jiapeng.chong@linux.alibaba.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230824075448.76548-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/24/23 15:54, Jiapeng Chong wrote:
> ./fs/ceph/mds_client.c: crypto.h is included more than once.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=6211
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   fs/ceph/mds_client.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 7cfa0e3aedb4..9a3b617270c3 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -16,7 +16,6 @@
>   #include "super.h"
>   #include "crypto.h"
>   #include "mds_client.h"
> -#include "crypto.h"
>   
>   #include <linux/ceph/ceph_features.h>
>   #include <linux/ceph/messenger.h>

Reviewed-by: Xiubo Li <xiubli@redhat.com>


