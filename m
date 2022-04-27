Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B387512273
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiD0TVU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiD0TTj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BC2562CF
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A409C61A01
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3EFC385A7;
        Wed, 27 Apr 2022 19:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086839;
        bh=HiyHoFuQT6U1dF5z+DwmZm40YsMHDM+nBxJbq1l1J3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnwbtxL3on29o+HLOku18+v1Tt+MOMqGr4kc7yrgEBnc4sSpm0DGN5Z94nbtqsgcr
         tbwb4KP4RqAPzp70WZihAxIiNerxWPoEi88KKmyg0Ixh1sqY23mzJTwphKcIvKX362
         UyDtjCuloPkba0LYWrubKs35yS+JsHA7BmBNg4LP5c4a6fZdvjnV0ZNqryJ8+um3cP
         NRinlrNsWhZhl38DY0UcZWl+RUjtH4FXLh4W9hdUS07o7RlNXB9S+qsp30TMgFvsTn
         qrK2CHnFgbIDbx99wnmi2yyIFH+BxzdK+ZtBGpHNAEsmYfZV0PeEXI2wdMkulZH1ap
         rDVjohGYr8apg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 60/64] ceph: invalidate pages when doing direct/sync writes
Date:   Wed, 27 Apr 2022 15:13:10 -0400
Message-Id: <20220427191314.222867-61-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3d8f0839b718..2a9d6dd37a65 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1614,11 +1614,6 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		return ret;
 
 	ceph_fscache_invalidate(inode, false);
-	ret = invalidate_inode_pages2_range(inode->i_mapping,
-					    pos >> PAGE_SHIFT,
-					    (pos + count - 1) >> PAGE_SHIFT);
-	if (ret < 0)
-		dout("invalidate_inode_pages2_range returned %d\n", ret);
 
 	while ((len = iov_iter_count(from)) > 0) {
 		size_t left;
@@ -1946,6 +1941,20 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			break;
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
2.35.1

