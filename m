Return-Path: <ceph-devel+bounces-3006-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F32A7F410
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Apr 2025 07:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C60CB3B3589
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Apr 2025 05:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19ED9204599;
	Tue,  8 Apr 2025 05:19:26 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C1A1A4E98
	for <ceph-devel@vger.kernel.org>; Tue,  8 Apr 2025 05:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744089565; cv=none; b=qhbOcwLmvjqQHmDlEYDSf3/zqshk1drKi0WGs162zBURT8NI2X2P8rM7jesKS2w/MoEi2kAP0FsUA3s9n2x10AmF8hN2iniCgSACWg/2bpQ2Q1uQx9PA6sq6bSuj/JsWyAuoNptB7uqYNp7tjpQ5/1pKiOsPitrPgP4W/GQPV18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744089565; c=relaxed/simple;
	bh=bsLvgNeudz4Q1kKxoMKscLZcSpogHxCceYaIqSlyiPg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=azZHjWcn/qZT/eKiiWVMpU1eXmKh/bJsNRoS9w89ga9WyV3pK+Pui1HWAk/AGJusNNl5wH1d4kdCtsSuaupU0VnTWQNtDYf6xFmrFwlVvZlElKtl1FlH3SdzcX2RZrjP30VtDGDNVuGNFaCNFB2ls2MaNLMiEJXMjmqKoMgBHPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d458e61faaso54548925ab.0
        for <ceph-devel@vger.kernel.org>; Mon, 07 Apr 2025 22:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744089563; x=1744694363;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GHlAcPlI47sJryiPcSdLXFwtpjnpSvFHnU+hdarGisw=;
        b=mxart1PO4xOjCDU5wwDX5xOwgd3W3DtXPhLbKB40tdLKQXD3OXWly1LNoSl5h/voxx
         ulhx97CAFVTH6l+dLRcDCfLrKiu48GZvhPpMLwPcZISS6OMBdkrYym4dk3r2MRruBY20
         RUJoFYnD43/RS9uPXuTxpW/QTEWUNZCIDdORJWDSzNMiyx2QUHo+yu6JUhuv3XAak/zD
         sGKyBDvdoj1W9J4xFrtogmWloJtCCOtaRaOhS4GfupVa3wnl6wRBY/jVdJt3lc84lPhC
         mXBapOTOT+gD/vA0oibTDyfygjT30BFmsBjKZU7O49xErWwvIhTKQbFJgANYddWcdQ16
         Jafg==
X-Gm-Message-State: AOJu0YwLSbknxQwavoeWZN/QaFaubCup6T/xlrU0LRokg+s/wmy2uo1R
	21dhisgvt8rjD6ObiLXc/V8fX0964OeyGiG4DXWxJYTWTJykxM+BsWwEHF1cF5d1V2BYPd8Szo3
	3luiKg6XQsbpmUCb4lVhZ6MMwTPXqjPecEPnQ/xTNit8upc0u6qOzxMAppg==
X-Google-Smtp-Source: AGHT+IER0hBF2DzmlnrxWvXRfsi3KhFN3zgtpO4+S0j4KOwzWcNTqTnT8XeRpcarYWhn/ZTNQZkAeDg/uu4FL4SfsNVODF+6kv0p
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3008:b0:3d4:2306:fbb6 with SMTP id
 e9e14a558f8ab-3d703697026mr26474365ab.10.1744089563297; Mon, 07 Apr 2025
 22:19:23 -0700 (PDT)
Date: Mon, 07 Apr 2025 22:19:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f4b1db.050a0220.396535.0556.GAE@google.com>
Subject: [syzbot] [ceph?] WARNING in __ceph_open_session
From: syzbot <syzbot+c35d73ce910d86c0026e@syzkaller.appspotmail.com>
To: ceph-devel@vger.kernel.org, edumazet@google.com, idryomov@gmail.com, 
	linux-kernel@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de, 
	syzkaller-bugs@googlegroups.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a4cda136f021 Add linux-next specific files for 20250404
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=148ca7cf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a257c454bb1afb7
dashboard link: https://syzkaller.appspot.com/bug?extid=c35d73ce910d86c0026e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fb2a74580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ef023f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/59048bc9c206/disk-a4cda136.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ad2ba7306f20/vmlinux-a4cda136.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b3bef7acbf10/bzImage-a4cda136.xz

The issue was bisected to:

commit 00b35530811f2aa3d7ceec2dbada80861c7632a8
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Feb 6 14:04:22 2025 +0000

    batman-adv: adopt netdev_hold() / netdev_put()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1703e23f980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1483e23f980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1083e23f980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c35d73ce910d86c0026e@syzkaller.appspotmail.com
Fixes: 00b35530811f ("batman-adv: adopt netdev_hold() / netdev_put()")

------------[ cut here ]------------
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff819c19fc>] prepare_to_wait_event+0x3ac/0x460 kernel/sched/wait.c:298
WARNING: CPU: 1 PID: 5840 at kernel/sched/core.c:8745 __might_sleep+0xb9/0xe0 kernel/sched/core.c:8741
Modules linked in:
CPU: 1 UID: 0 PID: 5840 Comm: syz-executor181 Not tainted 6.14.0-next-20250404-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:__might_sleep+0xb9/0xe0 kernel/sched/core.c:8741
Code: b7 0e 01 90 42 80 3c 23 00 74 08 48 89 ef e8 3e 13 9b 00 48 8b 4d 00 48 c7 c7 e0 33 4a 8c 44 89 ee 48 89 ca e8 18 11 f0 ff 90 <0f> 0b 90 90 eb b5 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 70 ff ff ff
RSP: 0018:ffffc9000415f988 EFLAGS: 00010246
RAX: fd368e7e13f3a900 RBX: 1ffff110058ec6b1 RCX: ffff88802c761e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88802c763588 R08: ffffffff81828012 R09: fffffbfff1d7a980
R10: dffffc0000000000 R11: fffffbfff1d7a980 R12: dffffc0000000000
R13: 0000000000000001 R14: 0000000000000242 R15: ffffffff8c4ad740
FS:  00005555827b3380(0000) GS:ffff88812508f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559c14e13950 CR3: 000000007bd64000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __mutex_lock_common kernel/locking/mutex.c:578 [inline]
 __mutex_lock+0x12c/0x10c0 kernel/locking/mutex.c:746
 have_mon_and_osd_map net/ceph/ceph_common.c:796 [inline]
 __ceph_open_session+0x471/0xa30 net/ceph/ceph_common.c:826
 ceph_real_mount fs/ceph/super.c:1167 [inline]
 ceph_get_tree+0xac4/0x17b0 fs/ceph/super.c:1355
 vfs_get_tree+0x90/0x2b0 fs/super.c:1759
 vfs_cmd_create+0xa0/0x1f0 fs/fsopen.c:225
 vfs_fsconfig_locked fs/fsopen.c:-1 [inline]
 __do_sys_fsconfig fs/fsopen.c:467 [inline]
 __se_sys_fsconfig+0xa20/0xf40 fs/fsopen.c:344
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0b20653329
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffabd71a98 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
RAX: ffffffffffffffda RBX: 00007fffabd71c68 RCX: 00007f0b20653329
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 00007f0b206c6610 R08: 0000000000000000 R09: 00007fffabd71c68
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fffabd71c58 R14: 0000000000000001 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

