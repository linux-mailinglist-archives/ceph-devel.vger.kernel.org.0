Return-Path: <ceph-devel+bounces-3933-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 285E8C3F9ED
	for <lists+ceph-devel@lfdr.de>; Fri, 07 Nov 2025 12:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0A5E3A9878
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Nov 2025 11:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AC72C21FB;
	Fri,  7 Nov 2025 11:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvPmoC2t"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5002F6596
	for <ceph-devel@vger.kernel.org>; Fri,  7 Nov 2025 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762513357; cv=none; b=mG8knGNKJtMfuO4ouAwu+xZtrvzd0Weflflh5Z6vrZ0yBVNVSh4dOdXlz1ZjtTixqoskjq+F+QrU3taEUCiqAA4GsisJWMb4gNogEse0Jd5wf3xbxKYcZ5WsTXfnFFzizyGHkT0KhXD4GwDfOEiUKw5G92FMUmZbhxmZo9jOGkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762513357; c=relaxed/simple;
	bh=0glgNOUYrPm5zcd0MVefgG0hgXf5oB9bFbZPXEg7K2o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PwoEqSJG6t6/aSETJ+bCBWtBezfKqIMs5lu+g1DqkOWDx7naqjNkAyBhwjRyhQlHU1bsJAtQO51HGd+wNTdl1WrWbPpq5UGKiSKEyyK+9NB1lKY7XRgLu6Ir4HVF+GFeOBseGniZFKjbw51m0dwfY+HXHlNfLlR+rpHRcWJoCjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NvPmoC2t; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ba507fe592dso379987a12.2
        for <ceph-devel@vger.kernel.org>; Fri, 07 Nov 2025 03:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762513354; x=1763118154; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XK1J1xn4Q03FzpnmhRDFHoASVG7PU1bHG/9O/porqGU=;
        b=NvPmoC2tx+QW7E3oQ3he7+lu6af94zG2DX97z0qhnb8RAuJsmwLntmJUVKneEOKtAo
         CwA1A/KQw7pW/ClN/ClbD6sDffFr5k0wOXClYWzVkCLsyUTEdFnXHMztn+48LU1V4Hew
         u7krKY5Fhs52q0mClG3tElHxH8qnO0p74OPKt/xqRxlWHhlNo02QAUITZp+c+IZPqyqX
         43mv+efZTH8LKJMJWZSSTbdKgAVmxbk1RZuB4Wc2FU+tAguVBWgV5KAw1PxePWPvi/Z5
         4nCeCzsV3kuo+cd3BSOgTe1wUj/0xOQ5l+W4awqQ8pPekio4P8Sra9M3NrFs235UPcrS
         7roA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762513354; x=1763118154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XK1J1xn4Q03FzpnmhRDFHoASVG7PU1bHG/9O/porqGU=;
        b=To/1UkihsYA5D5Gp/5uuqn2Q9wb4TqNx4Qs2FnFdUwgxHXredOH9NJRUxqfD+lDNa0
         yJGm8PIQUWMVaiiAi/J2fFnBfLxqw6xUdec2p1lqb5ie3MP9RKsiC3qmJ1gsWw4vonuZ
         S39cRVcgYCBGXFidHAt7jBXM9AGyBd0qynSW6mrf+gwJVrnHQOUunhOEF+Tf3Uj74/Aq
         FHYz6IE/iE9aXbGMrFYQWpQKOGEpV1VNYsRwSfA/gmnrsklWrN/zsrYzOvkWFdmrCjd3
         y8yZXMjLwHLEn7q2ymGuEFYOigMEeDGlKTz3TII8gRfs3EzBcsr9hxFtYvX4F1MhOLn3
         +fDA==
X-Gm-Message-State: AOJu0YwzEUjUZObmdLH6IXvdEv/+ff64h06RpsaYMQ20Zf3C9+LEx+Jr
	g3OMCnU6gwK6fvNulHnpiJJSPG6/lqkPc/WEQgqAzeYeVyvhZAzYwbbdSKK1hGKxUu5iLGob2Vl
	EnzGFY/wvjiaM6w7XHajzSUkBkS7wk3E=
X-Gm-Gg: ASbGnctgtArHu9YVSAfye3t8zwnre6Sd4IkC9X5MBl09Yr3poXNbxPxaru/QCxaKXyw
	LIdz1ZE3sfunzvuF+i1d9BC1HKM/3WbSmhtcY3EJkkFWvYtJ4XXrxnAW/jKTA2LunoeYDEhjzuc
	INKJjCQEjwMLhCbVcV1dK+YK3t27ZJyjz2gCdlLDib1t80QHjx//6GrgpFIV6czZ/SF4yHqM/IN
	PD+c6mN3E/vpv2JOlRAjDgwkS/Aurth0BH+NopummIBmGlzk8mBGs+qYGYB
X-Google-Smtp-Source: AGHT+IFun5AFjkDOhHtX6jQ3MMnLVmx4iGsxXuQ5aMgn+kynwKuAAaTcA4A8ZquVgFrWpZX+Lwu+nmuUSf0swu94PZg=
X-Received: by 2002:a17:902:f709:b0:267:a1f1:9b23 with SMTP id
 d9443c01a7336-297c03c72d9mr41381385ad.18.1762513353463; Fri, 07 Nov 2025
 03:02:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <dfc5c18d506d6183d1c3940dc819616dd24988b5.camel@ibm.com>
In-Reply-To: <dfc5c18d506d6183d1c3940dc819616dd24988b5.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 7 Nov 2025 12:02:21 +0100
X-Gm-Features: AWmQ_bl1EgnINHltUOWxlwlwcxD2ppWVCbrPVKejmvlh4TqNIbIfinLTFj0milw
Message-ID: <CAOi1vP_dh+SgsD7qeWgrrFsyG+-wtrzXJtatF+9pZ6qj_uRZmg@mail.gmail.com>
Subject: Re: [RFC] sparse read failure in fscrypt-encrypted directories for
 Ceph msgr2 protocol
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>, 
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 9:04=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> Hi Ilya,
>
> I am investigated the issue of Ceph msgr2 protocol implementation for the=
 case
