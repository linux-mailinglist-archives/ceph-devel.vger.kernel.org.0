Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C50B4BBDD3
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Feb 2022 17:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiBRQxO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Feb 2022 11:53:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiBRQxM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Feb 2022 11:53:12 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A181275C14
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 08:52:55 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 43D221F3AA;
        Fri, 18 Feb 2022 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645203174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n35neqrXr/CwUrmFkCw4ogNjLmdUlF6NFQr/i0k10wU=;
        b=gc6EgNIfbF/S9IVwK0NJJepdDdMVVqG08sc9oOHRscC0byaHdiWnMMYhFI4MUc6PQKPR8b
        s03/mm28g2A5giuNb8stM3FxfLRk2Nh6B/xjdg+D03WvwU/022sAGzFTPcStFEEZO6fIz+
        PJTvnokjpDJjzxZcDXBHpj1yDmoICkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645203174;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n35neqrXr/CwUrmFkCw4ogNjLmdUlF6NFQr/i0k10wU=;
        b=WuqlA0Xb+0nmULpFPOAbmFcd3j+hpTa3JsgsPtlQIpIZV8dSDA2IvJLkkpFXMp96XPj/Ok
        d+lwPtR6fED+3SCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CA88913CB6;
        Fri, 18 Feb 2022 16:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YVNrLuXOD2LmSgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 18 Feb 2022 16:52:53 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 691555f1;
        Fri, 18 Feb 2022 16:53:06 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ukernel@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph: do not update snapshot context when there is
 no new snapshot
References: <20220218024722.7952-1-xiubli@redhat.com>
Date:   Fri, 18 Feb 2022 16:53:06 +0000
In-Reply-To: <20220218024722.7952-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Fri, 18 Feb 2022 10:47:22 +0800")
Message-ID: <877d9si0b1.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

I'm seeing the BUG below when running a simple fsstress on an encrypted
directory.  Reverting this commit seems to make it go away, but I'm not
yet 100% sure this is the culprit (I just wanted to report it before going
offline for the weekend.)

I stared at this code for a bit, but no light so far.

Cheers,
--=20
Lu=C3=ADs

