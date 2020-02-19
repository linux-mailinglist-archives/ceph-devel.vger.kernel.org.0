Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9853F16427E
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 11:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgBSKpo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 05:45:44 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35592 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgBSKpn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 05:45:43 -0500
Received: by mail-io1-f66.google.com with SMTP id h8so51962iob.2
        for <ceph-devel@vger.kernel.org>; Wed, 19 Feb 2020 02:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IpjPR4lnKzCek/a3/YVBD+7MPB8QuSfeF5muT9fUpS0=;
        b=PVCTAhnQ+wYsut53xvRyLjvHLh3cOKS+E+jY+yESBWcVUaR7I9SCYdPQoFeIVPCAgK
         4BXcyKmEwB2p6yCHavR6plyP/O/0StGPughc5IuAKyISgj5A4bnVyg2q5k515jbSjLbu
         pW3wVtcOWZ2Mi5TPVH8GglnnSjhJqEGmlMmPffsA6GnXYRSYT3rXuHRwkLJZMTbyeGNh
         AWIK/iDal0N92YRIdz86aeiWo/H0l/Y+jc5jXIpMKwGZBxpLDJRxiQm+J/9bDsDIxt6H
         w9Itpsp9g137XZnbKLJE/tAiI4C3KZBJ/o+We96SYsjfYpMZVBwvfNLxryVvQGtwl5Gv
         VphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IpjPR4lnKzCek/a3/YVBD+7MPB8QuSfeF5muT9fUpS0=;
        b=jLYXLhSDUTZjonCtIIZVNvQWa031iq/w4FBMn+7eVWK5TE4NkR3gMwfk1d8g54QV14
         OFOcGK54GInz4YW3/wAdAlAr3iurQ6+sY38wXjQGY9XWXen/kcwwOQb9I3g4ZGEeYwqL
         A4jt3rDJJYMCWO2KfDeDH8tLqGnNzwTUITGAXCrXjvClrqW4LBrYoMddDTsa50N5T8aT
         1MDbXYKqvtcftr+4wGwDF8jLmHNZ0ev5p2wnG6mRPVwpH5+HBjA9I1zPbbCfzLokZZT2
         i6P0eFfb0tEHsijdzO1/TA6W2OiHzvTg4Ln9anbkiGlXoHNOMEAKqN67FNgwBOT6ltIp
         CIZg==
X-Gm-Message-State: APjAAAXTJ90s9vjYAV3HX/cOkHFCJG5KjUYJWXex2hL4NhUC15UuypHZ
        MBYqa4+o8E+2kbgpIMCombncm98wPWXaF0FaiXUDN307GuU=
X-Google-Smtp-Source: APXvYqw1mAo0q++DedIY8V/tL335N8Y9pavqX3htqG3FSUGVSoGljs2DLo7cjZfh2J2Dw6nAJjsiJI+UnXLsY5LveJ8=
X-Received: by 2002:a05:6638:34c:: with SMTP id x12mr20160128jap.144.1582109142617;
 Wed, 19 Feb 2020 02:45:42 -0800 (PST)
MIME-Version: 1.0
References: <20200219090853.33117-1-xiubli@redhat.com>
In-Reply-To: <20200219090853.33117-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Feb 2020 11:46:08 +0100
Message-ID: <CAOi1vP_nwfKFHRaUrUcVxapYgYeor7ULLGzwi7seCeTRMTjVsA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix use-after-free for the osdmap memory
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

