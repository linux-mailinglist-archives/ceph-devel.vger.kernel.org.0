Return-Path: <ceph-devel+bounces-852-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10043855B0C
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42B5A1C2B02D
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E686812E44;
	Thu, 15 Feb 2024 07:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K1u0KaVv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D238DDC5;
	Thu, 15 Feb 2024 07:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980602; cv=none; b=Ufq18fJHUzqY7sv230V2mN8M53m0V+3EC3niIrphGllkkWRtS5oI2ts3l+lQBwBnixnAQHFvvaW0uwP0R6j2HE0kaM2Hf+41L1jtrynvxf9abD4MMqQzMp2FLXeF4DHl1RiFCVPvm7aFK9HZGMpQSV4DJQ0XjIRxzRIqNp7DT+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980602; c=relaxed/simple;
	bh=9WdLjT1F7YTIn931E35YJoTSKBmhf9CKQyAr/kPRTLk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DekkdeIpvNEO86jr4KxmTwx5OxfVUQtNvnmG4rkRz+0K5iQ4PRblqB8SVwfQt+H//W5CILmYFWA2yEmtJ6nU1sVItTG4wTkPhA5Eat3ON1Q4smNgQzk2roy9nHmQV1TWg2B8junXktqFxWeO1/Lmj0x+fCh58BTe6pWwWuCyOeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K1u0KaVv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=N3fBrH+Lto5RYgJr+nYdsqKdgsA0d55LSKFhxAxcPw8=; b=K1u0KaVvpttKAYcC13KO/OXs60
	Stmjk5ZkzV9ciVKQ1lk6fjT0ws6neY4LG830L5g3EPjpRBHKQZ4c265JrT/XyuVBIL6gzhopZwOlj
	XDNtvW/SPULw6ucKPNlD7nSY/7VRCcEAAqGbY1Y5IOUx2m/73BAd11Y5YiQJRunMigYH1JkYFhI07
	+D6Kp2iSyOKq0lr6criZMoxHUscwsiEZ1VhyRhT4stlzOFMQJfXKqykYUf/m8eenR26CgCmHoNBeq
	L70Xygr2SW6vvTIsI4bKmpJcX4ks68+02nGMJAmrTCkKcLd7w1n77YmmPqQpKpDgDW/su5VOSZh/u
	8AQC1ovQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVm7-0000000FAOz-09gd;
	Thu, 15 Feb 2024 07:03:15 +0000
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
Subject: [PATCH 03/17] floppy: pass queue_limits to blk_mq_alloc_disk
Date: Thu, 15 Feb 2024 08:02:46 +0100
Message-Id: <20240215070300.2200308-4-hch@lst.de>
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

Pass the few limits floppy imposes directly to blk_mq_alloc_disk instead
of setting them one at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/floppy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 582cf50c6bf6b8..1b399ec8c07d1e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4516,13 +4516,15 @@ static bool floppy_available(int drive)
 
 static int floppy_alloc_disk(unsigned int drive, unsigned int type)
 {
+	struct queue_limits lim = {
+		.max_hw_sectors = 64,
+	};
 	struct gendisk *disk;
 
-	disk = blk_mq_alloc_disk(&tag_sets[drive], NULL, NULL);
+	disk = blk_mq_alloc_disk(&tag_sets[drive], &lim, NULL);
 	if (IS_ERR(disk))
 		return PTR_ERR(disk);
 
-	blk_queue_max_hw_sectors(disk->queue, 64);
 	disk->major = FLOPPY_MAJOR;
 	disk->first_minor = TOMINOR(drive) | (type << 2);
 	disk->minors = 1;
-- 
2.39.2


