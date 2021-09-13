Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C97408C32
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 15:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbhIMNOz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 09:14:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240536AbhIMNOq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 09:14:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631538810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cjed6zVninWiVUPwaQXiHwMycCtQNHfeegV2xHfcplQ=;
        b=PlFAvmWIgSYqOFiohfCvkbzWEZHuOJtiTQVsrx5LGQDNpYV+Jw1CAv5NR+o/f7hsGTlbJp
        xY9zyHKcgvMWf1JY9kZ492B2akYcn+bU6KsluUWNrUpwDBcH4gX/WoRKJNxtZaQQt34JJU
        5eYI2svMT2hI+83I3hqPKYckDe1BJLc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-K3gQIHYaNc6Mztc3inYH8A-1; Mon, 13 Sep 2021 09:13:29 -0400
X-MC-Unique: K3gQIHYaNc6Mztc3inYH8A-1
Received: by mail-pf1-f198.google.com with SMTP id h14-20020a62b40e0000b02903131bc4a1acso6238901pfn.4
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cjed6zVninWiVUPwaQXiHwMycCtQNHfeegV2xHfcplQ=;
        b=l19Q77m7MJSba5RxTs92bvL7XaJbqF3kSemE1WUPb0wtgxaZ1+bU7e1Cw/p5HWroq7
         2Q0uhmVMICT8zilTRox+nBcchW0+MLX5fhjHnjzTt5XhKUqigMr3QjIjldiothY5rS8I
         DzWNQ/7tL8jPQUVD6skcQmE3gg/nI1fSaKBApc0fbBLGa+2S1MtOwdmBI4K7R7msxYrz
         J666cHfiHXu3ejRzNs7earEw69hdeGrkmVFcn7ac9Dpbs7wZDjfa7QdQBgtkI2lyEfGp
         kYlVl3JHly5+zR7Tp+nhmcUpEf2Rh6DZulRIBcOHIVJ+CxQtbvZH6c9OWtnAe5gtj9S4
         Qakg==
X-Gm-Message-State: AOAM531N054a4fYqZpHxc/7qnW9lIQ4ulPnuggiMGHF9Hs1NKhK3SV+J
        +huxlpMP/zm4rWE/G6bzgJOP5qfzat5uBXQYVNgg/YZG2csSgfPHUJp2aSYqroNp1GyNKWnxFue
        4aIwz77b4tO6z1FmOHl5kCg==
X-Received: by 2002:a05:6a00:a94:b029:384:1dc6:7012 with SMTP id b20-20020a056a000a94b02903841dc67012mr10986393pfl.53.1631538807382;
        Mon, 13 Sep 2021 06:13:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuAVKrtJNHJqzo1tV9dxT7m1LWbxAXW1bXkk+O+fo+uUPkhiPo4evsH/AJwJtZqwoczIapJQ==
X-Received: by 2002:a05:6a00:a94:b029:384:1dc6:7012 with SMTP id b20-20020a056a000a94b02903841dc67012mr10986375pfl.53.1631538807158;
        Mon, 13 Sep 2021 06:13:27 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id i10sm7362010pfk.151.2021.09.13.06.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:13:26 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v1 2/4] ceph: track average/stdev r/w/m latency
Date:   Mon, 13 Sep 2021 18:43:09 +0530
Message-Id: <20210913131311.1347903-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913131311.1347903-1-vshankar@redhat.com>
References: <20210913131311.1347903-1-vshankar@redhat.com>
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
 fs/ceph/debugfs.c |  6 +++---
 fs/ceph/metric.c  | 45 ++++++++++++++++++++++++---------------------
 fs/ceph/metric.h  |  9 ++++++---
 3 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index f9ff70704423..9153bc233e08 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -176,7 +176,7 @@ static int metric_show(struct seq_file *s, void *p)
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->read_latency_min;
 	max = m->read_latency_max;
-	sq = m->read_latency_sq_sum;
+	sq = m->read_latency_stdev;
 	spin_unlock(&m->read_latency_lock);
 	CEPH_METRIC_SHOW("read", total, avg, min, max, sq);
 
@@ -186,7 +186,7 @@ static int metric_show(struct seq_file *s, void *p)
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->write_latency_min;
 	max = m->write_latency_max;
-	sq = m->write_latency_sq_sum;
+	sq = m->write_latency_stdev;
 	spin_unlock(&m->write_latency_lock);
 	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
 
@@ -196,7 +196,7 @@ static int metric_show(struct seq_file *s, void *p)
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->metadata_latency_min;
 	max = m->metadata_latency_max;
-	sq = m->metadata_latency_sq_sum;
+	sq = m->metadata_latency_stdev;
 	spin_unlock(&m->metadata_latency_lock);
 	CEPH_METRIC_SHOW("metadata", total, avg, min, max, sq);
 
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 19bca20cf7e1..e00b1c2ce25b 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -184,21 +184,24 @@ int ceph_metric_init(struct ceph_client_metric *m)
 		goto err_i_caps_mis;
 
 	spin_lock_init(&m->read_latency_lock);
