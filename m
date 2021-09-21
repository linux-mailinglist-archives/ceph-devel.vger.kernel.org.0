Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD87E4133C3
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Sep 2021 15:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhIUNJm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Sep 2021 09:09:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232828AbhIUNJl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 09:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632229692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1v01UpNH72I4V1y6xq9G6q0UPA384QwI1P98DnTJo0=;
        b=J4QNCanWj850vb6A6flA6tZFJ5TXImTnE+wUA+Sw5YCN2C2STzIaLWJMm7ndzuXeuTwb29
        ABZbdX0m8UQf6WcFiM8dTJ+G9vFBOl2VprQ1H7jXLkhncccj2PlOCfSOG9JAcc3zSVL7LY
        hKC06taqAegm13+ZUQrX/9+yIsUuxU4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-pI4PIY8qMWWqx33UE1XItQ-1; Tue, 21 Sep 2021 09:08:10 -0400
X-MC-Unique: pI4PIY8qMWWqx33UE1XItQ-1
Received: by mail-pf1-f200.google.com with SMTP id k206-20020a6284d7000000b004380af887afso15984996pfd.17
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 06:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J1v01UpNH72I4V1y6xq9G6q0UPA384QwI1P98DnTJo0=;
        b=1AodYcWWG6EMsJdGpEX3FnWzsLipE5sBn4Ndt3NzqmMZTS7CV8u5a4t+T8G8P3N2I4
         3CW/ISKsS+ReXQZdMLGsYait8FRbezuPsfFVufH9rtuEeYdHFaCF/lrZ3sscqs4sKrRO
         3/3QAPHwaOikOlJaGgKyP8cSaTGQlhZucvyiXmgwm68FvP0HeNmDJ/jlkMnO0Bd8O3l5
         ylYL5857o8whK1w8eU9kD/1BIuD3l7fcU+C/gfIfTJI5WR43/n8SrUPNtsw0ficzxDBZ
         DJFDrnCNWa3REtWqXYNHqCkyMrLIq9wklGX0cee/TyBgthlRIQl9bki8KOMFrp9jqPHc
         fxcA==
X-Gm-Message-State: AOAM532q12H2O26MyXJLcFrw+R9iq+DxnmTbNfXuIZMPriP4WclCId9F
        PNsJCF1WwqOozXJ3qQ+EU01UciehmZehRguFVHBXCzgcMWHJs9ToGu8go1dIrEbnYS/WY2Iq2c+
        ozS+Antc5gcbSuTllAxlEhw==
X-Received: by 2002:a17:90b:3805:: with SMTP id mq5mr5149593pjb.143.1632229688683;
        Tue, 21 Sep 2021 06:08:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweL4w1GloJlWB2jlyWsFjDbMMR/xDPohQZXYxmEIcFWGpU7k2QbpHpYDOk/EVdg3slVHoNxA==
X-Received: by 2002:a17:90b:3805:: with SMTP id mq5mr5149575pjb.143.1632229688460;
        Tue, 21 Sep 2021 06:08:08 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id w5sm18473890pgp.79.2021.09.21.06.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:08:07 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 3/4] ceph: include average/stddev r/w/m latency in mds metrics
Date:   Tue, 21 Sep 2021 18:37:49 +0530
Message-Id: <20210921130750.31820-4-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210921130750.31820-1-vshankar@redhat.com>
References: <20210921130750.31820-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The use of `jiffies_to_timespec64()` seems incorrect too, switch
that to `ktime_to_timespec64()`.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 46 ++++++++++++++++++++++++++++++----------------
 fs/ceph/metric.h | 48 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index ca758bff69ca..04ba98286382 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -8,6 +8,20 @@
 #include "metric.h"
 #include "mds_client.h"
 
