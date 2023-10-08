Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B5E7BCAD5
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Oct 2023 02:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbjJHAtq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 7 Oct 2023 20:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbjJHAtj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 7 Oct 2023 20:49:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F7FDE;
        Sat,  7 Oct 2023 17:49:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA686C433C8;
        Sun,  8 Oct 2023 00:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696726156;
        bh=6T6y6g6MkK/g9bZbH6IhH9VsKsMjUid8G0Jp284vhVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlpH4GC+Kf9jvzcLAh4gkCCrERny/MykrFM96Gmw0zdojbKkjGZ34Isfyswva2IUc
         6APUXeBE/T0PU4nfu6to/B2Zeh6K8o2K+cXopaq+B3AcUpw9/Cki1dSgqOMRAV7LhG
         3X1ALVuuohJ0Jk1BL9+eY5jIdpdN4jNoJxk2M/h48h4D5lTG1aCeBMhuY6+PlZDej1
         Mad/2R6IKqERYgaKdSGsn9WPxjw5YZzW7jdkfIN43K8Y58S1M23ylPHOZ/VeL2/weN
         E3eslLfnWRsLXLSc6zmC86i3FWG6MpIcR94ydGZpzHhn3V+3y1Bl5ikdaSUbQhd3VH
         LSGLr7TL7vaxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Sasha Levin <sashal@kernel.org>, axboe@kernel.dk,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.5 12/18] rbd: decouple header read-in from updating rbd_dev->header
Date:   Sat,  7 Oct 2023 20:48:46 -0400
Message-Id: <20231008004853.3767621-12-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231008004853.3767621-1-sashal@kernel.org>
References: <20231008004853.3767621-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.5.6
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 510a7330c82a7754d5df0117a8589e8a539067c7 ]

Make rbd_dev_header_info() populate a passed struct rbd_image_header
instead of rbd_dev->header and introduce rbd_dev_update_header() for
updating mutable fields in rbd_dev->header upon refresh.  The initial
read-in of both mutable and immutable fields in rbd_dev_image_probe()
passes in rbd_dev->header so no update step is required there.

rbd_init_layout() is now called directly from rbd_dev_image_probe()
instead of individually in format 1 and format 2 implementations.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rbd.c | 206 ++++++++++++++++++++++++--------------------
 1 file changed, 114 insertions(+), 92 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 91e9c709b8716..90a78176dbc89 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -632,7 +632,8 @@ void rbd_warn(struct rbd_device *rbd_dev, const char *fmt, ...)
 static void rbd_dev_remove_parent(struct rbd_device *rbd_dev);
 
 static int rbd_dev_refresh(struct rbd_device *rbd_dev);
-static int rbd_dev_v2_header_onetime(struct rbd_device *rbd_dev);
+static int rbd_dev_v2_header_onetime(struct rbd_device *rbd_dev,
+				     struct rbd_image_header *header);
 static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
 					u64 snap_id);
 static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
@@ -993,15 +994,24 @@ static void rbd_init_layout(struct rbd_device *rbd_dev)
 	RCU_INIT_POINTER(rbd_dev->layout.pool_ns, NULL);
 }
 
+static void rbd_image_header_cleanup(struct rbd_image_header *header)
+{
+	kfree(header->object_prefix);
+	ceph_put_snap_context(header->snapc);
+	kfree(header->snap_sizes);
+	kfree(header->snap_names);
+
+	memset(header, 0, sizeof(*header));
+}
+
 /*
  * Fill an rbd image header with information from the given format 1
  * on-disk header.
  */
