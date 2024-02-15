Return-Path: <ceph-devel+bounces-853-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B48CF855B11
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6E8C1C2B281
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF728134D2;
	Thu, 15 Feb 2024 07:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lfg/cCuL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234CB134C6;
	Thu, 15 Feb 2024 07:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980605; cv=none; b=hyzOwDYq9A50qYNKSMPsP+oyu0nzVwiey5okclVItTmPkMyrevp1WJO7oCTbGpBQEZwzUXabe/86x2kf6pZnks6YC2DW/caYfRSHNcNm/Hx0CE4ypAhMysfMYTlcSv2KyenWlpt5YrdVrwmnSyvOHlf0y4zr0lO0EEH2DLpSQGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980605; c=relaxed/simple;
	bh=rG7KUECEXkvtV7J69ch8icJVrkWt6lu2mGzyDLpE/v0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X100Bu5T5XhxR/+WEvMFy8hGyHWEPQztOszzcDbPezIDbq1LSRc3PTpRbYLoLkmvtuU/VfdyTqbe9eYIqI8yIb4++lK3t9P25jTPlVgVv9u13CNQ7QQCbGFBs+OsUHWUUws6MAuXixai+Xab5DA2wrbFHVWGRRpIp1fymeqDCaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lfg/cCuL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4fJVpifb0pDninviL6ZY7y1+xuTxMtXLHlTD8or8yks=; b=lfg/cCuLFSdOOMIr+fbwY4BD+6
	jKmtaE1fu3OCvm4a8D8b6oM02Dadh4IkbB6rRMMDgh9acpo5zy+z5xrYazIASRMNLuuzPoVqfQQ6O
	rRrPB6Crmd8rr1PMZB0khOJ/44EIktlnmAx30Cu5Lr+btKoMOnbxG1iTb1CGASKUI1/dLz4sjprn9
	022wdRBZJLPAMmJsCOt/ulmM2OHkFnRLWlY+rQi88EAufs1C4MC9eG87wMegoMvmEcycslL3v8Ri6
	MqaH7Ys3aeBTSBP2K0UAH2zcX56HXhGOrgKHIYHvCklKS0U39BSOPfeyIUo0DdL0opdKDxZZih6qP
	8yNZ+BSg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVm9-0000000FAPj-290B;
	Thu, 15 Feb 2024 07:03:18 +0000
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
Subject: [PATCH 04/17] mtip: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:47 +0100
Message-Id: <20240215070300.2200308-5-hch@lst.de>
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

Pass the few limits mtip imposes directly to blk_mq_alloc_disk instead
of setting them one at a time and drop the pointless setting of a io_min
that is equal to the physical block size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/mtip32xx/mtip32xx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index ac08dea73552f4..43a187609ef794 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3401,6 +3401,12 @@ static const struct blk_mq_ops mtip_mq_ops = {
  */
 static int mtip_block_initialize(struct driver_data *dd)
 {
+	struct queue_limits lim = {
+		.physical_block_size	= 4096,
+		.max_hw_sectors		= 0xffff,
+		.max_segments		= MTIP_MAX_SG,
+		.max_segment_size	= 0x400000,
+	};
 	int rv = 0, wait_for_rebuild = 0;
 	sector_t capacity;
 	unsigned int index = 0;
@@ -3431,7 +3437,7 @@ static int mtip_block_initialize(struct driver_data *dd)
 		goto block_queue_alloc_tag_error;
 	}
 
-	dd->disk = blk_mq_alloc_disk(&dd->tags, NULL, dd);
+	dd->disk = blk_mq_alloc_disk(&dd->tags, &lim, dd);
 	if (IS_ERR(dd->disk)) {
 		dev_err(&dd->pdev->dev,
 			"Unable to allocate request queue\n");
@@ -3481,12 +3487,7 @@ static int mtip_block_initialize(struct driver_data *dd)
 	/* Set device limits. */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, dd->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, dd->queue);
-	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
-	blk_queue_physical_block_size(dd->queue, 4096);
-	blk_queue_max_hw_sectors(dd->queue, 0xffff);
-	blk_queue_max_segment_size(dd->queue, 0x400000);
 	dma_set_max_seg_size(&dd->pdev->dev, 0x400000);
-	blk_queue_io_min(dd->queue, 4096);
 
 	/* Set the capacity of the device in 512 byte sectors. */
 	if (!(mtip_hw_get_capacity(dd, &capacity))) {
-- 
2.39.2


