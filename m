Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA9E1B277F
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgDUNTL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:50042 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgDUNTB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D205EAD79;
        Tue, 21 Apr 2020 13:18:56 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 03/16] libceph,rbd,cephfs: switch from ceph_osd_data to ceph_msg_data
Date:   Tue, 21 Apr 2020 15:18:37 +0200
Message-Id: <20200421131850.443228-4-rpenyaev@suse.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200421131850.443228-1-rpenyaev@suse.de>
References: <20200421131850.443228-1-rpenyaev@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is just a blind replacement from ceph_osd_data API to
ceph_msg_data.  In the next patch ceph_osd_data will be removed.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 drivers/block/rbd.c             |   4 +-
 fs/ceph/addr.c                  |  10 +--
 fs/ceph/file.c                  |   4 +-
 include/linux/ceph/osd_client.h |  24 +++---
 net/ceph/osd_client.c           | 145 ++++++++++++++++----------------
 5 files changed, 95 insertions(+), 92 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 67d65ac785e9..eddde641a615 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1971,7 +1971,7 @@ static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
 					struct ceph_osd_request *osd_req)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 	u64 objno;
 	u8 state, new_state, uninitialized_var(current_state);
 	bool has_current_state;
@@ -1991,7 +1991,7 @@ static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
 	 */
 	rbd_assert(osd_req->r_num_ops == 2);
 	osd_data = osd_req_op_data(osd_req, 1, cls, request_data);
