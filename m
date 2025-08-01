Return-Path: <ceph-devel+bounces-3346-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB87B186D7
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Aug 2025 19:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02FAC3B373F
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Aug 2025 17:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F12B279782;
	Fri,  1 Aug 2025 17:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HdRkFjgI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2855C1A08DB
	for <ceph-devel@vger.kernel.org>; Fri,  1 Aug 2025 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754070118; cv=none; b=YYwiyce7WDKFlHvZP5ax+ttVJuRiZLuqxx+oYALANux3GQb/zlse22V/gPBVRzCuZaPcIK+MvpbIrqP76h1TVPdilVLZPXkGACNepWPKGUxatEJxyKF7ATac0AZhArbJglmcg3ZPeTYRk7w0T6Hc6nGcgin+RrsEXrj69+5yc2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754070118; c=relaxed/simple;
	bh=bP37SW6ySn5kX55sTY9f5MqdVgIzSjJFViGfSiExj1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YdYF7k4PtNi+xfpZ4Me+g4KcXYB9flu18SbS/qPeWW4GSpxJGC2D/LsosKh/kbC7bFHWpGzPo1BOKY55GNOwsVgCZH9ftGno8rtptuCTnrOgeptIKNcjChqa1X5d0BOa8UV9941VlxuzoTN9ocNzxKBFftQbqxmgTj/CtnVAeCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HdRkFjgI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754070115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ulZN4/34I7UIr+xmEIokFIJR60aMEZKHe/FwgDVl6To=;
	b=HdRkFjgIc9Qa/K2dwJNoZYeso6YuF6Ay6gNPuCJIdJp1ubl4rlhkJcVrODTS2+fUXzRzo+
	D7bH6IgUGqSM/cEi2ga204U2npjUwM9z+sRLvl6JZUp+v5or2m8mhkJCOC1YoAoxO5K+4i
	3ugVxRvvZC5HW7n45i8GD894o366Ml8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465-BZvlnNPsN_uSWtKTCniV_A-1; Fri,
 01 Aug 2025 13:41:53 -0400
X-MC-Unique: BZvlnNPsN_uSWtKTCniV_A-1
X-Mimecast-MFC-AGG-ID: BZvlnNPsN_uSWtKTCniV_A_1754070112
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B416619560B6;
	Fri,  1 Aug 2025 17:41:52 +0000 (UTC)
Received: from li-4f30544c-234f-11b2-a85c-fca7e10b62e2.ibm.com.com (unknown [10.74.64.23])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EB5851954B11;
	Fri,  1 Aug 2025 17:41:48 +0000 (UTC)
From: khiremat@redhat.com
To: ceph-devel@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	pdonnell@redhat.com,
	vshankar@redhat.com,
	Kotresh HR <khiremat@redhat.com>
Subject: [PATCH v2] ceph: Fix multifs mds auth caps issue
Date: Fri,  1 Aug 2025 23:09:44 +0530
Message-ID: <20250801173944.61708-1-khiremat@redhat.com>
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

URL: https://tracker.ceph.com/issues/72167
Signed-off-by: Kotresh HR <khiremat@redhat.com>
---
 fs/ceph/mds_client.c | 10 ++++++++++
 fs/ceph/mdsmap.c     | 11 ++++++++++-
 fs/ceph/mdsmap.h     |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9eed6d73a508..8472ae7b7f3d 100644
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
+		      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
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
2.50.1


