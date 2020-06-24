Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24AD206EFB
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jun 2020 10:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389304AbgFXIco (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jun 2020 04:32:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21575 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387606AbgFXIcn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Jun 2020 04:32:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592987559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1W2wZ0Y8H6S50Qz9TKE1o5NyeuB/et2ZIMS6nGOzSU=;
        b=JjKFURe1EEzksFGgzriiXjKwTsM9B1RETa7BNBiM1tOddKLtBehK2f3M3V4c1TsNflCzef
        MXbWY2qtXtXPZVyEiC2PY6ev50yr+7xVv+AaqD6apbGxp+oFGFOWiNl/xj70lmZv6wXv3K
        bMZfSnOc6cJ3bJshNcRgHFPHiTr8dG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-XpDu2iXjOxa2Be8UUtRH0g-1; Wed, 24 Jun 2020 04:32:34 -0400
X-MC-Unique: XpDu2iXjOxa2Be8UUtRH0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2C6A107ACF2;
        Wed, 24 Jun 2020 08:32:32 +0000 (UTC)
Received: from [10.72.13.235] (ovpn-13-235.pek2.redhat.com [10.72.13.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 99F337C375;
        Wed, 24 Jun 2020 08:32:30 +0000 (UTC)
Subject: Re: [PATCH v3 2/4] ceph: periodically send perf metrics to ceph
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1592832300-29109-1-git-send-email-xiubli@redhat.com>
 <1592832300-29109-3-git-send-email-xiubli@redhat.com>
 <20081fe82338e7fbe686ced11275db5a3af9d140.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d0effa82-8464-35ba-56c3-15fe10c6fa1e@redhat.com>
Date:   Wed, 24 Jun 2020 16:32:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20081fe82338e7fbe686ced11275db5a3af9d140.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/24 1:24, Jeff Layton wrote:
> On Mon, 2020-06-22 at 09:24 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will send the caps/read/write/metadata metrics to any available
>> MDS only once per second as default, which will be the same as the
>> userland client, or every metric_send_interval seconds, which is a
>> module parameter.
>>
>> Skip the MDS sessions if they don't support the metric collection,
>> or the MDSs will close the socket connections directly when it get
>> an unknown type message.
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         |   3 +
>>   fs/ceph/mds_client.h         |   4 +-
>>   fs/ceph/metric.c             | 142 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/metric.h             |  78 ++++++++++++++++++++++++
>>   fs/ceph/super.c              |  42 +++++++++++++
>>   fs/ceph/super.h              |   2 +
>>   include/linux/ceph/ceph_fs.h |   1 +
>>   7 files changed, 271 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 608fb5c..f996363 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4625,6 +4625,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>>   
>>   	cancel_work_sync(&mdsc->cap_reclaim_work);
>>   	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
>> +	cancel_delayed_work_sync(&mdsc->metric.delayed_work); /* cancel timer */
>>   
>>   	dout("stopped\n");
>>   }
>> @@ -4667,6 +4668,7 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
>>   {
>>   	dout("stop\n");
>>   	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
>> +	cancel_delayed_work_sync(&mdsc->metric.delayed_work); /* cancel timer */
>>   	if (mdsc->mdsmap)
>>   		ceph_mdsmap_destroy(mdsc->mdsmap);
>>   	kfree(mdsc->sessions);
>> @@ -4824,6 +4826,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
>>   
>>   	mutex_unlock(&mdsc->mutex);
>>   	schedule_delayed(mdsc);
>> +	metric_schedule_delayed(&mdsc->metric);
>>   	return;
>>   
>>   bad_unlock:
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index bcb3892..3c65ac1 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -28,8 +28,9 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_LAZY_CAP_WANTED,
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,
>>   	CEPHFS_FEATURE_DELEG_INO,
>> +	CEPHFS_FEATURE_METRIC_COLLECT,
>>   
>> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
>> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>>   };
>>   
>>   /*
>> @@ -43,6 +44,7 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>>   	CEPHFS_FEATURE_DELEG_INO,		\
>> +	CEPHFS_FEATURE_METRIC_COLLECT,		\
>>   						\
>>   	CEPHFS_FEATURE_MAX,			\
>>   }
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 9217f35..4267b46 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -1,10 +1,150 @@
>>   /* SPDX-License-Identifier: GPL-2.0 */
>> +#include <linux/ceph/ceph_debug.h>
>>   
>>   #include <linux/types.h>
>>   #include <linux/percpu_counter.h>
>>   #include <linux/math64.h>
>>   
>>   #include "metric.h"
>> +#include "mds_client.h"
>> +
>> +static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>> +				   struct ceph_mds_session *s,
>> +				   u64 nr_caps)
>> +{
>> +	struct ceph_metric_head *head;
>> +	struct ceph_metric_cap *cap;
>> +	struct ceph_metric_read_latency *read;
>> +	struct ceph_metric_write_latency *write;
>> +	struct ceph_metric_metadata_latency *meta;
>> +	struct ceph_client_metric *m = &mdsc->metric;
>> +	struct ceph_msg *msg;
>> +	struct timespec64 ts;
>> +	s64 sum, total;
>> +	s32 items = 0;
>> +	s32 len;
>> +
>> +	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
>> +	      + sizeof(*meta);
>> +
>> +	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
>> +	if (!msg) {
>> +		pr_err("send metrics to mds%d, failed to allocate message\n",
>> +		       s->s_mds);
>> +		return false;
>> +	}
>> +
>> +	head = msg->front.iov_base;
>> +
>> +	/* encode the cap metric */
>> +	cap = (struct ceph_metric_cap *)(head + 1);
>> +	cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
>> +	cap->ver = 1;
>> +	cap->compat = 1;
>> +	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
>> +	cap->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
>> +	cap->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
>> +	cap->total = cpu_to_le64(nr_caps);
>> +	items++;
>> +
>> +	/* encode the read latency metric */
>> +	read = (struct ceph_metric_read_latency *)(cap + 1);
>> +	read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
>> +	read->ver = 1;
>> +	read->compat = 1;
>> +	read->data_len = cpu_to_le32(sizeof(*read) - 10);
>> +	total = m->total_reads;
>> +	sum = m->read_latency_sum;
>> +	jiffies_to_timespec64(sum, &ts);
>> +	read->sec = cpu_to_le32(ts.tv_sec);
>> +	read->nsec = cpu_to_le32(ts.tv_nsec);
>> +	items++;
>> +
>> +	/* encode the write latency metric */
>> +	write = (struct ceph_metric_write_latency *)(read + 1);
>> +	write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
>> +	write->ver = 1;
>> +	write->compat = 1;
>> +	write->data_len = cpu_to_le32(sizeof(*write) - 10);
>> +	total = m->total_writes;
>> +	sum = m->write_latency_sum;
>> +	jiffies_to_timespec64(sum, &ts);
>> +	write->sec = cpu_to_le32(ts.tv_sec);
>> +	write->nsec = cpu_to_le32(ts.tv_nsec);
>> +	items++;
>> +
>> +	/* encode the metadata latency metric */
>> +	meta = (struct ceph_metric_metadata_latency *)(write + 1);
>> +	meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
>> +	meta->ver = 1;
>> +	meta->compat = 1;
>> +	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
>> +	total = m->total_metadatas;
>> +	sum = m->metadata_latency_sum;
>> +	jiffies_to_timespec64(sum, &ts);
>> +	meta->sec = cpu_to_le32(ts.tv_sec);
>> +	meta->nsec = cpu_to_le32(ts.tv_nsec);
>> +	items++;
>> +
>> +	put_unaligned_le32(items, &head->num);
>> +	msg->front.iov_len = cpu_to_le32(len);
>> +	msg->hdr.version = cpu_to_le16(1);
>> +	msg->hdr.compat_version = cpu_to_le16(1);
>> +	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
>> +	dout("client%llu send metrics to mds%d\n",
>> +	     ceph_client_gid(mdsc->fsc->client), s->s_mds);
>> +	ceph_con_send(&s->s_con, msg);
>> +
>> +	return true;
>> +}
>> +
>> +static void metric_delayed_work(struct work_struct *work)
>> +{
>> +	struct ceph_client_metric *m =
>> +		container_of(work, struct ceph_client_metric, delayed_work.work);
>> +	struct ceph_mds_client *mdsc =
>> +		container_of(m, struct ceph_mds_client, metric);
>> +	struct ceph_mds_session *s;
>> +	u64 nr_caps = 0;
>> +	bool ret;
>> +	int i;
>> +
>> +	mutex_lock(&mdsc->mutex);
>> +	for (i = 0; i < mdsc->max_sessions; i++) {
>> +		s = __ceph_lookup_mds_session(mdsc, i);
>> +		if (!s)
>> +			continue;
>> +		nr_caps += s->s_nr_caps;
>> +		ceph_put_mds_session(s);
>> +	}
>> +
>> +	for (i = 0; i < mdsc->max_sessions; i++) {
>> +		s = __ceph_lookup_mds_session(mdsc, i);
>> +		if (!s)
>> +			continue;
>> +		if (!check_session_state(mdsc, s)) {
>> +			ceph_put_mds_session(s);
>> +			continue;
>> +		}
>> +
>> +		/*
>> +		 * Skip it if MDS doesn't support the metric collection,
>> +		 * or the MDS will close the session's socket connection
>> +		 * directly when it get this message.
>> +		 */
>> +		if (!test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features))
>> +			continue;
>> +
>> +		/* Only send the metric once in any available session */
>> +		ret = ceph_mdsc_send_metrics(mdsc, s, nr_caps);
>> +		ceph_put_mds_session(s);
>> +		if (ret)
>> +			break;
>> +	}
>> +	mutex_unlock(&mdsc->mutex);
>> +
>> +	metric_schedule_delayed(&mdsc->metric);
>> +}
>>   
> You're going to be queueing this job up to run every second, even when
> none of your MDS's support metrics.
>
> I think it would be better that we make this job conditional on having
> at least one session with an MDS that supports receiving metrics. Maybe
> have each MDS session hold a reference to the scheduled job and when the
> refcount goes to 0, we cancel it...
>
> A simpler approach here might be to just give each session its own
> struct work, and only queue the work if the session supports metrics.
> That way you could just cancel the work as part of each session's
> teardown. I think that would also mean you wouldn't need the mdsc->mutex
> here either, which would be a bonus.

