Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2362F484300
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiADOE7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60464 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiADOE5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B5ACB81616
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EFEC36AEF;
        Tue,  4 Jan 2022 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305095;
        bh=8e4epHakb3Xtslr0Q2NnZCutAr62cneMBxY2UNssPZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqw5CU1LnoJip9BKN35RpkPwumG3GCjwclE2LC5p9iMWNQyV3KcuPy4fWXihwQcWg
         sT4lm56ieUnXkDJtbU0jwJOAOSo4qXF+TarA0ss1Ss0IolBvL8DaDSF0UqQShmoWpO
         02GnllNa4HF22/TdlAucFu8QcObQPE4YL4RtA0DN1etjqFFGfrUj0dL00tetQyl8rF
         g20IqR/eSEicKeDFXFEmHG7NjfYYtMzKwa5re6VG66lF4tujQ/4Gj2T57pXikIbE5F
         7ETiYgyDeJ5Mmgo2fZ+i9dGSMK+FPYY4FDiG6NUjFKlit/pNBbpZP8cL309q/deLzS
         2C4uOyzd9rL9g==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 11/12] ceph/file: allow idmapped atomic_open inode op
Date:   Tue,  4 Jan 2022 15:04:13 +0100
Message-Id: <20220104140414.155198-12-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2448; h=from:subject; bh=3buUJvV9QWGh6sToQAqdVcg0nOBmUpDfSZr6VVRzOtI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd6c+m79jvnh/44Gz7iR7rP/hvPE0kUdUY3J5++E3Pru 4jLHp6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiB+QY/vs3P7/ps7E+JMOWl1luka Rc/0mZmDcHmos/1dmZsnNsAKpIaU3dv6bmnqe0efSdq82P161xXHhknr/tIeYbJhpfjM1YAA==
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_atomic_open() to handle idmapped mounts. This is just a
matter of passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/file.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c138e8126286..7fecb41796c7 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -608,7 +608,10 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	in.truncate_seq = cpu_to_le32(1);
 	in.truncate_size = cpu_to_le64(-1ULL);
 	in.xattr_version = cpu_to_le64(1);
-	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
+	in.uid = cpu_to_le32(from_kuid(&init_user_ns,
+				       mapped_kuid_user(req->mnt_userns,
+							&init_user_ns,
+							current_fsuid())));
 	if (dir->i_mode & S_ISGID) {
 		in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_gid));
 
@@ -616,11 +619,14 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
-			 !in_group_p(dir->i_gid) &&
-			 !capable_wrt_inode_uidgid(&init_user_ns, dir, CAP_FSETID))
+			 !in_group_p(i_gid_into_mnt(req->mnt_userns, dir)) &&
+			 !capable_wrt_inode_uidgid(req->mnt_userns, dir, CAP_FSETID))
 			mode &= ~S_ISGID;
 	} else {
-		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
+		in.gid = cpu_to_le32(from_kgid(&init_user_ns,
+				     mapped_kgid_user(req->mnt_userns,
+						      &init_user_ns,
+						      current_fsgid())));
 	}
 	in.mode = cpu_to_le32((u32)mode);
 
@@ -677,6 +683,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		     struct file *file, unsigned flags, umode_t mode)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
+	struct user_namespace *mnt_userns = file_mnt_user_ns(file);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
 	struct dentry *dn;
@@ -719,6 +726,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		mask |= CEPH_CAP_XATTR_SHARED;
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
+	req->mnt_userns = mnt_userns;
 	ihold(dir);
 
 	if (flags & O_CREAT) {
-- 
2.32.0

