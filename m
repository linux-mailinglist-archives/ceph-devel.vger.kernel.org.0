Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601813BB4A0
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jul 2021 03:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhGEBZq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 4 Jul 2021 21:25:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhGEBZq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 4 Jul 2021 21:25:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625448189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nufp5qIfOBbp2sMAiexYGJERHUaK32TVTCr+ahTlASQ=;
        b=GV0Cr6vyzksGrgPHP4KJySGkJAh+PGHEfWlI2OiEaVSkgPMXDlMeHTUbCTUgPt0xACcsy0
        6yuOAmlVLeSJo0v6JhIRXdxQG8X4o9uD2g8YDifdWIer7sQThLgD1bBke905zClgMCOMQ+
        Juwff20bwnQFppMRvRvCbginK/2J2x4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-DTbi-sGiOgiKZHWVvFZJ9Q-1; Sun, 04 Jul 2021 21:23:08 -0400
X-MC-Unique: DTbi-sGiOgiKZHWVvFZJ9Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 096F3800D62;
        Mon,  5 Jul 2021 01:23:07 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AF7D60875;
        Mon,  5 Jul 2021 01:23:04 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/4] ceph: make iterate_sessions a global symbol
Date:   Mon,  5 Jul 2021 09:22:55 +0800
Message-Id: <20210705012257.182669-3-xiubli@redhat.com>
In-Reply-To: <20210705012257.182669-1-xiubli@redhat.com>
References: <20210705012257.182669-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 26 +----------------------
 fs/ceph/mds_client.c | 49 +++++++++++++++++++++++++++++---------------
 fs/ceph/mds_client.h |  3 +++
 3 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e712826ea3f1..c6a3352a4d52 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4280,33 +4280,9 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
 	dout("flush_dirty_caps done\n");
 }
 
-static void iterate_sessions(struct ceph_mds_client *mdsc,
-			     void (*cb)(struct ceph_mds_session *))
-{
-	int mds;
-
-	mutex_lock(&mdsc->mutex);
-	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
-		struct ceph_mds_session *s;
-
-		if (!mdsc->sessions[mds])
-			continue;
-
-		s = ceph_get_mds_session(mdsc->sessions[mds]);
-		if (!s)
-			continue;
-
-		mutex_unlock(&mdsc->mutex);
-		cb(s);
-		ceph_put_mds_session(s);
-		mutex_lock(&mdsc->mutex);
-	}
-	mutex_unlock(&mdsc->mutex);
-}
-
 void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
 {
-	iterate_sessions(mdsc, flush_dirty_session_caps);
+	ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
 }
 
 void __ceph_touch_fmode(struct ceph_inode_info *ci,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3c9c58a6e75f..5c3ec7eb8141 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -802,6 +802,33 @@ static void put_request_session(struct ceph_mds_request *req)
 	}
 }
 
+void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
+			       void (*cb)(struct ceph_mds_session *),
+			       bool check_state)
+{
+	int mds;
+
+	mutex_lock(&mdsc->mutex);
+	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
+		struct ceph_mds_session *s;
+
+		s = __ceph_lookup_mds_session(mdsc, mds);
+		if (!s)
+			continue;
+
+		if (check_state && !check_session_state(s)) {
+			ceph_put_mds_session(s);
+			continue;
+		}
+
+		mutex_unlock(&mdsc->mutex);
+		cb(s);
+		ceph_put_mds_session(s);
+		mutex_lock(&mdsc->mutex);
+	}
+	mutex_unlock(&mdsc->mutex);
+}
+
 void ceph_mdsc_release_request(struct kref *kref)
 {
 	struct ceph_mds_request *req = container_of(kref,
@@ -4415,24 +4442,12 @@ void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
 }
 
 /*
- * lock unlock sessions, to wait ongoing session activities
+ * lock unlock the session, to wait ongoing session activities
  */
-static void lock_unlock_sessions(struct ceph_mds_client *mdsc)
+static void lock_unlock_session(struct ceph_mds_session *s)
 {
-	int i;
-
-	mutex_lock(&mdsc->mutex);
-	for (i = 0; i < mdsc->max_sessions; i++) {
-		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
-		if (!s)
-			continue;
-		mutex_unlock(&mdsc->mutex);
-		mutex_lock(&s->s_mutex);
-		mutex_unlock(&s->s_mutex);
-		ceph_put_mds_session(s);
-		mutex_lock(&mdsc->mutex);
-	}
-	mutex_unlock(&mdsc->mutex);
+	mutex_lock(&s->s_mutex);
+	mutex_unlock(&s->s_mutex);
 }
 
 static void maybe_recover_session(struct ceph_mds_client *mdsc)
@@ -4684,7 +4699,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 	dout("pre_umount\n");
 	mdsc->stopping = 1;
 
-	lock_unlock_sessions(mdsc);
+	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
 	ceph_flush_dirty_caps(mdsc);
 	wait_requests(mdsc);
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index bf2683f0ba43..fca2cf427eaf 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -523,6 +523,9 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
 	kref_put(&req->r_kref, ceph_mdsc_release_request);
 }
 
+extern void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
+				       void (*cb)(struct ceph_mds_session *),
+				       bool check_state);
 extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
 extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
 				    struct ceph_cap *cap);
-- 
2.27.0

