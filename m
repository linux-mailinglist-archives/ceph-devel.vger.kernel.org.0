Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FA9156EDD
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 06:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJFer (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 00:34:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgBJFer (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 00:34:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581312885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5Rt1uimLdL9ORJ/nSFAX1gF8S6wFqnP4l+raGYB1tE=;
        b=L1s3buyy/nGjb9NIxKKEgFtuV/UR13GoMI/GCWitq3e2oOX/m/P9sICcGPDfeBv58UhIYz
        Wp9x8gqUoZJEte/QkMKYljFIj0SEC48mzSAsgEyWB0VDn5UXItrhGbanEQkQE2ekrnZXm4
        AxDMMkb5vfh1ow4hBXlTbCCuOBLtvRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-qZmySwvNOgW3Qy6D9bYF3Q-1; Mon, 10 Feb 2020 00:34:42 -0500
X-MC-Unique: qZmySwvNOgW3Qy6D9bYF3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4BAF107ACCA;
        Mon, 10 Feb 2020 05:34:41 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02C6E10021B2;
        Mon, 10 Feb 2020 05:34:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 6/9] ceph: periodically send perf metrics to ceph
Date:   Mon, 10 Feb 2020 00:34:04 -0500
Message-Id: <20200210053407.37237-7-xiubli@redhat.com>
In-Reply-To: <20200210053407.37237-1-xiubli@redhat.com>
References: <20200210053407.37237-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Add metric_send_interval module parameter support, the default valume
is 0, means disabled. If none zero it will enable the transmission of
the metrics to the ceph cluster periodically per metric_send_interval
seconds.

This will send the caps, dentry lease and read/write/metadata perf
metrics to any available MDS only once per metric_send_interval
seconds.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c         | 235 +++++++++++++++++++++++++++++++----
 fs/ceph/mds_client.h         |   2 +
 fs/ceph/metric.h             |  76 +++++++++++
 fs/ceph/super.c              |   4 +
 fs/ceph/super.h              |   1 +
 include/linux/ceph/ceph_fs.h |   1 +
 6 files changed, 294 insertions(+), 25 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d414eded6810..f9a6f95c7941 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4085,16 +4085,167 @@ static void maybe_recover_session(struct ceph_md=
s_client *mdsc)
 	ceph_force_reconnect(fsc->sb);
 }
