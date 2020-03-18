Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275AF189D94
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 15:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgCROGu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 10:06:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:33105 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727114AbgCROGu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 10:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584540408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=7lSWtp+wV6Otq97NpqsVk644c8GKG6OKklvAI4WxIFs=;
        b=IkocARXSb13YKf1C9yUI9H42TKY+2r8FxnCdn9GwhTbpVZ7w5vtV0rq1rfdmXZIFvIgb8A
        0/VjJF/nWzGrCmXrPDsjqlKVacYw1MVOIdqazCNWfhCBChZxGExq+CbFheHxr5HgJ2uYUf
        qFxD7O3Na6eaLq8X9omLY8iM1Pq5RMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-HDfLCVPvM5-27mFfmslkOg-1; Wed, 18 Mar 2020 10:06:42 -0400
X-MC-Unique: HDfLCVPvM5-27mFfmslkOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D47EB100A5F4;
        Wed, 18 Mar 2020 14:06:41 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C7F910027A8;
        Wed, 18 Mar 2020 14:06:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v10 6/6] ceph: add standard deviation support for read/write/metadata perf metric
Date:   Wed, 18 Mar 2020 10:05:56 -0400
Message-Id: <1584540356-5885-7-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
References: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Switch {read/write/metadata}_latency_sum to atomic type and remove
{read/write/metadata}_latency_sum showing in the debugfs, which makes
no sense.

URL: https://tracker.ceph.com/issues/44534
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c |  61 +++++++++++++--------
 fs/ceph/metric.c  | 159 ++++++++++++++++++++++++++++++++++++++++++------------
 fs/ceph/metric.h  | 101 +++++++++-------------------------
 3 files changed, 187 insertions(+), 134 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 00c39a2..7c95ae5 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -124,13 +124,15 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static s64 get_avg(struct percpu_counter *totalp, struct percpu_counter *sump,
+static s64 get_avg(atomic64_t *totalp, atomic64_t *sump, spinlock_t *lockp,
 		   s64 *total)
 {
 	s64 t, sum, avg = 0;
 
-	t = percpu_counter_sum(totalp);
-	sum = percpu_counter_sum(sump);
+	spin_lock(lockp);
+	t = atomic64_read(totalp);
+	sum = atomic64_read(sump);
+	spin_unlock(lockp);
 
 	if (likely(t))
 		avg = DIV64_U64_ROUND_CLOSEST(sum, t);
@@ -139,13 +141,22 @@ static s64 get_avg(struct percpu_counter *totalp, struct percpu_counter *sump,
 	return avg;
 }
 
-#define CEPH_METRIC_SHOW(name, total, avg, min, max) {		\
-	s64 _avg, _min, _max;					\
-	_avg = jiffies_to_usecs(avg);				\
-	_min = jiffies_to_usecs(min == S64_MAX ? 0 : min);	\
-	_max = jiffies_to_usecs(max);				\
-	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%lld\n",	\
-		   name, total, _avg, _min, _max);		\
+#define CEPH_METRIC_SHOW(name, total, avg, min, max, sq) {		\
+	s64 _total, _avg, _min, _max, _sq, _st, _re = 0;		\
+	_avg = jiffies_to_usecs(avg);					\
+	_min = jiffies_to_usecs(min == S64_MAX ? 0 : min);		\
+	_max = jiffies_to_usecs(max);					\
+	_total = total - 1;						\
+	_sq = _total > 0 ? DIV64_U64_ROUND_CLOSEST(sq, _total) : 0;	\
+	_sq = jiffies_to_usecs(_sq);					\
+	_st = int_sqrt64(_sq);						\
+	if (_st > 0) {							\
+		_re = 5 * (_sq - (_st * _st));				\
+		_re = _re > 0 ? _re - 1 : 0;				\
+		_re = _st > 0 ? div64_s64(_re, _st) : 0;		\
+	}								\
+	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16lld%lld.%lld\n",	\
+		   name, total, _avg, _min, _max, _st, _re);		\
 }
 
 static int metric_show(struct seq_file *s, void *p)
@@ -154,31 +165,37 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_client_metric *m = &mdsc->metric;
 	int i, nr_caps = 0;
-	s64 total, avg, min, max;
+	s64 total, avg, min, max, sq;
 
