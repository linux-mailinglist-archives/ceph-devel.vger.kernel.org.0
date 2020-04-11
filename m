Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3DB1A533D
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Apr 2020 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgDKSH7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 11 Apr 2020 14:07:59 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33850 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgDKSH7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 11 Apr 2020 14:07:59 -0400
Received: by mail-lf1-f65.google.com with SMTP id x23so3579298lfq.1
        for <ceph-devel@vger.kernel.org>; Sat, 11 Apr 2020 11:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WR2JbI8Gs6LQeVTLZX5CBsmP8I65gpuvnsVCHdrn1oU=;
        b=Dq4zKn3UK6maHwCBItuZPDjCKODqEu3qmhBVvKu76ir3+wXMh8DBc9iwXVXNniVi47
         FNStwbd0hGTZ86NSOxhZ/uxGfHRgjsNh822pHnpAN1XwHBb/n2gzVWbKkL+wn+/KhKWy
         BIiTeV8Ad/MNI7+IkAV/Dh5Q63w5nDhqhZCsT3rIvbzxIl51QMpYpfJzQEK0WVbeJOHW
         p9JPBiO/OF7OUes0WVSNgfljeFpPFmXYzWKrzxc507zNhqzwXkoQkGGboTS4xzwssA08
         wFCLS85bG7M3tQzb7g40QysX/kJYL21bfwBmBzIQdvz84UvONmu6hWrJlTZyUdHpIoxd
         iDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WR2JbI8Gs6LQeVTLZX5CBsmP8I65gpuvnsVCHdrn1oU=;
        b=OyC69EJonGxIUSSrPNusEhbHy1rUHhaF6LiztIBOvNiy2ZvS4k8JgTMG5gM+y/jHA+
         FXmgEGDJxC1RVrQZ1ds/0gXgCrtBeRR4AcGLY0KAUIbeRy9931Bnx/WM/gG5ENiCSRJT
         UUIAb6JKhk0tirt4Y74tNSOxYCRH8b5BFYeNYDvjCLIBRiC8gKYf09p4XWcsFO0ewAoP
         9MsxNV946RpQjIHK9cL3amF3mJA0m5O6EAWz+aQUeI9ykbKfh14yhvDie+Xl1KZ3Y4nX
         aVCeAokL3BqxbMnDWSdbWfEjdT2yM+HsqMTem5v6ZaWVubGFKBjNHNMiyi91LcSpDgou
         uAZQ==
X-Gm-Message-State: AGi0PuZDWWcysbfKii5jrXP8948sV38qvdt6KwMwLfcooMkb2NxV2dRB
        k1HKIkighW3C1tI+W5tUnKWua4MfhRtXOYRgdj0o9jNJ
X-Google-Smtp-Source: APiQypKNrc1e3SHYzV2kdx8MBOTvhfcKDEiafPnEyEPNH49jy1hWlVepBE1lqIN7txVRhR32CJDVdn4Y/8VjAXosY4Y=
X-Received: by 2002:a19:3848:: with SMTP id d8mr5729627lfj.44.1586628474724;
 Sat, 11 Apr 2020 11:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
 <CAED-sie+qsrr3yZVAiB=t6cAzWUwX9Y=32srJY2dwyRpSXvgxg@mail.gmail.com>
 <e9c9ffb60265aebdab6edd7ce1565402eb787270.camel@kernel.org>
 <CAED-sicefQuJ3GGWh2bBXz6R=BFr1EQ=h6Sz-W_mh3u+-tO0wA@mail.gmail.com>
 <cbbc31d2041601b3e0d2c9b1e8b657ffa23ed97e.camel@kernel.org>
 <CAED-sic=eDaXz-A6_ejZOYcJYs=-tJtmxXLcONdQRRCod59L_g@mail.gmail.com>
 <25bc975e164a73f18653156d6591dda785c8d0c1.camel@kernel.org>
 <f131fc4a-112d-2bea-f254-ed268579cf7e@ajlc.waterloo.on.ca>
 <CAED-side70b+sXVFS8Tvh+4uPXWGuHC08hcA95p1yXmdpM_-wA@mail.gmail.com>
 <141990e9-11d4-7440-a8b5-870e2f14010a@ajlc.waterloo.on.ca> <CAED-sid=npTg95QEQmjrje60c=gik=KCOSFPU_Uj4=VjUVqr-Q@mail.gmail.com>
