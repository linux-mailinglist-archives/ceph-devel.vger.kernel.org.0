Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573082C7A8B
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Nov 2020 19:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgK2SUo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Nov 2020 13:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2SUn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Nov 2020 13:20:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605DCC0613D2;
        Sun, 29 Nov 2020 10:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ypeh1zE2tu7hsEqcA0sH6qIw67kFS0gBrOEt2wlFIlY=; b=DpSxjcarlaVANu+UwuqeFP67Ao
        HA6bQP8B1rQCvKXnAFP6urgjwhVQVO8dI0anxbgMKWn5MHnEBlTFSHilfXT2LBqDCYAjBFpSelhBW
        Ayg0yKTDclpVssVKVKf8i734cyTkDZ/OX9pR62Oc6Vs3HEN+LYROZC3IE2jkBcTOUkAhWqmi4ePGo
        p9lxIo2GDIU2LmhxuHlFxtW1iCLAOuF0N/kcay3jOP8uYzp3oa9ZP1pyjYHrvvzUYwo8WXeTnadhd
        6jtwic1kx7QAqR1Zfj1YS0l+V+4oNVPLmR46rhlB7g7tzm8UoYDN5LWrKyssB//1XRQIIgAePN0sY
        oYEX2GLA==;
Received: from [2001:4bb8:18c:1dd6:f89e:6884:c966:3d6c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRIR-000780-Rb; Sun, 29 Nov 2020 18:19:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: [PATCH 2/4] rbd: remove the ->set_read_only method
Date:   Sun, 29 Nov 2020 19:19:24 +0100
Message-Id: <20201129181926.897775-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201129181926.897775-1-hch@lst.de>
References: <20201129181926.897775-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Now that the hardware read-only state can't be changed by the BLKROSET
ioctl, the code in this method is not required anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rbd.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 2ed79b09439a82..2c64ca15ca079f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -692,29 +692,10 @@ static void rbd_release(struct gendisk *disk, fmode_t mode)
 	put_device(&rbd_dev->dev);
 }
 
-static int rbd_set_read_only(struct block_device *bdev, bool ro)
-{
-	struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
-
-	/*
-	 * Both images mapped read-only and snapshots can't be marked
-	 * read-write.
-	 */
-	if (!ro) {
-		if (rbd_is_ro(rbd_dev))
-			return -EROFS;
-
-		rbd_assert(!rbd_is_snap(rbd_dev));
-	}
-
-	return 0;
-}
-
 static const struct block_device_operations rbd_bd_ops = {
 	.owner			= THIS_MODULE,
 	.open			= rbd_open,
 	.release		= rbd_release,
-	.set_read_only		= rbd_set_read_only,
 };
 
 /*
-- 
2.29.2

