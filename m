Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06C639823D
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhFBG6f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhFBG6L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:58:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B229C061763;
        Tue,  1 Jun 2021 23:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZrMEf0Ls9F+Osx12fthB6jYFp7YA2RuOfcMRudkR5eo=; b=RmhbmeEgAua7D4yc0CN6m+daMw
        ggu55W3yOtqsYbnSz5c1dfLFQJ9ncvb9hc3nNvkXY6f0gcSGMOhLStwUwb0UQrJ1aG7h0ZSUng/WX
        es/ejunr+apwEHWPUWRQDfPQvgeX1hrHlUl4NOb5oItwm7czJQwirbV+FChfRP7dM0qxLnCRqVmgI
        bA1/+LYF3tWUOd/53KL9zns/VStS5lpZkIiq55Ah7xS6m/8ryTxd0+2JtSdNyv1ovCOilXcKoWuJr
        8KfLwtubqhZXD6/OkB2mdwrFmz8NTFBmkmZB+9B1+iGvFIgntGiUljL/AChzeEhq1iCnrHX8J/lkd
        xKgRqjOg==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKnR-0026ec-A8; Wed, 02 Jun 2021 06:56:10 +0000
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
Subject: [PATCH 30/30] z2ram: use blk_mq_alloc_disk and blk_cleanup_disk
Date:   Wed,  2 Jun 2021 09:53:45 +0300
Message-Id: <20210602065345.355274-31-hch@lst.de>
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
 drivers/block/z2ram.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index c1d20818e649..a8968d9e759b 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -323,27 +323,20 @@ static const struct blk_mq_ops z2_mq_ops = {
 
 static int z2ram_register_disk(int minor)
 {
-	struct request_queue *q;
 	struct gendisk *disk;
 
-	disk = alloc_disk(1);
-	if (!disk)
-		return -ENOMEM;
-
-	q = blk_mq_init_queue(&tag_set);
-	if (IS_ERR(q)) {
-		put_disk(disk);
-		return PTR_ERR(q);
-	}
+	disk = blk_mq_alloc_disk(&tag_set, NULL);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
 
 	disk->major = Z2RAM_MAJOR;
 	disk->first_minor = minor;
+	disk->minors = 1;
 	disk->fops = &z2_fops;
 	if (minor)
 		sprintf(disk->disk_name, "z2ram%d", minor);
 	else
 		sprintf(disk->disk_name, "z2ram");
-	disk->queue = q;
 
 	z2ram_gendisk[minor] = disk;
 	add_disk(disk);
-- 
2.30.2

