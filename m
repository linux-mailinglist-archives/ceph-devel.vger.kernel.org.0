Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B1B6459E6
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Dec 2022 13:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiLGMgp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Dec 2022 07:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiLGMgj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Dec 2022 07:36:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0F44EC33
        for <ceph-devel@vger.kernel.org>; Wed,  7 Dec 2022 04:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670416540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8pDtQ9nm2wZqYnBy49v2PpqXkl7rY/mR/RZTTzt+8gE=;
        b=P4s48fcG2lyIFCwviOerutZbc082QFJpzt3PYjfeWO2BXNeVVahzvX+CTsfI4KLGYoDwvb
        ovYRF1Q8oLGapGC0bNLvXOTs2CCujbBiCLEessDk+SYnlYnjPmCHHSWt27/kuOApzYgrur
        5qzVrpEt9etM5P3upSPrUMNtbddHJFE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-323-uuWs3O69NDuKGTtNl7qD4w-1; Wed, 07 Dec 2022 07:35:38 -0500
X-MC-Unique: uuWs3O69NDuKGTtNl7qD4w-1
Received: by mail-pj1-f72.google.com with SMTP id o18-20020a17090aac1200b00219ca917708so1286487pjq.8
        for <ceph-devel@vger.kernel.org>; Wed, 07 Dec 2022 04:35:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8pDtQ9nm2wZqYnBy49v2PpqXkl7rY/mR/RZTTzt+8gE=;
        b=bYJ3os9PVgaJBzP0C4J8+rVYqM+sD6GtrJ7uGon9GG4M3uvi58cy/Mec9HaNrI+/bm
         /5ngFiG42UlKpHhT0/cGNpC2AsDhkmz2R1PSnXR/l2kQzxNvabIVuKiA55P4gV1Y+eAM
         ymouQYM49TfiCE69ylEe7XT4aqamZFomH2nbLaDWJH/5Lay1MQIpD0/oWY3fGJpRioy4
         ufWaqIcDMdjBNyIL7jchfexwkCx2nQrQwCuZDnOsONtwAgIFIoHcHEIFSl2VjjMt2YXl
         cULqzdLIuXLH8PZoVaU82L9aozwEytl1A+ElDltvmcS/CuVaS7jR69WkdgIPa/Cz+S2d
         S+mg==
X-Gm-Message-State: ANoB5pnIaY8aqFwW6EF6kxSBLfckUQX2bd48084dfbepCEDvuFoCjsC5
        w8I4AnOj5/t8THDoiPH0JxYgiLU8M8WDA8B9UdFo+qFCMGTGQyqkqgIIseQ9mbu/xgku8H/E4+b
        RfCwhYL1l7eDi6YU4VAmieg==
X-Received: by 2002:a62:31c4:0:b0:56e:989d:7410 with SMTP id x187-20020a6231c4000000b0056e989d7410mr74685166pfx.1.1670416537702;
        Wed, 07 Dec 2022 04:35:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf43DuTnk73egDoSsoqVCVggHzcN08GJa+C4OxymGz7MS4siJ1w3hG42XH4MGeCvfWM9Xbn77Q==
X-Received: by 2002:a62:31c4:0:b0:56e:989d:7410 with SMTP id x187-20020a6231c4000000b0056e989d7410mr74685135pfx.1.1670416537403;
        Wed, 07 Dec 2022 04:35:37 -0800 (PST)
Received: from [10.72.12.134] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 194-20020a6300cb000000b00476b165ff8bsm7381658pga.57.2022.12.07.04.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 04:35:37 -0800 (PST)
Subject: Re: [PATCH v3] ceph: blocklist the kclient when receiving corrupted
 snap trace
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, atomlin@atomlin.com, stable@vger.kernel.org
References: <20221206125915.37404-1-xiubli@redhat.com>
 <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <897fc89b-775f-88ce-1550-90c47220dc18@redhat.com>
Date:   Wed, 7 Dec 2022 20:35:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8hkXZ7w9D5LnMViyjqVCmsKo3H2dg1QpzgHCPuNfvACQ@mail.gmail.com>
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


