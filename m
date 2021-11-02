Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA44A442DA1
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Nov 2021 13:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhKBMRE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Nov 2021 08:17:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhKBMRD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Nov 2021 08:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635855268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oWfroXQdXEB9NeeQmFKO+V8GiXIWR8HmUXdgvh2Ifog=;
        b=BxCgEbMMJ/WkMWnUG8Jwh5xneoseyq98IXjwJNLUUA2ge5gRaC+2GcVjTqAwwZcMJo5EtB
        mN6ZF4xa/5vl98nMc5dHfkooK0ujHsErNmzZQx2BN5mHExFZjLfYROf6Ty3Q53/w9C9u51
        JTuEuFT0gt/RBI8vcYGkijJSLsHsJcM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-7D2QMUyFOl28x3Ph7po6Eg-1; Tue, 02 Nov 2021 08:14:27 -0400
X-MC-Unique: 7D2QMUyFOl28x3Ph7po6Eg-1
Received: by mail-pg1-f200.google.com with SMTP id z7-20020a63c047000000b0026b13e40309so11601623pgi.19
        for <ceph-devel@vger.kernel.org>; Tue, 02 Nov 2021 05:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oWfroXQdXEB9NeeQmFKO+V8GiXIWR8HmUXdgvh2Ifog=;
        b=fYbo8VoCLJT7BWxf0u80Pi8Nywi6HPy54xlLrVgowlg6+dZwHSOa+8BzHSXpDiuwAL
         z46kdqqN7mnQgjR8l9OYnuNSSGCgiVk793ibwvC4Dm5Rty8fKWLP54hbkfwqwHkLoMXC
         RoZKRuxRnMCNCJOllUYmHNRWFLPyURVIKk33jdEUT2dIqy9W9JLLeNMxmtwgSiUT0mcM
         Pou1ruI8+Ny3qKqI20/GhcCnMAr2P3+ivczFD7EfEaXzzJ14R2aRzzwCMHevc5odwGrx
         4jcmHDmrjsR9OzqXxRt6YfE+R3Al8T4jluu4mrEX09mgOWpzAyQvdtt3YiGOsu0E/kPz
         W5Jg==
X-Gm-Message-State: AOAM5300mVETELOfMWzFg5rFTqtbdlhUxLKaERQWh5JA4okSDsRep2TN
        CiDSf2+fezoG3d+08JdJSQncx+jfw/KaTZChO2faCiVBoqiyfu0P6v2P3gJFdBXCQ128fT5tq8c
        8/HWjIhsdRVgBchl8k+SJ8wv/5AI84HDOKxkDe2NF/NTkpKx7jmUKn2uiaGEE+CR7JSXU5OE=
X-Received: by 2002:a63:81c8:: with SMTP id t191mr13575843pgd.192.1635855265120;
        Tue, 02 Nov 2021 05:14:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziY1Bzo7ZBav1URoAWYTCZ7j0XEgZ0aKks8bYmUxFyV4Y1BPf9DgLTQtu5kBbF01iAuUaXJg==
X-Received: by 2002:a63:81c8:: with SMTP id t191mr13575796pgd.192.1635855264694;
        Tue, 02 Nov 2021 05:14:24 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c25sm18147094pfn.159.2021.11.02.05.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 05:14:24 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211101020447.75872-1-xiubli@redhat.com>
 <5c5d98f06c0a70271b324d9f144f44f8dddd91e5.camel@kernel.org>
 <220cf4cd-8634-67ed-fe2e-c34f4e87934e@redhat.com>
 <207d0b9a23eadd3047253c469397230b2a0e0fb2.camel@kernel.org>
 <f603929b851876554beb7d85d33a94bb44d36528.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cd7f42a0-c9ac-5fad-6baa-d41322e20813@redhat.com>
