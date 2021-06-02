Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D58E39820C
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhFBG5d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhFBG5T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:57:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46FCC061347;
        Tue,  1 Jun 2021 23:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ay3+BGPlRqdc0EFLNjvSyNAlCXYv7F/E4ZKoFdkW+qs=; b=re781XvQTLqNz+tW0K+eeLN126
        ZHdsuYJ2Awc6hKt5NXrxWVcF1gLtmPmqrRoYM1HI43jkn7Qf75wWP01UlBu2V2sY61J+OM/Etw42Y
        +/Y9bV0NZSR7XSiaIB3hoA5FplO+Knn8VPNUx84Za0n+grjUeqHa7Ia2Y6hM5luzozyZJ8Is3hs5t
        0f1bIF+gL/yS4tMtIJDr7RZZ0gaHP+N8QcEaL1x8gVuo08fsq6poeekNRuls+ivPNI9U2B65ypj48
        yQjKdXwi7x17Mz91bhzCLHhe29vJAUjBIJ8vYze0d6zCgmUka+cbdrK9DUBsKkhmarGXEPYZxI+5z
        n/v3EyXw==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKma-0025sw-BW; Wed, 02 Jun 2021 06:55:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Justin Sanders <justin@coraid.com>,
        Denis Efremov <efremov@linux.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Tim Waugh <tim@cyberelk.net>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        nbd@other.debian.org, linuxppc-dev@lists.ozlabs.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: [PATCH 18/30] loop: use blk_mq_alloc_disk and blk_cleanup_disk
Date:   Wed,  2 Jun 2021 09:53:33 +0300
Message-Id: <20210602065345.355274-19-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210602065345.355274-1-hch@lst.de>
References: <20210602065345.355274-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Use blk_mq_alloc_disk and blk_cleanup_disk to simplify the gendisk and
request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 95c570f5923f..3f40e673a101 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2117,12 +2117,12 @@ static int loop_add(struct loop_device **l, int i)
 	if (err)
 		goto out_free_idr;
 
-	lo->lo_queue = blk_mq_init_queue(&lo->tag_set);
-	if (IS_ERR(lo->lo_queue)) {
-		err = PTR_ERR(lo->lo_queue);
+	disk = lo->lo_disk = blk_mq_alloc_disk(&lo->tag_set, lo);
+	if (IS_ERR(disk)) {
+		err = PTR_ERR(disk);
 		goto out_cleanup_tags;
 	}
-	lo->lo_queue->queuedata = lo;
+	lo->lo_queue = lo->lo_disk->queue;
 
 	blk_queue_max_hw_sectors(lo->lo_queue, BLK_DEF_MAX_SECTORS);
 
@@ -2134,11 +2134,6 @@ static int loop_add(struct loop_device **l, int i)
 	 */
 	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, lo->lo_queue);
 
-	err = -ENOMEM;
-	disk = lo->lo_disk = alloc_disk(1 << part_shift);
-	if (!disk)
-		goto out_free_queue;
-
 	/*
 	 * Disable partition scanning by default. The in-kernel partition
 	 * scanning can be requested individually per-device during its
@@ -2166,6 +2161,7 @@ static int loop_add(struct loop_device **l, int i)
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
+	disk->minors		= 1 << part_shift;
 	disk->fops		= &lo_fops;
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
@@ -2174,8 +2170,6 @@ static int loop_add(struct loop_device **l, int i)
 	*l = lo;
 	return lo->lo_number;
 
-out_free_queue:
-	blk_cleanup_queue(lo->lo_queue);
 out_cleanup_tags:
 	blk_mq_free_tag_set(&lo->tag_set);
 out_free_idr:
@@ -2189,9 +2183,8 @@ static int loop_add(struct loop_device **l, int i)
 static void loop_remove(struct loop_device *lo)
 {
 	del_gendisk(lo->lo_disk);
-	blk_cleanup_queue(lo->lo_queue);
 	blk_mq_free_tag_set(&lo->tag_set);
-	put_disk(lo->lo_disk);
+	blk_cleanup_disk(lo->lo_disk);
 	mutex_destroy(&lo->lo_mutex);
 	kfree(lo);
 }
-- 
2.30.2

