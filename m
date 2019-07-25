Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D7774A0F
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 11:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389375AbfGYJhm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 05:37:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:53408 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727600AbfGYJhm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 05:37:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3AC03ABE9;
        Thu, 25 Jul 2019 09:37:41 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     David Disseldorp <ddiss@suse.com>, ceph-devel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: don't list vxattrs in listxattr()
References: <20190724172026.23999-1-jlayton@kernel.org>
Date:   Thu, 25 Jul 2019 10:37:40 +0100
In-Reply-To: <20190724172026.23999-1-jlayton@kernel.org> (Jeff Layton's
        message of "Wed, 24 Jul 2019 13:20:26 -0400")
Message-ID: <87ftmu4fq3.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

(CC'ing David)

> Most filesystems that provide virtual xattrs (e.g. CIFS) don't display
> them via listxattr(). Ceph does, and that causes some of the tests in
> xfstests to fail.
>
> Have cephfs stop listing vxattrs in listxattr. Userspace can always
> query them directly when the name is known.

I don't see a problem with this, unless we already have applications
relying on this behaviour.  The first thing that came to my mind was
samba, but I guess David can probably confirm whether this is true or
not.

If we're unable to stop listing there xattrs, the other option for
fixing the xfstests that _may_ be acceptable by the maintainers is to
use an output filter (lots of examples in common/filter).

Cheers,
-- 
Luis

>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/xattr.c | 29 -----------------------------
>  1 file changed, 29 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 939eab7aa219..2fba06b50f25 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -903,11 +903,9 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
>  {
>  	struct inode *inode = d_inode(dentry);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -	struct ceph_vxattr *vxattrs = ceph_inode_vxattrs(inode);
>  	bool len_only = (size == 0);
>  	u32 namelen;
>  	int err;
> -	int i;
>  
>  	spin_lock(&ci->i_ceph_lock);
>  	dout("listxattr %p ver=%lld index_ver=%lld\n", inode,
> @@ -936,33 +934,6 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
>  		names = __copy_xattr_names(ci, names);
>  		size -= namelen;
>  	}
> -
> -
> -	/* virtual xattr names, too */
> -	if (vxattrs) {
> -		for (i = 0; vxattrs[i].name; i++) {
> -			size_t this_len;
> -
> -			if (vxattrs[i].flags & VXATTR_FLAG_HIDDEN)
> -				continue;
> -			if (vxattrs[i].exists_cb && !vxattrs[i].exists_cb(ci))
> -				continue;
> -
> -			this_len = strlen(vxattrs[i].name) + 1;
> -			namelen += this_len;
> -			if (len_only)
> -				continue;
> -
> -			if (this_len > size) {
> -				err = -ERANGE;
> -				goto out;
> -			}
> -
> -			memcpy(names, vxattrs[i].name, this_len);
> -			names += this_len;
> -			size -= this_len;
> -		}
> -	}
>  	err = namelen;
>  out:
>  	spin_unlock(&ci->i_ceph_lock);
