Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32D81A186B
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 00:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDGW5y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Apr 2020 18:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgDGW5y (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 18:57:54 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30507206C0;
        Tue,  7 Apr 2020 22:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586300272;
        bh=kxC2yjbONA5gg6JjZg6K/Xqs3rQbnojBnZBYqUEU0xA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KQfuLHOa9pd2NH3A+Xqhc38dv/oHodgyhPMUQGi0254hMCHVoIZKUIop/U0vpsK6k
         AXfKmaYZDj2a55KyJ6SAx+s3F1gI7VKtaQ6MXqO25Gr4/kFtUoHx/bb9J6aDJt/yex
         wbZV6q9wJRrQ+Qcc6ai0ct4b8rHnGBwX24FeyKkw=
Message-ID: <e32db4ef5a0ae4e2002a3d957491c88e49daa5bb.camel@kernel.org>
Subject: Re: [PATCH v2 2/2] ceph: allow rename operation under different
 quota realms
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Cc:     Frank Schilder <frans@dtu.dk>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Apr 2020 18:57:50 -0400
In-Reply-To: <20200407103020.22588-3-lhenriques@suse.com>
References: <20200407103020.22588-1-lhenriques@suse.com>
         <20200407103020.22588-3-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-04-07 at 11:30 +0100, Luis Henriques wrote:
> Returning -EXDEV when trying to 'mv' files/directories from different
> quota realms results in copy+unlink operations instead of the faster
> CEPH_MDS_OP_RENAME.  This will occur even when there aren't any quotas
> set in the destination directory, or if there's enough space left for
> the new file(s).
> 
> This patch adds a new helper function to be called on rename operations
> which will allow these operations if they can be executed.  This patch
> mimics userland fuse client commit b8954e5734b3 ("client:
> optimize rename operation under different quota root").
> 
> Since ceph_quota_is_same_realm() is now called only from this new
> helper, make it static.
> 
> URL: https://tracker.ceph.com/issues/44791
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/dir.c   |  9 ++++----
>  fs/ceph/quota.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/ceph/super.h |  3 ++-
>  3 files changed, 64 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index d0cd0aba5843..23f0345611a3 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1099,11 +1099,12 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
>  			op = CEPH_MDS_OP_RENAMESNAP;
>  		else
>  			return -EROFS;
> +	} else if (old_dir != new_dir) {
> +		err = ceph_quota_check_rename(mdsc, d_inode(old_dentry),
> +					      new_dir);
> +		if (err)
> +			return err;
>  	}
> -	/* don't allow cross-quota renames */
> -	if ((old_dir != new_dir) &&
> -	    (!ceph_quota_is_same_realm(old_dir, new_dir)))
> -		return -EXDEV;
>  
>  	dout("rename dir %p dentry %p to dir %p dentry %p\n",
>  	     old_dir, old_dentry, new_dir, new_dentry);
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index c5c8050f0f99..9e82704a9f7b 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -264,7 +264,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
>  	return NULL;
>  }
>  
> -bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
> +static bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
>  {
>  	struct ceph_mds_client *mdsc = ceph_inode_to_client(old)->mdsc;
>  	struct ceph_snap_realm *old_realm, *new_realm;
> @@ -516,3 +516,59 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>  	return is_updated;
>  }
>  
> +/*
> + * ceph_quota_check_rename - check if a rename can be executed
> + * @mdsc:	MDS client instance
> + * @old:	inode to be copied
> + * @new:	destination inode (directory)
> + *
> + * This function verifies if a rename (e.g. moving a file or directory) can be
> + * executed.  It forces an rstat update in the @new target directory (and in the
> + * source @old as well, if it's a directory).  The actual check is done both for
> + * max_files and max_bytes.
> + *
> + * This function returns 0 if it's OK to do the rename, or, if quotas are
> + * exceeded, -EXDEV (if @old is a directory) or -EDQUOT.
> + */
> +int ceph_quota_check_rename(struct ceph_mds_client *mdsc,
> +			    struct inode *old, struct inode *new)
> +{
> +	struct ceph_inode_info *ci_old = ceph_inode(old);
> +	int ret = 0;
> +
> +	if (ceph_quota_is_same_realm(old, new))
> +		return 0;
> +
> +	/*
> +	 * Get the latest rstat for target directory (and for source, if a
> +	 * directory)
> +	 */
> +	ret = ceph_do_getattr(new, CEPH_STAT_RSTAT, false);
> +	if (ret)
> +		return ret;
> +
> +	if (S_ISDIR(old->i_mode)) {
> +		ret = ceph_do_getattr(old, CEPH_STAT_RSTAT, false);
> +		if (ret)
> +			return ret;
> +		ret = check_quota_exceeded(new, QUOTA_CHECK_MAX_BYTES_OP,
> +					   ci_old->i_rbytes);
> +		if (!ret)
> +			ret = check_quota_exceeded(new,
> +						   QUOTA_CHECK_MAX_FILES_OP,
> +						   ci_old->i_rfiles +
> +						   ci_old->i_rsubdirs);

Somewhat idle curiosity, but what happens with hardlinked files where
one dentry is in one quota domain and another is in a different one?
Does it stay in the old quotarealm?

In any case, this is likely fine as non-hardlinked files are the
pessimal case anyway.

> +		if (ret)
> +			ret = -EXDEV;
> +	} else {
> +		ret = check_quota_exceeded(new, QUOTA_CHECK_MAX_BYTES_OP,
> +					   i_size_read(old));
> +		if (!ret)
> +			ret = check_quota_exceeded(new,
> +						   QUOTA_CHECK_MAX_FILES_OP, 1);
> +		if (ret)
> +			ret = -EDQUOT;
> +	}
> +
> +	return ret;
> +}
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 037cdfb2ad4f..d5853831a6b5 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1175,13 +1175,14 @@ extern void ceph_handle_quota(struct ceph_mds_client *mdsc,
>  			      struct ceph_mds_session *session,
>  			      struct ceph_msg *msg);
>  extern bool ceph_quota_is_max_files_exceeded(struct inode *inode);
> -extern bool ceph_quota_is_same_realm(struct inode *old, struct inode *new);
>  extern bool ceph_quota_is_max_bytes_exceeded(struct inode *inode,
>  					     loff_t newlen);
>  extern bool ceph_quota_is_max_bytes_approaching(struct inode *inode,
>  						loff_t newlen);
>  extern bool ceph_quota_update_statfs(struct ceph_fs_client *fsc,
>  				     struct kstatfs *buf);
> +extern int ceph_quota_check_rename(struct ceph_mds_client *mdsc,
> +				   struct inode *old, struct inode *new);
>  extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc);
>  
>  #endif /* _FS_CEPH_SUPER_H */

-- 
Jeff Layton <jlayton@kernel.org>

