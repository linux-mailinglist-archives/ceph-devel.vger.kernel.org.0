Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554A3153A68
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Feb 2020 22:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgBEVna (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 16:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbgBEVna (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 16:43:30 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E572072B;
        Wed,  5 Feb 2020 21:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580939009;
        bh=ESvdzhg8+HLw6eDfcvCf5jJfgSImdbGryTjJbWSHylY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fdeWENzXKg0AEyDXY3bTdzRILAHYcmL+dFNmAsjnh/w6FP6EMdZ74YKqwecNpfXZN
         Cihd3a2CWV7NAenxitAYimEBa/X8yeZq81tIdHgbE87bEOWKdVz3x3y2E5U/+Hg8u2
         Cs4H8cC7C6Z/Ked3TYRSNBAaPElH6tkThBkBySZw=
Message-ID: <57de3eb2f2009aec0ba086bb9d95a2936a7d1d9f.camel@kernel.org>
Subject: Re: [PATCH resend v5 08/11] ceph: periodically send perf metrics to
 MDS
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 05 Feb 2020 16:43:27 -0500
In-Reply-To: <20200129082715.5285-9-xiubli@redhat.com>
References: <20200129082715.5285-1-xiubli@redhat.com>
         <20200129082715.5285-9-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Add enable/disable sending metrics to MDS debugfs and disabled as
> default, if it's enabled the kclient will send metrics every
> second.
> 
> This will send global dentry lease hit/miss and read/write/metadata
> latency metrics and each session's caps hit/miss metric to MDS.
> 
> Every time only sends the global metrics once via any availible
> session.
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/debugfs.c            |  44 +++++++-
>  fs/ceph/mds_client.c         | 201 ++++++++++++++++++++++++++++++++---
>  fs/ceph/mds_client.h         |   3 +
>  fs/ceph/metric.h             |  76 +++++++++++++
>  fs/ceph/super.h              |   1 +
>  include/linux/ceph/ceph_fs.h |   1 +
>  6 files changed, 307 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 7fd031c18309..8aae7ecea54a 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -124,6 +124,40 @@ static int mdsc_show(struct seq_file *s, void *p)
>  	return 0;
>  }
>  
> +/*
> + * metrics debugfs
> + */
> +static int sending_metrics_set(void *data, u64 val)
> +{
> +	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
> +
> +	if (val > 1) {
> +		pr_err("Invalid sending metrics set value %llu\n", val);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&mdsc->mutex);
> +	mdsc->sending_metrics = (unsigned int)val;

Shouldn't that be a bool cast? Do we even need a cast there?

> +	mutex_unlock(&mdsc->mutex);
> +
> +	return 0;
> +}
> +
> +static int sending_metrics_get(void *data, u64 *val)
> +{
> +	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> +	struct ceph_mds_client *mdsc = fsc->mdsc;
> +
> +	mutex_lock(&mdsc->mutex);
> +	*val = (u64)mdsc->sending_metrics;
> +	mutex_unlock(&mdsc->mutex);
> +
> +	return 0;
> +}
> +DEFINE_SIMPLE_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
> +			sending_metrics_set, "%llu\n");
> +

I'd like to hear more about how we expect users to use this facility.
This debugfs file doesn't seem consistent with the rest of the UI, and I
imagine if the box reboots you'd have to (manually) re-enable it after
mount, right? Maybe this should be a mount option instead?


