Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5182B2DB018
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Dec 2020 16:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgLOPbP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Dec 2020 10:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbgLOPbD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Dec 2020 10:31:03 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBB6C0617A7
        for <ceph-devel@vger.kernel.org>; Tue, 15 Dec 2020 07:30:22 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id g1so19589679ilk.7
        for <ceph-devel@vger.kernel.org>; Tue, 15 Dec 2020 07:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4t0xwch1D6gBsa9Y2EHDplbnIGoFreeHf7WGZ3qTdw=;
        b=qXNZEKtMsox4ea0MYXrFWTFbP2Qy92pDAiW0G+mxvC6uWMAz1IGSX90QzBZMyst4ET
         18XS8djuYvudxUun7kMwhDjX1If4p2ONnX8N2CpS71pCCcVBaxhM0g9xnEDv+GezBy81
         OTukIe7UKLZNXceBj9POlrpNV4o5qgify9VRH3YVqeXBqh0syrgkhOj4g4UzhLTge/Uu
         hWHbgytURjPAmgSNwiq/p3dTpJ//GbBq9lciiPCCMjOcWdWunvseatORvaPWRjjOEpso
         ynn4VDI80deZBQQwLTaOUysW3AWetRbhRUdeOZLlS8eN4QS+QN8iBrlxDD9+9CBgKybk
         ijfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4t0xwch1D6gBsa9Y2EHDplbnIGoFreeHf7WGZ3qTdw=;
        b=pDZGIK9YaSJZ+Fl8hIoPBTtFZAo8z2idD2apxfXNa8QXq98e5bs1pw4R0Vq6qtZE6p
         WEbh0JcsaS7lBkfzLBaOqHlCBSdz1teD2u5pxyElECqrQ9za1audXMnoV0Vs43dtGYlt
         duNiIHhHiVGaC2XKL9jcj/R+QuW4Ox8wTVzocuJ2kNVV0k3IeoRhxy45/LJYTs1gCuKZ
         MLMdO8PKtLng1x0+PBHYZ06DcMKfT0tbsFj8KwlDUWNPyn8Jji+kS7hiQlm49F9MYpXC
         tm2WytwCBAap7SGWMyjJ15MlvHT7vWb2OHlhYoBpU9E3gZcozL3p6hS8lyia9eHqhW8p
         w3mg==
X-Gm-Message-State: AOAM532A2NXzmDD/JRZSgfqgUsiYynBxq5AZ4wUJ3zKJbrgBwHv6UWrr
        b3hKSv1fgng+BrraXH3Mbk6RXAc4ksMI0+JYBmH93Yrvp8s=
X-Google-Smtp-Source: ABdhPJyp9i3c8OB703QXBfDbWL+8ovfPkTzHZ2g9bIEr06HbRHQrcqxz2qpNFLsufaFVmzoTHXVo2HOwcr/kI9TUZuA=
X-Received: by 2002:a92:6512:: with SMTP id z18mr41703698ilb.220.1608046221700;
 Tue, 15 Dec 2020 07:30:21 -0800 (PST)
MIME-Version: 1.0
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
 <87wnxk1iwy.fsf@suse.de> <CAOi1vP-U4Hdw=zYNFmhX_TJeuUiAAXMwvAUJLmG++F8mN+z5HQ@mail.gmail.com>
 <87sg881epx.fsf@suse.de> <877dpjyzw2.fsf@suse.de>