-	rbd_assert(osd_data->type == CEPH_OSD_DATA_TYPE_PAGES);
+	rbd_assert(osd_data->type == CEPH_MSG_DATA_PAGES);
 
 	p = page_address(osd_data->pages[0]);
 	objno = ceph_decode_64(&p);
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6f4678d98df7..6021364233ba 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -299,7 +299,7 @@ static int ceph_readpage(struct file *filp, struct page *page)
 static void finish_read(struct ceph_osd_request *req)
 {
 	struct inode *inode = req->r_inode;
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 	int rc = req->r_result <= 0 ? req->r_result : 0;
 	int bytes = req->r_result >= 0 ? req->r_result : 0;
 	int num_pages;
@@ -311,7 +311,7 @@ static void finish_read(struct ceph_osd_request *req)
 
 	/* unlock all pages, zeroing any data we didn't read */
 	osd_data = osd_req_op_extent_osd_data(req, 0);
-	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
+	BUG_ON(osd_data->type != CEPH_MSG_DATA_PAGES);
 	num_pages = calc_pages_for((u64)osd_data->alignment,
 					(u64)osd_data->length);
 	for (i = 0; i < num_pages; i++) {
@@ -774,7 +774,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 {
 	struct inode *inode = req->r_inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 	struct page *page;
 	int num_pages, total_pages = 0;
 	int i, j;
@@ -809,7 +809,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 			break;
 
 		osd_data = osd_req_op_extent_osd_data(req, i);
-		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
+		BUG_ON(osd_data->type != CEPH_MSG_DATA_PAGES);
 		num_pages = calc_pages_for((u64)osd_data->alignment,
 					   (u64)osd_data->length);
 		total_pages += num_pages;
@@ -836,7 +836,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 
 			unlock_page(page);
 		}
-		dout("writepages_finish %p wrote %llu bytes cleaned %d pages\n",
+		dout("writepages_finish %p wrote %zu bytes cleaned %d pages\n",
 		     inode, osd_data->length, rc >= 0 ? num_pages : 0);
 
 		release_pages(osd_data->pages, num_pages);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index afdfca965a7f..49b35fa39bb6 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1043,9 +1043,9 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	int rc = req->r_result;
 	struct inode *inode = req->r_inode;
 	struct ceph_aio_request *aio_req = req->r_priv;
-	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
+	struct ceph_msg_data *osd_data = osd_req_op_extent_osd_data(req, 0);
 
-	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
+	BUG_ON(osd_data->type != CEPH_MSG_DATA_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
 
 	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 9d9f745b98a1..b1ec10c8a408 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -92,26 +92,26 @@ struct ceph_osd_req_op {
 	s32 rval;
 
 	union {
-		struct ceph_osd_data raw_data_in;
+		struct ceph_msg_data raw_data_in;
 		struct {
 			u64 offset, length;
 			u64 truncate_size;
 			u32 truncate_seq;
-			struct ceph_osd_data osd_data;
+			struct ceph_msg_data osd_data;
 		} extent;
 		struct {
 			u32 name_len;
 			u32 value_len;
 			__u8 cmp_op;       /* CEPH_OSD_CMPXATTR_OP_* */
 			__u8 cmp_mode;     /* CEPH_OSD_CMPXATTR_MODE_* */
-			struct ceph_osd_data osd_data;
+			struct ceph_msg_data osd_data;
 		} xattr;
 		struct {
 			const char *class_name;
 			const char *method_name;
-			struct ceph_osd_data request_info;
-			struct ceph_osd_data request_data;
-			struct ceph_osd_data response_data;
+			struct ceph_msg_data request_info;
+			struct ceph_msg_data request_data;
+			struct ceph_msg_data response_data;
 			__u8 class_len;
 			__u8 method_len;
 			u32 indata_len;
@@ -122,15 +122,15 @@ struct ceph_osd_req_op {
 			u32 gen;
 		} watch;
 		struct {
-			struct ceph_osd_data request_data;
+			struct ceph_msg_data request_data;
 		} notify_ack;
 		struct {
 			u64 cookie;
-			struct ceph_osd_data request_data;
-			struct ceph_osd_data response_data;
+			struct ceph_msg_data request_data;
+			struct ceph_msg_data response_data;
 		} notify;
 		struct {
-			struct ceph_osd_data response_data;
+			struct ceph_msg_data response_data;
 		} list_watchers;
 		struct {
 			u64 expected_object_size;
@@ -141,7 +141,7 @@ struct ceph_osd_req_op {
 			u64 src_version;
 			u8 flags;
 			u32 src_fadvise_flags;
-			struct ceph_osd_data osd_data;
+			struct ceph_msg_data osd_data;
 		} copy_from;
 	};
 };
@@ -417,7 +417,7 @@ extern void osd_req_op_extent_update(struct ceph_osd_request *osd_req,
 extern void osd_req_op_extent_dup_last(struct ceph_osd_request *osd_req,
 				       unsigned int which, u64 offset_inc);
 
-extern struct ceph_osd_data *osd_req_op_extent_osd_data(
+extern struct ceph_msg_data *osd_req_op_extent_osd_data(
 					struct ceph_osd_request *osd_req,
 					unsigned int which);
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index efe3d87b75f2..56a4d5f196b3 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -129,6 +129,7 @@ static void ceph_osd_data_init(struct ceph_osd_data *osd_data)
 /*
  * Consumes @pages if @own_pages is true.
  */
+__attribute__((unused))
 static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
 			struct page **pages, u64 length, u32 alignment,
 			bool pages_from_pool, bool own_pages)
@@ -144,6 +145,7 @@ static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
 /*
  * Consumes a ref on @pagelist.
  */
+__attribute__((unused))
 static void ceph_osd_data_pagelist_init(struct ceph_osd_data *osd_data,
 			struct ceph_pagelist *pagelist)
 {
@@ -152,6 +154,7 @@ static void ceph_osd_data_pagelist_init(struct ceph_osd_data *osd_data,
 }
 
 #ifdef CONFIG_BLOCK
+__attribute__((unused))
 static void ceph_osd_data_bio_init(struct ceph_osd_data *osd_data,
 				   struct ceph_bio_iter *bio_pos,
 				   u32 bio_length)
@@ -162,6 +165,7 @@ static void ceph_osd_data_bio_init(struct ceph_osd_data *osd_data,
 }
 #endif /* CONFIG_BLOCK */
 
+__attribute__((unused))
 static void ceph_osd_data_bvecs_init(struct ceph_osd_data *osd_data,
 				     struct ceph_bvec_iter *bvec_pos,
 				     u32 num_bvecs)
@@ -171,7 +175,7 @@ static void ceph_osd_data_bvecs_init(struct ceph_osd_data *osd_data,
 	osd_data->num_bvecs = num_bvecs;
 }
 
-static struct ceph_osd_data *
+static struct ceph_msg_data *
 osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int which)
 {
 	BUG_ON(which >= osd_req->r_num_ops);
@@ -179,7 +183,7 @@ osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int which)
 	return &osd_req->r_ops[which].raw_data_in;
 }
 
-struct ceph_osd_data *
+struct ceph_msg_data *
 osd_req_op_extent_osd_data(struct ceph_osd_request *osd_req,
 			unsigned int which)
 {
@@ -192,11 +196,11 @@ void osd_req_op_raw_data_in_pages(struct ceph_osd_request *osd_req,
 			u64 length, u32 alignment,
 			bool pages_from_pool, bool own_pages)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_raw_data_in(osd_req, which);
-	ceph_osd_data_pages_init(osd_data, pages, length, alignment,
-				pages_from_pool, own_pages);
+	ceph_msg_data_pages_init(osd_data, pages, length, alignment,
+				 pages_from_pool, own_pages);
 }
 EXPORT_SYMBOL(osd_req_op_raw_data_in_pages);
 
@@ -205,21 +209,21 @@ void osd_req_op_extent_osd_data_pages(struct ceph_osd_request *osd_req,
 			u64 length, u32 alignment,
 			bool pages_from_pool, bool own_pages)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_data(osd_req, which, extent, osd_data);
-	ceph_osd_data_pages_init(osd_data, pages, length, alignment,
-				pages_from_pool, own_pages);
+	ceph_msg_data_pages_init(osd_data, pages, length, alignment,
+				 pages_from_pool, own_pages);
 }
 EXPORT_SYMBOL(osd_req_op_extent_osd_data_pages);
 
 void osd_req_op_extent_osd_data_pagelist(struct ceph_osd_request *osd_req,
 			unsigned int which, struct ceph_pagelist *pagelist)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_data(osd_req, which, extent, osd_data);
-	ceph_osd_data_pagelist_init(osd_data, pagelist);
+	ceph_msg_data_pagelist_init(osd_data, pagelist);
 }
 EXPORT_SYMBOL(osd_req_op_extent_osd_data_pagelist);
 
@@ -229,10 +233,10 @@ void osd_req_op_extent_osd_data_bio(struct ceph_osd_request *osd_req,
 				    struct ceph_bio_iter *bio_pos,
 				    u32 bio_length)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_data(osd_req, which, extent, osd_data);
-	ceph_osd_data_bio_init(osd_data, bio_pos, bio_length);
+	ceph_msg_data_bio_init(osd_data, bio_pos, bio_length);
 }
 EXPORT_SYMBOL(osd_req_op_extent_osd_data_bio);
 #endif /* CONFIG_BLOCK */
@@ -242,14 +246,14 @@ void osd_req_op_extent_osd_data_bvecs(struct ceph_osd_request *osd_req,
 				      struct bio_vec *bvecs, u32 num_bvecs,
 				      u32 bytes)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 	struct ceph_bvec_iter it = {
 		.bvecs = bvecs,
 		.iter = { .bi_size = bytes },
 	};
 
 	osd_data = osd_req_op_data(osd_req, which, extent, osd_data);
-	ceph_osd_data_bvecs_init(osd_data, &it, num_bvecs);
+	ceph_msg_data_bvecs_init(osd_data, &it, num_bvecs);
 }
 EXPORT_SYMBOL(osd_req_op_extent_osd_data_bvecs);
 
@@ -257,10 +261,10 @@ void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_req,
 					 unsigned int which,
 					 struct ceph_bvec_iter *bvec_pos)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_data(osd_req, which, extent, osd_data);
-	ceph_osd_data_bvecs_init(osd_data, bvec_pos, 0);
+	ceph_msg_data_bvecs_init(osd_data, bvec_pos, 0);
 }
 EXPORT_SYMBOL(osd_req_op_extent_osd_data_bvec_pos);
 
