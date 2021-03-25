Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2BE348782
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Mar 2021 04:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhCYD3I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 23:29:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231235AbhCYD26 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 23:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616642937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ir7h7RClk9iKNDXHlkf9uxGeCb4HkqmXuKEk+Wx/y6M=;
        b=biipifyYOheSrVAUEqSH6DmjBsTekQD7XWtBMx81jcH4ASu10L5j8ypgFIjQq5Jwn+BMcQ
        HmYa1U79CnVm7FcGnRrwB/EjYeE1iCu/P3hWLnOFYH9y4cJtsjtNbKLozzdaKXb69+XveA
        wiP+4TvEw6WxhEmee7W3QaarTYMxBvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-upL5KmshOaeRJ5Vu89786w-1; Wed, 24 Mar 2021 23:28:54 -0400
X-MC-Unique: upL5KmshOaeRJ5Vu89786w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E914814256;
        Thu, 25 Mar 2021 03:28:53 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DBED62677;
        Thu, 25 Mar 2021 03:28:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] ceph: add IO size metrics support
Date:   Thu, 25 Mar 2021 11:28:26 +0800
Message-Id: <20210325032826.1725667-3-xiubli@redhat.com>
In-Reply-To: <20210325032826.1725667-1-xiubli@redhat.com>
References: <20210325032826.1725667-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will collect IO's total size and then calculate the average
size, and also will collect the min/max IO sizes.

The debugfs will show the size metrics in byte and will let the
userspace applications to switch to what they need.

URL: https://tracker.ceph.com/issues/49913
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c    | 14 ++++++++------
 fs/ceph/debugfs.c | 37 +++++++++++++++++++++++++++++++++----
 fs/ceph/file.c    | 23 +++++++++++------------
 fs/ceph/metric.c  | 36 ++++++++++++++++++++++++++++++++++--
 fs/ceph/metric.h  | 10 ++++++++--
 5 files changed, 94 insertions(+), 26 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index d26a88aca014..57c67180ce5c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -225,7 +225,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	int err = req->r_result;
 
 	ceph_update_read_metrics(&fsc->mdsc->metric, req->r_start_latency,
-				 req->r_end_latency, err);
+				 req->r_end_latency, osd_data->length, err);
 
 	dout("%s: result %d subreq->len=%zu i_size=%lld\n", __func__, req->r_result,
 	     subreq->len, i_size_read(req->r_inode));
@@ -559,7 +559,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 		err = ceph_osdc_wait_request(osdc, req);
 
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
-				  req->r_end_latency, err);
+				  req->r_end_latency, len, err);
 
 	ceph_osdc_put_request(req);
 	if (err == 0)
@@ -634,6 +634,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 	struct ceph_snap_context *snapc = req->r_snapc;
 	struct address_space *mapping = inode->i_mapping;
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	unsigned int len = 0;
 	bool remove_page;
 
 	dout("writepages_finish %p rc %d\n", inode, rc);
@@ -646,9 +647,6 @@ static void writepages_finish(struct ceph_osd_request *req)
 		ceph_clear_error_write(ci);
 	}
 
