Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E0814EABF
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgAaKiM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:55864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbgAaKiG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00DA7B021;
        Fri, 31 Jan 2020 10:38:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/15] rbd: schedule image_request after preparation
Date:   Fri, 31 Jan 2020 11:37:37 +0100
Message-Id: <20200131103739.136098-14-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Instead of pushing I/O directly to the workqueue we should be
preparing it first, and push it onto the workqueue as the last
step. This allows us to signal some back-pressure to the block
layer in case the queue fills up.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 52 +++++++++++++++-------------------------------------
 1 file changed, 15 insertions(+), 37 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 2566d6bd8230..9829f225c57d 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4775,9 +4775,10 @@ static int rbd_obj_method_sync(struct rbd_device *rbd_dev,
 	return ret;
 }
 
-static void rbd_queue_workfn(struct work_struct *work)
+static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
 {
-	struct request *rq = blk_mq_rq_from_pdu(work);
+	struct request *rq = bd->rq;
 	struct rbd_device *rbd_dev = rq->q->queuedata;
 	struct rbd_img_request *img_request;
 	struct ceph_snap_context *snapc = NULL;
@@ -4802,24 +4803,14 @@ static void rbd_queue_workfn(struct work_struct *work)
 		break;
 	default:
 		dout("%s: non-fs request type %d\n", __func__, req_op(rq));
-		result = -EIO;
-		goto err;
-	}
-
-	/* Ignore/skip any zero-length requests */
-
-	if (!length) {
-		dout("%s: zero-length request\n", __func__);
-		result = 0;
-		goto err_rq;
+		return BLK_STS_IOERR;
 	}
 
 	if (op_type != OBJ_OP_READ) {
 		if (rbd_is_ro(rbd_dev)) {
 			rbd_warn(rbd_dev, "%s on read-only mapping",
 				 obj_op_name(op_type));
-			result = -EIO;
-			goto err;
+			return BLK_STS_IOERR;
 		}
 		rbd_assert(!rbd_is_snap(rbd_dev));
 	}
@@ -4827,11 +4818,17 @@ static void rbd_queue_workfn(struct work_struct *work)
 	if (offset && length > U64_MAX - offset + 1) {
 		rbd_warn(rbd_dev, "bad request range (%llu~%llu)", offset,
 			 length);
-		result = -EINVAL;
-		goto err_rq;	/* Shouldn't happen */
+		return BLK_STS_NOSPC;	/* Shouldn't happen */
 	}
 
 	blk_mq_start_request(rq);
+	/* Ignore/skip any zero-length requests */
+	if (!length) {
+		dout("%s: zero-length request\n", __func__);
+		result = 0;
+		goto err;
+	}
+
 
 	mapping_size = READ_ONCE(rbd_dev->mapping.size);
 	if (op_type != OBJ_OP_READ) {
@@ -4868,8 +4865,8 @@ static void rbd_queue_workfn(struct work_struct *work)
 	if (result)
 		goto err_img_request;
 
-	rbd_img_handle_request(img_request, 0);
-	return;
+	rbd_img_schedule(img_request, 0);
+	return BLK_STS_OK;
 
 err_img_request:
 	rbd_img_request_destroy(img_request);
@@ -4880,15 +4877,6 @@ static void rbd_queue_workfn(struct work_struct *work)
 	ceph_put_snap_context(snapc);
 err:
 	blk_mq_end_request(rq, errno_to_blk_status(result));
-}
-
-static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
-		const struct blk_mq_queue_data *bd)
-{
-	struct request *rq = bd->rq;
-	struct work_struct *work = blk_mq_rq_to_pdu(rq);
-
-	queue_work(rbd_wq, work);
 	return BLK_STS_OK;
 }
 
@@ -5055,18 +5043,8 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
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
-- 
2.16.4

