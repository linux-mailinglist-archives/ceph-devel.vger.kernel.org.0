Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56F4398237
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhFBG6R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhFBG6C (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:58:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FC4C061761;
        Tue,  1 Jun 2021 23:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=e/ctmVcBKo8/4TfSYThwuDhurHZGsQmtrWLVmP8rYA8=; b=0A/jGm6O4Kj2j/Kx7dvigliFHC
        rITdmfIP63MHFDu3WSFM5d7dMu7+beFsioI4GrDpda176/3PUgnVrUbqyRWbSjWdcuAiJqiob1gTK
        AvRYkCVCw9w56bk5jObu58cLFiy6YDR/IPuribWTRblB+Qy/UxnevwGEDkt/f/knnTFZf15Y8vlCM
        5ocB4AhVAL+iOilDAuQ8GJXKzc8ZFMa3OISnsDLeHTuB1dBage0GQubfEEJs2dxaTysO0wL6PENPG
        HsubMhTFqnBjdPbq87DlkaqfHQIsjrwpF/ip3GpPNqk0nBPScEi1aAKtroJznPZbqZYyddYJMUb2K
        Z/qjGhrw==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKnJ-0026XD-03; Wed, 02 Jun 2021 06:56:01 +0000
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
Subject: [PATCH 28/30] amiflop: use blk_mq_alloc_disk and blk_cleanup_disk
Date:   Wed,  2 Jun 2021 09:53:43 +0300
Message-Id: <20210602065345.355274-29-hch@lst.de>
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
 drivers/block/amiflop.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 9e2d0c6a3877..8b1714021498 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1781,15 +1781,13 @@ static int fd_alloc_disk(int drive, int system)
 {
 	struct gendisk *disk;
 
-	disk = alloc_disk(1);
-	if (!disk)
-		goto out;
-	disk->queue = blk_mq_init_queue(&unit[drive].tag_set);
-	if (IS_ERR(disk->queue))
-		goto out_put_disk;
+	disk = blk_mq_alloc_disk(&unit[drive].tag_set, NULL);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
 
 	disk->major = FLOPPY_MAJOR;
 	disk->first_minor = drive + system;
+	disk->minors = 1;
 	disk->fops = &floppy_fops;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	if (system)
@@ -1802,12 +1800,6 @@ static int fd_alloc_disk(int drive, int system)
 	unit[drive].gendisk[system] = disk;
 	add_disk(disk);
 	return 0;
-
-out_put_disk:
-	disk->queue = NULL;
-	put_disk(disk);
-out:
-	return -ENOMEM;
 }
 
 static int fd_alloc_drive(int drive)
-- 
2.30.2

