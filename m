Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64D928BB9A
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Oct 2020 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389669AbgJLPNa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Oct 2020 11:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389225AbgJLPNa (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 11:13:30 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30A2E20878;
        Mon, 12 Oct 2020 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602515609;
        bh=MNDtc6dUQVevyeTWYuPPMJqdh4dQX1y5XbhV8VzLl9g=;
        h=From:To:Cc:Subject:Date:From;
        b=BvZRJon41mR/3orEfEeTsdJqMfI1oPl1+y5+HkDWLDKZXCjFOiHopuLb1tpDsSoWW
         MFIycQ010/7+02fW2s3w6WrTYpNaziaxWtmK4QtQTR3DN6RnToL4/78JRXyB+2b5Cf
         e2UItmSbwbxuoF9gLqsqk7KPLH6VApLHkfwAP8Wc=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com
Cc:     ukernel@gmail.com, pdonnell@redhat.com, xiubli@redhat.com,
        ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: check session state after bumping session->s_seq
Date:   Mon, 12 Oct 2020 11:13:26 -0400
Message-Id: <20201012151326.310268-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Some messages sent by the MDS entail a session sequence number
increment, and the MDS will drop certain types of requests on the floor
when the sequence numbers don't match.

In particular, a REQUEST_CLOSE message can cross with one of sequence
morphing messages from the MDS, which can cause the client to stall,
waiting for a response that will never come.

Originally, this meant an up to 5s delay before the recurring workqueue
job kicked in and resent the request, but a recent change made it so
that the client would never resend, causing a 60s stall unmounting and
sometimes a blockisting event.

Fix this by checking the connection state after bumping the session
sequence, which should cause a retransmit of the REQUEST_CLOSE, when
this occurs.

URL: https://tracker.ceph.com/issues/47563
Fixes: fa9967734227 ("ceph: fix potential mdsc use-after-free crash")
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 1 +
 fs/ceph/mds_client.c | 1 +
 fs/ceph/quota.c      | 1 +
 fs/ceph/snap.c       | 1 +
 4 files changed, 4 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c00abd7eefc1..ac822c74baea 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4072,6 +4072,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
 	mutex_lock(&session->s_mutex);
 	session->s_seq++;
+	check_session_state(session);
 	dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
 	     (unsigned)seq);
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0190555b1f9e..69f529d894e6 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4238,6 +4238,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 
 	mutex_lock(&session->s_mutex);
 	session->s_seq++;
+	check_session_state(session);
 
 	if (!inode) {
 		dout("handle_lease no inode %llx\n", vino.ino);
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 83cb4f26b689..a09667ee83c1 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -54,6 +54,7 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
 	/* increment msg sequence number */
 	mutex_lock(&session->s_mutex);
 	session->s_seq++;
+	check_session_state(session);
 	mutex_unlock(&session->s_mutex);
 
 	/* lookup inode */
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 0da39c16dab4..f1e73a65f4a5 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -874,6 +874,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 
 	mutex_lock(&session->s_mutex);
 	session->s_seq++;
+	check_session_state(session);
 	mutex_unlock(&session->s_mutex);
 
 	down_write(&mdsc->snap_rwsem);
-- 
2.26.2

