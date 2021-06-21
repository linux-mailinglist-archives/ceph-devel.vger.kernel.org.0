Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03A93AF9F5
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Jun 2021 01:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhFUX7j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 19:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhFUX7i (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 19:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7158E6100A;
        Mon, 21 Jun 2021 23:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624319843;
        bh=C6qb3Nh+7mSIfNIrkX5wQn2m/9F1eS0llJL1YH6g7mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oeNCPsG76irGD6AmpUcGhr2emUAkx0CphtFgzLO7iiGIPGu/bgeXEWrvGcPy5I3J1
         R8K4dZLvAi5sfHVqUj3xkWY8UrM1VoTyHjHRKH1tGdMMzmdqKR1V/RZ6039FiTFDqt
         Xr0WUmpSUSK3NpfuCyNpQJzB2INE5aez9GzkahUnRePUGNcE2qer8KMb9hk4R7RfyT
         33Gi/gWGyG1+tjyov4txxswvybwso09aQ2vGFYhvQZdBeLL4tw0qyXNjlJEo58qHPu
         OxfulipDbzOiavs46F3IKB52m8ijLCzUoCUOxCKlfDKELPte75OpvF2P73d/iNMk7N
         vornQ67yCNTaQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH v2] ceph: fix error handling in ceph_atomic_open and ceph_lookup
Date:   Mon, 21 Jun 2021 19:57:22 -0400
Message-Id: <20210621235722.304689-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603123850.74421-1-jlayton@kernel.org>
References: <20210603123850.74421-1-jlayton@kernel.org>
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
 fs/ceph/dir.c   | 22 ++++++++++++----------
 fs/ceph/file.c  | 14 ++++++++------
 fs/ceph/super.h |  2 +-
 3 files changed, 21 insertions(+), 17 deletions(-)

This one fixes the bug that Ilya spotted in ceph_atomic_open. Also,
there is no need to test IS_ERR(dentry) unless we called
ceph_handle_snapdir. Finally, it's probably best not to pass
ceph_finish_lookup an ERR_PTR as a dentry. Reinstate the res pointer and
only reset the dentry pointer if it's valid.

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 5624fae7a603..e78da771ec96 100644
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
@@ -793,12 +791,16 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
-	res = ceph_handle_snapdir(req, dentry, err);
-	if (IS_ERR(res)) {
-		err = PTR_ERR(res);
-	} else {
-		dentry = res;
-		err = 0;
+	if (err == -ENOENT) {
+		struct dentry *res;
+
+		res  = ceph_handle_snapdir(req, dentry);
+		if (IS_ERR(res)) {
+			err = PTR_ERR(res);
+		} else {
+			dentry = res;
+			err = 0;
+		}
 	}
 	dentry = ceph_finish_lookup(req, dentry, err);
 	ceph_mdsc_put_request(req);  /* will dput(dentry) */
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 7aa20d50a231..7c08f864694f 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -739,14 +739,16 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	err = ceph_mdsc_do_request(mdsc,
 				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
 				   req);
-	dentry = ceph_handle_snapdir(req, dentry, err);
-	if (IS_ERR(dentry)) {
-		err = PTR_ERR(dentry);
-		goto out_req;
+	if (err == -ENOENT) {
+		dentry = ceph_handle_snapdir(req, dentry);
+		if (IS_ERR(dentry)) {
+			err = PTR_ERR(dentry);
+			goto out_req;
+		}
+		err = 0;
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

