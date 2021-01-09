Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE92EFF07
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 11:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbhAIKqi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Jan 2021 05:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbhAIKqi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Jan 2021 05:46:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F34C0617A2;
        Sat,  9 Jan 2021 02:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Hk3FmyWBTPX2vs5vD3kbYiMzUxQSn7PXGcIMyCilJYs=; b=vx4kZ2Zd0/TAPMgqgFUzXTdBJu
        8Ettnbv0lHuMqotAHekqBrRJQrFK6XLthgr5Aia5ExJb7Cf9M4yKY6CmqDUdMs3v3rwtt4iSQ5ksA
        eTQN83suluixP8bK/t+EsvdTsEAJfNq8gphVEGE+HC3MpD5ALUDSiE/Rrtu1kh7tLgZzEOakc6kk6
        LxF2qbDMSmyb++jacxheJ4fdqHazY1H7nyA3ZMkww/Z+mQeCQ1t1XXyT7Wjs+JAgzoAOYqGa9gFsK
        pk71iuyyRsP340YteVF4F3oMxbOi0eCqvjX/2fcXxtJEjXOXWR0VSfXDwn5yhsk6gV8hdU/P+uySa
        y01UtpLg==;
Received: from [2001:4bb8:19b:e528:4197:a20:99de:e7b0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyBim-000SyX-HT; Sat, 09 Jan 2021 10:44:04 +0000
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
Date:   Sat,  9 Jan 2021 11:42:49 +0100
Message-Id: <20210109104254.1077093-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210109104254.1077093-1-hch@lst.de>
References: <20210109104254.1077093-1-hch@lst.de>
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

