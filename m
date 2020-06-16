Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291691FB130
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgFPMxA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 08:53:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55800 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728154AbgFPMxA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 08:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592311977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=FfrQraLkSB49Ej2DGsk+2jIkTT/VBoW6P+UDKO97xLI=;
        b=AzGIT7ksCVdMp2UmD5rZTNLxcB/M03I2aAVXH37W/9y0HvdhvfIN5uHq1209R8EQjR6n/O
        jUUIur39elbFNPlph6pWoT3h+dKS96NnZX98N2uKvgos0wdvTuNvR0OKtjnFKngqZG0grI
        BCqIl1xK3LbqSz/pxz/aREzkGeIkoQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-DGLTz1oTN-CXMUbfCHJLoQ-1; Tue, 16 Jun 2020 08:52:48 -0400
X-MC-Unique: DGLTz1oTN-CXMUbfCHJLoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3593318A8228;
        Tue, 16 Jun 2020 12:52:47 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F1D96ED96;
        Tue, 16 Jun 2020 12:52:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: periodically send perf metrics to ceph
Date:   Tue, 16 Jun 2020 08:52:29 -0400
Message-Id: <1592311950-17623-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1592311950-17623-1-git-send-email-xiubli@redhat.com>
References: <1592311950-17623-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will send the caps/read/write/metadata metrics to any available
MDS only once per second as default, which will be the same as the
userland client, or every metric_send_interval seconds, which is a
module parameter.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c         |  46 +++++++++------
 fs/ceph/mds_client.h         |   4 ++
 fs/ceph/metric.c             | 133 +++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h             |  78 +++++++++++++++++++++++++
 fs/ceph/super.c              |  29 ++++++++++
 include/linux/ceph/ceph_fs.h |   1 +
 6 files changed, 274 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a504971..f996363 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4263,6 +4263,30 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 	ceph_force_reconnect(fsc->sb);
 }
 
+bool check_session_state(struct ceph_mds_client *mdsc,
+			 struct ceph_mds_session *s)
+{
+	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
+		dout("resending session close request for mds%d\n",
+				s->s_mds);
+		request_close_session(mdsc, s);
+		return false;
+	}
+	if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
+		if (s->s_state == CEPH_MDS_SESSION_OPEN) {
+			s->s_state = CEPH_MDS_SESSION_HUNG;
+			pr_info("mds%d hung\n", s->s_mds);
+		}
+	}
+	if (s->s_state == CEPH_MDS_SESSION_NEW ||
+	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
+	    s->s_state == CEPH_MDS_SESSION_REJECTED)
+		/* this mds is failed or recovering, just wait */
+		return false;
+
+	return true;
+}
+
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
@@ -4294,23 +4318,8 @@ static void delayed_work(struct work_struct *work)
 		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
 		if (!s)
 			continue;
-		if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
-			dout("resending session close request for mds%d\n",
-			     s->s_mds);
-			request_close_session(mdsc, s);
-			ceph_put_mds_session(s);
-			continue;
-		}
-		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
-			if (s->s_state == CEPH_MDS_SESSION_OPEN) {
-				s->s_state = CEPH_MDS_SESSION_HUNG;
-				pr_info("mds%d hung\n", s->s_mds);
-			}
-		}
-		if (s->s_state == CEPH_MDS_SESSION_NEW ||
-		    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
-		    s->s_state == CEPH_MDS_SESSION_REJECTED) {
-			/* this mds is failed or recovering, just wait */
+
+		if (!check_session_state(mdsc, s)) {
 			ceph_put_mds_session(s);
 			continue;
 		}
@@ -4616,6 +4625,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 
 	cancel_work_sync(&mdsc->cap_reclaim_work);
 	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
+	cancel_delayed_work_sync(&mdsc->metric.delayed_work); /* cancel timer */
 
 	dout("stopped\n");
 }
