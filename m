Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDF230BF15
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 14:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhBBNLj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 08:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhBBNLZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 08:11:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23B1B64EDB;
        Tue,  2 Feb 2021 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612271443;
        bh=8z5wGmmOwhWEx7/4PjCxZWvsqfsxLlJI88DOQKJYGmE=;
        h=From:To:Cc:Subject:Date:From;
        b=CUCvF5DUiHbBP/I4aHvaE9WvjKytXCA92SIL6x9EaL3wsdg/eTCGVcsydqTIZOiNo
         IgX937CpnVsrGOPSOYXIjyE2x6SEER4zdQaXUK1jXhoyVz4aYEIGHvRVdfQxbVFtZ5
         ivJuWwFIXJUBIyfhjUJR6kYHJJv++v1YYmMdBdmYSgii+Muwyo+1OPpMAXc+sDcmf6
         NNcaXN+NmhdgjDI4/MHz2qaVAVt9sJ7oQimRcEUqb/Km+HNkz0j0CN8Pgm9oX293zx
         JNV/fHGQPFxqToP/c98aT+04lCVCuX1dlb62siMeYs82FDBwR+opt1ryUPSZm2ajVl
         mPaAl4Ir5OfQg==
From:   Jeff Layton <jlayton@kernel.org>
To:     dhowells@redhat.com
Cc:     dan.carpenter@oracle.com, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ceph: fix an oops in error handling in ceph_netfs_issue_op
Date:   Tue,  2 Feb 2021 08:10:41 -0500
Message-Id: <20210202131041.43977-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dan reported a potential oops in the cleanup if ceph_osdc_new_request
returns an error. Eliminate the unneeded initialization of "req" and
then just set it to NULL in the case where it holds an ERR_PTR.

Also, drop the unneeded NULL check before calling
ceph_osdc_put_request.

Fixes: 1cf7fdf52d5a ("ceph: convert readpage to fscache read helper")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 5eec6f66fe52..0dd64d31eff6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -234,7 +234,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 	struct inode *inode = rreq->mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_osd_request *req = NULL;
+	struct ceph_osd_request *req;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct iov_iter iter;
 	struct page **pages;
@@ -248,6 +248,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
+		req = NULL;
 		goto out;
 	}
 
@@ -273,8 +274,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 	if (err)
 		iput(inode);
 out:
-	if (req)
-		ceph_osdc_put_request(req);
+	ceph_osdc_put_request(req);
 	if (err)
 		netfs_subreq_terminated(subreq, err);
 	dout("%s: result %d\n", __func__, err);
-- 
2.29.2

