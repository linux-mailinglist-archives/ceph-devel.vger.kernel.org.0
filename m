Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E6D5523A
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731613AbfFYOlV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36354 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730925AbfFYOlV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so16989786wrs.3
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PY1iG4ZApMiK2oqW/oz2XZSAfCRbFDK3sQtPxnkSvLo=;
        b=AIdQjAlA6wWjS3adHK9YRO74svLgsHUX21GqEHQtrogi4K6JlVYl+f79gK3OURSfPh
         oqOQs+qL8Pr9sSQz1wKXmoG3DCeYXrKX4y46f3MVUoKnVZfHqJoUL+nOw8U7Ys3SRhCg
         UL3wQ27yYyQ7lCWe67OgPdmzMapyQUFfbs9uHE2BVLsrRXBUXQisqNtS4t+TpPfP8KJm
         75CIsz/imTYpF8sq7DI8P9V12ZW9dYmU+lTtFzmxsosN/Mxu4l2PBcubv148YdC3SHXb
         szsnbq12GWKt5c7EtGs5Onuj+hRC+7NRUxJ/B5h/KwMOa66yJIlvAOSoR/UBMnrjDhOl
         JA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PY1iG4ZApMiK2oqW/oz2XZSAfCRbFDK3sQtPxnkSvLo=;
        b=ZcAaPong+Rli1O04nhPNPSoqd66drKKSBMm+jjiNWrw0XdD1FqJLBmF5bd2pUFU6g9
         XeCamwvj0EnzC6/8QcividdLNIAxFqlMU+3KFlg1tQN49c63d0lhhSV7wiS2mPt8KDOk
         ZqQ3PcOa8kRbNT0mVoXMfOLJCN23sqkQ538yVSd2ZZJ5Feqm/HgMcoT/lQjV8ly1rzQ6
         ZhsMyHyaX4pvNgy9feKj54JKVZxxxXCCkKOF1LMOJJg/Zl9iOTKGZ5VVF6SzksySQYyh
         TF27gH6bYR/5lsgxKPglsjoGuyhscG2WYfY1uSD+Iy+FdHTvSBFMWzVflBP/WI7L2e76
         OZGg==
X-Gm-Message-State: APjAAAWa4jCHk9Ls/rZzqC20p0bOV01Emss4bToXc8DsCYS55YbWBLED
        iNErzpyM3XTinySQyIh2SG9NML9tiH4=
X-Google-Smtp-Source: APXvYqxpiW/cJar2ar/WFpLaxL1cWtdTKQcoyU5wrLlgYUtl+ADmH7stkwqMnvjJmJairZEU8qf/Mg==
X-Received: by 2002:a5d:46ce:: with SMTP id g14mr1647063wrs.203.1561473679018;
        Tue, 25 Jun 2019 07:41:19 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:18 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 11/20] rbd: introduce copyup state machine
Date:   Tue, 25 Jun 2019 16:41:02 +0200
Message-Id: <20190625144111.11270-12-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Both write and copyup paths will get more complex with object map.
Factor copyup code out into a separate state machine.

