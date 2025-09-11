Return-Path: <ceph-devel+bounces-3581-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08012B52D62
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 11:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AA12189C519
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 09:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835382EA481;
	Thu, 11 Sep 2025 09:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UvQEbEAN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECC52E9EDF
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 09:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757583321; cv=none; b=PERn2/9MCF4tfKM04P/J7F2wjQfG7S2eL7P3iBRXfjZYJFScPadL9WOdyRbfwOqp2XUEF+Vc/1LBPv1YRqceggyg+KaDONbeTiFFVRwTe89diwYVyvNlqggs34VFBNVQ2ps5+GQ/MvTkBf8OVytJYwdeqkzJmc5ECZKLUMNYLJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757583321; c=relaxed/simple;
	bh=hIS+O4VnJ8IkHVkBrREqQxVYDq8sXQNeRLKr+AVf/EM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PceqRVIZ71f2OId9Ug1SL8fOupS8gfzgEWYdmYFHyBOzRFgXxkhfDRy/1FF2LaZsHZ2vLTkQJcx5ozEDm5btBEmUeTBH7rgK766SZzTDp5eivCrWbOQnPCAyMxSpWToQCgnf+yPLJugG/6IQhqO44LP+3Yu7kMfNuFnCJizERto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UvQEbEAN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757583318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rHSwI5dqyJLLDNpu6E96qc/Q/2UWBvWYEtS8RCei/S0=;
	b=UvQEbEANI1z0zHIS60m0y2pTYJOLeNBTXGZqFugKCXxVDHCH8uUcLlyQ6IzeZJLGLW2AX0
	Uhg5kbcTn9uFoZF35JytMC/aIJwNjlMhTt2CN7mODZHKkDqjaLYNUQvgd2L8SETkHimJQj
	ku52ePKMb5d/L6JvvxkPUiksTCyFpNo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-552-R6UTI4AKPAClRy86NsWbVw-1; Thu,
 11 Sep 2025 05:35:14 -0400
X-MC-Unique: R6UTI4AKPAClRy86NsWbVw-1
X-Mimecast-MFC-AGG-ID: R6UTI4AKPAClRy86NsWbVw_1757583313
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87FC11800576;
	Thu, 11 Sep 2025 09:35:13 +0000 (UTC)
Received: from li-4f30544c-234f-11b2-a85c-fca7e10b62e2.ibm.com.com (unknown [10.76.98.115])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E40E419560B1;
	Thu, 11 Sep 2025 09:35:09 +0000 (UTC)
From: khiremat@redhat.com
To: ceph-devel@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	pdonnell@redhat.com,
	vshankar@redhat.com,
	Kotresh HR <khiremat@redhat.com>
Subject: [PATCH v4] ceph: Fix multifs mds auth caps issue
Date: Thu, 11 Sep 2025 15:02:35 +0530
Message-ID: <20250911093235.29845-1-khiremat@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Kotresh HR <khiremat@redhat.com>

The mds auth caps check should also validate the
fsname along with the associated caps. Not doing
so would result in applying the mds auth caps of
one fs on to the other fs in a multifs ceph cluster.
The bug causes multiple issues w.r.t user
authentication, following is one such example.

Steps to Reproduce (on vstart cluster):
1. Create two file systems in a cluster, say 'fsname1' and 'fsname2'
2. Authorize read only permission to the user 'client.usr' on fs 'fsname1'
    $ceph fs authorize fsname1 client.usr / r
3. Authorize read and write permission to the same user 'client.usr' on fs 'fsname2'
    $ceph fs authorize fsname2 client.usr / rw
4. Update the keyring
    $ceph auth get client.usr >> ./keyring

With above permssions for the user 'client.usr', following is the
expectation.
  a. The 'client.usr' should be able to only read the contents
     and not allowed to create or delete files on file system 'fsname1'.
  b. The 'client.usr' should be able to read/write on file system 'fsname2'.

But, with this bug, the 'client.usr' is allowed to read/write on file
system 'fsname1'. See below.

5. Mount the file system 'fsname1' with the user 'client.usr'
     $sudo bin/mount.ceph usr@.fsname1=/ /kmnt_fsname1_usr/
6. Try creating a file on file system 'fsname1' with user 'client.usr'. This
   should fail but passes with this bug.
     $touch /kmnt_fsname1_usr/file1
7. Mount the file system 'fsname1' with the user 'client.admin' and create a
   file.
     $sudo bin/mount.ceph admin@.fsname1=/ /kmnt_fsname1_admin
     $echo "data" > /kmnt_fsname1_admin/admin_file1
