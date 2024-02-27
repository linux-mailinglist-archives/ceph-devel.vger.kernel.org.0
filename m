Return-Path: <ceph-devel+bounces-915-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C483A8689E6
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 08:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A94D2881D7
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 07:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB86D54BED;
	Tue, 27 Feb 2024 07:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SUoqR6Y2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17DD54BCF
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 07:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019300; cv=none; b=N1e2uZA8W+ljctgWhY9cb/xDyOvD8VTrQDl/ij/VrNj9+iHPHFlOikM8Cj3fQ5nUIRBe+Bfao8nCmfIcVQ031gz4h5ri9VH7szDFYZSn0t6H7L50kj81JDvKq9OT/C24TzUtLtLR3UJVcyLxhBA7XFZl1cEvNnMFyygz6JFZ5Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019300; c=relaxed/simple;
	bh=obUsuLA0Mf5jmvdadtIzh9om1oqL329Iq0/fmTN7sto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8ulj5NkMaruKE9twD/QlaULvyIJlJCiwlq3gvRhwmzaA9t0Bet4sUdA59um9GMlSLNGx0b1l71WP0tokNKXZLsg6GunE2WMt9+WHCAoICKB39pCOriyf+GwSmAEgOpycxCb0un27BTRCw0YShY5SrAQPKJoBdicityehebZ4BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SUoqR6Y2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709019297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HPVnBwD3ydbOLb7P+EeLxPwobuPx+ipn2/pPPLEDDb4=;
	b=SUoqR6Y2O4CvhIQ+MH//sz2uC3gj9cge1A9Oqa0fQGBk2KF5D96iphU/sAMHGbgsGmBuKa
	J7uIc5hrtjFiA2Lk1RnPik5CNEnoGuBnfnXd+xWqgAZo23JV1bls04KJ0gicnTl9232sPc
	AEru71Te8BPDVV6Sq0YK1sP8+GPuZsc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-HysjH3c2ORaSTFgegJYaBw-1; Tue, 27 Feb 2024 02:34:55 -0500
X-MC-Unique: HysjH3c2ORaSTFgegJYaBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41B79862DC2;
	Tue, 27 Feb 2024 07:34:55 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.214])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C1572166B32;
	Tue, 27 Feb 2024 07:34:51 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 1/6] ceph: save the cap_auths in client when session being opened
Date: Tue, 27 Feb 2024 15:27:00 +0800
Message-ID: <20240227072705.593676-2-xiubli@redhat.com>
In-Reply-To: <20240227072705.593676-1-xiubli@redhat.com>
References: <20240227072705.593676-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

Save the cap_auths, which have been parsed by the MDS, in the opened
session.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 108 ++++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h |  21 +++++++++
 2 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 968918bcefdd..b715ccfff419 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4140,10 +4140,13 @@ static void handle_session(struct ceph_mds_session *session,
 	void *p = msg->front.iov_base;
 	void *end = p + msg->front.iov_len;
 	struct ceph_mds_session_head *h;
-	u32 op;
+	struct ceph_mds_cap_auth *cap_auths = NULL;
+	u32 op, cap_auths_num = 0;
 	u64 seq, features = 0;
 	int wake = 0;
 	bool blocklisted = false;
+	u32 i;
+
 
 	/* decode */
 	ceph_decode_need(&p, end, sizeof(*h), bad);
@@ -4188,7 +4191,103 @@ static void handle_session(struct ceph_mds_session *session,
 		}
 	}
 