While at it, take advantage of obj_req->osd_reqs list and issue empty
and current snapc OSD requests together, one after another.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 187 +++++++++++++++++++++++++++++---------------
 1 file changed, 123 insertions(+), 64 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 2bafdee61dbd..34bd45d336e6 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -226,6 +226,7 @@ enum obj_operation_type {
 
 #define RBD_OBJ_FLAG_DELETION			(1U << 0)
 #define RBD_OBJ_FLAG_COPYUP_ENABLED		(1U << 1)
+#define RBD_OBJ_FLAG_COPYUP_ZEROS		(1U << 2)
 
 enum rbd_obj_read_state {
 	RBD_OBJ_READ_START = 1,
@@ -261,9 +262,15 @@ enum rbd_obj_read_state {
 enum rbd_obj_write_state {
 	RBD_OBJ_WRITE_START = 1,
 	RBD_OBJ_WRITE_OBJECT,
-	RBD_OBJ_WRITE_READ_FROM_PARENT,
-	RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC,
-	RBD_OBJ_WRITE_COPYUP_OPS,
+	__RBD_OBJ_WRITE_COPYUP,
+	RBD_OBJ_WRITE_COPYUP,
+};
+
+enum rbd_obj_copyup_state {
+	RBD_OBJ_COPYUP_START = 1,
+	RBD_OBJ_COPYUP_READ_PARENT,
+	__RBD_OBJ_COPYUP_WRITE_OBJECT,
+	RBD_OBJ_COPYUP_WRITE_OBJECT,
 };
 
 struct rbd_obj_request {
@@ -286,12 +293,15 @@ struct rbd_obj_request {
 			u32			bvec_idx;
 		};
 	};
+
+	enum rbd_obj_copyup_state copyup_state;
 	struct bio_vec		*copyup_bvecs;
 	u32			copyup_bvec_count;
 
 	struct list_head	osd_reqs;	/* w/ r_unsafe_item */
 
 	struct mutex		state_mutex;
+	struct pending_result	pending;
 	struct kref		kref;
 };
 
@@ -2568,8 +2578,8 @@ static bool is_zero_bvecs(struct bio_vec *bvecs, u32 bytes)
 
 #define MODS_ONLY	U32_MAX
 
-static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
-					    u32 bytes)
+static int rbd_obj_copyup_empty_snapc(struct rbd_obj_request *obj_req,
+				      u32 bytes)
 {
 	struct ceph_osd_request *osd_req;
 	int ret;
@@ -2595,7 +2605,8 @@ static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
 	return 0;
 }
 
-static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
+static int rbd_obj_copyup_current_snapc(struct rbd_obj_request *obj_req,
+					u32 bytes)
 {
 	struct ceph_osd_request *osd_req;
 	int num_ops = count_write_ops(obj_req);
@@ -2628,33 +2639,6 @@ static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
 	return 0;
 }
 
-static int rbd_obj_issue_copyup(struct rbd_obj_request *obj_req, u32 bytes)
-{
-	/*
-	 * Only send non-zero copyup data to save some I/O and network
-	 * bandwidth -- zero copyup data is equivalent to the object not
-	 * existing.
-	 */
-	if (is_zero_bvecs(obj_req->copyup_bvecs, bytes)) {
-		dout("%s obj_req %p detected zeroes\n", __func__, obj_req);
-		bytes = 0;
-	}
-
-	if (obj_req->img_request->snapc->num_snaps && bytes > 0) {
-		/*
-		 * Send a copyup request with an empty snapshot context to
-		 * deep-copyup the object through all existing snapshots.
-		 * A second request with the current snapshot context will be
-		 * sent for the actual modification.
-		 */
-		obj_req->write_state = RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC;
-		return rbd_obj_issue_copyup_empty_snapc(obj_req, bytes);
-	}
-
-	obj_req->write_state = RBD_OBJ_WRITE_COPYUP_OPS;
-	return rbd_obj_issue_copyup_ops(obj_req, bytes);
-}
-
 static int setup_copyup_bvecs(struct rbd_obj_request *obj_req, u64 obj_overlap)
 {
 	u32 i;
@@ -2688,7 +2672,7 @@ static int setup_copyup_bvecs(struct rbd_obj_request *obj_req, u64 obj_overlap)
  * target object up to the overlap point (if any) from the parent,
  * so we can use it for a copyup.
  */
-static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
+static int rbd_obj_copyup_read_parent(struct rbd_obj_request *obj_req)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	int ret;
@@ -2703,22 +2687,111 @@ static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
 		 * request -- pass MODS_ONLY since the copyup isn't needed
 		 * anymore.
 		 */
-		obj_req->write_state = RBD_OBJ_WRITE_COPYUP_OPS;
-		return rbd_obj_issue_copyup_ops(obj_req, MODS_ONLY);
+		return rbd_obj_copyup_current_snapc(obj_req, MODS_ONLY);
 	}
 
 	ret = setup_copyup_bvecs(obj_req, rbd_obj_img_extents_bytes(obj_req));
 	if (ret)
 		return ret;
 
-	obj_req->write_state = RBD_OBJ_WRITE_READ_FROM_PARENT;
 	return rbd_obj_read_from_parent(obj_req);
 }
 
