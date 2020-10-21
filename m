Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEAD29477C
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Oct 2020 06:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440251AbgJUEum (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Oct 2020 00:50:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440248AbgJUEul (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Oct 2020 00:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603255839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=FJPDeMYPXTTFTriL0M1dOnxYKgacmKn87z/5eYombyU=;
        b=E9wOy9lXorj8jylImzbf8EmftxkcLAxDCxpWGfrvStSwLiSNOqNagEIPTgaAt5N+UMgLro
        ofGUi5VyxmD2cnLB2lsR7MqOL0Mr5MqXAozA009INRnJkEA25ElZAzcYvmsAB5NgsCOpP4
        STYCEV+d+6Z/Qt+wW9YLtSugXfhW+Qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-m_SN_6qnNJmsaRq84x82lA-1; Wed, 21 Oct 2020 00:50:35 -0400
X-MC-Unique: m_SN_6qnNJmsaRq84x82lA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69FDC8049DF;
        Wed, 21 Oct 2020 04:50:34 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-120.gsslab.pek2.redhat.com [10.72.37.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 099A75C1BB;
        Wed, 21 Oct 2020 04:50:31 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: send dentry lease metrics to MDS daemon
Date:   Wed, 21 Oct 2020 00:50:24 -0400
Message-Id: <20201021045024.44437-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the old ceph version, if it received this one metric message
containing the dentry lease metric info, it will just ignore it.

URL: https://tracker.ceph.com/issues/43423
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 18 +++++++++++++++---
 fs/ceph/metric.h | 14 ++++++++++++++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index fee4c4778313..06729cbfabee 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -16,6 +16,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	struct ceph_metric_read_latency *read;
 	struct ceph_metric_write_latency *write;
 	struct ceph_metric_metadata_latency *meta;
+	struct ceph_metric_dlease *dlease;
 	struct ceph_client_metric *m = &mdsc->metric;
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	struct ceph_msg *msg;
@@ -25,7 +26,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	s32 len;
 
 	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
-	      + sizeof(*meta);
+	      + sizeof(*meta) + sizeof(*dlease);
 
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
 	if (!msg) {
@@ -42,8 +43,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	cap->ver = 1;
 	cap->compat = 1;
 	cap->data_len = cpu_to_le32(sizeof(*cap) - 10);
-	cap->hit = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_hit));
-	cap->mis = cpu_to_le64(percpu_counter_sum(&mdsc->metric.i_caps_mis));
+	cap->hit = cpu_to_le64(percpu_counter_sum(&m->i_caps_hit));
+	cap->mis = cpu_to_le64(percpu_counter_sum(&m->i_caps_mis));
 	cap->total = cpu_to_le64(nr_caps);
 	items++;
 
@@ -83,6 +84,17 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	meta->nsec = cpu_to_le32(ts.tv_nsec);
 	items++;
 
+	/* encode the dentry lease metric */
+	dlease = (struct ceph_metric_dlease *)(meta + 1);
+	dlease->type = cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
+	dlease->ver = 1;
+	dlease->compat = 1;
+	dlease->data_len = cpu_to_le32(sizeof(*dlease) - 10);
+	dlease->hit = cpu_to_le64(percpu_counter_sum(&m->d_lease_hit));
+	dlease->mis = cpu_to_le64(percpu_counter_sum(&m->d_lease_mis));
+	dlease->total = atomic64_read(&m->total_dentries),
+	items++;
+
 	put_unaligned_le32(items, &head->num);
 	msg->front.iov_len = len;
 	msg->hdr.version = cpu_to_le16(1);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 710f3f1dceab..af6038ff39d4 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -27,6 +27,7 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_READ_LATENCY,	\
 	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
 	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
+	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
 						\
 	CLIENT_METRIC_TYPE_MAX,			\
 }
@@ -80,6 +81,19 @@ struct ceph_metric_metadata_latency {
 	__le32 nsec;
 } __packed;
 
+/* metric dentry lease header */
+struct ceph_metric_dlease {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(hit + mis + total) */
+	__le64 hit;
+	__le64 mis;
+	__le64 total;
+} __packed;
+
 struct ceph_metric_head {
 	__le32 num;	/* the number of metrics that will be sent */
 } __packed;
-- 
2.18.4

