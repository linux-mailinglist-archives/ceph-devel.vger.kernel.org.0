Return-Path: <ceph-devel+bounces-3031-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9031CABB543
	for <lists+ceph-devel@lfdr.de>; Mon, 19 May 2025 08:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DCA3189086D
	for <lists+ceph-devel@lfdr.de>; Mon, 19 May 2025 06:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045D8245006;
	Mon, 19 May 2025 06:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ey3A3LmG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590EA1CF96;
	Mon, 19 May 2025 06:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747636739; cv=none; b=IJ9pb+jniGdrhYma7DcmhWHTDoag+HCiuxMfjaaP6gEhQGWMy94ic45BSCU2CXiDjKKxV7YqdZwhyzZbQsAjVIMWx/fNGuEA2uGuYnrFybL9JYhOGgGWdWhQlFBJ/nrwbgHXIzsSfaHPGFqaXRkLYennNJVxRPtK7jD7yNo2irk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747636739; c=relaxed/simple;
	bh=YYkciApprTBW61Xe2c/9f1R4usCCh7pTaYq7TehA6mk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MIpHgZTFf9mWZTtanPvBJe8Cd1hPt+aJR8qYa4RSgrIU9w8OMzrSWPr54QnHDGC0KVnKvLBlR6lQ0jJJZ4afiuobG74y4F8JZcWFD5tgfns3c0TGmIFITNwtnbfPzq2e7CI1Kr35burdDIDQKIQqq4/9zw3VnXHjihAFJmrXQ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ey3A3LmG; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-742c7a52e97so655516b3a.3;
        Sun, 18 May 2025 23:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747636735; x=1748241535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tifdmFQDJps1lChYSd+EGnHuJQb6A1Xc67Aae2G0Ozs=;
        b=Ey3A3LmGDOgsG9sMHqhNntPDCpcm2jghddK5e6e27IxifeL4wPhkwKOLt3hl9LRw8+
         t/zE2ukeQ/9A0/DefQ3GM9kdawNvM6nK6EY4uVhPEXe2CWnQmGMVFnGt2xvCtCdngXfo
         J2MLM+kLjuEOx5rB/emWnodRh3qmbdBO6MXMP0GttYgCXpGo2AKpL+TffYi0Hwvk78hb
         dZJ3SL8XfC5LGXQ6E/7Vj9vZu5WMW7VtD6An4Q+P3wPIiO32nf3B7pOS1XTIRYQQXxRY
         qX2jJ95fodcHarRZWQwQxIL8/4eMZ2kurwQqUM/kizxh9oWPzronjSrRsJuXRm1cV0qW
         a4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747636735; x=1748241535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tifdmFQDJps1lChYSd+EGnHuJQb6A1Xc67Aae2G0Ozs=;
        b=U79MH8XK3TTD8Ye4zCDlU5Ni8dzL7zrfna7x0A7SFerlAPc5p92tSBY9v3b3QxU1qq
         oi/7hfzMxo+jpRTXJl0QXwW2OjM6wbvk37YVwvmrMYsgydcKYx6Z24pIwpnABhxwPPJc
         SnfKBUCGewgJGpcVhDdcqYXHhK4MEPFplN+oS+NUsDAmwsJPJtyrLaHJYgMj7wfHZh8S
         C/HmQiHDNQzr/hgKxTvcxOWR3zUwRiZNSwsLrZLQ/Ls+MsQ6OlmwQZulja380coiJl8q
         k/Mwkyls2MLO5d1VDu4/26aVxSl9IpXQEP+ANyzojhRCcLl5g8G+ejE5GI5h+gGQsgYg
         QzVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0+rrt2Cz5VN70I1LGUHbH+PkOWNx3Z9/LeUrAEhz2Nvxq2SGprI4NaZvfCkEewfpLA4Nt2B3DOwvBflh/@vger.kernel.org, AJvYcCWbi/XkMs+nkthFtVV+w52Gpw7nVRoGr1Lkp98xNOKS4j8vUYdqyPlVZev4s3uwJze04IZY2SN+8R0nMnw=@vger.kernel.org, AJvYcCWkC8u3hPTO6iv7CcJoHMHFsGn9TetfY1wHWCbgtj/Etz76Fpb58YcDF/+Zbq2HnNblKIWZdcOK85lX@vger.kernel.org
X-Gm-Message-State: AOJu0YzPR8I5GYRNhkYSb29NxdtpkFOPgtULxgpTfnPy5Z4yX1TvZDPF
	PEfj3XR0Po4PDGnRAQAfJILhLkFf9N+0NB/ltwJEeLoYX7J+fb1/3pGH
