Return-Path: <ceph-devel+bounces-1229-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A528D5C02
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2024 09:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A99F1C24938
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2024 07:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0DC824AC;
	Fri, 31 May 2024 07:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AYRwtnDJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58FD824A6;
	Fri, 31 May 2024 07:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141759; cv=none; b=AdFM9UEZBSmaxMqpQjRlX0UW6RChwCQ73gcre3GaIUKex0mbdrWyRlAxeAGTvAIOGZoq7tP8H+xPjv8HIpFkG7p4Tgk2EGi4WhyutFR8h/Lq/tkv2IBBOJZc+0Biv+A4so8bPOZvI9StSLrQdEOht1B0YCHLV2AWijXudHwtBvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141759; c=relaxed/simple;
	bh=SVgGgyQTslGKMXV9ob//fINAL7kas8rqhVvFhTYckgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9aWJh1pf2ZI3+1AGa2gqEja9wPYX50ATZP6Z4KBAxnnjuc3G3T0Q3ABL+ViYcsefy8ory3wey4XGcqqHhAG4ciCjIpRT2y0VrA8zvl5VJZ9+CS9hsZhocVGcBxxPcgMM27oAFqK1JncQTCyGChG7FsXJsP3/mVGiAgli/qdiEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AYRwtnDJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4/nz/WYb/Zb/tIFnKGf5HamatZXHIwD043qHeq+0qpw=; b=AYRwtnDJjcn1Q7UeYo5d6GeEQx
	LaFV50ZR3TRtTUPo8wntoO06zmq4gAGnJ4ANVns7K10iL11t+zsZvnxbVY/HHhcvd2HdDnEWt6M3I
	KS5qNdot9Yv78noRBAaqTrX/ncfwca4zubufWhJKQGUPXFvenQRFZ0KXmeDfJL+VjW82wIqW8tud1
	HjM+o0kSZkpMgbeCnqFY1QrLbfyBjmPJZpNx5f8ORMO5QrdP+A9P4pN4Mb8wwDb/UPnDb7PsSBtdi
	81r6DYNBSIm0KtezndCLhQPbtYZeuKW2SoxK392+JhzCXfVQZZs0XHHxuwx2JgLFimAQ2/ZkXNkOR
	n83SSfyA==;
Received: from 2a02-8389-2341-5b80-5ba9-f4da-76fa-44a9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5ba9:f4da:76fa:44a9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx0j-00000009Xkp-05jS;
	Fri, 31 May 2024 07:49:13 +0000
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
	linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 11/14] sd: convert to the atomic queue limits API
Date: Fri, 31 May 2024 09:48:06 +0200
Message-ID: <20240531074837.1648501-12-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531074837.1648501-1-hch@lst.de>
References: <20240531074837.1648501-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Assign all queue limits through a local queue_limits variable and
queue_limits_commit_update so that we can't race updating them from
multiple places, and freeze the queue when updating them so that
in-progress I/O submissions don't see half-updated limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c     | 130 ++++++++++++++++++++++++------------------
 drivers/scsi/sd.h     |   6 +-
 drivers/scsi/sd_zbc.c |  15 ++---
 3 files changed, 85 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 39eddfac09ef8f..049071b5681989 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -101,12 +101,13 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #define SD_MINORS	16
 
-static void sd_config_discard(struct scsi_disk *, unsigned int);
-static void sd_config_write_same(struct scsi_disk *);
+static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
+		unsigned int mode);
+static void sd_config_write_same(struct scsi_disk *sdkp,
+		struct queue_limits *lim);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
 static void sd_shutdown(struct device *);
-static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 
 static DEFINE_IDA(sd_index_ida);
@@ -456,7 +457,8 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
-	int mode;
+	struct queue_limits lim;
+	int mode, err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -472,8 +474,13 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (mode < 0)
 		return -EINVAL;
 
