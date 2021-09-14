Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716BA40A997
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 10:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhINIuf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 04:50:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229975AbhINIuf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 04:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631609357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8hyh99eGG99De2bMq9NDd3b3J6KyeGnSZ5PbazrQAAw=;
        b=eM5ox/lvLt2gnOJ8x6Kt8FtqqNnHacSGCwH0MM16xT4YvxtIVcXaQUX95ImaAD7ZLV/58R
        TlTKgng48Yy8uG+FNo9falrrWTWk+1leAEgCOrP30/DT29zJ3D0GRYHgFO0F2p8VdyzyC5
        cqMKDqQ07jf/ZKhEZ6DPi0W/mGn3yJ8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-ePp4hgslOUGw4DSLSDxhig-1; Tue, 14 Sep 2021 04:49:16 -0400
X-MC-Unique: ePp4hgslOUGw4DSLSDxhig-1
Received: by mail-pf1-f198.google.com with SMTP id r1-20020a62e401000000b003f27c6ae031so7852469pfh.20
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 01:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8hyh99eGG99De2bMq9NDd3b3J6KyeGnSZ5PbazrQAAw=;
        b=axotPPGvUNIoxq71oNIu41oF5hWTXr+bbycU2a67VykDS9zeDlDuxeOoSf6M9ahlw3
         rx+W3q/BksnNlXjkaEgBag8da1Q8zUaytpL66vYnULDSrBzI9sYTRwYq11gSjMNPlwmk
         zmmDJOqbXnTRbvTQBRjMxFYXPpUSdkRGm8XfJzpyfoocXfQnKHmnlJGYbFOy4H6Z6mpT
         KAnKIsOmfZMp/TtXY6sMyDmcEb6hFyZfGplNspgU57VcQ0yzh96UlJCXbNzlX7sbrVbF
         5m2N4o+6PKnIzeJvkfUfDZxM+yZL9gplE+2oH+YOJOUB8aMHyNv8nbFPe7Wy6R974LGm
         kSVA==
X-Gm-Message-State: AOAM530IxSovWtfALGk4me3i8yEiK+ciSvyeQHPKQlOrtfozwpxHTIsh
        qfEMnk/SBqFzjtGn8JQfzNPUHONNz/r+dUm4qRYpUBDLst6U+WN0BbfWbGl9M6VJ1CyGEEHI+Ud
        0HvwKT6yXf4uNT2fS+cr2JA==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr835979pjb.21.1631609355395;
        Tue, 14 Sep 2021 01:49:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLGO82ocSBX5nLZxGzycMfAMoZdyvFQwBl0YMMVTqFJS9EIEwvSUKsCqm1d4W+mpfAMTgRUQ==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr835960pjb.21.1631609355169;
        Tue, 14 Sep 2021 01:49:15 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id b12sm10006219pff.63.2021.09.14.01.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 01:49:14 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 2/4] ceph: track average/stdev r/w/m latency
Date:   Tue, 14 Sep 2021 14:19:00 +0530
Message-Id: <20210914084902.1618064-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914084902.1618064-1-vshankar@redhat.com>
References: <20210914084902.1618064-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The math involved in tracking average and standard deviation
for r/w/m latencies looks incorrect. Fix that up. Also, change
the variable name that tracks standard deviation (*_sq_sum) to
*_stdev.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/debugfs.c | 14 +++++-----
 fs/ceph/metric.c  | 70 ++++++++++++++++++++++-------------------------
 fs/ceph/metric.h  |  9 ++++--
 3 files changed, 45 insertions(+), 48 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 38b78b45811f..3abfa7ae8220 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -152,7 +152,7 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_client_metric *m = &mdsc->metric;
 	int nr_caps = 0;
-	s64 total, sum, avg, min, max, sq;
+	s64 total, sum, avg, min, max, stdev;
 	u64 sum_sz, avg_sz, min_sz, max_sz;
 
 	sum = percpu_counter_sum(&m->total_inodes);
@@ -175,9 +175,9 @@ static int metric_show(struct seq_file *s, void *p)
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->read_latency_min;
 	max = m->read_latency_max;
-	sq = m->read_latency_sq_sum;
+	stdev = m->read_latency_stdev;
 	spin_unlock(&m->read_metric_lock);
-	CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, sq);
+	CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, stdev);
 
 	spin_lock(&m->write_metric_lock);
 	total = m->total_writes;
@@ -185,9 +185,9 @@ static int metric_show(struct seq_file *s, void *p)
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->write_latency_min;
 	max = m->write_latency_max;
-	sq = m->write_latency_sq_sum;
+	stdev = m->write_latency_stdev;
 	spin_unlock(&m->write_metric_lock);
-	CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, sq);
+	CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, stdev);
 
 	spin_lock(&m->metadata_metric_lock);
 	total = m->total_metadatas;
@@ -195,9 +195,9 @@ static int metric_show(struct seq_file *s, void *p)
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->metadata_latency_min;
 	max = m->metadata_latency_max;
-	sq = m->metadata_latency_sq_sum;
+	stdev = m->metadata_latency_stdev;
 	spin_unlock(&m->metadata_metric_lock);
-	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
+	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, stdev);
 
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 226dc38e2909..6b774b1a88ce 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -244,7 +244,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
 		goto err_i_caps_mis;
 
 	spin_lock_init(&m->read_metric_lock);
-	m->read_latency_sq_sum = 0;
+	m->read_latency_stdev = 0;
+	m->avg_read_latency = 0;
 	m->read_latency_min = KTIME_MAX;
 	m->read_latency_max = 0;
 	m->total_reads = 0;
@@ -254,7 +255,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->read_size_sum = 0;
 
 	spin_lock_init(&m->write_metric_lock);
