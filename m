Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC795A0213
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Aug 2022 21:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239611AbiHXT1X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Aug 2022 15:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbiHXT1W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Aug 2022 15:27:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29404641C
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 12:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2569B825C0
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 19:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25D3C433C1;
        Wed, 24 Aug 2022 19:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661369238;
        bh=lwfUhBx+3hBuMMWMRgimY1++r2VKpJNBRHSedT53uZg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BBP2wDf97dNs0Yx2aYaPsxhir1eCGQc86yZ2grg0/NmI4dxbv/ElGy4D2h4Hk9WST
         ikv2SMXvtIDfqGzZJZJRFKDm4Lv/bCtO/nMR3REj89ifz54z7go4g11HF1YdvQ/FPc
         Iij9n/2V7sS+Tgtkf42JHMdF0ROlAJAvWbR/Z022pLsBCz+YSRF3q6fZObQ6ihpQTf
         tackKAdxSu1bI0DLKKOPF4aQ4hAS5E0tiM5eJ51rLnKGwM0RULC0wzJXn0Kvkf8ykg
         rosDhoUsABfp/zAyBWnMXxJ2fdEuBFbyFya8mAeQcTdwfRbcUnCZE4hzcqKb3TT1su
         Jz9BWf8D49VEg==
Message-ID: <bc320aeaa6d11f705c76dc3bd2236681765fed8c.camel@kernel.org>
Subject: Re: staging in the fscrypt patches
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Wed, 24 Aug 2022 15:27:16 -0400
In-Reply-To: <YwZHJqPO3iTT6qgC@suse.de>
References: <7de95a15fb97d7e60af6cbd9bac2150a17b9ad4f.camel@kernel.org>
         <YwZHJqPO3iTT6qgC@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-08-24 at 16:43 +0100, Lu=EDs Henriques wrote:
