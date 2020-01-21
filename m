Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D257D14452A
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Jan 2020 20:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAUT3j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Jan 2020 14:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728984AbgAUT3i (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 14:29:38 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 863E42467A;
        Tue, 21 Jan 2020 19:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579634977;
        bh=0Vmy3NZOws9KzJe/NtbmJ1gqspWfLnhv++ox5+yoQm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5WBxNWpZp+3mcohxCHy2jC5Qi4gCqoA0ydPC37O70AxAbw8VbwjkEno27ZddzW6R
         C1rxCz7iaEPSwPHJgtWyLF3W0llaprrco1BwjRvf/nfmKO0Rk7p7d1wJBpSlY0hIqB
         MGPv/qlEdi6pl6S0AbdjHyedtdKuov1wWT81QURY=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idridryomov@gmail.com, sage@redhat.com, zyan@redhat.com
Subject: [RFC PATCH v3 09/10] ceph: cache layout in parent dir on first sync create
Date:   Tue, 21 Jan 2020 14:29:27 -0500
Message-Id: <20200121192928.469316-10-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200121192928.469316-1-jlayton@kernel.org>
References: <20200121192928.469316-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It doesn't do much good to do an asynchronous create unless we can do
I/O to it before the create reply comes in. That means we need layout
info the new file before we've gotten the response from the MDS.

All files created in a directory will initially inherit the same layout,
so copy off the requisite info from the first synchronous create in the
directory, and save it in a new i_cached_layout field. Zero out the
layout when we lose Dc caps in the dir.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 13 ++++++++++---
 fs/ceph/file.c  | 22 +++++++++++++++++++++-
 fs/ceph/inode.c |  2 ++
 fs/ceph/super.h |  1 +
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 869e2102e827..0c95a7c9c7c1 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -561,14 +561,14 @@ static void __cap_delay_cancel(struct ceph_mds_client *mdsc,
 	spin_unlock(&mdsc->cap_delay_lock);
 }
 
-/*
- * Common issue checks for add_cap, handle_cap_grant.
- */
+/* Common issue checks for add_cap, handle_cap_grant. */
 static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 			      unsigned issued)
 {
 	unsigned had = __ceph_caps_issued(ci, NULL);
 
+	lockdep_assert_held(&ci->i_ceph_lock);
+
 	/*
 	 * Each time we receive FILE_CACHE anew, we increment
 	 * i_rdcache_gen.
@@ -593,6 +593,13 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 			__ceph_dir_clear_complete(ci);
 		}
 	}
+
+	/* Wipe saved layout if we're losing DIR_CREATE caps */
+	if (S_ISDIR(ci->vfs_inode.i_mode) && (had & CEPH_CAP_DIR_CREATE) &&
+		!(issued & CEPH_CAP_DIR_CREATE)) {
+	     ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
+	     memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
+	}
 }
 
 /*
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 1e6cdf2dfe90..b44ccbc85fe4 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -430,6 +430,23 @@ int ceph_open(struct inode *inode, struct file *file)
 	return err;
 }
 
+/* Clone the layout from a synchronous create, if the dir now has Dc caps */
+static void
+cache_file_layout(struct inode *dst, struct inode *src)
+{
+	struct ceph_inode_info *cdst = ceph_inode(dst);
+	struct ceph_inode_info *csrc = ceph_inode(src);
+
+	spin_lock(&cdst->i_ceph_lock);
+	if ((__ceph_caps_issued(cdst, NULL) & CEPH_CAP_DIR_CREATE) &&
+	    !ceph_file_layout_is_valid(&cdst->i_cached_layout)) {
+		memcpy(&cdst->i_cached_layout, &csrc->i_layout,
+			sizeof(cdst->i_cached_layout));
+		rcu_assign_pointer(cdst->i_cached_layout.pool_ns,
+				   ceph_try_get_string(csrc->i_layout.pool_ns));
+	}
+	spin_unlock(&cdst->i_ceph_lock);
+}
 
 /*
  * Do a lookup + open with a single request.  If we get a non-existent
@@ -518,7 +535,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	} else {
 		dout("atomic_open finish_open on dn %p\n", dn);
 		if (req->r_op == CEPH_MDS_OP_CREATE && req->r_reply_info.has_create_ino) {
-			ceph_init_inode_acls(d_inode(dentry), &as_ctx);
+			struct inode *newino = d_inode(dentry);
+
+			cache_file_layout(dir, newino);
+			ceph_init_inode_acls(newino, &as_ctx);
 			file->f_mode |= FMODE_CREATED;
 		}
 		err = finish_open(file, dentry, ceph_open);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 4056c7968b86..73f986efb1fd 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -447,6 +447,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	ci->i_max_files = 0;
 
 	memset(&ci->i_dir_layout, 0, sizeof(ci->i_dir_layout));
+	memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
 	RCU_INIT_POINTER(ci->i_layout.pool_ns, NULL);
 
 	ci->i_fragtree = RB_ROOT;
@@ -587,6 +588,7 @@ void ceph_evict_inode(struct inode *inode)
 		ceph_buffer_put(ci->i_xattrs.prealloc_blob);
 
 	ceph_put_string(rcu_dereference_raw(ci->i_layout.pool_ns));
+	ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
 }
 
 static inline blkcnt_t calc_inode_blocks(u64 size)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 86dd4a2163e0..09bd4b71de91 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -326,6 +326,7 @@ struct ceph_inode_info {
 
 	struct ceph_dir_layout i_dir_layout;
 	struct ceph_file_layout i_layout;
+	struct ceph_file_layout i_cached_layout;	// for async creates
 	char *i_symlink;
 
 	/* for dirs */
-- 
2.24.1