-	sd_config_discard(sdkp, mode);
-
+	lim = queue_limits_start_update(sdkp->disk->queue);
+	sd_config_discard(sdkp, &lim, mode);
+	blk_mq_freeze_queue(sdkp->disk->queue);
+	err = queue_limits_commit_update(sdkp->disk->queue, &lim);
+	blk_mq_unfreeze_queue(sdkp->disk->queue);
+	if (err)
+		return err;
 	return count;
 }
 static DEVICE_ATTR_RW(provisioning_mode);
@@ -556,6 +563,7 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
+	struct queue_limits lim;
 	unsigned long max;
 	int err;
 
@@ -577,8 +585,13 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 		sdkp->max_ws_blocks = max;
 	}
 
-	sd_config_write_same(sdkp);
-
+	lim = queue_limits_start_update(sdkp->disk->queue);
+	sd_config_write_same(sdkp, &lim);
+	blk_mq_freeze_queue(sdkp->disk->queue);
+	err = queue_limits_commit_update(sdkp->disk->queue, &lim);
+	blk_mq_unfreeze_queue(sdkp->disk->queue);
+	if (err)
+		return err;
 	return count;
 }
 static DEVICE_ATTR_RW(max_write_same_blocks);
@@ -827,17 +840,15 @@ static void sd_disable_discard(struct scsi_disk *sdkp)
 	blk_queue_max_discard_sectors(sdkp->disk->queue, 0);
 }
 
-static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
+static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
+		unsigned int mode)
 {
-	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int max_blocks = 0;
 
-	q->limits.discard_alignment =
-		sdkp->unmap_alignment * logical_block_size;
-	q->limits.discard_granularity =
-		max(sdkp->physical_block_size,
-		    sdkp->unmap_granularity * logical_block_size);
+	lim->discard_alignment = sdkp->unmap_alignment * logical_block_size;
+	lim->discard_granularity = max(sdkp->physical_block_size,
+			sdkp->unmap_granularity * logical_block_size);
 	sdkp->provisioning_mode = mode;
 
 	switch (mode) {
@@ -875,7 +886,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 	}
 
-	blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size >> 9));
+	lim->max_hw_discard_sectors = max_blocks *
+		(logical_block_size >> SECTOR_SHIFT);
 }
 
 static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
@@ -1010,9 +1022,9 @@ static void sd_disable_write_same(struct scsi_disk *sdkp)
 	blk_queue_max_write_zeroes_sectors(sdkp->disk->queue, 0);
 }
 
-static void sd_config_write_same(struct scsi_disk *sdkp)
+static void sd_config_write_same(struct scsi_disk *sdkp,
+		struct queue_limits *lim)
 {
-	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
 
 	if (sdkp->device->no_write_same) {
@@ -1066,8 +1078,8 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	}
 
 out:
-	blk_queue_max_write_zeroes_sectors(q, sdkp->max_ws_blocks *
-					 (logical_block_size >> 9));
+	lim->max_write_zeroes_sectors =
+		sdkp->max_ws_blocks * (logical_block_size >> SECTOR_SHIFT);
 }
 
 static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
@@ -2523,7 +2535,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 #define READ_CAPACITY_RETRIES_ON_RESET	10
 
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
-						unsigned char *buffer)
+		struct queue_limits *lim, unsigned char *buffer)
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
@@ -2597,7 +2609,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 	/* Lowest aligned logical block */
 	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
-	blk_queue_alignment_offset(sdp->request_queue, alignment);
+	lim->alignment_offset = alignment;
 	if (alignment && sdkp->first_scan)
 		sd_printk(KERN_NOTICE, sdkp,
 			  "physical block alignment offset: %u\n", alignment);
@@ -2608,7 +2620,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
 
