Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D753981FF
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhFBG5Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFBG5M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:57:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDE3C061756;
        Tue,  1 Jun 2021 23:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JLPBr5a4Ln5tpVtARufaz5Rx9DFRvnAc8JDCRXj5CBM=; b=FBI391AmGpCGer8nPkf12dCy+o
        eIEdbU42pvJv3rPD9dFUDNG20907L9ASE2fIQkUHxjUoIi8PgAItnVYsfQZ6hIztO2P1/v5yAnQCY
        AEIEL8vqjQuYY/yLZNb4GnSP5PvUwFzpizHw+fRWs4gY52j0aZwRyeKYcxL1PkeJAHD+Jt16XML9Y
        6k/bwePGimCyBX6ZWlmiXus1eyEpeartBYIhWxPwfdF5ffOhB85DbtrRd+aBJwu9lstkJ64aPi30u
        wP4A8hbv0iVNdk/AGNcCWJHaTuex2I57tAI1/KazjM7mVhow4NChmgEaGqXE5WnMhD7z0Peh8k1rH
        SZflGEZA==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKmR-0025lm-Ax; Wed, 02 Jun 2021 06:55:08 +0000
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
Subject: [PATCH 16/30] aoe: use blk_mq_alloc_disk and blk_cleanup_disk
Date:   Wed,  2 Jun 2021 09:53:31 +0300
Message-Id: <20210602065345.355274-17-hch@lst.de>
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
 drivers/block/aoe/aoeblk.c | 33 ++++++++++++---------------------
 drivers/block/aoe/aoedev.c |  3 +--
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index c34e71b0c4a9..06b360f7123a 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -338,14 +338,13 @@ static const struct blk_mq_ops aoeblk_mq_ops = {
 	.queue_rq	= aoeblk_queue_rq,
 };
 
-/* alloc_disk and add_disk can sleep */
+/* blk_mq_alloc_disk and add_disk can sleep */
 void
 aoeblk_gdalloc(void *vp)
 {
 	struct aoedev *d = vp;
 	struct gendisk *gd;
 	mempool_t *mp;
-	struct request_queue *q;
 	struct blk_mq_tag_set *set;
 	ulong flags;
 	int late = 0;
@@ -362,19 +361,12 @@ aoeblk_gdalloc(void *vp)
 	if (late)
 		return;
 
-	gd = alloc_disk(AOE_PARTITIONS);
-	if (gd == NULL) {
-		pr_err("aoe: cannot allocate disk structure for %ld.%d\n",
-			d->aoemajor, d->aoeminor);
-		goto err;
-	}
-
 	mp = mempool_create(MIN_BUFS, mempool_alloc_slab, mempool_free_slab,
 		buf_pool_cache);
 	if (mp == NULL) {
 		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
-		goto err_disk;
+		goto err;
 	}
 
 	set = &d->tag_set;
@@ -391,12 +383,11 @@ aoeblk_gdalloc(void *vp)
 		goto err_mempool;
 	}
 
-	q = blk_mq_init_queue(set);
-	if (IS_ERR(q)) {
+	gd = blk_mq_alloc_disk(set, d);
+	if (IS_ERR(gd)) {
 		pr_err("aoe: cannot allocate block queue for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
-		blk_mq_free_tag_set(set);
-		goto err_mempool;
+		goto err_tagset;
 	}
 
 	spin_lock_irqsave(&d->lock, flags);
@@ -405,16 +396,16 @@ aoeblk_gdalloc(void *vp)
 	WARN_ON(d->flags & DEVFL_TKILL);
 	WARN_ON(d->gd);
 	WARN_ON(d->flags & DEVFL_UP);
-	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
-	blk_queue_io_opt(q, SZ_2M);
+	blk_queue_max_hw_sectors(gd->queue, BLK_DEF_MAX_SECTORS);
+	blk_queue_io_opt(gd->queue, SZ_2M);
 	d->bufpool = mp;
-	d->blkq = gd->queue = q;
-	q->queuedata = d;
+	d->blkq = gd->queue;
 	d->gd = gd;
 	if (aoe_maxsectors)
-		blk_queue_max_hw_sectors(q, aoe_maxsectors);
+		blk_queue_max_hw_sectors(gd->queue, aoe_maxsectors);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor;
+	gd->minors = AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
 	gd->private_data = d;
 	set_capacity(gd, d->ssize);
@@ -435,10 +426,10 @@ aoeblk_gdalloc(void *vp)
 	spin_unlock_irqrestore(&d->lock, flags);
 	return;
 
+err_tagset:
+	blk_mq_free_tag_set(set);
 err_mempool:
 	mempool_destroy(mp);
-err_disk:
-	put_disk(gd);
 err:
 	spin_lock_irqsave(&d->lock, flags);
 	d->flags &= ~DEVFL_GD_NOW;
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index e2ea2356da06..c5753c6bfe80 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -277,9 +277,8 @@ freedev(struct aoedev *d)
 	if (d->gd) {
 		aoedisk_rm_debugfs(d);
 		del_gendisk(d->gd);
-		put_disk(d->gd);
+		blk_cleanup_disk(d->gd);
 		blk_mq_free_tag_set(&d->tag_set);
-		blk_cleanup_queue(d->blkq);
 	}
 	t = d->targets;
 	e = t + d->ntargets;
-- 
2.30.2

