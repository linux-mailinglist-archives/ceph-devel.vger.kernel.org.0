Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E936D70661C
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 13:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjEQLGV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 07:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjEQLGC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 07:06:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59AB26B7
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 04:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684321497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4D+Si5MsjCbSFxYWlAoakdg577K6cyyeycE4LB5MhY=;
        b=Pq0+ks/ERb4A/pZSK2/XaSNOEUMvqksMzPy4iugA3M+ckCbDMYIg+5aXZhvgewp7rMQ4Pd
        R3ebuOvY+nydoSGRkmTXlnrhFCPx6TWhZIfgbDm9xcX0/mh8VT4Nj+UgrTHj5CiFlYoILh
        JVMGsBAMEMHEKx25xgoOBNc5Tg24u08=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-4fCLP4tAPkOei4rZUzYOaw-1; Wed, 17 May 2023 07:04:56 -0400
X-MC-Unique: 4fCLP4tAPkOei4rZUzYOaw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1ab0f01ce43so8255625ad.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 04:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321495; x=1686913495;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4D+Si5MsjCbSFxYWlAoakdg577K6cyyeycE4LB5MhY=;
        b=guW8s/SDek4IbdJrqjOzjos0aHYHcIU+U7t0HVimdDYBRo7BMC2LvDFq06ZiI1Fnbm
         nUvVOA+dTJAsfIv/9pDVmu8OoxYenUYpQFplEUHLd9+CVLGwcUmU0tECQxhbO5r9UYJZ
         7c3qOH6/m+a34st/a/DDAMLzi6fU07Ix083uQPfZC3uCG+5WkTBVqzmCkLB2kGH4eD+Y
         5ttwKh7eQdVYg6NKkQ/PX3LfOfZmNoEVPJ1db6UOQ1lhXcxnCJ7L7Zx2R0o8VtZKQTtv
         FL8mfTjewMKph/EJHDE8/QpsuJeAwUf6QP9B4pWgJ8uVrxH6kyGR6ofyxIr5iwA7uQBl
         +UmQ==
X-Gm-Message-State: AC+VfDw2RR9pIpFMHRSIMfRpz/ZkEHjO1cwELQ1DOzwoZPa2i5tFpsZ+
        uVZ2cw1oExD+0ABLlYvJSDYNPQ3L69YNobsEc1HLYa0WoHXxaTjh98tqj8HAw2h64cV6BiWDREq
        bVXqkXOdduvWsFIeh6n4uxg==
X-Received: by 2002:a17:902:e80b:b0:1aa:ffed:652c with SMTP id u11-20020a170902e80b00b001aaffed652cmr54553714plg.64.1684321494931;
        Wed, 17 May 2023 04:04:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6GMgix2tkj9161luYdn5azJnnafpP0SrbcYQqana0eZAd3Qw9Doz685XSvfW0KCPDFXN3Ifg==
X-Received: by 2002:a17:902:e80b:b0:1aa:ffed:652c with SMTP id u11-20020a170902e80b00b001aaffed652cmr54553673plg.64.1684321494462;
        Wed, 17 May 2023 04:04:54 -0700 (PDT)
Received: from [10.72.12.110] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902d50b00b001ac84f87b1dsm17342708plg.155.2023.05.17.04.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 04:04:54 -0700 (PDT)
Message-ID: <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com>
Date:   Wed, 17 May 2023 19:04:49 +0800
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
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
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


