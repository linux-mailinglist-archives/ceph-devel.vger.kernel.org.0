Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639127E411
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfHAU0Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbfHAU0P (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:15 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A6262084C;
        Thu,  1 Aug 2019 20:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691173;
        bh=Xij1cDAFauv0aRo5uNWz6wMddYgRsuoDrvdZy+qgQcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDafvrt6OHm58hF1E3tydhQqjyzPMEUgulJOJF3Wbvy0zqmjzquOBv5ZrrXEny4RD
         ZZ/APZBikw4gIRUvTPElHiMQ7iaQtDOiu+1/ftIDL/dxVsrJ+mI7fud9nAb8HpN2KN
         LPkmDukh0VvDa98fTJqICspC94wpbw+ysRuos4MM=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 7/9] ceph: perform asynchronous unlink if we have sufficient caps
Date:   Thu,  1 Aug 2019 16:26:03 -0400
Message-Id: <20190801202605.18172-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801202605.18172-1-jlayton@kernel.org>
References: <20190801202605.18172-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: "Yan, Zheng" <zyan@redhat.com>

The MDS is getting a new lock-caching facility that will allow it
to cache the necessary locks to allow asynchronous directory operations.
Since the CEPH_CAP_FILE_* caps are currently unused on directories,
we can repurpose those bits for this purpose.

When performing an unlink, if we have Fx on the parent directory,
and CEPH_CAP_DIR_UNLINK (aka Fr), and we know that the dentry being
removed is the primary link, then then we can fire off an unlink
request immediately and don't need to wait on reply before returning.

In that situation, just fix up the dcache and link count and return
immediately after issuing the call to the MDS. This does mean that we
need to hold an extra reference to the inode being unlinked, and extra
references to the caps to avoid races. Those references are put and
error handling is done in the r_callback routine.

If the operation ends up failing, then set a writeback error on the
directory inode that can be fetched later by an fsync on the dir.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c               | 35 ++++++++++++------
 fs/ceph/dir.c                | 70 +++++++++++++++++++++++++++++++++---
 fs/ceph/inode.c              |  8 ++++-
 fs/ceph/super.h              |  1 +
 include/linux/ceph/ceph_fs.h |  9 +++++
 5 files changed, 107 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a9d0a2d211ac..9344e742397e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -991,7 +991,11 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
 int __ceph_caps_wanted(struct ceph_inode_info *ci)
 {
 	int w = __ceph_caps_file_wanted(ci) | __ceph_caps_used(ci);
-	if (!S_ISDIR(ci->vfs_inode.i_mode)) {
+	if (S_ISDIR(ci->vfs_inode.i_mode)) {
+		/* we want EXCL if holding caps of dir ops */
+		if (w & CEPH_CAP_ANY_DIR_OPS)
+			w |= CEPH_CAP_FILE_EXCL;
+	} else {
 		/* we want EXCL if dirty data */
 		if (w & CEPH_CAP_FILE_BUFFER)
 			w |= CEPH_CAP_FILE_EXCL;
@@ -1886,10 +1890,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			 * revoking the shared cap on every create/unlink
 			 * operation.
 			 */
-			if (IS_RDONLY(inode))
+			if (IS_RDONLY(inode)) {
 				want = CEPH_CAP_ANY_SHARED;
-			else
-				want = CEPH_CAP_ANY_SHARED | CEPH_CAP_FILE_EXCL;
+			} else {
+				want = CEPH_CAP_ANY_SHARED |
+				       CEPH_CAP_FILE_EXCL |
+				       CEPH_CAP_ANY_DIR_OPS;
+			}
 			retain |= want;
 		} else {
 
@@ -2652,7 +2659,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 				}
 				snap_rwsem_locked = true;
 			}
-			*got = need | (have & want);
+			if ((have & want) == want)
+				*got = need | want;
+			else
+				*got = need;
 			if (S_ISREG(inode->i_mode) &&
 			    (need & CEPH_CAP_FILE_RD) &&
 			    !(*got & CEPH_CAP_FILE_CACHE))
@@ -2742,13 +2752,16 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
 	int ret;
 
 	BUG_ON(need & ~CEPH_CAP_FILE_RD);
-	BUG_ON(want & ~(CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO|CEPH_CAP_FILE_SHARED));
-	ret = ceph_pool_perm_check(inode, need);
-	if (ret < 0)
-		return ret;
+	if (need) {
+		ret = ceph_pool_perm_check(inode, need);
+		if (ret < 0)
+			return ret;
+	}
 
-	ret = try_get_cap_refs(inode, need, want, 0,
-			       (nonblock ? NON_BLOCKING : 0), got);
+	BUG_ON(want & ~(CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO |
+			CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
+			CEPH_CAP_ANY_DIR_OPS));
+	ret = try_get_cap_refs(inode, need, want, 0, nonblock, got);
 	return ret == -EAGAIN ? 0 : ret;
 }
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 35797ff895e7..2bd3e073249e 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1068,6 +1068,47 @@ int ceph_async_dirop_request_wait(struct inode *inode)
 	return ret;
 }
 
