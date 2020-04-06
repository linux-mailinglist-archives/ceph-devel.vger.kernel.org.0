Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B1719F546
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 13:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgDFL62 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 07:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbgDFL62 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 07:58:28 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01E2E2072A;
        Mon,  6 Apr 2020 11:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586174306;
        bh=QkNbVK61MUn+L7Z6mYKFcQrhLquLMXLxpuI/79EJFtk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KM6HLY6GIq3cx5TD/Qc8IynR0zQTU1d3BuaGChc06MKoyv4VAOHj+MSjSOiXUesjp
         e1VtIXv0qw6/3YbirKfK/eTH+aqYANNFLiTQFN6rz9Wsgu+fWPOTrWtR76xJ4n/2LK
         D64q38Ln6zZmXxVYmkpsKJE7ms8RHVaaSYJvPBmA=
Message-ID: <73c181d967960dc2fe4b4ee2e1ecab06694abca7.camel@kernel.org>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
From:   Jeff Layton <jlayton@kernel.org>
To:     Jesper Krogh <jesper.krogh@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Date:   Mon, 06 Apr 2020 07:58:25 -0400
In-Reply-To: <CAED-sic_ckpk97rMVgpAydHHPLseBNNC79P_wQC+ifsqdEJ9zw@mail.gmail.com>
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
         <CAAM7YAmTxAeiemB4YZzD02i8fu99FGSFwpc7zLuzT1xUO6Cn=Q@mail.gmail.com>
         <CAED-sie1P_HTZkaffnPJwHGX-ZnBTrYKps=_N4gH8C1+Oa6ydw@mail.gmail.com>
         <CAED-sidV64ufDVBFn8yHZAGe0L7ejReXBFMj+qYMd+i3nP4g1g@mail.gmail.com>
         <CAED-sic_ckpk97rMVgpAydHHPLseBNNC79P_wQC+ifsqdEJ9zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-04-06 at 12:23 +0200, Jesper Krogh wrote:
> It also emits this one - quite a bit later (not sure thats relevant)
> 
> [43364.349446] kworker/3:6: page allocation failure: order:0,
> mode:0xa20(GFP_ATOMIC), nodemask=(null),cpuset=/,mems_allowed=0

