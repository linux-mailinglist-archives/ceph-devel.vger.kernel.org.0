Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9826133F79
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 11:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgAHKm0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 05:42:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726466AbgAHKm0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 05:42:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578480144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9DCDnq9Uh0vBkTKj2dwyp3H4Ot/MMOvlTHEFH0DODy4=;
        b=L32/w/0YPBLU2btCj6OE7+EUw66joevUjqVKImhqohrAoFyZ8nlWWEyUy74ZO8T67N8WFx
        J09VV9HUJGFdT4d2XYXEinMIV3YsnvIc2lcKXNxtj56UNNQknedsrtzhesLx0FM41vNbSn
        aap2SfK41/xe0XAaKzHhSpOr+OM3QCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-qi2y0RqTP7ilAdJiqXlHdQ-1; Wed, 08 Jan 2020 05:42:20 -0500
X-MC-Unique: qi2y0RqTP7ilAdJiqXlHdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5188107ACC9;
        Wed,  8 Jan 2020 10:42:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22C0719C58;
        Wed,  8 Jan 2020 10:42:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 3/8] ceph: add global read latency metric support
Date:   Wed,  8 Jan 2020 05:41:47 -0500
Message-Id: <20200108104152.28468-4-xiubli@redhat.com>
In-Reply-To: <20200108104152.28468-1-xiubli@redhat.com>
References: <20200108104152.28468-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
read          73          3590000         49178082

Fixes: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c                  | 15 ++++++++++++++-
 fs/ceph/debugfs.c               | 13 +++++++++++++
 fs/ceph/file.c                  | 12 ++++++++++++
 fs/ceph/mds_client.c            | 25 ++++++++++++++++++++++++-
 fs/ceph/mds_client.h            |  7 +++++++
 include/linux/ceph/osd_client.h |  2 +-
 net/ceph/osd_client.c           |  9 ++++++++-
 7 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7ab616601141..2c51da3515a0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -190,6 +190,8 @@ static int ceph_do_readpage(struct file *filp, struct=
 page *page)
 	struct inode *inode =3D file_inode(filp);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
+	s64 latency;
 	int err =3D 0;
 	u64 off =3D page_offset(page);
 	u64 len =3D PAGE_SIZE;
@@ -221,7 +223,7 @@ static int ceph_do_readpage(struct file *filp, struct=
 page *page)
 	err =3D ceph_osdc_readpages(&fsc->client->osdc, ceph_vino(inode),
 				  &ci->i_layout, off, &len,
 				  ci->i_truncate_seq, ci->i_truncate_size,
-				  &page, 1, 0);
+				  &page, 1, 0, &latency);
 	if (err =3D=3D -ENOENT)
 		err =3D 0;
 	if (err < 0) {
@@ -241,6 +243,9 @@ static int ceph_do_readpage(struct file *filp, struct=
 page *page)
 	ceph_readpage_to_fscache(inode, page);
=20
 out:
+	if (latency)
+		ceph_mdsc_update_read_latency(metric, latency);
+
 	return err < 0 ? err : 0;
 }
=20
@@ -260,6 +265,8 @@ static int ceph_readpage(struct file *filp, struct pa=
ge *page)
 static void finish_read(struct ceph_osd_request *req)
 {
 	struct inode *inode =3D req->r_inode;
+	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_data *osd_data;
 	int rc =3D req->r_result <=3D 0 ? req->r_result : 0;
 	int bytes =3D req->r_result >=3D 0 ? req->r_result : 0;
@@ -297,6 +304,12 @@ static void finish_read(struct ceph_osd_request *req=
)
 		put_page(page);
 		bytes -=3D PAGE_SIZE;
 	}
+
+	if (!rc || rc =3D=3D -ENOENT) {
+		s64 latency =3D jiffies - req->r_start_stamp;
+		ceph_mdsc_update_read_latency(metric, latency);
+	}
+
 	kfree(osd_data->pages);
 }
=20
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index c132fdb40d53..8200bf025ccd 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -128,8 +128,21 @@ static int metric_show(struct seq_file *s, void *p)
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
+	spin_lock(&mdsc->metric.read_lock);
+	total =3D atomic64_read(&mdsc->metric.total_reads),
+	sum =3D timespec64_to_ns(&mdsc->metric.read_latency_sum);
+	spin_unlock(&mdsc->metric.read_lock);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read",
+		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
+
+	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
=20
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 418c7b30c6db..84c9de9da022 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -586,6 +586,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, str=
uct iov_iter *to,
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
 	ssize_t ret;
 	u64 off =3D iocb->ki_pos;