> of fscrypt-encrypted directories. The issue has been reported in tracker =
[1]. I
> was able to reproduce the issue by this steps:
>
> sudo mount -t ceph :/ /mnt/cephfs/ -o name=3Dadmin,fs=3Dcephfs,ms_mode=3D=
secure
>
> The reproducing path:
> (1) mkdir /mnt/cephfs/fscrypt-test-3
> (2) cp area_decrypted.tar /mnt/cephfs/fscrypt-test-3
> (3) fscrypt encrypt --source=3Draw_key --key=3D./my.key /mnt/cephfs/fscry=
pt-test-3
> (4) fscrypt lock /mnt/cephfs/fscrypt-test-3
> (5) fscrypt unlock --key=3Dmy.key /mnt/cephfs/fscrypt-test-3
> (6) cat /mnt/cephfs/fscrypt-test-3/area_decrypted.tar
> (7) Issue has been triggered
>
> We have the call trace for the issue:
>
> [  408.072247] ------------[ cut here ]------------
> [  408.072251] WARNING: CPU: 1 PID: 392 at net/ceph/messenger_v2.c:865
> ceph_con_v2_try_read+0x4b39/0x72f0
> [  408.072267] Modules linked in: intel_rapl_msr intel_rapl_common
> intel_uncore_frequency_common intel_pmc_core pmt_telemetry pmt_discovery
> pmt_class intel_pmc_ssram_telemetry intel_vsec kvm_intel joydev kvm irqby=
pass
> polyval_clmulni ghash_clmulni_intel aesni_intel rapl input_leds psmouse
> serio_raw i2c_piix4 vga16fb bochs vgastate i2c_smbus floppy mac_hid qemu_=
fw_cfg
> pata_acpi sch_fq_codel rbd msr parport_pc ppdev lp parport efi_pstore
> [  408.072304] CPU: 1 UID: 0 PID: 392 Comm: kworker/1:3 Not tainted 6.17.=
0-rc7+
> #1 PREEMPT(voluntary)
> [  408.072307] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S
> 1.17.0-5.fc42 04/01/2014
> [  408.072310] Workqueue: ceph-msgr ceph_con_workfn
> [  408.072314] RIP: 0010:ceph_con_v2_try_read+0x4b39/0x72f0
> [  408.072317] Code: c7 c1 20 f0 d4 ae 50 31 d2 48 c7 c6 60 27 d5 ae 48 c=
7 c7 f8
> 8e 6f b0 68 60 38 d5 ae e8 00 47 61 fe 48 83 c4 18 e9 ac fc ff ff <0f> 0b=
 e9 06
> fe ff ff 4c 8b 9d 98 fd ff ff 0f 84 64 e7 ff ff 89 85
> [  408.072319] RSP: 0018:ffff88811c3e7a30 EFLAGS: 00010246
> [  408.072322] RAX: ffffed1024874c6f RBX: ffffea00042c2b40 RCX: 000000000=
0000f38
> [  408.072324] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000=
0000000
> [  408.072325] RBP: ffff88811c3e7ca8 R08: 0000000000000000 R09: 000000000=
00000c8
> [  408.072326] R10: 00000000000000c8 R11: 0000000000000000 R12: 000000000=
00000c8
> [  408.072327] R13: dffffc0000000000 R14: ffff8881243a6030 R15: 000000000=
0003000
> [  408.072329] FS:  0000000000000000(0000) GS:ffff88823eadf000(0000)
> knlGS:0000000000000000
> [  408.072331] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  408.072332] CR2: 000000c0003c6000 CR3: 000000010c106005 CR4: 000000000=
0772ef0
> [  408.072336] PKRU: 55555554
> [  408.072337] Call Trace:
> [  408.072338]  <TASK>
> [  408.072340]  ? sched_clock_noinstr+0x9/0x10
> [  408.072344]  ? __pfx_ceph_con_v2_try_read+0x10/0x10
> [  408.072347]  ? _raw_spin_unlock+0xe/0x40
> [  408.072349]  ? finish_task_switch.isra.0+0x15d/0x830
> [  408.072353]  ? __kasan_check_write+0x14/0x30
> [  408.072357]  ? mutex_lock+0x84/0xe0
> [  408.072359]  ? __pfx_mutex_lock+0x10/0x10
> [  408.072361]  ceph_con_workfn+0x27e/0x10e0
> [  408.072364]  ? metric_delayed_work+0x311/0x2c50
> [  408.072367]  process_one_work+0x611/0xe20
> [  408.072371]  ? __kasan_check_write+0x14/0x30
> [  408.072373]  worker_thread+0x7e3/0x1580
> [  408.072375]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [  408.072378]  ? __pfx_worker_thread+0x10/0x10
> [  408.072381]  kthread+0x381/0x7a0
> [  408.072383]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [  408.072385]  ? __pfx_kthread+0x10/0x10
> [  408.072387]  ? __kasan_check_write+0x14/0x30
> [  408.072389]  ? recalc_sigpending+0x160/0x220
> [  408.072392]  ? _raw_spin_unlock_irq+0xe/0x50
> [  408.072394]  ? calculate_sigpending+0x78/0xb0
> [  408.072395]  ? __pfx_kthread+0x10/0x10
> [  408.072397]  ret_from_fork+0x2b6/0x380
> [  408.072400]  ? __pfx_kthread+0x10/0x10
> [  408.072402]  ret_from_fork_asm+0x1a/0x30
> [  408.072406]  </TASK>
> [  408.072407] ---[ end trace 0000000000000000 ]---
> [  408.072418] Oops: general protection fault, probably for non-canonical
> address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> [  408.072984] KASAN: null-ptr-deref in range [0x0000000000000000-
> 0x0000000000000007]
> [  408.073350] CPU: 1 UID: 0 PID: 392 Comm: kworker/1:3 Tainted: G       =
 W
> 6.17.0-rc7+ #1 PREEMPT(voluntary)
> [  408.073886] Tainted: [W]=3DWARN
> [  408.074042] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S
> 1.17.0-5.fc42 04/01/2014
> [  408.074468] Workqueue: ceph-msgr ceph_con_workfn
> [  408.074694] RIP: 0010:ceph_msg_data_advance+0x79/0x1a80
> [  408.074976] Code: fc ff df 49 8d 77 08 48 c1 ee 03 80 3c 16 00 0f 85 0=
7 11 00
> 00 48 ba 00 00 00 00 00 fc ff df 49 8b 5f 08 48 89 de 48 c1 ee 03 <0f> b6=
 14 16
