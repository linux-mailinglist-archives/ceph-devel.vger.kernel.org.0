Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB62D10069E
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfKRNic (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:32 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51393 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfKRNib (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id q70so17408524wme.1
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=L3iBl88RH0m5yJZUDU8PaXLBX7yDxnnVlnvkkfsp37w=;
        b=lmwUmOxIcyV7xWleokJDeu+/c4VgeqnEcNdZkI42dvOPuBlpaEC3REJs9P91s0owqv
         QTpsxyles5p3pH2V4ZYpbXEWLMuUp90N3/PHpp9/BH3RAWZTVM1bV1AcOFagK/XLUwO6
         zWbElYBsZoX3BSPOrVrdWnWixvoSw70yxVGJur9agZBPaLP4+K18SH1kjlSHmEsHNJAG
         dn53V1TATbwal3SuX/O6gpLurXeZVqTJsr6mbnBK6SyGRfalHtw80V4lUlZdcsE3S/iD
         /ycldmu117lLLAjtRh2PWHbklcbQzsPyzXlp1peBuxHamaiqdyTCEvW8F/3i1zTwsmX1
         HYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L3iBl88RH0m5yJZUDU8PaXLBX7yDxnnVlnvkkfsp37w=;
        b=rCNE1/HQDA4XY7JmuWmb1NESuD+hZbbzmHQh5N7YMjVQIFwh907GtrcqoqyDNmyjrg
         38p7VZ3qdqG9Hirb/qEJNamiid/EWg6/CVwYF+f/C2fFcGYIu/rMAkL3KmnaZCl1IIq7
         tZweiT6Jf+XwG9VUyxT83zCiUoANYh/Mc2oEl6apj3gIjVRR9QbED9Z8zspw0yy6jA+U
         5pKxsVk+Nap/LmSKX0yneYJzSW/GljXlWvdxYJZ5Lsn6o3XBJ03ewJjRxDgAJrLu/d3C
         zpvMrksG0h1Jl2x4buE4kxjNiC9Cb3kSIJhwjO6owre3N5q1SxD3TbdsvuWPI8FTMczw
         iETQ==
X-Gm-Message-State: APjAAAXMUftgNA1NjWBaRVROoBSL2e33fu1SLFSpnb67NcZic7kj0A5v
        uYQkNl3RGsqLjykfM6oyjhH8VRGC
X-Google-Smtp-Source: APXvYqwjF2jBXHB6ejDMnrUhkRobZIYyRRxR9ZJAvaRxMzdNeelWodkwMSjc43R68rvQIhg8GnQZiw==
X-Received: by 2002:a05:600c:2307:: with SMTP id 7mr30790207wmo.154.1574084310161;
        Mon, 18 Nov 2019 05:38:30 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.29
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:29 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 2/9] rbd: introduce RBD_DEV_FLAG_READONLY
Date:   Mon, 18 Nov 2019 14:38:09 +0100
Message-Id: <20191118133816.3963-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_dev->opts is not available for parent images, making checking
rbd_dev->opts->read_only in various places (rbd_dev_image_probe(),
need_exclusive_lock(), use_object_map() in the following patches)
harder than it needs to be.

Keeping rbd_dev_image_probe() in mind, move the initialization in
do_rbd_add() up.  snap_id isn't filled in at that point, so replace
rbd_is_snap() with a snap_name comparison.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index cf2a7d094890..330d2789f373 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -464,6 +464,7 @@ struct rbd_device {
 enum rbd_dev_flags {
 	RBD_DEV_FLAG_EXISTS,	/* mapped snapshot has not been deleted */
 	RBD_DEV_FLAG_REMOVING,	/* this mapping is being removed */
+	RBD_DEV_FLAG_READONLY,  /* -o ro or snapshot */
 };
 
 static DEFINE_MUTEX(client_mutex);	/* Serialize client creation */
@@ -514,6 +515,11 @@ static int minor_to_rbd_dev_id(int minor)
 	return minor >> RBD_SINGLE_MAJOR_PART_SHIFT;
 }
 
+static bool rbd_is_ro(struct rbd_device *rbd_dev)
+{
+	return test_bit(RBD_DEV_FLAG_READONLY, &rbd_dev->flags);
+}
+
 static bool rbd_is_snap(struct rbd_device *rbd_dev)
 {
 	return rbd_dev->spec->snap_id != CEPH_NOSNAP;
@@ -6867,6 +6873,8 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 	__rbd_get_client(rbd_dev->rbd_client);
 	rbd_spec_get(rbd_dev->parent_spec);
 
+	__set_bit(RBD_DEV_FLAG_READONLY, &parent->flags);
+
 	ret = rbd_dev_image_probe(parent, depth);
 	if (ret < 0)
 		goto out_err;
@@ -6918,7 +6926,7 @@ static int rbd_dev_device_setup(struct rbd_device *rbd_dev)
 		goto err_out_blkdev;
 
 	set_capacity(rbd_dev->disk, rbd_dev->mapping.size / SECTOR_SIZE);
-	set_disk_ro(rbd_dev->disk, rbd_dev->opts->read_only);
+	set_disk_ro(rbd_dev->disk, rbd_is_ro(rbd_dev));
 
 	ret = dev_set_name(&rbd_dev->dev, "%d", rbd_dev->dev_id);
 	if (ret)
@@ -7107,6 +7115,11 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 	ctx.rbd_spec = NULL;	/* rbd_dev now owns this */
 	ctx.rbd_opts = NULL;	/* rbd_dev now owns this */
 
+	/* if we are mapping a snapshot it will be a read-only mapping */
+	if (rbd_dev->opts->read_only ||
+	    strcmp(rbd_dev->spec->snap_name, RBD_SNAP_HEAD_NAME))
+		__set_bit(RBD_DEV_FLAG_READONLY, &rbd_dev->flags);
+
 	rbd_dev->config_info = kstrdup(buf, GFP_KERNEL);
 	if (!rbd_dev->config_info) {
 		rc = -ENOMEM;
@@ -7120,10 +7133,6 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 		goto err_out_rbd_dev;
 	}
 
-	/* If we are mapping a snapshot it must be marked read-only */
-	if (rbd_is_snap(rbd_dev))
-		rbd_dev->opts->read_only = true;
-
 	if (rbd_dev->opts->alloc_size > rbd_dev->layout.object_size) {
 		rbd_warn(rbd_dev, "alloc_size adjusted to %u",
 			 rbd_dev->layout.object_size);
-- 
2.19.2

