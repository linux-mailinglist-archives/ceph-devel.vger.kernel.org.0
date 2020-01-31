Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E0714EABA
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgAaKiI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:55856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbgAaKiF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EF638B020;
        Fri, 31 Jan 2020 10:38:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/15] rbd: drop state_mutex in __rbd_img_handle_request()
Date:   Fri, 31 Jan 2020 11:37:35 +0100
Message-Id: <20200131103739.136098-12-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The use of READ_ONCE/WRITE_ONCE for the image request state allows
us to drop the state_mutex in __rbd_img_handle_request().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 671e941d6edf..db04401c4d8b 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -349,7 +349,6 @@ struct rbd_img_request {
 	struct list_head	object_extents;	/* obj_req.ex structs */
 	struct mutex		object_mutex;
 
-	struct mutex		state_mutex;
 	int			pending_result;
 	struct work_struct	work;
 	struct kref		kref;
@@ -1674,7 +1673,6 @@ static struct rbd_img_request *rbd_img_request_create(
 
 	INIT_LIST_HEAD(&img_request->lock_item);
 	INIT_LIST_HEAD(&img_request->object_extents);
-	mutex_init(&img_request->state_mutex);
 	mutex_init(&img_request->object_mutex);
 	kref_init(&img_request->kref);
 
@@ -2529,7 +2527,7 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
 		}
 	}
 	mutex_unlock(&img_req->object_mutex);
-	img_req->state = RBD_IMG_START;
+	WRITE_ONCE(img_req->state, RBD_IMG_START);
 	return 0;
 }
 
@@ -3652,15 +3650,15 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 	int ret;
 
 	dout("%s: img %p state %d\n", __func__, img_req, img_req->state);
-	switch (img_req->state) {
+	switch (READ_ONCE(img_req->state)) {
 	case RBD_IMG_START:
 		rbd_assert(!*result);
 
-		img_req->state = RBD_IMG_EXCLUSIVE_LOCK;
+		WRITE_ONCE(img_req->state, RBD_IMG_EXCLUSIVE_LOCK);
 		ret = rbd_img_exclusive_lock(img_req);
 		if (ret < 0) {
 			*result = ret;
-			img_req->state = RBD_IMG_DONE;
+			WRITE_ONCE(img_req->state, RBD_IMG_DONE);
 			return true;
 		}
 		if (ret == 0)
@@ -3668,17 +3666,17 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 		/* fall through */
 	case RBD_IMG_EXCLUSIVE_LOCK:
 		if (*result) {
-			img_req->state = RBD_IMG_DONE;
+			WRITE_ONCE(img_req->state, RBD_IMG_DONE);
 			return true;
 		}
 
 		rbd_assert(!need_exclusive_lock(img_req) ||
 			   __rbd_is_lock_owner(rbd_dev));
 
-		img_req->state = RBD_IMG_OBJECT_REQUESTS;
+		WRITE_ONCE(img_req->state, RBD_IMG_OBJECT_REQUESTS);
 		if (!rbd_img_object_requests(img_req)) {
 			*result = img_req->pending_result;
-			img_req->state = RBD_IMG_DONE;
+			WRITE_ONCE(img_req->state, RBD_IMG_DONE);
 			return true;
 		}
 		return false;
@@ -3686,7 +3684,7 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 		if (rbd_img_object_requests_pending(img_req))
 			return false;
 		*result = img_req->pending_result;
-		img_req->state = RBD_IMG_DONE;
+		WRITE_ONCE(img_req->state, RBD_IMG_DONE);
 		/* fall through */
 	case RBD_IMG_DONE:
 		return true;
@@ -3706,16 +3704,12 @@ static bool __rbd_img_handle_request(struct rbd_img_request *img_req,
 
 	if (need_exclusive_lock(img_req)) {
 		down_read(&rbd_dev->lock_rwsem);
-		mutex_lock(&img_req->state_mutex);
 		done = rbd_img_advance(img_req, result);
 		if (done)
 			rbd_lock_del_request(img_req);
-		mutex_unlock(&img_req->state_mutex);
 		up_read(&rbd_dev->lock_rwsem);
 	} else {
-		mutex_lock(&img_req->state_mutex);
 		done = rbd_img_advance(img_req, result);
-		mutex_unlock(&img_req->state_mutex);
 	}
 
 	if (done && *result) {
@@ -3985,10 +3979,8 @@ static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
 	}
 
 	list_for_each_entry(img_req, &rbd_dev->acquiring_list, lock_item) {
-		mutex_lock(&img_req->state_mutex);
-		rbd_assert(img_req->state == RBD_IMG_EXCLUSIVE_LOCK);
+		rbd_assert(READ_ONCE(img_req->state) == RBD_IMG_EXCLUSIVE_LOCK);
 		rbd_img_schedule(img_req, result);
-		mutex_unlock(&img_req->state_mutex);
 	}
 
 	list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
-- 
2.16.4

