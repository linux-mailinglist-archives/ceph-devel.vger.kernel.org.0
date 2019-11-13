Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCCFFB4CE
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 17:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfKMQS5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 11:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbfKMQS4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 11:18:56 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E602084F;
        Wed, 13 Nov 2019 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573661935;
        bh=OZj/ksgTZyxap+sGsZDR+ouxLrWwZ9KxJrF9Lfh3Lfw=;
        h=From:To:Cc:Subject:Date:From;
        b=AYaNcnBXnzj/+XHjYSyfJO2Kri+nX280VQQE3KfFl3oAKaaGmuXnhWqPz2Yd1GKu3
         2dtFagfgxRNqmaAR1AJS43E0WgJl4TKl4Em1cmAJn+k19Qu3G5rZ9Q8aPGQ4ajvMn7
         7B5e49G+HiA0hyeEZZbiNjJwS/d8GPHuEebOJTIo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
Subject: [PATCH] ceph: take the inode lock before acquiring cap refs
Date:   Wed, 13 Nov 2019 11:18:47 -0500
Message-Id: <20191113161848.91812-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Most of the time, we (or the vfs layer) takes the inode_lock and then
acquires caps, but ceph_read_iter does the opposite, and that can lead
to a deadlock.

When there are multiple clients treading over the same data, we can end
up in a situation where a reader takes caps and then tries to acquire
the inode_lock. Another task holds the inode_lock and issues a request
to the MDS which needs to revoke the caps, but that can't happen until
the inode_lock is unwedged.

Fix this by having ceph_read_iter take the inode_lock earlier, before
attempting to acquire caps.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index bd77adb64bfd..06efeaff3b57 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1264,14 +1264,24 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	dout("aio_read %p %llx.%llx %llu~%u trying to get caps on %p\n",
 	     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len, inode);
 
+	if (iocb->ki_flags & IOCB_DIRECT)
+		ceph_start_io_direct(inode);
+	else
+		ceph_start_io_read(inode);
+
 	if (fi->fmode & CEPH_FILE_MODE_LAZY)
 		want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
 	else
 		want = CEPH_CAP_FILE_CACHE;
 	ret = ceph_get_caps(filp, CEPH_CAP_FILE_RD, want, -1,
 			    &got, &pinned_page);
-	if (ret < 0)
+	if (ret < 0) {
+		if (iocb->ki_flags & IOCB_DIRECT)
+			ceph_end_io_direct(inode);
+		else
+			ceph_end_io_read(inode);
 		return ret;
+	}
 
 	if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
 	    (iocb->ki_flags & IOCB_DIRECT) ||
@@ -1283,16 +1293,12 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 		if (ci->i_inline_version == CEPH_INLINE_NONE) {
 			if (!retry_op && (iocb->ki_flags & IOCB_DIRECT)) {
-				ceph_start_io_direct(inode);
 				ret = ceph_direct_read_write(iocb, to,
 							     NULL, NULL);
-				ceph_end_io_direct(inode);
 				if (ret >= 0 && ret < len)
 					retry_op = CHECK_EOF;
 			} else {
-				ceph_start_io_read(inode);
 				ret = ceph_sync_read(iocb, to, &retry_op);
-				ceph_end_io_read(inode);
 			}
 		} else {
 			retry_op = READ_INLINE;
@@ -1303,11 +1309,10 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len,
 		     ceph_cap_string(got));
 		ceph_add_rw_context(fi, &rw_ctx);
-		ceph_start_io_read(inode);
 		ret = generic_file_read_iter(iocb, to);
-		ceph_end_io_read(inode);
 		ceph_del_rw_context(fi, &rw_ctx);
 	}
+
 	dout("aio_read %p %llx.%llx dropping cap refs on %s = %d\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(got), (int)ret);
 	if (pinned_page) {
@@ -1315,6 +1320,12 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		pinned_page = NULL;
 	}
 	ceph_put_cap_refs(ci, got);
+
+	if (iocb->ki_flags & IOCB_DIRECT)
+		ceph_end_io_direct(inode);
+	else
+		ceph_end_io_read(inode);
+
 	if (retry_op > HAVE_RETRIED && ret >= 0) {
 		int statret;
 		struct page *page = NULL;
-- 
2.23.0

