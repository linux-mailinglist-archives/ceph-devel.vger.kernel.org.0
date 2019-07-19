Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD156ECAA
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Jul 2019 01:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbfGSXHw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 19:07:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbfGSXHw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 19:07:52 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB5C2089C;
        Fri, 19 Jul 2019 23:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563577671;
        bh=6h+e0DQ6omq60QcQu5YWlxGv1jSCpjt2R+a+Cp1vyTA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SVSCVAFUR7KijMhbggA2vVf9ja197HO3/EZeglfHS1uLj9MGTrj6TLon1iUEsoAbL
         jXwNqirqqO0t4OgBKa/kOxQEXzXZaavgFvHlW6hwkYV5Evp2/qYbEe+wjCVC+BM0cL
         OsgVjE2yQ+OoUdCFqwS8j2fC5vfL3LB82Eo0A8Qo=
Message-ID: <1dee14212043f12ef5b26e4aee0c3155e118abf3.camel@kernel.org>
Subject: Re: [PATCH 2/4] ceph: fix buffer free while holding i_ceph_lock in
 __ceph_setxattr()
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 19 Jul 2019 19:07:49 -0400
In-Reply-To: <20190719143222.16058-3-lhenriques@suse.com>
References: <20190719143222.16058-1-lhenriques@suse.com>
         <20190719143222.16058-3-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-07-19 at 15:32 +0100, Luis Henriques wrote:
> Calling ceph_buffer_put() in __ceph_setxattr() may end up freeing the
> i_xattrs.prealloc_blob buffer while holding the i_ceph_lock.  This can be
> fixed by postponing the call until later, when the lock is released.
> 
> The following backtrace was triggered by fstests generic/117.
> 
>   BUG: sleeping function called from invalid context at mm/vmalloc.c:2283
>   in_atomic(): 1, irqs_disabled(): 0, pid: 650, name: fsstress
>   3 locks held by fsstress/650:
>    #0: 00000000870a0fe8 (sb_writers#8){.+.+}, at: mnt_want_write+0x20/0x50
>    #1: 00000000ba0c4c74 (&type->i_mutex_dir_key#6){++++}, at: vfs_setxattr+0x55/0xa0
>    #2: 000000008dfbb3f2 (&(&ci->i_ceph_lock)->rlock){+.+.}, at: __ceph_setxattr+0x297/0x810
>   CPU: 1 PID: 650 Comm: fsstress Not tainted 5.2.0+ #437
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
>   Call Trace:
>    dump_stack+0x67/0x90
>    ___might_sleep.cold+0x9f/0xb1
>    vfree+0x4b/0x60
>    ceph_buffer_release+0x1b/0x60
>    __ceph_setxattr+0x2b4/0x810
>    __vfs_setxattr+0x66/0x80
>    __vfs_setxattr_noperm+0x59/0xf0
>    vfs_setxattr+0x81/0xa0
>    setxattr+0x115/0x230
>    ? filename_lookup+0xc9/0x140
>    ? rcu_read_lock_sched_held+0x74/0x80
>    ? rcu_sync_lockdep_assert+0x2e/0x60
>    ? __sb_start_write+0x142/0x1a0
>    ? mnt_want_write+0x20/0x50
>    path_setxattr+0xba/0xd0
>    __x64_sys_lsetxattr+0x24/0x30
>    do_syscall_64+0x50/0x1c0
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>   RIP: 0033:0x7ff23514359a
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/xattr.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 37b458a9af3a..c083557b3657 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1036,6 +1036,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>  	struct ceph_cap_flush *prealloc_cf = NULL;
> +	struct ceph_buffer *old_blob = NULL;
>  	int issued;
>  	int err;
>  	int dirty = 0;
> @@ -1109,13 +1110,15 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>  		struct ceph_buffer *blob;
>  
>  		spin_unlock(&ci->i_ceph_lock);
> -		dout(" preaallocating new blob size=%d\n", required_blob_size);
> +		ceph_buffer_put(old_blob); /* Shouldn't be required */
> +		dout(" pre-allocating new blob size=%d\n", required_blob_size);
>  		blob = ceph_buffer_new(required_blob_size, GFP_NOFS);
>  		if (!blob)
>  			goto do_sync_unlocked;
>  		spin_lock(&ci->i_ceph_lock);
> +		/* prealloc_blob can't be released while holding i_ceph_lock */
>  		if (ci->i_xattrs.prealloc_blob)
> -			ceph_buffer_put(ci->i_xattrs.prealloc_blob);
> +			old_blob = ci->i_xattrs.prealloc_blob;
>  		ci->i_xattrs.prealloc_blob = blob;
>  		goto retry;
>  	}
> @@ -1131,6 +1134,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>  	}
>  
>  	spin_unlock(&ci->i_ceph_lock);
> +	ceph_buffer_put(old_blob);
>  	if (lock_snap_rwsem)
>  		up_read(&mdsc->snap_rwsem);
>  	if (dirty)

(cc'ing Al)

Al pointed out on IRC that vfree should be callable under spinlock. It
only sleeps if !in_interrupt(), and I think that should return true if
we're holding a spinlock.

I'll plan to try replicating this soon.
-- 
Jeff Layton <jlayton@kernel.org>

