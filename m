Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCDB403A3D
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 15:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbhIHNEy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 09:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233891AbhIHNEt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 09:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C3426115C;
        Wed,  8 Sep 2021 13:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631106218;
        bh=sC3gWkv8KG1mjSBvksXtHYgor4eR3VJ6E7kfjJx5elE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrOaQJwAOkS4hz6N2Ez8QARBEhjWBaLs6jYJtWzUxPR0mSX7VXUK4LOtQjT2ZG80g
         uBoS5nJdzLTGrGK/JZiSduxuqyGQqBq03ZgjZBnHM+9SSd1VprQjp/QwxaAIdNW/yK
         4I4KiSR+oW4V8R3ZuIOpKh3eA46g6qR2pgObJyZfd43sBENP7Aej6ZZ4V/H1/UrVpL
         C4atGBb4UIWo+6IbVIq+RP5eUaEYobGaUEOH9Qgt2v85QBXUI9T6OmlDPnVjThzugd
         qBgg7xv20+QUlRUFdMLZShAslrtSfYCYFn/GuXYT66xIlpNlqVcFAufiPHtNairkhp
         01z764F+jxgZw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH 1/6] ceph: print inode numbers instead of pointer values
Date:   Wed,  8 Sep 2021 09:03:31 -0400
Message-Id: <20210908130336.56668-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210908130336.56668-1-jlayton@kernel.org>
References: <20210908130336.56668-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We have a lot of log messages that print inode pointer values. This is
of dubious utility. Switch a random assortment of the ones I've found
most useful to use ceph_vinop to print the snap:inum tuple instead.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 8 ++++----
 fs/ceph/file.c  | 2 +-
 fs/ceph/inode.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 26be19d23ed6..b89c23a0b440 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1969,8 +1969,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		}
 	}
 
-	dout("check_caps %p file_want %s used %s dirty %s flushing %s"
-	     " issued %s revoking %s retain %s %s%s\n", inode,
+	dout("check_caps %llx:%llx file_want %s used %s dirty %s flushing %s"
+	     " issued %s revoking %s retain %s %s%s\n", ceph_vinop(inode),
 	     ceph_cap_string(file_wanted),
 	     ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
 	     ceph_cap_string(ci->i_flushing_caps),
@@ -1991,7 +1991,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	    (revoking & (CEPH_CAP_FILE_CACHE|
 			 CEPH_CAP_FILE_LAZYIO)) && /*  or revoking cache */
 	    !tried_invalidate) {
-		dout("check_caps trying to invalidate on %p\n", inode);
+		dout("check_caps trying to invalidate on %llx:%llx\n", ceph_vinop(inode));
 		if (try_nonblocking_invalidate(inode) < 0) {
 			dout("check_caps queuing invalidate\n");
 			queue_invalidate = true;
@@ -4334,7 +4334,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
 				      i_dirty_item);
 		inode = &ci->vfs_inode;
 		ihold(inode);
-		dout("flush_dirty_caps %p\n", inode);
+		dout("flush_dirty_caps %llx:%llx\n", ceph_vinop(inode));
 		spin_unlock(&mdsc->cap_dirty_lock);
 		ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
 		iput(inode);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3daebfaec8c6..175366eede23 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -557,7 +557,7 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 		}
 		ceph_kick_flushing_inode_caps(req->r_session, ci);
 		spin_unlock(&ci->i_ceph_lock);
-	} else {
+	} else if (!result) {
 		pr_warn("%s: no req->r_target_inode for 0x%llx\n", __func__,
 			req->r_deleg_ino);
 	}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 61ecf81ed875..43c02c4b2631 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1851,8 +1851,8 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	mutex_lock(&ci->i_truncate_mutex);
 
 	if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
-		pr_warn_ratelimited("invalidate_pages %p %lld forced umount\n",
-				    inode, ceph_ino(inode));
+		pr_warn_ratelimited("%s: inode %llx:%llx is shut down\n",
+				    __func__, ceph_vinop(inode));
 		mapping_set_error(inode->i_mapping, -EIO);
 		truncate_pagecache(inode, 0);
 		mutex_unlock(&ci->i_truncate_mutex);
@@ -1874,7 +1874,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 
 	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
-		pr_err("invalidate_pages %p fails\n", inode);
+		pr_err("invalidate_pages %llx:%llx failed\n", ceph_vinop(inode));
 	}
 
 	spin_lock(&ci->i_ceph_lock);
-- 
2.31.1

