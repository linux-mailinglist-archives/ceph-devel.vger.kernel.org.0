Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEF134694C
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Mar 2021 20:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCWTvT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Mar 2021 15:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhCWTvD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 15:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D5E8619C0;
        Tue, 23 Mar 2021 19:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616529062;
        bh=jg6+9zYPesqwrcyfw0Z3aNynu9eXmjrtcj8VRo0Iii4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HoLPrvGZVgRvfyVnrFD2Sk49Acxppo/vLRXYbJTR+LtIqOz4DLjjsFHRx7STbYwJ1
         ehpjWB0AY1UI/ttAsoziVAVFHpXRSeCDiiGK9+fRjcT2eiEkZ749I+CHkFr0D/PoCw
         pfinEi7KGSq05EAcaeddz8qpwjU41lhC9G7ZHy5D+xKU4zcZeqyGQp+FIjDEe/Kf6a
         YShKH/c0rAetyJ/ZvhYCHMiItV41qO2fB8rPtTOu20djvVnfoKABnnptX+LJ1mdy32
         SA7W98ixq541o3e/gPii/nN1sOvmcaLf3P7cfTC6kG/8agaMCkb3zKECz4DCbkoy0+
         qRw/+zN6iZNdA==
Message-ID: <98f926ff5679182e7b875178af8ff9e2ac7f84f6.camel@kernel.org>
Subject: Re: [PATCH] ceph: send opened files/pinned caps/opened inodes
 metrics to MDS daemon
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 23 Mar 2021 15:51:01 -0400
In-Reply-To: <ee667d67-ddc6-4ddd-46b9-600c77a059ac@redhat.com>
References: <20201126034743.1151342-1-xiubli@redhat.com>
         <c9ec3257-6067-68a6-e10c-802141e9227b@redhat.com>
         <5c1461d4f7c03f226ed2458f491885cfe9b44841.camel@kernel.org>
         <ee667d67-ddc6-4ddd-46b9-600c77a059ac@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-03-22 at 20:32 +0800, Xiubo Li wrote:
> On 2021/3/22 19:55, Jeff Layton wrote:
> > Oh! I hadn't realized that this patch was still unmerged.
> 
> No worry, this patch was waiting the MDS side patch, which was just 
> merged last week :-)
> 
> I almost forgot this patch too before I saw the ceph tracker today.
> 
> > Merged into testing branch. I'd have pulled this into testing a while
> > ago if I had realized. Let me know if I miss any in the future (or am
> > missing any now).
> 
> Sure, np.
> 
> BRs
> 
> Xiubo
> 

After doing some testing with this patch, I hit the following KASAN pop
today. I've backed this patch out of the testing branch for now:

[  110.969263] ==================================================================
[  110.972933] BUG: KASAN: slab-out-of-bounds in metric_delayed_work+0x5e9/0x880 [ceph]
[  110.976096] Write of size 8 at addr ffff88811b76ab90 by task kworker/7:2/613
[  110.978972] 
[  110.979668] CPU: 7 PID: 613 Comm: kworker/7:2 Tainted: G            E     5.12.0-rc2+ #70
[  110.983015] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-1.fc33 04/01/2014
[  110.986467] Workqueue: events metric_delayed_work [ceph]
[  110.988803] Call Trace:
[  110.989869]  dump_stack+0xa5/0xdc
[  110.991297]  print_address_description.constprop.0+0x18/0x160
[  110.993659]  ? metric_delayed_work+0x5e9/0x880 [ceph]
[  110.995892]  ? metric_delayed_work+0x5e9/0x880 [ceph]
[  110.998108]  kasan_report.cold+0x7f/0x111
[  110.999818]  ? _raw_spin_lock_irq+0x61/0x90
[  111.001563]  ? metric_delayed_work+0x5e9/0x880 [ceph]
[  111.003814]  kasan_check_range+0xf9/0x1e0
[  111.005503]  metric_delayed_work+0x5e9/0x880 [ceph]
[  111.007688]  ? ceph_caps_for_mode+0x40/0x40 [ceph]
[  111.009855]  process_one_work+0x525/0x9b0
[  111.011597]  ? pwq_dec_nr_in_flight+0x110/0x110
[  111.013504]  ? lock_acquired+0x2fe/0x560
[  111.015230]  worker_thread+0x2ea/0x6e0
[  111.016840]  ? __kthread_parkme+0xc0/0xe0
[  111.018534]  ? process_one_work+0x9b0/0x9b0
[  111.020262]  kthread+0x1fb/0x220
[  111.021622]  ? __kthread_bind_mask+0x70/0x70
[  111.023423]  ret_from_fork+0x22/0x30
[  111.025004] 
[  111.025687] Allocated by task 613:
[  111.027105]  kasan_save_stack+0x1b/0x40
[  111.028740]  __kasan_kmalloc+0x7a/0x90
[  111.029583]  ceph_kvmalloc+0xc7/0x110 [libceph]
[  111.030611]  ceph_msg_new2+0x15d/0x270 [libceph]
[  111.031537]  metric_delayed_work+0x1c5/0x880 [ceph]
[  111.032414]  process_one_work+0x525/0x9b0
[  111.033093]  worker_thread+0x2ea/0x6e0
[  111.033763]  kthread+0x1fb/0x220
[  111.034329]  ret_from_fork+0x22/0x30
[  111.038203] 
[  111.041730] The buggy address belongs to the object at ffff88811b76ab00
[  111.041730]  which belongs to the cache kmalloc-192 of size 192
[  111.050535] The buggy address is located 144 bytes inside of
[  111.050535]  192-byte region [ffff88811b76ab00, ffff88811b76abc0)
[  111.059194] The buggy address belongs to the page:
[  111.063348] page:0000000052971d41 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11b76a
[  111.068337] head:0000000052971d41 order:1 compound_mapcount:0
[  111.073364] flags: 0x17ffffc0010200(slab|head)
[  111.078020] raw: 0017ffffc0010200 0000000000000000 0000000100000001 ffff888100042a00
[  111.083177] raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
[  111.088350] page dumped because: kasan: bad access detected
[  111.093064] 
[  111.096773] Memory state around the buggy address:
[  111.101168]  ffff88811b76aa80: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  111.106154]  ffff88811b76ab00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  111.111073] >ffff88811b76ab80: 00 00 06 fc fc fc fc fc fc fc fc fc fc fc fc fc
[  111.115973]                          ^
[  111.120219]  ffff88811b76ac00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  111.125263]  ffff88811b76ac80: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  111.130227] ==================================================================

-- 
Jeff Layton <jlayton@kernel.org>