Yeah, we need to enhance the code here.

Since we only need to send the metrics to any of the available MDSs and 
the MDS with rank 0 is responsible to collect  them.  But we still need 
to traverse all the mdsc->sessions to collect the total cap number and 
it is hard to get rid of the mdsc->mutex.

As you mentioned above we could just add one ref counter to record the 
total number of MDSs supporting the metric collection, when opening a 
session & ref counter 0 --> 1 then wake up the work and when closing the 
session & ref counter 1 --> 0 then cancel it.

Thanks.


>
> Thoughts?
>
>
>>   int ceph_metric_init(struct ceph_client_metric *m)
>>   {
>> @@ -51,6 +191,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>   	m->total_metadatas = 0;
>>   	m->metadata_latency_sum = 0;
>>   
>> +	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
>> +
>>   	return 0;
>>   
>>   err_i_caps_mis:
>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>> index ccd8128..5a1f8b9 100644
>> --- a/fs/ceph/metric.h
>> +++ b/fs/ceph/metric.h
>> @@ -6,6 +6,71 @@
>>   #include <linux/percpu_counter.h>
>>   #include <linux/ktime.h>
>>   
>> +extern bool enable_send_metrics;
>> +
>> +enum ceph_metric_type {
>> +	CLIENT_METRIC_TYPE_CAP_INFO,
>> +	CLIENT_METRIC_TYPE_READ_LATENCY,
>> +	CLIENT_METRIC_TYPE_WRITE_LATENCY,
>> +	CLIENT_METRIC_TYPE_METADATA_LATENCY,
>> +	CLIENT_METRIC_TYPE_DENTRY_LEASE,
>> +
>> +	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
>> +};
>> +
>> +/* metric caps header */
>> +struct ceph_metric_cap {
>> +	__le32 type;     /* ceph metric type */
>> +
>> +	__u8  ver;
>> +	__u8  compat;
>> +
>> +	__le32 data_len; /* length of sizeof(hit + mis + total) */
>> +	__le64 hit;
>> +	__le64 mis;
>> +	__le64 total;
>> +} __packed;
>> +
>> +/* metric read latency header */
>> +struct ceph_metric_read_latency {
>> +	__le32 type;     /* ceph metric type */
>> +
>> +	__u8  ver;
>> +	__u8  compat;
>> +
>> +	__le32 data_len; /* length of sizeof(sec + nsec) */
>> +	__le32 sec;
>> +	__le32 nsec;
>> +} __packed;
>> +
>> +/* metric write latency header */
>> +struct ceph_metric_write_latency {
>> +	__le32 type;     /* ceph metric type */
>> +
>> +	__u8  ver;
>> +	__u8  compat;
>> +
>> +	__le32 data_len; /* length of sizeof(sec + nsec) */
>> +	__le32 sec;
>> +	__le32 nsec;
>> +} __packed;
>> +
>> +/* metric metadata latency header */
>> +struct ceph_metric_metadata_latency {
>> +	__le32 type;     /* ceph metric type */
>> +
>> +	__u8  ver;
>> +	__u8  compat;
>> +
>> +	__le32 data_len; /* length of sizeof(sec + nsec) */
>> +	__le32 sec;
>> +	__le32 nsec;
>> +} __packed;
>> +
>> +struct ceph_metric_head {
>> +	__le32 num;	/* the number of metrics that will be sent */
>> +} __packed;
>> +
>>   /* This is the global metrics */
>>   struct ceph_client_metric {
>>   	atomic64_t            total_dentries;
>> @@ -35,8 +100,21 @@ struct ceph_client_metric {
>>   	ktime_t metadata_latency_sq_sum;
>>   	ktime_t metadata_latency_min;
>>   	ktime_t metadata_latency_max;
>> +
>> +	struct delayed_work delayed_work;  /* delayed work */
>>   };
>>   
>> +static inline void metric_schedule_delayed(struct ceph_client_metric *m)
>> +{
>> +	/* per second as default */
>> +	unsigned int hz = round_jiffies_relative(HZ * enable_send_metrics);
>> +
>> +	if (!enable_send_metrics)
>> +		return;
>> +
>> +	schedule_delayed_work(&m->delayed_work, hz);
>> +}
>> +
>>   extern int ceph_metric_init(struct ceph_client_metric *m);
>>   extern void ceph_metric_destroy(struct ceph_client_metric *m);
>>   
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index c9784eb1..49f20ea 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -27,6 +27,9 @@
>>   #include <linux/ceph/auth.h>
>>   #include <linux/ceph/debugfs.h>
>>   
>> +static DEFINE_MUTEX(ceph_fsc_lock);
>> +static LIST_HEAD(ceph_fsc_list);
>> +
>>   /*
>>    * Ceph superblock operations
>>    *
>> @@ -691,6 +694,10 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>>   	if (!fsc->wb_pagevec_pool)
>>   		goto fail_cap_wq;
>>   
>> +	mutex_lock(&ceph_fsc_lock);
>> +	list_add_tail(&fsc->list, &ceph_fsc_list);
>> +	mutex_unlock(&ceph_fsc_lock);
>> +
>>   	return fsc;
>>   
>>   fail_cap_wq:
>> @@ -717,6 +724,10 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>>   {
>>   	dout("destroy_fs_client %p\n", fsc);
>>   
>> +	mutex_lock(&ceph_fsc_lock);
>> +	list_del(&fsc->list);
>> +	mutex_unlock(&ceph_fsc_lock);
>> +
>>   	ceph_mdsc_destroy(fsc);
>>   	destroy_workqueue(fsc->inode_wq);
>>   	destroy_workqueue(fsc->cap_wq);
>> @@ -1282,6 +1293,37 @@ static void __exit exit_ceph(void)
>>   	destroy_caches();
>>   }
>>   
>> +static int param_set_metrics(const char *val, const struct kernel_param *kp)
>> +{
>> +	struct ceph_fs_client *fsc;
>> +	int ret;
>> +
>> +	ret = param_set_bool(val, kp);
>> +	if (ret) {
>> +		pr_err("Failed to parse sending metrics switch value '%s'\n",
>> +		       val);
>> +		return ret;
>> +	} else if (enable_send_metrics) {
>> +		// wake up all the mds clients
>> +		mutex_lock(&ceph_fsc_lock);
>> +		list_for_each_entry(fsc, &ceph_fsc_list, list) {
>> +			metric_schedule_delayed(&fsc->mdsc->metric);
>> +		}
>> +		mutex_unlock(&ceph_fsc_lock);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct kernel_param_ops param_ops_metrics = {
>> +	.set = param_set_metrics,
>> +	.get = param_get_bool,
>> +};
>> +
>> +bool enable_send_metrics = true;
>> +module_param_cb(enable_send_metrics, &param_ops_metrics, &enable_send_metrics, 0644);
>> +MODULE_PARM_DESC(enable_send_metrics, "Enable sending perf metrics to ceph cluster (default: on)");
>> +
>>   module_init(init_ceph);
>>   module_exit(exit_ceph);
>>   
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 5a6cdd3..05edc9a 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -101,6 +101,8 @@ struct ceph_mount_options {
>>   struct ceph_fs_client {
>>   	struct super_block *sb;
>>   
>> +	struct list_head list;
>> +
>>   	struct ceph_mount_options *mount_options;
>>   	struct ceph_client *client;
>>   
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index ebf5ba6..455e9b9 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -130,6 +130,7 @@ struct ceph_dir_layout {
>>   #define CEPH_MSG_CLIENT_REQUEST         24
>>   #define CEPH_MSG_CLIENT_REQUEST_FORWARD 25
>>   #define CEPH_MSG_CLIENT_REPLY           26
>> +#define CEPH_MSG_CLIENT_METRICS         29
>>   #define CEPH_MSG_CLIENT_CAPS            0x310
>>   #define CEPH_MSG_CLIENT_LEASE           0x311
>>   #define CEPH_MSG_CLIENT_SNAP            0x312


