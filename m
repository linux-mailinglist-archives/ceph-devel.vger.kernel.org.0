Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE15E1716CA
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2020 13:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgB0MIA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Feb 2020 07:08:00 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37287 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728910AbgB0MH7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Feb 2020 07:07:59 -0500
Received: by mail-qt1-f195.google.com with SMTP id j34so2059225qtk.4
        for <ceph-devel@vger.kernel.org>; Thu, 27 Feb 2020 04:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WlEnbw4c7RkNqAG92gJzB0TbaroDVxKMYMrPFRk6K/0=;
        b=pmAiJXEOXSP11P4smQwHigVYPM4FNJ72gueJzIgScVt4xRdppyHMBiyHeGvkx7hmNL
         3jCexd6RHeAv10MstKi3Odpp9s7eUOboNADszXvZVD0Nrx2wnEBQ5iwBrTcBJQpJVtrc
         eYbBzWuMwniaMoG++ggiDQenazQg7Ia5ZPZeFxf+zueRgtiMMk8zV3yyaWx3OqAbaxr5
         TOJcuQC9S8S4lFGy+szLmCPPOHFuGuXhNvm70QOBnI8IwD4gpwquznHMKo0EXx5ZsM/4
         yviyGYXJSHCd6jFvBl3WnHVYRfQNPza+dsd/8Tf2Nj88qjiB+9M6D5aGJ7RcVoZiZ9rg
         4fOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WlEnbw4c7RkNqAG92gJzB0TbaroDVxKMYMrPFRk6K/0=;
        b=jf1+DJd8h4LXNQwRvIb82mGZ2/XVlTUn7gtyaiu7ZtbkPDCkoL4JxKLRGlGfyUJFV/
         yuuvW8Pmza6e++E0JtEXYAyz6jGw+NRmLlOTGcbbdWGILvX2Voy1JWc/xdomtkvcLV6y
         MPvMcHz3mw6JB/j9CLeOhP/TFWTntvtHFEA2Y++h9Jj5eiVs7R47iJh4XY9VOt/3HUA/
         eMuARQ34wwpZs8ZPDt41yhkRHAipp2UtpoiwtaLxgbg3i8+4aEX8ffLnGk8oHHeKQ3sL
         MkHMq6+zcsx6IqvwLP6uEbdjjg4BfRvyQn2ODftOXzUBBVY8DiKfzxY/iQVW5kJ8GMWH
         12Sg==
X-Gm-Message-State: APjAAAVRUBJ41jAUQwEdIC4h28AH77pb4/zHwtQz7HBX/5xvAIgnC9FP
        9Ij2D5O/XgoszvYq/8L92nX7DFEbKSstMpzDaqg=
X-Google-Smtp-Source: APXvYqyb3MKxeFuPo/Zn52mxkdj38Kg16gTLy9yywKbVbFjiEVv9jXE28MECdkoE+BPH6ePw63o16xKl7TJelq1SrXk=
X-Received: by 2002:ac8:5052:: with SMTP id h18mr4902051qtm.245.1582805278568;
 Thu, 27 Feb 2020 04:07:58 -0800 (PST)
