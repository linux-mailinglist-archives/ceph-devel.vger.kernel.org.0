Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7A14133C1
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Sep 2021 15:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhIUNJg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Sep 2021 09:09:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232828AbhIUNJg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 09:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632229687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/jpsnbT1BId0lAcyPCs8B7qUvWWy9dYCkSOGGJRA7rk=;
        b=XRdm2/9COA98isItMvoy5moGbPe+RLPaJ8eMnyKC0ZRKTmoL26jRpJK14hPHBDWW6FMdEj
        HnMeDtuZyWdQmEQvAPxcr0vPzIV3aNqfXNGHhS2207LGLkehjWjZCtfyDt/B+4ywLenpVB
        t1B+4ht1ndkee3LCm27Ew4oM8OfgiiU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-pEUy2_l0Of-jLYq3VBsiDQ-1; Tue, 21 Sep 2021 09:08:06 -0400
X-MC-Unique: pEUy2_l0Of-jLYq3VBsiDQ-1
Received: by mail-pl1-f200.google.com with SMTP id v7-20020a1709029a0700b0013daaeaa33eso3130900plp.5
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 06:08:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/jpsnbT1BId0lAcyPCs8B7qUvWWy9dYCkSOGGJRA7rk=;
        b=CgxG4CDNGZLg24rgPzrZy2GL4KAPk5wTVlsiKMrLpLz6reu9/FRuQk2km36SE6I7fj
         kugp5qWFLh3l0/4gdxBPoZRxRjCrrkehNU3dMGky7ybNYtiXGUe9TkKxMxtHKeaouGVm
         IZDZaMwOCFIpwObywdaVbpC+jOmIGwfSwVoqGiXTG43ydhLs+SQXf5DzDgoGGj42yxn1
         RowdzXi0aGgDtNHNkeui9u4iP380rnbVwzjJT5o3jcmiJuAnKUL/o2X2yoTt9vZJdnVy
         pGiGMWONkX07Y4f0FIRbpQzHjL0lCM9iFnq9Oyaf2a4jfvU3tCTJIupyW1YARS9TRyMp
         QbEg==
X-Gm-Message-State: AOAM533mGT8/steL3JoihqIk9kXlL7GR5kO9M8EgVVK0LBiUGQI+bdOy
        ms90yBoLdv6yLooXXV9+3M/O57zSFRicV1Qv6aA0PVZ9X2KSBMJbA2Atego60OXhBHId+HMrbZa
        JRFw5M3l0OAkIT3d7v3+asQ==
X-Received: by 2002:a63:e756:: with SMTP id j22mr27757352pgk.362.1632229685146;
        Tue, 21 Sep 2021 06:08:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx75Pe5cXDlgkZIL7uS8lqu9b4tKJazILO/UrXASOcVkZ6T7xp76TCzQnDfAsvOoHiI65YDVA==
X-Received: by 2002:a63:e756:: with SMTP id j22mr27757338pgk.362.1632229684938;
        Tue, 21 Sep 2021 06:08:04 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id w5sm18473890pgp.79.2021.09.21.06.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:08:04 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 2/4] ceph: track average/stdev r/w/m latency
Date:   Tue, 21 Sep 2021 18:37:48 +0530
Message-Id: <20210921130750.31820-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210921130750.31820-1-vshankar@redhat.com>
References: <20210921130750.31820-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Update the math involved to closely mimic how its done in
user land. This does not make a lot of difference to the
execution speed.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 63 +++++++++++++++++++++---------------------------
 fs/ceph/metric.h |  3 +++
 2 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 226dc38e2909..ca758bff69ca 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -245,6 +245,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
 
 	spin_lock_init(&m->read_metric_lock);
 	m->read_latency_sq_sum = 0;
+	m->avg_read_latency = 0;
 	m->read_latency_min = KTIME_MAX;
 	m->read_latency_max = 0;
 	m->total_reads = 0;
@@ -255,6 +256,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
 
 	spin_lock_init(&m->write_metric_lock);
 	m->write_latency_sq_sum = 0;
+	m->avg_write_latency = 0;
 	m->write_latency_min = KTIME_MAX;
 	m->write_latency_max = 0;
 	m->total_writes = 0;
@@ -265,6 +267,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
 
 	spin_lock_init(&m->metadata_metric_lock);
 	m->metadata_latency_sq_sum = 0;
+	m->avg_metadata_latency = 0;
 	m->metadata_latency_min = KTIME_MAX;
 	m->metadata_latency_max = 0;
 	m->total_metadatas = 0;
@@ -322,20 +325,25 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 		max = new;			\
 }
 
-static inline void __update_stdev(ktime_t total, ktime_t lsum,
-				  ktime_t *sq_sump, ktime_t lat)
+static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
+				    ktime_t *lavg, ktime_t *min, ktime_t *max,
+				    ktime_t *sum_sq, ktime_t lat)
 {
-	ktime_t avg, sq;
+	ktime_t total, avg;
 
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
+		*sum_sq = 0;
+	} else {
+		avg = *lavg + div64_s64(lat - *lavg, total);
+		*sum_sq += (lat - *lavg)*(lat - avg);
+		*lavg = avg;
+	}
 }
 
 void ceph_update_read_metrics(struct ceph_client_metric *m,
@@ -343,23 +351,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
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
+			 &m->read_latency_max, &m->read_latency_sq_sum, lat);
 	spin_unlock(&m->read_metric_lock);
 }
 
@@ -368,23 +371,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
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
+			 &m->write_latency_max, &m->write_latency_sq_sum, lat);
 	spin_unlock(&m->write_metric_lock);
 }
 
@@ -393,18 +391,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
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
+			 &m->metadata_latency_max, &m->metadata_latency_sq_sum, lat);
 	spin_unlock(&m->metadata_metric_lock);
 }
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 103ed736f9d2..0af02e212033 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -138,6 +138,7 @@ struct ceph_client_metric {
 	u64 read_size_min;
 	u64 read_size_max;
 	ktime_t read_latency_sum;
+	ktime_t avg_read_latency;
 	ktime_t read_latency_sq_sum;
 	ktime_t read_latency_min;
 	ktime_t read_latency_max;
@@ -148,6 +149,7 @@ struct ceph_client_metric {
 	u64 write_size_min;
 	u64 write_size_max;
 	ktime_t write_latency_sum;
+	ktime_t avg_write_latency;
 	ktime_t write_latency_sq_sum;
 	ktime_t write_latency_min;
 	ktime_t write_latency_max;
@@ -155,6 +157,7 @@ struct ceph_client_metric {
 	spinlock_t metadata_metric_lock;
 	u64 total_metadatas;
 	ktime_t metadata_latency_sum;
+	ktime_t avg_metadata_latency;
 	ktime_t metadata_latency_sq_sum;
 	ktime_t metadata_latency_min;
 	ktime_t metadata_latency_max;
-- 
2.31.1

