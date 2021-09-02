Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E7A3FF2B0
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 19:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347012AbhIBRmT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346819AbhIBRmR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 13:42:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073C5C061760;
        Thu,  2 Sep 2021 10:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nD4STtfNJcQ+G+5E7/R8DdPYF/LAlaZ05CClSla9oSk=; b=qeVBykg3QRCOjJ3lK/FrjL9Ga3
        48Ek8HklFVO3olOvEg8WlT+U3iW9YcaK8LAtUVKie7PraEhxMfiwdAUh5QiMaT2k+XwSOkAofv00r
        UEb5jywFmvvjQiS7pEh0aPYMOtDSuMNolDXhoGQM1IOvJ38FjzLR68GzGmQxQ6ShUZd8cuAk8ROE6
        0hvMtpFX+MFuilKX1IfHr903x/j2trNggEDTLQIh076w+d6XXCOMGwHe9/Fqn0DxuAeuAHf0KjP6G
        HnipxjYg5AHdUKk1dit5dfdUFIbWKQ7kVBnJChhG9Avsk+qO8dveDmeFAjYR8YI/c35OWGysgS2ko
        9BtgU//Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLqi2-00A9FQ-9Y; Thu, 02 Sep 2021 17:41:06 +0000
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
Subject: [PATCH 8/9] s390/block/scm_blk: add error handling support for add_disk()
Date:   Thu,  2 Sep 2021 10:41:04 -0700
Message-Id: <20210902174105.2418771-9-mcgrof@kernel.org>
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

