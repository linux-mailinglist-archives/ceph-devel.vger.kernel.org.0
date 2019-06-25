Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEFF55233
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfFYOlP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38091 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730758AbfFYOlO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so3245303wmj.3
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hjiKF6W5YArRGMlIr6RuVtD15rOklVYGBYBVGE8NRJE=;
        b=V3+LLvR30bDvK+Z7JpXkV4dPhMdvMCWXKp90ZDsg8c7sY01uqOh/sgKK1g4INquJoA
         brX4yBEE1C6n4IeXYPC0j02BUDjgwvZpTXzxLwofNOQk4JwYAMuAspZXfch+C2SWktSW
         FWmxtrZMoS7SzzvsjXAMK8FAu2EBNlGWDxAeQ6g0GuCModLHOowa2j6qI2QhoBUFpK8e
         tiEOcFNIYWKWK2xskV0EO3rQW1DivFxSIQ0A5haYYRyGwZjwtxNyWI/Ox2zRJ4GSE4L0
         5qxQGRxMoRlhOs2/aMIthuTwzXZW1zai3wzr1Tw1cf5JI5+GEB4MiSWtpZ2GVZ9u6PH6
         r2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hjiKF6W5YArRGMlIr6RuVtD15rOklVYGBYBVGE8NRJE=;
        b=dXHAnFD9RLB+yscIO7fQIo8V4GaqTo7rgaNZZUqdo74p8vuQVFjH4fdBLGarPR+g5F
         2S5yVAUkBd/e2e0VAFm47vBpgs+do19EUz6fn2s/dxHVVfUueRo8Fq/qtHxQC/kSe7nE
         g76DzcsDFBlTO7HDoP+lr/0HlxyG2DWEw1jwv5XMHBZWwg8ni4Q/iRfvagLQVUPcm9Mb
         3C2Qk0GHCCuHsQQW6m1sAJgrXQNeLMk5HlgcPBkNEUuHCht5kJE8se3JGn0eF9hI6A99
         e0FNj9ch7zyLrOaElhfXOSaVUGgggZrJHFfIT8Am7+2tO5rap2Nkei/y5B1TWgZbvm2O
         FWVw==
X-Gm-Message-State: APjAAAVSBr638udd1MFxQjRv3ZjI+UW0Rjd3pFceaZR3NM1MkyvWyiSs
        CmVbWB3o4Pxb2YEbactoz2b0EuZW0q8=
X-Google-Smtp-Source: APXvYqzFsU//I1E/GcdWZI+LfzLSvqSuJOtEVOK4LPGWn3HeMzEKJGX/sacDFNeCGCI6lzUd68movw==
X-Received: by 2002:a1c:e341:: with SMTP id a62mr20858748wmh.165.1561473670238;
        Tue, 25 Jun 2019 07:41:10 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:09 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 03/20] rbd: get rid of RBD_OBJ_WRITE_{FLAT,GUARD}
Date:   Tue, 25 Jun 2019 16:40:54 +0200
Message-Id: <20190625144111.11270-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In preparation for moving OSD request allocation and submission into
object request state machines, get rid of RBD_OBJ_WRITE_{FLAT,GUARD}.
We would need to start in a new state, whether the request is guarded
or not.  Unify them into RBD_OBJ_WRITE_OBJECT and pass guard info
through obj_req->flags.

While at it, make our ENOENT handling a little more precise: only hide
ENOENT when it is actually expected, that is on delete.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 112 ++++++++++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 52 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 7925b2fdde79..488da877a2bb 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -219,6 +219,9 @@ enum obj_operation_type {
 	OBJ_OP_ZEROOUT,
 };
 
