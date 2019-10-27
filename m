Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FEFE6274
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2019 13:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfJ0Mbw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 27 Oct 2019 08:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfJ0Mbw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 27 Oct 2019 08:31:52 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9160620679;
        Sun, 27 Oct 2019 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572179511;
        bh=EuTIDHl6bQl/3rTLwZ8VASMvn82jC2/UGPnCBd61cbI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gg7E7f+x2+FgboRqkW3txPE+c8F0VbcY6hZSAI/UGQ0LcB22fKTBqiJNiXIcDofUG
         EB/VdB1z//xNmIntXhf/LgQSlp4CpRaP2ya+V84Ys2Ik7PnQrNUC6FCDqb9w4DKX5g
         vb1qzsKMSx0G+Z647D0OByxbUBsOG/ABxlkyAgRc=
Message-ID: <1a9ac7d3097efe53ad6f2fda4dd584204dd7eba2.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: Fix use-after-free in __ceph_remove_cap
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 27 Oct 2019 08:31:49 -0400
In-Reply-To: <20191025130524.31755-1-lhenriques@suse.com>
References: <9c1fe73500ca7dece15c73d7534b9e0ec417c83a.camel@kernel.org>
         <20191025130524.31755-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-10-25 at 14:05 +0100, Luis Henriques wrote:
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
> This can be fixed by removing the cap from the inode list before being
> removed from the session list, and thus eliminating the risk of an UAF.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
> Hi!
> 
> So, after spending some time trying to find possible races throught code
> review and testing, I modified the fix according to Jeff's suggestion.
> 
> Cheers,
> Luis
> 
> fs/ceph/caps.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index d3b9c9d5c1bd..a9ce858c37d0 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1058,6 +1058,11 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  
>  	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>  
> +	/* remove from inode list */
> +	rb_erase(&cap->ci_node, &ci->i_caps);
> +	if (ci->i_auth_cap == cap)
> +		ci->i_auth_cap = NULL;
> +
>  	/* remove from session list */
>  	spin_lock(&session->s_cap_lock);
>  	if (session->s_cap_iterator == cap) {
> @@ -1091,11 +1096,6 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  
>  	spin_unlock(&session->s_cap_lock);
>  
> -	/* remove from inode list */
> -	rb_erase(&cap->ci_node, &ci->i_caps);
> -	if (ci->i_auth_cap == cap)
> -		ci->i_auth_cap = NULL;
> -
>  	if (removed)
>  		ceph_put_cap(mdsc, cap);
>  

Looks good. Merged with a slight modification to the comment:

+       /* remove from inode's cap rbtree, and clear auth cap */

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