@@ -268,20 +272,20 @@ static void osd_req_op_cls_request_info_pagelist(
 			struct ceph_osd_request *osd_req,
 			unsigned int which, struct ceph_pagelist *pagelist)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_data(osd_req, which, cls, request_info);
-	ceph_osd_data_pagelist_init(osd_data, pagelist);
+	ceph_msg_data_pagelist_init(osd_data, pagelist);
 }
 
 void osd_req_op_cls_request_data_pagelist(
 			struct ceph_osd_request *osd_req,
 			unsigned int which, struct ceph_pagelist *pagelist)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_data(osd_req, which, cls, request_data);
-	ceph_osd_data_pagelist_init(osd_data, pagelist);
+	ceph_msg_data_pagelist_init(osd_data, pagelist);
 	osd_req->r_ops[which].cls.indata_len += pagelist->length;
 	osd_req->r_ops[which].indata_len += pagelist->length;
 }
@@ -291,11 +295,11 @@ void osd_req_op_cls_request_data_pages(struct ceph_osd_request *osd_req,
 			unsigned int which, struct page **pages, u64 length,
 			u32 alignment, bool pages_from_pool, bool own_pages)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_data(osd_req, which, cls, request_data);
-	ceph_osd_data_pages_init(osd_data, pages, length, alignment,
-				pages_from_pool, own_pages);
+	ceph_msg_data_pages_init(osd_data, pages, length, alignment,
+				 pages_from_pool, own_pages);
 	osd_req->r_ops[which].cls.indata_len += length;
 	osd_req->r_ops[which].indata_len += length;
 }
