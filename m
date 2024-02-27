Return-Path: <ceph-devel+bounces-919-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0822F8689EE
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 08:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1675288EE6
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 07:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E160654F87;
	Tue, 27 Feb 2024 07:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="flUrK1Sg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E195465C
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 07:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019314; cv=none; b=WdacrS9RJjuSM0yQkmA3yuKJIy7hn4Adq9JnegiEDLb60rD85g8LrSXdgwBRh2NJMWkvqEFx96aZ2kQwSZZXzdgX8DbatF7+lFLIKkBecJUoh7N16CSzXkvhyf+WoGNSp8ckq51tMgbVvwrm7w9ast9DSFAusglTjoglJsHRHmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019314; c=relaxed/simple;
	bh=nF63QRLaOKgt00dahBVOswGtqBszJNlguF4IsbnOTW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6YmvP10Tldmp0C9O3FM4F7kurxD6bJTgxguZ3wLB7LQ2fv4qW3jsYMqe+i2DvvcGOiGfQpGXaL0vB7AvP1UbJ7dj46lQasaD7OtQlZVBltrGGerSNzuwBMEaokoMJ5CcnIesy/AfLUHF66iaV0LatLDEYCu5nmfYZIdVsvfLOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=flUrK1Sg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709019312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQIlHBfmSvW2FbONC19IW4f368KkH7kcGvcMmB6FAZI=;
	b=flUrK1SgUlCJUnGXfl/W1RSfdK8CWjndTbA0Rd1qnsCokwcAX3/RTzdNS48EmrIUctCvva
	nhDHM0oIMYmolcqDsqXc/4RUMb1VYwyua9ncV2xhV0AhMiGVB00QUxAQwilR2fW6Iff6f8
	jf1UDVwSwMPeZuX7i7d+wwSVbi3b6KQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-xj5t8JR9NpObodpEdJuijQ-1; Tue,
 27 Feb 2024 02:35:10 -0500
X-MC-Unique: xj5t8JR9NpObodpEdJuijQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFEDA1C29EA4;
	Tue, 27 Feb 2024 07:35:09 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.214])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CFE542166B32;
	Tue, 27 Feb 2024 07:35:06 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 5/6] ceph: check the cephx mds auth access for async dirop
Date: Tue, 27 Feb 2024 15:27:04 +0800
Message-ID: <20240227072705.593676-6-xiubli@redhat.com>
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

Before doing the op locally we need to check the cephx access.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c  | 28 ++++++++++++++++++++++++++++
 fs/ceph/file.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0e9f56eaba1e..82a2e2a06a65 100644
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
@@ -1351,6 +1355,30 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
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
+		ceph_mdsc_free_path(path, pathlen);
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
index 08cd36679fcc..24a003eaa5e0 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -790,6 +790,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
 	int mask;
 	int err;
+	char *path;
+	int pathlen;
+	u64 pathbase;
 
 	doutc(cl, "%p %llx.%llx dentry %p '%pd' %s flags %d mode 0%o\n",
 	      dir, ceph_vinop(dir), dentry, dentry,
@@ -807,6 +810,34 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
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
+			int fmode = ceph_flags_to_mode(flags);
+
+			mask = MAY_READ;
+			if (fmode & CEPH_FILE_MODE_WR)
+				mask |= MAY_WRITE;
+			err = ceph_mds_check_access(mdsc, path, mask);
+		}
+		ceph_mdsc_free_path(path, pathlen);
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
2.43.0


