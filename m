Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DACDEC60
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Oct 2019 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfJUMiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Oct 2019 08:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfJUMiF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 08:38:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67CE820882;
        Mon, 21 Oct 2019 12:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571661484;
        bh=U34Zxl40M0KZ91u68hnR39dcSI6e8wzjiQE2V86KUYA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LsOR3CbveNpm6buGaXmRVZawS9NvQcQHxkLfeBPUUwltw1VJmfSJcYHxZJN5AZ22Q
         ME0VdR+PCzKYAV+yXp8dOcEMAjG7CaMYFWP99xOMdYOjLfejS+iPpn1HLrBqG9j7VK
         Ye4LmGycxE91vfWPdoeQq9XAJI35PR/lI5uJWQYM=
Message-ID: <a68eeb81a5b193be2da49b83dfedce7d2782fb40.camel@kernel.org>
Subject: Re: [PATCH] ceph: Fix use-after-free in __ceph_remove_cap
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 21 Oct 2019 08:38:03 -0400
In-Reply-To: <20191017144636.28617-1-lhenriques@suse.com>
References: <20191017144636.28617-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-10-17 at 15:46 +0100, Luis Henriques wrote:
> KASAN reports a use-after-free when running xfstest generic/531, with the
> following trace:
> 
> [  293.903362]  kasan_report+0xe/0x20
> [  293.903365]  rb_erase+0x1f/0x790
> [  293.903370]  __ceph_remove_cap+0x201/0x370
> [  293.903375]  __ceph_remove_caps+0x4b/0x70
> [  293.903380]  ceph_evict_inode+0x4e/0x360
> [  293.903386]  evict+0x169/0x290
> [  293.903390]  __dentry_kill+0x16f/0x250
> [  293.903394]  dput+0x1c6/0x440
> [  293.903398]  __fput+0x184/0x330
> [  293.903404]  task_work_run+0xb9/0xe0
> [  293.903410]  exit_to_usermode_loop+0xd3/0xe0
> [  293.903413]  do_syscall_64+0x1a0/0x1c0
> [  293.903417]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This happens because __ceph_remove_cap() may queue a cap release
> (__ceph_queue_cap_release) which can be scheduled before that cap is
> removed from the inode list with
> 
> 	rb_erase(&cap->ci_node, &ci->i_caps);
> 
> And, when this finally happens, the use-after-free will occur.
> 
> This can be fixed by protecting the rb_erase with the s_cap_lock spinlock,
> which is used by ceph_send_cap_releases(), before the cap is freed.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/caps.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index d3b9c9d5c1bd..21ee38cabe98 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1089,13 +1089,13 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  	}
>  	cap->cap_ino = ci->i_vino.ino;
>  
> -	spin_unlock(&session->s_cap_lock);
> -
>  	/* remove from inode list */
>  	rb_erase(&cap->ci_node, &ci->i_caps);
>  	if (ci->i_auth_cap == cap)
>  		ci->i_auth_cap = NULL;
>  
> +	spin_unlock(&session->s_cap_lock);
> +
>  	if (removed)
>  		ceph_put_cap(mdsc, cap);
>  

Is there any reason we need to wait until this point to remove it from
the rbtree? ISTM that we ought to just do that at the beginning of the
function, before we take the s_cap_lock.
-- 
Jeff Layton <jlayton@kernel.org>

