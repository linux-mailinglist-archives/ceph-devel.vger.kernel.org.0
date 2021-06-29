Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0493B7147
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 13:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhF2LYl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 07:24:41 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40008 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbhF2LYl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Jun 2021 07:24:41 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6DDA1203D1;
        Tue, 29 Jun 2021 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624965733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/BDRKp0I/HPkq9uof8huaTPb8r6HoX8Yti9R/eucrA=;
        b=JjwKI7AupDsao8LIL8E87HDV/EhJLr/5nV1Bs754pScDJp+rM1DoxH3RTdgaFxL6vHrVuh
        AYZbM7nkH3gjUHxZrDzNi4RQePZ8Tfidp7Pv06ako8kDYBH0bJfGeKJ8HXoy/ToWBRQaMt
        yx/A88NarJuS7gAHCB59g+sqzPlppCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624965733;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/BDRKp0I/HPkq9uof8huaTPb8r6HoX8Yti9R/eucrA=;
        b=S6KtX7ayddM2kC6ilS7ZXzUuZFY6y+j05YEAC42le/R02idi4iIPBZJZsssgzA8FQSH8Eh
        dI/V8JXrCviai5DA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 116D111906;
        Tue, 29 Jun 2021 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624965733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/BDRKp0I/HPkq9uof8huaTPb8r6HoX8Yti9R/eucrA=;
        b=JjwKI7AupDsao8LIL8E87HDV/EhJLr/5nV1Bs754pScDJp+rM1DoxH3RTdgaFxL6vHrVuh
        AYZbM7nkH3gjUHxZrDzNi4RQePZ8Tfidp7Pv06ako8kDYBH0bJfGeKJ8HXoy/ToWBRQaMt
        yx/A88NarJuS7gAHCB59g+sqzPlppCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624965733;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/BDRKp0I/HPkq9uof8huaTPb8r6HoX8Yti9R/eucrA=;
        b=S6KtX7ayddM2kC6ilS7ZXzUuZFY6y+j05YEAC42le/R02idi4iIPBZJZsssgzA8FQSH8Eh
        dI/V8JXrCviai5DA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id A8uQAGUC22CeJAAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Tue, 29 Jun 2021 11:22:12 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 3a008d77;
        Tue, 29 Jun 2021 11:22:12 +0000 (UTC)
Date:   Tue, 29 Jun 2021 12:22:12 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     jlayton@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 0/4] ceph: new mount device syntax
Message-ID: <YNsCZP0JKHkRK20n@suse.de>
References: <20210628075545.702106-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210628075545.702106-1-vshankar@redhat.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 28, 2021 at 01:25:41PM +0530, Venky Shankar wrote:
> This series introduces changes Ceph File System mount device string.
> Old mount device syntax (source) has the following problems:
> 
> mounts to the same cluster but with different fsnames
> and/or creds have identical device string which can
> confuse xfstests.
> 
> Userspace mount helper tool resolves monitor addresses
> and fill in mon addrs automatically, but that means the
> device shown in /proc/mounts is different than what was
> used for mounting.
> 
> New device syntax is as follows:
> 
>   cephuser@fsid.mycephfs2=/path
> 
> Note, there is no "monitor address" in the device string.
> That gets passed in as mount option. This keeps the device
> string same when monitor addresses change (on remounts).
> 
> Also note that the userspace mount helper tool is backward
> compatible. I.e., the mount helper will fallback to using
> old syntax after trying to mount with the new syntax.

I haven't fully reviewed this patchset yet.  I've started doing that (I'll
send a few comments in a bit), but stopped when I found some parsing
issues that need fixing.

I gave these patches a quick test (with a not-so-up-to-date mount.ceph)
and saw the splat below.  Does this patchset depends on anything on the
testing branch?  I've tried it on v5.13 mainline.

I also had a segmentation fault on the userspace mount.  I've used
something like:

mount -t ceph admin@ef274016-6131-4936-9277-946b535f5d03.a=/ /mnt/test

Cheers,
--
Luís

