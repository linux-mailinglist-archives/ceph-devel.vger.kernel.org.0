Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718797ADFA8
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Sep 2023 21:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbjIYTlI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Sep 2023 15:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbjIYTlH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Sep 2023 15:41:07 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0133101
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 12:40:59 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-532c81b9adbso8725364a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 12:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695670858; x=1696275658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBmNJe5laBTCH6NjBjIjwBOXFQdiiIHdy0on/tK1+tE=;
        b=RAU7HwY+zrixs8yqIF72IVDZ0nqP2+hp3GeUPXChAPP4cr8JUhFy1yC0JCcTFqO5zN
         pQQICLymqSSkAvlWd3SNqwRDCcoIh3xI1Z/icJ/kkzKOlIUUO7YXcqWoDrQygR/Gb2qq
         ySUSUxfxv/2NSTcJBwJPWqY3dPXiRnK23afz/quUIBuKhk8CD5m5lp9Ps7GqGluZxkxK
         X2EuSsQ4DyoPiKu6A/eWUdYft2ARP5+nm/W54dBMFOdoGndeTs43UJz2JnpG5wxGXUv6
         p7o5NYvkP1883urUstVHLjMbhQcFl2KPmGaw/x3LH04hU2IbX9UMBQSOfDDHd1+I7bwW
         2fsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695670858; x=1696275658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rBmNJe5laBTCH6NjBjIjwBOXFQdiiIHdy0on/tK1+tE=;
        b=FNgl4VkEZFrKlqv81oT3lH/2Y0uzTjx4uo2CdgYfEKO6cts0prwd9UcXH0WqKjy+et
         iUuGQUIljIHyL68YXaxzmM5n2YgOKZoXyRkiUQKZYmt+O4wUrgjEljfKnM5OqHlwTfF/
         UNoI2hVw1hfkThIWVRmcSilTosLgGs4N62mSlsFFA9gJlDTZlHnvjA+F/96oQw2GW0yI
         t7D8PvnuD/X0j/IXVmP+6XSjVmjfN55g8482T2MVCiMqA4Im7p4rG4QhIIG2K2jeMeGa
         oYzktFRwJLdYcK+jW+lp0nvc03vEHA3WxLPxBs//w9u/Wx1zlSTeXrEmSustYKTn5BWU
         YOgA==
X-Gm-Message-State: AOJu0Yyiq7FPUTVp9tlb9qf2eASx+ATXwISCqofWgOqiJch8GZJP527e
        9oTn/0rj+3FhMlrlmme0Fioy/opIddE=
X-Google-Smtp-Source: AGHT+IF6I+IVczf2BMDfePbe7rRWbJoRvzcmjejz1yFohxnFeBN3YPYsqdx7DLnQqUid5331872JwA==
X-Received: by 2002:a05:6402:231a:b0:533:c77b:2f3e with SMTP id l26-20020a056402231a00b00533c77b2f3emr5399393eda.21.1695670858025;
        Mon, 25 Sep 2023 12:40:58 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id en13-20020a056402528d00b005340d9d042bsm1762365edb.40.2023.09.25.12.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 12:40:57 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 3/4] rbd: decouple parent info read-in from updating rbd_dev
Date:   Mon, 25 Sep 2023 21:40:33 +0200
Message-ID: <20230925194036.197899-4-idryomov@gmail.com>
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

Unlike header read-in, parent info read-in is already decoupled in
get_parent_info(), but it's buried in rbd_dev_v2_parent_info() along
with the processing logic.

Separate the initial read-in and update read-in logic into
rbd_dev_setup_parent() and rbd_dev_update_parent() respectively and
have rbd_dev_v2_parent_info() just populate struct parent_image_info
(i.e. what get_parent_info() did).  Some existing QoI issues, like
flatten of a standalone clone being disregarded on refresh, remain.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 142 +++++++++++++++++++++++++-------------------
 1 file changed, 80 insertions(+), 62 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6ed5520ef303..d62a0298c890 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5594,6 +5594,14 @@ struct parent_image_info {
 	u64		overlap;
 };
 
+static void rbd_parent_info_cleanup(struct parent_image_info *pii)
+{
+	kfree(pii->pool_ns);
+	kfree(pii->image_id);
+
+	memset(pii, 0, sizeof(*pii));
+}
+
 /*
  * The caller is responsible for @pii.
  */
