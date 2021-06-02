Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF1F3981C1
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhFBG4u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhFBG4m (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:56:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2BFC061574;
        Tue,  1 Jun 2021 23:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VKYFJ4i2fp8TEWNMfgNX8wUyWWT+i6aWdBUPvxl8r/8=; b=Kje0bT6cmZTfkyQxEo++Euls2J
        q9bXO5jBawfI5ZZjRGS03IawDLbrxJhUhzTvnTagkSofonFcJnjtZC0dS+BvJRy6582P7WupPFtDf
        YeiiT9xlBwIlX3HIpr7KUTIHfDr8j72sUD7rZUU1oNkALcPDkDl0X1EYUDita2YrN3DmOI90nfQUA
        gBWdA9G+j1xkdZAZ9F+vJTeuzyM+QXgQvwA/7khxUkXj7qUfyZB13p4qh8JGRf1c0Rpcy0rETNuYn
        ceg4VbVFwo5MAMklt15SLCAQymtkaL4oCoEvsKTQbGlTwFmOXo2sfzTaSyLUMXNv/EYWRrCaCG51D
        BG4zCUxQ==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKly-0025TX-SP; Wed, 02 Jun 2021 06:54:39 +0000
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
Subject: [PATCH 09/30] mtd_blkdevs: use blk_mq_alloc_disk
Date:   Wed,  2 Jun 2021 09:53:24 +0300
Message-Id: <20210602065345.355274-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210602065345.355274-1-hch@lst.de>
References: <20210602065345.355274-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mtd/mtd_blkdevs.c | 48 ++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index fb8e12d590a1..5dc4c966ea73 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -30,11 +30,9 @@ static void blktrans_dev_release(struct kref *kref)
 	struct mtd_blktrans_dev *dev =
 		container_of(kref, struct mtd_blktrans_dev, ref);
 
-	dev->disk->private_data = NULL;
-	blk_cleanup_queue(dev->rq);
+	blk_cleanup_disk(dev->disk);
 	blk_mq_free_tag_set(dev->tag_set);
 	kfree(dev->tag_set);
-	put_disk(dev->disk);
 	list_del(&dev->list);
 	kfree(dev);
 }
@@ -354,7 +352,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (new->devnum > (MINORMASK >> tr->part_bits) ||
 	    (tr->part_bits && new->devnum >= 27 * 26)) {
 		mutex_unlock(&blktrans_ref_mutex);
-		goto error1;
+		return ret;
 	}
 
 	list_add_tail(&new->list, &tr->devs);
@@ -366,17 +364,28 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (!tr->writesect)
 		new->readonly = 1;
 
-	/* Create gendisk */
 	ret = -ENOMEM;
-	gd = alloc_disk(1 << tr->part_bits);
+	new->tag_set = kzalloc(sizeof(*new->tag_set), GFP_KERNEL);
+	if (!new->tag_set)
+		goto out_list_del;
 
-	if (!gd)
-		goto error2;
+	ret = blk_mq_alloc_sq_tag_set(new->tag_set, &mtd_mq_ops, 2,
+			BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING);
+	if (ret)
+		goto out_kfree_tag_set;
+
+	/* Create gendisk */
+	gd = blk_mq_alloc_disk(new->tag_set, new);
+	if (IS_ERR(gd)) {
+		ret = PTR_ERR(gd);
+		goto out_free_tag_set;
+	}
 
 	new->disk = gd;
 	gd->private_data = new;
 	gd->major = tr->major;
 	gd->first_minor = (new->devnum) << tr->part_bits;
+	gd->minors = 1 << tr->part_bits;
 	gd->fops = &mtd_block_ops;
 
 	if (tr->part_bits)
@@ -398,22 +407,9 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	spin_lock_init(&new->queue_lock);
 	INIT_LIST_HEAD(&new->rq_list);
 
-	new->tag_set = kzalloc(sizeof(*new->tag_set), GFP_KERNEL);
-	if (!new->tag_set)
-		goto error3;
-
-	new->rq = blk_mq_init_sq_queue(new->tag_set, &mtd_mq_ops, 2,
-				BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING);
-	if (IS_ERR(new->rq)) {
-		ret = PTR_ERR(new->rq);
-		new->rq = NULL;
-		goto error4;
-	}
-
 	if (tr->flush)
 		blk_queue_write_cache(new->rq, true, false);
 
-	new->rq->queuedata = new;
 	blk_queue_logical_block_size(new->rq, tr->blksize);
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, new->rq);
@@ -437,13 +433,13 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		WARN_ON(ret);
 	}
 	return 0;
-error4:
+
+out_free_tag_set:
+	blk_mq_free_tag_set(new->tag_set);
+out_kfree_tag_set:
 	kfree(new->tag_set);
-error3:
-	put_disk(new->disk);
-error2:
+out_list_del:
 	list_del(&new->list);
-error1:
 	return ret;
 }
 
-- 
2.30.2

