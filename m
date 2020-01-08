Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEA5133F7A
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 11:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgAHKm2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 05:42:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727878AbgAHKm2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 05:42:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578480145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NNhSIf4cZ+9CZjadDtovT4ZFep4lkOKr/B+v+8OB9I=;
        b=BStP3ZBN+TiCWJ8LJJbWuSrUcKmykZdvbYaAjJFNdbWq8PorL4e+rnox2E25RW7q8B0/Bj
        NDnWGLX/2njDQbnvw7jLHV27yHiHQmr7cuPuik+sh7CGUvtliYpQvZBmhzDqjBpaGhxkfR
        wDsHYwUVEez19WcceVPg+wnUNJ+SdV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-TEypqwwIMg6Bl8yqvaQ-ZQ-1; Wed, 08 Jan 2020 05:42:24 -0500
X-MC-Unique: TEypqwwIMg6Bl8yqvaQ-ZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08747800D4E;
        Wed,  8 Jan 2020 10:42:23 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58837272CB;
        Wed,  8 Jan 2020 10:42:20 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 4/8] ceph: add global write latency metric support
Date:   Wed,  8 Jan 2020 05:41:48 -0500
Message-Id: <20200108104152.28468-5-xiubli@redhat.com>
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
write         222         5287750000      23818693

Fixes: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c                  | 23 +++++++++++++++++++++--
 fs/ceph/debugfs.c               |  8 ++++++++
 fs/ceph/file.c                  | 12 ++++++++++--
 fs/ceph/mds_client.c            | 20 ++++++++++++++++++++
 fs/ceph/mds_client.h            |  6 ++++++
 include/linux/ceph/osd_client.h |  3 ++-
 net/ceph/osd_client.c           |  9 ++++++++-
 7 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 2c51da3515a0..5337202530ec 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -598,12 +598,15 @@ static int writepage_nounlock(struct page *page, st=
ruct writeback_control *wbc)
 	loff_t page_off =3D page_offset(page);
 	int err, len =3D PAGE_SIZE;
 	struct ceph_writeback_ctl ceph_wbc;
+	struct ceph_client_metric *metric;
+	s64 latency;
=20
 	dout("writepage %p idx %lu\n", page, page->index);
=20
 	inode =3D page->mapping->host;
 	ci =3D ceph_inode(inode);
 	fsc =3D ceph_inode_to_client(inode);
+	metric =3D &fsc->mdsc->metric;
=20
 	/* verify this is a writeable snap context */
 	snapc =3D page_snap_context(page);
@@ -645,7 +648,11 @@ static int writepage_nounlock(struct page *page, str=
uct writeback_control *wbc)
 				   &ci->i_layout, snapc, page_off, len,
 				   ceph_wbc.truncate_seq,
 				   ceph_wbc.truncate_size,
-				   &inode->i_mtime, &page, 1);
+				   &inode->i_mtime, &page, 1,
+				   &latency);
+	if (latency)
+		ceph_mdsc_update_write_latency(metric, latency);
+
 	if (err < 0) {
 		struct writeback_control tmp_wbc;
 		if (!wbc)
@@ -707,6 +714,8 @@ static void writepages_finish(struct ceph_osd_request=
 *req)
 {
 	struct inode *inode =3D req->r_inode;
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
+	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_data *osd_data;
 	struct page *page;
 	int num_pages, total_pages =3D 0;
@@ -714,7 +723,6 @@ static void writepages_finish(struct ceph_osd_request=
 *req)
 	int rc =3D req->r_result;
 	struct ceph_snap_context *snapc =3D req->r_snapc;
 	struct address_space *mapping =3D inode->i_mapping;
-	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
 	bool remove_page;
=20
 	dout("writepages_finish %p rc %d\n", inode, rc);
@@ -783,6 +791,11 @@ static void writepages_finish(struct ceph_osd_reques=
t *req)
 			     ceph_sb_to_client(inode->i_sb)->wb_pagevec_pool);
 	else
 		kfree(osd_data->pages);
+
+	if (!rc || rc =3D=3D -ENOENT) {
+		s64 latency =3D jiffies - req->r_start_stamp;
+		ceph_mdsc_update_write_latency(metric, latency);
+	}
 	ceph_osdc_put_request(req);
 }
=20
@@ -1675,6 +1688,7 @@ int ceph_uninline_data(struct file *filp, struct pa=
ge *locked_page)
 	struct inode *inode =3D file_inode(filp);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_osd_request *req;
 	struct page *page =3D NULL;
 	u64 len, inline_version;
@@ -1785,6 +1799,11 @@ int ceph_uninline_data(struct file *filp, struct p=
age *locked_page)
 	err =3D ceph_osdc_start_request(&fsc->client->osdc, req, false);
 	if (!err)
 		err =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
+
+	if (!err || err =3D=3D -ETIMEDOUT) {
+		s64 latency =3D jiffies - req->r_start_stamp;
+		ceph_mdsc_update_write_latency(metric, latency);
+	}
 out_put:
 	ceph_osdc_put_request(req);
 	if (err =3D=3D -ECANCELED)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 8200bf025ccd..3fdb15af0a83 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -142,6 +142,14 @@ static int metric_show(struct seq_file *s, void *p)
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read",
 		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
