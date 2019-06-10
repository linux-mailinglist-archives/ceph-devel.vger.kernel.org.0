Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6D23B40A
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Jun 2019 13:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389284AbfFJLdZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Jun 2019 07:33:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389247AbfFJLdZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 07:33:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6EC430833B4
        for <ceph-devel@vger.kernel.org>; Mon, 10 Jun 2019 11:33:24 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CF1D60126;
        Mon, 10 Jun 2019 11:33:22 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH] ceph: don't blindly unregister session that is in opening state
Date:   Mon, 10 Jun 2019 19:33:20 +0800
Message-Id: <20190610113320.18743-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 10 Jun 2019 11:33:24 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

handle_cap_export() may add placeholder caps to session that is in
opening state. These caps' session pointer become wild after session get
unregistered.

The fix is, during mds failovers, not to unregister session that is in
opening state. Just let client to reconnect later when mds is recovered.

Link: https://tracker.ceph.com/issues/40190
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/mds_client.c | 59 +++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 33 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f5c3499fdec6..fda621bc8a29 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3737,42 +3737,35 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		     ceph_mdsmap_is_laggy(newmap, i) ? " (laggy)" : "",
 		     ceph_session_state_name(s->s_state));
 
-		if (i >= newmap->m_num_mds ||
-		    memcmp(ceph_mdsmap_get_addr(oldmap, i),
-			   ceph_mdsmap_get_addr(newmap, i),
-			   sizeof(struct ceph_entity_addr))) {
-			if (s->s_state == CEPH_MDS_SESSION_OPENING) {
-				/* the session never opened, just close it
-				 * out now */
-				get_session(s);
-				__unregister_session(mdsc, s);
-				__wake_requests(mdsc, &s->s_waiting);
-				ceph_put_mds_session(s);
-			} else if (i >= newmap->m_num_mds) {
-				/* force close session for stopped mds */
-				get_session(s);
-				__unregister_session(mdsc, s);
-				__wake_requests(mdsc, &s->s_waiting);
-				kick_requests(mdsc, i);
-				mutex_unlock(&mdsc->mutex);
+		if (i >= newmap->m_num_mds) {
+			/* force close session for stopped mds */
+			get_session(s);
+			__unregister_session(mdsc, s);
+			__wake_requests(mdsc, &s->s_waiting);
+			mutex_unlock(&mdsc->mutex);
 
-				mutex_lock(&s->s_mutex);
-				cleanup_session_requests(mdsc, s);
-				remove_session_caps(s);
-				mutex_unlock(&s->s_mutex);
+			mutex_lock(&s->s_mutex);
+			cleanup_session_requests(mdsc, s);
+			remove_session_caps(s);
+			mutex_unlock(&s->s_mutex);
 
-				ceph_put_mds_session(s);
+			ceph_put_mds_session(s);
 
-				mutex_lock(&mdsc->mutex);
-			} else {
-				/* just close it */
-				mutex_unlock(&mdsc->mutex);
-				mutex_lock(&s->s_mutex);
-				mutex_lock(&mdsc->mutex);
-				ceph_con_close(&s->s_con);
-				mutex_unlock(&s->s_mutex);
-				s->s_state = CEPH_MDS_SESSION_RESTARTING;
-			}
+			mutex_lock(&mdsc->mutex);
+			kick_requests(mdsc, i);
+			continue;
+		}
+
+		if (memcmp(ceph_mdsmap_get_addr(oldmap, i),
+			   ceph_mdsmap_get_addr(newmap, i),
+			   sizeof(struct ceph_entity_addr))) {
+			/* just close it */
+			mutex_unlock(&mdsc->mutex);
+			mutex_lock(&s->s_mutex);
+			mutex_lock(&mdsc->mutex);
+			ceph_con_close(&s->s_con);
+			mutex_unlock(&s->s_mutex);
+			s->s_state = CEPH_MDS_SESSION_RESTARTING;
 		} else if (oldstate == newstate) {
 			continue;  /* nothing new with this mds */
 		}
-- 
2.17.2

