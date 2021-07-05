Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF7E3BB49F
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jul 2021 03:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhGEBZo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 4 Jul 2021 21:25:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhGEBZn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 4 Jul 2021 21:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625448187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mr0qOpfsFI9a1aM4GxTgBMbC4GQ4Qh6sfmn3S+vr+i4=;
        b=e0CWPMCnd8w3Nc3mOJqZfhUtAoXdzcpv/2dMmGheIBolXR4y/2Av/GvqlPulWMk35TwtBr
        QnXSbSVOc8cjk+AINWnnUeBqb01fNrIFpYgXwp/mJ/7oQXKy0jUTVJCOYj8XoNsxZu4zcB
        8Rkd1Vo5r2gFKfc87f0gb5B3Dw06qso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-ZwLd6A8nOy2XjjJ4hEcunQ-1; Sun, 04 Jul 2021 21:23:05 -0400
X-MC-Unique: ZwLd6A8nOy2XjjJ4hEcunQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1353802920;
        Mon,  5 Jul 2021 01:23:04 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C278560875;
        Mon,  5 Jul 2021 01:23:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/4] ceph: make ceph_create_session_msg a global symbol
Date:   Mon,  5 Jul 2021 09:22:54 +0800
Message-Id: <20210705012257.182669-2-xiubli@redhat.com>
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
 fs/ceph/mds_client.c | 16 +++++++++-------
 fs/ceph/mds_client.h |  1 +
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2d7dcd295bb9..3c9c58a6e75f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1150,7 +1150,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 /*
  * session messages
  */
-static struct ceph_msg *create_session_msg(u32 op, u64 seq)
+struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq)
 {
 	struct ceph_msg *msg;
 	struct ceph_mds_session_head *h;
@@ -1158,7 +1158,8 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h), GFP_NOFS,
 			   false);
 	if (!msg) {
-		pr_err("create_session_msg ENOMEM creating msg\n");
+		pr_err("ENOMEM creating session %s msg\n",
+		       ceph_session_op_name(op));
 		return NULL;
 	}
 	h = msg->front.iov_base;
@@ -1289,7 +1290,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
 			   GFP_NOFS, false);
 	if (!msg) {
-		pr_err("create_session_msg ENOMEM creating msg\n");
+		pr_err("ENOMEM creating session open msg\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	p = msg->front.iov_base;
@@ -1801,8 +1802,8 @@ static int send_renew_caps(struct ceph_mds_client *mdsc,
 
 	dout("send_renew_caps to mds%d (%s)\n", session->s_mds,
 		ceph_mds_state_name(state));
-	msg = create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
-				 ++session->s_renew_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
+				      ++session->s_renew_seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
@@ -1816,7 +1817,7 @@ static int send_flushmsg_ack(struct ceph_mds_client *mdsc,
 
 	dout("send_flushmsg_ack to mds%d (%s)s seq %lld\n",
 	     session->s_mds, ceph_session_state_name(session->s_state), seq);
-	msg = create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
@@ -1868,7 +1869,8 @@ static int request_close_session(struct ceph_mds_session *session)
 	dout("request_close_session mds%d state %s seq %lld\n",
 	     session->s_mds, ceph_session_state_name(session->s_state),
 	     session->s_seq);
-	msg = create_session_msg(CEPH_SESSION_REQUEST_CLOSE, session->s_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_CLOSE,
+				      session->s_seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index bf99c5ba47fc..bf2683f0ba43 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -523,6 +523,7 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
 	kref_put(&req->r_kref, ceph_mdsc_release_request);
 }
 
+extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
 extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
 				    struct ceph_cap *cap);
 extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,
-- 
2.27.0

