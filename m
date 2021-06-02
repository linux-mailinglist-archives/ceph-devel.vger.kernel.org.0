Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18951398223
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhFBG55 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhFBG5o (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:57:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915C6C061756;
        Tue,  1 Jun 2021 23:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5mJAZZeO1CtG3mn2Yuq3t9OP/z6HiPXlonifU+Xv8uk=; b=tt3BlzEvyR33jB2X0kDiZ5TSxB
        csELHSnmlT8T6KUWOPDXdz45J2xQyFQU19xaezbdVZgeUVrTi9u9ZPTPO6fqT1nm0qE2v7SVLycE9
        /MOWrjDcC/xYy6qBU13Znm79Ch9jRwtBbUtbfzUmR+I9pRspaNFEvyOXmYvNfXgWZsh0TdBvJLp4s
        /Fr3RVYTz9uY0FffL4ddTLGXqxR4LHnzHncqok0pz2PtYl2ZKi5VfjzMdqvx8SDrYpymOwhWqr6QX
        Z9xSFfPHVSbsRQooQMBqPIpILAv/Gx+wWjK7rLtRMYAMdC9wtpz/a7ziP04g4HcPFPbwAdib7nnbG
        Ptr9BkmA==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKmx-0026Co-6G; Wed, 02 Jun 2021 06:55:40 +0000
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
Subject: [PATCH 23/30] rnbd: use blk_mq_alloc_disk and blk_cleanup_disk
Date:   Wed,  2 Jun 2021 09:53:38 +0300
Message-Id: <20210602065345.355274-24-hch@lst.de>
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
 drivers/block/rnbd/rnbd-clt.c | 35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index c604a402cd5c..f4fa45d24c0b 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1353,18 +1353,6 @@ static void rnbd_init_mq_hw_queues(struct rnbd_clt_dev *dev)
 	}
 }
 
-static int setup_mq_dev(struct rnbd_clt_dev *dev)
-{
-	dev->queue = blk_mq_init_queue(&dev->sess->tag_set);
-	if (IS_ERR(dev->queue)) {
-		rnbd_clt_err(dev, "Initializing multiqueue queue failed, err: %ld\n",
-			      PTR_ERR(dev->queue));
-		return PTR_ERR(dev->queue);
-	}
-	rnbd_init_mq_hw_queues(dev);
-	return 0;
-}
-
 static void setup_request_queue(struct rnbd_clt_dev *dev)
 {
 	blk_queue_logical_block_size(dev->queue, dev->logical_block_size);
@@ -1393,13 +1381,13 @@ static void setup_request_queue(struct rnbd_clt_dev *dev)
 	blk_queue_io_opt(dev->queue, dev->sess->max_io_size);
 	blk_queue_virt_boundary(dev->queue, SZ_4K - 1);
 	blk_queue_write_cache(dev->queue, dev->wc, dev->fua);
-	dev->queue->queuedata = dev;
 }
 
 static void rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev, int idx)
 {
 	dev->gd->major		= rnbd_client_major;
 	dev->gd->first_minor	= idx << RNBD_PART_BITS;
+	dev->gd->minors		= 1 << RNBD_PART_BITS;
 	dev->gd->fops		= &rnbd_client_ops;
 	dev->gd->queue		= dev->queue;
 	dev->gd->private_data	= dev;
@@ -1426,24 +1414,18 @@ static void rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev, int idx)
 
 static int rnbd_client_setup_device(struct rnbd_clt_dev *dev)
 {
-	int err, idx = dev->clt_device_id;
+	int idx = dev->clt_device_id;
 
 	dev->size = dev->nsectors * dev->logical_block_size;
 
-	err = setup_mq_dev(dev);
-	if (err)
-		return err;
+	dev->gd = blk_mq_alloc_disk(&dev->sess->tag_set, dev);
+	if (IS_ERR(dev->gd))
+		return PTR_ERR(dev->gd);
+	dev->queue = dev->gd->queue;
+	rnbd_init_mq_hw_queues(dev);
 
 	setup_request_queue(dev);
-
-	dev->gd = alloc_disk_node(1 << RNBD_PART_BITS,	NUMA_NO_NODE);
-	if (!dev->gd) {
-		blk_cleanup_queue(dev->queue);
-		return -ENOMEM;
-	}
-
 	rnbd_clt_setup_gen_disk(dev, idx);
-
 	return 0;
 }
 
@@ -1650,8 +1632,7 @@ struct rnbd_clt_dev *rnbd_clt_map_device(const char *sessname,
 static void destroy_gen_disk(struct rnbd_clt_dev *dev)
 {
 	del_gendisk(dev->gd);
-	blk_cleanup_queue(dev->queue);
-	put_disk(dev->gd);
+	blk_cleanup_disk(dev->gd);
 }
 
 static void destroy_sysfs(struct rnbd_clt_dev *dev,
-- 
2.30.2

