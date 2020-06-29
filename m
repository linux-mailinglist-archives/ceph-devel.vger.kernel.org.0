Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ECE20D486
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jun 2020 21:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgF2TJV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jun 2020 15:09:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730498AbgF2TJT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jun 2020 15:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593457756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6hvY2LNkM2U4mZCN5wPoKEm1tn7tfAh+7cis46TMxvA=;
        b=TXXGiyHtay3cEXSbXh8MFU0ZzAa+EhMlR22iHU7mUeAPxxbBWypLksK1Xywi79chKxAFSq
        eYdBram2ui313zLuKD3UCRAD4Ds8kepx5jgnYfkU0PYSNmEAUHKQjk9HZk39+LM2gHOwSU
        uuKDVoy1aCgi+ZH7HqREtRlpDxhOToM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-mc80VaxdM0aEcIJepnhfsQ-1; Mon, 29 Jun 2020 09:06:25 -0400
X-MC-Unique: mc80VaxdM0aEcIJepnhfsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64D7B106B213;
        Mon, 29 Jun 2020 13:06:24 +0000 (UTC)
Received: from [10.72.13.235] (ovpn-13-235.pek2.redhat.com [10.72.13.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E65207BEA3;
        Mon, 29 Jun 2020 13:06:21 +0000 (UTC)
Subject: Re: [PATCH v4 3/5] ceph: periodically send perf metrics to ceph
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1593333734-27480-1-git-send-email-xiubli@redhat.com>
 <1593333734-27480-4-git-send-email-xiubli@redhat.com>
 <fe312db727af918b5835678e6674a23e714a8717.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <799d1bab-07a7-2437-866a-1665c08d865a@redhat.com>
Date:   Mon, 29 Jun 2020 21:06:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fe312db727af918b5835678e6674a23e714a8717.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/29 19:51, Jeff Layton wrote:
> On Sun, 2020-06-28 at 04:42 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will send the caps/read/write/metadata metrics to any available
>> MDS only once per second as default, which will be the same as the
>> userland client. It will skip the MDS sessions which don't support
>> the metric collection, or the MDSs will close the socket connections
>> directly when it get an unknown type message.
>>
>> We can disable the metric sending via the enable_send_metric module
>> parameter.
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         |  29 +++++++++
>>   fs/ceph/mds_client.h         |   6 +-
>>   fs/ceph/metric.c             | 142 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/metric.h             |  75 +++++++++++++++++++++++
>>   fs/ceph/super.c              |  44 ++++++++++++++
>>   fs/ceph/super.h              |   2 +
>>   include/linux/ceph/ceph_fs.h |   1 +
>>   7 files changed, 298 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 2eeab10..18f43a4 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -754,6 +754,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>>   	s->s_cap_iterator = NULL;
>>   	INIT_LIST_HEAD(&s->s_cap_releases);
>>   	INIT_WORK(&s->s_cap_release_work, ceph_cap_release_work);
>> +	INIT_DELAYED_WORK(&s->metric_delayed_work, ceph_metric_delayed_work);
>>   
>>   	INIT_LIST_HEAD(&s->s_cap_dirty);
>>   	INIT_LIST_HEAD(&s->s_cap_flushing);
>> @@ -1801,6 +1802,20 @@ static int request_close_session(struct ceph_mds_client *mdsc,
>>   	return 1;
>>   }
>>   
>> +static void try_reset_metric_work(struct ceph_mds_client *mdsc,
>> +				  struct ceph_mds_session *session)
>> +{
>> +	mutex_lock(&mdsc->mutex);
>> +	if (mdsc->metric.mds == session->s_mds) {
>> +		mdsc->metric.mds = -1;
>> +		cancel_delayed_work_sync(&session->metric_delayed_work);
>> +
>> +		/* Choose a new session to run the metric work */
>> +		ceph_choose_new_metric_session(mdsc);
>> +	}
>> +	mutex_unlock(&mdsc->mutex);
>> +}
>> +
>>   /*
>>    * Called with s_mutex held.
>>    */
>> @@ -1810,6 +1825,9 @@ static int __close_session(struct ceph_mds_client *mdsc,
>>   	if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
>>   		return 0;
>>   	session->s_state = CEPH_MDS_SESSION_CLOSING;
>> +
>> +	try_reset_metric_work(mdsc, session);
>> +
>>   	return request_close_session(mdsc, session);
>>   }
>>   
>> @@ -3312,6 +3330,15 @@ static void handle_session(struct ceph_mds_session *session,
>>   		session->s_features = features;
>>   		renewed_caps(mdsc, session, 0);
>>   		wake = 1;
>> +
>> +		mutex_lock(&mdsc->mutex);
>> +		if (mdsc->metric.mds < 0 &&
>> +		    test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features)) {
>> +			ceph_metric_schedule_delayed(session);
>> +			mdsc->metric.mds = session->s_mds;
>> +		}
>> +		mutex_unlock(&mdsc->mutex);
>> +
>>   		if (mdsc->stopping)
>>   			__close_session(mdsc, session);
>>   		break;
>> @@ -3806,6 +3833,8 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
>>   
>>   	xa_destroy(&session->s_delegated_inos);
>>   
>> +	try_reset_metric_work(mdsc, session);
>> +
>>   	mutex_lock(&session->s_mutex);
>>   	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
>>   	session->s_seq = 0;
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index bcb3892..daa905f 100644
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
>> @@ -212,6 +214,8 @@ struct ceph_mds_session {
>>   	struct list_head  s_waiting;  /* waiting requests */
>>   	struct list_head  s_unsafe;   /* unsafe requests */
>>   	struct xarray	  s_delegated_inos;
>> +
>> +	struct delayed_work metric_delayed_work;  /* delayed work */
>>   };
>>   
> (cc'ing Venky)
>
> My apologies, Xiubo:
>
> The cover letter was a bit vague, and I missed an important point with
> the v3 set. That made it sound like you were sending stats to all the
> MDS's that support them. That's not the case though -- you're attempting
> to send them to each MDS in turn and then you stop up once a send is
> successful.

Ah sorry, the comments are not that correct as the code does.

For this version we will only have one active workqueue job running on 
an MDS session which supports it and send the metrics once per second, 
all the other sessions' workqueue jobs will be in standy mode. With this 
we can totally get rid of the mdsc->mutex in the workqueue job here.


> If you have to coordinate and ensure that the stats are only sent once,

Since no matter which MDS receives the metrics it will report them to 
the MDS with rank 0, so the clients need to send the metrics to at least 
1 MDS each time.


> then we're probably better off with a single workqueue job after all. I
> do still think though that we need to get the mdsc->mutex out of this
> code as much as possible though. That's a rather highly contended mutex
> and having stats code flogging it regularly is less than ideal.

IMO both approaches should be fine, but since the workqueue job running 
periodically per second, mutlti workqueue jobs should be better ?

And the following is another approach with a single workqueue job, no 
matter we save the session itself or mds rank number in mdsc, we need to 
and cannot get rid of the mdsc->mutex lock. But mostly the code in 
mdsc->mutex lock/unlock pair should be short and fast and also should be 
rare running into the unlikely() case:

.

+/*
+ * called under mdsc->mutex
+ */
+static struct ceph_mds_session *metric_get_session(struct ceph_mds_client *mdsc)
+{
+	struct ceph_mds_session *s;
+	int i;
+
+	for (i = 0; i < mdsc->max_sessions; i++) {
+		s = __ceph_lookup_mds_session(mdsc, i);
+		if (!s)
+			continue;
+
+		if (!check_session_state(mdsc, s)) {
+			ceph_put_mds_session(s);
+			continue;
+		}
+
+		/*
+		 * Skip it if MDS doesn't support the metric collection,
+		 * or the MDS will close the session's socket connection
+		 * directly when it get this message.
+		 */
+		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)) {
+			mdsc->metric.mds = i;
+			return s;
+		}
+
+		ceph_put_mds_session(s);
+	}
+
+	return NULL;
+}
+
+static void metric_delayed_work(struct work_struct *work)
+{
+	struct ceph_client_metric *m =
+		container_of(work, struct ceph_client_metric, delayed_work.work);
+	struct ceph_mds_client *mdsc =
+		container_of(m, struct ceph_mds_client, metric);
+	struct ceph_mds_session *s = NULL;
+	u64 nr_caps = atomic64_read(&m->total_caps);
+
+	/* No mds supports the metric collection, will stop the work */
+	if (!atomic_read(&m->mds_cnt))
+		return;
+
+	mutex_lock(&mdsc->mutex);
+	s = __ceph_lookup_mds_session(mdsc, m->mds);
+	if (unlikely(!s || !test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)))
+		s = metric_get_session(mdsc);
+	mutex_unlock(&mdsc->mutex);
+	if (likely(s)) {
+		/* Only send the metric once in any available session */
+		ceph_mdsc_send_metrics(mdsc, s, nr_caps);
+		ceph_put_mds_session(s);
+	}
+
+	metric_schedule_delayed(m);
+}



