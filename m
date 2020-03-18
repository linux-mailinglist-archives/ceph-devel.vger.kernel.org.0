Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5329189574
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 06:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgCRFq0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 01:46:26 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:27590 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727029AbgCRFq0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 01:46:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584510384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=SJhv3JRts9Zb8GyfXn59WSKVJ12iD8bW7vMm2b2oyjM=;
        b=OT4D0V6kjPzNZRybUz3LFH/poH8sPG5WTLT0kF6g3+gNIVG98Ultmj4meTnEnMFSRGzpi+
        +3oBt0AF6rPYTzuSEZI/s5ppXTv/iH61kA9k9alNTTSD30eD3cIOPzxFOztQqzr1I8QMV0
        16WJT5tdX8CAgzZ9eMRMmcjC7r/mt0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-Xriqf919P8-pHeNYG4hyhQ-1; Wed, 18 Mar 2020 01:46:18 -0400
X-MC-Unique: Xriqf919P8-pHeNYG4hyhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEB45107ACC9;
        Wed, 18 Mar 2020 05:46:17 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13EC69080E;
        Wed, 18 Mar 2020 05:46:14 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 4/4] ceph: add standard deviation support for read/write/metadata perf metric
Date:   Wed, 18 Mar 2020 01:45:55 -0400
Message-Id: <1584510355-6936-5-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584510355-6936-1-git-send-email-xiubli@redhat.com>
References: <1584510355-6936-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 fs/ceph/debugfs.c | 88 +++++++++++++++++++++++++++++++++----------------
 fs/ceph/metric.c  | 99 ++++++++++++++++++++++++++++++++-----------------------
 fs/ceph/metric.h  | 18 ++++++----
 3 files changed, 129 insertions(+), 76 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 01b95fe..21f5663 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/ceph/ceph_debug.h>
 
+#include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -124,48 +125,77 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static s64 get_avg(atomic64_t *totalp, atomic64_t *sump, spinlock_t *lockp,
+		   s64 *total)
+{
+	s64 n, sum, avg = 0;
+
+	spin_lock(lockp);
+	n = atomic64_read(totalp);
+	sum = atomic64_read(sump);
+	spin_unlock(lockp);
+
+	if (likely(n))
+		avg = DIV64_U64_ROUND_CLOSEST(sum, n);
+
+	*total = n;
+	return avg;
+}
+
+#define METRIC(name, total, avg, min, max, sq)	{			\
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
+}
+
 static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	int i, nr_caps = 0;
-	s64 total, sum, avg = 0, min, max;
+	s64 total, avg, min, max, sq;
 
-	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)     min_lat(us)     max_lat(us)\n");
-	seq_printf(s, "-------------------------------------------------------------------------------------\n");
+	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
+	seq_printf(s, "-----------------------------------------------------------------------------------\n");
 
-	total = percpu_counter_sum(&mdsc->metric.total_reads);
-	sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
-	sum = jiffies_to_usecs(sum);
-	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = get_avg(&mdsc->metric.total_reads,
+		      &mdsc->metric.read_latency_sum,
+		      &mdsc->metric.read_latency_lock,
+		      &total);
 	min = atomic64_read(&mdsc->metric.read_latency_min);
-	min = jiffies_to_usecs(min == S64_MAX ? 0 : min);
 	max = atomic64_read(&mdsc->metric.read_latency_max);
-	max = jiffies_to_usecs(max);
-	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16lld%lld\n", "read",
-		   total, sum, avg, min, max);
-
-	total = percpu_counter_sum(&mdsc->metric.total_writes);
-	sum = percpu_counter_sum(&mdsc->metric.write_latency_sum);
-	sum = jiffies_to_usecs(sum);
-	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	sq = percpu_counter_sum(&mdsc->metric.read_latency_sq_sum);
+	METRIC("read", total, avg, min, max, sq);
+
+	avg = get_avg(&mdsc->metric.total_writes,
+		      &mdsc->metric.write_latency_sum,
+		      &mdsc->metric.write_latency_lock,
+		      &total);
 	min = atomic64_read(&mdsc->metric.write_latency_min);
-	min = jiffies_to_usecs(min == S64_MAX ? 0 : min);
 	max = atomic64_read(&mdsc->metric.write_latency_max);
-	max = jiffies_to_usecs(max);
-	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16lld%lld\n", "write",
-		   total, sum, avg, min, max);
-
-	total = percpu_counter_sum(&mdsc->metric.total_metadatas);
-	sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
-	sum = jiffies_to_usecs(sum);
-	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	sq = percpu_counter_sum(&mdsc->metric.write_latency_sq_sum);
+	METRIC("write", total, avg, min, max, sq);
+
+	avg = get_avg(&mdsc->metric.total_metadatas,
+		      &mdsc->metric.metadata_latency_sum,
+		      &mdsc->metric.metadata_latency_lock,
+		      &total);
 	min = atomic64_read(&mdsc->metric.metadata_latency_min);
