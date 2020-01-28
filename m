Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204AA14B498
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2020 14:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgA1NDO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jan 2020 08:03:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39784 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725926AbgA1NDO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jan 2020 08:03:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580216592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6oZub7dYtpkVuiJqQ/eysBjiqkABCC/FaPm9IiQk+R0=;
        b=TIO3KPd9RLec2t/YMZMEHvxAA6/52JyiEkcatS/ljZ6r1xX/OF9IfFfIZhb8ZY44D8FNn3
        aZgnLk2GSwmPNK3SnDOUxhAZM9g8J6jfQCEI7+PIpOtqUx/lmSBFvUc8GhWHBy1xW5Fnyn
        kgcHNvAhtnO6LIzEw9CTawI6cr3/BtM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147--ldhFdJtPK6VZyMKcGGC8A-1; Tue, 28 Jan 2020 08:03:08 -0500
X-MC-Unique: -ldhFdJtPK6VZyMKcGGC8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED42610120A1;
        Tue, 28 Jan 2020 13:03:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39A7F88827;
        Tue, 28 Jan 2020 13:03:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 02/10] ceph: move ceph_osdc_{read,write}pages to ceph.ko
Date:   Tue, 28 Jan 2020 08:02:40 -0500
Message-Id: <20200128130248.4266-3-xiubli@redhat.com>
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

Since this helpers are only used by cpeh.ko, let's move it to ceph.ko
and rename to _sync_.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c                  | 86 ++++++++++++++++++++++++++++++++-
 include/linux/ceph/osd_client.h | 17 -------
 net/ceph/osd_client.c           | 79 ------------------------------
 3 files changed, 84 insertions(+), 98 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 29d4513eff8c..20e5ebfff389 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -182,6 +182,47 @@ static int ceph_releasepage(struct page *page, gfp_t=
 g)
 	return !PagePrivate(page);
 }
=20
+/*
+ * Read some contiguous pages.  If we cross a stripe boundary, shorten
+ * *plen.  Return number of bytes read, or error.
+ */
+static int ceph_sync_readpages(struct ceph_fs_client *fsc,
+			       struct ceph_vino vino,
+			       struct ceph_file_layout *layout,
+			       u64 off, u64 *plen,
+			       u32 truncate_seq, u64 truncate_size,
+			       struct page **pages, int num_pages,
+			       int page_align)
+{
+	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
+	struct ceph_osd_request *req;
+	int rc =3D 0;
+
+	dout("readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
+	     vino.snap, off, *plen);
+	req =3D ceph_osdc_new_request(osdc, layout, vino, off, plen, 0, 1,
+				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
+				    NULL, truncate_seq, truncate_size,
+				    false);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* it may be a short read due to an object boundary */
+	osd_req_op_extent_osd_data_pages(req, 0,
+				pages, *plen, page_align, false, false);
+
+	dout("readpages  final extent is %llu~%llu (%llu bytes align %d)\n",
+	     off, *plen, *plen, page_align);
+
+	rc =3D ceph_osdc_start_request(osdc, req, false);
+	if (!rc)
+		rc =3D ceph_osdc_wait_request(osdc, req);
+
+	ceph_osdc_put_request(req);
+	dout("readpages result %d\n", rc);
+	return rc;
+}
+
 /*
  * read a single page, without unlocking it.
  */
@@ -218,7 +259,7 @@ static int ceph_do_readpage(struct file *filp, struct=
 page *page)
=20
 	dout("readpage inode %p file %p page %p index %lu\n",
 	     inode, filp, page, page->index);