MIME-Version: 1.0
References: <20200221131659.87777-1-zyan@redhat.com> <3f03a0ea1ec33be21fb36a8e36c912e2b66a2ae8.camel@kernel.org>
In-Reply-To: <3f03a0ea1ec33be21fb36a8e36c912e2b66a2ae8.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 27 Feb 2020 20:07:47 +0800
Message-ID: <CAAM7YAkGj00jhUYq30uqCLbppx3H2dZq=gAA0hTkZxH8F5P0SA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] ceph: don't request caps for idle open files
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Feb 21, 2020 at 10:59 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
> > This series make cephfs client not request caps for open files that
> > idle for a long time. For the case that one active client and multiple
> > standby clients open the same file, this increase the possibility that
> > mds issues exclusive caps to the active client.
> >
> > Yan, Zheng (4):
> >   ceph: always renew caps if mds_wanted is insufficient
> >   ceph: consider inode's last read/write when calculating wanted caps
> >   ceph: simplify calling of ceph_get_fmode()
> >   ceph: remove delay check logic from ceph_check_caps()
> >
> >  fs/ceph/caps.c               | 324 +++++++++++++++--------------------
> >  fs/ceph/file.c               |  39 ++---
> >  fs/ceph/inode.c              |  19 +-
> >  fs/ceph/ioctl.c              |   2 +
> >  fs/ceph/mds_client.c         |   5 -
> >  fs/ceph/super.h              |  35 ++--
> >  include/linux/ceph/ceph_fs.h |   1 +
> >  7 files changed, 188 insertions(+), 237 deletions(-)
> >
>
> Testing with this series and xfstests is throwing softlockups. Still
> looking at the cause:
>
> [  251.385573] watchdog: BUG: soft lockup - CPU#7 stuck for 23s! [fsstres=
s:7113]
> [  251.387105] Modules linked in: ceph(OE) libceph(E) ip6t_REJECT(E) nf_r=
eject_ipv6(E) ip6t_rpfilter(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_conntrack=
(E) ebtable_nat(E) ebtable_broute(E) ip6table_nat(E) ip6table_mangle(E) ip6=
table_raw(E) ip6table_security(E) iptable_nat(E) nf_nat(E) iptable_mangle(E=
) iptable_raw(E) iptable_security(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_d=
efrag_ipv4(E) ip_set(E) nfnetlink(E) ebtable_filter(E) ebtables(E) ip6table=
_filter(E) ip6_tables(E) iptable_filter(E) cachefiles(E) fscache(E) sunrpc(=
E) pcspkr(E) joydev(E) i2c_piix4(E) virtio_balloon(E) crct10dif_pclmul(E) c=
rc32_pclmul(E) ghash_clmulni_intel(E) ip_tables(E) xfs(E) libcrc32c(E) rfki=
ll(E) qxl(E) drm_ttm_helper(E) crc32c_intel(E) ttm(E) drm_kms_helper(E) cec=
(E) serio_raw(E) virtio_net(E) net_failover(E) virtio_console(E) virtio_blk=
(E) failover(E) drm(E) ata_generic(E) floppy(E) pata_acpi(E) qemu_fw_cfg(E)
> [  251.402300] CPU: 7 PID: 7113 Comm: fsstress Kdump: loaded Tainted: G  =
         OE     5.6.0-rc1+ #12
> [  251.404351] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2=
014
> [  251.407716] RIP: 0010:ceph_get_caps+0x108/0x5e0 [ceph]
> [  251.409154] Code: 80 cc 02 85 d2 44 89 f2 0f 45 d8 41 89 d8 e8 4f f8 f=
f ff 89 c1 83 f8 f5 74 ba 85 c0 0f 84 55 02 00 00 48 8b 74 24 50 f6 06 02 <=
74> 11 48 8b 44 24 48 8b 40 2c 39 46 1c 0f 85 97 04 00 00 85 c9 0f
> [  251.413302] RSP: 0018:ffffb72c01567a10 EFLAGS: 00000202 ORIG_RAX: ffff=
ffffffffff13
> [  251.414827] RAX: 00000000ffffff8c RBX: 0000000000000002 RCX: 00000000f=
fffff8c
> [  251.416303] RDX: ffff8a1fd45b4468 RSI: ffff8a2228fd2c08 RDI: ffff8a1fd=
45b42d0
> [  251.417778] RBP: ffffb72c01567b00 R08: ffff8a2227fcb000 R09: ffffb72c0=
1567a6c
> [  251.419265] R10: 0000000000000001 R11: 0000000000000000 R12: 000000001=
60337c1
> [  251.420811] R13: 0000000000001000 R14: 0000000000002000 R15: ffff8a1fd=
45b45f8
> [  251.422355] FS:  00007fcdcc9ebf40(0000) GS:ffff8a222fbc0000(0000) knlG=
S:0000000000000000
> [  251.423962] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  251.425294] CR2: 000000000162e000 CR3: 00000001f0b18000 CR4: 000000000=
03406e0
> [  251.426785] Call Trace:
> [  251.427739]  ? __vfs_getxattr+0x53/0x70
> [  251.428835]  ? generic_update_time+0x9d/0xc0
> [  251.429978]  ? file_update_time+0xdd/0x120
> [  251.431106]  ceph_write_iter+0x27b/0xc30 [ceph]
> [  251.432285]  ? ceph_read_iter+0x3b3/0xd60 [ceph]
> [  251.433463]  ? _cond_resched+0x15/0x30
> [  251.434533]  ? do_iter_readv_writev+0x158/0x1d0
> [  251.435681]  do_iter_readv_writev+0x158/0x1d0
> [  251.436825]  do_iter_write+0x7d/0x190
> [  251.437867]  iter_file_splice_write+0x26a/0x3c0
> [  251.439059]  direct_splice_actor+0x35/0x40
> [  251.440144]  splice_direct_to_actor+0x102/0x250
> [  251.441274]  ? generic_pipe_buf_nosteal+0x10/0x10
> [  251.442444]  do_splice_direct+0x8b/0xd0
> [  251.443491]  generic_copy_file_range+0x32/0x40
> [  251.444596]  vfs_copy_file_range+0x2eb/0x310
> [  251.445691]  ? __do_sys_newfstat+0x5a/0x70
> [  251.446764]  __x64_sys_copy_file_range+0xd6/0x210
> [  251.447933]  do_syscall_64+0x5b/0x1c0
> [  251.448972]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  251.450188] RIP: 0033:0x7fcdccae91ed
> [  251.451236] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 4=
8 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 6b 5c 0c 00 f7 d8 64 89 01 48
> [  251.455096] RSP: 002b:00007ffcbac62e28 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000146
> [  251.456664] RAX: ffffffffffffffda RBX: 0000000124e3181d RCX: 00007fcdc=
cae91ed
> [  251.458153] RDX: 0000000000000004 RSI: 00007ffcbac62e60 RDI: 000000000=
0000003
> [  251.459626] RBP: 0000000000000003 R08: 000000000001c50b R09: 000000000=
0000000
> [  251.461147] R10: 00007ffcbac62e68 R11: 0000000000000246 R12: 000000000=
0000088
> [  251.462680] R13: 0000000000000004 R14: 000000000001c50b R15: 000000001=
602447d
>
>

I have tried fsstress for days. found a few other issue, but still
can't reproduce this. Please try branch
https://github.com/ceph/ceph-client/tree/wip-fmode-timeout

Regards
Yan, Zheng

> --
> Jeff Layton <jlayton@kernel.org>
>
