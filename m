Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6294315CB1D
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 20:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgBMTZp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 14:25:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42103 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgBMTZo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 14:25:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id k11so8095257wrd.9
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 11:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NmLXxKBCsTPcondIxrW0UsmJUv9LkhHy3/AG7jONab4=;
        b=ZTsxShvB+s0dxUMTNj6mQNVUFwwP8dcP2jMv5/kdAUNQI29oWIvUp7PJp1LX/VwKjg
         BM6ZRDpDWD83JCbuymVy2a+jBxvPARWf4tDtXCMEIXvuoVcNKTu8gxutQJ/y/C0ak1bw
         7O3G9tkT5TpZ6YPXFga7bMDG87EzLwcWbGnXexy0wiqGdx0KMtoqYVbjsMdpRVNPUB6V
         jqMOSwcg+NXBME+HSaJIpN/y8QViPQJCeIMg2ca3lkbI5+BHn0tZqLdjkCkTUV5idplw
         COqTd3MedKYMXApWDS4wx00W9poDVuo1dq75TS/hpYJCbDsSXgbVUrgwYdriVDMcvtFI
         fwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NmLXxKBCsTPcondIxrW0UsmJUv9LkhHy3/AG7jONab4=;
        b=VbwmVWOkzyjwcFpl0lde4K82UHapJpJyRDqoebgzBtCLBP+EblImh2oYsGCNATucgi
         DCm9OOOJe5RB1uExxeNKQYMX6mtDCb1MyYtxGaRiLumFtXMM+ZKFE/8U3N/4FxcJYOs2
         htF3f0aL7gXLzsIIvW1j4VX2h5zX8r8qSKHoedQ+hAlVEEpbmpB66S7lRW4foaiCCrfB
         FBx8w0YHLI11RUcgwb4aZXz98ZY7GsYtV+caL+qe3Wm9irZuxQYpESuwKt1/QOnBBV/n
         k3O19jB+rb/jOgmDSus3Q8xdAFGz6/0LVIQv/NiOJSzEr5Y5aw7ileWlhCOPn7ZHv2XK
         RF8w==
X-Gm-Message-State: APjAAAW1ThBTRxsnp9e6uSfF2RPIBsf78aoPr0khhH8mwf8bE6pgDU8R
        cfSswO1RnXxSLF1Sv0OXGDSoVXnY9Kg=
X-Google-Smtp-Source: APXvYqx9VMBXFF7sRUlsIKnYsvQDXSh6cWDyx3AHVYt3EjqvYl9tEBXkyBWfelZ+B7stT9mQ8RpsjA==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr22425938wru.382.1581621942166;
        Thu, 13 Feb 2020 11:25:42 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 21sm4326227wmo.8.2020.02.13.11.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:25:41 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] rbd: kill img_request kref
Date:   Thu, 13 Feb 2020 20:26:02 +0100
Message-Id: <20200213192606.31194-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200213192606.31194-1-idryomov@gmail.com>
References: <20200213192606.31194-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

The reference counter is never increased, so we can as well call
rbd_img_request_destroy() directly and drop the kref.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/rbd.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index f206edbbc5d3..22d524a0e98b 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -349,7 +349,6 @@ struct rbd_img_request {
 	struct pending_result	pending;
 	struct work_struct	work;
 	int			work_result;
-	struct kref		kref;
 };
 
 #define for_each_obj_request(ireq, oreq) \
@@ -1320,15 +1319,6 @@ static void rbd_obj_request_put(struct rbd_obj_request *obj_request)
 	kref_put(&obj_request->kref, rbd_obj_request_destroy);
 }
 
-static void rbd_img_request_destroy(struct kref *kref);
-static void rbd_img_request_put(struct rbd_img_request *img_request)
-{
-	rbd_assert(img_request != NULL);
-	dout("%s: img %p (was %d)\n", __func__, img_request,
-		kref_read(&img_request->kref));
-	kref_put(&img_request->kref, rbd_img_request_destroy);
-}
-
 static inline void rbd_img_obj_request_add(struct rbd_img_request *img_request,
 					struct rbd_obj_request *obj_request)
 {
@@ -1656,19 +1646,15 @@ static struct rbd_img_request *rbd_img_request_create(
 	INIT_LIST_HEAD(&img_request->lock_item);
 	INIT_LIST_HEAD(&img_request->object_extents);
 	mutex_init(&img_request->state_mutex);
-	kref_init(&img_request->kref);
 
 	return img_request;
 }
 
-static void rbd_img_request_destroy(struct kref *kref)
+static void rbd_img_request_destroy(struct rbd_img_request *img_request)
 {
-	struct rbd_img_request *img_request;
 	struct rbd_obj_request *obj_request;
 	struct rbd_obj_request *next_obj_request;
 
-	img_request = container_of(kref, struct rbd_img_request, kref);
-
 	dout("%s: img %p\n", __func__, img_request);
 
 	WARN_ON(!list_empty(&img_request->lock_item));
@@ -2885,7 +2871,7 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 					      obj_req->copyup_bvecs);
 	}
 	if (ret) {
-		rbd_img_request_put(child_img_req);
+		rbd_img_request_destroy(child_img_req);
 		return ret;
 	}
 
@@ -3644,7 +3630,7 @@ static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
 	if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
 		struct rbd_obj_request *obj_req = img_req->obj_request;
 
-		rbd_img_request_put(img_req);
+		rbd_img_request_destroy(img_req);
 		if (__rbd_obj_handle_request(obj_req, &result)) {
 			img_req = obj_req->img_request;
 			goto again;
@@ -3652,7 +3638,7 @@ static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
 	} else {
 		struct request *rq = img_req->rq;
 
-		rbd_img_request_put(img_req);
+		rbd_img_request_destroy(img_req);
 		blk_mq_end_request(rq, errno_to_blk_status(result));
 	}
 }
@@ -4798,7 +4784,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 	return;
 
 err_img_request:
-	rbd_img_request_put(img_request);
+	rbd_img_request_destroy(img_request);
 err_rq:
 	if (result)
 		rbd_warn(rbd_dev, "%s %llx at %llx result %d",
-- 
2.19.2

