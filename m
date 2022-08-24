Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76BB59FEAE
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Aug 2022 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbiHXPoB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Aug 2022 11:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbiHXPnd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Aug 2022 11:43:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A39A5A83D
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 08:42:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BEBA11F96D;
        Wed, 24 Aug 2022 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661355763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yV5q3XhzzdV9qHrw2+g1kyngMdYfzyqu9iXG0aKh2Sw=;
        b=C5CdpnnRlx/3ZJADOU6V8eQrEoVSUpuZo5ti9DIJuuXvQj5o8Eymq5gGnbEuYrMMTnnCOP
        Y8dM9Rj4Si5x/zwzoNv5Vr/wdUS6bcWFYJZQFWjTT7ueIQobOmswPv1nfkmijAo2LbJbGM
        Rfjh4qOOEj1lSeLENQHcr0XBjz5HPTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661355763;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yV5q3XhzzdV9qHrw2+g1kyngMdYfzyqu9iXG0aKh2Sw=;
        b=hkRfsI6jNZBC4a3wqo6Nmco/u/tnAzx4lCZnNZgsHfibdRg+D6H3NYHChOJUMBkmpsNP4F
        ldxanOnNiKdmCqAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 70A3C13780;
        Wed, 24 Aug 2022 15:42:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OY6PGPNGBmPZJQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 24 Aug 2022 15:42:43 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 00579ae9;
        Wed, 24 Aug 2022 15:43:34 +0000 (UTC)
Date:   Wed, 24 Aug 2022 16:43:34 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: staging in the fscrypt patches
Message-ID: <YwZHJqPO3iTT6qgC@suse.de>
References: <7de95a15fb97d7e60af6cbd9bac2150a17b9ad4f.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7de95a15fb97d7e60af6cbd9bac2150a17b9ad4f.camel@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 27, 2022 at 12:34:59PM -0400, Jeff Layton wrote:
> Once the Ceph PR for this merge window has gone through, I'd like to
> start merging in some of the preliminary fscrypt patches. In particular,
> I'd like to merge these two patches into ceph-client/master so that they
> go to linux-next:
> 
> be2bc0698248 fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_encrypted_size
> 7feda88977b8 fscrypt: add fscrypt_context_for_new_inode
> 
> I'd like to see these in ceph-client/testing, so that they start getting
> some exposure in teuthology:
> 
> 477944c2ed29 libceph: add spinlock around osd->o_requests
> 355d9572686c libceph: define struct ceph_sparse_extent and add some helpers
> 229a3e2cf1c7 libceph: add sparse read support to msgr2 crc state machine
> a0a9795c2a2c libceph: add sparse read support to OSD client
> 6a16e0951aaf libceph: support sparse reads on msgr2 secure codepath
> 538b618f8726 libceph: add sparse read support to msgr1
> 7ef4c2c39f05 ceph: add new mount option to enable sparse reads
> b609087729f4 ceph: preallocate inode for ops that may create one
> e66323d65639 ceph: make ceph_msdc_build_path use ref-walk
> 
> ...they don't add any new functionality (other than the sparse read
> stuff), but they do change "normal" operation in some ways that we'll
> need later, so I'd like to see them start being regularly tested.
> 
> If that goes OK, then I'll plan to start merging another tranche a
> couple of weeks after that.
> 
> Does that sound OK?
> -- 
> Jeff Layton <jlayton@kernel.org>
> 

Sorry for hijacking this thread but, after not looking at this branch for
a few weeks, I did run a few fstests and just saw the splat bellow.
Before start looking at it I wanted to ask if it looks familiar.  It seems
to be reliably trigger by running generic/013, and since I never saw this
before, something probably broke in a recent rebase.

