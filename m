Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614B055230
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbfFYOlL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39743 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730758AbfFYOlL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so18175313wrt.6
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yDrJLonIBJ2yVcjyU5Psh+oZg1bksaryXhyQxm2Gwug=;
        b=grBfuVkQlYIS5vX7cdQbMXBf2pV9nTOzxldF2T62cOWlwgYEmCyzAJ4Mz9wAF/UPZ1
         wMuoY7z/QU5OffIscmLOn22+jcnl2APg0dWLTUbKFFhJUXAdKwevhzP+9zW10Dfjcjo9
         jy28/lTTkHhHe1ANeSomuZ0GNTcVq8K4Pp5iRmr6fxEl5B816G90pAqA9//MO+r3J0EG
         Tq7LKo1W1a8bbnhcB+3bdeNws4XvxrY9YRGu7yMVRcPYQz3KPi+1gZRRTxQbp6smG8Wv
         UOS1Pc/h6C56HrtuFthftyB3neVBzVtuh9wMD28ryLXu1+PfjN2LMBpQcphvn9OEO0Yk
         AmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDrJLonIBJ2yVcjyU5Psh+oZg1bksaryXhyQxm2Gwug=;
        b=Mf70KM+mJvs2lQfgBmRAGT6rHpZD9JwJfLOlw+TA5zxpaWxZd5sX3WNOYmlGmZvK9w
         WMCn1voN+dqVV5MTZDZxWLUDcYeJ2l5ETODp/nxRrSOzMsn5W0f4hesr/53U8gAXMgU3
         IpghMobIfEv0HeyehM7x7DJWmgRhj/MdZ8L2hJOBu9jX8L146X20XiNdGNdy1Ul+wP5l
         Xk0eME5nBr6ApthFOu2roCmUPgF5WdEFwkq0n+OUhXACaXxhyDxwTtq3SIlW2/qBkLVB
         6o2yA51XeKc6tKRiEv4G3hMy8PFz377po2YirlgEeCVq4Xt92eBQ2AI3t0L1U2kn1RjJ
         BiWQ==
X-Gm-Message-State: APjAAAWBcljiqKCaqXTOAFI5JebeyfmFR0gImv43BMjq5UEo4Fn5sNLs
        aHmm7SxAnIbbzFH/5QLKhjzecfUP+/0=
X-Google-Smtp-Source: APXvYqyl/uZ8VQKykWBMWI6hqdpfqih8PZz4lr5a/b/IABiql22Li20RzVMSHVaSIqEZc0T4bCi4+Q==
X-Received: by 2002:a5d:46ce:: with SMTP id g14mr1646436wrs.203.1561473668190;
        Tue, 25 Jun 2019 07:41:08 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:07 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 01/20] rbd: get rid of obj_req->xferred, obj_req->result and img_req->xferred
Date:   Tue, 25 Jun 2019 16:40:52 +0200
Message-Id: <20190625144111.11270-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

obj_req->xferred and img_req->xferred don't bring any value.  The
former is used for short reads and has to be set to obj_req->ex.oe_len
after that and elsewhere.  The latter is just an aggregate.

Use result for short reads (>=0 - number of bytes read, <0 - error) and
pass it around explicitly.  No need to store it in obj_req.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 149 +++++++++++++++++---------------------------
 1 file changed, 58 insertions(+), 91 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e5009a34f9c2..a9b0b23148f9 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -276,9 +276,6 @@ struct rbd_obj_request {
 
 	struct ceph_osd_request	*osd_req;
 
-	u64			xferred;	/* bytes transferred */
-	int			result;
-
 	struct kref		kref;
 };
 
@@ -301,7 +298,6 @@ struct rbd_img_request {
 		struct rbd_obj_request	*obj_request;	/* obj req initiator */
 	};
 	spinlock_t		completion_lock;
-	u64			xferred;/* aggregate bytes transferred */
 	int			result;	/* first nonzero obj_request result */
 
 	struct list_head	object_extents;	/* obj_req.ex structs */