-	err =3D ceph_osdc_readpages(&fsc->client->osdc, ceph_vino(inode),
+	err =3D ceph_sync_readpages(fsc, ceph_vino(inode),
 				  &ci->i_layout, off, &len,
 				  ci->i_truncate_seq, ci->i_truncate_size,
 				  &page, 1, 0);
@@ -570,6 +611,47 @@ static u64 get_writepages_data_length(struct inode *=
inode,
 	return end > start ? end - start : 0;
 }
=20
+/*
+ * do a synchronous write on N pages
+ */
+static int ceph_sync_writepages(struct ceph_fs_client *fsc,
+				struct ceph_vino vino,
+				struct ceph_file_layout *layout,
+				struct ceph_snap_context *snapc,
+				u64 off, u64 len,
+				u32 truncate_seq, u64 truncate_size,
+				struct timespec64 *mtime,
+				struct page **pages, int num_pages)
+{
+	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
+	struct ceph_osd_request *req;
+	int rc =3D 0;
+	int page_align =3D off & ~PAGE_MASK;
+
+	req =3D ceph_osdc_new_request(osdc, layout, vino, off, &len, 0, 1,
+				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
+				    snapc, truncate_seq, truncate_size,
+				    true);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* it may be a short write due to an object boundary */
+	osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_align,
+				false, false);
+	dout("writepages %llu~%llu (%llu bytes)\n", off, len, len);
+
+	req->r_mtime =3D *mtime;
+	rc =3D ceph_osdc_start_request(osdc, req, true);
+	if (!rc)
+		rc =3D ceph_osdc_wait_request(osdc, req);
+
+	ceph_osdc_put_request(req);
+	if (rc =3D=3D 0)
+		rc =3D len;
+	dout("writepages result %d\n", rc);
+	return rc;
+}
+
 /*
  * Write a single page, but leave the page locked.
  *
@@ -628,7 +710,7 @@ static int writepage_nounlock(struct page *page, stru=
ct writeback_control *wbc)
 		set_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
=20
 	set_page_writeback(page);
-	err =3D ceph_osdc_writepages(&fsc->client->osdc, ceph_vino(inode),
+	err =3D ceph_sync_writepages(fsc, ceph_vino(inode),
 				   &ci->i_layout, snapc, page_off, len,
 				   ceph_wbc.truncate_seq,
 				   ceph_wbc.truncate_size,
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
index 5a62dbd3f4c2..9d9f745b98a1 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -509,23 +509,6 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
 		   struct page *req_page, size_t req_len,
 		   struct page **resp_pages, size_t *resp_len);
=20
-extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
-			       struct ceph_vino vino,
-			       struct ceph_file_layout *layout,
-			       u64 off, u64 *plen,
-			       u32 truncate_seq, u64 truncate_size,
-			       struct page **pages, int nr_pages,
-			       int page_align);
-
-extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
-				struct ceph_vino vino,
-				struct ceph_file_layout *layout,
-				struct ceph_snap_context *sc,
-				u64 off, u64 len,
-				u32 truncate_seq, u64 truncate_size,
-				struct timespec64 *mtime,
-				struct page **pages, int nr_pages);
-
 int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			u64 src_snapid, u64 src_version,
 			struct ceph_object_id *src_oid,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b68b376d8c2f..8ff2856e2d52 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5230,85 +5230,6 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
 	ceph_msgpool_destroy(&osdc->msgpool_op_reply);
 }
=20
-/*
- * Read some contiguous pages.  If we cross a stripe boundary, shorten
- * *plen.  Return number of bytes read, or error.
- */
-int ceph_osdc_readpages(struct ceph_osd_client *osdc,
-			struct ceph_vino vino, struct ceph_file_layout *layout,
-			u64 off, u64 *plen,
-			u32 truncate_seq, u64 truncate_size,
-			struct page **pages, int num_pages, int page_align)
-{
-	struct ceph_osd_request *req;
-	int rc =3D 0;
-
-	dout("readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
-	     vino.snap, off, *plen);
-	req =3D ceph_osdc_new_request(osdc, layout, vino, off, plen, 0, 1,
-				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
-				    NULL, truncate_seq, truncate_size,
-				    false);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	/* it may be a short read due to an object boundary */
-	osd_req_op_extent_osd_data_pages(req, 0,
-				pages, *plen, page_align, false, false);
-
-	dout("readpages  final extent is %llu~%llu (%llu bytes align %d)\n",
-	     off, *plen, *plen, page_align);
-
-	rc =3D ceph_osdc_start_request(osdc, req, false);
-	if (!rc)
-		rc =3D ceph_osdc_wait_request(osdc, req);
-
-	ceph_osdc_put_request(req);
-	dout("readpages result %d\n", rc);
-	return rc;
-}
-EXPORT_SYMBOL(ceph_osdc_readpages);
-
-/*
- * do a synchronous write on N pages
- */
-int ceph_osdc_writepages(struct ceph_osd_client *osdc, struct ceph_vino =
vino,
-			 struct ceph_file_layout *layout,
-			 struct ceph_snap_context *snapc,
-			 u64 off, u64 len,
-			 u32 truncate_seq, u64 truncate_size,
-			 struct timespec64 *mtime,
-			 struct page **pages, int num_pages)
-{
-	struct ceph_osd_request *req;
-	int rc =3D 0;
-	int page_align =3D off & ~PAGE_MASK;
-
-	req =3D ceph_osdc_new_request(osdc, layout, vino, off, &len, 0, 1,
-				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
-				    snapc, truncate_seq, truncate_size,
-				    true);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	/* it may be a short write due to an object boundary */
-	osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_align,
-				false, false);
-	dout("writepages %llu~%llu (%llu bytes)\n", off, len, len);
-
-	req->r_mtime =3D *mtime;
-	rc =3D ceph_osdc_start_request(osdc, req, true);
-	if (!rc)
-		rc =3D ceph_osdc_wait_request(osdc, req);
-
-	ceph_osdc_put_request(req);
-	if (rc =3D=3D 0)
-		rc =3D len;
-	dout("writepages result %d\n", rc);
-	return rc;
-}
-EXPORT_SYMBOL(ceph_osdc_writepages);
-
 static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 				     u64 src_snapid, u64 src_version,
 				     struct ceph_object_id *src_oid,
--=20
2.21.0

