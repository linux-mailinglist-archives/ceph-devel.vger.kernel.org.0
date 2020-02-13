Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B788015CB1E
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 20:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgBMTZr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 14:25:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45693 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgBMTZq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 14:25:46 -0500
Received: by mail-wr1-f67.google.com with SMTP id g3so8093217wrs.12
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 11:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pot70fHs+lXUgzbEMMDHA0AfLvlJ2KldabgcypBbh1Q=;
        b=RfX1sDEipXmXh4rWT1IknxE/g9dnKXU5uPsmN7eP0NFQeePqF1zeQtonAlqWOYa5QS
         uqupix83rNKw0BLEkbdao1dxhLcGV2pd8aEO3MBBAejeVbSW6EojdpNQAF3glTsDPYh9
         R1g5N+gYKPytlQiLPs44RGT1W6hhmwPZfXt29avsD9RA+A8y0JExV8J6rN7w8hLjcOFY
         StJVr3RglQXn95gq5FEks66tDumS3apKoZ4hDh1sDLauT5xNCwahvjX1NUdxqJ67xahW
         qqBHRkjmWl2mYpt95Tw8tw0yVXF20Ven/euC8TuSrLP1XIztBvonOOZ4VEiUhUK3n2Es
         YayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pot70fHs+lXUgzbEMMDHA0AfLvlJ2KldabgcypBbh1Q=;
        b=smTvTxCTxzrTSg+mqSJ8SODt6L+kfmWKgZxHG+dQuOEJb4UwW+p4wWh3hrRxYYlZOC
         GnN8bEI5qetOWa3b3zKjj2skXFqbwX4r326i1pXqpmX9alYmN7WMBvt9s0w/lnof/b8p
         YqKmykyxUcNNO6A586ghlf6jvpUIxYsP5GEnDUmDIA+T10/HzToH16osfliH55qlhTBX
         6gkbX/A72epyebvyv3OsSEZm4TTBALxvPbCznzoEFUadAd0LIs0B5X3VfoJ7rEHY9hSo
         vl3cmisdDNa8i+gHqJl5TffvfKJX9FDqJGYPLkSAptNqhXYimanabEMVUwlfOckPrfOF
         t7EA==
X-Gm-Message-State: APjAAAWeQq0QH/5TTS6vQBtgkI/9L/AdEs1SwJu+kpsEV+VHE5bQDtbB
        ZnjASwJvZMGJd1aC/CB8AkfN5umEEdM=
X-Google-Smtp-Source: APXvYqxiIo6h2djZ1AZm8cNjeORhTYbGzeWGHJR+Nuqjh7EP/cjrYCp+wUXHJ+AKmMMLmEbLGehqhg==
X-Received: by 2002:a5d:4a91:: with SMTP id o17mr22191571wrq.232.1581621944115;
        Thu, 13 Feb 2020 11:25:44 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 21sm4326227wmo.8.2020.02.13.11.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:25:43 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] rbd: acquire header_rwsem just once in rbd_queue_workfn()
Date:   Thu, 13 Feb 2020 20:26:04 +0100
Message-Id: <20200213192606.31194-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200213192606.31194-1-idryomov@gmail.com>
References: <20200213192606.31194-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently header_rwsem is acquired twice: once in rbd_dev_parent_get()
when the image request is being created and then in rbd_queue_workfn()
to capture mapping_size and snapc.  Introduce rbd_img_capture_header()
and move image request allocation so that header_rwsem can be acquired
just once.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 59 ++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 96aa0133fb40..d9eaf470728b 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1601,10 +1601,8 @@ static bool rbd_dev_parent_get(struct rbd_device *rbd_dev)
 	if (!rbd_dev->parent_spec)
 		return false;
 
-	down_read(&rbd_dev->header_rwsem);
 	if (rbd_dev->parent_overlap)
 		counter = atomic_inc_return_safe(&rbd_dev->parent_ref);
-	up_read(&rbd_dev->header_rwsem);
 
 	if (counter < 0)
 		rbd_warn(rbd_dev, "parent reference overflow");