In-Reply-To: <CAED-sid=npTg95QEQmjrje60c=gik=KCOSFPU_Uj4=VjUVqr-Q@mail.gmail.com>
From:   Jesper Krogh <jesper.krogh@gmail.com>
Date:   Sat, 11 Apr 2020 20:07:43 +0200
Message-ID: <CAED-sifSamjxzB24CXJRhf2SDAJM6fELSFsGNY0jH+hruBvOAA@mail.gmail.com>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     Tony Lill <ajlill@ajlc.waterloo.on.ca>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ok, I set the mount options to 32MB and after a fresh VM reboot I got
a page-allocation error again.
This time it was the "first" kernel stacktrace after reboot - no "hung
tasks for more than 120s prior".

[Sat Apr 11 17:52:58 2020] kworker/7:1: page allocation failure:
order:0, mode:0xa20(GFP_ATOMIC),
nodemask=(null),cpuset=/,mems_allowed=0
[Sat Apr 11 17:52:58 2020] CPU: 7 PID: 2638 Comm: kworker/7:1 Not
tainted 5.4.30 #5
[Sat Apr 11 17:52:58 2020] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[Sat Apr 11 17:52:58 2020] Workqueue: ceph-msgr ceph_con_workfn [libceph]
[Sat Apr 11 17:52:58 2020] Call Trace:
[Sat Apr 11 17:52:58 2020]  <IRQ>
[Sat Apr 11 17:52:58 2020]  dump_stack+0x6d/0x95
[Sat Apr 11 17:52:58 2020]  warn_alloc+0x10c/0x170
[Sat Apr 11 17:52:58 2020]  __alloc_pages_slowpath+0xe6c/0xef0
[Sat Apr 11 17:52:58 2020]  ? ip_local_deliver_finish+0x48/0x50
[Sat Apr 11 17:52:58 2020]  ? ip_local_deliver+0x6f/0xe0
[Sat Apr 11 17:52:58 2020]  ? tcp_v4_early_demux+0x11c/0x150
[Sat Apr 11 17:52:58 2020]  __alloc_pages_nodemask+0x2f3/0x360
[Sat Apr 11 17:52:58 2020]  page_frag_alloc+0x129/0x150
[Sat Apr 11 17:52:58 2020]  __napi_alloc_skb+0x86/0xd0
[Sat Apr 11 17:52:58 2020]  page_to_skb+0x67/0x350 [virtio_net]
[Sat Apr 11 17:52:58 2020]  receive_buf+0xe47/0x16c0 [virtio_net]
[Sat Apr 11 17:52:58 2020]  virtnet_poll+0xf2/0x364 [virtio_net]
[Sat Apr 11 17:52:58 2020]  net_rx_action+0x265/0x3e0
[Sat Apr 11 17:52:58 2020]  __do_softirq+0xf9/0x2aa
[Sat Apr 11 17:52:58 2020]  irq_exit+0xae/0xb0
[Sat Apr 11 17:52:58 2020]  do_IRQ+0x59/0xe0
[Sat Apr 11 17:52:58 2020]  common_interrupt+0xf/0xf
[Sat Apr 11 17:52:58 2020]  </IRQ>
[Sat Apr 11 17:52:58 2020] RIP: 0010:__check_object_size+0x40/0x1b0
[Sat Apr 11 17:52:58 2020] Code: 4c 8d 34 3e 41 55 41 54 44 0f b6 ea
49 8d 46 ff 53 49 89 f4 48 89 fb 48 39 c7 0f 87 48 01 00 00 48 83 ff
10 0f 86 54 01 00 00 <e8> 0b fe ff ff 85 c0 74 27 78 0f 83 f8 02 7f 0a
5b 41 5c 41 5d 41
[Sat Apr 11 17:52:58 2020] RSP: 0018:ffffb96c00c479f8 EFLAGS: 00000286
ORIG_RAX: ffffffffffffffdc
[Sat Apr 11 17:52:58 2020] RAX: ffff92b9f36a7aca RBX: ffff92b9f36a7ab6
RCX: ffffb96c00c47c58
[Sat Apr 11 17:52:58 2020] RDX: 0000000000000001 RSI: 0000000000000015
RDI: ffff92b9f36a7ab6
[Sat Apr 11 17:52:58 2020] RBP: ffffb96c00c47a18 R08: 0000000000000000
R09: 0000000000000000
[Sat Apr 11 17:52:58 2020] R10: 0000000000000015 R11: ffff92bbea8957f8
R12: 0000000000000015
[Sat Apr 11 17:52:58 2020] R13: 0000000000000001 R14: ffff92b9f36a7acb
R15: 0000000000000005
[Sat Apr 11 17:52:58 2020]  simple_copy_to_iter+0x2a/0x50
[Sat Apr 11 17:52:58 2020]  __skb_datagram_iter+0x162/0x280
[Sat Apr 11 17:52:58 2020]  ? skb_kill_datagram+0x70/0x70
[Sat Apr 11 17:52:58 2020]  skb_copy_datagram_iter+0x40/0xa0
[Sat Apr 11 17:52:58 2020]  tcp_recvmsg+0x6f7/0xbc0
[Sat Apr 11 17:52:58 2020]  ? aa_sk_perm+0x43/0x190
[Sat Apr 11 17:52:58 2020]  inet_recvmsg+0x64/0xf0
[Sat Apr 11 17:52:58 2020]  sock_recvmsg+0x66/0x70
[Sat Apr 11 17:52:58 2020]  ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
[Sat Apr 11 17:52:58 2020]  read_partial.isra.26+0x50/0x80 [libceph]
[Sat Apr 11 17:52:58 2020]  read_partial_message+0x198/0x7c0 [libceph]
[Sat Apr 11 17:52:58 2020]  ceph_con_workfn+0xa6a/0x23d0 [libceph]
[Sat Apr 11 17:52:58 2020]  ? __dir_lease_try_check+0x90/0x90 [ceph]
[Sat Apr 11 17:52:58 2020]  process_one_work+0x167/0x400
[Sat Apr 11 17:52:58 2020]  worker_thread+0x4d/0x460
[Sat Apr 11 17:52:58 2020]  kthread+0x105/0x140
[Sat Apr 11 17:52:58 2020]  ? rescuer_thread+0x370/0x370
[Sat Apr 11 17:52:58 2020]  ? kthread_destroy_worker+0x50/0x50
[Sat Apr 11 17:52:58 2020]  ret_from_fork+0x35/0x40
[Sat Apr 11 17:52:58 2020] Mem-Info:
[Sat Apr 11 17:52:58 2020] active_anon:6795 inactive_anon:8914 isolated_anon:0
                            active_file:6364 inactive_file:3914973