-	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)\n");
-	seq_printf(s, "---------------------------------------------------------------------\n");
+	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
+	seq_printf(s, "-----------------------------------------------------------------------------------\n");
 
 	avg = get_avg(&mdsc->metric.total_reads,
 		      &mdsc->metric.read_latency_sum,
+		      &mdsc->metric.read_latency_lock,
 		      &total);
-	min = atomic64_read(&m->read_latency_min);
-	max = atomic64_read(&m->read_latency_max);
-	CEPH_METRIC_SHOW("read", total, avg, min, max);
+	min = atomic64_read(&mdsc->metric.read_latency_min);
+	max = atomic64_read(&mdsc->metric.read_latency_max);
+	sq = percpu_counter_sum(&mdsc->metric.read_latency_sq_sum);
+	CEPH_METRIC_SHOW("read", total, avg, min, max, sq);
 
 	avg = get_avg(&mdsc->metric.total_writes,
 		      &mdsc->metric.write_latency_sum,
+		      &mdsc->metric.write_latency_lock,
 		      &total);
-	min = atomic64_read(&m->write_latency_min);
-	max = atomic64_read(&m->write_latency_max);
-	CEPH_METRIC_SHOW("write", total, avg, min, max);
+	min = atomic64_read(&mdsc->metric.write_latency_min);
+	max = atomic64_read(&mdsc->metric.write_latency_max);
+	sq = percpu_counter_sum(&mdsc->metric.write_latency_sq_sum);
+	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
 
 	avg = get_avg(&mdsc->metric.total_metadatas,
 		      &mdsc->metric.metadata_latency_sum,
+		      &mdsc->metric.metadata_latency_lock,
 		      &total);
-	min = atomic64_read(&m->metadata_latency_min);
-	max = atomic64_read(&m->metadata_latency_max);
-	CEPH_METRIC_SHOW("metadata", total, avg, min, max);
+	min = atomic64_read(&mdsc->metric.metadata_latency_min);
+	max = atomic64_read(&mdsc->metric.metadata_latency_max);
+	sq = percpu_counter_sum(&mdsc->metric.metadata_latency_sq_sum);
+	CEPH_METRIC_SHOW("metadata", total, avg, min, max, sq);
 
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index c0158f6..ac1e800 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -2,6 +2,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu_counter.h>
+#include <linux/math64.h>
 
 #include "metric.h"
 
@@ -29,52 +30,43 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_i_caps_mis;
 
-	ret = percpu_counter_init(&m->total_reads, 0, GFP_KERNEL);
+	ret = percpu_counter_init(&m->read_latency_sq_sum, 0, GFP_KERNEL);
 	if (ret)
-		goto err_total_reads;
-
-	ret = percpu_counter_init(&m->read_latency_sum, 0, GFP_KERNEL);
-	if (ret)
-		goto err_read_latency_sum;
+		goto err_read_latency_sq_sum;
 
+	spin_lock_init(&m->read_latency_lock);
+	atomic64_set(&m->total_reads, 0);
+	atomic64_set(&m->read_latency_sum, 0);
 	atomic64_set(&m->read_latency_min, S64_MAX);
 	atomic64_set(&m->read_latency_max, 0);
 
-	ret = percpu_counter_init(&m->total_writes, 0, GFP_KERNEL);
+	ret = percpu_counter_init(&m->write_latency_sq_sum, 0, GFP_KERNEL);
 	if (ret)
-		goto err_total_writes;
-
-	ret = percpu_counter_init(&m->write_latency_sum, 0, GFP_KERNEL);
-	if (ret)
-		goto err_write_latency_sum;
+		goto err_write_latency_sq_sum;
 
+	spin_lock_init(&m->write_latency_lock);
+	atomic64_set(&m->total_writes, 0);
+	atomic64_set(&m->write_latency_sum, 0);
 	atomic64_set(&m->write_latency_min, S64_MAX);
 	atomic64_set(&m->write_latency_max, 0);
 
-	ret = percpu_counter_init(&m->total_metadatas, 0, GFP_KERNEL);
-	if (ret)
-		goto err_total_metadatas;
-
-	ret = percpu_counter_init(&m->metadata_latency_sum, 0, GFP_KERNEL);
+	ret = percpu_counter_init(&m->metadata_latency_sq_sum, 0, GFP_KERNEL);
 	if (ret)
