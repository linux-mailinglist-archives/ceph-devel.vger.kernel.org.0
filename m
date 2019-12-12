Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F0E11CFC1
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Dec 2019 15:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfLLO1U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Dec 2019 09:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729392AbfLLO1U (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 09:27:20 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF9C214D8;
        Thu, 12 Dec 2019 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576160838;
        bh=JNRZpOcuvJo0bsWr0HgrRU2kAZT9gkIykLNcH28+ryQ=;
        h=From:To:Cc:Subject:Date:From;
        b=pHM1A0eXktGaSml5wDMibYYhIoKztG/1xFjacSjulWqxRikvL+ky1z+sekp4vLglU
         ywhdM3uy37USjEtCkIyQltQoS0xn8FF6HpHl41CGe8gCY5mGPOydCmvf7dFnuDpPzQ
         jpzjSrV7JclsQJMF5k4OBQhUDlsYhPd3B/3xddVM=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com
Subject: [PATCH] ceph: don't clear I_NEW until inode metadata is fully populated
Date:   Thu, 12 Dec 2019 09:27:17 -0500
Message-Id: <20191212142717.23656-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, we could have an open-by-handle (or NFS server) call
into the filesystem and start working with an inode before it's
properly filled out.

Don't clear I_NEW until we have filled out the inode, and discard it
properly if that fails. Note that we occasionally take an extra
reference to the inode to ensure that we don't put the last reference in
discard_new_inode, but rather leave it for ceph_async_iput.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 5bdc1afc2bee..11672f8192b9 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -55,11 +55,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
 	inode = iget5_locked(sb, t, ceph_ino_compare, ceph_set_ino_cb, &vino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
-	if (inode->i_state & I_NEW) {
+	if (inode->i_state & I_NEW)
 		dout("get_inode created new inode %p %llx.%llx ino %llx\n",
 		     inode, ceph_vinop(inode), (u64)inode->i_ino);
-		unlock_new_inode(inode);
-	}
 
 	dout("get_inode on %lu=%llx.%llx got %p\n", inode->i_ino, vino.ino,
 	     vino.snap, inode);
@@ -88,6 +86,10 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	inode->i_fop = &ceph_snapdir_fops;
 	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
 	ci->i_rbytes = 0;
+
+	if (inode->i_state & I_NEW)
+		unlock_new_inode(inode);
+
 	return inode;
 }
 
@@ -1301,7 +1303,6 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			err = PTR_ERR(in);
 			goto done;
 		}
-		req->r_target_inode = in;
 
 		err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
 				session,
@@ -1311,8 +1312,13 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		if (err < 0) {
 			pr_err("fill_inode badness %p %llx.%llx\n",
 				in, ceph_vinop(in));
+			if (in->i_state & I_NEW)
+				discard_new_inode(in);
 			goto done;
 		}
+		req->r_target_inode = in;
+		if (in->i_state & I_NEW)
+			unlock_new_inode(in);
 	}
 
 	/*
@@ -1496,7 +1502,12 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
 		if (rc < 0) {
 			pr_err("fill_inode badness on %p got %d\n", in, rc);
 			err = rc;
+			ihold(in);
+			discard_new_inode(in);
+		} else if (in->i_state & I_NEW) {
+			unlock_new_inode(in);
 		}
+
 		/* avoid calling iput_final() in mds dispatch threads */
 		ceph_async_iput(in);
 	}
@@ -1698,12 +1709,18 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			if (d_really_is_negative(dn)) {
 				/* avoid calling iput_final() in mds
 				 * dispatch threads */
+				if (in->i_state & I_NEW) {
+					ihold(in);
+					discard_new_inode(in);
+				}
 				ceph_async_iput(in);
 			}
 			d_drop(dn);
 			err = ret;
 			goto next_item;
 		}
+		if (in->i_state & I_NEW)
+			unlock_new_inode(in);
 
 		if (d_really_is_negative(dn)) {
 			if (ceph_security_xattr_deadlock(in)) {
-- 
2.23.0

