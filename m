Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BEC22A8F5
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jul 2020 08:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgGWG1W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jul 2020 02:27:22 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:41853 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgGWG1V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jul 2020 02:27:21 -0400
Received: by mail-io1-f69.google.com with SMTP id n3so3414228iob.8
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jul 2020 23:27:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5S/81hsecrU3K+bhmVLmmLLHbSsTXsRoeQzbcVaqmy4=;
        b=BwPHq+iFph3cThns5y5r+Mwa3kbkdRBlbo1WLl9noW55B4hYmS6vwSUHjimz4Nz0Oe
         ofw7AK0SXiUzHaWqCtHscIoSidVp9XLBuFKCzkt3jx8fKFOzgZxrIPXO1kuhwgaVXavO
         FmE7s2eiARJeGrLFI9oysjI55rPXoLx+yoH1Cjfyq7E6t8DG5Ds/p120q3FSAs/uo1TN
         GwchBfBpSJngS38u5vMQ6Eo6ZMnG1AgZ6Z2hMba2JLvk0SHKKZVHjij2sWNy8id1QCJc
         jnOsXw0GHiDlRNLM4UtCGAEknxv14irIHPaLjgPNwIyX3BwKlmFoQNaA1IyCjilTmib8
         PwsQ==
X-Gm-Message-State: AOAM532pBgDSv+qQuQIQgH4P/Pabfxl0FgaprZ27mJuAkmXeZ98cG+pU
        4UCFHcQhggNVU9bwWTSu/NoEl7mH5ohZEo9A/Y+jAzofGv2s
X-Google-Smtp-Source: ABdhPJz7+sq71viipFnrK5clBmYXYSwzIk+JgW4gZYB3Ro+zPp+LQjjpZq4hRxJfQAfK+TtaC1optjMnrrX+C6oDMPLEEZHNkceh
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d51:: with SMTP id h17mr3636243ilj.131.1595485639492;
 Wed, 22 Jul 2020 23:27:19 -0700 (PDT)
Date:   Wed, 22 Jul 2020 23:27:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c94b1a05ab15f2ea@google.com>
Subject: KASAN: use-after-free Read in ceph_mdsc_destroy
From:   syzbot <syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f932d58a Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=152c6a80900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a160d1053fc89af5
dashboard link: https://syzkaller.appspot.com/bug?extid=b57f46d8d6ea51960b8c
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in timer_is_static_object+0x7a/0x90 kernel/time/timer.c:611
Read of size 8 at addr ffff88809e482380 by task syz-executor.3/15653

CPU: 0 PID: 15653 Comm: syz-executor.3 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 timer_is_static_object+0x7a/0x90 kernel/time/timer.c:611
 debug_object_assert_init lib/debugobjects.c:866 [inline]
 debug_object_assert_init+0x1df/0x2e0 lib/debugobjects.c:841
 debug_timer_assert_init kernel/time/timer.c:728 [inline]
 debug_assert_init kernel/time/timer.c:773 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1196
 try_to_grab_pending kernel/workqueue.c:1249 [inline]
 __cancel_work_timer+0x12d/0x700 kernel/workqueue.c:3092
 ceph_mdsc_stop fs/ceph/mds_client.c:4660 [inline]
 ceph_mdsc_destroy+0x50/0x140 fs/ceph/mds_client.c:4679
 destroy_fs_client+0x13/0x200 fs/ceph/super.c:720
 ceph_get_tree+0x9e5/0x1660 fs/ceph/super.c:1110
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2875 [inline]
 do_mount+0x1592/0x1fe0 fs/namespace.c:3200
 __do_sys_mount fs/namespace.c:3410 [inline]
 __se_sys_mount fs/namespace.c:3387 [inline]
 __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1d9
Code: Bad RIP value.
RSP: 002b:00007f33d2bc0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000000000001f400 RCX: 000000000045c1d9
RDX: 0000000020000140 RSI: 00000000200000c0 RDI: 00000000200005c0
RBP: 000000000078bf50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007fffaad3cc8f R14: 00007f33d2bc19c0 R15: 000000000078bf0c

Allocated by task 15653:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 ceph_mdsc_init+0x47/0xf10 fs/ceph/mds_client.c:4351
 ceph_get_tree+0x4fe/0x1660 fs/ceph/super.c:1063
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2875 [inline]
 do_mount+0x1592/0x1fe0 fs/namespace.c:3200
 __do_sys_mount fs/namespace.c:3410 [inline]
 __se_sys_mount fs/namespace.c:3387 [inline]
 __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 15653:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 ceph_mdsc_init+0xc64/0xf10 fs/ceph/mds_client.c:4422
 ceph_get_tree+0x4fe/0x1660 fs/ceph/super.c:1063
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2875 [inline]
 do_mount+0x1592/0x1fe0 fs/namespace.c:3200
 __do_sys_mount fs/namespace.c:3410 [inline]
 __se_sys_mount fs/namespace.c:3387 [inline]
 __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88809e482000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 896 bytes inside of
 4096-byte region [ffff88809e482000, ffff88809e483000)
The buggy address belongs to the page:
page:ffffea0002792080 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0002792080 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0002792008 ffffea000241dc08 ffff8880aa002000
raw: 0000000000000000 ffff88809e482000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809e482280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809e482300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88809e482380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88809e482400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809e482480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
