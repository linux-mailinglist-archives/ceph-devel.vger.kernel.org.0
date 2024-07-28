Return-Path: <ceph-devel+bounces-1570-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B59A493E4A3
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jul 2024 12:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C8031F2172C
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jul 2024 10:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8742BAE5;
	Sun, 28 Jul 2024 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="i2UfbhI5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B85079FE
	for <ceph-devel@vger.kernel.org>; Sun, 28 Jul 2024 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722163807; cv=none; b=iOQ3qmS8IZvN9jhTMsO2F8klSmGpJ8OdRCQNB/wckjyx/KoX4qLTiC5KqZmg+5m6KJw0L+M6kp4h5ERl+wIxg0TTcV2MhrQN1DhhwzNiGwbGbjue2dEnQnZYDkt+ZG8rLnCfnnlC4voO1pZHvR8ip2LeCuJuG7eewD6IHESAG9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722163807; c=relaxed/simple;
	bh=EoYaL+mLJByPrinJnBR2J5nYwvdm6u0KzhxQwIuie9A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=fsSKd5bErvKVB3rEH66WCS57/oc0fohnmt1+vOMZFMiwarVZ0SXFB9UqNK4LH+EQE74nO+bUtgH425LSt1LwHdDajosfTPUp/MtfRP17cA73lJH4jr8dpP3H9XyJyZ4zb2zby9Jb9yjcRM+IgjCf6CMfBu1L6HEAOf1xgRnAcZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=i2UfbhI5; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77ec5d3b0dso333042266b.0
        for <ceph-devel@vger.kernel.org>; Sun, 28 Jul 2024 03:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722163803; x=1722768603; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=09/k60kZWNc6aqMN9cbd3E96NZpZdb40JpW7ARPp7ik=;
        b=i2UfbhI5xr22sEneRmQRjliVERHrP9NiFDgpXPHaFpUNc++vhPNvU3sRFJZKgkZIlC
         k7TG9kjK5S7sRjc+MyfVX7i6ooyJHqNyBDm/y9h0/3C8CLVtzJLubA98i0/QRaPB1I6N
         Vl9bZ/K08cHyXTRBoH5fm0pl6Co5g8owmOn+pJDHNOwwL36dqB6lwuCQhB8AcbFk4fmc
         8o8tGz4sfmdZYhWBzsEZfbrDaDKmLclu3tSeB9Z0qhvsQZNLLmf+PslTD2zIAjqy9pGW
         F+D0/vek2cmUhjeJ3VMkO1iIgO15SL5jtdp0+3QQTmq1cY6xoR3tnslLLt4n/ruCceVa
         xJqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722163803; x=1722768603;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=09/k60kZWNc6aqMN9cbd3E96NZpZdb40JpW7ARPp7ik=;
        b=YRbwma3D6PgvpOLN0lpDqvZvHx4zZZ/VQ+A8TgaBaephYFg08Ev1fbKb4uJmbg5g8D
         PPaePaoz5+XediiBCcJJvxjyYlzhsrpGPpMNKytEG/M/DxDOABWDsFeHmqvEiWB1bIt3
         WaHDChBLauaGBo1rkxhcbs0gpUey10i8CE87xRxArE6HYaIrObzW2v5yzm+cMrlh4eps
         67ukoAzpIiokxnpishmUUsG79ewMyqJ5J+rjzhge0njaiIGQBpdznJ2e/NenluTEudjL
         J36PCj7UakU2bQ9A3mIn4xCNG7w37v7NrRtR8zv0o5ze9Mp5wMJDFjiPdtrQgl3vIYKQ
         2qpw==
X-Forwarded-Encrypted: i=1; AJvYcCW+vah78A+ZJvUOQUlxNDCVhONTv9w8oz+MtOWniK6Ao23Tzer5wcn1v2lfB95cLZ3t3bshyElu64AcggzoBb1aDyjd/koncnR6Tw==
X-Gm-Message-State: AOJu0Yw6+QB970av8ReqMx73vokiLZAueUfEkWt0DVypDomgMKS/HfDk
	iu5hoMand8A+pokkhBWEs51gSlq4RzTH7tEIudsJU3UBg/rdPanuxhBZ/7oVoNe591QNIsioaJy
	BGmgZbAtaEnzz09MfXjQ3KkLrdO44cXTFVyDouQ==
X-Google-Smtp-Source: AGHT+IF7iV4aj1iGM8VKKufqx8ukGL7Ctkzc7F5g55X0WhODVsuBbmrl6ZsbAl2rIFwuUbPuJ+W/jhWfJJ1rABEn/24=
X-Received: by 2002:a17:906:c115:b0:a7d:35d7:4aa9 with SMTP id
 a640c23a62f3a-a7d4005781dmr321416866b.34.1722163802681; Sun, 28 Jul 2024
 03:50:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Max Kellermann <max.kellermann@ionos.com>
