Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B51F19C6DE
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Apr 2020 18:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389786AbgDBQQ6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Apr 2020 12:16:58 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33258 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389573AbgDBQQ6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Apr 2020 12:16:58 -0400
Received: by mail-qk1-f194.google.com with SMTP id v7so4598347qkc.0
        for <ceph-devel@vger.kernel.org>; Thu, 02 Apr 2020 09:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poochiereds-net.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=yu0mqbKjrAAmMkGb16ZrxMRkFo6dHUGEtRy1dS7h2q0=;
        b=pTu0+8EKFiGfoR3F6mJTfB2qSYLEDpMtIIe8/7hsx0GSfajLWYg2/oEPWPqTdAwEUj
         MT7VY2nVvYe7cR1A5y6fS99ckX9vABoypAPRTSbIYi1SDGxqs3GIdKRacHxeUtxpS3xc
         6deUjO0v3vR0ddZqZwdVf7oM2mFtvcgiQ/mc+MKendS1H00wpbI/IG2xBZP0CuTMUE72
         xeorTdoAIBdMbmRExGTo4rfMG5XqLjoHFbCQ7gq+KYQGaD6CnIjpjm7fH809O3x4l5l/
         rKEwb37b5REQ73k/nbo+12RmUJStBPkqWYbzoywGnjZLgCW2K7SlDLvMOW1B4rAOafdV
         luDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yu0mqbKjrAAmMkGb16ZrxMRkFo6dHUGEtRy1dS7h2q0=;
        b=nFDL3p8d5xudvP5YHSeXFj3tu0Ol1G5TYt/OW2JjpCQHrOFSieFWL46eJbalRahMfx
         cVou5UfK/KGjxpTJigWT7/zS4fAjUC5tnClutV+DSi/6/0ImI5F72lyA0R2As3u+eQMc
         ysm7SRgrmAJ0KTuPxVCVPK3H6oXM2OaKkv7v10Ca271pXDDqkPwuF5xBsSkgPANt9/3u
         Axfgesk+x7l9mbo9+JTbDfw+JaIvlF2dDOwuklAGRvP62Z+/nUzplbqAAMgnTkUWQKE7
         QMYerVeVc91zw2xKSXBFhh8sCERuOq339OkIChBJsUVrukODlJAk5uw8bCoL8oRutLbv
         A2Ag==
X-Gm-Message-State: AGi0PuYZDfJ5NJBHQsjKElQ0aBR8bUmBb3UxVDwDAY5CGeJ8Wbwe5gK1
        qCdnUqbw8+gxtvxKapSzhfZX4tl6QDUfoA==
X-Google-Smtp-Source: APiQypIXKIVBLijvWo9oykDDsxapznT26Sr5cWj6eYWClb4ZcFCAFQv2x4r6dU1odiyYCBadcGb5TQ==
X-Received: by 2002:a37:490:: with SMTP id 138mr4382526qke.378.1585844217237;
        Thu, 02 Apr 2020 09:16:57 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 18sm3752975qkk.84.2020.04.02.09.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 09:16:55 -0700 (PDT)
Message-ID: <bec9b206b0806887098eb1d255ad42cfb769c92f.camel@poochiereds.net>
Subject: Re: Stacktrace from 5.4.26 kernel.
From:   Jeff Layton <jlayton@poochiereds.net>
To:     jesper@krogh.cc, ceph-devel@vger.kernel.org
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Date:   Thu, 02 Apr 2020 12:16:55 -0400
In-Reply-To: <1fe23046f3d1a68b82beaaebe04465cf.squirrel@shrek.krogh.cc>
References: <1fe23046f3d1a68b82beaaebe04465cf.squirrel@shrek.krogh.cc>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-04-02 at 17:35 +0200, jesper@krogh.cc wrote:
> Kernel. 5.4.26 and Ceph Luminous
> 
> Seem to be working still but I got this after putting load on it.
> 
> [  785.581198] kworker/3:2: page allocation failure: order:0,
> mode:0xa20(GFP_ATOMIC), nodemask=(null),cpuset=/,mems_allowed=0

