Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5692224D7
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jul 2020 16:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgGPOGr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jul 2020 10:06:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23898 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727044AbgGPOGr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 10:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594908404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vpIdxeDMk2c9Dd5Iey+4bAH4oK4VOV4zIkuVuzf5gyM=;
        b=XsxDIqQaC160Mm92hg3DblJrPzjqKqDJ3E1dO/SEHvjssdG65oNqyUN8lYe0jOnhRc5ORa
        iTPvjSxMkOQmBYQAyAmQXDgVv//5HeDpNrrrlJAnJg9Ht6WoYRANdwG2mVZEZazq7a9Psg
        XHNlit+JanGxkSoAZd+AWRRJfZWoSkI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-sliwqM8OOqaMEgpgJoE9Jw-1; Thu, 16 Jul 2020 10:06:18 -0400
X-MC-Unique: sliwqM8OOqaMEgpgJoE9Jw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70DB68027FE;
        Thu, 16 Jul 2020 14:06:17 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53D885FC2E;
        Thu, 16 Jul 2020 14:06:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 1/2] ceph: periodically send perf metrics to ceph
Date:   Thu, 16 Jul 2020 10:05:57 -0400
Message-Id: <20200716140558.5185-2-xiubli@redhat.com>
In-Reply-To: <20200716140558.5185-1-xiubli@redhat.com>
References: <20200716140558.5185-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will send the caps/read/write/metadata metrics to any available
MDS only once per second as default, which will be the same as the
userland client. It will skip the MDS sessions which don't support
the metric collection, or the MDSs will close the socket connections
directly when it get an unknown type message.

We can disable the metric sending via the disable_send_metric module
parameter.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c         |   4 +
 fs/ceph/mds_client.h         |   4 +-
 fs/ceph/metric.c             | 151 +++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h             |  77 ++++++++++++++++++
 fs/ceph/super.c              |  42 ++++++++++
 fs/ceph/super.h              |   2 +
 include/linux/ceph/ceph_fs.h |   1 +
 7 files changed, 280 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9a09d12569bd..cf4c2ba2311f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3334,6 +3334,8 @@ static void handle_session(struct ceph_mds_session *session,
 		session->s_state = CEPH_MDS_SESSION_OPEN;
 		session->s_features = features;
 		renewed_caps(mdsc, session, 0);
+		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features))
+			metric_schedule_delayed(&mdsc->metric);
 		wake = 1;
 		if (mdsc->stopping)
 			__close_session(mdsc, session);
@@ -4303,6 +4305,7 @@ bool check_session_state(struct ceph_mds_session *s)
 	}
 	if (s->s_state == CEPH_MDS_SESSION_NEW ||
 	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
+	    s->s_state == CEPH_MDS_SESSION_CLOSED  ||
 	    s->s_state == CEPH_MDS_SESSION_REJECTED)
 		/* this mds is failed or recovering, just wait */
 		return false;
@@ -4724,6 +4727,7 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_metric_destroy(&mdsc->metric);
 
+	flush_delayed_work(&mdsc->metric.delayed_work);
 	fsc->mdsc = NULL;
 	kfree(mdsc);
 	dout("mdsc_destroy %p done\n", mdsc);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 6147ff0a1cdf..bc9e95937d7c 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -28,8 +28,9 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,
 	CEPHFS_FEATURE_MULTI_RECONNECT,
 	CEPHFS_FEATURE_DELEG_INO,
+	CEPHFS_FEATURE_METRIC_COLLECT,
 
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
 };
 
 /*
@@ -43,6 +44,7 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
+	CEPHFS_FEATURE_METRIC_COLLECT,		\
 						\
 	CEPHFS_FEATURE_MAX,			\
 }
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 269eacbd2a15..f6da01b10450 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -1,10 +1,153 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/ceph/ceph_debug.h>
 
 #include <linux/types.h>
 #include <linux/percpu_counter.h>
 #include <linux/math64.h>
 
 #include "metric.h"
+#include "mds_client.h"
+
+static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
+				   struct ceph_mds_session *s)
+{
+	struct ceph_metric_head *head;
+	struct ceph_metric_cap *cap;
+	struct ceph_metric_read_latency *read;
+	struct ceph_metric_write_latency *write;
+	struct ceph_metric_metadata_latency *meta;
+	struct ceph_client_metric *m = &mdsc->metric;
+	u64 nr_caps = atomic64_read(&m->total_caps);
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
+	dout("client%llu send metrics to mds%d\n",
+	     ceph_client_gid(mdsc->fsc->client), s->s_mds);
+	ceph_con_send(&s->s_con, msg);
+
+	return true;
+}
+
+
+static void metric_get_session(struct ceph_mds_client *mdsc)
+{
+	struct ceph_mds_session *s;
+	int i;
+
+	mutex_lock(&mdsc->mutex);
+	for (i = 0; i < mdsc->max_sessions; i++) {
+		s = __ceph_lookup_mds_session(mdsc, i);
+		if (!s)
+			continue;
+
+		/*
+		 * Skip it if MDS doesn't support the metric collection,
+		 * or the MDS will close the session's socket connection
+		 * directly when it get this message.
+		 */
+		if (check_session_state(s) &&
+		    test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)) {
+			mdsc->metric.session = s;
+			break;
+		}
+
+		ceph_put_mds_session(s);
+	}
+	mutex_unlock(&mdsc->mutex);
+}
+
+static void metric_delayed_work(struct work_struct *work)
+{
+	struct ceph_client_metric *m =
+		container_of(work, struct ceph_client_metric, delayed_work.work);
+	struct ceph_mds_client *mdsc =
+		container_of(m, struct ceph_mds_client, metric);
+
+	if (mdsc->stopping)
+		return;
+
+	if (!m->session || !check_session_state(m->session)) {
+		if (m->session) {
+			ceph_put_mds_session(m->session);
+			m->session = NULL;
+		}
+		metric_get_session(mdsc);
+	}
+	if (m->session) {
+		ceph_mdsc_send_metrics(mdsc, m->session);
+		metric_schedule_delayed(m);
+	}
+}
 
 int ceph_metric_init(struct ceph_client_metric *m)
 {
@@ -52,6 +195,9 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->total_metadatas = 0;
 	m->metadata_latency_sum = 0;
 
+	m->session = NULL;
+	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
+
 	return 0;
 
 err_i_caps_mis:
@@ -73,6 +219,11 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	percpu_counter_destroy(&m->i_caps_hit);
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
+
+	cancel_delayed_work_sync(&m->delayed_work);
+
+	if (m->session)
+		ceph_put_mds_session(m->session);
 }
 
 static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 23a3373d5a3d..fe5d07d2e63a 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -6,6 +6,71 @@
 #include <linux/percpu_counter.h>
 #include <linux/ktime.h>
 
