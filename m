Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F962EFF09
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 11:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbhAIKrW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Jan 2021 05:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbhAIKrV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Jan 2021 05:47:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395FDC061786;
        Sat,  9 Jan 2021 02:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tm46/p8xGvJZrA4UFHRSRl5YybeqFScWDNcbf2u9WV4=; b=R8EsSubjYzfHWHOhcdFz8vIWtg
        s3ZErXQrg2WYLXyM/qkf31uicxMafacZNC4iJtvH8Z5VlB/0AyXTANnXVE35/Hjs1SkXIe2cOYF2c
        FfSxggotM9it9zEejl4i/elmHPVrj+0J9fruBDnwzTgR7iizE/g+r9dn2tPWiqtyDtL4uDVjcF6eS
        TtWPLTRHot6isJFtb8affiE8cHw2oiXPENfZxAdFhoG/mN5rmf5q3MQV2QbzR9TOiuoRhdNwux9cH
        WzFJ0V5d8gyhmz2fdODSCcpqqbU2hB+x/h2hUDmTrF6uM/kv4RmJztmeDBA5mzDmUdlAA9TGTZsJR
        qhOAFXLg==;
Received: from [2001:4bb8:19b:e528:4197:a20:99de:e7b0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyBjS-000T18-2X; Sat, 09 Jan 2021 10:44:50 +0000
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
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/6] block: remove the NULL bdev check in bdev_read_only
Date:   Sat,  9 Jan 2021 11:42:50 +0100
Message-Id: <20210109104254.1077093-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210109104254.1077093-1-hch@lst.de>
References: <20210109104254.1077093-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Only a single caller can end up in bdev_read_only, so move the check
there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/genhd.c | 3 ---
 fs/super.c    | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 73faec438e49a8..4f90f80d7aa76d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1654,11 +1654,8 @@ EXPORT_SYMBOL(set_disk_ro);
 
 int bdev_read_only(struct block_device *bdev)
 {
-	if (!bdev)
-		return 0;
 	return bdev->bd_read_only;
 }
-
 EXPORT_SYMBOL(bdev_read_only);
 
 /*
diff --git a/fs/super.c b/fs/super.c
index 2c6cdea2ab2d9e..5a1f384ffc74f6 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -865,7 +865,8 @@ int reconfigure_super(struct fs_context *fc)
 
 	if (fc->sb_flags_mask & SB_RDONLY) {
 #ifdef CONFIG_BLOCK
-		if (!(fc->sb_flags & SB_RDONLY) && bdev_read_only(sb->s_bdev))
+		if (!(fc->sb_flags & SB_RDONLY) && sb->s_bdev &&
+		    bdev_read_only(sb->s_bdev))
 			return -EACCES;
 #endif
 
-- 
2.29.2

