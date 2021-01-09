Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C8C2EFF14
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 11:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbhAIKs6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Jan 2021 05:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbhAIKs6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Jan 2021 05:48:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA58C061786;
        Sat,  9 Jan 2021 02:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wxTexlKWoneBV6anguGO7lPwaZLGPxnUSoduv84HejQ=; b=jU1mJj9yQJ3yuBh2nxDhfbiwPk
        PWLPKvlKs2ww9DnqLspxRCC7AMxns9SMfy+KADVB3Kb6FDHVWlgrXmSz7S0B/iZjIeUtG1JF2uV46
        r6OdelNAwOSO+Y4Omkc3WEcO+sTI7RegH/UDzzD/YCl6AD4GWhtCDkG8P51ex0fm6wN8aFZpwJ4A7
        o4cHKWHao7BpRjm4tgSPvB3cpqukaj20y/hM8n4xvqHNZUR3x5vw0W3Uw2lHbIRj1U+VZMsfq501h
        T3w+1Qu4oxARPjiEvJmJGE1D40YEjVxRfDOsSq2d5jGte3qFmDIwNxLi4GRoLSvnFb7XJgYcwa48x
        u8ibnoxg==;
Received: from [2001:4bb8:19b:e528:4197:a20:99de:e7b0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyBlg-000TGF-Cc; Sat, 09 Jan 2021 10:47:20 +0000
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
Date:   Sat,  9 Jan 2021 11:42:53 +0100
Message-Id: <20210109104254.1077093-6-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210109104254.1077093-1-hch@lst.de>
References: <20210109104254.1077093-1-hch@lst.de>
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
index 59cfe71d0b3a39..bbb88eb009e0ba 100644
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

