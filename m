Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1C216454D
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 14:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgBSNZb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 08:25:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgBSNZb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:25:31 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29EE324670;
        Wed, 19 Feb 2020 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582118730;
        bh=fZ/3hnLQcb5i2gV6/nPvFXNtyb6vAGkFvlrrjZdJdh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnSeBSAq3/mG9fZ7xHJiHwK8vHOBYHM+KMpM0GbRyAn5B8uDeCstGUxMn4eXd5MeF
         j9o/q4J9pxjvfINDS/Xcl/PdrHRjcXkaTiwfVnIpgA/26ZUK7hK/fwOOTyqIUVPR+5
         dWzEu3GqUwxquw/XJpQjOVxbo7G12c96Rp+xJPqc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [PATCH v5 03/12] ceph: add infrastructure for waiting for async create to complete
Date:   Wed, 19 Feb 2020 08:25:17 -0500
Message-Id: <20200219132526.17590-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219132526.17590-1-jlayton@kernel.org>
References: <20200219132526.17590-1-jlayton@kernel.org>
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
 fs/ceph/caps.c       | 13 ++++++++++++-
 fs/ceph/dir.c        |  2 +-
 fs/ceph/mds_client.c | 20 +++++++++++++++++++-
 fs/ceph/mds_client.h |  7 +++++++
 fs/ceph/super.h      |  4 +++-
 5 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d05717397c2a..85e13aa359d2 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -511,7 +511,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
 				struct ceph_inode_info *ci,
 				bool set_timeout)
 {
-	dout("__cap_delay_requeue %p flags %d at %lu\n", &ci->vfs_inode,
+	dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
 	     ci->i_ceph_flags, ci->i_hold_caps_max);
 	if (!mdsc->stopping) {
 		spin_lock(&mdsc->cap_delay_lock);
@@ -1294,6 +1294,13 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
 	int delayed = 0;
 	int ret;
 
+	/* Don't send anything if it's still being created. Return delayed */
+	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
+		spin_unlock(&ci->i_ceph_lock);
+		dout("%s async create in flight for %p\n", __func__, inode);
+		return 1;
+	}
+
 	held = cap->issued | cap->implemented;
 	revoking = cap->implemented & ~cap->issued;
 	retain &= ~revoking;
@@ -2250,6 +2257,10 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	if (datasync)
 		goto out;
 
+	ret = ceph_wait_on_async_create(inode);
+	if (ret)
+		goto out;
+
 	dirty = try_flush_caps(inode, &flush_tid);
 	dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
 
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
index 94d18e643a3d..38eb9dd5062b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2730,7 +2730,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
 int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 			      struct ceph_mds_request *req)
 {
-	int err;
+	int err = 0;
 
 	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
 	if (req->r_inode)
@@ -2743,6 +2743,24 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
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
index 3430d7ffe8f7..bfb03adb4a08 100644
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
@@ -524,6 +524,8 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 #define CEPH_I_ERROR_WRITE	(1 << 10) /* have seen write errors */
 #define CEPH_I_ERROR_FILELOCK	(1 << 11) /* have seen file lock errors */
 #define CEPH_I_ODIRECT		(1 << 12) /* inode in direct I/O mode */
+#define CEPH_ASYNC_CREATE_BIT	(13)	  /* async create in flight for this */
+#define CEPH_I_ASYNC_CREATE	(1 << CEPH_ASYNC_CREATE_BIT)
 
 /*
  * Masks of ceph inode work.
-- 
2.24.1

