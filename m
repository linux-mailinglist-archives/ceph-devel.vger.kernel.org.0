Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D91C14B49C
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2020 14:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgA1NDc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jan 2020 08:03:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41260 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbgA1NDb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jan 2020 08:03:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580216609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEJgoMb5Tx5SEdINDkcdLjht8sZVW13I7Tzt6tP0GK0=;
        b=QYqjHiClPCpQoKzjM4iMRbd7nrJ9N3hVNwCwHJzyWBVC580ZDYe14CMXQ3e9ThCU3KR7ql
        z7W2JQhsPnbXk4rNJVFOpczUFTKWt8fiHdngMy8C5gAQBsXiU3iq5OtwiI5lLoK9HfwB7+
        KjpeUR7zl5AUPmIWR7g8CU+dGfg1M+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-v2CPQwmpN92B6Z4s1ZbbDA-1; Tue, 28 Jan 2020 08:03:15 -0500
X-MC-Unique: v2CPQwmpN92B6Z4s1ZbbDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ABF7107ACC4;
        Tue, 28 Jan 2020 13:03:14 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CED5780A5C;
        Tue, 28 Jan 2020 13:03:10 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 04/10] ceph: add global read latency metric support
Date:   Tue, 28 Jan 2020 08:02:42 -0500
Message-Id: <20200128130248.4266-5-xiubli@redhat.com>
In-Reply-To: <20200128130248.4266-1-xiubli@redhat.com>
References: <20200128130248.4266-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
read          73          3590000         49178082

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c       |  8 ++++++++
 fs/ceph/debugfs.c    | 11 +++++++++++
 fs/ceph/file.c       | 15 +++++++++++++++
 fs/ceph/mds_client.c | 29 +++++++++++++++++++++++------
 fs/ceph/mds_client.h |  9 ++-------
 fs/ceph/metric.h     | 30 ++++++++++++++++++++++++++++++
 6 files changed, 89 insertions(+), 13 deletions(-)
 create mode 100644 fs/ceph/metric.h

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 20e5ebfff389..0435a694370b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -195,6 +195,7 @@ static int ceph_sync_readpages(struct ceph_fs_client =
*fsc,
 			       int page_align)
 {
 	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_request *req;
 	int rc =3D 0;
=20
@@ -218,6 +219,8 @@ static int ceph_sync_readpages(struct ceph_fs_client =
*fsc,
 	if (!rc)
 		rc =3D ceph_osdc_wait_request(osdc, req);
=20
+	ceph_update_read_latency(metric, req, rc);
+
 	ceph_osdc_put_request(req);
 	dout("readpages result %d\n", rc);
 	return rc;
@@ -301,6 +304,8 @@ static int ceph_readpage(struct file *filp, struct pa=
ge *page)
 static void finish_read(struct ceph_osd_request *req)
 {
 	struct inode *inode =3D req->r_inode;
+	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_data *osd_data;
 	int rc =3D req->r_result <=3D 0 ? req->r_result : 0;
 	int bytes =3D req->r_result >=3D 0 ? req->r_result : 0;
@@ -338,6 +343,9 @@ static void finish_read(struct ceph_osd_request *req)
 		put_page(page);
 		bytes -=3D PAGE_SIZE;
 	}
+
+	ceph_update_read_latency(metric, req, rc);
+
 	kfree(osd_data->pages);
 }
=20
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index c132fdb40d53..f8a32fa335ae 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -128,8 +128,19 @@ static int metric_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc =3D s->private;
 	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+	s64 total, sum, avg =3D 0;
 	int i;
=20
+	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n"=
);
+	seq_printf(s, "-----------------------------------------------------\n"=
);
+
+	total =3D percpu_counter_sum(&mdsc->metric.total_reads);
+	sum =3D percpu_counter_sum(&mdsc->metric.read_latency_sum);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read",
+		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
+
+	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
=20
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c78dfbbb7b91..69288c39229b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -588,6 +588,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, str=
uct iov_iter *to,
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
 	ssize_t ret;
 	u64 off =3D iocb->ki_pos;
@@ -660,6 +661,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, str=
uct iov_iter *to,
 		ret =3D ceph_osdc_start_request(osdc, req, false);
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(osdc, req);
+
+		ceph_update_read_latency(metric, req, ret);
+
 		ceph_osdc_put_request(req);
=20
 		i_size =3D i_size_read(inode);
@@ -798,13 +802,20 @@ static void ceph_aio_complete_req(struct ceph_osd_r=
equest *req)
 	struct inode *inode =3D req->r_inode;
 	struct ceph_aio_request *aio_req =3D req->r_priv;
 	struct ceph_osd_data *osd_data =3D osd_req_op_extent_osd_data(req, 0);
+	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
=20
 	BUG_ON(osd_data->type !=3D CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
+	BUG_ON(!aio_req);
=20
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
@@ -933,6 +944,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov=
_iter *iter,
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct bio_vec *bvecs;
@@ -1049,6 +1061,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
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
index 141c1c03636c..101b51f9f05d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4182,14 +4182,29 @@ static int ceph_mdsc_metric_init(struct ceph_clie=
nt_metric *metric)
 	atomic64_set(&metric->total_dentries, 0);
 	ret =3D percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
 	if (ret)
-		return ret;
+		return ret;;
 	ret =3D percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
-	if (ret) {
-		percpu_counter_destroy(&metric->d_lease_hit);
-		return ret;
-	}
+	if (ret)
+		goto err_dlease_mis;
=20
-	return 0;
+	ret =3D percpu_counter_init(&metric->total_reads, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_reads;
+
+	ret =3D percpu_counter_init(&metric->read_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_read_latency_sum;
+
+	return ret;
+
+err_read_latency_sum:
+	percpu_counter_destroy(&metric->total_reads);
+err_total_reads:
+	percpu_counter_destroy(&metric->d_lease_mis);
+err_dlease_mis:
+	percpu_counter_destroy(&metric->d_lease_hit);
+
+	return ret;
 }
=20
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
@@ -4529,6 +4544,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_reads);
 	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
 	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
=20
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index ba74ff74c59c..574d4e5a5de2 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -16,6 +16,8 @@
 #include <linux/ceph/mdsmap.h>
 #include <linux/ceph/auth.h>
=20
+#include "metric.h"
+
 /* The first 8 bits are reserved for old ceph releases */
 enum ceph_feature_type {
 	CEPHFS_FEATURE_MIMIC =3D 8,
@@ -361,13 +363,6 @@ struct cap_wait {
 	int			want;
 };
=20
-/* This is the global metrics */
-struct ceph_client_metric {
-	atomic64_t		total_dentries;
-	struct percpu_counter	d_lease_hit;
-	struct percpu_counter	d_lease_mis;
-};
-
 /*
  * mds client state
  */
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
new file mode 100644
index 000000000000..2a7b8f3fe6a4
--- /dev/null
+++ b/fs/ceph/metric.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _FS_CEPH_MDS_METRIC_H
+#define _FS_CEPH_MDS_METRIC_H
+
+#include <linux/ceph/osd_client.h>
+
+/* This is the global metrics */
+struct ceph_client_metric {
+	atomic64_t		total_dentries;
+	struct percpu_counter	d_lease_hit;
+	struct percpu_counter	d_lease_mis;
+
+	struct percpu_counter	total_reads;
+	struct percpu_counter	read_latency_sum;
+};
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
+		percpu_counter_inc(&m->total_reads);
+		percpu_counter_add(&m->read_latency_sum, latency);
+	}
+}
+#endif
--=20
2.21.0

