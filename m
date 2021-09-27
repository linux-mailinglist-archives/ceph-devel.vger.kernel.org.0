Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C12641A263
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 00:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbhI0WGC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Sep 2021 18:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237883AbhI0WFe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Sep 2021 18:05:34 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD1EC061217;
        Mon, 27 Sep 2021 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0XhzHqCRK7YpFsSG+7Rmrxl0ZALMmH2eUYve6WoEo48=; b=FVOFkdymklCD9HFfwIA+D+3xTm
        TsckIlazcNTsRtk64tsaiwo3wu86zZ2y43ctmSLDJgp7V4mxt+XWGceXb0dXYXy2LBR92VQp63zm+
        VXeMrQogOnIKb8OWRMZ54F80i2uLPLWcfg388mkvxNd0y251xt24Bk3t9v29agqUjGO1KkA9HFsO9
        eUqKdzur1+A4N7XofqKJCE6QLka7PZbTTXYoTYdFme0hJBxnZxgSEVjIZEZpCqrPhECSj9zVMPvWL
        3T82b9AN9WbwJWJMepzeLogaEIW3J8r+lLE3X3OfoJBuC/uBmVASjC2kbc1qAtAyo3gNPmKfB8MCa
        rDRUSVfw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyhm-004UuE-2P; Mon, 27 Sep 2021 22:02:34 +0000
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
Subject: [PATCH v2 6/6] s390/block/scm_blk: add error handling support for add_disk()
Date:   Mon, 27 Sep 2021 15:02:32 -0700
Message-Id: <20210927220232.1071926-7-mcgrof@kernel.org>
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

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/s390/block/scm_blk.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 88cba6212ee2..61ecdcb2cc6a 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -495,9 +495,14 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 
 	/* 512 byte sectors */
 	set_capacity(bdev->gendisk, scmdev->size >> 9);
-	device_add_disk(&scmdev->dev, bdev->gendisk, NULL);
+	ret = device_add_disk(&scmdev->dev, bdev->gendisk, NULL);
+	if (ret)
+		goto out_cleanup_disk;
+
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(bdev->gendisk);
 out_tag:
 	blk_mq_free_tag_set(&bdev->tag_set);
 out:
-- 
2.30.2