@@ -306,14 +310,14 @@ void osd_req_op_cls_request_data_bvecs(struct ceph_osd_request *osd_req,
 				       struct bio_vec *bvecs, u32 num_bvecs,
 				       u32 bytes)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 	struct ceph_bvec_iter it = {
 		.bvecs = bvecs,
 		.iter = { .bi_size = bytes },
 	};
 
 	osd_data = osd_req_op_data(osd_req, which, cls, request_data);
-	ceph_osd_data_bvecs_init(osd_data, &it, num_bvecs);
+	ceph_msg_data_bvecs_init(osd_data, &it, num_bvecs);
 	osd_req->r_ops[which].cls.indata_len += bytes;
 	osd_req->r_ops[which].indata_len += bytes;
 }
@@ -323,11 +327,11 @@ void osd_req_op_cls_response_data_pages(struct ceph_osd_request *osd_req,
 			unsigned int which, struct page **pages, u64 length,
 			u32 alignment, bool pages_from_pool, bool own_pages)
 {
-	struct ceph_osd_data *osd_data;
+	struct ceph_msg_data *osd_data;
 
 	osd_data = osd_req_op_data(osd_req, which, cls, response_data);
-	ceph_osd_data_pages_init(osd_data, pages, length, alignment,
-				pages_from_pool, own_pages);
+	ceph_msg_data_pages_init(osd_data, pages, length, alignment,
+				 pages_from_pool, own_pages);
 }
 EXPORT_SYMBOL(osd_req_op_cls_response_data_pages);
 
@@ -352,6 +356,7 @@ static u64 ceph_osd_data_length(struct ceph_osd_data *osd_data)
 	}
 }
 
