Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9762175CB0
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 15:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCBOOl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 09:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgCBOOk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 09:14:40 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E61FA22B48;
        Mon,  2 Mar 2020 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583158479;
        bh=ut96lQnLSUjyHnGChlQLrry2dSEeDao3fjWDsSn2Odc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0AqHnBuLLCKzg+XnwCEQgbgz9BXTMZclS5uSULjUi5vVDwJYE5nV8Ghjb3nYaeAN
         Td9hUnOiFDxIZ4zHYXkQhZ0ykJIyJPNCWjzJj3Qb+IQSs3Iuabn9pd3VFwynlqfw05
         znkt8QO727asbXWEk0OKPZgxHdtzgY2gMr1p1Vjw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v6 04/13] ceph: add infrastructure for waiting for async create to complete
Date:   Mon,  2 Mar 2020 09:14:25 -0500
Message-Id: <20200302141434.59825-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302141434.59825-1-jlayton@kernel.org>
References: <20200302141434.59825-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we issue an async create, we must ensure that any later on-the-wire
requests involving it wait for the create reply.

Expand i_ceph_flags to be an unsigned long, and add a new bit that
MDS requests can wait on. If the bit is set in the inode when sending
caps, then don't send it and just return that it has been delayed.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 28 ++++++++++++++++++++++++----
 fs/ceph/dir.c        |  2 +-
 fs/ceph/mds_client.c | 20 +++++++++++++++++++-
 fs/ceph/mds_client.h |  7 +++++++
 fs/ceph/super.h      |  4 +++-
 5 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 553fd1d52456..3fff4945f10e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -507,7 +507,7 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
 static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
 				struct ceph_inode_info *ci)
 {
-	dout("__cap_delay_requeue %p flags %d at %lu\n", &ci->vfs_inode,
+	dout("%s %p flags 0x%lx at %lu\n", __func__, &ci->vfs_inode,
 	     ci->i_ceph_flags, ci->i_hold_caps_max);
 	if (!mdsc->stopping) {
 		spin_lock(&mdsc->cap_delay_lock);
@@ -1843,6 +1843,14 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	bool tried_invalidate = false;
 
 	spin_lock(&ci->i_ceph_lock);
+
+	/* Just requeue it until create reply comes in */
+	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
+		__cap_delay_requeue(mdsc, ci);
+		spin_unlock(&ci->i_ceph_lock);
+		return;
+	}
+
 	if (ci->i_ceph_flags & CEPH_I_FLUSH)
 		flags |= CHECK_CAPS_FLUSH;
 
@@ -2080,6 +2088,7 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 
 retry:
 	spin_lock(&ci->i_ceph_lock);
+	WARN_ON_ONCE(ci->i_ceph_flags & CEPH_I_ASYNC_CREATE);
 retry_locked:
 	if (ci->i_dirty_caps && ci->i_auth_cap) {
 		struct ceph_cap *cap = ci->i_auth_cap;
@@ -2212,6 +2221,10 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	if (datasync)
 		goto out;
 
+	ret = ceph_wait_on_async_create(inode);
+	if (ret)
+		goto out;
+
 	dirty = try_flush_caps(inode, &flush_tid);
 	dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
 
@@ -2259,10 +2272,13 @@ int ceph_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	dout("write_inode %p wait=%d\n", inode, wait);
 	if (wait) {
-		dirty = try_flush_caps(inode, &flush_tid);
-		if (dirty)
-			err = wait_event_interruptible(ci->i_cap_wq,
+		err = ceph_wait_on_async_create(inode);
+		if (!err) {
+			dirty = try_flush_caps(inode, &flush_tid);
+			if (dirty)
+				err = wait_event_interruptible(ci->i_cap_wq,
 				       caps_are_flushed(inode, flush_tid));
+		}
 	} else {
 		struct ceph_mds_client *mdsc =
 			ceph_sb_to_client(inode->i_sb)->mdsc;
@@ -2289,6 +2305,10 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 	u64 first_tid = 0;
 	u64 last_snap_flush = 0;
 
+	/* Can't flush an inode that's not created yet */
+	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE)
+		return;
+
 	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 
 	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index a87274935a09..5b83bda57056 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -752,7 +752,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 		struct ceph_dentry_info *di = ceph_dentry(dentry);
 
 		spin_lock(&ci->i_ceph_lock);
-		dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
+		dout(" dir %p flags are 0x%lx\n", dir, ci->i_ceph_flags);
 		if (strncmp(dentry->d_name.name,
 			    fsc->mount_options->snapdir_name,
 			    dentry->d_name.len) &&
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 5d6959c0cf33..2fbe505e5b2e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2725,7 +2725,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
 int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 			      struct ceph_mds_request *req)
 {
-	int err;
+	int err = 0;
 
 	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
 	if (req->r_inode)
@@ -2738,6 +2738,24 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
 				  CEPH_CAP_PIN);
 
+	if (req->r_inode) {
+		err = ceph_wait_on_async_create(req->r_inode);
+		if (err) {
+			dout("%s: wait for async create returned: %d\n",
+			     __func__, err);
+			return err;
+		}
+	}
+
+	if (!err && req->r_old_inode) {
+		err = ceph_wait_on_async_create(req->r_old_inode);
+		if (err) {
+			dout("%s: wait for async create returned: %d\n",
+			     __func__, err);
+			return err;
+		}
+	}
+
 	dout("submit_request on %p for inode %p\n", req, dir);
 	mutex_lock(&mdsc->mutex);
 	__register_request(mdsc, req, dir);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 95ac00e59e66..8043f2b439b1 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -538,4 +538,11 @@ extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
 extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
 			  struct ceph_mds_session *session,
 			  int max_caps);
+static inline int ceph_wait_on_async_create(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
+			   TASK_INTERRUPTIBLE);
+}
 #endif
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6acecb7cf6d2..8cfacee5e856 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -316,7 +316,7 @@ struct ceph_inode_info {
 	u64 i_inline_version;
 	u32 i_time_warp_seq;
 
-	unsigned i_ceph_flags;
+	unsigned long i_ceph_flags;
 	atomic64_t i_release_count;
 	atomic64_t i_ordered_count;
 	atomic64_t i_complete_seq[2];
@@ -523,6 +523,8 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 #define CEPH_I_ERROR_WRITE	(1 << 9)  /* have seen write errors */
 #define CEPH_I_ERROR_FILELOCK	(1 << 10) /* have seen file lock errors */
 #define CEPH_I_ODIRECT		(1 << 11) /* inode in direct I/O mode */
+#define CEPH_ASYNC_CREATE_BIT	(12)	  /* async create in flight for this */
+#define CEPH_I_ASYNC_CREATE	(1 << CEPH_ASYNC_CREATE_BIT)
 
 /*
  * Masks of ceph inode work.
-- 
2.24.1

