Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DE02ADA8B
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 16:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732411AbgKJPiV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 10:38:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730511AbgKJPiU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 10:38:20 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A5DE2076E;
        Tue, 10 Nov 2020 15:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605022699;
        bh=tszIh52InYzbHm2jJuK3EJDM2cm9p3Zo127FHVeh45s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e0dtn/GBjrmNgfye8Oz5ju5OwRsXfZXW4RMafEYVef2Gzoi7e7If0WMm/KrSi/gFT
         gXr0G1VwIXhSV7QdSDmGyzbqC9eWozl8rNsDcTUIo1YS+eb8DCV3pFxGw9HeYA0M0c
         tr7YhC161ypzwtfESg6kNRAGMMYTilxSIe1NUE34=
Message-ID: <c2497a831c8c28b7f5acdc2bf5aee9812b6e5ce1.camel@kernel.org>
Subject: Re: [PATCH] ceph: ensure we have Fs caps when fetching dir link
 count
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Nov 2020 10:38:18 -0500
In-Reply-To: <20201110120302.13992-1-jlayton@kernel.org>
References: <20201110120302.13992-1-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-11-10 at 07:03 -0500, Jeff Layton wrote:
> The link count for a directory is defined as inode->i_subdirs + 2,
> (for "." and ".."). i_subdirs is only populated when Fs caps are held.
> Ensure we grab Fs caps when fetching the link count for a directory.
> 
> URL: https://tracker.ceph.com/issues/48125
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/inode.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 7c22bc2ea076..9ba15ca6b010 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2343,15 +2343,22 @@ int ceph_permission(struct inode *inode, int mask)
>  }
>  
> 
> 
> 
>  /* Craft a mask of needed caps given a set of requested statx attrs. */
> -static int statx_to_caps(u32 want)
> +static int statx_to_caps(u32 want, umode_t mode)
>  {
>  	int mask = 0;
>  
> 
> 
> 
>  	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME))
>  		mask |= CEPH_CAP_AUTH_SHARED;
>  
> 
> 
> 
> -	if (want & (STATX_NLINK|STATX_CTIME))
> +	if (want & (STATX_NLINK|STATX_CTIME)) {
>  		mask |= CEPH_CAP_LINK_SHARED;
> +		/*
> +		 * The link count for directories depends on inode->i_subdirs,
> +		 * and that is only updated when Fs caps are held.
> +		 */
> +		if (S_ISDIR(mode))
> +			mask |= CEPH_CAP_FILE_SHARED;
> +	}

I think I'm going to make a small change here and make this not set the
Ls bit on directories. There really is no need for it since only care
about i_subdirs, and that might prevent having to do a synchronous call
to the MDS.

>  
> 
> 
> 
>  	if (want & (STATX_ATIME|STATX_MTIME|STATX_CTIME|STATX_SIZE|
>  		    STATX_BLOCKS))
> @@ -2377,7 +2384,7 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
>  
> 
> 
> 
>  	/* Skip the getattr altogether if we're asked not to sync */
>  	if (!(flags & AT_STATX_DONT_SYNC)) {
> -		err = ceph_do_getattr(inode, statx_to_caps(request_mask),
> +		err = ceph_do_getattr(inode, statx_to_caps(request_mask, inode->i_mode),
>  				      flags & AT_STATX_FORCE_SYNC);
>  		if (err)
>  			return err;

-- 
Jeff Layton <jlayton@kernel.org>

