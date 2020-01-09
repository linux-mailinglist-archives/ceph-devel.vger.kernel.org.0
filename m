Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19436135A98
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 14:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbgAINwL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 08:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729476AbgAINwL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 08:52:11 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D81E206ED;
        Thu,  9 Jan 2020 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578577929;
        bh=q0TYfmWNknPihpfcDQmFT3kMFnVrWb+tMx0AuYxNiLs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NqlTyJGHMLTQ+5HLEvx4XaJF3LSa/jv/ezbKqs5+qNDlfD2xdpqpUIZa0MEYgUyjT
         j7yqm8uiNAr1f1bpXHPUVkv5YLpLFWka3BQjHadHqlGHyqUaa/GTNh4IEScK74yhBG
         dMGbx/TOg/Ohikl331ObkFF40SbZN9qRPej3YH3o=
Message-ID: <d5e5040b7c177a6c8d66d8b68f4b965721693f85.camel@kernel.org>
Subject: Re: [PATCH v2 1/8] ceph: add global dentry lease metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 09 Jan 2020 08:52:08 -0500
In-Reply-To: <20200108104152.28468-2-xiubli@redhat.com>
References: <20200108104152.28468-1-xiubli@redhat.com>
         <20200108104152.28468-2-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-01-08 at 05:41 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the dentry lease we will only count the hit/miss info triggered
