Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57A13ED435
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Aug 2021 14:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhHPMoe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 08:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhHPMoe (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 08:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7385963272;
        Mon, 16 Aug 2021 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629117842;
        bh=kSw1KOIjJJOA+srQgisUf/zjB7LEm89DflSYBZRlzZo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ShlnE/4YogzIOVGDx1tjPZnl3nkNolmZCJkG0Rkh3gHik6EJ7v8Nh2LAXWAfg2gOy
         7n9aNm6fnmDCr4EpuNvnD3lOz1a/7KsrEAuJnwJU7/H6kFdusQ0kqogb2ikcOve5Ac
         rMCXm2dS1kGdcGCEWZgSZ9ze0sHyWAiTGhZjYes8ZUP6kS7OJ0FkQT5LlmjvznznkY
         4+4XadXsZTjlgpGhtYXl5sJJhBbgEqFJU8O/bBhTQfsR1vCXoO5oePmROyiAQ+ig4Z
         6sufmUDdyWRm52p+P+sa2drHI13tXProabBBj3mY6WtQsGx1RkE7pCz1WE+WYaLQeY
         MBG0d7R43gzrQ==
Message-ID: <e07e5f52bf73c0a9ef1441295f5ff42753d3e29a.camel@kernel.org>
Subject: Re: [fscrypt][RFC PATCH] ceph: don't allow changing layout on
 encrypted files/directories
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 16 Aug 2021 08:44:01 -0400
In-Reply-To: <YRZtiL+qo95vK0Nf@suse.de>
References: <YRZtiL+qo95vK0Nf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-08-13 at 14:03 +0100, Luis Henriques wrote:
> Encryption is currently only supported on files/directories with layouts
> where stripe_count=1.  Forbid changing layouts when encryption is involved.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> Hi!
> 
> While continuing looking into fscrypt, I realized we're not yet forbidding
> different layouts on encrypted files.  This patch tries to do just that.
> 
> Regarding the setxattr, I've also made a change [1] to the MDS code so that it
> also prevents layouts to be changed.  This should make the changes to
> ceph_sync_setxattr() redundant, but in practice it doesn't because if we encrypt
> a directory and immediately after that we change that directory layout, the MDS
> wouldn't yet have received the fscrypt_auth for that inode.  So... yeah, an
> alternative would be to propagate the fscrypt context immediately after
> encrypting a directory.
> 
> [1] https://github.com/luis-henrix/ceph/commit/601488ae798ecfa5ec81677d1ced02f7dd42aa10
> 
> Cheers,
> --
> Luis
> 
>  fs/ceph/ioctl.c | 4 ++++
>  fs/ceph/xattr.c | 6 ++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 477ecc667aee..42abfc564301 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
> +	/* encrypted directories can't have striped layout */
> +	if (ci->i_layout.stripe_count > 1)
> +		return -EOPNOTSUPP;
> +

Yes, I've been needing to add that for a while. I'm not sure EOPNOTSUPP
is the right error code though. Maybe EINVAL instead?

>  	ret = vet_mds_for_fscrypt(file);
>  	if (ret)
>  		return ret;
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index b175b3029dc0..7921cb34900c 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1051,6 +1051,12 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
>  	int op = CEPH_MDS_OP_SETXATTR;
>  	int err;
>  
> +	/* encrypted directories/files can't have their layout changed */
> +	if (IS_ENCRYPTED(inode) &&
> +	    (!strncmp(name, "ceph.file.layout", 16) ||
> +	     !strncmp(name, "ceph.dir.layout", 15)))
> +		return -EOPNOTSUPP;
> +

Yuck.

What might be nicer is to just make ceph_vxattrcb_layout* return an
error when the inode is encrypted? You can return negative error codes
from the ->getxattr_cb ops, and that's probably the better place to
check for this.

>  	if (size > 0) {
>  		/* copy value into pagelist */
>  		pagelist = ceph_pagelist_alloc(GFP_NOFS);
> 
> Cheers,
> --
> Luís

-- 
Jeff Layton <jlayton@kernel.org>

