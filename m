Return-Path: <ceph-devel+bounces-1620-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B002394212F
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 22:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F0861F25454
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 20:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2801918CC12;
	Tue, 30 Jul 2024 20:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UMdY8vFk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F1169397
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722369643; cv=none; b=Pdq7UqFq7ZhSDwVZLdTSn9FLkHcQve0KEG5cN6uiV37YvE+OWVu+viIylURYvM/JehSWER9Rkko3QoHzQzDPq+2aYM8UZRcUafdcZ9lvqrEXx7h/IWDiKrZuqqksAGvAgeWoGeO2JvMuCL+sB4nO4ZUSAg/Xjmbd68+T0yiwj88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722369643; c=relaxed/simple;
	bh=KW8P1f9QtLpNiOED/9q/P8RZi+voxvllnMDRlZd/H2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T7i5JwZtH3LHBElRaObov1pqJuxo79B6607h+O6UlAnrF54zkOEQIf24nTZIgCGApDI5nLJDyX5K2lu6ERheJj9PPssNoRW/Du6PHZgeX2GtGImNnc54Knh/zS8GnZAA6X7jnbUYmLWRtcPHHlBYXZMA9SnQV2+plemMRpvydKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UMdY8vFk; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5af6a1afa63so5069764a12.0
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 13:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722369640; x=1722974440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbPZYMLRnlwPHtoaKt4K6dn+FyDOOUhmY8EoiLqybE0=;
        b=UMdY8vFkU3l54CTk70AIDub1zNuhBBpWlzfDJ/euXjLqdFGm+58FUHxJuyERUfogZ9
         J7X1/rVKCsoWpDAMtb+K29O/bBJm0W/aJTTR9Jh6XsT+QdFgrQVCSFhFwDoR0Lpq+Rhr
         l1tWxLeVnLfUbZcWndfRfK2opZxKknonZH3OVD3is6yHYc6V1/d81xdfqIJNXUqUTHA9
         voLHjm4vQEo852eg00ZTPXiUP39d98YDBgaGmMuT1dPPfkOSikA0yspaDH6BKjuq1hX/
         7jk1bUPA9H8w8rCGppkV3Iq8Q8VirenY879zfC63mrUcasLwNAewS6+sWxzbuPjV+PIm
         rEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722369640; x=1722974440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbPZYMLRnlwPHtoaKt4K6dn+FyDOOUhmY8EoiLqybE0=;
        b=P+Ob2RXszU179zB96ZvMwfKNygvaGXV70grN6tNAejY+6m6FssRVmE7LkYfryCR8zz
         fzVmLsGlAKEHXqaAtdIAPiDlQNt0IVEh4ul5krJlvpqa1RoKSVG6Ado18qYw6s7we3NK
         62MkIvauHeTS1eu1z1JInBnQt1rNueXgPWIF8Oa3aaTCTnFqw14tROchpoWqxuODzdah
         jOHjBvds3mOYz1pt7PZW2gxhKephCNFci8eoprzLBdI9eJmeFGYmfE4rD8LM+aNuHWtD
         JkPIRKG5bbBuRNGrelJTZ2hm783S1WpcrBOfnQdPp5cz6d0nIF0VvpJJPpWpRTkFHjPi
         t21w==
X-Forwarded-Encrypted: i=1; AJvYcCUu8mXKStYyg58A2De47hrpi6zRYgikgvAl5NuEx6TVhgrNWZPVKIQzm5vmhv0GoLEbnmH545ey8NDnh54tTU0wwlOjX19+LiDQNg==
X-Gm-Message-State: AOJu0YxbadfZJ8aITppXg0BdLEukPucYK3wXp4NrMKHKAhhuouh0CE+Q
	NmpyDI/VVmguA1MRxxoBvQWggtytMkWiElKnrCQ+FBKwBUV3w+93qpK7xfMV+gSpPv3yxvyXUKi
	qEH53wQfuALQZ3l2fkgErx4hsnAQ6ZfsUz8KRew==
X-Google-Smtp-Source: AGHT+IEE5EzRjQgQf7OLsadPZRVm5wfpMjhdtPXwM5eAo5BtDg8quTA9PAyUuMV7aPlhtR9I5OqiC7L3/3tTJkE4oTA=
X-Received: by 2002:a17:907:a80d:b0:a6f:6126:18aa with SMTP id
 a640c23a62f3a-a7d40173b7emr694439966b.67.1722369640184; Tue, 30 Jul 2024
 13:00:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729091532.855688-1-max.kellermann@ionos.com>
 <3575457.1722355300@warthog.procyon.org.uk> <CAKPOu+9_TQx8XaB2gDKzwN-YoN69uKoZGiCDPQjz5fO-2ztdFQ@mail.gmail.com>
