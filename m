Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20A355239
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbfFYOlU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37572 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731158AbfFYOlU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so3256268wme.2
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R5Y6YY2EprO0T/O9tPp8lzbdyDH4MC8yxH6mA6CuYpE=;
        b=ciJOH37zjC5IDssjAF2DzCsQhFV5b+TJM98VU+VQlo/rgMVIGPO1KJYKl+zxxM7Kdp
         8rT7bBYt329eoYg581/ww+bzGWnjtDouyBN59tXBpkUXBfJz6YrBkf56WvvPdubQDhXL
         6ystToLzKPndUowPNToBqBps4EUrimygx66V0zmPSMUp5944Oa6aNh4BcvNY3xVwf1q5
         02UmP/oqkyGFf79/A5df4yqVFD5/APJVeFATqomCbkQ76dMtaSB6F0dI4goiRUMshCII
         cdNMB6zAQxC38sa8eWXJmU3uwinb7VaKh4CaWOSIOvH0xzeOG2emsLxsgzOgTztSSiX2
         ml2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R5Y6YY2EprO0T/O9tPp8lzbdyDH4MC8yxH6mA6CuYpE=;
        b=UUe9TF8mR5CfUlvB7ylmBKuUALvMwta83oUjFt5t+ftiYO+yYeUyQJX2iiSP+XiRsC
         hBdEmSeam1zWGR9DYLSaXGSKZLP1RRqlxpG3q9mC27iRz+K4L4d6XRdiwaJE8jCNcqbS
         hTwYqpGyPIxqKG4yN5hlyTPfzPNSIpUubiEBeuC7O7FeleHEsm7QaIwIdtrvZsnwpwWF
         fSv/s1XweZVTCQEFppoqWrAZ0vNA96/z6LT7xCtJBnDhaYlM+LXiZzNd/+CODnpMxiUT
         8OREI6mfpz1rvb9OfxaAE3bggOFv38rJF0yC5R8w9sXxkPsafrmWoQLQkUEGJeZkOgB4
         5m5g==
X-Gm-Message-State: APjAAAWwn5Gxw2Z4aT/YkUOAfI4NxDF7pnYnw+/Iv/+2hS5GSXrEevYf
        hSWwsU4CdUHLDT2dbWWEknmaa+V0d0U=
X-Google-Smtp-Source: APXvYqzWYvnGwgrdP5teyUYFlHvnUfLgEJbmxlWYlLaY7BWSjseOwskgUv6VSpMWs5NimAJE9uevkQ==
X-Received: by 2002:a1c:b6d4:: with SMTP id g203mr19917203wmf.19.1561473678144;
        Tue, 25 Jun 2019 07:41:18 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:17 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 10/20] rbd: rename rbd_obj_setup_*() to rbd_obj_init_*()
Date:   Tue, 25 Jun 2019 16:41:01 +0200
Message-Id: <20190625144111.11270-11-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

These functions don't allocate and set up OSD requests anymore.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 61bc20cf1c29..2bafdee61dbd 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1819,12 +1819,6 @@ static void rbd_osd_setup_data(struct ceph_osd_request *osd_req, int which)
 	}
 }
 
-static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
-{
-	obj_req->read_state = RBD_OBJ_READ_START;
-	return 0;
-}
-
 static int rbd_osd_setup_stat(struct ceph_osd_request *osd_req, int which)
 {
 	struct page **pages;
@@ -1863,6 +1857,12 @@ static int rbd_osd_setup_copyup(struct ceph_osd_request *osd_req, int which,
 	return 0;
 }
 
+static int rbd_obj_init_read(struct rbd_obj_request *obj_req)
+{
+	obj_req->read_state = RBD_OBJ_READ_START;
+	return 0;
+}
+
 static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
 				      int which)
 {
@@ -1884,7 +1884,7 @@ static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
 	rbd_osd_setup_data(osd_req, which);
 }
 
-static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
+static int rbd_obj_init_write(struct rbd_obj_request *obj_req)
 {
 	int ret;
 
@@ -1922,7 +1922,7 @@ static void __rbd_osd_setup_discard_ops(struct ceph_osd_request *osd_req,
 	}
 }
 
-static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
+static int rbd_obj_init_discard(struct rbd_obj_request *obj_req)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	u64 off, next_off;
@@ -1991,7 +1991,7 @@ static void __rbd_osd_setup_zeroout_ops(struct ceph_osd_request *osd_req,
 				       0, 0);
 }
 
-static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
+static int rbd_obj_init_zeroout(struct rbd_obj_request *obj_req)
 {
 	int ret;
 
@@ -2062,16 +2062,16 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
 	for_each_obj_request_safe(img_req, obj_req, next_obj_req) {
 		switch (img_req->op_type) {
 		case OBJ_OP_READ:
-			ret = rbd_obj_setup_read(obj_req);
+			ret = rbd_obj_init_read(obj_req);
 			break;
 		case OBJ_OP_WRITE:
-			ret = rbd_obj_setup_write(obj_req);
+			ret = rbd_obj_init_write(obj_req);
 			break;
 		case OBJ_OP_DISCARD:
-			ret = rbd_obj_setup_discard(obj_req);
+			ret = rbd_obj_init_discard(obj_req);
 			break;
 		case OBJ_OP_ZEROOUT:
-			ret = rbd_obj_setup_zeroout(obj_req);
+			ret = rbd_obj_init_zeroout(obj_req);
 			break;
 		default:
 			BUG();
-- 
2.19.2

