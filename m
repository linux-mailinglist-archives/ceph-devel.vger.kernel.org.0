Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7646C403A3F
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 15:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244400AbhIHNFE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 09:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236221AbhIHNEt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 09:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A10061176;
        Wed,  8 Sep 2021 13:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631106221;
        bh=vr8UVrEttdvLIs3FqQ2kzETP1qpBSWGPFGYOzgB+re0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D54Lk8t55FwTlJwm09kA8EhfUTk0zM6C4MerKpa14s+Z5VuMf1Y5WBvOtfuNtAlbu
         pM10CNyNx2mK6WLjdlb4iCf8ERB1Ry4wzYApz/rAWvqa2odm+JfekKKmKyf+xzeme4
         gjpFzib54wIMzEIjO36fBqrMHbik7aoXCCp6xSDEwtzw1wxafEWTwrMpWUB62wZjk5
         unGmw59sM3KpvPIz8eluNhB1twM4zRkIl0+Us+Sjjrd/6Oi71CgT+mLBivNLj0BDl2
         LoFMY0BxeFy0EIeh/eV7nFLVQZRks0eGrTBBEa7JIEUoN1I7a0dw5xH16M6Jw7kIBx
         oB/DbVbwX+AlA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH 6/6] ceph: shut down access to inode when async create fails
Date:   Wed,  8 Sep 2021 09:03:36 -0400
Message-Id: <20210908130336.56668-7-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210908130336.56668-1-jlayton@kernel.org>
References: <20210908130336.56668-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add proper error handling for when an async create fails. The inode
never existed, so any dirty caps or data are now toast. We already
d_drop the dentry in that case, but the now-stale inode may still be
around. We want to shut down access to these inodes, and ensure that
they can't harbor any more dirty data, which can cause problems at
umount time.

When this occurs, flag such inodes as being SHUTDOWN, and trash any caps
and cap flushes that may be in flight for them, and invalidate the
pagecache for the inode. Add a new helper that can check whether an
inode or an entire mount is now shut down, and call it instead of
accessing the mount_state directly in places where we test that now.

URL: https://tracker.ceph.com/issues/51279
Signed-off-by: Jeff Layton  <jlayton@kernel.org>
---
 fs/ceph/addr.c   | 16 +++++++++++-----
 fs/ceph/caps.c   | 12 ++++++------
 fs/ceph/export.c | 12 +++++++++++-
 fs/ceph/file.c   | 10 +++++++++-
 fs/ceph/inode.c  | 33 +++++++++++++++++++++++++++++++--
 fs/ceph/locks.c  |  6 ++++++
 fs/ceph/super.h  | 11 +++++++++++
 7 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6d3f74d46e5b..c4658f6db8d1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -724,7 +724,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 	     wbc->sync_mode == WB_SYNC_NONE ? "NONE" :
 	     (wbc->sync_mode == WB_SYNC_ALL ? "ALL" : "HOLD"));
 