> 84 d2 74 09 80 fa 03 0f 8e 0f 0e 00 00 8b 13 83 fa 03
> [  408.075884] RSP: 0018:ffff88811c3e7990 EFLAGS: 00010246
> [  408.076305] RAX: ffff8881243a6388 RBX: 0000000000000000 RCX: 000000000=
0000000
> [  408.076909] RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffff88812=
43a6378
> [  408.077466] RBP: ffff88811c3e7a20 R08: 0000000000000000 R09: 000000000=
00000c8
> [  408.078034] R10: ffff8881243a6388 R11: 0000000000000000 R12: ffffed102=
4874c71
> [  408.078575] R13: dffffc0000000000 R14: ffff8881243a6030 R15: ffff88812=
43a6378
> [  408.079159] FS:  0000000000000000(0000) GS:ffff88823eadf000(0000)
> knlGS:0000000000000000
> [  408.079736] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  408.080039] CR2: 000000c0003c6000 CR3: 000000010c106005 CR4: 000000000=
0772ef0
> [  408.080376] PKRU: 55555554
> [  408.080513] Call Trace:
> [  408.080630]  <TASK>
> [  408.080729]  ceph_con_v2_try_read+0x49b9/0x72f0
> [  408.081115]  ? __pfx_ceph_con_v2_try_read+0x10/0x10
> [  408.081348]  ? _raw_spin_unlock+0xe/0x40
> [  408.081538]  ? finish_task_switch.isra.0+0x15d/0x830
> [  408.081768]  ? __kasan_check_write+0x14/0x30
> [  408.081986]  ? mutex_lock+0x84/0xe0
> [  408.082160]  ? __pfx_mutex_lock+0x10/0x10
> [  408.082343]  ceph_con_workfn+0x27e/0x10e0
> [  408.082529]  ? metric_delayed_work+0x311/0x2c50
> [  408.082737]  process_one_work+0x611/0xe20
> [  408.082948]  ? __kasan_check_write+0x14/0x30
> [  408.083156]  worker_thread+0x7e3/0x1580
> [  408.083331]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [  408.083557]  ? __pfx_worker_thread+0x10/0x10
> [  408.083751]  kthread+0x381/0x7a0
> [  408.083922]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [  408.084139]  ? __pfx_kthread+0x10/0x10
> [  408.084310]  ? __kasan_check_write+0x14/0x30
> [  408.084510]  ? recalc_sigpending+0x160/0x220
> [  408.084708]  ? _raw_spin_unlock_irq+0xe/0x50
> [  408.084917]  ? calculate_sigpending+0x78/0xb0
> [  408.085138]  ? __pfx_kthread+0x10/0x10
> [  408.085335]  ret_from_fork+0x2b6/0x380
> [  408.085525]  ? __pfx_kthread+0x10/0x10
> [  408.085720]  ret_from_fork_asm+0x1a/0x30
> [  408.085922]  </TASK>
> [  408.086036] Modules linked in: intel_rapl_msr intel_rapl_common
> intel_uncore_frequency_common intel_pmc_core pmt_telemetry pmt_discovery
> pmt_class intel_pmc_ssram_telemetry intel_vsec kvm_intel joydev kvm irqby=
pass
> polyval_clmulni ghash_clmulni_intel aesni_intel rapl input_leds psmouse
> serio_raw i2c_piix4 vga16fb bochs vgastate i2c_smbus floppy mac_hid qemu_=
fw_cfg
> pata_acpi sch_fq_codel rbd msr parport_pc ppdev lp parport efi_pstore
> [  408.087778] ---[ end trace 0000000000000000 ]---
> [  408.088007] RIP: 0010:ceph_msg_data_advance+0x79/0x1a80
> [  408.088260] Code: fc ff df 49 8d 77 08 48 c1 ee 03 80 3c 16 00 0f 85 0=
7 11 00
> 00 48 ba 00 00 00 00 00 fc ff df 49 8b 5f 08 48 89 de 48 c1 ee 03 <0f> b6=
 14 16
