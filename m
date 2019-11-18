Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED3EF1006A4
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfKRNig (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36872 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfKRNie (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id t1so19516347wrv.4
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NF9NCOiEjVY37tjt3beWLkGdWem+1qOnCPXXKFY7H5c=;
        b=H24JrVxvl/fZLaMmUf8hU3a8WI+lOvdCemjTpmpZEu+nPjMIdGKJlce+8KLqInV9KE
         8IvPYRd+VyuVI1xCEVcsItqmoYag3WMkphWIsLyKgxJVjxw0X652ZCcdg/ih7Qvnb4ow
         PD9wWITw2je2l7O2xFKhCgSRbXwS2t5JHf7DrNs6YfxaKqa2RmYA1ntUtfFGj9wmHwuU
         Nj4VVkJxpWx1g3k5lI/vbaPx1t/oId1w3oUK3pWYhXR8ycxyZCL6rkqct1TMdWDAz3m3
         EThk2/cY+1kO2uZrfNJjWsgcEaD4R4320nXbiZb4VKnZnKGifn60jX6b5cG9N615eH4Y
         5CmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NF9NCOiEjVY37tjt3beWLkGdWem+1qOnCPXXKFY7H5c=;
        b=XOWJxmX+lf75iBPqaEo11+YmB+2TI87MRBiA2iiW863rVkQT/osl5CBYZ/wQvsggRP
         gwp2Q+4f32LswVQEve34dq+YZTqLToZDfS5008o91oL0t75ahjHrPQ2ArZ+D2OHavtJi
         RJdamK1JjlSomyDmGaD6BBYXfdBN6uOA14kTlsBBalEIkHJS9wrM4+1+pgvd/DiQvtOT
         J8csVdST1FLqk0s/0Ri27E1pSsGrVptqFwbijp1vwIPFvUZsML9TYSq7ZR4rMNOmkCQZ
         yeJAlhEAf1817BNoDblnZ3/1JoO6/b/pHPo1mYmQvjVN/Te61Fen2/Jy4D0ucKD5sWpz
         mImQ==
X-Gm-Message-State: APjAAAUFPxB4CDh0bYCO3Dry2YGTLCENAKWpDCkMnJC6RZXPSZJofS1e
        5RKbNEZl7J6WAwrb1IdjAJZ2zUho
X-Google-Smtp-Source: APXvYqyrs10YUN4a1hqACUdN/DOoLBE5TlLwtdC1Q/Evc9qzxyD/sLmpLwmqCJ3w6M/Ad22VOxIjTw==
X-Received: by 2002:adf:b199:: with SMTP id q25mr32278397wra.320.1574084313161;
        Mon, 18 Nov 2019 05:38:33 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.32
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:32 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 5/9] rbd: don't acquire exclusive lock for read-only mappings
Date:   Mon, 18 Nov 2019 14:38:12 +0100
Message-Id: <20191118133816.3963-6-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A read-only mapping should be usable with read-only OSD caps, so
neither the header lock nor the object map lock can be acquired.
Unfortunately, this means that images mapped read-only lose the
advantage of the object map.

Snapshots, however, can take advantage of the object map without
any exclusionary locks, so if the object map is desired, snapshot
the image and map the snapshot instead of the image.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 979203cd934c..aaa359561356 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1833,6 +1833,17 @@ static u8 rbd_object_map_get(struct rbd_device *rbd_dev, u64 objno)
 
 static bool use_object_map(struct rbd_device *rbd_dev)
 {
+	/*
+	 * An image mapped read-only can't use the object map -- it isn't
+	 * loaded because the header lock isn't acquired.  Someone else can
+	 * write to the image and update the object map behind our back.
+	 *
+	 * A snapshot can't be written to, so using the object map is always
+	 * safe.
+	 */
+	if (!rbd_is_snap(rbd_dev) && rbd_is_ro(rbd_dev))
+		return false;
+
 	return ((rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) &&
 		!(rbd_dev->object_map_flags & RBD_FLAG_OBJECT_MAP_INVALID));
 }
@@ -3556,7 +3567,7 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
 	if (!(rbd_dev->header.features & RBD_FEATURE_EXCLUSIVE_LOCK))
 		return false;
 
-	if (rbd_is_snap(rbd_dev))
+	if (rbd_is_ro(rbd_dev))
 		return false;
 
 	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
@@ -6677,7 +6688,7 @@ static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
 		return -EINVAL;
 	}
 
-	if (rbd_is_snap(rbd_dev))
+	if (rbd_is_ro(rbd_dev))
 		return 0;
 
 	rbd_assert(!rbd_is_lock_owner(rbd_dev));
-- 
2.19.2

