Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F2A4478DD
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 04:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbhKHDZH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 7 Nov 2021 22:25:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234035AbhKHDZG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 7 Nov 2021 22:25:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636341742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tiXhxCBsX3adJyHVMOhsT7eLE2E/mJKEGd17+lsakLI=;
        b=R8tvJQ6oqxwVGxwhcKmQSW9crvvU2DCkupuDN5EzdHgCq7kTJwfjubeTjEL09doKXTyc6V
        LmoYzuS5uSIl9P5AKBc+oa2ZViyRQfOAwLGfn1MzzZbZtuce+HdclzXD2cwAjYvqb2Cnc0
        UuKTE4ixdxfQWmWSsM/OU4NCtl4E5rI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-cERm95ARPN-P4ctuKh7xtg-1; Sun, 07 Nov 2021 22:22:21 -0500
X-MC-Unique: cERm95ARPN-P4ctuKh7xtg-1
Received: by mail-pj1-f72.google.com with SMTP id n2-20020a17090a2fc200b001a1bafb59bfso4002593pjm.1
        for <ceph-devel@vger.kernel.org>; Sun, 07 Nov 2021 19:22:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tiXhxCBsX3adJyHVMOhsT7eLE2E/mJKEGd17+lsakLI=;
        b=Ivzn6+ehazWIlCUDVMAAe50hmFpYzgvwVz04fWWExImlWwhmhlZUJetiLmGc9LZbuL
         x4I5XbzaZM9lKUvHNC1hW3bQPc8yvxCoxe0sfJjMToOmWCCCJ6JfnsKoBlZ3eGw1EH12
         wD9jgd64L1AJjSGpF9ZzPLCp6iaHdA5vpNOvFrNp+zMkoHQJeOnrfAgE0/NU02bGtVhZ
         /x8g54DTfTvUOTnABDn0Ht/p5JwB8CHYyLT6EZoyFxtQ/1T6e3mLer40hI/Joqn04cTa
         Qvtfk6iUDODsglH5rXIVOrpmEN9dok5inAVtefAom5xY350OifRCI+NNFoZ7+rv+NKBo
         hv0A==
X-Gm-Message-State: AOAM532w5iczpSenP5XA2022/5l0bXo9Fq1roy2QoOLMCaaIm5behILf
        ndFNIpBB1LuYvC/0hkyqfzIeGo0Gb/S0dBFBqKOoqvOb9DhfLgvisJVPgQw1f+U8Ew9to4zv3s2
        0PY/1EBynxzLl5LjQUbAm/TPEORC93+Gie4bd8s4npFNIlHD+YHPS9GYwRXTbmWr1+tgERVc=
X-Received: by 2002:a05:6a00:84c:b0:494:6d40:ed76 with SMTP id q12-20020a056a00084c00b004946d40ed76mr28380978pfk.65.1636341738808;
        Sun, 07 Nov 2021 19:22:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKOZ/a3oI/mpVvLkoNy8Sks4iwFamSc3TMM0JUfyAk2XIM0Qbj98S46jmoojNa62vKxQwBIg==
X-Received: by 2002:a05:6a00:84c:b0:494:6d40:ed76 with SMTP id q12-20020a056a00084c00b004946d40ed76mr28380926pfk.65.1636341738255;
        Sun, 07 Nov 2021 19:22:18 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b21sm6337178pff.75.2021.11.07.19.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 19:22:17 -0800 (PST)
Subject: Re: [PATCH v7 0/9] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211105142215.345566-1-xiubli@redhat.com>
 <946e4c63292ae901e9a0925cc678609ba9e2ba9c.camel@kernel.org>
 <3ea75e3a6ab79ea090d6ea301633716846992db2.camel@kernel.org>
 <e0fcee87-68bd-8c33-b920-867fd0ef8fa9@redhat.com>
 <98d31e0fac7d2bfb8b81b252c1b75aea40e759dc.camel@kernel.org>
 <d31b2241f72115896bc38a7ed84beecdff409afa.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1dd5e6bf-1f53-8edc-7e66-aebf1eb72330@redhat.com>