> 84 d2 74 09 80 fa 03 0f 8e 0f 0e 00 00 8b 13 83 fa 03
> [  408.089118] RSP: 0018:ffff88811c3e7990 EFLAGS: 00010246
> [  408.089357] RAX: ffff8881243a6388 RBX: 0000000000000000 RCX: 000000000=
0000000
> [  408.089678] RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffff88812=
43a6378
> [  408.090020] RBP: ffff88811c3e7a20 R08: 0000000000000000 R09: 000000000=
00000c8
> [  408.090360] R10: ffff8881243a6388 R11: 0000000000000000 R12: ffffed102=
4874c71
> [  408.090687] R13: dffffc0000000000 R14: ffff8881243a6030 R15: ffff88812=
43a6378
> [  408.091035] FS:  0000000000000000(0000) GS:ffff88823eadf000(0000)
> knlGS:0000000000000000
> [  408.091452] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  408.092015] CR2: 000000c0003c6000 CR3: 000000010c106005 CR4: 000000000=
0772ef0
> [  408.092530] PKRU: 55555554
> [  417.112915]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  417.113491] BUG: KASAN: slab-use-after-free in
> __mutex_lock.constprop.0+0x1522/0x1610
> [  417.114014] Read of size 4 at addr ffff888124870034 by task kworker/2:=
0/4951
>
> [  417.114587] CPU: 2 UID: 0 PID: 4951 Comm: kworker/2:0 Tainted: G      =
D W
> 6.17.0-rc7+ #1 PREEMPT(voluntary)
> [  417.114592] Tainted: [D]=3DDIE, [W]=3DWARN
> [  417.114593] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S
> 1.17.0-5.fc42 04/01/2014
> [  417.114596] Workqueue: events handle_timeout
> [  417.114601] Call Trace:
> [  417.114602]  <TASK>
> [  417.114604]  dump_stack_lvl+0x5c/0x90
> [  417.114610]  print_report+0x171/0x4dc
> [  417.114613]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [  417.114617]  ? kasan_complete_mode_report_info+0x80/0x220
> [  417.114621]  kasan_report+0xbd/0x100
> [  417.114625]  ? __mutex_lock.constprop.0+0x1522/0x1610
> [  417.114628]  ? __mutex_lock.constprop.0+0x1522/0x1610
> [  417.114630]  __asan_report_load4_noabort+0x14/0x30
> [  417.114633]  __mutex_lock.constprop.0+0x1522/0x1610
> [  417.114635]  ? queue_con_delay+0x8d/0x200
> [  417.114638]  ? __pfx___mutex_lock.constprop.0+0x10/0x10
> [  417.114641]  ? __send_subscribe+0x529/0xb20
> [  417.114644]  __mutex_lock_slowpath+0x13/0x20
> [  417.114646]  mutex_lock+0xd4/0xe0
> [  417.114649]  ? __pfx_mutex_lock+0x10/0x10
> [  417.114652]  ? ceph_monc_renew_subs+0x2a/0x40
> [  417.114654]  ceph_con_keepalive+0x22/0x110
> [  417.114656]  handle_timeout+0x6b3/0x11d0
> [  417.114659]  ? _raw_spin_unlock_irq+0xe/0x50
> [  417.114662]  ? __pfx_handle_timeout+0x10/0x10
> [  417.114664]  ? queue_delayed_work_on+0x8e/0xa0
> [  417.114669]  process_one_work+0x611/0xe20
> [  417.114672]  ? __kasan_check_write+0x14/0x30
> [  417.114676]  worker_thread+0x7e3/0x1580
> [  417.114678]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [  417.114682]  ? __pfx_sched_setscheduler_nocheck+0x10/0x10
> [  417.114687]  ? __pfx_worker_thread+0x10/0x10
> [  417.114689]  kthread+0x381/0x7a0
> [  417.114692]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [  417.114694]  ? __pfx_kthread+0x10/0x10
> [  417.114697]  ? __kasan_check_write+0x14/0x30
> [  417.114699]  ? recalc_sigpending+0x160/0x220
> [  417.114703]  ? _raw_spin_unlock_irq+0xe/0x50
> [  417.114705]  ? calculate_sigpending+0x78/0xb0
> [  417.114707]  ? __pfx_kthread+0x10/0x10
> [  417.114710]  ret_from_fork+0x2b6/0x380
> [  417.114713]  ? __pfx_kthread+0x10/0x10
> [  417.114715]  ret_from_fork_asm+0x1a/0x30
> [  417.114720]  </TASK>
>
> [  417.125171] Allocated by task 2:
> [  417.125333]  kasan_save_stack+0x26/0x60
> [  417.125522]  kasan_save_track+0x14/0x40
> [  417.125742]  kasan_save_alloc_info+0x39/0x60
> [  417.125945]  __kasan_slab_alloc+0x8b/0xb0
> [  417.126133]  kmem_cache_alloc_node_noprof+0x13b/0x460
> [  417.126381]  copy_process+0x320/0x6250
> [  417.126595]  kernel_clone+0xb7/0x840
> [  417.126792]  kernel_thread+0xd6/0x120
> [  417.126995]  kthreadd+0x85c/0xbe0
> [  417.127176]  ret_from_fork+0x2b6/0x380
> [  417.127378]  ret_from_fork_asm+0x1a/0x30
>
> [  417.127692] Freed by task 0:
> [  417.127851]  kasan_save_stack+0x26/0x60
> [  417.128057]  kasan_save_track+0x14/0x40
> [  417.128267]  kasan_save_free_info+0x3b/0x60
> [  417.128491]  __kasan_slab_free+0x6c/0xa0
> [  417.128708]  kmem_cache_free+0x182/0x550
> [  417.128906]  free_task+0xeb/0x140
> [  417.129070]  __put_task_struct+0x1d2/0x4f0
> [  417.129259]  __put_task_struct_rcu_cb+0x15/0x20
> [  417.129480]  rcu_do_batch+0x3d3/0xe70
> [  417.129681]  rcu_core+0x549/0xb30
> [  417.129839]  rcu_core_si+0xe/0x20
> [  417.130005]  handle_softirqs+0x160/0x570
> [  417.130190]  __irq_exit_rcu+0x189/0x1e0
> [  417.130369]  irq_exit_rcu+0xe/0x20
> [  417.130531]  sysvec_apic_timer_interrupt+0x9f/0xd0
> [  417.130768]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
>
> [  417.131082] Last potentially related work creation:
> [  417.131305]  kasan_save_stack+0x26/0x60
> [  417.131484]  kasan_record_aux_stack+0xae/0xd0
> [  417.131695]  __call_rcu_common+0xcd/0x14b0
> [  417.131909]  call_rcu+0x31/0x50
> [  417.132071]  delayed_put_task_struct+0x128/0x190
> [  417.132295]  rcu_do_batch+0x3d3/0xe70
> [  417.132478]  rcu_core+0x549/0xb30
> [  417.132658]  rcu_core_si+0xe/0x20
> [  417.132808]  handle_softirqs+0x160/0x570
> [  417.132993]  __irq_exit_rcu+0x189/0x1e0
> [  417.133181]  irq_exit_rcu+0xe/0x20
> [  417.133353]  sysvec_apic_timer_interrupt+0x9f/0xd0
> [  417.133584]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
>
> [  417.133921] Second to last potentially related work creation:
> [  417.134183]  kasan_save_stack+0x26/0x60
> [  417.134362]  kasan_record_aux_stack+0xae/0xd0
> [  417.134566]  __call_rcu_common+0xcd/0x14b0
> [  417.134782]  call_rcu+0x31/0x50
> [  417.134929]  put_task_struct_rcu_user+0x58/0xb0
> [  417.135143]  finish_task_switch.isra.0+0x5d3/0x830
> [  417.135366]  __schedule+0xd30/0x5100
> [  417.135534]  schedule_idle+0x5a/0x90
> [  417.135712]  do_idle+0x25f/0x410
> [  417.135871]  cpu_startup_entry+0x53/0x70
> [  417.136053]  start_secondary+0x216/0x2c0
> [  417.136233]  common_startup_64+0x13e/0x141
>
> [  417.136894] The buggy address belongs to the object at ffff88812487000=
0
>                 which belongs to the cache task_struct of size 10504
> [  417.138122] The buggy address is located 52 bytes inside of
>                 freed 10504-byte region [ffff888124870000, ffff8881248729=
08)
>
> [  417.139465] The buggy address belongs to the physical page:
> [  417.140016] page: refcount:0 mapcount:0 mapping:0000000000000000 index=
:0x0
> pfn:0x124870
> [  417.140789] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped=
:0
> pincount:0
> [  417.141519] memcg:ffff88811aa20e01
> [  417.141874] anon flags:
> 0x17ffffc0000040(head|node=3D0|zone=3D2|lastcpupid=3D0x1fffff)
> [  417.142600] page_type: f5(slab)
> [  417.142922] raw: 0017ffffc0000040 ffff88810094f040 0000000000000000
> dead000000000001
> [  417.143554] raw: 0000000000000000 0000000000030003 00000000f5000000
> ffff88811aa20e01
> [  417.143954] head: 0017ffffc0000040 ffff88810094f040 0000000000000000
> dead000000000001
> [  417.144329] head: 0000000000000000 0000000000030003 00000000f5000000
> ffff88811aa20e01
> [  417.144710] head: 0017ffffc0000003 ffffea0004921c01 00000000ffffffff
> 00000000ffffffff
> [  417.145106] head: ffffffffffffffff 0000000000000000 00000000ffffffff
> 0000000000000008
> [  417.145485] page dumped because: kasan: bad access detected
>
> [  417.145859] Memory state around the buggy address:
> [  417.146094]  ffff88812486ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc
> fc
> [  417.146439]  ffff88812486ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc
> fc
> [  417.146791] >ffff888124870000: fa fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb
> fb
> [  417.147145]                                      ^
> [  417.147387]  ffff888124870080: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb
> fb
> [  417.147751]  ffff888124870100: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb
> fb
> [  417.148123]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> As far as I can see, we have warning here [2]:
>
> static void get_bvec_at(struct ceph_msg_data_cursor *cursor,
>             struct bio_vec *bv)
> {
>     struct page *page;
>     size_t off, len;
>
>     WARN_ON(!cursor->total_resid); <-- We have warning here!
>
>     /* skip zero-length data items */
>     while (!cursor->resid)
>         ceph_msg_data_advance(cursor, 0);
>
>     /* get a piece of data, cursor isn't advanced */
>     page =3D ceph_msg_data_next(cursor, &off, &len);
>     bvec_set_page(bv, page, len, off);
> }
>
> And we have crash in ceph_msg_data_advance() [3] because cursor->data is =
NULL:
>
> void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t by=
tes)
> {
>         bool new_piece;
>
>         BUG_ON(bytes > cursor->resid);
>         switch (cursor->data->type) {
>         case CEPH_MSG_DATA_PAGELIST:
>                 new_piece =3D ceph_msg_data_pagelist_advance(cursor, byte=
s);
>                 break;
>         case CEPH_MSG_DATA_PAGES:
>                 new_piece =3D ceph_msg_data_pages_advance(cursor, bytes);
>                 break;
> #ifdef CONFIG_BLOCK
>         case CEPH_MSG_DATA_BIO:
>                 new_piece =3D ceph_msg_data_bio_advance(cursor, bytes);
>                 break;
> #endif /* CONFIG_BLOCK */
>         case CEPH_MSG_DATA_BVECS:
>                 new_piece =3D ceph_msg_data_bvecs_advance(cursor, bytes);
>                 break;
>         case CEPH_MSG_DATA_ITER:
>                 new_piece =3D ceph_msg_data_iter_advance(cursor, bytes);
>                 break;
>         case CEPH_MSG_DATA_NONE:
>         default:
>                 BUG();
>                 break;
>         }
>         cursor->total_resid -=3D bytes;
>
>         if (!cursor->resid && cursor->total_resid) {
>                 cursor->data++;
>                 __ceph_msg_data_cursor_init(cursor);
>                 new_piece =3D true;
>         }
>         cursor->need_crc =3D new_piece;
> }
>
> So, somehow, we feed get_bvec_at() with not initialized struct
> ceph_msg_data_cursor because data is NULL and total_resid contains zero.
>
> Moreover, as far as I can see, Ceph msgr1 protocol can manage this situat=
ion
> without any issues:
>
> Nov  5 14:51:43 ceph-0006 kernel: [  214.841846] libceph: pid
> 67:net/ceph/messenger.c:1075 ceph_msg_data_cursor_init(): length 12288, m=
sg-
> >data_length 12288, msg->num_data_items 1
> Nov  5 14:51:43 ceph-0006 kernel: [  214.842656] libceph: pid
> 67:net/ceph/messenger.c:1040 __ceph_msg_data_cursor_init(): cursor->total=
_resid
> 12288, cursor->data->type 0x1
> Nov  5 14:51:43 ceph-0006 kernel: [  214.843360] libceph: pid
> 67:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x0
> Nov  5 14:51:43 ceph-0006 kernel: [  214.843946] libceph: pid
> 67:net/ceph/osd_client.c:5813 osd_sparse_read(): CEPH_SPARSE_READ_HDR
> Nov  5 14:51:43 ceph-0006 kernel: [  214.844458] libceph: pid
> 67:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x1
> Nov  5 14:51:43 ceph-0006 kernel: [  214.845112] libceph: pid
> 67:net/ceph/osd_client.c:5831 osd_sparse_read(): CEPH_SPARSE_READ_EXTENTS=
: count
> 1
> Nov  5 14:51:43 ceph-0006 kernel: [  214.845547] libceph: pid
> 67:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x2
> Nov  5 14:51:43 ceph-0006 kernel: [  214.846068] libceph: pid
> 67:net/ceph/osd_client.c:5862 osd_sparse_read(): CEPH_SPARSE_READ_DATA_LE=
N: sr-
> >sr_datalen 0
> Nov  5 14:51:43 ceph-0006 kernel: [  214.846642] libceph: pid
> 67:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x3
> Nov  5 14:51:43 ceph-0006 kernel: [  214.847170] libceph: pid
> 67:net/ceph/osd_client.c:5871 osd_sparse_read(): CEPH_SPARSE_READ_DATA_PR=
E: sr-
> >sr_datalen 12288
> Nov  5 14:51:43 ceph-0006 kernel: [  214.847746] libceph: pid
> 67:net/ceph/osd_client.c:5893 osd_sparse_read(): CEPH_SPARSE_READ_DATA: e=
xt 0
> off 0x0 len 0x3000
> Nov  5 14:51:43 ceph-0006 kernel: [  214.848434] libceph: pid
> 67:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x4
> Nov  5 14:51:43 ceph-0006 kernel: [  214.848852] libceph: pid
> 67:net/ceph/osd_client.c:5813 osd_sparse_read(): CEPH_SPARSE_READ_HDR
>
> And we call ceph_msg_data_cursor_init() for the case of Ceph msgr1 protoc=
ol. But
> I don't see any likewise call for the case of Ceph msgr2 protocol:
>
> Nov  4 15:22:33 ceph-0006 kernel: [   51.114531] libceph: pid
> 232:net/ceph/messenger_v2.c:1013 setup_message_sgs(): starting...
> Nov  4 15:22:33 ceph-0006 kernel: [   51.115066] libceph: pid
> 232:net/ceph/messenger_v2.c:1016 setup_message_sgs(): front_len(msg) 164,
> middle_len(msg) 0, data_len(msg) 12312, pages 00000000f99807bf
> Nov  4 15:22:33 ceph-0006 kernel: [   51.116089] libceph: pid
> 232:net/ceph/messenger_v2.c:1243 decrypt_tail(): data_length 12288, data
> 00000000e2dbb152, num_data_items 1, max_data_items 1, more_to_follow 0x0,
> needs_out_seq 0x0, sparse_read_total 12288, front_alloc_len 570
> Nov  4 15:22:33 ceph-0006 kernel: [   51.117599] libceph: pid
> 232:net/ceph/messenger_v2.c:1127 process_v2_sparse_read(): BEFORE sparse_=
read:
> total_resid 0, data 0000000000000000, resid 0, sr_resid 0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.118669] libceph: pid
> 232:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.119311] libceph: pid
> 232:net/ceph/osd_client.c:5813 osd_sparse_read(): CEPH_SPARSE_READ_HDR
> Nov  4 15:22:33 ceph-0006 kernel: [   51.119924] libceph: pid
> 232:net/ceph/messenger_v2.c:1144 process_v2_sparse_read(): AFTER sparse_r=
ead:
> total_resid 0, data 0000000000000000, resid 0, sr_resid 0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.120948] libceph: pid
> 232:net/ceph/messenger_v2.c:1161 process_v2_sparse_read(): data_length 12=
288,
> data 00000000e2dbb152, num_data_items 1, max_data_items 1, more_to_follow=
 0x0,
