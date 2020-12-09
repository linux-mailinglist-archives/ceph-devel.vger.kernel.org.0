Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F342D4988
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 19:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbgLISyo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Dec 2020 13:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387443AbgLISyj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 13:54:39 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH 3/4] ceph: clean up argument lists to __prepare_send_request and __send_request
Date:   Wed,  9 Dec 2020 13:53:53 -0500
Message-Id: <20201209185354.29097-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209185354.29097-1-jlayton@kernel.org>
References: <20201209185354.29097-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We can always get the mdsc from the session, so there's no need to pass
it in as a separate argument. Pass the session to __prepare_send_request
as well, to prepare for later patches that will need to access it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1f1c5e490596..f76ae9e7d4c1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2634,10 +2634,12 @@ static void complete_request(struct ceph_mds_client *mdsc,
 /*
  * called under mdsc->mutex
  */
-static int __prepare_send_request(struct ceph_mds_client *mdsc,
+static int __prepare_send_request(struct ceph_mds_session *session,
 				  struct ceph_mds_request *req,
-				  int mds, bool drop_cap_releases)
+				  bool drop_cap_releases)
 {
+	int mds = session->s_mds;
+	struct ceph_mds_client *mdsc = session->s_mdsc;
 	struct ceph_mds_request_head *rhead;
 	struct ceph_msg *msg;
 	int flags = 0;
@@ -2721,15 +2723,13 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
 /*
  * called under mdsc->mutex
  */
-static int __send_request(struct ceph_mds_client *mdsc,
-			  struct ceph_mds_session *session,
+static int __send_request(struct ceph_mds_session *session,
 			  struct ceph_mds_request *req,
 			  bool drop_cap_releases)
 {
 	int err;
 
-	err = __prepare_send_request(mdsc, req, session->s_mds,
-				     drop_cap_releases);
+	err = __prepare_send_request(session, req, drop_cap_releases);
 	if (!err) {
 		ceph_msg_get(req->r_request);
 		ceph_con_send(&session->s_con, req->r_request);
@@ -2856,7 +2856,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	if (req->r_request_started == 0)   /* note request start time */
 		req->r_request_started = jiffies;
 
-	err = __send_request(mdsc, session, req, false);
+	err = __send_request(session, req, false);
 
 out_session:
 	ceph_put_mds_session(session);
@@ -3535,7 +3535,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
 
 	mutex_lock(&mdsc->mutex);
 	list_for_each_entry_safe(req, nreq, &session->s_unsafe, r_unsafe_item)
-		__send_request(mdsc, session, req, true);
+		__send_request(session, req, true);
 
 	/*
 	 * also re-send old requests when MDS enters reconnect stage. So that MDS
@@ -3556,7 +3556,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
 
 		ceph_mdsc_release_dir_caps_no_check(req);
 
-		__send_request(mdsc, session, req, true);
+		__send_request(session, req, true);
 	}
 	mutex_unlock(&mdsc->mutex);
 }
-- 
2.29.2

