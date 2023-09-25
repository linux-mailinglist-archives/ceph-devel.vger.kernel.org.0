Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EDE7ADFA9
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Sep 2023 21:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjIYTlJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Sep 2023 15:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbjIYTlI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Sep 2023 15:41:08 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B731C10D
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 12:41:00 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-533d6a8d6b6so4766314a12.2
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 12:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695670859; x=1696275659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RgrC3QJ03WLcpEEC52C3Ui4nfeLUBQjD+WEIjcVBxVc=;
        b=Wcq7J5389C3USxH+gKngVz6SMno0BnFbojuErME4sWFOdvQtIaw9rOsSD6It/eN+FL
         CBP8CaZVd3S7933SbawYuRJeUDI1pvAa4UyH6yk6PBANfE9xLuQt6JTrK6zZRwOnbama
         YT0Op8TvHiLbvcU+NniveiB79o46z5sq9BfO2h8kEc7Z3Loo7mHUKJGQpF4KC+oCMAtr
         d3zIpTz5U5ETint3L70mv5C6BQzXvnX+qaGhk+EKGTP0uliX/o3p7IQ1n+U5f2hl8due
         Y4iThpOZVWn7JW2XCFWu70n6FW7ZDkHpNx8BuD0wj1bmot6FD7UnXdb2uspXw7xgQdpe
         frqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695670859; x=1696275659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RgrC3QJ03WLcpEEC52C3Ui4nfeLUBQjD+WEIjcVBxVc=;
        b=dnH6flvibf9hZWUPpwQ/jQinja+iut4BGzmfOdcdP/JjYmrhUPdZptGAvp+PtHhFxd
         gPi9QBbkdqqnaJ1HlQbre2/AYKyi2hIdjZUadTPutpDztqENw0ytjG4zTZrxz7KZ5yEE
         WBVkKugRFwRaK+O4veACDypOOkhHhTA9Q1lJh8nCesS+CNgG0uJBD6+26pRd18ap9j9y
         r9lAoOxuNV9CYpG4jR1HPYYjmW+OOoF3TIy/vzF8tey0HT7jkAePndRjbRaDABILa0B6
         FuNaKezeCm3rcB8r6jmxRsM6Ggl6DqwidOGz5Tze7+W1zE+XA2fsSh8pbTeN4rn7EDEe
         s7tg==
X-Gm-Message-State: AOJu0YzFlBLEVGMnM1ReU4L2VIGRXPQdWUpwoHE1PQ2As4stDl5kOK8F
        hbAS55A7pzeYn9Fvt43Gaa7eHARxCXU=
X-Google-Smtp-Source: AGHT+IF5ueRvJm3nZVn0Eg2GZ2Pvq54bP7A7GNDo0PVGHsh1ajIvurqzM4zAyYswPsmO4P8TtooEYg==
X-Received: by 2002:aa7:c741:0:b0:533:5c03:5fce with SMTP id c1-20020aa7c741000000b005335c035fcemr6685405eds.5.1695670859158;
        Mon, 25 Sep 2023 12:40:59 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id en13-20020a056402528d00b005340d9d042bsm1762365edb.40.2023.09.25.12.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 12:40:58 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 4/4] rbd: take header_rwsem in rbd_dev_refresh() only when updating
Date:   Mon, 25 Sep 2023 21:40:34 +0200
Message-ID: <20230925194036.197899-5-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230925194036.197899-1-idryomov@gmail.com>
References: <20230925194036.197899-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_dev_refresh() has been holding header_rwsem across header and
parent info read-in unnecessarily for ages.  With commit 870611e4877e
("rbd: get snapshot context after exclusive lock is ensured to be
held"), the potential for deadlocks became much more real owning to
a) header_rwsem now nesting inside lock_rwsem and b) rw_semaphores
not allowing new readers after a writer is registered.

For example, assuming that I/O request 1, I/O request 2 and header
read-in request all target the same OSD:

1. I/O request 1 comes in and gets submitted
2. watch error occurs
3. rbd_watch_errcb() takes lock_rwsem for write, clears owner_cid and
   releases lock_rwsem
4. after reestablishing the watch, rbd_reregister_watch() calls
   rbd_dev_refresh() which takes header_rwsem for write and submits
   a header read-in request
5. I/O request 2 comes in: after taking lock_rwsem for read in
   __rbd_img_handle_request(), it blocks trying to take header_rwsem
   for read in rbd_img_object_requests()
6. another watch error occurs
7. rbd_watch_errcb() blocks trying to take lock_rwsem for write
8. I/O request 1 completion is received by the messenger but can't be
   processed because lock_rwsem won't be granted anymore
9. header read-in request completion can't be received, let alone
   processed, because the messenger is stranded

Change rbd_dev_refresh() to take header_rwsem only for actually
updating rbd_dev->header.  Header and parent info read-in don't need
any locking.

Cc: stable@vger.kernel.org # e3580eaee090: rbd: move rbd_dev_refresh() definition
Cc: stable@vger.kernel.org # 641d828d82d0: rbd: decouple header read-in from updating rbd_dev->header
Cc: stable@vger.kernel.org # 2147c0b31b95: rbd: decouple parent info read-in from updating rbd_dev
Cc: stable@vger.kernel.org
Fixes: 870611e4877e ("rbd: get snapshot context after exclusive lock is ensured to be held")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index d62a0298c890..a999b698b131 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6986,7 +6986,14 @@ static void rbd_dev_update_header(struct rbd_device *rbd_dev,
 	rbd_assert(rbd_image_format_valid(rbd_dev->image_format));
 	rbd_assert(rbd_dev->header.object_prefix); /* !first_time */
 
-	rbd_dev->header.image_size = header->image_size;
+	if (rbd_dev->header.image_size != header->image_size) {
+		rbd_dev->header.image_size = header->image_size;
+
+		if (!rbd_is_snap(rbd_dev)) {
+			rbd_dev->mapping.size = header->image_size;
+			rbd_dev_update_size(rbd_dev);
+		}
+	}
 
 	ceph_put_snap_context(rbd_dev->header.snapc);
 	rbd_dev->header.snapc = header->snapc;
@@ -7044,11 +7051,9 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 {
 	struct rbd_image_header	header = { 0 };
 	struct parent_image_info pii = { 0 };
-	u64 mapping_size;
 	int ret;
 
-	down_write(&rbd_dev->header_rwsem);
-	mapping_size = rbd_dev->mapping.size;
+	dout("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	ret = rbd_dev_header_info(rbd_dev, &header, false);
 	if (ret)
@@ -7064,18 +7069,13 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 			goto out;
 	}
 
+	down_write(&rbd_dev->header_rwsem);
 	rbd_dev_update_header(rbd_dev, &header);
 	if (rbd_dev->parent)
 		rbd_dev_update_parent(rbd_dev, &pii);
-
-	rbd_assert(!rbd_is_snap(rbd_dev));
-	rbd_dev->mapping.size = rbd_dev->header.image_size;
-
-out:
 	up_write(&rbd_dev->header_rwsem);
-	if (!ret && mapping_size != rbd_dev->mapping.size)
-		rbd_dev_update_size(rbd_dev);
 
+out:
 	rbd_parent_info_cleanup(&pii);
 	rbd_image_header_cleanup(&header);
 	return ret;
-- 
2.41.0

