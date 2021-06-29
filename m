Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FCD3B6DB0
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 06:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhF2Ep0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 00:45:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231448AbhF2EpY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 00:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624941777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+oi027Xa1iARAZ8UUNvEYHg64a2ffEAe0GUhvw/DLs=;
        b=HQZ6Q+21yx5ZuSHpAEi32kYDZxKpHEE0LKg5lnHxzkrTw7pgpgViJFf4ZU+PQiXrXDNyfs
        x/hIin0q5uXb4NcrIdHQOUy4FXfbnzhmsf37OK0PW/1rZoPtW3fEp0hBGgPWzdZUkQMoGq
        u/LCBBvMDj2aRoPVnLOBYM/CUdzgARU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-3OK_IYV5NfO-1EG9Z0tgDg-1; Tue, 29 Jun 2021 00:42:52 -0400
X-MC-Unique: 3OK_IYV5NfO-1EG9Z0tgDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91350800D55;
        Tue, 29 Jun 2021 04:42:51 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B21825D9DC;
        Tue, 29 Jun 2021 04:42:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/5] ceph: export iterate_sessions
Date:   Tue, 29 Jun 2021 12:42:38 +0800
Message-Id: <20210629044241.30359-3-xiubli@redhat.com>
In-Reply-To: <20210629044241.30359-1-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 26 +-----------------------
 fs/ceph/mds_client.c | 47 +++++++++++++++++++++++++++++---------------
 fs/ceph/mds_client.h |  3 +++
 3 files changed, 35 insertions(+), 41 deletions(-)

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
index e49d3e230712..96bef289f58f 100644
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
@@ -4416,22 +4443,10 @@ void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
 /*
  * lock unlock sessions, to wait ongoing session activities
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
@@ -4683,7 +4698,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
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