In-Reply-To: <877dpjyzw2.fsf@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 15 Dec 2020 16:30:10 +0100
Message-ID: <CAOi1vP8Qx8qLd0BtS_t8nn1ukXh0uAxveJOd=NyHv+rYnzTpBg@mail.gmail.com>
Subject: Re: wip-msgr2
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 15, 2020 at 2:14 PM Luis Henriques <lhenriques@suse.de> wrote:
>
> Luis Henriques <lhenriques@suse.de> writes:
>
> > Ilya Dryomov <idryomov@gmail.com> writes:
> >
> >> On Mon, Dec 14, 2020 at 4:55 PM Luis Henriques <lhenriques@suse.de> wrote:
> >>>
> >>> Ilya Dryomov <idryomov@gmail.com> writes:
> >>>
> >>> > Hello,
> >>> >
> >>> > I've pushed wip-msgr2 and opened a dummy PR in ceph-client:
> >>> >
> >>> >   https://github.com/ceph/ceph-client/pull/22
> >>> >
> >>> > This set has been through a over a dozen krbd test suite runs with no
> >>> > issues other than those with the test suite itself.  The diffstat is
> >>> > rather big, so I didn't want to spam the list.  If someone wants it
> >>> > posted, let me know.  Any comments are welcome!
> >>>
> >>> That's *awesome*!  Thanks for sharing, Ilya.  Obviously this will need a
> >>> lot of time to digest but a quick attempt to do a mount using a v2 monitor
> >>> is just showing me a bunch of:
> >>>
> >>> libceph: mon0 (1)192.168.155.1:40898 socket closed (con state V1_BANNER)
> >>>
> >>> Note that this was just me giving it a try with a dummy vstart cluster
> >>> (octopus IIRC), so nothing that could be considered testing.  I'll try to
> >>> find out what I'm doing wrong in the next couple of days or, worst case,
> >>> after EOY vacations.
> >>
> >> Hi Luis,
> >>
> >> This is because the kernel continues to default to msgr1.  The socket
> >> gets closed by the mon right after it sees msgr1 banner and you should
> >> see "peer ... is using msgr V1 protocol" error in the log.
> >>
> >> For msgr2, you need to select a connection mode using the new ms_mode
> >> option:
> >>
> >>   ms_mode=legacy        - msgr1 (default)
> >>   ms_mode=crc           - crc mode, if denied fail
> >>   ms_mode=secure        - secure mode, if denied fail
> >>   ms_mode=prefer-crc    - crc mode, if denied agree to secure mode
> >>   ms_mode=prefer-secure - secure mode, if denied agree to crc mode
> >
> > Ah, right.  I should have took a quick look at the patches first to check
> > for any new parameters.  Thanks for pointing me at that, I'll retry my
> > test using ms_mode.
>
> Maybe you're already aware of this, but here it goes: I'm seeing the
> following BUG when doing a mount using ms_mode=secure:
>
> [  159.648716] ==================================================================
> [  159.652328] BUG: KASAN: slab-out-of-bounds in prepare_head_secure_small+0x101/0x110
> [  159.656203] Write of size 16 at addr ffff8881014eb5c0 by task kworker/0:1/12
> [  159.659764]
> [  159.660600] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.10.0-rc2+ #55
> [  159.663985] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
> [  159.669423] Workqueue: ceph-msgr ceph_con_workfn
> [  159.671559] Call Trace:
> [  159.672657]  dump_stack+0x9a/0xcc
> [  159.674115]  ? prepare_head_secure_small+0x101/0x110
> [  159.676127]  print_address_description.constprop.0+0x1c/0x220
> [  159.678455]  ? prepare_head_secure_small+0x101/0x110
> [  159.680334]  ? prepare_head_secure_small+0x101/0x110
> [  159.682245]  kasan_report.cold+0x1f/0x37
> [  159.683730]  ? queue_zeros+0x141/0x1c0
> [  159.685069]  ? prepare_head_secure_small+0x101/0x110
> [  159.686849]  check_memory_region+0x145/0x1a0
> [  159.688306]  memset+0x20/0x40
> [  159.689318]  prepare_head_secure_small+0x101/0x110
> [  159.691034]  ? gcm_crypt+0x190/0x190
> [  159.692266]  ? memset+0x20/0x40
> [  159.693349]  ? encode_preamble+0xc0/0xd0
> [  159.694591]  __prepare_control+0x3f1/0x450
> [  159.695463]  ? prepare_read_preamble+0x190/0x190
> [  159.696450]  ? kasan_unpoison_shadow+0x33/0x40
> [  159.697439]  ? ceph_kvmalloc+0x7e/0x110
> [  159.698369]  __handle_control+0x1115/0x2120
> [  159.699294]  ? process_hello+0x510/0x510
> [  159.700130]  ? lock_chain_count+0x20/0x20
> [  159.700995]  ? lock_acquire+0x1b1/0x580
> [  159.701780]  ? create_object.isra.0+0x239/0x4e0
> [  159.702776]  ? lockdep_enabled+0x39/0x50
> [  159.703667]  ? find_held_lock+0x85/0xa0
> [  159.704448]  ? __kmalloc+0x16d/0x330
> [  159.705231]  ? mark_held_locks+0x65/0x90
> [  159.706020]  ? lockdep_enabled+0x39/0x50
> [  159.706856]  ? ceph_kvmalloc+0x7e/0x110
> [  159.707588]  ceph_con_v2_try_read+0x13dc/0x1e00
> [  159.708456]  ? populate_out_iter+0x14b0/0x14b0
> [  159.709306]  ? __mutex_lock+0x2e9/0xb70
> [  159.710000]  ? trace_hardirqs_on+0x3e/0x110
> [  159.710770]  ? ceph_con_workfn+0x41/0xb00
> [  159.711503]  ? lock_acquire+0x1b1/0x580
> [  159.712187]  ? process_one_work+0x4b2/0xaa0
> [  159.712935]  ? lock_release+0x410/0x410
> [  159.713617]  ? lock_downgrade+0x380/0x380
> [  159.714353]  ceph_con_workfn+0x2df/0xb00
> [  159.715048]  process_one_work+0x599/0xaa0
> [  159.715729]  ? pwq_dec_nr_in_flight+0x110/0x110
> [  159.716489]  ? rwlock_bug.part.0+0x60/0x60
> [  159.717187]  worker_thread+0x2bc/0x780
> [  159.717832]  ? process_one_work+0xaa0/0xaa0
> [  159.718542]  kthread+0x1de/0x200
> [  159.719087]  ? kthread_create_worker_on_cpu+0xd0/0xd0
> [  159.719892]  ret_from_fork+0x22/0x30
> [  159.720488]
> [  159.720744] Allocated by task 12:
> [  159.721285]  kasan_save_stack+0x1b/0x40
> [  159.721901]  __kasan_kmalloc.constprop.0+0xc2/0xd0
> [  159.722678]  ceph_kvmalloc+0x68/0x110
> [  159.723249]  alloc_conn_buf+0x42/0xd0
> [  159.723817]  __handle_control+0x10bb/0x2120
> [  159.724456]  ceph_con_v2_try_read+0x13dc/0x1e00
> [  159.725149]  ceph_con_workfn+0x2df/0xb00
> [  159.725755]  process_one_work+0x599/0xaa0
> [  159.726382]  worker_thread+0x2bc/0x780
> [  159.726957]  kthread+0x1de/0x200
> [  159.727445]  ret_from_fork+0x22/0x30
> [  159.727976]
> [  159.728216] The buggy address belongs to the object at ffff8881014eb580
> [  159.728216]  which belongs to the cache kmalloc-96 of size 96
> [  159.730011] The buggy address is located 64 bytes inside of
> [  159.730011]  96-byte region [ffff8881014eb580, ffff8881014eb5e0)
> [  159.731648] The buggy address belongs to the page:
> [  159.732333] page:00000000892842f3 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1014eb
> [  159.733656] flags: 0x8000000000000200(slab)
> [  159.734264] raw: 8000000000000200 ffffea000415eac0 0000001900000019 ffff888100041780
> [  159.735355] raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
> [  159.736437] page dumped because: kasan: bad access detected
> [  159.737229]
> [  159.737454] Memory state around the buggy address:
> [  159.738130]  ffff8881014eb480: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> [  159.739533]  ffff8881014eb500: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> [  159.740898] >ffff8881014eb580: 00 00 00 00 00 00 00 00 04 fc fc fc fc fc fc fc
> [  159.742221]                                            ^
> [  159.743035]  ffff8881014eb600: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> [  159.744053]  ffff8881014eb680: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> [  159.745091] ==================================================================
>
> Looks like the memset in prepare_head_secure_small() is cleaning behind
> the base limits.  Unfortunately, I didn't really had time to dig deeper
> into this.

Ah, I disabled KASAN for some performance testing and didn't turn
it back on.  This doesn't actually corrupt any memory because the
96-byte object that gets allocated is big enough.  In fact, the
relevant code used to request 96 bytes independent of the connection
mode until I changed it to follow the on-wire format more strictly.

This frame is 68 bytes in plane mode and 96 bytes in secure mode
but we are requesting 68 bytes in both modes.  The following should
fix it:

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 5e38c847317b..11fd47b36fc8 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1333,7 +1333,8 @@ static int prepare_auth_signature(struct
ceph_connection *con)
        void *buf;
        int ret;

-       buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE, false));
+       buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE,
+                                                 con_secure(con)));
        if (!buf)
                return -ENOMEM;

Thanks,

                Ilya
