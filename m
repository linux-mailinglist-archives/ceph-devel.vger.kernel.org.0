Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E63E707715
	for <lists+ceph-devel@lfdr.de>; Thu, 18 May 2023 02:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjERAsv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 20:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjERAss (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 20:48:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B328E40C7
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 17:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684370881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IzfD+wGf9KN34fBi7sZ/VQvDiE72yw3lZzuom2iYCtg=;
        b=RBOh6qcXz662iac1FsV+AGUIRhd3GpJlJT1aMHoJyQcOZWmE+Jg8RzJ/hiMMHTaLNCvHjI
        d5qzT5qKhMGRZWq53ZdTbgPBk4+CirLEeeuoCBk2/Z5m0RL1Oay6v3GfotGju8LGeMsIZo
        rIlluf2gD+rk8yIMpHKiVDGM11kkHHY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-RCz7jcWgOBmowColf0DWsw-1; Wed, 17 May 2023 20:47:59 -0400
X-MC-Unique: RCz7jcWgOBmowColf0DWsw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-64d138bd759so98849b3a.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 17:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684370878; x=1686962878;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IzfD+wGf9KN34fBi7sZ/VQvDiE72yw3lZzuom2iYCtg=;
        b=IfFpMZMgzUqkFmH8CnmykzknZtehJ7ukcE2SlgrIHngdn+97W1FEDTlLRvqmxD8Z8x
         n+I0hjewTdUPZZ1NP4e9z9aRv26UiwZr2sXCmaopMQkcE8ONBzWz0uqb0qQxEghjZbrk
         fGujsPrxCjflvNyy1VMWLo81LgkNshvIS+SaHjKWgB1yGxUdloIlGKv0oxjLMWPc6CbN
         c6agxkMnVFQFKNdX4kdMl0OyV7fEH8XhRNOF+45AOXHkSG2EVyrxAdbdMWv5/v35bFLE
         GLi55ZEpHWt2vLCuewMYASBaAeUsbNOs5mlrdZxoRANq0xajDxZn/X+CVUowAnqMboEL
         f0AQ==
X-Gm-Message-State: AC+VfDx/9unE9POLxroouBEBICE771usbF8RQ5aWKMdR/Zlu9XbLl6UA
        v8PWmoipdoFYpuIS0cu86pdLDPePtFbMR82ZWoLbxCNOi7bxfrtVKpFtNlOePSbwUeMY4GYAcKp
        2B7O7VDBERXsgaEgVm3ZKMA==
X-Received: by 2002:a05:6a00:1a08:b0:64d:1185:2414 with SMTP id g8-20020a056a001a0800b0064d11852414mr1107770pfv.4.1684370878585;
        Wed, 17 May 2023 17:47:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7p6wNR/mVvgbLEjqM/wR4MonUShmKqC1WVDd8ZuT8ml/Yin7dFHbsxmR9moiQ0VpYy7roVMQ==
X-Received: by 2002:a05:6a00:1a08:b0:64d:1185:2414 with SMTP id g8-20020a056a001a0800b0064d11852414mr1107753pfv.4.1684370878295;
        Wed, 17 May 2023 17:47:58 -0700 (PDT)
Received: from [10.72.12.110] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a26-20020aa7865a000000b0063b85893633sm101898pfo.197.2023.05.17.17.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 17:47:57 -0700 (PDT)
Message-ID: <516afcfd-0027-25d2-7be4-1868ca4a4a7e@redhat.com>
Date:   Thu, 18 May 2023 08:47:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
References: <20230517052404.99904-1-xiubli@redhat.com>
 <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com>
 <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com>
 <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/23 22:27, Ilya Dryomov wrote:
> On Wed, May 17, 2023 at 3:59 PM Gregory Farnum <gfarnum@redhat.com> wrote:
>> On Wed, May 17, 2023 at 4:33 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>>> On Wed, May 17, 2023 at 1:04 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>
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
>>>>>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>>>>>                                   continue;
>>>>>>                           adjust_snap_realm_parent(mdsc, child, realm->ino);
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
>>>>       mds: send snap related messages centrally during mds recovery
>>>>
>>>>       sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
>>>>       clients centrally in MDCache::open_snaprealms()
>>>>
>>>>       Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>>>>
>>>> Before this commit it will only send the 'split_realm' list for the
>>>> _SPLIT op.
>>> It sounds like we have the culprit.  This should be treated as
>>> a regression and fixed on the MDS side.  I don't see a justification
>>> for putting useless data on the wire.
>> I don't really understand this viewpoint. We can treat it as an MDS
>> regression if we want, but it's a six-year-old patch so this is in
>> nearly every version of server code anybody's running. Why wouldn't we
>> fix it on both sides?
> Well, if I didn't speak up chances are we wouldn't have identified the
> regression in the MDS at all.  People seem to have this perception that
> the client is somehow "easier" to fix, assume that the server is always
> doing the right thing and default to patching the client.  I'm just
> trying to push back on that.
>
> In this particular case, after understanding the scope of the issue
> _and_ getting a committal for the MDS side fix, I approved taking the
> kernel client patch in an earlier reply.
>
>> On Wed, May 17, 2023 at 4:07 AM Xiubo Li <xiubli@redhat.com> wrote:
>>> And if the split_realm number equals to sizeof(ceph_mds_snap_realm) +
>>> extra snap buffer size by coincidence, the above 'corrupted' snaptrace
>>> will be parsed by kclient too and kclient won't give any warning, but it
>>> will corrupted the snaprealm and capsnap info in kclient.
>> I'm a bit confused about this patch, but I also don't follow the
>> kernel client code much so please forgive my ignorance. The change
>> you've made is still only invoked inside of the CEPH_SNAP_OP_SPLIT
>> case, so clearly the kclient *mostly* does the right thing when these
> No, it's invoked outside: it introduces a "op != CEPH_SNAP_OP_SPLIT"
> branch.

Yeah, correct.

The problem is not all the UPDATE cases in MDS will encode and pass the 
'split_realms' list to clients via the MClientSnap requests. By reading 
Zheng's commit I think he just copied that code to one UPDATE case from 
old SPLIT case and didn't notice it will introduce this issue in kclient.

Sending the 'split_realms' is unnecessary and useless in client side for 
UPDATE case, we should fix it in MDS side too.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