isolated_file:0
                            unevictable:0 dirty:25 writeback:0 unstable:0
                            slab_reclaimable:52533 slab_unreclaimable:45778
                            mapped:5289 shmem:564 pagetables:1216 bounce:0
                            free:24896 free_pcp:5276 free_cma:0
[Sat Apr 11 17:52:58 2020] Node 0 active_anon:27180kB
inactive_anon:35656kB active_file:25456kB inactive_file:15659892kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:21156kB
dirty:100kB writeback:0kB shmem:2256kB shmem_thp: 0kB shmem_pmdmapped:
0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
[Sat Apr 11 17:52:58 2020] Node 0 DMA free:15908kB min:64kB low:80kB
high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB
inactive_file:0kB unevictable:0kB writepending:0kB present:15992kB
managed:15908kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB
free_pcp:0kB local_pcp:0kB free_cma:0kB
[Sat Apr 11 17:52:58 2020] lowmem_reserve[]: 0 3444 15930 15930 15930
[Sat Apr 11 17:52:58 2020] Node 0 DMA32 free:55068kB min:14596kB
low:18244kB high:21892kB active_anon:1940kB inactive_anon:2316kB
active_file:1748kB inactive_file:3386696kB unevictable:0kB
writepending:56kB present:3653608kB managed:3588072kB mlocked:0kB
kernel_stack:16kB pagetables:28kB bounce:0kB free_pcp:11168kB
local_pcp:1552kB free_cma:0kB
[Sat Apr 11 17:52:58 2020] lowmem_reserve[]: 0 0 12485 12485 12485
[Sat Apr 11 17:52:58 2020] Node 0 Normal free:28608kB min:77492kB
low:90720kB high:103948kB active_anon:25240kB inactive_anon:33340kB
active_file:23708kB inactive_file:12273660kB unevictable:0kB
writepending:44kB present:13107200kB managed:12793540kB mlocked:0kB
kernel_stack:7504kB pagetables:4836kB bounce:0kB free_pcp:9936kB
local_pcp:1360kB free_cma:0kB
[Sat Apr 11 17:52:58 2020] lowmem_reserve[]: 0 0 0 0 0
[Sat Apr 11 17:52:58 2020] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB
(U) 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB
(M) 3*4096kB (M) = 15908kB
[Sat Apr 11 17:52:58 2020] Node 0 DMA32: 17*4kB (MEH) 22*8kB (UMH)
18*16kB (MH) 2*32kB (ME) 147*64kB (UME) 70*128kB (UME) 16*256kB (UM)
15*512kB (UME) 4*1024kB (UME) 2*2048kB (M) 4*4096kB (M) = 55316kB
[Sat Apr 11 17:52:58 2020] Node 0 Normal: 187*4kB (UMEH) 62*8kB (UMEH)
280*16kB (UMEH) 318*32kB (UMEH) 98*64kB (UMEH) 45*128kB (UMEH) 4*256kB
(UM) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28956kB
[Sat Apr 11 17:52:58 2020] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=1048576kB
[Sat Apr 11 17:52:58 2020] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=2048kB
[Sat Apr 11 17:52:58 2020] 3922168 total pagecache pages
[Sat Apr 11 17:52:58 2020] 279 pages in swap cache
[Sat Apr 11 17:52:58 2020] 279 pages in swap cache
[Sat Apr 11 17:52:58 2020] Swap cache stats: add 4764, delete 4485, find 347/500
[Sat Apr 11 17:52:58 2020] Free swap  = 4019440kB
[Sat Apr 11 17:52:58 2020] Total swap = 4038652kB
[Sat Apr 11 17:52:58 2020] 4194200 pages RAM
[Sat Apr 11 17:52:58 2020] 0 pages HighMem/MovableOnly
[Sat Apr 11 17:52:58 2020] 94820 pages reserved
[Sat Apr 11 17:52:58 2020] 0 pages cma reserved
[Sat Apr 11 17:52:58 2020] 0 pages hwpoisoned
[Sat Apr 11 17:57:01 2020] warn_alloc: 50 callbacks suppressed

