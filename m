Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A452939823F
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Jun 2021 08:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhFBG6i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Jun 2021 02:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhFBG6L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Jun 2021 02:58:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D65C0613CE;
        Tue,  1 Jun 2021 23:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7GHnP6DNZGlKFwjbxdBpad0uFlCxBKJH9Xsnx8ec7ac=; b=nF5H5Xm7fe4zGXbHdq72l4Rnzy
        kg+w8MA3+xaOntMSOadwazIKALvfRRzCTRy9MFxfEVrh2sKEgQoBbgUOGRaieuAuAxc4ABeXBS8HN
        SQtDG1OQjVRLervqQcLcyPmZ3DOCzf6Iza9QUOxa7eEES0n40jma6ts5XDhrZorWgE/EAulN1GwbV
        Z5MnbQ9Pt4ZuIesxtmUE7CYUNs9IpOi40S5W3ULs7jy5knAcpmh8yHUS3I5I9+QDcpjjk0bMn7Cxn
        tMuGXllg4mbf6SO7+IH+aPv1V5kGTRswN64kZiIdU1FDVemfSZMUYCMTkt4iBJ9J6ovY+/RiKuAOr
        KKtQYNhA==;
Received: from shol69.static.otenet.gr ([83.235.170.67] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loKnN-0026aZ-Dz; Wed, 02 Jun 2021 06:56:05 +0000
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
Subject: [PATCH 29/30] ataflop: use blk_mq_alloc_disk and blk_cleanup_disk
Date:   Wed,  2 Jun 2021 09:53:44 +0300
Message-Id: <20210602065345.355274-30-hch@lst.de>
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
 drivers/block/ataflop.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index d601e49f80e0..a093644ac39f 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1968,22 +1968,14 @@ static const struct blk_mq_ops ataflop_mq_ops = {
 static int ataflop_alloc_disk(unsigned int drive, unsigned int type)
 {
 	struct gendisk *disk;
-	int ret;
-
-	disk = alloc_disk(1);
-	if (!disk)
-		return -ENOMEM;
 
-	disk->queue = blk_mq_init_queue(&unit[drive].tag_set);
-	if (IS_ERR(disk->queue)) {
-		ret = PTR_ERR(disk->queue);
-		disk->queue = NULL;
-		put_disk(disk);
-		return ret;
-	}
+	disk = blk_mq_alloc_disk(&unit[drive].tag_set, NULL);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
 
 	disk->major = FLOPPY_MAJOR;
 	disk->first_minor = drive + (type << 2);
+	disk->minors = 1;
 	sprintf(disk->disk_name, "fd%d", drive);
 	disk->fops = &floppy_fops;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
-- 
2.30.2

