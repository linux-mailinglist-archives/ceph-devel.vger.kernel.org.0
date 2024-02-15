Return-Path: <ceph-devel+bounces-854-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44759855B15
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F391B294DEA
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A189CD52A;
	Thu, 15 Feb 2024 07:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vEZCMLqr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07EA13ADD;
	Thu, 15 Feb 2024 07:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980610; cv=none; b=kgQPeLd1Jep7BqQ8D0jkktBcq5fPDazjs7HOxhVSyQbcG9b/vxTmikWRO9nL/08UAO6Yo2QAKrt3CuzRVLuReJ0j4ZYKvh1zzS7wDFQjrn1jtGEcITPlYVdhgD6XTbPyvdFH/RrH9rQRQBEBYpN17Ggi6QKkL1vAVMD2w5miZgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980610; c=relaxed/simple;
	bh=Nzs6S9c3QPDH+r5sTZ18ZX6NI2Nq5aX1WAk/70UmZO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iGLfBjLCSiTtV7FyuV0jDHopkoctqTuuDKmy5oDsAC+H80WaMKLPvzwDknb0XX8Pee0vNlr1Ic+9ZF/ZNqoT4m/MbmatiQvdBdjt78tpF317fESLoX22sgJi2/EMYEHT9uo5HqFxzqIA59/s3IfCUs5dq/lEJddxdlxnhUM0fH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vEZCMLqr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fO86to3JpnoSw+kPoKux0mH6/s9bHY6TbVb09I4Zy+8=; b=vEZCMLqrk2MiK4sOPPGSUgw+PB
	TbZ+7r9cMOJymMW2o6DAG3hPHUQl/60B2dRNTETu+jaI1BgsT4WiSbex2/NkFoatvWym+EnOQI8f3
	plXhf9/KUxypZ1kC64pGRm2FA20QQQKcxlDCCNlKBZzObX/n3dFqrnhY7X1mSkPorueMSVVgGNqES
	jF5FfR2kBpOWflVY/gNiERWOpOiSRsg6mXiD9/Lva7M2banofRHyWEdEJkCBv1pUuehkHfcusZuMH
	se7GUKwxqI0xbRu4YG40rJJsHmXSNRNaoYHzce+1lyEPHY5ZFRluZQwrhdpt1FmuybY7eObdYXgeZ
	wbEkVFjg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmC-0000000FAQx-0hfK;
	Thu, 15 Feb 2024 07:03:20 +0000
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
Subject: [PATCH 05/17] nbd: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:48 +0100
Message-Id: <20240215070300.2200308-6-hch@lst.de>
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

Pass the few limits nbd imposes directly to blk_mq_alloc_disk instead
of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 30ae3cc12e7787..1038311462d083 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1783,6 +1783,12 @@ static const struct blk_mq_ops nbd_mq_ops = {
 
 static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 {
+	struct queue_limits lim = {
+		.max_hw_sectors		= 65536,
+		.max_user_sectors	= 256,
+		.max_segments		= USHRT_MAX,
+		.max_segment_size	= UINT_MAX,
+	};
 	struct nbd_device *nbd;
 	struct gendisk *disk;
 	int err = -ENOMEM;
@@ -1823,7 +1829,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	if (err < 0)
 		goto out_free_tags;
 
-	disk = blk_mq_alloc_disk(&nbd->tag_set, NULL, NULL);
+	disk = blk_mq_alloc_disk(&nbd->tag_set, &lim, NULL);
 	if (IS_ERR(disk)) {
 		err = PTR_ERR(disk);
 		goto out_free_idr;
@@ -1843,11 +1849,6 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	 * Tell the block layer that we are not a rotational device
 	 */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
-	blk_queue_max_discard_sectors(disk->queue, 0);
-	blk_queue_max_segment_size(disk->queue, UINT_MAX);
-	blk_queue_max_segments(disk->queue, USHRT_MAX);
-	blk_queue_max_hw_sectors(disk->queue, 65536);
-	disk->queue->limits.max_sectors = 256;
 
 	mutex_init(&nbd->config_lock);
 	refcount_set(&nbd->config_refs, 0);
-- 
2.39.2


