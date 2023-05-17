Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477017069C1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjEQNY1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 09:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjEQNYC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 09:24:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1145A1FC2
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 06:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684329797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R84mdR5Ybe8j5TDFyLE8jRpFf5CWTx9pF4UrNhUID5w=;
        b=Oly31mr6kMPXzcjRaGYoBeMBZCWGrKLxJA/cg8/YmJrd2Pwxb9T80W0hwhnqf8ATC5lMsP
        9P2bve2q9thzNAUoORq2bXnAK0TEi25uJUbBu8L3BC+1QCRT/4xUnxRHCD6NhWTK6wpm4f
        kARvQF5WwG4Pafdg3PZjz4sM73RytL0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-QSY4ePW3NRefpiDSj1yaZw-1; Wed, 17 May 2023 09:23:15 -0400
X-MC-Unique: QSY4ePW3NRefpiDSj1yaZw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-534107e73cfso494420a12.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 06:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684329795; x=1686921795;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R84mdR5Ybe8j5TDFyLE8jRpFf5CWTx9pF4UrNhUID5w=;
        b=fAjdjhVtc8/5vWJDsNGySCsWFaFzvugNQATufty0GpheK89i2ibcTJDAYnoH+fn0NH
         2VVTtIvrmtWbbRa+2+PNU2t3cWUKhDmcp6S5N33raZnrbb0iD1tGQa2YXdyQc2s8Qixg
         2t0ZZ/OYMWsuVHn2RA1l3DTtscKs91ZQR1+7xmrCf5RKzL6WtOmyR286coPM9OLiB9jI
         QvjwbPt0EMW+YPZ5S8MyQsW0z265d8zbFe/BIrmoORgC2506OTEe0Pwh7d3f5jsCfeRf
         IRHdY7cPBz/1afr9pnrxauYAc6W/8MLjs8CLIKcs8+5rUcVHmojZgWCuyKdUzocJj/KG
         yKVA==
X-Gm-Message-State: AC+VfDyUtJrqAc6eB5JQlCPeAV/WTz9Dh8V8vKeICThq6WYWQHAH2vaB
        zgM3GWghRADKZMDA+tAquvFZpVAXMWcK6Bw3djiw0oGORsS5DyGFziNcqZ5m6RgQ1qJmr+EE7F6
        Z5mjOr7j6umVkEKD4mV5ilQ==
X-Received: by 2002:a05:6a20:2588:b0:109:12d0:db23 with SMTP id k8-20020a056a20258800b0010912d0db23mr1462579pzd.1.1684329794784;
        Wed, 17 May 2023 06:23:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4LsE/lROXS0ziLWI8hfDwEKFXnewkhgmmjB/5GQh4sealsEmwZ9VIhcJBWcOmEex+rZ8buWQ==
X-Received: by 2002:a05:6a20:2588:b0:109:12d0:db23 with SMTP id k8-20020a056a20258800b0010912d0db23mr1462556pzd.1.1684329794457;
        Wed, 17 May 2023 06:23:14 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 12-20020a63124c000000b00502ecb91940sm15215345pgs.55.2023.05.17.06.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 06:23:14 -0700 (PDT)
Message-ID: <59141327-4a60-8907-3bd6-7ea4739fd17c@redhat.com>
Date:   Wed, 17 May 2023 21:23:07 +0800
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

Yeah. While IMO usually upgrading the kernel will be safer and easier 
than upgrading the whole ceph cluster, and upgrading the ceph cluster 
may cause the fs metadatas corruption issue, which we have hit many time 
from CUs and ceph-user mail list.

Will leave it to you for this. If that still doesn't make sense I will 
drop this patch.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

