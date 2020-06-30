Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3617F20EFE6
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jun 2020 09:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbgF3Hwt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 03:52:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35825 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731323AbgF3Hwr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Jun 2020 03:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593503565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=69CLOkx27owYWk54Ss3oJosZTkdWjdGWT3qu9pcVz/0=;
        b=XnMvjXo/ON/AQmhZ0TmnvGE7KTRIaueRJgLA/dEAqisUJdnmfYO7F+OzsQsUzahO6j2BDc
        ryBuQu/ESFHX9Mu+eJyLns1tGi0aHS8b5tj98fBgqxNyvA8g57JToFgIXXsYD1KwfdjLB9
        9+o+WphZPruX+B1p+teWXzhyuXhwmBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-uk4oeNUXNaSLGH6CGdMGlA-1; Tue, 30 Jun 2020 03:52:41 -0400
X-MC-Unique: uk4oeNUXNaSLGH6CGdMGlA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB1B8193F560;
        Tue, 30 Jun 2020 07:52:39 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD37D10098A4;
        Tue, 30 Jun 2020 07:52:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 1/5] ceph: add check_session_state helper and make it global
Date:   Tue, 30 Jun 2020 03:52:15 -0400
Message-Id: <1593503539-1209-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
References: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

And remove the unsed mdsc parameter to simplify the code.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 47 +++++++++++++++++++++++++++--------------------
 fs/ceph/mds_client.h |  3 +++
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a504971..58c54d4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1785,8 +1785,7 @@ static void renewed_caps(struct ceph_mds_client *mdsc,
 /*
  * send a session close request
  */
-static int request_close_session(struct ceph_mds_client *mdsc,
-				 struct ceph_mds_session *session)
+static int request_close_session(struct ceph_mds_session *session)
 {
 	struct ceph_msg *msg;
 
@@ -1809,7 +1808,7 @@ static int __close_session(struct ceph_mds_client *mdsc,
 	if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
 		return 0;
 	session->s_state = CEPH_MDS_SESSION_CLOSING;
-	return request_close_session(mdsc, session);
+	return request_close_session(session);
 }
 
 static bool drop_negative_children(struct dentry *dentry)
@@ -4263,6 +4262,29 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 	ceph_force_reconnect(fsc->sb);
 }
 
+bool check_session_state(struct ceph_mds_session *s)
+{
+	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
+		dout("resending session close request for mds%d\n",
+				s->s_mds);
+		request_close_session(s);
+		return false;
+	}
+	if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
+		if (s->s_state == CEPH_MDS_SESSION_OPEN) {
+			s->s_state = CEPH_MDS_SESSION_HUNG;
+			pr_info("mds%d hung\n", s->s_mds);
+		}
+	}
+	if (s->s_state == CEPH_MDS_SESSION_NEW ||
+	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
+	    s->s_state == CEPH_MDS_SESSION_REJECTED)
+		/* this mds is failed or recovering, just wait */
+		return false;
+
+	return true;
+}
+
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
@@ -4294,23 +4316,8 @@ static void delayed_work(struct work_struct *work)
 		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
 		if (!s)
 			continue;
-		if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
-			dout("resending session close request for mds%d\n",
-			     s->s_mds);
-			request_close_session(mdsc, s);
-			ceph_put_mds_session(s);
-			continue;
-		}
-		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
-			if (s->s_state == CEPH_MDS_SESSION_OPEN) {
-				s->s_state = CEPH_MDS_SESSION_HUNG;
-				pr_info("mds%d hung\n", s->s_mds);
-			}
-		}
-		if (s->s_state == CEPH_MDS_SESSION_NEW ||
-		    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
-		    s->s_state == CEPH_MDS_SESSION_REJECTED) {
-			/* this mds is failed or recovering, just wait */
+
+		if (!check_session_state(s)) {
 			ceph_put_mds_session(s);
 			continue;
 		}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 5e0c407..6147ff0 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -18,6 +18,7 @@
 #include <linux/ceph/auth.h>
 
 #include "metric.h"
+#include "super.h"
 
 /* The first 8 bits are reserved for old ceph releases */
 enum ceph_feature_type {
@@ -476,6 +477,8 @@ struct ceph_mds_client {
 
 extern const char *ceph_mds_op_name(int op);
 
+extern bool check_session_state(struct ceph_mds_session *s);
+
 extern struct ceph_mds_session *
 __ceph_lookup_mds_session(struct ceph_mds_client *, int mds);
 
-- 
1.8.3.1

