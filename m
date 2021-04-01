Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B26635207B
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Apr 2021 22:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhDAUQS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Apr 2021 16:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234489AbhDAUQP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 16:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA0D610CB;
        Thu,  1 Apr 2021 20:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617308175;
        bh=xf3GNfgK2RLIG+0DR2qkQwjNDDIBYfUXbv9v5okd4rU=;
        h=From:To:Cc:Subject:Date:From;
        b=f+czxpcieEUhhfd059owFhGNjW65MgFnPBbEkp3l8s4zqW0Xd08meVZo2dGXvh7Dr
         DpSzGJOHqnMbLdoiuJfHgZq1/GDk+mLkkNusvfW+nFSfiUW+ii2ARX0uWKg5cvNFPi
         XB7Z/zK5Z2YDoE58pq6SKbNYoYiE3xX8+QHO/Krn88x4zrVhymN+k/AZ/J/1DfLXoK
         JZRFo5orTnG9TIpHPTLRiAyKq1CNUI3BRzKh0e0EDVDTqy3W7tzQ8GsZISKoDhdOfB
         1L0/EN6JZ2q7VaFJrg8XrCBFbsZdakUP8Ywb2v+C8fY3Kzm96XrerrBSxQ+5mZufcG
         GnfRHUowTwo5A==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com
Subject: [RFC PATCH] ceph: don't allow access to MDS-private inodes
Date:   Thu,  1 Apr 2021 16:16:11 -0400
Message-Id: <20210401201611.32644-1-jlayton@kernel.org>
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
 fs/ceph/inode.c      |  5 +++++
 fs/ceph/mds_client.c |  7 +++++++
 fs/ceph/super.h      | 24 ++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2c512475c170..6aa796c59e1b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -54,8 +54,13 @@ static int ceph_set_ino_cb(struct inode *inode, void *data)
 
 struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
 {
+	int ret;
 	struct inode *inode;
 
+	ret = ceph_vet_vino(vino);
+	if (ret)
+		return ERR_PTR(ret);
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
index 5e0e1aeee1b5..1d63c5a28665 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -529,10 +529,34 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
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
+static inline int ceph_vet_vino(const struct ceph_vino vino)
+{
+	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT) {
+		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
+		return -EREMOTEIO;
+	}
+	return 0;
+}
 
 static inline struct inode *ceph_find_inode(struct super_block *sb,
 					    struct ceph_vino vino)
 {
+	int ret = ceph_vet_vino(vino);
+
+	if (ret)
+		return NULL;
+
 	/*
 	 * NB: The hashval will be run through the fs/inode.c hash function
 	 * anyway, so there is no need to squash the inode number down to
-- 
2.30.2