+	if (msg_version >= 6) {
+		ceph_decode_32_safe(&p, end, cap_auths_num, bad);
+		doutc(cl, "cap_auths_num %d\n", cap_auths_num);
+
+		if (cap_auths_num && op != CEPH_SESSION_OPEN) {
+			WARN_ON_ONCE(op != CEPH_SESSION_OPEN);
+			goto skip_cap_auths;
+		}
+
+		cap_auths = kcalloc(cap_auths_num,
+				    sizeof(struct ceph_mds_cap_auth),
+				    GFP_KERNEL);
+		if (!cap_auths) {
+			pr_err_client(cl, "No memory for cap_auths\n");
+			return;
+		}
+
+		for (i = 0; i < cap_auths_num; i++) {
+			u32 _len, j;
+
+			/* struct_v, struct_compat, and struct_len in MDSCapAuth */
+			ceph_decode_skip_n(&p, end, 2 + sizeof(u32), bad);
+
+			/* struct_v, struct_compat, and struct_len in MDSCapMatch */
+			ceph_decode_skip_n(&p, end, 2 + sizeof(u32), bad);
+			ceph_decode_64_safe(&p, end, cap_auths[i].match.uid, bad);
+			ceph_decode_32_safe(&p, end, _len, bad);
+			if (_len) {
+				cap_auths[i].match.gids = kcalloc(_len, sizeof(int64_t),
+								  GFP_KERNEL);
+				if (!cap_auths[i].match.gids) {
+					pr_err_client(cl, "No memory for gids\n");
+					goto fail;
+				}
+
+				cap_auths[i].match.num_gids = _len;
+				for (j = 0; j < _len; j++)
+					ceph_decode_64_safe(&p, end,
+							    cap_auths[i].match.gids[j],
+							    bad);
+			}
+
+			ceph_decode_32_safe(&p, end, _len, bad);
+			if (_len) {
+				cap_auths[i].match.path = kcalloc(_len + 1, sizeof(char),
+								  GFP_KERNEL);
+				if (!cap_auths[i].match.path) {
+					pr_err_client(cl, "No memory for path\n");
+					goto fail;
+				}
+				ceph_decode_copy(&p, cap_auths[i].match.path, _len);
+
+				/* Remove the tailing '/' */
+				while (_len && cap_auths[i].match.path[_len - 1] == '/') {
+					cap_auths[i].match.path[_len - 1] = '\0';
+					_len -= 1;
+				}
+			}
+
+			ceph_decode_32_safe(&p, end, _len, bad);
+			if (_len) {
+				cap_auths[i].match.fs_name = kcalloc(_len + 1, sizeof(char),
+								     GFP_KERNEL);
+				if (!cap_auths[i].match.fs_name) {
+					pr_err_client(cl, "No memory for fs_name\n");
+					goto fail;
+				}
+				ceph_decode_copy(&p, cap_auths[i].match.fs_name, _len);
+			}
+
+			ceph_decode_8_safe(&p, end, cap_auths[i].match.root_squash, bad);
+			ceph_decode_8_safe(&p, end, cap_auths[i].readable, bad);
+			ceph_decode_8_safe(&p, end, cap_auths[i].writeable, bad);
+			doutc(cl, "uid %lld, num_gids %d, path %s, fs_name %s,"
+			      " root_squash %d, readable %d, writeable %d\n",
+			      cap_auths[i].match.uid, cap_auths[i].match.num_gids,
+			      cap_auths[i].match.path, cap_auths[i].match.fs_name,
+			      cap_auths[i].match.root_squash,
+			      cap_auths[i].readable, cap_auths[i].writeable);
+		}
+
+	}
+
+skip_cap_auths:
 	mutex_lock(&mdsc->mutex);
+	if (op == CEPH_SESSION_OPEN) {
+		if (mdsc->s_cap_auths) {
+			for (i = 0; i < mdsc->s_cap_auths_num; i++) {
+				kfree(mdsc->s_cap_auths[i].match.gids);
+				kfree(mdsc->s_cap_auths[i].match.path);
+				kfree(mdsc->s_cap_auths[i].match.fs_name);
+			}
+			kfree(mdsc->s_cap_auths);
+		}
+		mdsc->s_cap_auths_num = cap_auths_num;
+		mdsc->s_cap_auths = cap_auths;
+	}
 	if (op == CEPH_SESSION_CLOSE) {
 		ceph_get_mds_session(session);
 		__unregister_session(mdsc, session);
@@ -4318,6 +4417,13 @@ static void handle_session(struct ceph_mds_session *session,
 	pr_err_client(cl, "corrupt message mds%d len %d\n", mds,
 		      (int)msg->front.iov_len);
 	ceph_msg_dump(msg);
+fail:
+	for (i = 0; i < cap_auths_num; i++) {
+		kfree(cap_auths[i].match.gids);
+		kfree(cap_auths[i].match.path);
+		kfree(cap_auths[i].match.fs_name);
+	}
+	kfree(cap_auths);
 	return;
 }
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 03f8ff00874f..b98aadac480e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -71,6 +71,24 @@ enum ceph_feature_type {
 struct ceph_fs_client;
 struct ceph_cap;
 
+#define MDS_AUTH_UID_ANY -1
+
+struct ceph_mds_cap_match {
+	int64_t uid; // MDS_AUTH_UID_ANY as default
+	uint32_t num_gids;
+	int64_t *gids;  // Use these GIDs
+	char *path;  // Require path to be child of this (may be "" or "/" for any)
+	char *fs_name;
+	u8 root_squash; // False as default
+};
+
+struct ceph_mds_cap_auth {
+	struct ceph_mds_cap_match match;
+	u8 readable;
+	u8 writeable;
+};
+
+
 /*
  * parsed info about a single inode.  pointers are into the encoded
  * on-wire structures within the mds reply message payload.
@@ -514,6 +532,9 @@ struct ceph_mds_client {
 	struct rw_semaphore     pool_perm_rwsem;
 	struct rb_root		pool_perm_tree;
 
+	u32			 s_cap_auths_num;
+	struct ceph_mds_cap_auth *s_cap_auths;
+
 	char nodename[__NEW_UTS_LEN + 1];
 };
 
-- 
2.43.0


