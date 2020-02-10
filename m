Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E995D156EDB
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 06:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgBJFeh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 00:34:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgBJFeh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 00:34:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581312876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u5W4g4pKYQ4QkZVKw8Ijjr7cuVA3BKsgXfh5DhewbHM=;
        b=TKtBWA0hWPfhUXpUlOy0gugg7InGdeNO9hrRB8H38jakzPKtVmWEiQN8EDGly7n2t6FCcu
        BsXJOgrJ2rNi9FPCznwiUK3iPukraReFfX/iZUCQmS+LoVP2+fVStj3uY7nKpeL8UqG38D
        VUQGH5FIs5wp8TyZwOs3nGLrI7bshfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-RS_QhMizOAOSp7ZjwYyY4g-1; Mon, 10 Feb 2020 00:34:34 -0500
X-MC-Unique: RS_QhMizOAOSp7ZjwYyY4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF3B1800D5E;
        Mon, 10 Feb 2020 05:34:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B12B10021B2;
        Mon, 10 Feb 2020 05:34:29 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 4/9] ceph: add global write latency metric support
Date:   Mon, 10 Feb 2020 00:34:02 -0500
Message-Id: <20200210053407.37237-5-xiubli@redhat.com>
In-Reply-To: <20200210053407.37237-1-xiubli@redhat.com>
References: <20200210053407.37237-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It will calculate the latency for the write osd requests, which only
include the time cousumed by network and the ceph osd.

item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
write         1048        8778000         8375

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c       |  7 +++++++
 fs/ceph/debugfs.c    |  6 ++++++
 fs/ceph/file.c       | 13 ++++++++++---
 fs/ceph/mds_client.c | 14 ++++++++++++++
 fs/ceph/metric.h     | 18 ++++++++++++++++++
 5 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 1cc47a062a6c..d14392b58f16 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -649,6 +649,8 @@ static int ceph_sync_writepages(struct ceph_fs_client=
 *fsc,
 	if (!rc)
 		rc =3D ceph_osdc_wait_request(osdc, req);
=20
+	ceph_update_write_latency(&fsc->mdsc->metric, req, rc);
+
 	ceph_osdc_put_request(req);
 	if (rc =3D=3D 0)
 		rc =3D len;
@@ -800,6 +802,8 @@ static void writepages_finish(struct ceph_osd_request=
 *req)
 		ceph_clear_error_write(ci);
 	}
=20
+	ceph_update_write_latency(&fsc->mdsc->metric, req, rc);
+
 	/*
 	 * We lost the cache cap, need to truncate the page before
 	 * it is unlocked, otherwise we'd truncate it later in the
@@ -1858,6 +1862,9 @@ int ceph_uninline_data(struct file *filp, struct pa=
ge *locked_page)
 	err =3D ceph_osdc_start_request(&fsc->client->osdc, req, false);
 	if (!err)
 		err =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
+
+	ceph_update_write_latency(&fsc->mdsc->metric, req, err);
+
 out_put:
 	ceph_osdc_put_request(req);
 	if (err =3D=3D -ECANCELED)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index d814a3a27611..464bfbdb970d 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -140,6 +140,12 @@ static int metric_show(struct seq_file *s, void *p)
 	avg =3D total ? sum / total : 0;
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read", total, sum, avg);
=20
+	total =3D percpu_counter_sum(&mdsc->metric.total_writes);
+	sum =3D percpu_counter_sum(&mdsc->metric.write_latency_sum);
+	sum =3D jiffies_to_usecs(sum);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3526673bd51e..f970a3aa349a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -811,8 +811,12 @@ static void ceph_aio_complete_req(struct ceph_osd_re=
quest *req)
 	     inode, rc, osd_data->bvec_pos.iter.bi_size);
=20
 	/* r_start_stamp =3D=3D 0 means the request was not submitted */
-	if (req->r_start_stamp && !aio_req->write)
-		ceph_update_read_latency(metric, req, rc);
+	if (req->r_start_stamp) {
+		if (aio_req->write)
+			ceph_update_write_latency(metric, req, rc);
+		else
+			ceph_update_read_latency(metric, req, rc);
+	}
=20
 	if (rc =3D=3D -EOLDSNAPC) {
 		struct ceph_aio_work *aio_work;
@@ -1059,7 +1063,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
ov_iter *iter,
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
=20
-		if (!write)
+		if (write)
+			ceph_update_write_latency(metric, req, ret);
+		else
 			ceph_update_read_latency(metric, req, ret);
=20
 		size =3D i_size_read(inode);
@@ -1233,6 +1239,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter=
 *from, loff_t pos,
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
=20
+		ceph_update_write_latency(&fsc->mdsc->metric, req, ret);
 out:
 		ceph_osdc_put_request(req);
 		if (ret !=3D 0) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e2d8312cc332..cc2b426cd8e4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4190,8 +4190,20 @@ static int ceph_mdsc_metric_init(struct ceph_clien=
t_metric *metric)
 	if (ret)
 		goto err_read_latency_sum;
=20
+	ret =3D percpu_counter_init(&metric->total_writes, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_writes;
+
+	ret =3D percpu_counter_init(&metric->write_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_write_latency_sum;
+
 	return 0;
=20
+err_write_latency_sum:
+	percpu_counter_destroy(&metric->total_writes);
+err_total_writes:
+	percpu_counter_destroy(&metric->read_latency_sum);
 err_read_latency_sum:
 	percpu_counter_destroy(&metric->total_reads);
 err_total_reads:
@@ -4543,6 +4555,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.write_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_writes);
 	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
 	percpu_counter_destroy(&mdsc->metric.total_reads);
 	percpu_counter_destroy(&mdsc->metric.i_caps_mis);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index afea44a3794b..a87197f3e915 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -15,6 +15,9 @@ struct ceph_client_metric {
=20
 	struct percpu_counter total_reads;
 	struct percpu_counter read_latency_sum;
+
+	struct percpu_counter total_writes;
+	struct percpu_counter write_latency_sum;
 };
=20
 static inline void ceph_update_read_latency(struct ceph_client_metric *m=
,
@@ -31,4 +34,19 @@ static inline void ceph_update_read_latency(struct cep=
h_client_metric *m,
 		percpu_counter_add(&m->read_latency_sum, latency);
 	}
 }
+
+static inline void ceph_update_write_latency(struct ceph_client_metric *=
m,
+					     struct ceph_osd_request *req,
+					     int rc)
+{
+	if (!m || !req)
+		return;
+
+	if (!rc || rc =3D=3D -ETIMEDOUT) {
+		s64 latency =3D req->r_end_stamp - req->r_start_stamp;
+
+		percpu_counter_inc(&m->total_writes);
+		percpu_counter_add(&m->write_latency_sum, latency);
+	}
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */
--=20
2.21.0

