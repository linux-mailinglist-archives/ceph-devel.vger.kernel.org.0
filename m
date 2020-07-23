Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC69522ACC7
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jul 2020 12:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgGWKm7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jul 2020 06:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgGWKm7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 06:42:59 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEB4620737;
        Thu, 23 Jul 2020 10:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595500978;
        bh=GBRxJ6H2k4FHDEnHVdMGAYhL7f9A7VsMZgKQ83jWbms=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EhJDnzeZs3Zi3PA2QCxCwJBwZKCv3kagy2Q6zJjLej7yD1In4tl/+bZFg8gx+0fIf
         WWRePDROJ3ymi6F6bA6nlp2lVM9FOn0ITSTmAqOZoNYQ0T67isaT9ivHf5ucQZd+px
         42HSLNTccmdxQMxaoQc/rR7H378TVQagexzJz3g4=
Message-ID: <1eec2dce35d8b0ca1e35e001719072e9a5f788ce.camel@kernel.org>
Subject: Re: [PATCH] ceph: KASAN: use-after-free Read in ceph_mdsc_destroy
From:   Jeff Layton <jlayton@kernel.org>
To:     qiang.zhang@windriver.com, idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 23 Jul 2020 06:42:56 -0400
In-Reply-To: <20200723075749.13043-1-qiang.zhang@windriver.com>
References: <20200723075749.13043-1-qiang.zhang@windriver.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-07-23 at 15:57 +0800, qiang.zhang@windriver.com wrote:
> From: Zhang Qiang <qiang.zhang@windriver.com>
> 
> When the mdsc ptr is free, we should assign "thefsc->mdsc" a null ptr,
> in ceph_mdsc_init func.
> 
> CPU: 0 PID: 15653 Comm: syz-executor.3 Not tainted 5.8.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xae/0x436
>  mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>  timer_is_static_object+0x7a/0x90 kernel/time/timer.c:611
>  debug_object_assert_init lib/debugobjects.c:866 [inline]
>  debug_object_assert_init+0x1df/0x2e0 lib/debugobjects.c:841
>  debug_timer_assert_init kernel/time/timer.c:728 [inline]
>  debug_assert_init kernel/time/timer.c:773 [inline]
>  del_timer+0x6d/0x110 kernel/time/timer.c:1196
>  try_to_grab_pending kernel/workqueue.c:1249 [inline]
>  __cancel_work_timer+0x12d/0x700 kernel/workqueue.c:3092
>  ceph_mdsc_stop fs/ceph/mds_client.c:4660 [inline]
>  ceph_mdsc_destroy+0x50/0x140 fs/ceph/mds_client.c:4679
>  destroy_fs_client+0x13/0x200 fs/ceph/super.c:720
>  ceph_get_tree+0x9e5/0x1660 fs/ceph/super.c:1110
>  vfs_get_tree+0x89/0x2f0 fs/super.c:1547
>  do_new_mount fs/namespace.c:2875 [inline]
>  do_mount+0x1592/0x1fe0 fs/namespace.c:3200
>  __do_sys_mount fs/namespace.c:3410 [inline]
>  __se_sys_mount fs/namespace.c:3387 [inline]
>  __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
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
>  save_stack+0x1b/0x40 mm/kasan/common.c:48
>  set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
>  kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
>  kmalloc include/linux/slab.h:555 [inline]
>  kzalloc include/linux/slab.h:669 [inline]
>  ceph_mdsc_init+0x47/0xf10 fs/ceph/mds_client.c:4351
>  ceph_get_tree+0x4fe/0x1660 fs/ceph/super.c:1063
>  vfs_get_tree+0x89/0x2f0 fs/super.c:1547
>  do_new_mount fs/namespace.c:2875 [inline]
>  do_mount+0x1592/0x1fe0 fs/namespace.c:3200
>  __do_sys_mount fs/namespace.c:3410 [inline]
>  __se_sys_mount fs/namespace.c:3387 [inline]
>  __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Freed by task 15653:
>  save_stack+0x1b/0x40 mm/kasan/common.c:48
>  set_track mm/kasan/common.c:56 [inline]
>  kasan_set_free_info mm/kasan/common.c:316 [inline]
>  __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
>  __cache_free mm/slab.c:3426 [inline]
>  kfree+0x103/0x2c0 mm/slab.c:3757
>  ceph_mdsc_init+0xc64/0xf10 fs/ceph/mds_client.c:4422
>  ceph_get_tree+0x4fe/0x1660 fs/ceph/super.c:1063
>  vfs_get_tree+0x89/0x2f0 fs/super.c:1547
>  do_new_mount fs/namespace.c:2875 [inline]
>  do_mount+0x1592/0x1fe0 fs/namespace.c:3200
>  __do_sys_mount fs/namespace.c:3410 [inline]
>  __se_sys_mount fs/namespace.c:3387 [inline]
>  __x64_sys_mount+0x18f/0x230 fs/namespace.c:3387
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The buggy address belongs to the object at ffff88809e482000
>  which belongs to the cache kmalloc-4k of size 4096
> The buggy address is located 896 bytes inside of
>  4096-byte region [ffff88809e482000, ffff88809e483000)
> The buggy address belongs to the page:
> page:ffffea0002792080 refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 head:ffffea0002792080 order:1 compound_mapcount:0
> flags: 0xfffe0000010200(slab|head)
> raw: 00fffe0000010200 ffffea0002792008 ffffea000241dc08 ffff8880aa002000
> raw: 0000000000000000 ffff88809e482000 0000000100000001 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff88809e482280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88809e482300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff88809e482380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                    ^
>  ffff88809e482400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88809e482480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 
> Fixes: f9009efac49c ("ceph: add dentry lease metric support")
> 
> Reported-by: syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com
> Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
> ---
>  fs/ceph/mds_client.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a50497142e59..6d819c285b05 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4420,6 +4420,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  	kfree(mdsc->mdsmap);
>  err_mdsc:
>  	kfree(mdsc);
> +	fsc->mdsc = NULL;
>  	return err;
>  }
>  

Hi Qiang,

Thanks for the contribution. Xiubo just sent a patch for the same
problem, so I'm dropping this one.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

