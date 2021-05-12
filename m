Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF1D37B952
	for <lists+ceph-devel@lfdr.de>; Wed, 12 May 2021 11:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhELJgE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 May 2021 05:36:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhELJgD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 May 2021 05:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620812095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GCNS/asYbl1d72+VjXp9JXtFxVjSDxURRrJfggUUA2w=;
        b=TNQ9koeHZnXY0zoxusi+tac9dPDmobQa0eiRj8kI2jZqwli6mPq6uJew16Tvb2rC/0HDYG
        F/4LXhJuVmM7czU9jaCN3nqqUHr8VDYhklffY6qYQxviPfdcQpGO3EOS4JmWKQ5VpwmSyJ
        t3kH4jkpWz4OCodskNTb39MQN1n85fc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234--FEPn-V1NauYXFMzGWIdNQ-1; Wed, 12 May 2021 05:34:54 -0400
X-MC-Unique: -FEPn-V1NauYXFMzGWIdNQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DE3D107ACE4;
        Wed, 12 May 2021 09:34:53 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A78C63746;
        Wed, 12 May 2021 09:34:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: simplify the metrics struct
Date:   Wed, 12 May 2021 17:34:43 +0800
Message-Id: <20210512093443.35128-3-xiubli@redhat.com>
In-Reply-To: <20210512093443.35128-1-xiubli@redhat.com>
References: <20210512093443.35128-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 80 ++++++++++++++++++++++++------------------------
 fs/ceph/metric.h | 73 +++++++++----------------------------------
 2 files changed, 55 insertions(+), 98 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index d6c76f1667ed..ba8d86ae9fcf 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -46,10 +46,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the cap metric */
 	cap = (struct ceph_metric_cap *)(head + 1);
-	cap->type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
-	cap->ver = 1;
-	cap->compat = 1;
-	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
+	cap->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
+	cap->header.ver = 1;
+	cap->header.compat = 1;
+	cap->header.data_len = cpu_to_le32(sizeof(*cap) - 10);
 	cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
 	cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
 	cap->total = cpu_to_le64(nr_caps);
@@ -57,10 +57,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the read latency metric */
 	read = (struct ceph_metric_read_latency *)(cap + 1);
-	read->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
-	read->ver = 1;
-	read->compat = 1;
-	read->data_len = cpu_to_le32(sizeof(*read) - 10);
+	read->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_LATENCY);
+	read->header.ver = 1;
+	read->header.compat = 1;
+	read->header.data_len = cpu_to_le32(sizeof(*read) - 10);
 	sum = m->read_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	read->sec = cpu_to_le32(ts.tv_sec);
@@ -69,10 +69,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the write latency metric */
 	write = (struct ceph_metric_write_latency *)(read + 1);
-	write->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
-	write->ver = 1;
-	write->compat = 1;
-	write->data_len = cpu_to_le32(sizeof(*write) - 10);
+	write->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_LATENCY);
+	write->header.ver = 1;
+	write->header.compat = 1;
+	write->header.data_len = cpu_to_le32(sizeof(*write) - 10);
 	sum = m->write_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	write->sec = cpu_to_le32(ts.tv_sec);
@@ -81,10 +81,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the metadata latency metric */
 	meta = (struct ceph_metric_metadata_latency *)(write + 1);
-	meta->type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
-	meta->ver = 1;
-	meta->compat = 1;
-	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
+	meta->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_METADATA_LATENCY);
+	meta->header.ver = 1;
+	meta->header.compat = 1;
+	meta->header.data_len = cpu_to_le32(sizeof(*meta) - 10);
 	sum = m->metadata_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	meta->sec = cpu_to_le32(ts.tv_sec);
@@ -93,10 +93,10 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the dentry lease metric */
 	dlease = (struct ceph_metric_dlease *)(meta + 1);
-	dlease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
-	dlease->ver = 1;
-	dlease->compat = 1;
-	dlease->data_len = cpu_to_le32(sizeof(*dlease) - 10);
+	dlease->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
+	dlease->header.ver = 1;
+	dlease->header.compat = 1;
+	dlease->header.data_len = cpu_to_le32(sizeof(*dlease) - 10);
 	dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
 	dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
 	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
@@ -106,50 +106,50 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	/* encode the opened files metric */
 	files = (struct ceph_opened_files *)(dlease + 1);
-	files->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
-	files->ver = 1;
-	files->compat = 1;
-	files->data_len = cpu_to_le32(sizeof(*files) - 10);
+	files->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
+	files->header.ver = 1;
+	files->header.compat = 1;
+	files->header.data_len = cpu_to_le32(sizeof(*files) - 10);
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
+	icaps->header.data_len = cpu_to_le32(sizeof(*icaps) - 10);
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
+	inodes->header.data_len = cpu_to_le32(sizeof(*inodes) - 10);
 	inodes->opened_inodes = cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
 	inodes->total = cpu_to_le64(sum);
 	items++;
 
 	/* encode the read io size metric */
 	rsize = (struct ceph_read_io_size *)(inodes + 1);
-	rsize->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
-	rsize->ver = 1;
-	rsize->compat = 1;
-	rsize->data_len = cpu_to_le32(sizeof(*rsize) - 10);
+	rsize->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
+	rsize->header.ver = 1;
+	rsize->header.compat = 1;
+	rsize->header.data_len = cpu_to_le32(sizeof(*rsize) - 10);
 	rsize->total_ops = cpu_to_le64(m->total_reads);
 	rsize->total_size = cpu_to_le64(m->read_size_sum);
 	items++;
 
 	/* encode the write io size metric */
 	wsize = (struct ceph_write_io_size *)(rsize + 1);
-	wsize->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
-	wsize->ver = 1;
-	wsize->compat = 1;
-	wsize->data_len = cpu_to_le32(sizeof(*wsize) - 10);
+	wsize->header.type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
+	wsize->header.ver = 1;
+	wsize->header.compat = 1;
+	wsize->header.data_len = cpu_to_le32(sizeof(*wsize) - 10);
 	wsize->total_ops = cpu_to_le64(m->total_writes);
 	wsize->total_size = cpu_to_le64(m->write_size_sum);
 	items++;
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 44b0f478b84b..0133955a3c6a 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -42,14 +42,16 @@ enum ceph_metric_type {
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
@@ -57,48 +59,28 @@ struct ceph_metric_cap {
 
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
@@ -106,60 +88,35 @@ struct ceph_metric_dlease {
 
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
 
 /* metric read io size header */
 struct ceph_read_io_size {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(opened_inodes + total) */
+	struct ceph_metric_header header;
 	__le64 total_ops;
 	__le64 total_size;
 } __packed;
 
 /* metric write io size header */
 struct ceph_write_io_size {
-	__le32 type;     /* ceph metric type */
-
-	__u8  ver;
-	__u8  compat;
-
-	__le32 data_len; /* length of sizeof(opened_inodes + total) */
+	struct ceph_metric_header header;
 	__le64 total_ops;
 	__le64 total_size;
 } __packed;
-- 
2.27.0

