Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759233AD159
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Jun 2021 19:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhFRRmK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Jun 2021 13:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231685AbhFRRmK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 18 Jun 2021 13:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FD4161261;
        Fri, 18 Jun 2021 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624038000;
        bh=akmXLvDTqN22m+5SWXns3XhUa6Vqj/swBhSvqQs9a5E=;
        h=From:To:Cc:Subject:Date:From;
        b=IFzS7SpBMyNsC1/1f0NvAo0O9du2by5TFEWumK/K4GunmcAzjbcrnqjVLJmbCFx4o
         wM5D/8N3gRyiNhwJiWuUzetSNdEHl35+LRE3VytxLOdp1cH2ZGmldHqIJ617njUt/2
         ML3XCafv/E7kWMqSiwPBKjzJyfSMMb5rCmduSZ1KTMMrAAH42sXmnsVxb5005GTBaH
         4aH9bhaZhYMDBtpMNtZ0chfC6T3Qv8WEv+ke1zS9WsXP93HVSlJpJ7Ra0BvTa5d69L
         lA9y5j5mFv7zYSSwq+D5i9z36dUlMvDxG0tBqVWnSvoYIXBndAbBt/4rQUzoIJgXj7
         KMvBYcj96Pjzg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: take reference to req->r_parent at point of assignment
Date:   Fri, 18 Jun 2021 13:39:59 -0400
Message-Id: <20210618173959.13998-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, we set the r_parent pointer but then don't take a reference
to it until we submit the request. If we end up freeing the req before
that point, then we'll do a iput when we shouldn't.

Instead, take the inode reference in the callers, so that it's always
safe to call ceph_mdsc_put_request on the req, even before submission.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c        | 9 +++++++++
 fs/ceph/export.c     | 1 +
 fs/ceph/file.c       | 1 +
 fs/ceph/mds_client.c | 1 -
 4 files changed, 11 insertions(+), 1 deletion(-)

Note that this isn't a problem with the existing code, because we never
put the last reference before submission, but with the coming fscrypt
patchset, we can end up doing this and this becomes a problem. With ths
change, a set r_parent field means a reference *was* taken.

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index bd508b1aeac2..a656c5c00e65 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -788,6 +788,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 		mask |= CEPH_CAP_XATTR_SHARED;
 	req->r_args.getattr.mask = cpu_to_le32(mask);
 
+	ihold(dir);
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
@@ -861,6 +862,7 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
+	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_args.mknod.mode = cpu_to_le32(mode);
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
@@ -922,6 +924,8 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 		goto out;
 	}
 	req->r_parent = dir;
+	ihold(dir);
+
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
@@ -986,6 +990,7 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
+	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
@@ -1030,6 +1035,7 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
 	req->r_num_caps = 2;
 	req->r_old_dentry = dget(old_dentry);
 	req->r_parent = dir;
+	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
@@ -1151,6 +1157,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
+	ihold(dir);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 	req->r_inode_drop = ceph_drop_caps_for_unlink(inode);
@@ -1225,6 +1232,7 @@ static int ceph_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	req->r_old_dentry = dget(old_dentry);
 	req->r_old_dentry_dir = old_dir;
 	req->r_parent = new_dir;
+	ihold(new_dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_old_dentry_drop = CEPH_CAP_FILE_SHARED;
 	req->r_old_dentry_unless = CEPH_CAP_FILE_EXCL;
@@ -1721,6 +1729,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 			req->r_dentry = dget(dentry);
 			req->r_num_caps = 2;
 			req->r_parent = dir;
+			ihold(dir);
 
 			mask = CEPH_STAT_CAP_INODE | CEPH_CAP_AUTH_SHARED;
 			if (ceph_security_xattr_wanted(dir))
diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 65540a4429b2..1d65934c1262 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -542,6 +542,7 @@ static int ceph_get_name(struct dentry *parent, char *name,
 	ihold(inode);
 	req->r_ino2 = ceph_vino(d_inode(parent));
 	req->r_parent = d_inode(parent);
+	ihold(req->r_parent);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_num_caps = 2;
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d3874c2df4b1..c8fd11cf4510 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -706,6 +706,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		mask |= CEPH_CAP_XATTR_SHARED;
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
+	ihold(dir);
 
 	if (flags & O_CREAT) {
 		struct ceph_file_layout lo;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c03098c58be3..52ae5373437d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2983,7 +2983,6 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 		ceph_take_cap_refs(ci, CEPH_CAP_PIN, false);
 		__ceph_touch_fmode(ci, mdsc, fmode);
 		spin_unlock(&ci->i_ceph_lock);
-		ihold(req->r_parent);
 	}
 	if (req->r_old_dentry_dir)
 		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
-- 
2.31.1

