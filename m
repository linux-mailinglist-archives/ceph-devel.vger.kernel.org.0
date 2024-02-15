Return-Path: <ceph-devel+bounces-863-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 100C6855B3B
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2B7A1F2DC33
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFBD179BD;
	Thu, 15 Feb 2024 07:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hDpnoHXj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D67179AE;
	Thu, 15 Feb 2024 07:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980638; cv=none; b=N28EvFTeDy0e0IoQakYKJR3mWYQaL8aoPQIjrQOnm+fMQlIEQmSCWn/yXfDPylvDgfpiCXWX9OZR7d9oLnfppAzW49HUAQzCnYVFsHCPAzqGnzgBuCNJcY9JSEbGzR/irL1QG5frDYh7Lh674TKI4+h3SVecoP+LaVhV+10frM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980638; c=relaxed/simple;
	bh=TayBTbCUIG1JEqcoTjePRyHLJRfNlJSYwmPUWxSesJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bMwDQLb7GIH2oe3tKfM4bpArpqp9weNOyr+I+02fZWmxavrIu+vvgXO1jpcORfA49EF/FtIEWmBnTJRdtxWOBNC+eVqUIHYKC8N/i+svUl33swla3Fld50aepy6A599pOeliK1AOW2L58cOqCxEFZ39wIxz5WCG21tsgJ8DhWIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hDpnoHXj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ql69Ny7Df6k1AIJdToQgpKmIcHybFsFhrQThMzA+DY0=; b=hDpnoHXjwcqg5h8+ZvzS20ElG5
	WVCKxfaksuW6utvZXnIBSvtfkMMIcxFdWSiLJk1iD+QZCL6Dpzz2bW0IdMlMFhLEa59IAKvFTNanH
	JJ8Am6okVbUC0r9ZXt1cCvaXC2s1msU+Ps6uP7TmfA+Kqn6ErrW8T8xCoprCmUH5aNQAroqbu88B9
	N5knglcRRVMqiYCL6edhT8sYYns+/gnPLxWnnjlq/4Vo8dUY0VuRGnJfppodpQoBGjggnbfrdPtfH
	imSs1uRyF4eFCvMo182CNCqmAIgXqNx7nsiY0HEKqi+3jfOS72sN8YT+cH2QsnnXSUNA18mUgNMhy
	d4WcUDiQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVmb-0000000FAll-1XVj;
	Thu, 15 Feb 2024 07:03:46 +0000
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
Subject: [PATCH 14/17] ubiblock: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:57 +0100
Message-Id: <20240215070300.2200308-15-hch@lst.de>
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

Pass the few limits ubiblock imposes directly to blk_mq_alloc_disk
instead of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mtd/ubi/block.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 9be87c231a2eba..5c8fdcc088a0df 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -348,6 +348,9 @@ static int calc_disk_capacity(struct ubi_volume_info *vi, u64 *disk_capacity)
 
 int ubiblock_create(struct ubi_volume_info *vi)
 {
+	struct queue_limits lim = {
+		.max_segments		= UBI_MAX_SG_COUNT,
+	};
 	struct ubiblock *dev;
 	struct gendisk *gd;
 	u64 disk_capacity;
@@ -393,7 +396,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 
 
 	/* Initialize the gendisk of this ubiblock device */
-	gd = blk_mq_alloc_disk(&dev->tag_set, NULL, dev);
+	gd = blk_mq_alloc_disk(&dev->tag_set, &lim, dev);
 	if (IS_ERR(gd)) {
 		ret = PTR_ERR(gd);
 		goto out_free_tags;
@@ -416,7 +419,6 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	dev->gd = gd;
 
 	dev->rq = gd->queue;
-	blk_queue_max_segments(dev->rq, UBI_MAX_SG_COUNT);
 
 	list_add_tail(&dev->list, &ubiblock_devices);
 
-- 
2.39.2


