Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A832F72FB9
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 15:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfGXNTQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 09:19:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:45726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727528AbfGXNTQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 09:19:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A4CFAE8C;
        Wed, 24 Jul 2019 13:19:14 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     "Jeff Layton" <jlayton@kernel.org>
Cc:     <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH] ceph: have copy op fall back when src_inode == dst_inode
References: <20190724120542.26391-1-jlayton@kernel.org>
Date:   Wed, 24 Jul 2019 14:19:13 +0100
In-Reply-To: <20190724120542.26391-1-jlayton@kernel.org> (Jeff Layton's
        message of "Wed, 24 Jul 2019 08:05:42 -0400")
Message-ID: <87tvbb4lke.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

"Jeff Layton" <jlayton@kernel.org> writes:

> Currently this just fails, but the fallback implementation can handle
> this case. Change it to return -EOPNOTSUPP instead of -EINVAL when
> copying data to a different spot in the same inode.

Thanks, Jeff!

So, just FTR (we had a quick chat on IRC already): I have a slightly
different patch sitting on my tree for a while.  The difference is that
my patch still allows to use the 'copy-from' operation in some cases,
even when src == dst.

I'll run a few more tests on it and send it out soon.

Cheers,
-- 
Luis


>
> Cc: Luis Henriques <lhenriques@suse.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> NB: with this patch, xfstest generic/075 now passes
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 82af4a3c714d..1b25df9d5853 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1915,8 +1915,6 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  
>  	if (src_inode->i_sb != dst_inode->i_sb)
>  		return -EXDEV;
> -	if (src_inode == dst_inode)
> -		return -EINVAL;
>  	if (ceph_snap(dst_inode) != CEPH_NOSNAP)
>  		return -EROFS;
>  
> @@ -1928,6 +1926,10 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	 * efficient).
>  	 */
>  
> +	/* Can't do OSD copy op to same object */
> +	if (src_inode == dst_inode)
> +		return -EOPNOTSUPP;
> +
>  	if (ceph_test_mount_opt(ceph_inode_to_client(src_inode), NOCOPYFROM))
>  		return -EOPNOTSUPP;