>>   /*
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 269eacb..47eba86 100644
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
>> +void ceph_metric_delayed_work(struct work_struct *work)
>> +{
>> +	struct ceph_mds_session *s =
>> +		container_of(work, struct ceph_mds_session, metric_delayed_work.work);
>> +	struct ceph_mds_client *mdsc = s->s_mdsc;
>> +	u64 nr_caps = atomic64_read(&mdsc->metric.total_caps);
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
>> +		return;
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
>> +	ceph_metric_schedule_delayed(s);
>> +}
>> +
>> +/*
>> + * called under mdsc->mutex
>> + */
> Instead of comments like this, add this to the function:
>
>      lockdep_assert_held(&mdsc->mutex);
>
> That both documents the requirement and should help us catch cases where
> that isn't done in lockdep-enabled builds.

Sure, will fix it.


>
>> +void ceph_choose_new_metric_session(struct ceph_mds_client *mdsc)
>> +{
>> +	struct ceph_mds_session *s;
>> +	int i;
>> +
>> +	if (mdsc->stopping)
>> +		return;
>> +
>> +	for (i = 0; i < mdsc->max_sessions; i++) {
>> +		s = __ceph_lookup_mds_session(mdsc, i);
>> +		if (!s)
>> +			continue;
>> +
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
>> +		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)) {
>> +			mdsc->metric.mds = i;
>> +			ceph_metric_schedule_delayed(s);
>> +			ceph_put_mds_session(s);
>> +			return;
>> +		}
>> +
>> +		ceph_put_mds_session(s);
>> +	}
>> +}
>> +
>> +void ceph_metric_schedule_delayed(struct ceph_mds_session *s)
>> +{
>> +	if (!enable_send_metrics)
>> +		return;
>> +
>> +	/* per second */
>> +	schedule_delayed_work(&s->metric_delayed_work, round_jiffies_relative(HZ));
>> +}
>>   
>>   int ceph_metric_init(struct ceph_client_metric *m)
>>   {
>> @@ -52,6 +192,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>   	m->total_metadatas = 0;
>>   	m->metadata_latency_sum = 0;
>>   
>> +	m->mds = -1;
>> +
>>   	return 0;
>>   
>>   err_i_caps_mis:
>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>> index 23a3373..1a7e3fb 100644
>> --- a/fs/ceph/metric.h
>> +++ b/fs/ceph/metric.h
>> @@ -6,6 +6,74 @@
>>   #include <linux/percpu_counter.h>
>>   #include <linux/ktime.h>
>>   
>> +struct ceph_mds_client;
>> +struct ceph_mds_session;
>> +
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
>> @@ -36,8 +104,15 @@ struct ceph_client_metric {
>>   	ktime_t metadata_latency_sq_sum;
>>   	ktime_t metadata_latency_min;
>>   	ktime_t metadata_latency_max;
>> +
>> +	/* The MDS session running the metric work */
>> +	int mds;
>>   };
>>   
>> +extern void ceph_metric_delayed_work(struct work_struct *work);
>> +extern void ceph_metric_schedule_delayed(struct ceph_mds_session *s);
>> +extern void ceph_choose_new_metric_session(struct ceph_mds_client *mdsc);
>> +
>>   extern int ceph_metric_init(struct ceph_client_metric *m);
>>   extern void ceph_metric_destroy(struct ceph_client_metric *m);
>>   
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index c9784eb1..510ccb1 100644
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
>> @@ -1282,6 +1293,39 @@ static void __exit exit_ceph(void)
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
>> +			mutex_lock(&fsc->mdsc->mutex);
>> +			ceph_choose_new_metric_session(fsc->mdsc);
>> +			mutex_unlock(&fsc->mdsc->mutex);
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
> Let's not name this list_head "list". It should be something more
> distinctive.

Okay, will fix it.

Thanks.


>
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


