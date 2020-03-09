Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A84D17D9EF
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 08:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCIHhc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 03:37:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36808 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726383AbgCIHhc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 03:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583739450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=nGXVD7kZWwODBdntvAKeffxAZP0lKn8FUz7d3S79wQA=;
        b=dREwH6ZzXG0xRLfMSSfq5w8bgo2zoPg/N5Y8zE7dtyNBzADUPF1rrcDcHMtr8LE8TYGNFf
        IYbDDVsf1ZmR1lz7+ms10hBggBvoPbAalhW3KIYJA8Ynk1//SRRuP8kjKOzFESQYHar7lQ
        5pW35//Lpq54wue/Q0oknyltx4QPF/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-oSEmz-5UNhWHxs4uf7lJ_Q-1; Mon, 09 Mar 2020 03:37:28 -0400
X-MC-Unique: oSEmz-5UNhWHxs4uf7lJ_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92F31107ACC7;
        Mon,  9 Mar 2020 07:37:27 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FB8F5C10C;
        Mon,  9 Mar 2020 07:37:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v9 3/5] ceph: add global read latency metric support
Date:   Mon,  9 Mar 2020 03:37:08 -0400
Message-Id: <1583739430-4928-4-git-send-email-xiubli@redhat.com>
In-Reply-To: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It will calculate the latency for the read osd requests:
item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
read          1036        848000          818

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c                  |  8 ++++++++
 fs/ceph/debugfs.c               | 11 +++++++++++
 fs/ceph/file.c                  | 16 ++++++++++++++++
 fs/ceph/mds_client.c            | 14 ++++++++++++++
 fs/ceph/metric.h                | 15 +++++++++++++++
 include/linux/ceph/osd_client.h |  1 +
 net/ceph/osd_client.c           |  2 ++
 7 files changed, 67 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6f4678d..55008a3 100644
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
 
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index c83e52b..d814a3a 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -129,7 +129,18 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	int i, nr_caps = 0;
+	s64 total, sum, avg = 0;
 
+	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n");
+	seq_printf(s, "-----------------------------------------------------\n");
+
+	total = percpu_counter_sum(&mdsc->metric.total_reads);
+	sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
+	sum = jiffies_to_usecs(sum);
+	avg = total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read", total, sum, avg);
+
+	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ba46ba74..3dce2a0 100644
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
@@ -1051,6 +1057,11 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
 	     inode, rc, osd_data->bvec_pos.iter.bi_size);
 
+	/* r_start_stamp == 0 means the request was not submitted */
+	if (req->r_start_stamp && !aio_req->write)
+		ceph_update_read_latency(metric, req->r_start_stamp,
+					 req->r_end_stamp, rc);
+
 	if (rc == -EOLDSNAPC) {
 		struct ceph_aio_work *aio_work;
 		BUG_ON(!aio_req->write);
@@ -1179,6 +1190,7 @@ static void ceph_aio_retry_work(struct work_struct *work)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric = &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct bio_vec *bvecs;
@@ -1295,6 +1307,10 @@ static void ceph_aio_retry_work(struct work_struct *work)
 		if (!ret)
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
 
+		if (!write)
+			ceph_update_read_latency(metric, req->r_start_stamp,
+						 req->r_end_stamp, ret);
+
 		size = i_size_read(inode);
 		if (!write) {
 			if (ret == -ENOENT)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ba54fd2..94f6e53 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4345,8 +4345,20 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
 	if (ret)
 		goto err_i_caps_mis;
 
+	ret = percpu_counter_init(&metric->total_reads, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_reads;
+
+	ret = percpu_counter_init(&metric->read_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_read_latency_sum;
+
 	return 0;
 
+err_read_latency_sum:
+	percpu_counter_destroy(&metric->total_reads);
+err_total_reads:
+	percpu_counter_destroy(&metric->i_caps_mis);
 err_i_caps_mis:
 	percpu_counter_destroy(&metric->i_caps_hit);
 err_i_caps_hit:
@@ -4694,6 +4706,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_mdsc_stop(mdsc);
 
+	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_reads);
 	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
 	percpu_counter_destroy(&mdsc->metric.i_caps_hit);
 	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index f620f72..0fe3eee 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -10,6 +10,9 @@ struct ceph_client_metric {
 
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
+
+	struct percpu_counter total_reads;
+	struct percpu_counter read_latency_sum;
 };
 
 static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
@@ -21,4 +24,16 @@ static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
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
index 51810db..4106db6 100644
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

