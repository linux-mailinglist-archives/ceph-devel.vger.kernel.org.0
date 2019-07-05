Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F260A4E
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Jul 2019 18:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfGEQdO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Jul 2019 12:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbfGEQdN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 12:33:13 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F252216E3;
        Fri,  5 Jul 2019 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562344392;
        bh=WUOVlI9P777cOYtJ8vLo2uR/7ubU0s7Mvhc0KMg3nU4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i3J4qn7Q81b6M9KSKGv6KZHLQaByXapmsOlXrNy0gt7tq6SvPPGRav7dxGw3THExT
         eszsr2ZEJqlS/0+rkX+3sGQRnDf/jRoLcOcwE5fOfMuRO/PqTPmVOBN1U/HnfU7vyn
         B1DTitaGTaMA1lT0/yIXL8gsX6yKPMK4g15fk568=
Message-ID: <8d9232639f77b64aad91c8d7c4134a2f9c120ed6.camel@kernel.org>
Subject: Re: [PATCH] ceph: use generic_delete_inode() for ->drop_inode
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 05 Jul 2019 12:33:10 -0400
In-Reply-To: <20190705161456.5138-1-lhenriques@suse.com>
References: <20190705161456.5138-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-07-05 at 17:14 +0100, Luis Henriques wrote:
> ceph_drop_inode() implementation is not any different from the generic
> function, thus there's no point in keeping it around.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/inode.c | 10 ----------
>  fs/ceph/super.c |  2 +-
>  fs/ceph/super.h |  1 -
>  3 files changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 761451f36e2d..211140e6ef9c 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -578,16 +578,6 @@ void ceph_destroy_inode(struct inode *inode)
>  	ceph_put_string(rcu_dereference_raw(ci->i_layout.pool_ns));
>  }
>  
> -int ceph_drop_inode(struct inode *inode)
> -{
> -	/*
> -	 * Positve dentry and corresponding inode are always accompanied
> -	 * in MDS reply. So no need to keep inode in the cache after
> -	 * dropping all its aliases.
> -	 */
> -	return 1;
> -}
> -
>  static inline blkcnt_t calc_inode_blocks(u64 size)
>  {
>  	return (size + (1<<9) - 1) >> 9;
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index d57fa60dcd43..b4a4772756cb 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -843,7 +843,7 @@ static const struct super_operations ceph_super_ops = {
>  	.destroy_inode	= ceph_destroy_inode,
>  	.free_inode	= ceph_free_inode,
>  	.write_inode    = ceph_write_inode,
> -	.drop_inode	= ceph_drop_inode,
> +	.drop_inode	= generic_delete_inode,
>  	.sync_fs        = ceph_sync_fs,
>  	.put_super	= ceph_put_super,
>  	.remount_fs	= ceph_remount,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 5f27e1f7f2d6..622e6c96c960 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -878,7 +878,6 @@ extern const struct inode_operations ceph_file_iops;
>  extern struct inode *ceph_alloc_inode(struct super_block *sb);
>  extern void ceph_destroy_inode(struct inode *inode);
>  extern void ceph_free_inode(struct inode *inode);
> -extern int ceph_drop_inode(struct inode *inode);
>  
>  extern struct inode *ceph_get_inode(struct super_block *sb,
>  				    struct ceph_vino vino);

Merged into ceph-client/testing. We should be able to get this in for
5.3.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