In-Reply-To: <CAKPOu+9_TQx8XaB2gDKzwN-YoN69uKoZGiCDPQjz5fO-2ztdFQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Tue, 30 Jul 2024 22:00:29 +0200
Message-ID: <CAKPOu+-qJR08WMfP0ZKCyWzXO6EgPGiKH1F_SB5S+v=sgNGeOQ@mail.gmail.com>
Subject: Re: [PATCH] netfs, ceph: Revert "netfs: Remove deprecated use of
 PG_private_2 as a second writeback flag"
To: David Howells <dhowells@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, willy@infradead.org, ceph-devel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 6:28=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
> I'll let you know when problems occur later, but until
> then, I agree with merging your revert instead of my patches.

Not sure if that's the same bug/cause (looks different), but 6.10.2
with your patch is still unstable:

 rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: {
9-.... 15-.... } 521399 jiffies s: 2085 root: 0x1/.
 rcu: blocking rcu_node structures (internal RCU debug): l=3D1:0-15:0x8200/=
.
 Sending NMI from CPU 3 to CPUs 9:
 NMI backtrace for cpu 9
 CPU: 9 PID: 2756 Comm: kworker/9:2 Tainted: G      D
6.10.2-cm4all2-vm+ #171
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01=
/2014
 Workqueue: ceph-msgr ceph_con_workfn
 RIP: 0010:native_queued_spin_lock_slowpath+0x80/0x260
 Code: 57 85 c0 74 10 0f b6 03 84 c0 74 09 f3 90 0f b6 03 84 c0 75 f7
b8 01 00 00 00 66 89 03 5b 5d 41 5c 41 5d c3 cc cc cc cc f3 90 <eb> 93
8b 37 b8 00 02 00 00 81 fe 00 01 00 00 74 07 eb a1 83 e8 01
 RSP: 0018:ffffaf5880c03bb8 EFLAGS: 00000202
 RAX: 0000000000000001 RBX: ffffa02bc37c9e98 RCX: ffffaf5880c03c90
 RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffffa02bc37c9e98
 RBP: ffffa02bc2f94000 R08: ffffaf5880c03c90 R09: 0000000000000010
 R10: 0000000000000514 R11: 0000000000000000 R12: ffffaf5880c03c90
 R13: ffffffffb4bcb2f0 R14: ffffa036c9e7e8e8 R15: ffffa02bc37c9e98
 FS:  0000000000000000(0000) GS:ffffa036cf040000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055fecac48568 CR3: 000000030d82c002 CR4: 00000000001706b0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <NMI>
  ? nmi_cpu_backtrace+0x83/0xf0
  ? nmi_cpu_backtrace_handler+0xd/0x20
  ? nmi_handle+0x56/0x120
  ? default_do_nmi+0x40/0x100
  ? exc_nmi+0xdc/0x100
  ? end_repeat_nmi+0xf/0x53
  ? __pfx_ceph_ino_compare+0x10/0x10
  ? native_queued_spin_lock_slowpath+0x80/0x260
  ? native_queued_spin_lock_slowpath+0x80/0x260
  ? native_queued_spin_lock_slowpath+0x80/0x260
  </NMI>
  <TASK>
  ? __pfx_ceph_ino_compare+0x10/0x10
  _raw_spin_lock+0x1e/0x30
  find_inode+0x6e/0xc0
  ? __pfx_ceph_ino_compare+0x10/0x10
  ? __pfx_ceph_set_ino_cb+0x10/0x10
  ilookup5_nowait+0x6d/0xa0
  ? __pfx_ceph_ino_compare+0x10/0x10
  iget5_locked+0x33/0xe0
  ceph_get_inode+0xb8/0xf0
  mds_dispatch+0xfe8/0x1ff0
  ? inet_recvmsg+0x4d/0xf0
  ceph_con_process_message+0x66/0x80
  ceph_con_v1_try_read+0xcfc/0x17c0
  ? __switch_to_asm+0x39/0x70
  ? finish_task_switch.isra.0+0x78/0x240
  ? __schedule+0x32a/0x1440
  ceph_con_workfn+0x339/0x4f0
  process_one_work+0x138/0x2e0
  worker_thread+0x2b9/0x3d0
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xba/0xe0
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x30/0x50
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
 </TASK>

