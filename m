Return-Path: <ceph-devel+bounces-3010-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 277C9A8102D
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Apr 2025 17:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D638318954A1
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Apr 2025 15:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911E73FB1B;
	Tue,  8 Apr 2025 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SD1YRpC8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EC47082A;
	Tue,  8 Apr 2025 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126220; cv=none; b=KPSyQkn+/TA+MrFdQ6eAKI0bMLTqS3tgiNwuVHB3enV7NtvzjONofBw13oHzYhDgBfsuQAADU5PDR2gtCSjUTO5moFsDl+em27LjiFie3wa3tgfyUqIuUaXDS+KjjHzFCL/ztlOd/nDmhI+nWf6K/xC5PkSQA3ySsTl5KYmkGiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126220; c=relaxed/simple;
	bh=gyfvUTJnk9GIxej3TSFZXj/Em8JwGncurtYNGBzsiwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FKTfZfjOOrEktI+vx/IkAETBZcoK4wPRU2aiKAs3/Hln1cEyLIMOcarev7rGzSFuon1IROyPXcJhesGKu239vxnLLh7Zh9qltx6OUWoj5iEmypVMg/RWQfdQFcB2Gb/dUHt3i5dWLebpfSHXAAdK3Q/fqVWGrbHOKDmdhy7xHKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SD1YRpC8; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-af9065f0fc0so3856725a12.2;
        Tue, 08 Apr 2025 08:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744126217; x=1744731017; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7P0Ph1eYkITU9mHXOzvfzfH81Uammd7Tgbce+HYzEg=;
        b=SD1YRpC8SbVdY7o8dewsHp8ASIr1v9GDCSrLh7y3BfJ/hqwply3UZXfHKY/X8D/SaJ
         mlcr0JhHWkcSkITM5iY2k0hTmMUWqaGfviLrIS+v09gTH0cSUcEmZMXWhzSD2zXuB0jp
         PyGVAdfFirGMPflHrxZwFwu9F+deqKyolomhV01x94b05cyd0pdw93o8VfU0B+xV1Wra
         kE+SF4bOfJFAem1AkjuICJ1PrV0GYm7JtIhhBk1mm6yleUD/jiiPDuskqDExVmJzKQMp
         aSJKm/kFYBqn8YUJJtGZLKoUXlrfCfiQxmAAoLqBgrhqQtVdijCzSVD6Merl4aTYjwNt
         IUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744126217; x=1744731017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7P0Ph1eYkITU9mHXOzvfzfH81Uammd7Tgbce+HYzEg=;
        b=sfYoj8FmzRTKFl51y01jt6cBQxYyQ3HXOoG5B9OtSkWUZP9yDvO1u8PY0/CXfW9Vw4
         z1kDsbYFyQDjxBxj9VsoPMOWT6ibicmcGi0XGxXzMg+153IUKyUUSHNg9O88zvNmZr5Z
         aDDua+MyPHj6VGjX3LMmS67LWn52DejQxuvx9AXlEeCKid0uPOGx/aVq9N+8bs5hMvko
         63LGqPQzQfZLXHGpkYUPDbF4RSVdGqUpkQN9WdG6yqaIxE+qbsWgeAcdNrE+qB0oCngj
         m+fcmeFMNZzWT08kRRDeD8dizgAbb42f3qozRXKYTzVg3EDYd0KexLKRXJ08O5Fvy+8y
         3R+A==
X-Forwarded-Encrypted: i=1; AJvYcCWUvw44wHg1uNwKp4hBrdQmmHdBsYbrUVOBFjzJG3XypJXa8lM5EGyrg+gadqTu6mekHnpb1HDPRGS5Otg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG0gcmzk8u0w7csH3Q7TzSMC/Dbvsa0m58XVYNPVwgWHRmtmnA
	IXGsrsJZsN794yUbdEuXrYcqaY6YFze6a5CAXzfdcx3sSqTqEZ+f9/djWAvvh1B5/uPNbpMN2dV
	xaqar/sFdTc2t9ChYyfR+EWuM/4w=
X-Gm-Gg: ASbGncvlOzaSEX1zBD22M8clFDUOivtJGeeEgHh3yqDkj7eW8/4tP4qp3FPNFFfbPyj
	uBv9H5El1sJGeaXv2NtXNICCCoTNcJToRrurx8MHxbXmNAbTUZ15v9FsIIDNntJQBxNxRRaoTyy
	zTRrfTUlaK8rgalGlnSEv9SxxqoQ==
X-Google-Smtp-Source: AGHT+IEqd5SDFYpjzz1DoD1CXBTUCyglEGsknnBeNPWkdaP88kXraCFj2hjbNEoUn3Mfm2Rgcbff3hF+E9hiHibnS2A=
X-Received: by 2002:a17:90a:d450:b0:2ff:5357:1c7e with SMTP id
 98e67ed59e1d1-306a48a4b94mr22487202a91.20.1744126217022; Tue, 08 Apr 2025
 08:30:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67f4b1db.050a0220.396535.0556.GAE@google.com>
