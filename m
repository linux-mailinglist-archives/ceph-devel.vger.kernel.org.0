Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5973A70688A
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 14:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjEQMrY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 08:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjEQMrW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 08:47:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09B2139
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 05:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684327600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KckHsHbbIqY9D2V0VjZuUY9vlyvn+kdMKmXwPtNmkGo=;
        b=NBC5d3SB9INniMxaIVtBbbnOBU0UmkNmyiwtjJGHjQAC3sATZyE/cAEc8kQCRYZLScj7D5
        rBDD8hupis3AcIMv8E5wMPFWeyzwfz9FzeWlDhiCCBnJ+FJwlYiy+r+E6sfgnc4XtF5OZn
        CRXE0Ko4PvMjsKTHpOeFbDughPyz0Pc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-SLqI589wMjW5ESAC-baA5g-1; Wed, 17 May 2023 08:46:39 -0400
X-MC-Unique: SLqI589wMjW5ESAC-baA5g-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1ae5c32b7feso1421035ad.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 05:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684327598; x=1686919598;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KckHsHbbIqY9D2V0VjZuUY9vlyvn+kdMKmXwPtNmkGo=;
        b=CoKqD8HD5tL/H/FIKZOG92gE4NkNF1HQtYitVksaA2iNqdQxXDmq1JcM6DcErixS/y
         nlAdGGvRWeRXHW3IvBdvIbZ3QfW1LQe01tQcX9TjeeKHrsGphLibjJe4IU71Uta3Ltl3
         +LLoeZpihYQgNkfYX8PsOJ18Fz8t/YfsDuIlzb/T7s2Rt9WuT3z6LGZIXWz3QW9GeqF9
         gvMzkR6R2hx3+zIH20fruBzVNtUBi4z35a/bH1zExAPQeRfLAeqCxPTy2IKV32hOa9b0
         tJK5E0f6VAm4x/nXs+KXtvYcW9Mk8Wg+iEGgSrIXh2u6xyR58tF1Pk1gPUNcroWaAnSl
         3sYQ==
X-Gm-Message-State: AC+VfDyYWOYa/J0yJa5wqMIpR6Z3WGggY9ws+iIvseq38WcPlbRHxCFr
        Qx/rh9KYeqvZICNtRIxSTY2s0quLNc0uxl+9EQX0zcbVecsnF4k8seedTk5K/L9yMxec9HndyNU
        8kdTncLls2MXPMoHt/1CxSQ==
X-Received: by 2002:a17:903:1247:b0:1ab:afd:903a with SMTP id u7-20020a170903124700b001ab0afd903amr53431564plh.24.1684327598648;
        Wed, 17 May 2023 05:46:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ47zbf1rx2006LueCqXrEuENlLsdjrwa4GrAVrtmrwe6GPQtRN5ni9NlH8XJucZ73i7W4j+Bw==
X-Received: by 2002:a17:903:1247:b0:1ab:afd:903a with SMTP id u7-20020a170903124700b001ab0afd903amr53431541plh.24.1684327598300;
        Wed, 17 May 2023 05:46:38 -0700 (PDT)
Received: from [10.72.12.110] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090276c900b001aaeaa27dd5sm17372074plt.252.2023.05.17.05.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 05:46:37 -0700 (PDT)
Message-ID: <11105fba-dce6-d54e-a75d-2673e4b5f3cf@redhat.com>
Date:   Wed, 17 May 2023 20:46:30 +0800
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
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/23 19:29, Ilya Dryomov wrote:
> On Wed, May 17, 2023 at 1:04 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 5/17/23 18:31, Ilya Dryomov wrote:
>>> On Wed, May 17, 2023 at 7:24 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
>>>> request may still contain a list of 'split_realms', and we need
>>>> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Cc: Frank Schilder <frans@dtu.dk>
>>>> Reported-by: Frank Schilder <frans@dtu.dk>
>>>> URL: https://tracker.ceph.com/issues/61200
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/snap.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>> index 0e59e95a96d9..d95dfe16b624 100644
>>>> --- a/fs/ceph/snap.c
>>>> +++ b/fs/ceph/snap.c
>>>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>>>                                   continue;
>>>>                           adjust_snap_realm_parent(mdsc, child, realm->ino);
>>>>                   }
>>>> +       } else {
>>>> +               p += sizeof(u64) * num_split_inos;
>>>> +               p += sizeof(u64) * num_split_realms;
>>>>           }
>>>>
>>>>           /*
>>>> --
>>>> 2.40.1
>>>>
>>> Hi Xiubo,
>>>
>>> This code appears to be very old -- it goes back to the initial commit
>>> 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
>>> explanation for why this popped up only now?
>> As I remembered we hit this before in one cu BZ last year, but I
>> couldn't remember exactly which one.  But I am not sure whether @Jeff
>> saw this before I joint ceph team.
>>
>>
>>> Has MDS always been including split_inos and split_realms arrays in
>>> !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recent
>>> change, I'd argue that this needs to be addressed on the MDS side.
>> While in MDS side for the _UPDATE op it won't send the 'split_realm'
>> list just before the commit in 2017:
>>
>> commit 93e7267757508520dfc22cff1ab20558bd4a44d4
>> Author: Yan, Zheng <zyan@redhat.com>
>> Date:   Fri Jul 21 21:40:46 2017 +0800
>>
>>       mds: send snap related messages centrally during mds recovery
>>
>>       sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
>>       clients centrally in MDCache::open_snaprealms()
>>
>>       Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>>
>> Before this commit it will only send the 'split_realm' list for the
>> _SPLIT op.
> It sounds like we have the culprit.  This should be treated as
> a regression and fixed on the MDS side.  I don't see a justification
> for putting useless data on the wire.

But we still need this patch to make it to work with the old ceph releases.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