@@ -5663,6 +5671,9 @@ static int __get_parent_info(struct rbd_device *rbd_dev,
 	if (pii->has_overlap)
 		ceph_decode_64_safe(&p, end, pii->overlap, e_inval);
 
+	dout("%s pool_id %llu pool_ns %s image_id %s snap_id %llu has_overlap %d overlap %llu\n",
+	     __func__, pii->pool_id, pii->pool_ns, pii->image_id, pii->snap_id,
+	     pii->has_overlap, pii->overlap);
 	return 0;
 
 e_inval:
@@ -5701,14 +5712,17 @@ static int __get_parent_info_legacy(struct rbd_device *rbd_dev,
 	pii->has_overlap = true;
 	ceph_decode_64_safe(&p, end, pii->overlap, e_inval);
 
+	dout("%s pool_id %llu pool_ns %s image_id %s snap_id %llu has_overlap %d overlap %llu\n",
+	     __func__, pii->pool_id, pii->pool_ns, pii->image_id, pii->snap_id,
+	     pii->has_overlap, pii->overlap);
 	return 0;
 
 e_inval:
 	return -EINVAL;
 }
 
-static int get_parent_info(struct rbd_device *rbd_dev,
-			   struct parent_image_info *pii)
+static int rbd_dev_v2_parent_info(struct rbd_device *rbd_dev,
+				  struct parent_image_info *pii)
 {
 	struct page *req_page, *reply_page;
 	void *p;
@@ -5736,7 +5750,7 @@ static int get_parent_info(struct rbd_device *rbd_dev,
 	return ret;
 }
 
-static int rbd_dev_v2_parent_info(struct rbd_device *rbd_dev)
+static int rbd_dev_setup_parent(struct rbd_device *rbd_dev)
 {
 	struct rbd_spec *parent_spec;
 	struct parent_image_info pii = { 0 };
@@ -5746,37 +5760,12 @@ static int rbd_dev_v2_parent_info(struct rbd_device *rbd_dev)
 	if (!parent_spec)
 		return -ENOMEM;
 
-	ret = get_parent_info(rbd_dev, &pii);
+	ret = rbd_dev_v2_parent_info(rbd_dev, &pii);
 	if (ret)
 		goto out_err;
 
-	dout("%s pool_id %llu pool_ns %s image_id %s snap_id %llu has_overlap %d overlap %llu\n",
-	     __func__, pii.pool_id, pii.pool_ns, pii.image_id, pii.snap_id,
-	     pii.has_overlap, pii.overlap);
-
-	if (pii.pool_id == CEPH_NOPOOL || !pii.has_overlap) {
-		/*
-		 * Either the parent never existed, or we have
-		 * record of it but the image got flattened so it no
-		 * longer has a parent.  When the parent of a
-		 * layered image disappears we immediately set the
-		 * overlap to 0.  The effect of this is that all new
-		 * requests will be treated as if the image had no
-		 * parent.
-		 *
-		 * If !pii.has_overlap, the parent image spec is not
-		 * applicable.  It's there to avoid duplication in each
-		 * snapshot record.
-		 */
-		if (rbd_dev->parent_overlap) {
-			rbd_dev->parent_overlap = 0;
-			rbd_dev_parent_put(rbd_dev);
-			pr_info("%s: clone image has been flattened\n",
-				rbd_dev->disk->disk_name);
-		}
-
+	if (pii.pool_id == CEPH_NOPOOL || !pii.has_overlap)
 		goto out;	/* No parent?  No problem. */
-	}
 
 	/* The ceph file layout needs to fit pool id in 32 bits */
 
@@ -5788,46 +5777,34 @@ static int rbd_dev_v2_parent_info(struct rbd_device *rbd_dev)
 	}
 
 	/*
-	 * The parent won't change (except when the clone is
-	 * flattened, already handled that).  So we only need to
-	 * record the parent spec we have not already done so.
+	 * The parent won't change except when the clone is flattened,
+	 * so we only need to record the parent image spec once.
 	 */
-	if (!rbd_dev->parent_spec) {
-		parent_spec->pool_id = pii.pool_id;
-		if (pii.pool_ns && *pii.pool_ns) {
-			parent_spec->pool_ns = pii.pool_ns;
-			pii.pool_ns = NULL;
-		}
-		parent_spec->image_id = pii.image_id;
-		pii.image_id = NULL;
-		parent_spec->snap_id = pii.snap_id;
-
-		rbd_dev->parent_spec = parent_spec;
-		parent_spec = NULL;	/* rbd_dev now owns this */
+	parent_spec->pool_id = pii.pool_id;
+	if (pii.pool_ns && *pii.pool_ns) {
+		parent_spec->pool_ns = pii.pool_ns;
+		pii.pool_ns = NULL;
 	}
+	parent_spec->image_id = pii.image_id;
+	pii.image_id = NULL;
+	parent_spec->snap_id = pii.snap_id;
+
+	rbd_assert(!rbd_dev->parent_spec);
+	rbd_dev->parent_spec = parent_spec;
+	parent_spec = NULL;	/* rbd_dev now owns this */
 
 	/*
-	 * We always update the parent overlap.  If it's zero we issue
-	 * a warning, as we will proceed as if there was no parent.
+	 * Record the parent overlap.  If it's zero, issue a warning as
+	 * we will proceed as if there is no parent.
 	 */
-	if (!pii.overlap) {
-		if (parent_spec) {
-			/* refresh, careful to warn just once */
-			if (rbd_dev->parent_overlap)
-				rbd_warn(rbd_dev,
-				    "clone now standalone (overlap became 0)");
-		} else {
-			/* initial probe */
-			rbd_warn(rbd_dev, "clone is standalone (overlap 0)");
-		}
-	}
+	if (!pii.overlap)
+		rbd_warn(rbd_dev, "clone is standalone (overlap 0)");
 	rbd_dev->parent_overlap = pii.overlap;
 
 out:
 	ret = 0;
 out_err:
-	kfree(pii.pool_ns);
-	kfree(pii.image_id);
+	rbd_parent_info_cleanup(&pii);
 	rbd_spec_put(parent_spec);
 	return ret;
 }
@@ -6977,7 +6954,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	}
 
 	if (rbd_dev->header.features & RBD_FEATURE_LAYERING) {
-		ret = rbd_dev_v2_parent_info(rbd_dev);
+		ret = rbd_dev_setup_parent(rbd_dev);
 		if (ret)
 			goto err_out_probe;
 	}
@@ -7026,9 +7003,47 @@ static void rbd_dev_update_header(struct rbd_device *rbd_dev,
 	}
 }
 
