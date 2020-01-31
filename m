Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C4A14EAB9
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgAaKiH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:55850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgAaKiF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB623B004;
        Fri, 31 Jan 2020 10:38:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/15] rbd: use callback for image request completion
Date:   Fri, 31 Jan 2020 11:37:31 +0100
Message-Id: <20200131103739.136098-8-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Using callbacks to simplify code and to separate out the different
code paths for parent and child requests.

Suggested-by: David Disseldorp <ddiss@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 61 +++++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index c31507a5fdd2..8cfd9407cbb8 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -317,6 +317,9 @@ struct rbd_obj_request {
 	struct kref		kref;
 };
 
+typedef void (*rbd_img_request_cb_t)(struct rbd_img_request *img_request,
+				     int result);
+
 enum img_req_flags {
 	IMG_REQ_CHILD,		/* initiator: block = 0, child image = 1 */
 	IMG_REQ_LAYERED,	/* ENOENT handling: normal = 0, layered = 1 */
@@ -339,11 +342,8 @@ struct rbd_img_request {
 		u64			snap_id;	/* for reads */
 		struct ceph_snap_context *snapc;	/* for writes */
 	};
-	union {
-		struct request		*rq;		/* block request */
-		struct rbd_obj_request	*obj_request;	/* obj req initiator */
-	};
-
+	void			*callback_data;
+	rbd_img_request_cb_t	callback;
 	struct list_head	lock_item;
 	struct list_head	object_extents;	/* obj_req.ex structs */
 	struct mutex		object_mutex;
@@ -506,6 +506,8 @@ static ssize_t add_single_major_store(struct bus_type *bus, const char *buf,
 static ssize_t remove_single_major_store(struct bus_type *bus, const char *buf,
 					 size_t count);
 static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth);
+static void rbd_img_end_child_request(struct rbd_img_request *img_req,
+				      int result);
 
 static int rbd_dev_id_to_minor(int dev_id)
 {
@@ -2882,7 +2884,8 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 		return -ENOMEM;
 
 	__set_bit(IMG_REQ_CHILD, &child_img_req->flags);
-	child_img_req->obj_request = obj_req;
+	child_img_req->callback = rbd_img_end_child_request;
+	child_img_req->callback_data = obj_req;
 
 	dout("%s child_img_req %p for obj_req %p\n", __func__, child_img_req,
 	     obj_req);
@@ -3506,14 +3509,12 @@ static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
 	return done;
 }
 
-/*
- * This is open-coded in rbd_img_handle_request() to avoid parent chain
- * recursion.
- */
 static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
 {
-	if (__rbd_obj_handle_request(obj_req, &result))
+	if (__rbd_obj_handle_request(obj_req, &result)) {
+		/* Recurse into parent */
 		rbd_img_handle_request(obj_req->img_request, result);
+	}
 }
 
 static bool need_exclusive_lock(struct rbd_img_request *img_req)
@@ -3695,26 +3696,29 @@ static bool __rbd_img_handle_request(struct rbd_img_request *img_req,
 	return done;
 }
 
-static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
+static void rbd_img_end_child_request(struct rbd_img_request *img_req,
+				      int result)
 {
-again:
-	if (!__rbd_img_handle_request(img_req, &result))
-		return;
+	struct rbd_obj_request *obj_req = img_req->callback_data;
 
-	if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
-		struct rbd_obj_request *obj_req = img_req->obj_request;
+	rbd_img_request_put(img_req);
+	rbd_obj_handle_request(obj_req, result);
+}
 
-		rbd_img_request_put(img_req);
-		if (__rbd_obj_handle_request(obj_req, &result)) {
-			img_req = obj_req->img_request;
-			goto again;
-		}
-	} else {
-		struct request *rq = img_req->rq;
+static void rbd_img_end_request(struct rbd_img_request *img_req, int result)
+{
+	struct request *rq = img_req->callback_data;
 
-		rbd_img_request_put(img_req);
-		blk_mq_end_request(rq, errno_to_blk_status(result));
-	}
+	rbd_img_request_put(img_req);
+	blk_mq_end_request(rq, errno_to_blk_status(result));
+}
+
+void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
+{
+	if (!__rbd_img_handle_request(img_req, &result))
+		return;
+
+	img_req->callback(img_req, result);
 }
 
 static const struct rbd_client_id rbd_empty_cid;
@@ -4840,7 +4844,8 @@ static void rbd_queue_workfn(struct work_struct *work)
 		result = -ENOMEM;
 		goto err_rq;
 	}
-	img_request->rq = rq;
+	img_request->callback = rbd_img_end_request;
+	img_request->callback_data = rq;
 	snapc = NULL; /* img_request consumes a ref */
 
 	dout("%s rbd_dev %p img_req %p %s %llu~%llu\n", __func__, rbd_dev,
-- 
2.16.4

