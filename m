Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB812B2B5
	for <lists+ceph-devel@lfdr.de>; Mon, 27 May 2019 13:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfE0LHO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 May 2019 07:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfE0LHO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 May 2019 07:07:14 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 34C7430842D1
        for <ceph-devel@vger.kernel.org>; Mon, 27 May 2019 11:07:13 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-84.pek2.redhat.com [10.72.12.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7628860BEC;
        Mon, 27 May 2019 11:07:08 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 2/2] ceph: add selinux support
Date:   Mon, 27 May 2019 19:07:02 +0800
Message-Id: <20190527110702.3962-2-zyan@redhat.com>
In-Reply-To: <20190527110702.3962-1-zyan@redhat.com>
References: <20190527110702.3962-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 27 May 2019 11:07:13 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When creating new file/directory, uses dentry_init_security() to prepare
selinux context for the new inode, then sends openc/mkdir request to MDS,
together with selinux xattr.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/Kconfig |  12 +++++
 fs/ceph/caps.c  |   1 +
 fs/ceph/dir.c   |  12 +++++
 fs/ceph/file.c  |   3 ++
 fs/ceph/inode.c |   1 +
 fs/ceph/super.h |  19 +++++++
 fs/ceph/xattr.c | 141 ++++++++++++++++++++++++++++++++++++++++++------
 7 files changed, 172 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 52095f473464..5a665c126a7c 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -35,3 +35,15 @@ config CEPH_FS_POSIX_ACL
 	  groups beyond the owner/group/world scheme.
 
 	  If you don't know what Access Control Lists are, say N
+
+config CEPH_FS_SECURITY_LABEL
+	bool "CephFS Security Labels"
+	depends on CEPH_FS && SECURITY
+	help
+	  Security labels support alternative access control models
+	  implemented by security modules like SELinux. This option
+	  enables an extended attribute handler for file security
+	  labels in the Ceph filesystem.
+
+	  If you are not using a security module that requires using
+	  extended attributes for file security labels, say N.
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7754d7679122..50409d9fdc90 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3156,6 +3156,7 @@ static void handle_cap_grant(struct inode *inode,
 			ci->i_xattrs.blob = ceph_buffer_get(xattr_buf);
 			ci->i_xattrs.version = version;
 			ceph_forget_all_cached_acls(inode);
+			ceph_security_invalidate_secctx(inode);
 		}
 	}
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 14d795e5fa73..b282d076dc9e 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -839,6 +839,9 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
 	err = ceph_pre_init_acls(dir, &mode, &as_ctx);
 	if (err < 0)
 		goto out;
+	err = ceph_security_init_secctx(dentry, mode, &as_ctx);
+	if (err < 0)
+	       goto out;
 
 	dout("mknod in dir %p dentry %p mode 0%ho rdev %d\n",
 	     dir, dentry, mode, rdev);
@@ -884,6 +887,7 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
+	struct ceph_acl_sec_ctx as_ctx = {};
 	int err;
 
 	if (ceph_snap(dir) != CEPH_NOSNAP)
@@ -894,6 +898,10 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
 		goto out;
 	}
 
+	err = ceph_security_init_secctx(dentry, S_IFLNK | S_IRWXUGO, &as_ctx);
+	if (err < 0)
+	       goto out;
+
 	dout("symlink in dir %p dentry %p to '%s'\n", dir, dentry, dest);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_SYMLINK, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
@@ -919,6 +927,7 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
 out:
 	if (err)
 		d_drop(dentry);
+	ceph_release_acl_sec_ctx(&as_ctx);
 	return err;
 }
 
@@ -953,6 +962,9 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	err = ceph_pre_init_acls(dir, &mode, &as_ctx);
 	if (err < 0)
 		goto out;
+	err = ceph_security_init_secctx(dentry, mode, &as_ctx);
+	if (err < 0)
+	       goto out;
 
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 5975345753d7..a7080783fe20 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -453,6 +453,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		err = ceph_pre_init_acls(dir, &mode, &as_ctx);
 		if (err < 0)
 			return err;
+		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
+		if (err < 0)
+			goto out_ctx;
 	}
 
 	/* do the open */
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 30d0cdc21035..125ac54b5841 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -891,6 +891,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 			       iinfo->xattr_data, iinfo->xattr_len);
 		ci->i_xattrs.version = le64_to_cpu(info->xattr_version);
 		ceph_forget_all_cached_acls(inode);
+		ceph_security_invalidate_secctx(inode);
 		xattr_blob = NULL;
 	}
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d7520ccf27e9..9c82d213a5ab 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -932,6 +932,10 @@ struct ceph_acl_sec_ctx {
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 	void *default_acl;
 	void *acl;
+#endif
+#ifdef CONFIG_CEPH_FS_SECURITY_LABEL
+	void *sec_ctx;
+	u32 sec_ctxlen;
 #endif
 	struct ceph_pagelist *pagelist;
 };
@@ -950,6 +954,21 @@ static inline bool ceph_security_xattr_wanted(struct inode *in)
 }
 #endif
 
+#ifdef CONFIG_CEPH_FS_SECURITY_LABEL
+extern int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
+				     struct ceph_acl_sec_ctx *ctx);
+extern void ceph_security_invalidate_secctx(struct inode *inode);
+#else
+static inline int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
+					    struct ceph_acl_sec_ctx *ctx)
+{
+	return 0;
+}
+static inline void ceph_security_invalidate_secctx(struct inode *inode)
+{
+}
+#endif
+
 void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx);
 
 /* acl.c */
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 518a5beed58c..fea70696f375 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -8,6 +8,7 @@
 #include <linux/ceph/decode.h>
 
 #include <linux/xattr.h>
+#include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/slab.h>
 
