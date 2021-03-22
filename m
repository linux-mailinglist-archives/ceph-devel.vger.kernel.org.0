Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27443440F7
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Mar 2021 13:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhCVM3Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Mar 2021 08:29:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229874AbhCVM3G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616416145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0exbIuQQPHZuwGxsE3owPTaKDu0id0az6eezu0G3B5M=;
        b=cGQS5wmE/JVCc8ONVeKg8CLypoeps0UJ3UgZvJJMjSPVEyLRvLnqRxWnahRl2IDNHQzhio
        IHUSVHKtlo5qUSEnKxfXo3TsrDeR/n/a8VJf5gQLVHEHqTTqg1rriQu5htF8e75Jbw8fnL
        PBITqYAYoBdEfCi7dotEmlVd6gMGswI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-QoWf34OXN6OQQf9Nx4G1lw-1; Mon, 22 Mar 2021 08:29:03 -0400
X-MC-Unique: QoWf34OXN6OQQf9Nx4G1lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61651101371B;
        Mon, 22 Mar 2021 12:29:02 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EDF05886A;
        Mon, 22 Mar 2021 12:29:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/4] ceph: update the __update_latency helper
Date:   Mon, 22 Mar 2021 20:28:50 +0800
Message-Id: <20210322122852.322927-3-xiubli@redhat.com>
In-Reply-To: <20210322122852.322927-1-xiubli@redhat.com>
References: <20210322122852.322927-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Let the __update_latency() helper choose the correcsponding members
according to the metric_type.

URL: https://tracker.ceph.com/issues/49913
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 58 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 75d309f2fb0c..d5560ff99a9d 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -249,19 +249,51 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 		ceph_put_mds_session(m->session);
 }
 
-static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
-				    ktime_t *min, ktime_t *max,
-				    ktime_t *sq_sump, ktime_t lat)
+typedef enum {
+	CEPH_METRIC_READ,
+	CEPH_METRIC_WRITE,
+	CEPH_METRIC_METADATA,
+} metric_type;
+
+static inline void __update_latency(struct ceph_client_metric *m,
+				    metric_type type, ktime_t lat)
 {
+	ktime_t *totalp, *minp, *maxp, *lsump, *sq_sump;
 	ktime_t total, avg, sq, lsum;
 
+	switch (type) {
+	case CEPH_METRIC_READ:
+		totalp = &m->total_reads;
+		lsump = &m->read_latency_sum;
+		minp = &m->read_latency_min;
+		maxp = &m->read_latency_max;
+		sq_sump = &m->read_latency_sq_sum;
+		break;
+	case CEPH_METRIC_WRITE:
+		totalp = &m->total_writes;
+		lsump = &m->write_latency_sum;
+		minp = &m->write_latency_min;
+		maxp = &m->write_latency_max;
+		sq_sump = &m->write_latency_sq_sum;
+		break;
+	case CEPH_METRIC_METADATA:
+		totalp = &m->total_metadatas;
+		lsump = &m->metadata_latency_sum;
+		minp = &m->metadata_latency_min;
+		maxp = &m->metadata_latency_max;
+		sq_sump = &m->metadata_latency_sq_sum;
+		break;
+	default:
+		return;
+	}
+
 	total = ++(*totalp);
 	lsum = (*lsump += lat);
 
-	if (unlikely(lat < *min))
-		*min = lat;
-	if (unlikely(lat > *max))
-		*max = lat;
+	if (unlikely(lat < *minp))
+		*minp = lat;
+	if (unlikely(lat > *maxp))
+		*maxp = lat;
 
 	if (unlikely(total == 1))
 		return;
@@ -284,9 +316,7 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
 		return;
 
 	spin_lock(&m->read_metric_lock);
-	__update_latency(&m->total_reads, &m->read_latency_sum,
-			 &m->read_latency_min, &m->read_latency_max,
-			 &m->read_latency_sq_sum, lat);
+	__update_latency(m, CEPH_METRIC_READ, lat);
 	spin_unlock(&m->read_metric_lock);
 }
 
@@ -300,9 +330,7 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
 		return;
 
 	spin_lock(&m->write_metric_lock);
-	__update_latency(&m->total_writes, &m->write_latency_sum,
-			 &m->write_latency_min, &m->write_latency_max,
-			 &m->write_latency_sq_sum, lat);
+	__update_latency(m, CEPH_METRIC_WRITE, lat);
 	spin_unlock(&m->write_metric_lock);
 }
 
@@ -316,8 +344,6 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
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

