Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6214EAC4
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgAaKiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:55852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbgAaKiF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D62A5B001;
        Fri, 31 Jan 2020 10:38:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/15] rbd: add 'done' state for rbd_obj_advance_copyup()
Date:   Fri, 31 Jan 2020 11:37:30 +0100
Message-Id: <20200131103739.136098-7-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Rename 'RBD_OBJ_COPYUP_WRITE_OBJECT' to 'RBD_OBJ_COPYUP_DONE' to
signal that the state machine has completed.
With that we can rename '__RBD_OBJ_COPYUP_WRITE_OBJECT' to
'RBD_OPJ_COPYUP_WRITE_OBJECT'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 766d67e4d5e5..c31507a5fdd2 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -277,11 +277,11 @@ enum rbd_obj_write_state {
 };
 
 enum rbd_obj_copyup_state {
-	RBD_OBJ_COPYUP_START = 1,
+	RBD_OBJ_COPYUP_DONE,
+	RBD_OBJ_COPYUP_START,
 	RBD_OBJ_COPYUP_READ_PARENT,
 	__RBD_OBJ_COPYUP_OBJECT_MAPS,
 	RBD_OBJ_COPYUP_OBJECT_MAPS,
-	__RBD_OBJ_COPYUP_WRITE_OBJECT,
 	RBD_OBJ_COPYUP_WRITE_OBJECT,
 };
 
@@ -3294,6 +3294,8 @@ static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
 	int ret;
 
 again:
+	dout("%s: obj %p copyup %d pending %d\n", __func__,
+	     obj_req, obj_req->copyup_state, obj_req->pending.num_pending);
 	switch (obj_req->copyup_state) {
 	case RBD_OBJ_COPYUP_START:
 		rbd_assert(!*result);
@@ -3301,17 +3303,19 @@ static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
 		ret = rbd_obj_copyup_read_parent(obj_req);
 		if (ret) {
 			*result = ret;
+			obj_req->copyup_state = RBD_OBJ_COPYUP_DONE;
 			return true;
 		}
 		if (obj_req->num_img_extents)
 			obj_req->copyup_state = RBD_OBJ_COPYUP_READ_PARENT;
 		else
-			obj_req->copyup_state = RBD_OBJ_COPYUP_WRITE_OBJECT;
+			obj_req->copyup_state = RBD_OBJ_COPYUP_DONE;
 		return false;
 	case RBD_OBJ_COPYUP_READ_PARENT:
-		if (*result)
+		if (*result) {
+			obj_req->copyup_state = RBD_OBJ_COPYUP_DONE;
 			return true;
-
+		}
 		if (is_zero_bvecs(obj_req->copyup_bvecs,
 				  rbd_obj_img_extents_bytes(obj_req))) {
 			dout("%s %p detected zeros\n", __func__, obj_req);
@@ -3329,27 +3333,30 @@ static bool rbd_obj_advance_copyup(struct rbd_obj_request *obj_req, int *result)
 	case __RBD_OBJ_COPYUP_OBJECT_MAPS:
 		if (!pending_result_dec(&obj_req->pending, result))
 			return false;
+		obj_req->copyup_state = RBD_OBJ_COPYUP_OBJECT_MAPS;
 		/* fall through */
 	case RBD_OBJ_COPYUP_OBJECT_MAPS:
 		if (*result) {
 			rbd_warn(rbd_dev, "snap object map update failed: %d",
 				 *result);
+			obj_req->copyup_state = RBD_OBJ_COPYUP_DONE;
 			return true;
 		}
 
 		rbd_obj_copyup_write_object(obj_req);
 		if (!obj_req->pending.num_pending) {
 			*result = obj_req->pending.result;
-			obj_req->copyup_state = RBD_OBJ_COPYUP_WRITE_OBJECT;
+			obj_req->copyup_state = RBD_OBJ_COPYUP_DONE;
 			goto again;
 		}
-		obj_req->copyup_state = __RBD_OBJ_COPYUP_WRITE_OBJECT;
+		obj_req->copyup_state = RBD_OBJ_COPYUP_WRITE_OBJECT;
 		return false;
-	case __RBD_OBJ_COPYUP_WRITE_OBJECT:
+	case RBD_OBJ_COPYUP_WRITE_OBJECT:
 		if (!pending_result_dec(&obj_req->pending, result))
 			return false;
+		obj_req->copyup_state = RBD_OBJ_COPYUP_DONE;
 		/* fall through */
-	case RBD_OBJ_COPYUP_WRITE_OBJECT:
+	case RBD_OBJ_COPYUP_DONE:
 		return true;
 	default:
 		BUG();
-- 
2.16.4