@@ -658,6 +659,11 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, st=
ruct iov_iter *to,
 		ret =3D ceph_osdc_start_request(osdc, req, false);
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(osdc, req);
+
+		if (ret > 0 || ret =3D=3D -ETIMEDOUT) {
+			s64 latency =3D jiffies - req->r_start_stamp;
+			ceph_mdsc_update_read_latency(metric, latency);
+		}
 		ceph_osdc_put_request(req);
=20
 		i_size =3D i_size_read(inode);
@@ -931,6 +937,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov=
_iter *iter,
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct bio_vec *bvecs;
@@ -1047,6 +1054,11 @@ ceph_direct_read_write(struct kiocb *iocb, struct =
iov_iter *iter,
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
=20
+		if ((ret > 0 || ret =3D=3D -ETIMEDOUT) && !write) {
+			s64 latency =3D jiffies - req->r_start_stamp;
+			ceph_mdsc_update_read_latency(metric, latency);
+		}
+
 		size =3D i_size_read(inode);
 		if (!write) {
 			if (ret =3D=3D -ENOENT)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 606fa8cd687f..d36464766e2c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4092,6 +4092,25 @@ static void maybe_recover_session(struct ceph_mds_=
client *mdsc)
 	ceph_force_reconnect(fsc->sb);
 }
=20
+/*
+ * metric helpers
+ */
+void ceph_mdsc_update_read_latency(struct ceph_client_metric *m,
+				   s64 latency)
+{
+	struct timespec64 ts;
+
+	if (!m)
+		return;
+
+	jiffies_to_timespec64(latency, &ts);
+
+	spin_lock(&m->read_lock);
+	atomic64_inc(&m->total_reads);
+	m->read_latency_sum =3D timespec64_add(m->read_latency_sum, ts);
+	spin_unlock(&m->read_lock);
+}
+
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
@@ -4181,13 +4200,17 @@ static int ceph_mdsc_metric_init(struct ceph_clie=
nt_metric *metric)
 	atomic64_set(&metric->total_dentries, 0);
 	ret =3D percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
 	if (ret)
-		return ret;
+		return ret;;
 	ret =3D percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
 	if (ret) {
 		percpu_counter_destroy(&metric->d_lease_hit);
 		return ret;
 	}
=20
+	spin_lock_init(&metric->read_lock);
+	memset(&metric->read_latency_sum, 0, sizeof(struct timespec64));
+	atomic64_set(&metric->total_reads, 0);
+
 	return 0;
 }
=20
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index c8935fd0d8bb..fb8412a1169b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -366,6 +366,10 @@ struct ceph_client_metric {
 	atomic64_t		total_dentries;
 	struct percpu_counter	d_lease_hit;
 	struct percpu_counter	d_lease_mis;
+
+	spinlock_t              read_lock;
+	atomic64_t		total_reads;
+	struct timespec64	read_latency_sum;
 };
=20
 /*
@@ -549,4 +553,7 @@ extern void ceph_mdsc_open_export_target_sessions(str=
uct ceph_mds_client *mdsc,
 extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
 			  struct ceph_mds_session *session,
 			  int max_caps);
+
+extern void ceph_mdsc_update_read_latency(struct ceph_client_metric *m,
+					  s64 latency);
 #endif
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
index eaffbdddf89a..8a7acd95f883 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -515,7 +515,7 @@ extern int ceph_osdc_readpages(struct ceph_osd_client=
 *osdc,
 			       u64 off, u64 *plen,
 			       u32 truncate_seq, u64 truncate_size,
 			       struct page **pages, int nr_pages,
-			       int page_align);
+			       int page_align, s64 *latency);
=20
 extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
 				struct ceph_vino vino,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ba45b074a362..547946d0c5d6 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5238,11 +5238,15 @@ int ceph_osdc_readpages(struct ceph_osd_client *o=
sdc,
 			struct ceph_vino vino, struct ceph_file_layout *layout,
 			u64 off, u64 *plen,
 			u32 truncate_seq, u64 truncate_size,
-			struct page **pages, int num_pages, int page_align)
+			struct page **pages, int num_pages, int page_align,
+			s64 *latency)
 {
 	struct ceph_osd_request *req;
 	int rc =3D 0;
=20
+	if (latency)
+		*latency =3D 0;
+
 	dout("readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
 	     vino.snap, off, *plen);
 	req =3D ceph_osdc_new_request(osdc, layout, vino, off, plen, 0, 1,
@@ -5263,6 +5267,9 @@ int ceph_osdc_readpages(struct ceph_osd_client *osd=
c,
 	if (!rc)
 		rc =3D ceph_osdc_wait_request(osdc, req);
=20
+	if (latency && (rc > 0 || rc =3D=3D -ETIMEDOUT))
+		*latency =3D jiffies - req->r_start_stamp;
+
 	ceph_osdc_put_request(req);
 	dout("readpages result %d\n", rc);
 	return rc;
--=20
2.21.0

