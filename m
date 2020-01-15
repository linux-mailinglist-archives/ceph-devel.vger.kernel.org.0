Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5893F13CE72
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 21:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgAOU7X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jan 2020 15:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729524AbgAOU7V (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 15:59:21 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63DB3207FF;
        Wed, 15 Jan 2020 20:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579121961;
        bh=jj8gnR7BXIM+v29L9EUR/Kto2mK9F4RgeCKScuR2TBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDm+UvBkuEmZ8xDhEHN4svHDjwzO3g/bKClOM+mLS4Ao6Tb5hvvC0BECviNBKjjDU
         YGDXD8drHXCVXpmecJvZjLwZcjWmAFLizQDg/+qXDjBlv/VRKbbljBkX9Jmtt6KYqS
         ZBujiN27u1PBe+HAwIE54br1VN3vEtxHytuPdZ4M=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [RFC PATCH v2 07/10] ceph: add infrastructure for waiting for async create to complete
Date:   Wed, 15 Jan 2020 15:59:09 -0500
Message-Id: <20200115205912.38688-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115205912.38688-1-jlayton@kernel.org>
References: <20200115205912.38688-1-jlayton@kernel.org>
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
 fs/ceph/caps.c       |  9 ++++++++-
 fs/ceph/dir.c        |  2 +-
 fs/ceph/mds_client.c | 12 +++++++++++-
 fs/ceph/super.h      |  4 +++-
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c983990acb75..9d1a3d6831f7 100644
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
@@ -1298,6 +1298,13 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
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
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0d97c2962314..b2bcd01ab4e9 100644
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
index f06496bb5705..e49ca0533df1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2806,14 +2806,24 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
 	}
 }
 
+static int ceph_wait_on_async_create(struct inode *inode)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
+			   TASK_INTERRUPTIBLE);
+}
+
 int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
 			      struct ceph_mds_request *req)
 {
 	int err;
 
 	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
-	if (req->r_inode)
+	if (req->r_inode) {
+		ceph_wait_on_async_create(req->r_inode);
 		ceph_get_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
+	}
 	if (req->r_parent) {
 		ceph_get_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
 		ihold(req->r_parent);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index cb7b549f0995..86dd4a2163e0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -319,7 +319,7 @@ struct ceph_inode_info {
 	u64 i_inline_version;
 	u32 i_time_warp_seq;
 
-	unsigned i_ceph_flags;
+	unsigned long i_ceph_flags;
 	atomic64_t i_release_count;
 	atomic64_t i_ordered_count;
 	atomic64_t i_complete_seq[2];
@@ -527,6 +527,8 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 #define CEPH_I_ERROR_WRITE	(1 << 10) /* have seen write errors */
 #define CEPH_I_ERROR_FILELOCK	(1 << 11) /* have seen file lock errors */
 #define CEPH_I_ODIRECT		(1 << 12) /* inode in direct I/O mode */
+#define CEPH_ASYNC_CREATE_BIT	(13)	  /* async create in flight for this */
+#define CEPH_I_ASYNC_CREATE	(1 << CEPH_ASYNC_CREATE_BIT)
 
 /*
  * Masks of ceph inode work.
-- 
2.24.1

