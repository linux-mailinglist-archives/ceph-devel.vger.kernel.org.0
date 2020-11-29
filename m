Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63D92C7A8E
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Nov 2020 19:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgK2SU5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Nov 2020 13:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgK2SUn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Nov 2020 13:20:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD30C0613D3;
        Sun, 29 Nov 2020 10:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hYHfVN063JQbHTCkfynZwru10h0kXGt47OKm344U7QI=; b=RNnJn233VIIM9mljzx/z0CfeHt
        G7ucCDhvMQpp00m0IO2uRh5AJu7x3w8f94ZW0gJhL5j+HD6tI3vatePjdc8aLbpOL/IqpoqN1OnGZ
        ZgZSqoVRQwzLwXKt9OCHUOfTzJkrzh4sH4SXAQcpxYEXU9jnpY/rKKtPZOVBdmelGJM4hjpxcMR+y
        773cKGqomZoQ/OD98M3I78XxAVdwQr6ebe33IX7CEok3fS3su5N5pGTcOasso+SEeE05Hxq/BLNIR
        XoyprCr5vtKtyPsk6uBYkfKDvUE84CfGXn+CUzhfUJIvZmn4bdsG6SrOmIjMdSV3KupxxPT2G2j1D
        zubdPLiw==;
Received: from [2001:4bb8:18c:1dd6:f89e:6884:c966:3d6c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRIW-00078O-W2; Sun, 29 Nov 2020 18:19:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: [PATCH 4/4] dm: use bdev_read_only to check if a device is read-only
Date:   Sun, 29 Nov 2020 19:19:26 +0100
Message-Id: <20201129181926.897775-5-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201129181926.897775-1-hch@lst.de>
References: <20201129181926.897775-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

dm-thin and dm-cache also work on partitions, so use the proper
interface to check if the device is read-only.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-cache-metadata.c | 2 +-
 drivers/md/dm-thin-metadata.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index af6d4f898e4c1d..89a73204dbf47f 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -449,7 +449,7 @@ static int __check_incompat_features(struct cache_disk_superblock *disk_super,
 	/*
 	 * Check for read-only metadata to skip the following RDWR checks.
 	 */
-	if (get_disk_ro(cmd->bdev->bd_disk))
+	if (bdev_read_only(cmd->bdev))
 		return 0;
 
 	features = le32_to_cpu(disk_super->compat_ro_flags) & ~DM_CACHE_FEATURE_COMPAT_RO_SUPP;
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 6ebb2127f3e2e0..e75b20480e460e 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -636,7 +636,7 @@ static int __check_incompat_features(struct thin_disk_superblock *disk_super,
 	/*
 	 * Check for read-only metadata to skip the following RDWR checks.
 	 */
-	if (get_disk_ro(pmd->bdev->bd_disk))
+	if (bdev_read_only(pmd->bdev))
 		return 0;
 
 	features = le32_to_cpu(disk_super->compat_ro_flags) & ~THIN_FEATURE_COMPAT_RO_SUPP;
-- 
2.29.2