+__attribute__((unused))
 static void ceph_osd_data_release(struct ceph_osd_data *osd_data)
 {
 	if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGES && osd_data->own_pages) {
@@ -378,32 +383,32 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
 	case CEPH_OSD_OP_READ:
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
-		ceph_osd_data_release(&op->extent.osd_data);
+		ceph_msg_data_release(&op->extent.osd_data);
 		break;
 	case CEPH_OSD_OP_CALL:
-		ceph_osd_data_release(&op->cls.request_info);
-		ceph_osd_data_release(&op->cls.request_data);
-		ceph_osd_data_release(&op->cls.response_data);
+		ceph_msg_data_release(&op->cls.request_info);
+		ceph_msg_data_release(&op->cls.request_data);
+		ceph_msg_data_release(&op->cls.response_data);
 		break;
 	case CEPH_OSD_OP_SETXATTR:
 	case CEPH_OSD_OP_CMPXATTR:
-		ceph_osd_data_release(&op->xattr.osd_data);
+		ceph_msg_data_release(&op->xattr.osd_data);
 		break;
 	case CEPH_OSD_OP_STAT:
-		ceph_osd_data_release(&op->raw_data_in);
+		ceph_msg_data_release(&op->raw_data_in);
 		break;
 	case CEPH_OSD_OP_NOTIFY_ACK:
-		ceph_osd_data_release(&op->notify_ack.request_data);
+		ceph_msg_data_release(&op->notify_ack.request_data);
 		break;
 	case CEPH_OSD_OP_NOTIFY:
-		ceph_osd_data_release(&op->notify.request_data);
-		ceph_osd_data_release(&op->notify.response_data);
+		ceph_msg_data_release(&op->notify.request_data);
+		ceph_msg_data_release(&op->notify.response_data);
 		break;
 	case CEPH_OSD_OP_LIST_WATCHERS:
-		ceph_osd_data_release(&op->list_watchers.response_data);
+		ceph_msg_data_release(&op->list_watchers.response_data);
 		break;
 	case CEPH_OSD_OP_COPY_FROM2:
-		ceph_osd_data_release(&op->copy_from.osd_data);
+		ceph_msg_data_release(&op->copy_from.osd_data);
 		break;
 	default:
 		break;
@@ -908,7 +913,7 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
 	op->xattr.cmp_op = cmp_op;
 	op->xattr.cmp_mode = cmp_mode;
 
-	ceph_osd_data_pagelist_init(&op->xattr.osd_data, pagelist);
+	ceph_msg_data_pagelist_init(&op->xattr.osd_data, pagelist);
 	op->indata_len = payload_len;
 	return 0;
 
@@ -953,6 +958,7 @@ void osd_req_op_alloc_hint_init(struct ceph_osd_request *osd_req,
 }
 EXPORT_SYMBOL(osd_req_op_alloc_hint_init);
 
+__attribute__((unused))
 static void ceph_osdc_msg_data_add(struct ceph_msg *msg,
 				struct ceph_osd_data *osd_data)
 {
@@ -1954,37 +1960,35 @@ static void setup_request_data(struct ceph_osd_request *req)
 		case CEPH_OSD_OP_WRITE:
 		case CEPH_OSD_OP_WRITEFULL:
 			WARN_ON(op->indata_len != op->extent.length);
-			ceph_osdc_msg_data_add(request_msg,
-					       &op->extent.osd_data);
+			ceph_msg_data_add(request_msg,
+					  &op->extent.osd_data);
 			break;
 		case CEPH_OSD_OP_SETXATTR:
 		case CEPH_OSD_OP_CMPXATTR:
 			WARN_ON(op->indata_len != op->xattr.name_len +
 						  op->xattr.value_len);
-			ceph_osdc_msg_data_add(request_msg,
-					       &op->xattr.osd_data);
+			ceph_msg_data_add(request_msg,
+					  &op->xattr.osd_data);
 			break;
 		case CEPH_OSD_OP_NOTIFY_ACK:
-			ceph_osdc_msg_data_add(request_msg,
-					       &op->notify_ack.request_data);
+			ceph_msg_data_add(request_msg,
+					  &op->notify_ack.request_data);
 			break;
 		case CEPH_OSD_OP_COPY_FROM2:
-			ceph_osdc_msg_data_add(request_msg,
-					       &op->copy_from.osd_data);
+			ceph_msg_data_add(request_msg,
+					  &op->copy_from.osd_data);
 			break;
 
 		/* reply */
 		case CEPH_OSD_OP_STAT:
-			ceph_osdc_msg_data_add(reply_msg,
-					       &op->raw_data_in);
+			ceph_msg_data_add(reply_msg, &op->raw_data_in);
 			break;
 		case CEPH_OSD_OP_READ:
-			ceph_osdc_msg_data_add(reply_msg,
-					       &op->extent.osd_data);
+			ceph_msg_data_add(reply_msg, &op->extent.osd_data);
 			break;
 		case CEPH_OSD_OP_LIST_WATCHERS:
-			ceph_osdc_msg_data_add(reply_msg,
-					       &op->list_watchers.response_data);
+			ceph_msg_data_add(reply_msg,
+					  &op->list_watchers.response_data);
 			break;
 
 		/* both */
@@ -1992,20 +1996,19 @@ static void setup_request_data(struct ceph_osd_request *req)
 			WARN_ON(op->indata_len != op->cls.class_len +
 						  op->cls.method_len +
 						  op->cls.indata_len);
-			ceph_osdc_msg_data_add(request_msg,
-					       &op->cls.request_info);
+			ceph_msg_data_add(request_msg, &op->cls.request_info);
 			/* optional, can be NONE */
-			ceph_osdc_msg_data_add(request_msg,
-					       &op->cls.request_data);
+			ceph_msg_data_add(request_msg,
+					  &op->cls.request_data);
 			/* optional, can be NONE */
-			ceph_osdc_msg_data_add(reply_msg,
-					       &op->cls.response_data);
+			ceph_msg_data_add(reply_msg,
+					  &op->cls.response_data);
 			break;
 		case CEPH_OSD_OP_NOTIFY:
-			ceph_osdc_msg_data_add(request_msg,
-					       &op->notify.request_data);
-			ceph_osdc_msg_data_add(reply_msg,
-					       &op->notify.response_data);
+			ceph_msg_data_add(request_msg,
+					  &op->notify.request_data);
+			ceph_msg_data_add(reply_msg,
+					  &op->notify.response_data);
 			break;
 		}
 	}
