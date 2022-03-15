Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1DD4D9A14
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 12:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347882AbiCOLNh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 07:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347881AbiCOLNf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 07:13:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D9DE4F9C8
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 04:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647342742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YH4ciMW5tUx/onVoacl1F1J9+3r/TgfMvl44pZpJEz0=;
        b=DpqLCTuyD/HWLdNv8AH421RkVUYXyiB5tqFHW7xap3RmYRUXWow63xr7UW41EsNvns41cK
        JUnFDCixT8EVGOOrhUiPPPjjReYheBxXSxLyMDI3mbZiPPYIJNlDg1cqo1iAORZDGhEaxa
        illfePga0w9QMKn8t86hJyxE0NJYvSw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-F3hQj6-zPDKIMnkKeznyyw-1; Tue, 15 Mar 2022 07:12:20 -0400
X-MC-Unique: F3hQj6-zPDKIMnkKeznyyw-1
Received: by mail-pl1-f200.google.com with SMTP id w14-20020a1709027b8e00b0015386056d2bso2550406pll.5
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 04:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YH4ciMW5tUx/onVoacl1F1J9+3r/TgfMvl44pZpJEz0=;
        b=Ae8QB9A/QIRGUn6DggkeQRXd9z9RQjli8oP6HirCYRR3zUrxsCDYqb5HgLaX9Kulz1
         lt7oCKOXMK+PP1tEBs/gCuSxRimEwx9pFRtlLZtua6K3XmNT/kRJl+ujn5UGeXTfcTqi
         VWLqoBaK0V29BK4QZfXGLEDFbhtkFtdJVeQXfKg/i4Rjgg2eyz+KzC9mIy8keYcDCcL7
         fXpw37VqltoRFv49WZTm9s06cjrfRAR1bV8EqUKp5dXVbQv4Tf14L3RRS7GydSGt8aO6
         3s4qKzEVkOPpoBzqh/kSVL0Gad05Uxv5EQlxarBY9mt4c9Xn9DgmHM1TRAiIrnURVkUr
         ai5A==
X-Gm-Message-State: AOAM5339muPlhD1HdcuQmJcOWxFLboSpnkh/PJHlFvASNLzt/Yb4Lobq
        0wG12YOVC02QRxYgDYWCy5g6LR8vi19C5Ro4ibxX9KyQTsvoU8tV9QuI8APEu+3faSP7p9XMJGm
        LMApyxAjp4cSMGaMZikQuuA==
X-Received: by 2002:a17:902:8e82:b0:151:6f68:7088 with SMTP id bg2-20020a1709028e8200b001516f687088mr28484103plb.11.1647342739119;
        Tue, 15 Mar 2022 04:12:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyThs0RvfgAzoyoheDQDMCiWkfaoDfwHblMlG3/+uIS0Kcw7xzY9hm/SLrQSEoHmHVE+KaVzw==
X-Received: by 2002:a17:902:8e82:b0:151:6f68:7088 with SMTP id bg2-20020a1709028e8200b001516f687088mr28484050plb.11.1647342738493;
        Tue, 15 Mar 2022 04:12:18 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b004e1bea9c582sm24463077pfj.43.2022.03.15.04.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 04:12:17 -0700 (PDT)
Subject: Re: [PATCH 0/3] ceph: support for sparse read in msgr2 crc path
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
References: <20220309123323.20593-1-jlayton@kernel.org>
 <f9ee2a7d-f8da-6056-c659-6f7c168cd93b@redhat.com>
 <5016766a07f38d16e6fea66b2ad9da7076bf4a9b.camel@kernel.org>
 <61be495f-c54e-42dc-27e8-8ffb3dfcb415@redhat.com>
 <7e115f2fb22ba5335ed247eb6f30a1fec1654d1b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d4b920c6-6afe-4506-77d4-0e6415a894ad@redhat.com>
