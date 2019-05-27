Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C04E2B2B4
	for <lists+ceph-devel@lfdr.de>; Mon, 27 May 2019 13:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfE0LHI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 May 2019 07:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44185 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfE0LHI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 May 2019 07:07:08 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB13F307D855
        for <ceph-devel@vger.kernel.org>; Mon, 27 May 2019 11:07:07 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-84.pek2.redhat.com [10.72.12.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1E9F60BEC;
        Mon, 27 May 2019 11:07:04 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 1/2] ceph: rename struct ceph_acls_info to ceph_acl_sec_ctx
Date:   Mon, 27 May 2019 19:07:01 +0800
Message-Id: <20190527110702.3962-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 27 May 2019 11:07:07 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

this is preparation for security label support

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/acl.c   | 22 +++++++---------------
 fs/ceph/dir.c   | 28 ++++++++++++++--------------
 fs/ceph/file.c  | 18 +++++++++---------
 fs/ceph/super.h | 29 +++++++++++++++--------------
 fs/ceph/xattr.c | 10 ++++++++++
 5 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index bc2b89e8fd3f..07c8ab39f6c7 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -172,7 +172,7 @@ int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 }
 
 int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
-		       struct ceph_acls_info *info)
+		       struct ceph_acl_sec_ctx *as_ctx)
 {
 	struct posix_acl *acl, *default_acl;
 	size_t val_size1 = 0, val_size2 = 0;
@@ -247,9 +247,9 @@ int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
 
 	kfree(tmp_buf);
 
-	info->acl = acl;
-	info->default_acl = default_acl;
-	info->pagelist = pagelist;
+	as_ctx->acl = acl;
+	as_ctx->default_acl = default_acl;
+	as_ctx->pagelist = pagelist;
 	return 0;
 
 out_err:
@@ -261,18 +261,10 @@ int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
 	return err;
 }
 
-void ceph_init_inode_acls(struct inode* inode, struct ceph_acls_info *info)
+void ceph_init_inode_acls(struct inode* inode, struct ceph_acl_sec_ctx *as_ctx)
 {
 	if (!inode)
 		return;
-	ceph_set_cached_acl(inode, ACL_TYPE_ACCESS, info->acl);
-	ceph_set_cached_acl(inode, ACL_TYPE_DEFAULT, info->default_acl);
-}
-
-void ceph_release_acls_info(struct ceph_acls_info *info)
-{
-	posix_acl_release(info->acl);
-	posix_acl_release(info->default_acl);
-	if (info->pagelist)
-		ceph_pagelist_release(info->pagelist);
+	ceph_set_cached_acl(inode, ACL_TYPE_ACCESS, as_ctx->acl);
+	ceph_set_cached_acl(inode, ACL_TYPE_DEFAULT, as_ctx->default_acl);
 }
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 72efad28857c..14d795e5fa73 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -825,7 +825,7 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
-	struct ceph_acls_info acls = {};
+	struct ceph_acl_sec_ctx as_ctx = {};
 	int err;
 
 	if (ceph_snap(dir) != CEPH_NOSNAP)
@@ -836,7 +836,7 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
 		goto out;
 	}
 
-	err = ceph_pre_init_acls(dir, &mode, &acls);
+	err = ceph_pre_init_acls(dir, &mode, &as_ctx);
 	if (err < 0)
 		goto out;
 
@@ -855,9 +855,9 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
-	if (acls.pagelist) {
-		req->r_pagelist = acls.pagelist;
-		acls.pagelist = NULL;
+	if (as_ctx.pagelist) {
+		req->r_pagelist = as_ctx.pagelist;
+		as_ctx.pagelist = NULL;
 	}
 	err = ceph_mdsc_do_request(mdsc, dir, req);
 	if (!err && !req->r_reply_info.head->is_dentry)
@@ -865,10 +865,10 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
 	ceph_mdsc_put_request(req);
 out:
 	if (!err)
-		ceph_init_inode_acls(d_inode(dentry), &acls);
+		ceph_init_inode_acls(d_inode(dentry), &as_ctx);
 	else
 		d_drop(dentry);
-	ceph_release_acls_info(&acls);
+	ceph_release_acl_sec_ctx(&as_ctx);
 	return err;
 }
 
@@ -927,7 +927,7 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
-	struct ceph_acls_info acls = {};
+	struct ceph_acl_sec_ctx as_ctx = {};
 	int err = -EROFS;
 	int op;
 
@@ -950,7 +950,7 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	}
 
 	mode |= S_IFDIR;
-	err = ceph_pre_init_acls(dir, &mode, &acls);
+	err = ceph_pre_init_acls(dir, &mode, &as_ctx);
 	if (err < 0)
 		goto out;
 
