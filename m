Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF1B862AB
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Aug 2019 15:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732929AbfHHNKy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Aug 2019 09:10:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33083 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732645AbfHHNKy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Aug 2019 09:10:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id c14so43449941plo.0;
        Thu, 08 Aug 2019 06:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kTRCLHiigbBDrn+iuRmixFu5QFRQn0XVTcwUbux7TsU=;
        b=tAA+DAKbPPDkZ3LQv01NV/WNsiFew0BrmPW+JrJf9MZ2a3dD5aPmIjQLdJFczBybWX
         YGkAVSqJeTetOB0GMAIONKspHMSbu5IJt56yS1kxHa0JfELB64JfCgVqYNms/XAs94ah
         EDd5QWupwrfIcGYh7A0WEFtKs5MljQmrLmpkWTExMuVhocNfUiQnIRlhFlERop2IW016
         jRzF3KNRQn5e9QkiL48rQA8P4OBRWT4J5Wgo2p86zu0U2laZcgvS6heRvQ2hDy+k/yR9
         vuL+Y2UZzlpbtAWT2r3pO2RIUmTCczCh1lmiKlt+JNLdZ3QnuDjXpe0RmdDA/AKjt86O
         4yzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kTRCLHiigbBDrn+iuRmixFu5QFRQn0XVTcwUbux7TsU=;
        b=Yq5FSAdxyuZfit3qErWrYZkKGPbzeJcWo+MLDos0frscOiL7rb9ArrileSxrBH7nfh
         hFqDbdn2apEF7/RX0dYrsxAI2CNgAj/1ZrgjhTupwSUMu2/BvGv3H6NFrZaLEavRv54+
         xtP3TOtTsKt2wmO9RWskTpL0hi/fO1x1RsI6Ta91mlnp0eS4gOE/el6cuIqxYdMcclNc
         ZpbqvYDuKoK1Auygxg1GZ+j2gVgjSDbmrh5F1sK02pI8wrGLop34oupZEg2uzREitEkf
         0i96WZMOcIGu980X/fw8BntzFW+jvLXajsrq3ea6CaT4SwZoframWhhBTElpm1OsSkkx
         Y82A==
X-Gm-Message-State: APjAAAXJtieAkV2BbO8AlI0qVDtzVYdYGHDHTLKP7BCT35+xSpuwCR5x
        tmBjSqAYiptSJE46kzVA8zQ=
X-Google-Smtp-Source: APXvYqzb3LTGlfNaHvIgIQAEIL8lGMTjdnS4OK96jy4BHunE6EAmlu2hvookmvlFtT9+ePuGirAJRA==
X-Received: by 2002:a17:902:ff05:: with SMTP id f5mr13216028plj.116.1565269853475;
        Thu, 08 Aug 2019 06:10:53 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id q22sm92394259pgh.49.2019.08.08.06.10.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 06:10:52 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Alex Elder <elder@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 2/3] rbd: Use refcount_t for refcount
Date:   Thu,  8 Aug 2019 21:10:48 +0800
Message-Id: <20190808131048.24695-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Reference counters are preferred to use refcount_t instead of
atomic_t.
This is because the implementation of refcount_t can prevent
overflows and detect possible use-after-free.
So convert atomic_t ref counters to refcount_t.

Since refcount_() APIs have checks for overflow and use-after-free,
the inc/dec_return_safe functions and the warnings are redundant
now. Remove them.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/block/rbd.c | 57 ++++++++-------------------------------------
 1 file changed, 10 insertions(+), 47 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3327192bb71f..74d2dddbe108 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -46,44 +46,12 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/workqueue.h>
+#include <linux/refcount.h>
 
 #include "rbd_types.h"
 
 #define RBD_DEBUG	/* Activate rbd_assert() calls */
 
-/*
- * Increment the given counter and return its updated value.
- * If the counter is already 0 it will not be incremented.
- * If the counter is already at its maximum value returns
- * -EINVAL without updating it.
- */
-static int atomic_inc_return_safe(atomic_t *v)
-{
-	unsigned int counter;
-
-	counter = (unsigned int)atomic_fetch_add_unless(v, 1, 0);
-	if (counter <= (unsigned int)INT_MAX)
-		return (int)counter;
-
-	atomic_dec(v);
-
-	return -EINVAL;
-}
-
-/* Decrement the counter.  Return the resulting value, or -EINVAL */
-static int atomic_dec_return_safe(atomic_t *v)
-{
-	int counter;
-
-	counter = atomic_dec_return(v);
-	if (counter >= 0)
-		return counter;
-
-	atomic_inc(v);
-
-	return -EINVAL;
-}
-
 #define RBD_DRV_NAME "rbd"
 
 #define RBD_MINORS_PER_MAJOR		256
@@ -438,7 +406,7 @@ struct rbd_device {
 
 	struct rbd_spec		*parent_spec;
 	u64			parent_overlap;
-	atomic_t		parent_ref;
+	refcount_t		parent_ref;
 	struct rbd_device	*parent;
 
 	/* Block layer tags. */
@@ -1680,21 +1648,19 @@ static void rbd_dev_unparent(struct rbd_device *rbd_dev)
  */
 static void rbd_dev_parent_put(struct rbd_device *rbd_dev)
 {
-	int counter;
+	bool is_dec_to_zero;
 
 	if (!rbd_dev->parent_spec)
 		return;
 
-	counter = atomic_dec_return_safe(&rbd_dev->parent_ref);
-	if (counter > 0)
+	is_dec_to_zero = refcount_dec_and_test_checked(&rbd_dev->parent_ref);
+	if (!is_dec_to_zero)
 		return;
 
 	/* Last reference; clean up parent data structures */
 
-	if (!counter)
+	if (is_dec_to_zero)
 		rbd_dev_unparent(rbd_dev);
-	else
-		rbd_warn(rbd_dev, "parent reference underflow");
 }
 
 /*
@@ -1707,20 +1673,17 @@ static void rbd_dev_parent_put(struct rbd_device *rbd_dev)
  */
 static bool rbd_dev_parent_get(struct rbd_device *rbd_dev)
 {
-	int counter = 0;
+	bool is_inc_suc = false;
 
 	if (!rbd_dev->parent_spec)
 		return false;
 
 	down_read(&rbd_dev->header_rwsem);
 	if (rbd_dev->parent_overlap)
-		counter = atomic_inc_return_safe(&rbd_dev->parent_ref);
+		is_inc_suc = refcount_inc_not_zero_checked(&rbd_dev->parent_ref);
 	up_read(&rbd_dev->header_rwsem);
 
-	if (counter < 0)
-		rbd_warn(rbd_dev, "parent reference overflow");
-
-	return counter > 0;
+	return is_inc_suc;
 }
 
 /*
@@ -6823,7 +6786,7 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 		goto out_err;
 
 	rbd_dev->parent = parent;
-	atomic_set(&rbd_dev->parent_ref, 1);
+	refcount_set(&rbd_dev->parent_ref, 1);
 	return 0;
 
 out_err:
-- 
2.20.1

