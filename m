Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCB441A265
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 00:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbhI0WGD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Sep 2021 18:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbhI0WFc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Sep 2021 18:05:32 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DA3C061216;
        Mon, 27 Sep 2021 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oUFeaFydBf47btSaJQAujL5lgV684wb9PUaVfH8cFxU=; b=47V3Gdi7DvixiWWgwtAB6qlwSN
        6hNbS/0rreghOppevBAuRNYL8a6SKfLWyQznEhqLzvct+Zb5xa2Zcs05j2iGt0zctbZPw2UIHdKzC
        3zEz99XNqX/icNepfJNNjzCPJfLM5Ku5uLoUVG0bSP+2npOSV4RwbtCtmke6Fo0MfHqVO0GDQ+Vjh
        5LZbeuPZde+TR9drRDD5ktu/bmPFPmVnnsKhcgXB2uneFMa+/xFUriPoRoNRVF8nh8PxjtIvsCq5P
        pcoihkPSZbjkdHQ0EvlfWqCruD4qsGl4dce5mBj/WnyMp3uhOEGr5OFG8kB3XPcJYN1GJsYfw1/u0
        LQPiCx+g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyhl-004Uts-MT; Mon, 27 Sep 2021 22:02:33 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        chaitanya.kulkarni@wdc.com, atulgopinathan@gmail.com, hare@suse.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        colin.king@canonical.com, shubhankarvk@gmail.com,
        baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hoeppner@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, oberpar@linux.ibm.com,
        tj@kernel.org
Cc:     linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 2/6] rbd: add add_disk() error handling
Date:   Mon, 27 Sep 2021 15:02:28 -0700
Message-Id: <20210927220232.1071926-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927220232.1071926-1-mcgrof@kernel.org>
References: <20210927220232.1071926-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/rbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e65c9d706f6f..341e5da6d029 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -7054,7 +7054,9 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 	if (rc)
 		goto err_out_image_lock;
 
-	device_add_disk(&rbd_dev->dev, rbd_dev->disk, NULL);
+	rc = device_add_disk(&rbd_dev->dev, rbd_dev->disk, NULL);
+	if (rc)
+		goto err_out_cleanup_disk;
 
 	spin_lock(&rbd_dev_list_lock);
 	list_add_tail(&rbd_dev->node, &rbd_dev_list);
@@ -7068,6 +7070,8 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 	module_put(THIS_MODULE);
 	return rc;
 
+err_out_cleanup_disk:
+	rbd_free_disk(rbd_dev);
 err_out_image_lock:
 	rbd_dev_image_unlock(rbd_dev);
 	rbd_dev_device_release(rbd_dev);
-- 
2.30.2

