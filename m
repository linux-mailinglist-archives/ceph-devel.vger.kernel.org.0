Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B1B76C05B
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Aug 2023 00:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbjHAWXR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Aug 2023 18:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjHAWXJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Aug 2023 18:23:09 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5EB270D
        for <ceph-devel@vger.kernel.org>; Tue,  1 Aug 2023 15:22:59 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99c3d3c3db9so60711866b.3
        for <ceph-devel@vger.kernel.org>; Tue, 01 Aug 2023 15:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690928578; x=1691533378;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2dN1eAzWWOg9JQJNB1duk9oA9ZHIyD9quKkdE3bQkdc=;
        b=NRSbTjHqnY/NQqwrr1hmRnOxAC+3DqifC5yf0TE4pQ1YAmnYgTA7cF4rySNFYOvwpk
         NZcLpOZnS8nX4WLZYxIg56zZWW7E5lurGgHdNUiWDd8rCutx9cKCpuEqbhMwRXFolMI8
         AaXGrXwTJC9aGN5VdzMzOQ62knP8GeT02bc7mMl6dtkXCcZZ5m0Sm3PFydBFL+3DeDf9
         YSE6QCr7gmv+1/7pzlCOWqE0zRysXS3msfYeHH/nZhmV1w/SrhskF4cXyZnfY4EfrQmu
         muNZ+E5yQv2TcxbrJTsuC1vkK5CRBwYrIW2vK9mAWZI41GFAg3NCWVnNdKWS4ivrT3HR
         x50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690928578; x=1691533378;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2dN1eAzWWOg9JQJNB1duk9oA9ZHIyD9quKkdE3bQkdc=;
        b=gIJSFKX8lhkGlRlwrFMv9xo7l6Pks3ovp1vu/2w+K1lQdCqHpRnO7SxHD4+RRfvucx
         R9SxhhI36TxQ2RIq3Q01AaHhWJ2ylOCz401rVnxH+FE+tjpi/geWmnaNbntRK9nwqsFb
         6qHjhaI8T0+c8Tem4ApDERHUXBwb6N+7HQ+XgppjGi4cpn8kL6RfTKIu9TQPp472+Dfy
         s6kIUXpNArIYuGaIOdu/uTHMohvPvLUt8Ha/KXczrMneIfxt3FKLshJGwvz2rkfG2BLo
         Sa/M89BGGvArD4kVJUqvD7FXIlXhNNyXTe8H4ua0d6m59vwHZVGIi+A06DYiZ/anDWnx
         JpQQ==
X-Gm-Message-State: ABy/qLbN9AQez+JBXoIZ27/NV1iQjgsrvtVO+JGqxnYMWkGgccFO2EBy
        rq36e5pj6sYvQ0v1/IjvMIS4NJxIAhc=
X-Google-Smtp-Source: APBJJlGZyXb+yQJi3PMm+NEFt4V1fIkDJdPUoYud8xt4u+OWnDAakvoOYpBqvO2MM14u0NRWJw7ixg==
X-Received: by 2002:a17:906:32cd:b0:99b:e5c3:2e55 with SMTP id k13-20020a17090632cd00b0099be5c32e55mr3475912ejk.38.1690928577678;
        Tue, 01 Aug 2023 15:22:57 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ov38-20020a170906fc2600b009929ab17bdfsm8123352ejb.168.2023.08.01.15.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:22:56 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH] rbd: prevent busy loop when requesting exclusive lock
Date:   Wed,  2 Aug 2023 00:22:37 +0200
Message-ID: <20230801222238.674641-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Due to rbd_try_acquire_lock() effectively swallowing all but
EBLOCKLISTED error from rbd_try_lock() ("request lock anyway") and
rbd_request_lock() returning ETIMEDOUT error not only for an actual
notify timeout but also when the lock owner doesn't respond, a busy
loop inside of rbd_acquire_lock() between rbd_try_acquire_lock() and
rbd_request_lock() is possible.

Requesting the lock on EBUSY error (returned by get_lock_owner_info()
if an incompatible lock or invalid lock owner is detected) makes very
little sense.  The same goes for ETIMEDOUT error (might pop up pretty
much anywhere if osd_request_timeout option is set) and many others.

Just fail I/O requests on rbd_dev->acquiring_list immediately on any
error from rbd_try_lock().

Cc: stable@vger.kernel.org # 588159009d5b: rbd: retrieve and check lock owner twice before blocklisting
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 24afcc93ac01..2328cc05be36 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3675,7 +3675,7 @@ static int rbd_lock(struct rbd_device *rbd_dev)
 	ret = ceph_cls_lock(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
 			    RBD_LOCK_NAME, CEPH_CLS_LOCK_EXCLUSIVE, cookie,
 			    RBD_LOCK_TAG, "", 0);
-	if (ret)
+	if (ret && ret != -EEXIST)
 		return ret;
 
 	__rbd_lock(rbd_dev, cookie);
@@ -3878,7 +3878,7 @@ static struct ceph_locker *get_lock_owner_info(struct rbd_device *rbd_dev)
 				 &rbd_dev->header_oloc, RBD_LOCK_NAME,
 				 &lock_type, &lock_tag, &lockers, &num_lockers);
 	if (ret) {
-		rbd_warn(rbd_dev, "failed to retrieve lockers: %d", ret);
+		rbd_warn(rbd_dev, "failed to get header lockers: %d", ret);
 		return ERR_PTR(ret);
 	}
 
@@ -3940,8 +3940,10 @@ static int find_watcher(struct rbd_device *rbd_dev,
 	ret = ceph_osdc_list_watchers(osdc, &rbd_dev->header_oid,
 				      &rbd_dev->header_oloc, &watchers,
 				      &num_watchers);
-	if (ret)
+	if (ret) {
+		rbd_warn(rbd_dev, "failed to get watchers: %d", ret);
 		return ret;
+	}
 
 	sscanf(locker->id.cookie, RBD_LOCK_COOKIE_PREFIX " %llu", &cookie);
 	for (i = 0; i < num_watchers; i++) {
@@ -3985,8 +3987,12 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
 		locker = refreshed_locker = NULL;
 
 		ret = rbd_lock(rbd_dev);
-		if (ret != -EBUSY)
+		if (!ret)
+			goto out;
+		if (ret != -EBUSY) {
+			rbd_warn(rbd_dev, "failed to lock header: %d", ret);
 			goto out;
+		}
 
 		/* determine if the current lock holder is still alive */
 		locker = get_lock_owner_info(rbd_dev);
@@ -4089,11 +4095,8 @@ static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
 
 	ret = rbd_try_lock(rbd_dev);
 	if (ret < 0) {
-		rbd_warn(rbd_dev, "failed to lock header: %d", ret);
-		if (ret == -EBLOCKLISTED)
-			goto out;
-
-		ret = 1; /* request lock anyway */
+		rbd_warn(rbd_dev, "failed to acquire lock: %d", ret);
+		goto out;
 	}
 	if (ret > 0) {
 		up_write(&rbd_dev->lock_rwsem);
@@ -6627,12 +6630,11 @@ static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
 		cancel_delayed_work_sync(&rbd_dev->lock_dwork);
 		if (!ret)
 			ret = -ETIMEDOUT;
-	}
 
-	if (ret) {
-		rbd_warn(rbd_dev, "failed to acquire exclusive lock: %ld", ret);
-		return ret;
+		rbd_warn(rbd_dev, "failed to acquire lock: %ld", ret);
 	}
+	if (ret)
+		return ret;
 
 	/*
 	 * The lock may have been released by now, unless automatic lock
-- 
2.41.0