-		sd_config_discard(sdkp, SD_LBP_WS16);
+		sd_config_discard(sdkp, lim, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
@@ -2711,13 +2723,14 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
  * read disk capacity
  */
 static void
-sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
+sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
+		unsigned char *buffer)
 {
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
 
 	if (sd_try_rc16_first(sdp)) {
-		sector_size = read_capacity_16(sdkp, sdp, buffer);
+		sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
 		if (sector_size == -ENODEV)
@@ -2737,7 +2750,7 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 			int old_sector_size = sector_size;
 			sd_printk(KERN_NOTICE, sdkp, "Very big device. "
 					"Trying to use READ CAPACITY(16).\n");
-			sector_size = read_capacity_16(sdkp, sdp, buffer);
+			sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
 			if (sector_size < 0) {
 				sd_printk(KERN_NOTICE, sdkp,
 					"Using 0xffffffff as device size\n");
@@ -2796,9 +2809,8 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 		 */
 		sector_size = 512;
 	}
-	blk_queue_logical_block_size(sdp->request_queue, sector_size);
-	blk_queue_physical_block_size(sdp->request_queue,
-				      sdkp->physical_block_size);
+	lim->logical_block_size = sector_size;
+	lim->physical_block_size = sdkp->physical_block_size;
 	sdkp->device->sector_size = sector_size;
 
 	if (sdkp->capacity > 0xffffffff)
@@ -3220,11 +3232,11 @@ static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
 	return SD_LBP_DISABLE;
 }
 
-/**
- * sd_read_block_limits - Query disk device for preferred I/O sizes.
- * @sdkp: disk to query
+/*
+ * Query disk device for preferred I/O sizes.
  */
-static void sd_read_block_limits(struct scsi_disk *sdkp)
+static void sd_read_block_limits(struct scsi_disk *sdkp,
+		struct queue_limits *lim)
 {
 	struct scsi_vpd *vpd;
 
@@ -3258,7 +3270,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 			sdkp->unmap_alignment =
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
-		sd_config_discard(sdkp, sd_discard_mode(sdkp));
+		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
 	}
 
  out:
@@ -3277,11 +3289,9 @@ static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
 	rcu_read_unlock();
 }
 
-/**
- * sd_read_block_characteristics - Query block dev. characteristics
- * @sdkp: disk to query
- */
-static void sd_read_block_characteristics(struct scsi_disk *sdkp)
+/* Query block device characteristics */
+static void sd_read_block_characteristics(struct scsi_disk *sdkp,
+		struct queue_limits *lim)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	struct scsi_vpd *vpd;
@@ -3307,29 +3317,26 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 #ifdef CONFIG_BLK_DEV_ZONED /* sd_probe rejects ZBD devices early otherwise */
 	if (sdkp->device->type == TYPE_ZBC) {
-		/*
-		 * Host-managed.
-		 */
-		disk_set_zoned(sdkp->disk);
+		lim->zoned = true;
 
 		/*
 		 * Per ZBC and ZAC specifications, writes in sequential write
 		 * required zones of host-managed devices must be aligned to
 		 * the device physical block size.
 		 */
-		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
+		lim->zone_write_granularity = sdkp->physical_block_size;
 	} else {
 		/*
 		 * Host-aware devices are treated as conventional.
 		 */
-		WARN_ON_ONCE(blk_queue_is_zoned(q));
+		lim->zoned = false;
 	}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 	if (!sdkp->first_scan)
 		return;
 
-	if (blk_queue_is_zoned(q))
+	if (lim->zoned)
 		sd_printk(KERN_NOTICE, sdkp, "Host-managed zoned block device\n");
 	else if (sdkp->zoned == 1)
 		sd_printk(KERN_NOTICE, sdkp, "Host-aware SMR disk used as regular disk\n");
@@ -3605,8 +3612,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_device *sdp = sdkp->device;
 	struct request_queue *q = sdkp->disk->queue;
 	sector_t old_capacity = sdkp->capacity;
+	struct queue_limits lim;
 	unsigned char *buffer;
 	unsigned int dev_max;
+	int err;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -3627,12 +3636,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	sd_spinup_disk(sdkp);
 
