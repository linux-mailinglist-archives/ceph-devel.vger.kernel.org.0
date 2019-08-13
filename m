Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4628AFCE
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Aug 2019 08:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfHMGQs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Aug 2019 02:16:48 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42403 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727371AbfHMGQr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Aug 2019 02:16:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id p3so392785pgb.9;
        Mon, 12 Aug 2019 23:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nL9PyzNKtAFr+Adeyaa0mv/ZBzbqceeQurZwipQbI9U=;
        b=M6a1lbX/QMKRBowg/REKBlhpahKFtMjvvZG2VZlHVhn8xWNE8HMKDSiu2uNAFYXTLH
         2az6Yz3meyyw5ob2HxAIYn3xlyYIZMsvr2BQShotqy9pxElgOb+4QqW6Ep/62XLU1n2w
         Vn/JWUFBYYG/i9oCq4qlSuAAdxX0e1Qqjy+CsNXrl80Q2ymuwCSg0PKeZ5zvDOYU0+CX
         a9y/1guN+eb+Ug6IiLSvmIB5eyENxmN5kpxxLT8zs3ezLZf1RILCDSFpz4GhvzUU4RgM
         Tj1tTp95hpuvfucv6lwUcCjHiAn5rk7bJt2IrhJazdYtQy5UthwgjeNagIUw28xYOMqr
         if+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nL9PyzNKtAFr+Adeyaa0mv/ZBzbqceeQurZwipQbI9U=;
        b=UCtaFwH9HHLraucVm1E1/GgtwklTWVWgheGQABtuNHPFsFO932ZMVFjtt11PHUJb/A
         qSeTDlTmpsIgjPJGFs19dOqkGmM/nv8O2hNRaa7s9pVzisuI0uL//4+ZYDKNVp/Dr5QO
         b4uw5pG/sC7cGL8fu9s4p+0UH77el1HnImzM9okpQWlL6RMXF8HZti8fuCu58ssMpRZW
         +MPpIGTPfltAaFrdRd+5uZJ8i+phnYe39Gavu/M1vKvrU0xecZjb0CoglGBsXJ9aUBNI
         Wjg+XnMIXHEQHMwPwWAHmiPFK6/HszDgNfBobmJZ4fxZJ25o5iDu51FxGWntzz9xQQTi
         +wSQ==
X-Gm-Message-State: APjAAAUbob5WLLkvNJpS2CFCho27ISvj1NWcuMDus+ZLINYg+roCN58E
        4Y8J31F+a2jYw7VqhsQ3a/E=
X-Google-Smtp-Source: APXvYqwLQhlZXFxPe2sOgdGVt1EiVo8WOfWlft8uB5djhw5MMQlc564Zq6Rna3xdpeGiEnuUOI9g6Q==
X-Received: by 2002:a17:90a:eb08:: with SMTP id j8mr772974pjz.72.1565677006908;
        Mon, 12 Aug 2019 23:16:46 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id k5sm6062037pfg.167.2019.08.12.23.16.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 23:16:46 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Alex Elder <elder@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 2/3] rbd: Use refcount_t for refcount
Date:   Tue, 13 Aug 2019 14:16:41 +0800
Message-Id: <20190813061641.5428-1-hslester96@gmail.com>
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

