Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1463FF299
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 19:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347061AbhIBRmY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 13:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347023AbhIBRmU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 13:42:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC89BC061575;
        Thu,  2 Sep 2021 10:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=m46K19zqMpohOFZJ7xRAzdG17R75/WCRRoDdwcwdSMI=; b=nGsfDA0FoN9p02CmwlLLtE/j5O
        onQNmJ7WjpnucJfBj4/6zRGMVSHMnWTMoxJPRz/uz/kJpJeESHsHO33Gj/jldk92HuaOfobXhfHrp
        /uNJMJe+oV8CLgCYZPgbU9f/0iZjsabR3dpuHpYdMc0JWVXRXFzFGmh6nXf1RCtfaCqK7IZLRRC7b
        1qCyvjhUzLZQe4zXn2gLZnsxjdgSbxtH4fbTLKmEUCTGwNjl6nHj65OIbzHhP5Zm/XAA347ahLQhM
        CjfFSpqKjjGCIYQo7g0ptAFBAvDPwvRaW8vpg82U23YvpkgLZvQrpn9P9T00KijCg78bCy6OHFabn
        sgDF1Ewg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLqi2-00A9FK-36; Thu, 02 Sep 2021 17:41:06 +0000
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
Subject: [PATCH 5/9] mtd: add add_disk() error handling
Date:   Thu,  2 Sep 2021 10:41:01 -0700
Message-Id: <20210902174105.2418771-6-mcgrof@kernel.org>
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
 drivers/mtd/mtd_blkdevs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 44bea3f65060..343ff96589cc 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -427,7 +427,9 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
-	device_add_disk(&new->mtd->dev, gd, NULL);
+	ret = device_add_disk(&new->mtd->dev, gd, NULL);
+	if (ret)
+		goto out_cleanup_disk;
 
 	if (new->disk_attributes) {
 		ret = sysfs_create_group(&disk_to_dev(gd)->kobj,
@@ -436,6 +438,8 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	}
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(new->disk);
 out_free_tag_set:
 	blk_mq_free_tag_set(new->tag_set);
 out_kfree_tag_set:
-- 
2.30.2

