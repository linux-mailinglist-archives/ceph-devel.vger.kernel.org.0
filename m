Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB76189D91
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 15:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCROGi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 10:06:38 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:60768 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726893AbgCROGh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 10:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584540396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=rddQ2fzm+lG7L7rOzpszUflD3FsocJUn/+j/Lf822vA=;
        b=LUXoEAl+Ed+bOD3MAiLFJY4YqtFwjo+QfyAvPisR9wOubSoSC0KvUQCBlt+kcbGfAR5TjY
        LtDXybkd4efhTEL99Bsi4aGb62Ecah2tZwUORko9MZegj1MOk5rRFM90tl1s0Lv01Z6b+Q
        hLcJnmtTbTA/JnNHxrHuT19SivzbPFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-BxA9EZ86Mq-topofJklakw-1; Wed, 18 Mar 2020 10:06:20 -0400
X-MC-Unique: BxA9EZ86Mq-topofJklakw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33725184D26B;
        Wed, 18 Mar 2020 14:06:19 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 876501001DC0;
        Wed, 18 Mar 2020 14:06:16 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v10 3/6] ceph: add read/write latency metric support
Date:   Wed, 18 Mar 2020 10:05:53 -0400
Message-Id: <1584540356-5885-4-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
References: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 fs/ceph/addr.c                  | 18 ++++++++++++++++++
 fs/ceph/debugfs.c               | 17 +++++++++++++++++
 fs/ceph/file.c                  | 26 ++++++++++++++++++++++++++
 fs/ceph/metric.c                | 28 ++++++++++++++++++++++++++++
 fs/ceph/metric.h                | 30 ++++++++++++++++++++++++++++++
 include/linux/ceph/osd_client.h |  1 +
 net/ceph/osd_client.c           |  2 ++
 7 files changed, 122 insertions(+)

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
index 66b9622..f2bb997 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -130,7 +130,24 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_client_metric *m = &mdsc->metric;
 	int i, nr_caps = 0;
+	s64 total, sum, avg = 0;
 
+	seq_printf(s, "item          total       avg_lat(us)\n");
+	seq_printf(s, "-------------------------------------\n");
+
+	total = percpu_counter_sum(&m->total_reads);
+	sum = percpu_counter_sum(&m->read_latency_sum);
+	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = jiffies_to_usecs(avg);
+	seq_printf(s, "%-14s%-12lld%lld\n", "read", total, avg);
+
+	total = percpu_counter_sum(&m->total_writes);
+	sum = percpu_counter_sum(&m->write_latency_sum);
+	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
+	avg = jiffies_to_usecs(avg);
+	seq_printf(s, "%-14s%-12lld%lld\n", "write", total, avg);
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
index 2a4b739..1d34d8c 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -29,8 +29,32 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_i_caps_mis;
 
+	ret = percpu_counter_init(&m->total_reads, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_reads;
+
+	ret = percpu_counter_init(&m->read_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_read_latency_sum;
+
+	ret = percpu_counter_init(&m->total_writes, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_writes;
+
+	ret = percpu_counter_init(&m->write_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_write_latency_sum;
+
 	return 0;
 
+err_write_latency_sum:
+	percpu_counter_destroy(&m->total_writes);
+err_total_writes:
+	percpu_counter_destroy(&m->read_latency_sum);
+err_read_latency_sum:
+	percpu_counter_destroy(&m->total_reads);
+err_total_reads:
+	percpu_counter_destroy(&m->i_caps_mis);
 err_i_caps_mis:
 	percpu_counter_destroy(&m->i_caps_hit);
 err_i_caps_hit:
@@ -46,6 +70,10 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
+	percpu_counter_destroy(&m->write_latency_sum);
+	percpu_counter_destroy(&m->total_writes);
+	percpu_counter_destroy(&m->read_latency_sum);
+	percpu_counter_destroy(&m->total_reads);
 	percpu_counter_destroy(&m->i_caps_mis);
 	percpu_counter_destroy(&m->i_caps_hit);
 	percpu_counter_destroy(&m->d_lease_mis);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 098ee8a..b1b45b0 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -13,6 +13,12 @@ struct ceph_client_metric {
 
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
+
+	struct percpu_counter total_reads;
+	struct percpu_counter read_latency_sum;
+
+	struct percpu_counter total_writes;
+	struct percpu_counter write_latency_sum;
 };
 
 extern int ceph_metric_init(struct ceph_client_metric *m);
@@ -27,4 +33,28 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
 {
 	percpu_counter_inc(&m->i_caps_mis);
 }
+
+static inline void ceph_update_read_latency(struct ceph_client_metric *m,
+					    unsigned long r_start,
+					    unsigned long r_end,
+					    int rc)
+{
+	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
+		return;
+
+	percpu_counter_inc(&m->total_reads);
+	percpu_counter_add(&m->read_latency_sum, r_end - r_start);
+}
+
+static inline void ceph_update_write_latency(struct ceph_client_metric *m,
+					     unsigned long r_start,
+					     unsigned long r_end,
+					     int rc)
+{
+	if (rc && rc != -ETIMEDOUT)
+		return;
+
+	percpu_counter_inc(&m->total_writes);
+	percpu_counter_add(&m->write_latency_sum, r_end - r_start);
+}
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

