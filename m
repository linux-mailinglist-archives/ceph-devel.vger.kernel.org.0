Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A82370697A
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 15:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjEQNQn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 09:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjEQNQW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 09:16:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B087AB8
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 06:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684329258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GSxqaBHAim774qvW88UHZhDlySvLeQ1vkfkWK/gZres=;
        b=ZUUX2DcezO+xmvb/kpnK0Y4qWDjZicK33zaW7SdGROhsOuf3tD0kjPFQ8eQ1qkgBpxoMCm
        /5rXDE/ONwpQrFoXakKLMn1b3TKTQ1Tkzv+Fyrfx7jM/nPcOEAhqirkZHidh1Bb+5/FwQw
        FmpeflIvbzvoscheot3vN+mrkpRU9Zo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-C0H3UTmaNyGg8YVY_aMWQw-1; Wed, 17 May 2023 09:14:17 -0400
X-MC-Unique: C0H3UTmaNyGg8YVY_aMWQw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1aaeaa1ad2dso5666825ad.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 06:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684329256; x=1686921256;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GSxqaBHAim774qvW88UHZhDlySvLeQ1vkfkWK/gZres=;
        b=Y0/BQePd5j36m/HbsrdEv+K84ZrSe6CeRkLIlIHYeka22B/nYUeNg9hvhv2c3C5DuX
         NwV/79JaDA9mWw6iXpL/K8Xorsw6MRZD09Juhh91xkIi4xD2+jBf4vQ757iaAoh0jBeU
         I267XHGs/pEX7ySKsg6zH6+9LJ7OiUNDAdZ0lnSnWjQW35eUbvg1sVujoCxQOwpoT8Yp
         bV46MVXxCWSHnHbdeldTREfeMKPKq8gQLkg+K9Or4GN2kukCyW1NefxCQsmn14BjjXHU
         2f47GDLEkpi7Q4ju/rBIA2scVtBV+wsx06cTto4+/BPqTOJSv2Rjq7CuM5YcOuBkHuG9
         Cqpw==
X-Gm-Message-State: AC+VfDwxXJDIVLsrnRaNIZrmdbbWjgdcdYprvpqAywhWaPYNYq1Mjwxn
        LZhCFh3lUlPFlBKU3oqrrSmBN5p2e1iAnm6r4e7CbpZehZNhzzJW2bc3D+YlrEyzJqqge3G3byp
        ujPCpB5GUX9teRKjMltSK352t29gnSoEn
X-Received: by 2002:a17:902:d2c9:b0:1ac:61ad:d6bd with SMTP id n9-20020a170902d2c900b001ac61add6bdmr44341184plc.65.1684329256319;
        Wed, 17 May 2023 06:14:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5qooaQuzMUOsBF1LOow6IY7y3KvUMDNJLDQfiWmHRV0palhjSPDmbi8kkYW89FubZBPcGobw==
X-Received: by 2002:a17:902:d2c9:b0:1ac:61ad:d6bd with SMTP id n9-20020a170902d2c900b001ac61add6bdmr44341162plc.65.1684329255979;
        Wed, 17 May 2023 06:14:15 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902e89100b001a5fccab02dsm17583018plg.177.2023.05.17.06.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 06:14:15 -0700 (PDT)
Message-ID: <790a1935-1af8-94ea-0a7a-69a1e91641b2@redhat.com>
Date:   Wed, 17 May 2023 21:14:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
Content-Language: en-US
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
References: <20230517052404.99904-1-xiubli@redhat.com>
 <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com>
 <d6ae6f9e-07f5-0120-2cc6-b5f3f2ddca5f@redhat.com>
 <CACPzV1=BUwKBBbThawt-PnJRoKnvwCNAd9AGPSH2mHVW_6zSZw@mail.gmail.com>
 <CACPzV1=q4C6pJ7L7jdPRuM=AQic93Muv=3rpZ_-y=cJ4ouYcww@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1=q4C6pJ7L7jdPRuM=AQic93Muv=3rpZ_-y=cJ4ouYcww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/23 20:53, Venky Shankar wrote:
