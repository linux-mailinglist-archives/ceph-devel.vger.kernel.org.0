Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B18189D92
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 15:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgCROGl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 10:06:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42865 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726893AbgCROGl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 10:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584540399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=S3DXrMSseFSEGRdLbWNjrV+E8YB5AdAmVwUayCiNBNo=;
        b=GAj3yBHcYra63JVELKpyKQeCBvnH++jdJ4F3Z1eO948c/0bug5cEoU7iFv87P65eib8Fuc
        3ShyuMq3cFiXDzm530rivbLSHaVteUW/IX9hbJaQ4cSi1fQNwDQT0CegQkVGdTr61WH11G
        NAAoZz16SYUeyJREZqzv9NZgjuXw+Q4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-S0-Aeq1FPDORL23Db9olmQ-1; Wed, 18 Mar 2020 10:06:29 -0400
X-MC-Unique: S0-Aeq1FPDORL23Db9olmQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E83B91857BE0;
        Wed, 18 Mar 2020 14:06:27 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6CF01001920;
        Wed, 18 Mar 2020 14:06:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v10 5/6] ceph: add min/max latency support for read/write/metadata metrics
Date:   Wed, 18 Mar 2020 10:05:55 -0400
Message-Id: <1584540356-5885-6-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
References: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

These will be very useful help diagnose problems.

URL: https://tracker.ceph.com/issues/44533
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c | 71 ++++++++++++++++++++++++++++++++++++++-----------------
 fs/ceph/metric.c  |  9 +++++++
 fs/ceph/metric.h  | 48 ++++++++++++++++++++++++++++++++++---
 3 files changed, 103 insertions(+), 25 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index b04344e..00c39a2 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -124,34 +124,61 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static s64 get_avg(struct percpu_counter *totalp, struct percpu_counter *sump,
+		   s64 *total)
+{
+	s64 t, sum, avg = 0;
+
+	t = percpu_counter_sum(totalp);
+	sum = percpu_counter_sum(sump);
+
+	if (likely(t))
+		avg = DIV64_U64_ROUND_CLOSEST(sum, t);
+
+	*total = t;
+	return avg;
+}
+
+#define CEPH_METRIC_SHOW(name, total, avg, min, max) {		\
+	s64 _avg, _min, _max;					\
+	_avg = jiffies_to_usecs(avg);				\
+	_min = jiffies_to_usecs(min == S64_MAX ? 0 : min);	\
+	_max = jiffies_to_usecs(max);				\
+	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%lld\n",	\
+		   name, total, _avg, _min, _max);		\
+}
+
 static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_client_metric *m = &mdsc->metric;
 	int i, nr_caps = 0;
-	s64 total, sum, avg = 0;
-
-	seq_printf(s, "item          total       avg_lat(us)\n");
-	seq_printf(s, "-------------------------------------\n");
-
-	total = percpu_counter_sum(&m->total_reads);
-	sum = percpu_counter_sum(&m->read_latency_sum);
-	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
-	avg = jiffies_to_usecs(avg);
-	seq_printf(s, "%-14s%-12lld%lld\n", "read", total, avg);
-
-	total = percpu_counter_sum(&m->total_writes);
-	sum = percpu_counter_sum(&m->write_latency_sum);
-	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
-	avg = jiffies_to_usecs(avg);
-	seq_printf(s, "%-14s%-12lld%lld\n", "write", total, avg);
-
-	total = percpu_counter_sum(&m->total_metadatas);
-	sum = percpu_counter_sum(&m->metadata_latency_sum);
-	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
-	avg = jiffies_to_usecs(avg);
-	seq_printf(s, "%-14s%-12lld%lld\n", "metadata", total, avg);
+	s64 total, avg, min, max;
+
+	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)\n");
+	seq_printf(s, "---------------------------------------------------------------------\n");
+
+	avg = get_avg(&mdsc->metric.total_reads,
+		      &mdsc->metric.read_latency_sum,
+		      &total);
+	min = atomic64_read(&m->read_latency_min);
+	max = atomic64_read(&m->read_latency_max);
+	CEPH_METRIC_SHOW("read", total, avg, min, max);
+
+	avg = get_avg(&mdsc->metric.total_writes,
+		      &mdsc->metric.write_latency_sum,
+		      &total);
+	min = atomic64_read(&m->write_latency_min);
+	max = atomic64_read(&m->write_latency_max);
+	CEPH_METRIC_SHOW("write", total, avg, min, max);
+
+	avg = get_avg(&mdsc->metric.total_metadatas,
+		      &mdsc->metric.metadata_latency_sum,
+		      &total);
+	min = atomic64_read(&m->metadata_latency_min);
+	max = atomic64_read(&m->metadata_latency_max);
+	CEPH_METRIC_SHOW("metadata", total, avg, min, max);
 
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 629a328..c0158f6 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -37,6 +37,9 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_read_latency_sum;
 
