Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B2653F391
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 03:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbiFGBvL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 21:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiFGBvK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 21:51:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C04DD19CC
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 18:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654566666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C74sLn2dhSMVXeDRSNp9jgCM3/sAq7h7LCyRhYv0wF8=;
        b=C74xdhgnue8889QhNg7+YgaT2L+sOYd6unBRFB+eOWq504K2PS0RJFbL/3JAb7IcslIwbQ
        A+SF27Akh8Zb3p2Q7jiAMUW3b6GQ7C6q6fieLcjoUY+Bmae3IOiD1S58RuvUcQ8US0u/ns
        ZTJegUR5u2MZGQNcp3pMREaVGXqYmck=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490--C1uh5WfMD2iBvT-v2KqdQ-1; Mon, 06 Jun 2022 21:51:05 -0400
X-MC-Unique: -C1uh5WfMD2iBvT-v2KqdQ-1
Received: by mail-pj1-f70.google.com with SMTP id j23-20020a17090a061700b001e89529d397so874871pjj.6
        for <ceph-devel@vger.kernel.org>; Mon, 06 Jun 2022 18:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=C74sLn2dhSMVXeDRSNp9jgCM3/sAq7h7LCyRhYv0wF8=;
        b=zNsueDrwAHHnGwDGjFQWzVmCTjfRNJRo9s27jRGYg5ynbbbwrRSAmdkYFPdbQOxyvO
         vVh/h7g1HIz/eFa7TYD1TIRiR9Jr06S26QvEhTjnrm55bRPJjnv1IZu2He6PjXX+Ocjf
         RJr44lJrjKPfK1m+qlCx11niAcm1xPY/b8Awp2PSnAql/32plbKMbCTqKo4SZzkj9wWy
         awPEPFM4tH8+TG44Xfl55qtUqXNA9zvkOOAFFXQGVicJ7iimSSSIAFQZgQ7kwBQgUvkc
         EUA0M0xHTgAwS8R/4RTnFOmMXN+FcQYdFcgK2lPeDmFgnCMieZvTasQkkJiuwQA2pTKk
         /+/g==
X-Gm-Message-State: AOAM531lLmZFC57BlyfDG9dPFcX6W5Wq+KFfQQ6/uoSCaKMs9L5EWVue
        JK1Z+JAM7RLkeZLW1PJvB11WDxrWtcnBuRiG1zkA+V3LPq64x6m8ftM0boCAnbCdAbbwaHrz5hw
        gFvMRPxqh3p9mrM2UrMoHW4VLcFsnKnINCUgxZXHCGK1hDs3Xn/wDv6vBbdSgAR24h+OCfQk=
X-Received: by 2002:a17:90a:6fc2:b0:1e3:2c21:c29f with SMTP id e60-20020a17090a6fc200b001e32c21c29fmr42201350pjk.191.1654566664200;
        Mon, 06 Jun 2022 18:51:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPAao/Cc6H/zQv5QXIsGcmPJXxaX4MUO7o3+mkNO0cdl1ilWchTNG/izHvPYmtDQL5HUF6CQ==
X-Received: by 2002:a17:90a:6fc2:b0:1e3:2c21:c29f with SMTP id e60-20020a17090a6fc200b001e32c21c29fmr42201324pjk.191.1654566663826;
        Mon, 06 Jun 2022 18:51:03 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z12-20020a17090a8b8c00b001df666ebddesm13248979pjn.6.2022.06.06.18.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 18:51:03 -0700 (PDT)
Subject: Re: [PATCH] ceph: wait on async create before checking caps for
 syncfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220606233142.150457-1-jlayton@kernel.org>
 <e0dac29b-f6e6-84bd-c548-06106e345554@redhat.com>
 <82bb2d6f8c890405a276e3ceffaa6550681f3b38.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d51679b8-d523-ce95-d8fc-9a6d3cc78cc6@redhat.com>
Date:   Tue, 7 Jun 2022 09:50:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <82bb2d6f8c890405a276e3ceffaa6550681f3b38.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/7/22 9:21 AM, Jeff Layton wrote:
> On Tue, 2022-06-07 at 09:11 +0800, Xiubo Li wrote:
>> On 6/7/22 7:31 AM, Jeff Layton wrote:
>>> Currently, we'll call ceph_check_caps, but if we're still waiting on the
>>> reply, we'll end up spinning around on the same inode in
>>> flush_dirty_session_caps. Wait for the async create reply before
>>> flushing caps.
>>>
>>> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
>>> URL: https://tracker.ceph.com/issues/55823
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/ceph/caps.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> I don't know if this will fix the tx queue stalls completely, but I
>>> haven't seen one with this patch in place. I think it makes sense on its
>>> own, either way.
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index 0a48bf829671..5ecfff4b37c9 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>>>    		ihold(inode);
>>>    		dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
>>>    		spin_unlock(&mdsc->cap_dirty_lock);
>>> +		ceph_wait_on_async_create(inode);
>>>    		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>>>    		iput(inode);
>>>    		spin_lock(&mdsc->cap_dirty_lock);
>> This looks good.
>>
>> Possibly we can add one dedicated list to store the async creating
>> inodes instead of getting stuck all the others ?
>>
> I'd be open to that. I think we ought to take this patch first to fix
> the immediate bug though, before we add extra complexity.

Sounds good to me.

I will merge it to the testing branch for now and let's improve it later.

Thanks

-- Xiubo