> On Fri, May 27, 2022 at 12:34:59PM -0400, Jeff Layton wrote:
> > Once the Ceph PR for this merge window has gone through, I'd like to
> > start merging in some of the preliminary fscrypt patches. In particular=
,
> > I'd like to merge these two patches into ceph-client/master so that the=
y
> > go to linux-next:
> >=20
> > be2bc0698248 fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_en=
crypted_size
> > 7feda88977b8 fscrypt: add fscrypt_context_for_new_inode
> >=20
> > I'd like to see these in ceph-client/testing, so that they start gettin=
g
> > some exposure in teuthology:
> >=20
> > 477944c2ed29 libceph: add spinlock around osd->o_requests
> > 355d9572686c libceph: define struct ceph_sparse_extent and add some hel=
pers
> > 229a3e2cf1c7 libceph: add sparse read support to msgr2 crc state machin=
e
> > a0a9795c2a2c libceph: add sparse read support to OSD client
> > 6a16e0951aaf libceph: support sparse reads on msgr2 secure codepath
> > 538b618f8726 libceph: add sparse read support to msgr1
> > 7ef4c2c39f05 ceph: add new mount option to enable sparse reads
> > b609087729f4 ceph: preallocate inode for ops that may create one
> > e66323d65639 ceph: make ceph_msdc_build_path use ref-walk
> >=20
> > ...they don't add any new functionality (other than the sparse read
> > stuff), but they do change "normal" operation in some ways that we'll
> > need later, so I'd like to see them start being regularly tested.
> >=20
> > If that goes OK, then I'll plan to start merging another tranche a
> > couple of weeks after that.
> >=20
> > Does that sound OK?
> > --=20
> > Jeff Layton <jlayton@kernel.org>
> >=20
>=20
> Sorry for hijacking this thread but, after not looking at this branch for
> a few weeks, I did run a few fstests and just saw the splat bellow.
> Before start looking at it I wanted to ask if it looks familiar.  It seem=
s
> to be reliably trigger by running generic/013, and since I never saw this
> before, something probably broke in a recent rebase.
>=20
> [  237.090462] kernel BUG at net/ceph/messenger.c:1116!
> [  237.092299] invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [  237.093536] CPU: 1 PID: 21 Comm: kworker/1:0 Not tainted 5.19.0-rc6+ #=
99
> [  237.095169] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.16.0-0-gd239552-rebuilt.opensuse.org 04/01/2014
> [  237.097916] Workqueue: ceph-msgr ceph_con_workfn [libceph]
> [  237.099350] RIP: 0010:ceph_msg_data_next+0x251/0x280 [libceph]
> [  237.100778] Code: 00 10 00 00 48 89 0e 48 29 c8 48 8b 4f 10 48 39 c8 4=
8 0f 47 c1 49 89 04 24 0f b7 4f 24 48 8b 42 08 48 8b 04 c8 e9 d8 fe ff ff <=
0f> 0b 0f 0b 0f 0b 0f 0bb
> [  237.105190] RSP: 0018:ffffc900000bbc08 EFLAGS: 00010246
> [  237.106565] RAX: 0000000000000000 RBX: ffff888009354378 RCX: 000000000=
0000000
> [  237.108264] RDX: ffff8880064e0900 RSI: ffffc900000bbc48 RDI: ffff88800=
9354378
> [  237.109956] RBP: ffffc900000bbc48 R08: 0000000073d74d75 R09: 000000000=
0000004
> [  237.111683] R10: ffff888009354378 R11: 0000000000000001 R12: ffffc9000=
00bbc50
> [  237.113660] R13: 0000160000000000 R14: 0000000000001000 R15: ffff88800=
9354378
> [  237.115380] FS:  0000000000000000(0000) GS:ffff88806f700000(0000) knlG=
S:0000000000000000
> [  237.117299] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  237.118689] CR2: 000000000043d000 CR3: 000000007b456000 CR4: 000000000=
00006a0
> [  237.120397] Call Trace:
> [  237.121005]  <TASK>
> [  237.121614]  advance_cursor+0x4f/0x140 [libceph]
> [  237.122942]  osd_sparse_read+0x439/0x670 [libceph]
> [  237.124310]  prepare_sparse_read_cont+0xa6/0x510 [libceph]
> [  237.125833]  ? inet_recvmsg+0x56/0x130
> [  237.126959]  ceph_con_v2_try_read+0x51d/0x1b60 [libceph]
> [  237.128523]  ? _raw_spin_unlock+0x12/0x30
> [  237.129862]  ? finish_task_switch.isra.0+0xa3/0x270
> [  237.131266]  ceph_con_workfn+0x2f9/0x760 [libceph]
> [  237.132481]  process_one_work+0x1c3/0x3c0
> [  237.133454]  worker_thread+0x4d/0x3c0
> [  237.134369]  ? rescuer_thread+0x380/0x380
> [  237.135298]  kthread+0xe2/0x110
> [  237.136018]  ? kthread_complete_and_exit+0x20/0x20
> [  237.137088]  ret_from_fork+0x22/0x30
> [  237.137901]  </TASK>
> [  237.138441] Modules linked in: ceph libceph
> [  237.139798] ---[ end trace 0000000000000000 ]---
> [  237.140970] RIP: 0010:ceph_msg_data_next+0x251/0x280 [libceph]
> [  237.142216] Code: 00 10 00 00 48 89 0e 48 29 c8 48 8b 4f 10 48 39 c8 4=
8 0f 47 c1 49 89 04 24 0f b7 4f 24 48 8b 42 08 48 8b 04 c8 e9 d8 fe ff ff <=
0f> 0b 0f 0b 0f 0b 0f 0bb
> [  237.146797] RSP: 0018:ffffc900000bbc08 EFLAGS: 00010246
> [  237.148291] RAX: 0000000000000000 RBX: ffff888009354378 RCX: 000000000=
0000000
> [  237.149816] RDX: ffff8880064e0900 RSI: ffffc900000bbc48 RDI: ffff88800=
9354378
> [  237.151332] RBP: ffffc900000bbc48 R08: 0000000073d74d75 R09: 000000000=
0000004
> [  237.152816] R10: ffff888009354378 R11: 0000000000000001 R12: ffffc9000=
00bbc50
> [  237.154395] R13: 0000160000000000 R14: 0000000000001000 R15: ffff88800=
9354378
> [  237.155890] FS:  0000000000000000(0000) GS:ffff88806f700000(0000) knlG=
S:0000000000000000
> [  237.157558] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  237.158772] CR2: 000000000043d000 CR3: 000000007b456000 CR4: 000000000=
00006a0
> [  237.160258] note: kworker/1:0[21] exited with preempt_count 1
>=20

I think this is due to a missing wait in the ceph_sync_write rmw code
that probably crept in when it was rebased last time. It just needs:

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8e809299f90b..9d0fe8e95ba8 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1756,6 +1756,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *=
from, loff_t pos,
 			}
=20
 			ceph_osdc_start_request(osdc, req);
