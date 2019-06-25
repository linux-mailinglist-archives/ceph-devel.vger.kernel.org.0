Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F1F55231
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbfFYOlM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34504 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFYOlM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so2450062wmd.1
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FQSup7rRjtMCyrYz7PYIx6nI6ADEVg6xf1gvoVYFCbs=;
        b=WMq8aSGF5jz/WexyoXGgZYTI4H5wim2o9QgNq50bbeb+Ov6FLbrXdkCLtegKFRcNqy
         wHKj1426lkgkODFFL7sN7KahpnALsqyAOqPgLTEH9Y14Ut+G2xK5unzjYHg1f9CJ2hOh
         Ke3nZEhdXubMeK5Vk2Sy7hBXMOSAJcYz3R6ybnFXyGvhhfb5aPYH6zjYNZ3nJ4lyk3O9
         WcC4LaPgc9G821wlDdMv91d9hhIBVHLKKEz9maahlHebqqrxFyJevKh4CrWCchFaS+hb
         isyMjUrJbTnpMehtA8api9+qxge0zV5JfsY+qqrM+YsOjddJptFoKkDAONUXSGPyfFwq
         YslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQSup7rRjtMCyrYz7PYIx6nI6ADEVg6xf1gvoVYFCbs=;
        b=D8q408G+O7qY0ZW8u3/8uq1kzTqBbpzS1MtqK6ThaChc4vt/IOh8XYEDhhoHuRV94p
         7bPk8BTZwTeOTUxefdi8ji4Tgo09PRH0QW7NwESCmq/GeYvEmDlnVjG2o7rUHNIpElTB
         4xPlcHPLsOiXmtTHBb0lAo3OZSk6qydddQEU3HZe/h2PAVfsEkfF4FUvBbwkVYhsMGsU
         /ptlolOdDtPzKE19bZKf++yUbOED9ka0u+DuGlK52XpCVPghr5n7LycBHhN2iH4uayhn
         PAqz2uXmaESONNHQxbNMhY6T8kRg1gKlDtKht2B+lQNqAlJgwGYRdZ6xuqLu0C5+Minc
         /ugg==
X-Gm-Message-State: APjAAAU64+R2+cbK7NzElzh/VeyWgqiYjdR+uBZwyFax0OhbOjbjetbX
        E0CnB9DxoVO9qc6vFEzRfT/GiK8ksvM=
X-Google-Smtp-Source: APXvYqzMVohmjo5TPCTz/CrbfKwbHThGL/hz8nzBbcwjJXfIZH6X8rQ2P1vb+2B0H4TnDxY0Sl8cAg==
X-Received: by 2002:a1c:740f:: with SMTP id p15mr20108394wmc.103.1561473669313;
        Tue, 25 Jun 2019 07:41:09 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:08 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 02/20] rbd: replace obj_req->tried_parent with obj_req->read_state
Date:   Tue, 25 Jun 2019 16:40:53 +0200
Message-Id: <20190625144111.11270-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Make rbd_obj_handle_read() look like a state machine and get rid of
the necessity to patch result in rbd_obj_handle_request(), completing
the removal of obj_req->xferred and img_req->xferred.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 82 +++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 36 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index a9b0b23148f9..7925b2fdde79 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -219,6 +219,11 @@ enum obj_operation_type {
 	OBJ_OP_ZEROOUT,
 };
 
+enum rbd_obj_read_state {
+	RBD_OBJ_READ_OBJECT = 1,
+	RBD_OBJ_READ_PARENT,
+};
+
 /*
  * Writes go through the following state machine to deal with
  * layering:
@@ -255,7 +260,7 @@ enum rbd_obj_write_state {
 struct rbd_obj_request {
 	struct ceph_object_extent ex;
 	union {
-		bool			tried_parent;	/* for reads */
+		enum rbd_obj_read_state	 read_state;	/* for reads */
 		enum rbd_obj_write_state write_state;	/* for writes */
 	};
 
