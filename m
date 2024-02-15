Return-Path: <ceph-devel+bounces-864-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3FA855B40
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05DFB28F4AD
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1933E134DB;
	Thu, 15 Feb 2024 07:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dLSqTAzC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5635117C8D;
	Thu, 15 Feb 2024 07:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980642; cv=none; b=bsq0Lof9ADOIrukMa8d0wiX0G8sc2v3HoxTi3oxJpJ6BU49Nsmuia04gdw+zHDDSpM1ktt952UngfPYvU9AQ/WWIfMcBWIYAY2gPNdXUvpQYwRmhCEpo2B1zPmnMScY32MsDvbf+YPE4qBgyZ7pFHVyNGfLFvm1luR1mAgn3gBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980642; c=relaxed/simple;
	bh=YWPFN9dIkNPNhkH6x4Jzjm+vv8hSFIINOyiI4y7/vvc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sIOkVsLvXP5uZtASST+wBRdtokui4fvDZVTTNXCkLKwgJ6etQKU/AklsuISbo508wxxLLBeGE1hxwQ03jB+9yKfKhO3GwRjbJieF1j54aKSl2t/nqiqIaMGUa3H5Mv947jKSnRxc88T8DpVZLk3YXDKMsN/te8jvJm8zSmHHZAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dLSqTAzC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DxnmyhvZU++vGdnpFDaWSOJPifrXzsFw9sqifAG0cKk=; b=dLSqTAzCge/kq2H3GTm9MjkFri
	jGHQbIk6cz5uv75+PS/A15N81GEKAjG5g+xrjMyawhj5oNAmf59NzkMmmCwxamu9L9nHIr2AYka3N
	TdCIQsiEVH6CiPJkKei7DjrUCNx7jG335JtrHMD0nELIowXd5ZL97DhesyZiJk5usrPAbN4R0o8J8
	pL6sCqUfDQwGYvstGV910BbdhGTgjUQZprDDPA2+w7xpHHbSKhRVaLhjtjfgd4K+DHiKoe7nwe+R4
	dXDRZ9p0GDE/h+8EuKlik0q9sJEIAsoQagv4UVDxwIvWp53xVXIcYVFgNEsYHx6gljyE0uYwZoloD
	5LElJpbQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVme-0000000FAoN-2DEF;
	Thu, 15 Feb 2024 07:03:49 +0000
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
Subject: [PATCH 15/17] scm_blk: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:58 +0100
Message-Id: <20240215070300.2200308-16-hch@lst.de>
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

Pass the few limits scm_block imposes directly to blk_mq_alloc_disk
instead of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/block/scm_blk.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index d05b2e2799a47a..9f6fdd0daa74eb 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -435,10 +435,17 @@ static const struct blk_mq_ops scm_mq_ops = {
 
 int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 {
-	unsigned int devindex, nr_max_blk;
+	struct queue_limits lim = {
+		.logical_block_size	= 1 << 12,
+	};
+	unsigned int devindex;
 	struct request_queue *rq;
 	int len, ret;
 
+	lim.max_segments = min(scmdev->nr_max_block,
+		(unsigned int) (PAGE_SIZE / sizeof(struct aidaw)));
+	lim.max_hw_sectors = lim.max_segments << 3; /* 8 * 512 = blk_size */
+
 	devindex = atomic_inc_return(&nr_devices) - 1;
 	/* scma..scmz + scmaa..scmzz */
 	if (devindex > 701) {
@@ -462,18 +469,12 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 	if (ret)
 		goto out;
 
-	bdev->gendisk = blk_mq_alloc_disk(&bdev->tag_set, NULL, scmdev);
+	bdev->gendisk = blk_mq_alloc_disk(&bdev->tag_set, &lim, scmdev);
 	if (IS_ERR(bdev->gendisk)) {
 		ret = PTR_ERR(bdev->gendisk);
 		goto out_tag;
 	}
 	rq = bdev->rq = bdev->gendisk->queue;
-	nr_max_blk = min(scmdev->nr_max_block,
-			 (unsigned int) (PAGE_SIZE / sizeof(struct aidaw)));
-
-	blk_queue_logical_block_size(rq, 1 << 12);
-	blk_queue_max_hw_sectors(rq, nr_max_blk << 3); /* 8 * 512 = blk_size */
-	blk_queue_max_segments(rq, nr_max_blk);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, rq);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, rq);
 
-- 
2.39.2