-	min = jiffies_to_usecs(min == S64_MAX ? 0 : min);
 	max = atomic64_read(&mdsc->metric.metadata_latency_max);
-	max = jiffies_to_usecs(max);
-	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16lld%lld\n", "metadata",
-		   total, sum, avg, min, max);
+	sq = percpu_counter_sum(&mdsc->metric.metadata_latency_sq_sum);
+	METRIC("metadata", total, avg, min, max, sq);
 
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 1b764df..23bd80f 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/kernel.h>
 #include <linux/atomic.h>
 #include <linux/percpu_counter.h>
 
@@ -29,52 +30,43 @@ int ceph_mdsc_metric_init(struct ceph_client_metric *m)
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
-	if (ret)
-		goto err_total_writes;
-
-	ret = percpu_counter_init(&m->write_latency_sum, 0, GFP_KERNEL);
+	ret = percpu_counter_init(&m->write_latency_sq_sum, 0, GFP_KERNEL);
 	if (ret)
-		goto err_write_latency_sum;
+		goto err_write_latency_sq_sum;
 
+	spin_lock_init(&m->write_latency_lock);
+	atomic64_set(&m->total_writes, 0);
+	atomic64_set(&m->write_latency_sum, 0);
 	atomic64_set(&m->write_latency_min, S64_MAX);
 	atomic64_set(&m->write_latency_max, 0);
 
-	ret = percpu_counter_init(&m->total_metadatas, 0, GFP_KERNEL);
+	ret = percpu_counter_init(&m->metadata_latency_sq_sum, 0, GFP_KERNEL);
 	if (ret)
-		goto err_total_metadatas;
-
-	ret = percpu_counter_init(&m->metadata_latency_sum, 0, GFP_KERNEL);
-	if (ret)
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
@@ -88,12 +80,9 @@ int ceph_mdsc_metric_init(struct ceph_client_metric *m)
 
 void ceph_mdsc_metric_destroy(struct ceph_client_metric *m)
 {
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
@@ -124,6 +113,28 @@ static inline void __update_max_latency(atomic64_t *max, unsigned long lat)
 	} while (unlikely((cur = atomic64_cmpxchg(max, old, lat)) != old));
 }
 
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
 void ceph_update_read_latency(struct ceph_client_metric *m,
 			      unsigned long r_start,
 			      unsigned long r_end,
@@ -134,10 +145,12 @@ void ceph_update_read_latency(struct ceph_client_metric *m,
 	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
 		return;
 
-	percpu_counter_inc(&m->total_reads);
-	percpu_counter_add(&m->read_latency_sum, lat);
 	__update_min_latency(&m->read_latency_min, lat);
 	__update_max_latency(&m->read_latency_max, lat);
+	__update_avg_and_sq(&m->total_reads, &m->read_latency_sum,
+			    &m->read_latency_sq_sum,
+			    &m->read_latency_lock,
+			    lat);
 }
 
 void ceph_update_write_latency(struct ceph_client_metric *m,
@@ -150,10 +163,12 @@ void ceph_update_write_latency(struct ceph_client_metric *m,
 	if (rc && rc != -ETIMEDOUT)
 		return;
 
-	percpu_counter_inc(&m->total_writes);
-	percpu_counter_add(&m->write_latency_sum, lat);
 	__update_min_latency(&m->write_latency_min, lat);
 	__update_max_latency(&m->write_latency_max, lat);
+	__update_avg_and_sq(&m->total_writes, &m->write_latency_sum,
+			    &m->write_latency_sq_sum,
+			    &m->write_latency_lock,
+			    lat);
 }
 
 void ceph_update_metadata_latency(struct ceph_client_metric *m,
@@ -166,8 +181,10 @@ void ceph_update_metadata_latency(struct ceph_client_metric *m,
 	if (rc && rc != -ENOENT)
 		return;
 
-	percpu_counter_inc(&m->total_metadatas);
-	percpu_counter_add(&m->metadata_latency_sum, lat);
 	__update_min_latency(&m->metadata_latency_min, lat);
 	__update_max_latency(&m->metadata_latency_max, lat);
+	__update_avg_and_sq(&m->total_metadatas, &m->metadata_latency_sum,
+			    &m->metadata_latency_sq_sum,
+			    &m->metadata_latency_lock,
+			    lat);
 }
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index f139aff..d63b95e 100644
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
-- 
1.8.3.1