+static void rbd_dev_update_parent(struct rbd_device *rbd_dev,
+				  struct parent_image_info *pii)
+{
+	if (pii->pool_id == CEPH_NOPOOL || !pii->has_overlap) {
+		/*
+		 * Either the parent never existed, or we have
+		 * record of it but the image got flattened so it no
+		 * longer has a parent.  When the parent of a
+		 * layered image disappears we immediately set the
+		 * overlap to 0.  The effect of this is that all new
+		 * requests will be treated as if the image had no
+		 * parent.
+		 *
+		 * If !pii.has_overlap, the parent image spec is not
+		 * applicable.  It's there to avoid duplication in each
+		 * snapshot record.
+		 */
+		if (rbd_dev->parent_overlap) {
+			rbd_dev->parent_overlap = 0;
+			rbd_dev_parent_put(rbd_dev);
+			pr_info("%s: clone has been flattened\n",
+				rbd_dev->disk->disk_name);
+		}
+	} else {
+		rbd_assert(rbd_dev->parent_spec);
+
+		/*
+		 * Update the parent overlap.  If it became zero, issue
+		 * a warning as we will proceed as if there is no parent.
+		 */
+		if (!pii->overlap && rbd_dev->parent_overlap)
+			rbd_warn(rbd_dev,
+				 "clone has become standalone (overlap 0)");
+		rbd_dev->parent_overlap = pii->overlap;
+	}
+}
+
 static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 {
 	struct rbd_image_header	header = { 0 };
+	struct parent_image_info pii = { 0 };
 	u64 mapping_size;
 	int ret;
 
@@ -7044,12 +7059,14 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 	 * mapped image getting flattened.
 	 */
 	if (rbd_dev->parent) {
-		ret = rbd_dev_v2_parent_info(rbd_dev);
+		ret = rbd_dev_v2_parent_info(rbd_dev, &pii);
 		if (ret)
 			goto out;
 	}
 
 	rbd_dev_update_header(rbd_dev, &header);
+	if (rbd_dev->parent)
+		rbd_dev_update_parent(rbd_dev, &pii);
 
 	rbd_assert(!rbd_is_snap(rbd_dev));
 	rbd_dev->mapping.size = rbd_dev->header.image_size;
@@ -7059,6 +7076,7 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 	if (!ret && mapping_size != rbd_dev->mapping.size)
 		rbd_dev_update_size(rbd_dev);
 
+	rbd_parent_info_cleanup(&pii);
 	rbd_image_header_cleanup(&header);
 	return ret;
 }
-- 
2.41.0

