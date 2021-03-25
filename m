Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8340E348780
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Mar 2021 04:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCYD3I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 23:29:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231157AbhCYD24 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 23:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616642935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j2q3Md3wFsDCKaPbPCPw5QQOmyl1Jp11uOvUe5c7ZW8=;
        b=Aebb373DTm4C35nlFw2jhDbYl2kBxn6tGqwenLFhYe5NTAzsGytcqxwnSA911iJgJ/B+XW
        6g91PSGgd9gda9YFmrlMskhRs0Xrie/GgNG8mvQ4za6Cxza8QE/n3cnh6UL398doISo8XD
        rDLgYzlkD+PK+H/0jeOfSU2LcHBUbSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-B9aydEqlOZ6lXJE54JiMdA-1; Wed, 24 Mar 2021 23:28:51 -0400
X-MC-Unique: B9aydEqlOZ6lXJE54JiMdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00047814256;
        Thu, 25 Mar 2021 03:28:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F04D62951;
        Thu, 25 Mar 2021 03:28:48 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/2] ceph: update the __update_latency helper
Date:   Thu, 25 Mar 2021 11:28:25 +0800
Message-Id: <20210325032826.1725667-2-xiubli@redhat.com>
In-Reply-To: <20210325032826.1725667-1-xiubli@redhat.com>
References: <20210325032826.1725667-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Let the __update_latency() helper choose the correcsponding members
according to the metric_type.

URL: https://tracker.ceph.com/issues/49913
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 73 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 28b6b42ad677..f3e68db08760 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -285,19 +285,56 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 		ceph_put_mds_session(m->session);
 }
 
-static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
-				    ktime_t *min, ktime_t *max,
-				    ktime_t *sq_sump, ktime_t lat)
-{
-	ktime_t total, avg, sq, lsum;
-
-	total = ++(*totalp);
-	lsum = (*lsump += lat);
+typedef enum {
+	CEPH_METRIC_READ,
+	CEPH_METRIC_WRITE,
+	CEPH_METRIC_METADATA,
+} metric_type;
+
+#define METRIC_UPDATE_MIN_MAX(min, max, new)	\
+{						\
+	if (unlikely(new < min))		\
+		min = new;			\
+	if (unlikely(new > max))		\
+		max = new;			\
+}
 
-	if (unlikely(lat < *min))
-		*min = lat;
-	if (unlikely(lat > *max))
-		*max = lat;
+static inline void __update_latency(struct ceph_client_metric *m,
+				    metric_type type, ktime_t lat)
+{
+	ktime_t total, avg, sq, lsum, *sq_sump;
+
+	switch (type) {
+	case CEPH_METRIC_READ:
+		total = ++m->total_reads;
+		m->read_latency_sum += lat;
+		lsum = m->read_latency_sum;
+		METRIC_UPDATE_MIN_MAX(m->read_latency_min,
+				      m->read_latency_max,
+				      lat);
+		sq_sump = &m->read_latency_sq_sum;
+		break;
+	case CEPH_METRIC_WRITE:
+		total = ++m->total_writes;
+		m->write_latency_sum += lat;
+		lsum = m->write_latency_sum;
+		METRIC_UPDATE_MIN_MAX(m->write_latency_min,
+				      m->write_latency_max,
+				      lat);
+		sq_sump = &m->write_latency_sq_sum;
+		break;
+	case CEPH_METRIC_METADATA:
+		total = ++m->total_metadatas;
+		m->metadata_latency_sum += lat;
+		lsum = m->metadata_latency_sum;
+		METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
+				      m->metadata_latency_max,
+				      lat);
+		sq_sump = &m->metadata_latency_sq_sum;
+		break;
+	default:
+		return;
+	}
 
 	if (unlikely(total == 1))
 		return;
@@ -320,9 +357,7 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
 		return;
 
 	spin_lock(&m->read_metric_lock);
-	__update_latency(&m->total_reads, &m->read_latency_sum,
-			 &m->read_latency_min, &m->read_latency_max,
-			 &m->read_latency_sq_sum, lat);
+	__update_latency(m, CEPH_METRIC_READ, lat);
 	spin_unlock(&m->read_metric_lock);
 }
 
@@ -336,9 +371,7 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
 		return;
 
 	spin_lock(&m->write_metric_lock);
-	__update_latency(&m->total_writes, &m->write_latency_sum,
-			 &m->write_latency_min, &m->write_latency_max,
-			 &m->write_latency_sq_sum, lat);
+	__update_latency(m, CEPH_METRIC_WRITE, lat);
 	spin_unlock(&m->write_metric_lock);
 }
 
@@ -352,8 +385,6 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 		return;
 
 	spin_lock(&m->metadata_metric_lock);
-	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
-			 &m->metadata_latency_min, &m->metadata_latency_max,
-			 &m->metadata_latency_sq_sum, lat);
+	__update_latency(m, CEPH_METRIC_METADATA, lat);
 	spin_unlock(&m->metadata_metric_lock);
 }
-- 
2.27.0