[   43.593441] ------------[ cut here ]------------=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[   43.595707] kernel BUG at fs/ceph/addr.c:108!
[   43.598354] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[   43.601563] CPU: 0 PID: 232 Comm: fsstress Not tainted 5.17.0-rc2+ #62
[   43.604225] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
[   43.607957] RIP: 0010:ceph_set_page_dirty+0x1eb/0x1f0 [ceph]
[   43.610909] Code: 55 51 83 e9 01 50 51 48 c7 c1 df 50 0d a0 52 ff 73 20 =
ba 03 00 00 00 53 41 ff 34 24 e8 2e 31 2f e1 48 83 c4 50 e9 f0 fe ff ff <0f=
> 0b 0f 1f 00 0f 1f 44f
[   43.619910] RSP: 0018:ffffc900002cb9c8 EFLAGS: 00010246
[   43.621662] RAX: ffff888005e65ff0 RBX: ffffea0001fac3c0 RCX: 00000000000=
00001
[   43.624036] RDX: ffff888005e65ff0 RSI: 000000000037b280 RDI: 00000000000=
00000
[   43.626441] RBP: ffff888005e66180 R08: 0000000000000f8a R09: ffffea0001f=
ac3c0
[   43.629834] R10: ffff88800b567e10 R11: 0000000000001000 R12: ffff888005e=
662e0
[   43.633396] R13: 0000000000000000 R14: ffff888005e65e10 R15: 00000000000=
00f8a
[   43.637012] FS:  00007fdc23f7fb80(0000) GS:ffff888071200000(0000) knlGS:=
0000000000000000
[   43.641055] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.643799] CR2: 00007ff30428d008 CR3: 00000000043b6000 CR4: 00000000000=
006b0
[   43.646667] Call Trace:
[   43.647694]  <TASK>
[   43.648579]  folio_mark_dirty+0x36/0x50
[   43.650166]  ceph_write_end+0x53/0x100 [ceph]
[   43.651734]  generic_perform_write+0xfe/0x1d0
[   43.653263]  ceph_write_iter+0x5b5/0x790 [ceph]
[   43.654864]  do_iter_readv_writev+0x14d/0x1d0
[   43.656295]  do_iter_write+0x85/0x1f0
[   43.657491]  iter_file_splice_write+0x253/0x370
[   43.658858]  direct_splice_actor+0x2c/0x40
[   43.660797]  splice_direct_to_actor+0xf8/0x220
[   43.662209]  ? opipe_prep.part.19+0xb0/0xb0
[   43.663493]  do_splice_direct+0x9a/0xd0
[   43.664684]  generic_copy_file_range+0x32/0x40
[   43.666055]  ceph_copy_file_range+0xb3/0xa10 [ceph]
[   43.667455]  ? _raw_spin_unlock+0x12/0x30
[   43.668475]  ? __ceph_do_getattr+0x7a/0x240 [ceph]
[   43.669724]  ? _copy_to_user+0x1c/0x30
[   43.670654]  ? cp_new_stat+0x12b/0x160
[   43.671569]  vfs_copy_file_range+0x26c/0x510
[   43.672609]  __x64_sys_copy_file_range+0x12d/0x1d0
[   43.673759]  do_syscall_64+0x42/0x90
[   43.674607]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   43.675875] RIP: 0033:0x7fdc240a695d
[   43.677114] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 018
[   43.683105] RSP: 002b:00007ffef97a53a8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000146
[   43.685395] RAX: ffffffffffffffda RBX: 0000000000000051 RCX: 00007fdc240=
a695d
[   43.687528] RDX: 0000000000000005 RSI: 00007ffef97a53e0 RDI: 00000000000=
00004
[   43.689596] RBP: 0000000000000004 R08: 000000000001471b R09: 00000000000=
00000
[   43.691550] R10: 00007ffef97a53e8 R11: 0000000000000246 R12: 00000000000=
00005
[   43.693490] R13: 00000000002d3c32 R14: 000000000001471b R15: 00000000004=
be076
[   43.695375]  </TASK>
[   43.695960] Modules linked in: ceph libceph
[   43.697060] ---[ end trace 0000000000000000 ]---
[   43.698259] RIP: 0010:ceph_set_page_dirty+0x1eb/0x1f0 [ceph]
[   43.699676] Code: 55 51 83 e9 01 50 51 48 c7 c1 df 50 0d a0 52 ff 73 20 =
ba 03 00 00 00 53 41 ff 34 24 e8 2e 31 2f e1 48 83 c4 50 e9 f0 fe ff ff <0f=
> 0b 0f 1f 00 0f 1f 44f
[   43.704183] RSP: 0018:ffffc900002cb9c8 EFLAGS: 00010246
[   43.705424] RAX: ffff888005e65ff0 RBX: ffffea0001fac3c0 RCX: 00000000000=
00001
[   43.707116] RDX: ffff888005e65ff0 RSI: 000000000037b280 RDI: 00000000000=
00000
[   43.708718] RBP: ffff888005e66180 R08: 0000000000000f8a R09: ffffea0001f=
ac3c0
[   43.709866] R10: ffff88800b567e10 R11: 0000000000001000 R12: ffff888005e=
662e0
[   43.710923] R13: 0000000000000000 R14: ffff888005e65e10 R15: 00000000000=
00f8a
[   43.711995] FS:  00007fdc23f7fb80(0000) GS:ffff888071200000(0000) knlGS:=
0000000000000000
[   43.713189] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.714069] CR2: 00007ff30428d008 CR3: 00000000043b6000 CR4: 00000000000=
006b0
[   43.715093] note: fsstress[232] exited with preempt_count 1