@@ -1619,8 +1617,7 @@ static bool rbd_dev_parent_get(struct rbd_device *rbd_dev)
  */
 static struct rbd_img_request *rbd_img_request_create(
 					struct rbd_device *rbd_dev,
-					enum obj_operation_type op_type,
-					struct ceph_snap_context *snapc)
+					enum obj_operation_type op_type)
 {
 	struct rbd_img_request *img_request;
 
@@ -1630,13 +1627,6 @@ static struct rbd_img_request *rbd_img_request_create(
 
 	img_request->rbd_dev = rbd_dev;
 	img_request->op_type = op_type;
-	if (!rbd_img_is_write(img_request))
-		img_request->snap_id = rbd_dev->spec->snap_id;
-	else
-		img_request->snapc = snapc;
-
-	if (rbd_dev_parent_get(rbd_dev))
-		img_request_layered_set(img_request);
 
 	INIT_LIST_HEAD(&img_request->lock_item);
 	INIT_LIST_HEAD(&img_request->object_extents);
@@ -1645,6 +1635,21 @@ static struct rbd_img_request *rbd_img_request_create(
 	return img_request;
 }
 
+static void rbd_img_capture_header(struct rbd_img_request *img_req)
+{
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
+
+	lockdep_assert_held(&rbd_dev->header_rwsem);
+
+	if (rbd_img_is_write(img_req))
+		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
+	else
+		img_req->snap_id = rbd_dev->spec->snap_id;
+
+	if (rbd_dev_parent_get(rbd_dev))
+		img_request_layered_set(img_req);
+}
+
 static void rbd_img_request_destroy(struct rbd_img_request *img_request)
 {
 	struct rbd_obj_request *obj_request;
@@ -2825,17 +2830,21 @@ static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
 static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 {
 	struct rbd_img_request *img_req = obj_req->img_request;
+	struct rbd_device *parent = img_req->rbd_dev->parent;
 	struct rbd_img_request *child_img_req;
 	int ret;
 
-	child_img_req = rbd_img_request_create(img_req->rbd_dev->parent,
-					       OBJ_OP_READ, NULL);
+	child_img_req = rbd_img_request_create(parent, OBJ_OP_READ);
 	if (!child_img_req)
 		return -ENOMEM;
 
 	__set_bit(IMG_REQ_CHILD, &child_img_req->flags);
 	child_img_req->obj_request = obj_req;
 
+	down_read(&parent->header_rwsem);
+	rbd_img_capture_header(child_img_req);
+	up_read(&parent->header_rwsem);
+
 	dout("%s child_img_req %p for obj_req %p\n", __func__, child_img_req,
 	     obj_req);
 
@@ -4686,7 +4695,6 @@ static void rbd_queue_workfn(struct work_struct *work)
 	struct request *rq = blk_mq_rq_from_pdu(work);
 	struct rbd_device *rbd_dev = rq->q->queuedata;
 	struct rbd_img_request *img_request;
-	struct ceph_snap_context *snapc = NULL;
 	u64 offset = (u64)blk_rq_pos(rq) << SECTOR_SHIFT;
 	u64 length = blk_rq_bytes(rq);
 	enum obj_operation_type op_type;
@@ -4739,28 +4747,24 @@ static void rbd_queue_workfn(struct work_struct *work)
 
 	blk_mq_start_request(rq);
 
+	img_request = rbd_img_request_create(rbd_dev, op_type);
+	if (!img_request) {
+		result = -ENOMEM;
+		goto err_rq;
+	}
+	img_request->rq = rq;
+
 	down_read(&rbd_dev->header_rwsem);
 	mapping_size = rbd_dev->mapping.size;
-	if (op_type != OBJ_OP_READ) {
-		snapc = rbd_dev->header.snapc;
-		ceph_get_snap_context(snapc);
-	}
+	rbd_img_capture_header(img_request);
 	up_read(&rbd_dev->header_rwsem);
 
 	if (offset + length > mapping_size) {
 		rbd_warn(rbd_dev, "beyond EOD (%llu~%llu > %llu)", offset,
 			 length, mapping_size);
 		result = -EIO;
-		goto err_rq;
-	}
-
-	img_request = rbd_img_request_create(rbd_dev, op_type, snapc);
-	if (!img_request) {
-		result = -ENOMEM;
-		goto err_rq;
+		goto err_img_request;
 	}
-	img_request->rq = rq;
-	snapc = NULL; /* img_request consumes a ref */
 
 	dout("%s rbd_dev %p img_req %p %s %llu~%llu\n", __func__, rbd_dev,
 	     img_request, obj_op_name(op_type), offset, length);
@@ -4782,7 +4786,6 @@ static void rbd_queue_workfn(struct work_struct *work)
 	if (result)
 		rbd_warn(rbd_dev, "%s %llx at %llx result %d",
 			 obj_op_name(op_type), length, offset, result);
-	ceph_put_snap_context(snapc);
 err:
 	blk_mq_end_request(rq, errno_to_blk_status(result));
 }
-- 
2.19.2

