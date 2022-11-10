Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39788623B74
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Nov 2022 06:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiKJFqg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Nov 2022 00:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKJFqe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Nov 2022 00:46:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A087F13FB5
        for <ceph-devel@vger.kernel.org>; Wed,  9 Nov 2022 21:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668059144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8k4w4Vnv9fqY6JUFkeKEzkLEw9Y/HJrXWV3TRz87NqA=;
        b=i8S1sU6K9Zi/IJ/UAW9mYHjNqCg+JGzK94ErSQlv2xMbBcSYzBLN025MXdgQSo3xmOMhQT
        JfIvicdsCDuvbwaE00YcCUHso2ipGyxfzvGFmXLTICjn9lCGRm+szAS2EuGTUCvK36vu0y
        ZQfCzgsBI0Xo4wM0x6njTWOrRLBvvZU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-631-ekFiFxQbP8ei7xp1h7oizg-1; Thu, 10 Nov 2022 00:45:03 -0500
X-MC-Unique: ekFiFxQbP8ei7xp1h7oizg-1
Received: by mail-pl1-f199.google.com with SMTP id q6-20020a170902dac600b001873ef77938so670395plx.18
        for <ceph-devel@vger.kernel.org>; Wed, 09 Nov 2022 21:45:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8k4w4Vnv9fqY6JUFkeKEzkLEw9Y/HJrXWV3TRz87NqA=;
        b=GRTTX/w5v34Z0eExbZIIUNRYKDFDQN2ZodYInOA3xtvddpIb0NWN5PdNCivDB5Jn0l
         hYLK7j8V8gxhG5efkbBEVxsG4RoW2hvdhqfebMCPrNNqRf4woKFKPdE2D/2raXTRzpdl
         l2UufWemeACEzsLRQsQChBHclJNEohfSJAnfDJhOlLXvOYSGslJndy0SyTpRWxXWOkFX
         yXETIssT55SpZ7s1Vpw4Ss9vqYYOT48yVf6d1lXIFowD3so6iVWf8v14VLVRB8hGBdEO
         Qv2enLaai5wcIxMCpnkzY2nTJYTbRCNn7DMiFKCmCXueUOVc+M8I7o4l7juWi0JP3M7a
         8BaQ==
X-Gm-Message-State: ACrzQf13629kQAaEd/XLrf1av9ArnhzRDWIalEX5q5P2y+NQhMeuE6mH
        O2Ju+EA/UaAuWjG5S5gYkhAiPF6poGBg8KaP0uTPZKXPzxKhBHW3Sp7VG4b+nUsX7MdzefK0cDt
        kPivpbp/gP2otOjZpdWGNmw==
X-Received: by 2002:a17:902:d38d:b0:186:9fc5:6c13 with SMTP id e13-20020a170902d38d00b001869fc56c13mr63823527pld.73.1668059102684;
        Wed, 09 Nov 2022 21:45:02 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5Od5hw/v96iirS/f5xvd1IT5T0T2A96tmeZWR8dgNsa6AbLSl0yB/i2/FSqXPQnXI2ZtpnaQ==
X-Received: by 2002:a17:902:d38d:b0:186:9fc5:6c13 with SMTP id e13-20020a170902d38d00b001869fc56c13mr63823513pld.73.1668059102386;
        Wed, 09 Nov 2022 21:45:02 -0800 (PST)
Received: from [10.72.12.148] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b1-20020a170903228100b00176ba091cd3sm10211389plh.196.2022.11.09.21.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 21:45:01 -0800 (PST)
Subject: Re: [PATCH] ceph: Fix NULL vs IS_ERR checking in ceph_getattr
To:     Miaoqian Lin <linmq006@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221110031311.1629288-1-linmq006@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <67a1782c-9b7d-055a-5e62-456294cb4401@redhat.com>
Date:   Thu, 10 Nov 2022 13:44:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221110031311.1629288-1-linmq006@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Miaoqian,

Thanks for your patch. This has already been fixed by Dan Carpenter 
weeks ago and already in the ceph-client's testing branch, please see [1]:

[1] 
https://github.com/ceph/ceph-client/commit/ffc4d66a34bb5bd76d0a3f83bebf500d96a8e37c

BRs

- Xiubo

On 10/11/2022 11:13, Miaoqian Lin wrote:
> The ceph_lookup_inode() function return error pointers on error
> instead of NULL.
> Use IS_ERR() to check the return value to fix this.
>
> Fixes: aa87052dd965 ("ceph: fix incorrectly showing the .snap size for stat")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
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

