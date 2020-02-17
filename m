Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09255161350
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 14:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgBQN16 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 08:27:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbgBQN16 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 08:27:58 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2146D2070B;
        Mon, 17 Feb 2020 13:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581946076;
        bh=TvkJ4y5ATUkCbf4PASpTWGLIq+Hzq8MCRm0hcYogunM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=yX0dvfcdo8km7qMEcDRfaatsSFpvtkjz0sFo6V5CrR7hXDnuyA8AB09xFkd0bF7IC
         ohp0MkPG0cjmGaXZXGAQYgoYpfw7s0+CaVJDs7VN7a92E4femta9k2MozhIxlHLJpT
         z0XoIL5aXyw558OM4aEmmmr18Kx6mB81HhnbUc5w=
Message-ID: <c4c0dc74b34e234bef78aca99c1e31e051c1c72d.camel@kernel.org>
Subject: Re: [PATCH v6 2/9] ceph: add caps perf metric for each session
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 17 Feb 2020 08:27:55 -0500
In-Reply-To: <20200210053407.37237-3-xiubli@redhat.com>
References: <20200210053407.37237-1-xiubli@redhat.com>
         <20200210053407.37237-3-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-02-10 at 00:34 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will fulfill the cap hit/mis metric stuff per-superblock,
> it will count the hit/mis counters based each inode, and if one
> inode's 'issued & ~revoking == mask' will mean a hit, or a miss.
> 
> item          total           miss            hit
> -------------------------------------------------
> caps          295             107             4119
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/acl.c        |  2 ++
>  fs/ceph/caps.c       | 29 +++++++++++++++++++++++++++++
>  fs/ceph/debugfs.c    | 16 ++++++++++++++++
>  fs/ceph/dir.c        |  9 +++++++--
>  fs/ceph/file.c       |  2 ++
>  fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
>  fs/ceph/metric.h     |  3 +++
>  fs/ceph/quota.c      |  9 +++++++--
>  fs/ceph/super.h      |  9 +++++++++
>  fs/ceph/xattr.c      | 17 ++++++++++++++---
>  10 files changed, 111 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index 26be6520d3fb..58e119e3519f 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -22,6 +22,8 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
>  	spin_lock(&ci->i_ceph_lock);
> +	__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> +
>  	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
>  		set_cached_acl(inode, type, acl);
>  	else
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 7fc87b693ba4..b4f122eb74bb 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -818,6 +818,32 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
>  	return have;
>  }
>  
> +/*
> + * Counts the cap metric.
> + *
> + * This will try to traverse all the ci->i_caps, if we can
> + * get all the cap 'mask' it will count the hit, or the mis.
> + */
> +void __ceph_caps_metric(struct ceph_inode_info *ci, int mask)
> +{
> +	struct ceph_mds_client *mdsc =
> +		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> +	struct ceph_client_metric *metric = &mdsc->metric;
> +	int issued;
> +
> +	lockdep_assert_held(&ci->i_ceph_lock);
> +
> +	if (mask <= 0)
> +		return;
> +
> +	issued = __ceph_caps_issued(ci, NULL);
> +
> +	if ((mask & issued) == mask)
> +		percpu_counter_inc(&metric->i_caps_hit);
> +	else
> +		percpu_counter_inc(&metric->i_caps_mis);
> +}
> +
>  /*
>   * Get cap bits issued by caps other than @ocap
>   */
> @@ -2758,6 +2784,7 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
>  	BUG_ON(want & ~(CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO |
>  			CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
>  			CEPH_CAP_ANY_DIR_OPS));
> +	ceph_caps_metric(ceph_inode(inode), need | want);
>  	ret = try_get_cap_refs(inode, need, want, 0, nonblock, got);
>  	return ret == -EAGAIN ? 0 : ret;
>  }
> @@ -2784,6 +2811,8 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
>  		return -EBADF;
>  
> +	ceph_caps_metric(ci, need | want);
> +
>  	while (true) {
>  		if (endoff > 0)
>  			check_max_size(inode, endoff);
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 15975ba95d9a..c83e52bd9961 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -128,6 +128,7 @@ static int metric_show(struct seq_file *s, void *p)
>  {
>  	struct ceph_fs_client *fsc = s->private;
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	int i, nr_caps = 0;
>  
>  	seq_printf(s, "item          total           miss            hit\n");
>  	seq_printf(s, "-------------------------------------------------\n");
> @@ -137,6 +138,21 @@ static int metric_show(struct seq_file *s, void *p)
>  		   percpu_counter_sum(&mdsc->metric.d_lease_mis),
>  		   percpu_counter_sum(&mdsc->metric.d_lease_hit));
>  
> +	mutex_lock(&mdsc->mutex);
> +	for (i = 0; i < mdsc->max_sessions; i++) {
> +		struct ceph_mds_session *s;
> +
> +		s = __ceph_lookup_mds_session(mdsc, i);
> +		if (!s)
> +			continue;
> +		nr_caps += s->s_nr_caps;
> +		ceph_put_mds_session(s);
> +	}
> +	mutex_unlock(&mdsc->mutex);
> +	seq_printf(s, "%-14s%-16d%-16lld%lld\n", "caps", nr_caps,
> +		   percpu_counter_sum(&mdsc->metric.i_caps_mis),
> +		   percpu_counter_sum(&mdsc->metric.i_caps_hit));
> +
>  	return 0;
>  }
>  
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 4771bf61d562..ffeaff5bf211 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -313,7 +313,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
>  	int i;
> -	int err;
> +	int err, ret = -1;
>  	unsigned frag = -1;
>  	struct ceph_mds_reply_info_parsed *rinfo;
>  
> @@ -346,13 +346,16 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
>  	    ceph_snap(inode) != CEPH_SNAPDIR &&
>  	    __ceph_dir_is_complete_ordered(ci) &&
> -	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
> +	    (ret = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
>  		int shared_gen = atomic_read(&ci->i_shared_gen);
> +		__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);

