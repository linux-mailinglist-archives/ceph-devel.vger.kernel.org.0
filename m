Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2BA163B71
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 04:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgBSDkY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 22:40:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24831 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726403AbgBSDkY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 22:40:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582083622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFimMWpKRx2Wd1BRxTKZwehTgeOsohdPlflif0gme2o=;
        b=L/Gc0MeQymQCU9bfXmTNICTgCJfWvUwtWtvjJRUCzETp6FAz7EalCA1mREPMtxZhlPhRZT
        ad3taj77kjRQFb43bjozJM9ZlaNZJrfmgKWEOhVF0GMhjy6+8KMAO0/USuORjzCmgHuaMR
        zkisEKBVD/4gHeLMgLGHo9f8MmptkDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-L0N35ulrNQ2PqpC2akV-cQ-1; Tue, 18 Feb 2020 22:40:15 -0500
X-MC-Unique: L0N35ulrNQ2PqpC2akV-cQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 896FA800D48;
        Wed, 19 Feb 2020 03:40:14 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3C2360C81;
        Wed, 19 Feb 2020 03:40:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v7 3/5] ceph: add global read latency metric support
Date:   Tue, 18 Feb 2020 22:38:49 -0500
Message-Id: <20200219033851.6548-4-xiubli@redhat.com>
In-Reply-To: <20200219033851.6548-1-xiubli@redhat.com>
References: <20200219033851.6548-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It will calculate the latency for the read osd requests, which only
include the time cousumed by network and the ceph osd.

item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
read          1036        848000          818

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c                  |  6 ++++++
 fs/ceph/debugfs.c               | 11 +++++++++++
 fs/ceph/file.c                  | 13 +++++++++++++
 fs/ceph/mds_client.c            | 14 ++++++++++++++
 fs/ceph/metric.h                | 20 ++++++++++++++++++++
 include/linux/ceph/osd_client.h |  1 +
 net/ceph/osd_client.c           |  2 ++
 7 files changed, 67 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6f4678d98df7..16573a13ffee 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -216,6 +216,8 @@ static int ceph_sync_readpages(struct ceph_fs_client =
*fsc,
 	if (!rc)
 		rc =3D ceph_osdc_wait_request(osdc, req);
=20
+	ceph_update_read_latency(&fsc->mdsc->metric, req, rc);
+
 	ceph_osdc_put_request(req);
 	dout("readpages result %d\n", rc);
 	return rc;
@@ -299,6 +301,7 @@ static int ceph_readpage(struct file *filp, struct pa=
ge *page)
 static void finish_read(struct ceph_osd_request *req)
 {
 	struct inode *inode =3D req->r_inode;
+	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
 	struct ceph_osd_data *osd_data;
 	int rc =3D req->r_result <=3D 0 ? req->r_result : 0;
 	int bytes =3D req->r_result >=3D 0 ? req->r_result : 0;
@@ -336,6 +339,9 @@ static void finish_read(struct ceph_osd_request *req)
 		put_page(page);
 		bytes -=3D PAGE_SIZE;
 	}
+
+	ceph_update_read_latency(&fsc->mdsc->metric, req, rc);
+
 	kfree(osd_data->pages);
 }
=20
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index c83e52bd9961..d814a3a27611 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -129,7 +129,18 @@ static int metric_show(struct seq_file *s, void *p)
 	struct ceph_fs_client *fsc =3D s->private;
 	struct ceph_mds_client *mdsc =3D fsc->mdsc;
 	int i, nr_caps =3D 0;
+	s64 total, sum, avg =3D 0;
=20
+	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n"=
);
+	seq_printf(s, "-----------------------------------------------------\n"=
);
+
+	total =3D percpu_counter_sum(&mdsc->metric.total_reads);
+	sum =3D percpu_counter_sum(&mdsc->metric.read_latency_sum);
+	sum =3D jiffies_to_usecs(sum);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read", total, sum, avg);
+
+	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
=20
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index b1b5aa35d25f..96e35935b764 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -660,6 +660,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, str=
uct iov_iter *to,
 		ret =3D ceph_osdc_start_request(osdc, req, false);
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(osdc, req);
+
+		ceph_update_read_latency(&fsc->mdsc->metric, req, ret);
+
 		ceph_osdc_put_request(req);
