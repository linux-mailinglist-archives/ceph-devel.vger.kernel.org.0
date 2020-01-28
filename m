Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD9814B49E
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2020 14:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgA1NDk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jan 2020 08:03:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48998 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726007AbgA1NDk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jan 2020 08:03:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580216618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=19M73t7HmnYSsqP0+igGXGkeLAWlntz+rlHlLYCfMdI=;
        b=IESvyoNSuRbm5G4VCMbWeGePdcmlusy2n/NXG82mVeuK24ZBZZexXDUnP2AouE9HeCOwZV
        UF7Zlp9GG9zwWz1Ez0xH+qDSc5Hx3heIJBHSDY6UfkR3w0WJxmwTw5D/HyG0lQjAdMjbGV
        YgOPy0L5Mh1hKrKMlRKx/YRRNEIbWnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-0TIP8JVgOiucngXCQjQF-g-1; Tue, 28 Jan 2020 08:03:23 -0500
X-MC-Unique: 0TIP8JVgOiucngXCQjQF-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35CFC8010C4;
        Tue, 28 Jan 2020 13:03:22 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3F94863D6;
        Tue, 28 Jan 2020 13:03:14 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 05/10] ceph: add global write latency metric support
Date:   Tue, 28 Jan 2020 08:02:43 -0500
Message-Id: <20200128130248.4266-6-xiubli@redhat.com>
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
write         222         5287750000      23818693

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c       | 10 ++++++++++
 fs/ceph/debugfs.c    |  6 ++++++
 fs/ceph/file.c       | 14 +++++++++++---
 fs/ceph/mds_client.c | 15 ++++++++++++++-
 fs/ceph/metric.h     | 17 +++++++++++++++++
 5 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 0435a694370b..74868231f007 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -632,6 +632,7 @@ static int ceph_sync_writepages(struct ceph_fs_client=
 *fsc,
 				struct page **pages, int num_pages)
 {
 	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_request *req;
 	int rc =3D 0;
 	int page_align =3D off & ~PAGE_MASK;
@@ -653,6 +654,8 @@ static int ceph_sync_writepages(struct ceph_fs_client=
 *fsc,
 	if (!rc)
 		rc =3D ceph_osdc_wait_request(osdc, req);
=20
+	ceph_update_write_latency(metric, req, rc);
+
 	ceph_osdc_put_request(req);
 	if (rc =3D=3D 0)
 		rc =3D len;
@@ -792,6 +795,7 @@ static void writepages_finish(struct ceph_osd_request=
 *req)
 	struct ceph_snap_context *snapc =3D req->r_snapc;
 	struct address_space *mapping =3D inode->i_mapping;
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	bool remove_page;
=20
 	dout("writepages_finish %p rc %d\n", inode, rc);
@@ -804,6 +808,8 @@ static void writepages_finish(struct ceph_osd_request=
 *req)
 		ceph_clear_error_write(ci);
 	}
=20
+	ceph_update_write_latency(metric, req, rc);
+
 	/*
 	 * We lost the cache cap, need to truncate the page before
 	 * it is unlocked, otherwise we'd truncate it later in the
@@ -1752,6 +1758,7 @@ int ceph_uninline_data(struct file *filp, struct pa=
ge *locked_page)
 	struct inode *inode =3D file_inode(filp);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_request *req;
 	struct page *page =3D NULL;
 	u64 len, inline_version;
@@ -1864,6 +1871,9 @@ int ceph_uninline_data(struct file *filp, struct pa=
ge *locked_page)
 	err =3D ceph_osdc_start_request(&fsc->client->osdc, req, false);
 	if (!err)
 		err =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
+
+	ceph_update_write_latency(metric, req, err);
+
 out_put:
 	ceph_osdc_put_request(req);
 	if (err =3D=3D -ECANCELED)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index f8a32fa335ae..3d27f2e6f556 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -140,6 +140,12 @@ static int metric_show(struct seq_file *s, void *p)
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read",
 		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
=20
+	total =3D percpu_counter_sum(&mdsc->metric.total_writes);
+	sum =3D percpu_counter_sum(&mdsc->metric.write_latency_sum);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write",
+		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 69288c39229b..9940eb85eff6 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -813,8 +813,12 @@ static void ceph_aio_complete_req(struct ceph_osd_re=
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
@@ -1061,7 +1065,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
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
@@ -1150,6 +1156,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter=
 *from, loff_t pos,
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct page **pages;
@@ -1235,6 +1242,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter=
 *from, loff_t pos,
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
=20
+		ceph_update_write_latency(metric, req, ret);
 out:
 		ceph_osdc_put_request(req);
 		if (ret !=3D 0) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 101b51f9f05d..d072cab77ab2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4195,8 +4195,19 @@ static int ceph_mdsc_metric_init(struct ceph_clien=
t_metric *metric)
 	if (ret)
 		goto err_read_latency_sum;
=20
-	return ret;
+	ret =3D percpu_counter_init(&metric->total_writes, 0, GFP_KERNEL);
+	if (ret)
+		goto err_total_writes;
=20
+	ret =3D percpu_counter_init(&metric->write_latency_sum, 0, GFP_KERNEL);
+	if (ret)
+		goto err_write_latency_sum;
+
+	return ret;
+err_write_latency_sum:
+	percpu_counter_destroy(&metric->total_writes);
+err_total_writes:
+	percpu_counter_destroy(&metric->read_latency_sum);
 err_read_latency_sum:
 	percpu_counter_destroy(&metric->total_reads);
 err_total_reads:
@@ -4544,6 +4555,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
=20
 	ceph_mdsc_stop(mdsc);
=20
+	percpu_counter_destroy(&mdsc->metric.write_latency_sum);
+	percpu_counter_destroy(&mdsc->metric.total_writes);
 	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
 	percpu_counter_destroy(&mdsc->metric.total_reads);
 	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 2a7b8f3fe6a4..49546961eeed 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -12,6 +12,9 @@ struct ceph_client_metric {
=20
 	struct percpu_counter	total_reads;
 	struct percpu_counter	read_latency_sum;
+
+	struct percpu_counter	total_writes;
+	struct percpu_counter	write_latency_sum;
 };
=20
 static inline void ceph_update_read_latency(struct ceph_client_metric *m=
,
@@ -27,4 +30,18 @@ static inline void ceph_update_read_latency(struct cep=
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
+		percpu_counter_inc(&m->total_writes);
+		percpu_counter_add(&m->write_latency_sum, latency);
+	}
+}
 #endif
--=20
2.21.0

