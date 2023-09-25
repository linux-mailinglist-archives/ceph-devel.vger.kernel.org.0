Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484307ADFA6
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Sep 2023 21:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjIYTlF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Sep 2023 15:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjIYTlE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Sep 2023 15:41:04 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E08101
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 12:40:57 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-50325ce89e9so12036230e87.0
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 12:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695670856; x=1696275656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uluF7rC4DV182er+Ikvn30IR/aP2+rtAmb+5lqBFiGI=;
        b=PxAHOJ1E6ONLFDOqbYg+KzYYfk1WPgob6ZHnJ7MG/t/grXMLiqnlpPiT2gEvu4srTE
         S76WbQqFkpOqh0jFUtm47okLEmAy2x3DxtRETkvz/+2I/CQoZX/vgTL8bLBlij/fTJlO
         WJB3GN4/WPIcFHYFDhanarCkFO5z918eZk4+LpfpGkkURMH9/sZilBm6+tmINEy6D3Uu
         bRcVbON14jxMxd9T/qR1vo+6w+ioTGkjw46oXn90nDOQnEbN2H6+Xj/NXnoDRb65iSi1
         jwluhJu+9I5bgqrnMRx2mTZwQ+prCQ00thsyEHwDpUgiECn1nGZNTb3Wsw7SHmSLoZQb
         FPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695670856; x=1696275656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uluF7rC4DV182er+Ikvn30IR/aP2+rtAmb+5lqBFiGI=;
        b=LQCtXX5FUmR/DL/KiqllmqEm7A2o0hsOSCtI6XpjHXpIKmyLcqiwmFk9j6rjhEFi9k
         76R2jVisqwIaAYVPiROU5yZt6DnXGg1FFM5MqESyEXGd0kP5c0/ZV/d2EzuOyRl8MmAJ
         plokm9Pcji979CeCmGJhB1PZFVhJ1W0G30AQhqcwSdIORf90PhccXx8eI7AnjPHAQ/vA
         1dRmuLoezmZHUtKaa0qgG2h6aq5+DRuBrc2ONn8PJubLt9/1qIejp3NbSQuRQNncQuK/
         l+N5tTfsd25p3+DmHBIUA70OWo7AOtQx9KTXNbgXUf9fE0wDkeNg3wdg9meYvJYPtYN/
         724A==
X-Gm-Message-State: AOJu0YxBkIQhJQ+QQ94PcmWwQC/rhHq2UT624hnV3Tcw1gqx0K4b2QD/
        RcUkobfmMJtE/8SK+Nz/SrPFPYLcdNQ=
X-Google-Smtp-Source: AGHT+IF7Wj75LpIGuB8uW0xf9PpjdefRiNEGdCcMgMWjn1/NQ8F4IPAgRWr7PyEwlnQiibk1CvWlAw==
X-Received: by 2002:a19:6710:0:b0:500:9a15:9054 with SMTP id b16-20020a196710000000b005009a159054mr5809904lfc.20.1695670855556;
        Mon, 25 Sep 2023 12:40:55 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id en13-20020a056402528d00b005340d9d042bsm1762365edb.40.2023.09.25.12.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 12:40:54 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 1/4] rbd: move rbd_dev_refresh() definition
Date:   Mon, 25 Sep 2023 21:40:31 +0200
Message-ID: <20230925194036.197899-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230925194036.197899-1-idryomov@gmail.com>
References: <20230925194036.197899-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Move rbd_dev_refresh() definition further down to avoid having to
move struct parent_image_info definition in the next commit.  This
spares some forward declarations too.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 68 ++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3de11f077144..5da001f1fe94 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -633,8 +633,6 @@ static void rbd_dev_remove_parent(struct rbd_device *rbd_dev);
 
 static int rbd_dev_refresh(struct rbd_device *rbd_dev);
 static int rbd_dev_v2_header_onetime(struct rbd_device *rbd_dev);
-static int rbd_dev_header_info(struct rbd_device *rbd_dev);
-static int rbd_dev_v2_parent_info(struct rbd_device *rbd_dev);
 static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
 					u64 snap_id);
 static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
@@ -4931,39 +4929,6 @@ static void rbd_dev_update_size(struct rbd_device *rbd_dev)
 	}
 }
 
-static int rbd_dev_refresh(struct rbd_device *rbd_dev)
-{
-	u64 mapping_size;
-	int ret;
-
-	down_write(&rbd_dev->header_rwsem);
-	mapping_size = rbd_dev->mapping.size;
-
-	ret = rbd_dev_header_info(rbd_dev);
-	if (ret)
-		goto out;
-
-	/*
-	 * If there is a parent, see if it has disappeared due to the
-	 * mapped image getting flattened.
-	 */
-	if (rbd_dev->parent) {
-		ret = rbd_dev_v2_parent_info(rbd_dev);
-		if (ret)
-			goto out;
-	}
-
-	rbd_assert(!rbd_is_snap(rbd_dev));
-	rbd_dev->mapping.size = rbd_dev->header.image_size;
-
-out:
-	up_write(&rbd_dev->header_rwsem);
-	if (!ret && mapping_size != rbd_dev->mapping.size)
-		rbd_dev_update_size(rbd_dev);
-
-	return ret;
-}
-
 static const struct blk_mq_ops rbd_mq_ops = {
 	.queue_rq	= rbd_queue_rq,
 };
@@ -7043,6 +7008,39 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	return ret;
 }
 
+static int rbd_dev_refresh(struct rbd_device *rbd_dev)
+{
+	u64 mapping_size;
+	int ret;
+
+	down_write(&rbd_dev->header_rwsem);
+	mapping_size = rbd_dev->mapping.size;
+
+	ret = rbd_dev_header_info(rbd_dev);
+	if (ret)
+		goto out;
+
+	/*
+	 * If there is a parent, see if it has disappeared due to the
+	 * mapped image getting flattened.
+	 */
+	if (rbd_dev->parent) {
+		ret = rbd_dev_v2_parent_info(rbd_dev);
+		if (ret)
+			goto out;
+	}
+
+	rbd_assert(!rbd_is_snap(rbd_dev));
+	rbd_dev->mapping.size = rbd_dev->header.image_size;
+
+out:
+	up_write(&rbd_dev->header_rwsem);
+	if (!ret && mapping_size != rbd_dev->mapping.size)
+		rbd_dev_update_size(rbd_dev);
+
+	return ret;
+}
+
 static ssize_t do_rbd_add(const char *buf, size_t count)
 {
 	struct rbd_device *rbd_dev = NULL;
-- 
2.41.0