> from the vfs calls, for the cases like request reply handling and
> perodically ceph_trim_dentries() we will ignore them.
> 
> Currently only the debugfs is support:
> 
> The output will be:
> 
> item          total           miss            hit
> -------------------------------------------------
> d_lease       11              7               141
> 
> Fixes: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/debugfs.c    | 32 ++++++++++++++++++++++++++++----
>  fs/ceph/dir.c        | 18 ++++++++++++++++--
>  fs/ceph/mds_client.c | 37 +++++++++++++++++++++++++++++++++++--
>  fs/ceph/mds_client.h |  9 +++++++++
>  fs/ceph/super.h      |  1 +
>  5 files changed, 89 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index fb7cabd98e7b..40a22da0214a 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -124,6 +124,22 @@ static int mdsc_show(struct seq_file *s, void *p)
>  	return 0;
>  }
>  
> +static int metric_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
> +
> +	seq_printf(s, "item          total           miss            hit\n");
> +	seq_printf(s, "-------------------------------------------------\n");
> +
> +	seq_printf(s, "%-14s%-16lld%-16lld%lld\n", "d_lease",
> +		   atomic64_read(&mdsc->metric.total_dentries),
> +		   percpu_counter_sum(&mdsc->metric.d_lease_mis),
> +		   percpu_counter_sum(&mdsc->metric.d_lease_hit));
> +
> +	return 0;
> +}
> +
>  static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
>  {
>  	struct seq_file *s = p;
> @@ -220,6 +236,7 @@ static int mds_sessions_show(struct seq_file *s, void *ptr)
>  
>  CEPH_DEFINE_SHOW_FUNC(mdsmap_show)
>  CEPH_DEFINE_SHOW_FUNC(mdsc_show)
> +CEPH_DEFINE_SHOW_FUNC(metric_show)
>  CEPH_DEFINE_SHOW_FUNC(caps_show)
>  CEPH_DEFINE_SHOW_FUNC(mds_sessions_show)
>  
> @@ -255,6 +272,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>  	debugfs_remove(fsc->debugfs_mdsmap);
>  	debugfs_remove(fsc->debugfs_mds_sessions);
>  	debugfs_remove(fsc->debugfs_caps);
> +	debugfs_remove(fsc->debugfs_metric);
>  	debugfs_remove(fsc->debugfs_mdsc);
>  }
>  
> @@ -295,11 +313,17 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  						fsc,
>  						&mdsc_show_fops);
>  
> +	fsc->debugfs_metric = debugfs_create_file("metrics",
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
> index d0cd0aba5843..382beb04bacb 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -38,6 +38,8 @@ static int __dir_lease_try_check(const struct dentry *dentry);
>  static int ceph_d_init(struct dentry *dentry)
>  {
>  	struct ceph_dentry_info *di;
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
>  
>  	di = kmem_cache_zalloc(ceph_dentry_cachep, GFP_KERNEL);
>  	if (!di)
> @@ -48,6 +50,9 @@ static int ceph_d_init(struct dentry *dentry)
>  	di->time = jiffies;
>  	dentry->d_fsdata = di;
>  	INIT_LIST_HEAD(&di->lease_list);
> +
> +	atomic64_inc(&mdsc->metric.total_dentries);
> +
>  	return 0;
>  }
>  
> @@ -1551,6 +1556,7 @@ static int dir_lease_is_valid(struct inode *dir, struct dentry *dentry)
>   */
>  static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  {
> +	struct ceph_mds_client *mdsc;
>  	int valid = 0;
>  	struct dentry *parent;
>  	struct inode *dir, *inode;
> @@ -1589,13 +1595,14 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  		}
>  	}
>  
> +	mdsc = ceph_sb_to_client(dir->i_sb)->mdsc;
>  	if (!valid) {
> -		struct ceph_mds_client *mdsc =
> -			ceph_sb_to_client(dir->i_sb)->mdsc;
>  		struct ceph_mds_request *req;
>  		int op, err;
>  		u32 mask;
>  
> +		percpu_counter_inc(&mdsc->metric.d_lease_mis);
> +
>  		if (flags & LOOKUP_RCU)
>  			return -ECHILD;
>  

So suppose we're doing an RCU walk, and call d_revalidate and the dentry
is invalid. We'll bump the counter here, but then return -ECHILD and the
kernel will do the d_revalidate all over again with refwalk, and we bump
the counter again.

Won't that end up double-counting the cache miss? Or is that intended
here?

> @@ -1630,6 +1637,8 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  			dout("d_revalidate %p lookup result=%d\n",
>  			     dentry, err);
>  		}
> +	} else {
> +		percpu_counter_inc(&mdsc->metric.d_lease_hit);
>  	}
>  
>  	dout("d_revalidate %p %s\n", dentry, valid ? "valid" : "invalid");
> @@ -1638,6 +1647,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  
>  	if (!(flags & LOOKUP_RCU))
>  		dput(parent);
> +
>  	return valid;
>  }
>  
> @@ -1672,9 +1682,13 @@ static int ceph_d_delete(const struct dentry *dentry)
>  static void ceph_d_release(struct dentry *dentry)
>  {
>  	struct ceph_dentry_info *di = ceph_dentry(dentry);
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
>  
>  	dout("d_release %p\n", dentry);
>  
> +	atomic64_dec(&mdsc->metric.total_dentries);
> +
>  	spin_lock(&dentry->d_lock);
>  	__dentry_lease_unlist(di);
>  	dentry->d_fsdata = NULL;
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index d379f489ab63..a976febf9647 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4157,10 +4157,31 @@ static void delayed_work(struct work_struct *work)
>  	schedule_delayed(mdsc);
>  }
>  
> +static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
> +{
> +	int ret;
> +
> +	if (!metric)
> +		return -EINVAL;
> +
> +	atomic64_set(&metric->total_dentries, 0);
> +	ret = percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
> +	if (ret)
> +		return ret;
> +	ret = percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
> +	if (ret) {
> +		percpu_counter_destroy(&metric->d_lease_hit);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  
>  {
>  	struct ceph_mds_client *mdsc;
> +	int err;
>  
>  	mdsc = kzalloc(sizeof(struct ceph_mds_client), GFP_NOFS);
>  	if (!mdsc)
> @@ -4169,8 +4190,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  	mutex_init(&mdsc->mutex);
>  	mdsc->mdsmap = kzalloc(sizeof(*mdsc->mdsmap), GFP_NOFS);
>  	if (!mdsc->mdsmap) {
> -		kfree(mdsc);
> -		return -ENOMEM;
> +		err = -ENOMEM;
> +		goto err_mdsc;
>  	}
>  
>  	fsc->mdsc = mdsc;
> @@ -4209,6 +4230,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  	init_waitqueue_head(&mdsc->cap_flushing_wq);
>  	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
>  	atomic_set(&mdsc->cap_reclaim_pending, 0);
> +	err = ceph_mdsc_metric_init(&mdsc->metric);
> +	if (err)
> +		goto err_mdsmap;
>  
>  	spin_lock_init(&mdsc->dentry_list_lock);
>  	INIT_LIST_HEAD(&mdsc->dentry_leases);
> @@ -4227,6 +4251,12 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  	strscpy(mdsc->nodename, utsname()->nodename,
>  		sizeof(mdsc->nodename));
>  	return 0;
> +
> +err_mdsmap:
> +	kfree(mdsc->mdsmap);
> +err_mdsc:
> +	kfree(mdsc);
> +	return err;
>  }
>  
>  /*
> @@ -4484,6 +4514,9 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
>  
>  	ceph_mdsc_stop(mdsc);
>  
> +	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
> +	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
> +
>  	fsc->mdsc = NULL;
>  	kfree(mdsc);
>  	dout("mdsc_destroy %p done\n", mdsc);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index c950f8f88f58..22186060bc37 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -358,6 +358,13 @@ struct cap_wait {
>  	int			want;
>  };
>  
> +/* This is the global metrics */
> +struct ceph_client_metric {
> +	atomic64_t		total_dentries;
> +	struct percpu_counter	d_lease_hit;
> +	struct percpu_counter	d_lease_mis;
> +};
> +
>  /*
>   * mds client state
>   */
> @@ -446,6 +453,8 @@ struct ceph_mds_client {
>  	struct list_head  dentry_leases;     /* fifo list */
>  	struct list_head  dentry_dir_leases; /* lru list */
>  
> +	struct ceph_client_metric metric;
> +
>  	spinlock_t		snapid_map_lock;
>  	struct rb_root		snapid_map_tree;
>  	struct list_head	snapid_map_lru;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 3bf1a01cd536..40703588b889 100644
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

-- 
Jeff Layton <jlayton@kernel.org>

