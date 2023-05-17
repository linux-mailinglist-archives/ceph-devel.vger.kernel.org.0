Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17EB7069FC
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 15:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjEQNfA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 09:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbjEQNeu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 09:34:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75979033
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 06:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684330421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrGoKrrtcHzhXcko4pUQ70VqzVmgKR5M67k0Ep1qRLw=;
        b=b+lTLOW1W+Y8gc7WOZpCFVJKFPl0FKJyQe3i9hZ4zhe22UVAKMhiXZgMSjiTuMiGL/4azE
        Tj5LSu3HyncUvJnyqyMg+y4EWD1GQpxD5OYJjPeZnAOiB5tB4HxN/YI/crSJ7hWNrV0E8m
        MklxLjCdHbIvh0M3ZPfkmYM63JepQVI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-p7wcKD-PNtuHzvmKcvz-SQ-1; Wed, 17 May 2023 09:33:40 -0400
X-MC-Unique: p7wcKD-PNtuHzvmKcvz-SQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ae40139967so9761025ad.3
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 06:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684330419; x=1686922419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TrGoKrrtcHzhXcko4pUQ70VqzVmgKR5M67k0Ep1qRLw=;
        b=KepYj1KrF+5FhDc8eQ00HWBk32wpvdO6ijgfR2ibSxB3GhBu//rkiwTwe7TjJvM/ap
         8i5OMIpIhUbhDTmjrZbPjcP/nJ3LjICWsztxN59HDOQPgahKDQi6p5GC4a2040nb72H+
         1TmaoERJMKsHN6U1CdxdGUx+T7fX8OBHwJqTuShp2Bly0T0r97mxGlKPC8ANoWp8Aoa2
         LzikbJ31vEXNcHaOIkha5RS60YFBwvvqSeP74zl2Z9TNuUXBuE88YJ9T5zMp+X2xFGT5
         Yzb3iB7Sb9YQbBLyPUo8oVupEkSXR+0JsJiRXlPRFWoObkoTji6613he/zi9fzralIBT
         0VRg==
X-Gm-Message-State: AC+VfDyC+5w8A4fmJawQS70lA/IWjsAelz6WD3A4gx56IWCYRVeNy56u
        1Op9yuqY+ICJ5CMNj/D+sqM60JKU8JjRVVY5R34zhInpX1PCoIg/rNuGDc5f8sj5YH0FBTEkk4E
        /ndrO7M2sH8Byubnt8+sy3Q==
X-Received: by 2002:a17:902:e5c1:b0:1ab:1bb0:126d with SMTP id u1-20020a170902e5c100b001ab1bb0126dmr55928078plf.23.1684330418770;
        Wed, 17 May 2023 06:33:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4raW/uKS3w1mkj6Tmlg/64ohiKJW7/4XCt0AkbGQ4RT0OjHQd45jReS/cBcyPtQ7xQP2FRMg==
X-Received: by 2002:a17:902:e5c1:b0:1ab:1bb0:126d with SMTP id u1-20020a170902e5c100b001ab1bb0126dmr55928050plf.23.1684330418438;
        Wed, 17 May 2023 06:33:38 -0700 (PDT)
Received: from [10.72.12.110] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s3-20020a170902988300b001ac7c725c1asm15709020plp.6.2023.05.17.06.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 06:33:38 -0700 (PDT)
Message-ID: <5391b06a-2bb6-05f2-dd7c-c96f259ba443@redhat.com>
Date:   Wed, 17 May 2023 21:33:31 +0800
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
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-xT56QYsne-n-fjSoDitEbeaEQNuxA_sKKbR=M+V7baA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/23 21:11, Ilya Dryomov wrote:
> On Wed, May 17, 2023 at 2:46 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 5/17/23 19:29, Ilya Dryomov wrote:
>>> On Wed, May 17, 2023 at 1:04 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 5/17/23 18:31, Ilya Dryomov wrote:
>>>>> On Wed, May 17, 2023 at 7:24 AM <xiubli@redhat.com> wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
>>>>>> request may still contain a list of 'split_realms', and we need
>>>>>> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Cc: Frank Schilder <frans@dtu.dk>
>>>>>> Reported-by: Frank Schilder <frans@dtu.dk>
>>>>>> URL: https://tracker.ceph.com/issues/61200
>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>> ---
>>>>>>     fs/ceph/snap.c | 3 +++
>>>>>>     1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>>> index 0e59e95a96d9..d95dfe16b624 100644
>>>>>> --- a/fs/ceph/snap.c
>>>>>> +++ b/fs/ceph/snap.c
>>>>>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>>>>>                                    continue;
>>>>>>                            adjust_snap_realm_parent(mdsc, child, realm->ino);
>>>>>>                    }
>>>>>> +       } else {
>>>>>> +               p += sizeof(u64) * num_split_inos;
>>>>>> +               p += sizeof(u64) * num_split_realms;
>>>>>>            }
>>>>>>
>>>>>>            /*
>>>>>> --
>>>>>> 2.40.1
>>>>>>
>>>>> Hi Xiubo,
>>>>>
>>>>> This code appears to be very old -- it goes back to the initial commit
>>>>> 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
>>>>> explanation for why this popped up only now?
>>>> As I remembered we hit this before in one cu BZ last year, but I
>>>> couldn't remember exactly which one.  But I am not sure whether @Jeff
>>>> saw this before I joint ceph team.
>>>>
>>>>
>>>>> Has MDS always been including split_inos and split_realms arrays in
>>>>> !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recent
>>>>> change, I'd argue that this needs to be addressed on the MDS side.
>>>> While in MDS side for the _UPDATE op it won't send the 'split_realm'
>>>> list just before the commit in 2017:
>>>>
>>>> commit 93e7267757508520dfc22cff1ab20558bd4a44d4
>>>> Author: Yan, Zheng <zyan@redhat.com>
>>>> Date:   Fri Jul 21 21:40:46 2017 +0800
>>>>
>>>>        mds: send snap related messages centrally during mds recovery
>>>>
>>>>        sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
>>>>        clients centrally in MDCache::open_snaprealms()
>>>>
>>>>        Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>>>>
>>>> Before this commit it will only send the 'split_realm' list for the
>>>> _SPLIT op.
>>> It sounds like we have the culprit.  This should be treated as
>>> a regression and fixed on the MDS side.  I don't see a justification
>>> for putting useless data on the wire.
>> But we still need this patch to make it to work with the old ceph releases.
> This is debatable:
>
> - given that no one noticed this for so long, the likelihood of MDS
>    sending a CEPH_SNAP_OP_UPDATE message with bogus split_inos and
>    split_realms arrays is very low
>
> - MDS side fix would be backported to supported Ceph releases
>
> - people who are running unsupported Ceph releases (i.e. aren't
>    updating) are unlikely to be diligently updating their kernel clients

Just searched the ceph tracker and I found another 3 trackers have the 
same issue:

https://tracker.ceph.com/issues/57817
https://tracker.ceph.com/issues/57703
https://tracker.ceph.com/issues/57686

So plusing this time and the previous CU case:

https://www.spinics.net/lists/ceph-users/msg77106.html

I have seen at least 5 times.

All this are reproduced when doing MDS failover, and this is the root 
cause in MDS side.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