On Wed, Feb 19, 2020 at 10:09 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When there has new {osd/mon/mds}map comes, it will replace
> and release the old maps' memory, so without the lock wrappers
> it may continue to use the freed ones. The call trace likes:
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
>  fs/ceph/debugfs.c      | 13 +++++++++++--
>  fs/ceph/super.c        |  4 ++++
>  net/ceph/ceph_common.c | 20 +++++++++++++++++---
>  net/ceph/debugfs.c     | 15 +++++++++++----
>  4 files changed, 43 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 60f3e307fca1..0873791a3f77 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -23,11 +23,18 @@ static int mdsmap_show(struct seq_file *s, void *p)
>  {
>         int i;
>         struct ceph_fs_client *fsc = s->private;
> +       struct ceph_mds_client *mdsc = fsc->mdsc;
>         struct ceph_mdsmap *mdsmap;
>
> -       if (!fsc->mdsc || !fsc->mdsc->mdsmap)
> +       if (!mdsc)
> +              return 0;
> +
> +       mutex_lock(&mdsc->mutex);
> +       mdsmap = mdsc->mdsmap;
> +       if (!mdsmap) {
> +               mutex_unlock(&mdsc->mutex);
>                 return 0;
> -       mdsmap = fsc->mdsc->mdsmap;
> +       }
>         seq_printf(s, "epoch %d\n", mdsmap->m_epoch);
>         seq_printf(s, "root %d\n", mdsmap->m_root);
>         seq_printf(s, "max_mds %d\n", mdsmap->m_max_mds);
> @@ -40,6 +47,8 @@ static int mdsmap_show(struct seq_file *s, void *p)
>                                ceph_pr_addr(addr),
>                                ceph_mds_state_name(state));
>         }
> +       mutex_unlock(&mdsc->mutex);
> +
>         return 0;
>  }
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index f9a9a2038c6e..2856389c352f 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -53,11 +53,13 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
>         int err;
>         u64 data_pool;
>
> +       mutex_lock(&fsc->mdsc->mutex);
>         if (fsc->mdsc->mdsmap->m_num_data_pg_pools == 1) {
>                 data_pool = fsc->mdsc->mdsmap->m_data_pg_pools[0];
>         } else {
>                 data_pool = CEPH_NOPOOL;
>         }
> +       mutex_unlock(&fsc->mdsc->mutex);
>
>         dout("statfs\n");
>         err = ceph_monc_do_statfs(monc, data_pool, &st);
> @@ -1087,10 +1089,12 @@ static int ceph_get_tree(struct fs_context *fc)
>         return 0;
>
>  out_splat:
> +       mutex_lock(&fsc->mdsc->mutex);
>         if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
>                 pr_info("No mds server is up or the cluster is laggy\n");
>                 err = -EHOSTUNREACH;
>         }
> +       mutex_unlock(&fsc->mdsc->mutex);
>
>         ceph_mdsc_close_sessions(fsc->mdsc);
>         deactivate_locked_super(sb);
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index a0e97f6c1072..69e505ca80fe 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -177,11 +177,15 @@ int ceph_compare_options(struct ceph_options *new_opt,
>         }
>
>         /* any matching mon ip implies a match */
> +       mutex_lock(&client->monc.mutex);
>         for (i = 0; i < opt1->num_mon; i++) {
>                 if (ceph_monmap_contains(client->monc.monmap,
> -                                &opt1->mon_addr[i]))
> +                                &opt1->mon_addr[i])) {
> +                       mutex_unlock(&client->monc.mutex);
>                         return 0;
> +               }
>         }
> +       mutex_unlock(&client->monc.mutex);
>         return -1;
>  }
>  EXPORT_SYMBOL(ceph_compare_options);
> @@ -682,8 +686,18 @@ EXPORT_SYMBOL(ceph_reset_client_addr);
>   */
>  static bool have_mon_and_osd_map(struct ceph_client *client)
>  {
> -       return client->monc.monmap && client->monc.monmap->epoch &&
> -              client->osdc.osdmap && client->osdc.osdmap->epoch;
> +       bool have_osd_map = false;
> +       bool have_mon_map = false;
> +
> +       down_read(&client->osdc.lock);
> +       have_osd_map = !!(client->osdc.osdmap && client->osdc.osdmap->epoch);
> +       up_read(&client->osdc.lock);
> +
> +       mutex_lock(&client->monc.mutex);
> +       have_mon_map = !!(client->monc.monmap && client->monc.monmap->epoch);
> +       mutex_unlock(&client->monc.mutex);
> +
> +       return have_mon_map && have_osd_map;
>  }
>
>  /*
> diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
> index 1344f232ecc5..a9d5c9de0070 100644
> --- a/net/ceph/debugfs.c
> +++ b/net/ceph/debugfs.c
> @@ -36,8 +36,11 @@ static int monmap_show(struct seq_file *s, void *p)
>         int i;
>         struct ceph_client *client = s->private;
>
> -       if (client->monc.monmap == NULL)
> +       mutex_lock(&client->monc.mutex);
> +       if (client->monc.monmap == NULL) {
> +               mutex_unlock(&client->monc.mutex);
>                 return 0;
> +       }
>
>         seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
>         for (i = 0; i < client->monc.monmap->num_mon; i++) {
> @@ -48,6 +51,7 @@ static int monmap_show(struct seq_file *s, void *p)
>                            ENTITY_NAME(inst->name),
>                            ceph_pr_addr(&inst->addr));
>         }
> +       mutex_unlock(&client->monc.mutex);
>         return 0;
>  }
>
> @@ -56,13 +60,16 @@ static int osdmap_show(struct seq_file *s, void *p)
>         int i;
>         struct ceph_client *client = s->private;
>         struct ceph_osd_client *osdc = &client->osdc;
> -       struct ceph_osdmap *map = osdc->osdmap;
> +       struct ceph_osdmap *map;
>         struct rb_node *n;
>
> -       if (map == NULL)
> +       down_read(&osdc->lock);
> +       map = osdc->osdmap;
> +       if (map == NULL) {
> +               up_read(&osdc->lock);
>                 return 0;
> +       }
>
> -       down_read(&osdc->lock);
>         seq_printf(s, "epoch %u barrier %u flags 0x%x\n", map->epoch,
>                         osdc->epoch_barrier, map->flags);

Hi Xiubo,

This is part of what I meant when I said there are more issues with
map pointers yesterday.  This version doesn't capture all of them,
and some of them could involve lock dependency issues.  I don't have
a complete patch yet -- we might need to have to add refcounts for
maps after all.

Feel free to use this version in your testing, but, like I said
yesterday, I'll probably be fixing these myself.

It would be great if you could share your test cases though.

Thanks,

                Ilya
