Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFC672B762
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jun 2023 07:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbjFLFfv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 01:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbjFLFfo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 01:35:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6340718B
        for <ceph-devel@vger.kernel.org>; Sun, 11 Jun 2023 22:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=89VKJziDz7b/CYr41XY8Omy1Z40o8Fo790ujxdQ6y1Q=; b=Mtm8B8CFGMDL/eImXuFiivwCAL
        6bWOvKuI/gwDslwsqYw7HTMCpUTRNWGwL+rWG3EohGRyar04BgqCjxmXY/YIDq21WrHKvPvqinMvf
        87vLPqiQqQuuph2sLxr+BeyQ/pfu5N6PzlKgK+Nso6truDD8ipUdJ7YfcAv+2WRQM5nNfO6ofWif+
        5UwTFz9Fj2bBe0ec+VK7r65amnRCC0XOQnoP9CyP7XHiBkzPgBbHQY5cU6M614NvplsCGKfldpb0B
        XC41EzbERC5tNFx/nuis8XFq17VOAvYhxfLuZDscUzKKtpoucVe+o3f367Ov6BGFabSyiuTZbTC3s
        l2wykD4w==;
Received: from 2a02-8389-2341-5b80-8c8c-28f8-1274-e038.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c8c:28f8:1274:e038] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q8aDL-002f7O-1e;
        Mon, 12 Jun 2023 05:35:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     xiubli@redhat.com, idryomov@gmail.com, jlayton@kernel.org,
        ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: set FMODE_CAN_ODIRECT instead of a dummy direct_IO method
Date:   Mon, 12 Jun 2023 07:35:37 +0200
Message-Id: <20230612053537.585525-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
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

Since commit a2ad63daa88b ("VFS: add FMODE_CAN_ODIRECT file flag") file
systems can just set the FMODE_CAN_ODIRECT flag at open time instead of
wiring up a dummy direct_IO method to indicate support for direct I/O.
Do that for ceph so that noop_direct_IO can eventually be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ceph/addr.c | 1 -
 fs/ceph/file.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6bb251a4d613eb..19c0f42540b600 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1401,7 +1401,6 @@ const struct address_space_operations ceph_aops = {
 	.dirty_folio = ceph_dirty_folio,
 	.invalidate_folio = ceph_invalidate_folio,
 	.release_folio = ceph_release_folio,
-	.direct_IO = noop_direct_IO,
 };
 
 static void ceph_block_sigs(sigset_t *oldset)
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index f4d8bf7dec88a8..314c5d5971bf4a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -368,6 +368,8 @@ int ceph_open(struct inode *inode, struct file *file)
 	flags = file->f_flags & ~(O_CREAT|O_EXCL);
 	if (S_ISDIR(inode->i_mode))
 		flags = O_DIRECTORY;  /* mds likes to know */
+	if (S_ISREG(inode->i_mode))
+		file->f_mode |= FMODE_CAN_ODIRECT;
 
 	dout("open inode %p ino %llx.%llx file %p flags %d (%d)\n", inode,
 	     ceph_vinop(inode), file, flags, file->f_flags);
-- 
2.39.2

