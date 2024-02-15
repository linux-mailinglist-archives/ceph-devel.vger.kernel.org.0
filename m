Return-Path: <ceph-devel+bounces-855-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A72A855B19
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBBED1F239E9
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F72813FE4;
	Thu, 15 Feb 2024 07:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jm67qksr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFB813ADD;
	Thu, 15 Feb 2024 07:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980612; cv=none; b=sJYy1YLB8x1sDvAJ/CLtBL1APNvrmmVvArorkv5qD3aY7FELh/sBjrdoq11z+BAGH5JN+g7VhAFBldHOAFyoWAS4zxb9v69Nr9RotgEyd7RKNcMu3Y+GZBxQSBjHdZdOH/hk942M1axtXE/NalAdtawjqd2YHwd7FA7EOHtval8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980612; c=relaxed/simple;
	bh=Nr3bWteZlzTW/mnHkXjsqhh2zwmzmSZu0LzU1Q8vBqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V6lho2FtmqVBBy8v8vuaEvwHRHpCZFIXdd4SMvKD6WsHhJEgKce7z/MctW6Ut1ztqVpkmhpcDrgLVR5q7DJ9b85I4dzbU2Yoo3tPqjds0bD4L8mo9cvOtoGVrO3vDOsC/yvWegWUbCquK/lv1f1G77xnWKPREqWrxqRDw3syDA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jm67qksr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DrUjq9+otlq+JZyp7sUnHxt2qvboylumMEQhRnGxK+Q=; b=Jm67qksrPHmI4UQIhva7QTKFgF
	USOIE1dq3e4LdFpUJOiZ4Ku1Ge6o6+5xX6M1zdBAoj+GGoSBgcOs7Xt6c/FFZy1Xah/rL4XPhYHCm
	l///ec2UpRCMrEbnXSowx8kaWKClCVzhorEMiUkXcB5SvrW/UvcX7T9woJs31wCcq8UBCNYq1Nb+v
	hW+pqUWSC5q/zvqjj2H3LIjJQLsacEheUj/RB5pdOyj2Y8boA7RNnAUbv/5Qu2GS6qUcWdcaJhimF
	Nyn5SKFeSmDP1iL3nKtUXaia+A3K9TOAKkN46U7FPzOqm3/Kvr2cg7sFtz3e454kxSqxIvu5aQuD8
	W13FMWuQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmE-0000000FASA-3Iy0;
	Thu, 15 Feb 2024 07:03:23 +0000
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
Subject: [PATCH 06/17] ps3disk: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:49 +0100
Message-Id: <20240215070300.2200308-7-hch@lst.de>
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

Pass the few limits ps3disk imposes directly to blk_mq_alloc_disk instead
of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/ps3disk.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index dfd3860df4f880..b810ac0a5c4b97 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -382,6 +382,14 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	struct ps3disk_private *priv;
 	int error;
 	unsigned int devidx;
+	struct queue_limits lim = {
+		.logical_block_size	= dev->blk_size,
+		.max_hw_sectors		= dev->bounce_size >> 9,
+		.max_segments		= -1,
+		.max_segment_size	= dev->bounce_size,
+		.dma_alignment		= dev->blk_size - 1,
+	};
+
 	struct request_queue *queue;
 	struct gendisk *gendisk;
 
@@ -431,7 +439,7 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	if (error)
 		goto fail_teardown;
 
-	gendisk = blk_mq_alloc_disk(&priv->tag_set, NULL, dev);
+	gendisk = blk_mq_alloc_disk(&priv->tag_set, &lim, dev);
 	if (IS_ERR(gendisk)) {
 		dev_err(&dev->sbd.core, "%s:%u: blk_mq_alloc_disk failed\n",
 			__func__, __LINE__);
@@ -441,15 +449,8 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 
 	queue = gendisk->queue;
 
-	blk_queue_max_hw_sectors(queue, dev->bounce_size >> 9);
-	blk_queue_dma_alignment(queue, dev->blk_size-1);
-	blk_queue_logical_block_size(queue, dev->blk_size);
-
 	blk_queue_write_cache(queue, true, false);
 
-	blk_queue_max_segments(queue, -1);
-	blk_queue_max_segment_size(queue, dev->bounce_size);
-
 	priv->gendisk = gendisk;
 	gendisk->major = ps3disk_major;
 	gendisk->first_minor = devidx * PS3DISK_MINORS;
-- 
2.39.2


