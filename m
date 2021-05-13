Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116E337F0FA
	for <lists+ceph-devel@lfdr.de>; Thu, 13 May 2021 03:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhEMBmZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 May 2021 21:42:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230034AbhEMBmX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 May 2021 21:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620870074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQvVSRe7o1WfbOraRmD3On6J3tCjUZavOvrcN5KOf+0=;
        b=CdHZjUiZgaQ6HrIi2jtWljZJR8CFUt3RVysoEt64dgvqyFwDzLVs/5tPIBzAI8OVZyFG8F
        NsdnACfThwmX+SGaOBcnJzOHpGzfLrrbDH78fAcuwmPoiqSd3qHUN1BQZp1viwvbE5X/mu
        Q04bLOVpAeEw3edz5Co4tKAlggJ3DAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-L4QUPUTfOaeLFi2mUF9p2Q-1; Wed, 12 May 2021 21:41:11 -0400
X-MC-Unique: L4QUPUTfOaeLFi2mUF9p2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA58E800D55;
        Thu, 13 May 2021 01:41:10 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A14A19D9F;
        Thu, 13 May 2021 01:41:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/2] ceph: simplify the metrics struct
Date:   Thu, 13 May 2021 09:40:52 +0800
Message-Id: <20210513014053.81346-2-xiubli@redhat.com>
In-Reply-To: <20210513014053.81346-1-xiubli@redhat.com>
References: <20210513014053.81346-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 65 ++++++++++++++++++++++++------------------------
 fs/ceph/metric.h | 59 ++++++++++---------------------------------
 2 files changed, 46 insertions(+), 78 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index fbeb8f2fe5ad..57f28995c665 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -22,6 +22,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	struct ceph_opened_inodes *inodes;
 	struct ceph_client_metric *m = &mdsc->metric;
 	u64 nr_caps = atomic64_read(&m->total_caps);
+	u32 header_len = sizeof(struct ceph_metric_header);
 	struct ceph_msg *msg;
 	struct timespec64 ts;
 	s64 sum;
@@ -43,10 +44,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the cap metric */
 	cap = (struct ceph_metric_cap *)(head + 1);
-	cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
-	cap->ver = 1;
-	cap->compat = 1;
-	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
+	cap->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
+	cap->header.ver = 1;
+	cap->header.compat = 1;
+	cap->header.data_len = cpu_to_le32(sizeof(*cap) - header_len);
 	cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
 	cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
 	cap->total = cpu_to_le64(nr_caps);
@@ -54,10 +55,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the read latency metric */
 	read = (struct ceph_metric_read_latency *)(cap + 1);
-	read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
-	read->ver = 1;
-	read->compat = 1;
-	read->data_len = cpu_to_le32(sizeof(*read) - 10);
+	read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
+	read->header.ver = 1;
+	read->header.compat = 1;
+	read->header.data_len = cpu_to_le32(sizeof(*read) - header_len);
 	sum = m->read_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	read->sec = cpu_to_le32(ts.tv_sec);
@@ -66,10 +67,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the write latency metric */
 	write = (struct ceph_metric_write_latency *)(read + 1);
-	write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
-	write->ver = 1;
-	write->compat = 1;
-	write->data_len = cpu_to_le32(sizeof(*write) - 10);
+	write->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
+	write->header.ver = 1;
+	write->header.compat = 1;
+	write->header.data_len = cpu_to_le32(sizeof(*write) - header_len);
 	sum = m->write_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	write->sec = cpu_to_le32(ts.tv_sec);
@@ -78,10 +79,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the metadata latency metric */
 	meta = (struct ceph_metric_metadata_latency *)(write + 1);
-	meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
-	meta->ver = 1;
-	meta->compat = 1;
-	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
+	meta->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
+	meta->header.ver = 1;
+	meta->header.compat = 1;
+	meta->header.data_len = cpu_to_le32(sizeof(*meta) - header_len);
 	sum = m->metadata_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	meta->sec = cpu_to_le32(ts.tv_sec);
@@ -90,10 +91,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the dentry lease metric */
 	dlease = (struct ceph_metric_dlease *)(meta + 1);
