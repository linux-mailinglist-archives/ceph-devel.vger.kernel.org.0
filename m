Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC86723150
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 22:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjFEU1b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 16:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbjFEU12 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 16:27:28 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8336998
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 13:27:27 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5149e65c218so8009987a12.2
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 13:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685996846; x=1688588846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KybI+WtMi3tnB4KN37yItIiLRMfDM1+PQqPRpK6aeE=;
        b=dSzJjtik3WzwEJG0yhz/Oo3ufqeICd+XlbjNeXAsFLYj9B1jgjYGIS2KYRfUw24W5u
         ekxhzYsjJaQAjpTJ+ib2DM7PLMhCIRDfoJsZIpNEb83o1E6Lyjhb9FG0UB4rUDnn7Lsq
         ZQ784mKlU9jjinxHoJ14kx0e/yM1Q55YVSkLZGqQskujaXcTp1RndBnxPpiWzsVpaSC/
         N4yH1mVbRLRjyUGhllgrWRys3NPqj5L5Ie9avtPCO3FDshxzOkD/xD/Wf8u/reMdJcQi
         uAHmMMRmb7ZFKQGpMQ9dYx9pl3Q/jdYMu//56/C6nYXzew8lUZwfGTPiWr9NR5gx5cpn
         1kVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685996846; x=1688588846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KybI+WtMi3tnB4KN37yItIiLRMfDM1+PQqPRpK6aeE=;
        b=JL8rO5WEb4zsAUwozvmN/+7cw4zsPa1Rw2PPoHFIXimMIRq9BfQTyVxzN4H/5Emmvy
         U1i2lLPN9Wimko4zgctLOwxqdhtP26WivNS0ap6vb46/+rFJAARLRYds7QH8lleFKd7J
         AKfepm97xBMpZE0NqFas+XC0j7uUir+mW6ZMku3mikWj+SZkfw7o1OI18kpDAqWQ6PGc
         7EG9jCbEybRWQIfHkcQQZVii/jPEOxxdv5anIqnMi8KObnpor9cvVmLOlCFEw1NDeYvA
         mS9xFm7WxpIa/34c99KnrshbxYP5+I6GPx7KVgq5oDeJLeEN26CdjZL+/GkIfCFFDOR+
         JSZA==
X-Gm-Message-State: AC+VfDyEQWExm1248g6XOZqb1xjCpiM1ZzqSUKUTI/HucOOtRmhSC5Ng
        isj5+WI7AyJeciOL97DlQerDhcNudYM=
X-Google-Smtp-Source: ACHHUZ5deTMQ7o6Rno7gTEOGYMEPZWev50qcf4zySbF8oJC9NaW1TeEHeylS7QHdLJ10wZueD1bUIA==
X-Received: by 2002:a17:907:d29:b0:974:31:ed74 with SMTP id gn41-20020a1709070d2900b009740031ed74mr7975522ejc.65.1685996845782;
        Mon, 05 Jun 2023 13:27:25 -0700 (PDT)
Received: from zambezi.redhat.com (ip-94-112-104-28.bb.vodafone.cz. [94.112.104.28])
        by smtp.gmail.com with ESMTPSA id i15-20020a170906a28f00b00968242f8c37sm4619808ejz.50.2023.06.05.13.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 13:27:25 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 2/2] rbd: get snapshot context after exclusive lock is ensured to be held
Date:   Mon,  5 Jun 2023 22:27:15 +0200
Message-Id: <20230605202715.968962-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605202715.968962-1-idryomov@gmail.com>
References: <20230605202715.968962-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Move capturing the snapshot context into the image request state
machine, after exclusive lock is ensured to be held for the duration of
dealing with the image request.  This is needed to ensure correctness
of fast-diff states (OBJECT_EXISTS vs OBJECT_EXISTS_CLEAN) and object
deltas computed based off of them.  Otherwise the object map that is
forked for the snapshot isn't guaranteed to accurately reflect the
contents of the snapshot when the snapshot is taken under I/O.  This
breaks differential backup and snapshot-based mirroring use cases with
fast-diff enabled: since some object deltas may be incomplete, the
destination image may get corrupted.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/61472
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6c847db6ee2c..632751ddb287 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1336,6 +1336,8 @@ static bool rbd_obj_is_tail(struct rbd_obj_request *obj_req)
  */
 static void rbd_obj_set_copyup_enabled(struct rbd_obj_request *obj_req)
 {
+	rbd_assert(obj_req->img_request->snapc);
+
 	if (obj_req->img_request->op_type == OBJ_OP_DISCARD) {
 		dout("%s %p objno %llu discard\n", __func__, obj_req,
 		     obj_req->ex.oe_objno);
@@ -1456,6 +1458,7 @@ __rbd_obj_add_osd_request(struct rbd_obj_request *obj_req,
 static struct ceph_osd_request *
 rbd_obj_add_osd_request(struct rbd_obj_request *obj_req, int num_ops)
 {
+	rbd_assert(obj_req->img_request->snapc);
 	return __rbd_obj_add_osd_request(obj_req, obj_req->img_request->snapc,
 					 num_ops);
 }
@@ -1592,15 +1595,18 @@ static void rbd_img_request_init(struct rbd_img_request *img_request,
 	mutex_init(&img_request->state_mutex);
 }
 
+/*
+ * Only snap_id is captured here, for reads.  For writes, snapshot
+ * context is captured in rbd_img_object_requests() after exclusive
+ * lock is ensured to be held.
+ */
 static void rbd_img_capture_header(struct rbd_img_request *img_req)
 {
 	struct rbd_device *rbd_dev = img_req->rbd_dev;
 
 	lockdep_assert_held(&rbd_dev->header_rwsem);
 
-	if (rbd_img_is_write(img_req))
-		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
-	else
+	if (!rbd_img_is_write(img_req))
 		img_req->snap_id = rbd_dev->spec->snap_id;
 
 	if (rbd_dev_parent_get(rbd_dev))
@@ -3482,9 +3488,19 @@ static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
 
 static void rbd_img_object_requests(struct rbd_img_request *img_req)
 {
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
 	struct rbd_obj_request *obj_req;
 
 	rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
+	rbd_assert(!need_exclusive_lock(img_req) ||
+		   __rbd_is_lock_owner(rbd_dev));
+
+	if (rbd_img_is_write(img_req)) {
+		rbd_assert(!img_req->snapc);
+		down_read(&rbd_dev->header_rwsem);
+		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
+		up_read(&rbd_dev->header_rwsem);
+	}
 
 	for_each_obj_request(img_req, obj_req) {
 		int result = 0;
@@ -3502,7 +3518,6 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
 
 static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 {
-	struct rbd_device *rbd_dev = img_req->rbd_dev;
 	int ret;
 
 again:
@@ -3523,9 +3538,6 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 		if (*result)
 			return true;
 
-		rbd_assert(!need_exclusive_lock(img_req) ||
-			   __rbd_is_lock_owner(rbd_dev));
-
 		rbd_img_object_requests(img_req);
 		if (!img_req->pending.num_pending) {
 			*result = img_req->pending.result;
@@ -3987,6 +3999,10 @@ static int rbd_post_acquire_action(struct rbd_device *rbd_dev)
 {
 	int ret;
 
+	ret = rbd_dev_refresh(rbd_dev);
+	if (ret)
+		return ret;
+
 	if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) {
 		ret = rbd_object_map_open(rbd_dev);
 		if (ret)
-- 
2.39.2

