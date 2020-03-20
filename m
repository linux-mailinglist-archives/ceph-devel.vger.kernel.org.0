Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1454718C60D
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Mar 2020 04:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgCTDpc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 23:45:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:45776 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbgCTDpc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 23:45:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584675929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=siCMx5hRibGw9Ejnei59yum/h/ZNdi/zO2mOs6gNTyw=;
        b=GwZTFcyJxBPeKcFyPmQn6L76W76B27eg2kHBxlBlzFP84DbHh7Sw8zMRdx6IDOjp37nz9L
        ubyPftJF9eSBbc+2UFemotA6BJ3MyzCyWXAfC32A0FRkCWMlBW0onAwM3s0ueIBvNf1Ofl
        hY1KU0Yqc1ZLgVgtxp4u4wHA0EUFPRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-TVOAD4O_MOe3i9lD0ZQbMQ-1; Thu, 19 Mar 2020 23:45:23 -0400
X-MC-Unique: TVOAD4O_MOe3i9lD0ZQbMQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECC788017CC;
        Fri, 20 Mar 2020 03:45:21 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C61C5D9CD;
        Fri, 20 Mar 2020 03:45:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v13 3/4] ceph: add read/write latency metric support
Date:   Thu, 19 Mar 2020 23:45:01 -0400
Message-Id: <1584675902-16493-4-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584675902-16493-1-git-send-email-xiubli@redhat.com>
References: <1584675902-16493-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 fs/ceph/addr.c                  | 20 ++++++++++++
 fs/ceph/debugfs.c               | 43 +++++++++++++++++++++++-
 fs/ceph/file.c                  | 30 +++++++++++++++++
 fs/ceph/metric.c                | 72 +++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h                | 22 +++++++++++++
 include/linux/ceph/osd_client.h |  3 ++
 net/ceph/osd_client.c           |  3 ++
 7 files changed, 192 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6f4678d..01ad097 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -11,10 +11,12 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/signal.h>
 #include <linux/iversion.h>
+#include <linux/ktime.h>
 
 #include "super.h"
 #include "mds_client.h"
 #include "cache.h"
+#include "metric.h"
 #include <linux/ceph/osd_client.h>
 #include <linux/ceph/striper.h>
 
@@ -216,6 +218,9 @@ static int ceph_sync_readpages(struct ceph_fs_client *fsc,
 	if (!rc)
 		rc = ceph_osdc_wait_request(osdc, req);
 
+	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
+				 req->r_end_latency, rc);
+
 	ceph_osdc_put_request(req);
 	dout("readpages result %d\n", rc);
 	return rc;
@@ -299,6 +304,7 @@ static int ceph_readpage(struct file *filp, struct page *page)
 static void finish_read(struct ceph_osd_request *req)
 {
 	struct inode *inode = req->r_inode;
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_data *osd_data;
 	int rc = req->r_result <= 0 ? req->r_result : 0;
 	int bytes = req->r_result >= 0 ? req->r_result : 0;
@@ -336,6 +342,10 @@ static void finish_read(struct ceph_osd_request *req)
 		put_page(page);
 		bytes -= PAGE_SIZE;
 	}
+
+	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
+				 req->r_end_latency, rc);
+
 	kfree(osd_data->pages);
 }
 
@@ -643,6 +653,9 @@ static int ceph_sync_writepages(struct ceph_fs_client *fsc,
 	if (!rc)
 		rc = ceph_osdc_wait_request(osdc, req);
 
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+				  req->r_end_latency, rc);
+
 	ceph_osdc_put_request(req);
 	if (rc == 0)
 		rc = len;
