Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6EB28BEF6
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Oct 2020 19:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404009AbgJLRVn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Oct 2020 13:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403928AbgJLRVn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 13:21:43 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF41208B8;
        Mon, 12 Oct 2020 17:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602523303;
        bh=N6pZfBx+bp5u+V/xL+mJ9EkfNDvT+4v5hWY+4gu1sdM=;
        h=From:To:Cc:Subject:Date:From;
        b=idH8L8Aza32PnZ7qe7wsKIJYtvXDT9w8+PzMFDs0f3D+c0pPXGBSq2q6ASMscL2Iy
         p9yQ/AnxG/usC5aa8V3RRIB7beO1Bq/2cLdkvYA3xCQHPwgZR0A89M1upYf/t4CNq+
         G/ytExHBErE6r3NdyoAIBJDCPpc9xavhSqLqmQCQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        xiubli@redhat.com
Subject: [PATCH v2] ceph: check session state after bumping session->s_seq
Date:   Mon, 12 Oct 2020 13:21:40 -0400
Message-Id: <20201012172140.602684-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Some messages sent by the MDS entail a session sequence number
increment, and the MDS will drop certain types of requests on the floor
when the sequence numbers don't match.

In particular, a REQUEST_CLOSE message can cross with one of the
sequence morphing messages from the MDS which can cause the client to
stall, waiting for a response that will never come.

Originally, this meant an up to 5s delay before the recurring workqueue
job kicked in and resent the request, but a recent change made it so
that the client would never resend, causing a 60s stall unmounting and
sometimes a blockisting event.

Add a new helper for incrementing the session sequence and then testing
to see whether a REQUEST_CLOSE needs to be resent. Change all of the
bare sequence counter increments to use the new helper.

URL: https://tracker.ceph.com/issues/47563
Fixes: fa9967734227 ("ceph: fix potential mdsc use-after-free crash")
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       |  2 +-
 fs/ceph/mds_client.c | 35 +++++++++++++++++++++++++++++------
 fs/ceph/mds_client.h |  1 +
 fs/ceph/quota.c      |  2 +-
 fs/ceph/snap.c       |  2 +-
 5 files changed, 33 insertions(+), 9 deletions(-)

v2: move seq increment and check for closed session into new helper

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c00abd7eefc1..ba0e4f44862c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4071,7 +4071,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	     vino.snap, inode);
 
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 	dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
 	     (unsigned)seq);
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0190555b1f9e..17b94f06826a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4237,7 +4237,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	     dname.len, dname.name);
 
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 
 	if (!inode) {
 		dout("handle_lease no inode %llx\n", vino.ino);
@@ -4384,14 +4384,25 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 	ceph_force_reconnect(fsc->sb);
 }
 
+static bool check_session_closing(struct ceph_mds_session *s)
+{
+	int ret;
+
+	if (s->s_state != CEPH_MDS_SESSION_CLOSING)
+		return true;
+
+	dout("resending session close request for mds%d\n", s->s_mds);
+	ret = request_close_session(s);
+	if (ret < 0)
+		pr_err("ceph: Unable to close session to mds %d: %d\n", s->s_mds, ret);
+	return false;
+}
+
 bool check_session_state(struct ceph_mds_session *s)
 {
-	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
-		dout("resending session close request for mds%d\n",
-				s->s_mds);
-		request_close_session(s);
+	if (!check_session_closing(s))
 		return false;
-	}
+
 	if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
 		if (s->s_state == CEPH_MDS_SESSION_OPEN) {
 			s->s_state = CEPH_MDS_SESSION_HUNG;
@@ -4408,6 +4419,18 @@ bool check_session_state(struct ceph_mds_session *s)
 	return true;
 }
 
+/*
+ * If the sequence is incremented while we're waiting on a REQUEST_CLOSE reply,
+ * then we need to retransmit that request.
+ */
+void inc_session_sequence(struct ceph_mds_session *s)
+{
+	lockdep_assert_held(&s->s_mutex);
+
+	s->s_seq++;
+	check_session_closing(s);
+}
+
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index cbf8af437140..f5adbebcb38e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -480,6 +480,7 @@ struct ceph_mds_client {
 extern const char *ceph_mds_op_name(int op);
 
 extern bool check_session_state(struct ceph_mds_session *s);
+void inc_session_sequence(struct ceph_mds_session *s);
 
 extern struct ceph_mds_session *
 __ceph_lookup_mds_session(struct ceph_mds_client *, int mds);
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 83cb4f26b689..9b785f11e95a 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -53,7 +53,7 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
 
 	/* increment msg sequence number */
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 	mutex_unlock(&session->s_mutex);
 
 	/* lookup inode */
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 0da39c16dab4..b611f829cb61 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -873,7 +873,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	     ceph_snap_op_name(op), split, trace_len);
 
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 	mutex_unlock(&session->s_mutex);
 
 	down_write(&mdsc->snap_rwsem);
-- 
2.26.2

