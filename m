Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE45553FD75
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 13:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241614AbiFGL1L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 07:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241539AbiFGL1I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 07:27:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7679B0A56
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 04:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 914F7B81EFF
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 11:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0684C385A5;
        Tue,  7 Jun 2022 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654601225;
        bh=Wp7ERFXeQpmR1TdbhcN5ndpIktPpCqlTyf4NeyGpXs8=;
        h=From:To:Cc:Subject:Date:From;
        b=bUB3rlKza92rs8T/Q0udHxeTSCYtZGpOOk5NwOXU9NZonQ0h2Oo5leugEZKKbGbps
         F/E7JbPsxfyDF9HedMuQ0cEF7gl3Lck00IjO/eo2zs/TxK8Nc4pyftt/OIWlaBlQSy
         yh+M8Xdhm1jgQGmw0UGXERI6inMa4LWATJ7hbhYcFXAyqKsgC2nSrPcK4aBY0VsqU4
         D/N5s75FkMtj83mGkf58W16y41XhQCv8WXtiZ/Dl7SUCb9tCPy646oLZZtzn9tc9Gs
         k643EcTrbQ3bU1Tbuciv4s0yum6UhCdwHXcFsdpflkPBfcDvfNlCTGdCZ+kRU9znqQ
         xjRmlavZs68hQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: don't implement writepage
Date:   Tue,  7 Jun 2022 07:27:03 -0400
Message-Id: <20220607112703.17997-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Remove ceph_writepage as it's not strictly required these days.

To quote from commit 21b4ee7029c9 (xfs: drop ->writepage completely):

    ->writepage is only used in one place - single page writeback from
    memory reclaim. We only allow such writeback from kswapd, not from
    direct memory reclaim, and so it is rarely used. When it comes from
    kswapd, it is effectively random dirty page shoot-down, which is
    horrible for IO patterns. We will already have background writeback
    trying to clean all the dirty pages in memory as efficiently as
    possible, so having kswapd interrupt our well formed IO stream only
    slows things down. So get rid of xfs_vm_writepage() completely.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 40830cb9b599..3489444c55b9 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -680,30 +680,6 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	return err;
 }
 
-static int ceph_writepage(struct page *page, struct writeback_control *wbc)
-{
-	int err;
-	struct inode *inode = page->mapping->host;
-	BUG_ON(!inode);
-	ihold(inode);
-
-	if (wbc->sync_mode == WB_SYNC_NONE &&
-	    ceph_inode_to_client(inode)->write_congested)
-		return AOP_WRITEPAGE_ACTIVATE;
-
-	wait_on_page_fscache(page);
-
-	err = writepage_nounlock(page, wbc);
-	if (err == -ERESTARTSYS) {
-		/* direct memory reclaimer was killed by SIGKILL. return 0
-		 * to prevent caller from setting mapping/page error */
-		err = 0;
-	}
-	unlock_page(page);
-	iput(inode);
-	return err;
-}
-
 /*
  * async writeback completion handler.
  *
@@ -1394,7 +1370,6 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
 const struct address_space_operations ceph_aops = {
 	.readpage = netfs_readpage,
 	.readahead = netfs_readahead,
-	.writepage = ceph_writepage,
 	.writepages = ceph_writepages_start,
 	.write_begin = ceph_write_begin,
 	.write_end = ceph_write_end,
-- 
2.36.1

