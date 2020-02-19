Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542F616454C
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 14:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBSNZa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 08:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgBSNZa (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:25:30 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 547B52465D;
        Wed, 19 Feb 2020 13:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582118729;
        bh=SBl7u79Zw/3cghaZRQQ7tE31FQXNNbIFXMxIWWjeZbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oW+U76HRi4KZNTr5XD3rlkgcIUKZEk2DZ/htcq5hfzhRgSU9pqiIGg4ihNeVCCALO
         aZTnHnuMS49XdHU5qWoDQl2SYzgIFlX5bymAyvqiPEtSqBnBRKfZVWSJ4ifYAHLPrK
         JReP5d16KiwOj7oaMiSKEjQsLuuorTyVCBb/Ecro=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [PATCH v5 02/12] ceph: track primary dentry link
Date:   Wed, 19 Feb 2020 08:25:16 -0500
Message-Id: <20200219132526.17590-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219132526.17590-1-jlayton@kernel.org>
References: <20200219132526.17590-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Newer versions of the MDS will flag a dentry as "primary". In later
patches, we'll need to consult this info, so track it in di->flags.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c                | 1 +
 fs/ceph/inode.c              | 8 +++++++-
 fs/ceph/super.h              | 1 +
 include/linux/ceph/ceph_fs.h | 3 +++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index d0cd0aba5843..a87274935a09 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1411,6 +1411,7 @@ void ceph_invalidate_dentry_lease(struct dentry *dentry)
 	spin_lock(&dentry->d_lock);
 	di->time = jiffies;
 	di->lease_shared_gen = 0;
+	di->flags &= ~CEPH_DENTRY_PRIMARY_LINK;
 	__dentry_lease_unlist(di);
 	spin_unlock(&dentry->d_lock);
 }
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9869ec101e88..7478bd0283c1 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1051,6 +1051,7 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
 				  struct ceph_mds_session **old_lease_session)
 {
 	struct ceph_dentry_info *di = ceph_dentry(dentry);
+	unsigned mask = le16_to_cpu(lease->mask);
 	long unsigned duration = le32_to_cpu(lease->duration_ms);
 	long unsigned ttl = from_time + (duration * HZ) / 1000;
 	long unsigned half_ttl = from_time + (duration * HZ / 2) / 1000;
@@ -1062,8 +1063,13 @@ static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
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
index 37dc1ac8f6c3..3430d7ffe8f7 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -284,6 +284,7 @@ struct ceph_dentry_info {
 #define CEPH_DENTRY_REFERENCED		1
 #define CEPH_DENTRY_LEASE_LIST		2
 #define CEPH_DENTRY_SHRINK_LIST		4
+#define CEPH_DENTRY_PRIMARY_LINK	8
 
 struct ceph_inode_xattrs_info {
 	/*
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 9f747a1b8788..94cc4b047987 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -531,6 +531,9 @@ struct ceph_mds_reply_lease {
 	__le32 seq;
 } __attribute__ ((packed));
 
+#define CEPH_LEASE_VALID        (1 | 2) /* old and new bit values */
+#define CEPH_LEASE_PRIMARY_LINK 4       /* primary linkage */
+
 struct ceph_mds_reply_dirfrag {
 	__le32 frag;            /* fragment */
 	__le32 auth;            /* auth mds, if this is a delegation point */
-- 
2.24.1

