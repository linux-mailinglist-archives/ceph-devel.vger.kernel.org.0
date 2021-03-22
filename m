Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5E13440F6
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Mar 2021 13:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhCVM3Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Mar 2021 08:29:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229467AbhCVM3F (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616416144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tpFqxmw84C+IXp9xWbXf2zZz5IeounpOeesMunI9mQ=;
        b=gExf3u+Fh3Vbg1HoE18MqozPDnbUGff/xi0qsT1kQRi5h6PdrtfZcHPCXym8mo63rk19NB
        B91n9SkRKMD0nzhyJE1rRZjdVQBtGBa2etmZXzGLMmWT8S4WFN7aRZpss9ZQqFy5sYzkBB
        7a3qSwhw6jdT41ZTOV0CrVe7LZmQPt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-9z2zJhbSM_-5Jb3F5TlyMw-1; Mon, 22 Mar 2021 08:29:01 -0400
X-MC-Unique: 9z2zJhbSM_-5Jb3F5TlyMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F41E8108BD06;
        Mon, 22 Mar 2021 12:28:59 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0C161C4;
        Mon, 22 Mar 2021 12:28:57 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/4] ceph: rename the metric helpers
Date:   Mon, 22 Mar 2021 20:28:49 +0800
Message-Id: <20210322122852.322927-2-xiubli@redhat.com>
In-Reply-To: <20210322122852.322927-1-xiubli@redhat.com>
References: <20210322122852.322927-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Prepare for the size metrics patches followed.

URL: https://tracker.ceph.com/issues/49913
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c       |  8 ++++----
 fs/ceph/debugfs.c    | 12 ++++++------
 fs/ceph/file.c       | 12 ++++++------
 fs/ceph/mds_client.c |  2 +-
 fs/ceph/metric.c     | 24 ++++++++++++------------
 fs/ceph/metric.h     | 12 ++++++------
 6 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b476133353ae..7c2802758d0e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -226,7 +226,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	int num_pages;
 	int err = req->r_result;
 
-	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
+	ceph_update_read_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				 req->r_end_latency, err);
 
 	dout("%s: result %d subreq->len=%zu i_size=%lld\n", __func__, req->r_result,
@@ -560,7 +560,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	if (!err)
 		err = ceph_osdc_wait_request(osdc, req);
 
-	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, err);
 
 	ceph_osdc_put_request(req);
@@ -648,7 +648,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 		ceph_clear_error_write(ci);
 	}
 
