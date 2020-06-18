Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2021FF11A
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jun 2020 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgFRMBG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Jun 2020 08:01:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50163 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728103AbgFRMBF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 Jun 2020 08:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592481663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=0m8kZ4gRdQmZ7XYTCzz5brAZXZHRJSvphFqKqSIPNOY=;
        b=Hov0eVREI1MFgfyRCCaiN7tzK+YFmpc5z3q1mo0w7grRQZwx5TC3TsFGizVksP93AMOPm4
        LbRC/nWwqjNStpdeAiNxRFtMReMJugH4rHgm0yok/03VwzExd6wUJa0UCYfEImDo3W7NOk
        Df+E5g4LlytjffqdLnVCJXjwN48HywM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-YPmxm_FGPcWlEsLOPD0kKQ-1; Thu, 18 Jun 2020 08:00:55 -0400
X-MC-Unique: YPmxm_FGPcWlEsLOPD0kKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6565A0BE7;
        Thu, 18 Jun 2020 12:00:53 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19D2A7A01A;
        Thu, 18 Jun 2020 12:00:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/5] ceph: add check_session_state helper and make it global
Date:   Thu, 18 Jun 2020 07:59:55 -0400
Message-Id: <1592481599-7851-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will be used by followed sending metrics patches.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 43 ++++++++++++++++++++++++++-----------------
 fs/ceph/mds_client.h |  4 ++++
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a504971..608fb5c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4263,6 +4263,30 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 	ceph_force_reconnect(fsc->sb);
 }
 
+bool check_session_state(struct ceph_mds_client *mdsc,
+			 struct ceph_mds_session *s)
+{
+	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
+		dout("resending session close request for mds%d\n",
+				s->s_mds);
+		request_close_session(mdsc, s);
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
@@ -4294,23 +4318,8 @@ static void delayed_work(struct work_struct *work)
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
+		if (!check_session_state(mdsc, s)) {
 			ceph_put_mds_session(s);
 			continue;
 		}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 5e0c407..bcb3892 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -18,6 +18,7 @@
 #include <linux/ceph/auth.h>
 
 #include "metric.h"
+#include "super.h"
 
 /* The first 8 bits are reserved for old ceph releases */
 enum ceph_feature_type {
@@ -476,6 +477,9 @@ struct ceph_mds_client {
 
 extern const char *ceph_mds_op_name(int op);
 
+extern bool check_session_state(struct ceph_mds_client *mdsc,
+				struct ceph_mds_session *s);
+
 extern struct ceph_mds_session *
 __ceph_lookup_mds_session(struct ceph_mds_client *, int mds);
 
-- 
1.8.3.1

