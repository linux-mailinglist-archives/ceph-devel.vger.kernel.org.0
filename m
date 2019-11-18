Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8251006A7
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKRNil (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:41 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36141 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfKRNii (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id r10so19529934wrx.3
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GsWqfzpunClOrNTrCyg12HyaYUqVXl804urV/ExLfpE=;
        b=Alz8pSD81Bi93JKR9VEDtJ1YYANYp22sOrlNKpknoKiWXZNJTR6YGC3tG+nzyUZkCc
         AUVOPyl9CQGjs8/1NZutQftS5HCUxsBqSnWmD8kEPlqBUlQUsLlBhamxEEANrzpAUqAm
         w2bUg6wLzOKURs1oGH/oqMsm162WVdw/Ib7nhWualvBfQfFLYxOYb/xTEWd/lVkes+nC
         Gl2Jbmh5W2nVI/rJAL6SmtuiiNFYwV8c3W5YSrO3H/jm+70yoYCsspDOgJ8Smu/DIvKU
         p1L4bOYcUGq0iX2NVvZe8Ft3clNZ6+9JnZJ6cLWQZshIMkKemufbmNfUACy1VevhmucH
         MiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GsWqfzpunClOrNTrCyg12HyaYUqVXl804urV/ExLfpE=;
        b=NxFxn7tbvEquqbqDG5mUpXwdJtJeykI6r5PD8MZ5OcV7pKMetzv85u/c0iUuA0Pyng
         5HF+m0Zm/9/uSWJMpMy/vDEkLWXtCmGT6nIlh8WqwVDA6YRcle4g1c40nVXxqvEHWIRv
         uqlUKzC8FTm3qttckEcGrALZvPPbpogjGHnCmfOon9vwWDcKS9diRsQUJTshE0oluXqt
         wu2ZX+OxT3MtXci05Etz8HlmZ/n1fKhY6YampuLTFxt2h6mLpmC/0O6Qm2eqIwNgF42X
         OsphTsmRCJBBHol4kBCXD9OlM3IwLoVxVTS7WfmOUXYQoqB9mldAJZTECNNX2oJTvdg5
         a45A==
X-Gm-Message-State: APjAAAW5qw9KkrHGKqzcczmPM490zqDTYtULqUM3zRSFeb4Q2KHkUfBA
        aEQl/22yYr8z3vS/G1lHedzfXlhw
X-Google-Smtp-Source: APXvYqw+YbT+yT8i+aCVPZB55dOprZNcGUYHQF7OlkLSCgSLVfSaluCvdwv37hoFq5s/45CKbWiN9g==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr21427448wrw.357.1574084316175;
        Mon, 18 Nov 2019 05:38:36 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.35
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:35 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 8/9] rbd: don't query snapshot features
Date:   Mon, 18 Nov 2019 14:38:15 +0100
Message-Id: <20191118133816.3963-9-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Since infernalis, ceph.git commit 281f87f9ee52 ("cls_rbd: get_features
on snapshots returns HEAD image features"), querying and checking that
is pointless.  Userspace support for manipulating image features after
image creation came also in infernalis, so a snapshot with a different
set of features wasn't ever possible.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index aba60e37b058..935b66808e40 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -377,7 +377,6 @@ struct rbd_client_id {
 
 struct rbd_mapping {
 	u64                     size;
-	u64                     features;
 };
 
 /*
@@ -644,8 +643,6 @@ static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
 					u64 snap_id);
 static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
 				u8 *order, u64 *snap_size);
-static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
-		u64 *snap_features);
 static int rbd_dev_v2_get_flags(struct rbd_device *rbd_dev);
 
 static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result);
@@ -1303,51 +1300,23 @@ static int rbd_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
 	return 0;
 }
 
-static int rbd_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
-			u64 *snap_features)
-{
-	rbd_assert(rbd_image_format_valid(rbd_dev->image_format));
-	if (snap_id == CEPH_NOSNAP) {
-		*snap_features = rbd_dev->header.features;
-	} else if (rbd_dev->image_format == 1) {
-		*snap_features = 0;	/* No features for format 1 */
-	} else {
-		u64 features = 0;
-		int ret;
-
-		ret = _rbd_dev_v2_snap_features(rbd_dev, snap_id, &features);
-		if (ret)
-			return ret;
-
-		*snap_features = features;
-	}
-	return 0;
-}
-
 static int rbd_dev_mapping_set(struct rbd_device *rbd_dev)
 {
 	u64 snap_id = rbd_dev->spec->snap_id;
 	u64 size = 0;
-	u64 features = 0;
 	int ret;
 
 	ret = rbd_snap_size(rbd_dev, snap_id, &size);
-	if (ret)
-		return ret;
-	ret = rbd_snap_features(rbd_dev, snap_id, &features);
 	if (ret)
 		return ret;
 
 	rbd_dev->mapping.size = size;
-	rbd_dev->mapping.features = features;
-
 	return 0;
 }
 
 static void rbd_dev_mapping_clear(struct rbd_device *rbd_dev)
 {
 	rbd_dev->mapping.size = 0;
-	rbd_dev->mapping.features = 0;
 }
 
 static void zero_bvec(struct bio_vec *bv)
@@ -5190,17 +5159,12 @@ static ssize_t rbd_size_show(struct device *dev,
 		(unsigned long long)rbd_dev->mapping.size);
 }
 
-/*
- * Note this shows the features for whatever's mapped, which is not
- * necessarily the base image.
- */
 static ssize_t rbd_features_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
 
-	return sprintf(buf, "0x%016llx\n",
-			(unsigned long long)rbd_dev->mapping.features);
+	return sprintf(buf, "0x%016llx\n", rbd_dev->header.features);
 }
 
 static ssize_t rbd_major_show(struct device *dev,
-- 
2.19.2

