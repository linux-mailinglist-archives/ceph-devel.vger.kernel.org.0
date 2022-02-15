Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A86B4B6B49
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 12:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiBOLiy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 06:38:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiBOLix (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 06:38:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 131B02A266
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 03:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644925122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cm79KxMob3PS4qoLLiV1cm9E2Q7/PY/UMhR3gT4r/Q4=;
        b=X6EG/BG1FKWVT/Bf2Pizg5iY53QrWSv4G3AWsbQhu+s93YQUkOqoK5Y6H6u204idXOuX3E
        flS8xuSdObNomgJGKHcaWAQ1sAIcBQ5ztJdey1eFOFt/CQuItlw4AVeapIgxURopIMzYEK
        oV0m6sgAzE2oxEn+TimQayaOQQl1FIc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-mgH-Oj16NKiaquKx1T57GA-1; Tue, 15 Feb 2022 06:38:38 -0500
X-MC-Unique: mgH-Oj16NKiaquKx1T57GA-1
Received: by mail-qv1-f72.google.com with SMTP id gi11-20020a056214248b00b0042c2cc3c1b9so13770570qvb.9
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 03:38:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Cm79KxMob3PS4qoLLiV1cm9E2Q7/PY/UMhR3gT4r/Q4=;
        b=M7HzgyEGXYUohVnwugG+UDC9tiMd/+zuUHwQx+h2xtdDC3NDivu/6QyOFiOdaAzy0X
         vB14GVM/AK5Qv4vJQeFD9bP5EZDZKGaQlxx+azbdHsTQXAk8GjEbwtR7fm1fEQ2NdQBB
         MkQ0twEsFdYZUmsxrLfY/s9FAAti4shVO36kKkZ4TfpJupIzjZu/TyX37bq2ChWxpUo3
         S0wOHgyB0h2cbyIwv7aeSMdgOyeRiDPs0BoNFGX0WjoHFTwVpjEsYnzMSKLHqQBxVmE8
         YDVjhbMReMRhRJi18wJjtfaGepzm9yY5IRg5mIXJg77WWldSj59EqUI3mEuQzhLbYuDJ
         n4TA==
X-Gm-Message-State: AOAM530MgEy4mfyzcbKm2Wmtr8fcj1qX2li8LcX0sWM3XXPxDQgHaihL
        XAEp/MIkgwOQ+Smd/0eLPJ+0A2V25B5V2ZI0lkJASRZ2pUVOmTxaEIUzYEucT0ShXeLwU03Syk/
        /cstOKiZPqBVI298iipsASg==
X-Received: by 2002:a05:622a:12:: with SMTP id x18mr2262772qtw.264.1644925118459;
        Tue, 15 Feb 2022 03:38:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0gh9ENkwDyh3kbht9EzCwTLjyrIPvduynlSbPSS1u+pxxirwnmlnruxxu3u95errl+5V/WA==
X-Received: by 2002:a05:622a:12:: with SMTP id x18mr2262766qtw.264.1644925118284;
        Tue, 15 Feb 2022 03:38:38 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id m9sm17953149qkn.81.2022.02.15.03.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:38:37 -0800 (PST)
Message-ID: <3f74605528367ae8935aaade101c168198e3996f.camel@redhat.com>
Subject: Re: [PATCH 0/3] ceph: forward average read/write/metadata latency
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Tue, 15 Feb 2022 06:38:37 -0500
In-Reply-To: <20220215091657.104079-1-vshankar@redhat.com>
References: <20220215091657.104079-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-02-15 at 14:46 +0530, Venky Shankar wrote:
> Right now, cumulative read/write/metadata latencies are tracked
> and are periodically forwarded to the MDS. These meterics are not
> particularly useful. A much more useful metric is the average latency
> and standard deviation (stdev) which is what this series of patches
> aims to do.
> 
> The userspace (libcephfs+tool) changes are here::
> 
>           https://github.com/ceph/ceph/pull/41397
> 
> Note that the cumulative latencies are still forwarded to the MDS but
> the tool (cephfs-top) ignores it altogether.
> 
> Latency standard deviation is calculated in `cephfs-top` tool.
> 
> Venky Shankar (3):
>   ceph: track average r/w/m latency
>   ceph: include average/stdev r/w/m latency in mds metrics
>   ceph: use tracked average r/w/m latencies to display metrics in
>     debugfs
> 
>  fs/ceph/debugfs.c |  2 +-
>  fs/ceph/metric.c  | 44 +++++++++++++++++++++++----------------
>  fs/ceph/metric.h  | 52 +++++++++++++++++++++++++++++++++--------------
>  3 files changed, 65 insertions(+), 33 deletions(-)
> 

Looks good, Venky. Merged into testing branch. I did make a small change
to the last patch to fix a compiler warning. PTAL and make sure you're
OK with it.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

