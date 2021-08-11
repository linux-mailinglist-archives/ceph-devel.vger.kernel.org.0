Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768CB3E96E9
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Aug 2021 19:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhHKRiE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 13:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhHKRiE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 13:38:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9375360FC3;
        Wed, 11 Aug 2021 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628703460;
        bh=IauFODze5gZm4XT6/usizKpARfDAJbZk4cQzikdnyCM=;
        h=From:To:Cc:Subject:Date:From;
        b=kBAbHvLn/AAGZVcPRIAZoZQcotxXHKvvR4aFll8jQYCfb/fNNbu4Wnv56i/GmIxtN
         XtmS/cZSWV7UpTowmf7B7MWfSag8GSSxPejMZWB2icleu6/nPqRaEV54ekVr6A80vk
         aognr7imdXSZuMoGn8V8/Frb/nkeMRnYNQFCFNdYWL+njj1Rdr4ZuYJwvSuri2dw03
         HaX5qNUV7emmd1tChQcXAG/04qYBhQdJ28UihVqjH9x4PO9ceZtx4RCKAqT7/8F/F4
         WnZLmQCY+4Kw2Gs7uvbuh3rPpWXdhbEMDF2w/tftf7z2YS7wfi+wwgI0UH9/907uJw
         BZGFNbFGy7+lg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de, xiubli@redhat.com,
        =?UTF-8?q?Jozef=20Kov=C3=A1=C4=8D?= <kovac@firma.zoznam.sk>
Subject: [PATCH v2] ceph: request Fw caps before updating the mtime in ceph_write_iter
Date:   Wed, 11 Aug 2021 13:37:38 -0400
Message-Id: <20210811173738.29574-1-jlayton@kernel.org>
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
 fs/ceph/file.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

v2: fix error handling -- make sure we release i_rwsem on error exit

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d1755ac1d964..da856bd5eaa5 100644
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
 
@@ -1822,7 +1822,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
 			ceph_check_caps(ci, 0, NULL);
 	}
-
 	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
 	     inode, ceph_vinop(inode), pos, (unsigned)count,
 	     ceph_cap_string(got));
@@ -1842,6 +1841,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	goto out_unlocked;
+out_caps:
+	ceph_put_cap_refs(ci, got);
 out:
 	if (direct_lock)
 		ceph_end_io_direct(inode);
-- 
2.31.1