-static int rbd_header_from_disk(struct rbd_device *rbd_dev,
-				 struct rbd_image_header_ondisk *ondisk)
+static int rbd_header_from_disk(struct rbd_image_header *header,
+				struct rbd_image_header_ondisk *ondisk,
+				bool first_time)
 {
-	struct rbd_image_header *header = &rbd_dev->header;
-	bool first_time = header->object_prefix == NULL;
 	struct ceph_snap_context *snapc;
 	char *object_prefix = NULL;
 	char *snap_names = NULL;
@@ -1068,11 +1078,6 @@ static int rbd_header_from_disk(struct rbd_device *rbd_dev,
 	if (first_time) {
 		header->object_prefix = object_prefix;
 		header->obj_order = ondisk->options.order;
-		rbd_init_layout(rbd_dev);
-	} else {
-		ceph_put_snap_context(header->snapc);
-		kfree(header->snap_names);
-		kfree(header->snap_sizes);
 	}
 
 	/* The remaining fields always get updated (when we refresh) */
@@ -4857,7 +4862,9 @@ static int rbd_obj_read_sync(struct rbd_device *rbd_dev,
  * return, the rbd_dev->header field will contain up-to-date
  * information about the image.
  */
-static int rbd_dev_v1_header_info(struct rbd_device *rbd_dev)
+static int rbd_dev_v1_header_info(struct rbd_device *rbd_dev,
+				  struct rbd_image_header *header,
+				  bool first_time)
 {
 	struct rbd_image_header_ondisk *ondisk = NULL;
 	u32 snap_count = 0;
@@ -4905,7 +4912,7 @@ static int rbd_dev_v1_header_info(struct rbd_device *rbd_dev)
 		snap_count = le32_to_cpu(ondisk->snap_count);
 	} while (snap_count != want_count);
 
-	ret = rbd_header_from_disk(rbd_dev, ondisk);
+	ret = rbd_header_from_disk(header, ondisk, first_time);
 out:
 	kfree(ondisk);
 
@@ -5468,17 +5475,12 @@ static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
 	return 0;
 }
 
-static int rbd_dev_v2_image_size(struct rbd_device *rbd_dev)
-{
-	return _rbd_dev_v2_snap_size(rbd_dev, CEPH_NOSNAP,
-					&rbd_dev->header.obj_order,
-					&rbd_dev->header.image_size);
-}
-
-static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
+static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev,
+				    char **pobject_prefix)
 {
 	size_t size;
 	void *reply_buf;
+	char *object_prefix;
 	int ret;
 	void *p;
 
@@ -5496,16 +5498,16 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
 		goto out;
 
 	p = reply_buf;
-	rbd_dev->header.object_prefix = ceph_extract_encoded_string(&p,
-						p + ret, NULL, GFP_NOIO);
+	object_prefix = ceph_extract_encoded_string(&p, p + ret, NULL,
+						    GFP_NOIO);
+	if (IS_ERR(object_prefix)) {
+		ret = PTR_ERR(object_prefix);
+		goto out;
+	}
 	ret = 0;
 
-	if (IS_ERR(rbd_dev->header.object_prefix)) {
-		ret = PTR_ERR(rbd_dev->header.object_prefix);
-		rbd_dev->header.object_prefix = NULL;
-	} else {
-		dout("  object_prefix = %s\n", rbd_dev->header.object_prefix);
-	}
+	*pobject_prefix = object_prefix;
+	dout("  object_prefix = %s\n", object_prefix);
 out:
 	kfree(reply_buf);
 
@@ -5556,13 +5558,6 @@ static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
 	return 0;
 }
 
-static int rbd_dev_v2_features(struct rbd_device *rbd_dev)
-{
-	return _rbd_dev_v2_snap_features(rbd_dev, CEPH_NOSNAP,
-					 rbd_is_ro(rbd_dev),
-					 &rbd_dev->header.features);
-}
-
 /*
  * These are generic image flags, but since they are used only for
  * object map, store them in rbd_dev->object_map_flags.
@@ -5837,14 +5832,14 @@ static int rbd_dev_v2_parent_info(struct rbd_device *rbd_dev)
 	return ret;
 }
 
-static int rbd_dev_v2_striping_info(struct rbd_device *rbd_dev)
+static int rbd_dev_v2_striping_info(struct rbd_device *rbd_dev,
+				    u64 *stripe_unit, u64 *stripe_count)
 {
 	struct {
 		__le64 stripe_unit;
 		__le64 stripe_count;
 	} __attribute__ ((packed)) striping_info_buf = { 0 };
 	size_t size = sizeof (striping_info_buf);
-	void *p;
 	int ret;
 
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
@@ -5856,27 +5851,33 @@ static int rbd_dev_v2_striping_info(struct rbd_device *rbd_dev)
 	if (ret < size)
 		return -ERANGE;
 
-	p = &striping_info_buf;
-	rbd_dev->header.stripe_unit = ceph_decode_64(&p);
-	rbd_dev->header.stripe_count = ceph_decode_64(&p);
+	*stripe_unit = le64_to_cpu(striping_info_buf.stripe_unit);
+	*stripe_count = le64_to_cpu(striping_info_buf.stripe_count);
+	dout("  stripe_unit = %llu stripe_count = %llu\n", *stripe_unit,
+	     *stripe_count);
+
 	return 0;
 }
 
-static int rbd_dev_v2_data_pool(struct rbd_device *rbd_dev)
+static int rbd_dev_v2_data_pool(struct rbd_device *rbd_dev, s64 *data_pool_id)
 {
-	__le64 data_pool_id;
+	__le64 data_pool_buf;
 	int ret;
 
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
 				  &rbd_dev->header_oloc, "get_data_pool",
-				  NULL, 0, &data_pool_id, sizeof(data_pool_id));
+				  NULL, 0, &data_pool_buf,
+				  sizeof(data_pool_buf));
+	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
 		return ret;
-	if (ret < sizeof(data_pool_id))
+	if (ret < sizeof(data_pool_buf))
 		return -EBADMSG;
 
-	rbd_dev->header.data_pool_id = le64_to_cpu(data_pool_id);
-	WARN_ON(rbd_dev->header.data_pool_id == CEPH_NOPOOL);
+	*data_pool_id = le64_to_cpu(data_pool_buf);
+	dout("  data_pool_id = %lld\n", *data_pool_id);
+	WARN_ON(*data_pool_id == CEPH_NOPOOL);
+
 	return 0;
 }
 
@@ -6068,7 +6069,8 @@ static int rbd_spec_fill_names(struct rbd_device *rbd_dev)
 	return ret;
 }
 
-static int rbd_dev_v2_snap_context(struct rbd_device *rbd_dev)
+static int rbd_dev_v2_snap_context(struct rbd_device *rbd_dev,
+				   struct ceph_snap_context **psnapc)
 {
 	size_t size;
 	int ret;
@@ -6129,9 +6131,7 @@ static int rbd_dev_v2_snap_context(struct rbd_device *rbd_dev)
 	for (i = 0; i < snap_count; i++)
 		snapc->snaps[i] = ceph_decode_64(&p);
 
-	ceph_put_snap_context(rbd_dev->header.snapc);
-	rbd_dev->header.snapc = snapc;
-
+	*psnapc = snapc;
 	dout("  snap context seq = %llu, snap_count = %u\n",
 		(unsigned long long)seq, (unsigned int)snap_count);
 out:
@@ -6180,38 +6180,42 @@ static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
 	return snap_name;
 }
 
-static int rbd_dev_v2_header_info(struct rbd_device *rbd_dev)
+static int rbd_dev_v2_header_info(struct rbd_device *rbd_dev,
+				  struct rbd_image_header *header,
+				  bool first_time)
 {
-	bool first_time = rbd_dev->header.object_prefix == NULL;
 	int ret;
 
-	ret = rbd_dev_v2_image_size(rbd_dev);
+	ret = _rbd_dev_v2_snap_size(rbd_dev, CEPH_NOSNAP,
+				    first_time ? &header->obj_order : NULL,
+				    &header->image_size);
 	if (ret)
 		return ret;
 
 	if (first_time) {
-		ret = rbd_dev_v2_header_onetime(rbd_dev);
+		ret = rbd_dev_v2_header_onetime(rbd_dev, header);
 		if (ret)
 			return ret;
 	}
 
-	ret = rbd_dev_v2_snap_context(rbd_dev);
-	if (ret && first_time) {
-		kfree(rbd_dev->header.object_prefix);
-		rbd_dev->header.object_prefix = NULL;
-	}
+	ret = rbd_dev_v2_snap_context(rbd_dev, &header->snapc);
+	if (ret)
+		return ret;
 
-	return ret;
+	return 0;
 }
 
-static int rbd_dev_header_info(struct rbd_device *rbd_dev)
+static int rbd_dev_header_info(struct rbd_device *rbd_dev,
+			       struct rbd_image_header *header,
+			       bool first_time)
 {
 	rbd_assert(rbd_image_format_valid(rbd_dev->image_format));
+	rbd_assert(!header->object_prefix && !header->snapc);
 
 	if (rbd_dev->image_format == 1)
-		return rbd_dev_v1_header_info(rbd_dev);
+		return rbd_dev_v1_header_info(rbd_dev, header, first_time);
 
-	return rbd_dev_v2_header_info(rbd_dev);
+	return rbd_dev_v2_header_info(rbd_dev, header, first_time);
 }
 
 /*
@@ -6699,60 +6703,49 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
  */
 static void rbd_dev_unprobe(struct rbd_device *rbd_dev)
 {
-	struct rbd_image_header	*header;
-
 	rbd_dev_parent_put(rbd_dev);
 	rbd_object_map_free(rbd_dev);
 	rbd_dev_mapping_clear(rbd_dev);
 
 	/* Free dynamic fields from the header, then zero it out */
 
-	header = &rbd_dev->header;
-	ceph_put_snap_context(header->snapc);
-	kfree(header->snap_sizes);
-	kfree(header->snap_names);
-	kfree(header->object_prefix);
-	memset(header, 0, sizeof (*header));
+	rbd_image_header_cleanup(&rbd_dev->header);
 }
 
-static int rbd_dev_v2_header_onetime(struct rbd_device *rbd_dev)
+static int rbd_dev_v2_header_onetime(struct rbd_device *rbd_dev,
+				     struct rbd_image_header *header)
 {
 	int ret;
 
-	ret = rbd_dev_v2_object_prefix(rbd_dev);
+	ret = rbd_dev_v2_object_prefix(rbd_dev, &header->object_prefix);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	/*
 	 * Get the and check features for the image.  Currently the
 	 * features are assumed to never change.
 	 */
-	ret = rbd_dev_v2_features(rbd_dev);
+	ret = _rbd_dev_v2_snap_features(rbd_dev, CEPH_NOSNAP,
+					rbd_is_ro(rbd_dev), &header->features);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	/* If the image supports fancy striping, get its parameters */
 
-	if (rbd_dev->header.features & RBD_FEATURE_STRIPINGV2) {
-		ret = rbd_dev_v2_striping_info(rbd_dev);
-		if (ret < 0)
-			goto out_err;
+	if (header->features & RBD_FEATURE_STRIPINGV2) {
+		ret = rbd_dev_v2_striping_info(rbd_dev, &header->stripe_unit,
+					       &header->stripe_count);
+		if (ret)
+			return ret;
 	}
 
-	if (rbd_dev->header.features & RBD_FEATURE_DATA_POOL) {
-		ret = rbd_dev_v2_data_pool(rbd_dev);
+	if (header->features & RBD_FEATURE_DATA_POOL) {
+		ret = rbd_dev_v2_data_pool(rbd_dev, &header->data_pool_id);
 		if (ret)
-			goto out_err;
+			return ret;
 	}
 
-	rbd_init_layout(rbd_dev);
 	return 0;
-
-out_err:
-	rbd_dev->header.features = 0;
-	kfree(rbd_dev->header.object_prefix);
-	rbd_dev->header.object_prefix = NULL;
-	return ret;
 }
 
 /*
@@ -6947,13 +6940,15 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	if (!depth)
 		down_write(&rbd_dev->header_rwsem);
 
-	ret = rbd_dev_header_info(rbd_dev);
+	ret = rbd_dev_header_info(rbd_dev, &rbd_dev->header, true);
 	if (ret) {
 		if (ret == -ENOENT && !need_watch)
 			rbd_print_dne(rbd_dev, false);
 		goto err_out_probe;
 	}
 
+	rbd_init_layout(rbd_dev);
+
 	/*
 	 * If this image is the one being mapped, we have pool name and
 	 * id, image name and id, and snap name - need to fill snap id.
@@ -7008,15 +7003,39 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	return ret;
 }
 
+static void rbd_dev_update_header(struct rbd_device *rbd_dev,
+				  struct rbd_image_header *header)
+{
+	rbd_assert(rbd_image_format_valid(rbd_dev->image_format));
+	rbd_assert(rbd_dev->header.object_prefix); /* !first_time */
+
+	rbd_dev->header.image_size = header->image_size;
+
+	ceph_put_snap_context(rbd_dev->header.snapc);
+	rbd_dev->header.snapc = header->snapc;
+	header->snapc = NULL;
+
+	if (rbd_dev->image_format == 1) {
+		kfree(rbd_dev->header.snap_names);
+		rbd_dev->header.snap_names = header->snap_names;
+		header->snap_names = NULL;
+
+		kfree(rbd_dev->header.snap_sizes);
+		rbd_dev->header.snap_sizes = header->snap_sizes;
+		header->snap_sizes = NULL;
+	}
+}
+
 static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 {
+	struct rbd_image_header	header = { 0 };
 	u64 mapping_size;
 	int ret;
 
 	down_write(&rbd_dev->header_rwsem);
 	mapping_size = rbd_dev->mapping.size;
 
-	ret = rbd_dev_header_info(rbd_dev);
+	ret = rbd_dev_header_info(rbd_dev, &header, false);
 	if (ret)
 		goto out;
 
@@ -7030,6 +7049,8 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 			goto out;
 	}
 
+	rbd_dev_update_header(rbd_dev, &header);
+
 	rbd_assert(!rbd_is_snap(rbd_dev));
 	rbd_dev->mapping.size = rbd_dev->header.image_size;
 
@@ -7038,6 +7059,7 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 	if (!ret && mapping_size != rbd_dev->mapping.size)
 		rbd_dev_update_size(rbd_dev);
 
+	rbd_image_header_cleanup(&header);
 	return ret;
 }
 
-- 
2.40.1