@@ -1794,6 +1799,7 @@ static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
 	rbd_osd_req_setup_data(obj_req, 0);
 
 	rbd_osd_req_format_read(obj_req);
+	obj_req->read_state = RBD_OBJ_READ_OBJECT;
 	return 0;
 }
 
@@ -2402,44 +2408,48 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	int ret;
 
-	if (*result == -ENOENT &&
-	    rbd_dev->parent_overlap && !obj_req->tried_parent) {
-		/* reverse map this object extent onto the parent */
-		ret = rbd_obj_calc_img_extents(obj_req, false);
-		if (ret) {
-			*result = ret;
-			return true;
-		}
-
-		if (obj_req->num_img_extents) {
-			obj_req->tried_parent = true;
-			ret = rbd_obj_read_from_parent(obj_req);
+	switch (obj_req->read_state) {
+	case RBD_OBJ_READ_OBJECT:
+		if (*result == -ENOENT && rbd_dev->parent_overlap) {
+			/* reverse map this object extent onto the parent */
+			ret = rbd_obj_calc_img_extents(obj_req, false);
 			if (ret) {
 				*result = ret;
 				return true;
 			}
-			return false;
+			if (obj_req->num_img_extents) {
+				ret = rbd_obj_read_from_parent(obj_req);
+				if (ret) {
+					*result = ret;
+					return true;
+				}
+				obj_req->read_state = RBD_OBJ_READ_PARENT;
+				return false;
+			}
 		}
-	}
 
-	/*
-	 * -ENOENT means a hole in the image -- zero-fill the entire
-	 * length of the request.  A short read also implies zero-fill
-	 * to the end of the request.
-	 */
-	if (*result == -ENOENT) {
-		rbd_obj_zero_range(obj_req, 0, obj_req->ex.oe_len);
-		*result = 0;
-	} else if (*result >= 0) {
-		if (*result < obj_req->ex.oe_len)
-			rbd_obj_zero_range(obj_req, *result,
-					   obj_req->ex.oe_len - *result);
-		else
-			rbd_assert(*result == obj_req->ex.oe_len);
-		*result = 0;
+		/*
+		 * -ENOENT means a hole in the image -- zero-fill the entire
+		 * length of the request.  A short read also implies zero-fill
+		 * to the end of the request.
+		 */
+		if (*result == -ENOENT) {
+			rbd_obj_zero_range(obj_req, 0, obj_req->ex.oe_len);
+			*result = 0;
+		} else if (*result >= 0) {
+			if (*result < obj_req->ex.oe_len)
+				rbd_obj_zero_range(obj_req, *result,
+						obj_req->ex.oe_len - *result);
+			else
+				rbd_assert(*result == obj_req->ex.oe_len);
+			*result = 0;
+		}
+		return true;
+	case RBD_OBJ_READ_PARENT:
+		return true;
+	default:
+		BUG();
 	}
-
-	return true;
 }
 
 /*
@@ -2658,11 +2668,11 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
 	case RBD_OBJ_WRITE_COPYUP_OPS:
 		return true;
 	case RBD_OBJ_WRITE_READ_FROM_PARENT:
-		if (*result < 0)
+		if (*result)
 			return true;
 
-		rbd_assert(*result);
-		ret = rbd_obj_issue_copyup(obj_req, *result);
+		ret = rbd_obj_issue_copyup(obj_req,
+					   rbd_obj_img_extents_bytes(obj_req));
 		if (ret) {
 			*result = ret;
 			return true;
@@ -2757,7 +2767,7 @@ static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
 	rbd_assert(img_req->result <= 0);
 	if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
 		obj_req = img_req->obj_request;
-		result = img_req->result ?: rbd_obj_img_extents_bytes(obj_req);
+		result = img_req->result;
 		rbd_img_request_put(img_req);
 		goto again;
 	}
-- 
2.19.2

