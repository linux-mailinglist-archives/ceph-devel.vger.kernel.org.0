Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A551A4D948E
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 07:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345188AbiCOGZL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 02:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345186AbiCOGZJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 02:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3D705F8B
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 23:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647325437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uRB/8G7jsmT5DDceI/Qojw4MB86/QorNAkYi2Xr5UJ8=;
        b=aqGNYBMDVN+/lWqB1K1nkH7Qpi5YcKhQ+jwNIUZ8dWtFG8BkRQzAn36AGHiqLDJetdAVGf
        FhvAY3wzats5Wsog7ott+SBDIVZrOrEKys9M5K2OdJJ1XGMvWZkggJ7agPfYoLhGRuUwAc
        21wDIJpjPAQPKrtpAmJNTt8hV8G4CEw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-q8FlxyzLMZGQPcVl88QakQ-1; Tue, 15 Mar 2022 02:23:55 -0400
X-MC-Unique: q8FlxyzLMZGQPcVl88QakQ-1
Received: by mail-pj1-f69.google.com with SMTP id s20-20020a17090ad49400b001bf481fae01so865844pju.1
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 23:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uRB/8G7jsmT5DDceI/Qojw4MB86/QorNAkYi2Xr5UJ8=;
        b=g4rGYtGyDx8ftKZ7CUJAt1zCR8j4GoI24Gu4Krwv+tNnMroSiXU6qxtj7DWB/9G5Qk
         YOTft8EWdMQvSH8M6h7Xb1tIcqCZMinePPiV+uoFLPV/AM9Sn1UB3vzCm71RKwaSMASt
         Kp0spA9OjP8njTgMfWaEgSmJYO/8Xaytnf0fx5/bHHz819mCR6DKieMgfKLkgO2TJ2dA
         Ch57MPQ2xvwus9cxekFw+3NzEUjc2gBpF7FmYVb+iBxUu60Ly3spgaBflD6tWOfOhYtL
         czd0hdDvL62LVbnTWriWD/FId9KnVlh+DgNvTgXMOo8QpoaT2V2tfaSoyDo2OcoJCVDP
         AQ+g==
X-Gm-Message-State: AOAM531cI3ytslxEhYZl/bC7ila/vmCObth6SKg/UkC7RQU0GvAr/qKR
        dZJBstT+0wgx9i205RJ+CuFKBeChr+rVtPPwfuwmbsRRqifH6FKgOj7k6ZtbmKTSIRVgqaTQHSS
        6SICBfojKmAlwH3G+lX/xeQ==
X-Received: by 2002:a17:902:a40f:b0:14b:61:b19e with SMTP id p15-20020a170902a40f00b0014b0061b19emr26541321plq.20.1647325433450;
        Mon, 14 Mar 2022 23:23:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziDXpT2Awqd792CiMPkXwov1xASL2P20CUaSen02Ztaqk+78kRB38eKu/Rg08q5AFYGWYN9g==
X-Received: by 2002:a17:902:a40f:b0:14b:61:b19e with SMTP id p15-20020a170902a40f00b0014b0061b19emr26541310plq.20.1647325433156;
        Mon, 14 Mar 2022 23:23:53 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o65-20020a17090a0a4700b001bef5cffea7sm1803071pjo.0.2022.03.14.23.23.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 23:23:52 -0700 (PDT)
Subject: Re: [PATCH 0/3] ceph: support for sparse read in msgr2 crc path
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
References: <20220309123323.20593-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f9ee2a7d-f8da-6056-c659-6f7c168cd93b@redhat.com>
Date:   Tue, 15 Mar 2022 14:23:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220309123323.20593-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
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

Hi Jeff,

I hit the following crash by using the latest wip-fscrypt branch:

<5>[245348.815462] Key type ceph unregistered
<5>[245545.560567] Key type ceph registered
<6>[245545.566723] libceph: loaded (mon/osd proto 15/24)
<6>[245545.775116] ceph: loaded (mds proto 32)
<6>[245545.822200] libceph: mon2 (1)10.72.47.117:40843 session established
<6>[245545.829658] libceph: client5000 fsid 
2b9c5f33-3f43-4f89-945d-2a1b6372c5af
<4>[245583.531648] ------------[ cut here ]------------
<2>[245583.531701] kernel BUG at net/ceph/messenger.c:1032!
<4>[245583.531929] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
<4>[245583.532030] CPU: 2 PID: 283539 Comm: kworker/2:0 Tainted: 
G            E     5.17.0-rc6+ #98
<4>[245583.532050] Hardware name: Red Hat RHEV Hypervisor, BIOS 
1.11.0-2.el7 04/01/2014
<4>[245583.532086] Workqueue: ceph-msgr ceph_con_workfn [libceph]
<4>[245583.532380] RIP: 0010:ceph_msg_data_cursor_init+0x79/0x80 [libceph]
<4>[245583.532592] Code: 8d 7b 08 e8 39 99 00 dc 48 8d 7b 18 48 89 6b 08 
e8 ec 97 00 dc c7 43 18 00 00 00 00 48 89 df 5b 5d 41 5c e9 89 c7 ff ff 
0f 0b <0f> 0b 0f 0b 0f 1f 00 0f 1f 44 00 00 41 57 41 56 41 55 49 89 cd 41
<4>[245583.532609] RSP: 0018:ffffc90018847c10 EFLAGS: 00010287
<4>[245583.532654] RAX: 0000000000000000 RBX: ffff888244ff3850 RCX: 
ffffffffc10bd850
<4>[245583.532683] RDX: dffffc0000000000 RSI: ffff888244ff37d0 RDI: 
ffff888244ff3838
<4>[245583.532705] RBP: ffff888244ff37d0 R08: 00000000000000d1 R09: 
ffffed10489fe701
<4>[245583.532726] R10: ffff888244ff3804 R11: ffffed10489fe700 R12: 
00000000000000d1
<4>[245583.532746] R13: ffff8882d1adb030 R14: ffff8882d1adb408 R15: 
0000000000000000
<4>[245583.532764] FS:  0000000000000000(0000) GS:ffff8887ccd00000(0000) 
knlGS:0000000000000000
<4>[245583.532785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[245583.532797] CR2: 00007fb991665000 CR3: 0000000368ebe001 CR4: 
00000000007706e0
<4>[245583.532809] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
<4>[245583.532820] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
<4>[245583.532831] PKRU: 55555554
<4>[245583.532840] Call Trace:
<4>[245583.532852]  <TASK>
<4>[245583.532863]  ceph_con_v1_try_read+0xd21/0x15c0 [libceph]
<4>[245583.533124]  ? ceph_tcp_sendpage+0x100/0x100 [libceph]
<4>[245583.533348]  ? load_balance+0x1240/0x1240
<4>[245583.533655]  ? dequeue_entity+0x18b/0x6f0
<4>[245583.533690]  ? mutex_lock+0x8e/0xe0
<4>[245583.533869]  ? __mutex_lock_slowpath+0x10/0x10
<4>[245583.533887]  ? _raw_spin_unlock+0x16/0x30
<4>[245583.533906]  ? __switch_to+0x2fa/0x690
<4>[245583.534007]  ceph_con_workfn+0x545/0x940 [libceph]
<4>[245583.534234]  process_one_work+0x3c1/0x6e0
<4>[245583.534340]  worker_thread+0x57/0x580
<4>[245583.534363]  ? process_one_work+0x6e0/0x6e0
<4>[245583.534382]  kthread+0x160/0x190
<4>[245583.534421]  ? kthread_complete_and_exit+0x20/0x20
<4>[245583.534477]  ret_from_fork+0x1f/0x30
<4>[245583.534544]  </TASK>
...

<4>[245583.535413] RIP: 0010:ceph_msg_data_cursor_init+0x79/0x80 [libceph]
<4>[245583.535627] Code: 8d 7b 08 e8 39 99 00 dc 48 8d 7b 18 48 89 6b 08 
e8 ec 97 00 dc c7 43 18 00 00 00 00 48 89 df 5b 5d 41 5c e9 89 c7 ff ff 
0f 0b <0f> 0b 0f 0b 0f 1f 00 0f 1f 44 00 00 41 57 41 56 41 55 49 89 cd 41
<4>[245583.535644] RSP: 0018:ffffc90018847c10 EFLAGS: 00010287
<4>[245583.535720] RAX: 0000000000000000 RBX: ffff888244ff3850 RCX: 
ffffffffc10bd850
<4>[245583.535745] RDX: dffffc0000000000 RSI: ffff888244ff37d0 RDI: 
ffff888244ff3838
<4>[245583.535769] RBP: ffff888244ff37d0 R08: 00000000000000d1 R09: 
ffffed10489fe701

Seems caused by the parse read ?



On 3/9/22 8:33 PM, Jeff Layton wrote:
> This patchset is a revised version of the one I sent a couple of weeks
> ago. This adds support for sparse reads to libceph, and changes cephfs
> over to use instead of non-sparse reads. The sparse read codepath is a
> drop in replacement for regular reads, so the upper layers should be
> able to use it interchangeibly.
>
> This is necessary for the (ongoing) fscrypt work. We need to know which
> regions in a file are actually sparse so that we can avoid decrypting
> them.
>
> The next step is to add the same support to the msgr2 secure codepath.
> Currently that code sets up a scatterlist with the final destination
> data pages in it and passes that to the decrypt routine so that the
> decrypted data is written directly to the destination.
>
> My thinking here is to change that to decrypt the data in-place for
> sparse reads, and then we'll just parse the decrypted buffer via
> calling sparse_read and copy the data into the right places.
>
> Ilya, does that sound sane? Is it OK to pass gcm_crypt two different
> scatterlists with a region that overlaps?
>
> Jeff Layton (3):
>    libceph: add sparse read support to msgr2 crc state machine
>    libceph: add sparse read support to OSD client
>    ceph: convert to sparse reads
>
>   fs/ceph/addr.c                  |   2 +-
>   fs/ceph/file.c                  |   4 +-
>   include/linux/ceph/messenger.h  |  31 +++++
>   include/linux/ceph/osd_client.h |  38 ++++++
>   net/ceph/messenger.c            |   1 +
>   net/ceph/messenger_v2.c         | 215 ++++++++++++++++++++++++++++++--
>   net/ceph/osd_client.c           | 163 ++++++++++++++++++++++--
>   7 files changed, 435 insertions(+), 19 deletions(-)
>

