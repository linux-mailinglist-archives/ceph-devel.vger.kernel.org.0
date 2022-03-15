Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9A64D9C4E
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 14:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343569AbiCONel (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 09:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237841AbiCONek (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 09:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C2C6443
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91EE461629
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 13:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9285EC340E8;
        Tue, 15 Mar 2022 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647351206;
        bh=Cg0OtXLrLXHJfrVervVbVJOBBQ3n9vIdFLctyy/jvRc=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=jkz8fz1ft2zpOaBb8YrjmlCJRw6mBIUn9DXyysTQmviX1e+Cv7v/gCIqaum3U6BWi
         PZd6bL+Hc53nGzKD52LNRSWZvNuMMDrUcfnWFZyqFtis25naevfTh1kM8Y7vo2kW+Q
         fNvQI1+CGSJRnHkKPL2eTnHWlN0sZe5NG7usOPShdLw0hYuyi4SeG0A+xN+2RWGt9I
         o/WBQitfACPYhDU24csW/bDrmgXRJynuIkuxy/s+F1L9KqmscSHSMjdmKUyP7mKGK0
         FMuMRTfp52DkIYcR7CARDUtSgS8GL9KRZ9oAHA+ihb0Y9OrVeWVV84YwDHl2yHquE8
         T8OSr7dGxSzDA==
Message-ID: <0101c170ef8388f307c25556854992f5fe7704be.camel@kernel.org>
Subject: Re: [PATCH 0/3] ceph: support for sparse read in msgr2 crc path
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
Date:   Tue, 15 Mar 2022 09:33:24 -0400
In-Reply-To: <d4b920c6-6afe-4506-77d4-0e6415a894ad@redhat.com>
References: <20220309123323.20593-1-jlayton@kernel.org>
         <f9ee2a7d-f8da-6056-c659-6f7c168cd93b@redhat.com>
         <5016766a07f38d16e6fea66b2ad9da7076bf4a9b.camel@kernel.org>
         <61be495f-c54e-42dc-27e8-8ffb3dfcb415@redhat.com>
         <7e115f2fb22ba5335ed247eb6f30a1fec1654d1b.camel@kernel.org>
         <d4b920c6-6afe-4506-77d4-0e6415a894ad@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-15 at 19:12 +0800, Xiubo Li wrote:
> On 3/15/22 7:10 PM, Jeff Layton wrote:
> > On Tue, 2022-03-15 at 19:03 +0800, Xiubo Li wrote:
> > > On 3/15/22 6:12 PM, Jeff Layton wrote:
> > > > On Tue, 2022-03-15 at 14:23 +0800, Xiubo Li wrote:
> > > > > Hi Jeff,
> > > > > 
> > > > > I hit the following crash by using the latest wip-fscrypt branch:
> > > > > 
> > > > > <5>[245348.815462] Key type ceph unregistered
> > > > > <5>[245545.560567] Key type ceph registered
> > > > > <6>[245545.566723] libceph: loaded (mon/osd proto 15/24)
> > > > > <6>[245545.775116] ceph: loaded (mds proto 32)
> > > > > <6>[245545.822200] libceph: mon2 (1)10.72.47.117:40843 session established
> > > > > <6>[245545.829658] libceph: client5000 fsid
> > > > > 2b9c5f33-3f43-4f89-945d-2a1b6372c5af
> > > > > <4>[245583.531648] ------------[ cut here ]------------
> > > > > <2>[245583.531701] kernel BUG at net/ceph/messenger.c:1032!
> > > > > <4>[245583.531929] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> > > > > <4>[245583.532030] CPU: 2 PID: 283539 Comm: kworker/2:0 Tainted:
> > > > > G            E     5.17.0-rc6+ #98
> > > > > <4>[245583.532050] Hardware name: Red Hat RHEV Hypervisor, BIOS
> > > > > 1.11.0-2.el7 04/01/2014
> > > > > <4>[245583.532086] Workqueue: ceph-msgr ceph_con_workfn [libceph]
> > > > > <4>[245583.532380] RIP: 0010:ceph_msg_data_cursor_init+0x79/0x80 [libceph]
> > > > > <4>[245583.532592] Code: 8d 7b 08 e8 39 99 00 dc 48 8d 7b 18 48 89 6b 08
> > > > > e8 ec 97 00 dc c7 43 18 00 00 00 00 48 89 df 5b 5d 41 5c e9 89 c7 ff ff
> > > > > 0f 0b <0f> 0b 0f 0b 0f 1f 00 0f 1f 44 00 00 41 57 41 56 41 55 49 89 cd 41
> > > > > <4>[245583.532609] RSP: 0018:ffffc90018847c10 EFLAGS: 00010287
> > > > > <4>[245583.532654] RAX: 0000000000000000 RBX: ffff888244ff3850 RCX:
> > > > > ffffffffc10bd850
> > > > > <4>[245583.532683] RDX: dffffc0000000000 RSI: ffff888244ff37d0 RDI:
> > > > > ffff888244ff3838
> > > > > <4>[245583.532705] RBP: ffff888244ff37d0 R08: 00000000000000d1 R09:
> > > > > ffffed10489fe701
> > > > > <4>[245583.532726] R10: ffff888244ff3804 R11: ffffed10489fe700 R12:
> > > > > 00000000000000d1
> > > > > <4>[245583.532746] R13: ffff8882d1adb030 R14: ffff8882d1adb408 R15:
> > > > > 0000000000000000
> > > > > <4>[245583.532764] FS:  0000000000000000(0000) GS:ffff8887ccd00000(0000)
> > > > > knlGS:0000000000000000
> > > > > <4>[245583.532785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > <4>[245583.532797] CR2: 00007fb991665000 CR3: 0000000368ebe001 CR4:
> > > > > 00000000007706e0
> > > > > <4>[245583.532809] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > > 0000000000000000
> > > > > <4>[245583.532820] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > > > 0000000000000400
> > > > > <4>[245583.532831] PKRU: 55555554
> > > > > <4>[245583.532840] Call Trace:
> > > > > <4>[245583.532852]  <TASK>
> > > > > <4>[245583.532863]  ceph_con_v1_try_read+0xd21/0x15c0 [libceph]
> > > > > <4>[245583.533124]  ? ceph_tcp_sendpage+0x100/0x100 [libceph]
> > > > > <4>[245583.533348]  ? load_balance+0x1240/0x1240
> > > > > <4>[245583.533655]  ? dequeue_entity+0x18b/0x6f0
> > > > > <4>[245583.533690]  ? mutex_lock+0x8e/0xe0
> > > > > <4>[245583.533869]  ? __mutex_lock_slowpath+0x10/0x10
> > > > > <4>[245583.533887]  ? _raw_spin_unlock+0x16/0x30
> > > > > <4>[245583.533906]  ? __switch_to+0x2fa/0x690
> > > > > <4>[245583.534007]  ceph_con_workfn+0x545/0x940 [libceph]
> > > > > <4>[245583.534234]  process_one_work+0x3c1/0x6e0
> > > > > <4>[245583.534340]  worker_thread+0x57/0x580
> > > > > <4>[245583.534363]  ? process_one_work+0x6e0/0x6e0
> > > > > <4>[245583.534382]  kthread+0x160/0x190
> > > > > <4>[245583.534421]  ? kthread_complete_and_exit+0x20/0x20
> > > > > <4>[245583.534477]  ret_from_fork+0x1f/0x30
> > > > > <4>[245583.534544]  </TASK>
> > > > > ...
> > > > > 
> > > > > <4>[245583.535413] RIP: 0010:ceph_msg_data_cursor_init+0x79/0x80 [libceph]
> > > > > <4>[245583.535627] Code: 8d 7b 08 e8 39 99 00 dc 48 8d 7b 18 48 89 6b 08
> > > > > e8 ec 97 00 dc c7 43 18 00 00 00 00 48 89 df 5b 5d 41 5c e9 89 c7 ff ff
> > > > > 0f 0b <0f> 0b 0f 0b 0f 1f 00 0f 1f 44 00 00 41 57 41 56 41 55 49 89 cd 41
> > > > > <4>[245583.535644] RSP: 0018:ffffc90018847c10 EFLAGS: 00010287
> > > > > <4>[245583.535720] RAX: 0000000000000000 RBX: ffff888244ff3850 RCX:
> > > > > ffffffffc10bd850
> > > > > <4>[245583.535745] RDX: dffffc0000000000 RSI: ffff888244ff37d0 RDI:
> > > > > ffff888244ff3838
> > > > > <4>[245583.535769] RBP: ffff888244ff37d0 R08: 00000000000000d1 R09:
> > > > > ffffed10489fe701
> > > > > 
> > > > > Seems caused by the parse read ?
> > > > > 
> > > > > 
> > > > You mean sparse read? Those patches aren't in the wip-fscrypt branch
> > > > yet, so I wouldn't think them a factor here. What commit was at the top
> > > > of your branch?
> > > > 
> > > > If you're testing the latest sparse read patches on top of wip-fscrypt,
> > > > then those only work with msgr2 so far. Using msgr1 with it is likely to
> > > > have problems.
> > > Okay, it seems another patch series. But I am not sure, this is the
> > > latest commits in the wip-fscrypt branch I hit the issue:
> > > 
> > > 
> > > ce03ef535e7b SQUASH: OSD
> > > 5020f1a5464b ceph: convert to sparse reads
> > > 8614b45d3758 libceph: add sparse read support to OSD client
> > > a11c3b2673aa libceph: add sparse read support to msgr2 crc state machine
> > > a020a702a220 (origin/testing) ceph: allow `ceph.dir.rctime' xattr to be
> > > updatable
> > > 
> > > I just switched back to the branch I pulled days ago, it works well:
> > > 
> > > Yeah, I am using the '--msgr1'. Maybe this is a problem. I will try
> > > '--msgr2' later.
> > > 
> > That makes sense. That oops is probably expected with msgr1 and the
> > sparse read code. If you test with "-o ms_mode=crc" then it should
> > (hopefully!) work.
> 
> Sure.
> 
> 
> > My plan is eventually to add support to all 3 msgr codepaths (v1, v2-
> > crc, and v2-secure), but I'd like some feedback from Ilya on what I have
> > so far before I do that.
> > 
> I will help test your related patches tomorrow.
> 

Thanks.

I think this was my mistake. I pushed the wrong branch into wip-fscrypt
from my tree and it ended up having the sparse read patches for the last
day or so. I've dropped those from the branch for now.

We'll want them eventually, but they're still a little too bleeding-edge
at this point.

-- 
Jeff Layton <jlayton@kernel.org>
