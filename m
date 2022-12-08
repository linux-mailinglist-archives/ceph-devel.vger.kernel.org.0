Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B390E646636
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Dec 2022 02:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiLHBGA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Dec 2022 20:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLHBF7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Dec 2022 20:05:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838626F0F3
        for <ceph-devel@vger.kernel.org>; Wed,  7 Dec 2022 17:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670461503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rdq13wTSYVFmpzMSVo7RcvYDh43Y9yefY5Jog3FfE6Y=;
        b=TJEc+PUoMgMzzOrdTiYKMrdQiKo1rY3O/hG2krdU4zw9giKpjG/noTmD20KBZ+nOwgT2bM
        2Ij7EDyne48AIZ6rykJd9K1HPAUKq7CASxjBhXGN+52tPNSkXqy8IsRxKOms7v6ys/OAo3
        POel4kEkTdKsDLivDSo5IJlv1V0WGpo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-544-QXaI4-RTPgePl9y-ijtzkA-1; Wed, 07 Dec 2022 20:05:02 -0500
X-MC-Unique: QXaI4-RTPgePl9y-ijtzkA-1
Received: by mail-pf1-f197.google.com with SMTP id a18-20020a62bd12000000b0056e7b61ec78so30934pff.17
        for <ceph-devel@vger.kernel.org>; Wed, 07 Dec 2022 17:05:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rdq13wTSYVFmpzMSVo7RcvYDh43Y9yefY5Jog3FfE6Y=;
        b=RwNuI5jR59UiSQg4BuANYmGEUnEIWLNI2NZm/+wGHpof+zruMxwjb5fypvkPzRdGyW
         0zE3lxXMXM/S4kmV2EEu4Y1/p9hPioH+W9TjDq698FySdeEonjIgA/f/Ak/Dw/57BJfh
         uT5E9n8VF7aTbjq+wGR1hBMeeH3zZvZEL3XpBID5Tz5wlNFWBE+1y67L7dTQYrc84GqT
         zKRK+BmObr+XIhlnxWJ2Bx5OwsD+M5ossKiIsLYwmh+3mFxVWUvC8fFnEVQpCr+KMMbf
         AT129LmiIXHGsxpbaXUDh1WnlimBw41z0iELL57MlHnVe1TR87BN1ZMnR0jm5Nl7Wkjd
         pbOw==
X-Gm-Message-State: ANoB5pmxyLdvndkhcYN74A2DpqjE8ly4694w2o595Ks+m12PxV4iRJpL
        Z1IHyY5SGk2JGKPxKlFh8TBCiboH9o3a52F7kDIStT42KLjI0DA7RABqoZ1aKyAlNXJx412Aq0e
        RXHgnfgT0t5Sn73gOZIKS9Q==
X-Received: by 2002:a05:6a00:1696:b0:566:94d0:8c96 with SMTP id k22-20020a056a00169600b0056694d08c96mr1724849pfc.26.1670461501405;
        Wed, 07 Dec 2022 17:05:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6rnJHnRNnvlHPghyA5uXTBtqc+Ev7KeTt0LcCh2KPTUgyNarU3cwYPQIRpdGTTlI8Ucb8hUw==
X-Received: by 2002:a05:6a00:1696:b0:566:94d0:8c96 with SMTP id k22-20020a056a00169600b0056694d08c96mr1724830pfc.26.1670461501057;
        Wed, 07 Dec 2022 17:05:01 -0800 (PST)
Received: from [10.72.12.134] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z20-20020aa79f94000000b0056be4dbd4besm14135412pfr.111.2022.12.07.17.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 17:05:00 -0800 (PST)
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com, stable@vger.kernel.org
References: <20221206125915.37404-1-xiubli@redhat.com>
 <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
 <897fc89b-775f-88ce-1550-90c47220dc18@redhat.com>
 <CAOi1vP8f_qHpPT05yx2X+dbVb28qq+hkpWP988bVcpabU=b+1Q@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6d3bdd08-d091-b20b-95bd-d97c7025d75e@redhat.com>
