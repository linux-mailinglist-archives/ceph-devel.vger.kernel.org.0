Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE38715CB1F
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 20:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgBMTZs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 14:25:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34417 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgBMTZs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 14:25:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id s144so421814wme.1
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 11:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DEUWm2t3nIZGEuMh/RKfnCRKyeOeYAyQHLIDG/g+LTo=;
        b=iUJf4eCaRhov0JQyA770ZfjSXjZfdE4INQZESUHUwUGCPzvYJ5A+c0m2Z9Ch3xzJve
         tomjQOO0e2+tEeEiA1yTVQKFDG5pAirxKTwFTFHk+DG44HI0A91EfrrBGZuIbZOaNIko
         xpzfsE+w04qKObRbK0S1teDw4+PMQFg/Ts/a65fYZZx/yneOKYpsDXwvWB7PLIHVF8bK
         UyCd0oiYFclQ34IZ4185YvG5dwLGhUHgj2FsMtXTNug0GXTLUOW8Usvw+7ET3TI7e/MF
         vORdwwvcMFBq/d/ddUyMTVXv/4eEB4Yg9xo7GR5G7TKBVedXEYy5aMFntV3tRkBwVkiN
         rWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DEUWm2t3nIZGEuMh/RKfnCRKyeOeYAyQHLIDG/g+LTo=;
        b=KCyk8HsMsdrmxh7XS9tnFgqZF+CbRLjjX/QdiAbAu8RT+hvK46S93kUiax0VvrQxce
         Q1iDxLfWMjTPPxgxrGaLHb3xk7oW5CwFCVh6G0kWlnukRn6ZuYmKDDJklW3NrapZ6W29
         0M2+yEIBxg1eCP2d42b2FU635dVKmKMzouY5xzh1x8LNYl6Pfd9Q/ZWgvc3u/5rVCuYy
         7wXOOlb1NjU7kVLsBQVbJRnbeMVJZGKyRI2MogGoU75baC6DHOIStU5nt3rkU38nWdip
         urKLodUg+k/xhSmY2GR3+f512HoiV/udfSn+LFdawy7+vG/f/Gx4fXUTQG8kNfKhhXRR
         OuUA==
X-Gm-Message-State: APjAAAVlcispWhztc124kZoVaEViIRmwF5tOCdGDnLuOmYm+bmPXfsu2
        dhLvMOSpwZ8pdqqmjIJ0bLQt6Dlgs6c=
X-Google-Smtp-Source: APXvYqyd54w9cvzrW7r505jYLSUotayeQyZt7lrX6XHtyiiyFfzWTitUb19YLbbJVb11llaqER5y9w==
X-Received: by 2002:a1c:7f0d:: with SMTP id a13mr6996995wmd.182.1581621945005;
        Thu, 13 Feb 2020 11:25:45 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 21sm4326227wmo.8.2020.02.13.11.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:25:44 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/5] rbd: embed image request in blk-mq pdu
Date:   Thu, 13 Feb 2020 20:26:05 +0100
Message-Id: <20200213192606.31194-5-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200213192606.31194-1-idryomov@gmail.com>
References: <20200213192606.31194-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Avoid making allocations for !IMG_REQ_CHILD image requests.  Only
IMG_REQ_CHILD image requests need to be freed now.

Move the initial request checks to rbd_queue_rq().  Unfortunately we
can't fill the image request and kick the state machine directly from
rbd_queue_rq() because ->queue_rq() isn't allowed to block.

This is loosely based on a patch from Hannes Reinecke <hare@suse.de>.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 138 ++++++++++++++++----------------------------
 1 file changed, 51 insertions(+), 87 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index d9eaf470728b..9ff4355fe48a 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -337,10 +337,7 @@ struct rbd_img_request {
 		u64			snap_id;	/* for reads */
 		struct ceph_snap_context *snapc;	/* for writes */
 	};
-	union {
-		struct request		*rq;		/* block request */
-		struct rbd_obj_request	*obj_request;	/* obj req initiator */
-	};
+	struct rbd_obj_request	*obj_request;	/* obj req initiator */
 
 	struct list_head	lock_item;
 	struct list_head	object_extents;	/* obj_req.ex structs */
@@ -1610,20 +1607,11 @@ static bool rbd_dev_parent_get(struct rbd_device *rbd_dev)
 	return counter > 0;
 }
 