On 07/12/2022 18:59, Ilya Dryomov wrote:
> On Tue, Dec 6, 2022 at 1:59 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When received corrupted snap trace we don't know what exactly has
>> happened in MDS side. And we shouldn't continue writing to OSD,
>> which may corrupt the snapshot contents.
>>
>> Just try to blocklist this client and If fails we need to crash the
>> client instead of leaving it writeable to OSDs.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57686
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Thanks Aaron's feedback.
>>
>> V3:
>> - Fixed ERROR: spaces required around that ':' (ctx:VxW)
>>
>> V2:
>> - Switched to WARN() to taint the Linux kernel.
>>
>>   fs/ceph/mds_client.c |  3 ++-
>>   fs/ceph/mds_client.h |  1 +
>>   fs/ceph/snap.c       | 25 +++++++++++++++++++++++++
>>   3 files changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index cbbaf334b6b8..59094944af28 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -5648,7 +5648,8 @@ static void mds_peer_reset(struct ceph_connection *con)
>>          struct ceph_mds_client *mdsc = s->s_mdsc;
>>
>>          pr_warn("mds%d closed our session\n", s->s_mds);
>> -       send_mds_reconnect(mdsc, s);
>> +       if (!mdsc->no_reconnect)
>> +               send_mds_reconnect(mdsc, s);
>>   }
>>
>>   static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 728b7d72bf76..8e8f0447c0ad 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -413,6 +413,7 @@ struct ceph_mds_client {
>>          atomic_t                num_sessions;
>>          int                     max_sessions;  /* len of sessions array */
>>          int                     stopping;      /* true if shutting down */
>> +       int                     no_reconnect;  /* true if snap trace is corrupted */
>>
>>          atomic64_t              quotarealms_count; /* # realms with quota */
>>          /*
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index c1c452afa84d..023852b7c527 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          struct ceph_snap_realm *realm;
>>          struct ceph_snap_realm *first_realm = NULL;
>>          struct ceph_snap_realm *realm_to_rebuild = NULL;
>> +       struct ceph_client *client = mdsc->fsc->client;
>>          int rebuild_snapcs;
>>          int err = -ENOMEM;
>> +       int ret;
>>          LIST_HEAD(dirty_realms);
>>
>>          lockdep_assert_held_write(&mdsc->snap_rwsem);
>> @@ -885,6 +887,29 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
>>          if (first_realm)
>>                  ceph_put_snap_realm(mdsc, first_realm);
>>          pr_err("%s error %d\n", __func__, err);
>> +
>> +       /*
>> +        * When receiving a corrupted snap trace we don't know what
>> +        * exactly has happened in MDS side. And we shouldn't continue
>> +        * writing to OSD, which may corrupt the snapshot contents.
>> +        *
>> +        * Just try to blocklist this kclient and if it fails we need
>> +        * to crash the kclient instead of leaving it writeable.
> Hi Xiubo,
>
> I'm not sure I understand this "let's blocklist ourselves" concept.
> If the kernel client shouldn't continue writing to OSDs in this case,
> why not just stop issuing writes -- perhaps initiating some equivalent
> of a read-only remount like many local filesystems would do on I/O
> errors (e.g. errors=remount-ro mode)?

I still haven't found how could I handle it this way from ceph layer. I 
saw they are just marking the inodes as EIO when this happens.

>
> Or, perhaps, all in-memory snap contexts could somehow be invalidated
> in this case, making writes fail naturally -- on the client side,
> without actually being sent to OSDs just to be nixed by the blocklist
> hammer.
>
> But further, what makes a failure to decode a snap trace special?

 From the known tracker the snapid was corrupted in one inode in MDS and 
then when trying to build the snap trace with the corrupted snapid it 
will corrupt.

And also there maybe other cases.

> AFAIK we don't do anything close to this for any other decoding
> failure.  Wouldn't "when received corrupted XYZ we don't know what
> exactly has happened in MDS side" argument apply to pretty much all
> decoding failures?

The snap trace is different from other cases. The corrupted snap trace 
will affect the whole snap realm hierarchy, which will affect the whole 
inodes in the mount in worst case.

This is why I was trying to evict the mount to prevent further IOs.

>
>> +        *
>> +        * Then this kclient must be remounted to continue after the
>> +        * corrupted metadata fixed in the MDS side.
>> +        */
>> +       mdsc->no_reconnect = 1;
>> +       ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
>> +       if (ret) {
>> +               pr_err("%s blocklist of %s failed: %d", __func__,
>> +                      ceph_pr_addr(&client->msgr.inst.addr), ret);
>> +               BUG();
> ... and this is a rough equivalent of errors=panic mode.
>
> Is there a corresponding userspace client PR that can be referenced?
> This needs additional background and justification IMO.

Not yet. Any way we shouldn't let it continue do the IOs if fails to add 
it to the blocklist.

- Xiubo

>
> Thanks,
>
>                  Ilya
>