=20
+	spin_lock(&mdsc->metric.write_lock);
+	total =3D atomic64_read(&mdsc->metric.total_writes),
+	sum =3D timespec64_to_ns(&mdsc->metric.write_latency_sum);
+	spin_unlock(&mdsc->metric.write_lock);
+	avg =3D total ? sum / total : 0;
+	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write",
+		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
+
 	seq_printf(s, "\n");
 	seq_printf(s, "item          total           miss            hit\n");
 	seq_printf(s, "-------------------------------------------------\n");
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 84c9de9da022..f5754acac3b9 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1054,9 +1054,12 @@ ceph_direct_read_write(struct kiocb *iocb, struct =
iov_iter *iter,
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
=20
-		if ((ret > 0 || ret =3D=3D -ETIMEDOUT) && !write) {
+		if (ret > 0 || ret =3D=3D -ETIMEDOUT) {
 			s64 latency =3D jiffies - req->r_start_stamp;
-			ceph_mdsc_update_read_latency(metric, latency);
+			if (write)
+				ceph_mdsc_update_write_latency(metric, latency);
+			else
+				ceph_mdsc_update_read_latency(metric, latency);
 		}
=20
 		size =3D i_size_read(inode);
@@ -1145,6 +1148,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter=
 *from, loff_t pos,
 	struct inode *inode =3D file_inode(file);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
+	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
 	struct ceph_vino vino;
 	struct ceph_osd_request *req;
 	struct page **pages;
@@ -1230,6 +1234,10 @@ ceph_sync_write(struct kiocb *iocb, struct iov_ite=
r *from, loff_t pos,
 		if (!ret)
 			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
=20
+		if (!ret || ret =3D=3D -ETIMEDOUT) {
+			s64 latency =3D jiffies - req->r_start_stamp;
+			ceph_mdsc_update_write_latency(metric, latency);
+		}
 out:
 		ceph_osdc_put_request(req);
 		if (ret !=3D 0) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d36464766e2c..865ff33aac0b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4111,6 +4111,22 @@ void ceph_mdsc_update_read_latency(struct ceph_cli=
ent_metric *m,
 	spin_unlock(&m->read_lock);
 }
=20
+void ceph_mdsc_update_write_latency(struct ceph_client_metric *m,
+				    s64 latency)
+{
+	struct timespec64 ts;
+
+	if (!m)
+		return;
+
+	jiffies_to_timespec64(latency, &ts);
+
+	spin_lock(&m->write_lock);
+	atomic64_inc(&m->total_writes);
+	m->write_latency_sum =3D timespec64_add(m->write_latency_sum, ts);
+	spin_unlock(&m->write_lock);
+}
+
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
@@ -4211,6 +4227,10 @@ static int ceph_mdsc_metric_init(struct ceph_clien=
t_metric *metric)
 	memset(&metric->read_latency_sum, 0, sizeof(struct timespec64));
 	atomic64_set(&metric->total_reads, 0);
=20
+	spin_lock_init(&metric->write_lock);
+	memset(&metric->write_latency_sum, 0, sizeof(struct timespec64));
+	atomic64_set(&metric->total_writes, 0);
+
 	return 0;
 }
=20
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index fb8412a1169b..1c8c446fb7bb 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -370,6 +370,10 @@ struct ceph_client_metric {
 	spinlock_t              read_lock;
 	atomic64_t		total_reads;
 	struct timespec64	read_latency_sum;
+
+	spinlock_t              write_lock;
+	atomic64_t		total_writes;
+	struct timespec64	write_latency_sum;
 };
=20
 /*
@@ -556,4 +560,6 @@ extern int ceph_trim_caps(struct ceph_mds_client *mds=
c,
=20
 extern void ceph_mdsc_update_read_latency(struct ceph_client_metric *m,
 					  s64 latency);
+extern void ceph_mdsc_update_write_latency(struct ceph_client_metric *m,
+					   s64 latency);
 #endif
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
index 8a7acd95f883..9d16c9cb1d69 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -524,7 +524,8 @@ extern int ceph_osdc_writepages(struct ceph_osd_clien=
t *osdc,
 				u64 off, u64 len,
 				u32 truncate_seq, u64 truncate_size,
 				struct timespec64 *mtime,
-				struct page **pages, int nr_pages);
+				struct page **pages, int nr_pages,
+				s64 *latency);
=20
 int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			u64 src_snapid, u64 src_version,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 547946d0c5d6..09632d79cd9a 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5285,12 +5285,16 @@ int ceph_osdc_writepages(struct ceph_osd_client *=
osdc, struct ceph_vino vino,
 			 u64 off, u64 len,
 			 u32 truncate_seq, u64 truncate_size,
 			 struct timespec64 *mtime,
-			 struct page **pages, int num_pages)
+			 struct page **pages, int num_pages,
+			 s64 *latency)
 {
 	struct ceph_osd_request *req;
 	int rc =3D 0;
 	int page_align =3D off & ~PAGE_MASK;
=20
+	if (latency)
+		*latency =3D 0;
+
 	req =3D ceph_osdc_new_request(osdc, layout, vino, off, &len, 0, 1,
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
 				    snapc, truncate_seq, truncate_size,
@@ -5308,6 +5312,9 @@ int ceph_osdc_writepages(struct ceph_osd_client *os=
dc, struct ceph_vino vino,
 	if (!rc)
 		rc =3D ceph_osdc_wait_request(osdc, req);
=20
+	if (latency && (rc > 0 || rc =3D=3D -ETIMEDOUT))
+		*latency =3D jiffies - req->r_start_stamp;
+
 	ceph_osdc_put_request(req);
 	if (rc =3D=3D 0)
 		rc =3D len;
--=20
2.21.0

