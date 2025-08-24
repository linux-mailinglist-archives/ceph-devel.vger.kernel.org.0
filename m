Return-Path: <ceph-devel+bounces-3469-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7BFB3321A
	for <lists+ceph-devel@lfdr.de>; Sun, 24 Aug 2025 20:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B57961897ABD
	for <lists+ceph-devel@lfdr.de>; Sun, 24 Aug 2025 18:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0181F5619;
	Sun, 24 Aug 2025 18:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAq9LwjA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411EE1E3DFE
	for <ceph-devel@vger.kernel.org>; Sun, 24 Aug 2025 18:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756061477; cv=none; b=gNr5PVRH6AwKd7BODJ6yuwump50tzflqUsslreC8m3A91pIG4l2FmVs+CPxpjk1zY6FSrr4EevTRPvtQSc6B5MQIzgjHItmQMzDNw3tz4i/sX3wyDgcIAb0cWkcK03kC+v6KIiL81zTXEtVxEG2WURlVTVIpQ1R0gMvi1FyFnEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756061477; c=relaxed/simple;
	bh=Uhe6NN8g9bUQ5LcbV8WS0HC4uR+ZDcDkDoKEG3Pfrao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wj+2LyS77duZPD67MvMTyRngbWR9LCv7BObF0u1pHp41CM6d7UMUAUIcAU9IrvydSSf/WSIOU11Cz0WLqMwaDPyFsh/+dIC/YnhXIDhExwo9F9ZA8V3T2gUkYYlkata1A3jW+vnyswqURvMJx3IfqEtE6QvegcupnmrtLIz3mDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TAq9LwjA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756061474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P5dY2Jir9PJcDt/BVASgV/ozcIf4DnDW0JNfLtcK4Us=;
	b=TAq9LwjA9fCyFHUXm8QF4ts5pSTXQBRk7NF26rHO0WuflF7o9hUc0sP965qXd5EbACkLIG
	hJHd0/34709YTeDm1dWR28lYwolHvLX6aXRqSQk0IfqQ7lWP0qLQUY9dLHVkUAEtzFX8FP
	+zBviTYz6sz9uIXQYtFYIZPG+0AfSHc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-4eR9J1woNiq3M7NTvbAuTg-1; Sun,
 24 Aug 2025 14:51:10 -0400
X-MC-Unique: 4eR9J1woNiq3M7NTvbAuTg-1
X-Mimecast-MFC-AGG-ID: 4eR9J1woNiq3M7NTvbAuTg_1756061470
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D48861956088;
	Sun, 24 Aug 2025 18:51:09 +0000 (UTC)
Received: from li-4f30544c-234f-11b2-a85c-fca7e10b62e2.ibm.com.com (unknown [10.74.64.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5E51030001A5;
	Sun, 24 Aug 2025 18:51:06 +0000 (UTC)
From: khiremat@redhat.com
To: ceph-devel@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	pdonnell@redhat.com,
	vshankar@redhat.com,
	Kotresh HR <khiremat@redhat.com>
Subject: [PATCH v3] ceph: Fix multifs mds auth caps issue
Date: Mon, 25 Aug 2025 00:18:58 +0530
Message-ID: <20250824184858.24413-1-khiremat@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

URL: https://tracker.ceph.com/issues/72167
Signed-off-by: Kotresh HR <khiremat@redhat.com>
---
 fs/ceph/mds_client.c | 10 ++++++++++
 fs/ceph/mdsmap.c     | 14 +++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ce0c129f4651..638a12626432 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5680,11 +5680,21 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 	u32 caller_uid = from_kuid(&init_user_ns, cred->fsuid);
 	u32 caller_gid = from_kgid(&init_user_ns, cred->fsgid);
 	struct ceph_client *cl = mdsc->fsc->client;
+	const char *fs_name = mdsc->fsc->mount_options->mds_namespace;
 	const char *spath = mdsc->fsc->mount_options->server_path;
 	bool gid_matched = false;
 	u32 gid, tlen, len;
 	int i, j;
 
+	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
+		doutc(cl, "fsname check failed fs_name=%s  match.fs_name=%s\n",
+		      fs_name, auth->match.fs_name);
+		return 0;
+	} else {
+		doutc(cl, "fsname check passed fs_name=%s  match.fs_name=%s\n",
+		      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
+	}
+
 	doutc(cl, "match.uid %lld\n", auth->match.uid);
 	if (auth->match.uid != MDS_AUTH_UID_ANY) {
 		if (auth->match.uid != caller_uid)
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 8109aba66e02..44f435351daa 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -356,7 +356,19 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		/* enabled */
 		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
 		/* fs_name */
-		ceph_decode_skip_string(p, end, bad_ext);
+	        const char *mds_namespace = mdsc->fsc->mount_options->mds_namespace;
+		u32 fsname_len;
+		ceph_decode_32_safe(p, end, fsname_len, bad_ext);
+
+	        void *sp = *p;
+		if (!(mds_namespace &&
+		      strlen(mds_namespace) == fsname_len &&
+		      !strncmp(mds_namespace, (char *)sp, fsname_len))) {
+			pr_warn_client(cl, "fsname doesn't match\n");
+			goto bad;
+		}
+		// skip fsname after validation
+		ceph_decode_skip_n(p, end, fsname_len, bad);
 	}
 	/* damaged */
 	if (mdsmap_ev >= 9) {
-- 
2.50.1