Date: Sun, 28 Jul 2024 12:49:51 +0200
Message-ID: <CAKPOu+_DA8XiMAA2ApMj7Pyshve_YWknw8Hdt1=zCy9Y87R1qw@mail.gmail.com>
Subject: RCU stalls and GPFs in ceph/netfs
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, netfs@lists.linux.dev, linux-kernel@vger.kernel.org, 
	ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi David,

in the last few days, I have been chasing a 6.10 regression. After
updating one of our servers from 6.9.10 to 6.10.1, I found various
problems that may or may not be caused by the same code change
(abbreviated):

[  108.043488] WARNING: CPU: 0 PID: 2860 at fs/ceph/caps.c:3386
ceph_put_wrbuffer_cap_refs+0x1bb/0x1f0
[  108.043498] Modules linked in:
[  108.043500] CPU: 0 PID: 2860 Comm: rsync Not tainted 6.10.1-cm4all1-vm+ #117
[  108.043505] RIP: 0010:ceph_put_wrbuffer_cap_refs+0x1bb/0x1f0
[  108.043526] Call Trace:
[  108.043573]  ? ceph_put_wrbuffer_cap_refs+0x27/0x1f0
[  108.043575]  ceph_invalidate_folio+0x9a/0xc0
[  108.043577]  truncate_cleanup_folio+0x52/0x90
[  108.043583]  truncate_inode_pages_range+0xfe/0x400
[  108.043585]  ? __rseq_handle_notify_resume+0x25b/0x480
[  108.043589]  ? vfs_read+0x246/0x340

