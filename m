Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92D5398216
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhFBG5h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhFBG52 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:57:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46D9C06174A;
        Tue,  1 Jun 2021 23:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dPXgPagX0YUjFpHkmb7+BJvE2rgQGNh10xmKRHSEoBw=; b=BmfFZoZgZc3og4CmFwOmdLx19i
        QO/EHgrku+yvgdhYC17jfB1aTEH3npIjzEWzSTOP+FtfRG47SoCYsd6XDZdDvG8QFc30baslGnBO5
        603qv1a5lD3zj6piDqc7/7HezJHswlQmBy2hQzdsqi+Pq2AqXMvtz6CZelFZP4OuEsOQ481G/g0oe
        2D5d45xL9+Y8IhSZ0SJ7QgmfDd59y+PvwieZLqYIaXHXwCMZQBwPlFGdwrK57V7ShUrkG8V37WJ3E
        EOpP42tJMZNBze5kjBlU3735zuT501c+A9ju4eeM4xto97GnaI9ogfZqwLOqhLmVBPmt6XU0UdEOR
        G7vAYXaA==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKmj-00260g-93; Wed, 02 Jun 2021 06:55:26 +0000
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
Subject: [PATCH 20/30] nullb: use blk_mq_alloc_disk
Date:   Wed,  2 Jun 2021 09:53:35 +0300
Message-Id: <20210602065345.355274-21-hch@lst.de>
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
 drivers/block/null_blk/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index d8e098f1e5b5..74fb2ec63219 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1851,13 +1851,12 @@ static int null_add_dev(struct nullb_device *dev)
 
 		rv = -ENOMEM;
 		nullb->tag_set->timeout = 5 * HZ;
-		nullb->q = blk_mq_init_queue_data(nullb->tag_set, nullb);
-		if (IS_ERR(nullb->q))
-			goto out_cleanup_tags;
-		nullb->disk = alloc_disk_node(1, nullb->dev->home_node);
-		if (!nullb->disk)
+		nullb->disk = blk_mq_alloc_disk(nullb->tag_set, nullb);
+		if (IS_ERR(nullb->disk)) {
+			rv = PTR_ERR(nullb->disk);
 			goto out_cleanup_disk;
-		nullb->disk->queue = nullb->q;
+		}
+		nullb->q = nullb->disk->queue;
 	} else if (dev->queue_mode == NULL_Q_BIO) {
 		rv = -ENOMEM;
 		nullb->disk = blk_alloc_disk(nullb->dev->home_node);
-- 
2.30.2