-	m->write_latency_sq_sum = 0;
+	m->write_latency_stdev = 0;
+	m->avg_write_latency = 0;
 	m->write_latency_min = KTIME_MAX;
 	m->write_latency_max = 0;
 	m->total_writes = 0;
@@ -264,7 +266,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->write_size_sum = 0;
 
 	spin_lock_init(&m->metadata_metric_lock);
-	m->metadata_latency_sq_sum = 0;
+	m->metadata_latency_stdev = 0;
+	m->avg_metadata_latency = 0;
 	m->metadata_latency_min = KTIME_MAX;
 	m->metadata_latency_max = 0;
 	m->total_metadatas = 0;
@@ -322,20 +325,26 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 		max = new;			\
 }
 
-static inline void __update_stdev(ktime_t total, ktime_t lsum,
-				  ktime_t *sq_sump, ktime_t lat)
+static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
+				    ktime_t *lavg, ktime_t *min, ktime_t *max,
+				    ktime_t *lstdev, ktime_t lat)
 {
-	ktime_t avg, sq;
+	ktime_t total, avg, stdev;
 
-	if (unlikely(total == 1))
-		return;
+	total = ++(*ctotal);
+	*lsum += lat;
+
+	METRIC_UPDATE_MIN_MAX(*min, *max, lat);
 
-	/* the sq is (lat - old_avg) * (lat - new_avg) */
-	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
-	sq = lat - avg;
-	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
-	sq = sq * (lat - avg);
-	*sq_sump += sq;
+	if (unlikely(total == 1)) {
+		*lavg = lat;
+		*lstdev = 0;
+	} else {
+		avg = *lavg + div64_s64(lat - *lavg, total);
+		stdev = *lstdev + (lat - *lavg)*(lat - avg);
+		*lstdev = int_sqrt(div64_u64(stdev, total - 1));
+		*lavg = avg;
+	}
 }
 
 void ceph_update_read_metrics(struct ceph_client_metric *m,
@@ -343,23 +352,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
 			      unsigned int size, int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
-	ktime_t total;
 
 	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
 		return;
 
 	spin_lock(&m->read_metric_lock);
-	total = ++m->total_reads;
 	m->read_size_sum += size;
-	m->read_latency_sum += lat;
 	METRIC_UPDATE_MIN_MAX(m->read_size_min,
 			      m->read_size_max,
 			      size);
-	METRIC_UPDATE_MIN_MAX(m->read_latency_min,
-			      m->read_latency_max,
-			      lat);
-	__update_stdev(total, m->read_latency_sum,
-		       &m->read_latency_sq_sum, lat);
+	__update_latency(&m->total_reads, &m->read_latency_sum,
+			 &m->avg_read_latency, &m->read_latency_min,
+			 &m->read_latency_max, &m->read_latency_stdev, lat);
 	spin_unlock(&m->read_metric_lock);
 }
 
@@ -368,23 +372,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
 			       unsigned int size, int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
-	ktime_t total;
 
 	if (unlikely(rc && rc != -ETIMEDOUT))
 		return;
 
 	spin_lock(&m->write_metric_lock);
-	total = ++m->total_writes;
 	m->write_size_sum += size;
-	m->write_latency_sum += lat;
 	METRIC_UPDATE_MIN_MAX(m->write_size_min,
 			      m->write_size_max,
 			      size);
-	METRIC_UPDATE_MIN_MAX(m->write_latency_min,
-			      m->write_latency_max,
-			      lat);
-	__update_stdev(total, m->write_latency_sum,
-		       &m->write_latency_sq_sum, lat);
+	__update_latency(&m->total_writes, &m->write_latency_sum,
+			 &m->avg_write_latency, &m->write_latency_min,
+			 &m->write_latency_max, &m->write_latency_stdev, lat);
 	spin_unlock(&m->write_metric_lock);
 }
 
@@ -393,18 +392,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 				  int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
-	ktime_t total;
 
 	if (unlikely(rc && rc != -ENOENT))
 		return;
 
 	spin_lock(&m->metadata_metric_lock);
-	total = ++m->total_metadatas;
-	m->metadata_latency_sum += lat;
-	METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
-			      m->metadata_latency_max,
-			      lat);
-	__update_stdev(total, m->metadata_latency_sum,
-		       &m->metadata_latency_sq_sum, lat);
+	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
+			 &m->avg_metadata_latency, &m->metadata_latency_min,
+			 &m->metadata_latency_max, &m->metadata_latency_stdev, lat);
 	spin_unlock(&m->metadata_metric_lock);
 }
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 103ed736f9d2..a5da21b8f8ed 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -138,7 +138,8 @@ struct ceph_client_metric {
 	u64 read_size_min;
 	u64 read_size_max;
 	ktime_t read_latency_sum;
-	ktime_t read_latency_sq_sum;
+	ktime_t avg_read_latency;
+	ktime_t read_latency_stdev;
 	ktime_t read_latency_min;
 	ktime_t read_latency_max;
 
@@ -148,14 +149,16 @@ struct ceph_client_metric {
 	u64 write_size_min;
 	u64 write_size_max;
 	ktime_t write_latency_sum;
-	ktime_t write_latency_sq_sum;
+	ktime_t avg_write_latency;
+	ktime_t write_latency_stdev;
 	ktime_t write_latency_min;
 	ktime_t write_latency_max;
 
 	spinlock_t metadata_metric_lock;
 	u64 total_metadatas;
 	ktime_t metadata_latency_sum;
-	ktime_t metadata_latency_sq_sum;
+	ktime_t avg_metadata_latency;
+	ktime_t metadata_latency_stdev;
 	ktime_t metadata_latency_min;
 	ktime_t metadata_latency_max;
 
-- 
2.31.1