On Sat, Apr 11, 2020 at 3:20 PM Jesper Krogh <jesper.krogh@gmail.com> wrote:
>
> Ok, i'll change the mount options and report back in a few days on
> that topic. This is fairly reproducible, so I would expect to see the
> effect if it works.
>
> On Fri, Apr 10, 2020 at 6:32 PM Tony Lill <ajlill@ajlc.waterloo.on.ca> wrote:
> >
> >
> >
> > On 4/10/20 3:13 AM, Jesper Krogh wrote:
> > > Hi. What is the suggested change? - is it Ceph that has an rsize,wsize
> > > of 64MB ?
> > >
> >
> > Sorry, set rsize and wsize in the mount options for your cephfs to
> > something smaller.
> >
> > My problem with this is that I use autofs to mount my filesystem.
> > Starting with 4.14.82, after a few mount/unmount cycles, the mount would
> > fail with order 4 allocation error, and I'd have to reboot.
> >
> > I traced it to a change that doubled CEPH_MSG_MAX_DATA_LEN from 16M to
> > 32M. Later in the 5 series kernels, this was doubled again, and that
> > caused an order 5 allocation failure. This define is used to set the max
> > and default rsize and wsize.
> >
> > Reducing the rsize and wsize in the mount option fixed the problem for
> > me. This may do nothing for you, but, if it clears your allocation issue...
> >
> >
> > > On Fri, Apr 10, 2020 at 12:47 AM Tony Lill <ajlill@ajlc.waterloo.on.ca> wrote:
> > >>
> > >>
> > >>
> > >> On 4/9/20 12:30 PM, Jeff Layton wrote:
> > >>> On Thu, 2020-04-09 at 18:00 +0200, Jesper Krogh wrote:
> > >>>> Thanks Jeff - I'll try that.
> > >>>>
> > >>>> I would just add to the case that this is a problem we have had on a
> > >>>> physical machine - but too many "other" workloads at the same time -
> > >>>> so we isolated it off to a VM - assuming that it was the mixed
> > >>>> workload situation that did cause us issues. I cannot be sure that it
> > >>>> is "excactly" the same problem we're seeing but symptoms are
> > >>>> identical.
> > >>>>
> > >>>
> > >>> Do you see the "page allocation failure" warnings on bare metal hosts
> > >>> too? If so, then maybe we're dealing with a problem that isn't
> > >>> virtio_net specific. In any case, let's get some folks more familiar
> > >>> with that area involved first and take it from there.
> > >>>
> > >>> Feel free to cc me on the bug report too.
> > >>>
> > >>> Thanks,
> > >>>
> > >>
> > >> In 5.4.20, the default rsize and wsize is 64M. This has caused me page
> > >> allocation failures in a different context. Try setting it to something
> > >> sensible.
> > >> --
> > >> Tony Lill, OCT,                     ajlill@AJLC.Waterloo.ON.CA
> > >> President, A. J. Lill Consultants               (519) 650 0660
> > >> 539 Grand Valley Dr., Cambridge, Ont. N3H 2S2   (519) 241 2461
> > >> -------------- http://www.ajlc.waterloo.on.ca/ ---------------
> > >>
> > >>
> > >>
> >
> > --
> > Tony Lill, OCT,                     ajlill@AJLC.Waterloo.ON.CA
> > President, A. J. Lill Consultants               (519) 650 0660
> > 539 Grand Valley Dr., Cambridge, Ont. N3H 2S2   (519) 241 2461
> > -------------- http://www.ajlc.waterloo.on.ca/ ---------------
> >
> >
> >
