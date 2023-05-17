Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725F5705C0E
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 02:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjEQAlV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 May 2023 20:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjEQAlT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 May 2023 20:41:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB54D9E
        for <ceph-devel@vger.kernel.org>; Tue, 16 May 2023 17:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684284031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6e+XP0wt3t9p2rv2rjuk4UQmMTynuIWCH/JljqNeoQ=;
        b=HHDR1m6TedPFqVOD9RJFk5POjlkhD1s/K5tiLXj2Gq6Yn+QUi2UOGX1gXicVqzhohth5Dt
        dGZ1eaT06LdNBzIyXlMtM7NZkGWZK2tnpgq7ZtRMN5vt3kdi/G5G0Tx7aCbJpyGq5wWNqU
        j49nz+RUnMGDrzMwitZSpDN+lnSjH5s=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-wyaCpaG7MoCCzOzGMLs4Dg-1; Tue, 16 May 2023 20:40:29 -0400
X-MC-Unique: wyaCpaG7MoCCzOzGMLs4Dg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-64386573ba8so73128b3a.3
        for <ceph-devel@vger.kernel.org>; Tue, 16 May 2023 17:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684284028; x=1686876028;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6e+XP0wt3t9p2rv2rjuk4UQmMTynuIWCH/JljqNeoQ=;
        b=CmwDPYArk0ykmC4ojvGIO/rbgLZ3/8bgt45bDOnP/frYIrC5lM5OlEHyX3KtJG4/QL
         3KU+rLzg4TD6rpDf21xrgFYUMWXEKbHfnbVpcuLtL6BBfcdpQGhZ4cc6CYdql6yq5GdX
         dMoIR6rc7e1yp1xc13RJT7uwJ7vbQnkGXL+yfPWstlip2qV6aeO1FSBkAbHMt0b9w/si
         r3e3C+yfo1uK2ikJxDHwP7quH9Ig6BH2+7Lr3M4c4iM9ZNnDqUbJbKV4jIR0AaXRB1y1
         uL0DORwIfkM9yKAnecFRO/+PbsUc+d+HE2qAGAB3cRAGVjc0ga+0bfbAKA8PcIdcaCcF
         LAaw==
X-Gm-Message-State: AC+VfDxgBvmNjoLBmSHogMvoySSVU+vxE/bUKt0V44T2Wu6//5IhgRhi
        UqhmwPd77fX8L3xrSAdopQtKkffa0RDKBC1SxdIclJFT8JFnu1bentCrnmGsir35v2Cp7jnT36J
        0vKP9rRSHIijylJKmKXTFxA==
X-Received: by 2002:a05:6a20:a12b:b0:101:5037:7542 with SMTP id q43-20020a056a20a12b00b0010150377542mr33645410pzk.10.1684284028102;
        Tue, 16 May 2023 17:40:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5p6PllfNsVJYOFKkVMkOAvvWBBQEIPni5j+20gcvr55ibGS++zE5X/DQt+TTFO6zTel/AS7g==
X-Received: by 2002:a05:6a20:a12b:b0:101:5037:7542 with SMTP id q43-20020a056a20a12b00b0010150377542mr33645394pzk.10.1684284027780;
        Tue, 16 May 2023 17:40:27 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k11-20020a63d10b000000b0051b71e8f633sm14019411pgg.92.2023.05.16.17.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 17:40:27 -0700 (PDT)
Message-ID: <5b6700c6-f0ba-4b4f-caaa-564960399399@redhat.com>
Date:   Wed, 17 May 2023 08:40:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/3] ceph: account for name and fsid in new device spec
Content-Language: en-US
To:     Hu Weiwen <huww98@outlook.com>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/8/23 01:53, Hu Weiwen wrote:
> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
>
> We have name and fsid in the new device spec format, but kernel just
> discard them.  Instead of relying on the mount.ceph helper, we should do
> this directly in kernel to ensure the options and device spec are
> consistent.  And also avoid any confusion.
>
> Hu Weiwen (3):
>    ceph: refactor mds_namespace comparing
>    ceph: save name and fsid in mount source
>    libceph: reject mismatching name and fsid
>
>   fs/ceph/super.c        | 51 +++++++++++++++++++++++++-----------------
>   net/ceph/ceph_common.c | 26 ++++++++++++++++-----
>   2 files changed, 52 insertions(+), 25 deletions(-)
>
Will apply this patch series to the testing branch and run the test.

Thanks Weiwen

- Xiubo

