Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8D439821B
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhFBG5n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhFBG5e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:57:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5E7C061756;
        Tue,  1 Jun 2021 23:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nI/ZQsUq4UAVWWD+XlWiGZNbHY/pEUl6HaoFswHnuQ4=; b=zGlrfHSC/oppIdruF4aRva3o8B
        wtEFmwSmcFHEhWITeGFtHuY9Wo10P04noPv6NDlI408bgIBJRkVwwSNa+XWLEAJlAJuKZOmEWMLIK
        ypzvochOmpTNDSw00TOxKnVYokteVrnhgtmSr1j1yBWFdJc27AJBjUNwKpISp0vKiLy2jjLimY0Ek
        6P9TdCUkFiGBNMeFMPeq+ck3KCV/5OtDAHAEJPXDdOXuVm3Wp8pMIeYa4M2y0KOxO5BAOQxPKiJkk
        QtHEQ5wWjrHNPSLHnxZaMHUkkPwojUCno1EhOKjx/cVHeiOj1wg20mdo5EoURfDorHUaeAxyeZdGp
        7/lZ2gHg==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKmo-002647-90; Wed, 02 Jun 2021 06:55:31 +0000
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
Subject: [PATCH 21/30] pd: use blk_mq_alloc_disk and blk_cleanup_disk
Date:   Wed,  2 Jun 2021 09:53:36 +0300
Message-Id: <20210602065345.355274-22-hch@lst.de>
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
 drivers/block/paride/pd.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 828a45ffe0e7..3b2b8e872beb 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -879,18 +879,6 @@ static void pd_probe_drive(struct pd_unit *disk)
 {
 	struct gendisk *p;
 
-	p = alloc_disk(1 << PD_BITS);
-	if (!p)
-		return;
-
-	strcpy(p->disk_name, disk->name);
-	p->fops = &pd_fops;
-	p->major = major;
-	p->first_minor = (disk - pd) << PD_BITS;
-	p->events = DISK_EVENT_MEDIA_CHANGE;
-	disk->gd = p;
-	p->private_data = disk;
-
 	memset(&disk->tag_set, 0, sizeof(disk->tag_set));
 	disk->tag_set.ops = &pd_mq_ops;
 	disk->tag_set.cmd_size = sizeof(struct pd_req);
@@ -903,14 +891,21 @@ static void pd_probe_drive(struct pd_unit *disk)
 	if (blk_mq_alloc_tag_set(&disk->tag_set))
 		return;
 
-	p->queue = blk_mq_init_queue(&disk->tag_set);
-	if (IS_ERR(p->queue)) {
+	p = blk_mq_alloc_disk(&disk->tag_set, disk);
+	if (!p) {
 		blk_mq_free_tag_set(&disk->tag_set);
-		p->queue = NULL;
 		return;
 	}
+	disk->gd = p;
+
+	strcpy(p->disk_name, disk->name);
+	p->fops = &pd_fops;
+	p->major = major;
+	p->first_minor = (disk - pd) << PD_BITS;
+	p->minors = 1 << PD_BITS;
+	p->events = DISK_EVENT_MEDIA_CHANGE;
+	p->private_data = disk;
 
-	p->queue->queuedata = disk;
 	blk_queue_max_hw_sectors(p->queue, cluster);
 	blk_queue_bounce_limit(p->queue, BLK_BOUNCE_HIGH);
 
@@ -1019,9 +1014,8 @@ static void __exit pd_exit(void)
 		if (p) {
 			disk->gd = NULL;
 			del_gendisk(p);
-			blk_cleanup_queue(p->queue);
 			blk_mq_free_tag_set(&disk->tag_set);
-			put_disk(p);
+			blk_cleanup_disk(p);
 			pi_release(disk->pi);
 		}
 	}
-- 
2.30.2

