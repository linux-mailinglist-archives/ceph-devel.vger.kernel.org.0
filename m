Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8B2403A44
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 15:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243111AbhIHNFK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 09:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232870AbhIHNEt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 09:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF60F61175;
        Wed,  8 Sep 2021 13:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631106221;
        bh=zSlp8PtpO1znP4jsQx+2+QC0RcRWc3ZTUJ8AK7B5m4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAMn9ssIVqnyRwRKhHArgdTPxyPeOwOrUguNienSV4/f7DBvh3V1ckKEFp56H0J+T
         IUMfv96MZA4xnS1er9M19IVnsJAviytMiTp7AGjtELPzOzChZ0BJyR6ClMMdEG1/DK
         KoYVBwy5mSNfphCNjU8A5nTKK4Vry+VVaNZIIN372RTNGTvw4O4RMkoJku8Trv+750
         5XIYwtipav7EGmEdLoSt8gJV/S33AOoe6jOaYUd6aUOH5ruf8lF6JJpV1LcT6o91xo
         vRb1q2gpAtly9dwB2fPGTSYgo9zINK6ai2+hs0YVDfraFxYS+ou1Due4mLgOBRS12r
         ckC2Cxi3jMZRg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH 5/6] ceph: refactor remove_session_caps_cb
Date:   Wed,  8 Sep 2021 09:03:35 -0400
Message-Id: <20210908130336.56668-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210908130336.56668-1-jlayton@kernel.org>
References: <20210908130336.56668-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Move remove_capsnaps to caps.c. Move the part of remove_session_caps_cb
under i_ceph_lock into a separate function that lives in caps.c. Have
remove_session_caps_cb call the new helper after taking the lock.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 116 +++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c | 108 ++--------------------------------------
 fs/ceph/super.h      |   1 +
 3 files changed, 120 insertions(+), 105 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f8307d70674b..bc17515a11c9 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4579,3 +4579,119 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	spin_unlock(&dentry->d_lock);
 	return ret;
 }
+
+static int remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_cap_snap *capsnap;
+	int capsnap_release = 0;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
+
+	while (!list_empty(&ci->i_cap_snaps)) {
+		capsnap = list_first_entry(&ci->i_cap_snaps,
+					   struct ceph_cap_snap, ci_item);
+		__ceph_remove_capsnap(inode, capsnap, NULL, NULL);
+		ceph_put_snap_context(capsnap->context);
+		ceph_put_cap_snap(capsnap);
+		capsnap_release++;
+	}
+	wake_up_all(&ci->i_cap_wq);
+	wake_up_all(&mdsc->cap_flushing_wq);
+	return capsnap_release;
+}
+
+int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invalidate)
+{
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	bool is_auth;
+	bool dirty_dropped = false;
+	int iputs = 0;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	dout("removing cap %p, ci is %p, inode is %p\n",
+	     cap, ci, &ci->vfs_inode);
+
+	is_auth = (cap == ci->i_auth_cap);
+	__ceph_remove_cap(cap, false);
+	if (is_auth) {
+		struct ceph_cap_flush *cf;
+
+		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
+			if (inode->i_data.nrpages > 0)
+				*invalidate = true;
+			if (ci->i_wrbuffer_ref > 0)
+				mapping_set_error(&inode->i_data, -EIO);
+		}
+
+		spin_lock(&mdsc->cap_dirty_lock);
+
+		/* trash all of the cap flushes for this inode */
+		while (!list_empty(&ci->i_cap_flush_list)) {
+			cf = list_first_entry(&ci->i_cap_flush_list,
+					      struct ceph_cap_flush, i_list);
+			list_del_init(&cf->g_list);
+			list_del_init(&cf->i_list);
+			if (!cf->is_capsnap)
+				ceph_free_cap_flush(cf);
+		}
+
+		if (!list_empty(&ci->i_dirty_item)) {
+			pr_warn_ratelimited(
+				" dropping dirty %s state for %p %lld\n",
+				ceph_cap_string(ci->i_dirty_caps),
+				inode, ceph_ino(inode));
+			ci->i_dirty_caps = 0;
+			list_del_init(&ci->i_dirty_item);
+			dirty_dropped = true;
+		}
+		if (!list_empty(&ci->i_flushing_item)) {
+			pr_warn_ratelimited(
+				" dropping dirty+flushing %s state for %p %lld\n",
+				ceph_cap_string(ci->i_flushing_caps),
+				inode, ceph_ino(inode));
+			ci->i_flushing_caps = 0;
+			list_del_init(&ci->i_flushing_item);
+			mdsc->num_cap_flushing--;
+			dirty_dropped = true;
+		}
+		spin_unlock(&mdsc->cap_dirty_lock);
+
+		if (dirty_dropped) {
+			errseq_set(&ci->i_meta_err, -EIO);
+
+			if (ci->i_wrbuffer_ref_head == 0 &&
+			    ci->i_wr_ref == 0 &&
+			    ci->i_dirty_caps == 0 &&
+			    ci->i_flushing_caps == 0) {
+				ceph_put_snap_context(ci->i_head_snapc);
+				ci->i_head_snapc = NULL;
+			}
+		}
+
+		if (atomic_read(&ci->i_filelock_ref) > 0) {
+			/* make further file lock syscall return -EIO */
+			ci->i_ceph_flags |= CEPH_I_ERROR_FILELOCK;
+			pr_warn_ratelimited(" dropping file locks for %p %lld\n",
+					    inode, ceph_ino(inode));
+		}
+
+		if (!ci->i_dirty_caps && ci->i_prealloc_cap_flush) {
+			cf = ci->i_prealloc_cap_flush;
+			ci->i_prealloc_cap_flush = NULL;
+			if (!cf->is_capsnap)
+				ceph_free_cap_flush(cf);
+		}
+
+		if (!list_empty(&ci->i_cap_snaps))
+			iputs = remove_capsnaps(mdsc, inode);
+	}
+	if (dirty_dropped)
+		++iputs;
+	return iputs;
+}
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4b3ef0412539..44bc780b2b0e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1597,125 +1597,23 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	return ret;
 }
 
