Return-Path: <ceph-devel+bounces-849-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EB7855B01
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 08:03:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E283CB231F7
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 07:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD063D52A;
	Thu, 15 Feb 2024 07:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XY72oYnL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C1133C5;
	Thu, 15 Feb 2024 07:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980600; cv=none; b=kazT+qEQXyzI8piNAyShTHXYFtijqOkZeNfHQjMcxNzgxB5SduPE9Vn1WM6O95krLVyWQFGPHgx2GYLv2rHkYx48a0ICBTH1y9nk83uI7yFMvitmI10bIPyG/N6YSgNfDffJC6J/FgK1rR6HyScrgBhJs3nU4i489ymBMgLHRYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980600; c=relaxed/simple;
	bh=U4yOpDeN09NExZEPN46FgqX+fcF5jxPj58pyagQwFFE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RdJIgxSwdPWt619RUuf5XASsbK+A3+JenO3pYDlE9sKFAXil3LVa3d2okXkPSp6IaQx/xSHyymduQjwnDkjUCSFc2oLC4nyyQDyXux+Y+drjUFWKKENhXgp7lg3uoMNwjYrUIOf3rn4WUruEup8esxARWYqXJbaWfG64RezmjDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XY72oYnL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=K2FgxI/Q5z39NeiH1eGPpjIbdu8553gMMeg+3F7f/g0=; b=XY72oYnL7yvCvK8xeQhtM8J9nH
	GQ115g5bBxrJPMyB0kUAzpWVesmy/dAZHeFVEqkkVzviYdmEXVdln4vL7iZAyXAnMNSBAG2Ona+nB
	ST3R9rDYwtkhlC/pNHvAyoa005k0tzhnlyb8v0ct42hSvgJ8PJyUJBa86eQ/vP3ipmXU8k60ydOor
	FwM+vuChUf0fPpJ6dD1uhGK2VxiPc/U+IE7HiNpxbyWQKJavy2q2EoOo89EySCCYHotcNESZMslD4
	PXcLVqhsnGgsShRW9HD4JMmDgWbJ0wlRD6egcjphmvGFg8Le812rGfhT345Z22C+NXJCjoj3pACXc
	5h7l5ICg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVlz-0000000FANl-1akg;
	Thu, 15 Feb 2024 07:03:07 +0000
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
Subject: pass queue_limits to blk_mq_alloc_disk for simple drivers
Date: Thu, 15 Feb 2024 08:02:43 +0100
Message-Id: <20240215070300.2200308-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens,

this series converts all "simple" blk-mq drivers that don't have complex
internal layering or other oddities to pass the queue_limits to
blk_mq_alloc_disk.  None of these drivers updates the limits at runtime.


Diffstat:
 arch/um/drivers/ubd_kern.c          |    8 +-
 drivers/block/aoe/aoeblk.c          |   15 ++---
 drivers/block/floppy.c              |    6 +-
 drivers/block/mtip32xx/mtip32xx.c   |   13 ++--
 drivers/block/nbd.c                 |   13 ++--
 drivers/block/ps3disk.c             |   17 +++---
 drivers/block/rbd.c                 |   29 +++++-----
 drivers/block/rnbd/rnbd-clt.c       |   64 +++++++++--------------
 drivers/block/sunvdc.c              |   18 +++---
 drivers/block/ublk_drv.c            |   90 +++++++++++++++------------------
 drivers/cdrom/gdrom.c               |   14 ++---
 drivers/memstick/core/ms_block.c    |   14 ++---
 drivers/memstick/core/mspro_block.c |   15 ++---
 drivers/mmc/core/queue.c            |   97 +++++++++++++++++++-----------------
 drivers/mtd/mtd_blkdevs.c           |   12 ++--
 drivers/mtd/ubi/block.c             |    6 +-
 drivers/s390/block/scm_blk.c        |   17 +++---
 17 files changed, 222 insertions(+), 226 deletions(-)

