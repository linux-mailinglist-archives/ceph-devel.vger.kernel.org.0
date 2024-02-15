Return-Path: <ceph-devel+bounces-858-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 708E3855B26
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ABC02824B0
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553FA16429;
	Thu, 15 Feb 2024 07:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l9p86yy3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31C910A2C;
	Thu, 15 Feb 2024 07:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980623; cv=none; b=oUiigc3vURHAK4Wy+dXNfDhfCN2KoyMzWQcCa34V1Om2QEF3ND8qC8wX8nIlNFOfTXFTYkRXzRzeEaBJamUNy0ZQDK5/JJrR4EJyuAsOsecB4SdJ+c9LCeYaFu81kYd0nlLT9kIjm4K0bcjbGVlfDbwe5VdSXH93GIdxSnWR21E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980623; c=relaxed/simple;
	bh=f5itqxhe1A7n0EcDRwGIFCMxSOGyacHdrqFBZR1qgh8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a5Wx/Zm5UOn00UE+WXNbJnRwPyev8PjFJ+LcZGuJyG5Z/ZU/1WLyGMtyUgTP+25/t/CZuRmWzwo0OR4OKpIvYxMyN+qr2c0ZQ3SKS8hb79oTsHK9AKGt6hXTSPZ3JBC4kTYJ2FQ4D5acEXqZZcSqfSg+O1X1GD0ZrQvK491LYug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l9p86yy3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Od2gUUs5DLG3Gw+tTDh1Q5WwgEseXZXNxX3GosZewcY=; b=l9p86yy3wVCNRe2LlsM+yFEfE/
	xLNLqunPqG/jtWWbCC31cdh1G5Hvkcmvb+VpFIrc6FhQsmGgsdU+nCPUar6582teIfZEXj9DnCib1
	3xeyZy0r3BbFIr+qM7NueuszQj+sJ5LEAtAAu+1M/2G/s9KqMOROR0Sp+FELuUV+sL2uHLGW+S8Uu
	QQSYgljbmyBT2gNIqZMJoEatZUpBsUp1I0cr3GCOw96g6CVjks3bX/x92WLGycaL1x7rtoZzRZQw8
	+cbBENE2nsv+Z6tqI8d1ZKaPELihRqUGK1qsw07TRzqgH1NWP1z31U9atE2/EtRVlxBOoPmlDGCj3
	szSf5Skw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmN-0000000FAY2-0VaO;
	Thu, 15 Feb 2024 07:03:31 +0000
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
Subject: [PATCH 09/17] sunvdc: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:52 +0100
Message-Id: <20240215070300.2200308-10-hch@lst.de>
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

Pass the few limits sunvdc imposes directly to blk_mq_alloc_disk instead
of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/sunvdc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index a1f74dd1eae5d5..c99dd6698977ea 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -784,6 +784,14 @@ static const struct blk_mq_ops vdc_mq_ops = {
 
 static int probe_disk(struct vdc_port *port)
 {
+	struct queue_limits lim = {
+		.physical_block_size		= port->vdisk_phys_blksz,
+		.max_hw_sectors			= port->max_xfer_size,
+		/* Each segment in a request is up to an aligned page in size. */
+		.seg_boundary_mask		= PAGE_SIZE - 1,
+		.max_segment_size		= PAGE_SIZE,
+		.max_segments			= port->ring_cookies,
+	};
 	struct request_queue *q;
 	struct gendisk *g;
 	int err;
@@ -824,7 +832,7 @@ static int probe_disk(struct vdc_port *port)
 	if (err)
 		return err;
 
-	g = blk_mq_alloc_disk(&port->tag_set, NULL, port);
+	g = blk_mq_alloc_disk(&port->tag_set, &lim, port);
 	if (IS_ERR(g)) {
 		printk(KERN_ERR PFX "%s: Could not allocate gendisk.\n",
 		       port->vio.name);
@@ -835,12 +843,6 @@ static int probe_disk(struct vdc_port *port)
 	port->disk = g;
 	q = g->queue;
 
-	/* Each segment in a request is up to an aligned page in size. */
-	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
-	blk_queue_max_segment_size(q, PAGE_SIZE);
-
-	blk_queue_max_segments(q, port->ring_cookies);
-	blk_queue_max_hw_sectors(q, port->max_xfer_size);
 	g->major = vdc_major;
 	g->first_minor = port->vio.vdev->dev_no << PARTITION_SHIFT;
 	g->minors = 1 << PARTITION_SHIFT;
@@ -872,8 +874,6 @@ static int probe_disk(struct vdc_port *port)
 		}
 	}
 
-	blk_queue_physical_block_size(q, port->vdisk_phys_blksz);
-
 	pr_info(PFX "%s: %u sectors (%u MB) protocol %d.%d\n",
 	       g->disk_name,
 	       port->vdisk_size, (port->vdisk_size >> (20 - 9)),
-- 
2.39.2


