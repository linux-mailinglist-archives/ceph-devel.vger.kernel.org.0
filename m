Return-Path: <ceph-devel+bounces-857-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1415855B22
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CBDF1F23314
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA0E33C5;
	Thu, 15 Feb 2024 07:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Eg7EtnBS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559A814014;
	Thu, 15 Feb 2024 07:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980619; cv=none; b=Z+kEh869oA3cE7JNi+ZP0QnWS7NYrlH7Fv1oGmdU+WqxcXBQHFy8ulGBBSEqwgulBzMeJUQ8Q2O9F7hutlFDmu1JyoIrgfsbQDWG/Bxr3doLf0l0YVpDJPM5mDWDTIjfmVI50wY9wNbgT/8Fa8rWPRYZ3XLIzYnnS0ladvEfdKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980619; c=relaxed/simple;
	bh=MKxdDBxYXgN4p1VXCQxlJVfxbgRYjw0RyBk/5ozJnA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g2CtyYu34hLTBA9sLMZWCFnBQfZtbWLsMHc741+7Bzl9FueNUkPsFjNeLGRCeRkHAMzNlagDO+PAgL8UL64Zas+/pFkmxFJaYbwaEIjx796ftjIg1sGt3mgZrpaeXBBoJP5DdA/AzPZJTIvOBj1bsr6he4OpYyKgKTKWxj7V69Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Eg7EtnBS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yJHDSn6WPvm2hiPcnkw4M8SzhD1N4VSQZfg0CpuJ6q8=; b=Eg7EtnBSYRZyyqfX2b3btVHrNp
	Yhjo3OArJmpd6JThmMl/nN1Nl4qCSEdnqyUmYfRcNrt80HwB/MmMaZI5YxLf0AfkSa8+Rg+C3KMPd
	oGRl/veA4sqC0fKq+KADMTcCn7Joc1kjoKmsvncZN53lvUUXS891sY1j3S7Xo2CCyqnc8rMekpKbS
	IbOkJ0NMfPGUQrsI70jrZczz9BKgFFF1VXk6MYrS4q4jUVI8YLfBHUvt2AKNnZGkiJtzCVZerLTQv
	MoIA4hwgQn5jWGVsNXIQlJ9ba/+ZaSVKyE3/zQc59h+1LbWkIFNe/XOaVdkovfQss/tuAguj75OAq
	hyOtAHaw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmK-0000000FAUd-0tPX;
	Thu, 15 Feb 2024 07:03:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Justin Sanders <justin@coraid.com>,
	Denis Efremov <efremov@linux.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Geoff Levand <geoff@infradead.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Ming Lei <ming.lei@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [PATCH 08/17] rnbd-clt: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:51 +0100
Message-Id: <20240215070300.2200308-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215070300.2200308-1-hch@lst.de>
References: <20240215070300.2200308-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Pass the limits rnbd-clt imposes directly to blk_mq_alloc_disk instead
of setting them one at a time.

While at it don't set an explicit number of discard segments, as 1 is
the default (which most drivers rely on).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rnbd/rnbd-clt.c | 64 ++++++++++++++---------------------
 1 file changed, 25 insertions(+), 39 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index d51be4f2df61a3..b7ffe03c61606d 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1329,43 +1329,6 @@ static void rnbd_init_mq_hw_queues(struct rnbd_clt_dev *dev)
 	}
 }
 
-static void setup_request_queue(struct rnbd_clt_dev *dev,
-				struct rnbd_msg_open_rsp *rsp)
-{
-	blk_queue_logical_block_size(dev->queue,
-				     le16_to_cpu(rsp->logical_block_size));
-	blk_queue_physical_block_size(dev->queue,
-				      le16_to_cpu(rsp->physical_block_size));
-	blk_queue_max_hw_sectors(dev->queue,
-				 dev->sess->max_io_size / SECTOR_SIZE);
-
-	/*
-	 * we don't support discards to "discontiguous" segments
-	 * in on request
-	 */
-	blk_queue_max_discard_segments(dev->queue, 1);
-
-	blk_queue_max_discard_sectors(dev->queue,
-				      le32_to_cpu(rsp->max_discard_sectors));
-	dev->queue->limits.discard_granularity =
-					le32_to_cpu(rsp->discard_granularity);
-	dev->queue->limits.discard_alignment =
-					le32_to_cpu(rsp->discard_alignment);
-	if (le16_to_cpu(rsp->secure_discard))
-		blk_queue_max_secure_erase_sectors(dev->queue,
-					le32_to_cpu(rsp->max_discard_sectors));
-	blk_queue_flag_set(QUEUE_FLAG_SAME_COMP, dev->queue);
-	blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, dev->queue);
-	blk_queue_max_segments(dev->queue, dev->sess->max_segments);
-	blk_queue_io_opt(dev->queue, dev->sess->max_io_size);
-	blk_queue_virt_boundary(dev->queue, SZ_4K - 1);
-	blk_queue_write_cache(dev->queue,
-			      !!(rsp->cache_policy & RNBD_WRITEBACK),
-			      !!(rsp->cache_policy & RNBD_FUA));
-	blk_queue_max_write_zeroes_sectors(dev->queue,
-					   le32_to_cpu(rsp->max_write_zeroes_sectors));
-}
-
 static int rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev,
 				   struct rnbd_msg_open_rsp *rsp, int idx)
 {
@@ -1403,18 +1366,41 @@ static int rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev,
 static int rnbd_client_setup_device(struct rnbd_clt_dev *dev,
 				    struct rnbd_msg_open_rsp *rsp)
 {
+	struct queue_limits lim = {
+		.logical_block_size	= le16_to_cpu(rsp->logical_block_size),
+		.physical_block_size	= le16_to_cpu(rsp->physical_block_size),
+		.io_opt			= dev->sess->max_io_size,
+		.max_hw_sectors		= dev->sess->max_io_size / SECTOR_SIZE,
+		.max_hw_discard_sectors	= le32_to_cpu(rsp->max_discard_sectors),
+		.discard_granularity	= le32_to_cpu(rsp->discard_granularity),
+		.discard_alignment	= le32_to_cpu(rsp->discard_alignment),
+		.max_segments		= dev->sess->max_segments,
+		.virt_boundary_mask	= SZ_4K - 1,
+		.max_write_zeroes_sectors =
+			le32_to_cpu(rsp->max_write_zeroes_sectors),
+	};
 	int idx = dev->clt_device_id;
 
 	dev->size = le64_to_cpu(rsp->nsectors) *
 			le16_to_cpu(rsp->logical_block_size);
 
-	dev->gd = blk_mq_alloc_disk(&dev->sess->tag_set, NULL, dev);
+	if (rsp->secure_discard) {
+		lim.max_secure_erase_sectors =
+			le32_to_cpu(rsp->max_discard_sectors);
+	}
+
+	dev->gd = blk_mq_alloc_disk(&dev->sess->tag_set, &lim, dev);
 	if (IS_ERR(dev->gd))
 		return PTR_ERR(dev->gd);
 	dev->queue = dev->gd->queue;
 	rnbd_init_mq_hw_queues(dev);
 
-	setup_request_queue(dev, rsp);
+	blk_queue_flag_set(QUEUE_FLAG_SAME_COMP, dev->queue);
+	blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, dev->queue);
+	blk_queue_write_cache(dev->queue,
+			      !!(rsp->cache_policy & RNBD_WRITEBACK),
+			      !!(rsp->cache_policy & RNBD_FUA));
+
 	return rnbd_clt_setup_gen_disk(dev, rsp, idx);
 }
 
-- 
2.39.2