+	lim = queue_limits_start_update(sdkp->disk->queue);
+
 	/*
 	 * Without media there is no reason to ask; moreover, some devices
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, buffer);
+		sd_read_capacity(sdkp, &lim, buffer);
 		/*
 		 * Some USB/UAS devices return generic values for mode pages
 		 * until the media has been accessed. Trigger a READ operation
@@ -3651,10 +3662,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
-			sd_read_block_limits(sdkp);
+			sd_read_block_limits(sdkp, &lim);
 			sd_read_block_limits_ext(sdkp);
-			sd_read_block_characteristics(sdkp);
-			sd_zbc_read_zones(sdkp, buffer);
+			sd_read_block_characteristics(sdkp, &lim);
+			sd_zbc_read_zones(sdkp, &lim, buffer);
 			sd_read_cpr(sdkp);
 		}
 
@@ -3680,31 +3691,36 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	/* Some devices report a maximum block count for READ/WRITE requests. */
 	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
-	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
+	lim.max_dev_sectors = logical_to_sectors(sdp, dev_max);
 
 	if (sd_validate_min_xfer_size(sdkp))
-		blk_queue_io_min(sdkp->disk->queue,
-				 logical_to_bytes(sdp, sdkp->min_xfer_blocks));
+		lim.io_min = logical_to_bytes(sdp, sdkp->min_xfer_blocks);
 	else
-		blk_queue_io_min(sdkp->disk->queue, 0);
+		lim.io_min = 0;
 
 	/*
 	 * Limit default to SCSI host optimal sector limit if set. There may be
 	 * an impact on performance for when the size of a request exceeds this
 	 * host limit.
 	 */
-	q->limits.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
+	lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
 	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
-		q->limits.io_opt = min_not_zero(q->limits.io_opt,
+		lim.io_opt = min_not_zero(lim.io_opt,
 				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
 	}
 
 	sdkp->first_scan = 0;
 
 	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
-	sd_config_write_same(sdkp);
+	sd_config_write_same(sdkp, &lim);
 	kfree(buffer);
 
+	blk_mq_freeze_queue(sdkp->disk->queue);
+	err = queue_limits_commit_update(sdkp->disk->queue, &lim);
+	blk_mq_unfreeze_queue(sdkp->disk->queue);
+	if (err)
+		return err;
+
 	/*
 	 * For a zoned drive, revalidating the zones can be done only once
 	 * the gendisk capacity is set. So if this fails, set back the gendisk
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 49dd600bfa4825..b4170b17bad47a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -239,7 +239,8 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE]);
+int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
+		u8 buf[SD_BUF_SIZE]);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 					 unsigned char op, bool all);
@@ -250,7 +251,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
-static inline int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
+static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
+		struct queue_limits *lim, u8 buf[SD_BUF_SIZE])
 {
 	return 0;
 }
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 1c24c844e8d178..f685838d9ed214 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -582,13 +582,15 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 /**
  * sd_zbc_read_zones - Read zone information and update the request queue
  * @sdkp: SCSI disk pointer.
+ * @lim: queue limits to read into
  * @buf: 512 byte buffer used for storing SCSI command output.
  *
  * Read zone information and update the request queue zone characteristics and
  * also the zoned device information in *sdkp. Called by sd_revalidate_disk()
  * before the gendisk capacity has been set.
  */
-int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
+int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
+		u8 buf[SD_BUF_SIZE])
 {
 	struct gendisk *disk = sdkp->disk;
 	struct request_queue *q = disk->queue;
@@ -626,14 +628,13 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	/* The drive satisfies the kernel restrictions: set it up */
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	if (sdkp->zones_max_open == U32_MAX)
-		disk_set_max_open_zones(disk, 0);
+		lim->max_open_zones = 0;
 	else
-		disk_set_max_open_zones(disk, sdkp->zones_max_open);
-	disk_set_max_active_zones(disk, 0);
-	blk_queue_chunk_sectors(q,
-			logical_to_sectors(sdkp->device, zone_blocks));
+		lim->max_open_zones = sdkp->zones_max_open;
+	lim->max_active_zones = 0;
+	lim->chunk_sectors = logical_to_sectors(sdkp->device, zone_blocks);
 	/* Enable block layer zone append emulation */
-	blk_queue_max_zone_append_sectors(q, 0);
+	lim->max_zone_append_sectors = 0;
 
 	return 0;
 
-- 
2.43.0


