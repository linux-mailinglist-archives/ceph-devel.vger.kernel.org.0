Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E6A5A125D
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242798AbiHYNca (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242780AbiHYNcC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDF0B5A69
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D3761D18
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A62DC433C1;
        Thu, 25 Aug 2022 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434311;
        bh=c35Fheo3xdVGFAhJdyNKzTQ750ajc8SNvBYCff+5CnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElgcdIjdDHg/XgztBPpmvs/lJVbMUpuQA2B1JfclBxFwtm3d9WyxbQYX3fuO/KV4n
         6VofyTpWfEKrNcoT7QrLTL0p5mAG3qzCKf4F8OzfaT5npUJgi/sAk5L9f43ed4HGCV
         yGajUiwiblsUCFJInCDcwsYSJL3+d5WpoWdyBKmUJu3mTdk24Br1Jdh8nrBQSFokeE
         ubllv4a+h26iXKq+++TFix9Z9a+7F1jNU6T76nALHWfYyTK4lucLw0dHxkOHLE0hrZ
         EcVpPmihLBDIsZGs8TR/DgXbR2COsiKnYtJsdNRtadvyjQ4tsr93nZgHQk0zGy/RYg
         8y2hFhk6R+B7g==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 24/29] ceph: invalidate pages when doing direct/sync writes
Date:   Thu, 25 Aug 2022 09:31:27 -0400
Message-Id: <20220825133132.153657-25-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

When doing a direct/sync write, we need to invalidate the page cache in
the range being written to. If we don't do this, the cache will include
invalid data as we just did a write that avoided the page cache.

In the event that invalidation fails, just ignore the error. That likely
just means that we raced with another task doing a buffered write, in
which case we want to leave the page intact anyway.

[ jlayton: minor comment update ]

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3ebdc43959a4..537638abcb03 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1625,11 +1625,6 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		return ret;
 
 	ceph_fscache_invalidate(inode, false);
-	ret = invalidate_inode_pages2_range(inode->i_mapping,
-					    pos >> PAGE_SHIFT,
-					    (pos + count - 1) >> PAGE_SHIFT);
-	if (ret < 0)
-		dout("invalidate_inode_pages2_range returned %d\n", ret);
 
 	while ((len = iov_iter_count(from)) > 0) {
 		size_t left;
@@ -1955,6 +1950,20 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		}
 
 		ceph_clear_error_write(ci);
+
+		/*
+		 * We successfully wrote to a range of the file. Declare
+		 * that region of the pagecache invalid.
+		 */
+		ret = invalidate_inode_pages2_range(
+				inode->i_mapping,
+				pos >> PAGE_SHIFT,
+				(pos + len - 1) >> PAGE_SHIFT);
+		if (ret < 0) {
+			dout("invalidate_inode_pages2_range returned %d\n",
+			     ret);
+			ret = 0;
+		}
 		pos += len;
 		written += len;
 		dout("sync_write written %d\n", written);
-- 
2.37.2

