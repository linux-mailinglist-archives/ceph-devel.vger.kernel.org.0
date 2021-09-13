Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03603408C33
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 15:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbhIMNO5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 09:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240575AbhIMNOt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 09:14:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631538813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQQxvFd6889UTgxl8qWsgkpLFA8tU2Z7/AK1LVBrCSE=;
        b=GyfdMlnFU1CSttSiopqnsDoUEiJxkIHQsbR888w/otnhW20XXSuDyFrNw0L5FMGxXrEunh
        eqOz4/GGJaAmAdYF096eoj5GONq3B5RXvEpP353nOjc19CIJr33R8xPwLETR5HEtfJpeab
        CxQCcftPbxf6F9KOAibqEvMkXDVL6Oc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-3RE7VB-QMdGub888qeXPBA-1; Mon, 13 Sep 2021 09:13:33 -0400
X-MC-Unique: 3RE7VB-QMdGub888qeXPBA-1
Received: by mail-pg1-f198.google.com with SMTP id b5-20020a6541c5000000b002661347cfbcso7383949pgq.1
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EQQxvFd6889UTgxl8qWsgkpLFA8tU2Z7/AK1LVBrCSE=;
        b=k5WWUYNTM9A+ONrM+K0KL6O9Gh4y+36X5WiTdQvK6NmfSMVXYpNqFgZeMLo9TgmtXP
         OBv19giNwky35K2AS0oZyEWDXLmXYU+S4bLYP292+2NbncjxCzh1sJUhSQa6NO1VK8ST
         1KepZR+6zaGkRykZlw/cy4jsHhkREy0xvrXDO3Yt8FAE2nc3AwSHHY2bWLkBvasOpjO9
         WycYtXiHFMT+RHQn2HbL2S8VfgyEAN6VTRHEW/RxTRSD5rwOpc+w0h3O1cCnDPzxE4Xz
         wr4OeNRNtGiDPhPXH2V/QmEL1yQRoiuD9KHvhJFfbmq7EjyAFdJ0AJ2c48m71wMp+8iy
         dx1A==
X-Gm-Message-State: AOAM5331Ix3gIB8qRbWPzCqV49Fg0S7yNmy+hW44iZADS1MB8t4OPlbk
        t23OUrDsvp75C+82nlqn8hLUcUPWPJXcXGTx9oy3DbGhyLSD36igvvzL3I06mDz376GtFSsDV1B
        Fu/E83W0AzDFllQQXr9j9sA==
X-Received: by 2002:a62:1683:0:b0:3f3:814f:4367 with SMTP id 125-20020a621683000000b003f3814f4367mr11120030pfw.68.1631538811628;
        Mon, 13 Sep 2021 06:13:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL3TyulkpqpqoTi8f6pFGDl+0KEyjvp0zid+YdzhzQ21fkhT/RRpEAIcpHzgbr5THpV0YB0g==
X-Received: by 2002:a62:1683:0:b0:3f3:814f:4367 with SMTP id 125-20020a621683000000b003f3814f4367mr11120006pfw.68.1631538811345;
        Mon, 13 Sep 2021 06:13:31 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id i10sm7362010pfk.151.2021.09.13.06.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:13:30 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v1 3/4] ceph: include average/stddev r/w/m latency in mds metrics
Date:   Mon, 13 Sep 2021 18:43:10 +0530
Message-Id: <20210913131311.1347903-4-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913131311.1347903-1-vshankar@redhat.com>
References: <20210913131311.1347903-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The use of `jiffies_to_timespec64()` seems incorrect too, switch
that to `ktime_to_timespec64()`.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/metric.c | 36 +++++++++++++++++++-----------------
 fs/ceph/metric.h | 44 +++++++++++++++++++++++++++++++-------------
 2 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index e00b1c2ce25b..cb332ae2411f 100644
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
@@ -20,8 +27,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	struct ceph_client_metric *m = &mdsc->metric;
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	struct ceph_msg *msg;
-	struct timespec64 ts;
-	s64 sum;
 	s32 items = 0;
 	s32 len;
 
@@ -51,37 +56,34 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	/* encode the read latency metric */
 	read = (struct ceph_metric_read_latency *)(cap + 1);
 	read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
-	read->ver = 1;
+	read->ver = 2;
 	read->compat = 1;
 	read->data_len = cpu_to_le32(sizeof(*read) - 10);
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
 	write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
-	write->ver = 1;
+	write->ver = 2;
 	write->compat = 1;
 	write->data_len = cpu_to_le32(sizeof(*write) - 10);
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
 	meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
-	meta->ver = 1;
+	meta->ver = 2;
 	meta->compat = 1;
 	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
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
index 136689fa0aec..b68927378e59 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -14,22 +14,34 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_WRITE_LATENCY,
 	CLIENT_METRIC_TYPE_METADATA_LATENCY,
 	CLIENT_METRIC_TYPE_DENTRY_LEASE,
-
-	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
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
-						\
-	CLIENT_METRIC_TYPE_MAX,			\
+#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	   \
+	CLIENT_METRIC_TYPE_CAP_INFO,		   \
+	CLIENT_METRIC_TYPE_READ_LATENCY,	   \
+	CLIENT_METRIC_TYPE_WRITE_LATENCY,	   \
+	CLIENT_METRIC_TYPE_METADATA_LATENCY,	   \
+	CLIENT_METRIC_TYPE_DENTRY_LEASE,	   \
+	CLIENT_METRIC_TYPE_AVG_READ_LATENCY,	   \
+	CLIENT_METRIC_TYPE_STDEV_READ_LATENCY,	   \
+	CLIENT_METRIC_TYPE_AVG_WRITE_LATENCY,	   \
+	CLIENT_METRIC_TYPE_STDEV_WRITE_LATENCY,	   \
+	CLIENT_METRIC_TYPE_AVG_METADATA_LATENCY,   \
+	CLIENT_METRIC_TYPE_STDEV_METADATA_LATENCY, \
+						   \
+	CLIENT_METRIC_TYPE_MAX,			   \
 }
 
 /* metric caps header */
@@ -52,8 +64,10 @@ struct ceph_metric_read_latency {
 	__u8  ver;
 	__u8  compat;
 
-	__le32 data_len; /* length of sizeof(lat) */
+	__le32 data_len; /* length of sizeof(lat+avg+stdev) */
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	struct ceph_timespec stdev;
 } __packed;
 
 /* metric write latency header */
@@ -63,8 +77,10 @@ struct ceph_metric_write_latency {
 	__u8  ver;
 	__u8  compat;
 
-	__le32 data_len; /* length of sizeof(lat) */
+	__le32 data_len; /* length of sizeof(lat_avg_stdev) */
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	struct ceph_timespec stdev;
 } __packed;
 
 /* metric metadata latency header */
@@ -74,8 +90,10 @@ struct ceph_metric_metadata_latency {
 	__u8  ver;
 	__u8  compat;
 
-	__le32 data_len; /* length of sizeof(lat) */
+	__le32 data_len; /* length of sizeof(lat+avg+stdev) */
 	struct ceph_timespec lat;
+	struct ceph_timespec avg;
+	struct ceph_timespec stdev;
 } __packed;
 
 /* metric dentry lease header */
-- 
2.27.0

