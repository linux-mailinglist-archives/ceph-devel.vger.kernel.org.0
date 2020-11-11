Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEAE2AEDDD
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 10:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgKKJeD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Nov 2020 04:34:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:43048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgKKJeC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 04:34:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B1CEFABD6;
        Wed, 11 Nov 2020 09:34:01 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 44934b85;
        Wed, 11 Nov 2020 09:34:14 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, pdonnell@redhat.com
Subject: Re: [PATCH v2] ceph: ensure we have Fs caps when fetching dir link
 count
References: <20201110163052.482965-1-jlayton@kernel.org>
Date:   Wed, 11 Nov 2020 09:34:13 +0000
In-Reply-To: <20201110163052.482965-1-jlayton@kernel.org> (Jeff Layton's
        message of "Tue, 10 Nov 2020 11:30:52 -0500")
Message-ID: <877dqsfd9m.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> The link count for a directory is defined as inode->i_subdirs + 2,
> (for "." and ".."). i_subdirs is only populated when Fs caps are held.
> Ensure we grab Fs caps when fetching the link count for a directory.
>

Maybe this would be worth a stable@ tag too...?

Cheers,
-- 
Luis

> URL: https://tracker.ceph.com/issues/48125
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/inode.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 7c22bc2ea076..ab02966ef0a4 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2343,15 +2343,23 @@ int ceph_permission(struct inode *inode, int mask)
>  }
>  
>  /* Craft a mask of needed caps given a set of requested statx attrs. */
> -static int statx_to_caps(u32 want)
> +static int statx_to_caps(u32 want, umode_t mode)
>  {
>  	int mask = 0;
>  
>  	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME))
>  		mask |= CEPH_CAP_AUTH_SHARED;
>  
> -	if (want & (STATX_NLINK|STATX_CTIME))
> -		mask |= CEPH_CAP_LINK_SHARED;
> +	if (want & (STATX_NLINK|STATX_CTIME)) {
> +		/*
> +		 * The link count for directories depends on inode->i_subdirs,
> +		 * and that is only updated when Fs caps are held.
> +		 */
> +		if (S_ISDIR(mode))
> +			mask |= CEPH_CAP_FILE_SHARED;
> +		else
> +			mask |= CEPH_CAP_LINK_SHARED;
> +	}
>  
>  	if (want & (STATX_ATIME|STATX_MTIME|STATX_CTIME|STATX_SIZE|
>  		    STATX_BLOCKS))
> @@ -2377,7 +2385,7 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
>  
>  	/* Skip the getattr altogether if we're asked not to sync */
>  	if (!(flags & AT_STATX_DONT_SYNC)) {
> -		err = ceph_do_getattr(inode, statx_to_caps(request_mask),
> +		err = ceph_do_getattr(inode, statx_to_caps(request_mask, inode->i_mode),
>  				      flags & AT_STATX_FORCE_SYNC);
>  		if (err)
>  			return err;

