Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFBB41A24F
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 00:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbhI0WFt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Sep 2021 18:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbhI0WF3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Sep 2021 18:05:29 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DB8C061235;
        Mon, 27 Sep 2021 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=y0kWvQS67gJE9oH2Tu+3mzoZQKPgF7CjDPD3Aqrkl9E=; b=czcgq8i1+g9A9g+zXiauQIA7Kj
        pbcCXZYG2uU49Bh9MXwzR4eMtk+Vd3AktD9gnc4BiUDpyy4iQxV2/JvF8DBmWH47Cr2miHslnIT9R
        hyxzvkr9FA94O+Tw5P7L6DlzcfXn4Px/DZGDRFqjWtgWamOX5q9SvCKacNlgYzcaHRCkzXAcXJzG5
        vHQLx42LfHZkPRYMmGSG3gLSUwIuDr+XsLW79eCmEuOKvi9YZXC0FRuxTa+lCAXES/zPk9nmKqffx
        U+Vc1UKWOMktji+o+HOsBfKCbnXOD5KE5TEdqhnK2ZXjs3bdgYZDKgxz6VrS0GSSNUw8Pyc/2N+bC
        bzxoHKtg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyhl-004Uu2-Rg; Mon, 27 Sep 2021 22:02:33 +0000
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
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 5/6] s390/block/dcssblk: add error handling support for add_disk()
Date:   Mon, 27 Sep 2021 15:02:31 -0700
Message-Id: <20210927220232.1071926-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927220232.1071926-1-mcgrof@kernel.org>
References: <20210927220232.1071926-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
---
 drivers/s390/block/dcssblk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5be3d1c39a78..0741a9321712 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -696,7 +696,9 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	}
 
 	get_device(&dev_info->dev);
-	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
+	rc = device_add_disk(&dev_info->dev, dev_info->gd, NULL);
+	if (rc)
+		goto out_dax;
 
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
@@ -712,6 +714,10 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	rc = count;
 	goto out;
 
+out_dax:
+	put_device(&dev_info->dev);
+	kill_dax(dev_info->dax_dev);
+	put_dax(dev_info->dax_dev);
 put_dev:
 	list_del(&dev_info->lh);
 	blk_cleanup_disk(dev_info->gd);
-- 
2.30.2

