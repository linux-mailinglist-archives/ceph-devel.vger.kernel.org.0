Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D963F62B383
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Nov 2022 07:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiKPGxE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Nov 2022 01:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiKPGw7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Nov 2022 01:52:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22F928704
        for <ceph-devel@vger.kernel.org>; Tue, 15 Nov 2022 22:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668581523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vq7VhhIioEkBpyEyo7DjXd2G6elh/0ZIzPMU9tWeQtI=;
        b=Cr1O0A/2y/+9pJePH6dcaqaTC/EVLXsbgNBNJKyzJtj/MC2RJR9x24gVmvF1vWl35cD2m2
        K9OJsA9r6nPLqv/V+VL5gt9udWDYrjN0lTYrER2ExkJXVD/mgh+AmVBdFqlMVkXSKkr0oa
        ONjyzn6BBhApeHN02SzWbBxgkQ/W3zM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-659-4QAI4Dh0MNORQByX3QgN4Q-1; Wed, 16 Nov 2022 01:52:00 -0500
X-MC-Unique: 4QAI4Dh0MNORQByX3QgN4Q-1
Received: by mail-pl1-f198.google.com with SMTP id k9-20020a170902c40900b0018734e872a9so13259638plk.21
        for <ceph-devel@vger.kernel.org>; Tue, 15 Nov 2022 22:52:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vq7VhhIioEkBpyEyo7DjXd2G6elh/0ZIzPMU9tWeQtI=;
        b=fXFgMg2zY84W8CpdysXHonkEvq1sG2YZ9AMWxxScQ1+/S37BrPlykdjxV9MWqGtSLE
         55DbrrqkKoOQwaVK/hcezuTGXLcq5v1O8H3jGYY7WOAYAxTEef/sGZZkwC+nmSgmcZPR
         uUW/Dy99LGd+SL469HO3Rd/aHqw1ZxKq1d/Gr4cZcVHKuN3s2vXGmEcKxj8wXSn4EBTC
         /d3teGdRJMjZSuKcDnG7fmqshZIQSWBGN64bX8X0uRLrjbNLb72wFiscRWBC3MtXJRKV
         96UMw7TJxuc9YWyEthGIGZNw7Vj4fKuvS8UxIIbsGbsUxdVEQJxucJgewFn6ACe9+jh4
         NUZA==
X-Gm-Message-State: ANoB5pke69mbfuVkL6d13WCkqX1ouvpYz4oRvd72NfIKFHSmNxbV3cMU
        zg3Uruee9VIKYc697YCICzwYVmPCtJPdhABYpfSkbp4f+7759rEGaaw2usYRkeJ3d2IqKVZW5Px
        64fqPRtH936AfpAJJ97Jnddt3U5D9gouCAFE/FW/0P8Uvnr+CfYeG/HAqjm6kfuTvAyYw0MU=
X-Received: by 2002:a63:5424:0:b0:437:e9f3:8add with SMTP id i36-20020a635424000000b00437e9f38addmr19759863pgb.438.1668581519454;
        Tue, 15 Nov 2022 22:51:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7+0OfWBbrari+7dV4zBDsFtuPije+sFKtUBkTUreEdTCQahUh3c8waFkHfFyhFgatJ7IM7KA==
X-Received: by 2002:a63:5424:0:b0:437:e9f3:8add with SMTP id i36-20020a635424000000b00437e9f38addmr19759826pgb.438.1668581518680;
        Tue, 15 Nov 2022 22:51:58 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709027fcc00b00186a6b63525sm11114188plb.120.2022.11.15.22.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 22:51:58 -0800 (PST)
Subject: Re: [PATCH] ceph/005: skip test if using "test_dummy_encryption"
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20221115144500.10015-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b6df573a-4760-d9bc-8085-0e2a1c0ad119@redhat.com>
Date:   Wed, 16 Nov 2022 14:51:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221115144500.10015-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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


On 15/11/2022 22:45, Luís Henriques wrote:
> When using the "test_dummy_encryption" mount option, new file and directory
> names will be encrypted.  This means that if using as a mount base directory
> a newly created directory, we would have to use the encrypted directory name
> instead.  For the moment, ceph doesn't provide a way to get this encrypted
> file name, thus for now simply skip this test.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   tests/ceph/005 | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/tests/ceph/005 b/tests/ceph/005
> index fd71d91350db..015f6571b098 100755
> --- a/tests/ceph/005
> +++ b/tests/ceph/005
> @@ -13,6 +13,7 @@ _begin_fstest auto quick quota
>   
>   _supported_fs ceph
>   _require_scratch
> +_exclude_test_mount_option "test_dummy_encryption"
>   
>   _scratch_mount
>   mkdir -p "$SCRATCH_MNT/quota-dir/subdir"
>
Reviewed-by: Xiubo Li <xiubli@redhat.com>