@@ -967,9 +967,9 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
-	if (acls.pagelist) {
-		req->r_pagelist = acls.pagelist;
-		acls.pagelist = NULL;
+	if (as_ctx.pagelist) {
+		req->r_pagelist = as_ctx.pagelist;
+		as_ctx.pagelist = NULL;
 	}
 	err = ceph_mdsc_do_request(mdsc, dir, req);
 	if (!err &&
@@ -979,10 +979,10 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	ceph_mdsc_put_request(req);
 out:
 	if (!err)
-		ceph_init_inode_acls(d_inode(dentry), &acls);
+		ceph_init_inode_acls(d_inode(dentry), &as_ctx);
 	else
 		d_drop(dentry);
-	ceph_release_acls_info(&acls);
+	ceph_release_acl_sec_ctx(&as_ctx);
 	return err;
 }
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index b7be02dfb897..5975345753d7 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -436,7 +436,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
 	struct dentry *dn;
-	struct ceph_acls_info acls = {};
+	struct ceph_acl_sec_ctx as_ctx = {};
 	int mask;
 	int err;
 
@@ -450,7 +450,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
-		err = ceph_pre_init_acls(dir, &mode, &acls);
+		err = ceph_pre_init_acls(dir, &mode, &as_ctx);
 		if (err < 0)
 			return err;
 	}
@@ -459,16 +459,16 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	req = prepare_open_request(dir->i_sb, flags, mode);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
-		goto out_acl;
+		goto out_ctx;
 	}
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	if (flags & O_CREAT) {
 		req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 		req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
-		if (acls.pagelist) {
-			req->r_pagelist = acls.pagelist;
-			acls.pagelist = NULL;
+		if (as_ctx.pagelist) {
+			req->r_pagelist = as_ctx.pagelist;
+			as_ctx.pagelist = NULL;
 		}
 	}
 
@@ -506,7 +506,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	} else {
 		dout("atomic_open finish_open on dn %p\n", dn);
 		if (req->r_op == CEPH_MDS_OP_CREATE && req->r_reply_info.has_create_ino) {
-			ceph_init_inode_acls(d_inode(dentry), &acls);
+			ceph_init_inode_acls(d_inode(dentry), &as_ctx);
 			file->f_mode |= FMODE_CREATED;
 		}
 		err = finish_open(file, dentry, ceph_open);
@@ -515,8 +515,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (!req->r_err && req->r_target_inode)
 		ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode);
 	ceph_mdsc_put_request(req);
-out_acl:
-	ceph_release_acls_info(&acls);
+out_ctx:
+	ceph_release_acl_sec_ctx(&as_ctx);
 	dout("atomic_open result=%d\n", err);
 	return err;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index e74867743e07..d7520ccf27e9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -928,6 +928,14 @@ extern void __ceph_build_xattrs_blob(struct ceph_inode_info *ci);
 extern void __ceph_destroy_xattrs(struct ceph_inode_info *ci);
 extern const struct xattr_handler *ceph_xattr_handlers[];
 
+struct ceph_acl_sec_ctx {
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	void *default_acl;
+	void *acl;
+#endif
+	struct ceph_pagelist *pagelist;
+};
+
 #ifdef CONFIG_SECURITY
 extern bool ceph_security_xattr_deadlock(struct inode *in);
 extern bool ceph_security_xattr_wanted(struct inode *in);
@@ -942,21 +950,17 @@ static inline bool ceph_security_xattr_wanted(struct inode *in)
 }
 #endif
 
-/* acl.c */
-struct ceph_acls_info {
-	void *default_acl;
-	void *acl;
-	struct ceph_pagelist *pagelist;
-};
+void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx);
 
+/* acl.c */
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 
 struct posix_acl *ceph_get_acl(struct inode *, int);
 int ceph_set_acl(struct inode *inode, struct posix_acl *acl, int type);
 int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
-		       struct ceph_acls_info *info);
-void ceph_init_inode_acls(struct inode *inode, struct ceph_acls_info *info);
-void ceph_release_acls_info(struct ceph_acls_info *info);
+		       struct ceph_acl_sec_ctx *as_ctx);
+void ceph_init_inode_acls(struct inode *inode,
+			  struct ceph_acl_sec_ctx *as_ctx);
 
 static inline void ceph_forget_all_cached_acls(struct inode *inode)
 {
@@ -969,15 +973,12 @@ static inline void ceph_forget_all_cached_acls(struct inode *inode)
 #define ceph_set_acl NULL
 
 static inline int ceph_pre_init_acls(struct inode *dir, umode_t *mode,
-				     struct ceph_acls_info *info)
+				     struct ceph_acl_sec_ctx *as_ctx)
 {
 	return 0;
 }
 static inline void ceph_init_inode_acls(struct inode *inode,
-					struct ceph_acls_info *info)
-{
-}
-static inline void ceph_release_acls_info(struct ceph_acls_info *info)
+					struct ceph_acl_sec_ctx *as_ctx)
 {
 }
 static inline int ceph_acl_chmod(struct dentry *dentry, struct inode *inode)
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 7eff619f7ac8..518a5beed58c 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1197,3 +1197,13 @@ bool ceph_security_xattr_deadlock(struct inode *in)
 	return ret;
 }
 #endif
+
+void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx)
+{
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	posix_acl_release(as_ctx->acl);
+	posix_acl_release(as_ctx->default_acl);
+#endif
+	if (as_ctx->pagelist)
+		ceph_pagelist_release(as_ctx->pagelist);
+}
-- 
2.17.2

