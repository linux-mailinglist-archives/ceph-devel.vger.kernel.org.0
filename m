Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06C7EB873
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Oct 2019 21:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfJaUiM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Oct 2019 16:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfJaUiM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 16:38:12 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D563420656;
        Thu, 31 Oct 2019 20:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572554291;
        bh=zYw14uMadLx3u2jcXBKSfCHC/nD9Iz89j0EMHTzKNeY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PzbPPdaEv5msn5nmEsiAmmHi+s3gAZbbfwrG59cLeVM1res4DndL+bBQ7xo05/uAE
         FSTnsfjKkTwIlua3vJUf1H8kB7ECKHPpisplBiIUVZW7JmJWH491FnOZjeZ/QhXpfQ
         5TMMVsgcEIVN6RnpgalsfD77mjT+YUMp8qGOvmJw=
Message-ID: <75212b62a913a5376d9a6d567110178616d9a57f.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't try to handle hashed dentries in
 non-O_CREAT atomic_open
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 31 Oct 2019 16:38:09 -0400
In-Reply-To: <20191030164336.11163-1-jlayton@kernel.org>
References: <20191030164336.11163-1-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-10-30 at 12:43 -0400, Jeff Layton wrote:
> If ceph_atomic_open is handed a !d_in_lookup dentry, then that means
> that it already passed d_revalidate so we *know* what the state of the
> thing was just recently. Just bail out at that point and let the caller
> handle that case.
> 
> This also addresses a subtle bug in dentry handling. Non-O_CREAT opens
> call atomic_open with the parent's i_rwsem shared, but calling
> d_splice_alias on a hashed dentry requires the exclusive lock.
> 
> ceph_atomic_open could receive a hashed, negative dentry on a
> non-O_CREAT open. If another client were to race in and create the file
> before we issue our OPEN, ceph_fill_trace could end up calling
> d_splice_alias on the dentry with the new inode.
> 
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d277f71abe0b..691b7b1a6075 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -462,6 +462,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
>  		if (err < 0)
>  			goto out_ctx;
> +	} else if (!d_in_lookup(dentry)) {
> +		return finish_no_open(file, dentry);
>  	}
>  
>  	/* do the open */

Self NAK on this patch after further testing with KASAN. I'm seeing some
dcache corruption occur with this patch:

[ 1133.828015] ------------[ cut here ]------------
[ 1133.830150] list_del corruption. prev->next should be ffff88815b963f30, but was ffff88837e447010
[ 1133.832420] WARNING: CPU: 4 PID: 5360 at lib/list_debug.c:51 __list_del_entry_valid+0xb3/0xd0
[ 1133.834275] Modules linked in: ceph(O) libceph(O) rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd grace dns_resolver ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat iptable_mangle iptable_raw iptable_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables cachefiles fscache sunrpc joydev virtio_balloon i2c_piix4 edac_mce_amd xfs libcrc32c virtio_net net_failover virtio_blk failover virtio_console serio_raw virtio_pci ata_generic pata_acpi floppy virtio_rng virtio_ring virtio [last unloaded: libceph]
[ 1133.845815] CPU: 4 PID: 5360 Comm: blogbench Kdump: loaded Tainted: G           O      5.4.0-rc4+ #61
[ 1133.848720] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
[ 1133.850724] RIP: 0010:__list_del_entry_valid+0xb3/0xd0
[ 1133.852216] Code: 4c 89 e2 48 89 ee 48 c7 c7 c0 4d 67 82 e8 a4 2c 96 ff 0f 0b 31 c0 eb c6 4c 89 e2 48 89 ee 48 c7 c7 20 4e 67 82 e8 8c 2c 96 ff <0f> 0b 31 c0 eb ae 4c 89 e6 48 c7 c7 80 4e 67 82 e8 77 2c 96 ff 0f
[ 1133.856435] RSP: 0018:ffff888396ec7cd0 EFLAGS: 00010282
[ 1133.857530] RAX: 0000000000000000 RBX: ffff8880bf0978c0 RCX: 0000000000000000
[ 1133.858900] RDX: 1ffff11075ea4fd5 RSI: 0000000000000008 RDI: ffffed1072dd8f8c
[ 1133.860327] RBP: ffff88815b963f30 R08: 0000000000000001 R09: ffffed1075ea6261
[ 1133.861769] R10: ffffed1075ea6260 R11: ffff8883af531307 R12: ffff88837e447010
[ 1133.863211] R13: ffff88837e447010 R14: ffff88815b963f00 R15: ffff88815b963e98
[ 1133.864643] FS:  00007fd0bc088700(0000) GS:ffff8883af500000(0000) knlGS:0000000000000000
[ 1133.866589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1133.868003] CR2: 00007fd0a705cec8 CR3: 00000003a3a80000 CR4: 00000000000006e0
[ 1133.869849] Call Trace:
[ 1133.870803]  __dentry_kill+0xfe/0x280
[ 1133.871700]  ? dput+0x26/0x5f0
[ 1133.872467]  dput+0x367/0x5f0
[ 1133.873211]  do_renameat2+0x4d0/0x6d0
[ 1133.874079]  ? user_path_create+0x30/0x30
[ 1133.874955]  ? lock_downgrade+0x360/0x360
[ 1133.875903]  ? blkcg_maybe_throttle_current+0x7a/0x7d0
[ 1133.877077]  ? _raw_spin_unlock_irq+0x29/0x40
[ 1133.879007]  ? trace_hardirqs_on_thunk+0x1a/0x20
[ 1133.880113]  __x64_sys_rename+0x3a/0x40
[ 1133.881072]  do_syscall_64+0x6e/0xc0
[ 1133.882215]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1133.883568] RIP: 0033:0x7fd0bd8e34fb
[ 1133.884492] Code: e8 0a ad 09 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5d c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5d c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 59 b9 16 00 f7 d8
[ 1133.888266] RSP: 002b:00007fd0bc085eb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
[ 1133.890069] RAX: ffffffffffffffda RBX: 0000000000007c00 RCX: 00007fd0bd8e34fb
[ 1133.891611] RDX: 0000000000001824 RSI: 00007fd0bc086ee0 RDI: 00007fd0bc085ec0
[ 1133.893028] RBP: 0000000000000400 R08: 0000000000000000 R09: 00007fd0bda4f260
[ 1133.894512] R10: 0000000000000180 R11: 0000000000000246 R12: 00007fd0bc086ee0
[ 1133.896169] R13: 00007ffc5dced0cf R14: 00007ffc5dced0d0 R15: 00007fd0bc087fc0
[ 1133.897741] irq event stamp: 14346
[ 1133.898580] hardirqs last  enabled at (14345): [<ffffffff811ef629>] console_unlock+0x569/0x720
[ 1133.900455] hardirqs last disabled at (14346): [<ffffffff810044ca>] trace_hardirqs_off_thunk+0x1a/0x20
[ 1133.902707] softirqs last  enabled at (14342): [<ffffffff8220046a>] __do_softirq+0x46a/0x5a1
[ 1133.904626] softirqs last disabled at (14335): [<ffffffff81137820>] irq_exit+0x150/0x160
[ 1133.906506] ---[ end trace 5de2da24d1897e08 ]---
[ 1133.908051] ==================================================================
[ 1133.910617] BUG: KASAN: null-ptr-deref in __dentry_lease_unlist+0x1b/0x110 [ceph]
[ 1133.912667] Read of size 4 at addr 0000000000000020 by task blogbench/5360
[ 1133.914493] 
[ 1133.915206] CPU: 4 PID: 5360 Comm: blogbench Kdump: loaded Tainted: G        W  O      5.4.0-rc4+ #61
[ 1133.917069] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
[ 1133.918836] Call Trace:
[ 1133.919488]  dump_stack+0x9a/0xf0
[ 1133.920290]  ? __dentry_lease_unlist+0x1b/0x110 [ceph]
[ 1133.921372]  ? __dentry_lease_unlist+0x1b/0x110 [ceph]
[ 1133.922482]  __kasan_report.cold+0x5/0x33
[ 1133.923447]  ? __dentry_lease_unlist+0x1b/0x110 [ceph]
[ 1133.924654]  kasan_report+0xe/0x20
[ 1133.925572]  __dentry_lease_unlist+0x1b/0x110 [ceph]
[ 1133.926751]  ceph_d_release+0x40/0xd0 [ceph]
[ 1133.927843]  __dentry_kill+0x1df/0x280
[ 1133.928757]  ? dput+0x26/0x5f0
[ 1133.929629]  dput+0x367/0x5f0
[ 1133.930434]  do_renameat2+0x4d0/0x6d0
[ 1133.931407]  ? user_path_create+0x30/0x30
[ 1133.932432]  ? lock_downgrade+0x360/0x360
[ 1133.933535]  ? blkcg_maybe_throttle_current+0x7a/0x7d0
[ 1133.934704]  ? _raw_spin_unlock_irq+0x29/0x40
[ 1133.935703]  ? trace_hardirqs_on_thunk+0x1a/0x20
[ 1133.936868]  __x64_sys_rename+0x3a/0x40
[ 1133.937841]  do_syscall_64+0x6e/0xc0
[ 1133.939672]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1133.941033] RIP: 0033:0x7fd0bd8e34fb
[ 1133.942432] Code: e8 0a ad 09 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5d c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5d c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 59 b9 16 00 f7 d8
[ 1133.947176] RSP: 002b:00007fd0bc085eb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
[ 1133.948932] RAX: ffffffffffffffda RBX: 0000000000007c00 RCX: 00007fd0bd8e34fb
[ 1133.950510] RDX: 0000000000001824 RSI: 00007fd0bc086ee0 RDI: 00007fd0bc085ec0
[ 1133.952017] RBP: 0000000000000400 R08: 0000000000000000 R09: 00007fd0bda4f260
[ 1133.953516] R10: 0000000000000180 R11: 0000000000000246 R12: 00007fd0bc086ee0
[ 1133.955181] R13: 00007ffc5dced0cf R14: 00007ffc5dced0d0 R15: 00007fd0bc087fc0
[ 1133.956913] ==================================================================


It looks like the dentry is being prematurely freed.

Now that I look closer, it seems like other fs' never call
finish_no_open with a negative dentry, so I'm thinking that may be part
of the problem here.

I'll send a v2 for this patch in a bit that just has it return -ENOENT
in this case instead of finish_no_open. If the dentry is not being
looked up, then we know it's negative so I think that's probably fine.

-- 
Jeff Layton <jlayton@kernel.org>