Date:   Mon, 8 Nov 2021 11:22:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d31b2241f72115896bc38a7ed84beecdff409afa.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/6/21 6:51 PM, Jeff Layton wrote:
> On Sat, 2021-11-06 at 06:50 -0400, Jeff Layton wrote:
>> On Sat, 2021-11-06 at 09:35 +0800, Xiubo Li wrote:
>>> On 11/6/21 4:46 AM, Jeff Layton wrote:
>>>> On Fri, 2021-11-05 at 14:36 -0400, Jeff Layton wrote:
>>>>> On Fri, 2021-11-05 at 22:22 +0800, xiubli@redhat.com wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> This patch series is based on the "wip-fscrypt-fnames" branch in
>>>>>> repo https://github.com/ceph/ceph-client.git.
>>>>>>
>>>>>> And I have picked up 5 patches from the "ceph-fscrypt-size-experimental"
>>>>>> branch in repo
>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
>>>>>>
>>>>>> ====
>>>>>>
>>>>>> This approach is based on the discussion from V1 and V2, which will
>>>>>> pass the encrypted last block contents to MDS along with the truncate
>>>>>> request.
>>>>>>
>>>>>> This will send the encrypted last block contents to MDS along with
>>>>>> the truncate request when truncating to a smaller size and at the
>>>>>> same time new size does not align to BLOCK SIZE.
>>>>>>
>>>>>> The MDS side patch is raised in PR
>>>>>> https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
>>>>>> previous great work in PR https://github.com/ceph/ceph/pull/41284.
>>>>>>
>>>>>> The MDS will use the filer.write_trunc(), which could update and
>>>>>> truncate the file in one shot, instead of filer.truncate().
>>>>>>
>>>>>> This just assume kclient won't support the inline data feature, which
>>>>>> will be remove soon, more detail please see:
>>>>>> https://tracker.ceph.com/issues/52916
>>>>>>
>>>>>> Changed in V7:
>>>>>> - Fixed the sparse check warnings.
>>>>>> - Removed the include/linux/ceph/crypto.h header file.
>>>>>>
>>>>>> Changed in V6:
>>>>>> - Fixed the file hole bug, also have updated the MDS side PR.
>>>>>> - Add add object version support for sync read in #8.
>>>>>>
>>>>>>
>>>>>> Changed in V5:
>>>>>> - Rebase to "wip-fscrypt-fnames" branch in ceph-client.git repo.
>>>>>> - Pick up 5 patches from Jeff's "ceph-fscrypt-size-experimental" branch
>>>>>>     in linux.git repo.
>>>>>> - Add "i_truncate_pagecache_size" member support in ceph_inode_info
>>>>>>     struct, this will be used to truncate the pagecache only in kclient
>>>>>>     side, because the "i_truncate_size" will always be aligned to BLOCK
>>>>>>     SIZE. In fscrypt case we need to use the real size to truncate the
>>>>>>     pagecache.
>>>>>>
>>>>>>
>>>>>> Changed in V4:
>>>>>> - Retry the truncate request by 20 times before fail it with -EAGAIN.
>>>>>> - Remove the "fill_last_block" label and move the code to else branch.
>>>>>> - Remove the #3 patch, which has already been sent out separately, in
>>>>>>     V3 series.
>>>>>> - Improve some comments in the code.
>>>>>>
>>>>>>
>>>>>> Changed in V3:
>>>>>> - Fix possibly corrupting the file just before the MDS acquires the
>>>>>>     xlock for FILE lock, another client has updated it.
>>>>>> - Flush the pagecache buffer before reading the last block for the
>>>>>>     when filling the truncate request.
>>>>>> - Some other minore fixes.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Jeff Layton (5):
>>>>>>     libceph: add CEPH_OSD_OP_ASSERT_VER support
>>>>>>     ceph: size handling for encrypted inodes in cap updates
>>>>>>     ceph: fscrypt_file field handling in MClientRequest messages
>>>>>>     ceph: get file size from fscrypt_file when present in inode traces
>>>>>>     ceph: handle fscrypt fields in cap messages from MDS
>>>>>>
>>>>>> Xiubo Li (4):
>>>>>>     ceph: add __ceph_get_caps helper support
>>>>>>     ceph: add __ceph_sync_read helper support
>>>>>>     ceph: add object version support for sync read
>>>>>>     ceph: add truncate size handling support for fscrypt
>>>>>>
>>>>>>    fs/ceph/caps.c                  | 136 ++++++++++++++----
>>>>>>    fs/ceph/crypto.h                |  25 ++++
>>>>>>    fs/ceph/dir.c                   |   3 +
>>>>>>    fs/ceph/file.c                  |  76 ++++++++--
>>>>>>    fs/ceph/inode.c                 | 244 +++++++++++++++++++++++++++++---
>>>>>>    fs/ceph/mds_client.c            |   9 +-
>>>>>>    fs/ceph/mds_client.h            |   2 +
>>>>>>    fs/ceph/super.h                 |  25 ++++
>>>>>>    include/linux/ceph/osd_client.h |   6 +-
>>>>>>    include/linux/ceph/rados.h      |   4 +
>>>>>>    net/ceph/osd_client.c           |   5 +
>>>>>>    11 files changed, 475 insertions(+), 60 deletions(-)
>>>>>>
>>>>> Thanks Xiubo.
>>>>>
>>>>> I hit this today after some more testing (generic/014 again):
>>>>>
>>>>> [ 1674.146843] libceph: mon0 (2)192.168.1.81:3300 session established
>>>>> [ 1674.150902] libceph: client54432 fsid 4e286176-3d8b-11ec-bece-52540031ba78
>>>>> [ 1674.153791] ceph: test_dummy_encryption mode enabled
>>>>> [ 1719.254308] run fstests generic/014 at 2021-11-05 13:36:26
>>>>> [ 1727.157974]
>>>>> [ 1727.158334] =====================================
>>>>> [ 1727.159219] WARNING: bad unlock balance detected!
>>>>> [ 1727.160707] 5.15.0-rc6+ #53 Tainted: G           OE
>>>>> [ 1727.162248] -------------------------------------
>>>>> [ 1727.171918] truncfile/7800 is trying to release lock (&mdsc->snap_rwsem) at:
>>>>> [ 1727.180836] [<ffffffffc127438e>] __ceph_setattr+0x85e/0x1270 [ceph]
>>>>> [ 1727.192788] but there are no more locks to release!
>>>>> [ 1727.203450]
>>>>> [ 1727.203450] other info that might help us debug this:
>>>>> [ 1727.220766] 2 locks held by truncfile/7800:
>>>>> [ 1727.225548]  #0: ffff888116dd2460 (sb_writers#15){.+.+}-{0:0}, at: do_syscall_64+0x3b/0x90
>>>>> [ 1727.234851]  #1: ffff8882d8dac3d0 (&sb->s_type->i_mutex_key#20){++++}-{3:3}, at: do_truncate+0xbe/0x140
>>>>> [ 1727.240027]
>>>>> [ 1727.240027] stack backtrace:
>>>>> [ 1727.247863] CPU: 3 PID: 7800 Comm: truncfile Tainted: G           OE     5.15.0-rc6+ #53
>>>>> [ 1727.252508] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-6.fc35 04/01/2014
>>>>> [ 1727.257303] Call Trace:
>>>>> [ 1727.261503]  dump_stack_lvl+0x57/0x72
>>>>> [ 1727.265492]  lock_release.cold+0x49/0x4e
>>>>> [ 1727.269499]  ? __ceph_setattr+0x85e/0x1270 [ceph]
>>>>> [ 1727.273802]  ? lock_downgrade+0x390/0x390
>>>>> [ 1727.277913]  ? preempt_count_sub+0x14/0xc0
>>>>> [ 1727.281883]  ? _raw_spin_unlock+0x29/0x40
>>>>> [ 1727.285725]  ? __ceph_mark_dirty_caps+0x29f/0x450 [ceph]
>>>>> [ 1727.289959]  up_read+0x17/0x20
>>>>> [ 1727.293852]  __ceph_setattr+0x85e/0x1270 [ceph]
>>>>> [ 1727.297827]  ? ceph_inode_work+0x460/0x460 [ceph]
>>>>> [ 1727.301765]  ceph_setattr+0x12d/0x1c0 [ceph]
>>>>> [ 1727.305839]  notify_change+0x4e9/0x720
>>>>> [ 1727.309762]  ? do_truncate+0xcf/0x140
>>>>> [ 1727.313504]  do_truncate+0xcf/0x140
>>>>> [ 1727.317092]  ? file_open_root+0x1e0/0x1e0
>>>>> [ 1727.321022]  ? lock_release+0x410/0x410
>>>>> [ 1727.324769]  ? lock_is_held_type+0xfb/0x130
>>>>> [ 1727.328699]  do_sys_ftruncate+0x306/0x350
>>>>> [ 1727.332449]  do_syscall_64+0x3b/0x90
>>>>> [ 1727.336127]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>> [ 1727.340303] RIP: 0033:0x7f7f38be356b
>>>>> [ 1727.344445] Code: 77 05 c3 0f 1f 40 00 48 8b 15 09 99 0c 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 4d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 d9 98 0c 00 f7 d8
>>>>> [ 1727.354258] RSP: 002b:00007ffdee35cd18 EFLAGS: 00000202 ORIG_RAX: 000000000000004d
>>>>> [ 1727.358964] RAX: ffffffffffffffda RBX: 000000000c8a9d62 RCX: 00007f7f38be356b
>>>>> [ 1727.363836] RDX: 000000000c8a9d62 RSI: 000000000c8a9d62 RDI: 0000000000000003
>>>>> [ 1727.368467] RBP: 0000000000000003 R08: 000000000000005a R09: 00007f7f38cada60
>>>>> [ 1727.373285] R10: 00007f7f38af3700 R11: 0000000000000202 R12: 0000000061856b9d
>>>>> [ 1727.377870] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>>>> [ 1727.382578] ------------[ cut here ]------------
>>>>> [ 1727.391761] DEBUG_RWSEMS_WARN_ON(tmp < 0): count = 0xffffffffffffff00, magic = 0xffff88812f062220, owner = 0x1, curr 0xffff88810095b280, list empty
>>>>> [ 1727.419497] WARNING: CPU: 14 PID: 7800 at kernel/locking/rwsem.c:1297 __up_read+0x404/0x430
>>>>> [ 1727.432752] Modules linked in: ceph(OE) libceph(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) ip_set(E) stp(E) llc(E) rfkill(E) nf_tables(E) nfnetlink(E) cachefiles(E) fscache(E) netfs(E) sunrpc(E) iTCO_wdt(E) intel_pmc_bxt(E) iTCO_vendor_support(E) intel_rapl_msr(E) lpc_ich(E) joydev(E) i2c_i801(E) i2c_smbus(E) virtio_balloon(E) intel_rapl_common(E) fuse(E) zram(E) ip_tables(E) xfs(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) virtio_gpu(E) virtio_blk(E) ghash_clmulni_intel(E) virtio_dma_buf(E) virtio_console(E) serio_raw(E) virtio_net(E) drm_kms_helper(E) net_failover(E) cec(E) failover(E) drm(E) qemu_fw_cfg(E)
>>>>> [ 1727.506081] CPU: 1 PID: 7800 Comm: truncfile Tainted: G           OE     5.15.0-rc6+ #53
>>>>> [ 1727.512691] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-6.fc35 04/01/2014
>>>>> [ 1727.521863] RIP: 0010:__up_read+0x404/0x430
>>>>> [ 1727.528011] Code: 48 8b 55 00 4d 89 f0 4c 89 e1 53 48 c7 c6 e0 db 89 b1 48 c7 c7 00 d9 89 b1 65 4c 8b 3c 25 80 fe 01 00 4d 89 f9 e8 a2 4b 08 01 <0f> 0b 5a e9 b4 fd ff ff be 08 00 00 00 4c 89 e7 e8 57 4d 33 00 f0
>>>>> [ 1727.540864] RSP: 0018:ffff888118a07bb0 EFLAGS: 00010286
>>>>> [ 1727.556265] RAX: 0000000000000000 RBX: ffffffffb189d840 RCX: 0000000000000000
>>>>> [ 1727.571003] RDX: 0000000000000001 RSI: ffffffffb1aa6380 RDI: ffffed1023140f6c
>>>>> [ 1727.580837] RBP: ffff88812f062220 R08: ffffffffb0185284 R09: ffff8884209ad7c7
>>>>> [ 1727.593908] R10: ffffed1084135af8 R11: 0000000000000001 R12: ffff88812f062220
>>>>> [ 1727.605431] R13: 1ffff11023140f79 R14: 0000000000000001 R15: ffff88810095b280
>>>>> [ 1727.615457] FS:  00007f7f38add740(0000) GS:ffff888420640000(0000) knlGS:0000000000000000
>>>>> [ 1727.623346] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> [ 1727.631138] CR2: 00007fa7810e8000 CR3: 000000012124a000 CR4: 00000000003506e0
>>>>> [ 1727.639503] Call Trace:
>>>>> [ 1727.649160]  ? _raw_spin_unlock+0x29/0x40
>>>>> [ 1727.655583]  ? up_write+0x270/0x270
>>>>> [ 1727.661769]  __ceph_setattr+0x85e/0x1270 [ceph]
>>>>> [ 1727.670914]  ? ceph_inode_work+0x460/0x460 [ceph]
>>>>> [ 1727.677397]  ceph_setattr+0x12d/0x1c0 [ceph]
>>>>> [ 1727.685205]  notify_change+0x4e9/0x720
>>>>> [ 1727.694598]  ? do_truncate+0xcf/0x140
>>>>> [ 1727.705737]  do_truncate+0xcf/0x140
>>>>> [ 1727.712680]  ? file_open_root+0x1e0/0x1e0
>>>>> [ 1727.720447]  ? lock_release+0x410/0x410
>>>>> [ 1727.727851]  ? lock_is_held_type+0xfb/0x130
>>>>> [ 1727.734045]  do_sys_ftruncate+0x306/0x350
>>>>> [ 1727.740636]  do_syscall_64+0x3b/0x90
>>>>> [ 1727.748675]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>> [ 1727.755634] RIP: 0033:0x7f7f38be356b
>>>>> [ 1727.763575] Code: 77 05 c3 0f 1f 40 00 48 8b 15 09 99 0c 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 4d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 d9 98 0c 00 f7 d8
>>>>> [ 1727.777868] RSP: 002b:00007ffdee35cd18 EFLAGS: 00000202 ORIG_RAX: 000000000000004d
>>>>> [ 1727.792610] RAX: ffffffffffffffda RBX: 000000000c8a9d62 RCX: 00007f7f38be356b
>>>>> [ 1727.807383] RDX: 000000000c8a9d62 RSI: 000000000c8a9d62 RDI: 0000000000000003
>>>>> [ 1727.821520] RBP: 0000000000000003 R08: 000000000000005a R09: 00007f7f38cada60
>>>>> [ 1727.829368] R10: 00007f7f38af3700 R11: 0000000000000202 R12: 0000000061856b9d
>>>>> [ 1727.837356] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>>>> [ 1727.849767] irq event stamp: 549109
>>>>> [ 1727.863878] hardirqs last  enabled at (549109): [<ffffffffb12f8b54>] _raw_spin_unlock_irq+0x24/0x50
>>>>> [ 1727.879034] hardirqs last disabled at (549108): [<ffffffffb12f8d04>] _raw_spin_lock_irq+0x54/0x60
>>>>> [ 1727.897434] softirqs last  enabled at (548984): [<ffffffffb013d097>] __irq_exit_rcu+0x157/0x1b0
>>>>> [ 1727.913276] softirqs last disabled at (548975): [<ffffffffb013d097>] __irq_exit_rcu+0x157/0x1b0
>>>>> [ 1727.933182] ---[ end trace a89de5333b156523 ]---
>>>>>
>>>>>
>>>>>
>>>>> I think this patch should fix it:
>>>>>
>>>>> [PATCH] SQUASH: ensure we unset lock_snap_rwsem after unlocking it
>>>>>
>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>> ---
>>>>>    fs/ceph/inode.c | 4 +++-
>>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>>> index eebbd0296004..cb0ad0faee45 100644
>>>>> --- a/fs/ceph/inode.c
>>>>> +++ b/fs/ceph/inode.c
>>>>> @@ -2635,8 +2635,10 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>>>>    
>>>>>    	release &= issued;
>>>>>    	spin_unlock(&ci->i_ceph_lock);
>>>>> -	if (lock_snap_rwsem)
>>>>> +	if (lock_snap_rwsem) {
>>>>>    		up_read(&mdsc->snap_rwsem);
>>>>> +		lock_snap_rwsem = false;
>>>>> +	}
>>>>>    
>>>>>    	if (inode_dirty_flags)
>>>>>    		__mark_inode_dirty(inode, inode_dirty_flags);
>>>> Testing with that patch on top of your latest series looks pretty good
>>>> so far.
>>> Cool.
>>>
>>>>    I see some xfstests failures that need to be investigated
>>>> (generic/075, in particular). I'll take a harder look at that next week.
>>> I will also try this.
>>>> For now, I've gone ahead and updated wip-fscrypt-fnames to the latest
>>>> fnames branch, and also pushed a new wip-fscrypt-size branch that has
>>>> all of your patches, with the above SQUASH patch folded into #9.
>>>>
>>>> I'll continue the testing next week, but I think the -size branch is
>>>> probably a good place to work from for now.
>>> BTW, what's your test script for the xfstests ? I may miss some important.
>>>
>> I'm mainly running:
>>
>>      $ sudo ./check -g quick -E ./ceph.exclude
>>
>> ...and ceph.exclude has:
>>
>> ceph/001
>> generic/003
>> generic/531
>> generic/538
>>
>> ...most of the exclusions are because they take a long time to run.
> Oh and I should say...most of the failures I've seen with this patchset
> are intermittent. I suspect there is some race condition we haven't
> addressed yet.