+static void to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
+{
+	struct timespec64 t = ktime_to_timespec64(val);
+	ts->tv_sec = cpu_to_le32(t.tv_sec);
+	ts->tv_nsec = cpu_to_le32(t.tv_nsec);
+}
+
+static ktime_t calc_stdev(ktime_t sq_sum, u64 total)
+{
+	if (total > 1)
+		return int_sqrt64(DIV64_U64_ROUND_CLOSEST(sq_sum, total - 1));
+	return 0;
+}
+
 static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 				   struct ceph_mds_session *s)
 {
@@ -26,10 +40,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	u32 header_len = sizeof(struct ceph_metric_header);
 	struct ceph_msg *msg;
-	struct timespec64 ts;
 	s64 sum;
 	s32 items = 0;
 	s32 len;
+        ktime_t stdev;
 
 	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
 	      + sizeof(*meta) + sizeof(*dlease) + sizeof(*files)
@@ -59,37 +73,37 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	/* encode the read latency metric */
 	read = (struct ceph_metric_read_latency *)(cap + 1);
 	read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
-	read->header.ver = 1;
+	read->header.ver = 2;
 	read->header.compat = 1;
 	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
-	sum = m->read_latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	read->lat.tv_sec = cpu_to_le32(ts.tv_sec);
-	read->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
+	to_ceph_timespec(&read->lat, m->read_latency_sum);
+	to_ceph_timespec(&read->avg, m->avg_read_latency);
+	stdev = calc_stdev(m->read_latency_sq_sum, m->total_reads);
+	to_ceph_timespec(&read->stdev, stdev);
 	items++;
 
 	/* encode the write latency metric */
 	write = (struct ceph_metric_write_latency *)(read + 1);
 	write->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
-	write->header.ver = 1;
+	write->header.ver = 2;
 	write->header.compat = 1;
 	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
-	sum = m->write_latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	write->lat.tv_sec = cpu_to_le32(ts.tv_sec);
-	write->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
+	to_ceph_timespec(&write->lat, m->write_latency_sum);
+	to_ceph_timespec(&write->avg, m->avg_write_latency);
+	stdev = calc_stdev(m->write_latency_sq_sum, m->total_writes);
+	to_ceph_timespec(&write->stdev, stdev);
 	items++;
 
 	/* encode the metadata latency metric */
 	meta = (struct ceph_metric_metadata_latency *)(write + 1);
 	meta->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
-	meta->header.ver = 1;
+	meta->header.ver = 2;
 	meta->header.compat = 1;
 	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
-	sum = m->metadata_latency_sum;
-	jiffies_to_timespec64(sum, &ts);
-	meta->lat.tv_sec = cpu_to_le32(ts.tv_sec);
-	meta->lat.tv_nsec = cpu_to_le32(ts.tv_nsec);
+	to_ceph_timespec(&meta->lat, m->metadata_latency_sum);
+	to_ceph_timespec(&meta->avg, m->avg_metadata_latency);
+	stdev = calc_stdev(m->metadata_latency_sq_sum, m->total_metadatas);
+	to_ceph_timespec(&meta->stdev, stdev);
 	items++;
 
 	/* encode the dentry lease metric */
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 0af02e212033..028c5fbc6299 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -19,27 +19,39 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_OPENED_INODES,
 	CLIENT_METRIC_TYPE_READ_IO_SIZES,
 	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,
-
-	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_WRITE_IO_SIZES,
+	CLIENT_METRIC_TYPE_AVG_READ_LATENCY,
+	CLIENT_METRIC_TYPE_STDEV_READ_LATENCY,
+	CLIENT_METRIC_TYPE_AVG_WRITE_LATENCY,
+	CLIENT_METRIC_TYPE_STDEV_WRITE_LATENCY,
+	CLIENT_METRIC_TYPE_AVG_METADATA_LATENCY,
+	CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY,
+
+	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY,
 };
 
 /*
  * This will always have the highest metric bit value
  * as the last element of the array.
  */
-#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	\
-	CLIENT_METRIC_TYPE_CAP_INFO,		\
-	CLIENT_METRIC_TYPE_READ_LATENCY,	\
-	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
-	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
-	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
-	CLIENT_METRIC_TYPE_OPENED_FILES,	\
-	CLIENT_METRIC_TYPE_PINNED_ICAPS,	\
-	CLIENT_METRIC_TYPE_OPENED_INODES,	\
-	CLIENT_METRIC_TYPE_READ_IO_SIZES,	\
-	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,	\
-						\
-	CLIENT_METRIC_TYPE_MAX,			\
+#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	    \
+	CLIENT_METRIC_TYPE_CAP_INFO,		    \
+	CLIENT_METRIC_TYPE_READ_LATENCY,	    \
+	CLIENT_METRIC_TYPE_WRITE_LATENCY,	    \
+	CLIENT_METRIC_TYPE_METADATA_LATENCY,	    \
+	CLIENT_METRIC_TYPE_DENTRY_LEASE,	    \
+	CLIENT_METRIC_TYPE_OPENED_FILES,	    \
+	CLIENT_METRIC_TYPE_PINNED_ICAPS,	    \
+	CLIENT_METRIC_TYPE_OPENED_INODES,	    \
+	CLIENT_METRIC_TYPE_READ_IO_SIZES,	    \
+	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,	    \
+	CLIENT_METRIC_TYPE_AVG_READ_LATENCY,	    \
+	CLIENT_METRIC_TYPE_STDEV_READ_LATENCY,	    \
+	CLIENT_METRIC_TYPE_AVG_WRITE_LATENCY,	    \
+	CLIENT_METRIC_TYPE_STDEV_WRITE_LATENCY,	    \
+	CLIENT_METRIC_TYPE_AVG_METADATA_LATENCY,    \
+	CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY,  \
+						    \
+	CLIENT_METRIC_TYPE_MAX,			    \
 }
 
 struct ceph_metric_header {
@@ -61,18 +73,24 @@ struct ceph_metric_cap {
 struct ceph_metric_read_latency {
 	struct ceph_metric_header header;
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	struct ceph_timespec stdev;
 } __packed;
 
 /* metric write latency header */
 struct ceph_metric_write_latency {
 	struct ceph_metric_header header;
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	struct ceph_timespec stdev;
 } __packed;
 
 /* metric metadata latency header */
 struct ceph_metric_metadata_latency {
 	struct ceph_metric_header header;
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	struct ceph_timespec stdev;
 } __packed;
 
 /* metric dentry lease header */
-- 
2.31.1

