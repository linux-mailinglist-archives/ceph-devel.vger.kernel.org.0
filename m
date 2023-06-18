Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E9B734937
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Jun 2023 01:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjFRXIo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 18 Jun 2023 19:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjFRXIn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 18 Jun 2023 19:08:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD08121
        for <ceph-devel@vger.kernel.org>; Sun, 18 Jun 2023 16:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687129675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2EkauvTfpm3+c/4KjTxzG70d29Eikoe7e7wc++cyCVU=;
        b=dnWpmhxfAkbsxmb1bcIfXCAJhbbVAJ2Ll/aXtxze1hNzDsaeKHNbKf5KPowzoSul0vKSW9
        LqADCm27UgloretfFgLLq1Rxqy8AMVxLbOrjNbIc7I6RTtIu17xDAGJPr3zVVI1/W+jqVl
        KWtG8Qo+tR1zaxDfsarCRwFw97KFiXE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-3rCIC30vPYm6UDk7zSnRVw-1; Sun, 18 Jun 2023 19:07:54 -0400
X-MC-Unique: 3rCIC30vPYm6UDk7zSnRVw-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b52fd9bf64so14093415ad.1
        for <ceph-devel@vger.kernel.org>; Sun, 18 Jun 2023 16:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687129673; x=1689721673;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2EkauvTfpm3+c/4KjTxzG70d29Eikoe7e7wc++cyCVU=;
        b=bk5OtA8wdjdo0nFx2zPHoksYXKb2wwL/Rkb/URhq7Rwkmim3b3Dq4mLnDPCdSXdn0b
         WjDcZSWALQvFqc9jJcyMT1DtYUeiqSwKLGOfxp+l8zVTRmzTe6MJL6iIEnEYgtF+yAko
         9R0spv6LXmybQkruokqM5hme2GQt8J5V/eoIld+nHsgA1e/weft94jVHztqyFXLwBMqR
         MTTUa8A5AQDdESuKzpjJxQZo5pF03/nRVhJUhU8BccBQHAnNRsLtqn8y6GJGChlBtFQk
         UDhOOUlFwjSY5XIWXkei0XfNImudtDOLh4vibZqlH8l5ON4EF+EcbVQs1SsnZlkbopG8
         BdNg==
X-Gm-Message-State: AC+VfDyoDub8uYYYkZaBAS+5htoIWh9flJBmbmJgzM/7303y/goWUAXM
        TAXF8T677iHfLlaoM5A9/ZRMhHl7nfWh4XKFpAJrELyanWq6mjjLmUeLuTnxfYAFOpE8egiRz1e
        VPbS/jYpSUT610X3KrRGfQQ==
X-Received: by 2002:a17:902:da89:b0:1b5:1b0f:521b with SMTP id j9-20020a170902da8900b001b51b0f521bmr12985403plx.6.1687129673342;
        Sun, 18 Jun 2023 16:07:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5UlkBPlsHtNd8N5CBsvRoHZI7+TeXBsqqCE15kWrbR2N/YCtgfk1VjaVCdZxfpl9bDu1uK0g==
X-Received: by 2002:a17:902:da89:b0:1b5:1b0f:521b with SMTP id j9-20020a170902da8900b001b51b0f521bmr12985387plx.6.1687129672929;
        Sun, 18 Jun 2023 16:07:52 -0700 (PDT)
Received: from [10.72.12.38] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bi2-20020a170902bf0200b001ac7f583f72sm19117167plb.209.2023.06.18.16.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jun 2023 16:07:52 -0700 (PDT)
Message-ID: <534750e0-d4d5-4e2f-2d5a-25cfc908e5b0@redhat.com>
Date:   Mon, 19 Jun 2023 07:07:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] ceph: only send metrics when the MDS rank is ready
To:     Venky Shankar <vshankar@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
References: <20230606005732.1056361-1-xiubli@redhat.com>
 <CACPzV1miqfsoAHbjqnw=1wo5CKEcQR0G-J1Zi0ia2Ara=3x-ZA@mail.gmail.com>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1miqfsoAHbjqnw=1wo5CKEcQR0G-J1Zi0ia2Ara=3x-ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/16/23 12:40, Venky Shankar wrote:
> Hi Xiubo,
>
> On Tue, Jun 6, 2023 at 6:30 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When the MDS rank is in clientreplay state, the metrics requests
>> will be discarded directly. Also, when there are a lot of known
>> client requests to recover from, the metrics requests will slow
>> down the MDS rank from getting to the active state sooner.
>>
>> With this patch, we will send the metrics requests only when the
>> MDS rank is in active state.
> Although the changes look fine. I have a question though - the metrics
> are sent by the client each second (on tick()) - how many clients were
> connected for the MDS to experience further slowness due to metric
> update messages?

As I remembered there were 1761 clients. The MDS will just queue the 
metric messages and then trigger to print one debug log message , which 
could slow down the MDS, to buffer and file(?) for each when handling them.

Thanks

- Xiubo

>
>> URL: https://tracker.ceph.com/issues/61524
>> Reviewed-by: Milind Changire <mchangir@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - rephrase the commit comment from Milind's comments.
>>
>>
>>   fs/ceph/metric.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index c47347d2e84e..cce78d769f55 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -36,6 +36,14 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>>          s32 items = 0;
>>          s32 len;
>>
>> +       /* Do not send the metrics until the MDS rank is ready */
>> +       mutex_lock(&mdsc->mutex);
>> +       if (ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) != CEPH_MDS_STATE_ACTIVE) {
>> +               mutex_unlock(&mdsc->mutex);
>> +               return false;
>> +       }
>> +       mutex_unlock(&mdsc->mutex);
>> +
>>          len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
>>                + sizeof(*meta) + sizeof(*dlease) + sizeof(*files)
>>                + sizeof(*icaps) + sizeof(*inodes) + sizeof(*rsize)
>> --
>> 2.40.1
>>
>