[  237.090462] kernel BUG at net/ceph/messenger.c:1116!
[  237.092299] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  237.093536] CPU: 1 PID: 21 Comm: kworker/1:0 Not tainted 5.19.0-rc6+ #99
[  237.095169] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552-rebuilt.opensuse.org 04/01/2014
[  237.097916] Workqueue: ceph-msgr ceph_con_workfn [libceph]
[  237.099350] RIP: 0010:ceph_msg_data_next+0x251/0x280 [libceph]
[  237.100778] Code: 00 10 00 00 48 89 0e 48 29 c8 48 8b 4f 10 48 39 c8 48 0f 47 c1 49 89 04 24 0f b7 4f 24 48 8b 42 08 48 8b 04 c8 e9 d8 fe ff ff <0f> 0b 0f 0b 0f 0b 0f 0bb
[  237.105190] RSP: 0018:ffffc900000bbc08 EFLAGS: 00010246
[  237.106565] RAX: 0000000000000000 RBX: ffff888009354378 RCX: 0000000000000000
[  237.108264] RDX: ffff8880064e0900 RSI: ffffc900000bbc48 RDI: ffff888009354378
[  237.109956] RBP: ffffc900000bbc48 R08: 0000000073d74d75 R09: 0000000000000004
[  237.111683] R10: ffff888009354378 R11: 0000000000000001 R12: ffffc900000bbc50
[  237.113660] R13: 0000160000000000 R14: 0000000000001000 R15: ffff888009354378
[  237.115380] FS:  0000000000000000(0000) GS:ffff88806f700000(0000) knlGS:0000000000000000
[  237.117299] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  237.118689] CR2: 000000000043d000 CR3: 000000007b456000 CR4: 00000000000006a0
[  237.120397] Call Trace:
[  237.121005]  <TASK>
[  237.121614]  advance_cursor+0x4f/0x140 [libceph]
[  237.122942]  osd_sparse_read+0x439/0x670 [libceph]
[  237.124310]  prepare_sparse_read_cont+0xa6/0x510 [libceph]
[  237.125833]  ? inet_recvmsg+0x56/0x130
[  237.126959]  ceph_con_v2_try_read+0x51d/0x1b60 [libceph]
[  237.128523]  ? _raw_spin_unlock+0x12/0x30
[  237.129862]  ? finish_task_switch.isra.0+0xa3/0x270
[  237.131266]  ceph_con_workfn+0x2f9/0x760 [libceph]
[  237.132481]  process_one_work+0x1c3/0x3c0
[  237.133454]  worker_thread+0x4d/0x3c0
[  237.134369]  ? rescuer_thread+0x380/0x380
[  237.135298]  kthread+0xe2/0x110
[  237.136018]  ? kthread_complete_and_exit+0x20/0x20
[  237.137088]  ret_from_fork+0x22/0x30
[  237.137901]  </TASK>
[  237.138441] Modules linked in: ceph libceph
[  237.139798] ---[ end trace 0000000000000000 ]---
[  237.140970] RIP: 0010:ceph_msg_data_next+0x251/0x280 [libceph]
[  237.142216] Code: 00 10 00 00 48 89 0e 48 29 c8 48 8b 4f 10 48 39 c8 48 0f 47 c1 49 89 04 24 0f b7 4f 24 48 8b 42 08 48 8b 04 c8 e9 d8 fe ff ff <0f> 0b 0f 0b 0f 0b 0f 0bb
[  237.146797] RSP: 0018:ffffc900000bbc08 EFLAGS: 00010246
[  237.148291] RAX: 0000000000000000 RBX: ffff888009354378 RCX: 0000000000000000
[  237.149816] RDX: ffff8880064e0900 RSI: ffffc900000bbc48 RDI: ffff888009354378
[  237.151332] RBP: ffffc900000bbc48 R08: 0000000073d74d75 R09: 0000000000000004
[  237.152816] R10: ffff888009354378 R11: 0000000000000001 R12: ffffc900000bbc50
[  237.154395] R13: 0000160000000000 R14: 0000000000001000 R15: ffff888009354378
[  237.155890] FS:  0000000000000000(0000) GS:ffff88806f700000(0000) knlGS:0000000000000000
[  237.157558] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  237.158772] CR2: 000000000043d000 CR3: 000000007b456000 CR4: 00000000000006a0
[  237.160258] note: kworker/1:0[21] exited with preempt_count 1

Cheers,
--
Luís