(cc'ing virtualization mailing list)

Basically, looks like the kernel needed to allocate a page (4k) of
memory in order to handle a receive, and wasn't able to do so. This is a
GFP_ATOMIC allocation down inside the networking code, so it couldn't do
anything like reclaim memory to satisfy the allocation.

Looks like the box was just critically out of memory, but maybe the
problem is something else.

> [  785.581211] CPU: 3 PID: 332 Comm: kworker/3:2 Not tainted 5.4.26 #4
> [  785.581212] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [  785.581251] Workqueue: ceph-msgr ceph_con_workfn [libceph]
> [  785.581252] Call Trace:
> [  785.581255]  <IRQ>
> [  785.581271]  dump_stack+0x6d/0x95
> [  785.581275]  warn_alloc+0xfe/0x160
> [  785.581277]  __alloc_pages_slowpath+0xe07/0xe40
> [  785.581282]  ? dev_gro_receive+0x626/0x690
> [  785.581284]  __alloc_pages_nodemask+0x2cd/0x320
> [  785.581287]  alloc_pages_current+0x6a/0xe0
> [  785.581298]  skb_page_frag_refill+0xd4/0x100
> [  785.581302]  try_fill_recv+0x3ed/0x740 [virtio_net]
> [  785.581304]  virtnet_poll+0x31f/0x349 [virtio_net]
> [  785.581306]  net_rx_action+0x140/0x3c0
> [  785.581313]  __do_softirq+0xe4/0x2da
> [  785.581318]  irq_exit+0xae/0xb0
> [  785.581320]  do_IRQ+0x59/0xe0
> [  785.581322]  common_interrupt+0xf/0xf
> [  785.581322]  </IRQ>
> [  785.581332] RIP: 0010:tcp_rcv_space_adjust+0x56/0x1c0
> [  785.581333] Code: 06 00 00 bf 00 00 00 00 89 d1 48 89 f0 c1 e9 03 48 2b
> 83 50 08 00 00 48 0f 48 c7 39 c1 77 04 85 d2 75 4a 5b 41 5c 41 5d 41 5e
> <41> 5f 5d c3 65 8b 05 ff 40 09 5b 89 c0 48 0f a3 05 05 2f ec 00 73
> [  785.581334] RSP: 0018:ffffa47c40267bf0 EFLAGS: 00000202 ORIG_RAX:
> ffffffffffffffdd
> [  785.581335] RAX: 0000000000000002 RBX: 0000000000005437 RCX:
> 00000000000004fd
> [  785.581336] RDX: 00000000000027eb RSI: 000000002ed30b4b RDI:
> 0000000000000000
> [  785.581336] RBP: ffffa47c40267bf8 R08: 0000011c5ab9d567 R09:
> 0000000000000001
> [  785.581337] R10: ffffa47c40267d38 R11: 0000000000000000 R12:
> ffff94854d06d400
> [  785.581338] R13: ffff948711b64600 R14: ffff948711b64b74 R15:
> 0000000000000000
> [  785.581340]  tcp_recvmsg+0x297/0xb70
> [  785.581344]  ? _cond_resched+0x19/0x40
> [  785.581347]  ? aa_sk_perm+0x43/0x190
> [  785.581351]  inet_recvmsg+0x5e/0xe0
> [  785.581353]  sock_recvmsg+0x66/0x70
> [  785.581357]  ceph_tcp_recvpage+0x76/0xa0 [libceph]
> [  785.581363]  ceph_con_workfn+0x1a33/0x2be0 [libceph]
> [  785.581365]  process_one_work+0x20f/0x400
> [  785.581366]  worker_thread+0x34/0x410
> [  785.581369]  kthread+0x121/0x140
> [  785.581370]  ? process_one_work+0x400/0x400
> [  785.581371]  ? kthread_park+0x90/0x90
> [  785.581372]  ret_from_fork+0x35/0x40
> [  785.581374] Mem-Info:
> [  785.581379] active_anon:5599 inactive_anon:7153 isolated_anon:0
> [  785.581382] Node 0 active_anon:22396kB inactive_anon:28612kB
> active_file:31252kB inactive_file:7673984kB unevictable:0kB
> isolated(anon):0kB isolated(file):64kB mapped:28112kB dirty:0kB
> writeback:0kB shmem:2384kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp:
> 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
> [  785.581383] Node 0 DMA free:15908kB min:132kB low:164kB high:196kB
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
> unevictable:0kB writepending:0kB present:15992kB managed:15908kB
> mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB
> local_pcp:0kB free_cma:0kB
> [  785.581386] lowmem_reserve[]: 0 3444 7878 7878 7878
> [  785.581387] Node 0 DMA32 free:31476kB min:37680kB low:45052kB
> high:52424kB active_anon:792kB inactive_anon:1216kB active_file:2316kB
> inactive_file:3427096kB unevictable:0kB writepending:0kB present:3653608kB
> managed:3588072kB mlocked:0kB kernel_stack:80kB pagetables:36kB bounce:0kB
> free_pcp:808kB local_pcp:696kB free_cma:0kB
> [  785.581390] lowmem_reserve[]: 0 0 4433 4433 4433
> [  785.581391] Node 0 Normal free:20672kB min:56392kB low:65880kB
> high:75368kB active_anon:21604kB inactive_anon:27396kB active_file:28936kB
> inactive_file:4246864kB unevictable:0kB writepending:0kB present:4718592kB
> managed:4548188kB mlocked:0kB kernel_stack:3280kB pagetables:4208kB
> bounce:0kB free_pcp:1168kB local_pcp:1168kB free_cma:0kB
> [  785.581393] lowmem_reserve[]: 0 0 0 0 0
> [  785.581395] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 2*64kB (U)
> 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) =
> 15908kB
> [  785.581399] Node 0 DMA32: 35*4kB (UMEH) 109*8kB (UMEH) 372*16kB (UMEH)
> 144*32kB (MEH) 28*64kB (MEH) 37*128kB (ME) 55*256kB (UME) 0*512kB 0*1024kB
> 0*2048kB 0*4096kB = 32180kB
> [  785.581404] Node 0 Normal: 347*4kB (UMEH) 250*8kB (UMEH) 655*16kB
> (UMEH) 80*32kB (UMEH) 29*64kB (ME) 7*128kB (MEH) 6*256kB (MEH) 0*512kB
> 0*1024kB 0*2048kB 0*4096kB = 20716kB
> [  785.581409] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0
> hugepages_size=1048576kB
> [  785.581409] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0
> hugepages_size=2048kB
> [  785.581410] 1926939 total pagecache pages
> [  785.581413] 38 pages in swap cache
> [  785.581413] Swap cache stats: add 994, delete 956, find 81/89
> [  785.581414] Free swap  = 4033776kB
> [  785.581414] Total swap = 4038652kB
> [  785.581415] 2097048 pages RAM
> [  785.581415] 0 pages HighMem/MovableOnly
> [  785.581416] 59006 pages reserved
> [  785.581416] 0 pages cma reserved
> [  785.581417] 0 pages hwpoisoned
> 
> 

-- 
Jeff Layton <jlayton@poochiereds.net>

