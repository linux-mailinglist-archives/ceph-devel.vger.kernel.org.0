Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35949AFF12
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 16:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfIKOp7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 10:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfIKOp7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 10:45:59 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48A2E20644;
        Wed, 11 Sep 2019 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568213157;
        bh=jKKbrkpAal/QD48EE9vzeg1oiRuwzKYAtypZnetUa7Q=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=AhmLJwVbJuXnXNBUxhb0f1s1wxB9JmxU+Pxfj0cgsB5rmaNfM6kvy7pCTPCYfn3fK
         zLG7T5xupv6XsNmGwPJRxyNVkCAt9ZPBsFrI4p02dGwFbFU6BfvOWoxUiATYIjpTmM
         81ohPteQUguReu3hTBZlI5Btvoe4uTj4E0r+2GCE=
Message-ID: <2570072aa4f573cc9686b3ca3ecc83a3066700d0.camel@kernel.org>
Subject: Re: [PATCH] libceph: avoid a __vmalloc() deadlock in ceph_kvmalloc()
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Wed, 11 Sep 2019 10:45:56 -0400
In-Reply-To: <20190910151748.914-1-idryomov@gmail.com>
References: <20190910151748.914-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-09-10 at 17:17 +0200, Ilya Dryomov wrote:
> The vmalloc allocator doesn't fully respect the specified gfp mask:
> while the actual pages are allocated as requested, the page table pages
> are always allocated with GFP_KERNEL.  ceph_kvmalloc() may be called
> with GFP_NOFS and GFP_NOIO (for ceph and rbd respectively), so this may
> result in a deadlock.
> 
> There is no real reason for the current PAGE_ALLOC_COSTLY_ORDER logic,
> it's just something that seemed sensible at the time (ceph_kvmalloc()
> predates kvmalloc()).  kvmalloc() is smarter: in an attempt to reduce
> long term fragmentation, it first tries to kmalloc non-disruptively.
> 
> Switch to kvmalloc() and set the respective PF_MEMALLOC_* flag using
> the scope API to avoid the deadlock.  Note that kvmalloc() needs to be
> passed GFP_KERNEL to enable the fallback.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  net/ceph/ceph_common.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index c41789154cdb..970e74b46213 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -13,6 +13,7 @@
>  #include <linux/nsproxy.h>
>  #include <linux/fs_parser.h>
>  #include <linux/sched.h>
> +#include <linux/sched/mm.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include <linux/statfs.h>
> @@ -185,18 +186,34 @@ int ceph_compare_options(struct ceph_options *new_opt,
>  }
>  EXPORT_SYMBOL(ceph_compare_options);
>  
> +/*
> + * kvmalloc() doesn't fall back to the vmalloc allocator unless flags are
> + * compatible with (a superset of) GFP_KERNEL.  This is because while the
> + * actual pages are allocated with the specified flags, the page table pages
> + * are always allocated with GFP_KERNEL.  map_vm_area() doesn't even take
> + * flags because GFP_KERNEL is hard-coded in {p4d,pud,pmd,pte}_alloc().
> + *
> + * ceph_kvmalloc() may be called with GFP_KERNEL, GFP_NOFS or GFP_NOIO.
> + */
>  void *ceph_kvmalloc(size_t size, gfp_t flags)
>  {
> -	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
> -		void *ptr = kmalloc(size, flags | __GFP_NOWARN);
> -		if (ptr)
> -			return ptr;
> +	void *p;
> +
> +	if ((flags & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS)) {
> +		p = kvmalloc(size, flags);
> +	} else if ((flags & (__GFP_IO | __GFP_FS)) == __GFP_IO) {
> +		unsigned int nofs_flag = memalloc_nofs_save();
> +		p = kvmalloc(size, GFP_KERNEL);
> +		memalloc_nofs_restore(nofs_flag);
> +	} else {
> +		unsigned int noio_flag = memalloc_noio_save();
> +		p = kvmalloc(size, GFP_KERNEL);
> +		memalloc_noio_restore(noio_flag);
>  	}
>  
> -	return __vmalloc(size, flags, PAGE_KERNEL);
> +	return p;
>  }
>  
> -
>  static int parse_fsid(const char *str, struct ceph_fsid *fsid)
>  {
>  	int i = 0;

Reviewed-by: Jeff Layton <jlayton@kernel.org>

