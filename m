Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A887608A4
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 06:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjGYEgU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 00:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjGYEgS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 00:36:18 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416BAE55
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:36:17 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-31751d7d96eso1777751f8f.1
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690259776; x=1690864576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eL1WFQdHL939xNzGULY0ZSwlbWxB4jBimZZ1LkCYXgA=;
        b=NEBg3CDBmrbbC6qd8NvUTCJe7SKxOWlB3ZYnn6krfrLhu5tvpw6OVS9TnketJlKrTN
         Ri7XvyMNt4i4slhZQ9mNYfdsF2zkI4Fe+RK/ctYr8mCMhrVTAx+8dYPGLFLHYhpXUFB4
         oK2Utl/NG1OMTqHEp9rJyD/hk36iorEA1uwnV2en6trsqLIJA1Lt4SZwpbZ3vEVx5Mx8
         JQDIxJqn8Yn3EghmU1f4HsXLzvXlrC7d+PY9/Z5AJ8YzPbRJcqHhevdKJ9rXpjfseZxM
         PA7mf/HIiTe1Ml+TsOhthlQBzrQPIS/DT22x2kI+LPs4CJ/q1iar8mMqjmLtlsxe0EpN
         LCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690259776; x=1690864576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eL1WFQdHL939xNzGULY0ZSwlbWxB4jBimZZ1LkCYXgA=;
        b=D1gt4kAy0srduENjSi4Sm0rRmYQgpxSqfLntWwPFbkZ10jRbJR7XL8vOcq2fVCxMHr
         +VzWoF80JUGkoe9bbTmfNjsQZEbiQskROKS+8AajNHM82J2O0L12jNy5lTOESvAHIVGw
         MAvsSiIBExVwTBwBSqgsY8fihlC6p/OefRJbMUA8aUEknueFzbgkbv4R/asL66QlFJkJ
         tiorkLDaBb31YSrfkbQk+4ITDrVXiOpvBv129bPKj03rW4uXQmu7A1BquZee3BPkHLaE
         n22LcK/KM7r+CxcgwK9ZIUXUJETdVynLc2P6EsuB/irYV05Un6dtcFbnBwLIjKTx4NZS
         F1zg==
X-Gm-Message-State: ABy/qLaULqG2xYshhNxxVDrZRB8QkgTETg8q6MDhI+lvMn/tcu9L1qcC
        IOJgWfNlZbo4PHT24tzDyBjPvG8rdys=
X-Google-Smtp-Source: APBJJlH55qSmnLDAhAVNG/2kdr6cgtI9Tm+xt6Bw36ChjXVtYfctlxRd7yWgii6mef39SrPWjBId2w==
X-Received: by 2002:a5d:4e8f:0:b0:314:2ea7:af4a with SMTP id e15-20020a5d4e8f000000b003142ea7af4amr9175177wru.13.1690259775749;
        Mon, 24 Jul 2023 21:36:15 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d6441000000b00317643a93f4sm3500760wrw.96.2023.07.24.21.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 21:36:15 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 1/3] rbd: make get_lock_owner_info() return a single locker or NULL
Date:   Tue, 25 Jul 2023 06:35:54 +0200
Message-ID: <20230725043559.123889-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725043559.123889-1-idryomov@gmail.com>
References: <20230725043559.123889-1-idryomov@gmail.com>
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

Make the "num_lockers can be only 0 or 1" assumption explicit and
simplify the API by getting rid of output parameters in preparation
for calling get_lock_owner_info() twice before blocklisting.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 84 +++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 33 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index bd0e075a5d89..dca6c1e5f6bc 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3849,10 +3849,17 @@ static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
 	list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
 }
 
