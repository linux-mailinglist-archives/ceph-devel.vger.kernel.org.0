Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F18415D41
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Sep 2021 13:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240696AbhIWMAJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Sep 2021 08:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240678AbhIWMAI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 08:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE70161107;
        Thu, 23 Sep 2021 11:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632398317;
        bh=CmJyZGitG74sT8IAbrfCwdinj+v51hGvAGkDYlG7zcI=;
        h=From:To:Cc:Subject:Date:From;
        b=NrMeKA6RPfz3NCjjx8wwHCgAJFUEsZ+GqEAw64KMq1YqXOgcf2OgOBzeQRP6Eoynv
         crTFUVY1LnTrdR+HdG9RNIv97o9vd3rkLm3I9cQ1Vu4x943RpNOuzrA32Ek3DbmzfA
         EFzuqWKiiHVKGq5DxWKxlyD7l/YHBIUk/27j+IElP9O0UvPwAxz1cEbBj5bI0SnwWx
         /7VJTTlyXWaACDnMLJ6oFubVg+KVbwqC6IeavX2JQxb3r4vFtsq/f26LojCukhlyhR
         I7eaM0khVDFKQp8jbwNvPa5RWptf70gEThYAIr3BpExbbAiQCdRYeu0crlxNJJQ6Ct
         EWlJoj3heNq2A==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] ceph: convert to noop_direct_IO
Date:   Thu, 23 Sep 2021 07:58:35 -0400
Message-Id: <20210923115835.16513-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We have our own op, but the WARN_ON is not terribly helpful, and it's
otherwise identical to the noop one. Just use that.

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e09bfda37e6d..b39aebc2ed95 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1306,17 +1306,6 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
 	return copied;
 }
 
-/*
- * we set .direct_IO to indicate direct io is supported, but since we
- * intercept O_DIRECT reads and writes early, this function should
- * never get called.
- */
-static ssize_t ceph_direct_io(struct kiocb *iocb, struct iov_iter *iter)
-{
-	WARN_ON(1);
-	return -EINVAL;
-}
-
 const struct address_space_operations ceph_aops = {
 	.readpage = ceph_readpage,
 	.readahead = ceph_readahead,
@@ -1327,7 +1316,7 @@ const struct address_space_operations ceph_aops = {
 	.set_page_dirty = ceph_set_page_dirty,
 	.invalidatepage = ceph_invalidatepage,
 	.releasepage = ceph_releasepage,
-	.direct_IO = ceph_direct_io,
+	.direct_IO = noop_direct_IO,
 };
 
 static void ceph_block_sigs(sigset_t *oldset)
-- 
2.31.1

