Return-Path: <ceph-devel+bounces-1099-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DA678A9CF6
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 16:26:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC4BFB210BB
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 14:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7236316E898;
	Thu, 18 Apr 2024 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RJrYfGGl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C64168B06
	for <ceph-devel@vger.kernel.org>; Thu, 18 Apr 2024 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450176; cv=none; b=lppAwgjUj/Abki8iWQOEuhlm/Lo5Lqao43I3SuxVZnP+tysi9NdrT4LM2lxIa3kFQchu99+Rp9PGo4SO7NNssH6UJzu6gJgeAViDNbFDGNsXrA5npLOfLbGSYx006EGcJLXWeNNi8Xj7Ddmvn++mRVXOp4th4yWd9BtDekPDx2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450176; c=relaxed/simple;
	bh=xxTsUlH75ywphIh0rfkU4iUr2qkSzW+v7ivhrTCsyYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECxD5UNqKMbdBrE2xJ/T/IUWpAF/2RHbTXXCy/tJ4j7s5NOfVCpBxgAG4fDr9bBVOTVnPvzUhgMhhzdTi7rDjzT4wJ/qTRrNbVqscSowJGbH/DBh9EhsDhh3k4JC8TzE2MNjrmMlqOwshRTGl1tSrsBbsMrtazcgeFpseggNmz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RJrYfGGl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713450173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=objNVGknN2SlbSfY/1gWljk3kfAReNuBFm9Uv0Ul4g8=;
	b=RJrYfGGlWGzIqXA/FXts7Rf5HpsGTgkK5D6DbyDt1/J03SEe23Zs9awMIOm93uwFWBshG5
	LijxXD9/ER2Z0GNm3ErWIenL0wqlq4gDzWkxhYAqeIhLT2bPsYcexhkI5qbQbJ9MWHOugm
	HLv08k2ZkZ7PDurLEgTstWlIExWY+f0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-C-xYWVdQMrKJBk9907KBCA-1; Thu, 18 Apr 2024 10:22:49 -0400
X-MC-Unique: C-xYWVdQMrKJBk9907KBCA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 637C9104B507;
	Thu, 18 Apr 2024 14:22:49 +0000 (UTC)
Received: from li-25d5c94c-2c69-11b2-a85c-c76ff7643ea0.ibm.com.com (unknown [10.72.116.7])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DDA2835430;
	Thu, 18 Apr 2024 14:22:46 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 5/6] ceph: check the cephx mds auth access for async dirop
Date: Thu, 18 Apr 2024 22:20:18 +0800
Message-ID: <20240418142019.133191-6-xiubli@redhat.com>
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
index 4de4bdd7949e..4b8d59ebda00 100644
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


