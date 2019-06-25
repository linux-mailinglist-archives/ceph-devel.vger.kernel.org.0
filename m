Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27EEF55238
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbfFYOlT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37584 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731513AbfFYOlS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id v14so18200545wrr.4
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yHggmNnliZX946Ynyj6VnHr1USjTsZhN6yEN2+7cZ+I=;
        b=CVepk/ErrUhVTJOaEEi8IrVicr0vpENEp3DcgqBDVJyFovcRPdgoXmtDP6K1g2pg38
         MB2ZIoIfPu2T6ddpI+mnRhTisD18X7mouDuYkHAs7uKIr2PuRFk+B7MADmOwkkJcsMRN
         7siAFmMwscohZVbGlMvreiwVn0lXn0uzho/WWnP5lxAlnh5XLW0FIlh3psamFJ3RFjWB
         Njhef472V+LTE8mYdFozPWgyFd34LT1Dlc+zda5fWP4HkpkD8R+sh63qUMHB0XREyQht
         fMjSgkmiBZxfggciMBTcMgOBFkuwsOcre0rD5/3m5cyG9mi31lXS2aDf4E2VpM4IDRw7
         K7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yHggmNnliZX946Ynyj6VnHr1USjTsZhN6yEN2+7cZ+I=;
        b=BVVEhhIkekg7s3sZqV6GWJ0P/0lgjvKvxOwgYb6gUmdfXDOpTaDNv3zDoYz0GWZc6h
         lWg6dFy+BfjipZdSW/Fnds3KqfUBBUU3Mos0tBoJmviwNIJfLLfGQQelioPa3aTTBlZw
         1Zvrut1wstQNB9iYLAmJ2ecZmbJrWWhpCSK/BZpTdmU39dhgw1VR5nFJblSKD09LYWOv
         UFss9EMbhxb9+2fCfw1/LdZFF1WM+2gX/ZCoV5EELRkrcXYanV1TdEHwR0ThBNwkhNsw
         UzLZwgE71y86/tS4GPaQcWGL0DRwzyZGAUhk5ngkjArWPps+U0DtZwjOfA939G8hPs+c
         LoIg==
X-Gm-Message-State: APjAAAVtHhaJIRBwjCYt/nm8h0BmvH35HRjuB6uNDTbXnIcVK53iTh+a
        wXw0jk+1mq1IziBDPTij13mIt0ZcWMo=
X-Google-Smtp-Source: APXvYqxAaHSuzj1Vtxbsb/cnx3O/Pu6Kii3+tDXkH8uIPlrCXXoX08IdHBlVXmXXFGFKAaiA1Wn51w==
X-Received: by 2002:adf:ec49:: with SMTP id w9mr44648185wrn.303.1561473673817;
        Tue, 25 Jun 2019 07:41:13 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:13 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 06/20] rbd: introduce obj_req->osd_reqs list
Date:   Tue, 25 Jun 2019 16:40:57 +0200
Message-Id: <20190625144111.11270-7-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Since the dawn of time it had been assumed that a single object request
spawns a single OSD request.  This is already impacting copyup: instead
of sending empty and current snapc copyups together, we wait for empty
snapc OSD request to complete in order to reassign obj_req->osd_req
with current snapc OSD request.  Looking further, updating potentially
hundreds of snapshot object maps serially is a non-starter.

