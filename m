Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C110B74CC1
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403950AbfGYLRy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403942AbfGYLRw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:52 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9022522BF5
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053471;
        bh=5PI+8PGCaZE3iUPGdSx2j+kMtobuFJGA7Fem2ilLNu4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RQlwp8usjmSkagdx3BVYZOSsfMnx1dSoB1S8KmqtvyZ+LWp3le38U86U4Asyr6FLw
         k402R9Y6O0wkY/1+ZhxVTAZg7CthhLFKblFh/9GB/5AyGfUeGQ9dYh8KsIOOxqxz8N
         KN5mue/0EZxLitq14QAPBB4hmBg/tOHbvL6YyK3U=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 7/8] ceph: remove CEPH_I_NOFLUSH
Date:   Thu, 25 Jul 2019 07:17:45 -0400
Message-Id: <20190725111746.10393-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
References: <20190725111746.10393-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Nothing sets this flag.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 10 ----------
 fs/ceph/super.h | 19 +++++++++----------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index bb91abaf7559..b1c80d837d0d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2003,11 +2003,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		}
 
 ack:
-		if (ci->i_ceph_flags & CEPH_I_NOFLUSH) {
-			dout(" skipping %p I_NOFLUSH set\n", inode);
-			continue;
-		}
-
 		if (session && session != cap->session) {
 			dout("oops, wrong session %p mutex\n", session);
 			mutex_unlock(&session->s_mutex);
@@ -2105,11 +2100,6 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 retry:
 	spin_lock(&ci->i_ceph_lock);
 retry_locked:
-	if (ci->i_ceph_flags & CEPH_I_NOFLUSH) {
-		spin_unlock(&ci->i_ceph_lock);
-		dout("try_flush_caps skipping %p I_NOFLUSH set\n", inode);
-		goto out;
-	}
 	if (ci->i_dirty_caps && ci->i_auth_cap) {
 		struct ceph_cap *cap = ci->i_auth_cap;
 		int delayed;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 817bab741267..9c374ae679dd 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -507,16 +507,15 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 #define CEPH_I_DIR_ORDERED	(1 << 0)  /* dentries in dir are ordered */
 #define CEPH_I_NODELAY		(1 << 1)  /* do not delay cap release */
 #define CEPH_I_FLUSH		(1 << 2)  /* do not delay flush of dirty metadata */
-#define CEPH_I_NOFLUSH		(1 << 3)  /* do not flush dirty caps */
-#define CEPH_I_POOL_PERM	(1 << 4)  /* pool rd/wr bits are valid */
-#define CEPH_I_POOL_RD		(1 << 5)  /* can read from pool */
-#define CEPH_I_POOL_WR		(1 << 6)  /* can write to pool */
-#define CEPH_I_SEC_INITED	(1 << 7)  /* security initialized */
-#define CEPH_I_CAP_DROPPED	(1 << 8)  /* caps were forcibly dropped */
-#define CEPH_I_KICK_FLUSH	(1 << 9)  /* kick flushing caps */
-#define CEPH_I_FLUSH_SNAPS	(1 << 10) /* need flush snapss */
-#define CEPH_I_ERROR_WRITE	(1 << 11) /* have seen write errors */
-#define CEPH_I_ERROR_FILELOCK	(1 << 12) /* have seen file lock errors */
+#define CEPH_I_POOL_PERM	(1 << 3)  /* pool rd/wr bits are valid */
+#define CEPH_I_POOL_RD		(1 << 4)  /* can read from pool */
+#define CEPH_I_POOL_WR		(1 << 5)  /* can write to pool */
+#define CEPH_I_SEC_INITED	(1 << 6)  /* security initialized */
+#define CEPH_I_CAP_DROPPED	(1 << 7)  /* caps were forcibly dropped */
+#define CEPH_I_KICK_FLUSH	(1 << 8)  /* kick flushing caps */
+#define CEPH_I_FLUSH_SNAPS	(1 << 9) /* need flush snapss */
+#define CEPH_I_ERROR_WRITE	(1 << 10) /* have seen write errors */
+#define CEPH_I_ERROR_FILELOCK	(1 << 11) /* have seen file lock errors */
 
 
 /*
-- 
2.21.0

