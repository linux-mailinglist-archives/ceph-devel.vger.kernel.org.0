Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AB84CB421
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Mar 2022 02:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiCCBBC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 20:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiCCBBB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 20:01:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DECB158E98
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 17:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646269214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2a7Lv8VkjqRsJ7DYLLhkIwvhQuFMGfBJauFMMPmA4eY=;
        b=L+NU7yCaHl5dgvj8z+dTvQj2S8/5SQzHBIVF3MHibE9UmWY6fzZyOt5i/cy3DcBNsa+qhr
        07Pm6J6kXYrtfGi70PnXa6iUJGwHvDj3wTVIHYaVgqxWWhsg2O1H3hwRhGMNkeSzDfSrte
        W6IwRdjoSg04v/5igL1qBjjzu8BFiqo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-BurbgbosPQCnu7plXfYjnw-1; Wed, 02 Mar 2022 20:00:13 -0500
X-MC-Unique: BurbgbosPQCnu7plXfYjnw-1
Received: by mail-pg1-f200.google.com with SMTP id v32-20020a634660000000b0037c3f654c50so1258950pgk.6
        for <ceph-devel@vger.kernel.org>; Wed, 02 Mar 2022 17:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2a7Lv8VkjqRsJ7DYLLhkIwvhQuFMGfBJauFMMPmA4eY=;
        b=boLfi/YRtj0diW3whp8ZE0aVi8atMThnJnVLgssBB1vuf1LHhBOKYR1ztk1Pqy8+CO
         /CHDWkX+D5LvHQT9cYqw6/dfrT9IIRm2/eK8oEUN/Qj+Y7qCpRC8r/9RXrfXXyyn07nf
         aGJ7TBSVzO+2NByaXlfcVNCYFLumR2L0WNpcUHDQOtRuT0iZe4XXjMQVOk1A04QNhw62
         C9z4VXws88GeGQ98i8XNXf4HmSxhD+4ApQlWBIWvOMCO897+FrRvS0mdkpbwNQFZhsjd
         JaJcZATxre4Iz3wtQiUV54siWOJi9CTjt4Rb1QP120+G4Vx543cFXYiT9rRI7aM2mtSg
         SRJg==
X-Gm-Message-State: AOAM530z9zbjcO/9QTf7k11pmvlfgKadl/HF2Cqkz5GMxDYiWCSFcWu8
        RVK5oynjnmcCadGokXLqW22mc8uAm+KiXppj0BMMv4ZGKHk8Lro6gXCQFcPHkAIbO2/wtch7Fs2
        96ZgGmjIQb2phnMP2IoMyRpf4l8McunXcaz2/b5X3fobkhxjHEd+ueHI+QdfkPx/aDo0Amvw=
X-Received: by 2002:a17:90b:1645:b0:1bf:11:66ae with SMTP id il5-20020a17090b164500b001bf001166aemr2550722pjb.198.1646269211210;
        Wed, 02 Mar 2022 17:00:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQ88ULvBfkD/CysK7V1uBa0cBozphSEOG7tK00abjFBX9VM1z1k+I8+gd0YN2hujl+J/+y+Q==
X-Received: by 2002:a17:90b:1645:b0:1bf:11:66ae with SMTP id il5-20020a17090b164500b001bf001166aemr2550641pjb.198.1646269210271;
        Wed, 02 Mar 2022 17:00:10 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q21-20020a63e215000000b00373efe2cbcbsm308400pgh.80.2022.03.02.17.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 17:00:09 -0800 (PST)
Subject: Re: [PATCH v2] ceph: fix memory leakage in ceph_readdir
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220301131726.439070-1-xiubli@redhat.com>
 <527234d849b0de18b326d6db0d59070b70d19b7e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0235c703-66bb-e70a-382a-e1a9ef28f0c4@redhat.com>
