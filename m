Return-Path: <ceph-devel+bounces-194-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5B18043E3
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 02:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D79BF1F212D7
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 01:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5EE10E8;
	Tue,  5 Dec 2023 01:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfYwO8bU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA28A4
	for <ceph-devel@vger.kernel.org>; Mon,  4 Dec 2023 17:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701739039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9VKbdRwPdwsSWZ4y5WdtUSevOeiMmJxAN2OK7QPvTgg=;
	b=gfYwO8bUq5VxWCLppLE18GabRzGKFvs9iTvfor+hHPJy9ehpDqczlF36rJVQh65bglNg9C
	tT3JDQqsMTRVKeWnFYWfb2wfHE3Sjr0vRR5C5WAV+WIfAanIjxhYMskRvfV1/bCKqsIm8l
	NXRQlijcDf7e9flM2Ru9DyUKBQ73suk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-mb3fRb5GMriT-adwdQEKhQ-1; Mon,
 04 Dec 2023 20:17:15 -0500
X-MC-Unique: mb3fRb5GMriT-adwdQEKhQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B5E71C0758A;
	Tue,  5 Dec 2023 01:17:15 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.153])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC695492BE0;
	Tue,  5 Dec 2023 01:17:12 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 5/6] ceph: check the cephx mds auth access for async dirop
Date: Tue,  5 Dec 2023 09:14:38 +0800
Message-ID: <20231205011439.84238-6-xiubli@redhat.com>
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

Before doing the op locally we need to check the cephx access.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c  | 28 ++++++++++++++++++++++++++++
 fs/ceph/file.c | 26 ++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 91709934c8b1..ca63c70c5ecc 100644
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
index 47511df2e666..341a05dc4edd 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -789,6 +789,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
 	int mask;
 	int err;
+	char *path;
+	int pathlen;
+	u64 pathbase;
 
 	doutc(cl, "%p %llx.%llx dentry %p '%pd' %s flags %d mode 0%o\n",
 	      dir, ceph_vinop(dir), dentry, dentry,
@@ -806,6 +809,29 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
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
2.41.0


