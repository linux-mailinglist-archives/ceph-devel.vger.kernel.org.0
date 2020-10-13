Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6E28CDBE
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Oct 2020 14:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgJMMCc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Oct 2020 08:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbgJMMCZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 08:02:25 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB25E206D9;
        Tue, 13 Oct 2020 12:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602590544;
        bh=vXWoXdjL8NGrqE4RIVrf8WnusQgXUFFgor0O6o395Pk=;
        h=From:To:Cc:Subject:Date:From;
        b=Dr+B5p9eRtdFD7QgSPTqWvb2nX372hNa5+EH1xPgs3oCImgnAjrCERF8cGe6vmMiF
         6OxS2qhs2duiBrUHw/drgzQ2yOKaERZMQPLhks8lf4u4GOllWiU6uo5/+UWZ6pU60D
         f4Y1gKne+QEKUw0MRXpi8mGm+qGZGisBNJLs1NGE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        xiubli@redhat.com
Subject: [PATCH v3] ceph: check session state after bumping session->s_seq
Date:   Tue, 13 Oct 2020 08:02:21 -0400
Message-Id: <20201013120221.322461-1-jlayton@kernel.org>
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
to see whether a REQUEST_CLOSE needs to be resent, and move the handling
of CEPH_MDS_SESSION_CLOSING into that function. Change all of the
bare sequence counter increments to use the new helper.

Reorganize check_session_state with a switch statement.  It should no
longer be called when the session is CLOSING, so throw a warning if it
ever is (but still handle that case sanely).

URL: https://tracker.ceph.com/issues/47563
Fixes: fa9967734227 ("ceph: fix potential mdsc use-after-free crash")
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       |  2 +-
 fs/ceph/mds_client.c | 51 ++++++++++++++++++++++++++++++--------------
 fs/ceph/mds_client.h |  1 +
 fs/ceph/quota.c      |  2 +-
 fs/ceph/snap.c       |  2 +-
 5 files changed, 39 insertions(+), 19 deletions(-)

v3: reorganize check_session_state with switch statement. Don't attempt
    to reconnect in there, but do throw a warning if it's called while
    the session is CLOSING.

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
index 0190555b1f9e..00c0dc33f92e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4237,7 +4237,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	     dname.len, dname.name);
 
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 
 	if (!inode) {
 		dout("handle_lease no inode %llx\n", vino.ino);
@@ -4386,28 +4386,47 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 
 bool check_session_state(struct ceph_mds_session *s)
 {
-	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
-		dout("resending session close request for mds%d\n",
-				s->s_mds);
-		request_close_session(s);
-		return false;
-	}
-	if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
-		if (s->s_state == CEPH_MDS_SESSION_OPEN) {
+
+	switch (s->s_state) {
+	case CEPH_MDS_SESSION_OPEN:
+		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
 			s->s_state = CEPH_MDS_SESSION_HUNG;
 			pr_info("mds%d hung\n", s->s_mds);
 		}
-	}
-	if (s->s_state == CEPH_MDS_SESSION_NEW ||
-	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
-	    s->s_state == CEPH_MDS_SESSION_CLOSED ||
-	    s->s_state == CEPH_MDS_SESSION_REJECTED)
-		/* this mds is failed or recovering, just wait */
+		break;
+	case CEPH_MDS_SESSION_CLOSING:
+		/* Should never reach this when we're unmounting */
+		WARN_ON_ONCE(true);
+		fallthrough;
+	case CEPH_MDS_SESSION_NEW:
+	case CEPH_MDS_SESSION_RESTARTING:
+	case CEPH_MDS_SESSION_CLOSED:
+	case CEPH_MDS_SESSION_REJECTED:
 		return false;
-
+	}
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
+
+	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
+		int ret;
+
+		dout("resending session close request for mds%d\n", s->s_mds);
+		ret = request_close_session(s);
+		if (ret < 0)
+			pr_err("ceph: Unable to close session to mds %d: %d\n", s->s_mds, ret);
+	}
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

