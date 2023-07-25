Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF9776246B
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 23:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjGYV3T (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 17:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjGYV3Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 17:29:16 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA441FEC
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jul 2023 14:29:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51e619bcbf9so7955220a12.3
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jul 2023 14:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690320552; x=1690925352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKxfLmNS2Yxgb7gGh2D3p1/z7+JKv9s8t2rHAKNWc8Q=;
        b=bhwGvz1WLMG5sohk0I+SkHhlJ4vWvDb6I83cbGQV0V+XOu0yb0c6ChDyDxBo1jwjuj
         rsNX6F1WXTnl24Oa0mOtcl0mIcChQ3bl+RqroyxF4k5RLxWwpL/H9mYtUI2MRVDUGJOu
         89QlkW5NMPertqiZIZG2PPO5ESe+yD+A7+uyHeIaRpzvic6cj2PtVj+ArOriU2w/9bqo
         Dx3U5kFRezX/uFAScLjBStvi484BRRKR6cIdVScjLZwQYaSJaRCzplIvziWaLNymz7E2
         1eOD8H+TRzm8I0NHNO4CB5rg4dQRWgHRMRgONyqVwIUVB95vjFFUuo/M42cq2aJrXLj2
         MO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690320552; x=1690925352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sKxfLmNS2Yxgb7gGh2D3p1/z7+JKv9s8t2rHAKNWc8Q=;
        b=bbC3DFolxPSd5S4XwvTeRf6VM9Fte5dnRmr7C9DpW+861M3/eAgwQZASXHM8g/CqFl
         5pt+JwoQh91SnCcju2WGBFIImmEQQLdlAHlqnVUwp50HPYUrQ1E5BAdRThZXXKMK3fff
         WBDg5v9ZP0aZnNhr8iypa9Rxd01y5MpjPAhGLmfAoVVmAetsSq29420YID6tSMBTXvuO
         Gf2dRfqjKzeQJq0EeuH72IPbLmszmPZQ9GKckcMdPXzFWKkD1LB0Ds+3hU9xDXw9BOnI
         uD1wc6yEjXPgb3BPv9s5DD6fQgjwFFXqgnK0IElyyG5VfyTN5H84RwnoroDClKl1qKTq
         s30Q==
X-Gm-Message-State: ABy/qLZORFYnACPmLsH48dXZQ0eTZl+8EyEEyxBSObQgT9f4McWZjVAL
        FSNMrFOUiYSWL5Lc9f00Z2nAkdWc2Io=
X-Google-Smtp-Source: APBJJlETMdX3tzwtZbawnDwcihX3tr09CwKKOnyIGFprax86Y41qz6nnKtwYF8lDZnfIqX4xcXtgBw==
X-Received: by 2002:aa7:d055:0:b0:51a:2c81:72ee with SMTP id n21-20020aa7d055000000b0051a2c8172eemr102666edo.20.1690320552537;
        Tue, 25 Jul 2023 14:29:12 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id f23-20020a05640214d700b005224ec27dd7sm1200778edx.66.2023.07.25.14.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 14:29:12 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v2 3/3] rbd: retrieve and check lock owner twice before blocklisting
Date:   Tue, 25 Jul 2023 23:28:46 +0200
Message-ID: <20230725212847.137672-4-idryomov@gmail.com>
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

Cc: stable@vger.kernel.org # ba6b7b6db4df: rbd: make get_lock_owner_info() return a single locker or NULL
Cc: stable@vger.kernel.org # c476a060136a: rbd: harden get_lock_owner_info() a bit
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 94629e826369..24afcc93ac01 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3849,6 +3849,15 @@ static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
 	list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
 }
 
+static bool locker_equal(const struct ceph_locker *lhs,
+			 const struct ceph_locker *rhs)
+{
+	return lhs->id.name.type == rhs->id.name.type &&
+	       lhs->id.name.num == rhs->id.name.num &&
+	       !strcmp(lhs->id.cookie, rhs->id.cookie) &&
+	       ceph_addr_equal_no_type(&lhs->info.addr, &rhs->info.addr);
+}
+
 static void free_locker(struct ceph_locker *locker)
 {
 	if (locker)
@@ -3969,11 +3978,11 @@ static int find_watcher(struct rbd_device *rbd_dev,
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
@@ -3993,6 +4002,16 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
 		if (ret)
 			goto out; /* request lock or error */
 
+		refreshed_locker = get_lock_owner_info(rbd_dev);
+		if (IS_ERR(refreshed_locker)) {
+			ret = PTR_ERR(refreshed_locker);
+			refreshed_locker = NULL;
+			goto out;
+		}
+		if (!refreshed_locker ||
+		    !locker_equal(locker, refreshed_locker))
+			goto again;
+
 		rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
 			 ENTITY_NAME(locker->id.name));
 
@@ -4014,10 +4033,12 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
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
-- 
2.41.0

