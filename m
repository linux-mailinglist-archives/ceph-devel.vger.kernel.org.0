Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E47441A26B
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 00:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbhI0WGK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Sep 2021 18:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237998AbhI0WFd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Sep 2021 18:05:33 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E19C0611C0;
        Mon, 27 Sep 2021 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+OAfxCoaVOuKuOjWZKvBW/L6IB8523Q0h7o1ENcxwyY=; b=0OtugzOoZWoPNTHgHokvNhlzny
        LVtyiNlqwmw6UskbWe87APtWwkxhfaTd657hK8Nxf64/0n7+qjsV7SqOENx+Nu2qDlxckAxUmF+Ny
        AewzZsDualM8Exf0Z4MyhUf6wg4FoGv02lM2+G39XUuNmRy7q4DQjVJAvxnTsLM7wBNG7zW9xiMdt
        0lGQg/MrOx1MZn++Eo7oAEvY+pQprH6S4mmf137SY8aFgyvffLFv8NL/59vgPhPeBEU9w/iiqI1Oz
        bp7ic6YX1SV/0CLLDl0CKA8z9XRctV9hZQCOJcirvX+5F2ZSxVAPF0H+0JF5bVRvhnR1IuntUYRrS
        H5tYNCSA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyhl-004Utz-PR; Mon, 27 Sep 2021 22:02:33 +0000
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
Subject: [PATCH v2 4/6] s390/block/dasd_genhd: add error handling support for add_disk()
Date:   Mon, 27 Sep 2021 15:02:30 -0700
Message-Id: <20210927220232.1071926-5-mcgrof@kernel.org>
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

Be sure to call dasd_gendisk_free() on error.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/s390/block/dasd_genhd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index fa966e0db6ca..80673dbfb1f9 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -33,7 +33,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 {
 	struct gendisk *gdp;
 	struct dasd_device *base;
-	int len;
+	int len, rc;
 
 	/* Make sure the minor for this device exists. */
 	base = block->base;
@@ -79,7 +79,13 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 	dasd_add_link_to_gendisk(gdp, base);
 	block->gdp = gdp;
 	set_capacity(block->gdp, 0);
-	device_add_disk(&base->cdev->dev, block->gdp, NULL);
+
+	rc = device_add_disk(&base->cdev->dev, block->gdp, NULL);
+	if (rc) {
+		dasd_gendisk_free(block);
+		return rc;
+	}
+
 	return 0;
 }
 
-- 
2.30.2

