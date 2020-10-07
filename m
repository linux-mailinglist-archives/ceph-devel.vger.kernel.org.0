Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661C8285EEB
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 14:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgJGMRI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 08:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgJGMRH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 08:17:07 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B13D12083B;
        Wed,  7 Oct 2020 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602073026;
        bh=Pmn0r+QYHa3Bs/rM4XPTEd4PyedxghVr/om1n8FCD8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuV8p4n4YRkguMMykJIcKbzQdo5ktaiwkoQGk70lrWrKBvSnXtd9avdDrN8Ma1MwW
         Fgi5A2wojPHRPWTsy+eWgkQxdErtNe9w8Xex8iH5nFGvhDOpb836Efdvj5+RmHTrzq
         sSAvKoB19fkwIG3gIarHtqsXSCNWjqYUXyUW/W/M=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [PATCH v4 3/5] ceph: add new RECOVER mount_state when recovering session
Date:   Wed,  7 Oct 2020 08:16:58 -0400
Message-Id: <20201007121700.10489-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007121700.10489-1-jlayton@kernel.org>
References: <20201007121700.10489-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When recovering a session (a'la recover_session=clean), we want to do
all of the operations that we do on a forced umount, but changing the
mount state to SHUTDOWN is can cause queued MDS requests to fail when
the session comes back. Most of those can idle until the session is
recovered in this situation.

Reserve SHUTDOWN state for forced umount, and make a new RECOVER state
for the forced reconnect situation. Change several tests for equality with
SHUTDOWN to test for that or RECOVER.

Cc: "Yan, Zheng" <ukernel@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c               |  4 ++--
 fs/ceph/caps.c               |  2 +-
 fs/ceph/inode.c              |  2 +-
 fs/ceph/mds_client.c         |  4 ++--
 fs/ceph/super.c              | 14 ++++++++++----
 include/linux/ceph/libceph.h |  1 +
 6 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 97827f68a3e7..16d5072e1b7e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -841,7 +841,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 	     wbc->sync_mode == WB_SYNC_NONE ? "NONE" :
 	     (wbc->sync_mode == WB_SYNC_ALL ? "ALL" : "HOLD"));
 
-	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
+	if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
 		if (ci->i_wrbuffer_ref > 0) {
 			pr_warn_ratelimited(
 				"writepage_start %p %lld forced umount\n",
@@ -1265,7 +1265,7 @@ ceph_find_incompatible(struct page *page)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
-	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
+	if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
 		dout(" page %p forced umount\n", page);
 		return ERR_PTR(-EIO);
 	}
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2ee3f316afcf..12fe4d0ae958 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2735,7 +2735,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 			goto out_unlock;
 		}
 
-		if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
+		if (READ_ONCE(mdsc->fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
 			dout("get_cap_refs %p forced umount\n", inode);
 			ret = -EIO;
 			goto out_unlock;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 526faf4778ce..02b11a4a4d39 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1888,7 +1888,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 
 	mutex_lock(&ci->i_truncate_mutex);
 
-	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
+	if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
 		pr_warn_ratelimited("invalidate_pages %p %lld forced umount\n",
 				    inode, ceph_ino(inode));
 		mapping_set_error(inode->i_mapping, -EIO);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 6b408851eea1..91de271d0093 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1595,7 +1595,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		struct ceph_cap_flush *cf;
 		struct ceph_mds_client *mdsc = fsc->mdsc;
 
-		if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
+		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
 			if (inode->i_data.nrpages > 0)
 				invalidate = true;
 			if (ci->i_wrbuffer_ref > 0)
@@ -4658,7 +4658,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
 {
 	u64 want_tid, want_flush;
 
-	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
+	if (READ_ONCE(mdsc->fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN)
 		return;
 
 	dout("sync\n");
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 2516304379d3..2f530a111b3a 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -832,6 +832,13 @@ static void destroy_caches(void)
 	ceph_fscache_unregister();
 }
 
+static void __ceph_umount_begin(struct ceph_fs_client *fsc)
+{
+	ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
+	ceph_mdsc_force_umount(fsc->mdsc);
+	fsc->filp_gen++; // invalidate open files
+}
+
 /*
  * ceph_umount_begin - initiate forced umount.  Tear down the
  * mount, skipping steps that may hang while waiting for server(s).
@@ -844,9 +851,7 @@ static void ceph_umount_begin(struct super_block *sb)
 	if (!fsc)
 		return;
 	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
-	ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
-	ceph_mdsc_force_umount(fsc->mdsc);
-	fsc->filp_gen++; // invalidate open files
+	__ceph_umount_begin(fsc);
 }
 
 static const struct super_operations ceph_super_ops = {
@@ -1235,7 +1240,8 @@ int ceph_force_reconnect(struct super_block *sb)
 	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 	int err = 0;
 
-	ceph_umount_begin(sb);
+	fsc->mount_state = CEPH_MOUNT_RECOVER;
+	__ceph_umount_begin(fsc);
 
 	/* Make sure all page caches get invalidated.
 	 * see remove_session_caps_cb() */
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index c8645f0b797d..eb5a7ca13f9c 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -104,6 +104,7 @@ enum {
 	CEPH_MOUNT_UNMOUNTING,
 	CEPH_MOUNT_UNMOUNTED,
 	CEPH_MOUNT_SHUTDOWN,
+	CEPH_MOUNT_RECOVER,
 };
 
 static inline unsigned long ceph_timeout_jiffies(unsigned long timeout)
-- 
2.26.2

