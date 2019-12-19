Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D66A126087
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 12:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfLSLK3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Dec 2019 06:10:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbfLSLK3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 06:10:29 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3744B222C2;
        Thu, 19 Dec 2019 11:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576753828;
        bh=8ksGHP2WPOaksnN+OglMR2u5IOfQp0+HRcp5bGI3gCM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=1coEdAOuKdF9ZXav7gzurJu/KgorssLjfi4dq3JFvRPtCOIIFkXWOSljK62xARIQz
         sAvWosIyz0aJl/jMf4zsjALYBH5rSSI6T1FvrekLLELXM722fs3i//Zo6WXIGZFQDw
         CLTc+gVS82PhECEy+WDDeLc+bkwdgxfJ/+cHpod0=
Message-ID: <1b99ad456e4db43a1f27471adb5238211fec956e.camel@kernel.org>
Subject: Re: [PATCH] ceph: cleanup the dir debug log and xattr_version
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 19 Dec 2019 06:10:26 -0500
In-Reply-To: <20191219021518.60891-1-xiubli@redhat.com>
References: <20191219021518.60891-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-12-18 at 21:15 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> In the debug logs about the di->offset or ctx->pos it is in hex
> format, but some others are using the dec format. It is a little
> hard to read.
> 
> For the xattr version, it is u64 type, using a shorter type may
> truncate it.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c   | 4 ++--
>  fs/ceph/xattr.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 5c97bdbb0772..8d14a2867e7c 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1192,7 +1192,7 @@ void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di)
>  	struct dentry *dn = di->dentry;
>  	struct ceph_mds_client *mdsc;
>  
> -	dout("dentry_dir_lease_touch %p %p '%pd' (offset %lld)\n",
> +	dout("dentry_dir_lease_touch %p %p '%pd' (offset %llx)\n",
>  	     di, dn, dn, di->offset);

If you're printing hex values, it's generally a good idea to prefix them
with "0x" so that it's clear that they are in hex.

>  
>  	if (!list_empty(&di->lease_list)) {
> @@ -1577,7 +1577,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  
>  	mdsc = ceph_sb_to_client(dir->i_sb)->mdsc;
>  
> -	dout("d_revalidate %p '%pd' inode %p offset %lld\n", dentry,
> +	dout("d_revalidate %p '%pd' inode %p offset %llx\n", dentry,
>  	     dentry, inode, ceph_dentry(dentry)->offset);
>  
>  	/* always trust cached snapped dentries, snapdir dentry */
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 6e5e145d51d1..c8609dfd6b37 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -655,7 +655,7 @@ static int __build_xattrs(struct inode *inode)
>  	u32 len;
>  	const char *name, *val;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -	int xattr_version;
> +	u64 xattr_version;
>  	struct ceph_inode_xattr **xattrs = NULL;
>  	int err = 0;
>  	int i;

Merged, but I went ahead and added the "0x" prefixes on these values.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

