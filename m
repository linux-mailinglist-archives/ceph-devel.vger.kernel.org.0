Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1120F390
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jun 2020 13:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgF3LaE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 07:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgF3LaD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Jun 2020 07:30:03 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD01B206E9;
        Tue, 30 Jun 2020 11:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593516601;
        bh=SNyQ21WZvsfMAYblch//8rDbnIpVlBCMlUs/gsw5whA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Tc5R99RNOMMIHvgYfIzMuraPdaQvp0VeLq7A42t1t9QylU0Re/aRtqB02qKQmfGMZ
         HEyn9qGmfDfOwX7HVhQ2qJM6USY3T2gEk/FQlNe80aTh3pAUQFzeaAs0JIURdpEL/N
         Q5H3hgrKbPSSpkYXpXemqqowZZ2VKW5idIWR4C5Y=
Message-ID: <9dd552093a9779589f5bbcc500a3321d20fb0193.camel@kernel.org>
Subject: Re: [PATCH v5 3/5] ceph: periodically send perf metrics to ceph
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 30 Jun 2020 07:29:59 -0400
In-Reply-To: <1593503539-1209-4-git-send-email-xiubli@redhat.com>
References: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
         <1593503539-1209-4-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-06-30 at 03:52 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will send the caps/read/write/metadata metrics to any available
