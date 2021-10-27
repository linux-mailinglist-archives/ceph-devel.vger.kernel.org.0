Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C5543C8E9
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 13:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbhJ0L40 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 07:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237415AbhJ0L4Z (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 07:56:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF01B60F70;
        Wed, 27 Oct 2021 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635335640;
        bh=yyUuU6le0a6it+FY4er7R95DRBUMP+92ITK5t/NB1Jw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MjT2XTNnXMGvlFQDVYOVUNtxGSofr2LIWcLMGpN247Ebn7KURzvNEs3Msh5AXsKu/
         877EBHzEqMhA5eHd2XYRdu6XX+oKIcrkaRioo8R7YoKB00y6H60q45MTHHLSoH8hxG
         LLnq47pXYvjKcxFcrWeQ2C0vnVEcedG5TgcQhUlwDGKxwNjXfiPthHlS5Xigopna2y
         UFGz5offYvJUx6TKib3xSqmggCbffCldLKLca8Diy06TXakH/rdIPFU5BEBTOVebEy
         RFLFg7i4RBVwB4Qgb1xLsjoxIKvOwouf75zw2mq49NgmcHyNw8kUnwUevBS0NX65Yc
         JFIseBC0xFBSA==
Message-ID: <896df056746a9cfda36e64278aabcf2201e3f54b.camel@kernel.org>
Subject: Re: [PATCH] ceph: split 'metric' debugfs file into several files
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Oct 2021 07:53:58 -0400
In-Reply-To: <20211027100130.15227-1-lhenriques@suse.de>
References: <1ac925e3-5596-dcf4-317e-1408c764350f@redhat.com>
         <20211027100130.15227-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-10-27 at 11:01 +0100, Luís Henriques wrote:
> Currently, all the metrics are grouped together in a single file, making
> it difficult to process this file from scripts.  Furthermore, as new
> metrics are added, processing this file will become even more challenging.
> 
> This patch turns the 'metric' file into a directory that will contain
> several files, one for each metric.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Here's a patch that does just what I proposed.  It simply turns the metric
> file into a directory.  Not sure this is the best option, but here it is
> for discussion.
> 
> Cheers,
> --
> Luís
> 

Thanks Luis,

I'm fine with this change, and it is a lot more readable. I'll plan to
merge this into testing later today, unless anyone has objections.

>  fs/ceph/debugfs.c | 81 ++++++++++++++++++++++++++++++++---------------
>  fs/ceph/super.h   |  2 +-
>  2 files changed, 57 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 38b78b45811f..55426514491b 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -146,26 +146,30 @@ static int mdsc_show(struct seq_file *s, void *p)
>  		   name, total, avg, _min, max, sum);			\
>  }
>  
> -static int metric_show(struct seq_file *s, void *p)
> +static int metrics_file_show(struct seq_file *s, void *p)
>  {
>  	struct ceph_fs_client *fsc = s->private;
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> -	struct ceph_client_metric *m = &mdsc->metric;
> -	int nr_caps = 0;
> -	s64 total, sum, avg, min, max, sq;
> -	u64 sum_sz, avg_sz, min_sz, max_sz;
> +	struct ceph_client_metric *m = &fsc->mdsc->metric;
>  
> -	sum = percpu_counter_sum(&m->total_inodes);
>  	seq_printf(s, "item                               total\n");
>  	seq_printf(s, "------------------------------------------\n");
> -	seq_printf(s, "%-35s%lld / %lld\n", "opened files  / total inodes",
> -		   atomic64_read(&m->opened_files), sum);
> -	seq_printf(s, "%-35s%lld / %lld\n", "pinned i_caps / total inodes",
> -		   atomic64_read(&m->total_caps), sum);
> -	seq_printf(s, "%-35s%lld / %lld\n", "opened inodes / total inodes",
> -		   percpu_counter_sum(&m->opened_inodes), sum);
> -
> -	seq_printf(s, "\n");
> +	seq_printf(s, "%-35s%lld\n", "total inodes",
> +		   percpu_counter_sum(&m->total_inodes));
> +	seq_printf(s, "%-35s%lld\n", "opened files",
> +		   atomic64_read(&m->opened_files));
> +	seq_printf(s, "%-35s%lld\n", "pinned i_caps",
> +		   atomic64_read(&m->total_caps));
> +	seq_printf(s, "%-35s%lld\n", "opened inodes",
> +		   percpu_counter_sum(&m->opened_inodes));
> +	return 0;
> +}
> +
> +static int metrics_latency_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_client_metric *m = &fsc->mdsc->metric;
> +	s64 total, sum, avg, min, max, sq;
> +
>  	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
>  	seq_printf(s, "-----------------------------------------------------------------------------------\n");
>  
> @@ -199,7 +203,16 @@ static int metric_show(struct seq_file *s, void *p)
>  	spin_unlock(&m->metadata_metric_lock);
>  	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
>  
> -	seq_printf(s, "\n");
> +	return 0;
> +}
> +
> +static int metrics_size_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_client_metric *m = &fsc->mdsc->metric;
> +	s64 total;
> +	u64 sum_sz, avg_sz, min_sz, max_sz;
> +
>  	seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
>  	seq_printf(s, "----------------------------------------------------------------------------------------\n");
>  
> @@ -221,7 +234,15 @@ static int metric_show(struct seq_file *s, void *p)
>  	spin_unlock(&m->write_metric_lock);
>  	CEPH_SZ_METRIC_SHOW("write", total, avg_sz, min_sz, max_sz, sum_sz);
>  
> -	seq_printf(s, "\n");
> +	return 0;
> +}
> +
> +static int metrics_caps_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_client_metric *m = &fsc->mdsc->metric;
> +	int nr_caps = 0;
> +
>  	seq_printf(s, "item          total           miss            hit\n");
>  	seq_printf(s, "-------------------------------------------------\n");
>  
> @@ -350,8 +371,11 @@ DEFINE_SHOW_ATTRIBUTE(mdsmap);
>  DEFINE_SHOW_ATTRIBUTE(mdsc);
>  DEFINE_SHOW_ATTRIBUTE(caps);
>  DEFINE_SHOW_ATTRIBUTE(mds_sessions);
> -DEFINE_SHOW_ATTRIBUTE(metric);
>  DEFINE_SHOW_ATTRIBUTE(status);
> +DEFINE_SHOW_ATTRIBUTE(metrics_file);
> +DEFINE_SHOW_ATTRIBUTE(metrics_latency);
> +DEFINE_SHOW_ATTRIBUTE(metrics_size);
> +DEFINE_SHOW_ATTRIBUTE(metrics_caps);
>  
>  
>  /*
> @@ -385,8 +409,9 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>  	debugfs_remove(fsc->debugfs_mdsmap);
>  	debugfs_remove(fsc->debugfs_mds_sessions);
>  	debugfs_remove(fsc->debugfs_caps);
> -	debugfs_remove(fsc->debugfs_metric);
> +	debugfs_remove(fsc->debugfs_status);
>  	debugfs_remove(fsc->debugfs_mdsc);
> +	debugfs_remove_recursive(fsc->debugfs_metrics_dir);
>  }
>  
>  void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
> @@ -426,12 +451,6 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  						fsc,
>  						&mdsc_fops);
>  
> -	fsc->debugfs_metric = debugfs_create_file("metrics",
> -						  0400,
> -						  fsc->client->debugfs_dir,
> -						  fsc,
> -						  &metric_fops);
> -
>  	fsc->debugfs_caps = debugfs_create_file("caps",
>  						0400,
>  						fsc->client->debugfs_dir,
> @@ -443,6 +462,18 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  						  fsc->client->debugfs_dir,
>  						  fsc,
>  						  &status_fops);
> +
> +	fsc->debugfs_metrics_dir = debugfs_create_dir("metrics",
> +						      fsc->client->debugfs_dir);
> +
> +	debugfs_create_file("file", 0400, fsc->debugfs_metrics_dir, fsc,
> +			    &metrics_file_fops);
> +	debugfs_create_file("latency", 0400, fsc->debugfs_metrics_dir, fsc,
> +			    &metrics_latency_fops);
> +	debugfs_create_file("size", 0400, fsc->debugfs_metrics_dir, fsc,
> +			    &metrics_size_fops);
> +	debugfs_create_file("caps", 0400, fsc->debugfs_metrics_dir, fsc,
> +			    &metrics_caps_fops);
>  }
>  
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 14f951cd5b61..795b077143d6 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -128,9 +128,9 @@ struct ceph_fs_client {
>  	struct dentry *debugfs_congestion_kb;
>  	struct dentry *debugfs_bdi;
>  	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
> -	struct dentry *debugfs_metric;
>  	struct dentry *debugfs_status;
>  	struct dentry *debugfs_mds_sessions;
> +	struct dentry *debugfs_metrics_dir;
>  #endif
>  
>  #ifdef CONFIG_CEPH_FSCACHE

-- 
Jeff Layton <jlayton@kernel.org>

