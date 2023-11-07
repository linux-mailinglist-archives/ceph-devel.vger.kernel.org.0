Return-Path: <ceph-devel+bounces-64-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A09C7E335B
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 03:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE4F7B20BDD
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 02:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76D415BD;
	Tue,  7 Nov 2023 02:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fnqjbwK7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C838443D
	for <ceph-devel@vger.kernel.org>; Tue,  7 Nov 2023 02:56:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D88D183
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 18:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699325816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5e1SJnHHqoxy9KVnIU/jX5hue/azt1vU+8WuvtC+pDY=;
	b=fnqjbwK7ekiZFm4NcvTQgNbeAxQZmv3VHH05DwMbqmicNrwi4o2flekzKNQLG63srVIclp
	Z2HmfEAHYJ4izpmc9rmmq1SKaqNeUeBo1kNff8uPDHqICi6nZvRJxGlWMSXnwaCvJbsRYO
	hFICGUbg14wZ97LdCCQprqJlHBMEzEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-UK_8HJnOPwm-n3s7jCl_lQ-1; Mon, 06 Nov 2023 21:56:51 -0500
X-MC-Unique: UK_8HJnOPwm-n3s7jCl_lQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27CCD101A550;
	Tue,  7 Nov 2023 02:56:51 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CCB1C1596F;
	Tue,  7 Nov 2023 02:56:46 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: try to allocate a smaller extent map for sparse read
Date: Tue,  7 Nov 2023 10:54:23 +0800
Message-ID: <20231107025423.302404-3-xiubli@redhat.com>
In-Reply-To: <20231107025423.302404-1-xiubli@redhat.com>
References: <20231107025423.302404-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Xiubo Li <xiubli@redhat.com>

In fscrypt case and for a smaller read length we can predict the
max count of the extent map. And for small read length use cases
this could save some memories.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c  |  4 +++-
 fs/ceph/file.c  |  8 ++++++--
 fs/ceph/super.h | 14 ++++++++++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 63cb78fabebf..4bb19596e339 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -357,6 +357,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	u64 len = subreq->len;
 	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
 	u64 off = subreq->start;
+	int extent_cnt = 0;
 
 	if (ceph_inode_is_shutdown(inode)) {
 		err = -EIO;
@@ -379,7 +380,8 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	}
 
 	if (sparse) {
-		err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
+		extent_cnt = __ceph_sparse_read_ext_count(inode, len);
+		err = ceph_alloc_sparse_ext_map(&req->r_ops[0], extent_cnt);
 		if (err)
 			goto out;
 	}
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 53789c5f2ebb..227fc226227b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1028,6 +1028,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		struct ceph_osd_req_op *op;
 		u64 read_off = off;
 		u64 read_len = len;
+		int extent_cnt;
 
 		/* determine new offset/length if encrypted */
 		ceph_fscrypt_adjust_off_and_len(inode, &read_off, &read_len);
@@ -1067,7 +1068,8 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 
 		op = &req->r_ops[0];
 		if (sparse) {
-			ret = ceph_alloc_sparse_ext_map(op);
+			extent_cnt = __ceph_sparse_read_ext_count(inode, read_len);
+			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
 			if (ret) {
 				ceph_osdc_put_request(req);
 				break;
@@ -1464,6 +1466,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		ssize_t len;
 		struct ceph_osd_req_op *op;
 		int readop = sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ;
+		int extent_cnt;
 
 		if (write)
 			size = min_t(u64, size, fsc->mount_options->wsize);
@@ -1527,7 +1530,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
 		op = &req->r_ops[0];
 		if (sparse) {
-			ret = ceph_alloc_sparse_ext_map(op);
+			extent_cnt = __ceph_sparse_read_ext_count(inode, size);
+			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
 			if (ret) {
 				ceph_osdc_put_request(req);
 				break;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 7f4b62182a5d..f418b43d0e05 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -3,6 +3,7 @@
 #define _FS_CEPH_SUPER_H
 
 #include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/osd_client.h>
 
 #include <asm/unaligned.h>
 #include <linux/backing-dev.h>
@@ -1410,6 +1411,19 @@ static inline void __ceph_update_quota(struct ceph_inode_info *ci,
 		ceph_adjust_quota_realms_count(&ci->netfs.inode, has_quota);
 }
 
+static inline int __ceph_sparse_read_ext_count(struct inode *inode, u64 len)
+{
+	int cnt = 0;
+
+	if (IS_ENCRYPTED(inode)) {
+		cnt = len >> CEPH_FSCRYPT_BLOCK_SHIFT;
+		if (cnt > CEPH_SPARSE_EXT_ARRAY_INITIAL)
+			cnt = 0;
+	}
+
+	return cnt;
+}
+
 extern void ceph_handle_quota(struct ceph_mds_client *mdsc,
 			      struct ceph_mds_session *session,
 			      struct ceph_msg *msg);
-- 
2.41.0