X-Gm-Gg: ASbGncvE0kPVavc/snrUNytlWs31yowDf2almu66bFHoeSX8rq+kKSUnSAlPlP7G+LC
	hXtIXemxNysjVI0Ih6f39Lnd4eMz34TATMzY/TtjQWDVItuI1aHnwGhSRm+OYIR2Jy/requNACr
	4An8wK/W/r68gy4a5fTPLY2O+8aqMIDliy9TsPzIt8FPkgKPDYebGFQpu52r37R2+uWIBhgrwAc
	gms1KJwzd3DbKHITseXdgv2ZEAasgJoSFSHjf9zYMBe1qtxGCxU7iofpCCCb/seDPRQfMi9Jb8I
	PZbU4/6Q4nUFf9xB2qg8N9oyXJzEZRPzqYhbUCWrPKlYoNksTRAATrQ1znMykCKq/DRjagzXuss
	1IFzB
X-Google-Smtp-Source: AGHT+IE0+x8T6yBOyXZm3n8hjZVHiqQVnT7RuAZSE6vgPmNBV8XDAuXI7A4vPj6D0DoaDsVXQdlcGA==
X-Received: by 2002:a05:6a00:4c87:b0:730:9502:d564 with SMTP id d2e1a72fcca58-742acce2c1cmr15866160b3a.14.1747636735478;
        Sun, 18 May 2025 23:38:55 -0700 (PDT)
Received: from sid-Inspiron-15-3525.. ([106.222.230.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a98a3403sm5659042b3a.177.2025.05.18.23.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 23:38:55 -0700 (PDT)
From: Siddarth Gundu <siddarthsgml@gmail.com>
To: idryomov@gmail.com,
	dongsheng.yang@easystack.cn,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: elder@ieee.org,
	Siddarth Gundu <siddarthsgml@gmail.com>
Subject: [PATCH v2] rbd: replace strcpy() with strscpy()
Date: Mon, 19 May 2025 12:08:40 +0530
Message-ID: <20250519063840.6743-1-siddarthsgml@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strcpy() is deprecated; use strscpy() instead.

Both the destination and source buffer are of fixed length
so strscpy with 2-arguments is used.

Introduce a typedef for cookie array to improve code clarity.

Link: https://github.com/KSPP/linux/issues/88
Signed-off-by: Siddarth Gundu <siddarthsgml@gmail.com>
---
changes since v1
- added a typedef for cookie arrays

About the typedef: I was a bit hesitant to add it since the kernel
style guide is against adding new typedef but I wanted to follow 
the review feedback for this.

 drivers/block/rbd.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index faafd7ff43d6..863d9c591aa5 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -46,11 +46,14 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/workqueue.h>
+#include <linux/string.h>
 
 #include "rbd_types.h"
 
 #define RBD_DEBUG	/* Activate rbd_assert() calls */
 
+typedef char rbd_cookie_t[32];
+
 /*
  * Increment the given counter and return its updated value.
  * If the counter is already 0 it will not be incremented.
@@ -411,7 +414,7 @@ struct rbd_device {
 
 	struct rw_semaphore	lock_rwsem;
 	enum rbd_lock_state	lock_state;
-	char			lock_cookie[32];
+	rbd_cookie_t		lock_cookie;
 	struct rbd_client_id	owner_cid;
 	struct work_struct	acquired_lock_work;
 	struct work_struct	released_lock_work;
@@ -3649,12 +3652,12 @@ static void format_lock_cookie(struct rbd_device *rbd_dev, char *buf)
 	mutex_unlock(&rbd_dev->watch_mutex);
 }
 
-static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
+static void __rbd_lock(struct rbd_device *rbd_dev, const rbd_cookie_t cookie)
 {
 	struct rbd_client_id cid = rbd_get_cid(rbd_dev);
 
 	rbd_dev->lock_state = RBD_LOCK_STATE_LOCKED;
-	strcpy(rbd_dev->lock_cookie, cookie);
+	strscpy(rbd_dev->lock_cookie, cookie);
 	rbd_set_owner_cid(rbd_dev, &cid);
 	queue_work(rbd_dev->task_wq, &rbd_dev->acquired_lock_work);
 }
@@ -3665,7 +3668,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
 static int rbd_lock(struct rbd_device *rbd_dev)
 {
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
-	char cookie[32];
+	rbd_cookie_t cookie;
 	int ret;
 
 	WARN_ON(__rbd_is_lock_owner(rbd_dev) ||
@@ -4581,7 +4584,7 @@ static void rbd_unregister_watch(struct rbd_device *rbd_dev)
 static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
 {
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
-	char cookie[32];
+	rbd_cookie_t cookie;
 	int ret;
 
 	if (!rbd_quiesce_lock(rbd_dev))
-- 
2.43.0


