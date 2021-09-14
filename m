Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6589840A998
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 10:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhINIui (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 04:50:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230392AbhINIuh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 04:50:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631609360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O7l0DlyvqaJcVRbFQZfQ0Y20r5URg+k3c+gYrzZdUN4=;
        b=MmEM2UtB67JacIfAIXkzIn26MigdlRJhB2W68VNMieRxyfwahSNK384mICccB9Ub2ra6VT
        TGFCbEp3PlbOnP1Ngvmsig+O7wgTOWiJxpyqDQH5zVVi6npHZfzqNXj+w3uOLEBgwzOHZf
        n0BSfoYaX9O6euJdDWO4Zg4unvoe2N0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-H7OMo8L2PRCQJgaoIUsmiQ-1; Tue, 14 Sep 2021 04:49:19 -0400
X-MC-Unique: H7OMo8L2PRCQJgaoIUsmiQ-1
Received: by mail-pj1-f70.google.com with SMTP id g21-20020a17090adb1500b001976416d36bso1310976pjv.0
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 01:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O7l0DlyvqaJcVRbFQZfQ0Y20r5URg+k3c+gYrzZdUN4=;
        b=I1r0xkZ/g9ZlrNWAehlF1APOUKG0K3MVpcnTRUdOc9UYAkU0EKcn5Y9nrsoHyyYgrB
         T4YccRn1QQhbL7NEJPzNXj6TXN0l3EMYNUOcKgq2CLGUGfj6XlS9NhUOr440brpKfstV
         5zCiY3YNWwc6E1zEHp3CEf1NSItSQOZoKbTn5FO5Vf47N2eDf/Y5H1QYZDzwYeMF2nIP
         Xtu3pMYDdgO6rIcweRS8v+8DSOE97Oq9O7tXKYy4GITkHV5gBUhUovkpnHjJm/WWRixl
         Ll3HVK3LF/et0QouNDPkVN1yiQ5d+TI2RsyY8nlX7RDBKPuD3QPyxLbRngfZsw4FBB0y
         Tafw==
X-Gm-Message-State: AOAM533JDC0OcNBA2GE/SEPRc4ipBM5M0pDWDjYszfDAAiAxEO9N/gr1
        qrFhBQy2lsGe7h66jKgo1W+FxX+wJEgriGbCEo8Krn3Pn9kqcLweXgA2wLxdWsoxqW8EQtTbSPg
        H/YtXFFy968YF90BR2gDBqw==
X-Received: by 2002:a63:1e5c:: with SMTP id p28mr14613646pgm.89.1631609358270;
        Tue, 14 Sep 2021 01:49:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpDNRZJVLWLJcd/INFQCbrMpsLop4C53Rtqh1L7lTxH/ekZygTmN8rQRX2yJ/ybyhO/Z6Bog==
X-Received: by 2002:a63:1e5c:: with SMTP id p28mr14613629pgm.89.1631609357995;
        Tue, 14 Sep 2021 01:49:17 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id b12sm10006219pff.63.2021.09.14.01.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 01:49:17 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 3/4] ceph: include average/stddev r/w/m latency in mds metrics
Date:   Tue, 14 Sep 2021 14:19:01 +0530
Message-Id: <20210914084902.1618064-4-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914084902.1618064-1-vshankar@redhat.com>
References: <20210914084902.1618064-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The use of `jiffies_to_timespec64()` seems incorrect too, switch
that to `ktime_to_timespec64()`.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 35 +++++++++++++++++++----------------
 fs/ceph/metric.h | 48 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 6b774b1a88ce..78a50bb7bd0f 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -8,6 +8,13 @@
 #include "metric.h"
 #include "mds_client.h"
 
+static void to_ceph_timespec(struct ceph_timespec *ts, ktime_t val)
+{
+	struct timespec64 t = ktime_to_timespec64(val);
+	ts->tv_sec = cpu_to_le32(t.tv_sec);
+	ts->tv_nsec = cpu_to_le32(t.tv_nsec);
+}
+
 static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 				   struct ceph_mds_session *s)
 {
@@ -26,7 +33,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	u32 header_len = sizeof(struct ceph_metric_header);
 	struct ceph_msg *msg;
-	struct timespec64 ts;
 	s64 sum;
 	s32 items = 0;
 	s32 len;
@@ -59,37 +65,34 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
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
+	to_ceph_timespec(&read->stdev, m->read_latency_stdev);
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
+	to_ceph_timespec(&write->stdev, m->write_latency_stdev);
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
+	to_ceph_timespec(&meta->stdev, m->metadata_latency_stdev);
 	items++;
 
 	/* encode the dentry lease metric */
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index a5da21b8f8ed..2dd506dedebf 100644
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