In-Reply-To: <67f4b1db.050a0220.396535.0556.GAE@google.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 8 Apr 2025 17:30:05 +0200
X-Gm-Features: ATxdqUFKD9McGOLQDwRDoBtQ4uCOk-TjvDlt-jRLpjNP8Yc_QQv3yyPo8DLaSLo
Message-ID: <CAOi1vP_5wiDzFqm8ndMWCZ-SdcZGUvmS4XN9HQC+-0LAuERiUQ@mail.gmail.com>
Subject: Re: [syzbot] [ceph?] WARNING in __ceph_open_session
To: syzbot <syzbot+c35d73ce910d86c0026e@syzkaller.appspotmail.com>
Cc: ceph-devel@vger.kernel.org, edumazet@google.com, 
	linux-kernel@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de, 
	syzkaller-bugs@googlegroups.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 7:19=E2=80=AFAM syzbot
<syzbot+c35d73ce910d86c0026e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    a4cda136f021 Add linux-next specific files for 20250404
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D148ca7cf98000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8a257c454bb1a=
fb7
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc35d73ce910d86c=
0026e
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12fb2a74580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13ef023f98000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/59048bc9c206/dis=
k-a4cda136.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ad2ba7306f20/vmlinu=
x-a4cda136.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b3bef7acbf10/b=
zImage-a4cda136.xz
>
> The issue was bisected to:
>
> commit 00b35530811f2aa3d7ceec2dbada80861c7632a8
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Feb 6 14:04:22 2025 +0000
>
>     batman-adv: adopt netdev_hold() / netdev_put()

The issue is caused by a WIP patch in the Ceph tree, not this commit.
Please ignore this -- the patch in question is going to be reworked.

>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D1703e23f98=
0000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D1483e23f98=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1083e23f98000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+c35d73ce910d86c0026e@syzkaller.appspotmail.com
> Fixes: 00b35530811f ("batman-adv: adopt netdev_hold() / netdev_put()")
>
> ------------[ cut here ]------------
> do not call blocking ops when !TASK_RUNNING; state=3D1 set at [<ffffffff8=
19c19fc>] prepare_to_wait_event+0x3ac/0x460 kernel/sched/wait.c:298
> WARNING: CPU: 1 PID: 5840 at kernel/sched/core.c:8745 __might_sleep+0xb9/=
0xe0 kernel/sched/core.c:8741
> Modules linked in:
> CPU: 1 UID: 0 PID: 5840 Comm: syz-executor181 Not tainted 6.14.0-next-202=
50404-syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 02/12/2025
> RIP: 0010:__might_sleep+0xb9/0xe0 kernel/sched/core.c:8741
> Code: b7 0e 01 90 42 80 3c 23 00 74 08 48 89 ef e8 3e 13 9b 00 48 8b 4d 0=
0 48 c7 c7 e0 33 4a 8c 44 89 ee 48 89 ca e8 18 11 f0 ff 90 <0f> 0b 90 90 eb=
 b5 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 70 ff ff ff
> RSP: 0018:ffffc9000415f988 EFLAGS: 00010246
> RAX: fd368e7e13f3a900 RBX: 1ffff110058ec6b1 RCX: ffff88802c761e00
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffff88802c763588 R08: ffffffff81828012 R09: fffffbfff1d7a980
> R10: dffffc0000000000 R11: fffffbfff1d7a980 R12: dffffc0000000000
> R13: 0000000000000001 R14: 0000000000000242 R15: ffffffff8c4ad740
> FS:  00005555827b3380(0000) GS:ffff88812508f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000559c14e13950 CR3: 000000007bd64000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __mutex_lock_common kernel/locking/mutex.c:578 [inline]
>  __mutex_lock+0x12c/0x10c0 kernel/locking/mutex.c:746
>  have_mon_and_osd_map net/ceph/ceph_common.c:796 [inline]
>  __ceph_open_session+0x471/0xa30 net/ceph/ceph_common.c:826
>  ceph_real_mount fs/ceph/super.c:1167 [inline]
>  ceph_get_tree+0xac4/0x17b0 fs/ceph/super.c:1355
>  vfs_get_tree+0x90/0x2b0 fs/super.c:1759
>  vfs_cmd_create+0xa0/0x1f0 fs/fsopen.c:225
>  vfs_fsconfig_locked fs/fsopen.c:-1 [inline]
>  __do_sys_fsconfig fs/fsopen.c:467 [inline]
>  __se_sys_fsconfig+0xa20/0xf40 fs/fsopen.c:344
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0b20653329
> Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffabd71a98 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
> RAX: ffffffffffffffda RBX: 00007fffabd71c68 RCX: 00007f0b20653329
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
> RBP: 00007f0b206c6610 R08: 0000000000000000 R09: 00007fffabd71c68
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007fffabd71c58 R14: 0000000000000001 R15: 0000000000000001
>  </TASK>

Thanks,

                Ilya

