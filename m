Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50217647EF6
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Dec 2022 09:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLIIIq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Dec 2022 03:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLIIIo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Dec 2022 03:08:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F9CBC87
        for <ceph-devel@vger.kernel.org>; Fri,  9 Dec 2022 00:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670573258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EWYoGR7ZMYVitpz9hSEWansn9yhsNBZoKyZGaVZvqus=;
        b=JEkZ6VMHyHMJSx+6VIEM+rFR4YXY/+8PFuEkTQeamUS5/RLgs9682yIgi3LeKCT0jubusc
        KSKXiybQpVCmhJFz2th0nDUjoQqbnagbZmYyK0nie9zw/QtRzjjqYAiYYguRxH474cncQc
        12aMz0ih0I9FEJs0rysOc/dysOQRGSg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-280-2wMsZZEzOgSF1fsKZiju5g-1; Fri, 09 Dec 2022 03:07:37 -0500
X-MC-Unique: 2wMsZZEzOgSF1fsKZiju5g-1
Received: by mail-pl1-f198.google.com with SMTP id j18-20020a170902da9200b00189b3b16addso3698126plx.23
        for <ceph-devel@vger.kernel.org>; Fri, 09 Dec 2022 00:07:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EWYoGR7ZMYVitpz9hSEWansn9yhsNBZoKyZGaVZvqus=;
        b=5AWTyqeQHsxzQZlsi9L3PaDWZwez9abx4Z5Je8Jk81aZxFZPMbVGr/T/822jqBu6UR
         d/8dd6m8+20BbY8mppmF69pnupMlUE7UDW+18wRbX39otf0lEdkXrKLdcJsT2XGUbBgF
         GTGY1IOgq03/zXHBTQmsDiBAqaniT10ZQRzyneT8t4pQ0hafgpUzPD4nG1DGPHjCeUWn
         XgyJxli3Y+0cnconGTRGTkI0bC8PkTxvg3694Wht0FAeHrdBG4ouoldeV+QndbyfxFyn
         B3JyceFmZ6OWkTFso7sVG3d716MRdit24yyH5FEvGVSPj9vjE+H641KtYZusGFl3f+t2
         1Sig==
X-Gm-Message-State: ANoB5pk6LbwntqrEPI/j7ISOVD0H4bf0fwWViMzbqknE8pvDw2iZvhmL
        V2M1gNL6rBvJIJgJGeRgcScIJNlo+oNgH2RN1Z/CYMiPe9YAUDy6k17iTyl4a30AaX3yhJIdv2h
        x7CeWHqQGxUbX6pcKj9pNPw==
X-Received: by 2002:a17:903:1247:b0:189:acee:7aa4 with SMTP id u7-20020a170903124700b00189acee7aa4mr5763933plh.65.1670573255833;
        Fri, 09 Dec 2022 00:07:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf79QSf23h36PgLvM7X3ZBLi7YvtMX59KayQfilDL4OilrJOrlrZirDDqpHvqfHN1tKF1g2Scg==
X-Received: by 2002:a17:903:1247:b0:189:acee:7aa4 with SMTP id u7-20020a170903124700b00189acee7aa4mr5763914plh.65.1670573255435;
        Fri, 09 Dec 2022 00:07:35 -0800 (PST)
Received: from [10.72.12.134] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id je20-20020a170903265400b00187197c499asm729127plb.164.2022.12.09.00.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:07:35 -0800 (PST)
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, mchangir@redhat.com, atomlin@atomlin.com,
        stable@vger.kernel.org
References: <20221206125915.37404-1-xiubli@redhat.com>
 <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
 <baa681e9-4472-bcfb-601f-132dc6658888@redhat.com>
 <ac1e95e6-f8fa-e243-97bd-a280b8e0fa66@redhat.com>
 <CAOi1vP_=2wOSYmrzfdm3k__dVONjXspjV15gbZ+Yq247xmpnXQ@mail.gmail.com>
 <d8a35b3a-e0b9-8ee8-9b0e-dc77ddc9c312@redhat.com>
 <CACPzV1k=L0GyhK5c0Jgce=s02wqxa20qMuTzHhZvJB6cgnSQcw@mail.gmail.com>
 <487811e4-ffba-cfe5-db2b-5379602e7b26@redhat.com>
 <CACPzV1mhhskPUz1URs6FUJE9CebOVm1xcRTRgK2yYiwD+soO2g@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1eb59764-5489-8af9-d502-4f3bd44be4dd@redhat.com>