> needs_out_seq 0x0, sparse_read_total 12288, front_alloc_len 570
> Nov  4 15:22:33 ceph-0006 kernel: [   51.122307] libceph: pid
> 232:net/ceph/messenger_v2.c:1175 process_v2_sparse_read(): sparse_read re=
turn 4
> buf 00000000d8193189
> Nov  4 15:22:33 ceph-0006 kernel: [   51.123118] libceph: pid
> 232:net/ceph/messenger_v2.c:1127 process_v2_sparse_read(): BEFORE sparse_=
read:
> total_resid 0, data 0000000000000000, resid 0, sr_resid 0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.124009] libceph: pid
> 232:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x1
> Nov  4 15:22:33 ceph-0006 kernel: [   51.124600] libceph: pid
> 232:net/ceph/osd_client.c:5831 osd_sparse_read(): CEPH_SPARSE_READ_EXTENT=
S:
> count 1
> Nov  4 15:22:33 ceph-0006 kernel: [   51.125214] libceph: pid
> 232:net/ceph/messenger_v2.c:1144 process_v2_sparse_read(): AFTER sparse_r=
ead:
> total_resid 0, data 0000000000000000, resid 0, sr_resid 0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.126123] libceph: pid
> 232:net/ceph/messenger_v2.c:1161 process_v2_sparse_read(): data_length 12=
288,
> data 00000000e2dbb152, num_data_items 1, max_data_items 1, more_to_follow=
 0x0,
