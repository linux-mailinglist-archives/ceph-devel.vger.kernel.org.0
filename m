Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4C07E40E
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfHAU0O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbfHAU0N (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:13 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC092087E;
        Thu,  1 Aug 2019 20:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691171;
        bh=waDiAq9JxHsX1cmD1cirK7VbDedUL4nkAGbMPVeAU2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKak0YPZB62Daeh1vmU3BYSl7Am8pOuklMZ6HwnXQkrWxorFG9zcuUoC9+sjly1y4
         R3clNlJSHR+LMdpUXbbhEq+HMyxPb35rajUSMYcYK4N8kPcerPpkh7LYxCRcoF8Cz1
         38cvRFT4HjolC1CcHoj11ukmtbLnvCcPcjwr4YBY=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 5/9] ceph: wait for async dir ops to complete before doing synchronous dir ops
Date:   Thu,  1 Aug 2019 16:26:01 -0400
Message-Id: <20190801202605.18172-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ensure that we wait on replies from any pending directory operations
involving children before we allow synchronous operations involving
that directory to proceed.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c   | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/file.c  |  4 ++++
 fs/ceph/super.h |  1 +
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index aab29f48c62d..35797ff895e7 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1036,6 +1036,38 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
 	return err;
 }
 
+int ceph_async_dirop_request_wait(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_mds_request *cur, *req;
+	int ret = 0;
+
+	/* Only applicable for directories */
+	if (!inode || !S_ISDIR(inode->i_mode))
+		return 0;
+retry:
+	spin_lock(&ci->i_unsafe_lock);
+	req = NULL;
+	list_for_each_entry(cur, &ci->i_unsafe_dirops, r_unsafe_dir_item) {
+		if (!test_bit(CEPH_MDS_R_GOT_UNSAFE, &cur->r_req_flags) &&
+		    !test_bit(CEPH_MDS_R_GOT_SAFE, &cur->r_req_flags)) {
+			req = cur;
+			ceph_mdsc_get_request(req);
+			break;
+		}
+	}
+	spin_unlock(&ci->i_unsafe_lock);
+	if (req) {
+		dout("%s %lx wait on tid %llu\n", __func__, inode->i_ino,
+		     req->r_tid);
+		ret = wait_for_completion_killable(&req->r_completion);
+		ceph_mdsc_put_request(req);
+		if (!ret)
+			goto retry;
+	}
+	return ret;
+}
+
 /*
  * rmdir and unlink are differ only by the metadata op code
  */
@@ -1059,6 +1091,12 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 			CEPH_MDS_OP_RMDIR : CEPH_MDS_OP_UNLINK;
 	} else
 		goto out;
+
+	/* Wait for any requests involving children to get a reply */
+	err = ceph_async_dirop_request_wait(inode);
+	if (err)
+		goto out;
+
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -1105,8 +1143,14 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
 	    (!ceph_quota_is_same_realm(old_dir, new_dir)))
 		return -EXDEV;
 
-	dout("rename dir %p dentry %p to dir %p dentry %p\n",
-	     old_dir, old_dentry, new_dir, new_dentry);
+	err = ceph_async_dirop_request_wait(d_inode(old_dentry));
+	if (err)
+		return err;
+
+	err = ceph_async_dirop_request_wait(d_inode(new_dentry));
+	if (err)
+		return err;
+
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3c0b5247818f..75bce889305c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -449,6 +449,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	     dir, dentry, dentry,
 	     d_unhashed(dentry) ? "unhashed" : "hashed", flags, mode);
 
+	err = ceph_async_dirop_request_wait(dir);
+	if (err)
+		return err;
+
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a9aa3e358226..77ed6c5900be 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1113,6 +1113,7 @@ extern int ceph_handle_snapdir(struct ceph_mds_request *req,
 			       struct dentry *dentry, int err);
 extern struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 					 struct dentry *dentry, int err);
+extern int ceph_async_dirop_request_wait(struct inode *inode);
 
 extern void __ceph_dentry_lease_touch(struct ceph_dentry_info *di);
 extern void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di);
-- 
2.21.0