@@ -2944,12 +2947,12 @@ static void linger_commit_cb(struct ceph_osd_request *req)
 	lreq->committed = true;
 
 	if (!lreq->is_watch) {
-		struct ceph_osd_data *osd_data =
+		struct ceph_msg_data *osd_data =
 		    osd_req_op_data(req, 0, notify, response_data);
 		void *p = page_address(osd_data->pages[0]);
 
 		WARN_ON(req->r_ops[0].op != CEPH_OSD_OP_NOTIFY ||
-			osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
+			osd_data->type != CEPH_MSG_DATA_PAGES);
 
 		/* make note of the notify_id */
 		if (req->r_ops[0].outdata_len >= sizeof(u64)) {
@@ -4730,7 +4733,7 @@ static int osd_req_op_notify_ack_init(struct ceph_osd_request *req, int which,
 		return -ENOMEM;
 	}
 
-	ceph_osd_data_pagelist_init(&op->notify_ack.request_data, pl);
+	ceph_msg_data_pagelist_init(&op->notify_ack.request_data, pl);
 	op->indata_len = pl->length;
 	return 0;
 }
@@ -4796,7 +4799,7 @@ static int osd_req_op_notify_init(struct ceph_osd_request *req, int which,
 		return -ENOMEM;
 	}
 
-	ceph_osd_data_pagelist_init(&op->notify.request_data, pl);
+	ceph_msg_data_pagelist_init(&op->notify.request_data, pl);
 	op->indata_len = pl->length;
 	return 0;
 }
@@ -4860,7 +4863,7 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 		ret = PTR_ERR(pages);
 		goto out_put_lreq;
 	}
-	ceph_osd_data_pages_init(osd_req_op_data(lreq->reg_req, 0, notify,
+	ceph_msg_data_pages_init(osd_req_op_data(lreq->reg_req, 0, notify,
 						 response_data),
 				 pages, PAGE_SIZE, 0, false, true);
 
@@ -5007,7 +5010,7 @@ int ceph_osdc_list_watchers(struct ceph_osd_client *osdc,
 	}
 
 	osd_req_op_init(req, 0, CEPH_OSD_OP_LIST_WATCHERS, 0);
-	ceph_osd_data_pages_init(osd_req_op_data(req, 0, list_watchers,
+	ceph_msg_data_pages_init(osd_req_op_data(req, 0, list_watchers,
 						 response_data),
 				 pages, PAGE_SIZE, 0, false, true);
 
@@ -5259,7 +5262,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 	ceph_encode_64(&p, truncate_size);
 	op->indata_len = PAGE_SIZE - (end - p);
 
-	ceph_osd_data_pages_init(&op->copy_from.osd_data, pages,
+	ceph_msg_data_pages_init(&op->copy_from.osd_data, pages,
 				 op->indata_len, 0, false, true);
 	return 0;
 }
-- 
2.24.1