-	if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
+	if (ceph_inode_is_shutdown(inode)) {
 		if (ci->i_wrbuffer_ref > 0) {
 			pr_warn_ratelimited(
 				"writepage_start %p %lld forced umount\n",
@@ -1145,12 +1145,12 @@ static struct ceph_snap_context *
 ceph_find_incompatible(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
-	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
-	if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
-		dout(" page %p forced umount\n", page);
-		return ERR_PTR(-EIO);
+	if (ceph_inode_is_shutdown(inode)) {
+		dout(" page %p %llx:%llx is shutdown\n", page,
+		     ceph_vinop(inode));
+		return ERR_PTR(-ESTALE);
 	}
 
 	for (;;) {
@@ -1356,6 +1356,9 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 	sigset_t oldset;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
+	if (ceph_inode_is_shutdown(inode))
+		return ret;
+
 	ceph_block_sigs(&oldset);
 
 	dout("filemap_fault %p %llx.%llx %llu trying to get caps\n",
@@ -1444,6 +1447,9 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	sigset_t oldset;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
+	if (ceph_inode_is_shutdown(inode))
+		return ret;
+
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return VM_FAULT_OOM;
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index bc17515a11c9..cdeb5b2d7920 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1188,11 +1188,11 @@ void ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-	fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
+	fsc = ceph_inode_to_client(&ci->vfs_inode);
 	WARN_ON_ONCE(ci->i_auth_cap == cap &&
 		     !list_empty(&ci->i_dirty_item) &&
 		     !fsc->blocklisted &&
-		     READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN);
+		     !ceph_inode_is_shutdown(&ci->vfs_inode));
 
 	__ceph_remove_cap(cap, queue_release);
 }
@@ -2756,9 +2756,9 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 			goto out_unlock;
 		}
 
-		if (READ_ONCE(mdsc->fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
-			dout("get_cap_refs %p forced umount\n", inode);
-			ret = -EIO;
+		if (ceph_inode_is_shutdown(inode)) {
+			dout("get_cap_refs %p inode is shutdown\n", inode);
+			ret = -ESTALE;
 			goto out_unlock;
 		}
 		mds_wanted = __ceph_caps_mds_wanted(ci, false);
@@ -4622,7 +4622,7 @@ int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invali
 	if (is_auth) {
 		struct ceph_cap_flush *cf;
 
-		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
+		if (ceph_inode_is_shutdown(inode)) {
 			if (inode->i_data.nrpages > 0)
 				*invalidate = true;
 			if (ci->i_wrbuffer_ref > 0)
diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 1d65934c1262..e0fa66ac8b9f 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -157,6 +157,11 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
 		ceph_mdsc_put_request(req);
 		if (!inode)
 			return err < 0 ? ERR_PTR(err) : ERR_PTR(-ESTALE);
+	} else {
+		if (ceph_inode_is_shutdown(inode)) {
+			iput(inode);
+			return ERR_PTR(-ESTALE);
+		}
 	}
 	return inode;
 }
@@ -223,8 +228,13 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
 		return ERR_PTR(-ESTALE);
 
 	inode = ceph_find_inode(sb, vino);
-	if (inode)
+	if (inode) {
+		if (ceph_inode_is_shutdown(inode)) {
+			iput(inode);
+			return ERR_PTR(-ESTALE);
+		}
 		return d_obtain_alias(inode);
+	}
 
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
 				       USE_ANY_MDS);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 175366eede23..950e1b44f0aa 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -526,6 +526,7 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 
 	if (result) {
 		struct dentry *dentry = req->r_dentry;
+		struct inode *inode = d_inode(dentry);
 		int pathlen = 0;
 		u64 base = 0;
 		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
@@ -535,7 +536,8 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 		if (!d_unhashed(dentry))
 			d_drop(dentry);
 
-		/* FIXME: start returning I/O errors on all accesses? */
+		ceph_inode_shutdown(inode);
+
 		pr_warn("ceph: async create failure path=(%llx)%s result=%d!\n",
 			base, IS_ERR(path) ? "<<bad>>" : path, result);
 		ceph_mdsc_free_path(path, pathlen);
@@ -1527,6 +1529,9 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	dout("aio_read %p %llx.%llx %llu~%u trying to get caps on %p\n",
 	     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len, inode);
 
+	if (ceph_inode_is_shutdown(inode))
+		return -ESTALE;
+
 	if (direct_lock)
 		ceph_start_io_direct(inode);
 	else
@@ -1679,6 +1684,9 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	loff_t pos;
 	loff_t limit = max(i_size_read(inode), fsc->max_file_size);
 
+	if (ceph_inode_is_shutdown(inode))
+		return -ESTALE;
+
 	if (ceph_snap(inode) != CEPH_NOSNAP)
 		return -EROFS;
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 43c02c4b2631..23b5a0867e3a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1844,13 +1844,12 @@ void ceph_queue_inode_work(struct inode *inode, int work_bit)
 static void ceph_do_invalidate_pages(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	u32 orig_gen;
 	int check = 0;
 
 	mutex_lock(&ci->i_truncate_mutex);
 
-	if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
+	if (ceph_inode_is_shutdown(inode)) {
 		pr_warn_ratelimited("%s: inode %llx:%llx is shut down\n",
 				    __func__, ceph_vinop(inode));
 		mapping_set_error(inode->i_mapping, -EIO);
@@ -2220,6 +2219,9 @@ int ceph_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 	if (ceph_snap(inode) != CEPH_NOSNAP)
 		return -EROFS;
 
+	if (ceph_inode_is_shutdown(inode))
+		return -ESTALE;
+
 	err = setattr_prepare(&init_user_ns, dentry, attr);
 	if (err != 0)
 		return err;
@@ -2350,6 +2352,9 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	u32 valid_mask = STATX_BASIC_STATS;
 	int err = 0;
 
+	if (ceph_inode_is_shutdown(inode))
+		return -ESTALE;
+
 	/* Skip the getattr altogether if we're asked not to sync */
 	if (!(flags & AT_STATX_DONT_SYNC)) {
 		err = ceph_do_getattr(inode,
@@ -2397,3 +2402,27 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	stat->result_mask = request_mask & valid_mask;
 	return err;
 }
+
+void ceph_inode_shutdown(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct rb_node *p;
+	int iputs = 0;
+	bool invalidate = false;
+
+	spin_lock(&ci->i_ceph_lock);
+	ci->i_ceph_flags |= CEPH_I_SHUTDOWN;
+	p = rb_first(&ci->i_caps);
+	while (p) {
+		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
+
+		p = rb_next(p);
+		iputs += ceph_purge_inode_cap(inode, cap, &invalidate);
+	}
+	spin_unlock(&ci->i_ceph_lock);
+
+	if (invalidate)
+		ceph_queue_invalidate(inode);
+	while (iputs--)
+		iput(inode);
+}
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index fa8a847743d0..bdc8bd04055b 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -244,6 +244,9 @@ int ceph_lock(struct file *file, int cmd, struct file_lock *fl)
 	if (__mandatory_lock(file->f_mapping->host) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
+	if (ceph_inode_is_shutdown(inode))
+		return -ESTALE;
+
 	dout("ceph_lock, fl_owner: %p\n", fl->fl_owner);
 
 	/* set wait bit as appropriate, then make command as Ceph expects it*/
@@ -309,6 +312,9 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
 	if (fl->fl_type & LOCK_MAND)
 		return -EOPNOTSUPP;
 
+	if (ceph_inode_is_shutdown(inode))
+		return -ESTALE;
+
 	dout("ceph_flock, fl_file: %p\n", fl->fl_file);
 
 	spin_lock(&ci->i_ceph_lock);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 67a0e1d2ecbb..13dd3c71c95b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -588,6 +588,7 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 #define CEPH_I_ODIRECT		(1 << 11) /* inode in direct I/O mode */
 #define CEPH_ASYNC_CREATE_BIT	(12)	  /* async create in flight for this */
 #define CEPH_I_ASYNC_CREATE	(1 << CEPH_ASYNC_CREATE_BIT)
+#define CEPH_I_SHUTDOWN		(1 << 13) /* inode is no longer usable */
 
 /*
  * Masks of ceph inode work.
@@ -1036,6 +1037,16 @@ extern int ceph_setattr(struct user_namespace *mnt_userns,
 extern int ceph_getattr(struct user_namespace *mnt_userns,
 			const struct path *path, struct kstat *stat,
 			u32 request_mask, unsigned int flags);
+void ceph_inode_shutdown(struct inode *inode);
+
+static inline bool ceph_inode_is_shutdown(struct inode *inode)
+{
+	unsigned long flags = READ_ONCE(ceph_inode(inode)->i_ceph_flags);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	int state = READ_ONCE(fsc->mount_state);
+
+	return (flags & CEPH_I_SHUTDOWN) || state >= CEPH_MOUNT_SHUTDOWN;
+}
 
 /* xattr.c */
 int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
-- 
2.31.1

