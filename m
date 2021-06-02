Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE83539819F
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhFBG4X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhFBG4W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:56:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B11C061574;
        Tue,  1 Jun 2021 23:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BVgbkrgI5w8hw6EfzYARLfGWi6Kh9lFpzsXZ419HK1w=; b=U/MbBupmxlqb75y1PHkCyebynQ
        Rt4fL6fa+WzCejYcSifBRXJN9ka135vcRGgG8l7nbiWMw0RO1zAmvQeHG1EB4hkdZrMO1+8e6kT24
        CCFvZVn7hwrTPmSO8fpiW0WjG8kLUcuJo4czgl1Ug2/VWcJs1QWpkGaOQJlwRiQFMiTkkEzvrxwXC
        /fDjwhFDYriH71KkRIgFNetz9g9Hzp0uZkvRppj4VHGBAA/bVFhYgYPuSMVLVDyrW+QDFj6Zc5Hbr
        orlbN/emDladETPZOn+hbjRC0uB/M6eGxSnx/UmBiIxbqX/2NW/f466ciE4Zata7/KUdQ0LnF4eAy
        LoIgT7+A==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKlg-0025NX-RE; Wed, 02 Jun 2021 06:54:21 +0000
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
Subject: [PATCH 06/30] pf: use blk_mq_alloc_disk
Date:   Wed,  2 Jun 2021 09:53:21 +0300
Message-Id: <20210602065345.355274-7-hch@lst.de>
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
 drivers/block/paride/pf.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index bb09f21ce21a..d5b9c88ba76f 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -294,20 +294,17 @@ static void __init pf_init_units(void)
 	for (unit = 0, pf = units; unit < PF_UNITS; unit++, pf++) {
 		struct gendisk *disk;
 
-		disk = alloc_disk(1);
-		if (!disk)
+		if (blk_mq_alloc_sq_tag_set(&pf->tag_set, &pf_mq_ops, 1,
+				BLK_MQ_F_SHOULD_MERGE))
 			continue;
 
-		disk->queue = blk_mq_init_sq_queue(&pf->tag_set, &pf_mq_ops,
-							1, BLK_MQ_F_SHOULD_MERGE);
-		if (IS_ERR(disk->queue)) {
-			disk->queue = NULL;
-			put_disk(disk);
+		disk = blk_mq_alloc_disk(&pf->tag_set, pf);
+		if (IS_ERR(disk)) {
+			blk_mq_free_tag_set(&pf->tag_set);
 			continue;
 		}
 
 		INIT_LIST_HEAD(&pf->rq_list);
-		disk->queue->queuedata = pf;
 		blk_queue_max_segments(disk->queue, cluster);
 		blk_queue_bounce_limit(disk->queue, BLK_BOUNCE_HIGH);
 		pf->disk = disk;
@@ -318,6 +315,7 @@ static void __init pf_init_units(void)
 		snprintf(pf->name, PF_NAMELEN, "%s%d", name, unit);
 		disk->major = major;
 		disk->first_minor = unit;
+		disk->minors = 1;
 		strcpy(disk->disk_name, pf->name);
 		disk->fops = &pf_fops;
 		disk->events = DISK_EVENT_MEDIA_CHANGE;
@@ -766,10 +764,8 @@ static int pf_detect(void)
 	for (pf = units, unit = 0; unit < PF_UNITS; pf++, unit++) {
 		if (!pf->disk)
 			continue;
-		blk_cleanup_queue(pf->disk->queue);
-		pf->disk->queue = NULL;
+		blk_cleanup_disk(pf->disk);
 		blk_mq_free_tag_set(&pf->tag_set);
-		put_disk(pf->disk);
 	}
 	pi_unregister_driver(par_drv);
 	return -1;
-- 
2.30.2

