Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16A039A138
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 14:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFCMkg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 08:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230074AbhFCMkf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 08:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DEA6613E7;
        Thu,  3 Jun 2021 12:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622723931;
        bh=SWbSjTWC79Jmo55XWqc4opNSiHdGi2cPQsjI1/DM0t0=;
        h=From:To:Subject:Date:From;
        b=tBLvPbV82ItGgpz3Vjo4ywOHAiJyovrXrFKcLVwTgdT9nP9hwmB7J0RGJJNcctxyv
         JXzMu8ZaUhQcur7jMrJB0fh7JZZsYynojR9VH6t9aJ3LLv4qKTDV+LY5o40wWZtCAA
         raWLkpDHOjbYxSmI9KUlpJGkRXmXy+VPEfKdno+QRPDgppucMc4Fdu2Xgx5sspRnEh
         r23UpnI9wmWMBHW5t7OXKi+k+4YslWU+c/v7ZFSH+lvKmx+2yZ4Gk2v9h/anFctd1p
         tVTEb0dWf/KV+pGYrNMpnJs9c9WZ3eHFT0w00i9t7wOSeCRKihhsA2Y7hipiBKQGjT
         P05AWeqfU+P4g==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH] ceph: fix error handling in ceph_atomic_open and ceph_lookup
Date:   Thu,  3 Jun 2021 08:38:50 -0400
Message-Id: <20210603123850.74421-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Commit aa60cfc3f7ee broke the error handling in these functions such
that they don't handle non-ENOENT errors from ceph_mdsc_do_request
properly.

Move the checking of -ENOENT out of ceph_handle_snapdir and into the
callers, and if we get a different error, return it immediately.

Fixes: aa60cfc3f7ee ("ceph: don't use d_add in ceph_handle_snapdir")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c   | 17 ++++++-----------
 fs/ceph/file.c  |  6 +++---
 fs/ceph/super.h |  2 +-
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 5624fae7a603..ac431246e0c9 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -668,14 +668,13 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int whence)
  * Handle lookups for the hidden .snap directory.
  */
 struct dentry *ceph_handle_snapdir(struct ceph_mds_request *req,
-				   struct dentry *dentry, int err)
+				   struct dentry *dentry)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
 	struct inode *parent = d_inode(dentry->d_parent); /* we hold i_mutex */
 
 	/* .snap dir? */
-	if (err == -ENOENT &&
-	    ceph_snap(parent) == CEPH_NOSNAP &&
+	if (ceph_snap(parent) == CEPH_NOSNAP &&
 	    strcmp(dentry->d_name.name, fsc->mount_options->snapdir_name) == 0) {
 		struct dentry *res;
 		struct inode *inode = ceph_get_snapdir(parent);
@@ -742,7 +741,6 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_mds_request *req;
-	struct dentry *res;
 	int op;
 	int mask;
 	int err;
@@ -793,13 +791,10 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
-	res = ceph_handle_snapdir(req, dentry, err);
-	if (IS_ERR(res)) {
-		err = PTR_ERR(res);
-	} else {
-		dentry = res;
-		err = 0;
-	}
+	if (err == -ENOENT)
+		dentry = ceph_handle_snapdir(req, dentry);
+	if (IS_ERR(dentry))
+		err = PTR_ERR(dentry);
 	dentry = ceph_finish_lookup(req, dentry, err);
 	ceph_mdsc_put_request(req);  /* will dput(dentry) */
 	dout("lookup result=%p\n", dentry);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 7aa20d50a231..a01ad342a91d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -739,14 +739,14 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	err = ceph_mdsc_do_request(mdsc,
 				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
 				   req);
-	dentry = ceph_handle_snapdir(req, dentry, err);
+	if (err == -ENOENT)
+		dentry = ceph_handle_snapdir(req, dentry);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		goto out_req;
 	}
-	err = 0;
 
-	if ((flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
+	if (!err && (flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
 		err = ceph_handle_notrace_create(dir, dentry);
 
 	if (d_in_lookup(dentry)) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 12d30153e4ca..31f0be9120dd 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1217,7 +1217,7 @@ extern const struct dentry_operations ceph_dentry_ops;
 extern loff_t ceph_make_fpos(unsigned high, unsigned off, bool hash_order);
 extern int ceph_handle_notrace_create(struct inode *dir, struct dentry *dentry);
 extern struct dentry *ceph_handle_snapdir(struct ceph_mds_request *req,
-			       struct dentry *dentry, int err);
+			       struct dentry *dentry);
 extern struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
 					 struct dentry *dentry, int err);
 
-- 
2.31.1