@@ -584,6 +580,8 @@ static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
 static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
 		u64 *snap_features);
 
+static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result);
+
 static int rbd_open(struct block_device *bdev, fmode_t mode)
 {
 	struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
@@ -1317,6 +1315,8 @@ static void zero_bvecs(struct ceph_bvec_iter *bvec_pos, u32 off, u32 bytes)
 static void rbd_obj_zero_range(struct rbd_obj_request *obj_req, u32 off,
 			       u32 bytes)
 {
+	dout("%s %p data buf %u~%u\n", __func__, obj_req, off, bytes);
+
 	switch (obj_req->img_request->data_type) {
 	case OBJ_REQUEST_BIO:
 		zero_bios(&obj_req->bio_pos, off, bytes);
@@ -1457,28 +1457,26 @@ static bool rbd_img_is_write(struct rbd_img_request *img_req)
 	}
 }
 
-static void rbd_obj_handle_request(struct rbd_obj_request *obj_req);
-
 static void rbd_osd_req_callback(struct ceph_osd_request *osd_req)
 {
 	struct rbd_obj_request *obj_req = osd_req->r_priv;
+	int result;
 
 	dout("%s osd_req %p result %d for obj_req %p\n", __func__, osd_req,
 	     osd_req->r_result, obj_req);
 	rbd_assert(osd_req == obj_req->osd_req);
 
-	obj_req->result = osd_req->r_result < 0 ? osd_req->r_result : 0;
-	if (!obj_req->result && !rbd_img_is_write(obj_req->img_request))
-		obj_req->xferred = osd_req->r_result;
+	/*
+	 * Writes aren't allowed to return a data payload.  In some
+	 * guarded write cases (e.g. stat + zero on an empty object)
+	 * a stat response makes it through, but we don't care.
+	 */
+	if (osd_req->r_result > 0 && rbd_img_is_write(obj_req->img_request))
+		result = 0;
 	else
-		/*
-		 * Writes aren't allowed to return a data payload.  In some
-		 * guarded write cases (e.g. stat + zero on an empty object)
-		 * a stat response makes it through, but we don't care.
-		 */
-		obj_req->xferred = 0;
+		result = osd_req->r_result;
 
-	rbd_obj_handle_request(obj_req);
+	rbd_obj_handle_request(obj_req, result);
 }
 
 static void rbd_osd_req_format_read(struct rbd_obj_request *obj_request)
@@ -2041,7 +2039,6 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
 		if (ret < 0)
 			return ret;
 		if (ret > 0) {
-			img_req->xferred += obj_req->ex.oe_len;
 			img_req->pending_count--;
 			rbd_img_obj_request_del(img_req, obj_req);
 			continue;
@@ -2400,17 +2397,17 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 	return 0;
 }
 
-static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req)
+static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	int ret;
 
-	if (obj_req->result == -ENOENT &&
+	if (*result == -ENOENT &&
 	    rbd_dev->parent_overlap && !obj_req->tried_parent) {
 		/* reverse map this object extent onto the parent */
 		ret = rbd_obj_calc_img_extents(obj_req, false);
 		if (ret) {
-			obj_req->result = ret;
+			*result = ret;
 			return true;
 		}
 
@@ -2418,7 +2415,7 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req)
 			obj_req->tried_parent = true;
 			ret = rbd_obj_read_from_parent(obj_req);
 			if (ret) {
-				obj_req->result = ret;
+				*result = ret;
 				return true;
 			}
 			return false;
@@ -2428,16 +2425,18 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req)
 	/*
 	 * -ENOENT means a hole in the image -- zero-fill the entire
 	 * length of the request.  A short read also implies zero-fill
-	 * to the end of the request.  In both cases we update xferred
-	 * count to indicate the whole request was satisfied.
+	 * to the end of the request.
 	 */
