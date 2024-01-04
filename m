Return-Path: <ceph-devel+bounces-476-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B32823B64
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Jan 2024 05:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E793B2433B
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Jan 2024 04:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5065610A27;
	Thu,  4 Jan 2024 04:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HEeuYDJm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7510953
	for <ceph-devel@vger.kernel.org>; Thu,  4 Jan 2024 04:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704341997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Eh3aHjqAtvWLVzbb+ijCDkQe2L+H01Aw9P6SnczwUjw=;
	b=HEeuYDJm4EAdXqDe1Nh7eOAGggOFSTVQJ5OXkp8gSDl50ylwscOYsSTYR4jEcpK5o3Psyo
	cWZ7sciQWw9tYdGiPx21x/uY6Bj+C6ssXHEbijqr0ANAhY6+ZPOxC0BN9bSLRUmJp27KeV
	fLNqWZI21tRBQ0eD7r3K4BPxKOn1fuk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-50-Nh_KsW6FN9SadqlhRpXyOQ-1; Wed,
 03 Jan 2024 23:19:54 -0500
X-MC-Unique: Nh_KsW6FN9SadqlhRpXyOQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E45A91C172AF;
	Thu,  4 Jan 2024 04:19:53 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.25])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C209B1C060AF;
	Thu,  4 Jan 2024 04:19:50 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: always check dir caps asynchronously
Date: Thu,  4 Jan 2024 12:17:23 +0800
Message-ID: <20240104041723.1120866-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Xiubo Li <xiubli@redhat.com>

The MDS will issue the 'Fr' caps for async dirop, while there is
buggy in kclient and it could miss releasing the async dirop caps,
which is 'Fsxr'. And then the MDS will complain with:

"[WRN] client.xxx isn't responding to mclientcaps(revoke) ..."

So when releasing the dirop async requests or when they fail we
should always make sure that being revoked caps could be released.

URL: https://tracker.ceph.com/issues/50223
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 6 ------
 fs/ceph/mds_client.c | 9 ++++-----
 fs/ceph/mds_client.h | 2 +-
 fs/ceph/super.h      | 2 --
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a9e19f1f26e0..4dd92f09b16e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3216,7 +3216,6 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
 
 enum put_cap_refs_mode {
 	PUT_CAP_REFS_SYNC = 0,
-	PUT_CAP_REFS_NO_CHECK,
 	PUT_CAP_REFS_ASYNC,
 };
 
@@ -3332,11 +3331,6 @@ void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had)
 	__ceph_put_cap_refs(ci, had, PUT_CAP_REFS_ASYNC);
 }
 
-void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
-{
-	__ceph_put_cap_refs(ci, had, PUT_CAP_REFS_NO_CHECK);
-}
-
 /*
  * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
  * context.  Adjust per-snap dirty page accounting as appropriate.
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7bdee08ec2eb..f278194a1a01 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1089,7 +1089,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 	struct ceph_mds_request *req = container_of(kref,
 						    struct ceph_mds_request,
 						    r_kref);
-	ceph_mdsc_release_dir_caps_no_check(req);
+	ceph_mdsc_release_dir_caps_async(req);
 	destroy_reply_info(&req->r_reply_info);
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
@@ -4428,7 +4428,7 @@ void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
 	}
 }
 
-void ceph_mdsc_release_dir_caps_no_check(struct ceph_mds_request *req)
+void ceph_mdsc_release_dir_caps_async(struct ceph_mds_request *req)
 {
 	struct ceph_client *cl = req->r_mdsc->fsc->client;
 	int dcaps;
@@ -4436,8 +4436,7 @@ void ceph_mdsc_release_dir_caps_no_check(struct ceph_mds_request *req)
 	dcaps = xchg(&req->r_dir_caps, 0);
 	if (dcaps) {
 		doutc(cl, "releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
-		ceph_put_cap_refs_no_check_caps(ceph_inode(req->r_parent),
-						dcaps);
+		ceph_put_cap_refs_async(ceph_inode(req->r_parent), dcaps);
 	}
 }
 
@@ -4473,7 +4472,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
 		if (req->r_session->s_mds != session->s_mds)
 			continue;
 
-		ceph_mdsc_release_dir_caps_no_check(req);
+		ceph_mdsc_release_dir_caps_async(req);
 
 		__send_request(session, req, true);
 	}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index e85172a92e6c..92695a280d7b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -579,7 +579,7 @@ extern int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 				struct inode *dir,
 				struct ceph_mds_request *req);
 extern void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req);
-extern void ceph_mdsc_release_dir_caps_no_check(struct ceph_mds_request *req);
+extern void ceph_mdsc_release_dir_caps_async(struct ceph_mds_request *req);
 static inline void ceph_mdsc_get_request(struct ceph_mds_request *req)
 {
 	kref_get(&req->r_kref);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f418b43d0e05..8832da060253 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1258,8 +1258,6 @@ extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
 extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
 extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
 extern void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had);
-extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
-					    int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				       struct ceph_snap_context *snapc);
 extern void __ceph_remove_capsnap(struct inode *inode,
-- 
2.43.0


