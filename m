Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1921FF11B
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jun 2020 14:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgFRMBK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Jun 2020 08:01:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728103AbgFRMBJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 Jun 2020 08:01:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592481667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=J89bZlscr7z8ob8sjvKW28i9uEQWWN8+Dh1wWPjiN/w=;
        b=IusS3A0nOCqPFHdJNtkKbROGkgZDImcmYqkYZSP4Lk7jv1DCe8i42me9Upghm0sGcNW6Wc
        BAuN+A4AOleFTAawSBtuN/qq8dv8dkCRmtvIqCkQlOH1tsOBJHoA1H47f3sATRDJ8ggzfU
        F8wE/eos5kxx5BivQMLzdw+DGwQ4DxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-WPQ2r-3eO_Wz250g6ofF5Q-1; Thu, 18 Jun 2020 08:01:05 -0400
X-MC-Unique: WPQ2r-3eO_Wz250g6ofF5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BF2C872FEF;
        Thu, 18 Jun 2020 12:01:04 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7C417BA1A;
        Thu, 18 Jun 2020 12:00:59 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 4/5] ceph: switch to WARN_ON and bubble up errnos to the callers
Date:   Thu, 18 Jun 2020 07:59:58 -0400
Message-Id: <1592481599-7851-5-git-send-email-xiubli@redhat.com>
In-Reply-To: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f996363..f29cb11 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1168,7 +1168,7 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
 
 static const unsigned char feature_bits[] = CEPHFS_FEATURES_CLIENT_SUPPORTED;
 #define FEATURE_BYTES(c) (DIV_ROUND_UP((size_t)feature_bits[c - 1] + 1, 64) * 8)
-static void encode_supported_features(void **p, void *end)
+static int encode_supported_features(void **p, void *end)
 {
 	static const size_t count = ARRAY_SIZE(feature_bits);
 
@@ -1176,16 +1176,22 @@ static void encode_supported_features(void **p, void *end)
 		size_t i;
 		size_t size = FEATURE_BYTES(count);
 
-		BUG_ON(*p + 4 + size > end);
+		if (WARN_ON(*p + 4 + size > end))
+			return -ERANGE;
+
 		ceph_encode_32(p, size);
 		memset(*p, 0, size);
 		for (i = 0; i < count; i++)
 			((unsigned char*)(*p))[i / 8] |= BIT(feature_bits[i] % 8);
 		*p += size;
 	} else {
-		BUG_ON(*p + 4 > end);
+		if (WARN_ON(*p + 4 > end))
+			return -ERANGE;
+
 		ceph_encode_32(p, 0);
 	}
+
+	return 0;
 }
 
 /*
@@ -1203,6 +1209,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 	struct ceph_mount_options *fsopt = mdsc->fsc->mount_options;
 	size_t size, count;
 	void *p, *end;
+	int ret;
 
 	const char* metadata[][2] = {
 		{"hostname", mdsc->nodename},
@@ -1232,7 +1239,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 			   GFP_NOFS, false);
 	if (!msg) {
 		pr_err("create_session_msg ENOMEM creating msg\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	p = msg->front.iov_base;
 	end = p + msg->front.iov_len;
@@ -1269,7 +1276,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 		p += val_len;
 	}
 
-	encode_supported_features(&p, end);
+	ret = encode_supported_features(&p, end);
+	if (ret) {
+		pr_err("encode_supported_features failed!\n");
+		ceph_msg_put(msg);
+		return ERR_PTR(ret);
+	}
+
 	msg->front.iov_len = p - msg->front.iov_base;
 	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
 
@@ -1297,8 +1310,8 @@ static int __open_session(struct ceph_mds_client *mdsc,
 
 	/* send connect message */
 	msg = create_session_open_msg(mdsc, session->s_seq);
-	if (!msg)
-		return -ENOMEM;
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 	ceph_con_send(&session->s_con, msg);
 	return 0;
 }
@@ -1312,6 +1325,7 @@ static int __open_session(struct ceph_mds_client *mdsc,
 __open_export_target_session(struct ceph_mds_client *mdsc, int target)
 {
 	struct ceph_mds_session *session;
+	int ret;
 
 	session = __ceph_lookup_mds_session(mdsc, target);
 	if (!session) {
@@ -1320,8 +1334,11 @@ static int __open_session(struct ceph_mds_client *mdsc,
 			return session;
 	}
 	if (session->s_state == CEPH_MDS_SESSION_NEW ||
-	    session->s_state == CEPH_MDS_SESSION_CLOSING)
-		__open_session(mdsc, session);
+	    session->s_state == CEPH_MDS_SESSION_CLOSING) {
+		ret = __open_session(mdsc, session);
+		if (ret)
+			return ERR_PTR(ret);
+	}
 
 	return session;
 }
@@ -2520,7 +2537,12 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 		ceph_encode_copy(&p, &ts, sizeof(ts));
 	}
 
-	BUG_ON(p > end);
+	if (WARN_ON(p > end)) {
+		ceph_msg_put(msg);
+		msg = ERR_PTR(-ERANGE);
+		goto out_free2;
+	}
+
 	msg->front.iov_len = p - msg->front.iov_base;
 	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
 
@@ -2756,7 +2778,9 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		}
 		if (session->s_state == CEPH_MDS_SESSION_NEW ||
 		    session->s_state == CEPH_MDS_SESSION_CLOSING) {
-			__open_session(mdsc, session);
+			err = __open_session(mdsc, session);
+			if (err)
+				goto out_session;
 			/* retry the same mds later */
 			if (random)
 				req->r_resend_mds = mds;
-- 
1.8.3.1

