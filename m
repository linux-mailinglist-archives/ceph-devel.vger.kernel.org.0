Return-Path: <ceph-devel+bounces-1571-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B3FE93E4D8
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jul 2024 13:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B1FE1C2133A
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jul 2024 11:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0982376E6;
	Sun, 28 Jul 2024 11:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BShK2bkr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527202F36;
	Sun, 28 Jul 2024 11:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722167130; cv=none; b=RYHOTNgsve6OAxQiRMRUh18x6fHOxaFMI6RoSSgxjv5hdUMD78kZplRxbpSbdBLXV0KbmABcmkB9ftXFkyloho0vjM5H3sBI//cvDxbs7ptdY82ULKTrLTiKyeRNcgZFGqltWY8bk3xNb5hQmdOfepFYWdSPO+A4fF37rhZQmwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722167130; c=relaxed/simple;
	bh=h2Sdtnfpylp7/HA0soS82YP16bpCKxTXKnPcdg0HzUM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kJfoTIO8QEsOc3ee4jhel8KyfehArUnUw+UyLnipcpIl0xfyfCy/Li2EhLf2Z42G/A89fy+Ety8Ny7OtBoi8mVOfvRBP0SjdLGHEP1NR4+XS1at7mDCYpPx0y/poL8AdhgFyvFEnuIMzCHJAqZG0mZ7kbjhYqpGw3x+5VtwUGNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BShK2bkr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE77C116B1;
	Sun, 28 Jul 2024 11:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722167129;
	bh=h2Sdtnfpylp7/HA0soS82YP16bpCKxTXKnPcdg0HzUM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=BShK2bkrkEo8O6Uo6VMb+fBUzxfb0oFDEUoqdd8+m0VqtU+dw9WTrn0OQFbIayUkF
	 RkGgK+DNnO0+BixwNnKZgmQzYE9tHflRZLLgmAX3wY2eufsmMbiLII7lKQJKZAM96o
	 0gbxjtEGgTP2//wCTJx26jGu4xu1Lsy6GPnwlwtmB3i52aV1tEoC8fdtRJMaSntkE7
	 8UbOlipAN/GHymMpVeYT0apza+9WNwbKTCC/1WRZ/PFqfEjrxD1cJVs0+aN0KyfEhV
	 9Pr35G3BYAGQKayS8sme0tvmRLN//oJ9v4+t90wVHZeDFdbm79DX8xM7DaCbNHfesy
	 2tHI/LzSryTEw==
Message-ID: <e5f8c7b5d0657bcb10daa6fe268a62a7ed1b7672.camel@kernel.org>
Subject: Re: RCU stalls and GPFs in ceph/netfs
From: Jeff Layton <jlayton@kernel.org>
To: Max Kellermann <max.kellermann@ionos.com>, David Howells
	 <dhowells@redhat.com>
Cc: netfs@lists.linux.dev, linux-kernel@vger.kernel.org, 
	ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Date: Sun, 28 Jul 2024 07:45:27 -0400
In-Reply-To: <CAKPOu+_DA8XiMAA2ApMj7Pyshve_YWknw8Hdt1=zCy9Y87R1qw@mail.gmail.com>
References: 
	<CAKPOu+_DA8XiMAA2ApMj7Pyshve_YWknw8Hdt1=zCy9Y87R1qw@mail.gmail.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 (3.52.3-1.fc40app2) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2024-07-28 at 12:49 +0200, Max Kellermann wrote:
> Hi David,
>=20
> in the last few days, I have been chasing a 6.10 regression. After
> updating one of our servers from 6.9.10 to 6.10.1, I found various
> problems that may or may not be caused by the same code change
> (abbreviated):
>=20
> [  108.043488] WARNING: CPU: 0 PID: 2860 at fs/ceph/caps.c:3386
> ceph_put_wrbuffer_cap_refs+0x1bb/0x1f0
> [  108.043498] Modules linked in:
> [  108.043500] CPU: 0 PID: 2860 Comm: rsync Not tainted 6.10.1-cm4all1-vm=
+ #117
> [  108.043505] RIP: 0010:ceph_put_wrbuffer_cap_refs+0x1bb/0x1f0
> [  108.043526] Call Trace:
> [  108.043573]  ? ceph_put_wrbuffer_cap_refs+0x27/0x1f0
> [  108.043575]  ceph_invalidate_folio+0x9a/0xc0
> [  108.043577]  truncate_cleanup_folio+0x52/0x90
> [  108.043583]  truncate_inode_pages_range+0xfe/0x400
> [  108.043585]  ? __rseq_handle_notify_resume+0x25b/0x480
> [  108.043589]  ? vfs_read+0x246/0x340
>
> [  108.043705] BUG: kernel NULL pointer dereference, address: 00000000000=
00356
> [  108.043948] #PF: supervisor write access in kernel mode
> [  108.044166] #PF: error_code(0x0002) - not-present page
> [  108.044341] PGD 0 P4D 0
> [  108.044465] Oops: Oops: 0002 [#1] SMP PTI
> [  108.048393] Call Trace:
> [  108.050002]  ? ceph_put_snap_context+0xf/0x30
> [  108.050178]  ceph_invalidate_folio+0xa2/0xc0
> [  108.050356]  truncate_cleanup_folio+0x52/0x90
> [  108.050532]  truncate_inode_pages_range+0xfe/0x400
> [  108.050711]  ? __rseq_handle_notify_resume+0x25b/0x480
> [  108.050896]  ? vfs_read+0x246/0x340
>=20
> [  104.587469] Oops: general protection fault, probably for
> non-canonical address 0xe01ffbf110207cde: 0000 [#1] SMP KASAN PTI
> [  104.588429] KASAN: maybe wild-memory-access in range
> [0x00ffff888103e6f0-0x00ffff888103e6f7]
> [  104.588663] CPU: 6 PID: 2882 Comm: php-cgi8.1 Not tainted
> 6.10.1-cm4all1-vm+ #120
> [  104.591880] Call Trace:
> [  104.592015]  <TASK>
> [  104.592207]  ? die_addr+0x3c/0xa0
> [  104.592411]  ? exc_general_protection+0x113/0x200
> [  104.592650]  ? asm_exc_general_protection+0x22/0x30
> [  104.592876]  ? netfs_alloc_request+0x761/0xbd0
> [  104.593099]  ? netfs_read_folio+0x11f/0xad0
> [  104.593318]  ? netfs_read_folio+0xf6/0xad0
> [  104.593498]  ? filemap_get_read_batch+0x2dd/0x650
> [  104.593677]  ? __pfx_netfs_read_folio+0x10/0x10
> [  104.593854]  filemap_read_folio+0xb2/0x210
> [  104.594042]  ? __pfx_filemap_read_folio+0x10/0x10
> [  104.594226]  ? __pfx_stack_trace_save+0x10/0x10
> [  104.594417]  ? stack_depot_save_flags+0x24/0x690
> [  104.594616]  filemap_get_pages+0xaf8/0x1200
> [  104.594821]  ? __pfx_filemap_get_pages+0x10/0x10
> [  104.595012]  ? _raw_spin_lock+0x7a/0xd0
>=20
>  rcu: INFO: rcu_sched self-detected stall on CPU
>  rcu:         7-....: (2099 ticks this GP)
> idle=3D4874/1/0x4000000000000000 softirq=3D1503/1503 fqs=3D1049
>  rcu:         (t=3D2100 jiffies g=3D4053 q=3D344 ncpus=3D16)
>  CPU: 7 PID: 3443 Comm: php-was Not tainted 6.9.0-vm+ #139
>  Call Trace:
>   <IRQ>
>   ? rcu_dump_cpu_stacks+0xed/0x170
>   ? rcu_sched_clock_irq+0x558/0xbc0
>   ? __smp_call_single_queue+0x8b/0xe0
>   ? update_process_times+0x69/0xa0
>   ? tick_nohz_handler+0x87/0x120
>   ? __pfx_tick_nohz_handler+0x10/0x10
>   ? __hrtimer_run_queues+0x110/0x250
>   ? hrtimer_interrupt+0xf6/0x230
>   ? __sysvec_apic_timer_interrupt+0x51/0x120
>   ? sysvec_apic_timer_interrupt+0x60/0x80
>   </IRQ>
>   <TASK>
>   ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>   ? __xas_next+0xc6/0xe0
>   filemap_get_read_batch+0x163/0x240
>   filemap_get_pages+0x9a/0x5c0
>   filemap_read+0xd9/0x310
>   ? __ceph_get_caps+0xd5/0x580
>   ? __ceph_caps_issued_mask+0x156/0x210
>=20
> These servers have Ceph mounts with fscache.
>=20
> At first, it looked like these bugs could be triggered easily and I
> did a bisect; however the WARNING in Ceph code went away, and going
> back further in the git history made reproducing the problem less
> likely. I tried KASAN but it didn't give any more information.
>=20
> After a few dead ends (due to some false "good" commits), the bisect
> arrived at your commit 2e9d7e4b984a61 ("mm: Remove the PG_fscache
> alias for PG_private_2"). This commit easily reproduces the RCU stalls
> on my server. The preceding commit 2ff1e97587f4d3 ("netfs: Replace
> PG_fscache by setting folio->private and marking dirty") never did,
> not even after an hour of rebooting and retrying.
>=20

That is really weird. AFAICT, 2e9d7e4b984a61 is just removing some
wrapper functions and changing the names of some others. There should
be no functional changes there. I'll keep looking but I don't see how
that commit would break anything.

> This is how the RCU stall looks like on 2e9d7e4b984a61:
>=20
>  rcu: INFO: rcu_sched self-detected stall on CPU
>  rcu:         6-....: (46220 ticks this GP)
> idle=3D4bfc/1/0x4000000000000000 softirq=3D1594/1594 fqs=3D21190
>  rcu:         (t=3D46221 jiffies g=3D2577 q=3D7220 ncpus=3D16)
>  CPU: 6 PID: 3119 Comm: wordpress-manag Not tainted
> 6.9.0-rc6-vm-00004-gae678317b95e #160
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/=
01/2014
>  RIP: 0010:filemap_get_read_batch+0x7b/0x240
>  Code: 48 c7 44 24 30 00 00 00 00 48 89 e7 e8 ee d4 99 00 48 85 c0 0f
> 84 bf 00 00 00 48 89 c7 48 81 ff 06 04 00 00 0f 84 fd 00 00 00 <48> 81
> ff 02 04 00 00 0f 84 ca 00 00 00 48 3b 6c 24 08 0f 82 97 00
>  RSP: 0018:ffffbb2500fef8f8 EFLAGS: 00000296
>  RAX: ffffefa30509c740 RBX: ffffbb2500fefa50 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffefa30509c740
>  RBP: 0000000000000003 R08: 0000000000000000 R09: ffffbb2500fefaec
>  R10: ffff9acb4a77ec80 R11: 0000000000000000 R12: ffffbb2500fefc58
>  R13: ffff9acb5c381d00 R14: 0000000000000000 R15: ffffbb2500fefc80
>  FS:  00007f5f6b6eeb80(0000) GS:ffff9ad64ef80000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00005623dea2b3d8 CR3: 000000011b658003 CR4: 00000000001706b0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   <IRQ>
>   ? rcu_dump_cpu_stacks+0xed/0x170
>   ? rcu_sched_clock_irq+0x558/0xbc0
>   ? __smp_call_single_queue+0x8b/0xe0
>   ? update_process_times+0x69/0xa0
>   ? tick_nohz_handler+0x87/0x120
>   ? __pfx_tick_nohz_handler+0x10/0x10
>   ? __hrtimer_run_queues+0x110/0x250
>   ? hrtimer_interrupt+0xf6/0x230
>   ? __sysvec_apic_timer_interrupt+0x51/0x120
>   ? sysvec_apic_timer_interrupt+0x60/0x80
>   </IRQ>
>   <TASK>
>   ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>   ? filemap_get_read_batch+0x7b/0x240
>   ? filemap_get_read_batch+0x163/0x240
>   filemap_get_pages+0x9a/0x5c0
>   ? __call_rcu_common.constprop.0+0x87/0x220
>   filemap_read+0xd9/0x310
>   ? __ceph_get_caps+0xd5/0x580
>   ? terminate_walk+0x95/0x100
>   ? path_openat+0xca3/0xf10
>   ceph_read_iter+0x3e1/0x620
>   vfs_read+0x23a/0x330
>   ksys_read+0x63/0xe0
>   do_syscall_64+0x66/0x100
>   ? __alloc_pages+0x176/0x2e0
>   ? __count_memcg_events+0x4e/0xb0
>   ? __pte_offset_map_lock+0x60/0xe0
>   ? __mod_memcg_lruvec_state+0x89/0x110
>   ? __lruvec_stat_mod_folio+0x41/0x70
>   ? do_anonymous_page+0x6dc/0x840
>   ? __handle_mm_fault+0x936/0x1250
>   ? __count_memcg_events+0x4e/0xb0
>   ? handle_mm_fault+0xa2/0x2a0
>   ? do_user_addr_fault+0x308/0x5d0
>   ? exc_page_fault+0x62/0x120
>   ? irqentry_exit_to_user_mode+0x40/0xf0
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>=20
> When that happens, the process is at 100% CPU usage, but gdb/strace
> cannot attach, and /proc/PID/stack is empty. I tried "perf record" and
> found the process was busy-looping inside filemap_get_pages(), calling
> filemap_get_read_batch() over and over, saw some xas_ calls but
> nothing else.
>=20
> Your commit 2e9d7e4b984a61 is too obscure for me, I don't know that
> part of the kernel, and I can't imagine how it can cause such a
> regression, but maybe you have an idea?
>=20
> I can get you more information or try patches with more debugging code
> if you want.
>=20


--=20
Jeff Layton <jlayton@kernel.org>

