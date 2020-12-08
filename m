Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701562D2FCC
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 17:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgLHQfy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 11:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgLHQfx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 11:35:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BE3C061749;
        Tue,  8 Dec 2020 08:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=FcrfDLXDMA6oQ175CyeC3VNyPVZW/odXwBqmYwf7d6s=; b=NbDUxu3AofBgFFaEc6xSfIhXOw
        c7uvYPpuX5u9/zeVdKnrjZFeNQaTZKOBIJ7Yp9OXPLhRHUm/XzX46cZdPGlAc4Nfb6S2XsbS/e4x6
        tINnMYr9bWpAHYEY7HZ3nZC5wTVtr2zNzLsF+sB0ZBQgdsZBvgrdZ05ZPRzOm7m6CEiLFpkkfvV++
        XMuSfHOgIbo0JYdoThDm+vhmMvPg73O1tZkI0nRNRchwezl803XDFGmt4WUEICTMr93kqLKXSAms8
        z5gpTzgFAJyIR2cSDudEYXqtXbbSoDJ69nkjyMrq8padi8W8wewDHZiKQ35URTLaEAan/7FGABTap
        Ljz+GWiQ==;
Received: from 089144200046.atnat0009.highway.a1.net ([89.144.200.46] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmfx9-0001Dj-SE; Tue, 08 Dec 2020 16:35:04 +0000
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
Date:   Tue,  8 Dec 2020 17:28:25 +0100
Message-Id: <20201208162829.2424563-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208162829.2424563-1-hch@lst.de>
References: <20201208162829.2424563-1-hch@lst.de>
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
index b84b8671e6270a..8f2b89d1161813 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1652,11 +1652,8 @@ EXPORT_SYMBOL(set_disk_ro);
 
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