-	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
-				  req->r_end_latency, rc);
-
 	/*
 	 * We lost the cache cap, need to truncate the page before
 	 * it is unlocked, otherwise we'd truncate it later in the
@@ -665,6 +663,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 
 		osd_data = osd_req_op_extent_osd_data(req, i);
 		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
+		len += osd_data->length;
 		num_pages = calc_pages_for((u64)osd_data->alignment,
 					   (u64)osd_data->length);
 		total_pages += num_pages;
@@ -695,6 +694,9 @@ static void writepages_finish(struct ceph_osd_request *req)
 		release_pages(osd_data->pages, num_pages);
 	}
 
+	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
+				  req->r_end_latency, len, rc);
+
 	ceph_put_wrbuffer_cap_refs(ci, total_pages, snapc);
 
 	osd_data = osd_req_op_extent_osd_data(req, 0);
@@ -1716,7 +1718,7 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
-				  req->r_end_latency, err);
+				  req->r_end_latency, len, err);
 
 out_put:
 	ceph_osdc_put_request(req);
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 425f3356332a..38b78b45811f 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -127,7 +127,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-#define CEPH_METRIC_SHOW(name, total, avg, min, max, sq) {		\
+#define CEPH_LAT_METRIC_SHOW(name, total, avg, min, max, sq) {		\
 	s64 _total, _avg, _min, _max, _sq, _st;				\
 	_avg = ktime_to_us(avg);					\
 	_min = ktime_to_us(min == KTIME_MAX ? 0 : min);			\
@@ -140,6 +140,12 @@ static int mdsc_show(struct seq_file *s, void *p)
 		   name, total, _avg, _min, _max, _st);			\
 }
 
+#define CEPH_SZ_METRIC_SHOW(name, total, avg, min, max, sum) {		\
+	u64 _min = min == U64_MAX ? 0 : min;				\
+	seq_printf(s, "%-14s%-12lld%-16llu%-16llu%-16llu%llu\n",	\
+		   name, total, avg, _min, max, sum);			\
+}
+
 static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
@@ -147,6 +153,7 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_client_metric *m = &mdsc->metric;
 	int nr_caps = 0;
 	s64 total, sum, avg, min, max, sq;
+	u64 sum_sz, avg_sz, min_sz, max_sz;
 
 	sum = percpu_counter_sum(&m->total_inodes);
 	seq_printf(s, "item                               total\n");
@@ -170,7 +177,7 @@ static int metric_show(struct seq_file *s, void *p)
 	max = m->read_latency_max;
 	sq = m->read_latency_sq_sum;
 	spin_unlock(&m->read_metric_lock);
-	CEPH_METRIC_SHOW("read", total, avg, min, max, sq);
+	CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, sq);
 
 	spin_lock(&m->write_metric_lock);
 	total = m->total_writes;
@@ -180,7 +187,7 @@ static int metric_show(struct seq_file *s, void *p)
 	max = m->write_latency_max;
 	sq = m->write_latency_sq_sum;
 	spin_unlock(&m->write_metric_lock);
-	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
+	CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, sq);
 
 	spin_lock(&m->metadata_metric_lock);
 	total = m->total_metadatas;
@@ -190,7 +197,29 @@ static int metric_show(struct seq_file *s, void *p)
 	max = m->metadata_latency_max;
 	sq = m->metadata_latency_sq_sum;
 	spin_unlock(&m->metadata_metric_lock);
-	CEPH_METRIC_SHOW("metadata", total, avg, min, max, sq);
+	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
+
+	seq_printf(s, "\n");
+	seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
+	seq_printf(s, "----------------------------------------------------------------------------------------\n");
+
+	spin_lock(&m->read_metric_lock);
+	total = m->total_reads;
+	sum_sz = m->read_size_sum;
+	avg_sz = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum_sz, total) : 0;
+	min_sz = m->read_size_min;
+	max_sz = m->read_size_max;
+	spin_unlock(&m->read_metric_lock);
+	CEPH_SZ_METRIC_SHOW("read", total, avg_sz, min_sz, max_sz, sum_sz);
+
+	spin_lock(&m->write_metric_lock);
+	total = m->total_writes;
+	sum_sz = m->write_size_sum;
+	avg_sz = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum_sz, total) : 0;
+	min_sz = m->write_size_min;
+	max_sz = m->write_size_max;
+	spin_unlock(&m->write_metric_lock);
+	CEPH_SZ_METRIC_SHOW("write", total, avg_sz, min_sz, max_sz, sum_sz);
 
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 31542eac7e59..db43d2d013b9 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -898,7 +898,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		ceph_update_read_metrics(&fsc->mdsc->metric,
 					 req->r_start_latency,
 					 req->r_end_latency,
-					 ret);
+					 len, ret);
 
 		ceph_osdc_put_request(req);
 
@@ -1030,12 +1030,12 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	struct ceph_aio_request *aio_req = req->r_priv;
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
 	struct ceph_client_metric *metric = &ceph_sb_to_mdsc(inode->i_sb)->metric;
+	unsigned int len = osd_data->bvec_pos.iter.bi_size;
 
 	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
 
-	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
-	     inode, rc, osd_data->bvec_pos.iter.bi_size);
+	dout("ceph_aio_complete_req %p rc %d bytes %u\n", inode, rc, len);
 
 	if (rc == -EOLDSNAPC) {
 		struct ceph_aio_work *aio_work;
@@ -1053,9 +1053,9 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	} else if (!aio_req->write) {
 		if (rc == -ENOENT)
 			rc = 0;
-		if (rc >= 0 && osd_data->bvec_pos.iter.bi_size > rc) {
+		if (rc >= 0 && len > rc) {
 			struct iov_iter i;
-			int zlen = osd_data->bvec_pos.iter.bi_size - rc;
+			int zlen = len - rc;
 
 			/*
 			 * If read is satisfied by single OSD request,
@@ -1072,8 +1072,7 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 			}
 
 			iov_iter_bvec(&i, READ, osd_data->bvec_pos.bvecs,
-				      osd_data->num_bvecs,
-				      osd_data->bvec_pos.iter.bi_size);
+				      osd_data->num_bvecs, len);
 			iov_iter_advance(&i, rc);
 			iov_iter_zero(zlen, &i);
 		}
@@ -1083,10 +1082,10 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	if (req->r_start_latency) {
 		if (aio_req->write)
 			ceph_update_write_metrics(metric, req->r_start_latency,
-						  req->r_end_latency, rc);
+						  req->r_end_latency, len, rc);
 		else
 			ceph_update_read_metrics(metric, req->r_start_latency,
-						 req->r_end_latency, rc);
+						 req->r_end_latency, len, rc);
 	}
 
 	put_bvecs(osd_data->bvec_pos.bvecs, osd_data->num_bvecs,
@@ -1294,10 +1293,10 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 
 		if (write)
 			ceph_update_write_metrics(metric, req->r_start_latency,
-						  req->r_end_latency, ret);
+						  req->r_end_latency, len, ret);
 		else
 			ceph_update_read_metrics(metric, req->r_start_latency,
-						 req->r_end_latency, ret);
+						 req->r_end_latency, len, ret);
 
 		size = i_size_read(inode);
 		if (!write) {
@@ -1471,7 +1470,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
 		ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
-					  req->r_end_latency, ret);
+					  req->r_end_latency, len, ret);
 out:
 		ceph_osdc_put_request(req);
 		if (ret != 0) {
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index f3e68db08760..c1d7fcb61b3c 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -225,6 +225,9 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->read_latency_max = 0;
 	m->total_reads = 0;
 	m->read_latency_sum = 0;
+	m->read_size_min = U64_MAX;
+	m->read_size_max = 0;
+	m->read_size_sum = 0;
 
 	spin_lock_init(&m->write_metric_lock);
 	m->write_latency_sq_sum = 0;
@@ -232,6 +235,9 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	m->write_latency_max = 0;
 	m->total_writes = 0;
 	m->write_latency_sum = 0;
+	m->write_size_min = U64_MAX;
+	m->write_size_max = 0;
+	m->write_size_sum = 0;
 
 	spin_lock_init(&m->metadata_metric_lock);
 	m->metadata_latency_sq_sum = 0;
@@ -347,9 +353,33 @@ static inline void __update_latency(struct ceph_client_metric *m,
 	*sq_sump += sq;
 }
 
+static inline void __update_size(struct ceph_client_metric *m,
+				 metric_type type, unsigned int size)
+{
+	switch (type) {
+	case CEPH_METRIC_READ:
+		++m->total_reads;
+		m->read_size_sum += size;
+		METRIC_UPDATE_MIN_MAX(m->read_size_min,
+				      m->read_size_max,
+				      size);
+		return;
+	case CEPH_METRIC_WRITE:
+		++m->total_writes;
+		m->write_size_sum += size;
+		METRIC_UPDATE_MIN_MAX(m->write_size_min,
+				      m->write_size_max,
+				      size);
+		return;
+	case CEPH_METRIC_METADATA:
+	default:
+		return;
+	}
+}
+
 void ceph_update_read_metrics(struct ceph_client_metric *m,
 			      ktime_t r_start, ktime_t r_end,
-			      int rc)
+			      unsigned int size, int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
 
@@ -358,12 +388,13 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
 
 	spin_lock(&m->read_metric_lock);
 	__update_latency(m, CEPH_METRIC_READ, lat);
+	__update_size(m, CEPH_METRIC_READ, size);
 	spin_unlock(&m->read_metric_lock);
 }
 
 void ceph_update_write_metrics(struct ceph_client_metric *m,
 			       ktime_t r_start, ktime_t r_end,
-			       int rc)
+			       unsigned int size, int rc)
 {
 	ktime_t lat = ktime_sub(r_end, r_start);
 
@@ -372,6 +403,7 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
 
 	spin_lock(&m->write_metric_lock);
 	__update_latency(m, CEPH_METRIC_WRITE, lat);
+	__update_size(m, CEPH_METRIC_WRITE, size);
 	spin_unlock(&m->write_metric_lock);
 }
 
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index e984eb2bb14b..4bd92689bf12 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -152,6 +152,9 @@ struct ceph_client_metric {
 
 	spinlock_t read_metric_lock;
 	u64 total_reads;
+	u64 read_size_sum;
+	u64 read_size_min;
+	u64 read_size_max;
 	ktime_t read_latency_sum;
 	ktime_t read_latency_sq_sum;
 	ktime_t read_latency_min;
@@ -159,6 +162,9 @@ struct ceph_client_metric {
 
 	spinlock_t write_metric_lock;
 	u64 total_writes;
+	u64 write_size_sum;
+	u64 write_size_min;
+	u64 write_size_max;
 	ktime_t write_latency_sum;
 	ktime_t write_latency_sq_sum;
 	ktime_t write_latency_min;
@@ -206,10 +212,10 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 
 extern void ceph_update_read_metrics(struct ceph_client_metric *m,
 				     ktime_t r_start, ktime_t r_end,
-				     int rc);
+				     unsigned int size, int rc);
 extern void ceph_update_write_metrics(struct ceph_client_metric *m,
 				      ktime_t r_start, ktime_t r_end,
-				      int rc);
+				      unsigned int size, int rc);
 extern void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 				         ktime_t r_start, ktime_t r_end,
 					 int rc);
-- 
2.27.0

