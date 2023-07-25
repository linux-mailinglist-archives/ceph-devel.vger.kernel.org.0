Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FB97608A6
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 06:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjGYEgW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 00:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjGYEgU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 00:36:20 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061C7E55
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:36:19 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3fbd33a57dcso49753635e9.0
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690259777; x=1690864577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUyjwZ53lab6sfzGfDl2TdRCVDTqp4D/S/ZXJ6DEFB4=;
        b=grCiKtjrguVb/H1SFWPeG+SAvvOfPIsQTSm9X1INO3J6+aThTbQjqTrVUOOlgJImF1
         inNSquZodR/JvYz1k9oLgbYTpgKthT3+j09w4xV94M8uSgLkxJU+9zlNHcql71IaLFRE
         NZ072ZzGgOelDrOn7LKgL+t7FjkTiS6hXAJnJfR2JmZWpKggl9hWmxsLaTmLBtTGcoEP
         SnHclX+vnJzvU/MNZMjeNPxWH0a6Mv7rfKKMtgiaq2Li0mB5l+SQ9HAd9QCETD3TLy6/
         zah4ajIlBmzvXFe4Ax5uHjGU2oh4/cntekMKm6LDZR9Ic3BB9F2B3JgCgFzGfig5k6Ve
         +Lyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690259777; x=1690864577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sUyjwZ53lab6sfzGfDl2TdRCVDTqp4D/S/ZXJ6DEFB4=;
        b=iqynlS8vLipBKiWwvkhV230Swn+/Kq7kesQt8oETEVd8mGOS+6nTbH5iOLQhaqRQLh
         IdQjXHGYLNjcQhDTdd3x2+v6mOfvLBOgkIHjw1usyF0m1reEmSCMXPE/bLBv9YJuTl9Y
         rxEBo10iNpXm3B6OAZAyfmbODssrXLOZRKKyYdkqsZOspyN0TXuNIbhWVSaSIs699K8b
         NA7k+wP051lv4MX/utCP7nsXlVL9JBoqRMVrpXYvfucpoDcSJ1HMw6qhwRx4AGHFKBVU
         eUryxIyvscAeu9RwbLcT24uGHr40KiHuZoA7RL5YND54/pk0B6jXZgNieQFN/E1t1h7B
         Cflw==
X-Gm-Message-State: ABy/qLbrfj05P1k3J6cTMWZmxe90TRCJiga9Uky29+9PsJR9a1O5EvPy
        0TAfkl8OgoynlCTS8w/PQMTD/DhbJds=
X-Google-Smtp-Source: APBJJlH4wsYWUAacKDaVq+3l8Z5d/3ZgPU1nufW3d4Qqvvi0uQ5acnmhq4TiCZ661EC7MBX7km9SFQ==
X-Received: by 2002:a05:600c:294b:b0:3f9:b9e7:2f8d with SMTP id n11-20020a05600c294b00b003f9b9e72f8dmr8395834wmd.2.1690259777491;
        Mon, 24 Jul 2023 21:36:17 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d6441000000b00317643a93f4sm3500760wrw.96.2023.07.24.21.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 21:36:16 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 3/3] rbd: retrieve and check lock owner twice before blocklisting
Date:   Tue, 25 Jul 2023 06:35:56 +0200
Message-ID: <20230725043559.123889-4-idryomov@gmail.com>
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

An attempt to acquire exclusive lock can race with the current lock
owner closing the image:

1. lock is held by client123, rbd_lock() returns -EBUSY
2. get_lock_owner_info() returns client123 instance details
3. client123 closes the image, lock is released
4. find_watcher() returns 0 as there is no matching watcher anymore
5. client123 instance gets erroneously blocklisted

Particularly impacted is mirror snapshot scheduler in snapshot-based
mirroring since it happens to open and close images a lot (images are
opened only for as long as it takes to take the next mirror snapshot,
the same client instance is used for all images).

To reduce the potential for erroneous blocklisting, retrieve the lock
owner again after find_watcher() returns 0.  If it's still there, make
sure it matches the previously detected lock owner.

Cc: stable@vger.kernel.org # 6d1736a0e432: rbd: make get_lock_owner_info() return a single locker or NULL
Cc: stable@vger.kernel.org # 5dc06bec6a5b: rbd: harden get_lock_owner_info() a bit
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c                  | 16 ++++++++++++++--
 include/linux/ceph/cls_lock_client.h | 10 ++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 94629e826369..e4b5829a03b4 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3969,11 +3969,11 @@ static int find_watcher(struct rbd_device *rbd_dev,
 static int rbd_try_lock(struct rbd_device *rbd_dev)
 {
 	struct ceph_client *client = rbd_dev->rbd_client->client;
-	struct ceph_locker *locker;
+	struct ceph_locker *locker, *refreshed_locker;
 	int ret;
 
 	for (;;) {
-		locker = NULL;
+		locker = refreshed_locker = NULL;
 
 		ret = rbd_lock(rbd_dev);
 		if (ret != -EBUSY)
@@ -3993,6 +3993,16 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
 		if (ret)
 			goto out; /* request lock or error */
 
+		refreshed_locker = get_lock_owner_info(rbd_dev);
+		if (IS_ERR(refreshed_locker)) {
+			ret = PTR_ERR(refreshed_locker);
+			refreshed_locker = NULL;
+			goto out;
+		}
+		if (!refreshed_locker ||
+		    !ceph_locker_equal(locker, refreshed_locker))
+			goto again;
+
 		rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
 			 ENTITY_NAME(locker->id.name));
 
@@ -4014,10 +4024,12 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
 		}
 
 again:
+		free_locker(refreshed_locker);
 		free_locker(locker);
 	}
 
 out:
+	free_locker(refreshed_locker);
 	free_locker(locker);
 	return ret;
 }
diff --git a/include/linux/ceph/cls_lock_client.h b/include/linux/ceph/cls_lock_client.h
index 17bc7584d1fe..b26f44ea38ca 100644
--- a/include/linux/ceph/cls_lock_client.h
+++ b/include/linux/ceph/cls_lock_client.h
@@ -24,6 +24,16 @@ struct ceph_locker {
 	struct ceph_locker_info info;
 };
 
+static inline bool ceph_locker_equal(const struct ceph_locker *lhs,
+				     const struct ceph_locker *rhs)
+{
+	return lhs->id.name.type == rhs->id.name.type &&
+	       lhs->id.name.num == rhs->id.name.num &&
+	       !strcmp(lhs->id.cookie, rhs->id.cookie) &&
+	       !memcmp(&lhs->info.addr, &rhs->info.addr,
+		       sizeof(rhs->info.addr));
+}
+
 int ceph_cls_lock(struct ceph_osd_client *osdc,
 		  struct ceph_object_id *oid,
 		  struct ceph_object_locator *oloc,
-- 
2.41.0

