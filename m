Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB25A057B
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 03:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiHYBEl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Aug 2022 21:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHYBEk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Aug 2022 21:04:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0AF5A3F1
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 18:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661389478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mR5KiPTSwVrKZkNEaoreaFGT3l3r38J60sC/0324n3g=;
        b=iwj7/yxiawq3ZkZp4e6gR5N3toizTfcwYfs/CBaEqSVknEQBnaAVlWRdYVBStNG74v5yMT
        IWSi8wQ/n/lS2nEiD4/aDoPfUvUlcX3OdN90oHBHOKOIvs60yQ4R+xcUEx6Ld8KKIgYc8F
        Ee6gvLpUFLHloNgRXE6mfDpRhzEiqjk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-497-k8vPtFAXN5OWijMBjqawPA-1; Wed, 24 Aug 2022 21:04:37 -0400
X-MC-Unique: k8vPtFAXN5OWijMBjqawPA-1
Received: by mail-pj1-f70.google.com with SMTP id s17-20020a17090aad9100b001faf81f9654so1893716pjq.5
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 18:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=mR5KiPTSwVrKZkNEaoreaFGT3l3r38J60sC/0324n3g=;
        b=0IlMR0rDKcIKuM4OdXTg9w33/JZ2L6oR/1ZFnm2wNVmkv8K/afXqormYzquGKHopSY
         4mgkjl6KUUAmErLajSL6RHElL0ccFu3HV6vRIbOHykapAnfjrBYk0n86fQvtezQ0OHPs
         XpRhqiOUkbm8gkSaCp1iOoEbFIrErdfvjyO+UbnOM0rW1p+MSMJoa9UvnF1TUVVY0Eid
         nO7yetgcZmGNTg3gm1JUPO7woZUBuExcsQ3YD8M1n/Cos0sTPB3hPkZTm6spaWmTVMnR
         nqTdKraU9wgQPxKbq0kqQNSNiCwtfnQ5Mufxk6Y0ISU8zX6iMU+JMdczwV+kcsEzod3U
         sg5Q==
X-Gm-Message-State: ACgBeo1gycPBLWmaGhuie8dZSEptk3a3pnM9Yc4ifIpu6cfHp70qxvCK
        dcXhAZub1dJkz4ilXGYIZT8LtUEHPjcSW6B6czTJZV+Fl/AaNy2fruSzpOM/6Ov1E3T4Ui2OUYq
        TYJLfiJHA8N1DcBkUkzNBDfD8vGafoky2DFjxCQ+UKzGFTIkwgGCvEC3zwz7MLtcmrv05YLY=
X-Received: by 2002:a63:da13:0:b0:42a:7f03:a00e with SMTP id c19-20020a63da13000000b0042a7f03a00emr1243312pgh.332.1661389475852;
        Wed, 24 Aug 2022 18:04:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5KDVfCMK2WAdF461rR0NW5rGahnDzSo1PKJy2l9qsNCi8elUDAhCeua0xEW0n5ber15LJjfQ==
X-Received: by 2002:a63:da13:0:b0:42a:7f03:a00e with SMTP id c19-20020a63da13000000b0042a7f03a00emr1243276pgh.332.1661389475450;
        Wed, 24 Aug 2022 18:04:35 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p189-20020a625bc6000000b00518285976cdsm13628331pfb.9.2022.08.24.18.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 18:04:34 -0700 (PDT)
Subject: Re: [PATCH] ceph: increment i_version when doing a setattr with caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220824132442.102062-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c091ed00-8573-2cfc-3d2c-fdd2ee30fce3@redhat.com>
Date:   Thu, 25 Aug 2022 09:04:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220824132442.102062-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/24/22 9:24 PM, Jeff Layton wrote:
> When the client has enough caps to satisfy a setattr locally without
> having to talk to the server, we currently do the setattr without
> incrementing the change attribute.
>
> Ensure that if the ctime changes locally, then the change attribute
> does too.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/inode.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index ccc926a7dcb0..65161296d449 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2192,6 +2192,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
>   		inode_dirty_flags = __ceph_mark_dirty_caps(ci, dirtied,
>   							   &prealloc_cf);
>   		inode->i_ctime = attr->ia_ctime;
> +		inode_inc_iversion_raw(inode);
>   	}
>   
>   	release &= issued;

Good catch!

Merged into the testing branch.

Thanks!

-- Xiubo