-static int get_lock_owner_info(struct rbd_device *rbd_dev,
-			       struct ceph_locker **lockers, u32 *num_lockers)
+static void free_locker(struct ceph_locker *locker)
+{
+	if (locker)
+		ceph_free_lockers(locker, 1);
+}
+
+static struct ceph_locker *get_lock_owner_info(struct rbd_device *rbd_dev)
 {
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
+	struct ceph_locker *lockers;
+	u32 num_lockers;
 	u8 lock_type;
 	char *lock_tag;
 	int ret;
@@ -3861,39 +3868,45 @@ static int get_lock_owner_info(struct rbd_device *rbd_dev,
 
 	ret = ceph_cls_lock_info(osdc, &rbd_dev->header_oid,
 				 &rbd_dev->header_oloc, RBD_LOCK_NAME,
-				 &lock_type, &lock_tag, lockers, num_lockers);
-	if (ret)
-		return ret;
+				 &lock_type, &lock_tag, &lockers, &num_lockers);
+	if (ret) {
+		rbd_warn(rbd_dev, "failed to retrieve lockers: %d", ret);
+		return ERR_PTR(ret);
+	}
 
-	if (*num_lockers == 0) {
+	if (num_lockers == 0) {
 		dout("%s rbd_dev %p no lockers detected\n", __func__, rbd_dev);
+		lockers = NULL;
 		goto out;
 	}
 
 	if (strcmp(lock_tag, RBD_LOCK_TAG)) {
 		rbd_warn(rbd_dev, "locked by external mechanism, tag %s",
 			 lock_tag);
-		ret = -EBUSY;
-		goto out;
+		goto err_busy;
 	}
 
 	if (lock_type == CEPH_CLS_LOCK_SHARED) {
 		rbd_warn(rbd_dev, "shared lock type detected");
-		ret = -EBUSY;
-		goto out;
+		goto err_busy;
 	}
 
-	if (strncmp((*lockers)[0].id.cookie, RBD_LOCK_COOKIE_PREFIX,
+	WARN_ON(num_lockers != 1);
+	if (strncmp(lockers[0].id.cookie, RBD_LOCK_COOKIE_PREFIX,
 		    strlen(RBD_LOCK_COOKIE_PREFIX))) {
 		rbd_warn(rbd_dev, "locked by external mechanism, cookie %s",
-			 (*lockers)[0].id.cookie);
-		ret = -EBUSY;
-		goto out;
+			 lockers[0].id.cookie);
+		goto err_busy;
 	}
 
 out:
 	kfree(lock_tag);
-	return ret;
+	return lockers;
+
+err_busy:
+	kfree(lock_tag);
+	ceph_free_lockers(lockers, num_lockers);
+	return ERR_PTR(-EBUSY);
 }
 
 static int find_watcher(struct rbd_device *rbd_dev,
@@ -3947,51 +3960,56 @@ static int find_watcher(struct rbd_device *rbd_dev,
 static int rbd_try_lock(struct rbd_device *rbd_dev)
 {
 	struct ceph_client *client = rbd_dev->rbd_client->client;
-	struct ceph_locker *lockers;
-	u32 num_lockers;
+	struct ceph_locker *locker;
 	int ret;
 
 	for (;;) {
+		locker = NULL;
+
 		ret = rbd_lock(rbd_dev);
 		if (ret != -EBUSY)
-			return ret;
+			goto out;
 
 		/* determine if the current lock holder is still alive */
-		ret = get_lock_owner_info(rbd_dev, &lockers, &num_lockers);
-		if (ret)
-			return ret;
-
-		if (num_lockers == 0)
+		locker = get_lock_owner_info(rbd_dev);
+		if (IS_ERR(locker)) {
+			ret = PTR_ERR(locker);
+			locker = NULL;
+			goto out;
+		}
+		if (!locker)
 			goto again;
 
-		ret = find_watcher(rbd_dev, lockers);
+		ret = find_watcher(rbd_dev, locker);
 		if (ret)
 			goto out; /* request lock or error */
 
 		rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
-			 ENTITY_NAME(lockers[0].id.name));
+			 ENTITY_NAME(locker->id.name));
 
 		ret = ceph_monc_blocklist_add(&client->monc,
-					      &lockers[0].info.addr);
+					      &locker->info.addr);
 		if (ret) {
-			rbd_warn(rbd_dev, "blocklist of %s%llu failed: %d",
-				 ENTITY_NAME(lockers[0].id.name), ret);
+			rbd_warn(rbd_dev, "failed to blocklist %s%llu: %d",
+				 ENTITY_NAME(locker->id.name), ret);
 			goto out;
 		}
 
 		ret = ceph_cls_break_lock(&client->osdc, &rbd_dev->header_oid,
 					  &rbd_dev->header_oloc, RBD_LOCK_NAME,
-					  lockers[0].id.cookie,
-					  &lockers[0].id.name);
-		if (ret && ret != -ENOENT)
+					  locker->id.cookie, &locker->id.name);
+		if (ret && ret != -ENOENT) {
+			rbd_warn(rbd_dev, "failed to break header lock: %d",
+				 ret);
 			goto out;
+		}
 
 again:
-		ceph_free_lockers(lockers, num_lockers);
+		free_locker(locker);
 	}
 
 out:
-	ceph_free_lockers(lockers, num_lockers);
+	free_locker(locker);
 	return ret;
 }
 
-- 
2.41.0

