Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED848707706
	for <lists+ceph-devel@lfdr.de>; Thu, 18 May 2023 02:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjERAl0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 20:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjERAlY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 20:41:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DF1273D
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 17:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684370439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8CQgAddijEboW55aTzGRGRrUOmsB/Qp33EUTtzod16I=;
        b=fQWLiE0YYLAxfHtFNEEW7q8PLKdP5UafphbAY/BOx6HmbLLv9mO/1fWI+yDHoHa1ZM318B
        ujuLTZk1V8RVa6v+yKy/2Qc7eDxHLjzqPoqVh3tKDc+/e5LRqUjTznwMKxrf5eRzWFWtnC
        DgFG6ox9ufwQD0g7dLt0K4wfiaU9WkA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-wwC1lTslPla26M1pZcSl6Q-1; Wed, 17 May 2023 20:40:38 -0400
X-MC-Unique: wwC1lTslPla26M1pZcSl6Q-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-64d1d05a749so37456b3a.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 17:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684370437; x=1686962437;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8CQgAddijEboW55aTzGRGRrUOmsB/Qp33EUTtzod16I=;
        b=l92+AUVicGrMt8O6DaB1hkVPtqW5DUcCIzeS6Ah86iDKIaxtZyKaBdvxNdP2cfyP0E
         q8gudGoda7NvT7t1A66Q2p44U0B4MKEgkPdU+dCXWbo3GrU1DVJrsvLWmjzjYgENa7LI
         bcKNHcuLRPs6Q/1jG1Ukck/DM3P1LmJ8quEWVl+pIf0zrWDlzzTd+cI1ELt6w9xOuKGe
         K6DNMwdlUTGN30c8XpFO/14jWrbGVmVrWv6ggJammpewvxQSDTNcXsmh+roRKLEoCzHQ
         Q8AfhejCofrLGBFp1h+qeB7s4EDh8al6My/xVsnWSNaxveS7RdzwCqMP+U0xECMxdHQo
         cHpw==
X-Gm-Message-State: AC+VfDy6Nc8mY5sPxU0eyQjoydo6Ut+v6F+WGwzEtSz5wPREK9cdbqQl
        RZJtfew+/OJdMY4s0tFzgzDspPzaXGZEQJFrVlJ3MN0O67No4i39fY3wiMWmCdsKAvxy3rped3f
        hmsl7m/m9lnepCf7jeyUtmA==
X-Received: by 2002:a05:6a00:8c5:b0:64d:1185:2421 with SMTP id s5-20020a056a0008c500b0064d11852421mr1250632pfu.17.1684370437489;
        Wed, 17 May 2023 17:40:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ69ImueGRt3r7aK7SfoAMFHSghSCVn+aZ4EwpaEtUJN5unUP/2RBTQkqXV3Y+iagM4DYmNVSw==
X-Received: by 2002:a05:6a00:8c5:b0:64d:1185:2421 with SMTP id s5-20020a056a0008c500b0064d11852421mr1250611pfu.17.1684370437140;
        Wed, 17 May 2023 17:40:37 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j16-20020a62b610000000b00627fafe49f9sm116989pff.106.2023.05.17.17.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 17:40:36 -0700 (PDT)
Message-ID: <31895de0-5421-3ea2-e04d-316617c5e86f@redhat.com>
Date:   Thu, 18 May 2023 08:40:31 +0800
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
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Sure. Will update it in next version.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>