+#define RBD_OBJ_FLAG_DELETION			(1U << 0)
+#define RBD_OBJ_FLAG_COPYUP_ENABLED		(1U << 1)
+
 enum rbd_obj_read_state {
 	RBD_OBJ_READ_OBJECT = 1,
 	RBD_OBJ_READ_PARENT,
@@ -250,8 +253,7 @@ enum rbd_obj_read_state {
  * even if there is a parent).
  */
 enum rbd_obj_write_state {
-	RBD_OBJ_WRITE_FLAT = 1,
-	RBD_OBJ_WRITE_GUARD,
+	RBD_OBJ_WRITE_OBJECT = 1,
 	RBD_OBJ_WRITE_READ_FROM_PARENT,
 	RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC,
 	RBD_OBJ_WRITE_COPYUP_OPS,
@@ -259,6 +261,7 @@ enum rbd_obj_write_state {
 
 struct rbd_obj_request {
 	struct ceph_object_extent ex;
+	unsigned int		flags;	/* RBD_OBJ_FLAG_* */
 	union {
 		enum rbd_obj_read_state	 read_state;	/* for reads */
 		enum rbd_obj_write_state write_state;	/* for writes */
@@ -1858,7 +1861,6 @@ static void __rbd_obj_setup_write(struct rbd_obj_request *obj_req,
 static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
 {
 	unsigned int num_osd_ops, which = 0;
-	bool need_guard;
 	int ret;
 
 	/* reverse map the entire object onto the parent */
@@ -1866,23 +1868,24 @@ static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
 	if (ret)
 		return ret;
 
-	need_guard = rbd_obj_copyup_enabled(obj_req);
-	num_osd_ops = need_guard + count_write_ops(obj_req);
+	if (rbd_obj_copyup_enabled(obj_req))
+		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
+
+	num_osd_ops = count_write_ops(obj_req);
+	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
+		num_osd_ops++; /* stat */
 
 	obj_req->osd_req = rbd_osd_req_create(obj_req, num_osd_ops);
 	if (!obj_req->osd_req)
 		return -ENOMEM;
 
-	if (need_guard) {
+	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
 		ret = __rbd_obj_setup_stat(obj_req, which++);
 		if (ret)
 			return ret;
-
-		obj_req->write_state = RBD_OBJ_WRITE_GUARD;
-	} else {
-		obj_req->write_state = RBD_OBJ_WRITE_FLAT;
 	}
 
+	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
 	__rbd_obj_setup_write(obj_req, which);
 	return 0;
 }
@@ -1921,11 +1924,15 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
 	if (ret)
 		return ret;
 
+	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents)
+		obj_req->flags |= RBD_OBJ_FLAG_DELETION;
+
 	obj_req->osd_req = rbd_osd_req_create(obj_req, 1);
 	if (!obj_req->osd_req)
 		return -ENOMEM;
 
 	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents) {
+		rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
 		osd_req_op_init(obj_req->osd_req, 0, CEPH_OSD_OP_DELETE, 0);
 	} else {
 		dout("%s %p %llu~%llu -> %llu~%llu\n", __func__,
@@ -1936,7 +1943,7 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
 				       off, next_off - off, 0, 0);
 	}
 
-	obj_req->write_state = RBD_OBJ_WRITE_FLAT;
+	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
 	rbd_osd_req_format_write(obj_req);
 	return 0;
 }
@@ -1961,11 +1968,12 @@ static void __rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req,
 
 	if (rbd_obj_is_entire(obj_req)) {
 		if (obj_req->num_img_extents) {
-			if (!rbd_obj_copyup_enabled(obj_req))
+			if (!(obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED))
 				osd_req_op_init(obj_req->osd_req, which++,
 						CEPH_OSD_OP_CREATE, 0);
 			opcode = CEPH_OSD_OP_TRUNCATE;
 		} else {
+			rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
 			osd_req_op_init(obj_req->osd_req, which++,
 					CEPH_OSD_OP_DELETE, 0);
 			opcode = 0;
@@ -1986,7 +1994,6 @@ static void __rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req,
 static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
 {
 	unsigned int num_osd_ops, which = 0;
-	bool need_guard;
 	int ret;
 
 	/* reverse map the entire object onto the parent */
@@ -1994,23 +2001,28 @@ static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
 	if (ret)
 		return ret;
 
-	need_guard = rbd_obj_copyup_enabled(obj_req);
-	num_osd_ops = need_guard + count_zeroout_ops(obj_req);
+	if (rbd_obj_copyup_enabled(obj_req))
+		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
+	if (!obj_req->num_img_extents) {
+		if (rbd_obj_is_entire(obj_req))
+			obj_req->flags |= RBD_OBJ_FLAG_DELETION;
+	}
+
+	num_osd_ops = count_zeroout_ops(obj_req);
+	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED)
+		num_osd_ops++; /* stat */
 
 	obj_req->osd_req = rbd_osd_req_create(obj_req, num_osd_ops);
 	if (!obj_req->osd_req)
 		return -ENOMEM;
 
-	if (need_guard) {
+	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
 		ret = __rbd_obj_setup_stat(obj_req, which++);
 		if (ret)
 			return ret;
-
-		obj_req->write_state = RBD_OBJ_WRITE_GUARD;
-	} else {
-		obj_req->write_state = RBD_OBJ_WRITE_FLAT;
 	}
 
+	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
 	__rbd_obj_setup_zeroout(obj_req, which);
 	return 0;
 }
@@ -2617,6 +2629,11 @@ static int setup_copyup_bvecs(struct rbd_obj_request *obj_req, u64 obj_overlap)
 	return 0;
 }
 
+/*
+ * The target object doesn't exist.  Read the data for the entire
+ * target object up to the overlap point (if any) from the parent,
+ * so we can use it for a copyup.
+ */
 static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
@@ -2649,22 +2666,24 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
 	int ret;
 
 	switch (obj_req->write_state) {
-	case RBD_OBJ_WRITE_GUARD:
+	case RBD_OBJ_WRITE_OBJECT:
 		if (*result == -ENOENT) {
+			if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
+				ret = rbd_obj_handle_write_guard(obj_req);
+				if (ret) {
+					*result = ret;
+					return true;
+				}
+				return false;
+			}
 			/*
-			 * The target object doesn't exist.  Read the data for
-			 * the entire target object up to the overlap point (if
-			 * any) from the parent, so we can use it for a copyup.
+			 * On a non-existent object:
+			 *   delete - -ENOENT, truncate/zero - 0
 			 */
-			ret = rbd_obj_handle_write_guard(obj_req);
-			if (ret) {
-				*result = ret;
-				return true;
-			}
-			return false;
+			if (obj_req->flags & RBD_OBJ_FLAG_DELETION)
+				*result = 0;
 		}
 		/* fall through */
-	case RBD_OBJ_WRITE_FLAT:
 	case RBD_OBJ_WRITE_COPYUP_OPS:
 		return true;
 	case RBD_OBJ_WRITE_READ_FROM_PARENT:
@@ -2695,31 +2714,20 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
 }
 
 /*
- * Returns true if @obj_req is completed, or false otherwise.
+ * Return true if @obj_req is completed.
  */
 static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
 				     int *result)
 {
-	switch (obj_req->img_request->op_type) {
-	case OBJ_OP_READ:
-		return rbd_obj_handle_read(obj_req, result);
-	case OBJ_OP_WRITE:
-		return rbd_obj_handle_write(obj_req, result);
-	case OBJ_OP_DISCARD:
-	case OBJ_OP_ZEROOUT:
-		if (rbd_obj_handle_write(obj_req, result)) {
-			/*
-			 * Hide -ENOENT from delete/truncate/zero -- discarding
-			 * a non-existent object is not a problem.
-			 */
-			if (*result == -ENOENT)
-				*result = 0;
-			return true;
-		}
-		return false;
-	default:
-		BUG();
-	}
+	struct rbd_img_request *img_req = obj_req->img_request;
+	bool done;
+
+	if (!rbd_img_is_write(img_req))
+		done = rbd_obj_handle_read(obj_req, result);
+	else
+		done = rbd_obj_handle_write(obj_req, result);
+
+	return done;
 }
 
 static void rbd_obj_end_request(struct rbd_obj_request *obj_req, int result)
-- 
2.19.2

