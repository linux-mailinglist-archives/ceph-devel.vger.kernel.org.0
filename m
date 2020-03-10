Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116A717EEAC
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 03:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCJChQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 22:37:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28851 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726521AbgCJChQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 22:37:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583807833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=PpUUbijtdL22kJ7qp6mEqaz6tttg6woVFtKiRlAwPGY=;
        b=PK6Idu+CMdc32AH1EITV1PFgVacPP0ikMTLQCW5Z+9h1k0dXfz0XvFrDomXzO/yONgOkR1
        W5q2ci+HBdsceqCe2LssTG3SF7rbR8H2ybmMDuk/7xCnOTYePXO957v9hdiAxQGKZr9oBh
        7/3ps3jtCwVjq0a0SZskz24u7AGn8ik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-ECCjBX9rMaGKqOw0iw7FlQ-1; Mon, 09 Mar 2020 22:37:09 -0400
X-MC-Unique: ECCjBX9rMaGKqOw0iw7FlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3EC3184C800;
        Tue, 10 Mar 2020 02:37:08 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A60087B2F;
        Tue, 10 Mar 2020 02:37:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        gfarnum@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add min/max latency support for read/write/metadata metrics
Date:   Mon,  9 Mar 2020 22:36:57 -0400
Message-Id: <1583807817-5571-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

These will be very useful help diagnose problems.

URL: https://tracker.ceph.com/issues/44533
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

The output will be like:

# cat /sys/kernel/debug/ceph/19e31430-fc65-4aa1-99cf-2c8eaaafd451.client4347/metrics 
item          total       sum_lat(us)     avg_lat(us)     min_lat(us)     max_lat(us)
-------------------------------------------------------------------------------------
read          27          297000          11000           2000            27000
write         16          3860000         241250          175000          263000
metadata      3           30000           10000           2000            16000

item          total           miss            hit
-------------------------------------------------
d_lease       2               0               1
caps          2               0               3078



 fs/ceph/debugfs.c    | 27 ++++++++++++++++++++------
 fs/ceph/mds_client.c | 12 ++++++++++++
 fs/ceph/metric.h     | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 60f3e307..9ef0ffe 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -129,28 +129,43 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	int i, nr_caps = 0;
-	s64 total, sum, avg = 0;
+	s64 total, sum, avg = 0, min, max;
 
-	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n");
-	seq_printf(s, "-----------------------------------------------------\n");
+	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)     min_lat(us)     max_lat(us)\n");
+	seq_printf(s, "-------------------------------------------------------------------------------------\n");
 
 	total = percpu_counter_sum(&mdsc->metric.total_reads);
 	sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
 	sum = jiffies_to_usecs(sum);
 	avg = total ? sum / total : 0;
-	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read", total, sum, avg);
+	min = atomic64_read(&mdsc->metric.read_latency_min);
+	min = jiffies_to_usecs(min == S64_MAX ? 0 : min);
+	max = atomic64_read(&mdsc->metric.read_latency_max);
+	max = jiffies_to_usecs(max);
+	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16lld%lld\n", "read",
+		   total, sum, avg, min, max);
 
 	total = percpu_counter_sum(&mdsc->metric.total_writes);
 	sum = percpu_counter_sum(&mdsc->metric.write_latency_sum);
 	sum = jiffies_to_usecs(sum);
 	avg = total ? sum / total : 0;
-	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
+	min = atomic64_read(&mdsc->metric.write_latency_min);
+	min = jiffies_to_usecs(min == S64_MAX ? 0 : min);
+	max = atomic64_read(&mdsc->metric.write_latency_max);
+	max = jiffies_to_usecs(max);
+	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16lld%lld\n", "write",
+		   total, sum, avg, min, max);
 
 	total = percpu_counter_sum(&mdsc->metric.total_metadatas);
 	sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
 	sum = jiffies_to_usecs(sum);
 	avg = total ? sum / total : 0;
-	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata", total, sum, avg);
+	min = atomic64_read(&mdsc->metric.metadata_latency_min);
+	min = jiffies_to_usecs(min == S64_MAX ? 0 : min);
+	max = atomic64_read(&mdsc->metric.metadata_latency_max);
+	max = jiffies_to_usecs(max);
+	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16lld%lld\n", "metadata",
+		   total, sum, avg, min, max);
 
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 5c03ed3..ff6c2be 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4358,6 +4358,10 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
 	if (ret)
 		goto err_read_latency_sum;
 
+	spin_lock_init(&metric->read_latency_lock);
+	atomic64_set(&metric->read_latency_min, S64_MAX);
+	atomic64_set(&metric->read_latency_max, 0);
+
 	ret = percpu_counter_init(&metric->total_writes, 0, GFP_KERNEL);
 	if (ret)
 		goto err_total_writes;