Date:   Fri, 9 Dec 2022 16:07:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACPzV1mhhskPUz1URs6FUJE9CebOVm1xcRTRgK2yYiwD+soO2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 09/12/2022 15:15, Venky Shankar wrote:
> On Fri, Dec 9, 2022 at 12:29 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 09/12/2022 14:14, Venky Shankar wrote:
>>> On Thu, Dec 8, 2022 at 6:10 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 07/12/2022 22:20, Ilya Dryomov wrote:
>>>>> On Wed, Dec 7, 2022 at 2:31 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>> On 07/12/2022 21:19, Xiubo Li wrote:
>>>>>>> On 07/12/2022 18:59, Ilya Dryomov wrote:
>>>>>>>> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
>>>>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>>>>
>>>>>>>>> When received corrupted snap trace we don't know what exactly has
>>>>>>>>> happened in MDS side. And we shouldn't continue writing to OSD,
>>>>>>>>> which may corrupt the snapshot contents.
>>>>>>>>>
>>>>>>>>> Just try to blocklist this client and If fails we need to crash the
>>>>>>>>> client instead of leaving it writeable to OSDs.
>>>>>>>>>
>>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>>> URL: https://tracker.ceph.com/issues/57686
>>>>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>>>>> ---
>>>>>>>>>
>>>>>>>>> Thanks Aaron's feedback.
>>>>>>>>>
>>>>>>>>> V3:
>>>>>>>>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
>>>>>>>>>
>>>>>>>>> V2:
>>>>>>>>> - Switched to WARN() to taint the Linux kernel.
>>>>>>>>>
>>>>>>>>>      fs/ceph/mds_client.c |  3 ++-
>>>>>>>>>      fs/ceph/mds_client.h |  1 +
>>>>>>>>>      fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>>>>>>>>>      3 files changed, 28 insertions(+), 1 deletion(-)
>>>>>>>>>
>>>>>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>>>>>> index cbbaf334b6b8..59094944af28 100644
>>>>>>>>> --- a/fs/ceph/mds_client.c
>>>>>>>>> +++ b/fs/ceph/mds_client.c
>>>>>>>>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct
>>>>>>>>> ceph_connection *con)
>>>>>>>>>             struct ceph_mds_client *mdsc = s->s_mdsc;
>>>>>>>>>
>>>>>>>>>             pr_warn("mds%d closed our session\n", s->s_mds);
>>>>>>>>> -       send_mds_reconnect(mdsc, s);
>>>>>>>>> +       if (!mdsc->no_reconnect)
>>>>>>>>> +               send_mds_reconnect(mdsc, s);
>>>>>>>>>      }
>>>>>>>>>
>>>>>>>>>      static void mds_dispatch(struct ceph_connection *con, struct
>>>>>>>>> ceph_msg *msg)
>>>>>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>>>>>> index 728b7d72bf76..8e8f0447c0ad 100644
>>>>>>>>> --- a/fs/ceph/mds_client.h
>>>>>>>>> +++ b/fs/ceph/mds_client.h
>>>>>>>>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>>>>>>>>>             atomic_t                num_sessions;
>>>>>>>>>             int                     max_sessions;  /* len of sessions
>>>>>>>>> array */
>>>>>>>>>             int                     stopping;      /* true if shutting
>>>>>>>>> down */
>>>>>>>>> +       int                     no_reconnect;  /* true if snap trace
>>>>>>>>> is corrupted */
>>>>>>>>>
>>>>>>>>>             atomic64_t              quotarealms_count; /* # realms with
>>>>>>>>> quota */
>>>>>>>>>             /*
>>>>>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>>>>>> index c1c452afa84d..023852b7c527 100644
>>>>>>>>> --- a/fs/ceph/snap.c
>>>>>>>>> +++ b/fs/ceph/snap.c
>>>>>>>>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct
>>>>>>>>> ceph_mds_client *mdsc,
>>>>>>>>>             struct ceph_snap_realm *realm;
>>>>>>>>>             struct ceph_snap_realm *first_realm = NULL;
>>>>>>>>>             struct ceph_snap_realm *realm_to_rebuild = NULL;
>>>>>>>>> +       struct ceph_client *client = mdsc->fsc->client;
>>>>>>>>>             int rebuild_snapcs;
>>>>>>>>>             int err = -ENOMEM;
>>>>>>>>> +       int ret;
>>>>>>>>>             LIST_HEAD(dirty_realms);
>>>>>>>>>
>>>>>>>>>             lockdep_assert_held_write(&mdsc->snap_rwsem);
>>>>>>>>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct
>>>>>>>>> ceph_mds_client *mdsc,
>>>>>>>>>             if (first_realm)
>>>>>>>>>                     ceph_put_snap_realm(mdsc, first_realm);
>>>>>>>>>             pr_err("%s error %d\n", __func__, err);
>>>>>>>>> +
>>>>>>>>> +       /*
>>>>>>>>> +        * When receiving a corrupted snap trace we don't know what
>>>>>>>>> +        * exactly has happened in MDS side. And we shouldn't continue
>>>>>>>>> +        * writing to OSD, which may corrupt the snapshot contents.
>>>>>>>>> +        *
>>>>>>>>> +        * Just try to blocklist this kclient and if it fails we need
>>>>>>>>> +        * to crash the kclient instead of leaving it writeable.
>>>>>>>> Hi Xiubo,
>>>>>>>>
>>>>>>>> I'm not sure I understand this "let's blocklist ourselves" concept.
>>>>>>>> If the kernel client shouldn't continue writing to OSDs in this case,
>>>>>>>> why not just stop issuing writes -- perhaps initiating some equivalent
>>>>>>>> of a read-only remount like many local filesystems would do on I/O
>>>>>>>> errors (e.g. errors=remount-ro mode)?
>>>>>>> The following patch seems working. Let me do more test to make sure
>>>>>>> there is not further crash.
>>>>>>>
>>>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>>>> index c1c452afa84d..cd487f8a4cb5 100644
>>>>>>> --- a/fs/ceph/snap.c
>>>>>>> +++ b/fs/ceph/snap.c
>>>>>>> @@ -767,6 +767,7 @@ int ceph_update_snap_trace(struct ceph_mds_client
>>>>>>> *mdsc,
>>>>>>>            struct ceph_snap_realm *realm;
>>>>>>>            struct ceph_snap_realm *first_realm = NULL;
>>>>>>>            struct ceph_snap_realm *realm_to_rebuild = NULL;
>>>>>>> +       struct super_block *sb = mdsc->fsc->sb;
>>>>>>>            int rebuild_snapcs;
>>>>>>>            int err = -ENOMEM;
>>>>>>>            LIST_HEAD(dirty_realms);
>>>>>>> @@ -885,6 +886,9 @@ int ceph_update_snap_trace(struct ceph_mds_client
>>>>>>> *mdsc,
>>>>>>>            if (first_realm)
>>>>>>>                    ceph_put_snap_realm(mdsc, first_realm);
>>>>>>>            pr_err("%s error %d\n", __func__, err);
>>>>>>> +       pr_err("Remounting filesystem read-only\n");
>>>>>>> +       sb->s_flags |= SB_RDONLY;
>>>>>>> +
>>>>>>>            return err;
>>>>>>>     }
>>>>>>>
>>>>>>>
>>>>>> For readonly approach is also my first thought it should be, but I was
>>>>>> just not very sure whether it would be the best approach.
>>>>>>
>>>>>> Because by evicting the kclient we could prevent the buffer to be wrote
>>>>>> to OSDs. But the readonly one seems won't ?
>>>>> The read-only setting is more for the VFS and the user.  Technically,
>>>>> the kernel client could just stop issuing writes (i.e. OSD requests
>>>>> containing a write op) and not set SB_RDONLY.  That should cover any
>>>>> buffered data as well.
>>>>    From reading the local exit4 and other fs, they all doing it this way
>>>> and the VFS will help stop further writing. Tested the above patch and
>>>> it worked as expected.
>>>>
>>>> I think to stop the following OSD requests we can just check the
>>>> SB_RDONLY flag to prevent the buffer writeback.
>>>>
>>>>> By employing self-blocklisting, you are shifting the responsibility
>>>>> of rejecting OSD requests to the OSDs.  I'm saying that not issuing
>>>>> OSD requests from a potentially busted client in the first place is
>>>>> probably a better idea.  At the very least you wouldn't need to BUG
>>>>> on ceph_monc_blocklist_add() errors.
>>>> I found an issue for the read-only approach:
>>>>
>>>> In read-only mode it still can access to the MDSs and OSDs, which will
>>>> continue trying to update the snap realms with the corrupted snap trace
>>>> as before when reading. What if users try to read or backup the
>>>> snapshots by using the corrupted snap realms ?
>>>>
>>>> Isn't that a problem ?
>>> Yeh - this might end up in more problems in various places than what
>>> this change is supposed to handle.
>>>
>>> Maybe we could track affected realms (although, not that granular) and
>>> disallow reads to them (and its children), but I think it might not be
>>> worth putting in the effort.
>> IMO this doesn't make much sense.
>>
>> When reading we need to use the inodes to get the corresponding realms,
>> once the metadatas are corrupted and aborted here the inodes'
>> corresponding realms could be incorrect. That's because when updating
>> the snap realms here it's possible that the snap realm hierarchy will be
>> adjusted and some inodes' realms will be changed.
> My point was if at all we could identify the realms correctly, which
> seems risky with the corrupted info received. Seems like this needs to
> be an all or none approach.

Yeah. Agree.

>
>> Thanks
>>
>> - Xiubo
>>
>>>> Thanks
>>>>
>>>> - Xiubo
>>>>
>>>>> Thanks,
>>>>>
>>>>>                    Ilya
>>>>>
>