Date:   Thu, 8 Dec 2022 09:04:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8f_qHpPT05yx2X+dbVb28qq+hkpWP988bVcpabU=b+1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 07/12/2022 22:28, Ilya Dryomov wrote:
> On Wed, Dec 7, 2022 at 1:35 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 07/12/2022 18:59, Ilya Dryomov wrote:
>>> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> When received corrupted snap trace we don't know what exactly has
>>>> happened in MDS side. And we shouldn't continue writing to OSD,
>>>> which may corrupt the snapshot contents.
>>>>
>>>> Just try to blocklist this client and If fails we need to crash the
>>>> client instead of leaving it writeable to OSDs.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> URL: https://tracker.ceph.com/issues/57686
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>
>>>> Thanks Aaron's feedback.
>>>>
>>>> V3:
>>>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
>>>>
>>>> V2:
>>>> - Switched to WARN() to taint the Linux kernel.
>>>>
>>>>    fs/ceph/mds_client.c |  3 ++-
>>>>    fs/ceph/mds_client.h |  1 +
>>>>    fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>>>>    3 files changed, 28 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index cbbaf334b6b8..59094944af28 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
>>>>           struct ceph_mds_client *mdsc = s->s_mdsc;
>>>>
>>>>           pr_warn("mds%d closed our session\n", s->s_mds);
>>>> -       send_mds_reconnect(mdsc, s);
>>>> +       if (!mdsc->no_reconnect)
>>>> +               send_mds_reconnect(mdsc, s);
>>>>    }
>>>>
>>>>    static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>> index 728b7d72bf76..8e8f0447c0ad 100644
>>>> --- a/fs/ceph/mds_client.h
>>>> +++ b/fs/ceph/mds_client.h
>>>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>>>>           atomic_t                num_sessions;
>>>>           int                     max_sessions;  /* len of sessions array */
>>>>           int                     stopping;      /* true if shutting down */
>>>> +       int                     no_reconnect;  /* true if snap trace is corrupted */
>>>>
>>>>           atomic64_t              quotarealms_count; /* # realms with quota */
>>>>           /*
>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>> index c1c452afa84d..023852b7c527 100644
>>>> --- a/fs/ceph/snap.c
>>>> +++ b/fs/ceph/snap.c
>>>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>>>           struct ceph_snap_realm *realm;
>>>>           struct ceph_snap_realm *first_realm = NULL;
>>>>           struct ceph_snap_realm *realm_to_rebuild = NULL;
>>>> +       struct ceph_client *client = mdsc->fsc->client;
>>>>           int rebuild_snapcs;
>>>>           int err = -ENOMEM;
>>>> +       int ret;
>>>>           LIST_HEAD(dirty_realms);
>>>>
>>>>           lockdep_assert_held_write(&mdsc->snap_rwsem);
>>>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>>>           if (first_realm)
>>>>                   ceph_put_snap_realm(mdsc, first_realm);
>>>>           pr_err("%s error %d\n", __func__, err);
>>>> +
>>>> +       /*
>>>> +        * When receiving a corrupted snap trace we don't know what
>>>> +        * exactly has happened in MDS side. And we shouldn't continue
>>>> +        * writing to OSD, which may corrupt the snapshot contents.
>>>> +        *
>>>> +        * Just try to blocklist this kclient and if it fails we need
>>>> +        * to crash the kclient instead of leaving it writeable.
>>> Hi Xiubo,
>>>
>>> I'm not sure I understand this "let's blocklist ourselves" concept.
>>> If the kernel client shouldn't continue writing to OSDs in this case,
>>> why not just stop issuing writes -- perhaps initiating some equivalent
>>> of a read-only remount like many local filesystems would do on I/O
>>> errors (e.g. errors=remount-ro mode)?
>> I still haven't found how could I handle it this way from ceph layer. I
>> saw they are just marking the inodes as EIO when this happens.
>>
>>> Or, perhaps, all in-memory snap contexts could somehow be invalidated
>>> in this case, making writes fail naturally -- on the client side,
>>> without actually being sent to OSDs just to be nixed by the blocklist
>>> hammer.
>>>
>>> But further, what makes a failure to decode a snap trace special?
>>   From the known tracker the snapid was corrupted in one inode in MDS and
>> then when trying to build the snap trace with the corrupted snapid it
>> will corrupt.
>>
>> And also there maybe other cases.
>>
>>> AFAIK we don't do anything close to this for any other decoding
>>> failure.  Wouldn't "when received corrupted XYZ we don't know what
>>> exactly has happened in MDS side" argument apply to pretty much all
>>> decoding failures?
>> The snap trace is different from other cases. The corrupted snap trace
>> will affect the whole snap realm hierarchy, which will affect the whole
>> inodes in the mount in worst case.
>>
>> This is why I was trying to evict the mount to prevent further IOs.
> I suspected as much and my other suggestion was to look at somehow
> invalidating snap contexts/realms.  Perhaps decode out-of-place and on
> any error set a flag indicating that the snap context can't be trusted
> anymore?  The OSD client could then check whether this flag is set
> before admitting the snap context blob into the request message and
> return an error, effectively rejecting the write.

The snap realms are organize as tree-like hierarchy. When the snap trace 
is corruppted maybe only one of the snap realms are affected and maybe 
several or all. The problem is when decoding the corrupted snap trace we 
couldn't know exactly which realms will be affected. If one realm is 
marked as invalid all the child realms should be affected too.

So I don't think this is a better approach than read-only or evicting ones.

Thanks,

- Xiubo

>
> Thanks,
>
>                  Ilya
>

