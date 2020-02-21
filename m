Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC5D1680F5
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 15:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgBUO5f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 09:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbgBUO5f (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 09:57:35 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D3D24650;
        Fri, 21 Feb 2020 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582297054;
        bh=Pc/Y5h6v771GwqTlKOgwp9DwRIHeZWKLwMDVlkNWMFc=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=FvHtNbZaSzJzBMuPaCzQ4+4qmFMdA3BqHA6lqko/gHFhqleSA7QtDRoVE+we5bfLs
         jIhp76MFTlAObyx7diqa5whDlgq3m3pNNQ1rqUbx6wb+bSHAx1eyBe1rXNu5QiMw9C
         in+C59rglbZEbp/XkxANWd8UsNoPCq4y5JJCGOfU=
Message-ID: <3f03a0ea1ec33be21fb36a8e36c912e2b66a2ae8.camel@kernel.org>
Subject: Re: [PATCH v2 0/4] ceph: don't request caps for idle open files
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Fri, 21 Feb 2020 09:57:33 -0500
In-Reply-To: <20200221131659.87777-1-zyan@redhat.com>
References: <20200221131659.87777-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
> This series make cephfs client not request caps for open files that
> idle for a long time. For the case that one active client and multiple
> standby clients open the same file, this increase the possibility that
> mds issues exclusive caps to the active client.
> 
> Yan, Zheng (4):
>   ceph: always renew caps if mds_wanted is insufficient
>   ceph: consider inode's last read/write when calculating wanted caps
>   ceph: simplify calling of ceph_get_fmode()
>   ceph: remove delay check logic from ceph_check_caps()
> 
>  fs/ceph/caps.c               | 324 +++++++++++++++--------------------
>  fs/ceph/file.c               |  39 ++---
>  fs/ceph/inode.c              |  19 +-
>  fs/ceph/ioctl.c              |   2 +
>  fs/ceph/mds_client.c         |   5 -
>  fs/ceph/super.h              |  35 ++--
>  include/linux/ceph/ceph_fs.h |   1 +
>  7 files changed, 188 insertions(+), 237 deletions(-)
> 

Testing with this series and xfstests is throwing softlockups. Still
looking at the cause:

[  251.385573] watchdog: BUG: soft lockup - CPU#7 stuck for 23s! [fsstress:7113]
[  251.387105] Modules linked in: ceph(OE) libceph(E) ip6t_REJECT(E) nf_reject_ipv6(E) ip6t_rpfilter(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_conntrack(E) ebtable_nat(E) ebtable_broute(E) ip6table_nat(E) ip6table_mangle(E) ip6table_raw(E) ip6table_security(E) iptable_nat(E) nf_nat(E) iptable_mangle(E) iptable_raw(E) iptable_security(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ip_set(E) nfnetlink(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) cachefiles(E) fscache(E) sunrpc(E) pcspkr(E) joydev(E) i2c_piix4(E) virtio_balloon(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) ip_tables(E) xfs(E) libcrc32c(E) rfkill(E) qxl(E) drm_ttm_helper(E) crc32c_intel(E) ttm(E) drm_kms_helper(E) cec(E) serio_raw(E) virtio_net(E) net_failover(E) virtio_console(E) virtio_blk(E) failover(E) drm(E) ata_generic(E) floppy(E) pata_acpi(E) qemu_fw_cfg(E)
[  251.402300] CPU: 7 PID: 7113 Comm: fsstress Kdump: loaded Tainted: G           OE     5.6.0-rc1+ #12
[  251.404351] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
[  251.407716] RIP: 0010:ceph_get_caps+0x108/0x5e0 [ceph]
[  251.409154] Code: 80 cc 02 85 d2 44 89 f2 0f 45 d8 41 89 d8 e8 4f f8 ff ff 89 c1 83 f8 f5 74 ba 85 c0 0f 84 55 02 00 00 48 8b 74 24 50 f6 06 02 <74> 11 48 8b 44 24 48 8b 40 2c 39 46 1c 0f 85 97 04 00 00 85 c9 0f
[  251.413302] RSP: 0018:ffffb72c01567a10 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
[  251.414827] RAX: 00000000ffffff8c RBX: 0000000000000002 RCX: 00000000ffffff8c
[  251.416303] RDX: ffff8a1fd45b4468 RSI: ffff8a2228fd2c08 RDI: ffff8a1fd45b42d0
[  251.417778] RBP: ffffb72c01567b00 R08: ffff8a2227fcb000 R09: ffffb72c01567a6c
[  251.419265] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000160337c1
[  251.420811] R13: 0000000000001000 R14: 0000000000002000 R15: ffff8a1fd45b45f8
[  251.422355] FS:  00007fcdcc9ebf40(0000) GS:ffff8a222fbc0000(0000) knlGS:0000000000000000
[  251.423962] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  251.425294] CR2: 000000000162e000 CR3: 00000001f0b18000 CR4: 00000000003406e0
[  251.426785] Call Trace:
[  251.427739]  ? __vfs_getxattr+0x53/0x70
[  251.428835]  ? generic_update_time+0x9d/0xc0
[  251.429978]  ? file_update_time+0xdd/0x120
[  251.431106]  ceph_write_iter+0x27b/0xc30 [ceph]
[  251.432285]  ? ceph_read_iter+0x3b3/0xd60 [ceph]
[  251.433463]  ? _cond_resched+0x15/0x30
[  251.434533]  ? do_iter_readv_writev+0x158/0x1d0
[  251.435681]  do_iter_readv_writev+0x158/0x1d0
[  251.436825]  do_iter_write+0x7d/0x190
[  251.437867]  iter_file_splice_write+0x26a/0x3c0
[  251.439059]  direct_splice_actor+0x35/0x40
[  251.440144]  splice_direct_to_actor+0x102/0x250
[  251.441274]  ? generic_pipe_buf_nosteal+0x10/0x10
[  251.442444]  do_splice_direct+0x8b/0xd0
[  251.443491]  generic_copy_file_range+0x32/0x40
[  251.444596]  vfs_copy_file_range+0x2eb/0x310
[  251.445691]  ? __do_sys_newfstat+0x5a/0x70
[  251.446764]  __x64_sys_copy_file_range+0xd6/0x210
[  251.447933]  do_syscall_64+0x5b/0x1c0
[  251.448972]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  251.450188] RIP: 0033:0x7fcdccae91ed
[  251.451236] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 6b 5c 0c 00 f7 d8 64 89 01 48
[  251.455096] RSP: 002b:00007ffcbac62e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
[  251.456664] RAX: ffffffffffffffda RBX: 0000000124e3181d RCX: 00007fcdccae91ed
[  251.458153] RDX: 0000000000000004 RSI: 00007ffcbac62e60 RDI: 0000000000000003
[  251.459626] RBP: 0000000000000003 R08: 000000000001c50b R09: 0000000000000000
[  251.461147] R10: 00007ffcbac62e68 R11: 0000000000000246 R12: 0000000000000088
[  251.462680] R13: 0000000000000004 R14: 000000000001c50b R15: 000000001602447d


-- 
Jeff Layton <jlayton@kernel.org>