Date:   Thu, 3 Mar 2022 09:00:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <527234d849b0de18b326d6db0d59070b70d19b7e.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/3/22 2:04 AM, Jeff Layton wrote:
> On Tue, 2022-03-01 at 21:17 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/dir.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 0cf6afe283e9..bf69678d6434 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -478,8 +478,10 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   					2 : (fpos_off(rde->offset) + 1);
>>   			err = note_last_dentry(dfi, rde->name, rde->name_len,
>>   					       next_offset);
>> -			if (err)
>> +			if (err) {
>> +				ceph_mdsc_put_request(dfi->last_readdir);
>>   				return err;
>> +			}
>>   		} else if (req->r_reply_info.dir_end) {
>>   			dfi->next_offset = 2;
>>   			/* keep last name */
>> @@ -521,6 +523,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>>   			dout("filldir stopping us...\n");
>> +			ceph_mdsc_put_request(dfi->last_readdir);
>>   			return 0;
>>   		}
>>   		ctx->pos++;
> This patch is reliably causing a KASAN warning about a UAF with xfstest
> generic/006:
>
> [ 1170.050701] ==================================================================
> [ 1170.054738] BUG: KASAN: use-after-free in ceph_readdir+0x274/0x1cc0 [ceph]
> [ 1170.056908] Read of size 4 at addr ffff888116978db8 by task find/2367
> [ 1170.058814]
> [ 1170.059310] CPU: 1 PID: 2367 Comm: find Tainted: G           OE     5.17.0-rc6+ #163
> [ 1170.061601] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
> [ 1170.064099] Call Trace:
> [ 1170.064925]  <TASK>
> [ 1170.065608]  dump_stack_lvl+0x59/0x73
> [ 1170.066743]  print_address_description.constprop.0+0x1f/0x150
> [ 1170.068476]  ? ceph_readdir+0x274/0x1cc0 [ceph]
> [ 1170.069983]  kasan_report.cold+0x7f/0x11b
> [ 1170.071227]  ? ceph_readdir+0x274/0x1cc0 [ceph]
> [ 1170.072752]  ceph_readdir+0x274/0x1cc0 [ceph]
> [ 1170.074212]  ? lock_release+0x410/0x410
> [ 1170.075393]  ? do_raw_spin_unlock+0x86/0xf0
> [ 1170.076706]  ? mutex_lock_io_nested+0xbc0/0xbc0
> [ 1170.087733]  ? ceph_d_revalidate+0x7b0/0x7b0 [ceph]
> [ 1170.098993]  ? down_write_killable+0xc7/0x130
> [ 1170.109955]  ? __down_interruptible+0x1d0/0x1d0
> [ 1170.121021]  iterate_dir+0x107/0x2e0
> [ 1170.127058]  __x64_sys_getdents64+0xe2/0x1b0
> [ 1170.131463]  ? filldir+0x270/0x270
> [ 1170.136034]  ? __ia32_sys_getdents+0x1a0/0x1a0
> [ 1170.140761]  ? lockdep_hardirqs_on_prepare+0x129/0x220
> [ 1170.145606]  ? syscall_enter_from_user_mode+0x21/0x70
> [ 1170.150368]  do_syscall_64+0x3b/0x90
> [ 1170.154915]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1170.159623] RIP: 0033:0x7f7a4bd0ffd7
> [ 1170.164023] Code: 19 fb ff 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 21 0e 12 00 f7 d8 64 89 02 48
> [ 1170.174817] RSP: 002b:00007ffd260e00f8 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
> [ 1170.180113] RAX: ffffffffffffffda RBX: 000055b5d33be380 RCX: 00007f7a4bd0ffd7
> [ 1170.185346] RDX: 0000000000010000 RSI: 000055b5d33be380 RDI: 0000000000000004
> [ 1170.190507] RBP: 000055b5d33be354 R08: 0000000000000003 R09: 0000000000000001
> [ 1170.195623] R10: 0000000000000fff R11: 0000000000000293 R12: fffffffffffffe98
> [ 1170.200699] R13: 0000000000000000 R14: 000055b5d33be350 R15: 00000000000010fe
> [ 1170.205731]  </TASK>
> [ 1170.210052]
> [ 1170.214314] Allocated by task 2367:
> [ 1170.218734]  kasan_save_stack+0x1e/0x40
> [ 1170.223152]  __kasan_slab_alloc+0x90/0xc0
> [ 1170.227598]  kmem_cache_alloc+0x1bc/0x470
> [ 1170.232004]  ceph_mdsc_create_request+0x2f/0x270 [ceph]
> [ 1170.236476]  ceph_readdir+0xd8d/0x1cc0 [ceph]
> [ 1170.240894]  iterate_dir+0x107/0x2e0
> [ 1170.245245]  __x64_sys_getdents64+0xe2/0x1b0
> [ 1170.249498]  do_syscall_64+0x3b/0x90
> [ 1170.253664]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1170.257883]
> [ 1170.261666] Freed by task 2367:
> [ 1170.265636]  kasan_save_stack+0x1e/0x40
> [ 1170.269662]  kasan_set_track+0x21/0x30
> [ 1170.273521]  kasan_set_free_info+0x20/0x30
> [ 1170.277346]  ____kasan_slab_free+0x12f/0x160
> [ 1170.281127]  slab_free_freelist_hook+0xd6/0x1b0
> [ 1170.285122]  kmem_cache_free+0x12e/0x590
> [ 1170.288917]  ceph_readdir+0x15e2/0x1cc0 [ceph]
> [ 1170.292839]  iterate_dir+0x107/0x2e0
> [ 1170.296432]  __x64_sys_getdents64+0xe2/0x1b0
> [ 1170.300321]  do_syscall_64+0x3b/0x90
> [ 1170.304117]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1170.308067]
> [ 1170.311570] The buggy address belongs to the object at ffff888116978a90
> [ 1170.311570]  which belongs to the cache ceph_mds_request of size 1224
> [ 1170.319951] The buggy address is located 808 bytes inside of
> [ 1170.319951]  1224-byte region [ffff888116978a90, ffff888116978f58)
> [ 1170.327861] The buggy address belongs to the page:
> [ 1170.331994] page:000000002aea1f14 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x116978
> [ 1170.336790] head:000000002aea1f14 order:3 compound_mapcount:0 compound_pincount:0
> [ 1170.341392] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> [ 1170.346032] raw: 0017ffffc0010200 0000000000000000 dead000000000122 ffff88810c356000
> [ 1170.350771] raw: 0000000000000000 0000000080180018 00000001ffffffff 0000000000000000
> [ 1170.355530] page dumped because: kasan: bad access detected
> [ 1170.359971]
> [ 1170.363912] Memory state around the buggy address:
> [ 1170.368132]  ffff888116978c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1170.372861]  ffff888116978d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1170.377299] >ffff888116978d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1170.381594]                                         ^
> [ 1170.385746]  ffff888116978e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1170.390163]  ffff888116978e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1170.394629] ==================================================================
> [ 1170.399041] Disabling lock debugging due to kernel taint
> [ 1170.403354] ------------[ cut here ]------------
> [ 1170.413479] refcount_t: underflow; use-after-free.
> [ 1170.424453] WARNING: CPU: 7 PID: 2367 at lib/refcount.c:28 refcount_warn_saturate+0xc5/0x110
> [ 1170.436622] Modules linked in: ceph(OE) libceph(OE) rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) ip_set(E) stp(E) llc(E) rfkill(E) nf_tables(E) nfnetlink(E) cachefiles(E) fscache(E) netfs(E) sunrpc(E) iTCO_wdt(E) intel_pmc_bxt(E) iTCO_vendor_support(E) lpc_ich(E) intel_rapl_msr(E) virtio_balloon(E) joydev(E) i2c_i801(E) i2c_smbus(E) intel_rapl_common(E) fuse(E) zram(E) ip_tables(E) xfs(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) ghash_clmulni_intel(E) serio_raw(E) virtio_gpu(E) virtio_dma_buf(E) drm_shmem_helper(E) virtio_blk(E) drm_kms_helper(E) virtio_console(E) virtio_net(E) cec(E) net_failover(E) failover(E) drm(E) qemu_fw_cfg(E) [last unloaded: libceph]
> [ 1170.506605] CPU: 2 PID: 2367 Comm: find Tainted: G    B      OE     5.17.0-rc6+ #163
> [ 1170.521537] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
> [ 1170.535837] RIP: 0010:refcount_warn_saturate+0xc5/0x110
> [ 1170.549516] Code: 88 fd 66 02 01 e8 28 a4 93 00 0f 0b eb 99 80 3d 75 fd 66 02 00 75 90 48 c7 c7 20 9b aa 88 c6 05 65 fd 66 02 01 e8 08 a4 93 00 <0f> 0b e9 76 ff ff ff 80 3d 50 fd 66 02 00 0f 85 69 ff ff ff 48 c7
> [ 1170.577563] RSP: 0018:ffff8881507b7cd0 EFLAGS: 00010282
> [ 1170.591094] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> [ 1170.607700] RDX: 0000000000000001 RSI: ffffffff88aadf60 RDI: ffffed102a0f6f90
> [ 1170.624135] RBP: ffff888116978ab8 R08: ffffffff87187ec4 R09: ffff8884187bdb47
> [ 1170.640644] R10: ffffed10830f7b68 R11: 0000000000000001 R12: ffff8881507b7eb0
> [ 1170.655872] R13: 0ff7c9ea00000003 R14: 0000030000009ee1 R15: ffff8881507b7eb8
> [ 1170.673101] FS:  00007f7a4bb9d800(0000) GS:ffff888418780000(0000) knlGS:0000000000000000
> [ 1170.689317] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1170.705066] CR2: 00007f2a487a70d8 CR3: 000000011f6be000 CR4: 00000000003506e0
> [ 1170.721472] Call Trace:
> [ 1170.735726]  <TASK>
> [ 1170.750251]  ? __ia32_sys_getdents+0x1a0/0x1a0
> [ 1170.766809]  ceph_readdir+0x1428/0x1cc0 [ceph]
> [ 1170.782120]  ? mutex_lock_io_nested+0xbc0/0xbc0
> [ 1170.797099]  ? ceph_d_revalidate+0x7b0/0x7b0 [ceph]
> [ 1170.812069]  ? down_write_killable+0xc7/0x130
> [ 1170.825664]  ? __down_interruptible+0x1d0/0x1d0
> [ 1170.832980]  iterate_dir+0x107/0x2e0
> [ 1170.845448]  __x64_sys_getdents64+0xe2/0x1b0
> [ 1170.859218]  ? filldir+0x270/0x270
> [ 1170.871956]  ? __ia32_sys_getdents+0x1a0/0x1a0
> [ 1170.885328]  ? lockdep_hardirqs_on_prepare+0x129/0x220
> [ 1170.898675]  ? syscall_enter_from_user_mode+0x21/0x70
> [ 1170.911432]  do_syscall_64+0x3b/0x90
> [ 1170.924215]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1170.937487] RIP: 0033:0x7f7a4bd0ffd7
> [ 1170.951209] Code: 19 fb ff 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 21 0e 12 00 f7 d8 64 89 02 48
> [ 1170.978466] RSP: 002b:00007ffd260e00f8 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
> [ 1170.985171] RAX: ffffffffffffffda RBX: 000055b5d33be380 RCX: 00007f7a4bd0ffd7
> [ 1170.991427] RDX: 0000000000010000 RSI: 000055b5d33be380 RDI: 0000000000000004
> [ 1171.006641] RBP: 000055b5d33be354 R08: 0000000000000003 R09: 0000000000000001
> [ 1171.022724] R10: 0000000000000fff R11: 0000000000000293 R12: fffffffffffffe98
> [ 1171.037966] R13: 0000000000000000 R14: 000055b5d33be350 R15: 00000000000010fe
> [ 1171.047204]  </TASK>
> [ 1171.053887] irq event stamp: 10358
> [ 1171.060503] hardirqs last  enabled at (10357): [<ffffffff88317cb1>] syscall_enter_from_user_mode+0x21/0x70
> [ 1171.067647] hardirqs last disabled at (10358): [<ffffffff88331f80>] _raw_spin_lock_irqsave+0x60/0x70
> [ 1171.076273] softirqs last  enabled at (8366): [<ffffffff875c292c>] touch_atime+0x36c/0x380
> [ 1171.084243] softirqs last disabled at (8362): [<ffffffff87472e50>] wb_wakeup_delayed+0x40/0xa0
> [ 1171.090668] ---[ end trace 0000000000000000 ]---
>
> I think the original bugs are real, but I suspect that this fix is
> running afoul of some of the last_readdir tracking in this code.

