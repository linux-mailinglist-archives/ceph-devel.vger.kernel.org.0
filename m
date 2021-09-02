Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D023FF29B
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 19:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346714AbhIBRmZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 13:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347025AbhIBRmU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 13:42:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC1DC061757;
        Thu,  2 Sep 2021 10:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Vee+7CSHZ5OpNHjor5aboTDtNXHhzGkI8kD6MNYblNI=; b=a2/GQq9OVg6RViwxWUcGPADJ8i
        /mVxeshti2fqRZAUxwwrEDUCGM7UVJu+iEA069jUhG/IHMH0iEMkEp9q17L3mUfsJ0MkwyDshg7ZC
        c7vFR6GKhf3KwLI4fPlAjxpkH51EAo6sMFSQxBAULO6eVXJTlJgcyN0OH5Tr1dkLjuTzWyJacWLOo
        qKAMDT47RjnKBhe1K0vbye8jjMrs21uxnGF4DCvtFbBFHYx0pqz8X2/sRy5qt0OrGwFbfWONyD/Zc
        jJc2uB9/XZh26ua+2IdjQR3WhhFVQH55XBZozGPHgfrXPrX/i6844mvoKut/51UTUylyZ4nALLOb4
        6ssHIa6A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLqi1-00A9FE-Rh; Thu, 02 Sep 2021 17:41:05 +0000
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
Subject: [PATCH 2/9] ms_block: add error handling support for add_disk()
Date:   Thu,  2 Sep 2021 10:40:58 -0700
Message-Id: <20210902174105.2418771-3-mcgrof@kernel.org>
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

Contrary to the typical removal which delays the put_disk()
until later, since we are failing on a probe we immediately
put the disk on failure from add_disk by using
blk_cleanup_disk().

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/memstick/core/ms_block.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 4a4573fa7b0f..86c626933c1a 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2156,10 +2156,14 @@ static int msb_init_disk(struct memstick_dev *card)
 		set_disk_ro(msb->disk, 1);
 
 	msb_start(card);
-	device_add_disk(&card->dev, msb->disk, NULL);
+	rc = device_add_disk(&card->dev, msb->disk, NULL);
+	if (rc)
+		goto out_cleanup_disk;
 	dbg("Disk added");
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(msb->disk);
 out_free_tag_set:
 	blk_mq_free_tag_set(&msb->tag_set);
 out_release_id:
-- 
2.30.2