-		goto err_metadata_latency_sum;
+		goto err_metadata_latency_sq_sum;
 
+	spin_lock_init(&m->metadata_latency_lock);
+	atomic64_set(&m->total_metadatas, 0);
+	atomic64_set(&m->metadata_latency_sum, 0);
 	atomic64_set(&m->metadata_latency_min, S64_MAX);
 	atomic64_set(&m->metadata_latency_max, 0);
 
 	return 0;
 
-err_metadata_latency_sum:
-	percpu_counter_destroy(&m->total_metadatas);
-err_total_metadatas:
-	percpu_counter_destroy(&m->write_latency_sum);
-err_write_latency_sum:
-	percpu_counter_destroy(&m->total_writes);
-err_total_writes:
-	percpu_counter_destroy(&m->read_latency_sum);
-err_read_latency_sum:
-	percpu_counter_destroy(&m->total_reads);
-err_total_reads:
+err_metadata_latency_sq_sum:
+	percpu_counter_destroy(&m->write_latency_sq_sum);
+err_write_latency_sq_sum:
+	percpu_counter_destroy(&m->read_latency_sq_sum);
+err_read_latency_sq_sum:
 	percpu_counter_destroy(&m->i_caps_mis);
 err_i_caps_mis:
 	percpu_counter_destroy(&m->i_caps_hit);
@@ -91,14 +83,111 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
-	percpu_counter_destroy(&m->metadata_latency_sum);
-	percpu_counter_destroy(&m->total_metadatas);
-	percpu_counter_destroy(&m->write_latency_sum);
-	percpu_counter_destroy(&m->total_writes);
-	percpu_counter_destroy(&m->read_latency_sum);
-	percpu_counter_destroy(&m->total_reads);
+	percpu_counter_destroy(&m->metadata_latency_sq_sum);
+	percpu_counter_destroy(&m->write_latency_sq_sum);
+	percpu_counter_destroy(&m->read_latency_sq_sum);
 	percpu_counter_destroy(&m->i_caps_mis);
 	percpu_counter_destroy(&m->i_caps_hit);
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
 }
+
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
+static inline void __update_avg_and_sq(atomic64_t *totalp, atomic64_t *lat_sump,
+				       struct percpu_counter *sq_sump,
+				       spinlock_t *lockp, unsigned long lat)
+{
+	s64 total, avg, sq, lsum;
+
+	spin_lock(lockp);
+	total = atomic64_inc_return(totalp);
+	lsum = atomic64_add_return(lat, lat_sump);
+	spin_unlock(lockp);
+
+	if (unlikely(total == 1))
+		return;
+
+	/* the sq is (lat - old_avg) * (lat - new_avg) */
+	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
+	sq = lat - avg;
+	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
+	sq = sq * (lat - avg);
+	percpu_counter_add(sq_sump, sq);
+}
+
+void ceph_update_read_latency(struct ceph_client_metric *m,
+			      unsigned long r_start,
+			      unsigned long r_end,
+			      int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
+		return;
+
+	__update_min_latency(&m->read_latency_min, lat);
+	__update_max_latency(&m->read_latency_max, lat);
+	__update_avg_and_sq(&m->total_reads, &m->read_latency_sum,
+			    &m->read_latency_sq_sum,
+			    &m->read_latency_lock,
+			    lat);
+}
+
+void ceph_update_write_latency(struct ceph_client_metric *m,
+			       unsigned long r_start,
+			       unsigned long r_end,
+			       int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (rc && rc != -ETIMEDOUT)
+		return;
+
+	__update_min_latency(&m->write_latency_min, lat);
+	__update_max_latency(&m->write_latency_max, lat);
+	__update_avg_and_sq(&m->total_writes, &m->write_latency_sum,
+			    &m->write_latency_sq_sum,
+			    &m->write_latency_lock,
+			    lat);
+}
+
+void ceph_update_metadata_latency(struct ceph_client_metric *m,
+				  unsigned long r_start,
+				  unsigned long r_end,
+				  int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (rc && rc != -ENOENT)
+		return;
+
+	__update_min_latency(&m->metadata_latency_min, lat);
+	__update_max_latency(&m->metadata_latency_max, lat);
+	__update_avg_and_sq(&m->total_metadatas, &m->metadata_latency_sum,
+			    &m->metadata_latency_sq_sum,
+			    &m->metadata_latency_lock,
+			    lat);
+}
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 3f90875..fc1ffb1 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -14,18 +14,24 @@ struct ceph_client_metric {
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
 
-	struct percpu_counter total_reads;
-	struct percpu_counter read_latency_sum;
+	struct percpu_counter read_latency_sq_sum;
+	spinlock_t read_latency_lock;
+	atomic64_t total_reads;
+	atomic64_t read_latency_sum;
 	atomic64_t read_latency_min;
 	atomic64_t read_latency_max;
 
-	struct percpu_counter total_writes;
-	struct percpu_counter write_latency_sum;
+	struct percpu_counter write_latency_sq_sum;
+	spinlock_t write_latency_lock;
+	atomic64_t total_writes;
+	atomic64_t write_latency_sum;
 	atomic64_t write_latency_min;
 	atomic64_t write_latency_max;
 
-	struct percpu_counter total_metadatas;
-	struct percpu_counter metadata_latency_sum;
+	struct percpu_counter metadata_latency_sq_sum;
+	spinlock_t metadata_latency_lock;
+	atomic64_t total_metadatas;
+	atomic64_t metadata_latency_sum;
 	atomic64_t metadata_latency_min;
 	atomic64_t metadata_latency_max;
 };
