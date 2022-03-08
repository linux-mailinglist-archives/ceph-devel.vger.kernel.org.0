Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B514F4D1C99
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 16:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiCHP7m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 10:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348164AbiCHP7i (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 10:59:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD7CE50056
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 07:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646755106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/+3TahlbEZ3UdRkrjsad80A57hfwyXIvdd6xioUCCY=;
        b=MEA5MhT/F8dwK8mXTDBB6lJXdwcPizEYiYcJYa+JJSP9rQIGfnXtPmWFA4AwoGEKIUvk3n
        +qHdOBa5h+Awu1pitmaZB6K8J7xCtwSbMHhl5qtfUON0G0LN5nZPAH2F9FvXfAw+t0KzfV
        PTxCpr7l55E9cAa+6xBLXcGWZWxVpPk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-oZMslxXjMw-4zEIIGT7r0g-1; Tue, 08 Mar 2022 10:58:24 -0500
X-MC-Unique: oZMslxXjMw-4zEIIGT7r0g-1
Received: by mail-qt1-f200.google.com with SMTP id x10-20020ac8700a000000b002c3ef8fc44cso15533585qtm.8
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 07:58:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=X/+3TahlbEZ3UdRkrjsad80A57hfwyXIvdd6xioUCCY=;
        b=LodcitIEvq+cCpTgQqitsHVRJbUVKpUKJ6TiuACk//oVQVnjS+WuKK1Yp9/ZVnhBYH
         +Swp+bvlWdoec3qslZt5+U4405UE8TIlBWITE7Cb2o9zYkioauH6SRL7H09QeSPLauK9
         0G57QCidYfJBqMwWXk42QqrMqqteaAMQJHQJVyVVJD9H1fKv4Spg9ok6P84HrSNVDSgA
         AviTkKCNfl6SMdXHwAW2E02C7eSY35otB+tBaPWKJqYeSQU7TV6+TXGl4dufcF+ERoe9
         kYwngaG6Ddzt2Z4dDX8drEk7BvfWTlkySERFVuHEaXMqIMJ7G4qCpiG4cPj51i/q5rwA
         v7HA==
X-Gm-Message-State: AOAM530R7CT904ebbi/OdU6AQ5sqk5vA/5JQaTBdd/a/em57A3KaXs3x
        4x2pDrh0F2iqWA79fxhbm1ET1OgLGA7Ik2ImH84imJoUu2MBXNjI8AnrnumJxfyYlC0AKfbbUhF
        QOyBGoBo1XtpDrfXraDszrA==
X-Received: by 2002:a05:622a:1891:b0:2e0:6d8d:dad2 with SMTP id v17-20020a05622a189100b002e06d8ddad2mr5470396qtc.331.1646755104202;
        Tue, 08 Mar 2022 07:58:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLTyEZsfQQL7N2EzIvIAN3E6s3Vq4iR3WUMtJ4X8Go4dSoNluIbND4bov+C5+5ryOdw3DexA==
X-Received: by 2002:a05:622a:1891:b0:2e0:6d8d:dad2 with SMTP id v17-20020a05622a189100b002e06d8ddad2mr5470374qtc.331.1646755103914;
        Tue, 08 Mar 2022 07:58:23 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id e8-20020ac85dc8000000b002de409f360fsm10650882qtx.76.2022.03.08.07.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 07:58:23 -0800 (PST)
Message-ID: <4e82e2ac560baad2ab51d0b92ffb6fdfcadf48aa.camel@redhat.com>
Subject: Re: [PATCH v2 0/4] ceph: forward average read/write/metadata latency
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 08 Mar 2022 10:58:22 -0500
In-Reply-To: <20220308124219.771527-1-vshankar@redhat.com>
References: <20220308124219.771527-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-08 at 07:42 -0500, Venky Shankar wrote:
> v2
>   - rename to_ceph_timespec() to ktime_to_ceph_timespec()
>   - use ceph_encode_timespec64() helper
> 
> Jeff,
> 
> To apply these, please drop commit range f4bf256..840d9f0 from testing branch.
> 
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
> Venky Shankar (4):
>   ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
>   ceph: track average r/w/m latency
>   ceph: include average/stdev r/w/m latency in mds metrics
>   ceph: use tracked average r/w/m latencies to display metrics in
>     debugfs
> 
>  fs/ceph/debugfs.c |  5 ++--
>  fs/ceph/metric.c  | 63 +++++++++++++++++++++++++++--------------------
>  fs/ceph/metric.h  | 63 ++++++++++++++++++++++++++++++-----------------
>  3 files changed, 79 insertions(+), 52 deletions(-)
> 

Thanks Venky. New version is now merged into testing.
-- 
Jeff Layton <jlayton@redhat.com>

