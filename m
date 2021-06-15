Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90313A8375
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jun 2021 16:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhFOO7k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Jun 2021 10:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhFOO7j (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 10:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC83761584;
        Tue, 15 Jun 2021 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623769055;
        bh=Jw6Ug6zgXs6K4EVcrCk30dxjE3sccLIEYRwJRtXKBhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOTGPxzgprVWyHHymRt3TszEwxJqco+Nd6RuNdGLD6TO8DsY3tC3jWY+LAsKrDBys
         B0T6N56OTFKukeMSt1JU83rA7lzrl3YMfHG8rCvxidP9NFzJ2oPp0HRdUNlxpXBz8j
         tAzztfK3N86Q4FN11RJA1OyoBECBVuAyJLUY7zeMMV65bU5VDZYXkQHWRqi5xUK0uQ
         vwB8Hq6O7yfgPRU9eNPph8WIyuI8gUod5CU1VYO5vdotG9ikuPkRl5xWTzWZRoMfAV
         mUjIm98UzqslnMx+pb30z17vrZjNHO/N+fDXHWf+c+Q/RD1pNDMm55ElWLBi+FwQ+B
         HRBIGz6bwDHIw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com,
        xiubli@redhat.com
Subject: [RFC PATCH 5/6] ceph: don't take s_mutex in ceph_flush_snaps
Date:   Tue, 15 Jun 2021 10:57:29 -0400
Message-Id: <20210615145730.21952-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145730.21952-1-jlayton@kernel.org>
References: <20210615145730.21952-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 8 +-------
 fs/ceph/snap.c | 4 +---
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d21b1fa36875..5864d5088e27 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1531,7 +1531,7 @@ static inline int __send_flush_snap(struct inode *inode,
  * asynchronously back to the MDS once sync writes complete and dirty
  * data is written out.
  *
- * Called under i_ceph_lock.  Takes s_mutex as needed.
+ * Called under i_ceph_lock.
  */
 static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 			       struct ceph_mds_session *session)
@@ -1653,7 +1653,6 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 	mds = ci->i_auth_cap->session->s_mds;
 	if (session && session->s_mds != mds) {
 		dout(" oops, wrong session %p mutex\n", session);
-		mutex_unlock(&session->s_mutex);
 		ceph_put_mds_session(session);
 		session = NULL;
 	}
@@ -1662,10 +1661,6 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 		mutex_lock(&mdsc->mutex);
 		session = __ceph_lookup_mds_session(mdsc, mds);
 		mutex_unlock(&mdsc->mutex);
-		if (session) {
-			dout(" inverting session/ino locks on %p\n", session);
-			mutex_lock(&session->s_mutex);
-		}
 		goto retry;
 	}
 
@@ -1680,7 +1675,6 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 	if (psession) {
 		*psession = session;
 	} else if (session) {
-		mutex_unlock(&session->s_mutex);
 		ceph_put_mds_session(session);
 	}
 	/* we flushed them all; remove this inode from the queue */
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index f8cac2abab3f..afc7f4c32364 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -846,10 +846,8 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	}
 	spin_unlock(&mdsc->snap_flush_lock);
 
-	if (session) {
-		mutex_unlock(&session->s_mutex);
+	if (session)
 		ceph_put_mds_session(session);
-	}
 	dout("flush_snaps done\n");
 }
 
-- 
2.31.1