-	dlease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
-	dlease->ver = 1;
-	dlease->compat = 1;
-	dlease->data_len = cpu_to_le32(sizeof(*dlease) - 10);
+	dlease->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
+	dlease->header.ver = 1;
+	dlease->header.compat = 1;
+	dlease->header.data_len = cpu_to_le32(sizeof(*dlease) - header_len);
 	dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
 	dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
 	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
@@ -103,30 +104,30 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the opened files metric */
 	files = (struct ceph_opened_files *)(dlease + 1);
-	files->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
-	files->ver = 1;
-	files->compat = 1;
-	files->data_len = cpu_to_le32(sizeof(*files) - 10);
+	files->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
+	files->header.ver = 1;
+	files->header.compat = 1;
+	files->header.data_len = cpu_to_le32(sizeof(*files) - header_len);
 	files->opened_files = cpu_to_le64(atomic64_read(&m->opened_files));
 	files->total = cpu_to_le64(sum);
 	items++;
 
 	/* encode the pinned icaps metric */
 	icaps = (struct ceph_pinned_icaps *)(files + 1);
-	icaps->type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
-	icaps->ver = 1;
-	icaps->compat = 1;
-	icaps->data_len = cpu_to_le32(sizeof(*icaps) - 10);
+	icaps->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
+	icaps->header.ver = 1;
+	icaps->header.compat = 1;
+	icaps->header.data_len = cpu_to_le32(sizeof(*icaps) - header_len);
 	icaps->pinned_icaps = cpu_to_le64(nr_caps);
 	icaps->total = cpu_to_le64(sum);
 	items++;
 
 	/* encode the opened inodes metric */
 	inodes = (struct ceph_opened_inodes *)(icaps + 1);
-	inodes->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
-	inodes->ver = 1;
-	inodes->compat = 1;
-	inodes->data_len = cpu_to_le32(sizeof(*inodes) - 10);
+	inodes->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
+	inodes->header.ver = 1;
+	inodes->header.compat = 1;
+	inodes->header.data_len = cpu_to_le32(sizeof(*inodes) - header_len);
 	inodes->opened_inodes = cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
 	inodes->total = cpu_to_le64(sum);
 	items++;
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 4bd92689bf12..89ce32f1dc50 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -38,14 +38,16 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_MAX,			\
 }
 
-/* metric caps header */
-struct ceph_metric_cap {
+struct ceph_metric_header {
 	__le32 type;     /* ceph metric type */
-
 	__u8  ver;
 	__u8  compat;
-
 	__le32 data_len; /* length of sizeof(hit + mis + total) */
+} __packed;
+
+/* metric caps header */
+struct ceph_metric_cap {
+	struct ceph_metric_header header;
 	__le64 hit;
 	__le64 mis;
 	__le64 total;
@@ -53,48 +55,28 @@ struct ceph_metric_cap {
 
 /* metric read latency header */
 struct ceph_metric_read_latency {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(sec + nsec) */
+	struct ceph_metric_header header;
 	__le32 sec;
 	__le32 nsec;
 } __packed;
 
 /* metric write latency header */
 struct ceph_metric_write_latency {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(sec + nsec) */
+	struct ceph_metric_header header;
 	__le32 sec;
 	__le32 nsec;
 } __packed;
 
 /* metric metadata latency header */
 struct ceph_metric_metadata_latency {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(sec + nsec) */
+	struct ceph_metric_header header;
 	__le32 sec;
 	__le32 nsec;
 } __packed;
 
 /* metric dentry lease header */
 struct ceph_metric_dlease {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(hit + mis + total) */
+	struct ceph_metric_header header;
 	__le64 hit;
 	__le64 mis;
 	__le64 total;
@@ -102,36 +84,21 @@ struct ceph_metric_dlease {
 
 /* metric opened files header */
 struct ceph_opened_files {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(opened_files + total) */
+	struct ceph_metric_header header;
 	__le64 opened_files;
 	__le64 total;
 } __packed;
 
 /* metric pinned i_caps header */
 struct ceph_pinned_icaps {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(pinned_icaps + total) */
+	struct ceph_metric_header header;
 	__le64 pinned_icaps;
 	__le64 total;
 } __packed;
 
 /* metric opened inodes header */
 struct ceph_opened_inodes {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(opened_inodes + total) */
+	struct ceph_metric_header header;
 	__le64 opened_inodes;
 	__le64 total;
 } __packed;
-- 
2.27.0

