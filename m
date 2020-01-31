Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AF614EAB3
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgAaKiE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:55716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbgAaKiD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B773FAFFC;
        Fri, 31 Jan 2020 10:38:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/15] rbd: count pending object requests in-line
Date:   Fri, 31 Jan 2020 11:37:33 +0100
Message-Id: <20200131103739.136098-10-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Instead of having a counter for outstanding object requests
check the state and count only those which are not in the final
state.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index b708f5ecda07..a6c95b6e9c0c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -350,7 +350,7 @@ struct rbd_img_request {
 	struct mutex		object_mutex;
 
 	struct mutex		state_mutex;
-	struct pending_result	pending;
+	int			pending_result;
 	struct work_struct	work;
 	int			work_result;
 	struct kref		kref;
@@ -3602,11 +3602,12 @@ static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
 	return 0;
 }
 
-static void rbd_img_object_requests(struct rbd_img_request *img_req)
+static int rbd_img_object_requests(struct rbd_img_request *img_req)
 {
 	struct rbd_obj_request *obj_req;
+	int num_pending = 0;
 
-	rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
+	rbd_assert(!img_req->pending_result);
 
 	mutex_lock(&img_req->object_mutex);
 	for_each_obj_request(img_req, obj_req) {
@@ -3617,15 +3618,33 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
 			     __func__, obj_req, obj_req->img_request,
 			     img_req, result);
 			if (result) {
-				img_req->pending.result = result;
-				mutex_unlock(&img_req->object_mutex);
-				return;
+				img_req->pending_result = result;
+				break;
 			}
 		} else {
-			img_req->pending.num_pending++;
+			num_pending++;
 		}
 	}
 	mutex_unlock(&img_req->object_mutex);
+	return num_pending;
+}
+
+static int rbd_img_object_requests_pending(struct rbd_img_request *img_req)
+{
+	struct rbd_obj_request *obj_req;
+	int num_pending = 0;
+
+	mutex_lock(&img_req->object_mutex);
+	for_each_obj_request(img_req, obj_req) {
+		if (obj_req->obj_state > 1)
+			num_pending++;
+		else if (WARN_ON(obj_req->obj_state == 1))
+			num_pending++;
+		else if (WARN_ON(obj_req->pending.num_pending))
+			num_pending++;
+	}
+	mutex_unlock(&img_req->object_mutex);
+	return num_pending;
 }
 
 static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
@@ -3658,16 +3677,16 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 			   __rbd_is_lock_owner(rbd_dev));
 
 		img_req->state = RBD_IMG_OBJECT_REQUESTS;
-		rbd_img_object_requests(img_req);
-		if (!img_req->pending.num_pending) {
-			*result = img_req->pending.result;
+		if (!rbd_img_object_requests(img_req)) {
+			*result = img_req->pending_result;
 			img_req->state = RBD_IMG_DONE;
 			return true;
 		}
 		return false;
 	case RBD_IMG_OBJECT_REQUESTS:
-		if (!pending_result_dec(&img_req->pending, result))
+		if (rbd_img_object_requests_pending(img_req))
 			return false;
+		*result = img_req->pending_result;
 		img_req->state = RBD_IMG_DONE;
 		/* fall through */
 	case RBD_IMG_DONE:
-- 
2.16.4