+static void rbd_obj_copyup_write_object(struct rbd_obj_request *obj_req)
+{
+	u32 bytes = rbd_obj_img_extents_bytes(obj_req);
+	int ret;
+
+	rbd_assert(!obj_req->pending.result && !obj_req->pending.num_pending);
+
+	/*
+	 * Only send non-zero copyup data to save some I/O and network
+	 * bandwidth -- zero copyup data is equivalent to the object not
+	 * existing.
+	 */
+	if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ZEROS)
+		bytes = 0;
+
+	if (obj_req->img_request->snapc->num_snaps && bytes > 0) {
+		/*
+		 * Send a copyup request with an empty snapshot context to
+		 * deep-copyup the object through all existing snapshots.
+		 * A second request with the current snapshot context will be
+		 * sent for the actual modification.
+		 */
+		ret = rbd_obj_copyup_empty_snapc(obj_req, bytes);
+		if (ret) {
+			obj_req->pending.result = ret;
+			return;
+		}
+
+		obj_req->pending.num_pending++;
+		bytes = MODS_ONLY;
+	}
+
+	ret = rbd_obj_copyup_current_snapc(obj_req, bytes);
+	if (ret) {
+		obj_req->pending.result = ret;
+		return;
+	}
+
+	obj_req->pending.num_pending++;
+}
+
+static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
+{
+	int ret;
+
+again:
+	switch (obj_req->copyup_state) {
+	case RBD_OBJ_COPYUP_START:
+		rbd_assert(!*result);
+
+		ret = rbd_obj_copyup_read_parent(obj_req);
+		if (ret) {
+			*result = ret;
+			return true;
+		}
+		if (obj_req->num_img_extents)
+			obj_req->copyup_state = RBD_OBJ_COPYUP_READ_PARENT;
+		else
+			obj_req->copyup_state = RBD_OBJ_COPYUP_WRITE_OBJECT;
+		return false;
+	case RBD_OBJ_COPYUP_READ_PARENT:
+		if (*result)
+			return true;
+
+		if (is_zero_bvecs(obj_req->copyup_bvecs,
+				  rbd_obj_img_extents_bytes(obj_req))) {
+			dout("%s %p detected zeros\n", __func__, obj_req);
+			obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ZEROS;
+		}
+
+		rbd_obj_copyup_write_object(obj_req);
+		if (!obj_req->pending.num_pending) {
+			*result = obj_req->pending.result;
+			obj_req->copyup_state = RBD_OBJ_COPYUP_WRITE_OBJECT;
+			goto again;
+		}
+		obj_req->copyup_state = __RBD_OBJ_COPYUP_WRITE_OBJECT;
+		return false;
+	case __RBD_OBJ_COPYUP_WRITE_OBJECT:
+		if (!pending_result_dec(&obj_req->pending, result))
+			return false;
+		/* fall through */
+	case RBD_OBJ_COPYUP_WRITE_OBJECT:
+		return true;
+	default:
+		BUG();
+	}
+}
+
 static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
 {
+	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	int ret;
 
+again:
 	switch (obj_req->write_state) {
 	case RBD_OBJ_WRITE_START:
 		rbd_assert(!*result);
@@ -2733,12 +2806,10 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
 	case RBD_OBJ_WRITE_OBJECT:
 		if (*result == -ENOENT) {
 			if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
-				ret = rbd_obj_handle_write_guard(obj_req);
-				if (ret) {
-					*result = ret;
-					return true;
-				}
-				return false;
+				*result = 0;
+				obj_req->copyup_state = RBD_OBJ_COPYUP_START;
+				obj_req->write_state = __RBD_OBJ_WRITE_COPYUP;
+				goto again;
 			}
 			/*
 			 * On a non-existent object:
@@ -2747,31 +2818,19 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
 			if (obj_req->flags & RBD_OBJ_FLAG_DELETION)
 				*result = 0;
 		}
-		/* fall through */
-	case RBD_OBJ_WRITE_COPYUP_OPS:
-		return true;
-	case RBD_OBJ_WRITE_READ_FROM_PARENT:
 		if (*result)
 			return true;
 
-		ret = rbd_obj_issue_copyup(obj_req,
-					   rbd_obj_img_extents_bytes(obj_req));
-		if (ret) {
-			*result = ret;
-			return true;
-		}
-		return false;
-	case RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC:
+		obj_req->write_state = RBD_OBJ_WRITE_COPYUP;
+		goto again;
+	case __RBD_OBJ_WRITE_COPYUP:
+		if (!rbd_obj_advance_copyup(obj_req, result))
+			return false;
+		/* fall through */
+	case RBD_OBJ_WRITE_COPYUP:
 		if (*result)
-			return true;
-
-		obj_req->write_state = RBD_OBJ_WRITE_COPYUP_OPS;
-		ret = rbd_obj_issue_copyup_ops(obj_req, MODS_ONLY);
-		if (ret) {
-			*result = ret;
-			return true;
-		}
-		return false;
+			rbd_warn(rbd_dev, "copyup failed: %d", *result);
+		return true;
 	default:
 		BUG();
 	}
-- 
2.19.2

