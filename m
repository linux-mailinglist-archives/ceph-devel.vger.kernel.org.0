Return-Path: <ceph-devel+bounces-1095-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83EE88A9CF2
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 16:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DB44B27CE3
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 14:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FCB516DEB4;
	Thu, 18 Apr 2024 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dmsut18a"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC8A16D9DA
	for <ceph-devel@vger.kernel.org>; Thu, 18 Apr 2024 14:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450163; cv=none; b=ZcexgaWC+poK/b8Lt2MVZtuselKuw4KSFjwlEIJMVg4Im8C/nrOkcebCl3quFsknnmd+1VWowwXHVDZFi+JiiFKU6m9pFJ7SqeY9kLr6bbjE/jOoo2V5b4RWd3B7ukltMAsrhXqLQy24KAK7AL6KVbV2Tnl+EBgFEXIzcwqSb4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450163; c=relaxed/simple;
	bh=UsO0QGrMU762H91GmBzttAjjL9FxtHHimTkxDnPcYAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+YguPYVsE8R+YP+MbXXqoXUk+GmS8cV5uBEllA67pt1i1TZW8G4HKQ97/zUwPJRqA+wpQrZyVCH/DFyfIS0sUh+FEx/g66Kjo0PF8/DxFH6pdfdp89rTD51YA0jr7IZ1+LMGxEIUduiZqlicde8i15mBP780IOJaGeU9MbCA60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dmsut18a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713450160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GrvDtdZQN1bmpFvcyUP5a5i73kL6e42liH7xPtYZpwc=;
	b=Dmsut18aZbgqHHuYIonrLowQ/HrBVctmPqC8mpN8gqyoBnN5C34jnR16WPD/7AcCPhEcC9
	h4H60r8OZgE85RfcBQtOapEG+a/yaiNK0MlGWKxJVDD3Lys1SPZOIE3nBNchvaHVAJm87B
	uq9xFtgFqQCZzDl3AArsBHg5znwn7T8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-240-U-iC0IKSMYqCw4D95XV-Cg-1; Thu,
 18 Apr 2024 10:22:36 -0400
X-MC-Unique: U-iC0IKSMYqCw4D95XV-Cg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA988286A9DD;
	Thu, 18 Apr 2024 14:22:36 +0000 (UTC)
Received: from li-25d5c94c-2c69-11b2-a85c-c76ff7643ea0.ibm.com.com (unknown [10.72.116.7])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 047BA43FAC;
	Thu, 18 Apr 2024 14:22:33 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 1/6] ceph: save the cap_auths in client when session being opened
Date: Thu, 18 Apr 2024 22:20:14 +0800
Message-ID: <20240418142019.133191-2-xiubli@redhat.com>
In-Reply-To: <20240418142019.133191-1-xiubli@redhat.com>
References: <20240418142019.133191-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

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
index 8651d5a63dbb..0e26bc90457c 100644
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
+				cap_auths[i].match.gids = kcalloc(_len, sizeof(int32_t),
+								  GFP_KERNEL);
+				if (!cap_auths[i].match.gids) {
+					pr_err_client(cl, "No memory for gids\n");
+					goto fail;
+				}
+
+				cap_auths[i].match.num_gids = _len;
+				for (j = 0; j < _len; j++)
+					ceph_decode_32_safe(&p, end,
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
index b88e80415224..9e2fe310d0b4 100644
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
+	int32_t *gids;  // Use these GIDs
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
@@ -513,6 +531,9 @@ struct ceph_mds_client {
 	struct rw_semaphore     pool_perm_rwsem;
 	struct rb_root		pool_perm_tree;
 
+	u32			 s_cap_auths_num;
+	struct ceph_mds_cap_auth *s_cap_auths;
+
 	char nodename[__NEW_UTS_LEN + 1];
 };
 
-- 
2.43.0


