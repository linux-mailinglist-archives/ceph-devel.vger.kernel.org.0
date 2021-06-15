Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF83A8373
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jun 2021 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhFOO7i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Jun 2021 10:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231276AbhFOO7i (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 10:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6862E61580;
        Tue, 15 Jun 2021 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623769053;
        bh=sDVMMthhyUVe5W+rTg9O+ruL0K15mWRXAwUVogA8org=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyMvSfW0Wx41CkEQ0jOdTzhLxd61dNYDz7ssj/JKU9l8U6z/rcpAbaNOA1Ji2BArv
         iRNzXaUICAT8v+HB5IssUFuNql3VhPFhgLc//mHbXnjt7cGURQp70HFA5TPSMRUg6z
         WnEYoHmqBogaV7anv8Z4du/U19eKHc+WyD5DnaDZ87ZRnmwfUMhCxjIYc9i0QXe8Gw
         BqsPqafJLQdRm+3/96tKolahtB3MS3Qul5w9GuVDvWeiRghiazqzToY+vn69hSUdT7
         xNnK6J3D3MoQg4A0zrbIMgixmB1JQp2aB9RL349PQ+cYMj9rFgAmEcYsWacDjxABqg
         FpXA2dEOFvPXg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com,
        xiubli@redhat.com
Subject: [RFC PATCH 3/6] ceph: don't take s_mutex or snap_rwsem in ceph_check_caps
Date:   Tue, 15 Jun 2021 10:57:27 -0400
Message-Id: <20210615145730.21952-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145730.21952-1-jlayton@kernel.org>
References: <20210615145730.21952-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

These locks appear to be completely unnecessary. Almost all of this
function is done under the inode->i_ceph_lock, aside from the actual
sending of the message. Don't take either lock in this function.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 61 ++++++--------------------------------------------
 1 file changed, 7 insertions(+), 54 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 919eada97a1f..825b1e463ad3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1912,7 +1912,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	struct ceph_cap *cap;
 	u64 flush_tid, oldest_flush_tid;
 	int file_wanted, used, cap_used;
-	int took_snap_rwsem = 0;             /* true if mdsc->snap_rwsem held */
 	int issued, implemented, want, retain, revoking, flushing = 0;
 	int mds = -1;   /* keep track of how far we've gone through i_caps list
 			   to avoid an infinite loop on retry */
@@ -1920,6 +1919,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	bool queue_invalidate = false;
 	bool tried_invalidate = false;
 
+	if (session)
+		ceph_get_mds_session(session);
+
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_FLUSH)
 		flags |= CHECK_CAPS_FLUSH;
@@ -2021,8 +2023,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		    ((flags & CHECK_CAPS_AUTHONLY) && cap != ci->i_auth_cap))
 			continue;
 
-		/* NOTE: no side-effects allowed, until we take s_mutex */
-
 		/*
 		 * If we have an auth cap, we don't need to consider any
 		 * overlapping caps as used.
@@ -2085,37 +2085,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			continue;     /* nope, all good */
 
 ack:
-		if (session && session != cap->session) {
-			dout("oops, wrong session %p mutex\n", session);
-			mutex_unlock(&session->s_mutex);
-			session = NULL;
-		}
-		if (!session) {
-			session = cap->session;
-			if (mutex_trylock(&session->s_mutex) == 0) {
-				dout("inverting session/ino locks on %p\n",
-				     session);
-				session = ceph_get_mds_session(session);
-				spin_unlock(&ci->i_ceph_lock);
-				if (took_snap_rwsem) {
-					up_read(&mdsc->snap_rwsem);
-					took_snap_rwsem = 0;
-				}
-				if (session) {
-					mutex_lock(&session->s_mutex);
-					ceph_put_mds_session(session);
-				} else {
-					/*
-					 * Because we take the reference while
-					 * holding the i_ceph_lock, it should
-					 * never be NULL. Throw a warning if it
-					 * ever is.
-					 */
-					WARN_ON_ONCE(true);
-				}
-				goto retry;
-			}
-		}
+		ceph_put_mds_session(session);
+		session = ceph_get_mds_session(cap->session);
 
 		/* kick flushing and flush snaps before sending normal
 		 * cap message */
@@ -2130,19 +2101,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			goto retry_locked;
 		}
 
-		/* take snap_rwsem after session mutex */
-		if (!took_snap_rwsem) {
-			if (down_read_trylock(&mdsc->snap_rwsem) == 0) {
-				dout("inverting snap/in locks on %p\n",
-				     inode);
-				spin_unlock(&ci->i_ceph_lock);
-				down_read(&mdsc->snap_rwsem);
-				took_snap_rwsem = 1;
-				goto retry;
-			}
-			took_snap_rwsem = 1;
-		}
-
 		if (cap == ci->i_auth_cap && ci->i_dirty_caps) {
 			flushing = ci->i_dirty_caps;
 			flush_tid = __mark_caps_flushing(inode, session, false,
@@ -2179,13 +2137,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_put_mds_session(session);
 	if (queue_invalidate)
 		ceph_queue_invalidate(inode);
-
-	if (session)
-		mutex_unlock(&session->s_mutex);
-	if (took_snap_rwsem)
-		up_read(&mdsc->snap_rwsem);
 }
 
 /*
@@ -3550,13 +3504,12 @@ static void handle_cap_grant(struct inode *inode,
 	if (wake)
 		wake_up_all(&ci->i_cap_wq);
 
+	mutex_unlock(&session->s_mutex);
 	if (check_caps == 1)
 		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL,
 				session);
 	else if (check_caps == 2)
 		ceph_check_caps(ci, CHECK_CAPS_NOINVAL, session);
-	else
-		mutex_unlock(&session->s_mutex);
 }
 
 /*
-- 
2.31.1