@@ -794,6 +807,9 @@ static void writepages_finish(struct ceph_osd_request *req)
 		ceph_clear_error_write(ci);
 	}
 
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+				  req->r_end_latency, rc);
+
 	/*
 	 * We lost the cache cap, need to truncate the page before
 	 * it is unlocked, otherwise we'd truncate it later in the
@@ -1852,6 +1868,10 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
 	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
 	if (!err)
 		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
+
+	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+				  req->r_end_latency, err);
+
 out_put:
 	ceph_osdc_put_request(req);
 	if (err == -ECANCELED)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 66b9622..4a96b7f8 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -7,6 +7,8 @@
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/math64.h>
+#include <linux/ktime.h>
 
 #include <linux/ceph/libceph.h>
 #include <linux/ceph/mon_client.h>
@@ -18,6 +20,7 @@
 #ifdef CONFIG_DEBUG_FS
 
 #include "mds_client.h"
+#include "metric.h"
 
 static int mdsmap_show(struct seq_file *s, void *p)
 {
@@ -124,13 +127,51 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+#define CEPH_METRIC_SHOW(name, total, avg, min, max, sq) {		\
+	s64 _total, _avg, _min, _max, _sq, _st;				\
+	_avg = ktime_to_us(avg);					\
+	_min = ktime_to_us(min == KTIME_MAX ? 0 : min);			\
+	_max = ktime_to_us(max);					\
+	_total = total - 1;						\
+	_sq = _total > 0 ? DIV64_U64_ROUND_CLOSEST(sq, _total) : 0;	\
+	_st = int_sqrt64(_sq);						\
+	_st = ktime_to_us(_st);						\
+	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16lld%lld\n",	\
+		   name, total, _avg, _min, _max, _st);			\
+}
+
 static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_client_metric *m = &mdsc->metric;
 	int i, nr_caps = 0;
-
+	s64 total, sum, avg, min, max, sq;
+
+	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
+	seq_printf(s, "-----------------------------------------------------------------------------------\n");
+
+	spin_lock(&m->read_latency_lock);
+	total = m->total_reads;
+	sum = m->read_latency_sum;
+	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	min = m->read_latency_min;
+	max = m->read_latency_max;
+	sq = m->read_latency_sq_sum;
+	spin_unlock(&m->read_latency_lock);
+	CEPH_METRIC_SHOW("read", total, avg, min, max, sq);
+
+	spin_lock(&m->write_latency_lock);
+	total = m->total_writes;
+	sum = m->write_latency_sum;
+	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	min = m->write_latency_min;
+	max = m->write_latency_max;
+	sq = m->write_latency_sq_sum;
+	spin_unlock(&m->write_latency_lock);
+	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
+
+	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4a5ccbb..3a1bd13 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -11,11 +11,13 @@
 #include <linux/writeback.h>
 #include <linux/falloc.h>
 #include <linux/iversion.h>
+#include <linux/ktime.h>
 
 #include "super.h"
 #include "mds_client.h"
 #include "cache.h"
 #include "io.h"
+#include "metric.h"
 
 static __le32 ceph_flags_sys2wire(u32 flags)
 {
@@ -906,6 +908,12 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		ret = ceph_osdc_start_request(osdc, req, false);
 		if (!ret)
 			ret = ceph_osdc_wait_request(osdc, req);
+
+		ceph_update_read_latency(&fsc->mdsc->metric,
+					 req->r_start_latency,
+					 req->r_end_latency,
+					 ret);
+
 		ceph_osdc_put_request(req);
 
 		i_size = i_size_read(inode);
@@ -1044,6 +1052,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	struct inode *inode = req->r_inode;
 	struct ceph_aio_request *aio_req = req->r_priv;
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric = &fsc->mdsc->metric;
 
 	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
@@ -1051,6 +1061,16 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
 	     inode, rc, osd_data->bvec_pos.iter.bi_size);
 
+	/* r_start_latency == 0 means the request was not submitted */
+	if (req->r_start_latency) {
+		if (aio_req->write)
+			ceph_update_write_latency(metric, req->r_start_latency,
+						  req->r_end_latency, rc);
+		else
+			ceph_update_read_latency(metric, req->r_start_latency,
+						 req->r_end_latency, rc);
+	}
+
 	if (rc == -EOLDSNAPC) {
 		struct ceph_aio_work *aio_work;
 		BUG_ON(!aio_req->write);
@@ -1179,6 +1199,7 @@ static void ceph_aio_retry_work(struct work_struct *work)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric = &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct bio_vec *bvecs;
@@ -1295,6 +1316,13 @@ static void ceph_aio_retry_work(struct work_struct *work)
 		if (!ret)
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
+		if (write)
+			ceph_update_write_latency(metric, req->r_start_latency,
+						  req->r_end_latency, ret);
+		else
+			ceph_update_read_latency(metric, req->r_start_latency,
+						 req->r_end_latency, ret);
+
 		size = i_size_read(inode);
 		if (!write) {
 			if (ret == -ENOENT)
@@ -1466,6 +1494,8 @@ static void ceph_aio_retry_work(struct work_struct *work)
 		if (!ret)
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
+		ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_latency,
+					  req->r_end_latency, ret);
 out:
 		ceph_osdc_put_request(req);
 		if (ret != 0) {
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 2a4b739..f5cf32e7 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -2,6 +2,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu_counter.h>
+#include <linux/math64.h>
 
 #include "metric.h"
 
@@ -29,6 +30,20 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_i_caps_mis;
 
+	spin_lock_init(&m->read_latency_lock);
+	m->read_latency_sq_sum = 0;
+	m->read_latency_min = KTIME_MAX;
+	m->read_latency_max = 0;
+	m->total_reads = 0;
+	m->read_latency_sum = 0;
+
+	spin_lock_init(&m->write_latency_lock);
+	m->write_latency_sq_sum = 0;
+	m->write_latency_min = KTIME_MAX;
+	m->write_latency_max = 0;
+	m->total_writes = 0;
+	m->write_latency_sum = 0;
+
 	return 0;
 
 err_i_caps_mis:
@@ -51,3 +66,60 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
 }
+
+static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
+				    ktime_t *min, ktime_t *max,
+				    ktime_t *sq_sump, ktime_t lat)
+{
+	ktime_t total, avg, sq, lsum;
+
+	total = ++(*totalp);
+	lsum = (*lsump += lat);
+
+	if (unlikely(lat < *min))
+		*min = lat;
+	if (unlikely(lat > *max))
+		*max = lat;
+
+	if (unlikely(total == 1))
+		return;
+
+	/* the sq is (lat - old_avg) * (lat - new_avg) */
+	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
+	sq = lat - avg;
+	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
+	sq = sq * (lat - avg);
+	*sq_sump += sq;
+}
+
+void ceph_update_read_latency(struct ceph_client_metric *m,
+			      ktime_t r_start, ktime_t r_end,
+			      int rc)
+{
+	ktime_t lat = ktime_sub(r_end, r_start);
+
+	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
+		return;
+
+	spin_lock(&m->read_latency_lock);
+	__update_latency(&m->total_reads, &m->read_latency_sum,
+			 &m->read_latency_min, &m->read_latency_max,
+			 &m->read_latency_sq_sum, lat);
+	spin_unlock(&m->read_latency_lock);
+}
+
+void ceph_update_write_latency(struct ceph_client_metric *m,
+			       ktime_t r_start, ktime_t r_end,
+			       int rc)
+{
+	ktime_t lat = ktime_sub(r_end, r_start);
+
+	if (unlikely(rc && rc != -ETIMEDOUT))
+		return;
+
+	spin_lock(&m->write_latency_lock);
+	__update_latency(&m->total_writes, &m->write_latency_sum,
+			 &m->write_latency_min, &m->write_latency_max,
+			 &m->write_latency_sq_sum, lat);
+	spin_unlock(&m->write_latency_lock);
+}
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 098ee8a..ab1543c 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu_counter.h>
+#include <linux/ktime.h>
 
 /* This is the global metrics */
 struct ceph_client_metric {
@@ -13,6 +14,20 @@ struct ceph_client_metric {
 
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
+
+	spinlock_t read_latency_lock;
+	u64 total_reads;
+	ktime_t read_latency_sum;
+	ktime_t read_latency_sq_sum;
+	ktime_t read_latency_min;
+	ktime_t read_latency_max;
+
+	spinlock_t write_latency_lock;
+	u64 total_writes;
+	ktime_t write_latency_sum;
+	ktime_t write_latency_sq_sum;
+	ktime_t write_latency_min;
+	ktime_t write_latency_max;
 };
 
 extern int ceph_metric_init(struct ceph_client_metric *m);
@@ -27,4 +42,11 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 {
 	percpu_counter_inc(&m->i_caps_mis);
 }
+
+extern void ceph_update_read_latency(struct ceph_client_metric *m,
+				     ktime_t r_start, ktime_t r_end,
+				     int rc);
+extern void ceph_update_write_latency(struct ceph_client_metric *m,
+				      ktime_t r_start, ktime_t r_end,
+				      int rc);
 #endif /* _FS_CEPH_MDS_METRIC_H */
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 9d9f745..734f7c6 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -8,6 +8,7 @@
 #include <linux/mempool.h>
 #include <linux/rbtree.h>
 #include <linux/refcount.h>
+#include <linux/ktime.h>
 
 #include <linux/ceph/types.h>
 #include <linux/ceph/osdmap.h>
@@ -213,6 +214,8 @@ struct ceph_osd_request {
 	/* internal */
 	unsigned long r_stamp;                /* jiffies, send or check time */
 	unsigned long r_start_stamp;          /* jiffies */
+	ktime_t r_start_latency;              /* ktime_t */
+	ktime_t r_end_latency;                /* ktime_t */
 	int r_attempts;
 	u32 r_map_dne_bound;
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 998e26b..f963e29 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2373,6 +2373,7 @@ static void account_request(struct ceph_osd_request *req)
 	atomic_inc(&req->r_osdc->num_requests);
 
 	req->r_start_stamp = jiffies;
+	req->r_start_latency = ktime_get();
 }
 
 static void submit_request(struct ceph_osd_request *req, bool wrlocked)
@@ -2389,6 +2390,8 @@ static void finish_request(struct ceph_osd_request *req)
 	WARN_ON(lookup_request_mc(&osdc->map_checks, req->r_tid));
 	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
 
+	req->r_end_latency = ktime_get();
+
 	if (req->r_osd)
 		unlink_request(req->r_osd, req);
 	atomic_dec(&osdc->num_requests);
-- 
1.8.3.1