[    7.847565] ------------[ cut here ]------------
[    7.849322] kernel BUG at net/ceph/mon_client.c:209!
[    7.851151] invalid opcode: 0000 [#1] SMP PTI
[    7.852651] CPU: 1 PID: 188 Comm: mount Not tainted 5.13.0+ #32
[    7.854698] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
[    7.858555] RIP: 0010:__open_session+0x186/0x210 [libceph]
[    7.860517] Code: 50 01 00 00 e8 db a9 ff ff 48 8b b3 50 01 00 00 48 89 ef 5b 5d 41 5c e9 68 b6 ff ff e8 43 8e 48 e1 31 d2 f7 f5 e9 c9 fe ff ff <0f> 0b 48 8b 43 08 41 b91
[    7.866902] RSP: 0018:ffffc9000085fda0 EFLAGS: 00010246
[    7.868736] RAX: ffff888114396520 RBX: 0000000000003a98 RCX: 0000000000000000
[    7.871260] RDX: 0000000000000000 RSI: ffff88810eeec2a8 RDI: ffff88810eeec298
[    7.873653] RBP: 0000000000000000 R08: 0000000000000008 R09: 0000000000000000
[    7.875923] R10: ffffc9000085fdc0 R11: 0000000000000000 R12: 00000000ffffffff
[    7.878229] R13: ffff88811aef8500 R14: 00000000fffee289 R15: 7fffffffffffffff
[    7.880503] FS:  00007fda2ac9b800(0000) GS:ffff888237d00000(0000) knlGS:0000000000000000
[    7.883088] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.884915] CR2: 00007f837ba61e88 CR3: 000000010fefc000 CR4: 00000000000006a0
[    7.887174] Call Trace:
[    7.887920]  ceph_monc_open_session+0x43/0x60 [libceph]
[    7.889502]  __ceph_open_session+0x4b/0x250 [libceph]
[    7.891036]  ceph_get_tree+0x41b/0x880 [ceph]
[    7.892337]  vfs_get_tree+0x23/0x90
[    7.893315]  path_mount+0x73d/0xb20
[    7.894291]  __x64_sys_mount+0x103/0x140
[    7.895387]  do_syscall_64+0x45/0x80
[    7.896324]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    7.897738] RIP: 0033:0x7fda2aeb617e
[    7.898886] Code: 48 8b 0d f5 1c 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 018
[    7.903441] RSP: 002b:00007fff4b0d3e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[    7.905181] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fda2aeb617e
[    7.906813] RDX: 0000563e07b04c80 RSI: 0000563e07b04d20 RDI: 0000563e07b04ca0
[    7.908506] RBP: 0000563e07b04960 R08: 0000563e07b04be0 R09: 00007fda2af78a60
[    7.910176] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[    7.911830] R13: 0000563e07b04c80 R14: 0000563e07b04ca0 R15: 0000563e07b04960
[    7.913480] Modules linked in: ceph libceph
[    7.914492] ---[ end trace 2798408fec037d5a ]---
[    7.915582] RIP: 0010:__open_session+0x186/0x210 [libceph]
[    7.916853] Code: 50 01 00 00 e8 db a9 ff ff 48 8b b3 50 01 00 00 48 89 ef 5b 5d 41 5c e9 68 b6 ff ff e8 43 8e 48 e1 31 d2 f7 f5 e9 c9 fe ff ff <0f> 0b 48 8b 43 08 41 b91
[    7.921090] RSP: 0018:ffffc9000085fda0 EFLAGS: 00010246
[    7.922288] RAX: ffff888114396520 RBX: 0000000000003a98 RCX: 0000000000000000
[    7.923875] RDX: 0000000000000000 RSI: ffff88810eeec2a8 RDI: ffff88810eeec298
[    7.925323] RBP: 0000000000000000 R08: 0000000000000008 R09: 0000000000000000
[    7.926822] R10: ffffc9000085fdc0 R11: 0000000000000000 R12: 00000000ffffffff
[    7.928320] R13: ffff88811aef8500 R14: 00000000fffee289 R15: 7fffffffffffffff
[    7.929790] FS:  00007fda2ac9b800(0000) GS:ffff888237d00000(0000) knlGS:0000000000000000
[    7.931471] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.932579] CR2: 00007f837ba61e88 CR3: 000000010fefc000 CR4: 00000000000006a0
