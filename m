Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1513FF2A9
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 19:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347179AbhIBRmu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 13:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347008AbhIBRmT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 13:42:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AB9C061764;
        Thu,  2 Sep 2021 10:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oUFeaFydBf47btSaJQAujL5lgV684wb9PUaVfH8cFxU=; b=MDWGq2zI27NWhBv6BOn+YbZMyL
        rlV8p3XSRbJQOyaTy3gbg4Ql3AbI0pGITgKsByMSrltabrkFIGcrHpCGgHd2lSXPdGfxIeMeBz+O4
        Sb8Q+dnOO6YWlGaUrgrcYsasm6r2qHgc2z5gVzswCiEy/WETkOcOfkZQP2JMT9Ad7OicfSIQf9IS9
        og5e3xT2AJYwDoFEGE2CHHVSpRoEeBi/GLvSLjN5F8PJVFafzRYEeUD17hPqQBjL+XsUG5BHbpiAJ
        89D/oQc66ppD4xFwjktNhGnQAqOOsxws43qx4n9vsTfid2FN8PY1KB224oc3DNq5JOU1Q+2XOuwOq
        iG1OAFVw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLqi2-00A9FI-0b; Thu, 02 Sep 2021 17:41:06 +0000
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
Subject: [PATCH 4/9] rbd: add add_disk() error handling
Date:   Thu,  2 Sep 2021 10:41:00 -0700
Message-Id: <20210902174105.2418771-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902174105.2418771-1-mcgrof@kernel.org>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
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