=20
 		i_size =3D i_size_read(inode);
@@ -798,6 +801,8 @@ static void ceph_aio_complete_req(struct ceph_osd_req=
uest *req)
 	struct inode *inode =3D req->r_inode;
 	struct ceph_aio_request *aio_req =3D req->r_priv;
 	struct ceph_osd_data *osd_data =3D osd_req_op_extent_osd_data(req, 0);
+	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
=20
 	BUG_ON(osd_data->type !=3D CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
@@ -805,6 +810,10 @@ static void ceph_aio_complete_req(struct ceph_osd_re=
quest *req)
 	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
 	     inode, rc, osd_data->bvec_pos.iter.bi_size);
=20
+	/* r_start_stamp =3D=3D 0 means the request was not submitted */
+	if (req->r_start_stamp && !aio_req->write)
+		ceph_update_read_latency(metric, req, rc);
+
 	if (rc =3D=3D -EOLDSNAPC) {
 		struct ceph_aio_work *aio_work;
 		BUG_ON(!aio_req->write);
@@ -933,6 +942,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov=
_iter *iter,
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct bio_vec *bvecs;
@@ -1049,6 +1059,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
ov_iter *iter,
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
=20
+		if (!write)
+			ceph_update_read_latency(metric, req, ret);
+
 		size =3D i_size_read(inode);
 		if (!write) {
 			if (ret =3D=3D -ENOENT)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4993ccaceefe..b7ada9cde4f8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4184,8 +4184,20 @@ static int ceph_mdsc_metric_init(struct ceph_clien=
t_metric *metric)
 	if (ret)
 		goto err_i_caps_mis;
=20
+	ret =3D percpu_counter_init(&metric->total_reads, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_reads;
+
+	ret =3D percpu_counter_init(&metric->read_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_read_latency_sum;
+
 	return 0;
=20
+err_read_latency_sum:
+	percpu_counter_destroy(&metric->total_reads);
+err_total_reads:
+	percpu_counter_destroy(&metric->i_caps_mis);
 err_i_caps_mis:
 	percpu_counter_destroy(&metric->i_caps_hit);
 err_i_caps_hit:
@@ -4533,6 +4545,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_reads);
 	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
 	percpu_counter_destroy(&mdsc->metric.i_caps_hit);
 	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index e2fceb38a924..afea44a3794b 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -2,6 +2,8 @@
 #ifndef _FS_CEPH_MDS_METRIC_H
 #define _FS_CEPH_MDS_METRIC_H
=20
+#include <linux/ceph/osd_client.h>
+
 /* This is the global metrics */
 struct ceph_client_metric {
 	atomic64_t            total_dentries;
@@ -10,5 +12,23 @@ struct ceph_client_metric {
=20
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
+
+	struct percpu_counter total_reads;
+	struct percpu_counter read_latency_sum;
 };
+
+static inline void ceph_update_read_latency(struct ceph_client_metric *m=
,
+					    struct ceph_osd_request *req,
+					    int rc)
+{
+	if (!m || !req)
+		return;
+
+	if (rc >=3D 0 || rc =3D=3D -ENOENT || rc =3D=3D -ETIMEDOUT) {
+		s64 latency =3D req->r_end_stamp - req->r_start_stamp;
+
+		percpu_counter_inc(&m->total_reads);
+		percpu_counter_add(&m->read_latency_sum, latency);
+	}
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
index 9d9f745b98a1..02ff3a302d26 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -213,6 +213,7 @@ struct ceph_osd_request {
 	/* internal */
 	unsigned long r_stamp;                /* jiffies, send or check time */
 	unsigned long r_start_stamp;          /* jiffies */
+	unsigned long r_end_stamp;            /* jiffies */
 	int r_attempts;
 	u32 r_map_dne_bound;
=20
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 8ff2856e2d52..108c9457d629 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2389,6 +2389,8 @@ static void finish_request(struct ceph_osd_request =
*req)
 	WARN_ON(lookup_request_mc(&osdc->map_checks, req->r_tid));
 	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
=20
+	req->r_end_stamp =3D jiffies;
+
 	if (req->r_osd)
 		unlink_request(req->r_osd, req);
 	atomic_dec(&osdc->num_requests);
--=20
2.21.0