+extern bool disable_send_metrics;
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
@@ -36,8 +101,20 @@ struct ceph_client_metric {
 	ktime_t metadata_latency_sq_sum;
 	ktime_t metadata_latency_min;
 	ktime_t metadata_latency_max;
+
+	struct ceph_mds_session *session;
+	struct delayed_work delayed_work;  /* delayed work */
 };
 
+static inline void metric_schedule_delayed(struct ceph_client_metric *m)
+{
+	if (disable_send_metrics)
+		return;
+
+	/* per second */
+	schedule_delayed_work(&m->delayed_work, round_jiffies_relative(HZ));
+}
+
 extern int ceph_metric_init(struct ceph_client_metric *m);
 extern void ceph_metric_destroy(struct ceph_client_metric *m);
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c9784eb1159a..933f5df5da7d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -27,6 +27,9 @@
 #include <linux/ceph/auth.h>
 #include <linux/ceph/debugfs.h>
 
+static DEFINE_SPINLOCK(ceph_fsc_lock);
+static LIST_HEAD(ceph_fsc_list);
+
 /*
  * Ceph superblock operations
  *
@@ -691,6 +694,10 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 	if (!fsc->wb_pagevec_pool)
 		goto fail_cap_wq;
 
+	spin_lock(&ceph_fsc_lock);
+	list_add_tail(&fsc->metric_wakeup, &ceph_fsc_list);
+	spin_unlock(&ceph_fsc_lock);
+
 	return fsc;
 
 fail_cap_wq:
@@ -717,6 +724,10 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
 {
 	dout("destroy_fs_client %p\n", fsc);
 
+	spin_lock(&ceph_fsc_lock);
+	list_del(&fsc->metric_wakeup);
+	spin_unlock(&ceph_fsc_lock);
+
 	ceph_mdsc_destroy(fsc);
 	destroy_workqueue(fsc->inode_wq);
 	destroy_workqueue(fsc->cap_wq);
@@ -1282,6 +1293,37 @@ static void __exit exit_ceph(void)
 	destroy_caches();
 }
 
+static int param_set_metrics(const char *val, const struct kernel_param *kp)
+{
+	struct ceph_fs_client *fsc;
+	int ret;
+
+	ret = param_set_bool(val, kp);
+	if (ret) {
+		pr_err("Failed to parse sending metrics switch value '%s'\n",
+		       val);
+		return ret;
+	} else if (!disable_send_metrics) {
+		// wake up all the mds clients
+		spin_lock(&ceph_fsc_lock);
+		list_for_each_entry(fsc, &ceph_fsc_list, metric_wakeup) {
+			metric_schedule_delayed(&fsc->mdsc->metric);
+		}
+		spin_unlock(&ceph_fsc_lock);
+	}
+
+	return 0;
+}
+
+static const struct kernel_param_ops param_ops_metrics = {
+	.set = param_set_metrics,
+	.get = param_get_bool,
+};
+
+bool disable_send_metrics = false;
+module_param_cb(disable_send_metrics, &param_ops_metrics, &disable_send_metrics, 0644);
+MODULE_PARM_DESC(disable_send_metrics, "Enable sending perf metrics to ceph cluster (default: on)");
+
 module_init(init_ceph);
 module_exit(exit_ceph);
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 5a6cdd39bc10..2dcb6a90c636 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -101,6 +101,8 @@ struct ceph_mount_options {
 struct ceph_fs_client {
 	struct super_block *sb;
 
+	struct list_head metric_wakeup;
+
 	struct ceph_mount_options *mount_options;
 	struct ceph_client *client;
 
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index ebf5ba62b772..455e9b9e2adf 100644
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
2.27.0.221.ga08a83d.dirty

