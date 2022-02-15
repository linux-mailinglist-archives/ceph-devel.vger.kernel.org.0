Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5024B6A6E
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 12:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiBOLND (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 06:13:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbiBOLND (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 06:13:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97688108180
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 03:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644923572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0b1HvMe4Eji7JG9P+4D2kmyYyWkwZrRHL8vikKM+mk=;
        b=CdAqdGKbVjTnk+iP0fyLlp4fGBJ6aIiU9y/iGL41RR0s7zUY1DxuGj3RcwcQXf5dHk6fVB
        yYQ+mRS4ASaMDFOR8f/016wjaRqPW/QV8WcmQZQbX3QeP5ZoTAFS6s9eUc+I0LDvfJRwvj
        NWMihAQLjZvcYyKTXOiK48d6uZui6go=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-8eHr3finMmuv3tqStnwusw-1; Tue, 15 Feb 2022 06:12:51 -0500
X-MC-Unique: 8eHr3finMmuv3tqStnwusw-1
Received: by mail-pl1-f197.google.com with SMTP id j1-20020a170903028100b0014b1f9e0068so8084931plr.8
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 03:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=b0b1HvMe4Eji7JG9P+4D2kmyYyWkwZrRHL8vikKM+mk=;
        b=jc+1Y509qq6GuZ3ghcY8HxXOMZOM0gAJH2GFA67S/hrA2MgK3qfS3xprz6XFpWE35f
         XALAV1bH29lDcs5zFeSRU5Xa7R/zURady5Al0iNOThibi5++OuOppaOojKy5ueptTfSt
         yZtart8wAvCPRfgQyAmf/6qwu1J9CEoegWBrmCLu5hHG6JT6z/+FZ34bK6xW+5C9sZt7
         CTZT3IibUjl07NtFzGgUCbh0J1eoT1aVXrE5UoYZ7myUqund1xT4hR0KlF53YxDDPovd
         PsLPLUbUpln7EZJDuZlz9bcT/1guj3NmT/npOZSoI1P1qshIKoJGQY/gF4WtFzOHTh+U
         0vBQ==
X-Gm-Message-State: AOAM531oV4NIYU3aoV42AB9NVOvr/u63g55d01IiLFxK+kfTGU8aPQy3
        Rd3bTyNFQNNwSg2Z0ajkB+M1+mPNG9tqS20OXJ+BnN5QTX2NdxQy1vrdkLF4czf57qdSaqPkWQT
        0Mvb3VFX95ERg63DvrkKmLN6rJTWDuubV50PYqLEYIylWkFVwqIHvnmTCW7fjvOTZw46qrtA=
X-Received: by 2002:a17:90b:4b01:: with SMTP id lx1mr3760137pjb.206.1644923570108;
        Tue, 15 Feb 2022 03:12:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyITokmkgx0cGyO06Esnk2+HROOOrxA/6sKZ5QbIl9RSKgv0sZL1ymUoHPsWBmCmZi81hDwcg==
X-Received: by 2002:a17:90b:4b01:: with SMTP id lx1mr3760108pjb.206.1644923569794;
        Tue, 15 Feb 2022 03:12:49 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d20sm40106679pfv.74.2022.02.15.03.12.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 03:12:49 -0800 (PST)
Subject: Re: [PATCH 0/3] ceph: forward average read/write/metadata latency
To:     Venky Shankar <vshankar@redhat.com>, jlayton@redhat.com
Cc:     ceph-devel@vger.kernel.org
References: <20220215091657.104079-1-vshankar@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b2ee2c71-bff8-44bc-2e22-6a1c58a70f33@redhat.com>
Date:   Tue, 15 Feb 2022 19:12:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220215091657.104079-1-vshankar@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/15/22 5:16 PM, Venky Shankar wrote:
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
> Venky Shankar (3):
>    ceph: track average r/w/m latency
>    ceph: include average/stdev r/w/m latency in mds metrics
>    ceph: use tracked average r/w/m latencies to display metrics in
>      debugfs
>
>   fs/ceph/debugfs.c |  2 +-
>   fs/ceph/metric.c  | 44 +++++++++++++++++++++++----------------
>   fs/ceph/metric.h  | 52 +++++++++++++++++++++++++++++++++--------------
>   3 files changed, 65 insertions(+), 33 deletions(-)
>
This series looks good to me.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


