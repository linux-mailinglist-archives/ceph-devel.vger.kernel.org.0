Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063D11A37A8
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Apr 2020 18:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgDIQAn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Apr 2020 12:00:43 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46999 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbgDIQAn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Apr 2020 12:00:43 -0400
Received: by mail-lf1-f65.google.com with SMTP id m19so1811lfq.13
        for <ceph-devel@vger.kernel.org>; Thu, 09 Apr 2020 09:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WL3XAALoW1ByojvNbrvOlKe+ERyjA+kLeHrAJ7Z7LfA=;
        b=ZayjlfWwDxUSPl/DMqppNj3AzqwVTepezVt3SSUrnKKeS78ZuJevghHfgAS1t96BpK
         vTmOSxbqt6H2SMgO0OOsGzv1loPTMGwMSyI4rhnd1t8cWm+9zq3OTgSf9YLycvmGz5Dv
         Ix7GNaIiy+EWgo4k9vV6T1SfzC01HCr4yoMA8m0q5zIpNn5ezOHmYVTmsZsN1xlXUeJu
         sbx4l9Ib8KxCf46jP7EzMjucxLhvDgxrHt8BQUBhenkepVE3DA4hyhclsAbNFdTtSik5
         sIYcB87hU1W/Oj+q5V+I4nSuLxd1Ukki6+gZYVMxLxFAYi2iJJyl0vK4xWh6nPo2SXPT
         Bg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WL3XAALoW1ByojvNbrvOlKe+ERyjA+kLeHrAJ7Z7LfA=;
        b=WL0Cc/lny0GnBJnL4kxWCf9DuWjp8iyWoTc/x49SNJtajTkAgQdS+GbaLJqb3chAh+
         DQXgrUjl68ooLwZ8VAZATJq7/wm1z6Lx77E1Rmn89Q6jEfTl+gwrvUHxT/7EfgXpmQ0P
         /Noo+pUb94o5JFax30C1p5I8BiNLmKwqw5Q8R2dvHeNU4Z894pcvWdf4SJshjBv2LAGQ
         88Cqpa8lnaTvbTX9b2xYfEBlmgqvrb/QUEiuyFNbu9FQI9MkBD6qZPKxPOJl7K9GOoJD
         K+p8xSGhXwaUo6a3BGJTAi4VpRsdlXMiovcIVDl6UoGlkF+DCJnlFxgnN+lPZu43ap7K
         xM9g==
X-Gm-Message-State: AGi0PuaV+34d5sDa6HP2Hf8mR1nfSXuYr/GIDT5z/VeP47m5s1KqgY/i
        fGWwSowf9Y1TdBSal0TfKfxECUQ/JyW7tHjU1xHfsA==
X-Google-Smtp-Source: APiQypJoRdfhvoD0TbYAlVJYonWCxEfkATINJeE31UcHwaZZSyXf7whGFMl6rIO8lM5WtgAjFFxiureV31QM08RsNL0=
X-Received: by 2002:ac2:53a6:: with SMTP id j6mr8219975lfh.153.1586448038530;
 Thu, 09 Apr 2020 09:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
 <CAED-sie+qsrr3yZVAiB=t6cAzWUwX9Y=32srJY2dwyRpSXvgxg@mail.gmail.com>
 <e9c9ffb60265aebdab6edd7ce1565402eb787270.camel@kernel.org>
 <CAED-sicefQuJ3GGWh2bBXz6R=BFr1EQ=h6Sz-W_mh3u+-tO0wA@mail.gmail.com> <cbbc31d2041601b3e0d2c9b1e8b657ffa23ed97e.camel@kernel.org>
In-Reply-To: <cbbc31d2041601b3e0d2c9b1e8b657ffa23ed97e.camel@kernel.org>
From:   Jesper Krogh <jesper.krogh@gmail.com>
Date:   Thu, 9 Apr 2020 18:00:27 +0200
Message-ID: <CAED-sic=eDaXz-A6_ejZOYcJYs=-tJtmxXLcONdQRRCod59L_g@mail.gmail.com>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks Jeff - I'll try that.

I would just add to the case that this is a problem we have had on a
physical machine - but too many "other" workloads at the same time -
so we isolated it off to a VM - assuming that it was the mixed
workload situation that did cause us issues. I cannot be sure that it
is "excactly" the same problem we're seeing but symptoms are
identical.

Jesper

