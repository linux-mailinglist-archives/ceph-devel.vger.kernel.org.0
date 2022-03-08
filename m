Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219464D1874
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 13:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238441AbiCHM6P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 07:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiCHM6N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 07:58:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2B8B47563
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 04:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646744234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Q6vEx5WzCr/zAXFQhGnhmlRY+o2THj29T62ZLB50XI=;
        b=FcVSr0yAOdIMBgJL3FjhgR/xp2gd9TaVCuKobbrzkzz8/DhY9QYCXl5ZbcsDvKTZgqZnjL
        RuMNq0rxbeUY+UbUtH24nrRrQB8fC7o1kPFiVw6UvisDEimyyBBFfbFC11U5n7DpIMPLEg
        x60iZzGLvFFQHusLVXQdsQbqfVqfoik=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-mIZD8WMGPTaltoreiq8OiQ-1; Tue, 08 Mar 2022 07:57:13 -0500
X-MC-Unique: mIZD8WMGPTaltoreiq8OiQ-1
Received: by mail-pj1-f72.google.com with SMTP id j10-20020a17090a7e8a00b001bbef243093so1623146pjl.1
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 04:57:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2Q6vEx5WzCr/zAXFQhGnhmlRY+o2THj29T62ZLB50XI=;
        b=08+MqMyvJ37F3s9D5RUCWeRhMW927tZIidFdFQqHDRKRXnrpL9xl8SSc5EI0LAkbJB
         1N85NTdk4npIugmw+tIPTv2KIalgky6u85Nx3tkR8W6/BI2nCfK5RiYtToiWf+1t1STf
         DyFx3dfOCsOLeHU+oJWn7jtjeD08V8Gq2rOtPDSS0sWfGOaBijxdEwEGHPbA87+fKAlf
         7cNTqYgr0e9nrnUQdQBh/miDkD8A9Ku9Xcp08apNHCDmqQp5yYhOtIo7ZjA4xzaBrGVF
         VxInV4dDmjSZD2i7okAYwwjVULxsHrJT7V29w1YIa90ufJ2R3hskFuDIDICnS9/dSHZm
         Wh1w==
X-Gm-Message-State: AOAM530AhRHGnJce/Zyxt3tC3v7WKzu9WtJ/0e2YFa5vUBdtBQScx91b
        7gCoP/WomJbAz1FSuOlmkzJ5o5DEGTNy2Ob60md+ZtxJIWvOA/9sO4bA69zgpOg+aTjPZosLbxu
        SgjR6vbvFJyk6YBZ0YypdUhjflUioKZ6Av+oM5LnwN2C/YnyRfK1ii4P5v7VOuQw7AfisyYQ=
X-Received: by 2002:a05:6a00:3099:b0:4f6:d297:5f99 with SMTP id bh25-20020a056a00309900b004f6d2975f99mr18079657pfb.60.1646744232378;
        Tue, 08 Mar 2022 04:57:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy64ygdAiYTfCVCE61VbDavcdu5tsWNfoip++HQGz3jKwBd5EAsadaMzH4X1V3TN1BI0MT/CQ==
X-Received: by 2002:a05:6a00:3099:b0:4f6:d297:5f99 with SMTP id bh25-20020a056a00309900b004f6d2975f99mr18079637pfb.60.1646744232010;
        Tue, 08 Mar 2022 04:57:12 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l62-20020a633e41000000b0037fee1843dbsm10474475pga.25.2022.03.08.04.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 04:57:11 -0800 (PST)
Subject: Re: [PATCH v2 0/4] ceph: forward average read/write/metadata latency
To:     Venky Shankar <vshankar@redhat.com>, jlayton@redhat.com,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20220308124219.771527-1-vshankar@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4aa814b5-f651-8bde-456c-62003c074215@redhat.com>
Date:   Tue, 8 Mar 2022 20:57:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220308124219.771527-1-vshankar@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/8/22 8:42 PM, Venky Shankar wrote:
> v2
>    - rename to_ceph_timespec() to ktime_to_ceph_timespec()
>    - use ceph_encode_timespec64() helper
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
>            https://github.com/ceph/ceph/pull/41397
>
> Note that the cumulative latencies are still forwarded to the MDS but
> the tool (cephfs-top) ignores it altogether.
>
> Latency standard deviation is calculated in `cephfs-top` tool.
>
> Venky Shankar (4):
>    ceph: use ktime_to_timespec64() rather than jiffies_to_timespec64()
>    ceph: track average r/w/m latency
>    ceph: include average/stdev r/w/m latency in mds metrics
>    ceph: use tracked average r/w/m latencies to display metrics in
>      debugfs
>
>   fs/ceph/debugfs.c |  5 ++--
>   fs/ceph/metric.c  | 63 +++++++++++++++++++++++++++--------------------
>   fs/ceph/metric.h  | 63 ++++++++++++++++++++++++++++++-----------------
>   3 files changed, 79 insertions(+), 52 deletions(-)
>
The series LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


