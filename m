Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC58534E97C
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Mar 2021 15:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhC3NpK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Mar 2021 09:45:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:52058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhC3Now (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 09:44:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66C0AB1D7;
        Tue, 30 Mar 2021 13:44:51 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id dc74a1bf;
        Tue, 30 Mar 2021 13:46:11 +0000 (UTC)
Date:   Tue, 30 Mar 2021 14:46:11 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH] ceph: fix inode leak on getattr error in __fh_to_dentry
Message-ID: <YGMro0mhz1sIk7Q8@suse.de>
References: <20210326154032.86410-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210326154032.86410-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Mar 26, 2021 at 11:40:32AM -0400, Jeff Layton wrote:
> Cc: Luis Henriques <lhenriques@suse.de>
> Fixes: 878dabb64117 (ceph: don't return -ESTALE if there's still an open file)
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/export.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index f22156ee7306..17d8c8f4ec89 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -178,8 +178,10 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>  		return ERR_CAST(inode);
>  	/* We need LINK caps to reliably check i_nlink */
>  	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
> -	if (err)
> +	if (err) {
> +		iput(inode);

To be honest, I'm failing to see where we could be leaking the inode here.
We're trying to get LINK caps to do the check bellow; if ceph_do_getattr()
fails, the inode reference it (may) grabs will be released by calling
ceph_mdsc_put_request().

Do you see any other possibility?

Cheers,
--
Luís


>  		return ERR_PTR(err);
> +	}
>  	/* -ESTALE if inode as been unlinked and no file is open */
>  	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
>  		iput(inode);
> -- 
> 2.30.2
> 