We should reset the 'dfi->last_readdir' to NULL after release the 
request. The 'dfi' is a private data in the 'struct file', so for the 
next readdir it will try to release it again.


diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0cf6afe283e9..c8720944036f 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -478,8 +478,11 @@ static int ceph_readdir(struct file *file, struct 
dir_context *ctx)
                                         2 : (fpos_off(rde->offset) + 1);
                         err = note_last_dentry(dfi, rde->name, 
rde->name_len,
                                                next_offset);
-                       if (err)
+                       if (err) {
+ ceph_mdsc_put_request(dfi->last_readdir);
+                               dfi->last_readdir = NULL;
                                 return err;
+                       }
                 } else if (req->r_reply_info.dir_end) {
                         dfi->next_offset = 2;
                         /* keep last name */
@@ -521,6 +524,8 @@ static int ceph_readdir(struct file *file, struct 
dir_context *ctx)
                               ceph_present_ino(inode->i_sb, 
le64_to_cpu(rde->inode.in->ino)),
le32_to_cpu(rde->inode.in->mode) >> 12)) {
                         dout("filldir stopping us...\n");
+ ceph_mdsc_put_request(dfi->last_readdir);
+                       dfi->last_readdir = NULL;
                         return 0;
                 }
                 ctx->pos++;




> Ilya, can you drop patch this from master for now?
>
> Thanks,

