Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E89F708D1C
	for <lists+ceph-devel@lfdr.de>; Fri, 19 May 2023 02:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjESAzl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 May 2023 20:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjESAzk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 May 2023 20:55:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0BAE7F
        for <ceph-devel@vger.kernel.org>; Thu, 18 May 2023 17:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684457669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f96iNuTi84eLWb3Z+iggP7f8ewPuNSvr3skMKi09rbM=;
        b=dM7+dEmNm/chc9uhtJg0mMLrOWO+G8TTmiDiDJam80+Vu2t43jzuedQyYsiJT9bZwUxUAm
        1Ep8rVuHMHFGjLlnAl6eBXCT+0N0v3pSm5pgj4XQt1EXGZzwojH1ZgUtdGoam+EiW+2AVk
        LjjSfjuZ3lhZwPPiWBp0rnIRjKpPYSE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-jMPsUKlIPTKU_s5CeyLruA-1; Thu, 18 May 2023 20:54:27 -0400
X-MC-Unique: jMPsUKlIPTKU_s5CeyLruA-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-25364005c22so803953a91.0
        for <ceph-devel@vger.kernel.org>; Thu, 18 May 2023 17:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457667; x=1687049667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f96iNuTi84eLWb3Z+iggP7f8ewPuNSvr3skMKi09rbM=;
        b=WsYWKO93FvsePtigQhqAyTYeFDOQ9ICiIbnVzOIHiOiN6cRIbc3z9Sv2jlII7mYsOz
         28G0l33iWTgM9iuKGwOSUMLDLM/Vy3B/suGBos8ccIcHTD9V+Gy3TEyOup3XcYjkWWEP
         IYHFGYmokgHISMyRGa3CFdSw1ng3LNJTTgZA8U5oCzOv+eACWvr4hg0VBvvtQPVSe7K5
         qdZ0pNjxzHlDmNhnLQmFIha4Yx5gRoSIC7xbDQR/pY8V960TxhPtCDivBVg4iORKRJmV
         t/7g60c7pUS8hDpuyWO3VrlpnwB9+zXQtPDFt0dwF05gmjb73sC0iBwxNh7QWj5V0hCv
         04dw==
X-Gm-Message-State: AC+VfDzEOXTcdtYueq7WXntlbEN/wdMUlpB/iYCkRMYrxfX2M3L0Zezt
        RiofXio00XJM90RneN2pu20Lu6kw59wPXt4za0EcrhqG1Wp35KFGS7oJA8UBj3p69Dj7Nu9nvF8
        AbhMITChJjgJz2hmM2CFiqA==
X-Received: by 2002:a17:90a:c294:b0:253:572f:79b1 with SMTP id f20-20020a17090ac29400b00253572f79b1mr432513pjt.28.1684457666784;
        Thu, 18 May 2023 17:54:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7UuNCd+sTzCpEeBOZhefKOD7eRn5MTOqSYdMvU+3BhbYiezoPDzpQDisW8qK4DGipblXUTSQ==
X-Received: by 2002:a17:90a:c294:b0:253:572f:79b1 with SMTP id f20-20020a17090ac29400b00253572f79b1mr432502pjt.28.1684457666487;
        Thu, 18 May 2023 17:54:26 -0700 (PDT)
Received: from [10.72.12.110] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090a280700b0024b9e62c1d9sm289559pjd.41.2023.05.18.17.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 17:54:26 -0700 (PDT)
Message-ID: <60e8e576-1097-c874-a7f6-ad79556950f7@redhat.com>
Date:   Wed, 17 May 2023 22:04:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
References: <20230517052404.99904-1-xiubli@redhat.com>
 <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com>
 <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <11105fba-dce6-d54e-a75d-2673e4b5f3cf@redhat.com>
 <CAOi1vP-xT56QYsne-n-fjSoDitEbeaEQNuxA_sKKbR=M+V7baA@mail.gmail.com>
 <5391b06a-2bb6-05f2-dd7c-c96f259ba443@redhat.com>
 <CAOi1vP8Gwk8AwZh6X2Kss1o=pCmuboG1pNYcYNQiKF+YLVTm_Q@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8Gwk8AwZh6X2Kss1o=pCmuboG1pNYcYNQiKF+YLVTm_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/23 21:56, Ilya Dryomov wrote:
> On Wed, May 17, 2023 at 3:33 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 5/17/23 21:11, Ilya Dryomov wrote:
>>> On Wed, May 17, 2023 at 2:46 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 5/17/23 19:29, Ilya Dryomov wrote:
>>>>> On Wed, May 17, 2023 at 1:04 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>> On 5/17/23 18:31, Ilya Dryomov wrote:
>>>>>>> On Wed, May 17, 2023 at 7:24 AM <xiubli@redhat.com> wrote:
>>>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>>>
>>>>>>>> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
>>>>>>>> request may still contain a list of 'split_realms', and we need
>>>>>>>> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
>>>>>>>>
>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>> Cc: Frank Schilder <frans@dtu.dk>
>>>>>>>> Reported-by: Frank Schilder <frans@dtu.dk>
>>>>>>>> URL: https://tracker.ceph.com/issues/61200
>>>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>>>> ---
>>>>>>>>      fs/ceph/snap.c | 3 +++
>>>>>>>>      1 file changed, 3 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>>>>> index 0e59e95a96d9..d95dfe16b624 100644
>>>>>>>> --- a/fs/ceph/snap.c
>>>>>>>> +++ b/fs/ceph/snap.c
>>>>>>>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>>>>>>>                                     continue;
>>>>>>>>                             adjust_snap_realm_parent(mdsc, child, realm->ino);
>>>>>>>>                     }
>>>>>>>> +       } else {
>>>>>>>> +               p += sizeof(u64) * num_split_inos;
>>>>>>>> +               p += sizeof(u64) * num_split_realms;
>>>>>>>>             }
>>>>>>>>
>>>>>>>>             /*
>>>>>>>> --
>>>>>>>> 2.40.1
>>>>>>>>
>>>>>>> Hi Xiubo,
>>>>>>>
>>>>>>> This code appears to be very old -- it goes back to the initial commit
>>>>>>> 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
>>>>>>> explanation for why this popped up only now?
>>>>>> As I remembered we hit this before in one cu BZ last year, but I
>>>>>> couldn't remember exactly which one.  But I am not sure whether @Jeff
>>>>>> saw this before I joint ceph team.
>>>>>>
>>>>>>
>>>>>>> Has MDS always been including split_inos and split_realms arrays in
>>>>>>> !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recent
>>>>>>> change, I'd argue that this needs to be addressed on the MDS side.
>>>>>> While in MDS side for the _UPDATE op it won't send the 'split_realm'
>>>>>> list just before the commit in 2017:
>>>>>>
>>>>>> commit 93e7267757508520dfc22cff1ab20558bd4a44d4
>>>>>> Author: Yan, Zheng <zyan@redhat.com>
>>>>>> Date:   Fri Jul 21 21:40:46 2017 +0800
>>>>>>
>>>>>>         mds: send snap related messages centrally during mds recovery
>>>>>>
>>>>>>         sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
>>>>>>         clients centrally in MDCache::open_snaprealms()
>>>>>>
>>>>>>         Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>>>>>>
>>>>>> Before this commit it will only send the 'split_realm' list for the
>>>>>> _SPLIT op.
>>>>> It sounds like we have the culprit.  This should be treated as
>>>>> a regression and fixed on the MDS side.  I don't see a justification
>>>>> for putting useless data on the wire.
>>>> But we still need this patch to make it to work with the old ceph releases.
>>> This is debatable:
>>>
>>> - given that no one noticed this for so long, the likelihood of MDS
>>>     sending a CEPH_SNAP_OP_UPDATE message with bogus split_inos and
>>>     split_realms arrays is very low
>>>
>>> - MDS side fix would be backported to supported Ceph releases
>>>
>>> - people who are running unsupported Ceph releases (i.e. aren't
>>>     updating) are unlikely to be diligently updating their kernel clients
>> Just searched the ceph tracker and I found another 3 trackers have the
>> same issue:
>>
>> https://tracker.ceph.com/issues/57817
>> https://tracker.ceph.com/issues/57703
>> https://tracker.ceph.com/issues/57686
>>
>> So plusing this time and the previous CU case:
>>
>> https://www.spinics.net/lists/ceph-users/msg77106.html
>>
>> I have seen at least 5 times.
>>
>> All this are reproduced when doing MDS failover, and this is the root
>> cause in MDS side.
> OK, given that the fixup in the kernel client is small, it seems
> justified.  But, please, add a comment in the new else branch saying
> that it's there only to work around a bug in the MDS.

> Thanks,
>
>                  Ilya
>