> On Wed, May 17, 2023 at 6:18 PM Venky Shankar <vshankar@redhat.com> wrote:
>> Hey Xiubo,
>>
>> On Wed, May 17, 2023 at 4:45 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>
>>> On 5/17/23 19:04, Xiubo Li wrote:
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
>>>>>>    fs/ceph/snap.c | 3 +++
>>>>>>    1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>>> index 0e59e95a96d9..d95dfe16b624 100644
>>>>>> --- a/fs/ceph/snap.c
>>>>>> +++ b/fs/ceph/snap.c
>>>>>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client
>>>>>> *mdsc,
>>>>>>                                   continue;
>>>>>>                           adjust_snap_realm_parent(mdsc, child,
>>>>>> realm->ino);
>>>>>>                   }
>>>>>> +       } else {
>>>>>> +               p += sizeof(u64) * num_split_inos;
>>>>>> +               p += sizeof(u64) * num_split_realms;
>>>>>>           }
>>>>>>
>>>>>>           /*
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
>>> @Venky,
>>>
>>> Do you remember which one ? As I remembered this is why we fixed the
>>> snaptrace issue by blocking all the IOs and at the same time
>>> blocklisting the kclient before.
>>>
>>> Before the kcleint won't dump the corrupted msg and we don't know what
>>> was wrong with the msg and also we added code to dump the msg in the
>>> above fix.
>> The "corrupted" snaptrace issue happened just after the mds asserted
>> hitting the metadata corruption (dentry first corrupted) and it
>> _seemed_ that this corruption somehow triggered a corrupted snaptrace
>> to be sent to the client.
> [sent message a bit early - cotd...]
>
> But I think you found the issue - the message dump did help and its
> not related to the dentry first corruption.

Yeah, this one is not related to dentry first corruption.

@Ilya

I have created one ceph PR to fix it in MDS side 
https://tracker.ceph.com/issues/61217 and 
https://github.com/ceph/ceph/pull/51536.

Let's keep this kclient patch to make to be compatible with the old 
cephs. At least users could only update the kclient node to fix this issue.

Thanks

- Xiubo


>>> Thanks
>>>
>>> - Xiubo
>>>
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
>>>>      mds: send snap related messages centrally during mds recovery
>>>>
>>>>      sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
>>>>      clients centrally in MDCache::open_snaprealms()
>>>>
>>>>      Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>>>>
>>>> Before this commit it will only send the 'split_realm' list for the
>>>> _SPLIT op.
>>>>
>>>>
>>>> The following the snaptrace:
>>>>
>>>> [Wed May 10 16:03:06 2023] header: 00000000: 05 00 00 00 00 00 00 00
>>>> 00 00 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023] header: 00000010: 12 03 7f 00 01 00 00 01
>>>> 00 00 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023] header: 00000020: 00 00 00 00 02 01 00 00
>>>> 00 00 00 00 00 01 00 00  ................
>>>> [Wed May 10 16:03:06 2023] header: 00000030: 00 98 0d 60
>>>> 93                                   ...`.
>>>> [Wed May 10 16:03:06 2023]  front: 00000000: 00 00 00 00 00 00 00 00
>>>> 00 00 00 00 00 00 00 00  ................ <<== The op is 0, which is
>>>> 'CEPH_SNAP_OP_UPDATE'
>>>> [Wed May 10 16:03:06 2023]  front: 00000010: 0c 00 00 00 88 00 00 00
>>>> d1 c0 71 38 00 01 00 00  ..........q8....           <<== The '0c' is
>>>> the split_realm number
>>>> [Wed May 10 16:03:06 2023]  front: 00000020: 22 c8 71 38 00 01 00 00
>>>> d7 c7 71 38 00 01 00 00  ".q8......q8....       <<== All the 'q8' are
>>>> the ino#
>>>> [Wed May 10 16:03:06 2023]  front: 00000030: d9 c7 71 38 00 01 00 00
>>>> d4 c7 71 38 00 01 00 00  ..q8......q8....
>>>> [Wed May 10 16:03:06 2023]  front: 00000040: f1 c0 71 38 00 01 00 00
>>>> d4 c0 71 38 00 01 00 00  ..q8......q8....
>>>> [Wed May 10 16:03:06 2023]  front: 00000050: 20 c8 71 38 00 01 00 00
>>>> 1d c8 71 38 00 01 00 00   .q8......q8....
>>>> [Wed May 10 16:03:06 2023]  front: 00000060: ec c0 71 38 00 01 00 00
>>>> d6 c0 71 38 00 01 00 00  ..q8......q8....
>>>> [Wed May 10 16:03:06 2023]  front: 00000070: ef c0 71 38 00 01 00 00
>>>> 6a 11 2d 1a 00 01 00 00  ..q8....j.-.....
>>>> [Wed May 10 16:03:06 2023]  front: 00000080: 01 00 00 00 00 00 00 00
>>>> 01 00 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023]  front: 00000090: ee 01 00 00 00 00 00 00
>>>> 01 00 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023]  front: 000000a0: 00 00 00 00 00 00 00 00
>>>> 01 00 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023]  front: 000000b0: 01 09 00 00 00 00 00 00
>>>> 00 00 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023]  front: 000000c0: 01 00 00 00 00 00 00 00
>>>> 02 09 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023]  front: 000000d0: 05 00 00 00 00 00 00 00
>>>> 01 09 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023]  front: 000000e0: ff 08 00 00 00 00 00 00
>>>> fd 08 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023]  front: 000000f0: fb 08 00 00 00 00 00 00
>>>> f9 08 00 00 00 00 00 00  ................
>>>> [Wed May 10 16:03:06 2023] footer: 00000000: ca 39 06 07 00 00 00 00
>>>> 00 00 00 00 42 06 63 61  .9..........B.ca
>>>> [Wed May 10 16:03:06 2023] footer: 00000010: 7b 4b 5d 2d
>>>> 05                                   {K]-.
>>>>
>>>>
>>>> And if the split_realm number equals to sizeof(ceph_mds_snap_realm) +
>>>> extra snap buffer size by coincidence, the above 'corrupted' snaptrace
>>>> will be parsed by kclient too and kclient won't give any warning, but
>>>> it will corrupted the snaprealm and capsnap info in kclient.
>>>>
>>>>
>>>> Thanks
>>>>
>>>> - Xiubo
>>>>
>>>>
>>>>> Thanks,
>>>>>
>>>>>                   Ilya
>>>>>
>>
>> --
>> Cheers,
>> Venky
>
>

