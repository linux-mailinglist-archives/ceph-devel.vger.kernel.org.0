Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D575769567
	for <lists+ceph-devel@lfdr.de>; Mon, 31 Jul 2023 14:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjGaMAH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 31 Jul 2023 08:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjGaMAG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 31 Jul 2023 08:00:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7A8D7
        for <ceph-devel@vger.kernel.org>; Mon, 31 Jul 2023 04:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690804759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPxAZLR5ZMhdl0F2z+XaQSP0R3DCuQNQr4J2qoiFGb4=;
        b=b2WhUfd5PrGaDAJwIxzOCxovKVeDZUmoU96/4oXR12DEMaAFNZ11ToMaXxD1KSaaHD21d6
        OIz00iOvTm7ZnEPIHOuIUmpvSE44GmRGpxTGxwUrE5FmOIpgaheZAXRb4fysr0piDifBXW
        A+h9uTRArw2XfVOvf7aPLFftQCGG+3g=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-85XdBbMcMeuwHukEweECIg-1; Mon, 31 Jul 2023 07:59:17 -0400
X-MC-Unique: 85XdBbMcMeuwHukEweECIg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1bb893e61d5so30018455ad.0
        for <ceph-devel@vger.kernel.org>; Mon, 31 Jul 2023 04:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690804757; x=1691409557;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WPxAZLR5ZMhdl0F2z+XaQSP0R3DCuQNQr4J2qoiFGb4=;
        b=UtdFbtUy40c+FTHHxRFLOptFqUPcsSH536SuAXFJ8Dapi918IiTO2YiOWizLV7ri7R
         gNbXkCTHGtu2oNiTClALasSG+31vyBRvF6Ur3Z/QqMnjPNu0lnLb0wQxerY0z4+SI9rr
         IOoRdT+Qm9rFfWSCrtJYp+9hxtH2ohBfy1LjU2jkUGpAy1b34m2L7wlr8Ixe1z2AVsJo
         rL+tuaR2q4+WggZEC3kceLqz9Sdb8tsMhvQzP4sG3EmsobnhjFXrJH5tG7q0VHuCCZ1e
         FsKNx9LxkWIsNb2wgrvMoUA6gf2GBIwR4vlBCyU0T1NDJnkFyxcoucmUebRQ5f9B/P2i
         sjEg==
X-Gm-Message-State: ABy/qLb+bV8o9xyCq9X57phavsydQnrnJ2ek50FAwn822BmqUXsuvEUH
        2jr8TlBQcNkj7bLU7m7r4wC4c5b5LO/B7c0HCnzh0kTCV8wDUdtBoofitd1PYc2obNBcqb0hHCo
        lvMHCbuaGZrsQCmtfCT1H4Q==
X-Received: by 2002:a17:903:481:b0:1bb:c971:ef92 with SMTP id jj1-20020a170903048100b001bbc971ef92mr7494688plb.59.1690804756862;
        Mon, 31 Jul 2023 04:59:16 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF4S10H3yT1BTIBxPwNkRUlRahOP94EROxF+mnYQNiORs+3+BSyUxKYh1BvlglGMr1IAA9VPQ==
X-Received: by 2002:a17:903:481:b0:1bb:c971:ef92 with SMTP id jj1-20020a170903048100b001bbc971ef92mr7494674plb.59.1690804756558;
        Mon, 31 Jul 2023 04:59:16 -0700 (PDT)
Received: from [10.72.112.81] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001b9c960ffeasm8435477plf.47.2023.07.31.04.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 04:59:16 -0700 (PDT)
Message-ID: <b4766f81-faf6-2df5-8fea-51b0c5a772ab@redhat.com>
Date:   Mon, 31 Jul 2023 19:59:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3] ceph: defer stopping the mdsc delayed_work
Content-Language: en-US
To:     Milind Changire <mchangir@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org
References: <20230725040359.363444-1-xiubli@redhat.com>
 <CAED=hWDNP2AsnqHWxyHxuQij1KWVoT+oEETD7r3GqtBP=k7yBA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAED=hWDNP2AsnqHWxyHxuQij1KWVoT+oEETD7r3GqtBP=k7yBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/31/23 19:47, Milind Changire wrote:
> On Tue, Jul 25, 2023 at 9:36 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Flushing the dirty buffer may take a long time if the Rados is
>> overloaded or if there is network issue. So we should ping the
>> MDSs periodically to keep alive, else the MDS will blocklist
>> the kclient.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Venky Shankar <vshankar@redhat.com>
>> URL: https://tracker.ceph.com/issues/61843
>> Reviewed-by: Milind Changire <mchangir@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V3:
>> - Rebased to the master branch
>>
>>
>>   fs/ceph/mds_client.c |  4 ++--
>>   fs/ceph/mds_client.h |  5 +++++
>>   fs/ceph/super.c      | 10 ++++++++++
>>   3 files changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 66048a86c480..5fb367b1d4b0 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4764,7 +4764,7 @@ static void delayed_work(struct work_struct *work)
>>
>>          dout("mdsc delayed_work\n");
>>
>> -       if (mdsc->stopping)
>> +       if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
>>                  return;
> Do we want to continue to accept/perform delayed work when
> mdsc->stopping is set to CEPH_MDSC_STOPPING_BEGIN ?
>
> I thought setting the STOPPING_BEGIN flag would immediately bar any
> further new activity and STOPPING_FLUSHED would mark safe deletion of
> the superblock.

Yes,  we need.

Locally I can reproduce this very easy with fsstress.sh script, please 
see https://tracker.ceph.com/issues/61843#note-1.

That's because when umounting and flushing the dirty buffer it could be 
blocked by the Rados dues to the lower disk space or MM reasons. And 
during this we need to ping MDS to keep alive to make sure the MDS won't 
evict us before we close the sessions later.

Thanks

- Xiubo

>
>
>>          mutex_lock(&mdsc->mutex);
>> @@ -4943,7 +4943,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
>>   void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>>   {
>>          dout("pre_umount\n");
>> -       mdsc->stopping = 1;
>> +       mdsc->stopping = CEPH_MDSC_STOPPING_BEGIN;
>>
>>          ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>>          ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 724307ff89cd..86d2965e68a1 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -380,6 +380,11 @@ struct cap_wait {
>>          int                     want;
>>   };
>>
>> +enum {
>> +       CEPH_MDSC_STOPPING_BEGIN = 1,
>> +       CEPH_MDSC_STOPPING_FLUSHED = 2,
>> +};
>> +
>>   /*
>>    * mds client state
>>    */
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 3fc48b43cab0..a5f52013314d 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -1374,6 +1374,16 @@ static void ceph_kill_sb(struct super_block *s)
>>          ceph_mdsc_pre_umount(fsc->mdsc);
>>          flush_fs_workqueues(fsc);
>>
>> +       /*
>> +        * Though the kill_anon_super() will finally trigger the
>> +        * sync_filesystem() anyway, we still need to do it here
>> +        * and then bump the stage of shutdown to stop the work
>> +        * queue as earlier as possible.
>> +        */
>> +       sync_filesystem(s);
>> +
>> +       fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
>> +
>>          kill_anon_super(s);
>>
>>          fsc->client->extra_mon_dispatch = NULL;
>> --
>> 2.39.1
>>
>

