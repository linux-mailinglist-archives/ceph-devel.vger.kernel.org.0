Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E38610069F
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKRNic (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54217 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfKRNic (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id u18so17461772wmc.3
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vNOtyDS0dpOhdWQGv2GOfd5c8Sz2KUKGGLWqicusc8o=;
        b=EmrGq0iB4yUygFr/1Kbrw0dAxxTyfmfHEvqG+Z9tw5yDNmYa0RHKqyhPosdA/fMpjc
         uAMRfT/1JPSaFrnQABWwB29SiwN2ubQAvJFlhX1U5F8JnEIAXt1oQjSgOVZYhPJXniVY
         YkRlF3M/6ugX64zpkA19DI6E722//MWsLgkDTxzVfNUrtW2GNOEZl7ITlHd8XIJIt/K8
         02GC3V3T60/NYalOgBVeql4dJ4VPHK9HYBNeXkUgmFeaZf08KTWZ/kRo18fWS3ttrmRt
         x0BZgHXX9l22WSebNvNn2wHcBrO9q467/AuZRyKzDVQT2q1/9xqG+B4X1BvO7FPwm/UE
         R+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNOtyDS0dpOhdWQGv2GOfd5c8Sz2KUKGGLWqicusc8o=;
        b=Hfu02j+FdZcuzyCR/mh1Q/Wk8p1MGJUcOSFJXn1/E4/tANmH/FLIq2X2UUXR+YlhzI
         2UWeIzQ5xqTexp+jqQZoN6tIYmNfSJwYaYQ01RDLEKWyaBtZ5fvuK5oD6LSuEVROFalJ
         bH3bMXZTh4n3sKQnxJMeptBNpKnt8dIBlOOccs8jQtQSsGq/p8wO7SA2HM9Q3WpZyCXr
         jt3Dpn81AAcfzar2KVGPrI84N0AsOrhJq7Wrasfi4SE28JyUwMPI3Ix+swCrum9ZUHWB
         UkxZhfL+GMXQacMzIXpumCMiouXICtv66cIZt5edob8JXG45wtBQeSgjBOjL7qHmbsCS
         xHUA==
X-Gm-Message-State: APjAAAUMtSwJgkKOqLGoHpHoxw/dTNq62k6LcW3vBLpNQC5DU8YsX3W6
        O6pJshzcZXwQWBygC59Xl6Oy2Jvs
X-Google-Smtp-Source: APXvYqyNwCc2jYJs7zgu9GdDzIZWSav6e09Bc0cFDM2LX9Cqv0TPazLhwRblXdb812HhtbqRPz5+8A==
X-Received: by 2002:a7b:c632:: with SMTP id p18mr29566663wmk.73.1574084309352;
        Mon, 18 Nov 2019 05:38:29 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.28
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:28 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 1/9] rbd: introduce rbd_is_snap()
Date:   Mon, 18 Nov 2019 14:38:08 +0100
Message-Id: <20191118133816.3963-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 2aaa56e4cec9..cf2a7d094890 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -514,6 +514,11 @@ static int minor_to_rbd_dev_id(int minor)
 	return minor >> RBD_SINGLE_MAJOR_PART_SHIFT;
 }
 
+static bool rbd_is_snap(struct rbd_device *rbd_dev)
+{
+	return rbd_dev->spec->snap_id != CEPH_NOSNAP;
+}
+
 static bool __rbd_is_lock_owner(struct rbd_device *rbd_dev)
 {
 	lockdep_assert_held(&rbd_dev->lock_rwsem);
@@ -696,7 +701,7 @@ static int rbd_ioctl_set_ro(struct rbd_device *rbd_dev, unsigned long arg)
 		return -EFAULT;
 
 	/* Snapshots can't be marked read-write */
-	if (rbd_dev->spec->snap_id != CEPH_NOSNAP && !ro)
+	if (rbd_is_snap(rbd_dev) && !ro)
 		return -EROFS;
 
 	/* Let blkdev_roset() handle it */
@@ -3538,7 +3543,7 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
 	if (!(rbd_dev->header.features & RBD_FEATURE_EXCLUSIVE_LOCK))
 		return false;
 
-	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
+	if (rbd_is_snap(rbd_dev))
 		return false;
 
 	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
@@ -4809,7 +4814,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 		goto err_rq;
 	}
 
-	if (op_type != OBJ_OP_READ && rbd_dev->spec->snap_id != CEPH_NOSNAP) {
+	if (op_type != OBJ_OP_READ && rbd_is_snap(rbd_dev)) {
 		rbd_warn(rbd_dev, "%s on read-only snapshot",
 			 obj_op_name(op_type));
 		result = -EIO;
@@ -4824,7 +4829,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 	 */
 	if (!test_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags)) {
 		dout("request for non-existent snapshot");
-		rbd_assert(rbd_dev->spec->snap_id != CEPH_NOSNAP);
+		rbd_assert(rbd_is_snap(rbd_dev));
 		result = -ENXIO;
 		goto err_rq;
 	}
@@ -5067,7 +5072,7 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 			goto out;
 	}
 
-	if (rbd_dev->spec->snap_id == CEPH_NOSNAP) {
+	if (!rbd_is_snap(rbd_dev)) {
 		rbd_dev->mapping.size = rbd_dev->header.image_size;
 	} else {
 		/* validate mapped snapshot's EXISTS flag */
@@ -6656,7 +6661,7 @@ static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
 		return -EINVAL;
 	}
 
-	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
+	if (rbd_is_snap(rbd_dev))
 		return 0;
 
 	rbd_assert(!rbd_is_lock_owner(rbd_dev));
@@ -7027,7 +7032,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	if (ret)
 		goto err_out_probe;
 
-	if (rbd_dev->spec->snap_id != CEPH_NOSNAP &&
+	if (rbd_is_snap(rbd_dev) &&
 	    (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)) {
 		ret = rbd_object_map_load(rbd_dev);
 		if (ret)
@@ -7116,7 +7121,7 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 	}
 
 	/* If we are mapping a snapshot it must be marked read-only */
-	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
+	if (rbd_is_snap(rbd_dev))
 		rbd_dev->opts->read_only = true;
 
 	if (rbd_dev->opts->alloc_size > rbd_dev->layout.object_size) {
-- 
2.19.2

