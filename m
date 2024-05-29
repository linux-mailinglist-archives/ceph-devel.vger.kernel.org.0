Return-Path: <ceph-devel+bounces-1175-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E508D2C17
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2024 07:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB3D3B24A79
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2024 05:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 720AA161319;
	Wed, 29 May 2024 05:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ReWXkSxr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F0A161307;
	Wed, 29 May 2024 05:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716959148; cv=none; b=Cq87FuyxofJseyF8XQIyuvbUTvstUnAJ/Za925pTivYb8nkPncSGOkEAdOtbRXzPwD/RKjy8VaqoV/VXOKREq4/QE+QBroBGwnQAgaTPBgVnDwRLz5AohgSacMEcfdpcoX5Ob/KKebp3o4Xwq9Y/Zn7MXMJudHlA+OHlFOb4OYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716959148; c=relaxed/simple;
	bh=OyNECHjXr3nPPezBAxkgdWSgnFHJf6zBdO/G7WJxGZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmnElPvYyOlt2Oq2dyqxRr9QKILvA+Gqdnd95q4nADHGV8ilBjOnOdNAX/v47oSAyQNJKW1EnvpoCirzMuozBGnAgMpZHx4JRcmBVh6fy2pVT8xvsBNFX7NmiR46t0vAwo05j09RQV6C5RQf4vUatNKF0+TejicXXMLxRle5u0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ReWXkSxr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8d6ngVwHNTNauOwhnmSKDDZurLIjQvxFhyRamCIijqE=; b=ReWXkSxrT/T0XfXFgzP7fcQh8P
	LoBLaZcev4afPR23+iF5PXS7kCs2z2TUVpoIyd/78ykilQnjG3jxnGKaz2qygkpvtbwzRtjvrCAYl
	kRalvqMO0n637ZnM+ujlbGRx9Uu7J/K8mx82XsU4sJ6adxwSBGxzWOrKd2C7hHkoCEYhQW7+4GHs4
	8eb0wh5wj73qBWmxsrBOfDOpKI6TsU3lSvJljEqqgtLUrlfbSgX2/FMMZqnCGSthgaaxRI+ADIMzo
	LhS0RyV7JdhFep0OEvQhfZB6LNhKVpnMk+2X11OFk5auX0QSxcd9e8fvmb2iVW/2tkg3CnDFmOfdP
	YoUBvdAw==;
Received: from 2a02-8389-2341-5b80-7775-b725-99f7-3344.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7775:b725:99f7:3344] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCBVO-00000002pk9-3paf;
	Wed, 29 May 2024 05:05:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 12/12] block: add special APIs for run-time disabling of discard and friends
Date: Wed, 29 May 2024 07:04:14 +0200
Message-ID: <20240529050507.1392041-13-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240529050507.1392041-1-hch@lst.de>
References: <20240529050507.1392041-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

A few drivers optimistically try to support discard, write zeroes and
secure erase and disable the features from the I/O completion handler
if the hardware can't support them.  This disable can't be done using
the atomic queue limits API because the I/O completion handlers can't
take sleeping locks or freezer the queue.  Keep the existing clearing
of the relevant field to zero, but replace the old blk_queue_max_*
APIs with new disable APIs that force the value to 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/um/drivers/ubd_kern.c   |  5 ++---
 block/blk-settings.c         | 41 ------------------------------------
 drivers/block/xen-blkfront.c |  4 ++--
 drivers/scsi/sd.c            |  4 ++--
 include/linux/blkdev.h       | 28 ++++++++++++++++++------
 5 files changed, 28 insertions(+), 54 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index a79a3b7c33a647..7eae1519300fbd 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -475,10 +475,9 @@ static void ubd_handler(void)
 				struct request_queue *q = io_req->req->q;
 
 				if (req_op(io_req->req) == REQ_OP_DISCARD)
-					blk_queue_max_discard_sectors(q, 0);
+					blk_queue_disable_discard(q);
 				if (req_op(io_req->req) == REQ_OP_WRITE_ZEROES)
-					blk_queue_max_write_zeroes_sectors(q,
-							0);
+					blk_queue_disable_write_zeroes(q);
 			}
 			blk_mq_end_request(io_req->req, io_req->error);
 			kfree(io_req);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0b038729608f4b..996f247fc98e80 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -293,47 +293,6 @@ int queue_limits_set(struct request_queue *q, struct queue_limits *lim)
 }
 EXPORT_SYMBOL_GPL(queue_limits_set);
 