@@ -4658,6 +4668,7 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 {
 	dout("stop\n");
 	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
+	cancel_delayed_work_sync(&mdsc->metric.delayed_work); /* cancel timer */
 	if (mdsc->mdsmap)
 		ceph_mdsmap_destroy(mdsc->mdsmap);
 	kfree(mdsc->sessions);
@@ -4815,6 +4826,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 
 	mutex_unlock(&mdsc->mutex);
 	schedule_delayed(mdsc);
+	metric_schedule_delayed(&mdsc->metric);
 	return;
 
 bad_unlock:
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 5e0c407..bcb3892 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -18,6 +18,7 @@
 #include <linux/ceph/auth.h>
 
 #include "metric.h"
+#include "super.h"
 
 /* The first 8 bits are reserved for old ceph releases */
 enum ceph_feature_type {
@@ -476,6 +477,9 @@ struct ceph_mds_client {
 
 extern const char *ceph_mds_op_name(int op);
 
+extern bool check_session_state(struct ceph_mds_client *mdsc,
+				struct ceph_mds_session *s);
+
 extern struct ceph_mds_session *
 __ceph_lookup_mds_session(struct ceph_mds_client *, int mds);
 
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 9217f35..3c9b0ec 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -1,10 +1,141 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/ceph/ceph_debug.h>
 
 #include <linux/types.h>
 #include <linux/percpu_counter.h>
 #include <linux/math64.h>
 
 #include "metric.h"
+#include "mds_client.h"
+
+static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
+				   struct ceph_mds_session *s,
+				   u64 nr_caps)
+{
+	struct ceph_metric_head *head;
+	struct ceph_metric_cap *cap;
+	struct ceph_metric_read_latency *read;
+	struct ceph_metric_write_latency *write;
+	struct ceph_metric_metadata_latency *meta;
+	struct ceph_client_metric *m = &mdsc->metric;
+	struct ceph_msg *msg;
+	struct timespec64 ts;
+	s64 sum, total;
+	s32 items = 0;
+	s32 len;
+
+	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
+	      + sizeof(*meta);
+
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
+	if (!msg) {
+		pr_err("send metrics to mds%d, failed to allocate message\n",
+		       s->s_mds);
+		return false;
+	}
+
+	head = msg->front.iov_base;
+
+	/* encode the cap metric */
+	cap = (struct ceph_metric_cap *)(head + 1);
+	cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
+	cap->ver = 1;
+	cap->compat = 1;
+	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
+	cap->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
+	cap->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
+	cap->total = cpu_to_le64(nr_caps);
+	items++;
+
+	/* encode the read latency metric */
+	read = (struct ceph_metric_read_latency *)(cap + 1);
+	read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
+	read->ver = 1;
+	read->compat = 1;
+	read->data_len = cpu_to_le32(sizeof(*read) - 10);
+	total = m->total_reads;
+	sum = m->read_latency_sum;
+	jiffies_to_timespec64(sum, &ts);
+	read->sec = cpu_to_le32(ts.tv_sec);
+	read->nsec = cpu_to_le32(ts.tv_nsec);
+	items++;
+
+	/* encode the write latency metric */
+	write = (struct ceph_metric_write_latency *)(read + 1);
+	write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
+	write->ver = 1;
+	write->compat = 1;
+	write->data_len = cpu_to_le32(sizeof(*write) - 10);
+	total = m->total_writes;
+	sum = m->write_latency_sum;
+	jiffies_to_timespec64(sum, &ts);
+	write->sec = cpu_to_le32(ts.tv_sec);
+	write->nsec = cpu_to_le32(ts.tv_nsec);
+	items++;
+
+	/* encode the metadata latency metric */
+	meta = (struct ceph_metric_metadata_latency *)(write + 1);
+	meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
+	meta->ver = 1;
+	meta->compat = 1;
+	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
+	total = m->total_metadatas;
+	sum = m->metadata_latency_sum;
+	jiffies_to_timespec64(sum, &ts);
+	meta->sec = cpu_to_le32(ts.tv_sec);
+	meta->nsec = cpu_to_le32(ts.tv_nsec);
+	items++;
+
+	put_unaligned_le32(items, &head->num);
+	msg->front.iov_len = cpu_to_le32(len);
+	msg->hdr.version = cpu_to_le16(1);
+	msg->hdr.compat_version = cpu_to_le16(1);
+	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
+	dout("send metrics to mds%d %p\n", s->s_mds, msg);
+	ceph_con_send(&s->s_con, msg);
+
+	return true;
+}
+
+static void metric_delayed_work(struct work_struct *work)
+{
+	struct ceph_client_metric *m =
+		container_of(work, struct ceph_client_metric, delayed_work.work);
+	struct ceph_mds_client *mdsc =
+		container_of(m, struct ceph_mds_client, metric);
+	struct ceph_mds_session *s;
+	u64 nr_caps = 0;
+	bool ret;
+	int i;
+
+	mutex_lock(&mdsc->mutex);
+	for (i = 0; i < mdsc->max_sessions; i++) {
+		s = __ceph_lookup_mds_session(mdsc, i);
+		if (!s)
+			continue;
+		nr_caps += s->s_nr_caps;
+		ceph_put_mds_session(s);
+	}
+
+	for (i = 0; i < mdsc->max_sessions; i++) {
+		s = __ceph_lookup_mds_session(mdsc, i);
+		if (!s)
+			continue;
+		if (!check_session_state(mdsc, s)) {
+			ceph_put_mds_session(s);
+			continue;
+		}
+
+		/* Only send the metric once in any available session */
+		ret = ceph_mdsc_send_metrics(mdsc, s, nr_caps);
+		ceph_put_mds_session(s);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&mdsc->mutex);
+
+	metric_schedule_delayed(&mdsc->metric);
+}
 
 int ceph_metric_init(struct ceph_client_metric *m)
 {
@@ -51,6 +182,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->total_metadatas = 0;
 	m->metadata_latency_sum = 0;
 
+	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
+
 	return 0;
 
 err_i_caps_mis:
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index ccd8128..2af9e0b 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -6,6 +6,71 @@
 #include <linux/percpu_counter.h>
 #include <linux/ktime.h>
 
+extern unsigned int metric_send_interval;
+
+enum ceph_metric_type {
+	CLIENT_METRIC_TYPE_CAP_INFO,
+	CLIENT_METRIC_TYPE_READ_LATENCY,
+	CLIENT_METRIC_TYPE_WRITE_LATENCY,
+	CLIENT_METRIC_TYPE_METADATA_LATENCY,
+	CLIENT_METRIC_TYPE_DENTRY_LEASE,
+
+	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
+};
+
+/* metric caps header */
+struct ceph_metric_cap {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(hit + mis + total) */
+	__le64 hit;
+	__le64 mis;
+	__le64 total;
+} __packed;
+
+/* metric read latency header */
+struct ceph_metric_read_latency {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(sec + nsec) */
+	__le32 sec;
+	__le32 nsec;
+} __packed;
+
+/* metric write latency header */
+struct ceph_metric_write_latency {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(sec + nsec) */
+	__le32 sec;
+	__le32 nsec;
+} __packed;
+
+/* metric metadata latency header */
+struct ceph_metric_metadata_latency {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(sec + nsec) */
+	__le32 sec;
+	__le32 nsec;
+} __packed;
+
+struct ceph_metric_head {
+	__le32 num;	/* the number of metrics that will be sent */
+} __packed;
+
 /* This is the global metrics */
 struct ceph_client_metric {
 	atomic64_t            total_dentries;
@@ -35,8 +100,21 @@ struct ceph_client_metric {
 	ktime_t metadata_latency_sq_sum;
 	ktime_t metadata_latency_min;
 	ktime_t metadata_latency_max;
+
+	struct delayed_work delayed_work;  /* delayed work */
 };
 
+static inline void metric_schedule_delayed(struct ceph_client_metric *m)
+{
+	/* per second as default */
+	unsigned int hz = round_jiffies_relative(HZ * metric_send_interval);
+
+	if (!metric_send_interval)
+		return;
+
+	schedule_delayed_work(&m->delayed_work, hz);
+}
+
 extern int ceph_metric_init(struct ceph_client_metric *m);
 extern void ceph_metric_destroy(struct ceph_client_metric *m);
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c9784eb1..66a940c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1282,6 +1282,35 @@ static void __exit exit_ceph(void)
 	destroy_caches();
 }
 
+static int param_set_metric_interval(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	unsigned int interval;
+
+	ret = kstrtouint(val, 0, &interval);
+	if (ret < 0) {
+		pr_err("Failed to parse metric interval '%s'\n", val);
+		return ret;
+	}
+
+	if (interval > 5 || interval < 1) {
+		pr_err("Invalid metric interval %u\n", interval);
+		return -EINVAL;
+	}
+
+	metric_send_interval = interval;
+	return 0;
+}
+
+static const struct kernel_param_ops param_ops_metric_interval = {
+	.set = param_set_metric_interval,
+	.get = param_get_uint,
+};
+
+unsigned int metric_send_interval = 1;
+module_param_cb(metric_send_interval, &param_ops_metric_interval, &metric_send_interval, 0644);
+MODULE_PARM_DESC(metric_send_interval, "Interval (in seconds) of sending perf metric to ceph cluster, valid values are 1~5 (default: 1)");
+
 module_init(init_ceph);
 module_exit(exit_ceph);
 
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index ebf5ba6..455e9b9 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -130,6 +130,7 @@ struct ceph_dir_layout {
 #define CEPH_MSG_CLIENT_REQUEST         24
 #define CEPH_MSG_CLIENT_REQUEST_FORWARD 25
 #define CEPH_MSG_CLIENT_REPLY           26
+#define CEPH_MSG_CLIENT_METRICS         29
 #define CEPH_MSG_CLIENT_CAPS            0x310
 #define CEPH_MSG_CLIENT_LEASE           0x311
 #define CEPH_MSG_CLIENT_SNAP            0x312
-- 
1.8.3.1

