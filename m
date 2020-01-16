Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E1B13DBFC
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 14:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgAPNbM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 08:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgAPNbM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 08:31:12 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 740662077C;
        Thu, 16 Jan 2020 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579181472;
        bh=qvuk5F+xmELcJe88I5F+jzPf6ddii5WX6OLaF/dNf94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Iv0S4zPQTLTUnKqhHMoePKpNsWwRciozw42y1viUstYS74mK2w42OgLlVnDejAoyE
         8L537Hqy8FsXLSzU85zU6pFWs9nwPQJzS5ppfEfKzfIbplfxicoqqS53980zXh4kG1
         ukK+u3Jl05VQS+1wlHXjkilVgczRX5u/zJlHsJ9U=
Message-ID: <eb1e0cd575d21b744acdc8b588769f0e648fecb2.camel@kernel.org>
Subject: Re: [PATCH]--fix the race condition of remove_session_caps of ceph
 which tirgger bugon
From:   Jeff Layton <jlayton@kernel.org>
To:     =?UTF-8?Q?=E9=99=88=E5=AE=89=E5=BA=86?= <chenanqing@oppo.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>
Date:   Thu, 16 Jan 2020 08:31:10 -0500
In-Reply-To: <HK0PR02MB256313E669FF1C2BDA9155EEAB360@HK0PR02MB2563.apcprd02.prod.outlook.com>
References: <HK0PR02MB256313E669FF1C2BDA9155EEAB360@HK0PR02MB2563.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-01-16 at 02:02 +0000, 陈安庆 wrote:
> Hi All，I think I find a bug in the ceph .
>  
>  
> background:
> [3418687.123610] kernel BUG at fs/ceph/mds_client.c:1325! 
> [3418687.124102] invalid opcode: 0000 [#1] SMP
> [3418687.130132] CPU: 27 PID: 453692 Comm: kworker/27:2 Kdump: loaded Tainted: P OE ------------ T 3.10.0-957.27.2.el7.x86_64 #1
> [3418687.131427] Hardware name: Inspur NF5288M5/YZMB-00834-101, BIOS 4.0.08 09/19/2019
> [3418687.132109] Workqueue: ceph-msgr ceph_con_workfn [libceph]
> [3418687.132792] task: ffff94c932652080 ti: ffff94b73dae4000 task.ti: ffff94b73dae4000
> [3418687.133488] RIP: 0010:[<ffffffffc1acdc9f>] [<ffffffffc1acdc9f>] remove_session_caps+0x1bf/0x1d0 [ceph]
> [3418687.134213] RSP: 0018:ffff94b73dae7be0 EFLAGS: 00010202
> [3418687.134933] RAX: 0000000000000001 RBX: ffff94a09a49ed38 RCX: ffff94b73dae7be8
> [3418687.135668] RDX: ffff94c409f78118 RSI: ffff94b73dae7be8 RDI: ffff94a09a49e800
> [3418687.136407] RBP: ffff94b73dae7c38 R08: ffff94c409f78118 R09: 0000000000000001
> [3418687.137147] R10: 0000000000000000 R11: 0000000000000000 R12: ffff94a09a49e800
> [3418687.137895] R13: ffff94b73dae7be8 R14: ffff94c409f78000 R15: ffff94a09a49ed40
> [3418687.138648] FS: 0000000000000000(0000) GS:ffff94e0bc0c0000(0000) knlGS:0000000000000000
> [3418687.139414] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [3418687.140175] CR2: 00007f49c861a330 CR3: 0000002e4eec4000 CR4: 00000000007607e0
> [3418687.140939] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [3418687.141694] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [3418687.142439] PKRU: 00000000
> [3418687.143173] Call Trace:
> [3418687.143907] [<ffffffffc1ad399c>] dispatch+0x39c/0xb00 [ceph]
> [3418687.144635] [<ffffffffbd81b56a>] ? kernel_recvmsg+0x3a/0x50
> [3418687.145361] [<ffffffffc1a60fb4>] try_read+0x514/0x12c0 [libceph]
> [3418687.146081] [<ffffffffc1a61f64>] ceph_con_workfn+0xe4/0x1530 [libceph]
> [3418687.146795] [<ffffffffbd2d1b60>] ? finish_task_switch+0xe0/0x1c0
> [3418687.147502] [<ffffffffbd969aba>] ? __schedule+0x42a/0x860
> [3418687.148201] [<ffffffffbd2baf9f>] process_one_work+0x17f/0x440
> [3418687.148895] [<ffffffffbd2bc036>] worker_thread+0x126/0x3c0
> [3418687.149579] [<ffffffffbd2bbf10>] ? manage_workers.isra.25+0x2a0/0x2a0
> [3418687.150261] [<ffffffffbd2c2e81>] kthread+0xd1/0xe0
> [3418687.150933] [<ffffffffbd2c2db0>] ? insert_kthread_work+0x40/0x40
> [3418687.151603] [<ffffffffbd976c1d>] ret_from_fork_nospec_begin+0x7/0x21
> [3418687.152266] [<ffffffffbd2c2db0>] ? insert_kthread_work+0x40/0x40
> [3418687.152921] Code: 5d 41 5e 41 5f 5d c3 48 89 fa 48 c7 c6 68 31 ae c1 48 c7 c7 98 0f af c1 31 c0 e8 8d 5c ad fb e9 96 fe ff ff e8 03 a9 7c fb 0f 0b <0f> 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
> [3418687.154318] RIP [<ffffffffc1acdc9f>] remove_session_caps+0x1bf/0x1d0 [ceph]
> [3418687.154998] RSP <ffff94b73dae7be0>
>  
>  
> and I find another thread which is waiting for the spinlock of session->s_cap_lock.
> PID: 512130 TASK: ffff94bcb5afc100 CPU: 62 COMMAND: "kworker/62:4"
> #0 [ffff94e0bc588e48] crash_nmi_callback at ffffffffbd256027
> #1 [ffff94e0bc588e58] nmi_handle at ffffffffbd96e91c
> #2 [ffff94e0bc588eb0] do_nmi at ffffffffbd96eb3d
> #3 [ffff94e0bc588ef0] end_repeat_nmi at ffffffffbd96dd89
> [exception RIP: native_queued_spin_lock_slowpath+462]
> RIP: ffffffffbd3135de RSP: ffff94cfbf2cf800 RFLAGS: 00000202
> RAX: 0000000000000001 RBX: ffff94c409f78000 RCX: 0000000000000001
> RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff94a09a49ed38
> RBP: ffff94cfbf2cf800 R8: 0000000000000101 R9: ffff94a1e6d2e180
> R10: ffff94e1bfbba0e0 R11: ffffffffffffffff R12: ffff94a6c763e9b0
> R13: ffff94a09a49ed38 R14: ffff94a09a49e800 R15: 0000000000000400
> ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
> --- <NMI exception stack> ---
> #4 [ffff94cfbf2cf800] native_queued_spin_lock_slowpath at ffffffffbd3135de
> #5 [ffff94cfbf2cf808] queued_spin_lock_slowpath at ffffffffbd95e2cb
> #6 [ffff94cfbf2cf818] _raw_spin_lock at ffffffffbd96c7a0
> #7 [ffff94cfbf2cf828] __ceph_remove_cap at ffffffffc1ac1366 [ceph]----------this function is waiting for spinlock of session->s_cap_lock 
> #8 [ffff94cfbf2cf870] ceph_queue_caps_release at ffffffffc1ac156c [ceph]
> #9 [ffff94cfbf2cf890] ceph_destroy_inode at ffffffffc1aaabd5 [ceph]
> #10 [ffff94cfbf2cf8d0] destroy_inode at ffffffffbd45fe4b
> #11 [ffff94cfbf2cf8e8] evict at ffffffffbd45ff85
> #12 [ffff94cfbf2cf910] iput at ffffffffbd46082c
> #13 [ffff94cfbf2cf940] ceph_put_wrbuffer_cap_refs at ffffffffc1ac46e4 [ceph]
> #14 [ffff94cfbf2cf9b0] writepages_finish at ffffffffc1ab9ecc [ceph]
> #15 [ffff94cfbf2cfa30] __complete_request at ffffffffc1a67ebe [libceph]
> #16 [ffff94cfbf2cfa50] handle_reply at ffffffffc1a70d1d [libceph]
> #17 [ffff94cfbf2cfc10] dispatch at ffffffffc1a72ae3 [libceph]
> #18 [ffff94cfbf2cfcd0] try_read at ffffffffc1a60fb4 [libceph]
> #19 [ffff94cfbf2cfd90] ceph_con_workfn at ffffffffc1a61f64 [libceph]
> #20 [ffff94cfbf2cfe20] process_one_work at ffffffffbd2baf9f
> #21 [ffff94cfbf2cfe68] worker_thread at ffffffffbd2bc036
> #22 [ffff94cfbf2cfec8] kthread at ffffffffbd2c2e81
> #23 [ffff94cfbf2cff50] ret_from_fork_nospec_begin at ffffffffbd976c1d
>  
> after I read the ceph module of https://github.com/torvalds/linux.git and
> kernel/git/next/linux-next.git ,I think the bug is existed all the same.
>  
> so I make a patch,maybe I should replace the pr_warn_ratelimited by some function like udelay?
>  

Thanks for the patch.

First, be sure you follow the patch submission guidelines when sending a
patch. In particular, git-send-email is really the best way to submit
patches.

> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 4cfc4df9fc34..3734d2afb3c5 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1503,8 +1503,14 @@ static void remove_session_caps(struct ceph_mds_session *session)
>                 while (!list_empty(&session->s_caps)) {
>                         cap = list_entry(session->s_caps.next,
>                                          struct ceph_cap, session_caps);
> -                       if (cap == prev)
> -                                break;
> +                       if (cap == prev) {
> +                               spin_unlock(&session->s_cap_lock);
> +                               pr_warn_ratelimited(
> +                               "removing cap %p, inode is %p be delayed\n",
> +                               cap,  inode);
> +                               spin_lock(&session->s_cap_lock);
> +                               continue;
> +                       }

(cc'ing Zheng)

That seems like it might be prone to spinning for a very long time if we
have an inode with an outstanding reference for a long time. I get that
this is a problem though. 

I think the real bug is that this is not moving the cap to the end of
the list, so that it can attempt to clean up more than one that might be
there. Probably we just need to do a list_move_tail on the entry before
dropping the spinlock?



>                         prev = cap;
>                         vino = cap->ci->i_vino;
>                         spin_unlock(&session->s_cap_lock);
> @@ -1520,6 +1526,13 @@ static void remove_session_caps(struct ceph_mds_session *session)
>         // drop cap expires and unlock s_cap_lock
>         detach_cap_releases(session, &dispose);
>  
> +       /*
> +        * if ceph_async_iput execute ceph_destroy_inode which
> +        * call __ceph_remove_cap finally to dec the session->s_nr_caps
> +        * maybe after than BUGON,because it need session->s_cap_lock
> +        * then BUGON(session->s_nr_caps > 0) must be triggered ,
> +        * although it is just a race condition.
> +        */
>         BUG_ON(session->s_nr_caps > 0);
>         BUG_ON(!list_empty(&session->s_cap_flushing));
>         spin_unlock(&session->s_cap_lock);
> OPPO
> 
> 本电子邮件及其附件含有OPPO公司的保密信息，仅限于邮件指明的收件人使用（包含个人及群组）。禁止任何人在未经授权的情况下以任何形式使用。如果您错收了本邮件，请立即以电子邮件通知发件人并删除本邮件及其附件。
> This e-mail and its attachments contain confidential information from OPPO, which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender by phone or email immediately and delete it!

-- 
Jeff Layton <jlayton@kernel.org>

