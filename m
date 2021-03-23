Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9FE3469E3
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Mar 2021 21:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhCWUeA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Mar 2021 16:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233385AbhCWUd1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 16:33:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BB4961574
        for <ceph-devel@vger.kernel.org>; Tue, 23 Mar 2021 20:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616531607;
        bh=OfcLU+iwDbMk2WvJRBJTIvuEquwzGuzQWc0tGumks+4=;
        h=From:To:Subject:Date:From;
        b=boLlck76mCFRy3DOlrk5N0COVAc9M7XpZsGPYbeuJNTaEQVwfNsMTOkQrgC/eAXPx
         5PwVWpUej3eQmjr7pDgneTu4be1v51nTfaIKuhyWm+67oBujW+7dpTd9Y+IIJJ7ZFJ
         3uAooOTOOHnJGXpp8CSAIwN8KZ+cpsDCx3ElZdO8lHyiLUpcw20cstZbJQRNzYQ3G+
         ptVyZT2KP68lzL/raYnTisCkq01to4/1lajDfY1wHMH6yS99LK9mKCCiiS5LEoghe7
         DE7lQkivmZm+jive/Qn/BLaa5lz1a8ppclLuQb5uRRg6WJ8faM2XuA8mTMdfk1PI22
         XJ+SX1VFaQ1qQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 1/2] ceph: fix kerneldoc copypasta over ceph_start_io_direct
Date:   Tue, 23 Mar 2021 16:33:26 -0400
Message-Id: <20210323203326.217781-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/io.c b/fs/ceph/io.c
index 97602ea92ff4..c456509b31c3 100644
--- a/fs/ceph/io.c
+++ b/fs/ceph/io.c
@@ -118,7 +118,7 @@ static void ceph_block_buffered(struct ceph_inode_info *ci, struct inode *inode)
 }
 
 /**
- * ceph_end_io_direct - declare the file is being used for direct i/o
+ * ceph_start_io_direct - declare the file is being used for direct i/o
  * @inode: file inode
  *
  * Declare that a direct I/O operation is about to start, and ensure
-- 
2.30.2

