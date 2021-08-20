Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095363F2FA5
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Aug 2021 17:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbhHTPkY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Aug 2021 11:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240966AbhHTPkW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 11:40:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0F9560BD3;
        Fri, 20 Aug 2021 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629473984;
        bh=PoFhyVoh1v6aOUOay7iJWpTvvCYW5KcLVq09vZnzI2c=;
        h=From:To:Cc:Subject:Date:From;
        b=Wm/JpO0spBfHJTH1d9WzB5iEumMmYg4FAPsaRGPomUhi71DO0WOzMGq3SkgWZH26h
         kqzrYaFYnGv5JaHNx5OgxvgGt/gHXEi17C64T5KiC1v0noWpBBaLvDuh2W+XlZZ3F7
         c40a7nAcF2TIgnZIfAeOEW2MBoCj9szRJO1b5d99oz3UA7WmULILAA5XF99JXwPDgb
         GwK6gXkkVBE/hSJUCwBGRR7JlW3NP/panWYWXy9TlDzt04CG0TcC6m0bMv8gCvL37m
         DVWDwO7NBIYal8lFSIZJ4sLTexdALlMWnKQ+n08zidpf1x1EIz5zxCl/6d+xzTcuD2
         a7pxb1wfLYlrw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, "Yan, Zheng" <ukernel@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Xiubo Li <xiubli@redhat.com>,
        =?UTF-8?q?Jozef=20Kov=C3=A1=C4=8D?= <kovac@firma.zoznam.sk>
Subject: [PATCH v3] ceph: request Fw caps before updating the mtime in ceph_write_iter
Date:   Fri, 20 Aug 2021 11:39:42 -0400
Message-Id: <20210820153942.235516-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The current code will update the mtime and then try to get caps to
handle the write. If we end up having to request caps from the MDS, then
the mtime in the cap grant will clobber the updated mtime and it'll be
lost.

This is most noticable when two clients are alternately writing to the
same file. Fw caps are continually being granted and revoked, and the
mtime ends up stuck because the updated mtimes are always being
overwritten with the old one.

Fix this by changing the order of operations in ceph_write_iter to get
the caps before updating the times. Also, make sure we check the pool
full conditions before even getting any caps or uninlining.

URL: https://tracker.ceph.com/issues/46574
Cc: "Yan, Zheng" <ukernel@gmail.com>
Cc: Luis Henriques <lhenriques@suse.de>
Cc: Xiubo Li <xiubli@redhat.com>
Reported-by: Jozef Kováč <kovac@firma.zoznam.sk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

v3: remove privs before getting caps. That can generate a SETATTR
    request, which could deadlock with us holding Fw caps

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d1755ac1d964..3daebfaec8c6 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1722,32 +1722,26 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	}
 
-	err = file_remove_privs(file);
-	if (err)
+	down_read(&osdc->lock);
+	map_flags = osdc->osdmap->flags;
+	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
+	up_read(&osdc->lock);
+	if ((map_flags & CEPH_OSDMAP_FULL) ||
+	    (pool_flags & CEPH_POOL_FLAG_FULL)) {
+		err = -ENOSPC;
 		goto out;
+	}
 
-	err = file_update_time(file);
+	err = file_remove_privs(file);
 	if (err)
 		goto out;
 
-	inode_inc_iversion_raw(inode);
-
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
 		err = ceph_uninline_data(file, NULL);
 		if (err < 0)
 			goto out;
 	}
 
-	down_read(&osdc->lock);
-	map_flags = osdc->osdmap->flags;
-	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
-	up_read(&osdc->lock);
-	if ((map_flags & CEPH_OSDMAP_FULL) ||
-	    (pool_flags & CEPH_POOL_FLAG_FULL)) {
-		err = -ENOSPC;
-		goto out;
-	}
-
 	dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
 	     inode, ceph_vinop(inode), pos, count, i_size_read(inode));
 	if (fi->fmode & CEPH_FILE_MODE_LAZY)
@@ -1759,6 +1753,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (err < 0)
 		goto out;
 
+	err = file_update_time(file);
+	if (err)
+		goto out_caps;
+
+	inode_inc_iversion_raw(inode);
+
 	dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
 	     inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
 
@@ -1842,6 +1842,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	goto out_unlocked;
+out_caps:
+	ceph_put_cap_refs(ci, got);
 out:
 	if (direct_lock)
 		ceph_end_io_direct(inode);
-- 
2.31.1