=20
-/*
- * delayed work -- periodically trim expired leases, renew caps with mds
- */
+static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
+				   struct ceph_mds_session *s,
+				   u64 nr_caps)
+{
+	struct ceph_metric_head *head;
+	struct ceph_metric_cap *cap;
+	struct ceph_metric_dentry_lease *lease;
+	struct ceph_metric_read_latency *read;
+	struct ceph_metric_write_latency *write;
+	struct ceph_metric_metadata_latency *meta;
+	struct ceph_msg *msg;
+	struct timespec64 ts;
+	s64 sum, total;
+	s32 items =3D 0;
+	s32 len;
+
+	if (!mdsc || !s)
+		return false;
+
+	len =3D sizeof(*head) + sizeof(*cap) + sizeof(*lease) + sizeof(*read)
+	      + sizeof(*write) + sizeof(*meta);
+
+	msg =3D ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
+	if (!msg) {
+		pr_err("send metrics to mds%d, failed to allocate message\n",
+		       s->s_mds);
+		return false;
+	}
+
+	head =3D msg->front.iov_base;
+
+	/* encode the cap metric */
+	cap =3D (struct ceph_metric_cap *)(head + 1);
+	cap->type =3D cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
+	cap->ver =3D 1;
+	cap->compat =3D 1;
+	cap->data_len =3D cpu_to_le32(sizeof(*cap) - 10);
+	cap->hit =3D cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
+	cap->mis =3D cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
+	cap->total =3D cpu_to_le64(nr_caps);
+	items++;
+
+	dout("cap metric hit %lld, mis %lld, total caps %lld",
+	     le64_to_cpu(cap->hit), le64_to_cpu(cap->mis),
+	     le64_to_cpu(cap->total));
+
+	/* encode the read latency metric */
+	read =3D (struct ceph_metric_read_latency *)(cap + 1);
+	read->type =3D cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
+	read->ver =3D 1;
+	read->compat =3D 1;
+	read->data_len =3D cpu_to_le32(sizeof(*read) - 10);
+	total =3D percpu_counter_sum(&mdsc->metric.total_reads),
+	sum =3D percpu_counter_sum(&mdsc->metric.read_latency_sum);
+	jiffies_to_timespec64(sum, &ts);
+	read->sec =3D cpu_to_le32(ts.tv_sec);
+	read->nsec =3D cpu_to_le32(ts.tv_nsec);
+	items++;
+	dout("read latency metric total %lld, sum lat %lld", total, sum);
+
+	/* encode the write latency metric */
+	write =3D (struct ceph_metric_write_latency *)(read + 1);
+	write->type =3D cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
+	write->ver =3D 1;
+	write->compat =3D 1;
+	write->data_len =3D cpu_to_le32(sizeof(*write) - 10);
+	total =3D percpu_counter_sum(&mdsc->metric.total_writes),
+	sum =3D percpu_counter_sum(&mdsc->metric.write_latency_sum);
+	jiffies_to_timespec64(sum, &ts);
+	write->sec =3D cpu_to_le32(ts.tv_sec);
+	write->nsec =3D cpu_to_le32(ts.tv_nsec);
+	items++;
+	dout("write latency metric total %lld, sum lat %lld", total, sum);
+
+	/* encode the metadata latency metric */
+	meta =3D (struct ceph_metric_metadata_latency *)(write + 1);
+	meta->type =3D cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
+	meta->ver =3D 1;
+	meta->compat =3D 1;
+	meta->data_len =3D cpu_to_le32(sizeof(*meta) - 10);
+	total =3D percpu_counter_sum(&mdsc->metric.total_metadatas),
+	sum =3D percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
+	jiffies_to_timespec64(sum, &ts);
+	meta->sec =3D cpu_to_le32(ts.tv_sec);
+	meta->nsec =3D cpu_to_le32(ts.tv_nsec);
+	items++;
+	dout("metadata latency metric total %lld, sum lat %lld", total, sum);
+
+	/* encode the dentry lease metric */
+	lease =3D (struct ceph_metric_dentry_lease *)(meta + 1);
+	lease->type =3D cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
+	lease->ver =3D 1;
+	lease->compat =3D 1;
+	lease->data_len =3D cpu_to_le32(sizeof(*lease) - 10);
+	lease->hit =3D cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_hit=
));
+	lease->mis =3D cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_mis=
));
+	lease->total =3D cpu_to_le64(atomic64_read(&mdsc->metric.total_dentries=
));
+	items++;
+	dout("dentry lease metric hit %lld, mis %lld, total dentries %lld",
+	     le64_to_cpu(lease->hit), le64_to_cpu(lease->mis),
+	     le64_to_cpu(lease->total));
+
+	put_unaligned_le32(items, &head->num);
+	msg->front.iov_len =3D cpu_to_le32(len);
+	msg->hdr.version =3D cpu_to_le16(1);
+	msg->hdr.compat_version =3D cpu_to_le16(1);
+	msg->hdr.front_len =3D cpu_to_le32(msg->front.iov_len);
+	dout("send metrics to mds%d %p\n", s->s_mds, msg);
+	ceph_con_send(&s->s_con, msg);
+
+	return true;
+}
+
+#define CEPH_WORK_DELAY_DEF 5
+static void __schedule_delayed(struct delayed_work *work, int delay)
+{
+	unsigned int hz =3D round_jiffies_relative(HZ * delay);
+
+	schedule_delayed_work(work, hz);
+}
+
 static void schedule_delayed(struct ceph_mds_client *mdsc)
 {
-	int delay =3D 5;
-	unsigned hz =3D round_jiffies_relative(HZ * delay);
-	schedule_delayed_work(&mdsc->delayed_work, hz);
+	__schedule_delayed(&mdsc->delayed_work, CEPH_WORK_DELAY_DEF);
+}
+
+static void metric_schedule_delayed(struct ceph_mds_client *mdsc)
+{
+	/* delay CEPH_WORK_DELAY_DEF seconds when idle */
+	int delay =3D metric_send_interval ? : CEPH_WORK_DELAY_DEF;
+
+	__schedule_delayed(&mdsc->metric_delayed_work, delay);
+}
+
+static bool check_session_state(struct ceph_mds_client *mdsc,
+				struct ceph_mds_session *s)
+{
+	if (s->s_state =3D=3D CEPH_MDS_SESSION_CLOSING) {
+		dout("resending session close request for mds%d\n",
+				s->s_mds);
+		request_close_session(mdsc, s);
+		return false;
+	}
+	if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
+		if (s->s_state =3D=3D CEPH_MDS_SESSION_OPEN) {
+			s->s_state =3D CEPH_MDS_SESSION_HUNG;
+			pr_info("mds%d hung\n", s->s_mds);
+		}
+	}
+	if (s->s_state =3D=3D CEPH_MDS_SESSION_NEW ||
+	    s->s_state =3D=3D CEPH_MDS_SESSION_RESTARTING ||
+	    s->s_state =3D=3D CEPH_MDS_SESSION_REJECTED)
+		/* this mds is failed or recovering, just wait */
+		return false;
+
+	return true;
 }
