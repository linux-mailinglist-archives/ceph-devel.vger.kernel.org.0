Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0CF164552
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 14:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgBSNZg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 08:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgBSNZg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:25:36 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4921C24670;
        Wed, 19 Feb 2020 13:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582118734;
        bh=xPbmVxoujdh4JrxWT979DVoUUagzQmhdyHGTc6n9H8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhuHfxfS9G/b3dwVxyfMCOw3qo9dZnzkQFWzqzjO81bu06jSjXlYlzlcj0YLm2KK8
         O3F0YdEKn55tsPHfXbBGBkVIVY0PvEc6SMrsF8NzDYVs+ZyPNY4v7JoVGfqymIyGaH
         yAp7bnf7B9kQxnNTtl9ZYII0TEBmB88H8ywdfrK8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [PATCH v5 08/12] ceph: make ceph_fill_inode non-static
Date:   Wed, 19 Feb 2020 08:25:22 -0500
Message-Id: <20200219132526.17590-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219132526.17590-1-jlayton@kernel.org>
References: <20200219132526.17590-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 47 ++++++++++++++++++++++++-----------------------
 fs/ceph/super.h |  8 ++++++++
 2 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 7478bd0283c1..4056c7968b86 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -728,11 +728,11 @@ void ceph_fill_file_time(struct inode *inode, int issued,
  * Populate an inode based on info from mds.  May be called on new or
  * existing inodes.
  */
-static int fill_inode(struct inode *inode, struct page *locked_page,
-		      struct ceph_mds_reply_info_in *iinfo,
-		      struct ceph_mds_reply_dirfrag *dirinfo,
-		      struct ceph_mds_session *session, int cap_fmode,
-		      struct ceph_cap_reservation *caps_reservation)
+int ceph_fill_inode(struct inode *inode, struct page *locked_page,
+		    struct ceph_mds_reply_info_in *iinfo,
+		    struct ceph_mds_reply_dirfrag *dirinfo,
+		    struct ceph_mds_session *session, int cap_fmode,
+		    struct ceph_cap_reservation *caps_reservation)
 {
 	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
 	struct ceph_mds_reply_inode *info = iinfo->in;
@@ -749,7 +749,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 	bool new_version = false;
 	bool fill_inline = false;
 
-	dout("fill_inode %p ino %llx.%llx v %llu had %llu\n",
+	dout("%s %p ino %llx.%llx v %llu had %llu\n", __func__,
 	     inode, ceph_vinop(inode), le64_to_cpu(info->version),
 	     ci->i_version);
 
@@ -770,7 +770,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 	if (iinfo->xattr_len > 4) {
 		xattr_blob = ceph_buffer_new(iinfo->xattr_len, GFP_NOFS);
 		if (!xattr_blob)
-			pr_err("fill_inode ENOMEM xattr blob %d bytes\n",
+			pr_err("%s ENOMEM xattr blob %d bytes\n", __func__,
 			       iinfo->xattr_len);
 	}
 
@@ -933,8 +933,9 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 			spin_unlock(&ci->i_ceph_lock);
 
 			if (symlen != i_size_read(inode)) {
-				pr_err("fill_inode %llx.%llx BAD symlink "
-					"size %lld\n", ceph_vinop(inode),
+				pr_err("%s %llx.%llx BAD symlink "
+					"size %lld\n", __func__,
+					ceph_vinop(inode),
 					i_size_read(inode));
 				i_size_write(inode, symlen);
 				inode->i_blocks = calc_inode_blocks(symlen);
@@ -958,7 +959,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 		inode->i_fop = &ceph_dir_fops;
 		break;
 	default:
-		pr_err("fill_inode %llx.%llx BAD mode 0%o\n",
+		pr_err("%s %llx.%llx BAD mode 0%o\n", __func__,
 		       ceph_vinop(inode), inode->i_mode);
 	}
 
@@ -1246,10 +1247,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		struct inode *dir = req->r_parent;
 
 		if (dir) {
-			err = fill_inode(dir, NULL,
-					 &rinfo->diri, rinfo->dirfrag,
-					 session, -1,
-					 &req->r_caps_reservation);
+			err = ceph_fill_inode(dir, NULL, &rinfo->diri,
+					      rinfo->dirfrag, session, -1,
+					      &req->r_caps_reservation);
 			if (err < 0)
 				goto done;
 		} else {
@@ -1314,14 +1314,14 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			goto done;
 		}
 
-		err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
-				session,
+		err = ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
+				NULL, session,
 				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
 				 !test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags) &&
 				 rinfo->head->result == 0) ?  req->r_fmode : -1,
 				&req->r_caps_reservation);
 		if (err < 0) {
-			pr_err("fill_inode badness %p %llx.%llx\n",
+			pr_err("ceph_fill_inode badness %p %llx.%llx\n",
 				in, ceph_vinop(in));
 			if (in->i_state & I_NEW)
 				discard_new_inode(in);
@@ -1508,10 +1508,11 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
 			dout("new_inode badness got %d\n", err);
 			continue;
 		}
-		rc = fill_inode(in, NULL, &rde->inode, NULL, session,
-				-1, &req->r_caps_reservation);
+		rc = ceph_fill_inode(in, NULL, &rde->inode, NULL, session,
+				     -1, &req->r_caps_reservation);
 		if (rc < 0) {
-			pr_err("fill_inode badness on %p got %d\n", in, rc);
+			pr_err("ceph_fill_inode badness on %p got %d\n",
+			       in, rc);
 			err = rc;
 			if (in->i_state & I_NEW) {
 				ihold(in);
@@ -1715,10 +1716,10 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			}
 		}
 
-		ret = fill_inode(in, NULL, &rde->inode, NULL, session,
-				 -1, &req->r_caps_reservation);
+		ret = ceph_fill_inode(in, NULL, &rde->inode, NULL, session,
+				      -1, &req->r_caps_reservation);
 		if (ret < 0) {
-			pr_err("fill_inode badness on %p\n", in);
+			pr_err("ceph_fill_inode badness on %p\n", in);
 			if (d_really_is_negative(dn)) {
 				/* avoid calling iput_final() in mds
 				 * dispatch threads */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 1b4996efc111..47fb6e022339 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -895,6 +895,9 @@ static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
 }
 
 /* inode.c */
+struct ceph_mds_reply_info_in;
+struct ceph_mds_reply_dirfrag;
+
 extern const struct inode_operations ceph_file_iops;
 
 extern struct inode *ceph_alloc_inode(struct super_block *sb);
@@ -910,6 +913,11 @@ extern void ceph_fill_file_time(struct inode *inode, int issued,
 				u64 time_warp_seq, struct timespec64 *ctime,
 				struct timespec64 *mtime,
 				struct timespec64 *atime);
+extern int ceph_fill_inode(struct inode *inode, struct page *locked_page,
+		    struct ceph_mds_reply_info_in *iinfo,
+		    struct ceph_mds_reply_dirfrag *dirinfo,
+		    struct ceph_mds_session *session, int cap_fmode,
+		    struct ceph_cap_reservation *caps_reservation);
 extern int ceph_fill_trace(struct super_block *sb,
 			   struct ceph_mds_request *req);
 extern int ceph_readdir_prepopulate(struct ceph_mds_request *req,
-- 
2.24.1

