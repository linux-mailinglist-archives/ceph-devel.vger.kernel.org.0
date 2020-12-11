Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C974D2D75CA
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Dec 2020 13:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392347AbgLKMkS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Dec 2020 07:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436541AbgLKMjn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 07:39:43 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH 3/3] ceph: allow queueing cap/snap handling after putting cap references
Date:   Fri, 11 Dec 2020 07:38:58 -0500
Message-Id: <20201211123858.7522-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211123858.7522-1-jlayton@kernel.org>
References: <20201211123858.7522-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Testing with the fscache overhaul has triggered some lockdep warnings
about circular lock dependencies involving page_mkwrite and the
mmap_lock. It'd be better to do the "real work" without the mmap lock
being held.

Change the skip_checking_caps parameter in __ceph_put_cap_refs to an
enum, and use that to determine whether to queue check_caps, do it
synchronously or not at all. Change ceph_page_mkwrite to do a
ceph_put_cap_refs_async().

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c  |  2 +-
 fs/ceph/caps.c  | 28 ++++++++++++++++++++++++----
 fs/ceph/inode.c |  6 ++++++
 fs/ceph/super.h | 19 ++++++++++++++++---
 4 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 950552944436..26e66436f005 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1662,7 +1662,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 
 	dout("page_mkwrite %p %llu~%zd dropping cap refs on %s ret %x\n",
 	     inode, off, len, ceph_cap_string(got), ret);
-	ceph_put_cap_refs(ci, got);
+	ceph_put_cap_refs_async(ci, got);
 out_free:
 	ceph_restore_sigs(&oldset);
 	sb_end_pagefault(inode->i_sb);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 336348e733b9..a95ab4c02056 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3026,6 +3026,12 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
 	return 0;
 }
 
+enum PutCapRefsMode {
+	PutCapRefsModeSync = 0,
+	PutCapRefsModeSkip,
+	PutCapRefsModeAsync,
+};
+
 /*
  * Release cap refs.
  *
@@ -3036,7 +3042,7 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
  * cap_snap, and wake up any waiters.
  */
 static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
-				bool skip_checking_caps)
+				enum PutCapRefsMode mode)
 {
 	struct inode *inode = &ci->vfs_inode;
 	int last = 0, put = 0, flushsnaps = 0, wake = 0;
@@ -3092,11 +3098,20 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
 	     last ? " last" : "", put ? " put" : "");
 
-	if (!skip_checking_caps) {
+	switch(mode) {
+	default:
+		break;
+	case PutCapRefsModeSync:
 		if (last)
 			ceph_check_caps(ci, 0, NULL);
 		else if (flushsnaps)
 			ceph_flush_snaps(ci, NULL);
+		break;
+	case PutCapRefsModeAsync:
+		if (last)
+			ceph_queue_check_caps(inode);
+		else if (flushsnaps)
+			ceph_queue_flush_snaps(inode);
 	}
 	if (wake)
 		wake_up_all(&ci->i_cap_wq);
@@ -3106,12 +3121,17 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 
 void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 {
-	__ceph_put_cap_refs(ci, had, false);
+	__ceph_put_cap_refs(ci, had, PutCapRefsModeSync);
+}
+
+void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had)
+{
+	__ceph_put_cap_refs(ci, had, PutCapRefsModeAsync);
 }
 
 void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
 {
-	__ceph_put_cap_refs(ci, had, true);
+	__ceph_put_cap_refs(ci, had, PutCapRefsModeSkip);
 }
 
 /*
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9cd8b37e586a..a7ee19e27e26 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1965,6 +1965,12 @@ static void ceph_inode_work(struct work_struct *work)
 	if (test_and_clear_bit(CEPH_I_WORK_VMTRUNCATE, &ci->i_work_mask))
 		__ceph_do_pending_vmtruncate(inode);
 
+	if (test_and_clear_bit(CEPH_I_WORK_CHECK_CAPS, &ci->i_work_mask))
+		ceph_check_caps(ci, 0, NULL);
+
+	if (test_and_clear_bit(CEPH_I_WORK_FLUSH_SNAPS, &ci->i_work_mask))
+		ceph_flush_snaps(ci, NULL);
+
 	iput(inode);
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 59153ee201c0..13b02887b085 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -562,9 +562,11 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 /*
  * Masks of ceph inode work.
  */
-#define CEPH_I_WORK_WRITEBACK		0 /* writeback */
-#define CEPH_I_WORK_INVALIDATE_PAGES	1 /* invalidate pages */
-#define CEPH_I_WORK_VMTRUNCATE		2 /* vmtruncate */
+#define CEPH_I_WORK_WRITEBACK		0
+#define CEPH_I_WORK_INVALIDATE_PAGES	1
+#define CEPH_I_WORK_VMTRUNCATE		2
+#define CEPH_I_WORK_CHECK_CAPS		3
+#define CEPH_I_WORK_FLUSH_SNAPS		4
 
 /*
  * We set the ERROR_WRITE bit when we start seeing write errors on an inode
@@ -982,6 +984,16 @@ static inline void ceph_queue_writeback(struct inode *inode)
 	ceph_queue_inode_work(inode, CEPH_I_WORK_WRITEBACK);
 }
 
+static inline void ceph_queue_check_caps(struct inode *inode)
+{
+	ceph_queue_inode_work(inode, CEPH_I_WORK_CHECK_CAPS);
+}
+
+static inline void ceph_queue_flush_snaps(struct inode *inode)
+{
+	ceph_queue_inode_work(inode, CEPH_I_WORK_FLUSH_SNAPS);
+}
+
 extern int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 			     int mask, bool force);
 static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
@@ -1120,6 +1132,7 @@ extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
 				bool snap_rwsem_locked);
 extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
 extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
+extern void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had);
 extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
 					    int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
-- 
2.29.2