It failed to allocate a single page (order:0) to handle a receive. This
is a GFP_ATOMIC allocation which means that it's not allowed to sleep
(and thus can't do any active reclaim).

> [43364.349459] CPU: 3 PID: 23433 Comm: kworker/3:6 Not tainted 5.4.30 #5
> [43364.349460] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [43364.349515] Workqueue: ceph-msgr ceph_con_workfn [libceph]
> [43364.349516] Call Trace:
> [43364.349523]  <IRQ>
> [43364.349594]  dump_stack+0x6d/0x95
> [43364.349614]  warn_alloc+0x10c/0x170
> [43364.349616]  __alloc_pages_slowpath+0xe6c/0xef0
> [43364.349634]  ? ip_local_deliver_finish+0x48/0x50
> [43364.349635]  ? ip_local_deliver+0x6f/0xe0
> [43364.349640]  ? tcp_v4_early_demux+0x11c/0x150
> [43364.349641]  __alloc_pages_nodemask+0x2f3/0x360
> [43364.349643]  page_frag_alloc+0x129/0x150
> [43364.349654]  __napi_alloc_skb+0x86/0xd0
> [43364.349670]  page_to_skb+0x67/0x350 [virtio_net]
> [43364.349672]  receive_buf+0xe47/0x16c0 [virtio_net]
> [43364.349675]  virtnet_poll+0xf2/0x364 [virtio_net]
> [43364.349679]  net_rx_action+0x265/0x3e0
> [43364.349691]  __do_softirq+0xf9/0x2aa
> [43364.349701]  irq_exit+0xae/0xb0
> [43364.349705]  do_IRQ+0x59/0xe0
> [43364.349706]  common_interrupt+0xf/0xf
> [43364.349707]  </IRQ>
> [43364.349713] RIP: 0010:kvm_clock_get_cycles+0xc/0x20
> [43364.349715] Code: c3 48 c1 e1 06 31 c0 48 81 c1 00 10 60 84 49 89
> 0c 10 eb be 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 65 48 8b 3d e4
> 8f 7a 7d <e8> ff 0f 00 00 5d c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00
> 55 48
> [43364.349716] RSP: 0018:ffffc20941f4bab8 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffffdb
> [43364.349717] RAX: ffffffff8286e040 RBX: 0000277062955ccd RCX: 000000000000056a
> [43364.349735] RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffffffff846010c0
> [43364.349750] RBP: ffffc20941f4bab8 R08: 0000000000008f3e R09: 000000000000097a
> [43364.349751] R10: 0000000000000000 R11: 0000000000001000 R12: 0000000000000000
> [43364.349751] R13: 00000000004a63a2 R14: ffff9c1ac83665b4 R15: 0000000000000000
> [43364.349753]  ? kvmclock_setup_percpu+0x80/0x80
> [43364.349760]  ktime_get+0x3e/0xa0
> [43364.349763]  tcp_mstamp_refresh+0x12/0x40
> [43364.349764]  tcp_rcv_space_adjust+0x22/0x1d0
> [43364.349766]  tcp_recvmsg+0x28b/0xbc0
> [43364.349777]  ? aa_sk_perm+0x43/0x190
> [43364.349781]  inet_recvmsg+0x64/0xf0
> [43364.349786]  sock_recvmsg+0x66/0x70
> [43364.349791]  ceph_tcp_recvpage+0x79/0xb0 [libceph]
> [43364.349796]  read_partial_message+0x3c3/0x7c0 [libceph]
> [43364.349801]  ceph_con_workfn+0xa6a/0x23d0 [libceph]
> [43364.349809]  process_one_work+0x167/0x400
> [43364.349810]  worker_thread+0x4d/0x460
> [43364.349814]  kthread+0x105/0x140
> [43364.349815]  ? rescuer_thread+0x370/0x370
> [43364.349816]  ? kthread_destroy_worker+0x50/0x50
> [43364.349817]  ret_from_fork+0x35/0x40
> [43364.349845] Mem-Info:
> [43364.349849] active_anon:10675 inactive_anon:12484 isolated_anon:0
>                 active_file:14532 inactive_file:3900471 isolated_file:8
>                 unevictable:0 dirty:1 writeback:0 unstable:0
>                 slab_reclaimable:68339 slab_unreclaimable:36220
>                 mapped:11089 shmem:608 pagetables:1093 bounce:0
>                 free:25551 free_pcp:3443 free_cma:0
> [43364.349851] Node 0 active_anon:42700kB inactive_anon:49936kB
> active_file:58128kB inactive_file:15601884kB unevictable:0kB
> isolated(anon):0kB isolated(file):32kB mapped:44356kB dirty:4kB
> writeback:0kB shmem:2432kB shmem_thp: 0kB shmem_pmdmapped: 0kB
> anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
> [43364.349852] Node 0 DMA free:15908kB min:64kB low:80kB high:96kB
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
> unevictable:0kB writepending:0kB present:15992kB managed:15908kB
> mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB
> local_pcp:0kB free_cma:0kB
> [43364.349857] lowmem_reserve[]: 0 3444 15930 15930 15930
> [43364.349859] Node 0 DMA32 free:55240kB min:14596kB low:18244kB
> high:21892kB active_anon:1556kB inactive_anon:188kB active_file:48kB
> inactive_file:3430152kB unevictable:0kB writepending:0kB
> present:3653608kB managed:3588072kB mlocked:0kB kernel_stack:0kB
> pagetables:0kB bounce:0kB free_pcp:3568kB local_pcp:248kB free_cma:0kB
> [43364.349861] lowmem_reserve[]: 0 0 12485 12485 12485
> [43364.349862] Node 0 Normal free:31056kB min:83636kB low:96864kB
> high:110092kB active_anon:41144kB inactive_anon:49748kB
> active_file:58080kB inactive_file:12171732kB unevictable:0kB
> writepending:4kB present:13107200kB managed:12793540kB mlocked:0kB
> kernel_stack:7472kB pagetables:4372kB bounce:0kB free_pcp:10204kB
> local_pcp:1456kB free_cma:0kB
> [43364.349864] lowmem_reserve[]: 0 0 0 0 0
> [43364.349865] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 2*64kB
> (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB
> (M) = 15908kB
> [43364.349877] Node 0 DMA32: 22*4kB (EH) 18*8kB (UMEH) 0*16kB 13*32kB
> (UME) 17*64kB (UM) 18*128kB (UMEH) 14*256kB (UEH) 5*512kB (UE)
> 24*1024kB (UM) 10*2048kB (M) 0*4096kB = 55240kB
> [43364.349894] Node 0 Normal: 94*4kB (UMEH) 47*8kB (MEH) 60*16kB
> (UMEH) 38*32kB (UMEH) 30*64kB (MEH) 21*128kB (MEH) 37*256kB (UM)
> 28*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 31344kB

Here though, it looks like there is quite a bit of free memory, so I'm
not sure why the allocation failed. It's possible that at the time that
the allocation failed there was nothing free, but just afterward quite a
bit of memory did become free (before the kernel could print out the
summary).

It may also be indicative of something else being wrong. If this
happened much later, then it may just be fallout from whatever the
original problem was.

> [43364.349920] Node 0 hugepages_total=0 hugepages_free=0
> hugepages_surp=0 hugepages_size=1048576kB
> [43364.349927] Node 0 hugepages_total=0 hugepages_free=0
> hugepages_surp=0 hugepages_size=2048kB
> [43364.349928] 3915698 total pagecache pages
> [43364.349930] 79 pages in swap cache
> [43364.349931] Swap cache stats: add 393, delete 314, find 38/80
> [43364.349932] Free swap  = 4036080kB
> [43364.349932] Total swap = 4038652kB
> [43364.349933] 4194200 pages RAM
> [43364.349933] 0 pages HighMem/MovableOnly
> [43364.349934] 94820 pages reserved
> [43364.349934] 0 pages cma reserved
> [43364.349934] 0 pages hwpoisoned
> 
> On Mon, Apr 6, 2020 at 11:18 AM Jesper Krogh <jesper.krogh@gmail.com> wrote:
> > And it looks like I can reproduce this pattern - and when it has been
> > stuck for "sufficient" amount of time - then it gets blacklisted by
> > the MDS/OSD and (a related) issue is that I cannot get the mountpoint
> > back without a reboot on the kernel-client side.
> > 
> > On Mon, Apr 6, 2020 at 11:09 AM Jesper Krogh <jesper.krogh@gmail.com> wrote:
> > > home-directory style - median is about 3KB - but varies greatly.
> > > 
> > > I also get this:
> > > [41204.865818] INFO: task kworker/u16:102:21903 blocked for more than
> > > 120 seconds.
> > > [41204.865955]       Not tainted 5.4.30 #5
> > > [41204.866006] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > disables this message.
> > > [41204.866056] kworker/u16:102 D    0 21903      2 0x80004000
> > > [41204.866119] Workqueue: ceph-inode ceph_inode_work [ceph]
> > > [41204.866120] Call Trace:
> > > [41204.866156]  __schedule+0x45f/0x710
> > > [41204.866162]  ? xas_store+0x391/0x5f0
> > > [41204.866164]  schedule+0x3e/0xa0
> > > [41204.866166]  io_schedule+0x16/0x40
> > > [41204.866180]  __lock_page+0x12a/0x1d0
> > > [41204.866182]  ? file_fdatawait_range+0x30/0x30
> > > [41204.866187]  truncate_inode_pages_range+0x52c/0x980
> > > [41204.866191]  ? syscall_return_via_sysret+0x12/0x7f
> > > [41204.866197]  ? drop_inode_snap_realm+0x98/0xa0 [ceph]
> > > [41204.866207]  ? fsnotify_grab_connector+0x4d/0x90
> > > [41204.866209]  truncate_inode_pages_final+0x4c/0x60
> > > [41204.866214]  ceph_evict_inode+0x2d/0x210 [ceph]
> > > [41204.866219]  evict+0xca/0x1a0
> > > [41204.866221]  iput+0x1ba/0x210
> > > [41204.866225]  ceph_inode_work+0x40/0x270 [ceph]
> > > [41204.866232]  process_one_work+0x167/0x400
> > > [41204.866233]  worker_thread+0x4d/0x460
> > > [41204.866236]  kthread+0x105/0x140
> > > [41204.866237]  ? rescuer_thread+0x370/0x370
> > > [41204.866239]  ? kthread_destroy_worker+0x50/0x50
> > > [41204.866240]  ret_from_fork+0x35/0x40
> > > 
> > > On Mon, Apr 6, 2020 at 10:53 AM Yan, Zheng <ukernel@gmail.com> wrote:
> > > > On Mon, Apr 6, 2020 at 4:06 PM Jesper Krogh <jesper.krogh@gmail.com> wrote:
> > > > > This is a CephFS client - its only purpose is to run the "filedaemon" of bacula
> > > > > and transport data to the tape-library from CephFS - below 2 threads is
> > > > > essentially doing something equivalent to
> > > > > 
> > > > > find /cephfs/ -type f | xargs cat | nc server
> > > > > 
> > > > > 2 threads only, load exploding and the "net read vs net write" has
> > > > > more than 100x difference.
> > > > > 
> > > > > Can anyone explain this as "normal" behaviour?
> > > > > Server is a  VM with 16 "vCPU" and 16GB memory running libvirt/qemu
> > > > > 
> > > > > jk@wombat:~$ w
> > > > >  07:50:33 up 11:25,  1 user,  load average: 206.43, 76.23, 50.58
> > > > > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > > > > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > > > > jk@wombat:~$ dstat -ar
> > > > > --total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system-- --io/total-
> > > > > usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw | read  writ
> > > > >   0   0  98   1   0|  14k   34k|   0     0 |   3B   27B| 481   294 |0.55  0.73
> > > > >   1   1   0  98   0|   0     0 |  60M  220k|   0     0 |6402  6182 |   0     0
> > > > >   0   1   0  98   0|   0     0 |  69M  255k|   0     0 |7305  4339 |   0     0
> > > > >   1   2   0  98   0|   0     0 |  76M  282k|   0     0 |7914  4886 |   0     0
> > > > >   1   1   0  99   0|   0     0 |  70M  260k|   0     0 |7293  4444 |   0     0
> > > > >   1   1   0  98   0|   0     0 |  80M  278k|   0     0 |8018  4931 |   0     0
> > > > >   0   1   0  98   0|   0     0 |  60M  221k|   0     0 |6435  5951 |   0     0
> > > > >   0   1   0  99   0|   0     0 |  59M  211k|   0     0 |6163  3584 |   0     0
> > > > >   0   1   0  98   0|   0     0 |  64M  323k|   0     0 |6653  3881 |   0     0
> > > > >   1   0   0  99   0|   0     0 |  61M  243k|   0     0 |6822  4401 |   0     0
> > > > >   0   1   0  99   0|   0     0 |  55M  205k|   0     0 |5975  3518 |   0     0
> > > > >   1   1   0  98   0|   0     0 |  68M  242k|   0     0 |7094  6544 |   0     0
> > > > >   0   1   0  99   0|   0     0 |  58M  230k|   0     0 |6639  4178 |   0     0
> > > > >   1   2   0  98   0|   0     0 |  61M  243k|   0     0 |7117  4477 |   0     0
> > > > >   0   1   0  99   0|   0     0 |  61M  228k|   0     0 |6500  4078 |   0     0
> > > > >   0   1   0  99   0|   0     0 |  65M  234k|   0     0 |6595  3914 |   0     0
> > > > >   0   1   0  98   0|   0     0 |  64M  219k|   0     0 |6507  5755 |   0     0
> > > > >   1   1   0  99   0|   0     0 |  64M  233k|   0     0 |6869  4153 |   0     0
> > > > >   1   2   0  98   0|   0     0 |  63M  232k|   0     0 |6632  3907 |
> > > > > 0     0 ^C
> > > > > jk@wombat:~$ w
> > > > >  07:50:56 up 11:25,  1 user,  load average: 221.35, 88.07, 55.02
> > > > > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > > > > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > > > > jk@wombat:~$
> > > > > 
> > > > > Thanks.
> > > > 
> > > > how small these files are?

-- 
Jeff Layton <jlayton@kernel.org>

