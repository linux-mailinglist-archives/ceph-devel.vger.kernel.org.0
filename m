Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3835D27B7FA
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 01:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgI1XUh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Sep 2020 19:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgI1XUc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Sep 2020 19:20:32 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F79221E7;
        Mon, 28 Sep 2020 22:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601330632;
        bh=+la2/ba1fbR/KduJfr7qyzhlTAxzIaNEzTTFfAf8ZoI=;
        h=From:To:Cc:Subject:Date:From;
        b=sZxIUzGHPMKzP8+AH/G8nraeJIq8z5sMA2fC8maTeZaJwS6W+3dQZeNUVPj+tp5Y4
         8fI3eTbVDPbkcC53PhZ/5y3VS472Gtd+zNg/avUwC1wEvwkfhT5ueCny8p9kk7tBgV
         Pw2xT+IpcEDVhXSj1z+qOKJ/BBkrTlmoO+Srp/3o=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com
Subject: [PATCH] ceph: retransmit REQUEST_CLOSE every second if we don't get a response
Date:   Mon, 28 Sep 2020 18:03:49 -0400
Message-Id: <20200928220349.584709-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Patrick reported a case where the MDS and client client had racing
session messages to one anothe. The MDS was sending caps to the client
and the client was sending a CEPH_SESSION_REQUEST_CLOSE message in order
to unmount.

Because they were sending at the same time, the REQUEST_CLOSE had too
old a sequence number, and the MDS dropped it on the floor. On the
client, this would have probably manifested as a 60s hang during umount.
The MDS ended up blocklisting the client.

Once we've decided to issue a REQUEST_CLOSE, we're finished with the
session, so just keep sending them until the MDS acknowledges that.

Change the code to retransmit a REQUEST_CLOSE every second if the
session hasn't changed state yet. Give up and throw a warning after
mount_timeout elapses if we haven't gotten a response.

URL: https://tracker.ceph.com/issues/47563
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 53 ++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b07e7adf146f..d9cb74e3d5e3 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1878,7 +1878,7 @@ static int request_close_session(struct ceph_mds_session *session)
 static int __close_session(struct ceph_mds_client *mdsc,
 			 struct ceph_mds_session *session)
 {
-	if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
+	if (session->s_state > CEPH_MDS_SESSION_CLOSING)
 		return 0;
 	session->s_state = CEPH_MDS_SESSION_CLOSING;
 	return request_close_session(session);
@@ -4692,38 +4692,49 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
 	return atomic_read(&mdsc->num_sessions) <= skipped;
 }
 
+static bool umount_timed_out(unsigned long timeo)
+{
+	if (time_before(jiffies, timeo))
+		return false;
+	pr_warn("ceph: unable to close all sessions\n");
+	return true;
+}
+
 /*
  * called after sb is ro.
  */
 void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 {
-	struct ceph_options *opts = mdsc->fsc->client->options;
 	struct ceph_mds_session *session;
-	int i;
-	int skipped = 0;
+	int i, ret;
+	int skipped;
+	unsigned long timeo = jiffies +
+			      ceph_timeout_jiffies(mdsc->fsc->client->options->mount_timeout);
 
 	dout("close_sessions\n");
 
 	/* close sessions */
-	mutex_lock(&mdsc->mutex);
-	for (i = 0; i < mdsc->max_sessions; i++) {
-		session = __ceph_lookup_mds_session(mdsc, i);
-		if (!session)
-			continue;
-		mutex_unlock(&mdsc->mutex);
-		mutex_lock(&session->s_mutex);
-		if (__close_session(mdsc, session) <= 0)
-			skipped++;
-		mutex_unlock(&session->s_mutex);
-		ceph_put_mds_session(session);
+	do {
+		skipped = 0;
 		mutex_lock(&mdsc->mutex);
-	}
-	mutex_unlock(&mdsc->mutex);
+		for (i = 0; i < mdsc->max_sessions; i++) {
+			session = __ceph_lookup_mds_session(mdsc, i);
+			if (!session)
+				continue;
+			mutex_unlock(&mdsc->mutex);
+			mutex_lock(&session->s_mutex);
+			if (__close_session(mdsc, session) <= 0)
+				skipped++;
+			mutex_unlock(&session->s_mutex);
+			ceph_put_mds_session(session);
+			mutex_lock(&mdsc->mutex);
+		}
+		mutex_unlock(&mdsc->mutex);
 
-	dout("waiting for sessions to close\n");
-	wait_event_timeout(mdsc->session_close_wq,
-			   done_closing_sessions(mdsc, skipped),
-			   ceph_timeout_jiffies(opts->mount_timeout));
+		dout("waiting for sessions to close\n");
+		ret = wait_event_timeout(mdsc->session_close_wq,
+					 done_closing_sessions(mdsc, skipped), HZ);
+	} while (!ret && !umount_timed_out(timeo));
 
 	/* tear down remaining sessions */
 	mutex_lock(&mdsc->mutex);
-- 
2.26.2

