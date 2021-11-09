Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3593244B1C4
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 18:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhKIRM7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Nov 2021 12:12:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231550AbhKIRM6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 12:12:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E15261186;
        Tue,  9 Nov 2021 17:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636477812;
        bh=G2mvPdhdTLytfZxJlfG7Llc7s/zTrudA8F9eyK9fn1E=;
        h=From:To:Cc:Subject:Date:From;
        b=AdkEubQ26MxJ2RXrlOP1bmP+6M1QXf5qKV5RVWy+3QmFED2mo59DNN0aMNI8fcG+3
         2DunPAGtQoGAjGZjiD2oL57cRgBw6LAX96E8XMKprnfsA8ceWtiklS0qNacy/REAxN
         D/ngo4EOag8fhAet4jwCooxsGVkoOEbl1hHEZXLIjcgdEcdJzPmIW0nHkFXfoWNOgb
         nE3xLiUk0J84cmjOEYSgcQbMCo8VHXeEvjkqhBruHxsIU4n9yoGjpWLWHtZfrvmJGW
         7PdLDgLQNzgZ7n09ldjvIietAfohcyTHzk+Qb8x1CaKwdf+SWisOrLNb5VZT00QfjE
         HGd/8N5WCgOrQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de
Subject: [PATCH] ceph: don't check for quotas on MDS stray dirs
Date:   Tue,  9 Nov 2021 12:10:11 -0500
Message-Id: <20211109171011.39571-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

玮文 胡 reported seeing the WARN_RATELIMITED pop when writing to an
inode that had been transplanted into the stray dir. The client was
trying to look up the quotarealm info from the parent and that tripped
the warning.

Change the ceph_vino_is_reserved helper to not throw a warning and
add a new ceph_vino_warn_reserved() helper that does. Change all of the
existing callsites to call the "warn" variant, and have
ceph_has_realms_with_quotas check return false when the vino is
reserved.

URL: https://tracker.ceph.com/issues/53180
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/export.c |  4 ++--
 fs/ceph/inode.c  |  2 +-
 fs/ceph/quota.c  |  3 +++
 fs/ceph/super.h  | 17 ++++++++++-------
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index e0fa66ac8b9f..a75cf07d668f 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -130,7 +130,7 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
 	vino.ino = ino;
 	vino.snap = CEPH_NOSNAP;
 
-	if (ceph_vino_is_reserved(vino))
+	if (ceph_vino_warn_reserved(vino))
 		return ERR_PTR(-ESTALE);
 
 	inode = ceph_find_inode(sb, vino);
@@ -224,7 +224,7 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
 		vino.snap = sfh->snapid;
 	}
 
-	if (ceph_vino_is_reserved(vino))
+	if (ceph_vino_warn_reserved(vino))
 		return ERR_PTR(-ESTALE);
 
 	inode = ceph_find_inode(sb, vino);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e8eb8612ddd6..a685fab56772 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -56,7 +56,7 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
 {
 	struct inode *inode;
 
-	if (ceph_vino_is_reserved(vino))
+	if (ceph_vino_warn_reserved(vino))
 		return ERR_PTR(-EREMOTEIO);
 
 	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 620c691af40e..d1158c40bb0c 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -30,6 +30,9 @@ static inline bool ceph_has_realms_with_quotas(struct inode *inode)
 	/* if root is the real CephFS root, we don't have quota realms */
 	if (root && ceph_ino(root) == CEPH_INO_ROOT)
 		return false;
+	/* MDS stray dirs have no quota realms */
+	if (ceph_vino_is_reserved(ceph_inode(inode)->i_vino))
+		return false;
 	/* otherwise, we can't know for sure */
 	return true;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ed51e04739c4..c232ed8e8a37 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -547,18 +547,21 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
 
 static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
 {
-	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
-	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
-		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
-		return true;
-	}
-	return false;
+	return vino.ino < CEPH_INO_SYSTEM_BASE &&
+	       vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET;
+}
+
+static inline bool ceph_vino_warn_reserved(const struct ceph_vino vino)
+{
+	return WARN_RATELIMIT(ceph_vino_is_reserved(vino),
+				"Attempt to access reserved inode number 0x%llx",
+				vino.ino);
 }
 
 static inline struct inode *ceph_find_inode(struct super_block *sb,
 					    struct ceph_vino vino)
 {
-	if (ceph_vino_is_reserved(vino))
+	if (ceph_vino_warn_reserved(vino))
 		return NULL;
 
 	/*
-- 
2.33.1

