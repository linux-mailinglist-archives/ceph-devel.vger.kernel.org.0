Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B956018B8A6
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 15:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgCSOHZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 10:07:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:33393 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727159AbgCSOHY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 10:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584626843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=7JvWanYLyUMnUXPFjQ3R/DkAM12ixbytCJAMYUI4/jA=;
        b=Wui3nKNisjc4bBstx0dJ3GdjclxnOOhIwtGMwcEWj6Hxzc8m2fQP0Nz/5DLLilEnNSnzT2
        mD+1EqpCjORiKqtrWqsJLuhmfybycyOICHli5vKeLnv0HqRP9Lz0xs1+vYJlTbQYco/aQc
        HJFy+uJwoovFhrEquzNbDdO0zBwopro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-yQIs6KuGPMS0Mf9NSp_G3g-1; Thu, 19 Mar 2020 10:07:18 -0400
X-MC-Unique: yQIs6KuGPMS0Mf9NSp_G3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B94C58024D5;
        Thu, 19 Mar 2020 14:07:17 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C13D84D90;
        Thu, 19 Mar 2020 14:07:14 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v12 3/4] ceph: add read/write latency metric support
Date:   Thu, 19 Mar 2020 10:06:51 -0400
Message-Id: <1584626812-21323-4-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584626812-21323-1-git-send-email-xiubli@redhat.com>
References: <1584626812-21323-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Calculate the latency for OSD read requests. Add a new r_end_stamp
field to struct ceph_osd_request that will hold the time of that
the reply was received. Use that to calculate the RTT for each call,
and divide the sum of those by number of calls to get averate RTT.

Keep a tally of RTT for OSD writes and number of calls to track average
latency of OSD writes.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c                  |  18 +++++++
 fs/ceph/debugfs.c               |  60 +++++++++++++++++++++-
 fs/ceph/file.c                  |  26 ++++++++++
 fs/ceph/metric.c                | 110 ++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h                |  23 +++++++++
 include/linux/ceph/osd_client.h |   1 +
 net/ceph/osd_client.c           |   2 +
 7 files changed, 239 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6f4678d..f359619 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -216,6 +216,9 @@ static int ceph_sync_readpages(struct ceph_fs_client *fsc,
 	if (!rc)
 		rc = ceph_osdc_wait_request(osdc, req);
 
+	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
+				 req->r_end_stamp, rc);
+
 	ceph_osdc_put_request(req);
 	dout("readpages result %d\n", rc);
 	return rc;
@@ -299,6 +302,7 @@ static int ceph_readpage(struct file *filp, struct page *page)
 static void finish_read(struct ceph_osd_request *req)
 {
 	struct inode *inode = req->r_inode;
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_data *osd_data;
 	int rc = req->r_result <= 0 ? req->r_result : 0;
 	int bytes = req->r_result >= 0 ? req->r_result : 0;
@@ -336,6 +340,10 @@ static void finish_read(struct ceph_osd_request *req)
 		put_page(page);
 		bytes -= PAGE_SIZE;
 	}
+
+	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
+				 req->r_end_stamp, rc);
+
 	kfree(osd_data->pages);
 }
 
@@ -643,6 +651,9 @@ static int ceph_sync_writepages(struct ceph_fs_client *fsc,
 	if (!rc)
 		rc = ceph_osdc_wait_request(osdc, req);
 
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
+				  req->r_end_stamp, rc);
+
 	ceph_osdc_put_request(req);
 	if (rc == 0)
 		rc = len;