=20
+/*
+ * delayed work -- periodically trim expired leases, renew caps with mds
+ */
 static void delayed_work(struct work_struct *work)
 {
 	int i;
@@ -4116,23 +4267,8 @@ static void delayed_work(struct work_struct *work)
 		struct ceph_mds_session *s =3D __ceph_lookup_mds_session(mdsc, i);
 		if (!s)
 			continue;
-		if (s->s_state =3D=3D CEPH_MDS_SESSION_CLOSING) {
-			dout("resending session close request for mds%d\n",
-			     s->s_mds);
-			request_close_session(mdsc, s);
-			ceph_put_mds_session(s);
-			continue;
-		}
-		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
-			if (s->s_state =3D=3D CEPH_MDS_SESSION_OPEN) {
-				s->s_state =3D CEPH_MDS_SESSION_HUNG;
-				pr_info("mds%d hung\n", s->s_mds);
-			}
-		}
-		if (s->s_state =3D=3D CEPH_MDS_SESSION_NEW ||
-		    s->s_state =3D=3D CEPH_MDS_SESSION_RESTARTING ||
-		    s->s_state =3D=3D CEPH_MDS_SESSION_REJECTED) {
-			/* this mds is failed or recovering, just wait */
+
+		if (!check_session_state(mdsc, s)) {
 			ceph_put_mds_session(s);
 			continue;
 		}
@@ -4164,8 +4300,53 @@ static void delayed_work(struct work_struct *work)
 	schedule_delayed(mdsc);
 }
=20
-static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
+static void metric_delayed_work(struct work_struct *work)
+{
+	struct ceph_mds_client *mdsc =3D
+		container_of(work, struct ceph_mds_client, metric_delayed_work.work);
+	struct ceph_mds_session *s;
+	u64 nr_caps =3D 0;
+	bool ret;
+	int i;
+
+	if (!metric_send_interval)
+		goto idle;
+
+	dout("mdsc metric_delayed_work\n");
+
+	mutex_lock(&mdsc->mutex);
+	for (i =3D 0; i < mdsc->max_sessions; i++) {
+		s =3D __ceph_lookup_mds_session(mdsc, i);
+		if (!s)
+			continue;
+		nr_caps +=3D s->s_nr_caps;
+		ceph_put_mds_session(s);
+	}
+
+	for (i =3D 0; i < mdsc->max_sessions; i++) {
+		s =3D __ceph_lookup_mds_session(mdsc, i);
+		if (!s)
+			continue;
+		if (!check_session_state(mdsc, s)) {
+			ceph_put_mds_session(s);
+			continue;
+		}
+
+		/* Only send the metric once in any available session */
+		ret =3D ceph_mdsc_send_metrics(mdsc, s, nr_caps);
+		ceph_put_mds_session(s);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&mdsc->mutex);
+
+idle:
+	metric_schedule_delayed(mdsc);
+}
+
+static int ceph_mdsc_metric_init(struct ceph_mds_client *mdsc)
 {
+	struct ceph_client_metric *metric =3D &mdsc->metric;
 	int ret;
=20
 	if (!metric)
@@ -4289,7 +4470,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
 	atomic_set(&mdsc->cap_reclaim_pending, 0);
-	err =3D ceph_mdsc_metric_init(&mdsc->metric);
+	INIT_DELAYED_WORK(&mdsc->metric_delayed_work, metric_delayed_work);
+	err =3D ceph_mdsc_metric_init(mdsc);
 	if (err)
 		goto err_mdsmap;
=20
@@ -4511,6 +4693,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_clien=
t *mdsc)
=20
 	cancel_work_sync(&mdsc->cap_reclaim_work);
 	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
