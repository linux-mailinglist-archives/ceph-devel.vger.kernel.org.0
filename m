Return-Path: <ceph-devel+bounces-865-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60939855B44
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 176E128E2C7
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344C1D2E0;
	Thu, 15 Feb 2024 07:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AEj2STcz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5DB1804E;
	Thu, 15 Feb 2024 07:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980646; cv=none; b=T6iGLtyarIZIkPcsdifmfIOuBgDg16nYE87z3kBipRyICsYBa6H6jUWcWIAZZPGu6qdodgiGtSTgIDAfrqsxbZXB3zam+vE/RhSnzKi/lEzBs++xd96MdqlJ3HiKv3fzj1lBg8Wex9lPBC0HbhGV/bPRN3zmGLZAXLkdUXoP7+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980646; c=relaxed/simple;
	bh=Gaa0Kv9ByQjvA6J3Azvcq5kJOAqYmftIGpnzCEOL8H8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=psHY/3lTx0ghp5RuBXkhbc5wopsiv8wmWCGL/rSpHdVYy1T+MS8hAXffdOmrFpj3DWUcf/TbtE/1Evx7aObeoVBJxsYVJEBoFSie0fY7MmBsIAEdIqvyBkPawFjFI8DWzU6rj+sYlM+NyrKmDXeLIRKIOeB3eHQjn/5Pthf4c8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AEj2STcz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yRqEm5511GvEz3Bj7TYsIGKi15zk3G+RuSpIkW9QeAs=; b=AEj2STczLaZWePsIX8ySR6nW0K
	bRI/1Oq8NBxeaa1xszUM+zdB7aJ9Qs7OpDW80YxteOA2f+BRqT7EM8Dv7opqrP1Bz4QoPw8wYy/Si
	N1lMmCaPCyPRuPg8IGzKBbqEUiZQMFMPL5wr+KFYkNLPW9UVPXyH0AikAASNQFXl193txqd0bUTPB
	rb6lHa2HZGdZp2LhIm4heWeOaNeMlWwI8eEAqGzXAhpxOrFTo+2mrlCk/smjJB34f8i9cOKKmzSD3
	+R8WiBOyGpC9K2N7lCoiuk48PWK0cxAcroPaipLCfRGww3xfZ810fjBeWgWFztINA3C60ABUS30k4
	ZRg8F+4w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmh-0000000FArU-2G3o;
	Thu, 15 Feb 2024 07:03:52 +0000
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
Subject: [PATCH 16/17] ublk: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:59 +0100
Message-Id: <20240215070300.2200308-17-hch@lst.de>
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

Pass the limits ublk imposes directly to blk_mq_alloc_disk instead of
setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/ublk_drv.c | 90 ++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 49 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c5b6552707984b..01afe90a47ac46 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -246,21 +246,12 @@ static int ublk_dev_param_zoned_validate(const struct ublk_device *ub)
 	return 0;
 }
 
-static int ublk_dev_param_zoned_apply(struct ublk_device *ub)
+static void ublk_dev_param_zoned_apply(struct ublk_device *ub)
 {
-	const struct ublk_param_zoned *p = &ub->params.zoned;
-
-	disk_set_zoned(ub->ub_disk);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, ub->ub_disk->queue);
 	blk_queue_required_elevator_features(ub->ub_disk->queue,
 					     ELEVATOR_F_ZBD_SEQ_WRITE);
-	disk_set_max_active_zones(ub->ub_disk, p->max_active_zones);
-	disk_set_max_open_zones(ub->ub_disk, p->max_open_zones);
-	blk_queue_max_zone_append_sectors(ub->ub_disk->queue, p->max_zone_append_sectors);
-
 	ub->ub_disk->nr_zones = ublk_get_nr_zones(ub);
-
-	return 0;
 }
 
 /* Based on virtblk_alloc_report_buffer */
@@ -432,9 +423,8 @@ static int ublk_dev_param_zoned_validate(const struct ublk_device *ub)
 	return -EOPNOTSUPP;
 }
 
-static int ublk_dev_param_zoned_apply(struct ublk_device *ub)
+static void ublk_dev_param_zoned_apply(struct ublk_device *ub)
 {
-	return -EOPNOTSUPP;
 }
 
 static int ublk_revalidate_disk_zones(struct ublk_device *ub)
@@ -498,11 +488,6 @@ static void ublk_dev_param_basic_apply(struct ublk_device *ub)
 	struct request_queue *q = ub->ub_disk->queue;
 	const struct ublk_param_basic *p = &ub->params.basic;
 
-	blk_queue_logical_block_size(q, 1 << p->logical_bs_shift);
-	blk_queue_physical_block_size(q, 1 << p->physical_bs_shift);
-	blk_queue_io_min(q, 1 << p->io_min_shift);
-	blk_queue_io_opt(q, 1 << p->io_opt_shift);
-
 	blk_queue_write_cache(q, p->attrs & UBLK_ATTR_VOLATILE_CACHE,
 			p->attrs & UBLK_ATTR_FUA);
 	if (p->attrs & UBLK_ATTR_ROTATIONAL)