+			ret =3D ceph_osdc_wait_request(osdc, req);
=20
 			/* FIXME: length field is wrong if there are 2 extents */
 			ceph_update_read_metrics(&fsc->mdsc->metric,



I went ahead and rebased the wip-fscrypt pile onto the ceph/testing
branch, and pushed the result to the ceph-fscrypt branch in my tree.

Unfortunately, I'm still seeing a crash in the splice codepath when
running generic/013. We'll need to run that down as well:

[  119.170902] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  119.173416] BUG: KASAN: null-ptr-deref in iter_file_splice_write+0x454/0=
x5e0
[  119.175485] Read of size 8 at addr 0000000000000008 by task fsstress/175=
5
[  119.177524]=20
[  119.178010] CPU: 3 PID: 1755 Comm: fsstress Tainted: G           OE     =
 6.0.0-rc1+ #383
[  119.180333] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.1=
6.0-1.fc36 04/01/2014
[  119.182764] Call Trace:
[  119.183527]  <TASK>
[  119.184198]  dump_stack_lvl+0x5b/0x77
[  119.185308]  kasan_report+0xb1/0xf0
[  119.186586]  ? iter_file_splice_write+0x454/0x5e0
[  119.188072]  iter_file_splice_write+0x454/0x5e0
[  119.189462]  ? splice_from_pipe_next+0x290/0x290
[  119.190855]  ? add_to_pipe+0x180/0x180
[  119.192073]  ? static_obj+0x26/0x80
[  119.193175]  direct_splice_actor+0x80/0xb0
[  119.194406]  splice_direct_to_actor+0x1aa/0x400
[  119.195759]  ? is_bpf_text_address+0x67/0xe0
[  119.197064]  ? do_splice_direct+0x160/0x160
[  119.198351]  ? do_splice_to+0x130/0x130
[  119.199526]  do_splice_direct+0xf5/0x160
[  119.200710]  ? splice_direct_to_actor+0x400/0x400
[  119.208599]  ? kmem_cache_free+0x144/0x560
[  119.216004]  generic_copy_file_range+0x74/0x90
[  119.223735]  ? rw_verify_area+0xb0/0xb0
[  119.231082]  ? vfs_fstatat+0x5b/0x70
[  119.238399]  ? __lock_acquire+0x92e/0x2cf0
[  119.245382]  ceph_copy_file_range+0x583/0x980 [ceph]
[  119.252078]  ? ceph_do_objects_copy.constprop.0+0xa30/0xa30 [ceph]
[  119.255963]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[  119.259361]  ? lock_acquire+0x167/0x3e0
[  119.262571]  ? lock_downgrade+0x390/0x390
[  119.265763]  ? _copy_to_user+0x4c/0x60
[  119.268933]  ? inode_security+0x5c/0x80
[  119.272186]  ? avc_policy_seqno+0x28/0x40
[  119.275361]  ? lock_is_held_type+0xe3/0x140
[  119.278516]  vfs_copy_file_range+0x2d3/0x900
[  119.281647]  ? generic_file_rw_checks+0xd0/0xd0
[  119.284789]  ? __do_sys_newfstatat+0x70/0xa0
[  119.287984]  __do_sys_copy_file_range+0x12a/0x260
[  119.291130]  ? vfs_copy_file_range+0x900/0x900
[  119.294017]  ? lockdep_hardirqs_on_prepare+0x128/0x220
[  119.296956]  ? syscall_enter_from_user_mode+0x22/0xc0
[  119.299837]  ? __x64_sys_copy_file_range+0x5c/0x80
[  119.302742]  do_syscall_64+0x3a/0x90
[  119.305550]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  119.308474] RIP: 0033:0x7fa75610af3d
[  119.311122] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 ce 0e 00 f7 d8 64 89 01 48
[  119.317912] RSP: 002b:00007ffd487125d8 EFLAGS: 00000206 ORIG_RAX: 000000=
0000000146
[  119.321306] RAX: ffffffffffffffda RBX: 00000000000326fa RCX: 00007fa7561=
0af3d
[  119.324518] RDX: 0000000000000004 RSI: 00007ffd48712620 RDI: 00000000000=
00003
[  119.327686] RBP: 000000000000008e R08: 000000000000ab2a R09: 00000000000=
00000
[  119.330790] R10: 00007ffd48712628 R11: 0000000000000206 R12: 00000000000=
00003
[  119.333883] R13: 0000000000400000 R14: 000000000000ab2a R15: 00000000000=
1818d
[  119.337074]  </TASK>
[  119.339644] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

