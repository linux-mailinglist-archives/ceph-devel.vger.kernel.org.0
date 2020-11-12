Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C38A2B0A0D
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 17:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgKLQeL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 11:34:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgKLQeL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 11:34:11 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A512100A;
        Thu, 12 Nov 2020 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605198850;
        bh=BWH/5RK3bhbqeyFgF9B8m4fJtj/VbbeDUvPgso3PLhQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZZTj7IdcUtPHh3u8Ki1PzJrK2/mHJbjGyuu3UEEkrp7JDCPTtitiJBWgL3JNJHu6j
         AwhYRFzszwTj/YrSK86hLO5/FIIqE/DrTHsQSpcKr1eeocyPh9ufAjtU2bVn13IbD3
         6pmcu0VlgeFgwLB3TPP6AZyopNi9qU/hP/CptyJU=
Message-ID: <fd770ab57aeabc60d42690272aa0e15b3e6b4e43.camel@kernel.org>
Subject: Re: [PATCH] Revert "ceph: allow rename operation under different
 quota realms"
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 11:34:08 -0500
In-Reply-To: <20201112152321.32491-1-lhenriques@suse.de>
References: <87ft5ed3gj.fsf@suse.de>
         <20201112152321.32491-1-lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-11-12 at 15:23 +0000, Luis Henriques wrote:
> This reverts commit dffdcd71458e699e839f0bf47c3d42d64210b939.
> 
> When doing a rename across quota realms, there's a corner case that isn't
> handled correctly.  Here's a testcase:
> 
>   mkdir files limit
>   truncate files/file -s 10G
>   setfattr limit -n ceph.quota.max_bytes -v 1000000
>   mv files limit/
> 
> The above will succeed because ftruncate(2) won't immediately notify the
> MDSs with the new file size, and thus the quota realms stats won't be
> updated.
> 
> Since the possible fixes for this issue would have a huge performance impact,
> the solution for now is to simply revert to returning -EXDEV when doing a cross
> quota realms rename.
> 
> URL: https://tracker.ceph.com/issues/48203
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/dir.c   |  9 ++++----
>  fs/ceph/quota.c | 58 +------------------------------------------------
>  fs/ceph/super.h |  3 +--
>  3 files changed, 6 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index a4d48370b2b3..858ee7362ff5 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1202,12 +1202,11 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
>  			op = CEPH_MDS_OP_RENAMESNAP;
>  		else
>  			return -EROFS;
> -	} else if (old_dir != new_dir) {
> -		err = ceph_quota_check_rename(mdsc, d_inode(old_dentry),
> -					      new_dir);
> -		if (err)
> -			return err;
>  	}
> +	/* don't allow cross-quota renames */
> +	if ((old_dir != new_dir) &&
> +	    (!ceph_quota_is_same_realm(old_dir, new_dir)))
> +		return -EXDEV;
>  
> 
>  	dout("rename dir %p dentry %p to dir %p dentry %p\n",
>  	     old_dir, old_dentry, new_dir, new_dentry);
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 9b785f11e95a..4e32c9600ecc 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -264,7 +264,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
>  	return NULL;
>  }
>  
> 
> -static bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
> +bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
>  {
>  	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old->i_sb);
>  	struct ceph_snap_realm *old_realm, *new_realm;
> @@ -516,59 +516,3 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>  	return is_updated;
>  }
>  
> 
> -/*
> - * ceph_quota_check_rename - check if a rename can be executed
> - * @mdsc:	MDS client instance
> - * @old:	inode to be copied
> - * @new:	destination inode (directory)
> - *
> - * This function verifies if a rename (e.g. moving a file or directory) can be
> - * executed.  It forces an rstat update in the @new target directory (and in the
> - * source @old as well, if it's a directory).  The actual check is done both for
> - * max_files and max_bytes.
> - *
> - * This function returns 0 if it's OK to do the rename, or, if quotas are
> - * exceeded, -EXDEV (if @old is a directory) or -EDQUOT.
> - */
> -int ceph_quota_check_rename(struct ceph_mds_client *mdsc,
> -			    struct inode *old, struct inode *new)
> -{
> -	struct ceph_inode_info *ci_old = ceph_inode(old);
> -	int ret = 0;
> -
> -	if (ceph_quota_is_same_realm(old, new))
> -		return 0;
> -
> -	/*
> -	 * Get the latest rstat for target directory (and for source, if a
> -	 * directory)
> -	 */
> -	ret = ceph_do_getattr(new, CEPH_STAT_RSTAT, false);
> -	if (ret)
> -		return ret;
> -
> -	if (S_ISDIR(old->i_mode)) {
> -		ret = ceph_do_getattr(old, CEPH_STAT_RSTAT, false);
> -		if (ret)
> -			return ret;
> -		ret = check_quota_exceeded(new, QUOTA_CHECK_MAX_BYTES_OP,
> -					   ci_old->i_rbytes);
> -		if (!ret)
> -			ret = check_quota_exceeded(new,
> -						   QUOTA_CHECK_MAX_FILES_OP,
> -						   ci_old->i_rfiles +
> -						   ci_old->i_rsubdirs);
> -		if (ret)
> -			ret = -EXDEV;
> -	} else {
> -		ret = check_quota_exceeded(new, QUOTA_CHECK_MAX_BYTES_OP,
> -					   i_size_read(old));
> -		if (!ret)
> -			ret = check_quota_exceeded(new,
> -						   QUOTA_CHECK_MAX_FILES_OP, 1);
> -		if (ret)
> -			ret = -EDQUOT;
> -	}
> -
> -	return ret;
> -}
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 482473e4cce1..8dbb0babddea 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1222,14 +1222,13 @@ extern void ceph_handle_quota(struct ceph_mds_client *mdsc,
>  			      struct ceph_mds_session *session,
>  			      struct ceph_msg *msg);
>  extern bool ceph_quota_is_max_files_exceeded(struct inode *inode);
> +extern bool ceph_quota_is_same_realm(struct inode *old, struct inode *new);
>  extern bool ceph_quota_is_max_bytes_exceeded(struct inode *inode,
>  					     loff_t newlen);
>  extern bool ceph_quota_is_max_bytes_approaching(struct inode *inode,
>  						loff_t newlen);
>  extern bool ceph_quota_update_statfs(struct ceph_fs_client *fsc,
>  				     struct kstatfs *buf);
> -extern int ceph_quota_check_rename(struct ceph_mds_client *mdsc,
> -				   struct inode *old, struct inode *new);
>  extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc);
>  
> 
>  #endif /* _FS_CEPH_SUPER_H */

Ok, looks reasonable for now. I'll note that we probably _could_ allow
for cross-quota renames of regular files since we know that we're only
dealing with a single inode.

That said, it might be weird to see EXDEV on a directory but not a
regular file in the same parent dir.
-- 
Jeff Layton <jlayton@kernel.org>

