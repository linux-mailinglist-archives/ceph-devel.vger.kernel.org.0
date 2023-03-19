Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842BF6BFF96
	for <lists+ceph-devel@lfdr.de>; Sun, 19 Mar 2023 07:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjCSGcP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 19 Mar 2023 02:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCSGcN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 19 Mar 2023 02:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CB91E29E
        for <ceph-devel@vger.kernel.org>; Sat, 18 Mar 2023 23:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679207489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zgNqSeAnkD8xehBPecL0biGOWA/e3DxTPtpv2Ygur/Y=;
        b=ODR8HxASIgqD4X8x78BKftCr1PnSDDsjg+m3XEnjEyppAoLaXvp20z+OeZBJF3QDedvfQW
        rBdDW77SI6K2QNk+7RoTd11aG/RtA+JYx203myoLnGvMrmg8AadaY4sEl5y6CC7xGOjKMM
        HvH2Xkh9bJ0u16lVUyY3FwNNR4E2csU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-627-pjt9Tz3sNRmcDEXgAWbYaw-1; Sun, 19 Mar 2023 02:31:27 -0400
X-MC-Unique: pjt9Tz3sNRmcDEXgAWbYaw-1
Received: by mail-pl1-f198.google.com with SMTP id c2-20020a170903234200b001a0aecba4e1so5185273plh.16
        for <ceph-devel@vger.kernel.org>; Sat, 18 Mar 2023 23:31:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679207486;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zgNqSeAnkD8xehBPecL0biGOWA/e3DxTPtpv2Ygur/Y=;
        b=a7K0XKU61ALygPdwVMMQO/Lx+QRF+iDFvpAC4cio4n+DvFIDRKDJydWYnH6n2bj5H4
         3iuWRu7rpadErQUuB/XAfpbmdkmPuK6RW43M9B/TgIB65hd75C80XxUxMv4r8378zrBB
         R9d0ULP124rN8zxrLPbcgiXfzZVbqVm5yWEvNL+J+swb1J/lSJWrtpATBPnCTDQrbVel
         64WDee7k76RsGp+PhayF351IvI9gvt7kdHcUp8yTtStlqhwTP+3NsEKkn/dGxSWvq9A8
         8T3wjr/elr1smmNHOdi+dUvHXn2XYFjDsOuk3IrtVvyvhL2sFzdTAFY2+FqeUv9Vg8xz
         sKLA==
X-Gm-Message-State: AO0yUKW7FrsSokvW5+FunerbON6Jpdi6tdFBxaylHIxLagF2bx6W25SY
        TkulbSBjKsaBKUdgu5zfiqXrJesAC7NCyiNkarjMW021XZZg/xms3RBA6r7JmDV3uwTyew8bFs3
        QUsKtEtcZgl4a9yipmjCXTd5R4nLETvCm
X-Received: by 2002:a17:90b:4f8f:b0:23d:3264:16bf with SMTP id qe15-20020a17090b4f8f00b0023d326416bfmr8913353pjb.0.1679207486228;
        Sat, 18 Mar 2023 23:31:26 -0700 (PDT)
X-Google-Smtp-Source: AK7set94uc4iv61YoA1d4TWU2d7GFhycEo2ecSc2LC2X95ErJvVMSDZOiBFni0EyDMGzcYYBhOWCbA==
X-Received: by 2002:a17:90b:4f8f:b0:23d:3264:16bf with SMTP id qe15-20020a17090b4f8f00b0023d326416bfmr8913341pjb.0.1679207485956;
        Sat, 18 Mar 2023 23:31:25 -0700 (PDT)
Received: from [10.72.12.59] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n4-20020a17090ac68400b0023d1b9e17e2sm3819968pjt.31.2023.03.18.23.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 23:31:25 -0700 (PDT)
Message-ID: <c16a822c-1237-118b-ec3d-adf64289a7a5@redhat.com>
Date:   Sun, 19 Mar 2023 14:31:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] generic/075: no need to move the .fsxlog to the same
 directory
Content-Language: en-US
To:     fstests@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org, ceph-devel@vger.kernel.org,
        vshankar@redhat.com, zlang@redhat.com
References: <20230301020730.92354-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230301020730.92354-1-xiubli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ping.

What's the status of this patch ?

Thanks

- Xiubo


On 01/03/2023 10:07, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Actually it was trying to move the '075.$_n.fsxlog' from results
> directory to the same results directory.
>
> Fixes: https://tracker.ceph.com/issues/58834
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   tests/generic/075 | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/tests/generic/075 b/tests/generic/075
> index 9f24ad41..03a394a6 100755
> --- a/tests/generic/075
> +++ b/tests/generic/075
> @@ -57,7 +57,6 @@ _do_test()
>       then
>   	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
>   	mv $out/$seq.$_n $seqres.$_n.full
> -	mv "$RESULT_DIR"/$seq.$_n.fsxlog $seqres.$_n.fsxlog
>   	od -xAx $seqres.$_n.full > $seqres.$_n.bad
>   	od -xAx "$RESULT_DIR"/$seq.$_n.fsxgood > $seqres.$_n.good
>   	rm -f "$RESULT_DIR"/$seq.$_n.fsxgood

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

