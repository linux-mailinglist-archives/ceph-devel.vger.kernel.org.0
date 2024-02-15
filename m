Return-Path: <ceph-devel+bounces-851-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91ECF855B09
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FAE61F23B55
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756C311702;
	Thu, 15 Feb 2024 07:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HA7jzaYa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8CFD51D;
	Thu, 15 Feb 2024 07:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980602; cv=none; b=RnAOkonUOh6/GuS6oer4DL7y9JHgr2f10xt/X//j1fn8L7zxt3+LQfDUutBiWn7YGuh3B9WMrA0wKkj7Vvw5860pzhV/od7aQa1CnKzZJk8fb0nHxRaqBJe3UMQExOwQ294+I8QLR+x1LINeM8t02/RGKQzi/0c/oKuPB8DY+YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980602; c=relaxed/simple;
	bh=a9QVJFBPnRDzEIDwo35ISQTCrjJdpKkLwXzS5MaqizE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QSzu+Mjb1aMtES28ggc/sWqglzdnK6jH7vGwkSl7vuHE32It1JhWWD8yvvRRAv3SWL/IlwF1E7BP4Rs1ehoZZUag2yh5t/oGoV9WgErKhWubayhXOv2o4wbzlkUjkR+7uxTTcjiZsEu3G7f+zGgIQHyW7Pddl2WztL7j9rrllFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HA7jzaYa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZigXghdw7FPPNjYPfgXfrl3xig0YzK0yTKopqAeqWSw=; b=HA7jzaYaYdXjkmYnaBpxilg6Ki
	11yS23O2NB33310yE7yq2DHhRzyVjlMvJzFaQfcKWMY8mYkc8fWZkQ9/He7H5SxX7lSUMxsDuYwLa
	Qa8VCCsWOZ4/f5VC8FR778/M60GJQe1w4dh2wulK2VYPkAwxr5ACuIUBiFh0i+TSzfK3AIW2x10g9
	hjQrIYwxwPO7GnCt5A9PLNbuS6KJ2zqhNtJehnxzKkW9qMxUapBapJD7BVxhHtfw/NUduY/mUAg3g
	ifUGS26f+7+G1THUMvGQrXDnxhCn1Ik48tvcQ8FPqJv3UV210Hwl8178ABpMxSPO8mPW2oT+tFON2
	loq7cLQg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVm2-0000000FANr-02ZR;
	Thu, 15 Feb 2024 07:03:10 +0000
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
Subject: [PATCH 01/17] ubd: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:44 +0100
Message-Id: <20240215070300.2200308-2-hch@lst.de>
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

Pass the few limits ubd imposes directly to blk_mq_alloc_disk instead
of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/um/drivers/ubd_kern.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 25f1b18ce7d4e9..48e11f073551b4 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -881,6 +881,10 @@ static const struct blk_mq_ops ubd_mq_ops = {
 static int ubd_add(int n, char **error_out)
 {
 	struct ubd *ubd_dev = &ubd_devs[n];
+	struct queue_limits lim = {
+		.max_segments		= MAX_SG,
+		.seg_boundary_mask	= PAGE_SIZE - 1,
+	};
 	struct gendisk *disk;
 	int err = 0;
 
@@ -906,7 +910,7 @@ static int ubd_add(int n, char **error_out)
 	if (err)
 		goto out;
 
-	disk = blk_mq_alloc_disk(&ubd_dev->tag_set, NULL, ubd_dev);
+	disk = blk_mq_alloc_disk(&ubd_dev->tag_set, &lim, ubd_dev);
 	if (IS_ERR(disk)) {
 		err = PTR_ERR(disk);
 		goto out_cleanup_tags;
@@ -914,8 +918,6 @@ static int ubd_add(int n, char **error_out)
 	ubd_dev->queue = disk->queue;
 
 	blk_queue_write_cache(ubd_dev->queue, true, false);
-	blk_queue_max_segments(ubd_dev->queue, MAX_SG);
-	blk_queue_segment_boundary(ubd_dev->queue, PAGE_SIZE - 1);
 	err = ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, disk);
 	if (err)
 		goto out_cleanup_disk;
-- 
2.39.2


