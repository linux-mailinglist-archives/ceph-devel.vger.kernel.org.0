Return-Path: <ceph-devel+bounces-856-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FDDE855B1D
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E851E1F239E9
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF9313FF6;
	Thu, 15 Feb 2024 07:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SarH/SjF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4002DDC4;
	Thu, 15 Feb 2024 07:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980616; cv=none; b=k0SsydD0VLoJVA/I1VTA5YYQBrofNrKTUevO2uhDnCV0rYdLi9/K+WKBf62aXFCVsxSkc+CboXkBGzU4Xwh4EWW88MbY30CIP/Y/PZygO3Uaah+3SyTF443+9/k1FTHSikCrut+MQHga4x82OLT5YTDYiznVE1QL/IIknwHNDT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980616; c=relaxed/simple;
	bh=YpW7hWVpU+RkqycrVk7teFt6lxyiEXMUCs+FivgnvE4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g4w6YI6JlKCTZ06gwLxArrPgX32QKodfL8FtW9xkFfYpDgt3b0ofZi2XxkbHw+15QGvfBVav5ESdKkP6z/MTLXLHXsVzZeZK1AVAiVK/20y0MAgOVmxT64EfMEIyZxjNaiA65r7PHqUNmcFi6F/Lubnc+5phq4HoUFRqU6gFyN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SarH/SjF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1EnsEkvgD7HWr4nnx5YI4UIfs7PyaV58+s3ACjOhYUE=; b=SarH/SjFUdZkl+NMfFuvtM1/gX
	UxgaqqLDdaaKi6J3yAlssNsysQKCpaJLio6y5rmIQxCXUx4HmkJy/pgAgiJ0OECtELFptgJeLey2U
	HyfvPe2gmkG7LEOCw7PPCSEqv6Ugx2UK73l5AMnVl9gM2Q60K+fH/HW+E6UpImu4blbbisRj2zyEr
	iuV5RX0i28u6W4PZgvyPRLvFecWi0be54BmhcoLKNwWhy0kRooaTKZ+iFyKtfFOxDDpKsd119nXcO
	lz+12lcj2asO0Fnnn6nOeqodVydcC1VJMvzZJLSVSr4CWbDzsly6dRle6shwY+OiEdyHH/5xfiWCc
	1oef4Jww==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmH-0000000FATJ-1il1;
	Thu, 15 Feb 2024 07:03:25 +0000
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
Subject: [PATCH 07/17] rbd: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:50 +0100
Message-Id: <20240215070300.2200308-8-hch@lst.de>
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

Pass the limits rbd imposes directly to blk_mq_alloc_disk instead
of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rbd.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6b4f1898a722a3..26ff5cd2bf0abc 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4952,6 +4952,14 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	struct request_queue *q;
 	unsigned int objset_bytes =
 	    rbd_dev->layout.object_size * rbd_dev->layout.stripe_count;
+	struct queue_limits lim = {
+		.max_hw_sectors		= objset_bytes >> SECTOR_SHIFT,
+		.max_user_sectors	= objset_bytes >> SECTOR_SHIFT,
+		.io_min			= rbd_dev->opts->alloc_size,
+		.io_opt			= rbd_dev->opts->alloc_size,
+		.max_segments		= USHRT_MAX,
+		.max_segment_size	= UINT_MAX,
+	};
 	int err;
 
 	memset(&rbd_dev->tag_set, 0, sizeof(rbd_dev->tag_set));
@@ -4966,7 +4974,13 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	if (err)
 		return err;
 
-	disk = blk_mq_alloc_disk(&rbd_dev->tag_set, NULL, rbd_dev);
+	if (rbd_dev->opts->trim) {
+		lim.discard_granularity = rbd_dev->opts->alloc_size;
+		lim.max_hw_discard_sectors = objset_bytes >> SECTOR_SHIFT;
+		lim.max_write_zeroes_sectors = objset_bytes >> SECTOR_SHIFT;
+	}
+
+	disk = blk_mq_alloc_disk(&rbd_dev->tag_set, &lim, rbd_dev);
 	if (IS_ERR(disk)) {
 		err = PTR_ERR(disk);
 		goto out_tag_set;
@@ -4987,19 +5001,6 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 	/* QUEUE_FLAG_ADD_RANDOM is off by default for blk-mq */
 
-	blk_queue_max_hw_sectors(q, objset_bytes >> SECTOR_SHIFT);
-	q->limits.max_sectors = queue_max_hw_sectors(q);
-	blk_queue_max_segments(q, USHRT_MAX);
-	blk_queue_max_segment_size(q, UINT_MAX);
-	blk_queue_io_min(q, rbd_dev->opts->alloc_size);
-	blk_queue_io_opt(q, rbd_dev->opts->alloc_size);
-
-	if (rbd_dev->opts->trim) {
-		q->limits.discard_granularity = rbd_dev->opts->alloc_size;
-		blk_queue_max_discard_sectors(q, objset_bytes >> SECTOR_SHIFT);
-		blk_queue_max_write_zeroes_sectors(q, objset_bytes >> SECTOR_SHIFT);
-	}
-
 	if (!ceph_test_opt(rbd_dev->rbd_client->client, NOCRC))
 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, q);
 
-- 
2.39.2


