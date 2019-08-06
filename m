Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD24F83848
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 19:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfHFR5l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 13:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfHFR5l (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 13:57:41 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C285208C3;
        Tue,  6 Aug 2019 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565114260;
        bh=tSwF+zUrR9hT0SOEEByGfafbgxLbeS2j/ahwOqHWZ8A=;
        h=From:To:Cc:Subject:Date:From;
        b=cbz2VwhoDMZ1DwiU1mW2tcbWLwnOjBx8MleRwkgOlobA+mgXKuwNKhaYjIUneXuLP
         4S7VToy5qV0HnMnGmrN95x7ePb9u5OsG2wxbP+rqIgpbOFcHUkmM0qM3sIW7Y8+zOL
         g0AXtL5O0IlrNzan9bi2O21gIiQIGbkC8vULpMSA=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH] ceph: turn ceph_security_invalidate_secctx into static inline
Date:   Tue,  6 Aug 2019 13:57:38 -0400
Message-Id: <20190806175738.5407-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

No need to do an extra jump here. Also add some comments on the endifs.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.h | 5 ++++-
 fs/ceph/xattr.c | 9 ++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 98d7190289c8..bb5d02c2cd4d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -971,7 +971,10 @@ static inline bool ceph_security_xattr_wanted(struct inode *in)
 #ifdef CONFIG_CEPH_FS_SECURITY_LABEL
 extern int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 				     struct ceph_acl_sec_ctx *ctx);
-extern void ceph_security_invalidate_secctx(struct inode *inode);
+static inline void ceph_security_invalidate_secctx(struct inode *inode)
+{
+	security_inode_invalidate_secctx(inode);
+}
 #else
 static inline int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 					    struct ceph_acl_sec_ctx *ctx)
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 2fba06b50f25..5c608caf0190 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1265,11 +1265,6 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
 	return err;
 }
 
-void ceph_security_invalidate_secctx(struct inode *inode)
-{
-	security_inode_invalidate_secctx(inode);
-}
-
 static int ceph_xattr_set_security_label(const struct xattr_handler *handler,
 				    struct dentry *unused, struct inode *inode,
 				    const char *key, const void *buf,
@@ -1298,8 +1293,8 @@ static const struct xattr_handler ceph_security_label_handler = {
 	.get    = ceph_xattr_get_security_label,
 	.set    = ceph_xattr_set_security_label,
 };
-#endif
-#endif
+#endif /* CONFIG_CEPH_FS_SECURITY_LABEL */
+#endif /* CONFIG_SECURITY */
 
 void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx)
 {
-- 
2.21.0