@@ -43,75 +49,16 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 	percpu_counter_inc(&m->i_caps_mis);
 }
 
-static inline void __update_min_latency(atomic64_t *min, unsigned long lat)
-{
-	unsigned long cur, old;
-
-	cur = atomic64_read(min);
-	do {
-		old = cur;
-		if (likely(lat >= old))
-			break;
-	} while (unlikely((cur = atomic64_cmpxchg(min, old, lat)) != old));
-}
-
-static inline void __update_max_latency(atomic64_t *max, unsigned long lat)
-{
-	unsigned long cur, old;
-
-	cur = atomic64_read(max);
-	do {
-		old = cur;
-		if (likely(lat <= old))
-			break;
-	} while (unlikely((cur = atomic64_cmpxchg(max, old, lat)) != old));
-}
-
-static inline void ceph_update_read_latency(struct ceph_client_metric *m,
-					    unsigned long r_start,
-					    unsigned long r_end,
-					    int rc)
-{
-	unsigned long lat = r_end - r_start;
-
-	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
-		return;
-
-	percpu_counter_inc(&m->total_reads);
-	percpu_counter_add(&m->read_latency_sum, lat);
-	__update_min_latency(&m->read_latency_min, lat);
-	__update_max_latency(&m->read_latency_max, lat);
-}
-
-static inline void ceph_update_write_latency(struct ceph_client_metric *m,
-					     unsigned long r_start,
-					     unsigned long r_end,
-					     int rc)
-{
-	unsigned long lat = r_end - r_start;
-
-	if (rc && rc != -ETIMEDOUT)
-		return;
-
-	percpu_counter_inc(&m->total_writes);
-	percpu_counter_add(&m->write_latency_sum, lat);
-	__update_min_latency(&m->write_latency_min, lat);
-	__update_max_latency(&m->write_latency_max, lat);
-}
-
-static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
-						unsigned long r_start,
-						unsigned long r_end,
-						int rc)
-{
-	unsigned long lat = r_end - r_start;
-
-	if (rc && rc != -ENOENT)
-		return;
-
-	percpu_counter_inc(&m->total_metadatas);
-	percpu_counter_add(&m->metadata_latency_sum, lat);
-	__update_min_latency(&m->metadata_latency_min, lat);
-	__update_max_latency(&m->metadata_latency_max, lat);
-}
+extern void ceph_update_read_latency(struct ceph_client_metric *m,
+				     unsigned long r_start,
+				     unsigned long r_end,
+				     int rc);
+extern void ceph_update_write_latency(struct ceph_client_metric *m,
+				      unsigned long r_start,
+				      unsigned long r_end,
+				      int rc);
+extern void ceph_update_metadata_latency(struct ceph_client_metric *m,
+					 unsigned long r_start,
+					 unsigned long r_end,
+					 int rc);
 #endif /* _FS_CEPH_MDS_METRIC_H */
-- 
1.8.3.1

