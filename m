Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69F922A97F
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jul 2020 09:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgGWHVh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jul 2020 03:21:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725862AbgGWHVg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jul 2020 03:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595488894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2/j5LCLRfI78lIL3c01S9MpTseQpaURXpj/iLeTz5M=;
        b=MjFFPg8Cym8aVU2u0GTtc1eZ/GsCBBa2cOBT/xGc6dBfU3yQJlop8r/RynHehZnwu77gq2
        molQ+11vROMnhOywyLJ0Jhh67eO6mvu32FdQ/G9gY+sJbKGQovYinPaN+BRQbi0GifgPY/
        Cf/5NlATXQsycVk46aSjZ3YO4p1W1jE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-Py-LZZfGNYebfwvAfcEq6w-1; Thu, 23 Jul 2020 03:21:29 -0400
X-MC-Unique: Py-LZZfGNYebfwvAfcEq6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B3AB100AA21;
        Thu, 23 Jul 2020 07:21:27 +0000 (UTC)
Received: from [10.72.12.99] (ovpn-12-99.pek2.redhat.com [10.72.12.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 318DF60CC0;
        Thu, 23 Jul 2020 07:21:24 +0000 (UTC)
Subject: Re: KASAN: use-after-free Read in ceph_mdsc_destroy
To:     syzbot <syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com>,
        ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000c94b1a05ab15f2ea@google.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <049d6d67-7df6-ed36-43ad-ed18bbc14682@redhat.com>
Date:   Thu, 23 Jul 2020 15:21:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000c94b1a05ab15f2ea@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/23 14:27, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    f932d58a Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=152c6a80900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a160d1053fc89af5
> dashboard link: https://syzkaller.appspot.com/bug?extid=b57f46d8d6ea51960b8c
> compiler:       gcc (GCC) 10.1.0-syz 20200507
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in timer_is_static_object+0x7a/0x90 kernel/time/timer.c:611
> Read of size 8 at addr ffff88809e482380 by task syz-executor.3/15653

If the ceph_mdsc_init() fails, it will free the mdsc already. After 
freed we should set it to NULL.

I will fix it.

Thanks for reporting.



> CPU: 0 PID: 15653 Comm: syz-executor.3 Not tainted 5.8.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x18f/0x20d lib/dump_stack.c:118
>   print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
>   __kasan_report mm/kasan/report.c:513 [inline]
>   kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>   timer_is_static_object+0x7a/0x90 kernel/time/timer.c:611
>   debug_object_assert_init lib/debugobjects.c:866 [inline]
>   debug_object_assert_init+0x1df/0x2e0 lib/debugobjects.c:841
>   debug_timer_assert_init kernel/time/timer.c:728 [inline]
>   debug_assert_init kernel/time/timer.c:773 [inline]
>   del_timer+0x6d/0x110 kernel/time/timer.c:1196
>   try_to_grab_pending kernel/workqueue.c:1249 [inline]
>   __cancel_work_timer+0x12d/0x700 kernel/workqueue.c:3092
>   ceph_mdsc_stop fs/ceph/mds_client.c:4660 [inline]
>   ceph_mdsc_destroy+0x50/0x140 fs/ceph/mds_client.c:4679
>   destroy_fs_client+0x13/0x200 fs/ceph/super.c:720
>   ceph_get_tree+0x9e5/0x1660 fs/ceph/super.c:1110
>   vfs_get_tree+0x89/0x2f0 fs/super.c:1547
>   do_new_mount fs/namespace.c:2875 [inline]
>   do_mount+0x1592/0x1fe0 fs/namespace.c:3200
>   __do_sys_mount fs/namespace.c:3410 [inline]
>   __se_sys_mount fs/namespace.c:3387 [inline]
>   __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
>   do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45c1d9
> Code: Bad RIP value.
> RSP: 002b:00007f33d2bc0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 000000000001f400 RCX: 000000000045c1d9
> RDX: 0000000020000140 RSI: 00000000200000c0 RDI: 00000000200005c0
> RBP: 000000000078bf50 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
> R13: 00007fffaad3cc8f R14: 00007f33d2bc19c0 R15: 000000000078bf0c
>
> Allocated by task 15653:
>   save_stack+0x1b/0x40 mm/kasan/common.c:48
>   set_track mm/kasan/common.c:56 [inline]
>   __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
>   kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
>   kmalloc include/linux/slab.h:555 [inline]
>   kzalloc include/linux/slab.h:669 [inline]
>   ceph_mdsc_init+0x47/0xf10 fs/ceph/mds_client.c:4351
>   ceph_get_tree+0x4fe/0x1660 fs/ceph/super.c:1063
>   vfs_get_tree+0x89/0x2f0 fs/super.c:1547
>   do_new_mount fs/namespace.c:2875 [inline]
>   do_mount+0x1592/0x1fe0 fs/namespace.c:3200
>   __do_sys_mount fs/namespace.c:3410 [inline]
>   __se_sys_mount fs/namespace.c:3387 [inline]
>   __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
>   do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Freed by task 15653:
>   save_stack+0x1b/0x40 mm/kasan/common.c:48
>   set_track mm/kasan/common.c:56 [inline]
>   kasan_set_free_info mm/kasan/common.c:316 [inline]
>   __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
>   __cache_free mm/slab.c:3426 [inline]
>   kfree+0x103/0x2c0 mm/slab.c:3757
>   ceph_mdsc_init+0xc64/0xf10 fs/ceph/mds_client.c:4422
>   ceph_get_tree+0x4fe/0x1660 fs/ceph/super.c:1063
>   vfs_get_tree+0x89/0x2f0 fs/super.c:1547
>   do_new_mount fs/namespace.c:2875 [inline]
>   do_mount+0x1592/0x1fe0 fs/namespace.c:3200
>   __do_sys_mount fs/namespace.c:3410 [inline]
>   __se_sys_mount fs/namespace.c:3387 [inline]
>   __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
>   do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> The buggy address belongs to the object at ffff88809e482000
>   which belongs to the cache kmalloc-4k of size 4096
> The buggy address is located 896 bytes inside of
>   4096-byte region [ffff88809e482000, ffff88809e483000)
> The buggy address belongs to the page:
> page:ffffea0002792080 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0002792080 order:1 compound_mapcount:0
> flags: 0xfffe0000010200(slab|head)
> raw: 00fffe0000010200 ffffea0002792008 ffffea000241dc08 ffff8880aa002000
> raw: 0000000000000000 ffff88809e482000 0000000100000001 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff88809e482280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88809e482300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff88809e482380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                     ^
>   ffff88809e482400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88809e482480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>

