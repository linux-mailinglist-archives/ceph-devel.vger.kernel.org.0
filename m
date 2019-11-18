Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9B01006A6
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKRNik (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:40 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45340 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfKRNij (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id z10so19491399wrs.12
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9Oc+58vsWsnrZXoHwoX4dmW9FbrC0g6lB0P1EQYRzOM=;
        b=pmCjHdy3vRKjomMy6hw7Du4unRlx6J/hteQyl2uonXpoG9LWsdsMiznxi/6oTSCyOV
         s+je24G2G9wLL5z9tbVN4fK2HW0esaZwjX41TJpxwxF7vLQO1JGSPnKxTfTUAm4Obfi5
         zQUdLwyMxhf/vudM/8PJCGOEW5mreVUom0vAGaIX4WnZ/YA5Lx5CnlXSS1bsm/X/GpMF
         M28ehpUaaN2mHJFMAmsJ0RXGFze0i9AKkdlwQDFqi5+myzwanQjMLvfJWHMGykmg0iI9
         KS8T0Zzvu2jl729tFqMLKY0WdLo42B4veYcJnxBYXEUEg6f3WrKk9Q3wGVp1MgkzfhKe
         Mhug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Oc+58vsWsnrZXoHwoX4dmW9FbrC0g6lB0P1EQYRzOM=;
        b=lzPhi+67Cd6RHX/hTZ/mMVUtPWOlrHC8pvBfFoUlaiAk8jsbenRbKPXC+65tWZwQJM
         g0aR+8twB6II1UphMTeibNnxJVnGAzvIJQCzXb99TzA9rpxWIzbHei36NCUbFQv3UfCF
         Vn3SruhG8w1DIaaSOBN61Rr9JCBIl1erxn+EYz5z+aT7FH9/czfjQMCpbge7nfCRB9l5
         Xk3VVjEVSLvxMhPisZCoJR68qG/o0jizPmlxmOqQWuF+mUkLhOpZqXOKqTglHYbkiwHY
         dWW9BHVyIGPrzPX8l/XmFssxZE0Nd7c87n63hq2ShhJMgGRjKgtuK7oQQUh8RHyGIXqr
         hxvA==
X-Gm-Message-State: APjAAAX/XyfkyvkfwkkCKq+Aqh6Wdfw5RcCdRUjjhsgJhVWK9wxFGRaU
        CThOxZhUQG1+x5X14d9UnydB9lC7
X-Google-Smtp-Source: APXvYqyPqBuhFDY1S6VPZXfJBFTfmMehw5+uI/k8A4mxnhIfh/YL1JcLxApDWgjWgvhEJ5CL6plA/A==
X-Received: by 2002:adf:fa4a:: with SMTP id y10mr21389379wrr.177.1574084317015;
        Mon, 18 Nov 2019 05:38:37 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.36
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:36 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 9/9] rbd: ask for a weaker incompat mask for read-only mappings
Date:   Mon, 18 Nov 2019 14:38:16 +0100
Message-Id: <20191118133816.3963-10-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

For a read-only mapping, ask for a set of features that make the image
only unreadable, rather than both unreadable and unwritable by a client
that doesn't understand them.  As of today, the difference between them
for krbd is journaling (JOURNALING) and live migration (MIGRATING).

get_features method supports read_only parameter since hammer, ceph.git
commit 6176ec5fde2a ("librbd: differentiate between R/O vs R/W RBD
features").

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 935b66808e40..b3167247c90a 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5652,9 +5652,12 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
 }
 
 static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
-		u64 *snap_features)
+				     bool read_only, u64 *snap_features)
 {
-	__le64 snapid = cpu_to_le64(snap_id);
+	struct {
+		__le64 snap_id;
+		u8 read_only;
+	} features_in;
 	struct {
 		__le64 features;
 		__le64 incompat;
@@ -5662,9 +5665,12 @@ static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
 	u64 unsup;
 	int ret;
 
+	features_in.snap_id = cpu_to_le64(snap_id);
+	features_in.read_only = read_only;
+
 	ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
 				  &rbd_dev->header_oloc, "get_features",
-				  &snapid, sizeof(snapid),
+				  &features_in, sizeof(features_in),
 				  &features_buf, sizeof(features_buf));
 	dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
 	if (ret < 0)
@@ -5692,7 +5698,8 @@ static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
 static int rbd_dev_v2_features(struct rbd_device *rbd_dev)
 {
 	return _rbd_dev_v2_snap_features(rbd_dev, CEPH_NOSNAP,
-						&rbd_dev->header.features);
+					 rbd_is_ro(rbd_dev),
+					 &rbd_dev->header.features);
 }
 
 /*
-- 
2.19.2

