Return-Path: <ceph-devel+bounces-3899-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D30F5C2940C
	for <lists+ceph-devel@lfdr.de>; Sun, 02 Nov 2025 18:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7A2D74E197A
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Nov 2025 17:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C046F2DF134;
	Sun,  2 Nov 2025 17:38:04 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350AC2DEA77
	for <ceph-devel@vger.kernel.org>; Sun,  2 Nov 2025 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762105084; cv=none; b=edqdDOqzrXQXlZElNKlm4eeJEXc+Ug5C8Wro01iEMv4GnO/r4GAXZtpMJkOekFbqxUxuoqADsZlLvmYRBD/YkiIe9/fj5Rju4TSHwZnonxq1NmBAtkUmrikowHdXo4u89wHySwceeYvmzbCY3JfQTx/5WYZdFG7SrSyXk5y5DM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762105084; c=relaxed/simple;
	bh=o0FIdqFREk++l3J1v2J3tW9h4pt95Mr7/7IG2Ece5Aw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=g7G4pRLgJkIY3oKTRvx00gZwRJXlRHI9b23b/PM+OzI56CvfQuVL/e9fRwX0P6iPAbrGcx+wkQyDpjDDt/klhMKSJoaoSNqMGaiDSvj9YHv8jo+aMSKSkFjUyJsJW/1eJ7lTnOA55eWpyAYhWGrS/1GzVi15vveWTK618vBMvsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-93e7f4f7bb1so335092839f.3
        for <ceph-devel@vger.kernel.org>; Sun, 02 Nov 2025 09:38:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762105082; x=1762709882;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r/wAEv9GIPrwh1+x/pr00cLookNh43MVdSe1H945Cxs=;
        b=ol2CyKar0CGr1zyS0MsnbTqEUSANjYge3mSkVSvpzf53gRFr98K/arkaY3nvzl4Bx6
         Kq7I3drh+LGtebgE1hXvKxNdyL6hoDjGjG7pQNBCqPlRS/HKvVPb5GdiAGiRVFyqlofu
         PvbIj4KnjQp/p0xtaQIEbDWaykfWt2QHk+bxhLaZKnhBVX8D30LquVVd3M1I1r3H5alH
         bCYaOQTNCxSWKKDacJXsdmYNhGv0VTaOjJbb6XJccutailCkx517nAsafeQWBPoueiqR
         J/eQNEyauFUPN7tpLPJ5bNHbGOEZ/ZMvj1HzYGyRE4k4mtXhxz9QXbnzcy5L6zEOYL0z
         tAPQ==
X-Forwarded-Encrypted: i=1; AJvYcCX672AHMoLyl15iNWY65z+1m+hcTKkEHQqfNNOtvjoC2Sm3vEuFrWZPeVTf7Gn1mmrm9ysETO6YIi89@vger.kernel.org
X-Gm-Message-State: AOJu0YwOm7yUcH9HLiavy6LDhydNGy1jCZdw21WFySyetFHJrQmPSEh0
	hz4O4jJcUBgwh/VYGZWqrR2jXaAez4NCYc6jhLqE7n+a0ehkeZzy0VWuZ64oc+mS9EUgOfxvDtM
	scOxjGChl5oqnD1xpf09VFpkdlEsEq/FC6icznlIr63FngunlqEExpMBsNrM=
X-Google-Smtp-Source: AGHT+IG1zgigFckBfcGNeJaiPbJX6Gh9TmGX80g1LSF0Ct9iysgCECfpHX/faSxFEexyhP9Nc8O6trkMpNHWl4XussCMo5cabh/D
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3e8c:b0:430:ab63:69d6 with SMTP id
 e9e14a558f8ab-4330d1c9e60mr128484625ab.21.1762105082195; Sun, 02 Nov 2025
 09:38:02 -0800 (PST)
Date: Sun, 02 Nov 2025 09:38:02 -0800
In-Reply-To: <67b454d4.050a0220.173698.0051.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690796fa.a70a0220.37351b.000b.GAE@google.com>
Subject: Re: [syzbot] [kernfs?] [netfs?] INFO: task hung in pipe_write (6)
From: syzbot <syzbot+5984e31a805252b3b40a@syzkaller.appspotmail.com>
To: asmadeus@codewreck.org, brauner@kernel.org, ceph-devel@vger.kernel.org, 
	dhowells@redhat.com, gregkh@linuxfoundation.org, idryomov@gmail.com, 
	jack@suse.cz, jlayton@kernel.org, kprateek.nayak@amd.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, netfs@lists.linux.dev, oleg@redhat.com, 
	rostedt@goodmis.org, syzkaller-bugs@googlegroups.com, tj@kernel.org, 
	viro@zeniv.linux.org.uk, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit e8fe3f07a357c39d429e02ca34f740692d88967a
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Tue Aug 19 16:10:13 2025 +0000

    9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=154ba342580000
start commit:   ad1b832bf1cf Merge tag 'devicetree-fixes-for-6.14-1' of gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e55cabe422b4fcaf
dashboard link: https://syzkaller.appspot.com/bug?extid=5984e31a805252b3b40a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170d57df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12df35a4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: 9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

