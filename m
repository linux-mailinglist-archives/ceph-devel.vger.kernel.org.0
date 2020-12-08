Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAC92D2FDA
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 17:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgLHQiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 11:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbgLHQiF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 11:38:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A466EC061793;
        Tue,  8 Dec 2020 08:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=v4slHGDTT2Sku92ts8Y9y7CGrHZhu+VFefigrYM6LO8=; b=q8qsh046BojX4/WMceI+MqtOU5
        kLan7bFMfpJkXWMYs0KHbin2QITMe7hvMpL5IB4YpLG+ju8a9elK0PxytX9qAWOxvZk+E3SJ/tBpw
        kvfT5n68TmQAp2ClzU4C0aI7yM18Bgit0RecaUOolGKGFJx7q9osA4t1ylQXw+84hUG9XVkA6VJp1
        14lHzPo2Zizkg2YEdlBXSRxkqHBswHz3FbXJXBtbWNC//xa6J8n+3bmwhUfnoequauSgr+qv5Lr2H
        A7s9vR2xrTSVO0X6Na7OyLPpdTdp+KeqvPd87m+ozGkKsQltHOFjgjwU78jCZGmirCDEW+hj1+4LI
        RgtEWAyA==;
Received: from [2001:4bb8:188:f36:7a30:8a2b:aea3:231b] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmfzJ-0001O6-Oc; Tue, 08 Dec 2020 16:37:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] rbd: remove the ->set_read_only method
Date:   Tue,  8 Dec 2020 17:28:28 +0100
Message-Id: <20201208162829.2424563-6-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208162829.2424563-1-hch@lst.de>
References: <20201208162829.2424563-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Now that the hardware read-only state can't be changed by the BLKROSET
ioctl, the code in this method is not required anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