Date:   Tue, 2 Nov 2021 20:13:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f603929b851876554beb7d85d33a94bb44d36528.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/2/21 7:29 PM, Jeff Layton wrote:
> On Tue, 2021-11-02 at 06:52 -0400, Jeff Layton wrote:
>> On Tue, 2021-11-02 at 17:44 +0800, Xiubo Li wrote:
>>> On 11/1/21 6:27 PM, Jeff Layton wrote:
>>>> On Mon, 2021-11-01 at 10:04 +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> This patch series is based on the "fscrypt_size_handling" branch in
>>>>> https://github.com/lxbsz/linux.git, which is based Jeff's
>>>>> "ceph-fscrypt-content-experimental" branch in
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git
>>>>> and added two upstream commits, which should be merged already.
>>>>>
>>>>> These two upstream commits should be removed after Jeff rebase
>>>>> his "ceph-fscrypt-content-experimental" branch to upstream code.
>>>>>
>>>> I don't think I was clear last time. I'd like for you to post the
>>>> _entire_ stack of patches that is based on top of
>>>> ceph-client/wip-fscrypt-fnames. wip-fscrypt-fnames is pretty stable at
>>>> this point, so I think it's a reasonable place for you to base your
>>>> work. That way you're not beginning with a revert.
>>> Hi Jeff,
>>>
>>> BTW, have test by disabling the CONFIG_FS_ENCRYPTION option for branch
>>> ceph-client/wip-fscrypt-fnames ?
>>>
>>> I have tried it today but the kernel will crash always with the
>>> following script. I tried many times the terminal, which is running 'cat
>>> /proc/kmsg' will always be stuck without any call trace about it.
>>>
>>> # mkdir dir && echo "123" > dir/testfile
>>>
>>> By enabling the CONFIG_FS_ENCRYPTION, I haven't countered any issue yet.
>>>
>>> I am still debugging on it.
>>>
>>>
>>
>> No, I hadn't noticed that, but I can reproduce it too. AFAICT, bash is
>> sitting in a pselect() call:
>>
>> [jlayton@client1 ~]$ sudo cat /proc/1163/stack
>> [<0>] poll_schedule_timeout.constprop.0+0x53/0xa0
>> [<0>] do_select+0xb51/0xc70
>> [<0>] core_sys_select+0x2ac/0x620
>> [<0>] do_pselect.constprop.0+0x101/0x1b0
>> [<0>] __x64_sys_pselect6+0x9a/0xc0
>> [<0>] do_syscall_64+0x3b/0x90
>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> After playing around a bit more, I saw this KASAN pop, which may be
>> related:
>>
>> [ 1046.013880] ==================================================================
>> [ 1046.017053] BUG: KASAN: out-of-bounds in encode_cap_msg+0x76c/0xa80 [ceph]
>> [ 1046.019441] Read of size 18446744071716025685 at addr ffff8881011bf558 by task kworker/7:1/82
>> [ 1046.022243]
>> [ 1046.022785] CPU: 7 PID: 82 Comm: kworker/7:1 Tainted: G            E     5.15.0-rc6+ #43
>> [ 1046.025421] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-4.fc34 04/01/2014
>> [ 1046.028159] Workqueue: ceph-msgr ceph_con_workfn [libceph]
>> [ 1046.030111] Call Trace:
>> [ 1046.030983]  dump_stack_lvl+0x57/0x72
>> [ 1046.032177]  ? __mutex_unlock_slowpath+0x105/0x3c0
>> [ 1046.033864]  print_address_description.constprop.0+0x1f/0x140
>> [ 1046.035807]  ? __mutex_unlock_slowpath+0x105/0x3c0
>> [ 1046.037221]  ? encode_cap_msg+0x76c/0xa80 [ceph]
>> [ 1046.038680]  kasan_report.cold+0x7f/0x11b
>> [ 1046.039853]  ? __mutex_unlock_slowpath+0x105/0x3c0
>> [ 1046.041317]  ? encode_cap_msg+0x76c/0xa80 [ceph]
>> [ 1046.042782]  ? __mutex_unlock_slowpath+0x105/0x3c0
>> [ 1046.044168]  kasan_check_range+0xf5/0x1d0
>> [ 1046.045325]  ? __mutex_unlock_slowpath+0x105/0x3c0
>> [ 1046.046679]  memcpy+0x20/0x60
>> [ 1046.047555]  ? __mutex_unlock_slowpath+0x105/0x3c0
>> [ 1046.048930]  encode_cap_msg+0x76c/0xa80 [ceph]
>> [ 1046.050383]  ? ceph_kvmalloc+0xdd/0x110 [libceph]
>> [ 1046.051888]  ? ceph_msg_new2+0xf7/0x210 [libceph]
>> [ 1046.053395]  __send_cap+0x40/0x180 [ceph]
>> [ 1046.054696]  ceph_check_caps+0x5a2/0xc50 [ceph]
>> [ 1046.056482]  ? deref_stack_reg+0xb0/0xb0
>> [ 1046.057786]  ? ceph_con_workfn+0x224/0x8b0 [libceph]
>> [ 1046.059471]  ? __ceph_should_report_size+0x90/0x90 [ceph]
>> [ 1046.061190]  ? lock_is_held_type+0xe0/0x110
>> [ 1046.062453]  ? find_held_lock+0x85/0xa0
>> [ 1046.063684]  ? __mutex_unlock_slowpath+0x105/0x3c0
>> [ 1046.065089]  ? lock_release+0x1c7/0x3e0
>> [ 1046.066225]  ? wait_for_completion+0x150/0x150
>> [ 1046.067570]  ? __ceph_caps_file_wanted+0x25a/0x380 [ceph]
>> [ 1046.069319]  handle_cap_grant+0x113c/0x13a0 [ceph]
>> [ 1046.070962]  ? ceph_kick_flushing_inode_caps+0x240/0x240 [ceph]
>> [ 1046.081699]  ? __cap_is_valid+0x82/0x100 [ceph]
>> [ 1046.091755]  ? rb_next+0x1e/0x80
>> [ 1046.096640]  ? __ceph_caps_issued+0xe0/0x130 [ceph]
>> [ 1046.101331]  ceph_handle_caps+0x10f9/0x2280 [ceph]
>> [ 1046.106003]  ? mds_dispatch+0x134/0x2470 [ceph]
>> [ 1046.110416]  ? ceph_remove_capsnap+0x90/0x90 [ceph]
>> [ 1046.114901]  ? __mutex_lock+0x180/0xc10
>> [ 1046.119178]  ? release_sock+0x1d/0xf0
>> [ 1046.123331]  ? mds_dispatch+0xaf/0x2470 [ceph]
>> [ 1046.127588]  ? __mutex_unlock_slowpath+0x105/0x3c0
>> [ 1046.131845]  mds_dispatch+0x6fb/0x2470 [ceph]
>> [ 1046.136002]  ? tcp_recvmsg+0xe0/0x2c0
>> [ 1046.140038]  ? ceph_mdsc_handle_mdsmap+0x3c0/0x3c0 [ceph]
>> [ 1046.144255]  ? wait_for_completion+0x150/0x150
>> [ 1046.148235]  ceph_con_process_message+0xd9/0x240 [libceph]
>> [ 1046.152387]  ? iov_iter_advance+0x8e/0x480
>> [ 1046.156239]  process_message+0xf/0x100 [libceph]
>> [ 1046.160219]  ceph_con_v2_try_read+0x1561/0x1b00 [libceph]
>> [ 1046.164317]  ? __handle_control+0x1730/0x1730 [libceph]
>> [ 1046.168345]  ? __lock_acquire+0x830/0x2c60
>> [ 1046.172183]  ? __mutex_lock+0x180/0xc10
>> [ 1046.175910]  ? ceph_con_workfn+0x41/0x8b0 [libceph]
>> [ 1046.179814]  ? lockdep_hardirqs_on_prepare+0x220/0x220
>> [ 1046.183688]  ? mutex_lock_io_nested+0xba0/0xba0
>> [ 1046.187559]  ? lock_release+0x3e0/0x3e0
>> [ 1046.191422]  ceph_con_workfn+0x224/0x8b0 [libceph]
>> [ 1046.195464]  process_one_work+0x4fd/0x9a0
>> [ 1046.199281]  ? pwq_dec_nr_in_flight+0x100/0x100
>> [ 1046.203075]  ? rwlock_bug.part.0+0x60/0x60
>> [ 1046.206787]  worker_thread+0x2d4/0x6e0
>> [ 1046.210488]  ? process_one_work+0x9a0/0x9a0
>> [ 1046.214254]  kthread+0x1e3/0x210
>> [ 1046.217911]  ? set_kthread_struct+0x80/0x80
>> [ 1046.221694]  ret_from_fork+0x22/0x30
>> [ 1046.225553]
>> [ 1046.228927] The buggy address belongs to the page:
>> [ 1046.232690] page:000000001ee14099 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1011bf
>> [ 1046.237195] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
>> [ 1046.241352] raw: 0017ffffc0000000 ffffea0004046fc8 ffffea0004046fc8 0000000000000000
>> [ 1046.245998] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>> [ 1046.250612] page dumped because: kasan: bad access detected
>> [ 1046.254948]
>> [ 1046.258789] addr ffff8881011bf558 is located in stack of task kworker/7:1/82 at offset 296 in frame:
>> [ 1046.263501]  ceph_check_caps+0x0/0xc50 [ceph]
>> [ 1046.267766]
>> [ 1046.271643] this frame has 3 objects:
>> [ 1046.275934]  [32, 36) 'implemented'
>> [ 1046.275941]  [48, 56) 'oldest_flush_tid'
>> [ 1046.280091]  [80, 352) 'arg'
>> [ 1046.284281]
>> [ 1046.291847] Memory state around the buggy address:
>> [ 1046.295874]  ffff8881011bf400: 00 00 00 00 00 00 f1 f1 f1 f1 00 00 00 f2 f2 f2
>> [ 1046.300247]  ffff8881011bf480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [ 1046.304752] >ffff8881011bf500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [ 1046.309172]                                                     ^
>> [ 1046.313414]  ffff8881011bf580: 00 00 f3 f3 f3 f3 f3 f3 f3 f3 00 00 00 00 00 00
>> [ 1046.318113]  ffff8881011bf600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> [ 1046.322543] ==================================================================
>>
>> I'll keep investigating too.
> Found it -- this patch seems to fix it. I'll plan to roll it into the
> earlier patch that caused the bug, and will push an updated branch to
> wip-fscrypt-fnames.
>
> Good catch!
>
> --------------------------------------8<-------------------------------
>
> [PATCH] SQUASH: fix cap encoding when fscrypt is disabled
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 6e9f4de883d1..80f521dd7254 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1312,11 +1312,16 @@ static void encode_cap_msg(struct ceph_msg *msg,
> struct cap_msg_args *arg)
>   	ceph_encode_64(&p, 0);
>   	ceph_encode_64(&p, 0);
>   
> +#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
>   	/* fscrypt_auth and fscrypt_file (version 12) */
>   	ceph_encode_32(&p, arg->fscrypt_auth_len);
>   	ceph_encode_copy(&p, arg->fscrypt_auth, arg->fscrypt_auth_len);
>   	ceph_encode_32(&p, arg->fscrypt_file_len);
>   	ceph_encode_copy(&p, arg->fscrypt_file, arg->fscrypt_file_len);
> +#else /* CONFIG_FS_ENCRYPTION */
> +	ceph_encode_32(&p, 0);
> +	ceph_encode_32(&p, 0);
> +#endif /* CONFIG_FS_ENCRYPTION */
>   }
>   
>   /*

Yeah, this should be the root cause.