-/*
- * Caller is responsible for filling in the list of object requests
- * that comprises the image request, and the Linux request pointer
- * (if there is one).
- */
-static struct rbd_img_request *rbd_img_request_create(
-					struct rbd_device *rbd_dev,
-					enum obj_operation_type op_type)
+static void rbd_img_request_init(struct rbd_img_request *img_request,
+				 struct rbd_device *rbd_dev,
+				 enum obj_operation_type op_type)
 {
-	struct rbd_img_request *img_request;
-
-	img_request = kmem_cache_zalloc(rbd_img_request_cache, GFP_NOIO);
-	if (!img_request)
-		return NULL;
+	memset(img_request, 0, sizeof(*img_request));
 
 	img_request->rbd_dev = rbd_dev;
 	img_request->op_type = op_type;
@@ -1631,8 +1619,6 @@ static struct rbd_img_request *rbd_img_request_create(
 	INIT_LIST_HEAD(&img_request->lock_item);
 	INIT_LIST_HEAD(&img_request->object_extents);
 	mutex_init(&img_request->state_mutex);
-
-	return img_request;
 }
 
 static void rbd_img_capture_header(struct rbd_img_request *img_req)
@@ -1667,7 +1653,8 @@ static void rbd_img_request_destroy(struct rbd_img_request *img_request)
 	if (rbd_img_is_write(img_request))
 		ceph_put_snap_context(img_request->snapc);
 
-	kmem_cache_free(rbd_img_request_cache, img_request);
+	if (test_bit(IMG_REQ_CHILD, &img_request->flags))
+		kmem_cache_free(rbd_img_request_cache, img_request);
 }
 
 #define BITS_PER_OBJ	2
@@ -2834,10 +2821,11 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 	struct rbd_img_request *child_img_req;
 	int ret;
 
-	child_img_req = rbd_img_request_create(parent, OBJ_OP_READ);
+	child_img_req = kmem_cache_alloc(rbd_img_request_cache, GFP_NOIO);
 	if (!child_img_req)
 		return -ENOMEM;
 
+	rbd_img_request_init(child_img_req, parent, OBJ_OP_READ);
 	__set_bit(IMG_REQ_CHILD, &child_img_req->flags);
 	child_img_req->obj_request = obj_req;
 
