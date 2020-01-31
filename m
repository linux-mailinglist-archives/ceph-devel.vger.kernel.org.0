Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9043914EABC
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgAaKiJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:55848 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbgAaKiF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DC947B00A;
        Fri, 31 Jan 2020 10:38:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/15] rbd: embed image request as blk_mq request payload
Date:   Fri, 31 Jan 2020 11:37:38 +0100
Message-Id: <20200131103739.136098-15-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Instead of allocating an image request for every block request
we can as well embed it as the payload and save the allocation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 56 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 9829f225c57d..cc3e5116fe58 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -324,6 +324,7 @@ typedef void (*rbd_img_request_cb_t)(struct rbd_img_request *img_request,
 enum img_req_flags {
 	IMG_REQ_CHILD,		/* initiator: block = 0, child image = 1 */
 	IMG_REQ_LAYERED,	/* ENOENT handling: normal = 0, layered = 1 */
+	IMG_REQ_EMBEDDED,	/* free handling: normal = 0, embedded = 1 */
 };
 
 enum rbd_img_state {
@@ -1640,17 +1641,10 @@ static bool rbd_dev_parent_get(struct rbd_device *rbd_dev)
  * that comprises the image request, and the Linux request pointer
  * (if there is one).
  */
-static struct rbd_img_request *rbd_img_request_create(
-					struct rbd_device *rbd_dev,
-					enum obj_operation_type op_type,
-					struct ceph_snap_context *snapc)
+static void rbd_img_request_setup(struct rbd_img_request *img_request,
+		struct rbd_device *rbd_dev, enum obj_operation_type op_type,
+		struct ceph_snap_context *snapc)
 {
-	struct rbd_img_request *img_request;
-
-	img_request = kmem_cache_zalloc(rbd_img_request_cache, GFP_NOIO);
-	if (!img_request)
-		return NULL;
-
 	img_request->rbd_dev = rbd_dev;
 	img_request->op_type = op_type;
 	if (!rbd_img_is_write(img_request))
@@ -1661,9 +1655,25 @@ static struct rbd_img_request *rbd_img_request_create(
 	if (rbd_dev_parent_get(rbd_dev))
 		img_request_layered_set(img_request);
 
+	img_request->pending_result = 0;
+	img_request->state = RBD_IMG_DONE;
 	INIT_LIST_HEAD(&img_request->lock_item);
 	INIT_LIST_HEAD(&img_request->object_extents);
 	mutex_init(&img_request->object_mutex);
+}
+
+struct rbd_img_request *rbd_img_request_create(
+					struct rbd_device *rbd_dev,
+					enum obj_operation_type op_type,
+					struct ceph_snap_context *snapc)
+{
+	struct rbd_img_request *img_request;
+
+	img_request = kmem_cache_zalloc(rbd_img_request_cache, GFP_NOIO);
+	if (!img_request)
+		return NULL;
+
+	rbd_img_request_setup(img_request, rbd_dev, op_type, snapc);
 
 	return img_request;
 }
@@ -1690,7 +1700,8 @@ static void rbd_img_request_destroy(struct rbd_img_request *img_request)
 	if (rbd_img_is_write(img_request))
 		ceph_put_snap_context(img_request->snapc);
 
-	kmem_cache_free(rbd_img_request_cache, img_request);
+	if (!test_bit(IMG_REQ_EMBEDDED, &img_request->flags))
+		kmem_cache_free(rbd_img_request_cache, img_request);
 }
 
 #define BITS_PER_OBJ	2
@@ -4780,7 +4791,7 @@ static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 {
 	struct request *rq = bd->rq;
 	struct rbd_device *rbd_dev = rq->q->queuedata;
-	struct rbd_img_request *img_request;
+	struct rbd_img_request *img_request = blk_mq_rq_to_pdu(rq);
 	struct ceph_snap_context *snapc = NULL;
 	u64 offset = (u64)blk_rq_pos(rq) << SECTOR_SHIFT;
 	u64 length = blk_rq_bytes(rq);
@@ -4845,11 +4856,7 @@ static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 		goto err_rq;
 	}
 
-	img_request = rbd_img_request_create(rbd_dev, op_type, snapc);
-	if (!img_request) {
-		result = -ENOMEM;
-		goto err_rq;
-	}
+	rbd_img_request_setup(img_request, rbd_dev, op_type, snapc);
 	img_request->callback = rbd_img_end_request;
 	img_request->callback_data = rq;
 	snapc = NULL; /* img_request consumes a ref */
@@ -4865,7 +4872,7 @@ static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (result)
 		goto err_img_request;
 
-	rbd_img_schedule(img_request, 0);
+	queue_work(rbd_wq, &img_request->work);
 	return BLK_STS_OK;
 
 err_img_request:
@@ -5043,8 +5050,19 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 	return ret;
 }
 
+static int rbd_init_request(struct blk_mq_tag_set *set, struct request *rq,
+		unsigned int hctx_idx, unsigned int numa_node)
+{
+	struct rbd_img_request *img_req = blk_mq_rq_to_pdu(rq);
+
+	INIT_WORK(&img_req->work, rbd_img_handle_request_work);
+	set_bit(IMG_REQ_EMBEDDED, &img_req->flags);
+	return 0;
+}
+
 static const struct blk_mq_ops rbd_mq_ops = {
 	.queue_rq	= rbd_queue_rq,
+	.init_request	= rbd_init_request,
 };
 
 static int rbd_init_disk(struct rbd_device *rbd_dev)
@@ -5077,7 +5095,7 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	rbd_dev->tag_set.numa_node = NUMA_NO_NODE;
 	rbd_dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	rbd_dev->tag_set.nr_hw_queues = 1;
-	rbd_dev->tag_set.cmd_size = sizeof(struct work_struct);
+	rbd_dev->tag_set.cmd_size = sizeof(struct rbd_img_request);
 
 	err = blk_mq_alloc_tag_set(&rbd_dev->tag_set);
 	if (err)
-- 
2.16.4

