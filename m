Return-Path: <ceph-devel+bounces-861-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F8A855B34
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:05:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4DB82877F5
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BED0175B4;
	Thu, 15 Feb 2024 07:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NUB+VGQj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B9712B9C;
	Thu, 15 Feb 2024 07:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980632; cv=none; b=iOjhNtyklipnTq2s+BegiZBTA+L0aSKP6deRT9sHQTtMhUP85zf08syelnoenbryK9QuLkBOQckoIrBHzG3kOA/jZlQ9E9vCvMy2iDtclqjjqSaYLW6KM7kfTs0c+blzURhDbyNldF/V1Q2RtEYWvylMHH8kzSjgb4uu4GDybRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980632; c=relaxed/simple;
	bh=8o0dL8F5xd20bIi+vZIqwbfU0/XKXtOE38Hv+gLDsYY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uhQ0UsEVSG+qOrDkkZ1wALpn1icNsXKSM51i//cul9jCDdZwKTDx81ZOMKdvc1f+kKpI+7S2466VL/WA0qi8bQ7Al3ZZUdWRtrdx/hT2jidXDBlCgQl4jqv0sDxjIoudT9FDhxunJ8P+yh7U1Y8q/mY62DPhhFdgPy51TWFfDYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NUB+VGQj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=A4Pldf4zCAjd/e064ywZumh2zeW/Xf3dYRaxsI8nRSk=; b=NUB+VGQjHfTC0Z6RtBD6J/Jo4J
	WkRPC6Y7A8JlADZy2AlpoFuMX+K5K8aPCz1Ca7otIp2kvoOzBB5uCzCHwZrg99Ry/qa0rR8rNT3P8
	kqbiEanEhb759WeNljXX5VTjIZRDhImcQHIvx6MY+30OIzK6fhjysuhg0wQg5BEoAfEpDzLvN/j32
	gdQztuNkNHEdHTM54UkJNIwqmIiah1z8P8rSz9Jwjvr1QjJ9xOJCSvnrQX0jTK9tIaGFzkIoF4Yof
	qzpAZy4RL0GGMPNiTqX1Ns0KMLw4pvvv8jxtTsLeGWhAKZGDVe7q0xMxFnOLfJf/Mi8mxC4A87ZuK
	m1hcCuGA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmV-0000000FAgD-1jEO;
	Thu, 15 Feb 2024 07:03:40 +0000
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
Subject: [PATCH 12/17] mspro_block: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:55 +0100
Message-Id: <20240215070300.2200308-13-hch@lst.de>
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

Pass the few limits mspro_block imposes directly to blk_mq_alloc_disk
instead of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/memstick/core/mspro_block.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index db0e2a42ca3c32..49accfdc89d616 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1103,6 +1103,12 @@ static const struct blk_mq_ops mspro_mq_ops = {
 static int mspro_block_init_disk(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct queue_limits lim = {
+		.logical_block_size	= msb->page_size,
+		.max_hw_sectors		= MSPRO_BLOCK_MAX_PAGES,
+		.max_segments		= MSPRO_BLOCK_MAX_SEGS,
+		.max_segment_size	= MSPRO_BLOCK_MAX_PAGES * msb->page_size,
+	};
 	struct mspro_devinfo *dev_info = NULL;
 	struct mspro_sys_info *sys_info = NULL;
 	struct mspro_sys_attr *s_attr = NULL;
@@ -1138,18 +1144,13 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	if (rc)
 		goto out_release_id;
 
-	msb->disk = blk_mq_alloc_disk(&msb->tag_set, NULL, card);
+	msb->disk = blk_mq_alloc_disk(&msb->tag_set, &lim, card);
 	if (IS_ERR(msb->disk)) {
 		rc = PTR_ERR(msb->disk);
 		goto out_free_tag_set;
 	}
 	msb->queue = msb->disk->queue;
 
-	blk_queue_max_hw_sectors(msb->queue, MSPRO_BLOCK_MAX_PAGES);
-	blk_queue_max_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
-	blk_queue_max_segment_size(msb->queue,
-				   MSPRO_BLOCK_MAX_PAGES * msb->page_size);
-
 	msb->disk->major = major;
 	msb->disk->first_minor = disk_id << MSPRO_BLOCK_PART_SHIFT;
 	msb->disk->minors = 1 << MSPRO_BLOCK_PART_SHIFT;
@@ -1158,8 +1159,6 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 
 	sprintf(msb->disk->disk_name, "mspblk%d", disk_id);
 
-	blk_queue_logical_block_size(msb->queue, msb->page_size);
-
 	capacity = be16_to_cpu(sys_info->user_block_count);
 	capacity *= be16_to_cpu(sys_info->block_size);
 	capacity *= msb->page_size >> 9;
-- 
2.39.2


