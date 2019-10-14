Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A95D5F98
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2019 12:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbfJNKBB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Oct 2019 06:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731119AbfJNKBA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 06:01:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BA5D2054F;
        Mon, 14 Oct 2019 10:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571047260;
        bh=8hv8kOwTn5l1HMAW6XIWlV7FwUBsOLdkJOgm2pAl2aI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g7gI7ebKZCUYTZattLt0HE3lw3Nsq6q00J7tMhyyt9zDE8dEXgfC3XH8klLi+lsOp
         6yGF/Za110rw9sekhZIdCmSEXI3nbPJ7CdbBd9QEclVQKQbkhCGs/FECyI+eERPhJX
         sWISdHTROwOTQZ1ZSSRXTdDiihJAg6mphwKG5X3w=
Message-ID: <6157a498a381e63bbf19094b5d59137f62be7c7f.camel@kernel.org>
Subject: Re: [PATCH] function dispatch should return if mds session does not
 exist
From:   Jeff Layton <jlayton@kernel.org>
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 14 Oct 2019 06:00:58 -0400
In-Reply-To: <20191014090059.21871-1-gmayyyha@gmail.com>
References: <20191014090059.21871-1-gmayyyha@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-10-14 at 17:00 +0800, Yanhu Cao wrote:
> we shouldn't call ceph_msg_put, otherwise libceph will pass
> invalid pointer to mm.
> 
> kernel panic - not syncing: fatal exception
>     [5452201.213885] ------------[ cut here ]------------
>     [5452201.213889] kernel BUG at mm/slub.c:3901!
>     [5452201.213938] invalid opcode: 0000 [#1] SMP PTI
>     [5452201.213971] CPU: 35 PID: 3037447 Comm: kworker/35:1 Kdump: loaded Not tainted 4.19.15 #1
>     [5452201.214020] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 01/22/2018
>     [5452201.214088] Workqueue: ceph-msgr ceph_con_workfn [libceph]
>     [5452201.214129] RIP: 0010:kfree+0x15b/0x170
>     [5452201.214156] Code: 8b 02 f6 c4 80 75 08 49 8b 42 08 a8 01 74 1b 49 8b 02 31 f6 f6 c4 80 74 05 41 0f b6 72 51 5b 5d 41 5c 4c 89 d7 e9 95 03 f9 ff <0f> 0b 48 83 e8 01 e9 01 ff ff ff 49 83 ea 01 e9 e9 fe ff ff 90 0f
>     [5452201.214262] RSP: 0018:ffffb8c3a0607cb0 EFLAGS: 00010246
>     [5452201.214296] RAX: ffffeee840000008 RBX: ffff9130c0000000 RCX: 0000000080200016
>     [5452201.214339] RDX: 00006f0ec0000000 RSI: 0000000000000000 RDI: ffff9130c0000000
>     [5452201.214383] RBP: ffff91107f823970 R08: 0000000000000001 R09: 0000000000000000
>     [5452201.214426] R10: ffffeee840000000 R11: 0000000000000001 R12: ffffffffc076c45d
>     [5452201.214469] R13: ffff91107f823970 R14: ffff91107f8239e0 R15: ffff91107f823900
>     [5452201.214513] FS:  0000000000000000(0000) GS:ffff9110bfbc0000(0000) knlGS:0000000000000000
>     [5452201.214562] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     [5452201.214598] CR2: 000055993ab29620 CR3: 0000003a1e00a003 CR4: 00000000003606e0
>     [5452201.214641] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>     [5452201.214685] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>     [5452201.214728] Call Trace:
>     [5452201.214759]  ceph_msg_release+0x15d/0x190 [libceph]
>     [5452201.214811]  dispatch+0x66/0xa50 [ceph]
>     [5452201.214846]  try_read+0x7f3/0x11d0 [libceph]
>     [5452201.214878]  ? dequeue_entity+0x37e/0x7e0
>     [5452201.214907]  ? pick_next_task_fair+0x291/0x610
>     [5452201.214937]  ? dequeue_task_fair+0x5d/0x700
>     [5452201.214966]  ? __switch_to+0x8c/0x470
>     [5452201.214999]  ceph_con_workfn+0xa2/0x5b0 [libceph]
>     [5452201.215033]  process_one_work+0x16b/0x370
>     [5452201.215062]  worker_thread+0x49/0x3f0
>     [5452201.215089]  kthread+0xf5/0x130
>     [5452201.215112]  ? max_active_store+0x80/0x80
>     [5452201.215139]  ? kthread_bind+0x10/0x10
>     [5452201.215167]  ret_from_fork+0x1f/0x30
> 
> Link: https://tracker.ceph.com/issues/42288
> 
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/mds_client.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a8a8f84f3bbf..066358fea347 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4635,7 +4635,7 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>  	mutex_lock(&mdsc->mutex);
>  	if (__verify_registered_session(mdsc, s) < 0) {
>  		mutex_unlock(&mdsc->mutex);
> -		goto out;
> +		return;
>  	}
>  	mutex_unlock(&mdsc->mutex);
>  
> @@ -4672,7 +4672,6 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>  		pr_err("received unknown message type %d %s\n", type,
>  		       ceph_msg_type_name(type));
>  	}
> -out:
>  	ceph_msg_put(msg);
>  }
>  

This doesn't look quite right. We hold a msg reference here. If we don't
call ceph_msg_put on it then that reference will leak.

Do you know which pointer it was trying to kfree at the time of the
crash? What's your rationale for thinking that this is the problem?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

