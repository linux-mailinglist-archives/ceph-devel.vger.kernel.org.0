Return-Path: <ceph-devel+bounces-860-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A377D855B2E
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6BDF1C2B366
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F5B12B87;
	Thu, 15 Feb 2024 07:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RygLJ0VF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F2AC15B;
	Thu, 15 Feb 2024 07:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980629; cv=none; b=sK9M5fMaKVTBhoABPj7Y7aP7+JNGHmQIassmwpebPIHLN4OALiVghOtpaQMywoVWS39cElniii7N44XszcnELNtI2FtWvLka6OBQ2IQ/QIKoSJQeYzPSD95Km6JYp2FSFJ/f/FCyLwUPKq2ox6gl+VGrXXfwaqUtHUUfu2Zv7gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980629; c=relaxed/simple;
	bh=f6ioQTxd6bvy9yE5C+HwWGecoHA++xer911f/5CmXwY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iXnat+7cgQOaZNbgvVxOO4sVWVkenJD1HXTJ8rvREw1TOhsAPbpmXisPoz8AjMUDysxSWXxouoJqGHMvMaAjN/myUgDukP2rWxtGZtEonum6hfMao4GubX7FaBmQNGmcHX8nM7eCkqit1CMlqNODIjsPJqOLN0REeZDOqOeGAFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RygLJ0VF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7HW9nW/6R1po4TKLgzFygXD/FnydtoezUdFVDwul6Gg=; b=RygLJ0VFhu19BJnN/mrXhVxIZ/
	+m5eiwoXuNIsoMu1yUIpSCyzrmw9irbsK19WBIfx2LiNAd6OLOEBeE9hq95/IDZJfcBEMpMXtdDVQ
	aXLLlvAWAh3a5MvnkR/w/L4RyQDguW7wmUrbfrxvFaoRS3Ytvqqcu5NwYXIokLnUJYVERo0rjfWxQ
	bVfSlLVadoNBQg9wEaBIGgt8Odv3IB18yERFr7L3slrop+EU6HAcjjIR+XreyhBNO1vyataXnKkGe
	aeMNbhCGoqQxW4U4VVIbPXSvNwzRIXSNzrFav2B+686ZZcovDrnqQqox00jXS/5kUH0xcWW5yiWDP
	cfgOflHQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmS-0000000FAdC-1wnt;
	Thu, 15 Feb 2024 07:03:37 +0000
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
Subject: [PATCH 11/17] ms_block: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:54 +0100
Message-Id: <20240215070300.2200308-12-hch@lst.de>
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

Pass the few limits ms_block imposes directly to blk_mq_alloc_disk
instead of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/memstick/core/ms_block.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index d3277c901d16bb..47a314a4eb6faf 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2078,6 +2078,12 @@ static const struct blk_mq_ops msb_mq_ops = {
 static int msb_init_disk(struct memstick_dev *card)
 {
 	struct msb_data *msb = memstick_get_drvdata(card);
+	struct queue_limits lim = {
+		.logical_block_size	= msb->page_size,
+		.max_hw_sectors		= MS_BLOCK_MAX_PAGES,
+		.max_segments		= MS_BLOCK_MAX_SEGS,
+		.max_segment_size	= MS_BLOCK_MAX_PAGES * msb->page_size,
+	};
 	int rc;
 	unsigned long capacity;
 
@@ -2093,19 +2099,13 @@ static int msb_init_disk(struct memstick_dev *card)
 	if (rc)
 		goto out_release_id;
 
-	msb->disk = blk_mq_alloc_disk(&msb->tag_set, NULL, card);
+	msb->disk = blk_mq_alloc_disk(&msb->tag_set, &lim, card);
 	if (IS_ERR(msb->disk)) {
 		rc = PTR_ERR(msb->disk);
 		goto out_free_tag_set;
 	}
 	msb->queue = msb->disk->queue;
 
-	blk_queue_max_hw_sectors(msb->queue, MS_BLOCK_MAX_PAGES);
-	blk_queue_max_segments(msb->queue, MS_BLOCK_MAX_SEGS);
-	blk_queue_max_segment_size(msb->queue,
-				   MS_BLOCK_MAX_PAGES * msb->page_size);
-	blk_queue_logical_block_size(msb->queue, msb->page_size);
-
 	sprintf(msb->disk->disk_name, "msblk%d", msb->disk_id);
 	msb->disk->fops = &msb_bdops;
 	msb->disk->private_data = msb;
-- 
2.39.2


