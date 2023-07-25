Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A11076246A
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 23:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjGYV3S (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 17:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjGYV3Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 17:29:16 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCA01FE6
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jul 2023 14:29:13 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4fb7dc16ff0so9241224e87.2
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jul 2023 14:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690320551; x=1690925351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eL1WFQdHL939xNzGULY0ZSwlbWxB4jBimZZ1LkCYXgA=;
        b=Gkbcg116v093mc0+b/2znL2A+jlUpoOvTHgz3s2yJwyPFpkvjL0K6mtcjR0CO8HDTt
         hWG0IOrZF2dE6M3Ejw0vu4yI0q1embyYInpum0OuFPfTdzUb2NLVsLvEigEUP6H6Us9V
         nZHL9L/WDQixIiKB5hz3buXbh/x+ap1sQJjJw09JYzG066AOrKwcvpsuPWbVdo3c3vSA
         wOrpEbHN/lauhviOXXHFq+fSrPO3ezS+0YahtHO+ki+gH1iQ2YE/xr/gj9lDA7ybpg49
         zb2JixAbjEHiHVdwu5Vt9Ie1YzRCImWdP/cFAmkQ7ZxWEF2K/cEbbRPP7mMo7+U6sXJJ
         FDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690320551; x=1690925351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eL1WFQdHL939xNzGULY0ZSwlbWxB4jBimZZ1LkCYXgA=;
        b=Rfa5WQxAYlbF/yXgWI+VEQvhImiVBrzMYU0dbVxvw/B+RFCwJAOqcoZY5T17M8ru05
         B1yJedsNop77/gl5dPaCSA7PLHQs+XJ0ohLkpgc0SNja8QV6aoFz2883MHdpVSNb3Sca
         si+eEOUNizpLCW8ZVe6WfNrtPzsnG43FUnIkKty+zNYNp9ednVTan3z9/Nai+KAfjoHv
         L0mXpO/EDiBfcU2BJhvNHzQ+MhEGIkzIYQTQ8svByFsIyEvO50TCG0fJqC06K3ZDAbdw
         5X0MJcuUkG7zyN5ftuj8qOh0ptr2c5xVR+wxQe1akM4ZWwgafUPv+8kaGTWSKMM6WTmf
         oBUw==
X-Gm-Message-State: ABy/qLboNHFhfqm+gFSeEMzOccHb6DM6OIyeGQ3HMzA41nPtj+POLx1F
        TuTCcKD/FGk11Caqs4tVNn1vzH574Q4=
X-Google-Smtp-Source: APBJJlGf7fvtX7RWGrBsUBiCpwS6oWKqTekmS8LZv5gX3FLj0fvw6gUg2WmO7csx/ZZUI80DrnU06Q==
X-Received: by 2002:a05:6512:2521:b0:4fa:ad2d:6c58 with SMTP id be33-20020a056512252100b004faad2d6c58mr74841lfb.61.1690320550600;
        Tue, 25 Jul 2023 14:29:10 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id f23-20020a05640214d700b005224ec27dd7sm1200778edx.66.2023.07.25.14.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 14:29:10 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v2 1/3] rbd: make get_lock_owner_info() return a single locker or NULL
Date:   Tue, 25 Jul 2023 23:28:44 +0200
Message-ID: <20230725212847.137672-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725212847.137672-1-idryomov@gmail.com>
References: <20230725212847.137672-1-idryomov@gmail.com>
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