-	if (obj_req->result == -ENOENT ||
-	    (!obj_req->result && obj_req->xferred < obj_req->ex.oe_len)) {
-		rbd_assert(!obj_req->xferred || !obj_req->result);
-		rbd_obj_zero_range(obj_req, obj_req->xferred,
-				   obj_req->ex.oe_len - obj_req->xferred);
-		obj_req->result = 0;
-		obj_req->xferred = obj_req->ex.oe_len;
+	if (*result == -ENOENT) {
+		rbd_obj_zero_range(obj_req, 0, obj_req->ex.oe_len);
+		*result = 0;
+	} else if (*result >= 0) {
+		if (*result < obj_req->ex.oe_len)
+			rbd_obj_zero_range(obj_req, *result,
+					   obj_req->ex.oe_len - *result);
+		else
+			rbd_assert(*result == obj_req->ex.oe_len);
+		*result = 0;
 	}
 
 	return true;
@@ -2635,14 +2634,13 @@ static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
 	return rbd_obj_read_from_parent(obj_req);
 }
 
-static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
+static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
 {
 	int ret;
 
 	switch (obj_req->write_state) {
 	case RBD_OBJ_WRITE_GUARD:
-		rbd_assert(!obj_req->xferred);
-		if (obj_req->result == -ENOENT) {
+		if (*result == -ENOENT) {
 			/*
 			 * The target object doesn't exist.  Read the data for
 			 * the entire target object up to the overlap point (if
@@ -2650,7 +2648,7 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
 			 */
 			ret = rbd_obj_handle_write_guard(obj_req);
 			if (ret) {
-				obj_req->result = ret;
+				*result = ret;
 				return true;
 			}
 			return false;
@@ -2658,33 +2656,26 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
 		/* fall through */
 	case RBD_OBJ_WRITE_FLAT:
 	case RBD_OBJ_WRITE_COPYUP_OPS:
-		if (!obj_req->result)
-			/*
-			 * There is no such thing as a successful short
-			 * write -- indicate the whole request was satisfied.
-			 */
-			obj_req->xferred = obj_req->ex.oe_len;
 		return true;
 	case RBD_OBJ_WRITE_READ_FROM_PARENT:
-		if (obj_req->result)
+		if (*result < 0)
 			return true;
 
-		rbd_assert(obj_req->xferred);
-		ret = rbd_obj_issue_copyup(obj_req, obj_req->xferred);
+		rbd_assert(*result);
+		ret = rbd_obj_issue_copyup(obj_req, *result);
 		if (ret) {
-			obj_req->result = ret;
-			obj_req->xferred = 0;
+			*result = ret;
 			return true;
 		}
 		return false;
 	case RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC:
-		if (obj_req->result)
+		if (*result)
 			return true;
 
 		obj_req->write_state = RBD_OBJ_WRITE_COPYUP_OPS;
 		ret = rbd_obj_issue_copyup_ops(obj_req, MODS_ONLY);
 		if (ret) {
-			obj_req->result = ret;
+			*result = ret;
 			return true;
 		}
 		return false;
@@ -2696,24 +2687,23 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req)
 /*
  * Returns true if @obj_req is completed, or false otherwise.
  */
-static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req)
+static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
+				     int *result)
 {
 	switch (obj_req->img_request->op_type) {
 	case OBJ_OP_READ:
-		return rbd_obj_handle_read(obj_req);
+		return rbd_obj_handle_read(obj_req, result);
 	case OBJ_OP_WRITE:
-		return rbd_obj_handle_write(obj_req);
+		return rbd_obj_handle_write(obj_req, result);
 	case OBJ_OP_DISCARD:
 	case OBJ_OP_ZEROOUT:
-		if (rbd_obj_handle_write(obj_req)) {
+		if (rbd_obj_handle_write(obj_req, result)) {
 			/*
 			 * Hide -ENOENT from delete/truncate/zero -- discarding
 			 * a non-existent object is not a problem.
 			 */
-			if (obj_req->result == -ENOENT) {
-				obj_req->result = 0;
-				obj_req->xferred = obj_req->ex.oe_len;
-			}
+			if (*result == -ENOENT)
+				*result = 0;
 			return true;
 		}
 		return false;
@@ -2722,66 +2712,41 @@ static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req)
 	}
 }
 
-static void rbd_obj_end_request(struct rbd_obj_request *obj_req)
+static void rbd_obj_end_request(struct rbd_obj_request *obj_req, int result)
 {
 	struct rbd_img_request *img_req = obj_req->img_request;
 
-	rbd_assert((!obj_req->result &&
-		    obj_req->xferred == obj_req->ex.oe_len) ||
-		   (obj_req->result < 0 && !obj_req->xferred));
-	if (!obj_req->result) {
-		img_req->xferred += obj_req->xferred;
+	rbd_assert(result <= 0);
+	if (!result)
 		return;
-	}
 
-	rbd_warn(img_req->rbd_dev,
-		 "%s at objno %llu %llu~%llu result %d xferred %llu",
+	rbd_warn(img_req->rbd_dev, "%s at objno %llu %llu~%llu result %d",
 		 obj_op_name(img_req->op_type), obj_req->ex.oe_objno,
-		 obj_req->ex.oe_off, obj_req->ex.oe_len, obj_req->result,
-		 obj_req->xferred);
-	if (!img_req->result) {
-		img_req->result = obj_req->result;
-		img_req->xferred = 0;
-	}
-}
-
-static void rbd_img_end_child_request(struct rbd_img_request *img_req)
-{
-	struct rbd_obj_request *obj_req = img_req->obj_request;
-
-	rbd_assert(test_bit(IMG_REQ_CHILD, &img_req->flags));
-	rbd_assert((!img_req->result &&
-		    img_req->xferred == rbd_obj_img_extents_bytes(obj_req)) ||
-		   (img_req->result < 0 && !img_req->xferred));
-
-	obj_req->result = img_req->result;
-	obj_req->xferred = img_req->xferred;
-	rbd_img_request_put(img_req);
+		 obj_req->ex.oe_off, obj_req->ex.oe_len, result);
+	if (!img_req->result)
+		img_req->result = result;
 }
 
 static void rbd_img_end_request(struct rbd_img_request *img_req)
 {
 	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
-	rbd_assert((!img_req->result &&
-		    img_req->xferred == blk_rq_bytes(img_req->rq)) ||
-		   (img_req->result < 0 && !img_req->xferred));
 
 	blk_mq_end_request(img_req->rq,
 			   errno_to_blk_status(img_req->result));
 	rbd_img_request_put(img_req);
 }
 
-static void rbd_obj_handle_request(struct rbd_obj_request *obj_req)
+static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
 {
 	struct rbd_img_request *img_req;
 
 again:
-	if (!__rbd_obj_handle_request(obj_req))
+	if (!__rbd_obj_handle_request(obj_req, &result))
 		return;
 
 	img_req = obj_req->img_request;
 	spin_lock(&img_req->completion_lock);
-	rbd_obj_end_request(obj_req);
+	rbd_obj_end_request(obj_req, result);
 	rbd_assert(img_req->pending_count);
 	if (--img_req->pending_count) {
 		spin_unlock(&img_req->completion_lock);
@@ -2789,9 +2754,11 @@ static void rbd_obj_handle_request(struct rbd_obj_request *obj_req)
 	}
 
 	spin_unlock(&img_req->completion_lock);
+	rbd_assert(img_req->result <= 0);
 	if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
 		obj_req = img_req->obj_request;
-		rbd_img_end_child_request(img_req);
+		result = img_req->result ?: rbd_obj_img_extents_bytes(obj_req);
+		rbd_img_request_put(img_req);
 		goto again;
 	}
 	rbd_img_end_request(img_req);
-- 
2.19.2