Replace obj_req->osd_req pointer with obj_req->osd_reqs list.  Use
osd_req->r_unsafe_item for linkage -- it's used by the filesystem for
a similar purpose.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 191 +++++++++++++++++++++++---------------------
 1 file changed, 100 insertions(+), 91 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 51dd1b99c242..5c34fe215c63 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -289,7 +289,7 @@ struct rbd_obj_request {
 	struct bio_vec		*copyup_bvecs;
 	u32			copyup_bvec_count;
 
-	struct ceph_osd_request	*osd_req;
+	struct list_head	osd_reqs;	/* w/ r_unsafe_item */
 
 	struct mutex		state_mutex;
 	struct kref		kref;
@@ -1410,7 +1410,9 @@ static inline void rbd_img_obj_request_del(struct rbd_img_request *img_request,
 
 static void rbd_obj_request_submit(struct rbd_obj_request *obj_request)
 {
-	struct ceph_osd_request *osd_req = obj_request->osd_req;
+	struct ceph_osd_request *osd_req =
+	    list_last_entry(&obj_request->osd_reqs, struct ceph_osd_request,
+			    r_unsafe_item);
 
 	dout("%s %p object_no %016llx %llu~%llu osd_req %p\n", __func__,
 	     obj_request, obj_request->ex.oe_objno, obj_request->ex.oe_off,
@@ -1497,7 +1499,6 @@ static void rbd_osd_req_callback(struct ceph_osd_request *osd_req)
 
 	dout("%s osd_req %p result %d for obj_req %p\n", __func__, osd_req,
 	     osd_req->r_result, obj_req);
-	rbd_assert(osd_req == obj_req->osd_req);
 
 	/*
 	 * Writes aren't allowed to return a data payload.  In some
@@ -1512,17 +1513,17 @@ static void rbd_osd_req_callback(struct ceph_osd_request *osd_req)
 	rbd_obj_handle_request(obj_req, result);
 }
 
-static void rbd_osd_req_format_read(struct rbd_obj_request *obj_request)
+static void rbd_osd_format_read(struct ceph_osd_request *osd_req)
 {
-	struct ceph_osd_request *osd_req = obj_request->osd_req;
+	struct rbd_obj_request *obj_request = osd_req->r_priv;
 
 	osd_req->r_flags = CEPH_OSD_FLAG_READ;
 	osd_req->r_snapid = obj_request->img_request->snap_id;
 }
 
-static void rbd_osd_req_format_write(struct rbd_obj_request *obj_request)
+static void rbd_osd_format_write(struct ceph_osd_request *osd_req)
 {
-	struct ceph_osd_request *osd_req = obj_request->osd_req;
+	struct rbd_obj_request *obj_request = osd_req->r_priv;
 
 	osd_req->r_flags = CEPH_OSD_FLAG_WRITE;
 	ktime_get_real_ts64(&osd_req->r_mtime);
@@ -1530,19 +1531,21 @@ static void rbd_osd_req_format_write(struct rbd_obj_request *obj_request)
 }
 
 static struct ceph_osd_request *
-__rbd_osd_req_create(struct rbd_obj_request *obj_req,
-		     struct ceph_snap_context *snapc, unsigned int num_ops)
+__rbd_obj_add_osd_request(struct rbd_obj_request *obj_req,
+			  struct ceph_snap_context *snapc, int num_ops)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
 	struct ceph_osd_request *req;
 	const char *name_format = rbd_dev->image_format == 1 ?
 				      RBD_V1_DATA_FORMAT : RBD_V2_DATA_FORMAT;
+	int ret;
 
 	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, false, GFP_NOIO);
 	if (!req)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
+	list_add_tail(&req->r_unsafe_item, &obj_req->osd_reqs);
 	req->r_callback = rbd_osd_req_callback;
 	req->r_priv = obj_req;
 
@@ -1553,27 +1556,20 @@ __rbd_osd_req_create(struct rbd_obj_request *obj_req,
 	ceph_oloc_copy(&req->r_base_oloc, &rbd_dev->header_oloc);
 	req->r_base_oloc.pool = rbd_dev->layout.pool_id;
 
-	if (ceph_oid_aprintf(&req->r_base_oid, GFP_NOIO, name_format,
-			rbd_dev->header.object_prefix, obj_req->ex.oe_objno))
-		goto err_req;
+	ret = ceph_oid_aprintf(&req->r_base_oid, GFP_NOIO, name_format,
+			       rbd_dev->header.object_prefix,
+			       obj_req->ex.oe_objno);
+	if (ret)
+		return ERR_PTR(ret);
 
 	return req;
-
-err_req:
-	ceph_osdc_put_request(req);
-	return NULL;
 }
 
 static struct ceph_osd_request *
-rbd_osd_req_create(struct rbd_obj_request *obj_req, unsigned int num_ops)
+rbd_obj_add_osd_request(struct rbd_obj_request *obj_req, int num_ops)
 {
-	return __rbd_osd_req_create(obj_req, obj_req->img_request->snapc,
-				    num_ops);
-}
-
-static void rbd_osd_req_destroy(struct ceph_osd_request *osd_req)
-{
-	ceph_osdc_put_request(osd_req);
+	return __rbd_obj_add_osd_request(obj_req, obj_req->img_request->snapc,
+					 num_ops);
 }
 
 static struct rbd_obj_request *rbd_obj_request_create(void)
@@ -1585,6 +1581,7 @@ static struct rbd_obj_request *rbd_obj_request_create(void)
 		return NULL;
 
 	ceph_object_extent_init(&obj_request->ex);
+	INIT_LIST_HEAD(&obj_request->osd_reqs);
 	mutex_init(&obj_request->state_mutex);
 	kref_init(&obj_request->kref);
 
@@ -1595,14 +1592,19 @@ static struct rbd_obj_request *rbd_obj_request_create(void)
 static void rbd_obj_request_destroy(struct kref *kref)
 {
 	struct rbd_obj_request *obj_request;
+	struct ceph_osd_request *osd_req;
 	u32 i;
 
 	obj_request = container_of(kref, struct rbd_obj_request, kref);
 
 	dout("%s: obj %p\n", __func__, obj_request);
 
-	if (obj_request->osd_req)
-		rbd_osd_req_destroy(obj_request->osd_req);
+	while (!list_empty(&obj_request->osd_reqs)) {
+		osd_req = list_first_entry(&obj_request->osd_reqs,
+					struct ceph_osd_request, r_unsafe_item);
+		list_del_init(&osd_req->r_unsafe_item);
+		ceph_osdc_put_request(osd_req);
+	}
 
 	switch (obj_request->img_request->data_type) {
 	case OBJ_REQUEST_NODATA:
@@ -1796,11 +1798,13 @@ static int rbd_obj_calc_img_extents(struct rbd_obj_request *obj_req,
 	return 0;
 }
 
-static void rbd_osd_req_setup_data(struct rbd_obj_request *obj_req, u32 which)
+static void rbd_osd_setup_data(struct ceph_osd_request *osd_req, int which)
 {
+	struct rbd_obj_request *obj_req = osd_req->r_priv;
+
 	switch (obj_req->img_request->data_type) {
 	case OBJ_REQUEST_BIO:
-		osd_req_op_extent_osd_data_bio(obj_req->osd_req, which,
+		osd_req_op_extent_osd_data_bio(osd_req, which,
 					       &obj_req->bio_pos,
 					       obj_req->ex.oe_len);
 		break;
@@ -1809,7 +1813,7 @@ static void rbd_osd_req_setup_data(struct rbd_obj_request *obj_req, u32 which)
 		rbd_assert(obj_req->bvec_pos.iter.bi_size ==
 							obj_req->ex.oe_len);
 		rbd_assert(obj_req->bvec_idx == obj_req->bvec_count);
-		osd_req_op_extent_osd_data_bvec_pos(obj_req->osd_req, which,
+		osd_req_op_extent_osd_data_bvec_pos(osd_req, which,
 						    &obj_req->bvec_pos);
 		break;
 	default:
@@ -1819,21 +1823,22 @@ static void rbd_osd_req_setup_data(struct rbd_obj_request *obj_req, u32 which)
 
 static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
 {
-	obj_req->osd_req = __rbd_osd_req_create(obj_req, NULL, 1);
-	if (!obj_req->osd_req)
-		return -ENOMEM;
+	struct ceph_osd_request *osd_req;
 
-	osd_req_op_extent_init(obj_req->osd_req, 0, CEPH_OSD_OP_READ,
+	osd_req = __rbd_obj_add_osd_request(obj_req, NULL, 1);
+	if (IS_ERR(osd_req))
+		return PTR_ERR(osd_req);
+
+	osd_req_op_extent_init(osd_req, 0, CEPH_OSD_OP_READ,
 			       obj_req->ex.oe_off, obj_req->ex.oe_len, 0, 0);
-	rbd_osd_req_setup_data(obj_req, 0);
+	rbd_osd_setup_data(osd_req, 0);
 
-	rbd_osd_req_format_read(obj_req);
+	rbd_osd_format_read(osd_req);
 	obj_req->read_state = RBD_OBJ_READ_START;
 	return 0;
 }
 
-static int __rbd_obj_setup_stat(struct rbd_obj_request *obj_req,
-				unsigned int which)
+static int rbd_osd_setup_stat(struct ceph_osd_request *osd_req, int which)
 {
 	struct page **pages;
 
@@ -1849,8 +1854,8 @@ static int __rbd_obj_setup_stat(struct rbd_obj_request *obj_req,
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
-	osd_req_op_init(obj_req->osd_req, which, CEPH_OSD_OP_STAT, 0);
-	osd_req_op_raw_data_in_pages(obj_req->osd_req, which, pages,
+	osd_req_op_init(osd_req, which, CEPH_OSD_OP_STAT, 0);
+	osd_req_op_raw_data_in_pages(osd_req, which, pages,
 				     8 + sizeof(struct ceph_timespec),
 				     0, false, true);
 	return 0;
@@ -1861,13 +1866,14 @@ static int count_write_ops(struct rbd_obj_request *obj_req)
 	return 2; /* setallochint + write/writefull */
 }
 
-static void __rbd_obj_setup_write(struct rbd_obj_request *obj_req,
-				  unsigned int which)
+static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
+				      int which)
 {
+	struct rbd_obj_request *obj_req = osd_req->r_priv;
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	u16 opcode;
 
-	osd_req_op_alloc_hint_init(obj_req->osd_req, which++,
+	osd_req_op_alloc_hint_init(osd_req, which++,
 				   rbd_dev->layout.object_size,
 				   rbd_dev->layout.object_size);
 
@@ -1876,16 +1882,16 @@ static void __rbd_obj_setup_write(struct rbd_obj_request *obj_req,
 	else
 		opcode = CEPH_OSD_OP_WRITE;
 
-	osd_req_op_extent_init(obj_req->osd_req, which, opcode,
+	osd_req_op_extent_init(osd_req, which, opcode,
 			       obj_req->ex.oe_off, obj_req->ex.oe_len, 0, 0);
-	rbd_osd_req_setup_data(obj_req, which++);
+	rbd_osd_setup_data(osd_req, which);
 
-	rbd_assert(which == obj_req->osd_req->r_num_ops);
-	rbd_osd_req_format_write(obj_req);
+	rbd_osd_format_write(osd_req);
 }
 
 static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
 {
+	struct ceph_osd_request *osd_req;
 	unsigned int num_osd_ops, which = 0;
 	int ret;
 
@@ -1901,18 +1907,18 @@ static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
 	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
 		num_osd_ops++; /* stat */
 
-	obj_req->osd_req = rbd_osd_req_create(obj_req, num_osd_ops);
-	if (!obj_req->osd_req)
-		return -ENOMEM;
+	osd_req = rbd_obj_add_osd_request(obj_req, num_osd_ops);
+	if (IS_ERR(osd_req))
+		return PTR_ERR(osd_req);
 
 	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
-		ret = __rbd_obj_setup_stat(obj_req, which++);
+		ret = rbd_osd_setup_stat(osd_req, which++);
 		if (ret)
 			return ret;
 	}
 
 	obj_req->write_state = RBD_OBJ_WRITE_START;
-	__rbd_obj_setup_write(obj_req, which);
+	__rbd_osd_setup_write_ops(osd_req, which);
 	return 0;
 }
 
@@ -1925,6 +1931,7 @@ static u16 truncate_or_zero_opcode(struct rbd_obj_request *obj_req)
 static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
+	struct ceph_osd_request *osd_req;
 	u64 off = obj_req->ex.oe_off;
 	u64 next_off = obj_req->ex.oe_off + obj_req->ex.oe_len;
 	int ret;
@@ -1953,24 +1960,24 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
 	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents)
 		obj_req->flags |= RBD_OBJ_FLAG_DELETION;
 
-	obj_req->osd_req = rbd_osd_req_create(obj_req, 1);
-	if (!obj_req->osd_req)
-		return -ENOMEM;
+	osd_req = rbd_obj_add_osd_request(obj_req, 1);
+	if (IS_ERR(osd_req))
+		return PTR_ERR(osd_req);
 
 	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents) {
 		rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
-		osd_req_op_init(obj_req->osd_req, 0, CEPH_OSD_OP_DELETE, 0);
+		osd_req_op_init(osd_req, 0, CEPH_OSD_OP_DELETE, 0);
 	} else {
 		dout("%s %p %llu~%llu -> %llu~%llu\n", __func__,
 		     obj_req, obj_req->ex.oe_off, obj_req->ex.oe_len,
 		     off, next_off - off);
-		osd_req_op_extent_init(obj_req->osd_req, 0,
+		osd_req_op_extent_init(osd_req, 0,
 				       truncate_or_zero_opcode(obj_req),
 				       off, next_off - off, 0, 0);
 	}
 
 	obj_req->write_state = RBD_OBJ_WRITE_START;
-	rbd_osd_req_format_write(obj_req);
+	rbd_osd_format_write(osd_req);
 	return 0;
 }
 
@@ -1987,20 +1994,21 @@ static int count_zeroout_ops(struct rbd_obj_request *obj_req)
 	return num_osd_ops;
 }
 
-static void __rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req,
-				    unsigned int which)
+static void __rbd_osd_setup_zeroout_ops(struct ceph_osd_request *osd_req,
+					int which)
 {
+	struct rbd_obj_request *obj_req = osd_req->r_priv;
 	u16 opcode;
 
 	if (rbd_obj_is_entire(obj_req)) {
 		if (obj_req->num_img_extents) {
 			if (!(obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED))
-				osd_req_op_init(obj_req->osd_req, which++,
+				osd_req_op_init(osd_req, which++,
 						CEPH_OSD_OP_CREATE, 0);
 			opcode = CEPH_OSD_OP_TRUNCATE;
 		} else {
 			rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
-			osd_req_op_init(obj_req->osd_req, which++,
+			osd_req_op_init(osd_req, which++,
 					CEPH_OSD_OP_DELETE, 0);
 			opcode = 0;
 		}
@@ -2009,16 +2017,16 @@ static void __rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req,
 	}
 
 	if (opcode)
-		osd_req_op_extent_init(obj_req->osd_req, which++, opcode,
+		osd_req_op_extent_init(osd_req, which, opcode,
 				       obj_req->ex.oe_off, obj_req->ex.oe_len,
 				       0, 0);
 
-	rbd_assert(which == obj_req->osd_req->r_num_ops);
-	rbd_osd_req_format_write(obj_req);
+	rbd_osd_format_write(osd_req);
 }
 
 static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
 {
+	struct ceph_osd_request *osd_req;
 	unsigned int num_osd_ops, which = 0;
 	int ret;
 
@@ -2038,18 +2046,18 @@ static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
 	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
 		num_osd_ops++; /* stat */
 
-	obj_req->osd_req = rbd_osd_req_create(obj_req, num_osd_ops);
-	if (!obj_req->osd_req)
-		return -ENOMEM;
+	osd_req = rbd_obj_add_osd_request(obj_req, num_osd_ops);
+	if (IS_ERR(osd_req))
+		return PTR_ERR(osd_req);
 
 	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
-		ret = __rbd_obj_setup_stat(obj_req, which++);
+		ret = rbd_osd_setup_stat(osd_req, which++);
 		if (ret)
 			return ret;
 	}
 
 	obj_req->write_state = RBD_OBJ_WRITE_START;
-	__rbd_obj_setup_zeroout(obj_req, which);
+	__rbd_osd_setup_zeroout_ops(osd_req, which);
 	return 0;
 }
 
@@ -2061,6 +2069,7 @@ static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
 static int __rbd_img_fill_request(struct rbd_img_request *img_req)
 {
 	struct rbd_obj_request *obj_req, *next_obj_req;
+	struct ceph_osd_request *osd_req;
 	int ret;
 
 	for_each_obj_request_safe(img_req, obj_req, next_obj_req) {
@@ -2087,7 +2096,10 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
 			continue;
 		}
 
-		ret = ceph_osdc_alloc_messages(obj_req->osd_req, GFP_NOIO);
+		osd_req = list_last_entry(&obj_req->osd_reqs,
+					  struct ceph_osd_request,
+					  r_unsafe_item);
+		ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
 		if (ret)
 			return ret;
 	}
@@ -2538,28 +2550,27 @@ static bool is_zero_bvecs(struct bio_vec *bvecs, u32 bytes)
 static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
 					    u32 bytes)
 {
+	struct ceph_osd_request *osd_req;
 	int ret;
 
 	dout("%s obj_req %p bytes %u\n", __func__, obj_req, bytes);
-	rbd_assert(obj_req->osd_req->r_ops[0].op == CEPH_OSD_OP_STAT);
 	rbd_assert(bytes > 0 && bytes != MODS_ONLY);
-	rbd_osd_req_destroy(obj_req->osd_req);
 
-	obj_req->osd_req = __rbd_osd_req_create(obj_req, &rbd_empty_snapc, 1);
-	if (!obj_req->osd_req)
-		return -ENOMEM;
+	osd_req = __rbd_obj_add_osd_request(obj_req, &rbd_empty_snapc, 1);
+	if (IS_ERR(osd_req))
+		return PTR_ERR(osd_req);
 
-	ret = osd_req_op_cls_init(obj_req->osd_req, 0, "rbd", "copyup");
+	ret = osd_req_op_cls_init(osd_req, 0, "rbd", "copyup");
 	if (ret)
 		return ret;
 
-	osd_req_op_cls_request_data_bvecs(obj_req->osd_req, 0,
+	osd_req_op_cls_request_data_bvecs(osd_req, 0,
 					  obj_req->copyup_bvecs,
 					  obj_req->copyup_bvec_count,
 					  bytes);
-	rbd_osd_req_format_write(obj_req);
+	rbd_osd_format_write(osd_req);
 
-	ret = ceph_osdc_alloc_messages(obj_req->osd_req, GFP_NOIO);
+	ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
 	if (ret)
 		return ret;
 
@@ -2570,14 +2581,12 @@ static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
 static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
 {
 	struct rbd_img_request *img_req = obj_req->img_request;
+	struct ceph_osd_request *osd_req;
 	unsigned int num_osd_ops = (bytes != MODS_ONLY);
 	unsigned int which = 0;
 	int ret;
 
 	dout("%s obj_req %p bytes %u\n", __func__, obj_req, bytes);
-	rbd_assert(obj_req->osd_req->r_ops[0].op == CEPH_OSD_OP_STAT ||
-		   obj_req->osd_req->r_ops[0].op == CEPH_OSD_OP_CALL);
-	rbd_osd_req_destroy(obj_req->osd_req);
 
 	switch (img_req->op_type) {
 	case OBJ_OP_WRITE:
@@ -2590,17 +2599,17 @@ static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
 		BUG();
 	}
 
-	obj_req->osd_req = rbd_osd_req_create(obj_req, num_osd_ops);
-	if (!obj_req->osd_req)
-		return -ENOMEM;
+	osd_req = rbd_obj_add_osd_request(obj_req, num_osd_ops);
+	if (IS_ERR(osd_req))
+		return PTR_ERR(osd_req);
 
 	if (bytes != MODS_ONLY) {
-		ret = osd_req_op_cls_init(obj_req->osd_req, which, "rbd",
+		ret = osd_req_op_cls_init(osd_req, which, "rbd",
 					  "copyup");
 		if (ret)
 			return ret;
 
-		osd_req_op_cls_request_data_bvecs(obj_req->osd_req, which++,
+		osd_req_op_cls_request_data_bvecs(osd_req, which++,
 						  obj_req->copyup_bvecs,
 						  obj_req->copyup_bvec_count,
 						  bytes);
@@ -2608,16 +2617,16 @@ static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
 
 	switch (img_req->op_type) {
 	case OBJ_OP_WRITE:
-		__rbd_obj_setup_write(obj_req, which);
+		__rbd_osd_setup_write_ops(osd_req, which);
 		break;
 	case OBJ_OP_ZEROOUT:
-		__rbd_obj_setup_zeroout(obj_req, which);
+		__rbd_osd_setup_zeroout_ops(osd_req, which);
 		break;
 	default:
 		BUG();
 	}
 
-	ret = ceph_osdc_alloc_messages(obj_req->osd_req, GFP_NOIO);
+	ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
 	if (ret)
 		return ret;
 
-- 
2.19.2