> needs_out_seq 0x0, sparse_read_total 12288, front_alloc_len 570
> Nov  4 15:22:33 ceph-0006 kernel: [   51.127607] libceph: pid
> 232:net/ceph/messenger_v2.c:1175 process_v2_sparse_read(): sparse_read re=
turn 10
> buf 00000000b993b4dc
> Nov  4 15:22:33 ceph-0006 kernel: [   51.128398] libceph: pid
> 232:net/ceph/messenger_v2.c:1127 process_v2_sparse_read(): BEFORE sparse_=
read:
> total_resid 0, data 0000000000000000, resid 0, sr_resid 0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.129117] libceph: pid
> 232:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x2
> Nov  4 15:22:33 ceph-0006 kernel: [   51.129619] libceph: pid
> 232:net/ceph/osd_client.c:5862 osd_sparse_read(): CEPH_SPARSE_READ_DATA_L=
EN: sr-
> >sr_datalen 0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.130239] libceph: pid
> 232:net/ceph/messenger_v2.c:1144 process_v2_sparse_read(): AFTER sparse_r=
ead:
> total_resid 0, data 0000000000000000, resid 0, sr_resid 0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.131008] libceph: pid
> 232:net/ceph/messenger_v2.c:1161 process_v2_sparse_read(): data_length 12=
288,
> data 00000000e2dbb152, num_data_items 1, max_data_items 1, more_to_follow=
 0x0,
> needs_out_seq 0x0, sparse_read_total 12288, front_alloc_len 570
> Nov  4 15:22:33 ceph-0006 kernel: [   51.132205] libceph: pid
> 232:net/ceph/messenger_v2.c:1175 process_v2_sparse_read(): sparse_read re=
turn 4
> buf 000000006ad6b16a
> Nov  4 15:22:33 ceph-0006 kernel: [   51.132907] libceph: pid
> 232:net/ceph/messenger_v2.c:1127 process_v2_sparse_read(): BEFORE sparse_=
read:
> total_resid 0, data 0000000000000000, resid 0, sr_resid 0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.133764] libceph: pid
> 232:net/ceph/osd_client.c:5805 osd_sparse_read(): sr->sr_state 0x3
> Nov  4 15:22:33 ceph-0006 kernel: [   51.134251] libceph: pid
> 232:net/ceph/osd_client.c:5871 osd_sparse_read(): CEPH_SPARSE_READ_DATA_P=
RE: sr-
> >sr_datalen 12288
> Nov  4 15:22:33 ceph-0006 kernel: [   51.134878] libceph: pid
> 232:net/ceph/osd_client.c:5893 osd_sparse_read(): CEPH_SPARSE_READ_DATA: =
ext 0
> off 0x0 len 0x3000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.135604] libceph: pid
> 232:net/ceph/messenger_v2.c:1144 process_v2_sparse_read(): AFTER sparse_r=
ead:
> total_resid 0, data 0000000000000000, resid 0, sr_resid 12288
> Nov  4 15:22:33 ceph-0006 kernel: [   51.136434] libceph: pid
> 232:net/ceph/messenger_v2.c:1161 process_v2_sparse_read(): data_length 12=
288,
> data 00000000e2dbb152, num_data_items 1, max_data_items 1, more_to_follow=
 0x0,
> needs_out_seq 0x0, sparse_read_total 12288, front_alloc_len 570
> Nov  4 15:22:33 ceph-0006 kernel: [   51.137576] libceph: pid
> 232:net/ceph/messenger_v2.c:1175 process_v2_sparse_read(): sparse_read re=
turn
> 3000 buf 0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.138299]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Nov  4 15:22:33 ceph-0006 kernel: [   51.138682] BUG: KASAN: slab-out-of-=
bounds
> in __ceph_msg_data_cursor_init+0x75/0x9ad
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139053] Read of size 4 at addr
> ffff888113bcffb0 by task kworker/3:2/232
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139412]
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139495] CPU: 3 UID: 0 PID: 232 C=
omm:
> kworker/3:2 Not tainted 6.17.0-rc7+ #11 PREEMPT(voluntary)
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139498] Hardware name: QEMU Stan=
dard PC
> (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139499] Workqueue: ceph-msgr
> ceph_con_workfn
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139510] Call Trace:
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139511]  <TASK>
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139512]  dump_stack_lvl+0x5c/0x9=
0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139516]  print_report+0x171/0x4d=
c
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139520]  ?
> __pfx__raw_spin_lock_irqsave+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139523]  ?
> kasan_complete_mode_report_info+0x2d/0x220
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139527]  kasan_report+0xbd/0x100
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139530]  ?
> __ceph_msg_data_cursor_init+0x75/0x9ad
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139532]  ?
> __ceph_msg_data_cursor_init+0x75/0x9ad
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139534]
> __asan_report_load4_noabort+0x14/0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139536]
> __ceph_msg_data_cursor_init+0x75/0x9ad
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139538]
> ceph_msg_data_advance.cold+0x30/0xfd
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139540]  ? vprintk_default+0x1d/=
0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139544]  get_bvec_at+0xdb/0x230
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139546]  ? __pfx__printk+0x10/0x=
10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139550]  ? __pfx_get_bvec_at+0x1=
0/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139552]
> ceph_con_v2_try_read.cold+0x1a90/0x1bb4
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139554]  ? update_entity_lag+0x4=
9/0x190
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139558]  ?
> __pfx_ceph_con_v2_try_read+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139560]  ?
> finish_task_switch.isra.0+0x15d/0x830
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139564]  ?
> __kasan_check_write+0x14/0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139565]  ? mutex_lock+0x84/0xe0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139567]  ? __pfx_mutex_lock+0x10=
/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139570]  ceph_con_workfn+0x27e/0=
x10e0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139572]  process_one_work+0x611/=
0xe20
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139575]  ?
> __kasan_check_write+0x14/0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139577]  worker_thread+0x7e3/0x1=
580
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139579]  ?
> __pfx__raw_spin_lock_irqsave+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139582]  ?
> __pfx_worker_thread+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139584]  kthread+0x381/0x7a0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139587]  ?
> __pfx__raw_spin_lock_irq+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139588]  ? __pfx_kthread+0x10/0x=
10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139590]  ?
> __kasan_check_write+0x14/0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139592]  ?
> recalc_sigpending+0x160/0x220
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139594]  ?
> _raw_spin_unlock_irq+0xe/0x50
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139596]  ?
> calculate_sigpending+0x78/0xb0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139597]  ? __pfx_kthread+0x10/0x=
10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139599]  ret_from_fork+0x2b6/0x3=
80
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139602]  ? __pfx_kthread+0x10/0x=
10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139604]  ret_from_fork_asm+0x1a/=
0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139608]  </TASK>
> Nov  4 15:22:33 ceph-0006 kernel: [   51.139609]
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149701] Allocated by task 1989:
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149914]  kasan_save_stack+0x26/0=
x60
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149917]  kasan_save_track+0x14/0=
x40
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149920]
> kasan_save_alloc_info+0x39/0x60
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149922]  __kasan_kmalloc+0xa9/0x=
d0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149925]  __kmalloc_noprof+0x1ec/=
0x5c0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149928]  ceph_msg_new2+0x2ff/0x4=
90
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149931]
> __ceph_osdc_alloc_messages+0x3c0/0x650
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149934]
> ceph_osdc_alloc_messages+0x179/0x240
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149937]
> ceph_osdc_new_request+0x792/0x8a0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149939]
> ceph_netfs_issue_read+0xabd/0x2010
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149944]
> netfs_read_to_pagecache+0x3d0/0xf70
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149948]  netfs_readahead+0x47b/0=
x970
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149951]  read_pages+0x186/0x8b0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149954]
> page_cache_ra_unbounded+0x385/0x670
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149957]
> page_cache_ra_order+0x7c9/0xb00
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149960]  page_cache_sync_ra+0x45=
f/0xa60
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149962]  filemap_get_pages+0x2e2=
/0x17f0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149966]  filemap_read+0x311/0xd6=
0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149968]
> generic_file_read_iter+0x29a/0x430
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149971]  ceph_read_iter+0xdd9/0x=
1a70
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149974]  vfs_read+0x6e7/0xb00
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149977]  ksys_read+0xfc/0x230
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149980]  __x64_sys_read+0x72/0xd=
0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149983]  x64_sys_call+0x1e95/0x2=
330
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149986]  do_syscall_64+0x83/0x32=
0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149990]
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
> Nov  4 15:22:33 ceph-0006 kernel: [   51.149992]
> Nov  4 15:22:33 ceph-0006 kernel: [   51.150089] The buggy address belong=
s to
> the object at ffff888113bcff80
> Nov  4 15:22:33 ceph-0006 kernel: [   51.150089]  which belongs to the ca=
che
> kmalloc-64 of size 64
> Nov  4 15:22:33 ceph-0006 kernel: [   51.150713] The buggy address is loc=
ated 0
> bytes to the right of
> Nov  4 15:22:33 ceph-0006 kernel: [   51.150713]  allocated 48-byte regio=
n
> [ffff888113bcff80, ffff888113bcffb0)
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151407]
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151497] The buggy address belong=
s to
> the physical page:
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151802] page: refcount:0 mapcoun=
t:0
> mapping:0000000000000000 index:0xffff888113bcf300 pfn:0x113bcf
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151805] anon flags:
> 0x17ffffc0000000(node=3D0|zone=3D2|lastcpupid=3D0x1fffff)
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151808] page_type: f5(slab)
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151812] raw: 0017ffffc0000000
> ffff8881000428c0 0000000000000000 dead000000000001
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151814] raw: ffff888113bcf300
> 000000008020001a 00000000f5000000 0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151816] page dumped because: kas=
an: bad
> access detected
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151817]
> Nov  4 15:22:33 ceph-0006 kernel: [   51.151910] Memory state around the =
buggy
> address:
> Nov  4 15:22:33 ceph-0006 kernel: [   51.152180]  ffff888113bcfe80: fa fb=
 fb fb
