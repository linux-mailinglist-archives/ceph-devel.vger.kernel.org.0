Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAF9426818
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Oct 2021 12:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbhJHKoL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Oct 2021 06:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240019AbhJHKoC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 06:44:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CEE160F4A;
        Fri,  8 Oct 2021 10:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633689727;
        bh=bqdgFMEFkncGHtDEtFpC8t7oHibYPVZH4EeQ1goO/J0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fo2Tzh6ufD3ym8HO+ZOQgW4TSPXzhMOLOabsDyq44pdOc158XHKVx4wEajH6KmxZL
         zxlVnnlDjXePsf6RVY5z6S7l1W8tl0uf8EsC8yTIInBIy4zKjNcN0W5H6D88fYUdHb
         HlekKRfKAD5u0sSlaOXzD/e38kSv8/4BuIHORwtAZ3UtQd/yK6hVAEcd3CGb5psEBY
         iZ362FS2hUByUv5Tp6NAuF7k6HTrhHJRH+ul2FSKQxKi9NFWqiiqYzuRm+ubbEeOUG
         1g1YjZjmnkg/GNtcgEFv9+44/ftTx5ejr+iTsyq0sZxHfYOPNPO/dBpWuzMuJZBM5Z
         U5ivIS2qfg+LQ==
Message-ID: <354c7279c15bc9fd037d6ab29a51387d2cf12a28.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: ignore the truncate when size won't change
 with Fx caps ssued
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 08 Oct 2021 06:42:06 -0400
In-Reply-To: <20211008082358.679074-1-xiubli@redhat.com>
References: <20211008082358.679074-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-10-08 at 16:23 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the new size is the same with current size, the MDS will do nothing
> except changing the mtime/atime. The posix doesn't mandate that the
> filesystems must update them. So just ignore it.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 23b5a0867e3a..81a7b342fae7 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2105,12 +2105,14 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
>  		loff_t isize = i_size_read(inode);
>  
>  		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
> -		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size > isize) {
> -			i_size_write(inode, attr->ia_size);
> -			inode->i_blocks = calc_inode_blocks(attr->ia_size);
> -			ci->i_reported_size = attr->ia_size;
> -			dirtied |= CEPH_CAP_FILE_EXCL;
> -			ia_valid |= ATTR_MTIME;
> +		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
> +			if (attr->ia_size > isize) {
> +				i_size_write(inode, attr->ia_size);
> +				inode->i_blocks = calc_inode_blocks(attr->ia_size);
> +				ci->i_reported_size = attr->ia_size;
> +				dirtied |= CEPH_CAP_FILE_EXCL;
> +				ia_valid |= ATTR_MTIME;
> +			}
>  		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
>  			   attr->ia_size != isize) {
>  			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);

Thanks Xiubo, looks good. Merged into testing.

-- 
Jeff Layton <jlayton@kernel.org>

