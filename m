Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A833470A5
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Mar 2021 06:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhCXFIh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 01:08:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232648AbhCXFIg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 01:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616562515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=twTrhCuu8mfTAuUX/5X0w1DLyZLxIhGKzXLrQXKxBgk=;
        b=R+xwn/xmlXClMG/B6KDaoIjROtsnt5ptHryB6LssEpNxFazy7DilabRKkssPu73Hls938b
        f/d4V8x0YBeAswPth5bGA5cyg5rRRwk+x6IKTztVVnH+qsBuKKsGNhl7MULrwHCRfEKgab
        hgqejXViY/DJqfAPHUUbe0uvGuB6+sI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-CG38aBd0MEaUwHi2t7Hykw-1; Wed, 24 Mar 2021 01:08:31 -0400
X-MC-Unique: CG38aBd0MEaUwHi2t7Hykw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8577D180FCA0;
        Wed, 24 Mar 2021 05:08:30 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 828371992D;
        Wed, 24 Mar 2021 05:08:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: send opened files/pinned caps/opened inodes metrics to MDS daemon
Date:   Wed, 24 Mar 2021 13:08:25 +0800
Message-Id: <20210324050825.1650763-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the old ceph version, if it received this metric info, it will just
ignore them.

URL: https://tracker.ceph.com/issues/46866
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- fix the crash issue.


 fs/ceph/metric.c | 38 +++++++++++++++++++++++++++++++++++++-
 fs/ceph/metric.h | 44 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 5ec94bd4c1de..895eab25d314 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -17,6 +17,9 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	struct ceph_metric_write_latency *write;
 	struct ceph_metric_metadata_latency *meta;
 	struct ceph_metric_dlease *dlease;
+	struct ceph_opened_files *files;
+	struct ceph_pinned_icaps *icaps;
+	struct ceph_opened_inodes *inodes;
 	struct ceph_client_metric *m = &mdsc->metric;
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	struct ceph_msg *msg;
@@ -26,7 +29,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	s32 len;
 
 	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
-	      + sizeof(*meta) + sizeof(*dlease);
+	      + sizeof(*meta) + sizeof(*dlease) + sizeof(*files)
+	      + sizeof(*icaps) + sizeof(*inodes);
 
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
 	if (!msg) {
@@ -95,6 +99,38 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
 	items++;
 
+	sum = percpu_counter_sum(&m->total_inodes);
+
+	/* encode the opened files metric */
+	files = (struct ceph_opened_files *)(dlease + 1);
+	files->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_FILES);
+	files->ver = 1;
+	files->compat = 1;
+	files->data_len = cpu_to_le32(sizeof(*files) - 10);
+	files->opened_files = cpu_to_le64(atomic64_read(&m->opened_files));
+	files->total = cpu_to_le64(sum);
+	items++;
+
+	/* encode the pinned icaps metric */
+	icaps = (struct ceph_pinned_icaps *)(files + 1);
+	icaps->type = cpu_to_le32(CLIENT_METRIC_TYPE_PINNED_ICAPS);
+	icaps->ver = 1;
+	icaps->compat = 1;
+	icaps->data_len = cpu_to_le32(sizeof(*icaps) - 10);
+	icaps->pinned_icaps = cpu_to_le64(nr_caps);
+	icaps->total = cpu_to_le64(sum);
+	items++;
+
+	/* encode the opened inodes metric */
+	inodes = (struct ceph_opened_inodes *)(icaps + 1);
+	inodes->type = cpu_to_le32(CLIENT_METRIC_TYPE_OPENED_INODES);
+	inodes->ver = 1;
+	inodes->compat = 1;
+	inodes->data_len = cpu_to_le32(sizeof(*inodes) - 10);
+	inodes->opened_inodes = cpu_to_le64(percpu_counter_sum(&m->opened_inodes));
+	inodes->total = cpu_to_le64(sum);
+	items++;
+
 	put_unaligned_le32(items, &head->num);
 	msg->front.iov_len = len;
 	msg->hdr.version = cpu_to_le16(1);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index af6038ff39d4..4ceb462135d7 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -14,8 +14,11 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_WRITE_LATENCY,
 	CLIENT_METRIC_TYPE_METADATA_LATENCY,
 	CLIENT_METRIC_TYPE_DENTRY_LEASE,
+	CLIENT_METRIC_TYPE_OPENED_FILES,
+	CLIENT_METRIC_TYPE_PINNED_ICAPS,
+	CLIENT_METRIC_TYPE_OPENED_INODES,
 
-	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
+	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_OPENED_INODES,
 };
 
 /*
@@ -28,6 +31,9 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
 	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
 	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
+	CLIENT_METRIC_TYPE_OPENED_FILES,	\
+	CLIENT_METRIC_TYPE_PINNED_ICAPS,	\
+	CLIENT_METRIC_TYPE_OPENED_INODES,	\
 						\
 	CLIENT_METRIC_TYPE_MAX,			\
 }
@@ -94,6 +100,42 @@ struct ceph_metric_dlease {
 	__le64 total;
 } __packed;
 
+/* metric opened files header */
+struct ceph_opened_files {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(opened_files + total) */
+	__le64 opened_files;
+	__le64 total;
+} __packed;
+
+/* metric pinned i_caps header */
+struct ceph_pinned_icaps {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(pinned_icaps + total) */
+	__le64 pinned_icaps;
+	__le64 total;
+} __packed;
+
+/* metric opened inodes header */
+struct ceph_opened_inodes {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(opened_inodes + total) */
+	__le64 opened_inodes;
+	__le64 total;
+} __packed;
+
 struct ceph_metric_head {
 	__le32 num;	/* the number of metrics that will be sent */
 } __packed;
-- 
2.27.0