@@ -794,6 +805,9 @@ static void writepages_finish(struct ceph_osd_request *req)
 		ceph_clear_error_write(ci);
 	}
 
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
+				  req->r_end_stamp, rc);
+
 	/*
 	 * We lost the cache cap, need to truncate the page before
 	 * it is unlocked, otherwise we'd truncate it later in the
@@ -1852,6 +1866,10 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
 	if (!err)
 		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
+
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
+				  req->r_end_stamp, err);
+
 out_put:
 	ceph_osdc_put_request(req);
 	if (err == -ECANCELED)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 66b9622..de07fdb 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -7,6 +7,7 @@
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/math64.h>
 
 #include <linux/ceph/libceph.h>
 #include <linux/ceph/mon_client.h>
@@ -124,13 +125,70 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static u64 get_avg(u64 *totalp, u64 *sump, spinlock_t *lockp, u64 *total)
+{
+	u64 t, sum, avg = 0;
+
+	spin_lock(lockp);
+	t = *totalp;
+	sum = *sump;
+	spin_unlock(lockp);
+
+	if (likely(t))
+		avg = DIV64_U64_ROUND_CLOSEST(sum, t);
+
+	*total = t;
+	return avg;
+}
+
+#define CEPH_METRIC_SHOW(name, total, avg, min, max, sq) {		\
+	u64 _total, _avg, _min, _max, _sq, _st, _re = 0;		\
+	_avg = jiffies_to_usecs(avg);					\
+	_min = jiffies_to_usecs(min == S64_MAX ? 0 : min);		\
+	_max = jiffies_to_usecs(max);					\
+	_total = total - 1;						\
+	_sq = _total > 0 ? DIV64_U64_ROUND_CLOSEST(sq, _total) : 0;	\
+	_sq = jiffies_to_usecs(_sq);					\
+	_st = int_sqrt64(_sq);						\
+	if (_st > 0) {							\
+		_re = 5 * (_sq - (_st * _st));				\
+		_re = _re > 0 ? _re - 1 : 0;				\
+		_re = _st > 0 ? div64_s64(_re, _st) : 0;		\
+	}								\
+	seq_printf(s, "%-14s%-12llu%-16llu%-16llu%-16llu%llu.%llu\n",	\
+		   name, total, _avg, _min, _max, _st, _re);		\
+}
+
 static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_client_metric *m = &mdsc->metric;
 	int i, nr_caps = 0;
-
+	u64 total, avg, min, max, sq;
+
+	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
+	seq_printf(s, "-----------------------------------------------------------------------------------\n");
+
+	avg = get_avg(&m->total_reads,
+		      &m->read_latency_sum,
+		      &m->read_latency_lock,
+		      &total);
+	min = atomic64_read(&m->read_latency_min);
+	max = atomic64_read(&m->read_latency_max);
+	sq = percpu_counter_sum(&m->read_latency_sq_sum);
+	CEPH_METRIC_SHOW("read", total, avg, min, max, sq);
+
+	avg = get_avg(&m->total_writes,
+		      &m->write_latency_sum,
+		      &m->write_latency_lock,
+		      &total);
+	min = atomic64_read(&m->write_latency_min);
+	max = atomic64_read(&m->write_latency_max);
+	sq = percpu_counter_sum(&m->write_latency_sq_sum);
+	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
+
+	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4a5ccbb..8e40022 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -906,6 +906,10 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		ret = ceph_osdc_start_request(osdc, req, false);
 		if (!ret)
 			ret = ceph_osdc_wait_request(osdc, req);
+
+		ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
+					 req->r_end_stamp, ret);
+
 		ceph_osdc_put_request(req);
 
 		i_size = i_size_read(inode);
@@ -1044,6 +1048,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	struct inode *inode = req->r_inode;
 	struct ceph_aio_request *aio_req = req->r_priv;
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric = &fsc->mdsc->metric;
 
 	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
@@ -1051,6 +1057,16 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
 	     inode, rc, osd_data->bvec_pos.iter.bi_size);
 
+	/* r_start_stamp == 0 means the request was not submitted */
+	if (req->r_start_stamp) {
+		if (aio_req->write)
+			ceph_update_write_latency(metric, req->r_start_stamp,
+						  req->r_end_stamp, rc);
+		else
+			ceph_update_read_latency(metric, req->r_start_stamp,
+						 req->r_end_stamp, rc);
+	}
+
 	if (rc == -EOLDSNAPC) {
 		struct ceph_aio_work *aio_work;
 		BUG_ON(!aio_req->write);
@@ -1179,6 +1195,7 @@ static void ceph_aio_retry_work(struct work_struct *work)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric = &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct bio_vec *bvecs;
@@ -1295,6 +1312,13 @@ static void ceph_aio_retry_work(struct work_struct *work)
 		if (!ret)
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
+		if (write)
+			ceph_update_write_latency(metric, req->r_start_stamp,
+						  req->r_end_stamp, ret);
+		else
+			ceph_update_read_latency(metric, req->r_start_stamp,
+						 req->r_end_stamp, ret);
+
 		size = i_size_read(inode);
 		if (!write) {
 			if (ret == -ENOENT)
@@ -1466,6 +1490,8 @@ static void ceph_aio_retry_work(struct work_struct *work)
 		if (!ret)
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
+		ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
+					  req->r_end_stamp, ret);
 out:
 		ceph_osdc_put_request(req);
 		if (ret != 0) {
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 2a4b739..6cb64fb 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -2,6 +2,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu_counter.h>
+#include <linux/math64.h>
 
 #include "metric.h"
 
@@ -29,8 +30,32 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_i_caps_mis;
 
+	ret = percpu_counter_init(&m->read_latency_sq_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_read_latency_sq_sum;
+
+	atomic64_set(&m->read_latency_min, S64_MAX);
+	atomic64_set(&m->read_latency_max, 0);
+	spin_lock_init(&m->read_latency_lock);
+	m->total_reads = 0;
+	m->read_latency_sum = 0;
+
+	ret = percpu_counter_init(&m->write_latency_sq_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_write_latency_sq_sum;
+
+	atomic64_set(&m->write_latency_min, S64_MAX);
+	atomic64_set(&m->write_latency_max, 0);
+	spin_lock_init(&m->write_latency_lock);
+	m->total_writes = 0;
+	m->write_latency_sum = 0;
+
 	return 0;
 
+err_write_latency_sq_sum:
+	percpu_counter_destroy(&m->read_latency_sq_sum);
+err_read_latency_sq_sum:
+	percpu_counter_destroy(&m->i_caps_mis);
 err_i_caps_mis:
 	percpu_counter_destroy(&m->i_caps_hit);
 err_i_caps_hit:
@@ -46,8 +71,93 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
+	percpu_counter_destroy(&m->write_latency_sq_sum);
+	percpu_counter_destroy(&m->read_latency_sq_sum);
 	percpu_counter_destroy(&m->i_caps_mis);
 	percpu_counter_destroy(&m->i_caps_hit);
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
 }
+
+static inline void __update_min_latency(atomic64_t *min, unsigned long lat)
+{
+	u64 cur, old;
+
+	cur = atomic64_read(min);
+	do {
+		old = cur;
+		if (likely(lat >= old))
+			break;
+	} while (unlikely((cur = atomic64_cmpxchg(min, old, lat)) != old));
+}
+
+static inline void __update_max_latency(atomic64_t *max, unsigned long lat)
+{
+	u64 cur, old;
+
+	cur = atomic64_read(max);
+	do {
+		old = cur;
+		if (likely(lat <= old))
+			break;
+	} while (unlikely((cur = atomic64_cmpxchg(max, old, lat)) != old));
+}
+
+static inline void __update_avg_and_sq(u64 *totalp, u64 *lsump,
+				       struct percpu_counter *sq_sump,
+				       spinlock_t *lockp, unsigned long lat)
+{
+	u64 total, avg, sq, lsum;
+
+	spin_lock(lockp);
+	total = ++(*totalp);
+	*lsump += lat;
+	lsum = *lsump;
+	spin_unlock(lockp);
+
+	if (unlikely(total == 1))
+		return;
+
+	/* the sq is (lat - old_avg) * (lat - new_avg) */
+	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
+	sq = lat - avg;
+	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
+	sq = sq * (lat - avg);
+	percpu_counter_add(sq_sump, sq);
+}
+
+void ceph_update_read_latency(struct ceph_client_metric *m,
+			      unsigned long r_start,
+			      unsigned long r_end,
+			      int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
+		return;
+
+	__update_min_latency(&m->read_latency_min, lat);
+	__update_max_latency(&m->read_latency_max, lat);
+	__update_avg_and_sq(&m->total_reads, &m->read_latency_sum,
+			    &m->read_latency_sq_sum,
+			    &m->read_latency_lock,
+			    lat);
+}
+
+void ceph_update_write_latency(struct ceph_client_metric *m,
+			       unsigned long r_start,
+			       unsigned long r_end,
+			       int rc)
+{
+	unsigned long lat = r_end - r_start;
+
+	if (unlikely(rc && rc != -ETIMEDOUT))
+		return;
+
+	__update_min_latency(&m->write_latency_min, lat);
+	__update_max_latency(&m->write_latency_max, lat);
+	__update_avg_and_sq(&m->total_writes, &m->write_latency_sum,
+			    &m->write_latency_sq_sum,
+			    &m->write_latency_lock,
+			    lat);
+}
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 098ee8a..c7eae56 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -13,6 +13,20 @@ struct ceph_client_metric {
 
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
+
+	struct percpu_counter read_latency_sq_sum;
+	atomic64_t read_latency_min;
+	atomic64_t read_latency_max;
+	spinlock_t read_latency_lock;
+	u64 total_reads;
+	u64 read_latency_sum;
+
+	struct percpu_counter write_latency_sq_sum;
+	atomic64_t write_latency_min;
+	atomic64_t write_latency_max;
+	spinlock_t write_latency_lock;
+	u64 total_writes;
+	u64 write_latency_sum;
 };
 
 extern int ceph_metric_init(struct ceph_client_metric *m);
@@ -27,4 +41,13 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 {
 	percpu_counter_inc(&m->i_caps_mis);
 }
+
+extern void ceph_update_read_latency(struct ceph_client_metric *m,
+				     unsigned long r_start,
+				     unsigned long r_end,
+				     int rc);
+extern void ceph_update_write_latency(struct ceph_client_metric *m,
+				      unsigned long r_start,
+				      unsigned long r_end,
+				      int rc);
 #endif /* _FS_CEPH_MDS_METRIC_H */
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 9d9f745..02ff3a3 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -213,6 +213,7 @@ struct ceph_osd_request {
 	/* internal */
 	unsigned long r_stamp;                /* jiffies, send or check time */
 	unsigned long r_start_stamp;          /* jiffies */
+	unsigned long r_end_stamp;            /* jiffies */
 	int r_attempts;
 	u32 r_map_dne_bound;
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 998e26b..28e33e0 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2389,6 +2389,8 @@ static void finish_request(struct ceph_osd_request *req)
 	WARN_ON(lookup_request_mc(&osdc->map_checks, req->r_tid));
 	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
 
+	req->r_end_stamp = jiffies;
+
 	if (req->r_osd)
 		unlink_request(req->r_osd, req);
 	atomic_dec(&osdc->num_requests);
-- 
1.8.3.1

