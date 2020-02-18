Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB7916246A
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 11:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgBRKU5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 05:20:57 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40593 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgBRKU4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 05:20:56 -0500
Received: by mail-io1-f65.google.com with SMTP id x1so10243686iop.7
        for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2020 02:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yJO3POXjp/JhYy0VJ6n7biN6JMpWqigVrO4BvYAdO1w=;
        b=A4U/HqqwqM93SSWDsbKcko+UUe0mXABnyPJpJljZAR4kQhZdXg6BSILgwDyJ1yt4YV
         0IlL0Ca4ILnpO7EepfOB9AvubhjmHyelEYB6nmWppuHHKBHrWIQuIREdh9rWvEQm1fU+
         g4CYWTgNWu6/gsn9q8Rmog7S82pUdZOVR00VZcQdNDEczb/xbznGfyPOSAKul0U7VBc8
         Ju/ZcHvd54KkGxGz6ktmmmq+Ued0D1umMw+ijgQ8ylL4Ygov1SqzWVge7MV+In4YJAhV
         8bzWt/vcV10gQXzQ345lJXzfulDJNWZuwWIXGjpTigothuYYLigyOMA9FdKy1xu201Ui
         GeFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yJO3POXjp/JhYy0VJ6n7biN6JMpWqigVrO4BvYAdO1w=;
        b=SEOLBcSd0l3Sf3swdTmNQZYJbA1Ur4GuC3jx1ZN8UbnN307n3meQxEqfsc7S8+6URP
         YXLQ9ZQK/ORK/2zme7asfxfeajPmFUHQtKcTBui1Mj3gQttZcfI/IvKZabrXvZXx6ncy
         rW4Fe0udPdBtqxBjvaEqaGN1M/ZAqHDoorVbVZrONRJ3jbZbiOta3qI2E+TOX6uNbrps
         T/MhHL2K05NmQ5g5HWY19UpNLKaKL4onaLhHs2LGjqG2aQfa3TpvVMrSiWNou9yaIQkI
         1nYxnnoYSVotPgDusRlEKU8N8tScXdrdl92awS1fDTngCocjD06SFhYrM50Y/ZFYxMyQ
         pIAQ==
X-Gm-Message-State: APjAAAU/aC8B59FLEjK5ixwIRzQ1FWhujNfJ2lQfV8PUr9lGM6J2uV9f
        9QqKZSOMJt2VvMQnhv3gklE3CUwHmDTS27ki+lHcQWfpVA8=
X-Google-Smtp-Source: APXvYqw7kzswdVB4O3sCJUDRIaClteqiDf5gLHVSwKAuKBK/omTj6NeT5VQEp0HvwFC5u30cQDG1ULfh7dul2NaNoYE=
X-Received: by 2002:a6b:9188:: with SMTP id t130mr14209245iod.215.1582021255685;
 Tue, 18 Feb 2020 02:20:55 -0800 (PST)
