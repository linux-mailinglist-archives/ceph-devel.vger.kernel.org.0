Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C961006A8
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfKRNii (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:38 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39020 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbfKRNih (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:37 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so18888427wmi.4
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Gw4mcEr0n1YygCP5aT+WAGi6UtUpy1PoZH9RmvLRcf8=;
        b=rdfnSX9NDT3/I5YvnK9lo2oODXOPDHEkepxyJQjB3G/mvEQrtdwikDzytTcl+EjgFb
         37x8WhrTfOQsz1hfoMVyPum/lC+2LVbQV+Cx+4oUsQztEb4dngUExSsv6G32URbYcrg1
         IAw1TR2VMTFCy4caG/0ZVWPI9zLYL1fa5Ras9HC3jIwtSc3Id3kxrGETTe2HToN3+Cg+
         uwo597w6YSw7H7EMFW4cXjOy3857Ppv1N1m5Mk9QKvJ3J4HdWVtmXWvj3fOSyrGmaym4
         FBJMnCXfNhQa6W23ExQsikjcpXJTP7ngbhOCFW1KlV0HhXsDRB2ryU241EGV2WNgHtuT
         kwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gw4mcEr0n1YygCP5aT+WAGi6UtUpy1PoZH9RmvLRcf8=;
        b=kfRZdvCEe4i739MduxIsf0seYeWCwCRdPNEM0tEpGf6WBb30nXcIQM5K9EAhebj3y3
         9ENW+sFcz0RRh/wa7do5xbxdr8mVkwIW7lm8m7RcLH58kFMF6iXWNu0t7Cd6QbF9ljHz
         9I2L9+cU5BrX7pXOQSyXaT9B2dOFFO21OoZhI3JAUgSojIlmovaYkTu3fDNYgxlAerEK
         DzNLDJrER9nXH7CbKM9OHHiK6xx0PGkhGwJ+0bC6ynqHQrffyflujj4alht+fgXEnec+
         umrg08Me62I00vOc3TjJQ18/Px28PYw4PIqKz7x+nE3lD5/PIhWAc3xvUYckvJ2iGqw/
         xQEw==
X-Gm-Message-State: APjAAAWxL+/mnZfWuJbp8Our9qm5uCknq7+n13NFrpSTTgcmLEguvdoN
        lmZGKrBtXhmGkKjVy/c8MvZl/eeP
X-Google-Smtp-Source: APXvYqzswQOc7KAnk1L1x2pqAEx3Ggt1k99RCo1tarvgQ2my7fwBJU9GLXTl9mGcaoR+bc5USWCXzA==
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr31087038wme.92.1574084314181;
        Mon, 18 Nov 2019 05:38:34 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.33
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:33 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 6/9] rbd: don't establish watch for read-only mappings
Date:   Mon, 18 Nov 2019 14:38:13 +0100
Message-Id: <20191118133816.3963-7-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

With exclusive lock out of the way, watch is the only thing left that
prevents a read-only mapping from being used with read-only OSD caps.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index aaa359561356..bfff195e8e23 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6985,6 +6985,24 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
 	return ret;
 }
 
+static void rbd_print_dne(struct rbd_device *rbd_dev, bool is_snap)
+{
+	if (!is_snap) {
+		pr_info("image %s/%s%s%s does not exist\n",
+			rbd_dev->spec->pool_name,
+			rbd_dev->spec->pool_ns ?: "",
+			rbd_dev->spec->pool_ns ? "/" : "",
+			rbd_dev->spec->image_name);
+	} else {
+		pr_info("snap %s/%s%s%s@%s does not exist\n",
+			rbd_dev->spec->pool_name,
+			rbd_dev->spec->pool_ns ?: "",
+			rbd_dev->spec->pool_ns ? "/" : "",
+			rbd_dev->spec->image_name,
+			rbd_dev->spec->snap_name);
+	}
+}
+
 static void rbd_dev_image_release(struct rbd_device *rbd_dev)
 {
 	rbd_dev_unprobe(rbd_dev);
@@ -7003,6 +7021,7 @@ static void rbd_dev_image_release(struct rbd_device *rbd_dev)
  */
 static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 {
+	bool need_watch = !depth && !rbd_is_ro(rbd_dev);
 	int ret;
 
 	/*
@@ -7019,22 +7038,21 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	if (ret)
 		goto err_out_format;
 
-	if (!depth) {
+	if (need_watch) {
 		ret = rbd_register_watch(rbd_dev);
 		if (ret) {
 			if (ret == -ENOENT)
-				pr_info("image %s/%s%s%s does not exist\n",
-					rbd_dev->spec->pool_name,
-					rbd_dev->spec->pool_ns ?: "",
-					rbd_dev->spec->pool_ns ? "/" : "",
-					rbd_dev->spec->image_name);
+				rbd_print_dne(rbd_dev, false);
 			goto err_out_format;
 		}
 	}
 
 	ret = rbd_dev_header_info(rbd_dev);
-	if (ret)
+	if (ret) {
+		if (ret == -ENOENT && !need_watch)
+			rbd_print_dne(rbd_dev, false);
 		goto err_out_watch;
+	}
 
 	/*
 	 * If this image is the one being mapped, we have pool name and
@@ -7048,12 +7066,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 		ret = rbd_spec_fill_names(rbd_dev);
 	if (ret) {
 		if (ret == -ENOENT)
-			pr_info("snap %s/%s%s%s@%s does not exist\n",
-				rbd_dev->spec->pool_name,
-				rbd_dev->spec->pool_ns ?: "",
-				rbd_dev->spec->pool_ns ? "/" : "",
-				rbd_dev->spec->image_name,
-				rbd_dev->spec->snap_name);
+			rbd_print_dne(rbd_dev, true);
 		goto err_out_probe;
 	}
 
@@ -7085,7 +7098,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 err_out_probe:
 	rbd_dev_unprobe(rbd_dev);
 err_out_watch:
-	if (!depth)
+	if (need_watch)
 		rbd_unregister_watch(rbd_dev);
 err_out_format:
 	rbd_dev->image_format = 0;
-- 
2.19.2

