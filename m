Return-Path: <ceph-devel+bounces-862-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8DCF855B38
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6517F28D9B8
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52051773A;
	Thu, 15 Feb 2024 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FWUf/NVI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08DE17731;
	Thu, 15 Feb 2024 07:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980635; cv=none; b=rGGY9cQ9+e8cAqJe8A+sMsbp/CjUfHY3F6spppJOApoAB+K8jywLq8K3ufpNFIEV6ufIQHrnmy0AbGNcB4Y7Vu3H7lIigN7wxhzIMXXPKfpqNnp3iKAwSPTYjcpu2+v2SiMuwL930pvs2N3bgq2YiqEbBUrCPN5TzOeN3T3Pbzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980635; c=relaxed/simple;
	bh=hJ51WiDv88OsFBIkcgdEktmKx2FhGJMekTByp+DSBk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tjdba1Otd34za6Q720KPoFxDX/orojBByCP+dHVnr/zjfN5n0EwpNNAtk3ez/yNk/Z6PrFyB5um8RZStx9YN3yogPBuvwuzxty8QKQ8hE+Tv1T3eTZh+rzxWhzg5Dy0uE4fXwB8LO/1hQXuXq3xAMW+48485qC/Lk8zvlKDYNLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FWUf/NVI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yX6TjNZwV1r6foMr2Mx/pYjlb9HSFWyCxKJgPy+mgfc=; b=FWUf/NVIFJnkymZUE6OitjMEpo
	AvDOHoneczJ504a36JzctCYDJ6mM6seqiBlAhDExxgchaMNUS25aGtexiLTgFcTpH8lZVhlStA8fX
	zzOg/lXiSu4RxVzwSPzqOWyqyw8sZJPPXnh+Hd97psAyjK06nz2UMcNSLsLka6AzVZ1M9HwCtTH2d
	HVptIRWFaXYvoz6775vrfiv0hvfK2gwQAkDbkdEK9o6r1IBprFP64ryujWSKzVWejsKlpCw244aam
	UoBXCaWT3vNX9BWmPfA46Lm9dK4NASkbvvYhxT459Vj68MXCfCVnLKYkEMRcCn9HHLl6er//nOsoh
	BuATTlHA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmY-0000000FAis-2CQX;
	Thu, 15 Feb 2024 07:03:43 +0000
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
Subject: [PATCH 13/17] mtd_blkdevs: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:56 +0100
Message-Id: <20240215070300.2200308-14-hch@lst.de>
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

Pass the few limits mtd_blkdevs imposes directly to blk_mq_alloc_disk
instead of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mtd/mtd_blkdevs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index b8878a2457afa7..3caa0717d46c01 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -277,6 +277,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 {
 	struct mtd_blktrans_ops *tr = new->tr;
 	struct mtd_blktrans_dev *d;
+	struct queue_limits lim = { };
 	int last_devnum = -1;
 	struct gendisk *gd;
 	int ret;
@@ -331,9 +332,13 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 			BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING);
 	if (ret)
 		goto out_kfree_tag_set;
+	
+	lim.logical_block_size = tr->blksize;
+	if (tr->discard)
+		lim.max_hw_discard_sectors = UINT_MAX;
 
 	/* Create gendisk */
-	gd = blk_mq_alloc_disk(new->tag_set, NULL, new);
+	gd = blk_mq_alloc_disk(new->tag_set, &lim, new);
 	if (IS_ERR(gd)) {
 		ret = PTR_ERR(gd);
 		goto out_free_tag_set;
@@ -371,14 +376,9 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (tr->flush)
 		blk_queue_write_cache(new->rq, true, false);
 
-	blk_queue_logical_block_size(new->rq, tr->blksize);
-
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, new->rq);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, new->rq);
 
-	if (tr->discard)
-		blk_queue_max_discard_sectors(new->rq, UINT_MAX);
-
 	gd->queue = new->rq;
 
 	if (new->readonly)
-- 
2.39.2