-	m->read_latency_sq_sum = 0;
+	m->read_latency_stdev = 0;
+	m->avg_read_latency = 0;
 	m->read_latency_min = KTIME_MAX;
 	m->read_latency_max = 0;
 	m->total_reads = 0;
 	m->read_latency_sum = 0;
 
 	spin_lock_init(&m->write_latency_lock);
-	m->write_latency_sq_sum = 0;
+	m->write_latency_stdev = 0;
+	m->avg_write_latency = 0;
 	m->write_latency_min = KTIME_MAX;
 	m->write_latency_max = 0;
 	m->total_writes = 0;
 	m->write_latency_sum = 0;
 
 	spin_lock_init(&m->metadata_latency_lock);
-	m->metadata_latency_sq_sum = 0;
+	m->metadata_latency_stdev = 0;
+	m->avg_metadata_latency = 0;
 	m->metadata_latency_min = KTIME_MAX;
 	m->metadata_latency_max = 0;
 	m->total_metadatas = 0;
@@ -250,10 +253,10 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 }
 
 static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
-				    ktime_t *min, ktime_t *max,
-				    ktime_t *sq_sump, ktime_t lat)
+				    ktime_t *lavgp, ktime_t *min, ktime_t *max,
+				    ktime_t *lstdev, ktime_t lat)
 {
-	ktime_t total, avg, sq, lsum;
+	ktime_t total, avg, stdev, lsum;
 
 	total = ++(*totalp);
 	lsum = (*lsump += lat);
@@ -263,15 +266,15 @@ static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
 	if (unlikely(lat > *max))
 		*max = lat;
 
-	if (unlikely(total == 1))
-		return;
-
-	/* the sq is (lat - old_avg) * (lat - new_avg) */
-	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
-	sq = lat - avg;
-	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
-	sq = sq * (lat - avg);
-	*sq_sump += sq;
+	if (unlikely(total == 1)) {
+		*lavgp = lat;
+		*lstdev = 0;
+	} else {
+		avg = *lavgp + div64_s64(lat - *lavgp, total);
+		stdev = *lstdev + (lat - *lavgp)*(lat - avg);
+		*lstdev = int_sqrt(div64_u64(stdev, total - 1));
+		*lavgp = avg;
+	}
 }
 
 void ceph_update_read_latency(struct ceph_client_metric *m,
@@ -285,8 +288,8 @@ void ceph_update_read_latency(struct ceph_client_metric *m,
 
 	spin_lock(&m->read_latency_lock);
 	__update_latency(&m->total_reads, &m->read_latency_sum,
-			 &m->read_latency_min, &m->read_latency_max,
-			 &m->read_latency_sq_sum, lat);
+			 &m->avg_read_latency, &m->read_latency_min,
+			 &m->read_latency_max, &m->read_latency_stdev, lat);
 	spin_unlock(&m->read_latency_lock);
 }
 
@@ -301,8 +304,8 @@ void ceph_update_write_latency(struct ceph_client_metric *m,
 
 	spin_lock(&m->write_latency_lock);
 	__update_latency(&m->total_writes, &m->write_latency_sum,
-			 &m->write_latency_min, &m->write_latency_max,
-			 &m->write_latency_sq_sum, lat);
+			 &m->avg_write_latency, &m->write_latency_min,
+			 &m->write_latency_max, &m->write_latency_stdev, lat);
 	spin_unlock(&m->write_latency_lock);
 }
 
@@ -317,7 +320,7 @@ void ceph_update_metadata_latency(struct ceph_client_metric *m,
 
 	spin_lock(&m->metadata_latency_lock);
 	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
-			 &m->metadata_latency_min, &m->metadata_latency_max,
-			 &m->metadata_latency_sq_sum, lat);
+			 &m->avg_metadata_latency, &m->metadata_latency_min,
+			 &m->metadata_latency_max, &m->metadata_latency_stdev, lat);
 	spin_unlock(&m->metadata_latency_lock);
 }
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 1151d64dbcbc..136689fa0aec 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -108,21 +108,24 @@ struct ceph_client_metric {
 	spinlock_t read_latency_lock;
 	u64 total_reads;
 	ktime_t read_latency_sum;
-	ktime_t read_latency_sq_sum;
+	ktime_t avg_read_latency;
+	ktime_t read_latency_stdev;
 	ktime_t read_latency_min;
 	ktime_t read_latency_max;
 
 	spinlock_t write_latency_lock;
 	u64 total_writes;
 	ktime_t write_latency_sum;
-	ktime_t write_latency_sq_sum;
+	ktime_t avg_write_latency;
+	ktime_t write_latency_stdev;
 	ktime_t write_latency_min;
 	ktime_t write_latency_max;
 
 	spinlock_t metadata_latency_lock;
 	u64 total_metadatas;
 	ktime_t metadata_latency_sum;
-	ktime_t metadata_latency_sq_sum;
+	ktime_t avg_metadata_latency;
+	ktime_t metadata_latency_stdev;
 	ktime_t metadata_latency_min;
 	ktime_t metadata_latency_max;
 
-- 
2.27.0