@@ -4366,6 +4370,10 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
 	if (ret)
 		goto err_write_latency_sum;
 
+	spin_lock_init(&metric->write_latency_lock);
+	atomic64_set(&metric->write_latency_min, S64_MAX);
+	atomic64_set(&metric->write_latency_max, 0);
+
 	ret = percpu_counter_init(&metric->total_metadatas, 0, GFP_KERNEL);
 	if (ret)
 		goto err_total_metadatas;
@@ -4374,6 +4382,10 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
 	if (ret)
 		goto err_metadata_latency_sum;
 
+	spin_lock_init(&metric->metadata_latency_lock);
+	atomic64_set(&metric->metadata_latency_min, S64_MAX);
+	atomic64_set(&metric->metadata_latency_max, 0);
+
 	return 0;
 
 err_metadata_latency_sum:
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index faba142..9f0d050 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -2,6 +2,10 @@
 #ifndef _FS_CEPH_MDS_METRIC_H
 #define _FS_CEPH_MDS_METRIC_H
 
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+
 /* This is the global metrics */
 struct ceph_client_metric {
 	atomic64_t            total_dentries;
@@ -13,12 +17,21 @@ struct ceph_client_metric {
 
 	struct percpu_counter total_reads;
 	struct percpu_counter read_latency_sum;
+	spinlock_t read_latency_lock;
+	atomic64_t read_latency_min;
+	atomic64_t read_latency_max;
 
 	struct percpu_counter total_writes;
 	struct percpu_counter write_latency_sum;
+	spinlock_t write_latency_lock;
+	atomic64_t write_latency_min;
+	atomic64_t write_latency_max;
 
 	struct percpu_counter total_metadatas;
 	struct percpu_counter metadata_latency_sum;
+	spinlock_t metadata_latency_lock;
+	atomic64_t metadata_latency_min;
+	atomic64_t metadata_latency_max;
 };
 
 static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
@@ -36,11 +49,24 @@ static inline void ceph_update_read_latency(struct ceph_client_metric *m,
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
+
+	if (lat >= atomic64_read(&m->read_latency_min) &&
+	    lat <= atomic64_read(&m->read_latency_max))
+		return;
+
+	spin_lock(&m->read_latency_lock);
+	if (lat < atomic64_read(&m->read_latency_min))
+		atomic64_set(&m->read_latency_min, lat);
+	if (lat > atomic64_read(&m->read_latency_max))
+		atomic64_set(&m->read_latency_max, lat);
+	spin_unlock(&m->read_latency_lock);
 }
 
 static inline void ceph_update_write_latency(struct ceph_client_metric *m,
@@ -48,11 +74,24 @@ static inline void ceph_update_write_latency(struct ceph_client_metric *m,
 					     unsigned long r_end,
 					     int rc)
 {
+	unsigned long lat = r_end - r_start;
+
 	if (rc && rc != -ETIMEDOUT)
 		return;
 
 	percpu_counter_inc(&m->total_writes);
 	percpu_counter_add(&m->write_latency_sum, r_end - r_start);
+
+	if (lat >= atomic64_read(&m->write_latency_min) &&
+	    lat <= atomic64_read(&m->write_latency_max))
+		return;
+
+	spin_lock(&m->write_latency_lock);
+	if (lat < atomic64_read(&m->write_latency_min))
+		atomic64_set(&m->write_latency_min, lat);
+	if (lat > atomic64_read(&m->write_latency_max))
+		atomic64_set(&m->write_latency_max, lat);
+	spin_unlock(&m->write_latency_lock);
 }
 
 static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
@@ -60,10 +99,23 @@ static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
 						unsigned long r_end,
 						int rc)
 {
+	unsigned long lat = r_end - r_start;
+
 	if (rc && rc != -ENOENT)
 		return;
 
 	percpu_counter_inc(&m->total_metadatas);
 	percpu_counter_add(&m->metadata_latency_sum, r_end - r_start);
+
+	if (lat >= atomic64_read(&m->metadata_latency_min) &&
+	    lat <= atomic64_read(&m->metadata_latency_max))
+		return;
+
+	spin_lock(&m->metadata_latency_lock);
+	if (lat < atomic64_read(&m->metadata_latency_min))
+		atomic64_set(&m->metadata_latency_min, lat);
+	if (lat > atomic64_read(&m->metadata_latency_max))
+		atomic64_set(&m->metadata_latency_max, lat);
+	spin_unlock(&m->metadata_latency_lock);
 }
 #endif /* _FS_CEPH_MDS_METRIC_H */
-- 
1.8.3.1

