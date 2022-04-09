Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AF54FA3AA
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Apr 2022 06:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbiDIEyd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Apr 2022 00:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240923AbiDIExz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Apr 2022 00:53:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEF3BC862;
        Fri,  8 Apr 2022 21:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Bh+vV8H1PUD+w/3YWj6wMRz8JdOJ8okMcDjW6Mx/Fiw=; b=DWf7imoDvMSXJTtirA5ltk+rtE
        YeH7NxKahOANJaW3JeWmpEL0KWvrQ+sUioHsm0dQaUs7Tks6Ss/UVOXMhmulR7QEBLriQYI1KEMzQ
        aO9ISV0dwvPZErcNPFhlMeFi6wIDVT8NvUOYYMlUOKdrnhvM68xwDYg36srZ722XpvX8aIcmuYcaD
        sB1HtVb3yxckb8p+8Hs6srY4Fa9xc+Rr/tmxJaQIFCFAy3LRp9g0YB5fD3IXoh+PksnNKd9R9552Q
        DFKI2Il5Y+lOkByKWQ2YD6LETuE64wDq4THU/F5OZAcQu9U4H1sQRvyeZgS12iohkvkHfPdltFjhr
        Z+SPB7CA==;
Received: from 213-147-167-116.nat.highway.webapn.at ([213.147.167.116] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nd348-0020i9-Di; Sat, 09 Apr 2022 04:51:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 09/27] ntfs3: use bdev_logical_block_size instead of open coding it
Date:   Sat,  9 Apr 2022 06:50:25 +0200
Message-Id: <20220409045043.23593-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 278dcf5024102..cd30e81abbce0 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -920,7 +920,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	/* Parse boot. */
-	err = ntfs_init_from_boot(sb, rq ? queue_logical_block_size(rq) : 512,
+	err = ntfs_init_from_boot(sb, bdev_logical_block_size(bdev),
 				  bdev_nr_bytes(bdev));
 	if (err)
 		goto out;
-- 
2.30.2