8. Try removing an existing file on file system 'fsname1' with the user
   'client.usr'. This shoudn't succeed but succeeds with the bug.
     $rm -f /kmnt_fsname1_usr/admin_file1

For more information, please take a look at the corresponding mds/fuse patch
and tests added by looking into the tracker mentioned below.

v2: Fix a possible null dereference in doutc
v3: Don't store fsname from mdsmap, validate against
    ceph_mount_options's fsname and use it
v4: Code refactor, better warning message and
    fix possible compiler warning

URL: https://tracker.ceph.com/issues/72167
Signed-off-by: Kotresh HR <khiremat@redhat.com>
---
 fs/ceph/mds_client.c |  8 ++++++++
 fs/ceph/mdsmap.c     | 13 ++++++++++++-
 fs/ceph/super.c      | 14 --------------
 fs/ceph/super.h      | 14 ++++++++++++++
 4 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 179130948041..97f9de888713 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5689,11 +5689,19 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 	u32 caller_uid = from_kuid(&init_user_ns, cred->fsuid);
 	u32 caller_gid = from_kgid(&init_user_ns, cred->fsgid);
 	struct ceph_client *cl = mdsc->fsc->client;
+	const char *fs_name = mdsc->fsc->mount_options->mds_namespace;
 	const char *spath = mdsc->fsc->mount_options->server_path;
 	bool gid_matched = false;
 	u32 gid, tlen, len;
 	int i, j;
 
+	doutc(cl, "fsname check fs_name=%s  match.fs_name=%s\n",
+	      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
+	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
+		/* fsname check failed, try next one */
+		return 0;
+	}
+
 	doutc(cl, "match.uid %lld\n", auth->match.uid);
 	if (auth->match.uid != MDS_AUTH_UID_ANY) {
 		if (auth->match.uid != caller_uid)
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 8109aba66e02..de457470d07c 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -353,10 +353,21 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		__decode_and_drop_type(p, end, u8, bad_ext);
 	}
 	if (mdsmap_ev >= 8) {
+		u32 fsname_len;
 		/* enabled */
 		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
 		/* fs_name */
-		ceph_decode_skip_string(p, end, bad_ext);
+		ceph_decode_32_safe(p, end, fsname_len, bad_ext);
+
+		/* validate fsname against mds_namespace */
+		if (!namespace_equals(mdsc->fsc->mount_options, (const char *)*p, fsname_len)) {
+			pr_warn_client(cl, "fsname %*pE doesn't match mds_namespace %s\n",
+				       (int)fsname_len, (char *)*p,
+				       mdsc->fsc->mount_options->mds_namespace);
+			goto bad;
+		}
+		// skip fsname after validation
+		ceph_decode_skip_n(p, end, fsname_len, bad);
 	}
 	/* damaged */
 	if (mdsmap_ev >= 9) {
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 0e6787501b2f..2c6c45b2056d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -246,20 +246,6 @@ static void canonicalize_path(char *path)
 	path[j] = '\0';
 }
 
-/*
- * Check if the mds namespace in ceph_mount_options matches
- * the passed in namespace string. First time match (when
- * ->mds_namespace is NULL) is treated specially, since
- * ->mds_namespace needs to be initialized by the caller.
- */
-static int namespace_equals(struct ceph_mount_options *fsopt,
-			    const char *namespace, size_t len)
-{
-	return !(fsopt->mds_namespace &&
-		 (strlen(fsopt->mds_namespace) != len ||
-		  strncmp(fsopt->mds_namespace, namespace, len)));
-}
-
 static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
 				 struct fs_context *fc)
 {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 8cba1ce3b8b0..bb992f12e3b0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -104,6 +104,20 @@ struct ceph_mount_options {
 	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
+/*
+ * Check if the mds namespace in ceph_mount_options matches
+ * the passed in namespace string. First time match (when
+ * ->mds_namespace is NULL) is treated specially, since
+ * ->mds_namespace needs to be initialized by the caller.
+ */
+static inline int namespace_equals(struct ceph_mount_options *fsopt,
+				   const char *namespace, size_t len)
+{
+	return !(fsopt->mds_namespace &&
+		 (strlen(fsopt->mds_namespace) != len ||
+		  strncmp(fsopt->mds_namespace, namespace, len)));
+}
+
 /* mount state */
 enum {
 	CEPH_MOUNT_MOUNTING,
-- 
2.51.0


