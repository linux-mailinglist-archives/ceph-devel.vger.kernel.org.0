Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29486241A43
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Aug 2020 13:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgHKLUE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Aug 2020 07:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbgHKLUA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 07:20:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0EF520716;
        Tue, 11 Aug 2020 11:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597144796;
        bh=Ia1+jx8TGnCM0rhnf6SQW9uRQhXnAdtA+6ogA1l/NuI=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=gKiEEK03UhvBBYTAIaw5I5VEmHJJSZqsZBPt53qBg0nfh4kGVWD0pCf4+FPqb+egq
         Q1ZXobLxAkYHBBoPyAT6QXKSAR15b3SgjPhpCLitqtIFCWpBcnZNir+AF6HCfOLu3C
         PzEsVuAc24+ZTUxnsmM5ifonto+47MjQhsxHhbGg=
Message-ID: <c922749969ec0a070db8da1d924cd8da0aefbf45.camel@kernel.org>
Subject: Re: [PATCH] ceph: encode inodes' parent/d_name in cap reconnect
 message
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Tue, 11 Aug 2020 07:19:55 -0400
In-Reply-To: <20200811072303.24322-1-zyan@redhat.com>
References: <20200811072303.24322-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-08-11 at 15:23 +0800, Yan, Zheng wrote:
> Since nautilus, MDS tracks dirfrags whose child inodes have caps in open
> file table. When MDS recovers, it prefetches all of these dirfrags. This
> avoids using backtrace to load inodes. But dirfrags prefetch may load
> lots of useless inodes into cache, and make MDS run out of memory.
> 
> Recent MDS adds an option that disables dirfrags prefetch. When dirfrags
> prefetch is disabled. Recovering MDS only prefetches corresponding dir
> inodes. Including inodes' parent/d_name in cap reconnect message can
> help MDS to load inodes into its cache.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/mds_client.c | 89 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 61 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9a09d12569bd..4eaed12b4b4c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3553,6 +3553,39 @@ static int send_reconnect_partial(struct ceph_reconnect_state *recon_state)
>  	return err;
>  }
>  
> +static struct dentry* d_find_primary(struct inode *inode)
> +{
> +	struct dentry *alias, *dn = NULL;
> +
> +	if (hlist_empty(&inode->i_dentry))
> +		return NULL;
> +
> +	spin_lock(&inode->i_lock);
> +	if (hlist_empty(&inode->i_dentry))
> +		goto out_unlock;
> +
> +	if (S_ISDIR(inode->i_mode)) {
> +		alias = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
> +		if (!IS_ROOT(alias))
> +			dn = dget(alias);
> +		goto out_unlock;
> +	}
> +
> +	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
> +		spin_lock(&alias->d_lock);
> +		if (!d_unhashed(alias) &&
> +		    (ceph_dentry(alias)->flags & CEPH_DENTRY_PRIMARY_LINK)) {
> +			dn = dget_dlock(alias);
> +		}
> +		spin_unlock(&alias->d_lock);
> +		if (dn)
> +			break;
> +	}
> +out_unlock:
> +	spin_unlock(&inode->i_lock);
> +	return dn;
> +}
> +
>  /*
>   * Encode information about a cap for a reconnect with the MDS.
>   */
> @@ -3566,13 +3599,32 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  	struct ceph_inode_info *ci = cap->ci;
>  	struct ceph_reconnect_state *recon_state = arg;
>  	struct ceph_pagelist *pagelist = recon_state->pagelist;
> -	int err;
> +	struct dentry *dentry;
> +	char *path;
> +	int pathlen, err;
> +	u64 pathbase;
>  	u64 snap_follows;
>  
>  	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
>  	     inode, ceph_vinop(inode), cap, cap->cap_id,
>  	     ceph_cap_string(cap->issued));
>  
> +	dentry = d_find_primary(inode);
> +	if (dentry) {
> +		/* set pathbase to parent dir when msg_version >= 2 */
> +		path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
> +					    recon_state->msg_version >= 2);
> +		dput(dentry);
> +		if (IS_ERR(path)) {
> +			err = PTR_ERR(path);
> +			goto out_err;
> +		}
> +	} else {
> +		path = NULL;
> +		pathlen = 0;
> +		pathbase = 0;
> +	}
> +
>  	spin_lock(&ci->i_ceph_lock);
>  	cap->seq = 0;        /* reset cap seq */
>  	cap->issue_seq = 0;  /* and issue_seq */
> @@ -3593,7 +3645,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  		rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
>  		rec.v2.issued = cpu_to_le32(cap->issued);
>  		rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
> -		rec.v2.pathbase = 0;
> +		rec.v2.pathbase = cpu_to_le64(pathbase);
>  		rec.v2.flock_len = (__force __le32)
>  			((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
>  	} else {
> @@ -3604,7 +3656,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  		ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
>  		ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
>  		rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
> -		rec.v1.pathbase = 0;
> +		rec.v1.pathbase = cpu_to_le64(pathbase);
>  	}
>  
>  	if (list_empty(&ci->i_cap_snaps)) {
> @@ -3666,7 +3718,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  			    sizeof(struct ceph_filelock);
>  		rec.v2.flock_len = cpu_to_le32(struct_len);
>  
> -		struct_len += sizeof(u32) + sizeof(rec.v2);
> +		struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
>  
>  		if (struct_v >= 2)
>  			struct_len += sizeof(u64); /* snap_follows */
> @@ -3690,7 +3742,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  			ceph_pagelist_encode_8(pagelist, 1);
>  			ceph_pagelist_encode_32(pagelist, struct_len);
>  		}
> -		ceph_pagelist_encode_string(pagelist, NULL, 0);
> +		ceph_pagelist_encode_string(pagelist, path, pathlen);
>  		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
>  		ceph_locks_to_pagelist(flocks, pagelist,
>  				       num_fcntl_locks, num_flock_locks);
> @@ -3699,39 +3751,20 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  out_freeflocks:
>  		kfree(flocks);
>  	} else {
> -		u64 pathbase = 0;
> -		int pathlen = 0;
> -		char *path = NULL;
> -		struct dentry *dentry;
> -
> -		dentry = d_find_alias(inode);
> -		if (dentry) {
> -			path = ceph_mdsc_build_path(dentry,
> -						&pathlen, &pathbase, 0);
> -			dput(dentry);
> -			if (IS_ERR(path)) {
> -				err = PTR_ERR(path);
> -				goto out_err;
> -			}
> -			rec.v1.pathbase = cpu_to_le64(pathbase);
> -		}
> -
>  		err = ceph_pagelist_reserve(pagelist,
>  					    sizeof(u64) + sizeof(u32) +
>  					    pathlen + sizeof(rec.v1));
> -		if (err) {
> -			goto out_freepath;
> -		}
> +		if (err)
> +			goto out_err;
>  
>  		ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
>  		ceph_pagelist_encode_string(pagelist, path, pathlen);
>  		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
> -out_freepath:
> -		ceph_mdsc_free_path(path, pathlen);
>  	}
>  
>  out_err:
> -	if (err >= 0)
> +	ceph_mdsc_free_path(path, pathlen);
> +	if (!err)
>  		recon_state->nr_caps++;
>  	return err;
>  }

Looks good. Merged into testing.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