+	cancel_delayed_work_sync(&mdsc->metric_delayed_work); /* cancel timer *=
/
=20
 	dout("stopped\n");
 }
@@ -4553,6 +4736,7 @@ static void ceph_mdsc_stop(struct ceph_mds_client *=
mdsc)
 {
 	dout("stop\n");
 	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
+	cancel_delayed_work_sync(&mdsc->metric_delayed_work); /* cancel timer *=
/
 	if (mdsc->mdsmap)
 		ceph_mdsmap_destroy(mdsc->mdsmap);
 	kfree(mdsc->sessions);
@@ -4719,6 +4903,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client=
 *mdsc, struct ceph_msg *msg)
=20
 	mutex_unlock(&mdsc->mutex);
 	schedule_delayed(mdsc);
+	metric_schedule_delayed(mdsc);
 	return;
=20
 bad_unlock:
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 674fc7725913..c13910da07c4 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -448,7 +448,9 @@ struct ceph_mds_client {
 	struct list_head  dentry_leases;     /* fifo list */
 	struct list_head  dentry_dir_leases; /* lru list */
=20
+	/* metrics */
 	struct ceph_client_metric metric;
+	struct delayed_work	  metric_delayed_work;  /* delayed work */
=20
 	spinlock_t		snapid_map_lock;
 	struct rb_root		snapid_map_tree;
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 9de8beb436c7..224e92a70d88 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -4,6 +4,82 @@
=20
 #include <linux/ceph/osd_client.h>
=20
+enum ceph_metric_type {
+	CLIENT_METRIC_TYPE_CAP_INFO,
+	CLIENT_METRIC_TYPE_READ_LATENCY,
+	CLIENT_METRIC_TYPE_WRITE_LATENCY,
+	CLIENT_METRIC_TYPE_METADATA_LATENCY,
+	CLIENT_METRIC_TYPE_DENTRY_LEASE,
+
+	CLIENT_METRIC_TYPE_MAX =3D CLIENT_METRIC_TYPE_DENTRY_LEASE,
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
+} __attribute__ ((packed));
+
+/* metric dentry lease header */
+struct ceph_metric_dentry_lease {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(hit + mis + total) */
+	__le64 hit;
+	__le64 mis;
+	__le64 total;
+} __attribute__ ((packed));
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
+} __attribute__ ((packed));
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
+} __attribute__ ((packed));
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
+} __attribute__ ((packed));
+
+struct ceph_metric_head {
+	__le32 num;	/* the number of metrics that will be sent */
+} __attribute__ ((packed));
+
 /* This is the global metrics */
 struct ceph_client_metric {
 	atomic64_t            total_dentries;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 196d547c7054..5fef4f59e13e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1315,6 +1315,10 @@ bool enable_async_dirops;
 module_param(enable_async_dirops, bool, 0644);
 MODULE_PARM_DESC(enable_async_dirops, "Asynchronous directory operations=
 enabled");
=20
+unsigned int metric_send_interval;
+module_param(metric_send_interval, uint, 0644);
+MODULE_PARM_DESC(metric_send_interval, "Interval (in seconds) of sending=
 perf metric to ceph cluster (default: 0)");
+
 module_init(init_ceph);
 module_exit(exit_ceph);
=20
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 44b9a971ec9a..7eda7acc859a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -73,6 +73,7 @@
 #define CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT     60  /* cap release delay =
*/
=20
 extern bool enable_async_dirops;
+extern unsigned int metric_send_interval;
=20
 struct ceph_mount_options {
 	unsigned int flags;
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index a099f60feb7b..6028d3e865e4 100644
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
--=20
2.21.0

