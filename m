Return-Path: <ceph-devel+bounces-73-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE897E6546
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 09:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB29528173D
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Nov 2023 08:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A645310944;
	Thu,  9 Nov 2023 08:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WB6tjXsR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95F163B2
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:26:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DDF2D56
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 00:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699518410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JAnUYzloedoFDPPTlwLtgnbKwxrbypRMwN7LjhcWoLg=;
	b=WB6tjXsRl45xEgYqq/Cse/d8IPcxIlAm9kHn8FQ3l3TGq8BzX95W7v+7SkvRMISwiOUNr4
	lUMj4I1jbEL1OsWU8bi/YGZOo/OfSOu9e2lT44mK9cTekqkhQNlN3rLEtlfNagVpK5Ymw2
	RfN3KHX2pOsa99lJ8h2sB7O4JNAQIME=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-F9bsFQbYOti_D24rdC9rGg-1; Thu, 09 Nov 2023 03:26:46 -0500
X-MC-Unique: F9bsFQbYOti_D24rdC9rGg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9903E811E7E;
	Thu,  9 Nov 2023 08:26:46 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8D4492026D68;
	Thu,  9 Nov 2023 08:26:43 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 5/5] ceph: check the cephx mds auth access for async dirop
Date: Thu,  9 Nov 2023 16:24:09 +0800
Message-ID: <20231109082409.417726-6-xiubli@redhat.com>
In-Reply-To: <20231109082409.417726-1-xiubli@redhat.com>
References: <20231109082409.417726-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Xiubo Li <xiubli@redhat.com>

Before doing the op locally we need to check the cephx access.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c  | 27 +++++++++++++++++++++++++++
 fs/ceph/file.c | 25 +++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 91709934c8b1..e50f16a566f7 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1336,8 +1336,12 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	struct ceph_mds_request *req;
 	bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
+	struct dentry *dn;
 	int err = -EROFS;
 	int op;
+	char *path;
+	int pathlen;
+	u64 pathbase;
 
 	if (ceph_snap(dir) == CEPH_SNAPDIR) {
 		/* rmdir .snap/foo is RMSNAP */
@@ -1351,6 +1355,29 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 			CEPH_MDS_OP_RMDIR : CEPH_MDS_OP_UNLINK;
 	} else
 		goto out;
+
+	dn = d_find_alias(dir);
+	if (!dn) {
+		try_async = false;
+	} else {
+		path = ceph_mdsc_build_path(mdsc, dn, &pathlen, &pathbase, 0);
+		if (IS_ERR(path)) {
+			try_async = false;
+			err = 0;
+		} else {
+			err = ceph_mds_check_access(mdsc, path, MAY_WRITE);
+		}
+		dput(dn);
+
+		/* For none EACCES cases will let the MDS do the mds auth check */
+		if (err == -EACCES) {
+			return err;
+		} else if (err < 0) {
+			try_async = false;
+			err = 0;
+		}
+	}
+
 retry:
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8e9178446fdd..c8bced90244b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -788,6 +788,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
 	int mask;
 	int err;
+	char *path;
+	int pathlen;
+	u64 pathbase;
 
 	doutc(cl, "%p %llx.%llx dentry %p '%pd' %s flags %d mode 0%o\n",
 	      dir, ceph_vinop(dir), dentry, dentry,
@@ -805,6 +808,28 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	 */
 	flags &= ~O_TRUNC;
 
+	dn = d_find_alias(dir);
+	if (!dn) {
+		try_async = false;
+	} else {
+		path = ceph_mdsc_build_path(mdsc, dn, &pathlen, &pathbase, 0);
+		if (IS_ERR(path)) {
+			try_async = false;
+			err = 0;
+		} else {
+			err = ceph_mds_check_access(mdsc, path, MAY_WRITE);
+		}
+		dput(dn);
+
+		/* For none EACCES cases will let the MDS do the mds auth check */
+		if (err == -EACCES) {
+			return err;
+		} else if (err < 0) {
+			try_async = false;
+			err = 0;
+		}
+	}
+
 retry:
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
-- 
2.41.0


