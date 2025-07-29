Return-Path: <ceph-devel+bounces-3329-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD08B151CD
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jul 2025 19:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 418AC18A422E
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jul 2025 17:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B90F243378;
	Tue, 29 Jul 2025 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0S58Vme"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367E21019E
	for <ceph-devel@vger.kernel.org>; Tue, 29 Jul 2025 17:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753808749; cv=none; b=hCXlUBHTqYQOXmDfbtvES/0oQYdxaYnd0J/xPp8VGWVKeujG0FiLog+BDLZz/nl0xAhD/9aLe7/mIWNH2+wwbqFHqBsb3vd0yLAIG3+0YOdlRYo6SOhqOgWiqP/GvOfmqkGnPTXIU5KWqGUAbsCW5kTzbm0jMX1Ghx3zgpqfErI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753808749; c=relaxed/simple;
	bh=8bSv25TCukRoqglLAw44Un26r/qiTPrtSe9D6knyrVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o1VnFTrCpJIJGAh3bg3lZfm0CtG/OlG9SV2/go6SG+bhNkAIHpO4SSjvb4y2fbNmmaWE6S6Ds6RyMqmyBTbShvZilONRQKpOOBOwKGN1bQNjtc359caaMKl3oKG0q+Pi5P/bLJJWWuT5Ua5LxNUct3dU1++TBq4lztdyXl8nHEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0S58Vme; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753808745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XL7m+2HZwR+UCvNlDqnF1DB3q38CFB1cCxpOhqHYdhA=;
	b=a0S58VmeS8PoxcFh7sQkTOV7F+y9RTDzVU5kAhy3owcXKwh+0O4bG/56Htxf+zoRdA4jSQ
	0z42AIR9Fo3CV98Q7BiZzwmalvB822iCJvsmYcER2NHQqva5FTPIANvJdi014Y4o7dHJkz
	l45iHIyihAYZRSrxmKSN06V32huXbX0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-BiJPystYO1mebIGx0sHASw-1; Tue,
 29 Jul 2025 13:05:42 -0400
X-MC-Unique: BiJPystYO1mebIGx0sHASw-1
X-Mimecast-MFC-AGG-ID: BiJPystYO1mebIGx0sHASw_1753808741
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 017BB180045B;
	Tue, 29 Jul 2025 17:05:41 +0000 (UTC)
Received: from li-4f30544c-234f-11b2-a85c-fca7e10b62e2.ibm.com.com (unknown [10.74.64.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5CDFF30001B1;
	Tue, 29 Jul 2025 17:05:36 +0000 (UTC)
From: khiremat@redhat.com
To: ceph-devel@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	pdonnell@redhat.com,
	vshankar@redhat.com,
	Kotresh HR <khiremat@redhat.com>
Subject: [PATCH] ceph: Fix multifs mds auth caps issue
Date: Tue, 29 Jul 2025 22:32:40 +0530
Message-ID: <20250729170240.118794-1-khiremat@redhat.com>
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
The patch fixes the same.

Steps to Reproduce (on vstart cluster):
1. Create two file systems in a cluster, say 'a' and 'b'
2. ceph fs authorize a client.usr / r
3. ceph fs authorize b client.usr / rw
4. ceph auth get client.usr >> ./keyring
5. sudo bin/mount.ceph usr@.a=/ /kmnt_a_usr/
6. touch /kmnt_a_usr/file1 (SHOULD NOT BE ALLOWED)
7. sudo bin/mount.ceph admin@.a=/ /kmnt_a_admin
8. echo "data" > /kmnt_a_admin/admin_file1
9. rm -f /kmnt_a_usr/admin_file1 (SHOULD NOT BE ALLOWED)

URL: https://tracker.ceph.com/issues/72167
Signed-off-by: Kotresh HR <khiremat@redhat.com>
---
 fs/ceph/mds_client.c | 10 ++++++++++
 fs/ceph/mdsmap.c     | 11 ++++++++++-
 fs/ceph/mdsmap.h     |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9eed6d73a508..ba91f3360ff6 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5640,11 +5640,21 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 	u32 caller_uid = from_kuid(&init_user_ns, cred->fsuid);
 	u32 caller_gid = from_kgid(&init_user_ns, cred->fsgid);
 	struct ceph_client *cl = mdsc->fsc->client;
+	const char *fs_name = mdsc->mdsmap->fs_name;
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
+		      fs_name, auth->match.fs_name);
+	}
+
 	doutc(cl, "match.uid %lld\n", auth->match.uid);
 	if (auth->match.uid != MDS_AUTH_UID_ANY) {
 		if (auth->match.uid != caller_uid)
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 8109aba66e02..f1431ba0b33e 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -356,7 +356,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		/* enabled */
 		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
 		/* fs_name */
-		ceph_decode_skip_string(p, end, bad_ext);
+	        m->fs_name = ceph_extract_encoded_string(p, end, NULL, GFP_NOFS);
+	        if (IS_ERR(m->fs_name)) {
+			err = PTR_ERR(m->fs_name);
+			m->fs_name = NULL;
+			if (err == -ENOMEM)
+				goto out_err;
+			else
+				goto bad;
+	        }
 	}
 	/* damaged */
 	if (mdsmap_ev >= 9) {
@@ -418,6 +426,7 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
 		kfree(m->m_info);
 	}
 	kfree(m->m_data_pg_pools);
+	kfree(m->fs_name);
 	kfree(m);
 }
 
diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
index 1f2171dd01bf..acb0a2a3627a 100644
--- a/fs/ceph/mdsmap.h
+++ b/fs/ceph/mdsmap.h
@@ -45,6 +45,7 @@ struct ceph_mdsmap {
 	bool m_enabled;
 	bool m_damaged;
 	int m_num_laggy;
+	char *fs_name;
 };
 
 static inline struct ceph_entity_addr *
-- 
2.45.0


