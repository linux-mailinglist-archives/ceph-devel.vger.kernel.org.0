Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A51E63F215
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Dec 2022 14:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiLANxp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Dec 2022 08:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiLANxj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Dec 2022 08:53:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60632662
        for <ceph-devel@vger.kernel.org>; Thu,  1 Dec 2022 05:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPFO29GQd/j2Vp43J7xE1lR/NgFVg47GjPDbYNdnXLA=;
        b=cBoNLwlR9cdXXjXVu8q9DIAEgW9nZdrGwy6+de0fS6eue9fkeBQVI8eusLn/jW+IAK8U2c
        FmghyM5ENha6qae77JgzEPL+a2bE/aFzDzpyuqp+r3q72KmVNBvjJsQo0NQ5A/a3F3eT2K
        Sc0jK1ztzgJ1I1wJIcedgXdlQqFH1Ec=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-167-ooGnZ1HHNaaf2L-9yucctA-1; Thu, 01 Dec 2022 08:52:46 -0500
X-MC-Unique: ooGnZ1HHNaaf2L-9yucctA-1
Received: by mail-pf1-f199.google.com with SMTP id z19-20020a056a001d9300b0056df4b6f421so2047817pfw.4
        for <ceph-devel@vger.kernel.org>; Thu, 01 Dec 2022 05:52:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PPFO29GQd/j2Vp43J7xE1lR/NgFVg47GjPDbYNdnXLA=;
        b=Kgma90+Fg1f1ZX8zy2SuVEx+qjgjMXl9cPl666YUDPoPnNslZB6Aa5IXNUcM0X+nXk
         1b9CwBXYpqht5JYSzLBRe6QsnYH889Xq1UiHUK9CspJJVK80FP+1pGV5Ge/LHcGyM7id
         bXHfukV5AkEOsjDTBoj5JlXzvakdystvGxVNvrkHZPwHWi5lO7vJsB+j0xBxaw7UYoDB
         O2Nb22HKskFjcc9Qc/CyHtQ9MKrd00+SJSgTGCUL9qwHP4PT7iCcXk8c8vP3etYpC6TA
         X6sm+6UeLlGOyS9DxK8nBQuGyEb2o2K5I2t6lvGV+eEbBKq3bESq8VFt1Wr0OX2qGrJJ
         u/zw==
X-Gm-Message-State: ANoB5pkpQy0ZrfOJru4tUirramPuZMjBt4h6LXqteFbP/BV7Ahl9ALDx
        yiBN+3KCyyms/fCpP88ig9lsUTp3ws2FUvsVVzTQcwpPAIMClfD2gbr9uSSbA+f1N2qQofxb4/Q
        J9kzRZMTZk2UWkYkvrdOnFA==
X-Received: by 2002:a17:90a:9e5:b0:219:5139:7fa8 with SMTP id 92-20020a17090a09e500b0021951397fa8mr13638314pjo.15.1669902765742;
        Thu, 01 Dec 2022 05:52:45 -0800 (PST)
X-Google-Smtp-Source: AA0mqf767EeDMuiN2qJzeApP6eTOleaiHwP4PMtAhg7LdfBxZxTIDRJOjD60RUTZzRT+GiyI21+0bA==
X-Received: by 2002:a17:90a:9e5:b0:219:5139:7fa8 with SMTP id 92-20020a17090a09e500b0021951397fa8mr13638289pjo.15.1669902765457;
        Thu, 01 Dec 2022 05:52:45 -0800 (PST)
Received: from [10.72.12.244] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902710800b001891ad6eadasm3610344pll.251.2022.12.01.05.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 05:52:45 -0800 (PST)
Subject: Re: [PATCH] ceph: make sure all the files successfully put before
 unmounting
To:     Ilya Dryomov <idryomov@gmail.com>, ebiggers@google.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
References: <20221201065800.18149-1-xiubli@redhat.com>
 <CAOi1vP8u7fenJyH02=O1R9Q+2CrsM2Q5thrnKFCMWH0HiGz9pA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c1b4f622-8cfc-a73d-02af-ba80474a5ed9@redhat.com>
Date:   Thu, 1 Dec 2022 21:52:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8u7fenJyH02=O1R9Q+2CrsM2Q5thrnKFCMWH0HiGz9pA@mail.gmail.com>
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


On 01/12/2022 21:04, Ilya Dryomov wrote:
> On Thu, Dec 1, 2022 at 7:58 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When close a file it will be deferred to call the fput(), which
>> will hold the inode's i_count. And when unmounting the mountpoint
>> the evict_inodes() may skip evicting some inodes.
>>
>> If encrypt is enabled the kernel generate a warning when removing
>> the encrypt keys when the skipped inodes still hold the keyring:
>>
>> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
>> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
>> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
>> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
>> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
>> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
>> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
>> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
>> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
>> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
>> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>> <TASK>
>> generic_shutdown_super+0x47/0x120
>> kill_anon_super+0x14/0x30
>> ceph_kill_sb+0x36/0x90 [ceph]
>> deactivate_locked_super+0x29/0x60
>> cleanup_mnt+0xb8/0x140
>> task_work_run+0x67/0xb0
>> exit_to_user_mode_prepare+0x23d/0x240
>> syscall_exit_to_user_mode+0x25/0x60
>> do_syscall_64+0x40/0x80
>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7fd83dc39e9b
>>
>> URL: https://tracker.ceph.com/issues/58126
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/super.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 3db6f95768a3..1f46db92e81f 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -9,6 +9,7 @@
>>   #include <linux/in6.h>
>>   #include <linux/module.h>
>>   #include <linux/mount.h>
>> +#include <linux/file.h>
>>   #include <linux/fs_context.h>
>>   #include <linux/fs_parser.h>
>>   #include <linux/sched.h>
>> @@ -1477,6 +1478,14 @@ static void ceph_kill_sb(struct super_block *s)
>>          ceph_mdsc_pre_umount(fsc->mdsc);
>>          flush_fs_workqueues(fsc);
>>
>> +       /*
>> +        * If the encrypt is enabled we need to make sure the delayed
>> +        * fput to finish, which will make sure all the inodes will
>> +        * be evicted before removing the encrypt keys.
>> +        */
>> +       if (s->s_master_keys)
>> +               flush_delayed_fput();
> Hi Xiubo,
>
> In the tracker ticket comments, you are wondering whether this
> is a generic fscrypt bug but then proceed with working around it
> in CephFS:
>
>> By reading the code it should be a bug in fs/crypto/ code. When
>> closing the file it will be delayed in kernel space by adding it into
>> the delayed_fput_list delay queue.
>> And if that queue is delayed for some reasons and when unmounting the
>> mountpoint it will skip evicting the corresponding inode in
>> evict_inodes(). So the fscrypt_put_encryption_info(), which will
>> decrease the mk->mk_active_refs reference count, will be missed. And
>> at last in generic_shutdown_super() will hit this warning.
>> Still reading the code to see whether could I fix this in ceph layer.
> If the root cause lies in fs/crypto, I'd rather see it fixed there
> than papered over in fs/ceph.

Hi Ilya,

I was thinking maybe we could move this code to generic_shutdown_super() 
just before evict_inode(). But I am not very sure whether the other 
filesystems have the same issue.

Eric,

What do you think ? Will that make sense ?

Thanks!

- Xiubo

> Thanks,
>
>                  Ilya
>
>> +
>>          kill_anon_super(s);
>>
>>          fsc->client->extra_mon_dispatch = NULL;
>> --
>> 2.31.1
>>

