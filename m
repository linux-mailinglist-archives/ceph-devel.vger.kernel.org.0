Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14C12A8E60
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Nov 2020 05:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgKFEat (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Nov 2020 23:30:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbgKFEat (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Nov 2020 23:30:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604637047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=4pGJlqgIaLV0xIJl8xDdsmt7O3lD1DSIpJva6N7SkrA=;
        b=Cn6JjanHb2LmYRdelJ9Fq5e/vrIEz7QGE+J+jIG0vynX13KkriPNPObCaAryl0DfKg9cw0
        DbI7teO30ERTjd6lAZ6j9HW+7gkjES2Dya0kpPI2iTgGN1vtwtC4dE9GGnREFfDF9/W9/g
        4s63PkYXIm8Q6drSz7SialE0NbDkqIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-B5rx2qPcMgK1bubDpzSspg-1; Thu, 05 Nov 2020 23:30:44 -0500
X-MC-Unique: B5rx2qPcMgK1bubDpzSspg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EC1A835B47;
        Fri,  6 Nov 2020 04:30:43 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-120.gsslab.pek2.redhat.com [10.72.37.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C78968431;
        Fri,  6 Nov 2020 04:30:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: send dentry lease metrics to MDS daemon
Date:   Thu,  5 Nov 2020 23:30:21 -0500
Message-Id: <20201106043021.966064-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index fee4c4778313..5ec94bd4c1de 100644
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
+	dlease->total = cpu_to_le64(atomic64_read(&m->total_dentries));
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

