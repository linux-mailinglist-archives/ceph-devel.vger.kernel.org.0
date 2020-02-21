Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33711167D05
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 13:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgBUMAp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 07:00:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbgBUMAp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 07:00:45 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11F58222C4;
        Fri, 21 Feb 2020 12:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582286443;
        bh=Q5SGwbb6GZBzaYZlnupwFHbMIvYbYeWNgtDw5Jp2ctw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hazqgi6GjjWfQSU3+4eDG56lf8S710ivNf8pt7K0aFFj1yN40dfzOIyMjQklqBwZp
         HtEcDg5rmIws7sXCcSpieZSLX5on+VkPnO/H4H7OxcrI2l6ISoQJSshmqixzjAG1JO
         qPW+Iy4LXZG2PzPCoxjd8Jr1ydF5g2B+y98cc5qY=
Message-ID: <a654d3d4765741594e9c49ef62ba1d0ab41e3960.camel@kernel.org>
Subject: Re: [PATCH v8 2/5] ceph: add caps perf metric for each session
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Fri, 21 Feb 2020 07:00:41 -0500
In-Reply-To: <20200221070556.18922-3-xiubli@redhat.com>
References: <20200221070556.18922-1-xiubli@redhat.com>
         <20200221070556.18922-3-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-21 at 02:05 -0500, xiubli@redhat.com wrote:
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
>  fs/ceph/acl.c        |  2 +-
>  fs/ceph/caps.c       | 19 +++++++++++++++++++
>  fs/ceph/debugfs.c    | 16 ++++++++++++++++
>  fs/ceph/dir.c        |  5 +++--
>  fs/ceph/inode.c      |  4 ++--
>  fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
>  fs/ceph/metric.h     | 19 +++++++++++++++++++
>  fs/ceph/super.h      |  8 +++++---
>  fs/ceph/xattr.c      |  4 ++--
>  9 files changed, 89 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index 26be6520d3fb..e0465741c591 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
>  	spin_lock(&ci->i_ceph_lock);
> -	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
> +	if (__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 0))
>  		set_cached_acl(inode, type, acl);
>  	else
>  		forget_cached_acl(inode, type);

nit: calling __ceph_caps_issued_mask_metric means that you have an extra
branch. One to set/forget acl and one to update the counter.

This would be (very slightly) more efficient if you just put the cap
hit/miss calls inside the existing if block above. IOW, you could just
do:

if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0)) {
	set_cached_acl(inode, type, acl);
	ceph_update_cap_hit(&fsc->mdsc->metric);
} else {
	forget_cached_acl(inode, type);
	ceph_update_cap_mis(&fsc->mdsc->metric);
}

> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index d05717397c2a..fe2ae41f2ec1 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -920,6 +920,20 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>  	return 0;
>  }
>  
> +int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
> +				   int touch)
> +{
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> +	int r;
> +
> +	r = __ceph_caps_issued_mask(ci, mask, touch);
> +	if (r)
> +		ceph_update_cap_hit(&fsc->mdsc->metric);
> +	else
> +		ceph_update_cap_mis(&fsc->mdsc->metric);
> +	return r;
> +}
> +
>  /*
>   * Return true if mask caps are currently being revoked by an MDS.
>   */
> @@ -2700,6 +2714,11 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  	if (snap_rwsem_locked)
>  		up_read(&mdsc->snap_rwsem);
>  
> +	if (!ret)
> +		ceph_update_cap_mis(&mdsc->metric);
> +	else if (ret == 1)
> +		ceph_update_cap_hit(&mdsc->metric);
> +
>  	dout("get_cap_refs %p ret %d got %s\n", inode,
>  	     ret, ceph_cap_string(*got));
>  	return ret;
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
> index ff1714fe03aa..227949c3deb8 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -346,8 +346,9 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
>  	    ceph_snap(inode) != CEPH_SNAPDIR &&
>  	    __ceph_dir_is_complete_ordered(ci) &&
> -	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
> +	    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {

These could also just be cap_hit/mis calls inside the existing if
blocks.

>  		int shared_gen = atomic_read(&ci->i_shared_gen);
> +
>  		spin_unlock(&ci->i_ceph_lock);
>  		err = __dcache_readdir(file, ctx, shared_gen);
>  		if (err != -EAGAIN)
> @@ -764,7 +765,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>  		    !is_root_ceph_dentry(dir, dentry) &&
>  		    ceph_test_mount_opt(fsc, DCACHE) &&
>  		    __ceph_dir_is_complete(ci) &&
> -		    (__ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
> +		    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {

...and here

>  			spin_unlock(&ci->i_ceph_lock);
>  			dout(" dir %p complete, -ENOENT\n", dir);
>  			d_add(dentry, NULL);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 094b8fc37787..8dc10196e3a1 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2273,8 +2273,8 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>  
>  	dout("do_getattr inode %p mask %s mode 0%o\n",
>  	     inode, ceph_cap_string(mask), inode->i_mode);
> -	if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
> -		return 0;
> +	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
> +			return 0;
>  
>  	mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
>  	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 82060afd5dca..cd31bcb4e563 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4167,13 +4167,29 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
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
> @@ -4513,6 +4529,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
>  
>  	ceph_mdsc_stop(mdsc);
>  
> +	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
> +	percpu_counter_destroy(&mdsc->metric.i_caps_hit);
>  	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
>  	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
>  
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 998fe2a643cf..40eb58f9f43e 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -7,5 +7,24 @@ struct ceph_client_metric {
>  	atomic64_t            total_dentries;
>  	struct percpu_counter d_lease_hit;
>  	struct percpu_counter d_lease_mis;
> +
> +	struct percpu_counter i_caps_hit;
> +	struct percpu_counter i_caps_mis;
>  };
> +
> +static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
> +{
> +	if (!m)
> +		return;
> +

When are these ever NULL?

> +	percpu_counter_inc(&m->i_caps_hit);
> +}
> +
> +static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
> +{
> +	if (!m)
> +		return;
> +
> +	percpu_counter_inc(&m->i_caps_mis);
> +}
>  #endif /* _FS_CEPH_MDS_METRIC_H */
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ebcf7612eac9..4b269dc845bb 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -639,6 +639,8 @@ static inline bool __ceph_is_any_real_caps(struct ceph_inode_info *ci)
>  
>  extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented);
>  extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int t);
> +extern int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
> +					  int t);
>  extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
>  				    struct ceph_cap *cap);
>  
> @@ -651,12 +653,12 @@ static inline int ceph_caps_issued(struct ceph_inode_info *ci)
>  	return issued;
>  }
>  
> -static inline int ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,
> -					int touch)
> +static inline int ceph_caps_issued_mask_metric(struct ceph_inode_info *ci,
> +					       int mask, int touch)
>  {
>  	int r;
>  	spin_lock(&ci->i_ceph_lock);
> -	r = __ceph_caps_issued_mask(ci, mask, touch);
> +	r = __ceph_caps_issued_mask_metric(ci, mask, touch);
>  	spin_unlock(&ci->i_ceph_lock);
>  	return r;
>  }
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 7b8a070a782d..71ee34d160c3 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -856,7 +856,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  
>  	if (ci->i_xattrs.version == 0 ||
>  	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
> -	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
> +	      __ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1))) {
>  		spin_unlock(&ci->i_ceph_lock);
>  
>  		/* security module gets xattr while filling trace */
> @@ -914,7 +914,7 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
>  	     ci->i_xattrs.version, ci->i_xattrs.index_version);
>  
>  	if (ci->i_xattrs.version == 0 ||
> -	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
> +	    !__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1)) {
>  		spin_unlock(&ci->i_ceph_lock);
>  		err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
>  		if (err)

-- 
Jeff Layton <jlayton@kernel.org>