@@ -510,29 +495,12 @@ static void ublk_dev_param_basic_apply(struct ublk_device *ub)
 	else
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 
-	blk_queue_max_hw_sectors(q, p->max_sectors);
-	blk_queue_chunk_sectors(q, p->chunk_sectors);
-	blk_queue_virt_boundary(q, p->virt_boundary_mask);
-
 	if (p->attrs & UBLK_ATTR_READ_ONLY)
 		set_disk_ro(ub->ub_disk, true);
 
 	set_capacity(ub->ub_disk, p->dev_sectors);
 }
 
-static void ublk_dev_param_discard_apply(struct ublk_device *ub)
-{
-	struct request_queue *q = ub->ub_disk->queue;
-	const struct ublk_param_discard *p = &ub->params.discard;
-
-	q->limits.discard_alignment = p->discard_alignment;
-	q->limits.discard_granularity = p->discard_granularity;
-	blk_queue_max_discard_sectors(q, p->max_discard_sectors);
-	blk_queue_max_write_zeroes_sectors(q,
-			p->max_write_zeroes_sectors);
-	blk_queue_max_discard_segments(q, p->max_discard_segments);
-}
-
 static int ublk_validate_params(const struct ublk_device *ub)
 {
 	/* basic param is the only one which must be set */
@@ -576,20 +544,12 @@ static int ublk_validate_params(const struct ublk_device *ub)
 	return 0;
 }
 
-static int ublk_apply_params(struct ublk_device *ub)
+static void ublk_apply_params(struct ublk_device *ub)
 {
-	if (!(ub->params.types & UBLK_PARAM_TYPE_BASIC))
-		return -EINVAL;
-
 	ublk_dev_param_basic_apply(ub);
 
-	if (ub->params.types & UBLK_PARAM_TYPE_DISCARD)
-		ublk_dev_param_discard_apply(ub);
-
 	if (ub->params.types & UBLK_PARAM_TYPE_ZONED)
-		return ublk_dev_param_zoned_apply(ub);
-
-	return 0;
+		ublk_dev_param_zoned_apply(ub);
 }
 
 static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
@@ -2205,12 +2165,47 @@ static struct ublk_device *ublk_get_device_from_id(int idx)
 static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 {
 	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
+	const struct ublk_param_basic *p = &ub->params.basic;
 	int ublksrv_pid = (int)header->data[0];
+	struct queue_limits lim = {
+		.logical_block_size	= 1 << p->logical_bs_shift,
+		.physical_block_size	= 1 << p->physical_bs_shift,
+		.io_min			= 1 << p->io_min_shift,
+		.io_opt			= 1 << p->io_opt_shift,
+		.max_hw_sectors		= p->max_sectors,
+		.chunk_sectors		= p->chunk_sectors,
+		.virt_boundary_mask	= p->virt_boundary_mask,
+
+	};
 	struct gendisk *disk;
 	int ret = -EINVAL;
 
 	if (ublksrv_pid <= 0)
 		return -EINVAL;
+	if (!(ub->params.types & UBLK_PARAM_TYPE_BASIC))
+		return -EINVAL;
+
+	if (ub->params.types & UBLK_PARAM_TYPE_DISCARD) {
+		const struct ublk_param_discard *pd = &ub->params.discard;
+
+		lim.discard_alignment = pd->discard_alignment;
+		lim.discard_granularity = pd->discard_granularity;
+		lim.max_hw_discard_sectors = pd->max_discard_sectors;
+		lim.max_write_zeroes_sectors = pd->max_write_zeroes_sectors;
+		lim.max_discard_segments = pd->max_discard_segments;
+	}
+
+	if (ub->params.types & UBLK_PARAM_TYPE_ZONED) {
+		const struct ublk_param_zoned *p = &ub->params.zoned;
+
+		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED))
+			return -EOPNOTSUPP;
+
+		lim.zoned = true;
+		lim.max_active_zones = p->max_active_zones;
+		lim.max_open_zones =  p->max_open_zones;
+		lim.max_zone_append_sectors = p->max_zone_append_sectors;
+	}
 
 	if (wait_for_completion_interruptible(&ub->completion) != 0)
 		return -EINTR;
@@ -2222,7 +2217,7 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 		goto out_unlock;
 	}
 
-	disk = blk_mq_alloc_disk(&ub->tag_set, NULL, NULL);
+	disk = blk_mq_alloc_disk(&ub->tag_set, &lim, NULL);
 	if (IS_ERR(disk)) {
 		ret = PTR_ERR(disk);
 		goto out_unlock;
@@ -2234,9 +2229,7 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 	ub->dev_info.ublksrv_pid = ublksrv_pid;
 	ub->ub_disk = disk;
 
-	ret = ublk_apply_params(ub);
-	if (ret)
-		goto out_put_disk;
+	ublk_apply_params(ub);
 
 	/* don't probe partitions if any one ubq daemon is un-trusted */
 	if (ub->nr_privileged_daemon != ub->nr_queues_ready)
@@ -2262,7 +2255,6 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 		ub->dev_info.state = UBLK_S_DEV_DEAD;
 		ublk_put_device(ub);
 	}
-out_put_disk:
 	if (ret)
 		put_disk(disk);
 out_unlock:
-- 
2.39.2


