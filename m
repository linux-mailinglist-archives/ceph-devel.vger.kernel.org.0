Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822813FF2AC
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 19:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346850AbhIBRm4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 13:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347006AbhIBRmT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 13:42:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1802C061760;
        Thu,  2 Sep 2021 10:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7TDsKeD7IxDkEhHV9HOPpdDxKioqknLkF46unKTn3WM=; b=xGYAM35rDyzjVTq3BtdHLJZNPa
        j52bS1QcvGAYD81BWsYGdnk0y7caLpFkD7gameTc07LEGg13lAHLs7Gt9yW5GJcb9nAndjLcUTA/v
        /wG8U+2Dic+ZvEicKho6RS5Hf838hdyO4xBDR8UC5blVVZc+1ZpjRs8HIB4zGBweYMYHOdqzm0W9y
        0gN4bSw+yuQu3XxYJTKSsXXMtXg/HRuk0MxSW0s1EVwv4MQ48FW9pU9eexzUxX+y2/IUx80vLGDvp
        urAq0lK6TDcTP/JDPaLLXD+qJ+rOLFNE01UbQdwZHJVAkoQIll07INbEDxpLnAh8ubGfh8fin25nF
        yrZ6wufA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLqi2-00A9FO-8J; Thu, 02 Sep 2021 17:41:06 +0000
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
Subject: [PATCH 7/9] s390/block/dcssblk: add error handling support for add_disk()
Date:   Thu,  2 Sep 2021 10:41:03 -0700
Message-Id: <20210902174105.2418771-8-mcgrof@kernel.org>
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
 drivers/s390/block/dcssblk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5be3d1c39a78..b0fd5009a12e 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -696,7 +696,9 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	}
 
 	get_device(&dev_info->dev);
-	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
+	rc = device_add_disk(&dev_info->dev, dev_info->gd, NULL);
+	if (rc)
+		goto put_dev;
 
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
-- 
2.30.2

