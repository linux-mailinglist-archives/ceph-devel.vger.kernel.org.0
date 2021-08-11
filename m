Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F36A3E8F67
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Aug 2021 13:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhHKLXu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 07:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231821AbhHKLXt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 07:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 568C360EB5;
        Wed, 11 Aug 2021 11:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628681005;
        bh=2g1NNBBM1XDHY2OD77DbnIuDOfr6Ntn4EHCrJ6aHUVc=;
        h=From:To:Cc:Subject:Date:From;
        b=h00SksQ8WpSuuslzfPKSvGjXrJSgHbIIWGzM19UEVcfeGOwLkneTqrZzqXLlPuzpg
         0edCDaA08rceqdZeL32Te7lJ62C6ncspU9XOaMed1nue3Fv1E38h2x5vrao8VSBUXb
         H781Lysw4AbIzEhjiodEq+07HvIFaetawVAGau9dpB6p/HibAaZAEa0p6RKBzcxJu7
         oDH2x6fSjmJXPzok2do9+jkCBMlIsUPfHP8bavWU0aWkpUph+W8xoh2pxhDRQIqsKB
         vwZJmXEF6LW0O1pW+xmsuqFqWmiSKE69X9HwgRokTCSjCYZXtxOeVBl5NwNRm/FBar
         K8hiZ2hvpx5Bg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de, xiubli@redhat.com,
        =?UTF-8?q?Jozef=20Kov=C3=A1=C4=8D?= <kovac@firma.zoznam.sk>
Subject: [PATCH] ceph: request Fw caps before updating the mtime in ceph_write_iter
Date:   Wed, 11 Aug 2021 07:23:24 -0400
Message-Id: <20210811112324.8870-1-jlayton@kernel.org>
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

Fix this by changing the order of operations in ceph_write_iter. Get the
caps much earlier, and only update the times afterward. Also, make sure
we check the NEARFULL conditions before making any changes to the inode.

URL: https://tracker.ceph.com/issues/46574
Reported-by: Jozef Kováč <kovac@firma.zoznam.sk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index f55ca2c4c7de..5867acfc6a51 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1722,22 +1722,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	}
 
-	err = file_remove_privs(file);
-	if (err)
-		goto out;
-
-	err = file_update_time(file);
-	if (err)
-		goto out;
-
-	inode_inc_iversion_raw(inode);
-
-	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		err = ceph_uninline_data(file, NULL);
-		if (err < 0)
-			goto out;
-	}
-
 	down_read(&osdc->lock);
 	map_flags = osdc->osdmap->flags;
 	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
@@ -1748,6 +1732,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	}
 
+	if (ci->i_inline_version != CEPH_INLINE_NONE) {
+		err = ceph_uninline_data(file, NULL);
+		if (err < 0)
+			goto out;
+	}
+
 	dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
 	     inode, ceph_vinop(inode), pos, count, i_size_read(inode));
 	if (fi->fmode & CEPH_FILE_MODE_LAZY)
@@ -1759,6 +1749,16 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (err < 0)
 		goto out;
 
+	err = file_remove_privs(file);
+	if (err)
+		goto out_caps;
+
+	err = file_update_time(file);
+	if (err)
+		goto out_caps;
+
+	inode_inc_iversion_raw(inode);
+
 	dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
 	     inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
 
@@ -1822,7 +1822,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
 			ceph_check_caps(ci, 0, NULL);
 	}
-
+out_caps:
 	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
 	     inode, ceph_vinop(inode), pos, (unsigned)count,
 	     ceph_cap_string(got));
-- 
2.31.1