> MDS only once per second as default, which will be the same as the
> userland client. It will skip the MDS sessions which don't support
> the metric collection, or the MDSs will close the socket connections
> directly when it get an unknown type message.
> 
> We can disable the metric sending via the enable_send_metric module
> parameter.
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c         |  12 ++++
>  fs/ceph/mds_client.h         |   4 +-
>  fs/ceph/metric.c             | 157 +++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/metric.h             |  82 ++++++++++++++++++++++
>  fs/ceph/super.c              |  42 ++++++++++++
>  fs/ceph/super.h              |   2 +
>  include/linux/ceph/ceph_fs.h |   1 +
>  7 files changed, 299 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index f3c7123..bcdda5a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1809,6 +1809,11 @@ static int __close_session(struct ceph_mds_client *mdsc,
>  	if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
>  		return 0;
>  	session->s_state = CEPH_MDS_SESSION_CLOSING;
> +
> +	if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features)
> +	    && atomic_dec_return(&mdsc->metric.mds_cnt) == 0)
> +		cancel_delayed_work_sync(&mdsc->metric.delayed_work);
> +
>  	return request_close_session(session);
>  }
>  
> @@ -3310,6 +3315,9 @@ static void handle_session(struct ceph_mds_session *session,
>  		session->s_state = CEPH_MDS_SESSION_OPEN;
>  		session->s_features = features;
>  		renewed_caps(mdsc, session, 0);
> +		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features)
> +		    && atomic_inc_return(&mdsc->metric.mds_cnt) == 1)
> +			metric_schedule_delayed(&mdsc->metric);
>  		wake = 1;
>  		if (mdsc->stopping)
>  			__close_session(mdsc, session);
> @@ -3809,6 +3817,10 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
>  	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
>  	session->s_seq = 0;
>  
> +	if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features)
> +	    && atomic_dec_return(&mdsc->metric.mds_cnt) == 0)
> +		cancel_delayed_work_sync(&mdsc->metric.delayed_work);
> +
>  	dout("session %p state %s\n", session,
>  	     ceph_session_state_name(session->s_state));
>  
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 6147ff0..bc9e959 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -28,8 +28,9 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_LAZY_CAP_WANTED,
>  	CEPHFS_FEATURE_MULTI_RECONNECT,
>  	CEPHFS_FEATURE_DELEG_INO,
> +	CEPHFS_FEATURE_METRIC_COLLECT,
>  
> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>  };
>  
>  /*
> @@ -43,6 +44,7 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>  	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>  	CEPHFS_FEATURE_DELEG_INO,		\
> +	CEPHFS_FEATURE_METRIC_COLLECT,		\
>  						\
>  	CEPHFS_FEATURE_MAX,			\
>  }
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 269eacb..8d93cf6 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -1,10 +1,162 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> +#include <linux/ceph/ceph_debug.h>
>  
>  #include <linux/types.h>
>  #include <linux/percpu_counter.h>
>  #include <linux/math64.h>
>  
>  #include "metric.h"
> +#include "mds_client.h"
> +
> +static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
> +				   struct ceph_mds_session *s,
> +				   u64 nr_caps)
> +{
> +	struct ceph_metric_head *head;
> +	struct ceph_metric_cap *cap;
> +	struct ceph_metric_read_latency *read;
> +	struct ceph_metric_write_latency *write;
> +	struct ceph_metric_metadata_latency *meta;
> +	struct ceph_client_metric *m = &mdsc->metric;
> +	struct ceph_msg *msg;
> +	struct timespec64 ts;
> +	s64 sum, total;
> +	s32 items = 0;
> +	s32 len;
> +
> +	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
> +	      + sizeof(*meta);
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
> +	cap->compat = 1;
> +	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
> +	cap->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
> +	cap->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
> +	cap->total = cpu_to_le64(nr_caps);
> +	items++;
> +
> +	/* encode the read latency metric */
> +	read = (struct ceph_metric_read_latency *)(cap + 1);
> +	read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
> +	read->ver = 1;
> +	read->compat = 1;
> +	read->data_len = cpu_to_le32(sizeof(*read) - 10);
> +	total = m->total_reads;
> +	sum = m->read_latency_sum;
> +	jiffies_to_timespec64(sum, &ts);
> +	read->sec = cpu_to_le32(ts.tv_sec);
> +	read->nsec = cpu_to_le32(ts.tv_nsec);
> +	items++;
> +
> +	/* encode the write latency metric */
> +	write = (struct ceph_metric_write_latency *)(read + 1);
> +	write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
> +	write->ver = 1;
> +	write->compat = 1;
> +	write->data_len = cpu_to_le32(sizeof(*write) - 10);
> +	total = m->total_writes;
> +	sum = m->write_latency_sum;
> +	jiffies_to_timespec64(sum, &ts);
> +	write->sec = cpu_to_le32(ts.tv_sec);
> +	write->nsec = cpu_to_le32(ts.tv_nsec);
> +	items++;
> +
> +	/* encode the metadata latency metric */
> +	meta = (struct ceph_metric_metadata_latency *)(write + 1);
> +	meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
> +	meta->ver = 1;
> +	meta->compat = 1;
> +	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
> +	total = m->total_metadatas;
> +	sum = m->metadata_latency_sum;
> +	jiffies_to_timespec64(sum, &ts);
> +	meta->sec = cpu_to_le32(ts.tv_sec);
> +	meta->nsec = cpu_to_le32(ts.tv_nsec);
> +	items++;
> +
> +	put_unaligned_le32(items, &head->num);
> +	msg->front.iov_len = cpu_to_le32(len);
> +	msg->hdr.version = cpu_to_le16(1);
> +	msg->hdr.compat_version = cpu_to_le16(1);
> +	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
> +	dout("client%llu send metrics to mds%d\n",
> +	     ceph_client_gid(mdsc->fsc->client), s->s_mds);
> +	ceph_con_send(&s->s_con, msg);
> +
> +	return true;
> +}
> +
> +static struct ceph_mds_session *metric_get_session(struct ceph_mds_client *mdsc)
> +{
> +	struct ceph_mds_session *s;
> +	int i;
> +
> +	mutex_lock(&mdsc->mutex);
> +	for (i = 0; i < mdsc->max_sessions; i++) {
> +		s = __ceph_lookup_mds_session(mdsc, i);
> +		if (!s)
> +			continue;
> +		mutex_unlock(&mdsc->mutex);
> +

Why unlock here? AFAICT, it's safe to call ceph_put_mds_session with the
mdsc->mutex held.

> +		/*
> +		 * Skip it if MDS doesn't support the metric collection,
> +		 * or the MDS will close the session's socket connection
> +		 * directly when it get this message.
> +		 */
> +		if (check_session_state(s) &&
> +		    test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)) {
> +			mdsc->metric.mds = i;
> +			return s;
> +		}
> +		ceph_put_mds_session(s);
> +
> +		mutex_lock(&mdsc->mutex);
> +	}
> +	mutex_unlock(&mdsc->mutex);
> +
> +	return NULL;
> +}
> +
> +static void metric_delayed_work(struct work_struct *work)
> +{
> +	struct ceph_client_metric *m =
> +		container_of(work, struct ceph_client_metric, delayed_work.work);
> +	struct ceph_mds_client *mdsc =
> +		container_of(m, struct ceph_mds_client, metric);
> +	struct ceph_mds_session *s = NULL;
> +	u64 nr_caps = atomic64_read(&m->total_caps);
> +
> +	/* No mds supports the metric collection, will stop the work */
> +	if (!atomic_read(&m->mds_cnt))
> +		return;
> +
> +	mutex_lock(&mdsc->mutex);
> +	s = __ceph_lookup_mds_session(mdsc, m->mds);
> +	mutex_unlock(&mdsc->mutex);


Instead of doing a lookup of the mds every time we need to do this,
would it be better to instead just do a lookup before you first schedule
the work and keep a reference to it until the session state is no longer
good?

With that, you'd only need to take the mutex here if check_session_state
indicated that the session you had saved was no longer good.

> +	if (unlikely(!s || !check_session_state(s) ||
> +	    !test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)))
> +		s = metric_get_session(mdsc);
> +

