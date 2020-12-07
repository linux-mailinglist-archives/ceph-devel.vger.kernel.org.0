Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219792D11BE
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Dec 2020 14:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgLGNWm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Dec 2020 08:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgLGNWh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Dec 2020 08:22:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78B4C0613D3;
        Mon,  7 Dec 2020 05:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=P+/gCBxIheHJGDi3+bpOjeRK+157ValOVnRejSvOwWE=; b=Z2RKlT+SK7W1QGWnjaBeY3Yjn4
        +pY6zzOcs8NlwZgg4DL7ZAdyTrRQW6S97qaTP+/QiEpKrROMtXkJblXVRIIr4ZHHa2f7Lcy2c1/Ha
        8D74zoQHAEablq5XavxTmG9Yw5PWrhuCFpSmM4a+Q21+Lxu9YEjvN09RO4lCNnypqxeJAGP4dD6d2
        LEt/5W1WpriloeFpS8Lttq2bD2ZEr/SXj2JmbSRb/irg5sb7IPZBydxjUUVoX2DcC1LRozMFelXMp
        QtnEeoTBM+SADeaKSt/DLqL1M4XWRrh2Y4YfBzC9Zlw2lJ/LvJuf3ML5nYr/zjl6+UbqaaYeg3crL
        Y5+7TP8w==;
Received: from [2001:4bb8:188:f36:4fd9:254f:b3b5:5284] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmGSK-0006Oz-Te; Mon, 07 Dec 2020 13:21:33 +0000
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
Subject: [PATCH 2/6] block: remove the NULL bdev check in bdev_read_only
Date:   Mon,  7 Dec 2020 14:19:14 +0100
Message-Id: <20201207131918.2252553-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201207131918.2252553-1-hch@lst.de>
References: <20201207131918.2252553-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Only a single caller can end up in bdev_read_only, so move the check there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 3 ---
 fs/super.c    | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 09ff6cef028729..c87013879b8650 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1445,11 +1445,8 @@ EXPORT_SYMBOL(set_disk_ro);
 
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

