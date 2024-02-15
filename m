Return-Path: <ceph-devel+bounces-850-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0FA855B04
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3E3B1C2B6F9
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A38DDD9;
	Thu, 15 Feb 2024 07:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="USrYMYg3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3E3C15B;
	Thu, 15 Feb 2024 07:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980601; cv=none; b=pcMi8+coJP6S2MQLfDOXfkBOlrWCNNkICobIjxnLGqUFE4iOaEbTReBboGkaE0sI2V8/HAV14ytSSY9SYlWuPuiLiRNhxKesD0cLCpRZFxb4N8gf65GQyU5fjBEulaGy5vtBt5qaN9Q6B4GGXbsXg2rxoicbWwm2KU3BNpbQTYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980601; c=relaxed/simple;
	bh=8LTkkIg47/HDrdzbdQLcU8aL/okzfwKjVikEO0IDv20=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oKwjnQTEu5ikrkXmr2fs5GSWc08WsmLtWAx/VnZA1Q6yweVKqWxphql6vOsnelnsGzjKFSd0wHoBmhyq8idzYERlsU1/znEc3Pa6sfKgZQFoWFvuIycL3EJn97y4PxUR7WKz3J8AefzTeUpiAEKUgsKAmZrOKFF+coFiQAQEg6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=USrYMYg3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w+8VBJngr1LpgzhqtRiN7EAhAvx8U1FPWiPOb3OkKso=; b=USrYMYg35Bzm5+f4s1dmAh5PSS
	QkjuHrEenWxWrcgJc+gsmXtpRg40aRLWetOipmPw48dpOffUTa5q75aq+Wk3KisE/+OFvpYc6IfaL
	nzO04wFtrZ7qxMRNLsxVNt2eQKi7q73/IIvtZl7Yu4HzDpDwoo08SSmRihcJHFMtltcufV7NpC0UR
	MPQwkFkO9fwQcHYroBMeQ9s07q1fCbJMJql/tukDY8rJeipHGTF4+YLyCvKS/H2f6hB7NWIOuaXS/
	L0OMMU3LiJLyo+31u9dQebfl/szvAl8qAp1N2C2fYiBqLm4LBVLxiA3vLmhLMEkJwUXqazwKfGy1l
	mjIlZIbw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVm4-0000000FANy-1sSl;
	Thu, 15 Feb 2024 07:03:12 +0000
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
Subject: [PATCH 02/17] aoe: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:45 +0100
Message-Id: <20240215070300.2200308-3-hch@lst.de>
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

Pass the few limits aoe imposes directly to blk_mq_alloc_disk instead
of setting them one at a time and improve the way the default
max_hw_sectors is initialized while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/aoe/aoeblk.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 2ff6e2da8cc41c..b6dac8cee70fe1 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -24,8 +24,8 @@ static DEFINE_MUTEX(aoeblk_mutex);
 static struct kmem_cache *buf_pool_cache;
 static struct dentry *aoe_debugfs_dir;
 
-/* GPFS needs a larger value than the default. */
-static int aoe_maxsectors;
+/* random default picked from the historic block max_sectors cap */
+static int aoe_maxsectors = 2560;
 module_param(aoe_maxsectors, int, 0644);
 MODULE_PARM_DESC(aoe_maxsectors,
 	"When nonzero, set the maximum number of sectors per I/O request");
@@ -334,6 +334,10 @@ aoeblk_gdalloc(void *vp)
 	mempool_t *mp;
 	struct blk_mq_tag_set *set;
 	sector_t ssize;
+	struct queue_limits lim = {
+		.max_hw_sectors		= aoe_maxsectors,
+		.io_opt			= SZ_2M,
+	};
 	ulong flags;
 	int late = 0;
 	int err;
@@ -371,7 +375,7 @@ aoeblk_gdalloc(void *vp)
 		goto err_mempool;
 	}
 
-	gd = blk_mq_alloc_disk(set, NULL, d);
+	gd = blk_mq_alloc_disk(set, &lim, d);
 	if (IS_ERR(gd)) {
 		pr_err("aoe: cannot allocate block queue for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
@@ -384,14 +388,9 @@ aoeblk_gdalloc(void *vp)
 	WARN_ON(d->flags & DEVFL_TKILL);
 	WARN_ON(d->gd);
 	WARN_ON(d->flags & DEVFL_UP);
-	/* random number picked from the history block max_sectors cap */
-	blk_queue_max_hw_sectors(gd->queue, 2560u);
-	blk_queue_io_opt(gd->queue, SZ_2M);
 	d->bufpool = mp;
 	d->blkq = gd->queue;
 	d->gd = gd;
-	if (aoe_maxsectors)
-		blk_queue_max_hw_sectors(gd->queue, aoe_maxsectors);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor;
 	gd->minors = AOE_PARTITIONS;
-- 
2.39.2