On 5/17/23 18:31, Ilya Dryomov wrote:
> On Wed, May 17, 2023 at 7:24 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
>> request may still contain a list of 'split_realms', and we need
>> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Frank Schilder <frans@dtu.dk>
>> Reported-by: Frank Schilder <frans@dtu.dk>
>> URL: https://tracker.ceph.com/issues/61200
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index 0e59e95a96d9..d95dfe16b624 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>                                  continue;
>>                          adjust_snap_realm_parent(mdsc, child, realm->ino);
>>                  }
>> +       } else {
>> +               p += sizeof(u64) * num_split_inos;
>> +               p += sizeof(u64) * num_split_realms;
>>          }
>>
>>          /*
>> --
>> 2.40.1
>>
> Hi Xiubo,
>
> This code appears to be very old -- it goes back to the initial commit
> 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
> explanation for why this popped up only now?

As I remembered we hit this before in one cu BZ last year, but I 
couldn't remember exactly which one.  But I am not sure whether @Jeff 
saw this before I joint ceph team.


> Has MDS always been including split_inos and split_realms arrays in
> !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recent
> change, I'd argue that this needs to be addressed on the MDS side.

While in MDS side for the _UPDATE op it won't send the 'split_realm' 
list just before the commit in 2017:

commit 93e7267757508520dfc22cff1ab20558bd4a44d4
Author: Yan, Zheng <zyan@redhat.com>
Date:   Fri Jul 21 21:40:46 2017 +0800

     mds: send snap related messages centrally during mds recovery

     sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
     clients centrally in MDCache::open_snaprealms()

     Signed-off-by: "Yan, Zheng" <zyan@redhat.com>

Before this commit it will only send the 'split_realm' list for the 
_SPLIT op.


The following the snaptrace:

[Wed May 10 16:03:06 2023] header: 00000000: 05 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023] header: 00000010: 12 03 7f 00 01 00 00 01 00 
00 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023] header: 00000020: 00 00 00 00 02 01 00 00 00 
00 00 00 00 01 00 00  ................
[Wed May 10 16:03:06 2023] header: 00000030: 00 98 0d 60 
93                                   ...`.
[Wed May 10 16:03:06 2023]  front: 00000000: 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00  ................ <<== The op is 0, which is 
'CEPH_SNAP_OP_UPDATE'
[Wed May 10 16:03:06 2023]  front: 00000010: 0c 00 00 00 88 00 00 00 d1 
c0 71 38 00 01 00 00  ..........q8....           <<== The '0c' is the 
split_realm number
[Wed May 10 16:03:06 2023]  front: 00000020: 22 c8 71 38 00 01 00 00 d7 
c7 71 38 00 01 00 00  ".q8......q8....       <<== All the 'q8' are the ino#
[Wed May 10 16:03:06 2023]  front: 00000030: d9 c7 71 38 00 01 00 00 d4 
c7 71 38 00 01 00 00  ..q8......q8....
[Wed May 10 16:03:06 2023]  front: 00000040: f1 c0 71 38 00 01 00 00 d4 
c0 71 38 00 01 00 00  ..q8......q8....
[Wed May 10 16:03:06 2023]  front: 00000050: 20 c8 71 38 00 01 00 00 1d 
c8 71 38 00 01 00 00   .q8......q8....
[Wed May 10 16:03:06 2023]  front: 00000060: ec c0 71 38 00 01 00 00 d6 
c0 71 38 00 01 00 00  ..q8......q8....
[Wed May 10 16:03:06 2023]  front: 00000070: ef c0 71 38 00 01 00 00 6a 
11 2d 1a 00 01 00 00  ..q8....j.-.....
[Wed May 10 16:03:06 2023]  front: 00000080: 01 00 00 00 00 00 00 00 01 
00 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023]  front: 00000090: ee 01 00 00 00 00 00 00 01 
00 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023]  front: 000000a0: 00 00 00 00 00 00 00 00 01 
00 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023]  front: 000000b0: 01 09 00 00 00 00 00 00 00 
00 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023]  front: 000000c0: 01 00 00 00 00 00 00 00 02 
09 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023]  front: 000000d0: 05 00 00 00 00 00 00 00 01 
09 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023]  front: 000000e0: ff 08 00 00 00 00 00 00 fd 
08 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023]  front: 000000f0: fb 08 00 00 00 00 00 00 f9 
08 00 00 00 00 00 00  ................
[Wed May 10 16:03:06 2023] footer: 00000000: ca 39 06 07 00 00 00 00 00 
00 00 00 42 06 63 61  .9..........B.ca
[Wed May 10 16:03:06 2023] footer: 00000010: 7b 4b 5d 2d 
05                                   {K]-.


And if the split_realm number equals to sizeof(ceph_mds_snap_realm) + 
extra snap buffer size by coincidence, the above 'corrupted' snaptrace 
will be parsed by kclient too and kclient won't give any warning, but it 
will corrupted the snaprealm and capsnap info in kclient.


Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>