Date:   Tue, 15 Mar 2022 19:12:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7e115f2fb22ba5335ed247eb6f30a1fec1654d1b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/15/22 7:10 PM, Jeff Layton wrote:
> On Tue, 2022-03-15 at 19:03 +0800, Xiubo Li wrote:
>> On 3/15/22 6:12 PM, Jeff Layton wrote:
>>> On Tue, 2022-03-15 at 14:23 +0800, Xiubo Li wrote:
>>>> Hi Jeff,
>>>>
>>>> I hit the following crash by using the latest wip-fscrypt branch:
>>>>
>>>> <5>[245348.815462] Key type ceph unregistered
>>>> <5>[245545.560567] Key type ceph registered
>>>> <6>[245545.566723] libceph: loaded (mon/osd proto 15/24)
>>>> <6>[245545.775116] ceph: loaded (mds proto 32)
>>>> <6>[245545.822200] libceph: mon2 (1)10.72.47.117:40843 session established
>>>> <6>[245545.829658] libceph: client5000 fsid
>>>> 2b9c5f33-3f43-4f89-945d-2a1b6372c5af
>>>> <4>[245583.531648] ------------[ cut here ]------------
>>>> <2>[245583.531701] kernel BUG at net/ceph/messenger.c:1032!
>>>> <4>[245583.531929] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
>>>> <4>[245583.532030] CPU: 2 PID: 283539 Comm: kworker/2:0 Tainted:
>>>> G            E     5.17.0-rc6+ #98
>>>> <4>[245583.532050] Hardware name: Red Hat RHEV Hypervisor, BIOS
>>>> 1.11.0-2.el7 04/01/2014
>>>> <4>[245583.532086] Workqueue: ceph-msgr ceph_con_workfn [libceph]
>>>> <4>[245583.532380] RIP: 0010:ceph_msg_data_cursor_init+0x79/0x80 [libceph]
>>>> <4>[245583.532592] Code: 8d 7b 08 e8 39 99 00 dc 48 8d 7b 18 48 89 6b 08
>>>> e8 ec 97 00 dc c7 43 18 00 00 00 00 48 89 df 5b 5d 41 5c e9 89 c7 ff ff
>>>> 0f 0b <0f> 0b 0f 0b 0f 1f 00 0f 1f 44 00 00 41 57 41 56 41 55 49 89 cd 41
>>>> <4>[245583.532609] RSP: 0018:ffffc90018847c10 EFLAGS: 00010287
>>>> <4>[245583.532654] RAX: 0000000000000000 RBX: ffff888244ff3850 RCX:
>>>> ffffffffc10bd850
>>>> <4>[245583.532683] RDX: dffffc0000000000 RSI: ffff888244ff37d0 RDI:
>>>> ffff888244ff3838
>>>> <4>[245583.532705] RBP: ffff888244ff37d0 R08: 00000000000000d1 R09:
>>>> ffffed10489fe701
>>>> <4>[245583.532726] R10: ffff888244ff3804 R11: ffffed10489fe700 R12:
>>>> 00000000000000d1
>>>> <4>[245583.532746] R13: ffff8882d1adb030 R14: ffff8882d1adb408 R15:
>>>> 0000000000000000
>>>> <4>[245583.532764] FS:  0000000000000000(0000) GS:ffff8887ccd00000(0000)
>>>> knlGS:0000000000000000
>>>> <4>[245583.532785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> <4>[245583.532797] CR2: 00007fb991665000 CR3: 0000000368ebe001 CR4:
>>>> 00000000007706e0
>>>> <4>[245583.532809] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>>> 0000000000000000
>>>> <4>[245583.532820] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>>> 0000000000000400
>>>> <4>[245583.532831] PKRU: 55555554
>>>> <4>[245583.532840] Call Trace:
>>>> <4>[245583.532852]  <TASK>
>>>> <4>[245583.532863]  ceph_con_v1_try_read+0xd21/0x15c0 [libceph]
>>>> <4>[245583.533124]  ? ceph_tcp_sendpage+0x100/0x100 [libceph]
>>>> <4>[245583.533348]  ? load_balance+0x1240/0x1240
>>>> <4>[245583.533655]  ? dequeue_entity+0x18b/0x6f0
>>>> <4>[245583.533690]  ? mutex_lock+0x8e/0xe0
>>>> <4>[245583.533869]  ? __mutex_lock_slowpath+0x10/0x10
>>>> <4>[245583.533887]  ? _raw_spin_unlock+0x16/0x30
>>>> <4>[245583.533906]  ? __switch_to+0x2fa/0x690
>>>> <4>[245583.534007]  ceph_con_workfn+0x545/0x940 [libceph]
>>>> <4>[245583.534234]  process_one_work+0x3c1/0x6e0
>>>> <4>[245583.534340]  worker_thread+0x57/0x580
>>>> <4>[245583.534363]  ? process_one_work+0x6e0/0x6e0
>>>> <4>[245583.534382]  kthread+0x160/0x190
>>>> <4>[245583.534421]  ? kthread_complete_and_exit+0x20/0x20
>>>> <4>[245583.534477]  ret_from_fork+0x1f/0x30
>>>> <4>[245583.534544]  </TASK>
>>>> ...
>>>>
>>>> <4>[245583.535413] RIP: 0010:ceph_msg_data_cursor_init+0x79/0x80 [libceph]
>>>> <4>[245583.535627] Code: 8d 7b 08 e8 39 99 00 dc 48 8d 7b 18 48 89 6b 08
>>>> e8 ec 97 00 dc c7 43 18 00 00 00 00 48 89 df 5b 5d 41 5c e9 89 c7 ff ff
>>>> 0f 0b <0f> 0b 0f 0b 0f 1f 00 0f 1f 44 00 00 41 57 41 56 41 55 49 89 cd 41
>>>> <4>[245583.535644] RSP: 0018:ffffc90018847c10 EFLAGS: 00010287
>>>> <4>[245583.535720] RAX: 0000000000000000 RBX: ffff888244ff3850 RCX:
>>>> ffffffffc10bd850
>>>> <4>[245583.535745] RDX: dffffc0000000000 RSI: ffff888244ff37d0 RDI:
>>>> ffff888244ff3838
>>>> <4>[245583.535769] RBP: ffff888244ff37d0 R08: 00000000000000d1 R09:
>>>> ffffed10489fe701
>>>>
>>>> Seems caused by the parse read ?
>>>>
>>>>
>>> You mean sparse read? Those patches aren't in the wip-fscrypt branch
>>> yet, so I wouldn't think them a factor here. What commit was at the top
>>> of your branch?
>>>
>>> If you're testing the latest sparse read patches on top of wip-fscrypt,
>>> then those only work with msgr2 so far. Using msgr1 with it is likely to
>>> have problems.
>> Okay, it seems another patch series. But I am not sure, this is the
>> latest commits in the wip-fscrypt branch I hit the issue:
>>
>>
>> ce03ef535e7b SQUASH: OSD
>> 5020f1a5464b ceph: convert to sparse reads
>> 8614b45d3758 libceph: add sparse read support to OSD client
>> a11c3b2673aa libceph: add sparse read support to msgr2 crc state machine
>> a020a702a220 (origin/testing) ceph: allow `ceph.dir.rctime' xattr to be
>> updatable
>>
>> I just switched back to the branch I pulled days ago, it works well:
>>
>> Yeah, I am using the '--msgr1'. Maybe this is a problem. I will try
>> '--msgr2' later.
>>
> That makes sense. That oops is probably expected with msgr1 and the
> sparse read code. If you test with "-o ms_mode=crc" then it should
> (hopefully!) work.

Sure.


> My plan is eventually to add support to all 3 msgr codepaths (v1, v2-
> crc, and v2-secure), but I'd like some feedback from Ilya on what I have
> so far before I do that.
>
I will help test your related patches tomorrow.

- Xiubo


