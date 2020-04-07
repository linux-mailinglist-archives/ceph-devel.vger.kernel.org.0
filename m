Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7141A0ACB
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Apr 2020 12:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgDGKIZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Apr 2020 06:08:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:38660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgDGKIZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 06:08:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 48708AE09;
        Tue,  7 Apr 2020 10:08:21 +0000 (UTC)
Date:   Tue, 7 Apr 2020 11:08:42 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Zheng Yan <zyan@redhat.com>, Frank Schilder <frans@dtu.dk>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ceph: allow rename operation under different quota
 realms
Message-ID: <20200407100842.GA19111@suse.com>
References: <20200406151201.32432-1-lhenriques@suse.com>
 <20200406151201.32432-3-lhenriques@suse.com>
 <538e31d9f231fbc09500c92929ef7a3cc516377f.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <538e31d9f231fbc09500c92929ef7a3cc516377f.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 06, 2020 at 04:05:01PM -0400, Jeff Layton wrote:
> On Mon, 2020-04-06 at 16:12 +0100, Luis Henriques wrote:
> > Returning -EXDEV when trying to 'mv' files/directories from different
> > quota realms results in copy+unlink operations instead of the faster
> > CEPH_MDS_OP_RENAME.  This will occur even when there aren't any quotas
> > set in the destination directory, or if there's enough space left for
> > the new file(s).
> > 
> > This patch adds a new helper function to be called on rename operations
> > which will allow these operations if they can be executed.  This patch
> > mimics userland fuse client commit b8954e5734b3 ("client:
> > optimize rename operation under different quota root").
> > 
> > Since ceph_quota_is_same_realm() is now called only from this new
> > helper, make it static.
> > 
> > URL: https://tracker.ceph.com/issues/44791
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> >  fs/ceph/dir.c   |  9 ++++----
> >  fs/ceph/quota.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/ceph/super.h |  3 ++-
> >  3 files changed, 64 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index d0cd0aba5843..9d3f0062d800 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -1099,11 +1099,12 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
> >  			op = CEPH_MDS_OP_RENAMESNAP;
> >  		else
> >  			return -EROFS;
> > +	} else {
> > +		err = ceph_quota_check_rename(mdsc, d_inode(old_dentry),
> > +					      new_dir);
> 
> I was wondering why not use "old_dir" here, but I think this is more
> correct. I guess a directory could have a different quotarealm from its
> parent?

Yes, you can set, for example, ceph.quota.max_files to in a directory, and
set it again in a subdirectory; this subdirectory will now be on a
different quotarealm.

> 
> > +		if (err)
> > +			return err;
> >  	}
> > -	/* don't allow cross-quota renames */
> > -	if ((old_dir != new_dir) &&
> > -	    (!ceph_quota_is_same_realm(old_dir, new_dir)))
> > -		return -EXDEV;
> >  
> >  	dout("rename dir %p dentry %p to dir %p dentry %p\n",
> >  	     old_dir, old_dentry, new_dir, new_dentry);
> > diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> > index c5c8050f0f99..a6dd1a528c70 100644
> > --- a/fs/ceph/quota.c
> > +++ b/fs/ceph/quota.c
> > @@ -264,7 +264,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
> >  	return NULL;
> >  }
> >  
> > -bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
> > +static bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
> >  {
> >  	struct ceph_mds_client *mdsc = ceph_inode_to_client(old)->mdsc;
> >  	struct ceph_snap_realm *old_realm, *new_realm;
> > @@ -516,3 +516,59 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
> >  	return is_updated;
> >  }
> >  
> > +/*
> > + * ceph_quota_check_rename - check if a rename can be executed
> > + * @mdsc:	MDS client instance
> > + * @old:	inode to be copied
> > + * @new:	destination inode (directory)
> > + *
> > + * This function verifies if a rename (e.g. moving a file or directory) can be
> > + * executed.  It forces an rstat update in the @new target directory (and in the
> > + * source @old as well, if it's a directory).  The actual check is done both for
> > + * max_files and max_bytes.
> > + *
> > + * This function returns 0 if it's OK to do the rename, or, if quotas are
> > + * exceeded, -EXDEV (if @old is a directory) or -EDQUOT.
> > + */
> > +int ceph_quota_check_rename(struct ceph_mds_client *mdsc,
> > +			    struct inode *old, struct inode *new)
> > +{
> > +	struct ceph_inode_info *ci_old = ceph_inode(old);
> > +	int ret = 0;
> > +
> > +	if ((old == new) || (ceph_quota_is_same_realm(old, new)))
> > +		return 0;
> > +
> 
> "old" represents the old dentry being moved. "new" is the new parent
> dir. Do we need to test for old == new? The vfs won't allow the source
> to be the ancestor of the target (or vice versa). From vfs_rename():
> 
>         /* source should not be ancestor of target */
>         error = -EINVAL;
>         if (old_dentry == trap)
>                 goto exit5;
>         /* target should not be an ancestor of source */
>         if (!(flags & RENAME_EXCHANGE))
>                 error = -ENOTEMPTY;
> 

Err... yeah, that 'old == new' is a mistake.  I just wanted to keep the
optimization in the original code:

	if ((old_dir != new_dir) &&
	    (!ceph_quota_is_same_realm(old_dir, new_dir)))
		return -EXDEV;

I'll send out v2 in a minute with the following change to ceph_rename:

	} else if (old_dir != new_dir) {
		err = ceph_quota_check_rename(mdsc, d_inode(old_dentry),
					      new_dir);

Cheers,
--
Luís


> > +	/*
> > +	 * Get the latest rstat for target directory (and for source, if a
> > +	 * directory)
> > +	 */
> > +	ret = ceph_do_getattr(new, CEPH_STAT_RSTAT, false);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (S_ISDIR(old->i_mode)) {
> > +		ret = ceph_do_getattr(old, CEPH_STAT_RSTAT, false);
> > +		if (ret)
> > +			return ret;
> > +		ret = check_quota_exceeded(new, QUOTA_CHECK_MAX_BYTES_OP,
> > +					   ci_old->i_rbytes);
> > +		if (!ret)
> > +			ret = check_quota_exceeded(new,
> > +						   QUOTA_CHECK_MAX_FILES_OP,
> > +						   ci_old->i_rfiles +
> > +						   ci_old->i_rsubdirs);
> > +		if (ret)
> > +			ret = -EXDEV;
> > +	} else {
> > +		ret = check_quota_exceeded(new, QUOTA_CHECK_MAX_BYTES_OP,
> > +					   i_size_read(old));
> > +		if (!ret)
> > +			ret = check_quota_exceeded(new,
> > +						   QUOTA_CHECK_MAX_FILES_OP, 1);
> > +		if (ret)
> > +			ret = -EDQUOT;
> > +	}
> > +
> > +	return ret;
> > +}
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 037cdfb2ad4f..d5853831a6b5 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -1175,13 +1175,14 @@ extern void ceph_handle_quota(struct ceph_mds_client *mdsc,
> >  			      struct ceph_mds_session *session,
> >  			      struct ceph_msg *msg);
> >  extern bool ceph_quota_is_max_files_exceeded(struct inode *inode);
> > -extern bool ceph_quota_is_same_realm(struct inode *old, struct inode *new);
> >  extern bool ceph_quota_is_max_bytes_exceeded(struct inode *inode,
> >  					     loff_t newlen);
> >  extern bool ceph_quota_is_max_bytes_approaching(struct inode *inode,
> >  						loff_t newlen);
> >  extern bool ceph_quota_update_statfs(struct ceph_fs_client *fsc,
> >  				     struct kstatfs *buf);
> > +extern int ceph_quota_check_rename(struct ceph_mds_client *mdsc,
> > +				   struct inode *old, struct inode *new);
> >  extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc);
> >  
> >  #endif /* _FS_CEPH_SUPER_H */
> 
> Looks good otherwise. Nice work!
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
