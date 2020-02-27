Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE9717259F
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2020 18:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbgB0Rtd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Feb 2020 12:49:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729232AbgB0Rtd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 12:49:33 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD84324692;
        Thu, 27 Feb 2020 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582825772;
        bh=BvBhX209MEXF6EzkahQhZE+KhzndoVBoa271riRf3FE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K0RY4xfCIaBgYriR8QbPcw58IGU2KHJ4mekq6y3wclwD3yJ0wJ4UBT1PHZbvEbE3g
         sLG5B2JV2XEOT6BREkylkpOWLg5sEW/cyY27RbCZxEDV3WBZ/slF3nhuAdli8Cfu+Y
         iPhHtlBsr9t1jQK4l5TylugRenVF+20LCe2UN9fg=
Message-ID: <94aac4853ba4d7aaf290a2e9c374c6fdc120beb6.camel@kernel.org>
Subject: Re: [PATCH v2 0/4] ceph: don't request caps for idle open files
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Date:   Thu, 27 Feb 2020 12:49:30 -0500
In-Reply-To: <CAAM7YA=dnNBXkijDUDV6NWo3A=uak1i-b=KpaZ4-CG=9kENVmA@mail.gmail.com>
References: <20200221131659.87777-1-zyan@redhat.com>
         <3f03a0ea1ec33be21fb36a8e36c912e2b66a2ae8.camel@kernel.org>
         <CAAM7YAkGj00jhUYq30uqCLbppx3H2dZq=gAA0hTkZxH8F5P0SA@mail.gmail.com>
         <68c33106a754b443f2dd938f2d8eed6da19136dc.camel@kernel.org>
         <fe77b2f9c81e8c604f606e9d220093e834fbd8da.camel@kernel.org>
         <CAAM7YA=dnNBXkijDUDV6NWo3A=uak1i-b=KpaZ4-CG=9kENVmA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-27 at 23:26 +0800, Yan, Zheng wrote:
> On Thu, Feb 27, 2020 at 10:58 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Thu, 2020-02-27 at 08:36 -0500, Jeff Layton wrote:
> > > On Thu, 2020-02-27 at 20:07 +0800, Yan, Zheng wrote:
> > > > On Fri, Feb 21, 2020 at 10:59 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
> > > > > > This series make cephfs client not request caps for open files that
> > > > > > idle for a long time. For the case that one active client and multiple
> > > > > > standby clients open the same file, this increase the possibility that
> > > > > > mds issues exclusive caps to the active client.
> > > > > > 
> > > > > > Yan, Zheng (4):
> > > > > >   ceph: always renew caps if mds_wanted is insufficient
> > > > > >   ceph: consider inode's last read/write when calculating wanted caps
> > > > > >   ceph: simplify calling of ceph_get_fmode()
> > > > > >   ceph: remove delay check logic from ceph_check_caps()
> > > > > > 
> > > > > >  fs/ceph/caps.c               | 324 +++++++++++++++--------------------
> > > > > >  fs/ceph/file.c               |  39 ++---
> > > > > >  fs/ceph/inode.c              |  19 +-
> > > > > >  fs/ceph/ioctl.c              |   2 +
> > > > > >  fs/ceph/mds_client.c         |   5 -
> > > > > >  fs/ceph/super.h              |  35 ++--
> > > > > >  include/linux/ceph/ceph_fs.h |   1 +
> > > > > >  7 files changed, 188 insertions(+), 237 deletions(-)
> > > > > > 
> > > > > 
> > > > > Testing with this series and xfstests is throwing softlockups. Still
> > > > > looking at the cause:
> > > > > 
> > > > > [  251.385573] watchdog: BUG: soft lockup - CPU#7 stuck for 23s! [fsstress:7113]
> > > > > [  251.387105] Modules linked in: ceph(OE) libceph(E) ip6t_REJECT(E) nf_reject_ipv6(E) ip6t_rpfilter(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_conntrack(E) ebtable_nat(E) ebtable_broute(E) ip6table_nat(E) ip6table_mangle(E) ip6table_raw(E) ip6table_security(E) iptable_nat(E) nf_nat(E) iptable_mangle(E) iptable_raw(E) iptable_security(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ip_set(E) nfnetlink(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) cachefiles(E) fscache(E) sunrpc(E) pcspkr(E) joydev(E) i2c_piix4(E) virtio_balloon(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) ip_tables(E) xfs(E) libcrc32c(E) rfkill(E) qxl(E) drm_ttm_helper(E) crc32c_intel(E) ttm(E) drm_kms_helper(E) cec(E) serio_raw(E) virtio_net(E) net_failover(E) virtio_console(E) virtio_blk(E) failover(E) drm(E) ata_generic(E) floppy(E) pata_acpi(E) qemu_fw_cfg(E)
> > > > > [  251.402300] CPU: 7 PID: 7113 Comm: fsstress Kdump: loaded Tainted: G           OE     5.6.0-rc1+ #12
> > > > > [  251.404351] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> > > > > [  251.407716] RIP: 0010:ceph_get_caps+0x108/0x5e0 [ceph]
> > > > > [  251.409154] Code: 80 cc 02 85 d2 44 89 f2 0f 45 d8 41 89 d8 e8 4f f8 ff ff 89 c1 83 f8 f5 74 ba 85 c0 0f 84 55 02 00 00 48 8b 74 24 50 f6 06 02 <74> 11 48 8b 44 24 48 8b 40 2c 39 46 1c 0f 85 97 04 00 00 85 c9 0f
> > > > > [  251.413302] RSP: 0018:ffffb72c01567a10 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
> > > > > [  251.414827] RAX: 00000000ffffff8c RBX: 0000000000000002 RCX: 00000000ffffff8c
> > > > > [  251.416303] RDX: ffff8a1fd45b4468 RSI: ffff8a2228fd2c08 RDI: ffff8a1fd45b42d0
> > > > > [  251.417778] RBP: ffffb72c01567b00 R08: ffff8a2227fcb000 R09: ffffb72c01567a6c
> > > > > [  251.419265] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000160337c1
> > > > > [  251.420811] R13: 0000000000001000 R14: 0000000000002000 R15: ffff8a1fd45b45f8
> > > > > [  251.422355] FS:  00007fcdcc9ebf40(0000) GS:ffff8a222fbc0000(0000) knlGS:0000000000000000
> > > > > [  251.423962] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > [  251.425294] CR2: 000000000162e000 CR3: 00000001f0b18000 CR4: 00000000003406e0
> > > > > [  251.426785] Call Trace:
> > > > > [  251.427739]  ? __vfs_getxattr+0x53/0x70
> > > > > [  251.428835]  ? generic_update_time+0x9d/0xc0
> > > > > [  251.429978]  ? file_update_time+0xdd/0x120
> > > > > [  251.431106]  ceph_write_iter+0x27b/0xc30 [ceph]
> > > > > [  251.432285]  ? ceph_read_iter+0x3b3/0xd60 [ceph]
> > > > > [  251.433463]  ? _cond_resched+0x15/0x30
> > > > > [  251.434533]  ? do_iter_readv_writev+0x158/0x1d0
> > > > > [  251.435681]  do_iter_readv_writev+0x158/0x1d0
> > > > > [  251.436825]  do_iter_write+0x7d/0x190
> > > > > [  251.437867]  iter_file_splice_write+0x26a/0x3c0
> > > > > [  251.439059]  direct_splice_actor+0x35/0x40
> > > > > [  251.440144]  splice_direct_to_actor+0x102/0x250
> > > > > [  251.441274]  ? generic_pipe_buf_nosteal+0x10/0x10
> > > > > [  251.442444]  do_splice_direct+0x8b/0xd0
> > > > > [  251.443491]  generic_copy_file_range+0x32/0x40
> > > > > [  251.444596]  vfs_copy_file_range+0x2eb/0x310
> > > > > [  251.445691]  ? __do_sys_newfstat+0x5a/0x70
> > > > > [  251.446764]  __x64_sys_copy_file_range+0xd6/0x210
> > > > > [  251.447933]  do_syscall_64+0x5b/0x1c0
> > > > > [  251.448972]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > [  251.450188] RIP: 0033:0x7fcdccae91ed
> > > > > [  251.451236] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 6b 5c 0c 00 f7 d8 64 89 01 48
> > > > > [  251.455096] RSP: 002b:00007ffcbac62e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
> > > > > [  251.456664] RAX: ffffffffffffffda RBX: 0000000124e3181d RCX: 00007fcdccae91ed
> > > > > [  251.458153] RDX: 0000000000000004 RSI: 00007ffcbac62e60 RDI: 0000000000000003
> > > > > [  251.459626] RBP: 0000000000000003 R08: 000000000001c50b R09: 0000000000000000
> > > > > [  251.461147] R10: 00007ffcbac62e68 R11: 0000000000000246 R12: 0000000000000088
> > > > > [  251.462680] R13: 0000000000000004 R14: 000000000001c50b R15: 000000001602447d
> > > > > 
> > > > > 
> > > > 
> > > > I have tried fsstress for days. found a few other issue, but still
> > > > can't reproduce this. Please try branch
> > > > https://github.com/ceph/ceph-client/tree/wip-fmode-timeout
> > > > 
> > > 
> > > Still getting softlockups:
> > > 
> > > [  560.235608] watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [fsstress:10889]
> > > [  560.237143] Modules linked in: rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) ceph(E) libceph(E) ip6t_REJECT(E) nf_reject_ipv6(E) ip6t_rpfilter(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_conntrack(E) ebtable_nat(E) ebtable_broute(E) ip6table_nat(E) ip6table_mangle(E) ip6table_raw(E) ip6table_security(E) iptable_nat(E) nf_nat(E) iptable_mangle(E) iptable_raw(E) iptable_security(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ip_set(E) nfnetlink(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) cachefiles(E) fscache(E) sunrpc(E) joydev(E) i2c_piix4(E) crct10dif_pclmul(E) pcspkr(E) crc32_pclmul(E) virtio_balloon(E) ghash_clmulni_intel(E) ip_tables(E) xfs(E) libcrc32c(E) rfkill(E) qxl(E) drm_ttm_helper(E) ttm(E) drm_kms_helper(E) crc32c_intel(E) cec(E) virtio_console(E) serio_raw(E) virtio_net(E) net_failover(E) ata_generic(E) virtio_blk(E) failover(E) drm(E) floppy(E) pata_acpi(E) qemu_fw_cfg(E)
> > > [  560.252015] CPU: 1 PID: 10889 Comm: fsstress Kdump: loaded Tainted: G            E     5.6.0-rc1+ #14
> > > [  560.253778] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> > > [  560.256696] RIP: 0010:rb_first+0xf/0x20
> > > [  560.257857] Code: 4d 89 e7 4c 89 ea 4d 89 e5 49 89 c4 e9 80 fe ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8b 07 48 85 c0 74 10 49 89 c0 48 8b 40 10 <48> 85 c0 75 f4 4c 89 c0 c3 45 31 c0 eb f7 0f 1f 00 48 8b 07 48 85
> > > [  560.261524] RSP: 0018:ffffb59a015a7808 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
> > > [  560.263184] RAX: 0000000000000000 RBX: ffffb59a015a78cc RCX: 0000000000000000
> > > [  560.264740] RDX: 0000000000000000 RSI: ffffb59a015a78cc RDI: ffff9fbd70442298
> > > [  560.266286] RBP: 0000000000000d01 R08: ffff9fbd72629da0 R09: 0000000000000000
> > > [  560.267843] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9fbd70442160
> > > [  560.269424] R13: 0000000000000000 R14: ffff9fbd70442160 R15: 0000000000000d01
> > > [  560.271070] FS:  00007f37eff21f40(0000) GS:ffff9fbfafa40000(0000) knlGS:0000000000000000
> > > [  560.272833] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  560.274238] CR2: 00007f37ef7ffff0 CR3: 00000001f288c000 CR4: 00000000003406e0
> > > [  560.275842] Call Trace:
> > > [  560.276873]  __ceph_caps_issued+0x33/0xc0 [ceph]
> > > [  560.278206]  ceph_check_caps+0x105/0x9c0 [ceph]
> > > [  560.279450]  ? __cap_is_valid+0x1c/0xb0 [ceph]
> > > [  560.280730]  ? __ceph_caps_issued+0x6d/0xc0 [ceph]
> > > [  560.282132]  ? __ceph_caps_mds_wanted+0x46/0x90 [ceph]
> > > [  560.283672]  ceph_renew_caps+0x98/0x1b0 [ceph]
> > > [  560.285305]  ceph_get_caps+0x2d6/0x5e0 [ceph]
> > > [  560.286967]  ? __vfs_getxattr+0x53/0x70
> > > [  560.288162]  ? generic_update_time+0x9d/0xc0
> > > [  560.289353]  ? file_update_time+0xdd/0x120
> > > [  560.290552]  ceph_write_iter+0x27b/0xc30 [ceph]
> > > [  560.291764]  ? _cond_resched+0x15/0x30
> > > [  560.292884]  ? __inode_security_revalidate+0x62/0x70
> > > [  560.294129]  ? do_iter_readv_writev+0x158/0x1d0
> > > [  560.295319]  do_iter_readv_writev+0x158/0x1d0
> > > [  560.296476]  do_iter_write+0x7d/0x190
> > > [  560.297556]  iter_file_splice_write+0x26a/0x3c0
> > > [  560.298809]  direct_splice_actor+0x35/0x40
> > > [  560.300028]  splice_direct_to_actor+0x102/0x250
> > > [  560.301236]  ? generic_pipe_buf_nosteal+0x10/0x10
> > > [  560.302453]  do_splice_direct+0x8b/0xd0
> > > [  560.303610]  generic_copy_file_range+0x32/0x40
> > > [  560.304850]  ceph_copy_file_range+0xb2/0x6e0 [ceph]
> > > [  560.306085]  ? _cond_resched+0x15/0x30
> > > [  560.307148]  ? __inode_security_revalidate+0x62/0x70
> > > [  560.308357]  vfs_copy_file_range+0x2eb/0x310
> > > [  560.309479]  ? __do_sys_newfstat+0x5a/0x70
> > > [  560.310565]  __x64_sys_copy_file_range+0xd6/0x210
> > > [  560.311711]  do_syscall_64+0x5b/0x1c0
> > > [  560.312705]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > [  560.313855] RIP: 0033:0x7f37f001f1ed
> > > [  560.314818] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 6b 5c 0c 00 f7 d8 64 89 01 48
> > > [  560.319060] RSP: 002b:00007fff4263e4a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
> > > [  560.320845] RAX: ffffffffffffffda RBX: 0000000100163b5b RCX: 00007f37f001f1ed
> > > [  560.322389] RDX: 0000000000000004 RSI: 00007fff4263e4e0 RDI: 0000000000000003
> > > [  560.323756] RBP: 0000000000000003 R08: 0000000000001065 R09: 0000000000000000
> > > [  560.325286] R10: 00007fff4263e4e8 R11: 0000000000000246 R12: 000000000000014e
> > > [  560.327186] R13: 0000000000000004 R14: 0000000000001065 R15: 00000000787d3c00
> > > 
> > > This is testing against a ceph build from this morning's master branch
> > > (53febd478dfc) + a few userland client patches (nothing that should
> > > affect the mds).
> > > 
> > > I'm attaching my .config and the dmesg after enabling dynamic debug in
> > > try_get_cap_refs, ceph_check_caps, and ceph_renew_caps.
> > 
> > My bad...I had the wrong kernel module installed when I was testing
> > this. I'm rerunning the test now with the correct one and it seems to be
> > behaving better.
> > 
> > I'm guessing one of your other fixes might have fixed this as well. I'll
> > let you know if it does lock up, but you can disregard my earlier mail
> > for now.
> > 
> 
> FYI: I update https://github.com/ceph/ceph-client/tree/wip-fmode-timeout.
> remove round_jiffies in __ceph_cap_file_wanted(). round_jiffies()
> return original value for past jiffies. So the change shouldn't affect
> anything.
> 

(re-cc'ing the list)

I tested your latest branch with a few cap-related cleanups of my own
that I'll be posting soon. I'm no longer seeing softlockups.

Sorry for the false alarm earlier! This is looking good now, so I'd like
to see this merged soon. I'll wait for you to do a v3 post once you
think it's ready.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