>  static int metric_show(struct seq_file *s, void *p)
>  {
>  	struct ceph_fs_client *fsc = s->private;
> @@ -302,11 +336,9 @@ static int congestion_kb_get(void *data, u64 *val)
>  	*val = (u64)fsc->mount_options->congestion_kb;
>  	return 0;
>  }
> -
>  DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
>  			congestion_kb_set, "%llu\n");
>  
> -
>  void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>  {
>  	dout("ceph_fs_debugfs_cleanup\n");
> @@ -316,6 +348,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>  	debugfs_remove(fsc->debugfs_mds_sessions);
>  	debugfs_remove(fsc->debugfs_caps);
>  	debugfs_remove(fsc->debugfs_metric);
> +	debugfs_remove(fsc->debugfs_sending_metrics);
>  	debugfs_remove(fsc->debugfs_mdsc);
>  }
>  
> @@ -356,6 +389,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  						fsc,
>  						&mdsc_show_fops);
>  
> +	fsc->debugfs_sending_metrics =
> +			debugfs_create_file("sending_metrics",
> +					    0600,
> +					    fsc->client->debugfs_dir,
> +					    fsc,
> +					    &sending_metrics_fops);
> +
>  	fsc->debugfs_metric = debugfs_create_file("metrics",
>  						  0400,
>  						  fsc->client->debugfs_dir,
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 92a933810a79..d765804dc855 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4104,13 +4104,156 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>  	ceph_force_reconnect(fsc->sb);
>  }
>  
> +/*
> + * called under s_mutex
> + */
> +static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> +				   struct ceph_mds_session *s,
> +				   bool skip_global)
> +{
> +	struct ceph_metric_head *head;
> +	struct ceph_metric_cap *cap;
> +	struct ceph_metric_dentry_lease *lease;
> +	struct ceph_metric_read_latency *read;
> +	struct ceph_metric_write_latency *write;
> +	struct ceph_metric_metadata_latency *meta;
> +	struct ceph_msg *msg;
> +	struct timespec64 ts;
> +	s32 len = sizeof(*head) + sizeof(*cap);
> +	s64 sum, total, avg;
> +	s32 items = 0;
> +
> +	if (!mdsc || !s)
> +		return false;
> +
> +	if (!skip_global) {
> +		len += sizeof(*lease);
> +		len += sizeof(*read);
> +		len += sizeof(*write);
> +		len += sizeof(*meta);
> +	}
> +
> +	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
> +	if (!msg) {
> +		pr_err("send metrics to mds%d, failed to allocate message\n",
> +		       s->s_mds);
> +		return false;
> +	}
> +
> +	head = msg->front.iov_base;
> +
> +	/* encode the cap metric */
> +	cap = (struct ceph_metric_cap *)(head + 1);
> +	cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
> +	cap->ver = 1;
> +	cap->campat = 1;
> +	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
> +	cap->hit = cpu_to_le64(percpu_counter_sum(&s->i_caps_hit));
> +	cap->mis = cpu_to_le64(percpu_counter_sum(&s->i_caps_mis));
> +	cap->total = cpu_to_le64(s->s_nr_caps);
> +	items++;
> +
> +	dout("cap metric hit %lld, mis %lld, total caps %lld",
> +	     le64_to_cpu(cap->hit), le64_to_cpu(cap->mis),
> +	     le64_to_cpu(cap->total));
> +
> +	/* only send the global once */
> +	if (skip_global)
> +		goto skip_global;
> +
> +	/* encode the dentry lease metric */
> +	lease = (struct ceph_metric_dentry_lease *)(cap + 1);
> +	lease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
> +	lease->ver = 1;
> +	lease->campat = 1;
> +	lease->data_len = cpu_to_le32(sizeof(*lease) - 10);
> +	lease->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_hit));
> +	lease->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_mis));
> +	lease->total = cpu_to_le64(atomic64_read(&mdsc->metric.total_dentries));
> +	items++;
> +
> +	dout("dentry lease metric hit %lld, mis %lld, total dentries %lld",
> +	     le64_to_cpu(lease->hit), le64_to_cpu(lease->mis),
> +	     le64_to_cpu(lease->total));
> +
> +	/* encode the read latency metric */
> +	read = (struct ceph_metric_read_latency *)(lease + 1);
> +	read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
> +	read->ver = 1;
> +	read->campat = 1;
> +	read->data_len = cpu_to_le32(sizeof(*read) - 10);
> +	total = percpu_counter_sum(&mdsc->metric.total_reads),
> +	sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
> +	avg = total ? sum / total : 0;
> +	ts = ns_to_timespec64(avg);
> +	read->sec = cpu_to_le32(ts.tv_sec);
> +	read->nsec = cpu_to_le32(ts.tv_nsec);
> +	items++;
> +
> +	dout("read latency metric total %lld, sum lat %lld, avg lat %lld",
> +	     total, sum, avg);
> +
> +	/* encode the write latency metric */
> +	write = (struct ceph_metric_write_latency *)(read + 1);
> +	write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
> +	write->ver = 1;
> +	write->campat = 1;
> +	write->data_len = cpu_to_le32(sizeof(*write) - 10);
> +	total = percpu_counter_sum(&mdsc->metric.total_writes),
> +	sum = percpu_counter_sum(&mdsc->metric.write_latency_sum);
> +	avg = total ? sum / total : 0;
> +	ts = ns_to_timespec64(avg);
> +	write->sec = cpu_to_le32(ts.tv_sec);
> +	write->nsec = cpu_to_le32(ts.tv_nsec);
> +	items++;
> +
> +	dout("write latency metric total %lld, sum lat %lld, avg lat %lld",
> +	     total, sum, avg);
> +
> +	/* encode the metadata latency metric */
> +	meta = (struct ceph_metric_metadata_latency *)(write + 1);
> +	meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
> +	meta->ver = 1;
> +	meta->campat = 1;
> +	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
> +	total = percpu_counter_sum(&mdsc->metric.total_metadatas),
> +	sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
> +	avg = total ? sum / total : 0;
> +	ts = ns_to_timespec64(avg);
> +	meta->sec = cpu_to_le32(ts.tv_sec);
> +	meta->nsec = cpu_to_le32(ts.tv_nsec);
> +	items++;
> +
> +	dout("metadata latency metric total %lld, sum lat %lld, avg lat %lld",
> +	     total, sum, avg);
> +
> +skip_global:
> +	put_unaligned_le32(items, &head->num);
> +	msg->front.iov_len = cpu_to_le32(len);
> +	msg->hdr.version = cpu_to_le16(1);
> +	msg->hdr.compat_version = cpu_to_le16(1);
> +	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
> +	dout("send metrics to mds%d %p\n", s->s_mds, msg);
> +	ceph_con_send(&s->s_con, msg);
> +
> +	return true;
> +}
> +
>  /*
>   * delayed work -- periodically trim expired leases, renew caps with mds
>   */
> +#define CEPH_WORK_DELAY_DEF 5
>  static void schedule_delayed(struct ceph_mds_client *mdsc)
>  {
> -	int delay = 5;
> -	unsigned hz = round_jiffies_relative(HZ * delay);
> +	unsigned int hz;
> +	int delay = CEPH_WORK_DELAY_DEF;
> +
> +	mutex_lock(&mdsc->mutex);
> +	if (mdsc->sending_metrics)
> +		delay = 1;
> +	mutex_unlock(&mdsc->mutex);
> +

The mdsc->mutex is dropped in the callers a little before this is
called, so this is a little too mutex-thrashy. I think you'd be better
off changing this function to be called with the mutex still held.

> +	hz = round_jiffies_relative(HZ * delay);
>  	schedule_delayed_work(&mdsc->delayed_work, hz);
>  }
>  
> @@ -4121,18 +4264,28 @@ static void delayed_work(struct work_struct *work)
>  		container_of(work, struct ceph_mds_client, delayed_work.work);
>  	int renew_interval;
>  	int renew_caps;
> +	bool metric_only;
> +	bool sending_metrics;
> +	bool g_skip = false;
>  
>  	dout("mdsc delayed_work\n");
>  
>  	mutex_lock(&mdsc->mutex);
> -	renew_interval = mdsc->mdsmap->m_session_timeout >> 2;
> -	renew_caps = time_after_eq(jiffies, HZ*renew_interval +
> -				   mdsc->last_renew_caps);
> -	if (renew_caps)
> -		mdsc->last_renew_caps = jiffies;
> +	sending_metrics = !!mdsc->sending_metrics;
> +	metric_only = mdsc->sending_metrics &&
> +		(mdsc->ticks++ % CEPH_WORK_DELAY_DEF);
> +
> +	if (!metric_only) {
> +		renew_interval = mdsc->mdsmap->m_session_timeout >> 2;
> +		renew_caps = time_after_eq(jiffies, HZ*renew_interval +
> +					   mdsc->last_renew_caps);
> +		if (renew_caps)
> +			mdsc->last_renew_caps = jiffies;
> +	}
>  
>  	for (i = 0; i < mdsc->max_sessions; i++) {
>  		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
> +
>  		if (!s)
>  			continue;
>  		if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
> @@ -4158,13 +4311,20 @@ static void delayed_work(struct work_struct *work)
>  		mutex_unlock(&mdsc->mutex);
>  
>  		mutex_lock(&s->s_mutex);
> -		if (renew_caps)
> -			send_renew_caps(mdsc, s);
> -		else
> -			ceph_con_keepalive(&s->s_con);
> -		if (s->s_state == CEPH_MDS_SESSION_OPEN ||
> -		    s->s_state == CEPH_MDS_SESSION_HUNG)
> -			ceph_send_cap_releases(mdsc, s);
> +
> +		if (sending_metrics)
> +			g_skip = ceph_mdsc_send_metrics(mdsc, s, g_skip);
> +
> +		if (!metric_only) {
> +			if (renew_caps)
> +				send_renew_caps(mdsc, s);
> +			else
> +				ceph_con_keepalive(&s->s_con);
> +			if (s->s_state == CEPH_MDS_SESSION_OPEN ||
> +					s->s_state == CEPH_MDS_SESSION_HUNG)
> +				ceph_send_cap_releases(mdsc, s);
> +		}
> +
>  		mutex_unlock(&s->s_mutex);
>  		ceph_put_mds_session(s);
>  
> @@ -4172,6 +4332,9 @@ static void delayed_work(struct work_struct *work)
>  	}
>  	mutex_unlock(&mdsc->mutex);
>  
> +	if (metric_only)
> +		goto delay_work;
> +
>  	ceph_check_delayed_caps(mdsc);
>  
>  	ceph_queue_cap_reclaim_work(mdsc);
> @@ -4180,11 +4343,13 @@ static void delayed_work(struct work_struct *work)
>  
>  	maybe_recover_session(mdsc);
>  
> +delay_work:
>  	schedule_delayed(mdsc);
>  }
>  
> -static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
> +static int ceph_mdsc_metric_init(struct ceph_mds_client *mdsc)
>  {
> +	struct ceph_client_metric *metric = &mdsc->metric;
>  	int ret;
>  
>  	if (!metric)
> @@ -4222,7 +4387,9 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>  	if (ret)
>  		goto err_metadata_latency_sum;
>  
> -	return ret;
> +	mdsc->sending_metrics = 0;
> +	mdsc->ticks = 0;
> +	return 0;
>  err_metadata_latency_sum:
>  	percpu_counter_destroy(&metric->total_metadatas);
>  err_total_metadatas:
> @@ -4294,7 +4461,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  	init_waitqueue_head(&mdsc->cap_flushing_wq);
>  	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
>  	atomic_set(&mdsc->cap_reclaim_pending, 0);
> -	err = ceph_mdsc_metric_init(&mdsc->metric);
> +	err = ceph_mdsc_metric_init(mdsc);
>  	if (err)
>  		goto err_mdsmap;
>  
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 574d4e5a5de2..a0ece55d987c 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -451,6 +451,9 @@ struct ceph_mds_client {
>  	struct list_head  dentry_leases;     /* fifo list */
>  	struct list_head  dentry_dir_leases; /* lru list */
>  
> +	/* metrics */
> +	unsigned int		  sending_metrics;
> +	unsigned int		  ticks;
>  	struct ceph_client_metric metric;
>  
>  	spinlock_t		snapid_map_lock;
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 3cda616ba594..352eb753ce25 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -4,6 +4,82 @@
>  
>  #include <linux/ceph/osd_client.h>
>  
> +enum ceph_metric_type {
> +	CLIENT_METRIC_TYPE_CAP_INFO,
> +	CLIENT_METRIC_TYPE_READ_LATENCY,
> +	CLIENT_METRIC_TYPE_WRITE_LATENCY,
> +	CLIENT_METRIC_TYPE_METADATA_LATENCY,
> +	CLIENT_METRIC_TYPE_DENTRY_LEASE,
> +
> +	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
> +};
> +
> +/* metric caps header */
> +struct ceph_metric_cap {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  campat;

I think you meant "compat" here.

> +
> +	__le32 data_len; /* length of sizeof(hit + mis + total) */
> +	__le64 hit;
> +	__le64 mis;
> +	__le64 total;
> +} __attribute__ ((packed));
> +
> +/* metric dentry lease header */
> +struct ceph_metric_dentry_lease {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  campat;
> +
> +	__le32 data_len; /* length of sizeof(hit + mis + total) */
> +	__le64 hit;
> +	__le64 mis;
> +	__le64 total;
> +} __attribute__ ((packed));
> +
> +/* metric read latency header */
> +struct ceph_metric_read_latency {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  campat;
> +
> +	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	__le32 sec;
> +	__le32 nsec;
> +} __attribute__ ((packed));
> +
> +/* metric write latency header */
> +struct ceph_metric_write_latency {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  campat;
> +
> +	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	__le32 sec;
> +	__le32 nsec;
> +} __attribute__ ((packed));
> +
> +/* metric metadata latency header */
> +struct ceph_metric_metadata_latency {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  campat;
> +
> +	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	__le32 sec;
> +	__le32 nsec;
> +} __attribute__ ((packed));
> +
> +struct ceph_metric_head {
> +	__le32 num;	/* the number of metrics will be sent */

"the number of metrics that will be sent"

> +} __attribute__ ((packed));
> +
>  /* This is the global metrics */
>  struct ceph_client_metric {
>  	atomic64_t		total_dentries;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 3f4829222528..a91431e9bdf7 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -128,6 +128,7 @@ struct ceph_fs_client {
>  	struct dentry *debugfs_congestion_kb;
>  	struct dentry *debugfs_bdi;
>  	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
> +	struct dentry *debugfs_sending_metrics;
>  	struct dentry *debugfs_metric;
>  	struct dentry *debugfs_mds_sessions;
>  #endif
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index a099f60feb7b..6028d3e865e4 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -130,6 +130,7 @@ struct ceph_dir_layout {
>  #define CEPH_MSG_CLIENT_REQUEST         24
>  #define CEPH_MSG_CLIENT_REQUEST_FORWARD 25
>  #define CEPH_MSG_CLIENT_REPLY           26
> +#define CEPH_MSG_CLIENT_METRICS         29
>  #define CEPH_MSG_CLIENT_CAPS            0x310
>  #define CEPH_MSG_CLIENT_LEASE           0x311
>  #define CEPH_MSG_CLIENT_SNAP            0x312

-- 
Jeff Layton <jlayton@kernel.org>

