Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7972529A052
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Oct 2020 01:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409435AbgJZXva (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Oct 2020 19:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409417AbgJZXv2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BABB20878;
        Mon, 26 Oct 2020 23:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756287;
        bh=QSc82sGQQyqNVs6kY8ANMDdfEHxLu6FOkqtGhOBcoBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fb6ivgPpefBzBAjh4aB54+qLWG2jJBsEdG/H1tXrwYLhMUN5ZtUV9druA1GaF0+2r
         pZA+arXF6vFyuLZjVzT4zEy4UbO1fZJT9D7+6Z6g0nIASWbRDx15GUfgLgLTuT223N
         OAqLquiqhmMpKdvkzdr+j0UNvbmvme3l+X43k0M4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 116/147] ceph: encode inodes' parent/d_name in cap reconnect message
Date:   Mon, 26 Oct 2020 19:48:34 -0400
Message-Id: <20201026234905.1022767-116-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: "Yan, Zheng" <zyan@redhat.com>

[ Upstream commit a33f6432b3a63a4909dbbb0967f7c9df8ff2de91 ]

Since nautilus, MDS tracks dirfrags whose child inodes have caps in open
file table. When MDS recovers, it prefetches all of these dirfrags. This
avoids using backtrace to load inodes. But dirfrags prefetch may load
lots of useless inodes into cache, and make MDS run out of memory.

Recent MDS adds an option that disables dirfrags prefetch. When dirfrags
prefetch is disabled. Recovering MDS only prefetches corresponding dir
inodes. Including inodes' parent/d_name in cap reconnect message can
help MDS to load inodes into its cache.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 89 ++++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 28 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4a26862d7667e..76d8d9495d1d4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3612,6 +3612,39 @@ static int send_reconnect_partial(struct ceph_reconnect_state *recon_state)
 	return err;
 }
 
+static struct dentry* d_find_primary(struct inode *inode)
+{
+	struct dentry *alias, *dn = NULL;
+
+	if (hlist_empty(&inode->i_dentry))
+		return NULL;
+
+	spin_lock(&inode->i_lock);
+	if (hlist_empty(&inode->i_dentry))
+		goto out_unlock;
+
+	if (S_ISDIR(inode->i_mode)) {
+		alias = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
+		if (!IS_ROOT(alias))
+			dn = dget(alias);
+		goto out_unlock;
+	}
+
+	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
+		spin_lock(&alias->d_lock);
+		if (!d_unhashed(alias) &&
+		    (ceph_dentry(alias)->flags & CEPH_DENTRY_PRIMARY_LINK)) {
+			dn = dget_dlock(alias);
+		}
+		spin_unlock(&alias->d_lock);
+		if (dn)
+			break;
+	}
+out_unlock:
+	spin_unlock(&inode->i_lock);
+	return dn;
+}
+
 /*
  * Encode information about a cap for a reconnect with the MDS.
  */
@@ -3625,13 +3658,32 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_inode_info *ci = cap->ci;
 	struct ceph_reconnect_state *recon_state = arg;
 	struct ceph_pagelist *pagelist = recon_state->pagelist;
-	int err;
+	struct dentry *dentry;
+	char *path;
+	int pathlen, err;
+	u64 pathbase;
 	u64 snap_follows;
 
 	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
 	     inode, ceph_vinop(inode), cap, cap->cap_id,
 	     ceph_cap_string(cap->issued));
 
+	dentry = d_find_primary(inode);
+	if (dentry) {
+		/* set pathbase to parent dir when msg_version >= 2 */
+		path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
+					    recon_state->msg_version >= 2);
+		dput(dentry);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			goto out_err;
+		}
+	} else {
+		path = NULL;
+		pathlen = 0;
+		pathbase = 0;
+	}
+
 	spin_lock(&ci->i_ceph_lock);
 	cap->seq = 0;        /* reset cap seq */
 	cap->issue_seq = 0;  /* and issue_seq */
@@ -3652,7 +3704,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
 		rec.v2.issued = cpu_to_le32(cap->issued);
 		rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
-		rec.v2.pathbase = 0;
+		rec.v2.pathbase = cpu_to_le64(pathbase);
 		rec.v2.flock_len = (__force __le32)
 			((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
 	} else {
@@ -3663,7 +3715,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
 		ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
 		rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
-		rec.v1.pathbase = 0;
+		rec.v1.pathbase = cpu_to_le64(pathbase);
 	}
 
 	if (list_empty(&ci->i_cap_snaps)) {
@@ -3725,7 +3777,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			    sizeof(struct ceph_filelock);
 		rec.v2.flock_len = cpu_to_le32(struct_len);
 
-		struct_len += sizeof(u32) + sizeof(rec.v2);
+		struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
 
 		if (struct_v >= 2)
 			struct_len += sizeof(u64); /* snap_follows */
@@ -3749,7 +3801,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 			ceph_pagelist_encode_8(pagelist, 1);
 			ceph_pagelist_encode_32(pagelist, struct_len);
 		}
-		ceph_pagelist_encode_string(pagelist, NULL, 0);
+		ceph_pagelist_encode_string(pagelist, path, pathlen);
 		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
 		ceph_locks_to_pagelist(flocks, pagelist,
 				       num_fcntl_locks, num_flock_locks);
@@ -3758,39 +3810,20 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 out_freeflocks:
 		kfree(flocks);
 	} else {
-		u64 pathbase = 0;
-		int pathlen = 0;
-		char *path = NULL;
-		struct dentry *dentry;
-
-		dentry = d_find_alias(inode);
-		if (dentry) {
-			path = ceph_mdsc_build_path(dentry,
-						&pathlen, &pathbase, 0);
-			dput(dentry);
-			if (IS_ERR(path)) {
-				err = PTR_ERR(path);
-				goto out_err;
-			}
-			rec.v1.pathbase = cpu_to_le64(pathbase);
-		}
-
 		err = ceph_pagelist_reserve(pagelist,
 					    sizeof(u64) + sizeof(u32) +
 					    pathlen + sizeof(rec.v1));
-		if (err) {
-			goto out_freepath;
-		}
+		if (err)
+			goto out_err;
 
 		ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
 		ceph_pagelist_encode_string(pagelist, path, pathlen);
 		ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
-out_freepath:
-		ceph_mdsc_free_path(path, pathlen);
 	}
 
 out_err:
-	if (err >= 0)
+	ceph_mdsc_free_path(path, pathlen);
+	if (!err)
 		recon_state->nr_caps++;
 	return err;
 }
-- 
2.25.1

