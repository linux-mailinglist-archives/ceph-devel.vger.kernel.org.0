Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238A4415D47
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Sep 2021 13:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbhIWMAl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Sep 2021 08:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240727AbhIWMAd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 08:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD59A60F56;
        Thu, 23 Sep 2021 11:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632398342;
        bh=bCyiuEMrcGqg5eKV3UxzL0i9hmC6kCxOZDurl+ovZSM=;
        h=From:To:Cc:Subject:Date:From;
        b=F3EREPdYQVzypl4/ZPKcYIBgZBimFI32kCDeH+5P26iH3N9pl6f+26VOhXp+oFOgJ
         7hnJWzv65UEDk4h5WrXpfRSSkeFeGJPcg3G6Q1ZwY6K5GGixCKbu9iKdxX9+fr/mwy
         TdaIl8AokAuQQ8hUn9EhmDoWe6dWN6PjNC3WES2cAi9iUcXtbhzC+n7I6RJmLUvNoH
         XSv0ITcyzj8fsWoSXKrQM1KNpMdKcvpW4Eq06/vQywBDTNHPs9EHBH00Fp4kopHhlR
         V3gM1/FbZkW5NQf6xW+19Xf29FQd39FVMr/15UyARPpLBwQ+by8UOaY67dQCrYzFrt
         WdBh78D4U1ovw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] cifs: switch to noop_direct_IO
Date:   Thu, 23 Sep 2021 07:59:00 -0400
Message-Id: <20210923115900.16587-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The cifs one is identical to the noop one. Just use it instead.

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cifs/file.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d0216472f1c6..2406b9ddd623 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4890,25 +4890,6 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_done_oplock_break(cinode);
 }
 
-/*
- * The presence of cifs_direct_io() in the address space ops vector
- * allowes open() O_DIRECT flags which would have failed otherwise.
- *
- * In the non-cached mode (mount with cache=none), we shunt off direct read and write requests
- * so this method should never be called.
- *
- * Direct IO is not yet supported in the cached mode. 
- */
-static ssize_t
-cifs_direct_io(struct kiocb *iocb, struct iov_iter *iter)
-{
-        /*
-         * FIXME
-         * Eventually need to support direct IO for non forcedirectio mounts
-         */
-        return -EINVAL;
-}
-
 static int cifs_swap_activate(struct swap_info_struct *sis,
 			      struct file *swap_file, sector_t *span)
 {
@@ -4973,7 +4954,7 @@ const struct address_space_operations cifs_addr_ops = {
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	.releasepage = cifs_release_page,
-	.direct_IO = cifs_direct_io,
+	.direct_IO = noop_direct_io,
 	.invalidatepage = cifs_invalidate_page,
 	.launder_page = cifs_launder_page,
 	/*
-- 
2.31.1