[  108.043705] BUG: kernel NULL pointer dereference, address: 0000000000000356
[  108.043948] #PF: supervisor write access in kernel mode
[  108.044166] #PF: error_code(0x0002) - not-present page
[  108.044341] PGD 0 P4D 0
[  108.044465] Oops: Oops: 0002 [#1] SMP PTI
[  108.048393] Call Trace:
[  108.050002]  ? ceph_put_snap_context+0xf/0x30
[  108.050178]  ceph_invalidate_folio+0xa2/0xc0
[  108.050356]  truncate_cleanup_folio+0x52/0x90
[  108.050532]  truncate_inode_pages_range+0xfe/0x400
[  108.050711]  ? __rseq_handle_notify_resume+0x25b/0x480
[  108.050896]  ? vfs_read+0x246/0x340

[  104.587469] Oops: general protection fault, probably for
non-canonical address 0xe01ffbf110207cde: 0000 [#1] SMP KASAN PTI
[  104.588429] KASAN: maybe wild-memory-access in range
[0x00ffff888103e6f0-0x00ffff888103e6f7]
[  104.588663] CPU: 6 PID: 2882 Comm: php-cgi8.1 Not tainted
6.10.1-cm4all1-vm+ #120
[  104.591880] Call Trace:
[  104.592015]  <TASK>
[  104.592207]  ? die_addr+0x3c/0xa0
[  104.592411]  ? exc_general_protection+0x113/0x200
[  104.592650]  ? asm_exc_general_protection+0x22/0x30
[  104.592876]  ? netfs_alloc_request+0x761/0xbd0
[  104.593099]  ? netfs_read_folio+0x11f/0xad0
[  104.593318]  ? netfs_read_folio+0xf6/0xad0
[  104.593498]  ? filemap_get_read_batch+0x2dd/0x650
[  104.593677]  ? __pfx_netfs_read_folio+0x10/0x10
[  104.593854]  filemap_read_folio+0xb2/0x210
[  104.594042]  ? __pfx_filemap_read_folio+0x10/0x10
[  104.594226]  ? __pfx_stack_trace_save+0x10/0x10
[  104.594417]  ? stack_depot_save_flags+0x24/0x690
[  104.594616]  filemap_get_pages+0xaf8/0x1200
[  104.594821]  ? __pfx_filemap_get_pages+0x10/0x10
[  104.595012]  ? _raw_spin_lock+0x7a/0xd0

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu:         7-....: (2099 ticks this GP)
idle=4874/1/0x4000000000000000 softirq=1503/1503 fqs=1049
 rcu:         (t=2100 jiffies g=4053 q=344 ncpus=16)
 CPU: 7 PID: 3443 Comm: php-was Not tainted 6.9.0-vm+ #139
 Call Trace:
  <IRQ>
  ? rcu_dump_cpu_stacks+0xed/0x170
  ? rcu_sched_clock_irq+0x558/0xbc0
  ? __smp_call_single_queue+0x8b/0xe0
  ? update_process_times+0x69/0xa0
  ? tick_nohz_handler+0x87/0x120
  ? __pfx_tick_nohz_handler+0x10/0x10
  ? __hrtimer_run_queues+0x110/0x250
  ? hrtimer_interrupt+0xf6/0x230
  ? __sysvec_apic_timer_interrupt+0x51/0x120
  ? sysvec_apic_timer_interrupt+0x60/0x80
  </IRQ>
  <TASK>
  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
  ? __xas_next+0xc6/0xe0
  filemap_get_read_batch+0x163/0x240
  filemap_get_pages+0x9a/0x5c0
  filemap_read+0xd9/0x310
  ? __ceph_get_caps+0xd5/0x580
  ? __ceph_caps_issued_mask+0x156/0x210

These servers have Ceph mounts with fscache.

At first, it looked like these bugs could be triggered easily and I
did a bisect; however the WARNING in Ceph code went away, and going
back further in the git history made reproducing the problem less
likely. I tried KASAN but it didn't give any more information.

After a few dead ends (due to some false "good" commits), the bisect
arrived at your commit 2e9d7e4b984a61 ("mm: Remove the PG_fscache
alias for PG_private_2"). This commit easily reproduces the RCU stalls
on my server. The preceding commit 2ff1e97587f4d3 ("netfs: Replace
PG_fscache by setting folio->private and marking dirty") never did,
not even after an hour of rebooting and retrying.

This is how the RCU stall looks like on 2e9d7e4b984a61:

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu:         6-....: (46220 ticks this GP)
idle=4bfc/1/0x4000000000000000 softirq=1594/1594 fqs=21190
 rcu:         (t=46221 jiffies g=2577 q=7220 ncpus=16)
 CPU: 6 PID: 3119 Comm: wordpress-manag Not tainted
6.9.0-rc6-vm-00004-gae678317b95e #160
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 RIP: 0010:filemap_get_read_batch+0x7b/0x240
 Code: 48 c7 44 24 30 00 00 00 00 48 89 e7 e8 ee d4 99 00 48 85 c0 0f
84 bf 00 00 00 48 89 c7 48 81 ff 06 04 00 00 0f 84 fd 00 00 00 <48> 81
ff 02 04 00 00 0f 84 ca 00 00 00 48 3b 6c 24 08 0f 82 97 00
 RSP: 0018:ffffbb2500fef8f8 EFLAGS: 00000296
 RAX: ffffefa30509c740 RBX: ffffbb2500fefa50 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffefa30509c740
 RBP: 0000000000000003 R08: 0000000000000000 R09: ffffbb2500fefaec
 R10: ffff9acb4a77ec80 R11: 0000000000000000 R12: ffffbb2500fefc58
 R13: ffff9acb5c381d00 R14: 0000000000000000 R15: ffffbb2500fefc80
 FS:  00007f5f6b6eeb80(0000) GS:ffff9ad64ef80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005623dea2b3d8 CR3: 000000011b658003 CR4: 00000000001706b0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <IRQ>
  ? rcu_dump_cpu_stacks+0xed/0x170
  ? rcu_sched_clock_irq+0x558/0xbc0
  ? __smp_call_single_queue+0x8b/0xe0
  ? update_process_times+0x69/0xa0
  ? tick_nohz_handler+0x87/0x120
  ? __pfx_tick_nohz_handler+0x10/0x10
  ? __hrtimer_run_queues+0x110/0x250
  ? hrtimer_interrupt+0xf6/0x230
  ? __sysvec_apic_timer_interrupt+0x51/0x120
  ? sysvec_apic_timer_interrupt+0x60/0x80
  </IRQ>
  <TASK>
  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
  ? filemap_get_read_batch+0x7b/0x240
  ? filemap_get_read_batch+0x163/0x240
  filemap_get_pages+0x9a/0x5c0
  ? __call_rcu_common.constprop.0+0x87/0x220
  filemap_read+0xd9/0x310
  ? __ceph_get_caps+0xd5/0x580
  ? terminate_walk+0x95/0x100
  ? path_openat+0xca3/0xf10
  ceph_read_iter+0x3e1/0x620
  vfs_read+0x23a/0x330
  ksys_read+0x63/0xe0
  do_syscall_64+0x66/0x100
  ? __alloc_pages+0x176/0x2e0
  ? __count_memcg_events+0x4e/0xb0
  ? __pte_offset_map_lock+0x60/0xe0
  ? __mod_memcg_lruvec_state+0x89/0x110
  ? __lruvec_stat_mod_folio+0x41/0x70
  ? do_anonymous_page+0x6dc/0x840
  ? __handle_mm_fault+0x936/0x1250
  ? __count_memcg_events+0x4e/0xb0
  ? handle_mm_fault+0xa2/0x2a0
  ? do_user_addr_fault+0x308/0x5d0
  ? exc_page_fault+0x62/0x120
  ? irqentry_exit_to_user_mode+0x40/0xf0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

When that happens, the process is at 100% CPU usage, but gdb/strace
cannot attach, and /proc/PID/stack is empty. I tried "perf record" and
found the process was busy-looping inside filemap_get_pages(), calling
filemap_get_read_batch() over and over, saw some xas_ calls but
nothing else.

Your commit 2e9d7e4b984a61 is too obscure for me, I don't know that
part of the kernel, and I can't imagine how it can cause such a
regression, but maybe you have an idea?

I can get you more information or try patches with more debugging code
if you want.

Max

