Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C41F14EAB7
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgAaKiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:55860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgAaKiF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0EBB2B027;
        Fri, 31 Jan 2020 10:38:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/15] rbd: kill img_request kref
Date:   Fri, 31 Jan 2020 11:37:36 +0100
Message-Id: <20200131103739.136098-13-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The reference counter is never increased, so we can as well call
rbd_img_request_destroy() directly and drop the kref.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index db04401c4d8b..2566d6bd8230 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -351,7 +351,6 @@ struct rbd_img_request {
 
 	int			pending_result;
 	struct work_struct	work;
-	struct kref		kref;
 };
 
 #define for_each_obj_request(ireq, oreq) \
@@ -1329,15 +1328,6 @@ static void rbd_obj_request_put(struct rbd_obj_request *obj_request)
 	kref_put(&obj_request->kref, rbd_obj_request_destroy);
 }
 
-static void rbd_img_request_destroy(struct kref *kref);
-static void rbd_img_request_put(struct rbd_img_request *img_request)
-{
-	rbd_assert(img_request != NULL);
-	dout("%s: img %p (was %d)\n", __func__, img_request,
-		kref_read(&img_request->kref));
-	kref_put(&img_request->kref, rbd_img_request_destroy);
-}
-
 static inline void rbd_img_obj_request_add(struct rbd_img_request *img_request,
 					struct rbd_obj_request *obj_request)
 {
@@ -1674,19 +1664,15 @@ static struct rbd_img_request *rbd_img_request_create(
 	INIT_LIST_HEAD(&img_request->lock_item);
 	INIT_LIST_HEAD(&img_request->object_extents);
 	mutex_init(&img_request->object_mutex);
-	kref_init(&img_request->kref);
 
 	return img_request;
 }
 
-static void rbd_img_request_destroy(struct kref *kref)
+static void rbd_img_request_destroy(struct rbd_img_request *img_request)
 {
-	struct rbd_img_request *img_request;
 	struct rbd_obj_request *obj_request;
 	struct rbd_obj_request *next_obj_request;
 
-	img_request = container_of(kref, struct rbd_img_request, kref);
-
 	dout("%s: img %p\n", __func__, img_request);
 
 	WARN_ON(!list_empty(&img_request->lock_item));
@@ -2920,7 +2906,7 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 					      obj_req->copyup_bvecs);
 	}
 	if (ret) {
-		rbd_img_request_put(child_img_req);
+		rbd_img_request_destroy(child_img_req);
 		return ret;
 	}
 
@@ -3726,7 +3712,7 @@ static void rbd_img_end_child_request(struct rbd_img_request *img_req,
 {
 	struct rbd_obj_request *obj_req = img_req->callback_data;
 
-	rbd_img_request_put(img_req);
+	rbd_img_request_destroy(img_req);
 	rbd_obj_handle_request(obj_req, result);
 }
 
@@ -3734,7 +3720,7 @@ static void rbd_img_end_request(struct rbd_img_request *img_req, int result)
 {
 	struct request *rq = img_req->callback_data;
 
-	rbd_img_request_put(img_req);
+	rbd_img_request_destroy(img_req);
 	blk_mq_end_request(rq, errno_to_blk_status(result));
 }
 
@@ -4886,7 +4872,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 	return;
 
 err_img_request:
-	rbd_img_request_put(img_request);
+	rbd_img_request_destroy(img_request);
 err_rq:
 	if (result)
 		rbd_warn(rbd_dev, "%s %llx at %llx result %d",
-- 
2.16.4

