Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD314EACE
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgAaKiD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:55726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgAaKiD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7622AFF6;
        Fri, 31 Jan 2020 10:38:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/15] rbd: add debugging statements for the state machine
Date:   Fri, 31 Jan 2020 11:37:32 +0100
Message-Id: <20200131103739.136098-9-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add additional debugging statements to analyse the state machine.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 8cfd9407cbb8..b708f5ecda07 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -291,6 +291,7 @@ struct rbd_obj_request {
 	union {
 		enum rbd_obj_read_state	 read_state;	/* for reads */
 		enum rbd_obj_write_state write_state;	/* for writes */
+		unsigned char		 obj_state;	/* generic access */
 	};
 
 	struct rbd_img_request	*img_request;
@@ -1352,8 +1353,12 @@ static inline void rbd_img_obj_request_add(struct rbd_img_request *img_request,
 static inline void rbd_img_obj_request_del(struct rbd_img_request *img_request,
 					struct rbd_obj_request *obj_request)
 {
-	dout("%s: img %p obj %p\n", __func__, img_request, obj_request);
-	list_del(&obj_request->ex.oe_item);
+	dout("%s: img %p obj %p state %d copyup %d pending %d\n", __func__,
+	     img_request, obj_request, obj_request->obj_state,
+	     obj_request->copyup_state, obj_request->pending.num_pending);
+	WARN_ON(obj_request->obj_state > 1);
+	WARN_ON(obj_request->pending.num_pending);
+	list_del_init(&obj_request->ex.oe_item);
 	rbd_assert(obj_request->img_request == img_request);
 	rbd_obj_request_put(obj_request);
 }
@@ -1497,6 +1502,8 @@ __rbd_obj_add_osd_request(struct rbd_obj_request *obj_req,
 	req->r_callback = rbd_osd_req_callback;
 	req->r_priv = obj_req;
 
+	dout("%s: osd_req %p for obj_req %p\n", __func__, req, obj_req);
+
 	/*
 	 * Data objects may be stored in a separate pool, but always in
 	 * the same namespace in that pool as the header in its pool.
@@ -1686,6 +1693,7 @@ static void rbd_img_request_destroy(struct kref *kref)
 	dout("%s: img %p\n", __func__, img_request);
 
 	WARN_ON(!list_empty(&img_request->lock_item));
+	WARN_ON(img_request->state != RBD_IMG_DONE);
 	mutex_lock(&img_request->object_mutex);
 	for_each_obj_request_safe(img_request, obj_request, next_obj_request)
 		rbd_img_obj_request_del(img_request, obj_request);
@@ -3513,6 +3521,8 @@ static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
 {
 	if (__rbd_obj_handle_request(obj_req, &result)) {
 		/* Recurse into parent */
+		dout("%s: obj %p parent %p result %d\n", __func__,
+		     obj_req, obj_req->img_request, result);
 		rbd_img_handle_request(obj_req->img_request, result);
 	}
 }
@@ -3603,6 +3613,9 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
 		int result = 0;
 
 		if (__rbd_obj_handle_request(obj_req, &result)) {
+			dout("%s: obj %p parent %p img %p result %d\n",
+			     __func__, obj_req, obj_req->img_request,
+			     img_req, result);
 			if (result) {
 				img_req->pending.result = result;
 				mutex_unlock(&img_req->object_mutex);
-- 
2.16.4

