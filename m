Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD0E166FFD
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 08:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgBUHHE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 02:07:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33994 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726278AbgBUHHE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 02:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582268823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J5ErDN1RZk0/0t+MICM5JwB18y48MkAWcsbLnFOv47k=;
        b=OQ+AhvawLaHb5zOvosRqM1udIU8UJ4fo9iOERLvDA/GjrpaF+GHKsm035Jtqg03IU0RHZz
        zvwAaU6gcWCjuZM68c1ZuZdRuXOGZ5FyFPaXA15BqdhrCNxNSDFmZra3uZuTlCRJUaM0fl
        VK9VrJ9x0CvaqEtRwFhcW97JMk4Wkd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-zhpzTgKyM2W8jI_EW71Wxw-1; Fri, 21 Feb 2020 02:06:59 -0500
X-MC-Unique: zhpzTgKyM2W8jI_EW71Wxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E224C108442A;
        Fri, 21 Feb 2020 07:06:57 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42DF35D9E2;
        Fri, 21 Feb 2020 07:06:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v8 3/5] ceph: add global read latency metric support
Date:   Fri, 21 Feb 2020 02:05:54 -0500
Message-Id: <20200221070556.18922-4-xiubli@redhat.com>
In-Reply-To: <20200221070556.18922-1-xiubli@redhat.com>
References: <20200221070556.18922-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 7e0190b1f821..d51375c4627e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -658,6 +658,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, str=
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
@@ -796,6 +799,8 @@ static void ceph_aio_complete_req(struct ceph_osd_req=
uest *req)
 	struct inode *inode =3D req->r_inode;
 	struct ceph_aio_request *aio_req =3D req->r_priv;
 	struct ceph_osd_data *osd_data =3D osd_req_op_extent_osd_data(req, 0);
+	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
=20
 	BUG_ON(osd_data->type !=3D CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
@@ -803,6 +808,10 @@ static void ceph_aio_complete_req(struct ceph_osd_re=
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
@@ -931,6 +940,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov=
_iter *iter,
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct bio_vec *bvecs;
@@ -1047,6 +1057,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
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
index cd31bcb4e563..18f018b3bd53 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4180,8 +4180,20 @@ static int ceph_mdsc_metric_init(struct ceph_clien=
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
@@ -4529,6 +4541,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_reads);
 	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
 	percpu_counter_destroy(&mdsc->metric.i_caps_hit);
 	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 40eb58f9f43e..86a479da307e 100644
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
@@ -10,6 +12,9 @@ struct ceph_client_metric {
=20
 	struct percpu_counter i_caps_hit;
 	struct percpu_counter i_caps_mis;
+
+	struct percpu_counter total_reads;
+	struct percpu_counter read_latency_sum;
 };
=20
 static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
@@ -27,4 +32,19 @@ static inline void ceph_update_cap_mis(struct ceph_cli=
ent_metric *m)
=20
 	percpu_counter_inc(&m->i_caps_mis);
 }
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