@@ -17,26 +18,9 @@
 static int __remove_xattr(struct ceph_inode_info *ci,
 			  struct ceph_inode_xattr *xattr);
 
-static const struct xattr_handler ceph_other_xattr_handler;
-
-/*
- * List of handlers for synthetic system.* attributes. Other
- * attributes are handled directly.
- */
-const struct xattr_handler *ceph_xattr_handlers[] = {
-#ifdef CONFIG_CEPH_FS_POSIX_ACL
-	&posix_acl_access_xattr_handler,
-	&posix_acl_default_xattr_handler,
-#endif
-	&ceph_other_xattr_handler,
-	NULL,
-};
-
 static bool ceph_is_valid_xattr(const char *name)
 {
 	return !strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) ||
-	       !strncmp(name, XATTR_SECURITY_PREFIX,
-			XATTR_SECURITY_PREFIX_LEN) ||
 	       !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
 	       !strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 }
@@ -1196,6 +1180,110 @@ bool ceph_security_xattr_deadlock(struct inode *in)
 	spin_unlock(&ci->i_ceph_lock);
 	return ret;
 }
+
+#ifdef CONFIG_CEPH_FS_SECURITY_LABEL
+int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
+			   struct ceph_acl_sec_ctx *as_ctx)
+{
+	struct ceph_pagelist *pagelist = as_ctx->pagelist;
+	const char *name;
+	size_t name_len;
+	int err;
+
+	err = security_dentry_init_security(dentry, mode, &dentry->d_name,
+					    &as_ctx->sec_ctx,
+					    &as_ctx->sec_ctxlen);
+	if (err < 0) {
+		err = 0; /* do nothing */
+		goto out;
+	}
+
+	err = -ENOMEM;
+	if (!pagelist) {
+		pagelist = ceph_pagelist_alloc(GFP_KERNEL);
+		if (!pagelist)
+			goto out;
+		err = ceph_pagelist_reserve(pagelist, PAGE_SIZE);
+		if (err)
+			goto out;
+		ceph_pagelist_encode_32(pagelist, 1);
+	}
+
+	/*
+	 * FIXME: Make security_dentry_init_security() generic. Currently
+	 * It only supports single security module and only selinux has
+	 * dentry_init_security hook.
+	 */
+	name = XATTR_NAME_SELINUX;
+	name_len = strlen(name);
+	err = ceph_pagelist_reserve(pagelist,
+				    4 * 2 + name_len + as_ctx->sec_ctxlen);
+	if (err)
+		goto out;
+
+	if (as_ctx->pagelist) {
+		/* update count of KV pairs */
+		BUG_ON(pagelist->length <= sizeof(__le32));
+		if (list_is_singular(&pagelist->head)) {
+			le32_add_cpu((__le32*)pagelist->mapped_tail, 1);
+		} else {
+			struct page *page = list_first_entry(&pagelist->head,
+							     struct page, lru);
+			void *addr = kmap_atomic(page);
+			le32_add_cpu((__le32*)addr, 1);
+			kunmap_atomic(addr);
+		}
+	} else {
+		as_ctx->pagelist = pagelist;
+	}
+
+	ceph_pagelist_encode_32(pagelist, name_len);
+	ceph_pagelist_append(pagelist, name, name_len);
+
+	ceph_pagelist_encode_32(pagelist, as_ctx->sec_ctxlen);
+	ceph_pagelist_append(pagelist, as_ctx->sec_ctx, as_ctx->sec_ctxlen);
+
+	err = 0;
+out:
+	if (pagelist && !as_ctx->pagelist)
+		ceph_pagelist_release(pagelist);
+	return err;
+}
+
+void ceph_security_invalidate_secctx(struct inode *inode)
+{
+	security_inode_invalidate_secctx(inode);
+}
+
+static int ceph_xattr_set_security_label(const struct xattr_handler *handler,
+				    struct dentry *unused, struct inode *inode,
+				    const char *key, const void *buf,
+				    size_t buflen, int flags)
+{
+	if (security_ismaclabel(key)) {
+		const char *name = xattr_full_name(handler, key);
+		return __ceph_setxattr(inode, name, buf, buflen, flags);
+	}
+	return  -EOPNOTSUPP;
+}
+
+static int ceph_xattr_get_security_label(const struct xattr_handler *handler,
+				    struct dentry *unused, struct inode *inode,
+				    const char *key, void *buf, size_t buflen)
+{
+        if (security_ismaclabel(key)) {
+		const char *name = xattr_full_name(handler, key);
+		return __ceph_getxattr(inode, name, buf, buflen);
+	}
+	return  -EOPNOTSUPP;
+}
+
+static const struct xattr_handler ceph_security_label_handler = {
+        .prefix = XATTR_SECURITY_PREFIX,
+        .get    = ceph_xattr_get_security_label,
+        .set    = ceph_xattr_set_security_label,
+};
+#endif
 #endif
 
 void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx)
@@ -1203,7 +1291,26 @@ void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx)
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 	posix_acl_release(as_ctx->acl);
 	posix_acl_release(as_ctx->default_acl);
+#endif
+#ifdef CONFIG_CEPH_FS_SECURITY_LABEL
+	security_release_secctx(as_ctx->sec_ctx, as_ctx->sec_ctxlen);
 #endif
 	if (as_ctx->pagelist)
 		ceph_pagelist_release(as_ctx->pagelist);
 }
+
+/*
+ * List of handlers for synthetic system.* attributes. Other
+ * attributes are handled directly.
+ */
+const struct xattr_handler *ceph_xattr_handlers[] = {
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
+#endif
+#ifdef CONFIG_CEPH_FS_SECURITY_LABEL
+	&ceph_security_label_handler,
+#endif
+	&ceph_other_xattr_handler,
+	NULL,
+};
-- 
2.17.2

