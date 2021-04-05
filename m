Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C45635418A
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Apr 2021 13:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhDELdD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Apr 2021 07:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233431AbhDELdC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 07:33:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF1A613AD;
        Mon,  5 Apr 2021 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617622376;
        bh=K8ymqToOUOfJuMFEPg+WxUd22LBku4EBSed0Z04Qwkg=;
        h=From:To:Cc:Subject:Date:From;
        b=vMlqI2Gl0Rm7NtJYAlS9ON3N71fwGuIr1Z4nse/LYj2haoPSjW4KaPkjyRcg2Os6m
         d5ixoi/u6pkZmyETV3SRFAMk9P4rGUiClOUvvajKvmVXtzP46FDHjbGlbDyYTULi+l
         WuwWMCeZ/WERqQLSGB/UNqv4frK/jc3EdGjdmW+oYIqU/vMbCoxBM5SicK5EAIAX7p
         hjHKQoSMCcunaLWJQQWiqw71BirZBIS50gC781WG5UqVJb1O+Efmw/A5Inx9xCRCYp
         bxzTFo1Fyate7HAQwX+rtaX3x5xUt7pIwZB6UEVPQIeE8OK+/llh0ha0OFLjLoafci
         e6sS398m6h/Ig==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com
Subject: [PATCH] ceph: don't allow access to MDS-private inodes
Date:   Mon,  5 Apr 2021 07:32:54 -0400
Message-Id: <20210405113254.8085-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The MDS reserves a set of inodes for its own usage, and these should
never be accessible to clients. Add a new helper to vet a proposed
inode number against that range, and complain loudly and refuse to
create or look it up if it's in it.

Also, ensure that the MDS doesn't try to delegate that range to us
either. Print a warning if it does, and don't save the range in the
xarray.

URL: https://tracker.ceph.com/issues/49922
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/export.c     |  8 ++++++++
 fs/ceph/inode.c      |  3 +++
 fs/ceph/mds_client.c |  7 +++++++
 fs/ceph/super.h      | 22 ++++++++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 17d8c8f4ec89..65540a4429b2 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -129,6 +129,10 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
 
 	vino.ino = ino;
 	vino.snap = CEPH_NOSNAP;
+
+	if (ceph_vino_is_reserved(vino))
+		return ERR_PTR(-ESTALE);
+
 	inode = ceph_find_inode(sb, vino);
 	if (!inode) {
 		struct ceph_mds_request *req;
@@ -214,6 +218,10 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
 		vino.ino = sfh->ino;
 		vino.snap = sfh->snapid;
 	}
+
+	if (ceph_vino_is_reserved(vino))
+		return ERR_PTR(-ESTALE);
+
 	inode = ceph_find_inode(sb, vino);
 	if (inode)
 		return d_obtain_alias(inode);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2c512475c170..3f321ba801f1 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -56,6 +56,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
 {
 	struct inode *inode;
 
+	if (ceph_vino_is_reserved(vino))
+		return ERR_PTR(-EREMOTEIO);
+
 	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
 			     ceph_set_ino_cb, &vino);
 	if (!inode)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 73ecb7d128c9..2d7dcd295bb9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -433,6 +433,13 @@ static int ceph_parse_deleg_inos(void **p, void *end,
 
 		ceph_decode_64_safe(p, end, start, bad);
 		ceph_decode_64_safe(p, end, len, bad);
+
+		/* Don't accept a delegation of system inodes */
+		if (start < CEPH_INO_SYSTEM_BASE) {
+			pr_warn_ratelimited("ceph: ignoring reserved inode range delegation (start=0x%llx len=0x%llx)\n",
+					start, len);
+			continue;
+		}
 		while (len--) {
 			int err = xa_insert(&s->s_delegated_inos, ino = start++,
 					    DELEGATED_INO_AVAILABLE,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 5e0e1aeee1b5..1fe4cf385481 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -529,10 +529,32 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
 		ci->i_vino.snap == pvino->snap;
 }
 
+/*
+ * The MDS reserves a set of inodes for its own usage. These should never
+ * be accessible by clients, and so the MDS has no reason to ever hand these
+ * out.
+ *
+ * These come from src/mds/mdstypes.h in the ceph sources.
+ */
+#define CEPH_MAX_MDS		0x100
+#define CEPH_NUM_STRAY		10
+#define CEPH_INO_SYSTEM_BASE	((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
+
+static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
+{
+	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT) {
+		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
+		return true;
+	}
+	return false;
+}
 
 static inline struct inode *ceph_find_inode(struct super_block *sb,
 					    struct ceph_vino vino)
 {
+	if (ceph_vino_is_reserved(vino))
+		return NULL;
+
 	/*
 	 * NB: The hashval will be run through the fs/inode.c hash function
 	 * anyway, so there is no need to squash the inode number down to
-- 
2.30.2

