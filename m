Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73682D2FC3
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 17:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbgLHQds (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 11:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbgLHQds (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 11:33:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E119AC061749;
        Tue,  8 Dec 2020 08:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Hk3FmyWBTPX2vs5vD3kbYiMzUxQSn7PXGcIMyCilJYs=; b=CkahAQx5oWjZpm2CgHg+wqC7e1
        1bg1rgf/jlvMwyLut5vfSRxEIAlVFCyHO++A60PldTocwGftMFCcyjQyHkAc/ElwUzkzswVortiFZ
        LsZ67xbCb2Jq5RuJxaYrM3hjauAgAjRKGKTUGh1CNgDfCVup0tMuQfXlRXeWCGCl5XoJf++lKIQDB
        H9QB3B2nwIsNWar5Zp926j6b2DTZ+WeJK3FZGHK30mVWtdeiWfaKulhhKpFFu3VzmrvgIj9AJSFYA
        iy1D8YXe6iCbHl1w1QNoOZs3XSDBG+QlHDwLGyoA5WIwhlrqFvNNqdYn0rxqBgyKhgIKfM6dNN+PL
        CbBzKHQQ==;
Received: from 089144200046.atnat0009.highway.a1.net ([89.144.200.46] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmfv2-00014p-QV; Tue, 08 Dec 2020 16:32:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] dm: use bdev_read_only to check if a device is read-only
Date:   Tue,  8 Dec 2020 17:28:24 +0100
Message-Id: <20201208162829.2424563-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208162829.2424563-1-hch@lst.de>
References: <20201208162829.2424563-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

dm-thin and dm-cache also work on partitions, so use the proper
interface to check if the device is read-only.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