On Thu, Apr 9, 2020 at 4:06 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2020-04-09 at 12:23 +0200, Jesper Krogh wrote:
> > And now it jammed up again - stuck mountpoint - reboot needed to move
> > un - load 80 - zero activity.
> > Last stacktrace here (full kern.log attached). As mentioned - this
> > system "only" reads from CephFS to ship data over the network to a
> > tape-library system on another server.  - Suggetions are really -
> > really welcome.
> >
> > jk@wombat:~$ ls -l /ceph/cluster
> > ^C
> > jk@wombat:~$ sudo umount -f -l ' /ceph/cluster
> > > ^C
> > jk@wombat:~$ sudo umount -f -l /ceph/cluster
> > ^C^C^C
> >
> > - hard reboot needed.
> >
> > Apr  9 05:21:26 wombat kernel: [291368.861032] warn_alloc: 122
> > callbacks suppressed
> > Apr  9 05:21:26 wombat kernel: [291368.861035] kworker/3:10: page
> > allocation failure: order:0, mode:0xa20(GFP_ATOMIC),
> > nodemask=(null),cpuset=/,mems_allowed=0
> > Apr  9 05:21:26 wombat kernel: [291368.861041] CPU: 3 PID: 22346 Comm:
> > kworker/3:10 Not tainted 5.4.30 #5
> > Apr  9 05:21:26 wombat kernel: [291368.861042] Hardware name: Bochs
> > Bochs, BIOS Bochs 01/01/2011
> > Apr  9 05:21:26 wombat kernel: [291368.861058] Workqueue: ceph-msgr
> > ceph_con_workfn [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861059] Call Trace:
> > Apr  9 05:21:26 wombat kernel: [291368.861061]  <IRQ>
> > Apr  9 05:21:26 wombat kernel: [291368.861066]  dump_stack+0x6d/0x95
> > Apr  9 05:21:26 wombat kernel: [291368.861069]  warn_alloc+0x10c/0x170
> > Apr  9 05:21:26 wombat kernel: [291368.861070]
> > __alloc_pages_slowpath+0xe6c/0xef0
> > Apr  9 05:21:26 wombat kernel: [291368.861073]  ? tcp4_gro_receive+0x114/0x1b0
> > Apr  9 05:21:26 wombat kernel: [291368.861074]  ? inet_gro_receive+0x25d/0x2c0
> > Apr  9 05:21:26 wombat kernel: [291368.861076]  ? dev_gro_receive+0x69d/0x6f0
> > Apr  9 05:21:26 wombat kernel: [291368.861077]
> > __alloc_pages_nodemask+0x2f3/0x360
> > Apr  9 05:21:26 wombat kernel: [291368.861080]  alloc_pages_current+0x6a/0xe0
> > Apr  9 05:21:26 wombat kernel: [291368.861082]  skb_page_frag_refill+0xda/0x100
> > Apr  9 05:21:26 wombat kernel: [291368.861085]
> > try_fill_recv+0x285/0x6f0 [virtio_net]
>
> This looks like the same problem you reported before.
>
> The network interface driver (virtio_net) took an interrupt and the
> handler called skb_page_frag_refill to allocate a page (order:0) to
> handle a receive. This is a GFP_ATOMIC allocation (because this is in
> softirq context) which is generally means that the task can't do
> activity that sleeps in order to satisfy it (no reclaim allowed). That
> allocation failed for reasons that aren't clear.
>
> I think this probably has very little to do with ceph. It's just that it
> happened to occur while it was attempting to do a receive on behalf of
> the ceph socket. I'd probably start with the virtio_net maintainers (see
> the MAINTAINERS file in the kernel sources), and see if they have
> thoughts, and maybe cc the netdev mailing list.
>
> > Apr  9 05:21:26 wombat kernel: [291368.861087]
> > virtnet_poll+0x32d/0x364 [virtio_net]
> > Apr  9 05:21:26 wombat kernel: [291368.861088]  net_rx_action+0x265/0x3e0
> > Apr  9 05:21:26 wombat kernel: [291368.861091]  __do_softirq+0xf9/0x2aa
> > Apr  9 05:21:26 wombat kernel: [291368.861095]  irq_exit+0xae/0xb0
> > Apr  9 05:21:26 wombat kernel: [291368.861096]  do_IRQ+0x59/0xe0
> > Apr  9 05:21:26 wombat kernel: [291368.861098]  common_interrupt+0xf/0xf
> > Apr  9 05:21:26 wombat kernel: [291368.861098]  </IRQ>
> > Apr  9 05:21:26 wombat kernel: [291368.861124] RIP:
> > 0010:ceph_str_hash_rjenkins+0x199/0x270 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861125] Code: 60 0f b6 57 0a c1
> > e2 18 01 d6 0f b6 57 09 c1 e2 10 01 d6 0f b6 57 08 c1 e2 08 01 d6 0f
> > b6 57 07 c1 e2 18 41 01 d1 0f b6 57 06 <c1> e2 10 41 01 d1 0f b6 57 05
> > c1 e2 08 41 01 d1 0f b6 57 04 41 01
> > Apr  9 05:21:26 wombat kernel: [291368.861126] RSP:
> > 0018:ffffc2094113f890 EFLAGS: 00000206 ORIG_RAX: ffffffffffffffdb
> > Apr  9 05:21:26 wombat kernel: [291368.861127] RAX: 00000000cfce7272
> > RBX: ffff9c171adcd060 RCX: 0000000000000008
> > Apr  9 05:21:26 wombat kernel: [291368.861128] RDX: 0000000000000030
> > RSI: 00000000c35b3cfb RDI: ffff9c171adcd0c4
> > Apr  9 05:21:26 wombat kernel: [291368.861128] RBP: ffffc2094113f890
> > R08: 0000000000000220 R09: 0000000031103db4
> > Apr  9 05:21:26 wombat kernel: [291368.861129] R10: 0000000000303031
> > R11: 000000000000002c R12: ffff9c171adcd0b0
> > Apr  9 05:21:26 wombat kernel: [291368.861130] R13: ffffc2094113fa28
> > R14: ffff9c171adcd0b0 R15: ffff9c171adcd0f0
> > Apr  9 05:21:26 wombat kernel: [291368.861137]
> > ceph_str_hash+0x20/0x70 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861143]
> > __ceph_object_locator_to_pg+0x1bf/0x200 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861149]  ?
> > crush_do_rule+0x412/0x460 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861155]  ?
> > ceph_pg_to_up_acting_osds+0x547/0x8e0 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861160]  ?
> > ceph_pg_to_up_acting_osds+0x672/0x8e0 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861166]
> > calc_target+0x101/0x590 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861172]  ?
> > free_pg_mapping+0x13/0x20 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861177]  ?
> > alloc_pg_mapping+0x30/0x30 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861184]
> > scan_requests.constprop.57+0x165/0x270 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861189]
> > handle_one_map+0x198/0x200 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861194]
> > ceph_osdc_handle_map+0x22f/0x710 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861199]  dispatch+0x3b1/0x9c0 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861204]  ? dispatch+0x3b1/0x9c0 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861209]
> > ceph_con_workfn+0xae8/0x23d0 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861213]  ?
> > ceph_con_workfn+0xae8/0x23d0 [libceph]
> > Apr  9 05:21:26 wombat kernel: [291368.861215]  process_one_work+0x167/0x400
> > Apr  9 05:21:26 wombat kernel: [291368.861216]  worker_thread+0x4d/0x460
> > Apr  9 05:21:26 wombat kernel: [291368.861219]  kthread+0x105/0x140
> > Apr  9 05:21:26 wombat kernel: [291368.861220]  ? rescuer_thread+0x370/0x370
> > Apr  9 05:21:26 wombat kernel: [291368.861221]  ?
> > kthread_destroy_worker+0x50/0x50
> > Apr  9 05:21:26 wombat kernel: [291368.861222]  ret_from_fork+0x35/0x40
> > Apr  9 05:21:26 wombat kernel: [291368.861224] Mem-Info:
> > Apr  9 05:21:26 wombat kernel: [291368.861227] active_anon:1001298
> > inactive_anon:182746 isolated_anon:0
> > Apr  9 05:21:26 wombat kernel: [291368.861227]  active_file:9826
> > inactive_file:2765016 isolated_file:56
> > Apr  9 05:21:26 wombat kernel: [291368.861227]  unevictable:0 dirty:0
> > writeback:0 unstable:0
> > Apr  9 05:21:26 wombat kernel: [291368.861227]  slab_reclaimable:38024
> > slab_unreclaimable:39667
> > Apr  9 05:21:26 wombat kernel: [291368.861227]  mapped:7274 shmem:561
> > pagetables:3465 bounce:0
> > Apr  9 05:21:26 wombat kernel: [291368.861227]  free:31398
> > free_pcp:494 free_cma:0
> > Apr  9 05:21:26 wombat kernel: [291368.861229] Node 0
> > active_anon:4005192kB inactive_anon:730984kB active_file:39304kB
> > inactive_file:11060064kB unevictable:0kB isolated(anon):0kB
> > isolated(file):224kB mapped:29096kB dirty:0kB writeback:0kB
> > shmem:2244kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB
> > writeback_tmp:0kB unstable:0kB all_unreclaimable? no
> > Apr  9 05:21:26 wombat kernel: [291368.861230] Node 0 DMA free:15908kB
> > min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB
> > active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB
> > present:15992kB managed:15908kB mlocked:0kB kernel_stack:0kB
> > pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> > Apr  9 05:21:26 wombat kernel: [291368.861232] lowmem_reserve[]: 0
> > 3444 15930 15930 15930
> > Apr  9 05:21:26 wombat kernel: [291368.861234] Node 0 DMA32
> > free:60576kB min:28932kB low:32580kB high:36228kB active_anon:287052kB
> > inactive_anon:287460kB active_file:2888kB inactive_file:2859520kB
> > unevictable:0kB writepending:0kB present:3653608kB managed:3588072kB
> > mlocked:0kB kernel_stack:96kB pagetables:1196kB bounce:0kB
> > free_pcp:184kB local_pcp:184kB free_cma:0kB
> > Apr  9 05:21:26 wombat kernel: [291368.861236] lowmem_reserve[]: 0 0
> > 12485 12485 12485
> > Apr  9 05:21:26 wombat kernel: [291368.861237] Node 0 Normal
> > free:49108kB min:132788kB low:146016kB high:159244kB
> > active_anon:3718140kB inactive_anon:443524kB active_file:36416kB
> > inactive_file:8200544kB unevictable:0kB writepending:0kB
> > present:13107200kB managed:12793540kB mlocked:0kB kernel_stack:7936kB
> > pagetables:12664kB bounce:0kB free_pcp:1792kB local_pcp:1384kB
> > free_cma:0kB
> > Apr  9 05:21:26 wombat kernel: [291368.861239] lowmem_reserve[]: 0 0 0 0 0
> > Apr  9 05:21:26 wombat kernel: [291368.861240] Node 0 DMA: 1*4kB (U)
> > 0*8kB 0*16kB 1*32kB (U) 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB
> > 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15908kB
> > Apr  9 05:21:26 wombat kernel: [291368.861245] Node 0 DMA32: 734*4kB
> > (UMEH) 699*8kB (UMEH) 373*16kB (UMEH) 46*32kB (ME) 91*64kB (UM)
> > 67*128kB (UME) 54*256kB (UME) 22*512kB (U) 5*1024kB (U) 0*2048kB
> > 0*4096kB = 60576kB
> > Apr  9 05:21:26 wombat kernel: [291368.861250] Node 0 Normal: 5133*4kB
> > (UMEH) 414*8kB (UMEH) 1005*16kB (UMH) 145*32kB (UME) 68*64kB (UME)
> > 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 48916kB
> > Apr  9 05:21:26 wombat kernel: [291368.861259] Node 0
> > hugepages_total=0 hugepages_free=0 hugepages_surp=0
> > hugepages_size=1048576kB
> > Apr  9 05:21:26 wombat kernel: [291368.861260] Node 0
> > hugepages_total=0 hugepages_free=0 hugepages_surp=0
> > hugepages_size=2048kB
> > Apr  9 05:21:26 wombat kernel: [291368.861260] 2775949 total pagecache pages
> > Apr  9 05:21:26 wombat kernel: [291368.861263] 477 pages in swap cache
> > Apr  9 05:21:26 wombat kernel: [291368.861263] Swap cache stats: add
> > 24073, delete 23596, find 88552/91776
> > Apr  9 05:21:26 wombat kernel: [291368.861264] Free swap  = 3963900kB
> > Apr  9 05:21:26 wombat kernel: [291368.861264] Total swap = 4038652kB
> > Apr  9 05:21:26 wombat kernel: [291368.861265] 4194200 pages RAM
> > Apr  9 05:21:26 wombat kernel: [291368.861265] 0 pages HighMem/MovableOnly
> > Apr  9 05:21:26 wombat kernel: [291368.861266] 94820 pages reserved
> > Apr  9 05:21:26 wombat kernel: [291368.861266] 0 pages cma reserved
> > Apr  9 05:21:26 wombat kernel: [291368.861267] 0 pages hwpoisoned
> >
> > On Mon, Apr 6, 2020 at 9:45 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Mon, 2020-04-06 at 15:17 +0200, Jesper Krogh wrote:
> > > > Hi Jeff.
> > > >
> > > > No, because the client "bacula-fd" is reading from the local
> > > > filesystem - here CephFS and sending it over the network to the server
> > > > with the tape-libraries attached to it.  Thus "ideal" receive == send
> > > > - which is also the pattern I see when using larger files (multiple
> > > > MB).
> > > >
> > > > Is the per-file overhead many KB?
> > > >
> > >
> > > Maybe not "many" but "several".
> > >
> > > CephFS is quite chatty. There can also be quite a bit of back and forth
> > > between the client and MDS. The protocol has a lot of extraneous fields
> > > for any given message. Writing also means cap flushes (particularly on
> > > size changes), and those can add up.
> > >
> > > Whether that accounts for what you're seeing though, I'm not sure.
> > >
> > > > On Mon, Apr 6, 2020 at 1:45 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > On Mon, 2020-04-06 at 10:04 +0200, Jesper Krogh wrote:
> > > > > > This is a CephFS client - its only purpose is to run the "filedaemon" of bacula
> > > > > > and transport data to the tape-library from CephFS - below 2 threads is
> > > > > > essentially doing something equivalent to
> > > > > >
> > > > > > find /cephfs/ -type f | xargs cat | nc server
> > > > > >
> > > > > > 2 threads only, load exploding and the "net read vs net write" has
> > > > > > more than 100x difference.
> > > > > >
> > > > >
> > > > > Makes sense. You're basically just reading in all of the data on this
> > > > > cephfs, so the receive is going to be much larger than the send.
> > > > >
> > > > > > Can anyone explain this as "normal" behaviour?
> > > > > > Server is a  VM with 16 "vCPU" and 16GB memory running libvirt/qemu
> > > > > >
> > > > > > jk@wombat:~$ w
> > > > > >  07:50:33 up 11:25,  1 user,  load average: 206.43, 76.23, 50.58
> > > > > > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > > > > > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > > > > > jk@wombat:~$ dstat -ar
> > > > > > --total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system-- --io/total-
> > > > > > usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw | read  writ
> > > > > >   0   0  98   1   0|  14k   34k|   0     0 |   3B   27B| 481   294 |0.55  0.73
> > > > > >   1   1   0  98   0|   0     0 |  60M  220k|   0     0 |6402  6182 |   0     0
> > > > > >   0   1   0  98   0|   0     0 |  69M  255k|   0     0 |7305  4339 |   0     0
> > > > > >   1   2   0  98   0|   0     0 |  76M  282k|   0     0 |7914  4886 |   0     0
> > > > > >   1   1   0  99   0|   0     0 |  70M  260k|   0     0 |7293  4444 |   0     0
> > > > > >   1   1   0  98   0|   0     0 |  80M  278k|   0     0 |8018  4931 |   0     0
> > > > > >   0   1   0  98   0|   0     0 |  60M  221k|   0     0 |6435  5951 |   0     0
> > > > > >   0   1   0  99   0|   0     0 |  59M  211k|   0     0 |6163  3584 |   0     0
> > > > > >   0   1   0  98   0|   0     0 |  64M  323k|   0     0 |6653  3881 |   0     0
> > > > > >   1   0   0  99   0|   0     0 |  61M  243k|   0     0 |6822  4401 |   0     0
> > > > > >   0   1   0  99   0|   0     0 |  55M  205k|   0     0 |5975  3518 |   0     0
> > > > > >   1   1   0  98   0|   0     0 |  68M  242k|   0     0 |7094  6544 |   0     0
> > > > > >   0   1   0  99   0|   0     0 |  58M  230k|   0     0 |6639  4178 |   0     0
> > > > > >   1   2   0  98   0|   0     0 |  61M  243k|   0     0 |7117  4477 |   0     0
> > > > > >   0   1   0  99   0|   0     0 |  61M  228k|   0     0 |6500  4078 |   0     0
> > > > > >   0   1   0  99   0|   0     0 |  65M  234k|   0     0 |6595  3914 |   0     0
> > > > > >   0   1   0  98   0|   0     0 |  64M  219k|   0     0 |6507  5755 |   0     0
> > > > > >   1   1   0  99   0|   0     0 |  64M  233k|   0     0 |6869  4153 |   0     0
> > > > > >   1   2   0  98   0|   0     0 |  63M  232k|   0     0 |6632  3907 |
> > > > > > 0     0 ^C
> > > > >
> > > > > Load average is high, but it looks like it's all just waiting on I/O.
> > > > >
> > > > > > jk@wombat:~$ w
> > > > > >  07:50:56 up 11:25,  1 user,  load average: 221.35, 88.07, 55.02
> > > > > > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > > > > > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > > > > > jk@wombat:~$
> > > > > >
> > > > > --
> > > > > Jeff Layton <jlayton@kernel.org>
> > > > >
> > >
> > > --
> > > Jeff Layton <jlayton@kernel.org>
> > >
>
> --
> Jeff Layton <jlayton@kernel.org>
>
