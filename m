Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB996A33C6
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Feb 2023 20:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjBZTwh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 14:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBZTwg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 14:52:36 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75CB14E8D
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 11:52:34 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bt28so4163473wrb.8
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 11:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+mhgiuohrDIxuOX3p/LswwS5sIKFu54QPK8z4IsMbWs=;
        b=YejGuIbFquYM2OFlWq0zVG0UaFc+hueGy06/7v2zZ0diUKNHB5K6yWe1p5NJXo0ZBy
         L1ALubAkofb0gYWYG7G+zBAjIbPiei3wQbCoC/tGNxundvIQPMSNzqzU46ov3XGy499K
         BA5dTlmfV7YHojFqYrM0pNJSYM7kPfNYirAjuiCVKguRs1qpPYfezvU35Zp4vbn54hNX
         8zJWC8uWH67kVHszCYiEW88umZ0cDP2tFEeeOg/1r3K9S3ZpjXYkMwX+u+PYm4cQg9vC
         mbhmO5CXBgSKhTIjaVfS/FJ43e9TtSqNb99XMGyfY1cwdwCnP9bXO918flDyhGOYrrjL
         OR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mhgiuohrDIxuOX3p/LswwS5sIKFu54QPK8z4IsMbWs=;
        b=jXiOrLVbJtLtSG0sbme9IbhGWmplZXvt1TwOQRDt/54YzK3OxBmhTxJBMKG8ePoCgf
         U8TrMwTAyvs/WRKoTuUKsvC0k3hxqLlvna0sed87ud4qUNCwwSIg0K1fsGu0Qb2rW9VL
         GUqz00Wn7BIrdeEVhrjwiYCYaHQ6TtKjG4ul8YupVPgt4+pYvYUPoSufSsxSN+f4kE9l
         UhRMRyzYDqJ0W0Nbug7Nr7EpBnigS493FdThAF1Lnzlly6iayAoKtxJ6cTMCegSLJ90R
         nMRVUaQiPTadZJVjYj/ThC3IzxM+DNdac/IFI5o7KpJTRlMgL5EwMY+DZpEMCqf2wSTC
         nktg==
X-Gm-Message-State: AO0yUKXP/sXriSc0P7dq+FCO5xsZb0/enbZM+p43iK6kFFE1oHwIV2CH
        GXZ3iC0fWg2+jN4h6GLHDY6iNa0RTxY=
X-Google-Smtp-Source: AK7set/ii5/cOrnVBdgSPLIIYxuydLXn/tLJBZviC/a5bOZbvvwSEkNGFexmLhNFrmPXMx5UUYrRpA==
X-Received: by 2002:adf:ce0b:0:b0:2c6:e827:21c1 with SMTP id p11-20020adfce0b000000b002c6e82721c1mr17025816wrn.50.1677441153311;
        Sun, 26 Feb 2023 11:52:33 -0800 (PST)
Received: from zambezi.local (ip-94-112-104-28.bb.vodafone.cz. [94.112.104.28])
        by smtp.gmail.com with ESMTPSA id x14-20020adfec0e000000b002c54536c662sm5071170wrn.34.2023.02.26.11.52.32
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 11:52:32 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails
Date:   Sun, 26 Feb 2023 20:52:27 +0100
Message-Id: <20230226195227.185393-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.39.1
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

If getting an ID or setting up a work queue in rbd_dev_create() fails,
use-after-free on rbd_dev->rbd_client, rbd_dev->spec and rbd_dev->opts
is triggered in do_rbd_add().  The root cause is that the ownership of
these structures is transfered to rbd_dev prematurely and they all end
up getting freed when rbd_dev_create() calls rbd_dev_free() prior to
returning to do_rbd_add().

Found by Linux Verification Center (linuxtesting.org) with SVACE, an
incomplete patch submitted by Natalia Petrova <n.petrova@fintech.ru>.

Cc: stable@vger.kernel.org
Fixes: 1643dfa4c2c8 ("rbd: introduce a per-device ordered workqueue")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 04453f4a319c..60aed196a2e5 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5292,8 +5292,7 @@ static void rbd_dev_release(struct device *dev)
 		module_put(THIS_MODULE);
 }
 
-static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
-					   struct rbd_spec *spec)
+static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
 {
 	struct rbd_device *rbd_dev;
 
@@ -5338,9 +5337,6 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
 	rbd_dev->dev.parent = &rbd_root_dev;
 	device_initialize(&rbd_dev->dev);
 
-	rbd_dev->rbd_client = rbdc;
-	rbd_dev->spec = spec;
-
 	return rbd_dev;
 }
 
@@ -5353,12 +5349,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
 {
 	struct rbd_device *rbd_dev;
 
-	rbd_dev = __rbd_dev_create(rbdc, spec);
+	rbd_dev = __rbd_dev_create(spec);
 	if (!rbd_dev)
 		return NULL;
 
-	rbd_dev->opts = opts;
-
 	/* get an id and fill in device name */
 	rbd_dev->dev_id = ida_simple_get(&rbd_dev_id_ida, 0,
 					 minor_to_rbd_dev_id(1 << MINORBITS),
@@ -5375,6 +5369,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
 	/* we have a ref from do_rbd_add() */
 	__module_get(THIS_MODULE);
 
+	rbd_dev->rbd_client = rbdc;
+	rbd_dev->spec = spec;
+	rbd_dev->opts = opts;
+
 	dout("%s rbd_dev %p dev_id %d\n", __func__, rbd_dev, rbd_dev->dev_id);
 	return rbd_dev;
 
@@ -6736,7 +6734,7 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 		goto out_err;
 	}
 
-	parent = __rbd_dev_create(rbd_dev->rbd_client, rbd_dev->parent_spec);
+	parent = __rbd_dev_create(rbd_dev->parent_spec);
 	if (!parent) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -6746,8 +6744,8 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 	 * Images related by parent/child relationships always share
 	 * rbd_client and spec/parent_spec, so bump their refcounts.
 	 */
-	__rbd_get_client(rbd_dev->rbd_client);
-	rbd_spec_get(rbd_dev->parent_spec);
+	parent->rbd_client = __rbd_get_client(rbd_dev->rbd_client);
+	parent->spec = rbd_spec_get(rbd_dev->parent_spec);
 
 	__set_bit(RBD_DEV_FLAG_READONLY, &parent->flags);
 
-- 
2.39.1