@@ -3638,7 +3626,7 @@ static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
 			goto again;
 		}
 	} else {
-		struct request *rq = img_req->rq;
+		struct request *rq = blk_mq_rq_from_pdu(img_req);
 
 		rbd_img_request_destroy(img_req);
 		blk_mq_end_request(rq, errno_to_blk_status(result));
@@ -4692,68 +4680,25 @@ static int rbd_obj_method_sync(struct rbd_device *rbd_dev,
 
 static void rbd_queue_workfn(struct work_struct *work)
 {
-	struct request *rq = blk_mq_rq_from_pdu(work);
-	struct rbd_device *rbd_dev = rq->q->queuedata;
-	struct rbd_img_request *img_request;
+	struct rbd_img_request *img_request =
+	    container_of(work, struct rbd_img_request, work);
+	struct rbd_device *rbd_dev = img_request->rbd_dev;
+	enum obj_operation_type op_type = img_request->op_type;
+	struct request *rq = blk_mq_rq_from_pdu(img_request);
 	u64 offset = (u64)blk_rq_pos(rq) << SECTOR_SHIFT;
 	u64 length = blk_rq_bytes(rq);
-	enum obj_operation_type op_type;
 	u64 mapping_size;
 	int result;
 
-	switch (req_op(rq)) {
-	case REQ_OP_DISCARD:
-		op_type = OBJ_OP_DISCARD;
-		break;
-	case REQ_OP_WRITE_ZEROES:
-		op_type = OBJ_OP_ZEROOUT;
-		break;
-	case REQ_OP_WRITE:
-		op_type = OBJ_OP_WRITE;
-		break;
-	case REQ_OP_READ:
-		op_type = OBJ_OP_READ;
-		break;
-	default:
-		dout("%s: non-fs request type %d\n", __func__, req_op(rq));
-		result = -EIO;
-		goto err;
-	}
-
 	/* Ignore/skip any zero-length requests */
-
 	if (!length) {
 		dout("%s: zero-length request\n", __func__);
 		result = 0;
-		goto err_rq;
-	}
-
-	if (op_type != OBJ_OP_READ) {
-		if (rbd_is_ro(rbd_dev)) {
-			rbd_warn(rbd_dev, "%s on read-only mapping",
-				 obj_op_name(op_type));
-			result = -EIO;
-			goto err;
-		}
-		rbd_assert(!rbd_is_snap(rbd_dev));
-	}
-
-	if (offset && length > U64_MAX - offset + 1) {
-		rbd_warn(rbd_dev, "bad request range (%llu~%llu)", offset,
-			 length);
-		result = -EINVAL;
-		goto err_rq;	/* Shouldn't happen */
+		goto err_img_request;
 	}
 
 	blk_mq_start_request(rq);
 
-	img_request = rbd_img_request_create(rbd_dev, op_type);
-	if (!img_request) {
-		result = -ENOMEM;
-		goto err_rq;
-	}
-	img_request->rq = rq;
-
 	down_read(&rbd_dev->header_rwsem);
 	mapping_size = rbd_dev->mapping.size;
 	rbd_img_capture_header(img_request);
@@ -4782,21 +4727,50 @@ static void rbd_queue_workfn(struct work_struct *work)
 
 err_img_request:
 	rbd_img_request_destroy(img_request);
-err_rq:
 	if (result)
 		rbd_warn(rbd_dev, "%s %llx at %llx result %d",
 			 obj_op_name(op_type), length, offset, result);
-err:
 	blk_mq_end_request(rq, errno_to_blk_status(result));
 }
 
 static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
-	struct request *rq = bd->rq;
-	struct work_struct *work = blk_mq_rq_to_pdu(rq);
+	struct rbd_device *rbd_dev = hctx->queue->queuedata;
+	struct rbd_img_request *img_req = blk_mq_rq_to_pdu(bd->rq);
+	enum obj_operation_type op_type;
 
-	queue_work(rbd_wq, work);
+	switch (req_op(bd->rq)) {
+	case REQ_OP_DISCARD:
+		op_type = OBJ_OP_DISCARD;
+		break;
+	case REQ_OP_WRITE_ZEROES:
+		op_type = OBJ_OP_ZEROOUT;
+		break;
+	case REQ_OP_WRITE:
+		op_type = OBJ_OP_WRITE;
+		break;
+	case REQ_OP_READ:
+		op_type = OBJ_OP_READ;
+		break;
+	default:
+		rbd_warn(rbd_dev, "unknown req_op %d", req_op(bd->rq));
+		return BLK_STS_IOERR;
+	}
+
+	rbd_img_request_init(img_req, rbd_dev, op_type);
+
+	if (rbd_img_is_write(img_req)) {
+		if (rbd_is_ro(rbd_dev)) {
+			rbd_warn(rbd_dev, "%s on read-only mapping",
+				 obj_op_name(img_req->op_type));
+			return BLK_STS_IOERR;
+		}
+		rbd_assert(!rbd_is_snap(rbd_dev));
+	}
+
+	INIT_WORK(&img_req->work, rbd_queue_workfn);
+	queue_work(rbd_wq, &img_req->work);
 	return BLK_STS_OK;
 }
 
@@ -4963,18 +4937,8 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 	return ret;
 }
 
-static int rbd_init_request(struct blk_mq_tag_set *set, struct request *rq,
-		unsigned int hctx_idx, unsigned int numa_node)
-{
-	struct work_struct *work = blk_mq_rq_to_pdu(rq);
-
-	INIT_WORK(work, rbd_queue_workfn);
-	return 0;
-}
-
 static const struct blk_mq_ops rbd_mq_ops = {
 	.queue_rq	= rbd_queue_rq,
-	.init_request	= rbd_init_request,
 };
 
 static int rbd_init_disk(struct rbd_device *rbd_dev)
@@ -5007,7 +4971,7 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	rbd_dev->tag_set.numa_node = NUMA_NO_NODE;
 	rbd_dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	rbd_dev->tag_set.nr_hw_queues = 1;
-	rbd_dev->tag_set.cmd_size = sizeof(struct work_struct);
+	rbd_dev->tag_set.cmd_size = sizeof(struct rbd_img_request);
 
 	err = blk_mq_alloc_tag_set(&rbd_dev->tag_set);
 	if (err)
-- 
2.19.2