If we do need to keep doing a lookup every time, then it'd probably be
better to do the above check while holding the mdsc->mutex and just have
metric_get_session expect to be called with the mutex already held.

FWIW, mutexes are expensive locks since you can end up having to
schedule() if you can't get it. Minimizing the number of acquisitions
and simply holding them for a little longer is often the more efficient
approach.

> +	if (s) {
> +		/* Only send the metric once in any available session */
> +		ceph_mdsc_send_metrics(mdsc, s, nr_caps);
> +		ceph_put_mds_session(s);
> +	}
> +
> +	metric_schedule_delayed(m);
> +}
>  
>  int ceph_metric_init(struct ceph_client_metric *m)
>  {
> @@ -52,6 +204,11 @@ int ceph_metric_init(struct ceph_client_metric *m)
>  	m->total_metadatas = 0;
>  	m->metadata_latency_sum = 0;
>  
> +	/* We assume the rank 0 support it as default */
> +	m->mds = 0;
> +	atomic_set(&m->mds_cnt, 0);
> +	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
> +
>  	return 0;
>  
>  err_i_caps_mis:
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 23a3373..68e2d17 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -6,6 +6,71 @@
>  #include <linux/percpu_counter.h>
>  #include <linux/ktime.h>
>  
> +extern bool disable_send_metrics;
> +
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
> +	__u8  compat;
> +
> +	__le32 data_len; /* length of sizeof(hit + mis + total) */
> +	__le64 hit;
> +	__le64 mis;
> +	__le64 total;
> +} __packed;
> +
> +/* metric read latency header */
> +struct ceph_metric_read_latency {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  compat;
> +
> +	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	__le32 sec;
> +	__le32 nsec;
> +} __packed;
> +
> +/* metric write latency header */
> +struct ceph_metric_write_latency {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  compat;
> +
> +	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	__le32 sec;
> +	__le32 nsec;
> +} __packed;
> +
> +/* metric metadata latency header */
> +struct ceph_metric_metadata_latency {
> +	__le32 type;     /* ceph metric type */
> +
> +	__u8  ver;
> +	__u8  compat;
> +
> +	__le32 data_len; /* length of sizeof(sec + nsec) */
> +	__le32 sec;
> +	__le32 nsec;
> +} __packed;
> +
> +struct ceph_metric_head {
> +	__le32 num;	/* the number of metrics that will be sent */
> +} __packed;
> +
>  /* This is the global metrics */
>  struct ceph_client_metric {
>  	atomic64_t            total_dentries;
> @@ -36,8 +101,25 @@ struct ceph_client_metric {
>  	ktime_t metadata_latency_sq_sum;
>  	ktime_t metadata_latency_min;
>  	ktime_t metadata_latency_max;
> +
> +	int mds; /* the MDS being used to send the metrics to */
> +	atomic_t mds_cnt;  /* how many MDSs support metrics collection */
> +	struct delayed_work delayed_work;  /* delayed work */
>  };
>  
> +static inline void metric_schedule_delayed(struct ceph_client_metric *m)
> +{
> +	/*
> +	 * If send metrics is disabled or no mds support metric
> +	 * collection, will stop the work
> +	 */
> +	if (disable_send_metrics || !atomic_read(&m->mds_cnt))
> +		return;
> +
> +	/* per second */
> +	schedule_delayed_work(&m->delayed_work, round_jiffies_relative(HZ));
> +}
> +
>  extern int ceph_metric_init(struct ceph_client_metric *m);
>  extern void ceph_metric_destroy(struct ceph_client_metric *m);
>  
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index c9784eb1..cd33836 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -27,6 +27,9 @@
>  #include <linux/ceph/auth.h>
>  #include <linux/ceph/debugfs.h>
>  
> +static DEFINE_MUTEX(ceph_fsc_lock);

I think this could be a spinlock. None of the operations it protects
look like they can sleep.

> +static LIST_HEAD(ceph_fsc_list);
> +
>  /*
>   * Ceph superblock operations
>   *
> @@ -691,6 +694,10 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  	if (!fsc->wb_pagevec_pool)
>  		goto fail_cap_wq;
>  
> +	mutex_lock(&ceph_fsc_lock);
> +	list_add_tail(&fsc->metric_wakeup, &ceph_fsc_list);
> +	mutex_unlock(&ceph_fsc_lock);
> +
>  	return fsc;
>  
>  fail_cap_wq:
> @@ -717,6 +724,10 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>  {
>  	dout("destroy_fs_client %p\n", fsc);
>  
> +	mutex_lock(&ceph_fsc_lock);
> +	list_del(&fsc->metric_wakeup);
> +	mutex_unlock(&ceph_fsc_lock);
> +
>  	ceph_mdsc_destroy(fsc);
>  	destroy_workqueue(fsc->inode_wq);
>  	destroy_workqueue(fsc->cap_wq);
> @@ -1282,6 +1293,37 @@ static void __exit exit_ceph(void)
>  	destroy_caches();
>  }
>  
> +static int param_set_metrics(const char *val, const struct kernel_param *kp)
> +{
> +	struct ceph_fs_client *fsc;
> +	int ret;
> +
> +	ret = param_set_bool(val, kp);
> +	if (ret) {
> +		pr_err("Failed to parse sending metrics switch value '%s'\n",
> +		       val);
> +		return ret;
> +	} else if (!disable_send_metrics) {
> +		// wake up all the mds clients
> +		mutex_lock(&ceph_fsc_lock);
> +		list_for_each_entry(fsc, &ceph_fsc_list, metric_wakeup) {
> +			metric_schedule_delayed(&fsc->mdsc->metric);
> +		}
> +		mutex_unlock(&ceph_fsc_lock);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops param_ops_metrics = {
> +	.set = param_set_metrics,
> +	.get = param_get_bool,
> +};
> +
> +bool disable_send_metrics = false;
> +module_param_cb(disable_send_metrics, &param_ops_metrics, &disable_send_metrics, 0644);
> +MODULE_PARM_DESC(disable_send_metrics, "Enable sending perf metrics to ceph cluster (default: on)");
> +
>  module_init(init_ceph);
>  module_exit(exit_ceph);
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 5a6cdd3..2dcb6a9 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -101,6 +101,8 @@ struct ceph_mount_options {
>  struct ceph_fs_client {
>  	struct super_block *sb;
>  
> +	struct list_head metric_wakeup;
> +
>  	struct ceph_mount_options *mount_options;
>  	struct ceph_client *client;
>  
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index ebf5ba6..455e9b9 100644
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

