Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B57284E57
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Oct 2020 16:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgJFOzd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Oct 2020 10:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgJFOzc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 10:55:32 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEAF720789;
        Tue,  6 Oct 2020 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996132;
        bh=kLFmp5Dzc242ZFcd1UBywGbxeYTbNVYXxUPXRIJl6XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJStYxa3OBTPpjSgffux2onwY9w+50ZYImsD8if/uj9tr0c/dkkLD7m8EJbZAGUBO
         kP5mBN2qshykEKtiW6MnP2k/i0yqSBfwKO+qxQdnsUdHKeKDqYEGMoNiZT8ExZ99kE
         J1Y7ZBbnzNMuzgGis5AhjW9rOAsCJdK3zo6q5jcc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [PATCH v3 3/5] ceph: don't mark mount as SHUTDOWN when recovering session
Date:   Tue,  6 Oct 2020 10:55:24 -0400
Message-Id: <20201006145526.313151-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006145526.313151-1-jlayton@kernel.org>
References: <20201006145526.313151-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When recovering a session (a'la recover_session=clean), we want to do
all of the operations that we do on a forced umount, but changing the
mount state to SHUTDOWN is can cause queued MDS requests to fail when
the session comes back.

Reserve SHUTDOWN state for forced umount, and make a new RECOVER state
for the forced reconnect situation.

Cc: "Yan, Zheng" <ukernel@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>

SQUASH: add new CEPH_MOUNT_RECOVER state

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c              |  2 +-
 fs/ceph/mds_client.c         |  2 +-
 fs/ceph/super.c              | 14 ++++++++++----
 include/linux/ceph/libceph.h |  1 +
 4 files changed, 13 insertions(+), 6 deletions(-)

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
index 6b408851eea1..cd46f7e40370 100644
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

