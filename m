Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2544F544097
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 02:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiFIAb7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 20:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiFIAb6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 20:31:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68A3B1D31E
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 17:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654734714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7shL3OfuRlYzJSIX1xajDy50wF6riHGVqDo/zvA7DU=;
        b=PhbIn9spjt1FJsf14NMcs2YYUzTkcmmJzAU7iLpZ+e8oRsgmX71aSfc4pBTSHFOM8NPa6D
        Tb5yJzzO9MJsShq/791cZhM8vfdlR6oFEqTVUy6p90ko4dnNRWk6A/fKoY76/wVYg0cb1s
        Kk89av3d4oSAJvFadclc0My3PXcqfoM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-ZUWSPOjjMWKCgk898jY5Gw-1; Wed, 08 Jun 2022 20:31:53 -0400
X-MC-Unique: ZUWSPOjjMWKCgk898jY5Gw-1
Received: by mail-pj1-f69.google.com with SMTP id m5-20020a17090a4d8500b001e0cfe135c7so9572567pjh.3
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 17:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+7shL3OfuRlYzJSIX1xajDy50wF6riHGVqDo/zvA7DU=;
        b=BIvyfpJPBAW5nuzmQxk+uVTNVjZVwdoNPz3I/usx5om6mwD5O5ZXI6VU6QaZTjwFCQ
         CIwyVUafJlAfSI+FYeW3f1fAaOTxuIaXJWU7rjHtYwd9CEjyWKduy+iJLrtukYITmV/Y
         8wI/xw2yZM+zaD4TRE/pic5I/J9yMIS9932xgYkSGm5suP1EyUAsSOz8CQDh4pIztAX4
         P2+CN93uoEwdxd28rZN5erm36Cm6QbNDhtc9Wmq1PBE3bPVvhizElJftqN1/7ldRNDC4
         Jm9uK1UvnWFfmSGcv+WWIeDJvpalqZ0mcDC/oPpHsVH6pMHiyWLo/UrkwIlD5KgctkBb
         PrPg==
X-Gm-Message-State: AOAM5336TCxJo0yEzdLbdNa4HyeMdLXo2B7VWFNPBR56jfzh5HQorEHE
        EcLe7nxvtMn9Z1l1lLU1KkE1bb4XVuWVxyZqmGsS0esz5cp8U46w/AlkiAE0K/kPGG/WahmU8bW
        3YszYsxWmd/cAw9ziQZJJpOsy9q+OqPZ+0yArCchS2FJHGd7XpIY2ai5TQBWxuda2w1zR1KE=
X-Received: by 2002:a05:6a00:cd2:b0:51c:28b5:1573 with SMTP id b18-20020a056a000cd200b0051c28b51573mr15637971pfv.59.1654734711924;
        Wed, 08 Jun 2022 17:31:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgis1e3WmpZ4ijpSW9P7x3VpUL5WCVY/P6DLO6CqM49E63j9HYMDJEz6xOLwfjHdXLXeBiKw==
X-Received: by 2002:a05:6a00:cd2:b0:51c:28b5:1573 with SMTP id b18-20020a056a000cd200b0051c28b51573mr15637938pfv.59.1654734711561;
        Wed, 08 Jun 2022 17:31:51 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 85-20020a630558000000b003fb098151c9sm15509744pgf.64.2022.06.08.17.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 17:31:50 -0700 (PDT)
Subject: Re: [PATCH] ceph: wait on async create before checking caps for
 syncfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220606233142.150457-1-jlayton@kernel.org>
 <e0dac29b-f6e6-84bd-c548-06106e345554@redhat.com>
 <82bb2d6f8c890405a276e3ceffaa6550681f3b38.camel@kernel.org>
 <d51679b8-d523-ce95-d8fc-9a6d3cc78cc6@redhat.com>
 <ed45a5ddc10dd805506419306d1eb7a8120fe2ad.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2bf14228-62d0-0cf3-94f6-234bf984f7d6@redhat.com>
Date:   Thu, 9 Jun 2022 08:31:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ed45a5ddc10dd805506419306d1eb7a8120fe2ad.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/8/22 9:58 PM, Jeff Layton wrote:
> On Tue, 2022-06-07 at 09:50 +0800, Xiubo Li wrote:
>> On 6/7/22 9:21 AM, Jeff Layton wrote:
>>> On Tue, 2022-06-07 at 09:11 +0800, Xiubo Li wrote:
>>>> On 6/7/22 7:31 AM, Jeff Layton wrote:
>>>>> Currently, we'll call ceph_check_caps, but if we're still waiting on the
>>>>> reply, we'll end up spinning around on the same inode in
>>>>> flush_dirty_session_caps. Wait for the async create reply before
>>>>> flushing caps.
>>>>>
>>>>> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
>>>>> URL: https://tracker.ceph.com/issues/55823
>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>> ---
>>>>>     fs/ceph/caps.c | 1 +
>>>>>     1 file changed, 1 insertion(+)
>>>>>
>>>>> I don't know if this will fix the tx queue stalls completely, but I
>>>>> haven't seen one with this patch in place. I think it makes sense on its
>>>>> own, either way.
>>>>>
>>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>>> index 0a48bf829671..5ecfff4b37c9 100644
>>>>> --- a/fs/ceph/caps.c
>>>>> +++ b/fs/ceph/caps.c
>>>>> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>>>>>     		ihold(inode);
>>>>>     		dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
>>>>>     		spin_unlock(&mdsc->cap_dirty_lock);
>>>>> +		ceph_wait_on_async_create(inode);
>>>>>     		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>>>>>     		iput(inode);
>>>>>     		spin_lock(&mdsc->cap_dirty_lock);
>>>> This looks good.
>>>>
>>>> Possibly we can add one dedicated list to store the async creating
>>>> inodes instead of getting stuck all the others ?
>>>>
>>> I'd be open to that. I think we ought to take this patch first to fix
>>> the immediate bug though, before we add extra complexity.
>> Sounds good to me.
>>
>> I will merge it to the testing branch for now and let's improve it later.
>>
> Can we also mark this for stable? It's a pretty nasty bug, potentially.
> We should get this into mainline fairly soon.
Yeah, sure.
>
> Thanks,