The "generic/075" failed:

[root@lxbceph1 xfstests]# ./check generic/075
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0-rc6+

generic/075     [failed, exit status 1] - output mismatch (see 
/mnt/kcephfs/xfstests/results//generic/075.out.bad)
     --- tests/generic/075.out    2021-11-08 08:38:19.756822587 +0800
     +++ /mnt/kcephfs/xfstests/results//generic/075.out.bad 2021-11-08 
09:19:14.570013209 +0800
     @@ -4,15 +4,4 @@
      -----------------------------------------------
      fsx.0 : -d -N numops -S 0
      -----------------------------------------------
     -
     ------------------------------------------------
     -fsx.1 : -d -N numops -S 0 -x
     ------------------------------------------------
     ...
     (Run 'diff -u tests/generic/075.out 
/mnt/kcephfs/xfstests/results//generic/075.out.bad'  to see the entire diff)
Ran: generic/075
Failures: generic/075
Failed 1 of 1 tests


 From '075.0.fsxlog':


  84 122 trunc       from 0x40000 to 0x3ffd3
  85 123 mapread     0x2794d thru    0x2cb8c (0x5240 bytes)
  86 124 read        0x37b86 thru    0x3dc7b (0x60f6 bytes)
  87 READ BAD DATA: offset = 0x37b86, size = 0x60f6, fname = 075.0
  88 OFFSET  GOOD    BAD     RANGE
  89 0x38fc0 0x79b2  0x0000  0x00000
  90 operation# (mod 256) for the bad data unknown, check HOLE and 
EXTEND ops
  91 0x38fc1 0xb279  0x0000  0x00001
  92 operation# (mod 256) for the bad data unknown, check HOLE and 
EXTEND ops
  93 0x38fc2 0x791e  0x0000  0x00002
  94 operation# (mod 256) for the bad data unknown, check HOLE and 
EXTEND ops
  95 0x38fc3 0x1e79  0x0000  0x00003
  96 operation# (mod 256) for the bad data unknown, check HOLE and 
EXTEND ops
  97 0x38fc4 0x79e0  0x0000  0x00004
  98 operation# (mod 256) for the bad data unknown, check HOLE and 
EXTEND ops
  99 0x38fc5 0xe079  0x0000  0x00005
100 operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
101 0x38fc6 0x790b  0x0000  0x00006
102 operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
103 0x38fc7 0x0b79  0x0000  0x00007
104 operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
105 0x38fc8 0x7966  0x0000  0x00008
106 operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
107 0x38fc9 0x6679  0x0000  0x00009
108 operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
109 0x38fca 0x79ff  0x0000  0x0000a
110 operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
111 0x38fcb 0xff79  0x0000  0x0000b
112 operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
113 0x38fcc 0x7996  0x0000  0x0000c
...


I have dumped the '075.0.full', it's the same with the '075.out.bad'.

Checked the diff '075.0.good' and '075.0.bad', it shows that from the 
file offset 0x038fc0~i_size the contents are all zero in the 
'075.0.bad'. The '075.0.good is not.

 From the '/proc/kmsg' output:

18715 <7>[61484.334994] ceph:  fill_fscrypt_truncate size 262144 -> 
262099 got cap refs on Fr, issued pAsxLsXsxFsxcrwb
18716 <7>[61484.335010] ceph:  writepages_start 000000003e6c8932 (mode=ALL)
18717 <7>[61484.335021] ceph:   head snapc 000000003195bf7d has 8 dirty 
pages
18718 <7>[61484.335030] ceph:   oldest snapc is 000000003195bf7d seq 1 
(0 snaps)
18719 <7>[61484.335041] ceph:   not cyclic, 0 to 2251799813685247
18720 <7>[61484.335054] ceph:  pagevec_lookup_range_tag got 8
18721 <7>[61484.335063] ceph:  ? 000000007350de9f idx 56
18722 <7>[61484.335139] ceph:  000000003e6c8932 will write page 
000000007350de9f idx 56
18723 <7>[61484.335151] ceph:  ? 00000000db5774fb idx 57
18724 <7>[61484.335162] ceph:  000000003e6c8932 will write page 
00000000db5774fb idx 57
18725 <7>[61484.335173] ceph:  ? 000000008bc9ea57 idx 58
18726 <7>[61484.335183] ceph:  000000003e6c8932 will write page 
000000008bc9ea57 idx 58
18727 <7>[61484.335194] ceph:  ? 00000000be4c1d25 idx 59
18728 <7>[61484.335204] ceph:  000000003e6c8932 will write page 
00000000be4c1d25 idx 59
18729 <7>[61484.335215] ceph:  ? 0000000051d6fed1 idx 60
18730 <7>[61484.335225] ceph:  000000003e6c8932 will write page 
0000000051d6fed1 idx 60
18731 <7>[61484.335237] ceph:  ? 00000000f40c8a7a idx 61
18732 <7>[61484.335254] ceph:  000000003e6c8932 will write page 
00000000f40c8a7a idx 61
18733 <7>[61484.335274] ceph:  ? 00000000c7da9df6 idx 62
18734 <7>[61484.335291] ceph:  000000003e6c8932 will write page 
00000000c7da9df6 idx 62
18735 <7>[61484.335312] ceph:  ? 00000000646abb31 idx 63
18736 <7>[61484.335330] ceph:  000000003e6c8932 will write page 
00000000646abb31 idx 63
18737 <7>[61484.335344] ceph:  reached end pvec, trying for more
18738 <7>[61484.335352] ceph:  pagevec_lookup_range_tag got 0
18739 <7>[61484.336008] ceph:  writepages got pages at 229376~32768
18740 <7>[61484.336136] ceph:  pagevec_release on 0 pages (0000000000000000)
18741 <7>[61484.336157] ceph:  pagevec_lookup_range_tag got 0
18742 <7>[61484.336172] ceph:  writepages dend - startone, rc = 0
18743 <7>[61484.348123] ceph:  writepages_finish 000000003e6c8932 rc 0

...
18760 <7>[61485.386715] ceph:  sync_read on inode 000000003e6c8932 
258048~4096
18761 <7>[61485.386784] ceph:  client4220 send metrics to mds0
18762 <7>[61485.389512] ceph:  sync_read 258048~4096 got 4096 i_size 262144
18763 <7>[61485.389569] ceph:  sync_read result 4096 retry_op 2
18764 <7>[61485.389581] ceph:  put_cap_refs 000000003e6c8932 had Fr last


I see in fill_fscrypt_truncate() just before reading the last block it 
has already trigerred and successfully flushed the dirty pages to the 
OSD, but it seems those 8 pages' contents are zero.

Is that possibly those 8 pages are not dirtied yet when we are flushing 
it in fill_fscrypt_truncate() ?

Thanks

BRs






> Thanks,

