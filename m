Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DB822AA32
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jul 2020 09:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGWH60 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jul 2020 03:58:26 -0400
Received: from mail1.windriver.com ([147.11.146.13]:35700 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgGWH60 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jul 2020 03:58:26 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id 06N7w41n029713
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Thu, 23 Jul 2020 00:58:04 -0700 (PDT)
Received: from pek-qzhang2-d1.wrs.com (128.224.162.183) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Jul 2020 00:57:51 -0700
From:   <qiang.zhang@windriver.com>
To:     <jlayton@kernel.org>, <idryomov@gmail.com>, <xiubli@redhat.com>
CC:     <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ceph: KASAN: use-after-free Read in ceph_mdsc_destroy
Date:   Thu, 23 Jul 2020 15:57:49 +0800
Message-ID: <20200723075749.13043-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Zhang Qiang <qiang.zhang@windriver.com>

When the mdsc ptr is free, we should assign "thefsc->mdsc" a null ptr,
in ceph_mdsc_init func.

CPU: 0 PID: 15653 Comm: syz-executor.3 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436
 mm/kasan/report.c:383
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
page:ffffea0002792080 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 head:ffffea0002792080 order:1 compound_mapcount:0
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

Fixes: f9009efac49c ("ceph: add dentry lease metric support")

Reported-by: syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com
Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
---
 fs/ceph/mds_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a50497142e59..6d819c285b05 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4420,6 +4420,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	kfree(mdsc->mdsmap);
 err_mdsc:
 	kfree(mdsc);
+	fsc->mdsc = NULL;
 	return err;
 }
 
-- 
2.17.1

