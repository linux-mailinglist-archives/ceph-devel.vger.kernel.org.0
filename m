Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D727174CBF
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403959AbfGYLRx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403933AbfGYLRw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:52 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83EE022CB8
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053470;
        bh=Rux7/163cWSGQ0RprLu1Dkvzv0aX4lAswfZRY2MS4MI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JmK7gWHdPPWVAY7KVl/3esZo3lAtjGwXIZ9QcObhQrWWCFLMGwQSltABz8Tz1cEXu
         UaWfD4tJgsZKnNjUeU0v4XpUyACI/eDYIUcZBFAywLvm5bAzsiYr4pQfDDlrp3Ku7k
         nkaI9rd3B6qYRYsmh7J8aJO0P3Ku+oFUvI6roBHo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 5/8] ceph: have __mark_caps_flushing return flush_tid
Date:   Thu, 25 Jul 2019 07:17:43 -0400
Message-Id: <20190725111746.10393-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
References: <20190725111746.10393-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, this function returns ci->i_dirty_caps, but the callers have
to check that that isn't 0 before calling this function. Have the
callers grab that value directly out of the inode, and have
__mark_caps_flushing return the flush_tid instead.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2563f42445e6..6b8300d72cac 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1722,11 +1722,11 @@ static bool __finish_cap_flush(struct ceph_mds_client *mdsc,
  * Add dirty inode to the flushing list.  Assigned a seq number so we
  * can wait for caps to flush without starving.
  *
- * Called under i_ceph_lock.
+ * Called under i_ceph_lock. Returns the flush tid.
  */
-static int __mark_caps_flushing(struct inode *inode,
+static u64 __mark_caps_flushing(struct inode *inode,
 				struct ceph_mds_session *session, bool wake,
-				u64 *flush_tid, u64 *oldest_flush_tid)
+				u64 *oldest_flush_tid)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -1765,8 +1765,7 @@ static int __mark_caps_flushing(struct inode *inode,
 
 	list_add_tail(&cf->i_list, &ci->i_cap_flush_list);
 
-	*flush_tid = cf->tid;
-	return flushing;
+	return cf->tid;
 }
 
 /*
@@ -2056,9 +2055,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		}
 
 		if (cap == ci->i_auth_cap && ci->i_dirty_caps) {
-			flushing = __mark_caps_flushing(inode, session, false,
-							&flush_tid,
-							&oldest_flush_tid);
+			flushing = ci->i_dirty_caps;
+			flush_tid = __mark_caps_flushing(inode, session, false,
+							 &oldest_flush_tid);
 		} else {
 			flushing = 0;
 			flush_tid = 0;
@@ -2137,8 +2136,9 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 			goto retry_locked;
 		}
 
-		flushing = __mark_caps_flushing(inode, session, true,
-						&flush_tid, &oldest_flush_tid);
+		flushing = ci->i_dirty_caps;
+		flush_tid = __mark_caps_flushing(inode, session, true,
+						 &oldest_flush_tid);
 
 		/* __send_cap drops i_ceph_lock */
 		delayed = __send_cap(mdsc, cap, CEPH_CAP_OP_FLUSH,
-- 
2.21.0

