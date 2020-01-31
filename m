Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1E714EACB
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 11:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgAaKiE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 05:38:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:55736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbgAaKiD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:38:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89C9BAF43;
        Fri, 31 Jan 2020 10:38:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/15] rbd: reorder switch statement in rbd_advance_read()
Date:   Fri, 31 Jan 2020 11:37:28 +0100
Message-Id: <20200131103739.136098-5-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200131103739.136098-1-hare@suse.de>
References: <20200131103739.136098-1-hare@suse.de>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Reorder switch statement to avoid the use of a label/goto
statement and add a 'done' state to indicate that the state
machine has completed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index c80942e08164..4d7857667e9c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -235,7 +235,8 @@ enum obj_operation_type {
 #define RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT	(1U << 4)
 
 enum rbd_obj_read_state {
-	RBD_OBJ_READ_START = 1,
+	RBD_OBJ_READ_DONE,
+	RBD_OBJ_READ_START,
 	RBD_OBJ_READ_OBJECT,
 	RBD_OBJ_READ_PARENT,
 };
@@ -2924,36 +2925,38 @@ static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	int ret;
 
-again:
+	dout("%s: obj %p state %d\n", __func__, obj_req, obj_req->read_state);
 	switch (obj_req->read_state) {
 	case RBD_OBJ_READ_START:
 		rbd_assert(!*result);
 
-		if (!rbd_obj_may_exist(obj_req)) {
-			*result = -ENOENT;
+		if (rbd_obj_may_exist(obj_req)) {
+			ret = rbd_obj_read_object(obj_req);
+			if (ret) {
+				*result = ret;
+				obj_req->read_state = RBD_OBJ_READ_DONE;
+				return true;
+			}
 			obj_req->read_state = RBD_OBJ_READ_OBJECT;
-			goto again;
-		}
-
-		ret = rbd_obj_read_object(obj_req);
-		if (ret) {
-			*result = ret;
-			return true;
+			return false;
 		}
+		*result = -ENOENT;
 		obj_req->read_state = RBD_OBJ_READ_OBJECT;
-		return false;
+		/* fall through */
 	case RBD_OBJ_READ_OBJECT:
 		if (*result == -ENOENT && rbd_dev->parent_overlap) {
 			/* reverse map this object extent onto the parent */
 			ret = rbd_obj_calc_img_extents(obj_req, false);
 			if (ret) {
 				*result = ret;
+				obj_req->read_state = RBD_OBJ_READ_DONE;
 				return true;
 			}
 			if (obj_req->num_img_extents) {
 				ret = rbd_obj_read_from_parent(obj_req);
 				if (ret) {
 					*result = ret;
+					obj_req->read_state = RBD_OBJ_READ_DONE;
 					return true;
 				}
 				obj_req->read_state = RBD_OBJ_READ_PARENT;
@@ -2977,6 +2980,7 @@ static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
 				rbd_assert(*result == obj_req->ex.oe_len);
 			*result = 0;
 		}
+		obj_req->read_state = RBD_OBJ_READ_DONE;
 		return true;
 	case RBD_OBJ_READ_PARENT:
 		/*
@@ -2990,6 +2994,9 @@ static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
 				rbd_obj_zero_range(obj_req, obj_overlap,
 					    obj_req->ex.oe_len - obj_overlap);
 		}
+		obj_req->read_state = RBD_OBJ_READ_DONE;
+		/* fall through */
+	case RBD_OBJ_READ_DONE:
 		return true;
 	default:
 		BUG();
-- 
2.16.4

