Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C987B36D207
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Apr 2021 08:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbhD1GJi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Apr 2021 02:09:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229464AbhD1GJh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 02:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619590133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r4ccoOewp0/tIZpyM3mtQqofDWqmLYaEGOxNl06vfDk=;
        b=YOruCeQV6mf++SPf7+LjnEs2Lum6aqTybVB2/xDLukp8QFAJJ16vLihxQdVYFB8EfMTnPQ
        TG/3xpD8YT1oz3Skj5nL0yV3TVo+au4qAyfGhkidGrPIbfZHcgbgZst+SZEhwpvyPniD4E
        N+o3ckuK5dicDA51d+w8MNS0G44Qj1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-CrTG2BfDMVegtf2qawGHug-1; Wed, 28 Apr 2021 02:08:49 -0400
X-MC-Unique: CrTG2BfDMVegtf2qawGHug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BEF6801AC1;
        Wed, 28 Apr 2021 06:08:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51CD96BC0C;
        Wed, 28 Apr 2021 06:08:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/2] ceph: update and rename __update_latency helper to __update_stdev
Date:   Wed, 28 Apr 2021 14:08:39 +0800
Message-Id: <20210428060840.4447-2-xiubli@redhat.com>
In-Reply-To: <20210428060840.4447-1-xiubli@redhat.com>
References: <20210428060840.4447-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The new __update_stdev() helper will only compute the standard
deviation.

URL: https://tracker.ceph.com/issues/49913
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 56 ++++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 28b6b42ad677..c9a92fb8ebbf 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -285,19 +285,18 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
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
+static inline void __update_stdev(ktime_t total, ktime_t lsum,
+				  ktime_t *sq_sump, ktime_t lat)
+{
+	ktime_t avg, sq;
 
 	if (unlikely(total == 1))
 		return;
@@ -315,14 +314,19 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
 			      int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
+	ktime_t total;
 
 	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
 		return;
 
 	spin_lock(&m->read_metric_lock);
-	__update_latency(&m->total_reads, &m->read_latency_sum,
-			 &m->read_latency_min, &m->read_latency_max,
-			 &m->read_latency_sq_sum, lat);
+	total = ++m->total_reads;
+	m->read_latency_sum += lat;
+	METRIC_UPDATE_MIN_MAX(m->read_latency_min,
+			      m->read_latency_max,
+			      lat);
+	__update_stdev(total, m->read_latency_sum,
+		       &m->read_latency_sq_sum, lat);
 	spin_unlock(&m->read_metric_lock);
 }
 
@@ -331,14 +335,19 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
 			       int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
+	ktime_t total;
 
 	if (unlikely(rc && rc != -ETIMEDOUT))
 		return;
 
 	spin_lock(&m->write_metric_lock);
-	__update_latency(&m->total_writes, &m->write_latency_sum,
-			 &m->write_latency_min, &m->write_latency_max,
-			 &m->write_latency_sq_sum, lat);
+	total = ++m->total_writes;
+	m->write_latency_sum += lat;
+	METRIC_UPDATE_MIN_MAX(m->write_latency_min,
+			      m->write_latency_max,
+			      lat);
+	__update_stdev(total, m->write_latency_sum,
+		       &m->write_latency_sq_sum, lat);
 	spin_unlock(&m->write_metric_lock);
 }
 
@@ -347,13 +356,18 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 				  int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
+	ktime_t total;
 
 	if (unlikely(rc && rc != -ENOENT))
 		return;
 
 	spin_lock(&m->metadata_metric_lock);
-	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
-			 &m->metadata_latency_min, &m->metadata_latency_max,
-			 &m->metadata_latency_sq_sum, lat);
+	total = ++m->total_metadatas;
+	m->metadata_latency_sum += lat;
+	METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
+			      m->metadata_latency_max,
+			      lat);
+	__update_stdev(total, m->metadata_latency_sum,
+		       &m->metadata_latency_sq_sum, lat);
 	spin_unlock(&m->metadata_metric_lock);
 }
-- 
2.27.0