+	atomic64_set(&m->read_latency_min, S64_MAX);
+	atomic64_set(&m->read_latency_max, 0);
+
 	ret = percpu_counter_init(&m->total_writes, 0, GFP_KERNEL);
 	if (ret)
 		goto err_total_writes;
@@ -45,6 +48,9 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_write_latency_sum;
 
+	atomic64_set(&m->write_latency_min, S64_MAX);
+	atomic64_set(&m->write_latency_max, 0);
+
 	ret = percpu_counter_init(&m->total_metadatas, 0, GFP_KERNEL);
 	if (ret)
 		goto err_total_metadatas;
@@ -53,6 +59,9 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_metadata_latency_sum;
 
+	atomic64_set(&m->metadata_latency_min, S64_MAX);
+	atomic64_set(&m->metadata_latency_max, 0);
+
 	return 0;
 
 err_metadata_latency_sum:
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index aaf9979..3f90875 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -16,12 +16,18 @@ struct ceph_client_metric {
 
 	struct percpu_counter total_reads;
 	struct percpu_counter read_latency_sum;
+	atomic64_t read_latency_min;
+	atomic64_t read_latency_max;
 
 	struct percpu_counter total_writes;
 	struct percpu_counter write_latency_sum;
+	atomic64_t write_latency_min;
+	atomic64_t write_latency_max;
 
 	struct percpu_counter total_metadatas;
 	struct percpu_counter metadata_latency_sum;
+	atomic64_t metadata_latency_min;
+	atomic64_t metadata_latency_max;
 };
 
 extern int ceph_metric_init(struct ceph_client_metric *m);
@@ -37,16 +43,44 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 	percpu_counter_inc(&m->i_caps_mis);
 }
 
+static inline void __update_min_latency(atomic64_t *min, unsigned long lat)
+{
+	unsigned long cur, old;
+
+	cur = atomic64_read(min);
+	do {
+		old = cur;
+		if (likely(lat >= old))
+			break;
+	} while (unlikely((cur = atomic64_cmpxchg(min, old, lat)) != old));
+}
+
+static inline void __update_max_latency(atomic64_t *max, unsigned long lat)
+{
+	unsigned long cur, old;
+
+	cur = atomic64_read(max);
+	do {
+		old = cur;
+		if (likely(lat <= old))
+			break;
+	} while (unlikely((cur = atomic64_cmpxchg(max, old, lat)) != old));
+}
+
 static inline void ceph_update_read_latency(struct ceph_client_metric *m,
 					    unsigned long r_start,
 					    unsigned long r_end,
 					    int rc)
 {
+	unsigned long lat = r_end - r_start;
+
 	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
 		return;
 
 	percpu_counter_inc(&m->total_reads);
-	percpu_counter_add(&m->read_latency_sum, r_end - r_start);
+	percpu_counter_add(&m->read_latency_sum, lat);
+	__update_min_latency(&m->read_latency_min, lat);
+	__update_max_latency(&m->read_latency_max, lat);
 }
 
 static inline void ceph_update_write_latency(struct ceph_client_metric *m,
@@ -54,11 +88,15 @@ static inline void ceph_update_write_latency(struct ceph_client_metric *m,
 					     unsigned long r_end,
 					     int rc)
 {
+	unsigned long lat = r_end - r_start;
+
 	if (rc && rc != -ETIMEDOUT)
 		return;
 
 	percpu_counter_inc(&m->total_writes);
-	percpu_counter_add(&m->write_latency_sum, r_end - r_start);
+	percpu_counter_add(&m->write_latency_sum, lat);
+	__update_min_latency(&m->write_latency_min, lat);
+	__update_max_latency(&m->write_latency_max, lat);
 }
 
 static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
@@ -66,10 +104,14 @@ static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
 						unsigned long r_end,
 						int rc)
 {
+	unsigned long lat = r_end - r_start;
+
 	if (rc && rc != -ENOENT)
 		return;
 
 	percpu_counter_inc(&m->total_metadatas);
-	percpu_counter_add(&m->metadata_latency_sum, r_end - r_start);
+	percpu_counter_add(&m->metadata_latency_sum, lat);
+	__update_min_latency(&m->metadata_latency_min, lat);
+	__update_max_latency(&m->metadata_latency_max, lat);
 }
 #endif /* _FS_CEPH_MDS_METRIC_H */
-- 
1.8.3.1