-	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, rc);
 
 	/*
@@ -1719,7 +1719,7 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 	if (!err)
 		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
-	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, err);
 
 out_put:
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 66989c880adb..425f3356332a 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -162,34 +162,34 @@ static int metric_show(struct seq_file *s, void *p)
 	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
 	seq_printf(s, "-----------------------------------------------------------------------------------\n");
 
-	spin_lock(&m->read_latency_lock);
+	spin_lock(&m->read_metric_lock);
 	total = m->total_reads;
 	sum = m->read_latency_sum;
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->read_latency_min;
 	max = m->read_latency_max;
 	sq = m->read_latency_sq_sum;
-	spin_unlock(&m->read_latency_lock);
+	spin_unlock(&m->read_metric_lock);
 	CEPH_METRIC_SHOW("read", total, avg, min, max, sq);
 
-	spin_lock(&m->write_latency_lock);
+	spin_lock(&m->write_metric_lock);
 	total = m->total_writes;
 	sum = m->write_latency_sum;
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->write_latency_min;
 	max = m->write_latency_max;
 	sq = m->write_latency_sq_sum;
-	spin_unlock(&m->write_latency_lock);
+	spin_unlock(&m->write_metric_lock);
 	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
 
-	spin_lock(&m->metadata_latency_lock);
+	spin_lock(&m->metadata_metric_lock);
 	total = m->total_metadatas;
 	sum = m->metadata_latency_sum;
 	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	min = m->metadata_latency_min;
 	max = m->metadata_latency_max;
 	sq = m->metadata_latency_sq_sum;
-	spin_unlock(&m->metadata_latency_lock);
+	spin_unlock(&m->metadata_metric_lock);
 	CEPH_METRIC_SHOW("metadata", total, avg, min, max, sq);
 
 	seq_printf(s, "\n");
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a6ef1d143308..a27aabcb0e0b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -895,7 +895,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		if (!ret)
 			ret = ceph_osdc_wait_request(osdc, req);
 
-		ceph_update_read_latency(&fsc->mdsc->metric,
+		ceph_update_read_metrics(&fsc->mdsc->metric,
 					 req->r_start_latency,
 					 req->r_end_latency,
 					 ret);
@@ -1040,10 +1040,10 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	/* r_start_latency == 0 means the request was not submitted */
 	if (req->r_start_latency) {
 		if (aio_req->write)
-			ceph_update_write_latency(metric, req->r_start_latency,
+			ceph_update_write_metrics(metric, req->r_start_latency,
 						  req->r_end_latency, rc);
 		else
-			ceph_update_read_latency(metric, req->r_start_latency,
+			ceph_update_read_metrics(metric, req->r_start_latency,
 						 req->r_end_latency, rc);
 	}
 
@@ -1293,10 +1293,10 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
 		if (write)
-			ceph_update_write_latency(metric, req->r_start_latency,
+			ceph_update_write_metrics(metric, req->r_start_latency,
 						  req->r_end_latency, ret);
 		else
-			ceph_update_read_latency(metric, req->r_start_latency,
+			ceph_update_read_metrics(metric, req->r_start_latency,
 						 req->r_end_latency, ret);
 
 		size = i_size_read(inode);
@@ -1470,7 +1470,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		if (!ret)
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
-		ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+		ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 					  req->r_end_latency, ret);
 out:
 		ceph_osdc_put_request(req);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d87bd852ed96..73ecb7d128c9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3306,7 +3306,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	/* kick calling process */
 	complete_request(mdsc, req);
 
-	ceph_update_metadata_latency(&mdsc->metric, req->r_start_latency,
+	ceph_update_metadata_metrics(&mdsc->metric, req->r_start_latency,
 				     req->r_end_latency, err);
 out:
 	ceph_mdsc_put_request(req);
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 5ec94bd4c1de..75d309f2fb0c 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -183,21 +183,21 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_i_caps_mis;
 
-	spin_lock_init(&m->read_latency_lock);
+	spin_lock_init(&m->read_metric_lock);
 	m->read_latency_sq_sum = 0;
 	m->read_latency_min = KTIME_MAX;
 	m->read_latency_max = 0;
 	m->total_reads = 0;
 	m->read_latency_sum = 0;
 
-	spin_lock_init(&m->write_latency_lock);
+	spin_lock_init(&m->write_metric_lock);
 	m->write_latency_sq_sum = 0;
 	m->write_latency_min = KTIME_MAX;
 	m->write_latency_max = 0;
 	m->total_writes = 0;
 	m->write_latency_sum = 0;
 
-	spin_lock_init(&m->metadata_latency_lock);
+	spin_lock_init(&m->metadata_metric_lock);
 	m->metadata_latency_sq_sum = 0;
 	m->metadata_latency_min = KTIME_MAX;
 	m->metadata_latency_max = 0;
@@ -274,7 +274,7 @@ static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
 	*sq_sump += sq;
 }
 
-void ceph_update_read_latency(struct ceph_client_metric *m,
+void ceph_update_read_metrics(struct ceph_client_metric *m,
 			      ktime_t r_start, ktime_t r_end,
 			      int rc)
 {
@@ -283,14 +283,14 @@ void ceph_update_read_latency(struct ceph_client_metric *m,
 	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
 		return;
 
-	spin_lock(&m->read_latency_lock);
+	spin_lock(&m->read_metric_lock);
 	__update_latency(&m->total_reads, &m->read_latency_sum,
 			 &m->read_latency_min, &m->read_latency_max,
 			 &m->read_latency_sq_sum, lat);
-	spin_unlock(&m->read_latency_lock);
+	spin_unlock(&m->read_metric_lock);
 }
 
-void ceph_update_write_latency(struct ceph_client_metric *m,
+void ceph_update_write_metrics(struct ceph_client_metric *m,
 			       ktime_t r_start, ktime_t r_end,
 			       int rc)
 {
@@ -299,14 +299,14 @@ void ceph_update_write_latency(struct ceph_client_metric *m,
 	if (unlikely(rc && rc != -ETIMEDOUT))
 		return;
 
-	spin_lock(&m->write_latency_lock);
+	spin_lock(&m->write_metric_lock);
 	__update_latency(&m->total_writes, &m->write_latency_sum,
 			 &m->write_latency_min, &m->write_latency_max,
 			 &m->write_latency_sq_sum, lat);
-	spin_unlock(&m->write_latency_lock);
+	spin_unlock(&m->write_metric_lock);
 }
 
-void ceph_update_metadata_latency(struct ceph_client_metric *m,
+void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 				  ktime_t r_start, ktime_t r_end,
 				  int rc)
 {
@@ -315,9 +315,9 @@ void ceph_update_metadata_latency(struct ceph_client_metric *m,
 	if (unlikely(rc && rc != -ENOENT))
 		return;
 
-	spin_lock(&m->metadata_latency_lock);
+	spin_lock(&m->metadata_metric_lock);
 	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
 			 &m->metadata_latency_min, &m->metadata_latency_max,
 			 &m->metadata_latency_sq_sum, lat);
-	spin_unlock(&m->metadata_latency_lock);
+	spin_unlock(&m->metadata_metric_lock);
 }
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index af6038ff39d4..57b5f0ec38be 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -108,21 +108,21 @@ struct ceph_client_metric {
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
 
-	spinlock_t read_latency_lock;
+	spinlock_t read_metric_lock;
 	u64 total_reads;
 	ktime_t read_latency_sum;
 	ktime_t read_latency_sq_sum;
 	ktime_t read_latency_min;
 	ktime_t read_latency_max;
 
-	spinlock_t write_latency_lock;
+	spinlock_t write_metric_lock;
 	u64 total_writes;
 	ktime_t write_latency_sum;
 	ktime_t write_latency_sq_sum;
 	ktime_t write_latency_min;
 	ktime_t write_latency_max;
 
-	spinlock_t metadata_latency_lock;
+	spinlock_t metadata_metric_lock;
 	u64 total_metadatas;
 	ktime_t metadata_latency_sum;
 	ktime_t metadata_latency_sq_sum;
@@ -162,13 +162,13 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 	percpu_counter_inc(&m->i_caps_mis);
 }
 
-extern void ceph_update_read_latency(struct ceph_client_metric *m,
+extern void ceph_update_read_metrics(struct ceph_client_metric *m,
 				     ktime_t r_start, ktime_t r_end,
 				     int rc);
-extern void ceph_update_write_latency(struct ceph_client_metric *m,
+extern void ceph_update_write_metrics(struct ceph_client_metric *m,
 				      ktime_t r_start, ktime_t r_end,
 				      int rc);
-extern void ceph_update_metadata_latency(struct ceph_client_metric *m,
+extern void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 				         ktime_t r_start, ktime_t r_end,
 					 int rc);
 #endif /* _FS_CEPH_MDS_METRIC_H */
-- 
2.27.0