> fb fb fb fb fc fc fc fc fc fc fc fc
> Nov  4 15:22:33 ceph-0006 kernel: [   51.152598]  ffff888113bcff00: fa fb=
 fb fb
> fb fb fb fb fc fc fc fc fc fc fc fc
> Nov  4 15:22:33 ceph-0006 kernel: [   51.152986] >ffff888113bcff80: 00 00=
 00 00
> 00 00 fc fc fc fc fc fc fc fc fc fc
> Nov  4 15:22:33 ceph-0006 kernel: [   51.153383]
> ^
> Nov  4 15:22:33 ceph-0006 kernel: [   51.153658]  ffff888113bd0000: 00 00=
 00 00
> 00 00 00 00 00 00 00 00 00 00 00 00
> Nov  4 15:22:33 ceph-0006 kernel: [   51.154048]  ffff888113bd0080: 00 00=
 00 00
> 00 00 00 00 00 00 00 00 00 00 00 00
> Nov  4 15:22:33 ceph-0006 kernel: [   51.154437]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Nov  4 15:22:33 ceph-0006 kernel: [   51.154885] Disabling lock debugging=
 due to
> kernel taint
> Nov  4 15:22:33 ceph-0006 kernel: [   51.154887] libceph: pid
> 232:net/ceph/messenger.c:1040 __ceph_msg_data_cursor_init(): cursor->tota=
l_resid
> 12288, cursor->data->type 0x0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.155814] ------------[ cut here ]=
-------
> -----
> Nov  4 15:22:33 ceph-0006 kernel: [   51.155816] kernel BUG at
> net/ceph/messenger.c:1164!
> Nov  4 15:22:33 ceph-0006 kernel: [   51.156088] Oops: invalid opcode: 00=
00 [#1]
> SMP KASAN NOPTI
> Nov  4 15:22:33 ceph-0006 kernel: [   51.156383] CPU: 3 UID: 0 PID: 232 C=
omm:
> kworker/3:2 Tainted: G    B               6.17.0-rc7+ #11 PREEMPT(volunta=
ry)
> Nov  4 15:22:33 ceph-0006 kernel: [   51.156948] Tainted: [B]=3DBAD_PAGE
> Nov  4 15:22:33 ceph-0006 kernel: [   51.157121] Hardware name: QEMU Stan=
dard PC
> (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
> Nov  4 15:22:33 ceph-0006 kernel: [   51.157590] Workqueue: ceph-msgr
> ceph_con_workfn
> Nov  4 15:22:33 ceph-0006 kernel: [   51.157842] RIP:
> 0010:ceph_msg_data_advance+0x10e7/0x1a50
> Nov  4 15:22:33 ceph-0006 kernel: [   51.158114] Code: b0 4c 89 5d b8 4c =
89 45
> c8 e8 05 46 36 fd 48 8b 4d 98 44 8b 4d a0 8b 75 a8 4c 8b 55 b0 4c 8b 5d b=
8 4c 8b
> 45 c8 e9 ab f3 ff ff <0f> 0b 49 8d 7f 08 48 89 4d c0 4c 89 55 c8 4c 89 45=
 d0 e8
> 12 46 36
> Nov  4 15:22:33 ceph-0006 kernel: [   51.159059] RSP: 0018:ffff888122ec78=
80
> EFLAGS: 00010293
> Nov  4 15:22:33 ceph-0006 kernel: [   51.159323] RAX: 0000000000000000 RB=
X:
> ffff888113bcffb0 RCX: 0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.159716] RDX: 0000000000000000 RS=
I:
> 0000000000000000 RDI: 0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.160088] RBP: ffff888122ec7910 R0=
8:
> 0000000000000000 R09: 0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.160744] R10: ffff88811fce4388 R1=
1:
> 0000000000000000 R12: ffffed1023f9c871
> Nov  4 15:22:33 ceph-0006 kernel: [   51.161630] R13: 1ffff110245d8f25 R1=
4:
> ffff888122ec7ba0 R15: ffff88811fce4378
> Nov  4 15:22:33 ceph-0006 kernel: [   51.162099] FS:  0000000000000000(00=
00)
> GS:ffff8882449de000(0000) knlGS:0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.162998] CS:  0010 DS: 0000 ES: 0=
000
> CR0: 0000000080050033
> Nov  4 15:22:33 ceph-0006 kernel: [   51.163577] CR2: 00007dba67d08bc0 CR=
3:
> 0000000193c9e002 CR4: 0000000000772ef0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.164470] PKRU: 55555554
> Nov  4 15:22:33 ceph-0006 kernel: [   51.165041] Call Trace:
> Nov  4 15:22:33 ceph-0006 kernel: [   51.165458]  <TASK>
> Nov  4 15:22:33 ceph-0006 kernel: [   51.165699]  get_bvec_at+0xdb/0x230
> Nov  4 15:22:33 ceph-0006 kernel: [   51.166202]  ? __pfx__printk+0x10/0x=
10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.166853]  ? __pfx_get_bvec_at+0x1=
0/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.167990]
> ceph_con_v2_try_read.cold+0x1a90/0x1bb4
> Nov  4 15:22:33 ceph-0006 kernel: [   51.169097]  ? update_entity_lag+0x4=
9/0x190
> Nov  4 15:22:33 ceph-0006 kernel: [   51.169791]  ?
> __pfx_ceph_con_v2_try_read+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.170067]  ?
> finish_task_switch.isra.0+0x15d/0x830
> Nov  4 15:22:33 ceph-0006 kernel: [   51.170450]  ?
> __kasan_check_write+0x14/0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.170720]  ? mutex_lock+0x84/0xe0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.171026]  ? __pfx_mutex_lock+0x10=
/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.171246]  ceph_con_workfn+0x27e/0=
x10e0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.171596]  process_one_work+0x611/=
0xe20
> Nov  4 15:22:33 ceph-0006 kernel: [   51.171822]  ?
> __kasan_check_write+0x14/0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.172058]  worker_thread+0x7e3/0x1=
580
> Nov  4 15:22:33 ceph-0006 kernel: [   51.172403]  ?
> __pfx__raw_spin_lock_irqsave+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.172817]  ?
> __pfx_worker_thread+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.173049]  kthread+0x381/0x7a0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.173348]  ?
> __pfx__raw_spin_lock_irq+0x10/0x10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.174274]  ? __pfx_kthread+0x10/0x=
10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.175073]  ?
> __kasan_check_write+0x14/0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.176356]  ?
> recalc_sigpending+0x160/0x220
> Nov  4 15:22:33 ceph-0006 kernel: [   51.177248]  ?
> _raw_spin_unlock_irq+0xe/0x50
> Nov  4 15:22:33 ceph-0006 kernel: [   51.178145]  ?
> calculate_sigpending+0x78/0xb0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.179061]  ? __pfx_kthread+0x10/0x=
10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.179595]  ret_from_fork+0x2b6/0x3=
80
> Nov  4 15:22:33 ceph-0006 kernel: [   51.179792]  ? __pfx_kthread+0x10/0x=
10
> Nov  4 15:22:33 ceph-0006 kernel: [   51.179984]  ret_from_fork_asm+0x1a/=
0x30
> Nov  4 15:22:33 ceph-0006 kernel: [   51.180200]  </TASK>
> Nov  4 15:22:33 ceph-0006 kernel: [   51.180337] Modules linked in:
> intel_rapl_msr intel_rapl_common intel_uncore_frequency_common intel_pmc_=
core
> pmt_telemetry pmt_discovery pmt_class intel_pmc_ssram_telemetry intel_vse=
c
> kvm_intel kvm joydev irqbypass polyval_clmulni ghash_clmulni_intel aesni_=
intel
> rapl psmouse input_leds vga16fb serio_raw vgastate floppy i2c_piix4 mac_h=
id
> qemu_fw_cfg i2c_smbus pata_acpi bochs sch_fq_codel rbd msr parport_pc ppd=
ev lp
> parport efi_pstore
> Nov  4 15:22:33 ceph-0006 kernel: [   51.182337] ---[ end trace 000000000=
0000000
> ]---
> Nov  4 15:22:33 ceph-0006 kernel: [   51.182582] RIP:
> 0010:ceph_msg_data_advance+0x10e7/0x1a50
> Nov  4 15:22:33 ceph-0006 kernel: [   51.182882] Code: b0 4c 89 5d b8 4c =
89 45
> c8 e8 05 46 36 fd 48 8b 4d 98 44 8b 4d a0 8b 75 a8 4c 8b 55 b0 4c 8b 5d b=
8 4c 8b
> 45 c8 e9 ab f3 ff ff <0f> 0b 49 8d 7f 08 48 89 4d c0 4c 89 55 c8 4c 89 45=
 d0 e8
