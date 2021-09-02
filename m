Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C7B3FF291
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 19:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347029AbhIBRmU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 13:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346712AbhIBRmR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 13:42:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAE1C061575;
        Thu,  2 Sep 2021 10:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=PDzjS+dr10ndkrHE9asrJrwhiTPnedHV5fGVL8VIm34=; b=wFrUeTIQiVlCJMmbc0haxWL8cr
        ZtLHi5qjHqc8Gx+iVj/pRj4alPjXxvUOBZwM5VlBgXPA4q1WlYzZWxdB6w02oOklBEj5LXPUzhtPq
        PUuufFNWSbpZMzhicWxYDQrK5glPn1kQtjZol7KRAnd2JJpY0hQHqFtrho1iobrOdNQSemrgYkKJt
        jWfevQBE13OzFT4LlsAoZpDJARfY8hG+UZUTzMSkpZ6gej/9pLgwHEHDQlTgfifz2TkCwbmBT/ybb
        EJjIsLvvW8K72raohKTtmnnoBOP0ulkB5hiY6JXlTI/KGVuG+iAqOQ1yDAKWwfqflxyN/DFh68zf6
        q3UxIJoA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLqi1-00A9FG-UL; Thu, 02 Sep 2021 17:41:05 +0000
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
Subject: [PATCH 3/9] mspro_block: add error handling support for add_disk()
Date:   Thu,  2 Sep 2021 10:40:59 -0700
Message-Id: <20210902174105.2418771-4-mcgrof@kernel.org>
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
 drivers/memstick/core/mspro_block.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 22778d0e24f5..c0450397b673 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1239,10 +1239,14 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	set_capacity(msb->disk, capacity);
 	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
 
-	device_add_disk(&card->dev, msb->disk, NULL);
+	rc = device_add_disk(&card->dev, msb->disk, NULL);
+	if (rc)
+		goto out_cleanup_disk;
 	msb->active = 1;
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(msb->disk);
 out_free_tag_set:
 	blk_mq_free_tag_set(&msb->tag_set);
 out_release_id:
-- 
2.30.2

