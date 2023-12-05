Return-Path: <ceph-devel+bounces-190-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A888043DF
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 02:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40E241F21362
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 01:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EC8137E;
	Tue,  5 Dec 2023 01:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQ3f0A2y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED23CD
	for <ceph-devel@vger.kernel.org>; Mon,  4 Dec 2023 17:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701739023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7UXuoEU/KYEzsatWxBVryk/ptunNszHUGLN9ULzq8YM=;
	b=DQ3f0A2y982eWi1uPmTYd3Z4UPpjAv17qz1BX7Ai5TK4VUJ3kQH91FraZW6W/Kbycsu5tA
	4K6c1rLGlUkm0a7ByU5UGVITf7Crk30WggM+PWu4txxk3F0vTUvbtkjU9vrLqf7vnAuCZF
	ulKLzAk97tOfFRdbodzWgpbqKEZqyCw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-jLPfzDerMBWRjQihT_d8dg-1; Mon,
 04 Dec 2023 20:17:02 -0500
X-MC-Unique: jLPfzDerMBWRjQihT_d8dg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1E503C0E646;
	Tue,  5 Dec 2023 01:17:01 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.153])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB60492BE0;
	Tue,  5 Dec 2023 01:16:58 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/6] ceph: save the cap_auths in client when session being opened
Date: Tue,  5 Dec 2023 09:14:34 +0800
Message-ID: <20231205011439.84238-2-xiubli@redhat.com>
In-Reply-To: <20231205011439.84238-1-xiubli@redhat.com>
References: <20231205011439.84238-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

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
index 50299891ea94..07df467bbb13 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4129,10 +4129,13 @@ static void handle_session(struct ceph_mds_session *session,
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
@@ -4177,7 +4180,103 @@ static void handle_session(struct ceph_mds_session *session,
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
@@ -4307,6 +4406,13 @@ static void handle_session(struct ceph_mds_session *session,
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
index f25117fa910f..71f4d1ff663f 100644
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
2.41.0


