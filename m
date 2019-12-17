Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61966122DE4
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Dec 2019 15:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfLQOCi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Dec 2019 09:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbfLQOCg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 09:02:36 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD62921775;
        Tue, 17 Dec 2019 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576591355;
        bh=QQWSRvSEQZVE3/2ph3HnT6GjbqIuxJ4xeORW7Mn/67s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=0LxEnb75kSzAPh2ixX1dq0Dma9K0rgN3qVB7SQ08YD1fY9AyTEEZ5J8bdCTFFWCWT
         JQVgYGjrfBvMdChCSbTfmarwgsG9Aple57n92fG7CO/ato66inOy99B91sUGATGtGu
         BmbiavGClLIS42bklnASsGdLWHitJG+TgnBg0Otk=
Message-ID: <c9713c6d861d374a666a5068c259b672d4f05e2a.camel@kernel.org>
Subject: Re: [PATCH] ceph: add dentry lease and caps perf metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 17 Dec 2019 09:02:33 -0500
In-Reply-To: <20191216115334.33321-1-xiubli@redhat.com>
References: <20191216115334.33321-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-12-16 at 06:53 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For both dentry lease and caps perf metric we will only count the
> hit/miss info triggered from the vfs calls, for the cases like
> request reply handling and perodically ceph_trim_dentries() we will
> ignore them.
> 
> Currently only the debugfs is support and next will fulfill sending
> the mertic data to MDS.
> 
> The output will be:
> 
> item              hit              miss
> ---------------------------------------
> d_lease           19               0
> i_caps            168              1
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/acl.c        |  2 +-
>  fs/ceph/caps.c       | 24 +++++++++++++++++++++++-
>  fs/ceph/debugfs.c    | 31 +++++++++++++++++++++++++++----
>  fs/ceph/dir.c        | 30 +++++++++++++++++++-----------
>  fs/ceph/file.c       | 10 ++++++++++
>  fs/ceph/mds_client.c |  1 +
>  fs/ceph/mds_client.h |  9 +++++++++
>  fs/ceph/super.h      |  6 ++++--
>  fs/ceph/xattr.c      |  6 +++---
>  9 files changed, 97 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index aa55f412a6e3..b9411da0f6f2 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
>  	spin_lock(&ci->i_ceph_lock);
> -	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
> +	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0, true))
>  		set_cached_acl(inode, type, acl);
>  	else
>  		forget_cached_acl(inode, type);
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 3d56c1333777..319182229b9c 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -862,17 +862,22 @@ static void __touch_cap(struct ceph_cap *cap)
>   * front of their respective LRUs.  (This is the preferred way for
>   * callers to check for caps they want.)
>   */
> -int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
> +int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch,
> +			    bool metric)
>  {
>  	struct ceph_cap *cap;
>  	struct rb_node *p;
>  	int have = ci->i_snap_caps;
> +	struct inode *inode = &ci->vfs_inode;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>  
>  	if ((have & mask) == mask) {
>  		dout("__ceph_caps_issued_mask ino 0x%lx snap issued %s"
>  		     " (mask %s)\n", ci->vfs_inode.i_ino,
>  		     ceph_cap_string(have),
>  		     ceph_cap_string(mask));
> +		if (metric)
> +			mdsc->metric.i_caps_hit++;
>  		return 1;
>  	}
>  
> @@ -887,6 +892,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>  			     ceph_cap_string(mask));
>  			if (touch)
>  				__touch_cap(cap);
> +			if (metric)
> +				mdsc->metric.i_caps_hit++;
>  			return 1;
>  		}
>  
> @@ -912,10 +919,14 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>  						__touch_cap(cap);
>  				}
>  			}
> +			if (metric)
> +				mdsc->metric.i_caps_hit++;
>  			return 1;
>  		}
>  	}
>  
> +	if (metric)
> +		mdsc->metric.i_caps_mis++;
>  	return 0;
>  }
>  
> @@ -2718,6 +2729,7 @@ static void check_max_size(struct inode *inode, loff_t endoff)
>  int ceph_try_get_caps(struct inode *inode, int need, int want,
>  		      bool nonblock, int *got)
>  {
> +	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>  	int ret;
>  
>  	BUG_ON(need & ~CEPH_CAP_FILE_RD);
> @@ -2728,6 +2740,11 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
>  
>  	ret = try_get_cap_refs(inode, need, want, 0,
>  			       (nonblock ? NON_BLOCKING : 0), got);
> +	if (ret == 1)
> +		mdsc->metric.i_caps_hit++;
> +	else
> +		mdsc->metric.i_caps_mis++;
> +
>  	return ret == -EAGAIN ? 0 : ret;
>  }
>  
> @@ -2782,6 +2799,11 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  				continue;
>  		}
>  
> +		if (ret == 1)
> +			fsc->mdsc->metric.i_caps_hit++;
> +		else
> +			fsc->mdsc->metric.i_caps_mis++;
> +
>  		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
>  		    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
>  			if (ret >= 0 && _got)
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index facb387c2735..e86192f597e7 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -124,6 +124,21 @@ static int mdsc_show(struct seq_file *s, void *p)
>  	return 0;
>  }
>  
> +static int metric_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
> +
> +	seq_printf(s, "item              hit              miss\n");
> +	seq_printf(s, "---------------------------------------\n");
> +	seq_printf(s, "%-18s%-17llu%llu\n", "d_lease",
> +		   mdsc->metric.d_lease_hit, mdsc->metric.d_lease_mis);
> +	seq_printf(s, "%-18s%-17llu%llu\n", "i_caps",
> +		   mdsc->metric.i_caps_hit, mdsc->metric.i_caps_mis);
> +
> +	return 0;
> +}
> +
>  static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
>  {
>  	struct seq_file *s = p;
> @@ -207,6 +222,7 @@ static int mds_sessions_show(struct seq_file *s, void *ptr)
>  
>  CEPH_DEFINE_SHOW_FUNC(mdsmap_show)
>  CEPH_DEFINE_SHOW_FUNC(mdsc_show)
> +CEPH_DEFINE_SHOW_FUNC(metric_show)
>  CEPH_DEFINE_SHOW_FUNC(caps_show)
>  CEPH_DEFINE_SHOW_FUNC(mds_sessions_show)
>  
> @@ -242,6 +258,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>  	debugfs_remove(fsc->debugfs_mdsmap);
>  	debugfs_remove(fsc->debugfs_mds_sessions);
>  	debugfs_remove(fsc->debugfs_caps);
> +	debugfs_remove(fsc->debugfs_metric);
>  	debugfs_remove(fsc->debugfs_mdsc);
>  }
>  
> @@ -282,11 +299,17 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  						fsc,
>  						&mdsc_show_fops);
>  
> +	fsc->debugfs_metric = debugfs_create_file("metric",
> +						  0400,
> +						  fsc->client->debugfs_dir,
> +						  fsc,
> +						  &metric_show_fops);
> +
>  	fsc->debugfs_caps = debugfs_create_file("caps",
> -						   0400,
> -						   fsc->client->debugfs_dir,
> -						   fsc,
> -						   &caps_show_fops);
> +						0400,
> +						fsc->client->debugfs_dir,
> +						fsc,
> +						&caps_show_fops);
>  }
>  
>  
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index d17a789fd856..26864581f142 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -30,7 +30,7 @@
>  const struct dentry_operations ceph_dentry_ops;
>  
>  static bool __dentry_lease_is_valid(struct ceph_dentry_info *di);
> -static int __dir_lease_try_check(const struct dentry *dentry);
> +static int __dir_lease_try_check(const struct dentry *dentry, bool metric);
>  
>  /*
>   * Initialize ceph dentry state.
> @@ -341,7 +341,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
>  	    ceph_snap(inode) != CEPH_SNAPDIR &&
>  	    __ceph_dir_is_complete_ordered(ci) &&
> -	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
> +	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1, true)) {
>  		int shared_gen = atomic_read(&ci->i_shared_gen);
>  		spin_unlock(&ci->i_ceph_lock);
>  		err = __dcache_readdir(file, ctx, shared_gen);
> @@ -759,7 +759,8 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>  		    !is_root_ceph_dentry(dir, dentry) &&
>  		    ceph_test_mount_opt(fsc, DCACHE) &&
>  		    __ceph_dir_is_complete(ci) &&
> -		    (__ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
> +		    (__ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1,
> +					     true))) {
>  			spin_unlock(&ci->i_ceph_lock);
>  			dout(" dir %p complete, -ENOENT\n", dir);
>  			d_add(dentry, NULL);
> @@ -1336,7 +1337,7 @@ static int __dentry_lease_check(struct dentry *dentry, void *arg)
>  
>  	if (__dentry_lease_is_valid(di))
>  		return STOP;
> -	ret = __dir_lease_try_check(dentry);
> +	ret = __dir_lease_try_check(dentry, false);
>  	if (ret == -EBUSY)
>  		return KEEP;
>  	if (ret > 0)
> @@ -1349,7 +1350,7 @@ static int __dir_lease_check(struct dentry *dentry, void *arg)
>  	struct ceph_lease_walk_control *lwc = arg;
>  	struct ceph_dentry_info *di = ceph_dentry(dentry);
>  
> -	int ret = __dir_lease_try_check(dentry);
> +	int ret = __dir_lease_try_check(dentry, false);
>  	if (ret == -EBUSY)
>  		return KEEP;
>  	if (ret > 0) {
> @@ -1488,7 +1489,7 @@ static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
>  /*
>   * Called under dentry->d_lock.
>   */
> -static int __dir_lease_try_check(const struct dentry *dentry)
> +static int __dir_lease_try_check(const struct dentry *dentry, bool metric)
>  {
>  	struct ceph_dentry_info *di = ceph_dentry(dentry);
>  	struct inode *dir;
> @@ -1505,7 +1506,8 @@ static int __dir_lease_try_check(const struct dentry *dentry)
>  
>  	if (spin_trylock(&ci->i_ceph_lock)) {
>  		if (atomic_read(&ci->i_shared_gen) == di->lease_shared_gen &&
> -		    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 0))
> +		    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 0,
> +					    metric))
>  			valid = 1;
>  		spin_unlock(&ci->i_ceph_lock);
>  	} else {
> @@ -1527,7 +1529,7 @@ static int dir_lease_is_valid(struct inode *dir, struct dentry *dentry)
>  	int shared_gen;
>  
>  	spin_lock(&ci->i_ceph_lock);
> -	valid = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1);
> +	valid = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1, true);
>  	shared_gen = atomic_read(&ci->i_shared_gen);
>  	spin_unlock(&ci->i_ceph_lock);
>  	if (valid) {
> @@ -1551,6 +1553,7 @@ static int dir_lease_is_valid(struct inode *dir, struct dentry *dentry)
>   */
>  static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  {
> +	struct ceph_mds_client *mdsc;
>  	int valid = 0;
>  	struct dentry *parent;
>  	struct inode *dir, *inode;
> @@ -1567,6 +1570,8 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  		inode = d_inode(dentry);
>  	}
>  
> +	mdsc = ceph_sb_to_client(dir->i_sb)->mdsc;
> +
>  	dout("d_revalidate %p '%pd' inode %p offset %lld\n", dentry,
>  	     dentry, inode, ceph_dentry(dentry)->offset);
>  
> @@ -1590,12 +1595,12 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  	}
>  
>  	if (!valid) {
> -		struct ceph_mds_client *mdsc =
> -			ceph_sb_to_client(dir->i_sb)->mdsc;
>  		struct ceph_mds_request *req;
>  		int op, err;
>  		u32 mask;
>  
> +		mdsc->metric.d_lease_mis++;
> +
>  		if (flags & LOOKUP_RCU)
>  			return -ECHILD;
>  
> @@ -1630,6 +1635,8 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  			dout("d_revalidate %p lookup result=%d\n",
>  			     dentry, err);
>  		}
> +	} else {
> +		mdsc->metric.d_lease_hit++;
>  	}
>  
>  	dout("d_revalidate %p %s\n", dentry, valid ? "valid" : "invalid");
> @@ -1638,6 +1645,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  
>  	if (!(flags & LOOKUP_RCU))
>  		dput(parent);
> +
>  	return valid;
>  }
>  
> @@ -1660,7 +1668,7 @@ static int ceph_d_delete(const struct dentry *dentry)
>  	if (di) {
>  		if (__dentry_lease_is_valid(di))
>  			return 0;
> -		if (__dir_lease_try_check(dentry))
> +		if (__dir_lease_try_check(dentry, true))
>  			return 0;
>  	}
>  	return 1;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 8de633964dc3..1d06220a5986 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -375,6 +375,9 @@ int ceph_open(struct inode *inode, struct file *file)
>  		spin_lock(&ci->i_ceph_lock);
>  		__ceph_get_fmode(ci, fmode);
>  		spin_unlock(&ci->i_ceph_lock);
> +
> +		mdsc->metric.i_caps_hit++;
> +
>  		return ceph_init_file(inode, file, fmode);
>  	}
>  
> @@ -395,6 +398,8 @@ int ceph_open(struct inode *inode, struct file *file)
>  		__ceph_get_fmode(ci, fmode);
>  		spin_unlock(&ci->i_ceph_lock);
>  
> +		mdsc->metric.i_caps_hit++;
> +
>  		/* adjust wanted? */
>  		if ((issued & wanted) != wanted &&
>  		    (mds_wanted & wanted) != wanted &&
> @@ -406,11 +411,16 @@ int ceph_open(struct inode *inode, struct file *file)
>  		   (ci->i_snap_caps & wanted) == wanted) {
>  		__ceph_get_fmode(ci, fmode);
>  		spin_unlock(&ci->i_ceph_lock);
> +
> +		mdsc->metric.i_caps_hit++;
> +
>  		return ceph_init_file(inode, file, fmode);
>  	}
>  
>  	spin_unlock(&ci->i_ceph_lock);
>  
> +	mdsc->metric.i_caps_mis++;
> +
>  	dout("open fmode %d wants %s\n", fmode, ceph_cap_string(wanted));
>  	req = prepare_open_request(inode->i_sb, flags, 0);
>  	if (IS_ERR(req)) {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index d8bb3eebfaeb..6c3b6bb0b2c8 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4209,6 +4209,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  	init_waitqueue_head(&mdsc->cap_flushing_wq);
>  	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
>  	atomic_set(&mdsc->cap_reclaim_pending, 0);
> +	memset(&mdsc->metric, 0, sizeof(mdsc->metric));
>  
>  	spin_lock_init(&mdsc->dentry_list_lock);
>  	INIT_LIST_HEAD(&mdsc->dentry_leases);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 9fb2063b0600..8b51188b2c68 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -341,6 +341,13 @@ struct ceph_quotarealm_inode {
>  	struct inode *inode;
>  };
>  
> +struct ceph_client_metric {
> +	u64 d_lease_hit;
> +	u64 d_lease_mis;
> +	u64 i_caps_hit;
> +	u64 i_caps_mis;
> +};
> +

How are these counters protected? You're not using atomic operations or
per-cpu variables, so what locks are protecting them?

>  /*
>   * mds client state
>   */
> @@ -428,6 +435,8 @@ struct ceph_mds_client {
>  	struct list_head  dentry_leases;     /* fifo list */
>  	struct list_head  dentry_dir_leases; /* lru list */
>  
> +	struct ceph_client_metric metric;
> +
>  	spinlock_t		snapid_map_lock;
>  	struct rb_root		snapid_map_tree;
>  	struct list_head	snapid_map_lru;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index f0f9cb7447ac..a0e4d0bd013d 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -123,6 +123,7 @@ struct ceph_fs_client {
>  	struct dentry *debugfs_congestion_kb;
>  	struct dentry *debugfs_bdi;
>  	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
> +	struct dentry *debugfs_metric;
>  	struct dentry *debugfs_mds_sessions;
>  #endif
>  
> @@ -635,7 +636,8 @@ static inline bool __ceph_is_any_real_caps(struct ceph_inode_info *ci)
>  }
>  
>  extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented);
> -extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int t);
> +extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,
> +				   int t, bool metric);
>  extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
>  				    struct ceph_cap *cap);
>  
> @@ -653,7 +655,7 @@ static inline int ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,
>  {
>  	int r;
>  	spin_lock(&ci->i_ceph_lock);
> -	r = __ceph_caps_issued_mask(ci, mask, touch);
> +	r = __ceph_caps_issued_mask(ci, mask, touch, true);
>  	spin_unlock(&ci->i_ceph_lock);
>  	return r;
>  }
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index cb18ee637cb7..530fc2a72236 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -856,7 +856,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  
>  	if (ci->i_xattrs.version == 0 ||
>  	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
> -	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
> +	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1, true))) {
>  		spin_unlock(&ci->i_ceph_lock);
>  
>  		/* security module gets xattr while filling trace */
> @@ -914,7 +914,7 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
>  	     ci->i_xattrs.version, ci->i_xattrs.index_version);
>  
>  	if (ci->i_xattrs.version == 0 ||
> -	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
> +	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1, true)) {
>  		spin_unlock(&ci->i_ceph_lock);
>  		err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
>  		if (err)
> @@ -1192,7 +1192,7 @@ bool ceph_security_xattr_deadlock(struct inode *in)
>  	spin_lock(&ci->i_ceph_lock);
>  	ret = !(ci->i_ceph_flags & CEPH_I_SEC_INITED) &&
>  	      !(ci->i_xattrs.version > 0 &&
> -		__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0));
> +		__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0, false));
>  	spin_unlock(&ci->i_ceph_lock);
>  	return ret;
>  }

-- 
Jeff Layton <jlayton@kernel.org>

