Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C34F73562
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 19:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfGXR0W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 13:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbfGXR0W (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 13:26:22 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2715C20840
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563988828;
        bh=byGa3lgbUpT7aeqvzaXTJmtOHyq1uGNzmLM1kGZlT5o=;
        h=From:To:Subject:Date:From;
        b=ZLdZoltztEy6PdnyeG+/wINcmZOsb/A+NlAvAQ9chVLir4k22FNBH+MVx43ksO4x/
         AEipCpVjk3eMlsRKOWDxkAfdwYAFrKCUjnUocDmMr553N4Le0ClZNjUTFSyAOQmzx6
         jljLHQhNdMHAgJV0Wp1sbSAbVyiLL5iOT1R1ilxA=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [RFC PATCH] ceph: don't list vxattrs in listxattr()
Date:   Wed, 24 Jul 2019 13:20:26 -0400
Message-Id: <20190724172026.23999-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Most filesystems that provide virtual xattrs (e.g. CIFS) don't display
them via listxattr(). Ceph does, and that causes some of the tests in
xfstests to fail.

Have cephfs stop listing vxattrs in listxattr. Userspace can always
query them directly when the name is known.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 939eab7aa219..2fba06b50f25 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -903,11 +903,9 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
 {
 	struct inode *inode = d_inode(dentry);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_vxattr *vxattrs = ceph_inode_vxattrs(inode);
 	bool len_only = (size == 0);
 	u32 namelen;
 	int err;
-	int i;
 
 	spin_lock(&ci->i_ceph_lock);
 	dout("listxattr %p ver=%lld index_ver=%lld\n", inode,
@@ -936,33 +934,6 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
 		names = __copy_xattr_names(ci, names);
 		size -= namelen;
 	}
-
-
-	/* virtual xattr names, too */
-	if (vxattrs) {
-		for (i = 0; vxattrs[i].name; i++) {
-			size_t this_len;
-
-			if (vxattrs[i].flags & VXATTR_FLAG_HIDDEN)
-				continue;
-			if (vxattrs[i].exists_cb && !vxattrs[i].exists_cb(ci))
-				continue;
-
-			this_len = strlen(vxattrs[i].name) + 1;
-			namelen += this_len;
-			if (len_only)
-				continue;
-
-			if (this_len > size) {
-				err = -ERANGE;
-				goto out;
-			}
-
-			memcpy(names, vxattrs[i].name, this_len);
-			names += this_len;
-			size -= this_len;
-		}
-	}
 	err = namelen;
 out:
 	spin_unlock(&ci->i_ceph_lock);
-- 
2.21.0

