Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B44167F48
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 14:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgBUNwL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 08:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbgBUNwL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 08:52:11 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA547208C4;
        Fri, 21 Feb 2020 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582293129;
        bh=7Mu/OzH97MBx3EpBedNh7uht1JALxY+fLSPsvGt97mI=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=XUtjA3tPUMT+7UeViRl2kGeKv0A16JjLXQoYvJfrzpKZlpDmy3bILRT/KseUJ2bbE
         lw90dUmcSIvi1giw+6jNCpo0o/7pcl9ptuqvpTGHYNCjRuv2DJOzfnQb/txnqjgqwu
         TjCjwFxga9365cygsFbnNPcgP006FwrbKQm4L6aE=
Message-ID: <fec874b8fad7ddc34c9ff345eb47a35a74b37bba.camel@kernel.org>
Subject: Re: [PATCH v2 2/4] ceph: consider inode's last read/write when
 calculating wanted caps
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Fri, 21 Feb 2020 08:52:08 -0500
In-Reply-To: <20200221131659.87777-3-zyan@redhat.com>
References: <20200221131659.87777-1-zyan@redhat.com>
         <20200221131659.87777-3-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
> Add i_last_rd and i_last_wr to ceph_inode_info. These two fields are
> used to track inode's last read/write, they are updated when getting
> caps for read/write.
> 
> If there is no read/write on an inode for 'caps_wanted_delay_max'
> seconds, __ceph_caps_file_wanted() does not request caps for read/write
> even there are open files.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/caps.c               | 152 ++++++++++++++++++++++++-----------
>  fs/ceph/file.c               |  21 ++---
>  fs/ceph/inode.c              |  10 ++-
>  fs/ceph/ioctl.c              |   2 +
>  fs/ceph/super.h              |  13 ++-
>  include/linux/ceph/ceph_fs.h |   1 +
>  6 files changed, 139 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 293920d013ff..2a9df235286d 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -971,18 +971,49 @@ int __ceph_caps_used(struct ceph_inode_info *ci)
>  	return used;
>  }
>  
> +#define FMODE_WAIT_BIAS 1000
> +
>  /*
>   * wanted, by virtue of open file modes
>   */
>  int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
>  {
> -	int i, bits = 0;
> -	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
> -		if (ci->i_nr_by_mode[i])
> -			bits |= 1 << i;
> +	struct ceph_mount_options *opt =
> +		ceph_inode_to_client(&ci->vfs_inode)->mount_options;
> +	unsigned long used_cutoff =
> +		round_jiffies(jiffies - opt->caps_wanted_delay_max * HZ);
> +	unsigned long idle_cutoff =
> +		round_jiffies(jiffies - opt->caps_wanted_delay_min * HZ);
> +	int bits = 0;
> +
> +	if (ci->i_nr_by_mode[0] > 0)


Let's not use magic numbers as array indexes here:

    if (ci->i_nr_by_mode[CEPH_FILE_MODE_PIN] > 0)


> +		bits |= CEPH_FILE_MODE_PIN;
> +
> +	if (ci->i_nr_by_mode[1] > 0) {
> +		if (ci->i_nr_by_mode[1] >= FMODE_WAIT_BIAS ||
> +		    time_after(ci->i_last_rd, used_cutoff))
> +			bits |= CEPH_FILE_MODE_RD;
> +	} else if (time_after(ci->i_last_rd, idle_cutoff)) {
> +		bits |= CEPH_FILE_MODE_RD;
> +	}
> +
> +	if (ci->i_nr_by_mode[2] > 0) {
> +		if (ci->i_nr_by_mode[2] >= FMODE_WAIT_BIAS ||
> +		    time_after(ci->i_last_wr, used_cutoff))
> +			bits |= CEPH_FILE_MODE_WR;
> +	} else if (time_after(ci->i_last_wr, idle_cutoff)) {
> +		bits |= CEPH_FILE_MODE_WR;
>  	}
> +
> +	/* check lazyio only when read/write is wanted */
> +	if ((bits & CEPH_FILE_MODE_RDWR) && ci->i_nr_by_mode[3] > 0)
> +		bits |= CEPH_FILE_MODE_LAZY;
> +
>  	if (bits == 0)
>  		return 0;
> +	if (bits == 1 && !S_ISDIR(ci->vfs_inode.i_mode))
> +		return 0;
> +
>  	return ceph_caps_for_mode(bits >> 1);
> 

For the record, this function is really hard to follow just because
sometimes CEPH_FILE_MODE constants are interpreted as discrete values
(like an enum), and other times as set of flags.

It all works out in the end, but I spent several minutes yesterday
convincing myself that the shift right above this was correct. It might
be nice to make this whole function less "clever", if you see a way to
do it.

>  }
>  
> @@ -1021,14 +1052,6 @@ int __ceph_caps_mds_wanted(struct ceph_inode_info *ci, bool check)
>  	return mds_wanted;
>  }
>  
> -/*
> - * called under i_ceph_lock
> - */
> -static int __ceph_is_single_caps(struct ceph_inode_info *ci)
> -{
> -	return rb_first(&ci->i_caps) == rb_last(&ci->i_caps);
> -}
> -
>  int ceph_is_any_caps(struct inode *inode)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> @@ -1856,10 +1879,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  	if (ci->i_ceph_flags & CEPH_I_FLUSH)
>  		flags |= CHECK_CAPS_FLUSH;
>  
> -	if (!(flags & CHECK_CAPS_AUTHONLY) ||
> -	    (ci->i_auth_cap && __ceph_is_single_caps(ci)))
> -		__cap_delay_cancel(mdsc, ci);
> -
>  	goto retry_locked;
>  retry:
>  	spin_lock(&ci->i_ceph_lock);
> @@ -2081,9 +2100,16 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  		goto retry; /* retake i_ceph_lock and restart our cap scan. */
>  	}
>  
> -	/* Reschedule delayed caps release if we delayed anything */
> -	if (delayed)
> -		__cap_delay_requeue(mdsc, ci, false);
> +	if (list_empty(&ci->i_cap_delay_list)) {
> +	    if (delayed) {
> +		    /* Reschedule delayed caps release if we delayed anything */
> +		    __cap_delay_requeue(mdsc, ci, false);
> +	    } else if ((file_wanted & ~CEPH_CAP_PIN) &&
> +			!(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
> +		    /* periodically re-calculate caps wanted by open files */
> +		    __cap_delay_requeue(mdsc, ci, true);
> +	    }
> +	}
>  
>  	spin_unlock(&ci->i_ceph_lock);
>  
> @@ -2549,8 +2575,9 @@ static void __take_cap_refs(struct ceph_inode_info *ci, int got,
>   * FIXME: how does a 0 return differ from -EAGAIN?
>   */
>  enum {
> -	NON_BLOCKING	= 1,
> -	CHECK_FILELOCK	= 2,
> +	/* first 8 bits are reserved for CEPH_FILE_MODE_FOO */
> +	NON_BLOCKING	= (1 << 8),
> +	CHECK_FILELOCK	= (1 << 9),
>  };
>  
>  static int try_get_cap_refs(struct inode *inode, int need, int want,
> @@ -2560,7 +2587,6 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>  	int ret = 0;
>  	int have, implemented;
> -	int file_wanted;
>  	bool snap_rwsem_locked = false;
>  
>  	dout("get_cap_refs %p need %s want %s\n", inode,
> @@ -2576,15 +2602,6 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  		goto out_unlock;
>  	}
>  
> -	/* make sure file is actually open */
> -	file_wanted = __ceph_caps_file_wanted(ci);
> -	if ((file_wanted & need) != need) {
> -		dout("try_get_cap_refs need %s file_wanted %s, EBADF\n",
> -		     ceph_cap_string(need), ceph_cap_string(file_wanted));
> -		ret = -EBADF;
> -		goto out_unlock;
> -	}
> -
>  	/* finish pending truncate */
>  	while (ci->i_truncate_pending) {
>  		spin_unlock(&ci->i_ceph_lock);
> @@ -2692,6 +2709,9 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  		     ceph_cap_string(have), ceph_cap_string(need));
>  	}
>  out_unlock:
> +

nit: no need for blank like above

> +	__ceph_touch_fmode(ci, mdsc, flags);
> +
>  	spin_unlock(&ci->i_ceph_lock);
>  	if (snap_rwsem_locked)
>  		up_read(&mdsc->snap_rwsem);
> @@ -2729,10 +2749,20 @@ static void check_max_size(struct inode *inode, loff_t endoff)
>  		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
>  }
>  
> +static inline int get_used_fmode(int caps)
> +{
> +	int fmode = 0;
> +	if (caps & CEPH_CAP_FILE_RD)
> +		fmode |= CEPH_FILE_MODE_RD;
> +	if (caps & CEPH_CAP_FILE_WR)
> +		fmode |= CEPH_FILE_MODE_WR;
> +	return fmode;
> +}
> +
>  int ceph_try_get_caps(struct inode *inode, int need, int want,
>  		      bool nonblock, int *got)
>  {
> -	int ret;
> +	int ret, flags;
>  
>  	BUG_ON(need & ~CEPH_CAP_FILE_RD);
>  	BUG_ON(want & ~(CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO|CEPH_CAP_FILE_SHARED));
> @@ -2740,8 +2770,10 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = try_get_cap_refs(inode, need, want, 0,
> -			       (nonblock ? NON_BLOCKING : 0), got);
> +	flags = get_used_fmode(need | want);
> +	if (nonblock)
> +		flags |= NON_BLOCKING;
> +	ret = try_get_cap_refs(inode, need, want, 0, flags, got);
>  	return ret == -EAGAIN ? 0 : ret;
>  }
>  
> @@ -2767,11 +2799,15 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
>  		return -EBADF;
>  
> +	flags = get_used_fmode(need | want);
> +
>  	while (true) {
>  		if (endoff > 0)
>  			check_max_size(inode, endoff);
>  
> -		flags = atomic_read(&fi->num_locks) ? CHECK_FILELOCK : 0;
> +		flags &= CEPH_FILE_MODE_MASK;
> +		if (atomic_read(&fi->num_locks))
> +			flags |= CHECK_FILELOCK;
>  		_got = 0;
>  		ret = try_get_cap_refs(inode, need, want, endoff,
>  				       flags, &_got);
> @@ -2791,6 +2827,8 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  			list_add(&cw.list, &mdsc->cap_wait_list);
>  			spin_unlock(&mdsc->caps_list_lock);
>  
> +			/* make sure used fmode not timeout */
> +			ceph_get_fmode(ci, flags, FMODE_WAIT_BIAS);
>  			add_wait_queue(&ci->i_cap_wq, &wait);
>  
>  			flags |= NON_BLOCKING;
> @@ -2804,6 +2842,7 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  			}
>  
>  			remove_wait_queue(&ci->i_cap_wq, &wait);
> +			ceph_put_fmode(ci, flags, FMODE_WAIT_BIAS);
>  
>  			spin_lock(&mdsc->caps_list_lock);
>  			list_del(&cw.list);
> @@ -2823,7 +2862,7 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  		if (ret < 0) {
>  			if (ret == -ESTALE) {
>  				/* session was killed, try renew caps */
> -				ret = ceph_renew_caps(inode);
> +				ret = ceph_renew_caps(inode, flags);
>  				if (ret == 0)
>  					continue;
>  			}
> @@ -4121,6 +4160,31 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
>  	dout("flush_dirty_caps done\n");
>  }
>  
> +void __ceph_touch_fmode(struct ceph_inode_info *ci,
> +			struct ceph_mds_client *mdsc, int fmode)
> +{
> +	unsigned long now = jiffies;
> +	if (fmode & CEPH_FILE_MODE_RD)
> +		ci->i_last_rd = now;
> +	if (fmode & CEPH_FILE_MODE_WR)
> +		ci->i_last_wr = now;
> +	/* queue periodic check */
> +	if (fmode && list_empty(&ci->i_cap_delay_list))
> +		__cap_delay_requeue(mdsc, ci, true);
> +}
> +
> +void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
> +{
> +	int i;
> +	int bits = (fmode << 1) | 1;
> +	spin_lock(&ci->i_ceph_lock);
> +	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
> +		if (bits & (1 << i))
> +			ci->i_nr_by_mode[i] += count;
> +	}
> +	spin_unlock(&ci->i_ceph_lock);
> +}
> +
>  void __ceph_get_fmode(struct ceph_inode_info *ci, int fmode)
>  {
>  	int i;
> @@ -4136,26 +4200,18 @@ void __ceph_get_fmode(struct ceph_inode_info *ci, int fmode)
>   * we may need to release capabilities to the MDS (or schedule
>   * their delayed release).
>   */
> -void ceph_put_fmode(struct ceph_inode_info *ci, int fmode)
> +void ceph_put_fmode(struct ceph_inode_info *ci, int fmode, int count)
>  {
> -	int i, last = 0;
> +	int i;
>  	int bits = (fmode << 1) | 1;
>  	spin_lock(&ci->i_ceph_lock);
>  	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
>  		if (bits & (1 << i)) {
> -			BUG_ON(ci->i_nr_by_mode[i] == 0);
> -			if (--ci->i_nr_by_mode[i] == 0)
> -				last++;
> +			BUG_ON(ci->i_nr_by_mode[i] < count);
> +			ci->i_nr_by_mode[i] -= count;
>  		}
>  	}
> -	dout("put_fmode %p fmode %d {%d,%d,%d,%d}\n",
> -	     &ci->vfs_inode, fmode,
> -	     ci->i_nr_by_mode[0], ci->i_nr_by_mode[1],
> -	     ci->i_nr_by_mode[2], ci->i_nr_by_mode[3]);
>  	spin_unlock(&ci->i_ceph_lock);
> -
> -	if (last && ci->i_vino.snap == CEPH_NOSNAP)
> -		ceph_check_caps(ci, 0, NULL);
>  }
>  
>  /*
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 7e0190b1f821..f6ca9be9fbbd 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -213,7 +213,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>  		struct ceph_dir_file_info *dfi =
>  			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
>  		if (!dfi) {
> -			ceph_put_fmode(ci, fmode); /* clean up */
> +			ceph_put_fmode(ci, fmode, 1); /* clean up */
>  			return -ENOMEM;
>  		}
>  
> @@ -224,7 +224,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>  	} else {
>  		fi = kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
>  		if (!fi) {
> -			ceph_put_fmode(ci, fmode); /* clean up */
> +			ceph_put_fmode(ci, fmode, 1); /* clean up */
>  			return -ENOMEM;
>  		}
>  
> @@ -263,7 +263,7 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
>  	case S_IFLNK:
>  		dout("init_file %p %p 0%o (symlink)\n", inode, file,
>  		     inode->i_mode);
> -		ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
> +		ceph_put_fmode(ceph_inode(inode), fmode, 1); /* clean up */
>  		break;
>  
>  	default:
> @@ -273,7 +273,7 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
>  		 * we need to drop the open ref now, since we don't
>  		 * have .release set to ceph_release.
>  		 */
> -		ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
> +		ceph_put_fmode(ceph_inode(inode), fmode, 1); /* clean up */
>  		BUG_ON(inode->i_fop->release == ceph_release);
>  
>  		/* call the proper open fop */
> @@ -285,14 +285,15 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
>  /*
>   * try renew caps after session gets killed.
>   */
> -int ceph_renew_caps(struct inode *inode)
> +int ceph_renew_caps(struct inode *inode, int fmode)
>  {
> -	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_mds_request *req;
>  	int err, flags, wanted;
>  
>  	spin_lock(&ci->i_ceph_lock);
> +	__ceph_touch_fmode(ci, mdsc, fmode);
>  	wanted = __ceph_caps_file_wanted(ci);
>  	if (__ceph_is_any_real_caps(ci) &&
>  	    (!(wanted & CEPH_CAP_ANY_WR) || ci->i_auth_cap)) {
> @@ -405,6 +406,7 @@ int ceph_open(struct inode *inode, struct file *file)
>  	} else if (ceph_snap(inode) != CEPH_NOSNAP &&
>  		   (ci->i_snap_caps & wanted) == wanted) {
>  		__ceph_get_fmode(ci, fmode);
> +		__ceph_touch_fmode(ci, mdsc, fmode);
>  		spin_unlock(&ci->i_ceph_lock);
>  		return ceph_init_file(inode, file, fmode);
>  	}
> @@ -525,7 +527,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  	}
>  out_req:
>  	if (!req->r_err && req->r_target_inode)
> -		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode);
> +		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode, 1);
>  	ceph_mdsc_put_request(req);
>  out_ctx:
>  	ceph_release_acl_sec_ctx(&as_ctx);
> @@ -542,7 +544,7 @@ int ceph_release(struct inode *inode, struct file *file)
>  		dout("release inode %p dir file %p\n", inode, file);
>  		WARN_ON(!list_empty(&dfi->file_info.rw_contexts));
>  
> -		ceph_put_fmode(ci, dfi->file_info.fmode);
> +		ceph_put_fmode(ci, dfi->file_info.fmode, 1);
>  
>  		if (dfi->last_readdir)
>  			ceph_mdsc_put_request(dfi->last_readdir);
> @@ -554,7 +556,8 @@ int ceph_release(struct inode *inode, struct file *file)
>  		dout("release inode %p regular file %p\n", inode, file);
>  		WARN_ON(!list_empty(&fi->rw_contexts));
>  
> -		ceph_put_fmode(ci, fi->fmode);
> +		ceph_put_fmode(ci, fi->fmode, 1);
> +
>  		kmem_cache_free(ceph_file_cachep, fi);
>  	}
>  
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 094b8fc37787..95e7440cf6f7 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -478,6 +478,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>  	ci->i_head_snapc = NULL;
>  	ci->i_snap_caps = 0;
>  
> +	ci->i_last_rd = ci->i_last_wr = jiffies;
>  	for (i = 0; i < CEPH_FILE_MODE_BITS; i++)
>  		ci->i_nr_by_mode[i] = 0;
>  
> @@ -637,7 +638,7 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>  			if ((issued & (CEPH_CAP_FILE_CACHE|
>  				       CEPH_CAP_FILE_BUFFER)) ||
>  			    mapping_mapped(inode->i_mapping) ||
> -			    __ceph_caps_file_wanted(ci)) {
> +			    __ceph_is_file_opened(ci)) {
>  				ci->i_truncate_pending++;
>  				queue_trunc = 1;
>  			}
> @@ -1010,6 +1011,13 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
>  			fill_inline = true;
>  	}
>  
> +	if (cap_fmode >= 0) {
> +		if (!info_caps)
> +			pr_warn("mds issued no caps on %llx.%llx\n",
> +				ceph_vinop(inode));
> +		__ceph_touch_fmode(ci, mdsc, cap_fmode);
> +	}
> +
>  	spin_unlock(&ci->i_ceph_lock);
>  
>  	if (fill_inline)
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index c90f03beb15d..6e061bf62ad4 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -243,11 +243,13 @@ static long ceph_ioctl_lazyio(struct file *file)
>  	struct ceph_file_info *fi = file->private_data;
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> +	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>  
>  	if ((fi->fmode & CEPH_FILE_MODE_LAZY) == 0) {
>  		spin_lock(&ci->i_ceph_lock);
>  		fi->fmode |= CEPH_FILE_MODE_LAZY;
>  		ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)]++;
> +		__ceph_touch_fmode(ci, mdsc, fi->fmode);
>  		spin_unlock(&ci->i_ceph_lock);
>  		dout("ioctl_layzio: file %p marked lazy\n", file);
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 48e84d7f48a0..8ce210cc62c9 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -361,6 +361,8 @@ struct ceph_inode_info {
>  						    dirty|flushing caps */
>  	unsigned i_snap_caps;           /* cap bits for snapped files */
>  
> +	unsigned long i_last_rd;
> +	unsigned long i_last_wr;
>  	int i_nr_by_mode[CEPH_FILE_MODE_BITS];  /* open file counts */
>  
>  	struct mutex i_truncate_mutex;
> @@ -673,6 +675,10 @@ extern int __ceph_caps_revoking_other(struct ceph_inode_info *ci,
>  extern int ceph_caps_revoking(struct ceph_inode_info *ci, int mask);
>  extern int __ceph_caps_used(struct ceph_inode_info *ci);
>  
> +static inline bool __ceph_is_file_opened(struct ceph_inode_info *ci)
> +{
> +	return ci->i_nr_by_mode[0];
> +}
>  extern int __ceph_caps_file_wanted(struct ceph_inode_info *ci);
>  extern int __ceph_caps_wanted(struct ceph_inode_info *ci);
>  
> @@ -1074,7 +1080,10 @@ extern int ceph_try_get_caps(struct inode *inode,
>  
>  /* for counting open files by mode */
>  extern void __ceph_get_fmode(struct ceph_inode_info *ci, int mode);
> -extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode);
> +extern void ceph_get_fmode(struct ceph_inode_info *ci, int mode, int count);
> +extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode, int count);
> +extern void __ceph_touch_fmode(struct ceph_inode_info *ci,
> +			       struct ceph_mds_client *mdsc, int fmode);
>  
>  /* addr.c */
>  extern const struct address_space_operations ceph_aops;
> @@ -1086,7 +1095,7 @@ extern void ceph_pool_perm_destroy(struct ceph_mds_client* mdsc);
>  /* file.c */
>  extern const struct file_operations ceph_file_fops;
>  
> -extern int ceph_renew_caps(struct inode *inode);
> +extern int ceph_renew_caps(struct inode *inode, int fmode);
>  extern int ceph_open(struct inode *inode, struct file *file);
>  extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  			    struct file *file, unsigned flags, umode_t mode);
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index cb21c5cf12c3..8017130a08a1 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -564,6 +564,7 @@ struct ceph_filelock {
>  #define CEPH_FILE_MODE_RDWR       3  /* RD | WR */
>  #define CEPH_FILE_MODE_LAZY       4  /* lazy io */
>  #define CEPH_FILE_MODE_BITS       4
> +#define CEPH_FILE_MODE_MASK       ((1 << CEPH_FILE_MODE_BITS) - 1)
>  
>  int ceph_flags_to_mode(int flags);
>  

Looks reasonable overall, aside from a few nits.
-- 
Jeff Layton <jlayton@kernel.org>

