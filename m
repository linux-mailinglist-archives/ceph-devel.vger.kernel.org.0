Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546CE3FF2B3
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 19:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347226AbhIBRnM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 13:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347005AbhIBRmT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 13:42:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00E8C061757;
        Thu,  2 Sep 2021 10:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9WAQqGmCnBZBIvZV5P2hlA8WSQ4fd7LqTPumJ23Kn/w=; b=OsZrKg+vMpotB4axsHjx6FruHD
        7GIdZBhzq61yrFpuu4mb5Li+LLit+paEsC5jyH/KWYPeLNqpuKfHiyLPZokO+vJKA4P3MIXjuUlcM
        KSYCsS4jYWs2oz5+bLrvXa2OdX7NwfyHIlBMCw4ubaN/IaKitfS5+Mg/QsWa8Y8M/djrBhmHm9RXk
        ldur9JBj282q9KTmrunMF0U5r2O1pEapxpC3F0MSQgur9DxWClL9pWr5SHJzHAVVoSKDSOOCfbGVp
        SsRQB1G5YmcO43/vRkmf6vTQeM5x7cKxnfZIwiqCYPzJoGrEHiX95U0UgZIBuc/mCqDtWPvmL2fLE
        dTVBTxIg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLqi1-00A9FC-PM; Thu, 02 Sep 2021 17:41:05 +0000
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
Subject: [PATCH 1/9] cdrom/gdrom: add error handling support for add_disk()
Date:   Thu,  2 Sep 2021 10:40:57 -0700
Message-Id: <20210902174105.2418771-2-mcgrof@kernel.org>
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
 drivers/cdrom/gdrom.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 8e1fe75af93f..d50cc1fd34d5 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -805,9 +805,14 @@ static int probe_gdrom(struct platform_device *devptr)
 		err = -ENOMEM;
 		goto probe_fail_free_irqs;
 	}
-	add_disk(gd.disk);
+	err = add_disk(gd.disk);
+	if (err)
+		goto probe_fail_add_disk;
+
 	return 0;
 
+probe_fail_add_disk:
+	kfree(gd.toc);
 probe_fail_free_irqs:
 	free_irq(HW_EVENT_GDROM_DMA, &gd);
 	free_irq(HW_EVENT_GDROM_CMD, &gd);
-- 
2.30.2