-/**
- * blk_queue_max_discard_sectors - set max sectors for a single discard
- * @q:  the request queue for the device
- * @max_discard_sectors: maximum number of sectors to discard
- **/
-void blk_queue_max_discard_sectors(struct request_queue *q,
-		unsigned int max_discard_sectors)
-{
-	struct queue_limits *lim = &q->limits;
-
-	lim->max_hw_discard_sectors = max_discard_sectors;
-	lim->max_discard_sectors =
-		min(max_discard_sectors, lim->max_user_discard_sectors);
-}
-EXPORT_SYMBOL(blk_queue_max_discard_sectors);
-
-/**
- * blk_queue_max_secure_erase_sectors - set max sectors for a secure erase
- * @q:  the request queue for the device
- * @max_sectors: maximum number of sectors to secure_erase
- **/
-void blk_queue_max_secure_erase_sectors(struct request_queue *q,
-		unsigned int max_sectors)
-{
-	q->limits.max_secure_erase_sectors = max_sectors;
-}
-EXPORT_SYMBOL(blk_queue_max_secure_erase_sectors);
-
-/**
- * blk_queue_max_write_zeroes_sectors - set max sectors for a single
- *                                      write zeroes
- * @q:  the request queue for the device
- * @max_write_zeroes_sectors: maximum number of sectors to write per command
- **/
-void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
-		unsigned int max_write_zeroes_sectors)
-{
-	q->limits.max_write_zeroes_sectors = max_write_zeroes_sectors;
-}
-EXPORT_SYMBOL(blk_queue_max_write_zeroes_sectors);
-
 void disk_update_readahead(struct gendisk *disk)
 {
 	blk_apply_bdi_limits(disk->bdi, &disk->queue->limits);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index fd7c0ff2139cee..9b4ec3e4908cce 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1605,8 +1605,8 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				blkif_req(req)->error = BLK_STS_NOTSUPP;
 				info->feature_discard = 0;
 				info->feature_secdiscard = 0;
-				blk_queue_max_discard_sectors(rq, 0);
-				blk_queue_max_secure_erase_sectors(rq, 0);
+				blk_queue_disable_discard(rq);
+				blk_queue_disable_secure_erase(rq);
 			}
 			break;
 		case BLKIF_OP_FLUSH_DISKCACHE:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 03e67936b27928..56fd523b3987a5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -837,7 +837,7 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 static void sd_disable_discard(struct scsi_disk *sdkp)
 {
 	sdkp->provisioning_mode = SD_LBP_DISABLE;
-	blk_queue_max_discard_sectors(sdkp->disk->queue, 0);
+	blk_queue_disable_discard(sdkp->disk->queue);
 }
 
 static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
@@ -1019,7 +1019,7 @@ static void sd_disable_write_same(struct scsi_disk *sdkp)
 {
 	sdkp->device->no_write_same = 1;
 	sdkp->max_ws_blocks = 0;
-	blk_queue_max_write_zeroes_sectors(sdkp->disk->queue, 0);
+	blk_queue_disable_write_zeroes(sdkp->disk->queue);
 }
 
 static void sd_config_write_same(struct scsi_disk *sdkp,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bee71deb8ca066..b83441da12456a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -923,15 +923,31 @@ static inline void queue_limits_cancel_update(struct request_queue *q)
 	mutex_unlock(&q->limits_lock);
 }
 
+/*
+ * These helpers are for drivers that have sloppy feature negotiation and might
+ * have to disable DISCARD, WRITE_ZEROES or SECURE_DISCARD from the I/O
+ * completion handler when the device returned an indicator that the respective
+ * feature is not actually supported.  They are racy and the driver needs to
+ * cope with that.  Try to avoid this scheme if you can.
+ */
+static inline void blk_queue_disable_discard(struct request_queue *q)
+{
+	q->limits.max_discard_sectors = 0;
+}
+
+static inline void blk_queue_disable_secure_erase(struct request_queue *q)
+{
+	q->limits.max_secure_erase_sectors = 0;
+}
+
+static inline void blk_queue_disable_write_zeroes(struct request_queue *q)
+{
+	q->limits.max_write_zeroes_sectors = 0;
+}
+
 /*
  * Access functions for manipulating queue properties
  */
-void blk_queue_max_secure_erase_sectors(struct request_queue *q,
-		unsigned int max_sectors);
-extern void blk_queue_max_discard_sectors(struct request_queue *q,
-		unsigned int max_discard_sectors);
-extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
-		unsigned int max_write_same_sectors);
 void disk_update_readahead(struct gendisk *disk);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
-- 
2.43.0