MIME-Version: 1.0
References: <20200218033042.40047-1-xiubli@redhat.com>
In-Reply-To: <20200218033042.40047-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 18 Feb 2020 11:21:20 +0100
Message-ID: <CAOi1vP_nFEVUY+O-T_2WinyPGJvS_ciNXXZg3SwiyyfubWdPsw@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix use-after-free for the osdmap memory
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 18, 2020 at 4:30 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When there has new osdmap comes, it will replace and release
> the old osdmap memory, but if the mount is still on the way
> without the osdc->lock wrappers, we will hit use after free
> bug, like:
>
> <3>[ 3797.775970] BUG: KASAN: use-after-free in __ceph_open_session+0x2a9/0x370 [libceph]
> <3>[ 3797.775974] Read of size 4 at addr ffff8883d8b8a110 by task mount.ceph/64782
> <3>[ 3797.775975]
> <4>[ 3797.775980] CPU: 0 PID: 64782 Comm: mount.ceph Tainted: G            E     5.5.0+ #16
> <4>[ 3797.775982] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
> <4>[ 3797.775984] Call Trace:
> <4>[ 3797.775992]  dump_stack+0x8c/0xc0
> <4>[ 3797.775997]  print_address_description.constprop.0+0x1b/0x210
> <4>[ 3797.776029]  ? __ceph_open_session+0x2a9/0x370 [libceph]
> <4>[ 3797.776062]  ? __ceph_open_session+0x2a9/0x370 [libceph]
> <4>[ 3797.776065]  __kasan_report.cold+0x1a/0x33
> <4>[ 3797.776098]  ? __ceph_open_session+0x2a9/0x370 [libceph]
> <4>[ 3797.776101]  kasan_report+0xe/0x20
> <4>[ 3797.776133]  __ceph_open_session+0x2a9/0x370 [libceph]
> <4>[ 3797.776170]  ? ceph_reset_client_addr+0x30/0x30 [libceph]
> <4>[ 3797.776173]  ? _raw_spin_lock+0x7a/0xd0
> <4>[ 3797.776178]  ? finish_wait+0x100/0x100
> <4>[ 3797.776182]  ? __mutex_lock_slowpath+0x10/0x10
> <4>[ 3797.776227]  ceph_get_tree+0x65b/0xa40 [ceph]
> <4>[ 3797.776236]  vfs_get_tree+0x46/0x120
> <4>[ 3797.776240]  do_mount+0xa2c/0xd70
> <4>[ 3797.776245]  ? __list_add_valid+0x2f/0x60
> <4>[ 3797.776249]  ? copy_mount_string+0x20/0x20
> <4>[ 3797.776254]  ? __kasan_kmalloc.constprop.0+0xc2/0xd0
> <4>[ 3797.776258]  __x64_sys_mount+0xbe/0x100
> <4>[ 3797.776263]  do_syscall_64+0x73/0x210
> <4>[ 3797.776268]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> <4>[ 3797.776271] RIP: 0033:0x7f8f026e5b8e
> <4>[ 3797.776275] Code: 48 8b 0d fd 42 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ca 42 0c 00 f7 d8 64 89 01 48
> <4>[ 3797.776277] RSP: 002b:00007ffc2d7cccd8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> <4>[ 3797.776281] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8f026e5b8e
> <4>[ 3797.776283] RDX: 00005582afb2a558 RSI: 00007ffc2d7cef0d RDI: 00005582b01707a0
> <4>[ 3797.776285] RBP: 00007ffc2d7ccda0 R08: 00005582b0173250 R09: 0000000000000067
> <4>[ 3797.776287] R10: 0000000000000000 R11: 0000000000000206 R12: 00005582afb043a0
> <4>[ 3797.776289] R13: 00007ffc2d7cce80 R14: 0000000000000000 R15: 0000000000000000
> <3>[ 3797.776293]
> <3>[ 3797.776295] Allocated by task 64782:
> <4>[ 3797.776299]  save_stack+0x1b/0x80
> <4>[ 3797.776302]  __kasan_kmalloc.constprop.0+0xc2/0xd0
> <4>[ 3797.776336]  ceph_osdmap_alloc+0x29/0xd0 [libceph]
> <4>[ 3797.776368]  ceph_osdc_init+0x1ff/0x490 [libceph]
> <4>[ 3797.776399]  ceph_create_client+0x154/0x1b0 [libceph]
> <4>[ 3797.776427]  ceph_get_tree+0x97/0xa40 [ceph]
> <4>[ 3797.776430]  vfs_get_tree+0x46/0x120
> <4>[ 3797.776433]  do_mount+0xa2c/0xd70
> <4>[ 3797.776436]  __x64_sys_mount+0xbe/0x100
> <4>[ 3797.776439]  do_syscall_64+0x73/0x210
> <4>[ 3797.776443]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> <3>[ 3797.776443]
> <3>[ 3797.776445] Freed by task 55184:
> <4>[ 3797.776461]  save_stack+0x1b/0x80
> <4>[ 3797.776464]  __kasan_slab_free+0x12c/0x170
> <4>[ 3797.776467]  kfree+0xa3/0x290
> <4>[ 3797.776500]  handle_one_map+0x1f4/0x3c0 [libceph]
> <4>[ 3797.776533]  ceph_osdc_handle_map+0x910/0xa90 [libceph]
> <4>[ 3797.776567]  dispatch+0x826/0xde0 [libceph]
> <4>[ 3797.776599]  ceph_con_workfn+0x18c1/0x3b30 [libceph]
> <4>[ 3797.776603]  process_one_work+0x3b1/0x6a0
> <4>[ 3797.776606]  worker_thread+0x78/0x5d0
> <4>[ 3797.776609]  kthread+0x191/0x1e0
> <4>[ 3797.776612]  ret_from_fork+0x35/0x40
> <3>[ 3797.776613]
> <3>[ 3797.776616] The buggy address belongs to the object at ffff8883d8b8a100
> <3>[ 3797.776616]  which belongs to the cache kmalloc-192 of size 192
> <3>[ 3797.776836] The buggy address is located 16 bytes inside of
> <3>[ 3797.776836]  192-byte region [ffff8883d8b8a100, ffff8883d8b8a1c0)
> <3>[ 3797.776838] The buggy address belongs to the page:
> <4>[ 3797.776842] page:ffffea000f62e280 refcount:1 mapcount:0 mapping:ffff8883ec80f000 index:0xffff8883d8b8bf00 compound_mapcount: 0
> <4>[ 3797.776847] raw: 0017ffe000010200 ffffea000f6c6780 0000000200000002 ffff8883ec80f000
> <4>[ 3797.776851] raw: ffff8883d8b8bf00 000000008020001b 00000001ffffffff 0000000000000000
> <4>[ 3797.776852] page dumped because: kasan: bad access detected
> <3>[ 3797.776853]
> <3>[ 3797.776854] Memory state around the buggy address:
> <3>[ 3797.776857]  ffff8883d8b8a000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> <3>[ 3797.776859]  ffff8883d8b8a080: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> <3>[ 3797.776862] >ffff8883d8b8a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> <3>[ 3797.776863]                          ^
> <3>[ 3797.776866]  ffff8883d8b8a180: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> <3>[ 3797.776868]  ffff8883d8b8a200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> <3>[ 3797.776869] ==================================================================
>
> URL: https://tracker.ceph.com/issues/44177
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/ceph_common.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index a0e97f6c1072..5c6230b56e02 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -682,8 +682,14 @@ EXPORT_SYMBOL(ceph_reset_client_addr);
>   */
>  static bool have_mon_and_osd_map(struct ceph_client *client)
>  {
> +       bool have_osd_map = false;
> +
> +       down_read(&client->osdc.lock);
> +       have_osd_map = !!(client->osdc.osdmap && client->osdc.osdmap->epoch);
> +       up_read(&client->osdc.lock);
> +
>         return client->monc.monmap && client->monc.monmap->epoch &&
> -              client->osdc.osdmap && client->osdc.osdmap->epoch;
> +              have_osd_map;

Hi Xiubo,

The monmap pointer is reset the same way, so it needs some locking
as well.  And a quick grep shows more places that need to be fixed,
some between libceph and rbd.

I'll treat this patch as a bug report and fix them myself.

Thanks,

                Ilya