> 12 46 36
> Nov  4 15:22:33 ceph-0006 kernel: [   51.184326] RSP: 0018:ffff888122ec78=
80
> EFLAGS: 00010293
> Nov  4 15:22:33 ceph-0006 kernel: [   51.184697] RAX: 0000000000000000 RB=
X:
> ffff888113bcffb0 RCX: 0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.185118] RDX: 0000000000000000 RS=
I:
> 0000000000000000 RDI: 0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.185553] RBP: ffff888122ec7910 R0=
8:
> 0000000000000000 R09: 0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.186033] R10: ffff88811fce4388 R1=
1:
> 0000000000000000 R12: ffffed1023f9c871
> Nov  4 15:22:33 ceph-0006 kernel: [   51.186455] R13: 1ffff110245d8f25 R1=
4:
> ffff888122ec7ba0 R15: ffff88811fce4378
> Nov  4 15:22:33 ceph-0006 kernel: [   51.186905] FS:  0000000000000000(00=
00)
> GS:ffff8882449de000(0000) knlGS:0000000000000000
> Nov  4 15:22:33 ceph-0006 kernel: [   51.187420] CS:  0010 DS: 0000 ES: 0=
000
> CR0: 0000000080050033
> Nov  4 15:22:33 ceph-0006 kernel: [   51.187820] CR2: 00007dba67d08bc0 CR=
3:
> 0000000193c9e002 CR4: 0000000000772ef0
> Nov  4 15:22:33 ceph-0006 kernel: [   51.188230] PKRU: 55555554
>
> So, where could be the proper place of calling ceph_msg_data_cursor_init(=
) for
> the case of Ceph msgr2 protocol?
>
> I tried to consider the setup_message_sgs() but it doesn't work. What cou=
ld be
> the proper solution of this issue? Maybe, I am misunderstanding the logic=
 of
> Ceph msgr2 protocol but get_bvec_at() and ceph_msg_data_advance() expect =
to have
> the initialized cursor.

Hi Slava,

Yes, they do.

Based on a quick look, I'd expect the cursor to be initialized at the
top of process_v2_sparse_read(), before the for loop.  Keep in mind
that the initial submission for sparse read support didn't go through
me so I wouldn't necessarily know what the "proper" place is though.

Thanks,

                Ilya