+static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
+				 struct ceph_mds_request *req)
+{
+	/* If op failed, set error on parent directory */
+	mapping_set_error(req->r_parent->i_mapping, req->r_err);
+	if (req->r_err)
+		printk("%s: req->r_err = %d\n", __func__, req->r_err);
+	ceph_put_cap_refs(ceph_inode(req->r_parent),
+			  CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_UNLINK);
+	iput(req->r_old_inode);
+}
+
+static bool get_caps_for_async_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct ceph_inode_info *ci = ceph_inode(dir);
+	struct ceph_dentry_info *di;
+	int ret, want, got;
+
+	want = CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_UNLINK;
+	ret = ceph_try_get_caps(dir, 0, want, true, &got);
+	dout("Fx on %p ret=%d got=%d\n", dir, ret, got);
+	if (ret != 1 || got != want)
+		return false;
+
+        spin_lock(&dentry->d_lock);
+        di = ceph_dentry(dentry);
+	/* - We are holding CEPH_CAP_FILE_EXCL, which implies
+	 * CEPH_CAP_FILE_SHARED.
+	 * - Only support async unlink for primary linkage */
+	if (atomic_read(&ci->i_shared_gen) != di->lease_shared_gen ||
+	    !(di->flags & CEPH_DENTRY_PRIMARY_LINK))
+		ret = 0;
+        spin_unlock(&dentry->d_lock);
+
+	if (!ret) {
+		ceph_put_cap_refs(ci, got);
+		return false;
+	}
+	return true;
+}
+
 /*
  * rmdir and unlink are differ only by the metadata op code
  */
@@ -1105,13 +1146,33 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
-	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 	req->r_inode_drop = ceph_drop_caps_for_unlink(inode);
-	err = ceph_mdsc_do_request(mdsc, dir, req);
-	if (!err && !req->r_reply_info.head->is_dentry)
-		d_delete(dentry);
+
+	if (op == CEPH_MDS_OP_UNLINK &&
+	    get_caps_for_async_unlink(dir, dentry)) {
+		dout("ceph: Async unlink on %lu/%.*s", dir->i_ino,
+		     dentry->d_name.len, dentry->d_name.name);
+		req->r_callback = ceph_async_unlink_cb;
+		req->r_old_inode = d_inode(dentry);
+		ihold(req->r_old_inode);
+		err = ceph_mdsc_submit_request(mdsc, dir, req);
+		if (!err) {
+			/*
+			 * We have enough caps, so we assume that the unlink
+			 * will succeed. Fix up the target inode and dcache.
+			 */
+			drop_nlink(inode);
+			d_delete(dentry);
+		}
+	} else {
+		set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+		err = ceph_mdsc_do_request(mdsc, dir, req);
+		if (!err && !req->r_reply_info.head->is_dentry)
+			d_delete(dentry);
+	}
+
 	ceph_mdsc_put_request(req);
 out:
 	return err;
@@ -1455,6 +1516,7 @@ void ceph_invalidate_dentry_lease(struct dentry *dentry)
 	spin_lock(&dentry->d_lock);
 	di->time = jiffies;
 	di->lease_shared_gen = 0;
+	di->flags &= ~CEPH_DENTRY_PRIMARY_LINK;
 	__dentry_lease_unlist(di);
 	spin_unlock(&dentry->d_lock);
 }
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c844bd7f5f37..d71d97540b72 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1047,6 +1047,7 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
 				  struct ceph_mds_session **old_lease_session)
 {
 	struct ceph_dentry_info *di = ceph_dentry(dentry);
+	unsigned mask = le16_to_cpu(lease->mask);
 	long unsigned duration = le32_to_cpu(lease->duration_ms);
 	long unsigned ttl = from_time + (duration * HZ) / 1000;
 	long unsigned half_ttl = from_time + (duration * HZ / 2) / 1000;
@@ -1058,8 +1059,13 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
 	if (ceph_snap(dir) != CEPH_NOSNAP)
 		return;
 
+	if (mask & CEPH_LEASE_PRIMARY_LINK)
+		di->flags |= CEPH_DENTRY_PRIMARY_LINK;
+	else
+		di->flags &= ~CEPH_DENTRY_PRIMARY_LINK;
+
 	di->lease_shared_gen = atomic_read(&ceph_inode(dir)->i_shared_gen);
-	if (duration == 0) {
+	if (!(mask & CEPH_LEASE_VALID)) {
 		__ceph_dentry_dir_lease_touch(di);
 		return;
 	}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 292ac0544e33..537db863010b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -282,6 +282,7 @@ struct ceph_dentry_info {
 #define CEPH_DENTRY_REFERENCED		1
 #define CEPH_DENTRY_LEASE_LIST		2
 #define CEPH_DENTRY_SHRINK_LIST		4
+#define CEPH_DENTRY_PRIMARY_LINK	8
 
 struct ceph_inode_xattrs_info {
 	/*
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index cb21c5cf12c3..a099f60feb7b 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -530,6 +530,9 @@ struct ceph_mds_reply_lease {
 	__le32 seq;
 } __attribute__ ((packed));
 
+#define CEPH_LEASE_VALID        (1 | 2) /* old and new bit values */
+#define CEPH_LEASE_PRIMARY_LINK 4       /* primary linkage */
+
 struct ceph_mds_reply_dirfrag {
 	__le32 frag;            /* fragment */
 	__le32 auth;            /* auth mds, if this is a delegation point */
@@ -659,6 +662,12 @@ int ceph_flags_to_mode(int flags);
 #define CEPH_CAP_LOCKS (CEPH_LOCK_IFILE | CEPH_LOCK_IAUTH | CEPH_LOCK_ILINK | \
 			CEPH_LOCK_IXATTR)
 
+/* cap masks async dir operations */
+#define CEPH_CAP_DIR_CREATE	CEPH_CAP_FILE_CACHE
+#define CEPH_CAP_DIR_UNLINK	CEPH_CAP_FILE_RD
+#define CEPH_CAP_ANY_DIR_OPS	(CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_RD | \
+				 CEPH_CAP_FILE_WREXTEND | CEPH_CAP_FILE_LAZYIO)
+
 int ceph_caps_for_mode(int mode);
 
 enum {
-- 
2.21.0