Why is this dealing with Xs caps when you've checked Fs?

>  		spin_unlock(&ci->i_ceph_lock);
>  		err = __dcache_readdir(file, ctx, shared_gen);
>  		if (err != -EAGAIN)
>  			return err;
>  	} else {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);

Ditto.

>  		spin_unlock(&ci->i_ceph_lock);
>  	}
>  
> @@ -757,6 +760,8 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>  		struct ceph_dentry_info *di = ceph_dentry(dentry);
>  
>  		spin_lock(&ci->i_ceph_lock);
> +		__ceph_caps_metric(ci, CEPH_CAP_FILE_SHARED);
> +
>  		dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
>  		if (strncmp(dentry->d_name.name,
>  			    fsc->mount_options->snapdir_name,
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 4d1b5cc6dd3b..96803500b712 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -384,6 +384,8 @@ int ceph_open(struct inode *inode, struct file *file)
>  	 * asynchronously.
>  	 */
>  	spin_lock(&ci->i_ceph_lock);
> +	__ceph_caps_metric(ci, wanted);
> +
>  	if (__ceph_is_any_real_caps(ci) &&
>  	    (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap)) {
>  		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a24fd00676b8..1431e52e9558 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4169,13 +4169,29 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>  	ret = percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
>  	if (ret)
>  		return ret;
> +
>  	ret = percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
> -	if (ret) {
> -		percpu_counter_destroy(&metric->d_lease_hit);
> -		return ret;
> -	}
> +	if (ret)
> +		goto err_d_lease_mis;
> +
> +	ret = percpu_counter_init(&metric->i_caps_hit, 0, GFP_KERNEL);
> +	if (ret)
> +		goto err_i_caps_hit;
> +
> +	ret = percpu_counter_init(&metric->i_caps_mis, 0, GFP_KERNEL);
> +	if (ret)
> +		goto err_i_caps_mis;
>  
>  	return 0;
> +
> +err_i_caps_mis:
> +	percpu_counter_destroy(&metric->i_caps_hit);
> +err_i_caps_hit:
> +	percpu_counter_destroy(&metric->d_lease_mis);
> +err_d_lease_mis:
> +	percpu_counter_destroy(&metric->d_lease_hit);
> +
> +	return ret;
>  }
>  
>  int ceph_mdsc_init(struct ceph_fs_client *fsc)
> @@ -4515,6 +4531,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
>  
>  	ceph_mdsc_stop(mdsc);
>  
> +	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
> +	percpu_counter_destroy(&mdsc->metric.i_caps_hit);
>  	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
>  	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
>  
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 998fe2a643cf..e2fceb38a924 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -7,5 +7,8 @@ struct ceph_client_metric {
>  	atomic64_t            total_dentries;
>  	struct percpu_counter d_lease_hit;
>  	struct percpu_counter d_lease_mis;
> +
> +	struct percpu_counter i_caps_hit;
> +	struct percpu_counter i_caps_mis;
>  };
>  #endif /* _FS_CEPH_MDS_METRIC_H */
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index de56dee60540..4ce2f658e63d 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -147,9 +147,14 @@ static struct inode *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
>  		return NULL;
>  	}
>  	if (qri->inode) {
> +		struct ceph_inode_info *ci = ceph_inode(qri->inode);
> +		int ret;
> +
> +		ceph_caps_metric(ci, CEPH_STAT_CAP_INODE);
> +
>  		/* get caps */
> -		int ret = __ceph_do_getattr(qri->inode, NULL,
> -					    CEPH_STAT_CAP_INODE, true);
> +		ret = __ceph_do_getattr(qri->inode, NULL,
> +					CEPH_STAT_CAP_INODE, true);
>  		if (ret >= 0)
>  			in = qri->inode;
>  		else
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 5241efe0f9d0..44b9a971ec9a 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -641,6 +641,14 @@ static inline bool __ceph_is_any_real_caps(struct ceph_inode_info *ci)
>  	return !RB_EMPTY_ROOT(&ci->i_caps);
>  }
>  
> +extern void __ceph_caps_metric(struct ceph_inode_info *ci, int mask);
> +static inline void ceph_caps_metric(struct ceph_inode_info *ci, int mask)
> +{
> +	spin_lock(&ci->i_ceph_lock);
> +	__ceph_caps_metric(ci, mask);
> +	spin_unlock(&ci->i_ceph_lock);
> +}
> +
>  extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented);
>  extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int t);
>  extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
> @@ -927,6 +935,7 @@ extern int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>  			     int mask, bool force);
>  static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
>  {
> +	ceph_caps_metric(ceph_inode(inode), mask);
>  	return __ceph_do_getattr(inode, NULL, mask, force);
>  }
>  extern int ceph_permission(struct inode *inode, int mask);
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 7b8a070a782d..9b28e87b6719 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -829,6 +829,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  	struct ceph_vxattr *vxattr = NULL;
>  	int req_mask;
>  	ssize_t err;
> +	int ret = -1;
>  
>  	/* let's see if a virtual xattr was requested */
>  	vxattr = ceph_match_vxattr(inode, name);
> @@ -856,7 +857,9 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  
>  	if (ci->i_xattrs.version == 0 ||
>  	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
> -	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
> +	      (ret = __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)))) {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>  		spin_unlock(&ci->i_ceph_lock);
>  
>  		/* security module gets xattr while filling trace */
> @@ -871,6 +874,9 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  		if (err)
>  			return err;
>  		spin_lock(&ci->i_ceph_lock);
> +	} else {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>  	}
>  
>  	err = __build_xattrs(inode);
> @@ -907,19 +913,24 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	bool len_only = (size == 0);
>  	u32 namelen;
> -	int err;
> +	int err, ret = -1;
>  
>  	spin_lock(&ci->i_ceph_lock);
>  	dout("listxattr %p ver=%lld index_ver=%lld\n", inode,
>  	     ci->i_xattrs.version, ci->i_xattrs.index_version);
>  
>  	if (ci->i_xattrs.version == 0 ||
> -	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
> +	    !(ret = __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>  		spin_unlock(&ci->i_ceph_lock);
>  		err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
>  		if (err)
>  			return err;
>  		spin_lock(&ci->i_ceph_lock);
> +	} else {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>  	}
>  
>  	err = __build_xattrs(inode);

-- 
Jeff Layton <jlayton@kernel.org>