-static int remove_capsnaps(struct ceph_mds_client *mdsc, struct inode *inode)
-{
-	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_cap_snap *capsnap;
-	int capsnap_release = 0;
-
-	lockdep_assert_held(&ci->i_ceph_lock);
-
-	dout("removing capsnaps, ci is %p, inode is %p\n", ci, inode);
-
-	while (!list_empty(&ci->i_cap_snaps)) {
-		capsnap = list_first_entry(&ci->i_cap_snaps,
-					   struct ceph_cap_snap, ci_item);
-		__ceph_remove_capsnap(inode, capsnap, NULL, NULL);
-		ceph_put_snap_context(capsnap->context);
-		ceph_put_cap_snap(capsnap);
-		capsnap_release++;
-	}
-	wake_up_all(&ci->i_cap_wq);
-	wake_up_all(&mdsc->cap_flushing_wq);
-	return capsnap_release;
-}
-
 static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 				  void *arg)
 {
-	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
-	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	bool is_auth;
-	bool dirty_dropped = false;
 	bool invalidate = false;
-	int capsnap_release = 0;
+	int iputs;
 
 	dout("removing cap %p, ci is %p, inode is %p\n",
 	     cap, ci, &ci->vfs_inode);
 	spin_lock(&ci->i_ceph_lock);
-	is_auth = (cap == ci->i_auth_cap);
-	__ceph_remove_cap(cap, false);
-	if (is_auth) {
-		struct ceph_cap_flush *cf;
-
-		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
-			if (inode->i_data.nrpages > 0)
-				invalidate = true;
-			if (ci->i_wrbuffer_ref > 0)
-				mapping_set_error(&inode->i_data, -EIO);
-		}
-
-		spin_lock(&mdsc->cap_dirty_lock);
-
-		/* trash all of the cap flushes for this inode */
-		while (!list_empty(&ci->i_cap_flush_list)) {
-			cf = list_first_entry(&ci->i_cap_flush_list,
-					      struct ceph_cap_flush, i_list);
-			list_del_init(&cf->g_list);
-			list_del_init(&cf->i_list);
-			if (!cf->is_capsnap)
-				ceph_free_cap_flush(cf);
-		}
-
-		if (!list_empty(&ci->i_dirty_item)) {
-			pr_warn_ratelimited(
-				" dropping dirty %s state for %p %lld\n",
-				ceph_cap_string(ci->i_dirty_caps),
-				inode, ceph_ino(inode));
-			ci->i_dirty_caps = 0;
-			list_del_init(&ci->i_dirty_item);
-			dirty_dropped = true;
-		}
-		if (!list_empty(&ci->i_flushing_item)) {
-			pr_warn_ratelimited(
-				" dropping dirty+flushing %s state for %p %lld\n",
-				ceph_cap_string(ci->i_flushing_caps),
-				inode, ceph_ino(inode));
-			ci->i_flushing_caps = 0;
-			list_del_init(&ci->i_flushing_item);
-			mdsc->num_cap_flushing--;
-			dirty_dropped = true;
-		}
-		spin_unlock(&mdsc->cap_dirty_lock);
-
-		if (dirty_dropped) {
-			errseq_set(&ci->i_meta_err, -EIO);
-
-			if (ci->i_wrbuffer_ref_head == 0 &&
-			    ci->i_wr_ref == 0 &&
-			    ci->i_dirty_caps == 0 &&
-			    ci->i_flushing_caps == 0) {
-				ceph_put_snap_context(ci->i_head_snapc);
-				ci->i_head_snapc = NULL;
-			}
-		}
-
-		if (atomic_read(&ci->i_filelock_ref) > 0) {
-			/* make further file lock syscall return -EIO */
-			ci->i_ceph_flags |= CEPH_I_ERROR_FILELOCK;
-			pr_warn_ratelimited(" dropping file locks for %p %lld\n",
-					    inode, ceph_ino(inode));
-		}
-
-		if (!ci->i_dirty_caps && ci->i_prealloc_cap_flush) {
-			cf = ci->i_prealloc_cap_flush;
-			ci->i_prealloc_cap_flush = NULL;
-			if (!cf->is_capsnap)
-				ceph_free_cap_flush(cf);
-		}
-
-		if (!list_empty(&ci->i_cap_snaps))
-			capsnap_release = remove_capsnaps(mdsc, inode);
-	}
+	iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
 	spin_unlock(&ci->i_ceph_lock);
 
 	wake_up_all(&ci->i_cap_wq);
 	if (invalidate)
 		ceph_queue_invalidate(inode);
-	if (dirty_dropped)
-		iput(inode);
-	while (capsnap_release--)
+	while (iputs--)
 		iput(inode);
 	return 0;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c1add4ed59d2..67a0e1d2ecbb 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1207,6 +1207,7 @@ extern int ceph_mmap(struct file *file, struct vm_area_struct *vma);
 extern int ceph_uninline_data(struct file *filp, struct page *locked_page);
 extern int ceph_pool_perm_check(struct inode *inode, int need);
 extern void ceph_pool_perm_destroy(struct ceph_mds_client* mdsc);
+int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invalidate);
 
 /* file.c */
 extern const struct file_operations ceph_file_fops;
-- 
2.31.1

