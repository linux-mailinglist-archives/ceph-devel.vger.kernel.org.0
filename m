Return-Path: <ceph-devel+bounces-859-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6DB855B2A
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9224B1C2B1F1
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF8917555;
	Thu, 15 Feb 2024 07:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i3XHwKJc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656001643A;
	Thu, 15 Feb 2024 07:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980624; cv=none; b=QEgcF3LXASev4fk7n+tL5rbK2GMDE3Rd06UkRnzeS8EGU5/EJwFugqwLq9HPuvpxwRSdy3IovNmbHuyxZEgEVHibdbO/t56mgLuiIlXnIYDbR1/IC2ZXIl8hVI6PK0LcY3l80Rxla7x17AaljPe6tuTFBTOtu9OVJ4pj0k0WVJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980624; c=relaxed/simple;
	bh=mmqwtNtWvh7UHHpSRBkWlSe+Ca587snsbIiK2FcDGZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MDkgHFWXAxANTst4MkJsRe9oyn0QjB3duxTmQCSAuNh5SQbhhYuzl6+SwkrTbqZHzFYJpANIa+C6QRZr/CJIx+bqLvBj9i6m6p+iyfTfOjxWIRs9chvJgFRdHOmBC3rFLZokDD3g3LCoLgS6VwohEiZwQdSvmeZ9zuPYBsz1YzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i3XHwKJc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7iRPP0Y2sQPPXepK66WXjtmMtqZPIO8zH2dnYYQNfr0=; b=i3XHwKJcfIcKJoCvBoRZOESgzz
	Xm/uYgt9/6UmS8XkN7/iD0tSMZYJiLloFlL+IUOG02AQcQBjVPo6uancUZFrwPZxyPoyKhyhRYHX4
	dyO2MBJHiBwkrJN76c/aesm9VXKEV/3OzbFlnLigrYoC4XPgJ3Sdd3JAA/agPG+9aLhkv2tqRa2+F
	4XEMXcrvLEyaeOqPmaFV05tpeqE5N0THHlx0N77s5+R36hwEdcYLKcrBaPdx8aWxjV83dU5q3V4XU
	VdiyLklI4XlLYcv0/QtTuG0a6sgApGShZXYdP23Ss8BL70M1g8h5wGt7OuUIv5+3qX7H+d7R5RhFd
	4/7A/KPQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmP-0000000FAb7-3OYC;
	Thu, 15 Feb 2024 07:03:34 +0000
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
Subject: [PATCH 10/17] gdrom: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:53 +0100
Message-Id: <20240215070300.2200308-11-hch@lst.de>
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

Pass the few limits gdrom imposes directly to blk_mq_alloc_disk instead
of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/cdrom/gdrom.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 1d044779f5e42a..9398beeb5d1e89 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -724,11 +724,6 @@ static void probe_gdrom_setupdisk(void)
 
 static int probe_gdrom_setupqueue(void)
 {
-	blk_queue_logical_block_size(gd.gdrom_rq, GDROM_HARD_SECTOR);
-	/* using DMA so memory will need to be contiguous */
-	blk_queue_max_segments(gd.gdrom_rq, 1);
-	/* set a large max size to get most from DMA */
-	blk_queue_max_segment_size(gd.gdrom_rq, 0x40000);
 	gd.disk->queue = gd.gdrom_rq;
 	return gdrom_init_dma_mode();
 }
@@ -743,6 +738,13 @@ static const struct blk_mq_ops gdrom_mq_ops = {
  */
 static int probe_gdrom(struct platform_device *devptr)
 {
+	struct queue_limits lim = {
+		.logical_block_size		= GDROM_HARD_SECTOR,
+		/* using DMA so memory will need to be contiguous */
+		.max_segments			= 1,
+		/* set a large max size to get most from DMA */
+		.max_segment_size		= 0x40000,
+	};
 	int err;
 
 	/*
@@ -778,7 +780,7 @@ static int probe_gdrom(struct platform_device *devptr)
 	if (err)
 		goto probe_fail_free_cd_info;
 
-	gd.disk = blk_mq_alloc_disk(&gd.tag_set, NULL, NULL);
+	gd.disk = blk_mq_alloc_disk(&gd.tag_set, &lim, NULL);
 	if (IS_ERR(gd.disk)) {
 		err = PTR_ERR(gd.disk);
 		goto probe_fail_free_tag_set;
-- 
2.39.2


